<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/*EXTRA FUNCTIONS: mysql\_.+*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_database_drivers
 */

require_code('database/shared/mysql');

/**
 * Database driver class.
 *
 * @package    core_database_drivers
 */
class Database_Static_mysql extends Database_super_mysql
{
    protected $cache_db = array();
    public $last_select_db = null;
    public $reconnected_once = false;

    /**
     * Get a database connection. This function shouldn't be used by you, as a connection to the database is established automatically.
     *
     * @param  boolean $persistent Whether to create a persistent connection
     * @param  string $db_name The database name
     * @param  string $db_host The database host (the server)
     * @param  string $db_user The database connection username
     * @param  string $db_password The database connection password
     * @param  boolean $fail_ok Whether to on error echo an error and return with a null, rather than giving a critical error
     * @return ?mixed A database connection (note for this driver, it's actually a pair, containing the database name too: because we need to select the name before each query on the connection) (null: failed)
     */
    public function get_connection($persistent, $db_name, $db_host, $db_user, $db_password, $fail_ok = false)
    {
        if (!function_exists('mysql_connect')) {
            $error = 'The \'mysql\' PHP extension is not installed (anymore?). This extension was removed in PHP 7, in favour of \'mysqli\'. You need to contact the system administrator of this server, or use a different MySQL database driver (drivers can be chosen by editing _config.php).';
            if ($fail_ok) {
                echo $error . "\n";
                return null;
            }
            critical_error('PASSON', $error);
        }

        // Potential caching
        $x = serialize(array($db_user, $db_host));
        if (array_key_exists($x, $this->cache_db)) {
            if ($this->last_select_db[1] !== $db_name) {
                mysql_select_db($db_name, $this->cache_db[$x]);
                $this->last_select_db = array($this->cache_db[$x], $db_name);
            }

            return array($this->cache_db[$x], $db_name);
        }

        $db_link = $persistent ? @mysql_pconnect($db_host, $db_user, $db_password) : @mysql_connect($db_host, $db_user, $db_password, true);
        if ($db_link === false) {
            $error = 'Could not connect to database-server (' . mysql_error() . ', ' . cms_error_get_last() . ')';
            if ($fail_ok) {
                echo $error . "\n";
                return null;
            }
            critical_error('PASSON', $error);
        }
        if (!mysql_select_db($db_name, $db_link)) {
            if ($db_user == 'root') {
                @mysql_query('CREATE DATABASE IF NOT EXISTS ' . $db_name, $db_link);
            }

            if (!mysql_select_db($db_name, $db_link)) {
                $error = 'Could not connect to database (' . mysql_error() . ')';
                if ($fail_ok) {
                    echo $error . "\n";
                    return null;
                }
                critical_error('PASSON', $error); //warn_exit(do_lang_tempcode('CONNECT_ERROR'));
            }
        }
        $this->last_select_db = array($db_link, $db_name);

        $this->cache_db[$x] = $db_link;

        $init_queries = $this->get_init_queries();
        foreach ($init_queries as $init_query) {
            @mysql_query($init_query, $db_link);
        }

        global $SITE_INFO;
        $test = @mysql_set_charset($SITE_INFO['database_charset'], $db_link);
        if ((!$test) && ($SITE_INFO['database_charset'] == 'utf8mb4')) {
            // Conflict between compiled-in MySQL client library and what the server supports
            $test = @mysql_set_charset('utf8', $db_link);
            @mysql_query( 'SET NAMES "' . addslashes('utf8mb4') . '"', $db_link);
        }

        return array($db_link, $db_name);
    }

    /**
     * This function is a very basic query executor. It shouldn't usually be used by you, as there are abstracted versions available.
     *
     * @param  string $query The complete SQL query
     * @param  mixed $connection The DB connection
     * @param  ?integer $max The maximum number of rows to affect (null: no limit)
     * @param  integer $start The start row to affect
     * @param  boolean $fail_ok Whether to output an error on failure
     * @param  boolean $get_insert_id Whether to get the autoincrement ID created for an insert query
     * @return ?mixed The results (null: no results), or the insert ID
     */
    public function query($query, $connection, $max = null, $start = 0, $fail_ok = false, $get_insert_id = false)
    {
        list($db_link, $db_name) = $connection;

        if (!$this->query_may_run($query, $connection, $get_insert_id)) {
            return null;
        }

        if ($this->last_select_db[1] !== $db_name) {
            mysql_select_db($db_name, $db_link);
            $this->last_select_db = $db_name;
        }

        static $version = null;
        if ($version === null) {
            $version = @mysql_get_server_info($db);
        }
        if ($version !== false) {
            if (version_compare($version, '8', '>=')) {
                $query = $this->fix_mysql8_query($query); // LEGACY: This can be removed once all user DBs are upgraded to MySQL 8 (as ALTER TABLE calls themselves are now MySQL 8 compatible by default
            }
        }

        $this->apply_sql_limit_clause($query, $max, $start);

        $results = @mysql_query($query, $db_link);
        if (($results === false) && ((!$fail_ok) || (strpos(@strval(mysql_error($db_link)), 'is marked as crashed and should be repaired') !== false))) {
            $err = @strval(mysql_error($db_link));

            if ((function_exists('mysql_ping')) && ($err == 'MySQL server has gone away') && (!$this->reconnected_once)) {
                $this->reconnected_once = true;
                if ((!mysql_ping($db_link)) && (isset($GLOBALS['SITE_DB'])) && ($connection[1] == $GLOBALS['SITE_DB']->connection_write[1])) {
                    $this->cache_db = array();
                    $connection = $this->get_connection(get_use_persistent(), get_db_site(), get_db_site_host(), get_db_site_user(), get_db_site_password());
                    $GLOBALS['SITE_DB']->connection_write = $connection;
                    $GLOBALS['SITE_DB']->connection_read = $connection;
                }
                $ret = $this->query($query, $connection, null/*already encoded*/, null/*already encoded*/, $fail_ok, $get_insert_id);
                $this->reconnected_once = false;
                return $ret;
            }

            $this->handle_failed_query($query, $err, $connection);
            return null;
        }

        $sub = substr(ltrim($query), 0, 4);
        if (($results !== true) && (($sub === '(SEL') || ($sub === 'SELE') || ($sub === 'sele') || ($sub === 'CHEC') || ($sub === 'EXPL') || ($sub === 'REPA') || ($sub === 'DESC') || ($sub === 'SHOW')) && ($results !== false)) {
            return $this->get_query_rows($results, $query, $start);
        }

        if ($get_insert_id) {
            if (($sub === 'UPDA') || ($sub === 'upda')) {
                return mysql_affected_rows($db_link);
            }
            $ins = mysql_insert_id($db_link);
            if ($ins === 0) {
                $table = substr($query, 12, strpos($query, ' ', 12) - 12);
                $rows = $this->query('SELECT MAX(id) AS x FROM ' . $table, $connection, 1, 0, false, false);
                return $rows[0]['x'];
            }
            return $ins;
        }

        return null;
    }

    /**
     * Get the rows returned from a SELECT query.
     *
     * @param  resource $results The query result pointer
     * @param  string $query The complete SQL query (useful for debugging)
     * @param  integer $start Where to start reading from
     * @return array A list of row maps
     */
    protected function get_query_rows($results, $query, $start)
    {
        $row = mysql_fetch_row($results); // cannot use mysql_fetch_assoc because no dupe results are returned, which knocks off the offsets used by mysql_field_type
        if ($row === false) { // Quick get away
            mysql_free_result($results);
            return array();
        }

        $num_fields = mysql_num_fields($results);
        $names = array();
        $types = array();
        for ($x = 0; $x < $num_fields; $x++) {
            $names[$x] = mysql_field_name($results, $x);
            $types[$x] = mysql_field_type($results, $x);
        }

        $out = array();
        $newrow = array();
        do {
            $j = 0;
            foreach ($row as $v) {
                $name = $names[$j];
                $type = $types[$j];

                if (substr($type, 0, 3) == 'int') {
                    $type = 'int';
                }

                switch ($type) {
                    case 'int':
                        if (($v === null) || ($v === '')) {
                            $newrow[$name] = null;
                        } else {
                            if ($v === "\0" || $v === "\1") {
                                $newrow[$name] = ord($v); // 0/1 char for BIT field
                            } else {
                                $_v = intval($v);
                                $newrow[$name] = $_v;
                            }
                        }
                        break;

                    case 'real':
                        $newrow[$name] = is_string($v) ? floatval($v) : $v;
                        break;

                    case 'unknown':
                        if (is_string($v)) {
                            if ($v === "\0" || $v === "\1") {
                                $newrow[$name] = ord($v); // 0/1 char for BIT field
                            } else {
                                $newrow[$name] = intval($v);
                            }

                            break;
                        }

                    default:
                        $newrow[$name] = $v;
                }

                ++$j;
            }

            $out[] = $newrow;
        } while (false !== ($row = mysql_fetch_row($results)));

        mysql_free_result($results);
        return $out;
    }

    /**
     * Escape a string so it may be inserted into a query. If SQL statements are being built up and passed using db_query then it is essential that this is used for security reasons. Otherwise, the abstraction layer deals with the situation.
     *
     * @param  string $string The string
     * @return string The escaped string
     */
    public function escape_string($string)
    {
        if (function_exists('ctype_alnum')) {
            if (ctype_alnum($string)) {
                return $string; // No non-trivial characters
            }
        }
        if (preg_match('#[^a-zA-Z0-9\.]#', $string) === 0) {
            return $string; // No non-trivial characters
        }

        $string = fix_bad_unicode($string);

        static $mres = null;
        if ($mres === null) {
            $mres = function_exists('mysql_real_escape_string');
        }
        if (($mres) && (isset($GLOBALS['SITE_DB']->connection_read[0])) && ($GLOBALS['SITE_DB']->connection_read[0] !== false)) {
            return mysql_real_escape_string($string, $GLOBALS['SITE_DB']->connection_read[0]);
        }
        return @mysql_escape_string($string);
    }
}

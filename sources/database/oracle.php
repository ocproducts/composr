<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_database_drivers
 */

/*EXTRA FUNCTIONS: oci.+*/

/*
For: php_oci8.dll
*/

/**
 * Database driver class.
 *
 * @package    core_database_drivers
 */
class Database_Static_oracle extends DatabaseDriver
{
    protected $cache_db = array();

    /**
     * Get the default user for making db connections (used by the installer as a default).
     *
     * @return string The default user for db connections
     */
    public function default_user()
    {
        return 'system';
    }

    /**
     * Get the default password for making db connections (used by the installer as a default).
     *
     * @return string The default password for db connections
     */
    public function default_password()
    {
        return '';
    }

    /**
     * Get a database connection. This function shouldn't be used by you, as a connection to the database is established automatically.
     *
     * @param  boolean $persistent Whether to create a persistent connection
     * @param  string $db_name The database name
     * @param  string $db_host The database host (the server)
     * @param  string $db_user The database connection username
     * @param  string $db_password The database connection password
     * @param  boolean $fail_ok Whether to on error echo an error and return with a null, rather than giving a critical error
     * @return ?mixed A database connection (null: failed)
     */
    public function get_connection($persistent, $db_name, $db_host, $db_user, $db_password, $fail_ok = false)
    {
        if ($db_host != 'localhost') {
            fatal_exit(do_lang_tempcode('ONLY_LOCAL_HOST_FOR_TYPE'));
        }

        // Potential caching
        if (isset($this->cache_db[$db_name][$db_host])) {
            return $this->cache_db[$db_name][$db_host];
        }

        if (!function_exists('ocilogon')) {
            $error = 'The oracle PHP extension not installed (anymore?). You need to contact the system administrator of this server.';
            if ($fail_ok) {
                echo ((running_script('install')) && (get_param_string('type', '') == 'ajax_db_details')) ? strip_html($error) : $error;
                return null;
            }
            critical_error('PASSON', $error);
        }

        $connection = $persistent ? @ociplogon($db_user, $db_password, $db_name) : @ocilogon($db_user, $db_password, $db_name);
        if ($connection === false) {
            $error = 'Could not connect to database-server (' . ocierror() . ')';
            if ($fail_ok) {
                echo ((running_script('install')) && (get_param_string('type', '') == 'ajax_db_details')) ? strip_html($error) : $error;
                return null;
            }
            critical_error('PASSON', $error);
        }

        $this->cache_db[$db_name][$db_host] = $connection;
        return $connection;
    }

    /**
     * Adjust an SQL query to apply offset/limit restriction.
     *
     * @param  string $query The complete SQL query
     * @param  ?integer $max The maximum number of rows to affect (null: no limit)
     * @param  integer $start The start row to affect
     */
    public function apply_sql_limit_clause(&$query, $max = null, $start = 0)
    {
        if (($start != 0) && ($max !== null) && (strtoupper(substr(ltrim($query), 0, 7)) == 'SELECT ') || (strtoupper(substr(ltrim($query), 0, 8)) == '(SELECT ')) {
            $old_query = $query;
            $pos = stripos($old_query, 'FROM ');
            $pos2 = strpos($old_query, ' ', $pos + 5);
            $pos3 = stripos($old_query, 'WHERE ', $pos2);
            if ($pos3 === false) { // No where
                $pos4 = stripos($old_query, ' ORDER BY');
                if ($pos4 === false) {
                    $pos4 = strlen($old_query);
                }
                $query = substr($old_query, 0, $pos4) . ' WHERE rownum>=' . strval(intval($start));
                if ($max !== null) {
                    $query .= ' AND rownum<' . strval(intval($start + $max));
                }
                $query .= substr($old_query, $pos4);
            } else {
                $pos4 = stripos($old_query, ' ORDER BY');
                if ($pos4 === false) {
                    $pos4 = strlen($old_query);
                }
                $query = substr($old_query, 0, $pos3) . 'WHERE (' . substr($old_query, $pos3 + 6, $pos4 - $pos3 - 6) . ') AND rownum>=' . strval(intval($start));
                if ($max !== null) {
                    $query .= ' AND rownum<' . strval(intval($start + $max));
                }
                $query .= substr($old_query, $pos4);
            }
        }
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
        $this->apply_sql_limit_clause($query, $max, $start);

        $stmt = ociparse($connection, $query, 0);
        $results = @ociexecute($stmt);
        if ((($results === false) || (((strtoupper(substr(ltrim($query), 0, 7)) == 'SELECT ') || (strtoupper(substr(ltrim($query), 0, 8)) == '(SELECT ')) && ($results === true))) && (!$fail_ok)) {
            $err = ocierror($connection);
            if (function_exists('ocp_mark_as_escaped')) {
                ocp_mark_as_escaped($err);
            }
            if ((!running_script('upgrader')) && ((!get_mass_import_mode()) || (get_param_integer('keep_fatalistic', 0) != 0))) {
                if ((!function_exists('do_lang')) || (do_lang('QUERY_FAILED', null, null, null, null, false) === null)) {
                    $this->failed_query_exit(htmlentities('Query failed: ' . $query . ' : ' . $err));
                }

                $this->failed_query_exit(do_lang_tempcode('QUERY_FAILED', escape_html($query), ($err)));
            } else {
                $this->failed_query_echo(htmlentities('Database query failed: ' . $query . ' [') . ($err) . htmlentities(']'));
                return null;
            }
        }

        if (($results !== true) && ((strtoupper(substr(ltrim($query), 0, 7)) == 'SELECT ') || (strtoupper(substr(ltrim($query), 0, 8)) == '(SELECT ')) && ($results !== false)) {
            return $this->get_query_rows($stmt, $query, $start);
        }

        if ($get_insert_id) {
            if (strtoupper(substr(ltrim($query), 0, 7)) == 'UPDATE ') {
                return null;
            }

            $pos = strpos($query, '(');
            $table_name = substr($query, 12, $pos - 13);

            $stmt = ociparse($connection, 'SELECT gen_' . $table_name . '.CURRVAL AS v FROM dual');
            ociexecute($stmt);
            $ar2 = ocifetch($stmt);
            return $ar2[0];
        }

        return null;
    }

    /**
     * Get the rows returned from a SELECT query.
     *
     * @param  resource $stmt The query result pointer
     * @param  string $query The complete SQL query (useful for debugging)
     * @param  integer $start Where to start reading from
     * @return array A list of row maps
     */
    public function get_query_rows($stmt, $query, $start)
    {
        $out = array();
        $i = 0;

        $num_fields = ocinumcols($stmt);
        $types = array();
        $names = array();
        for ($x = 1; $x <= $num_fields; $x++) {
            $types[$x] = ocicolumntype($stmt, $x);
            $names[$x] = strtolower(ocicolumnname($stmt, $x));
        }
        while (ocifetch($stmt)) {
            if ($i >= $start) {
                $newrow = array();

                for ($j = 1; $j <= $num_fields; $j++) {
                    $v = ociresult($stmt, $j);
                    if (is_object($v)) {
                        $v = $v->load(); // For CLOB's
                    }
                    if ($v === false) {
                        $this->failed_query_exit(do_lang_tempcode('QUERY_FAILED', ocierror($stmt)));
                    }

                    $name = $names[$j];
                    $type = $types[$j];

                    if ($type == 'NUMBER') {
                        if ($v !== null) {
                            $newrow[$name] = intval($v);
                        } else {
                            $newrow[$name] = null;
                        }
                    } elseif ((substr($type, 0, 5) == 'FLOAT') || substr($type, 0, 6) == 'NUMBER') {
                        $newrow[$name] = floatval($v);
                    } else {
                        if ($v == ' ') {
                            $v = '';
                        }
                        $newrow[$name] = $v;
                    }
                }

                $out[] = $newrow;
            }

            $i++;
        }

        return $out;
    }

    /**
     * Get a map of Composr field types, to actual database types.
     *
     * @param  boolean $for_alter Whether this is for adding a table field
     * @return array The map
     */
    public function get_type_remap($for_alter = false)
    {
        $type_remap = array(
            'AUTO' => 'integer',
            'AUTO_LINK' => 'integer',
            'INTEGER' => 'integer',
            'UINTEGER' => 'bigint',
            'SHORT_INTEGER' => 'smallint',
            'REAL' => 'real',
            'BINARY' => 'smallint',
            'MEMBER' => 'integer',
            'GROUP' => 'integer',
            'TIME' => 'bigint',
            'LONG_TRANS' => 'bigint',
            'SHORT_TRANS' => 'bigint',
            'LONG_TRANS__COMCODE' => 'integer',
            'SHORT_TRANS__COMCODE' => 'integer',
            'SHORT_TEXT' => 'text',
            'LONG_TEXT' => 'CLOB',
            'ID_TEXT' => 'varchar(80)',
            'MINIID_TEXT' => 'varchar(40)',
            'IP' => 'varchar(40)',
            'LANGUAGE_NAME' => 'varchar(5)',
            'URLPATH' => 'varchar(255)',
        );
        return $type_remap;
    }

    /**
     * Get SQL for creating a new table.
     *
     * @param  ID_TEXT $table_name The table name
     * @param  array $fields A map of field names to Composr field types (with *#? encodings)
     * @param  mixed $connection The DB connection to make on
     * @param  ID_TEXT $raw_table_name The table name with no table prefix
     * @param  boolean $save_bytes Whether to use lower-byte table storage, with trade-offs of not being able to support all unicode characters; use this if key length is an issue
     * @return array List of SQL queries to run
     */
    public function create_table($table_name, $fields, $connection, $raw_table_name, $save_bytes = false)
    {
        $type_remap = $this->get_type_remap();

        $_fields = '';
        $keys = '';
        $trigger = false;
        foreach ($fields as $name => $type) {
            if ($type[0] == '*') { // Is a key
                $type = substr($type, 1);
                if ($keys != '') {
                    $keys .= ', ';
                }
                $keys .= $name;
            }

            if ($type[0] == '?') { // Is perhaps null
                $type = substr($type, 1);
                $perhaps_null = 'NULL';
            } else {
                $perhaps_null = 'NOT NULL';
            }

            if ($type == 'AUTO') {
                $trigger = true;
            }

            $type = isset($type_remap[$type]) ? $type_remap[$type] : $type;

            $_fields .= '    ' . $name . ' ' . $type;
            if (substr($name, -13) == '__text_parsed') {
                $_fields .= ' DEFAULT \'\'';
            } elseif (substr($name, -13) == '__source_user') {
                $_fields .= ' DEFAULT ' . strval(db_get_first_id());
            }
            $_fields .= ' ' . $perhaps_null . ',' . "\n";
        }

        $queries = array();

        $queries[] = 'CREATE TABLE ' . $table_name . ' (' . "\n" . $_fields . '    PRIMARY KEY (' . $keys . ")\n)";

        if ($trigger) {
            $queries[] = "
        CREATE SEQUENCE gen_$table_name
    ";
            $queries[] = "
        CREATE OR REPLACE TRIGGER gen_$table_name BEFORE INSERT ON $table_name
        FOR EACH ROW
        BEGIN
            SELECT gen_$table_name.nextval
            into :new.id
            from dual;
        END;
    ";
        }

        return $queries;
    }

    /**
     * Find whether table truncation support is present.
     *
     * @return boolean Whether it is
     */
    public function supports_truncate_table()
    {
        return true;
    }

    /**
     * Get SQL for creating a table index.
     *
     * @param  ID_TEXT $table_name The name of the table to create the index on
     * @param  ID_TEXT $index_name The index name (not really important at all)
     * @param  string $_fields Part of the SQL query: a comma-separated list of fields to use on the index
     * @param  mixed $connection The DB connection to make on
     * @param  ID_TEXT $raw_table_name The table name with no table prefix
     * @param  string $unique_key_fields The name of the unique key field for the table
     * @param  string $table_prefix The table prefix
     * @return array List of SQL queries to run
     */
    public function create_index($table_name, $index_name, $_fields, $connection, $raw_table_name, $unique_key_fields, $table_prefix)
    {
        if ($index_name[0] == '#') {
            $ret = array();
            $index_name = substr($index_name, 1);
            $fields = explode(',', $_fields);
            foreach ($fields as $field) {
                $ret[] = 'CREATE INDEX ' . $index_name . ' ON ' . $table_name . '(' . $field . ') INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS(\'lexer theme_lexer\')';
                $ret[] = 'EXEC DBMS_STATS.GATHER_TABLE_STATS(USER,\'' . $table_name . '\',cascade=>TRUE)';
            }
            return $ret;
        }

        $_fields = preg_replace('#\(\d+\)#', '', $_fields);

        $fields = explode(',', $_fields);
        foreach ($fields as $field) {
            $sql = 'SELECT m_type FROM ' . $table_prefix . 'db_meta WHERE m_table=\'' . $this->escape_string($raw_table_name) . '\' AND m_name=\'' . $this->escape_string($field) . '\'';
            $values = $this->query($sql, $connection, null, 0, true);
            if (!isset($values[0])) {
                continue; // No result found
            }
            $first = $values[0];
            $field_type = current($first); // Result found

            if ((strpos($field_type, 'LONG') !== false) || ((!multi_lang_content()) && (strpos($field_type, 'SHORT_TRANS') !== false))) {
                // We can't support this in Oracle http://www.oratable.com/ora-01450-maximum-key-length-exceeded/.
                // We assume shorter numbers than 250 are only being used on short columns anyway, which will index perfectly fine without any constraint.
                return array();
            }
        }

        return array('CREATE INDEX ' . $index_name . '__' . $table_name . ' ON ' . $table_name . '(' . $_fields . ')');
    }

    /**
     * Change the primary key of a table.
     *
     * @param  ID_TEXT $table_name The name of the table to create the index on
     * @param  array $new_key A list of fields to put in the new key
     * @param  mixed $connection The DB connection to make on
     */
    public function change_primary_key($table_name, $new_key, $connection)
    {
        $this->query('ALTER TABLE ' . $table_name . ' DROP PRIMARY KEY', $connection);
        $this->query('ALTER TABLE ' . $table_name . ' ADD PRIMARY KEY (' . implode(',', $new_key) . ')', $connection);
    }

    /**
     * Get the number of rows in a table, with approximation support for performance (if necessary on the particular database backend).
     *
     * @param  string $table The table name
     * @param  mixed $connection The DB connection
     * @return ?integer The count (null: do it normally)
     */
    public function get_table_count_approx($table, $connection)
    {
        $sql = 'SELECT NUM_ROWS FROM ALL_TABLES WHERE TABLE_NAME=\'' . strtoupper($this->escape_string($table)) . '\'';
        $values = $this->query($sql, $connection, null, 0, true);
        if (!isset($values[0])) {
            return null; // No result found
        }
        $first = $values[0];
        $v = current($first); // Result found
        return $v;
    }

    /**
     * Encode an SQL statement fragment for a conditional to see if two strings are equal.
     *
     * @param  ID_TEXT $attribute The attribute
     * @param  string $compare The comparison
     * @return string The SQL
     */
    public function string_equal_to($attribute, $compare)
    {
        return $attribute . " LIKE '" . $this->escape_string($compare) . "'";
    }

    /**
     * Assemble part of a WHERE clause for doing full-text search.
     *
     * @param  string $content Our match string (assumes "?" has been stripped already)
     * @param  boolean $boolean Whether to do a boolean full text search
     * @return string Part of a WHERE clause for doing full-text search
     */
    public function full_text_assemble($content, $boolean)
    {
        $content = str_replace('"', '', $content);
        return 'CONTAINS ((?),\'' . $this->escape_string($content) . '\')';
    }

    /**
     * This function is internal to the database system, allowing SQL statements to be build up appropriately. Some databases require IS NULL to be used to check for blank strings.
     *
     * @return boolean Whether a blank string IS NULL
     */
    public function empty_is_null()
    {
        return true;
    }

    /**
     * Escape a string so it may be inserted into a query. If SQL statements are being built up and passed using db_query then it is essential that this is used for security reasons. Otherwise, the abstraction layer deals with the situation.
     *
     * @param  string $string The string
     * @return string The escaped string
     */
    public function escape_string($string)
    {
        $string = fix_bad_unicode($string);

        $string = str_replace("'", "''", $string);
        return str_replace('&', '\&', $string);
    }

    /**
     * Close the database connections. We don't really need to close them (will close at exit), just disassociate so we can refresh them.
     */
    public function close_connections()
    {
        foreach ($this->cache_db as $connection) {
            foreach ($connection as $_db) {
                ocicommit($_db);
            }
        }
    }
}

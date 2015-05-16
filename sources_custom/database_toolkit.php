<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * Script to handle XML DB/MySQL chain synching.
 */
function xml_dump_script()
{
    // Run checks and set up chain DB
    if (get_db_type() != 'xml') {
        warn_exit('It makes no sense to run this script if you are not running the XML database driver.');
    }
    global $SITE_INFO;
    if (array_key_exists('db_chain_type', $SITE_INFO)) {
        require_code('database/' . $SITE_INFO['db_chain_type']);
        $chain_db = new Database_driver($SITE_INFO['db_chain'], $SITE_INFO['db_chain_host'], $SITE_INFO['db_chain_user'], $SITE_INFO['db_chain_password'], get_table_prefix(), false, object_factory('Database_Static_' . $SITE_INFO['db_chain_type']));
    } else {
        warn_exit('It makes no sense to run this script if you have not set up the following config options in _config.php: db_chain_type, db_chain_host, db_chain_user, db_chain_password, db_chain');
    }
    $chain_connection = &$chain_db->connection_write;
    if (count($chain_connection) > 4) { // Okay, we can't be lazy anymore
        $chain_connection = call_user_func_array(array($chain_db->static_ob, 'db_get_connection'), $chain_connection);
        _general_db_init();
    }

    if (function_exists('set_time_limit')) {
        @set_time_limit(0);
    }
    $GLOBALS['DEV_MODE'] = false;
    $GLOBALS['SEMI_DEV_MODE'] = false;

    safe_ini_set('ocproducts.xss_detect', '0');

    if (strtolower(cms_srv('REQUEST_METHOD')) == 'get') { // Interface
        $from = get_param_string('from', null);
        $skip = get_param_string('skip', null);
        $only = get_param_string('only', null);

        echo '
        <!DOCTYPE html>
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
        <title>XML/MySQL DB syncher</title>
        </head>
        <body>
        ';

        echo '<p>Select the tables to sync below. Tables have been auto-ticked based on what seems to need re-synching.</p>';
        echo '<form title="Choose tables" method="post" action="' . escape_html(get_self_url(true)) . '">';
        echo static_evaluate_tempcode(symbol_tempcode('INSERT_SPAMMER_BLACKHOLE'));

        $tables = array_keys(find_all_tables($GLOBALS['SITE_DB']));
        $mysql_status = list_to_map('Name', $chain_db->query('SHOW TABLE STATUS'));
        $mysql_tables = array_keys($mysql_status);
        foreach ($tables as $table_name) {
            $default_selected =
                (((!is_null($from)) && ($table_name >= $from)) ||
                 ((!is_null($only)) && (in_array($table_name, explode(',', $only))))) &&
                ((!is_null($skip)) || (!in_array($table_name, explode(',', $skip))));

            $missing = !in_array(get_table_prefix() . $table_name, $mysql_tables);
            $count_mismatch = !$missing && $chain_db->query_select_value($table_name, 'COUNT(*)') != $GLOBALS['SITE_DB']->query_select_value($table_name, 'COUNT(*)');
            $date_mismatch = false;
            if ((!$missing) && (!$count_mismatch)) {
                $last_m_time = null;
                $path = get_custom_file_base() . '/uploads/website_specific/' . get_db_site() . '/' . get_table_prefix() . $table_name;
                $dh = @opendir($path);
                if ($dh !== false) {
                    while (($f = readdir($dh)) !== false) {
                        if ((substr($f, -4) == '.dat') || (substr($f, -4) == '.xml')) {
                            $last_m_time = @max($last_m_time, filemtime($path . '/' . $f)); // @ because of the 255 read filepath limit on Windows
                        }
                    }
                    closedir($dh);
                }
                if (!is_null($last_m_time)) {
                    $mysql_time = strtotime($mysql_status[get_table_prefix() . $table_name]['Update_time']);
                    $date_mismatch = ($mysql_time < $last_m_time); // We can't do "!=" as last m-time for MySQL could well by the last sync time
                }
            }

            $needs_doing = $count_mismatch || $date_mismatch || $missing || $default_selected;

            echo '
                    <div style="width: 500px">
                            <span style="float: right; font-style: italic">
                            ' . ($missing ? '[table is missing]' : '') . '
                            ' . ($count_mismatch ? '[different record-counts]' : '') . '
                            ' . ($date_mismatch ? '[different last-modified-time]' : '') . '
                            </span>

                            <input ' . (($needs_doing) ? 'checked="checked" ' : '') . 'type="checkbox" name="table_' . htmlentities($table_name) . '" id="table_' . htmlentities($table_name) . '" value="1" />
                            <label for="table_' . htmlentities($table_name) . '">' . htmlentities($table_name) . '</label>
                    </div>
            ';
        }

        echo '<p><input class="menu___generic_admin__sync button_screen" type="submit" value="Sync" /> &nbsp;&nbsp;&nbsp;&nbsp; [<a href="#" onclick="var form=document.getElementsByTagName(\'form\')[0]; for (var i=0;i&lt;form.elements.length;i++) if (form.elements[i].checked) form.elements[i].checked=false; return false;">un-tick all</a>]</p>';
        echo '</form>';

        echo '
        </body>
        </html>
        ';

        exit();
    }

    // Actualiser

    $from = null;
    $skip = null;
    $only = '';
    foreach (array_keys($_POST) as $key) {
        if (substr($key, 0, 6) == 'table_') {
            if ($only != '') {
                $only .= ',';
            }
            $only .= substr($key, 6);
        }
    }
    if ($only == '') {
        $only = null;
    }

    @header('Content-type: text/plain; charset=' . get_charset());

    $sql = get_sql_dump(true, true, $from, is_null($skip) ? array() : explode(',', $skip), is_null($only) ? null : explode(',', $only));

    $cnt = count($sql);
    foreach ($sql as $i => $s) {
        print('Executing query ' . strval($i + 1) . '/' . strval($cnt) . ' ... ' . $s . "\n\n");
        flush();

        $fail_ok = (substr($s, 0, 5) == 'ALTER');
        $chain_db->static_ob->db_query($s, $chain_connection, null, null, $fail_ok, false);
    }

    print('!!Done!!');
}

/**
 * Get a list of the defines tables.
 *
 * @param  object $db Database connection to look in
 * @return array The tables
 */
function find_all_tables($db)
{
    $fields = $db->query_select('db_meta', array('m_table', 'm_name', 'm_type'), null, 'ORDER BY m_table');
    $tables = array();
    foreach ($fields as $field) {
        if (!isset($tables[$field['m_table']])) {
            $tables[$field['m_table']] = array();
        }
        $tables[$field['m_table']][$field['m_name']] = $field['m_type'];
    }
    $tables['db_meta'] = array('m_table' => '*ID_TEXT', 'm_name' => '*ID_TEXT', 'm_type' => 'ID_TEXT');
    $tables['db_meta_indices'] = array('i_table' => '*ID_TEXT', 'i_name' => '*ID_TEXT', 'i_fields' => '*ID_TEXT');

    ksort($tables);

    return $tables;
}

/**
 * Get MySQL SQL code for the currently loaded database.
 *
 * @param  boolean $include_drops Whether to include 'DROP' statements
 * @param  boolean $output_statuses Whether to output status as we go
 * @param  ?ID_TEXT $from Table to look from (null: first table)
 * @param  ?array $skip Array of table names to skip (null: none)
 * @param  ?array $only Array of only table names to do (null: all)
 * @param  boolean $echo Whether to echo out
 * @return array The SQL statements
 */
function get_sql_dump($include_drops = false, $output_statuses = false, $from = null, $skip = null, $only = null, $echo = false)
{
    if (is_null($skip)) {
        $skip = array();
    }

    $tables = find_all_tables($GLOBALS['SITE_DB']);

    $out = array();

    // Tables
    foreach ($tables as $table_name => $fields) {
        if ((!is_null($from)) && ($table_name < $from)) {
            continue;
        }
        if (in_array($table_name, $skip)) {
            continue;
        }
        if ((!is_null($only)) && (!in_array($table_name, $only))) {
            continue;
        }

        if ($output_statuses) {
            print('Working out SQL for table: ' . $table_name . "\n");
            flush();
        }

        if ($include_drops) {
            $out[] = 'DROP TABLE IF EXISTS ' . get_table_prefix() . $table_name . ';';
            if ($echo) {
                echo $out[0];
                $out = array();
            }
        }

        $out[] = db_create_table($table_name, $fields);
        if ($echo) {
            echo $out[0];
            $out = array();
        }

        // Data
        $start = 0;
        do {
            $data = $GLOBALS['SITE_DB']->query_select($table_name, array('*'), null, '', 100, $start, false, array());
            foreach ($data as $map) {
                $keys = '';
                $all_values = array();

                foreach ($map as $key => $value) {
                    if ($keys != '') {
                        $keys .= ', ';
                    }
                    $keys .= $key;

                    $_value = (!is_array($value)) ? array($value) : $value;

                    $v = mixed();
                    foreach ($_value as $i => $v) {
                        if (!array_key_exists($i, $all_values)) {
                            $all_values[$i] = '';
                        }
                        $values = $all_values[$i];

                        if ($values != '') {
                            $values .= ', ';
                        }

                        if (is_null($value)) {
                            $values .= 'NULL';
                        } else {
                            if (is_float($v)) {
                                $values .= float_to_raw_string($v);
                            } elseif (is_integer($v)) {
                                $values .= strval($v);
                            } else {
                                $values .= '\'' . db_escape_string($v) . '\'';
                            }
                        }

                        $all_values[$i] = $values; // essentially appends, as $values was loaded from former $all_values[$i] value
                    }
                }

                $out[] = 'INSERT INTO ' . get_table_prefix() . $table_name . ' (' . $keys . ') VALUES (' . $all_values[0] . ')' . ";";
                if ($echo) {
                    echo $out[0];
                    $out = array();
                }
            }

            $start += 100;
        } while (count($data) != 0);
    }

    // Indexes
    $indexes = $GLOBALS['SITE_DB']->query_select('db_meta_indices', array('*'));
    foreach ($indexes as $index) {
        $index_name = $index['i_name'];
        if ($index_name[0] == '#') {
            $index_name = substr($index_name, 1);
            $type = 'FULLTEXT';
        } else {
            $type = 'INDEX';
        }
        $out[] = 'ALTER TABLE ' . get_table_prefix() . $index['i_table'] . ' ADD ' . $type . ' ' . $index_name . ' (' . $index['i_fields'] . ')' . ";";
        if ($echo) {
            echo $out[0];
            $out = array();
        }
    }

    return $out;
}

/**
 * Get a map of Composr field types, to actual database types.
 *
 * @return array The map
 */
function db_get_type_remap()
{
    $type_remap = array(
        'AUTO' => 'integer unsigned auto_increment',
        'AUTO_LINK' => 'integer', // not unsigned because it's useful to have -ve for temporary usage whilst importing
        'INTEGER' => 'integer',
        'UINTEGER' => 'integer unsigned',
        'SHORT_INTEGER' => 'tinyint',
        'REAL' => 'real',
        'BINARY' => 'tinyint(1)',
        'MEMBER' => 'integer', // not unsigned because it's useful to have -ve for temporary usage whilst importing
        'GROUP' => 'integer', // not unsigned because it's useful to have -ve for temporary usage whilst importing
        'TIME' => 'integer unsigned',
        'LONG_TRANS' => 'integer unsigned',
        'SHORT_TRANS' => 'integer unsigned',
        'LONG_TRANS__COMCODE' => 'integer unsigned',
        'SHORT_TRANS__COMCODE' => 'integer unsigned',
        'SHORT_TEXT' => 'varchar(255)',
        'LONG_TEXT' => 'longtext',
        'ID_TEXT' => 'varchar(80)',
        'MINIID_TEXT' => 'varchar(40)',
        'IP' => 'varchar(40)', // 15 for ip4, but we now support ip6
        'LANGUAGE_NAME' => 'varchar(5)',
        'URLPATH' => 'varchar(255)',
        'MD5' => 'varchar(33)'
    );
    return $type_remap;
}

/**
 * Create a new table.
 *
 * @param  ID_TEXT $table_name The table name
 * @param  array $fields A map of field names to Composr field types (with *#? encodings)
 * @return string The SQL for it
 */
function db_create_table($table_name, $fields)
{
    $type_remap = db_get_type_remap();

    $_fields = '';
    $keys = '';
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

        $type = isset($type_remap[$type]) ? $type_remap[$type] : $type;

        $_fields .= '     ' . $name . ' ' . $type;
        /*if (substr($name, -13) == '__text_parsed') {    BLOB/TEXT column 'description__text_parsed' can't have a default value
            $_fields .= ' DEFAULT \'\'';
        } else*/
        if (substr($name, -13) == '__source_user') {
            $_fields .= ' DEFAULT ' . strval(db_get_first_id());
        }
        $_fields .= ' ' . $perhaps_null . ',' . "\n";
    }

    $query = 'CREATE TABLE ' . get_table_prefix() . $table_name . ' (
' . $_fields . '
      PRIMARY KEY (' . $keys . ')
    ) type=' . ('MyISAM') . ';';
    return $query;
}

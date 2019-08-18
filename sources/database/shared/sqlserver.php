<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

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

/**
 * Database driver class.
 *
 * @package    core_database_drivers
 */
class Database_super_sqlserver extends DatabaseDriver
{
    /**
     * Adjust an SQL query to apply offset/limit restriction.
     *
     * @param  string $query The complete SQL query
     * @param  ?integer $max The maximum number of rows to affect (null: no limit)
     * @param  integer $start The start row to affect
     */
    public function apply_sql_limit_clause(&$query, $max = null, $start = 0)
    {
        if ($max !== null) {
            $_max = $max;
            $_max += $start;

            $query = ltrim($query);

            // Unfortunately we can't apply to DELETE FROM and update :(. But its not too important, LIMIT'ing them was unnecessarily anyway
            $prefixes_recognised = array(
                'SELECT DISTINCT TOP' => false,
                'SELECT DISTINCT' => true,
                'SELECT TOP' => false,
                'SELECT' => true,
                '(SELECT DISTINCT TOP' => false,
                '(SELECT DISTINCT' => true,
                '(SELECT TOP' => false,
                '(SELECT' => true,
            );
            foreach ($prefixes_recognised as $prefix => $use) {
                if (strtoupper(substr($query, 0, strlen($prefix) + 1)) == $prefix . ' ') {
                    if ($use) {
                        $query = $prefix . ' TOP ' . strval(intval($_max)) . ' ' . substr($query, strlen($prefix) + 1);
                    }
                    break;
                }
            }
        }
    }

    /**
     * Adjust an SQL query to use T-SQL's unique Unicode syntax.
     *
     * @param  string $query The complete SQL query
     */
    protected function rewrite_to_unicode_syntax(&$query)
    {
        if (get_charset() != 'utf-8') {
            return;
        }

        if (strpos($query, "'") === false) {
            return;
        }

        $new_query = '';
        $len = strlen($query);
        $in_string = false;
        for ($i = 0; $i < $len; $i++) {
            $char = $query[$i];

            if ($in_string) {
                if ($char == "'") {
                    if (($i < $len - 1) && ($query[$i + 1] == "'")) {
                        // Escaped, so put it out and jump ahead a bit
                        $new_query .= "''";
                        $i++;
                        continue;
                    } else {
                        // End of string section
                        $in_string = false;
                    }
                }
            } else {
                if ($char == "'") {
                    // Start of string section
                    $in_string = true;
                    if (($i == 0) || ($new_query[$i - 1] != 'N')) {
                        $new_query .= 'N';
                    }
                }
            }

            $new_query .= $char;
        }

        $query = $new_query;
    }

    /**
     * Get the default user for making db connections (used by the installer as a default).
     *
     * @return string The default user for db connections
     */
    public function default_user()
    {
        return 'sa';
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
     * Get a map of Composr field types, to actual database types.
     *
     * @param  boolean $for_alter Whether this is for adding a table field
     * @return array The map
     */
    public function get_type_remap($for_alter = false)
    {
        $type_remap = array(
            'AUTO' => 'integer identity',
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
            'LONG_TRANS__COMCODE' => 'bigint',
            'SHORT_TRANS__COMCODE' => 'bigint',
            'SHORT_TEXT' => 'nvarchar(255)',
            'LONG_TEXT' => 'nvarchar(MAX)', // 'TEXT' cannot be indexed.
            'ID_TEXT' => 'nvarchar(80)',
            'MINIID_TEXT' => 'nvarchar(40)',
            'IP' => 'nvarchar(40)',
            'LANGUAGE_NAME' => 'nvarchar(5)',
            'URLPATH' => 'nvarchar(255)',
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

            $_fields .= '    ' . $name . ' ' . $type;
            if (substr($name, -13) == '__text_parsed') {
                $_fields .= ' DEFAULT \'\'';
            } elseif (substr($name, -13) == '__source_user') {
                $_fields .= ' DEFAULT ' . strval(db_get_first_id());
            }
            $_fields .= ' ' . $perhaps_null . ',' . "\n";
        }

        $query_create = 'CREATE TABLE ' . $table_name . ' (' . "\n" . $_fields . '    PRIMARY KEY (' . $keys . ")\n)";
        $ret = array($query_create);

        if (running_script('commandr')) {
            if (in_array('*AUTO', $fields)) {
                static $query_insert_last_table_name = null;
                if ($query_insert_last_table_name !== null) {
                    $query_identity_off = 'SET IDENTITY_INSERT ' . $query_insert_last_table_name . ' OFF';
                    $ret[] = $query_identity_off;
                }
                $query_insert_last_table_name = $table_name;
                $query_identity_on = 'SET IDENTITY_INSERT ' . $table_name . ' ON';
                $ret[] = $query_identity_on;
            }
        }

        return $ret;
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
            if ($this->has_full_text($connection)) {
                $index_name = substr($index_name, 1);

                // Only allowed one index per table, so we need to merge in any existing indices
                $existing_index_fields = $GLOBALS['SITE_DB']->query_select('db_meta_indices', array('i_name', 'i_fields'), array('i_table' => $raw_table_name));
                foreach ($existing_index_fields as $existing_index_field) {
                    if (substr($existing_index_field['i_name'], 0, 1) == '#') {
                        $_fields .= ',' . $existing_index_field['i_fields'];
                    }
                }
                $_fields = implode(',', array_unique(explode(',', $_fields)));

                // Full-text catalogue needed
                $ret[] = 'IF NOT EXISTS (SELECT * FROM sys.fulltext_catalogs WHERE name=\'ft\') CREATE FULLTEXT CATALOG ft AS DEFAULT';

                // Create unique index on primary key if needed (required for full-text to function)
                $unique_index_name = 'unique__' . $table_name;
                $ret[] = 'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name=\'' . $unique_index_name . '\' AND object_id=OBJECT_ID(\'' . $table_name . '\')) CREATE UNIQUE INDEX ' . $unique_index_name . ' ON ' . $table_name . '(' . $unique_key_fields . ')';

                // Delete full-text index if already exists
                $ret[] = 'IF EXISTS (SELECT * FROM sys.fulltext_indexes WHERE object_id=OBJECT_ID(\'' . $table_name . '\')) DROP FULLTEXT INDEX ON ' . $table_name;

                // Create full-text index on table if needed
                $ret[] = 'CREATE FULLTEXT INDEX ON ' . $table_name . '(' . $_fields . ') KEY INDEX ' . $unique_index_name;
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
                // We can't support this in SQL Server https://blogs.msdn.microsoft.com/bartd/2011/01/06/living-with-sqls-900-byte-index-key-length-limit/.
                // We assume shorter numbers than 250 are only being used on short columns anyway, which will index perfectly fine without any constraint.
                return array();
            }
        }

        return array('CREATE INDEX ' . $index_name . '__' . $table_name . ' ON ' . $table_name . '(' . $_fields . ')');
    }

    /**
     * Get SQL to delete a table.
     * When running this SQL you must suppress errors.
     *
     * @param  ID_TEXT $table The table name
     * @return array List of SQL queries to run
     */
    public function drop_table_if_exists($table)
    {
        return array('IF EXISTS (SELECT * FROM sys.objects WHERE object_id=OBJECT_ID(\'' . $table . '\') AND type IN (\'U\')) DROP TABLE ' . $table);
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
        $sql = 'SELECT SUM(p.rows) FROM sys.partitions AS p
            INNER JOIN sys.tables AS t
            ON p.[object_id] = t.[object_id]
            INNER JOIN sys.schemas AS s
            ON s.[schema_id] = t.[schema_id]
            WHERE t.name = N\'' . $this->escape_string($table) . '\'
            AND s.name = N\'dbo\'
            AND p.index_id IN (0,1)';
        $values = $this->query($sql, $connection, null, 0, true);
        if (!isset($values[0])) {
            return null; // No result found
        }
        $first = $values[0];
        $v = current($first); // Result found
        return $v;
    }

    /**
     * Set a time limit on future queries.
     * Not all database drivers support this.
     *
     * @param  integer $seconds The time limit in seconds
     * @param  mixed $connection The DB connection
     */
    public function set_query_time_limit($seconds, $connection)
    {
        $this->query_timeout = $seconds;
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
        return $attribute . "='" . $this->db_escape_string($compare) . "'";
    }

    /**
     * Encode a LIKE string comparison fragment for the database system. The pattern is a mixture of characters and ? and % wildcard symbols.
     *
     * @param  string $pattern The pattern
     * @return string The encoded pattern
     */
    public function encode_like($pattern)
    {
        return $this->escape_string(str_replace('%', '*', $pattern));
    }

    /**
     * Find whether full-text-search is present.
     *
     * @param  mixed $connection The DB connection
     * @return boolean Whether it is
     */
    public function has_full_text($connection)
    {
        return ((!function_exists('get_value')) || (get_value('disable_fulltext_sqlserver') !== '1'));
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
     * Escape a string so it may be inserted into a query. If SQL statements are being built up and passed using db_query then it is essential that this is used for security reasons. Otherwise, the abstraction layer deals with the situation.
     *
     * @param  string $string The string
     * @return string The escaped string
     */
    public function escape_string($string)
    {
        $string = fix_bad_unicode($string);

        return str_replace("'", "''", $string);
    }
}

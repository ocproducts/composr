<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/*
Used to generate a database schema in the form of SQL code that can be imported into MySQL Workbench

First run this, then run SQLEditor on the files created in uploads/website_specific.
*/

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

require_code('database_relations');

$all_tables = get_all_tables();

$tables_by = get_tables_by_addon();

foreach ($tables_by as $t => $ts) {
    $path = get_custom_file_base() . '/uploads/website_specific/composr_erd__' . $t . '.sql';
    $myfile = fopen($path, GOOGLE_APPENGINE ? 'wb' : 'wt');
    $tables = array();
    foreach ($ts as $table) {
        if (!array_key_exists($table, $all_tables)) {
            continue; // Not installed
        }

        $tables[$table] = $all_tables[$table];
    }
    fwrite($myfile, get_innodb_table_sql($tables, $all_tables));
    fclose($myfile);
    fix_permissions($path);
    sync_file($path);
}

$GLOBALS['SCREEN_TEMPLATE_CALLED'] = '';
echo 'Done, files generated in <kbd>uploads/website_specific</kbd>.';

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    db_schema
 */

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

require_code('database_relations');
$table_descriptions = get_table_descriptions();
$relation_map = get_relation_map();

$tables_by = get_tables_by_addon();

foreach ($tables_by as $t => $ts) {
    echo '<h2>';
    echo escape_html($t);
    echo '</h2>';
    sort($ts);
    echo '<ul>';
    foreach ($ts as $table) {
        echo '<li>' . escape_html($table);
        if (isset($table_descriptions[$table])) {
            echo ' &ndash; <span style="color: green">' . $table_descriptions[$table] . '</span>';
        }
        echo '<ul>';
        $fields = $GLOBALS['SITE_DB']->query_select('db_meta', array('m_name', 'm_type'), array('m_table' => $table));
        foreach ($fields as $field) {
            $type = str_replace('?', '', str_replace('*', '', $field['m_type']));
            $extra = '';
            if (array_key_exists($relation_map, $table . '.' . $field['m_name'])) {
                $relation = $relation_map[$table . '.' . $field['m_name']];
                $extra .= ' ( &rarr; <strong>' . escape_html(is_null($relation) ? '*' : $relation) . '</strong>)';
            }
            if (strpos($field['m_type'], '*') !== false) {
                $extra .= ' (<span style="text-decoration: underline"">Key field</span>)';
            }
            if (strpos($field['m_type'], '?') !== false) {
                $extra .= ' (<em>May be NULL</em>)';
            }
            echo '<li><strong>' . escape_html($type) . '</strong> ' . escape_html($field['m_name']) . $extra . '</li>';
        }
        echo '</ul>';
        echo '<br /></li>';
    }
    echo '</ul>';
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__privacy()
{
    define('PRIVACY_METHOD_leave', 0);
    define('PRIVACY_METHOD_anonymise', 1);
    define('PRIVACY_METHOD_delete', 2);
}

// TODO

/**
 * Privacy details base class.
 *
 * @package        core
 */
abstract class Hook_privacy_base
{
    /**
     * Get field metadata for a table.
     *
     * @param  ID_TEXT $table_name Table name
     * @return array Field metadata
     */
    protected function get_field_metadata($table_name)
    {
        $db = get_db_for($table_name);
        $fields = $db->query_select($table_name, array('m_name', 'm_type'), array('m_table' => $table_name));
        return collapse_2d_complexity('m_name', 'm_type', $fields);
    }

    /**
     * Serialise a row.
     *
     * @param  ID_TEXT $table_name Table name
     * @param  array $row Row raw from the database
     * @return array Row in a cleanly serialised format
     */
    public function serialise($table_name, $row)
    {
        $db = get_db_for($table_name);
        $metadata = $this->get_field_metadata($table_name);

        $row2 = array();
        foreach ($metadata as $key => $type) {
            if (strpos($type, '_TRANS') !== false) {
                $row2[$key] = get_translated_text($row[$key], $db);
            } else {
                $row2[$key] = $row[$key];
            }
        }

        return $row2;
    }

    /**
     * Anonymise a row.
     *
     * @param  ID_TEXT $table_name Table name
     * @param  array $row Row raw from the database
     */
    public function anonymise($table_name, $row)
    {
        $info = $this->info();
        $member_id_fields = $info['database_records'][$table_name]['member_id_fields'];

        $db = get_db_for($table_name);
        $metadata = $this->get_field_metadata($table_name);

        $where = array();
        foreach ($metadata as $key => $type) {
            if (strpos($type, '*') !== false) {
                $where[$key] = $row[$key];
            }
        }
        if ($where === array()) {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }

        $update = array();
        foreach ($member_id_fields as $member_id_field) {
            if (strpos($metadata[$member_id_field], '?') !== false) {
                $anonymised_value = null;
            } else {
                $anonymised_value = $GLOBALS['FORUM_DRIVER']->get_guest_id();
            }
            $update[$member_id_field] = $anonymised_value;
        }

        $db->query_update($table_name, $update, $where, '', 1);
    }

    /**
     * Delete a row.
     *
     * @param  ID_TEXT $table_name Table name
     * @param  array $row Row raw from the database
     */
    public function delete($table_name, $row)
    {
        $info = $this->info();

        $db = get_db_for($table_name);
        $metadata = $this->get_field_metadata($table_name);

        $where = array();
        foreach ($metadata as $key => $type) {
            if (strpos($type, '*') !== false) {
                $where[$key] = $row[$key];
            }
        }
        if ($where === array()) {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }

        foreach ($metadata as $key => $type) {
            if (strpos($type, '_TRANS') !== false) {
                delete_lang($row[$key], $db);
            }
        }

        $db->query_delete($table_name, $where, '', 1);
    }
}
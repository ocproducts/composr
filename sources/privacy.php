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
 * @package    core_privacy
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__privacy()
{
    if (!defined('PRIVACY_METHOD_leave')) {
        define('PRIVACY_METHOD_leave', 1);
        define('PRIVACY_METHOD_anonymise', 2);
        define('PRIVACY_METHOD_delete', 4);
    }

    require_lang('privacy');
}

/**
 * Privacy details base class.
 *
 * @package        core
 */
abstract class Hook_privacy_base
{
    /**
     * Get selection SQL for a particular search.
     *
     * @param  ID_TEXT $table_name Table name
     * @param  array $table_details Details from the info function for the given table
     * @param  ?MEMBER $member_id_username Member ID to search for, based on username (null: none)
     * @param  array $ip_addresses List of IP addresses to search for
     * @param  ?MEMBER $member_id Member ID to search for (null: none)
     * @param  string $email_address E-mail address to search for (blank: none)
     * @param  array $others List of other strings to search for, via additional-anonymise-fields
     * @return string The stem of the SQL query
     */
    public function get_selection_sql($table_name, $table_details, $member_id_username = null, $ip_addresses = array(), $member_id = null, $email_address = '', $others = array())
    {
        $db = get_db_for($table_name);

        $sql = '';

        $conditions = array();
        if ($member_id_username !== null) {
            foreach ($table_details['member_id_fields'] as $member_id_field) {
                $conditions[] = $member_id_field . '=' . strval($member_id_username);
            }
        }
        foreach ($ip_addresses as $ip_address) {
            if ($ip_address == '') {
                continue;
            }

            foreach ($table_details['ip_address_fields'] as $ip_address_field) {
                $conditions[] = db_string_equal_to($ip_address_field, $ip_address);
            }
        }
        if (($member_id !== null) && ($member_id_username !== $member_id)) {
            foreach ($table_details['member_id_fields'] as $member_id_field) {
                $conditions[] = $member_id_field . '=' . strval($member_id);
            }
        }
        if ($email_address != '') {
            foreach ($table_details['email_fields'] as $email_address_field) {
                $conditions[] = db_string_equal_to($email_address_field, $email_address);
            }
        }
        foreach ($others as $other) {
            if ($other == '') {
                continue;
            }

            foreach ($table_details['additional_anonymise_fields'] as $other_field) {
                $conditions[] = db_string_equal_to($other_field, $other);
            }
        }

        if (count($conditions) > 0) {
            $sql .= ' WHERE (';
            foreach ($conditions as $i => $condition) {
                if ($i != 0) {
                    $sql .= ' OR ';
                }

                $sql .= $condition;
            }
            $sql .= ')';
        }

        if ($table_details['extra_where'] !== null) {
            if (count($conditions) == 0) {
                $sql .= ' WHERE ';
            } else {
                $sql .= ' AND ';
            }
            $sql .= $table_details['extra_where'];
        }

        return $sql;
    }

    /**
     * Get field metadata for a table.
     *
     * @param  ID_TEXT $table_name Table name
     * @return array Field metadata
     */
    protected function get_field_metadata($table_name)
    {
        $db = get_db_for($table_name);
        $fields = $db->query_select('db_meta', array('m_name', 'm_type'), array('m_table' => $table_name));
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
            } elseif (strpos($type, 'TIME') !== false) {
                $row2[$key] = ($row[$key] === null) ? null : get_timezoned_date($row[$key]);
            } elseif (strpos($type, 'BINARY') !== false) {
                $row2[$key] = ($row[$key] === null) ? null : ($row[$key] == 1);
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

        $db = get_db_for($table_name);
        $metadata = $this->get_field_metadata($table_name);

        // Work out WHERE clause
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

        // Anonymise member ID
        $member_id_fields = $info['database_records'][$table_name]['member_id_fields'];
        foreach ($member_id_fields as $member_id_field) {
            if (strpos($metadata[$member_id_field], '?') !== false) {
                $anonymised_value = null;
            } else {
                $anonymised_value = $GLOBALS['FORUM_DRIVER']->get_guest_id();
            }
            $update[$member_id_field] = $anonymised_value;
        }

        // Anonymise IP address
        $ip_address_fields = $info['database_records'][$table_name]['ip_address_fields'];
        foreach ($ip_address_fields as $ip_address_field) {
            $update[$ip_address_field] = '';
        }

        // Anonymise e-mail address
        $email_fields = $info['database_records'][$table_name]['email_fields'];
        foreach ($email_fields as $email_field) {
            $update[$email_field] = '';
        }

        // Anonymise additional fields
        $additional_anonymise_fields = $info['database_records'][$table_name]['additional_anonymise_fields'];
        foreach ($additional_anonymise_fields as $additional_anonymise_field) {
            $update[$additional_anonymise_field] = do_lang('UNKNOWN');
        }

        // Run query.
        $db->query_update($table_name, $update, $where, '', null, 0, false, true);
        $db->query_delete($table_name, $where); // In case there was some duplication error causing the above query to fail
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

        // Work out WHERE clause
        $where = array();
        foreach ($metadata as $key => $type) {
            if (strpos($type, '*') !== false) {
                $where[$key] = $row[$key];
            }
        }
        if ($where === array()) {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }

        // Delete language strings
        foreach ($metadata as $key => $type) {
            if (strpos($type, '_TRANS') !== false) {
                delete_lang($row[$key], $db);
            }
        }

        // Run query
        $db->query_delete($table_name, $where, '', 1);
    }
}
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
 * @package    calendar
 */

/**
 * Hook class.
 */
class Hook_privacy_calendar extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('calendar')) {
            return null;
        }

        return array(
            'cookies' => array(
                /*'feed_*' => array( TODO #3846
                    'reason' => 'Feeds you have overlaid over your calendar',
                ),*/
            ),

            'positive' => array(
            ),

            'general' => array(
            ),

            'database_records' => array(
                'calendar_events' => array(
                    'timestamp_field' => 'e_add_date',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('e_submitter', 'e_member_calendar'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                    'allowed_handle_methods' => PRIVACY_METHOD_anonymise | PRIVACY_METHOD_delete,
                ),
                'calendar_reminders' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('n_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                    'allowed_handle_methods' => PRIVACY_METHOD_delete,
                ),
                'calendar_interests' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('i_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                    'allowed_handle_methods' => PRIVACY_METHOD_delete,
                ),
                'calendar_jobs' => array(
                    'timestamp_field' => 'j_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('j_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                    'allowed_handle_methods' => PRIVACY_METHOD_delete,
                ),
            ),
        );
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
        $ret = parent::serialise($table_name, $row);

        switch ($table_name) {
            case 'calendar_events':
                $title = $GLOBALS['SITE_DB']->query_select_value_if_there('calendar_types', 't_title', array('id' => $row['e_type']));
                if ($title !== null) {
                    $ret += array(
                        'e_type__dereferenced' => get_translated_text($title),
                    );
                }
                break;

            case 'calendar_reminders':
                $title = $GLOBALS['SITE_DB']->query_select_value_if_there('calendar_events', 'e_title', array('id' => $row['e_id']));
                if ($title !== null) {
                    $ret += array(
                        'e_id__dereferenced' => get_translated_text($title),
                    );
                }
                break;

            case 'calendar_interests':
                $title = $GLOBALS['SITE_DB']->query_select_value_if_there('calendar_types', 't_title', array('id' => $row['t_type']));
                if ($title !== null) {
                    $ret += array(
                        't_type__dereferenced' => get_translated_text($title),
                    );
                }
                break;

            case 'calendar_jobs':
                $title = $GLOBALS['SITE_DB']->query_select_value_if_there('calendar_events', 'e_title', array('id' => $row['j_event_id']));
                if ($title !== null) {
                    $ret += array(
                        'j_event_id__dereferenced' => get_translated_text($title),
                    );
                }
                break;
        }

        return $ret;
    }

    /**
     * Delete a row.
     *
     * @param  ID_TEXT $table_name Table name
     * @param  array $row Row raw from the database
     */
    public function delete($table_name, $row)
    {
        require_lang('calendar');

        switch ($table_name) {
            case 'calendar_events':
                require_code('calendar2');
                delete_calendar_event($row['id']);
                break;

            default:
                parent::delete($table_name, $row);
                break;
        }
    }
}

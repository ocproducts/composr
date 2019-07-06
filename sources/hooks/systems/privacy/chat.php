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
 * @package    chat
 */

/**
 * Hook class.
 */
class Hook_privacy_chat extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('chat')) {
            return null;
        }

        require_code('chat');

        return array(
            'cookies' => array(
                'software_chat_prefs' => array(
                    'purpose' => 'Chat room display preferences',
                ),
                'last_chat_msg_*' => array(
                    'purpose' => 'Your most recent unposted message in a chatroom, so we can prevent data loss if you accidentally reload the page',
                ),
            ),

            'positive' => array(
            ),

            'general' => array(
            ),

            'database_records' => array(
                'chat_friends' => array(
                    'timestamp_field' => 'date_and_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('member_likes', 'member_liked'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'chat_events' => array(
                    'timestamp_field' => 'e_date_and_time',
                    'retention_days' => intval(ceil(floatval(CHAT_EVENT_PRUNE) / 60.0 / 60.0 / 24.0)),
                    'retention_handle_method' => PRIVACY_METHOD_delete,
                    'member_id_fields' => array('e_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'chat_active' => array(
                    'timestamp_field' => 'date_and_time',
                    'retention_days' => intval(ceil(floatval(CHAT_ACTIVITY_PRUNE) / 60.0 / 60.0 / 24.0)),
                    'retention_handle_method' => PRIVACY_METHOD_delete,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'chat_messages' => array(
                    'timestamp_field' => 'date_and_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array('ip_address'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'chat_blocking' => array(
                    'timestamp_field' => 'date_and_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('member_blocker', 'member_blocked'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'chat_sound_effects' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('s_member'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
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
        $ret = $this->serialise($table_name, $row);

        switch ($table_name) {
            case 'chat_friends':
                $ret += array(
                    'member_likes__dereferenced' => $GLOBALS['FORUM_DRIVER']->get_username($row['member_likes']),
                    'member_liked__dereferenced' => $GLOBALS['FORUM_DRIVER']->get_username($row['member_liked']),
                );
                break;

            case 'chat_events':
                $ret += array(
                    'e_room_id__dereferenced' => $GLOBALS['SITE_DB']->query_select_value_if_there('chat_rooms', 'room_name', array('id' => $row['e_room_id'])),
                );
                break;

            case 'chat_active':
                $ret += array(
                    'room_id__dereferenced' => $GLOBALS['SITE_DB']->query_select_value_if_there('chat_rooms', 'room_name', array('id' => $row['room_id'])),
                );
                break;

            case 'chat_messages':
                $ret += array(
                    'room_id__dereferenced' => $GLOBALS['SITE_DB']->query_select_value_if_there('chat_rooms', 'room_name', array('id' => $row['room_id'])),
                );
                break;

            case 'chat_blocking':
                $ret += array(
                    'member_blocker__dereferenced' => $GLOBALS['FORUM_DRIVER']->get_username($row['member_blocker']),
                    'member_blocked__dereferenced' => $GLOBALS['FORUM_DRIVER']->get_username($row['member_blocked']),
                );
                break;
        }

        return $ret;
    }
}
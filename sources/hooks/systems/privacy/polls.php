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
 * @package    polls
 */

/**
 * Hook class.
 */
class Hook_privacy_polls extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('polls')) {
            return null;
        }

        return array(
            'cookies' => array(
            ),

            'positive' => array(
            ),

            'general' => array(
            ),

            'database_records' => array(
                'poll' => array(
                    'timestamp_field' => 'add_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('submitter'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                    'allowed_handle_methods' => PRIVACY_METHOD_anonymise | PRIVACY_METHOD_delete,
                ),
                'poll_votes' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('v_voter_id'),
                    'ip_address_fields' => array('v_voter_ip'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                    'allowed_handle_methods' => PRIVACY_METHOD_anonymise | PRIVACY_METHOD_delete,
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
            case 'poll_votes':
                $poll_rows = $GLOBALS['SITE_DB']->query_select('poll', array('*'), array('id' => $row['v_poll_id']), '', 1);
                if (array_key_exists(0, $poll_rows)) {
                    $ret += array(
                        'v_poll_id__dereferenced' => get_translated_text($poll_rows[0]['question']),
                        'v_vote_for__dereferenced' => ($row['v_vote_for'] === null) ? null : get_translated_text($poll_rows[0]['option' . strval($row['v_vote_for'])]),
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
        require_lang('polls');

        switch ($table_name) {
            case 'poll':
                require_code('polls2');
                delete_poll($row['id']);
                break;

            default:
                parent::delete($table_name, $row);
                break;
        }
    }
}

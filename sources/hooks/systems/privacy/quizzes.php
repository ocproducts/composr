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
 * @package    quizzes
 */

/**
 * Hook class.
 */
class Hook_privacy_quizzes extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('quizzes')) {
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
                'quizzes' => array(
                    'timestamp_field' => 'q_add_date',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('q_submitter'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                    'allowed_handle_methods' => PRIVACY_METHOD_anonymise | PRIVACY_METHOD_delete,
                ),
                'quiz_member_last_visit' => array(
                    'timestamp_field' => 'v_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('v_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                    'allowed_handle_methods' => PRIVACY_METHOD_delete,
                ),
                'quiz_entries' => array(
                    'timestamp_field' => 'q_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('q_member'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
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
            case 'quiz_member_last_visit':
                $name = $GLOBALS['SITE_DB']->query_select_value_if_there('quizzes', 'q_name', array('id' => $row['v_quiz_id']));
                if ($name !== null) {
                    $ret += array(
                        'v_quiz_id__dereferenced' => get_translated_text($name),
                    );
                }
                break;
            case 'quiz_entries':
                $name = $GLOBALS['SITE_DB']->query_select_value_if_there('quizzes', 'q_name', array('id' => $row['q_quiz']));
                if ($name !== null) {
                    require_code('quiz');
                    require_lang('quiz');
                    $scoring = score_quiz($row['id']);
                    $ret += array(
                        'q_quiz__dereferenced' => get_translated_text($name),
                        'given_answers' => $scoring[3],
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
        require_lang('quiz');

        switch ($table_name) {
            case 'quizzes':
                require_code('quiz2');
                delete_quiz($row['id']);
                break;

            case 'quiz_entries':
                $GLOBALS['SITE_DB']->query_delete('quiz_entry_answer', array('q_entry' => $row['id']));
                parent::delete($table_name, $row);
                break;

            default:
                parent::delete($table_name, $row);
                break;
        }
    }
}

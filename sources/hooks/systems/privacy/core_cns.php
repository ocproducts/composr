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
 * @package    core_cns
 */

/**
 * Hook class.
 */
class Hook_privacy_core_cns extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        require_lang('cns_privacy');

        return array(
            'cookies' => array(
            ),

            'positive' => array(
                ((get_option('is_on_coppa') == '0') || (get_option('dobs') == '0')) ? null : array(
                    'heading' => do_lang('CHILD_PROTECTION'),
                    'explanation' => do_lang('PRIVACY_EXPLANATION_COPPA', get_option('coppa_age')),
                ),
                array(
                    'heading' => do_lang('COOKIES'),
                    'explanation' => do_lang('PRIVACY_EXPLANATION_COOKIES'),
                ),
                array(
                    'heading' => do_lang('GENERAL'),
                    'explanation' => do_lang('PRIVACY_EXPLANATION_NON_DISCLOSURE'),
                ),
            ),

            'general' => array(
                array(
                    'heading' => do_lang('INFORMATION_DISCLOSURE'),
                    'action' => do_lang('PRIVACY_ACTION_PROFILE_DISCLOSURE'),
                    'reason' => do_lang('PRIVACY_REASON_PROFILE_DISCLOSURE'),
                ),
                array(
                    'heading' => do_lang('INFORMATION_DISCLOSURE'),
                    'action' => do_lang('PRIVACY_ACTION_PRIVATE_TOPICS'),
                    'reason' => do_lang('PRIVACY_REASON_PRIVATE_TOPICS'),
                ),
            ),

            'database_records' => array(
                'f_moderator_logs' => array(
                    'timestamp_field' => 'l_date_and_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('l_by'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'f_member_known_login_ips' => array(
                    'timestamp_field' => 'i_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('i_member_id'),
                    'ip_address_fields' => array('i_ip'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_group_join_log' => array(
                    'timestamp_field' => 'join_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_invites' => array(
                    'timestamp_field' => 'i_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('i_inviter'),
                    'ip_address_fields' => array(),
                    'email_fields' => array('i_email_address'),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'f_warnings' => array(
                    'timestamp_field' => 'w_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('w_member_id', 'w_by'),
                    'ip_address_fields' => array('p_banned_ip'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_members' => array(
                    'timestamp_field' => 'm_join_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('id'),
                    'ip_address_fields' => array('m_ip_address'),
                    'email_fields' => array('m_email_address'),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_posts' => array(
                    'timestamp_field' => 'p_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('p_poster', 'p_intended_solely_for', 'p_last_edit_by'),
                    'ip_address_fields' => array('p_ip_address'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array('p_poster_name_if_guest'),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'f_password_history' => array(
                    'timestamp_field' => 'p_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('p_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_member_custom_fields' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('mf_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise, // Will be deleted properly with member record
                ),
                'f_member_cpf_perms' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_group_members' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('gm_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_groups' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('g_group_leader'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'f_forums' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('f_cache_last_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array('f_cache_last_username'),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'f_topics' => array(
                    'timestamp_field' => 't_cache_first_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('t_pt_from', 't_pt_to', 't_cache_first_member_id', 't_cache_last_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array('t_cache_first_username', 't_cache_last_username'),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'f_special_pt_access' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('s_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_poll_votes' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('pv_member_id'),
                    'ip_address_fields' => array('pv_ip'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'f_read_logs' => array(
                    'timestamp_field' => 'l_time',
                    'retention_days' => intval(get_option('post_read_history_days')),
                    'retention_handle_method' => PRIVACY_METHOD_delete,
                    'member_id_fields' => array('l_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_group_member_timeouts' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_forum_intro_ip' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array(),
                    'ip_address_fields' => array('i_ip'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'f_forum_intro_member' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('i_member_id'),
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
            case 'f_group_join_log':
                if ($row['usergroup_id'] !== null) {
                    $g_name = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_groups', 'g_name', array('id' => $row['usergroup_id']));
                    if ($g_name !== null) {
                        $ret += array(
                            'usergroup_id__dereferenced' => get_translated_text($g_name, $GLOBALS['FORUM_DB']),
                        );
                    }
                }
                break;

            case 'f_warnings':
                $ret += array(
                    'w_member_id__dereferenced' => $GLOBALS['FORUM_DRIVER']->get_username($row['w_member_id']),
                    'w_by__dereferenced' => $GLOBALS['FORUM_DRIVER']->get_username($row['w_by']),
                );
                if ($row['p_silence_from_topic'] !== null) {
                    $ret += array(
                        'p_silence_from_topic' => '?AUTO_LINK',
                    );
                }
                if ($row['p_silence_from_topic'] !== null) {
                    $ret += array(
                        'p_silence_from_forum' => '?AUTO_LINK',
                    );
                }
                break;

            case 'f_members':
                $name = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_groups', 'g_name', array('id' => $row['m_primary_group']));
                if ($name !== null) {
                    $ret += array(
                        'm_primary_group__dereferenced' => get_translated_text($name, $GLOBALS['FORUM_DB']),
                    );
                }
                break;

            case 'f_posts':
                $ret += array(
                    'p_topic_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_topics', 't_cache_first_title', array('id' => $row['p_topic_id'])),
                    'p_cache_forum_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_forums', 'f_name', array('id' => $row['p_cache_forum_id'])),
                );
                break;

            case 'f_member_cpf_perms':
                $ret += array(
                    'field_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_custom_fields', 'cf_name', array('id' => $row['field_id'])),
                );
                break;

            case 'f_group_members':
                $ret += array(
                    'gm_group_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_groups', 'g_name', array('id' => $row['gm_group_id'])),
                );
                break;

            case 'f_forums':
                $ret = null; // We do not need to include this
                break;

            case 'f_topics':
                $ret += array(
                    'f_name__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_forums', 'f_name', array('id' => $row['t_forum_id'])),
                    't_pt_from__dereferenced' => ($row['t_pt_from'] === null) ? null : $GLOBALS['FORUM_DRIVER']->get_username($row['t_pt_from']),
                    't_pt_to__dereferenced' => ($row['t_pt_to'] === null) ? null : $GLOBALS['FORUM_DRIVER']->get_username($row['t_pt_to']),
                    't_poll_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_polls', 'po_question', array('id' => $row['t_poll_id'])),
                );
                break;

            case 'f_special_pt_access':
                $ret += array(
                    's_topic_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_topics', 't_cache_first_title', array('id' => $row['s_topic_id'])),
                );
                break;

            case 'f_poll_votes':
                $ret += array(
                    'pv_poll_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_polls', 'po_question', array('id' => $row['pv_poll_id'])),
                );
                break;

            case 'f_read_logs':
                $ret += array(
                    'l_topic_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_topics', 't_cache_first_title', array('id' => $row['l_topic_id'])),
                );
                break;

            case 'f_group_member_timeouts':
                $ret += array(
                    'group_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_groups', 'g_name', array('id' => $row['group_id'])),
                );
                break;

            case 'f_forum_intro_ip':
                $ret += array(
                    'i_forum_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_forums', 'f_name', array('id' => $row['i_forum_id'])),
                );
                break;

            case 'f_forum_intro_member':
                $ret += array(
                    'i_forum_id__dereferenced' => $GLOBALS['FORUM_DB']->query_select_value_if_there('f_forums', 'f_name', array('id' => $row['i_forum_id'])),
                );
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
        switch ($table_name) {
            case 'f_members':
                require_code('cns_members_action2');
                cns_delete_member($row['id']);
                break;

            case 'f_posts':
                require_code('cns_posts_action3');
                $topic_id = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_posts', 'p_topic_id', array('id' => $row['id']));
                if ($topic_id !== null) {
                    cns_delete_posts_topic($topic_id, array($row['id']), '', false, true);
                }
                break;

            case 'f_groups':
                require_code('cns_groups_action2');
                cns_delete_group($row['id']);
                break;

            case 'f_forums':
                // Deleting not acceptable!
                $this->anonymise($table_name, $row);
                break;

            case 'f_topics':
                require_code('cns_topics_action2');
                cns_delete_topic($row['id'], '', null, false);
                break;

            default:
                $this->delete($table_name, $row);
                break;
        }
    }
}

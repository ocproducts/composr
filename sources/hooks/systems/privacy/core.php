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
 * Hook class.
 */
class Hook_privacy_core extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        $deletion_exemptions = '';
        $deletion_exemptions .= '<ul>';
        $deletion_exemptions .= '<li>' . do_lang('PERSONAL_DATA_DELETION_EXPLANATION_EXEMPTION_logged') . '</li>';
        $deletion_exemptions .= '<li>' . do_lang('PERSONAL_DATA_DELETION_EXPLANATION_EXEMPTION_editorial') . '</li>';
        $deletion_exemptions .= '<li>' . do_lang('PERSONAL_DATA_DELETION_EXPLANATION_EXEMPTION_security') . '</li>';
        if (addon_installed('ecommerce')) {
            $deletion_exemptions .= '<li>' . do_lang('PERSONAL_DATA_DELETION_EXPLANATION_EXEMPTION_transactions') . '</li>';
        }
        $deletion_exemptions .= '</ul>';

        return array(
            'cookies' => array(
                'cms_autosave_*' => array(
                    'reason' => do_lang_tempcode('COOKIE_autosave'),
                ),
                'has_cookies' => array(
                    'reason' => do_lang_tempcode('COOKIE_has_cookies'),
                ),
                'has_js' => (get_option('detect_javascript') == '0') ? null : array(
                    'reason' => do_lang_tempcode('COOKIE_has_js'),
                ),
                'last_visit' => array(
                    'reason' => do_lang_tempcode('COOKIE_last_visit'),
                ),
                get_member_cookie() . ' & ' . get_pass_cookie() => array(
                    'reason' => do_lang_tempcode('COOKIE_automatic_login'),
                ),
                get_member_cookie() . '_invisible' => array(
                    'reason' => do_lang_tempcode('COOKIE_invisible'),
                ),
                get_session_cookie() => array(
                    'reason' => do_lang_tempcode('COOKIE_session'),
                ),
                'tray_*, hide*, og_*' => array(
                    'reason' => do_lang_tempcode('COOKIE_trays'),
                ),
                'use_wysiwyg' => array(
                    'reason' => do_lang_tempcode('COOKIE_use_wysiwyg'),
                ),
                'client_time*' => (get_option('is_on_timezone_detection') == '0') ? null : array(
                    'reason' => do_lang_tempcode('COOKIE_client_time'),
                ),
                'font_size' => array(
                    'reason' => do_lang_tempcode('COOKIE_font_size'),
                ),
                '__ut*, _ga, _gid' => (get_option('google_analytics') == '') ? null : array(
                    'reason' => do_lang_tempcode('COOKIE_ga'),
                ),
            ),

            'positive' => array(
                array(
                    'heading' => do_lang('INFORMATION_STORAGE'),
                    'explanation' => do_lang_tempcode('CORRECTIONS_EXPLANATION'),
                ),
                array(
                    'heading' => do_lang('INFORMATION_STORAGE'),
                    'explanation' => do_lang_tempcode('PERSONAL_DATA_DOWNLOAD_EXPLANATION'),
                ),
                array(
                    'heading' => do_lang('INFORMATION_STORAGE'),
                    'explanation' => do_lang_tempcode('PERSONAL_DATA_DELETION_EXPLANATION', protect_from_escaping($deletion_exemptions)),
                ),
            ),

            'general' => array(
                (get_option('spam_check_level') == 'NEVER') ? null : array(
                    'heading' => do_lang('INFORMATION_TRANSFER'),
                    'action' => do_lang_tempcode('PRIVACY_ACTION_stopforumspam'),
                    'reason' => do_lang_tempcode('PRIVACY_REASON_stopforumspam'),
                ),
                ((get_option('spam_check_level') == 'NEVER') || (get_option('stopforumspam_api_key') == '')) ? null : array(
                    'heading' => do_lang('INFORMATION_TRANSFER'),
                    'action' => do_lang_tempcode('PRIVACY_ACTION_dnsbl'),
                    'reason' => do_lang_tempcode('PRIVACY_REASON_dnsbl'),
                ),
                array(
                    'heading' => do_lang('INFORMATION_STORAGE'),
                    'action' => do_lang_tempcode('PRIVACY_ACTION_metadata'),
                    'reason' => do_lang_tempcode('PRIVACY_REASON_metadata'),
                ),
                array(
                    'heading' => do_lang('INFORMATION_STORAGE'),
                    'action' => do_lang_tempcode('PRIVACY_ACTION_editorial'),
                    'reason' => do_lang_tempcode('PRIVACY_REASON_editorial'),
                ),
                array(
                    'heading' => do_lang('INFORMATION_STORAGE'),
                    'action' => do_lang_tempcode('PRIVACY_ACTION_bans'),
                    'reason' => do_lang_tempcode('PRIVACY_REASON_bans'),
                ),
                array( // We define this here, not in newsletters hook, as webmasters are likely to use newsletters using external software
                    'heading' => do_lang('GENERAL'),
                    'action' => do_lang_tempcode('PRIVACY_ACTION_newsletter', escape_html(get_site_name()), escape_html(get_option('site_scope'))),
                    'reason' => do_lang_tempcode('PRIVACY_REASON_newsletter'),
                ),
                array(
                    'heading' => do_lang('INFORMATION_DISCLOSURE'),
                    'action' => do_lang_tempcode((get_option('is_on_invisibility') == '1') ? 'PRIVACY_ACTION_online_status_invisible' : 'PRIVACY_ACTION_online_status'),
                    'reason' => do_lang_tempcode('PRIVACY_REASON_online_status'),
                ),
                array(
                    'heading' => do_lang('GENERAL'),
                    'action' => do_lang_tempcode('PRIVACY_ACTION_no_dnt'),
                    'reason' => do_lang_tempcode('PRIVACY_REASON_no_dnt'),
                ),
                array(
                    'heading' => do_lang('INFORMATION_TRANSFER'),
                    'action' => do_lang_tempcode('PRIVACY_ACTION_ip_lookup'),
                    'reason' => do_lang_tempcode('PRIVACY_REASON_ip_lookup'),
                ),
                array(
                    'heading' => do_lang('INFORMATION_TRANSFER'),
                    'action' => do_lang_tempcode('PRIVACY_ACTION_web_code'),
                    'reason' => do_lang_tempcode('PRIVACY_REASON_web_code'),
                ),
            ),

            'database_records' => array(
                'email_bounces' => array(
                    'timestamp_field' => 'b_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array(),
                    'ip_address_fields' => array(),
                    'email_fields' => array('b_email_address'),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'actionlogs' => array(
                    'timestamp_field' => 'date_and_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array('ip'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'logged_mail_messages' => array(
                    'timestamp_field' => 'm_date_and_time',
                    'retention_days' => null,//intval(get_option('email_log_store_time')),
                    'retention_handle_method' => PRIVACY_METHOD_leave, // Happens automatically
                    'member_id_fields' => array('m_member_id', 'm_as'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(/*'m_to_email', Not actually a standalone field plus not important due to m_member_id*/'m_from_email', 'm_sender_email'),
                    'additional_anonymise_fields' => array('m_to_name', 'm_from_name'),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'rating' => array(
                    'timestamp_field' => 'rating_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('rating_member'),
                    'ip_address_fields' => array('rating_ip'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'trackbacks' => array(
                    'timestamp_field' => 'trackback_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array(),
                    'ip_address_fields' => array('trackback_ip'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'link_tracker' => array(
                    'timestamp_field' => 'c_date_and_time',
                    'retention_days' => intval(get_option('website_activity_store_time')),
                    'retention_handle_method' => PRIVACY_METHOD_anonymise,
                    'member_id_fields' => array('c_member_id'),
                    'ip_address_fields' => array('c_ip_address'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'failedlogins' => array(
                    'timestamp_field' => 'date_and_time',
                    'retention_days' => intval(get_option('website_activity_store_time')),
                    'retention_handle_method' => PRIVACY_METHOD_anonymise,
                    'member_id_fields' => array(),
                    'ip_address_fields' => array('ip'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'post_tokens' => array(
                    'timestamp_field' => 'generation_time',
                    'retention_days' => intval(ceil(floatval(get_option('csrf_token_expire_new')) / 24.0)),
                    'retention_handle_method' => PRIVACY_METHOD_delete,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array('ip_address'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'sessions' => array(
                    'timestamp_field' => 'last_activity',
                    'retention_days' => intval(ceil(floatval(get_option('session_expiry_time')) / 24.0)),
                    'retention_handle_method' => PRIVACY_METHOD_delete,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array('ip'),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array('cache_username'),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'attachments' => array(
                    'timestamp_field' => 'a_add_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('a_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'staff_tips_dismissed' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('t_member'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'member_tracking' => array(
                    'timestamp_field' => 'mt_time',
                    'retention_days' => intval(ceil(floatval(get_option('users_online_time')) / 24.0)),
                    'retention_handle_method' => PRIVACY_METHOD_delete,
                    'member_id_fields' => array('mt_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array('mt_cache_username'),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'member_zone_access' => array(
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
                'member_page_access' => array(
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
                'member_category_access' => array(
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
                'autosave' => array(
                    'timestamp_field' => 'a_time',
                    'retention_days' => 1,
                    'retention_handle_method' => PRIVACY_METHOD_delete,
                    'member_id_fields' => array('a_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'comcode_pages' => array(
                    'timestamp_field' => 'p_add_date',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('p_submitter'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'incoming_uploads' => array(
                    'timestamp_field' => 'i_date_and_time',
                    'retention_days' => 2,
                    'retention_handle_method' => PRIVACY_METHOD_delete,
                    'member_id_fields' => array('i_submitter'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'cron_caching_requests' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('c_member'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'cache' => array(
                    'timestamp_field' => 'date_and_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('the_member'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'notifications_enabled' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('l_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'digestives_tin' => array(
                    'timestamp_field' => 'd_date_and_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('d_from_member_id', 'd_to_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'digestives_consumed' => array(
                    'timestamp_field' => 'c_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('c_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'task_queue' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('t_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
                'translate' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('source_user'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise_only,
                ),
                'edit_pings' => array(
                    'timestamp_field' => 'the_time',
                    'retention_days' => 1,
                    'retention_handle_method' => PRIVACY_METHOD_delete,
                    'member_id_fields' => array('the_member'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
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
            case 'rating':
                require_code('content');
                list($title) = content_get_details($row['rating_for_type'], $row['rating_for_id']);
                $ret += array(
                    'content_title__dereferenced' => $title,
                );
                break;

            case 'trackbacks':
                require_code('content');
                list($title) = content_get_details($row['trackback_for_type'], $row['trackback_for_id']);
                $ret += array(
                    'content_title__dereferenced' => $title,
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
            case 'attachments':
                require_code('attachments3');
                _delete_attachment($row['id'], $GLOBALS['SITE_DB']);
                break;

            case 'comcode_pages':
                require_code('zones3');
                delete_cms_page($row['the_zone'], $row['the_page'], 'comcode_custom', false);
                break;

            case 'translate':
                // Deleting not acceptable!
                $this->anonymise($table_name, $row);
                break;

            default:
                $this->delete($table_name, $row);
                break;
        }
    }
}

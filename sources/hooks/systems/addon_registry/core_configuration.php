<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_configuration
 */

/**
 * Hook class.
 */
class Hook_addon_registry_core_configuration
{
    /**
     * Get a list of file permissions to set.
     *
     * @param  boolean $runtime Whether to include wildcards represented runtime-created chmoddable files
     * @return array File permissions to set
     */
    public function get_chmod_array($runtime = false)
    {
        return array();
    }

    /**
     * Get the version of Composr this addon is for.
     *
     * @return float Version number
     */
    public function get_version()
    {
        return cms_version_number();
    }

    /**
     * Get the description of the addon.
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'Set configuration options.';
    }

    /**
     * Get a list of tutorials that apply to this addon.
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array(
            'tut_configuration',
            'tut_adv_configuration',
            'tut_moving',
        );
    }

    /**
     * Get a mapping of dependency types.
     *
     * @return array File permissions to set
     */
    public function get_dependencies()
    {
        return array(
            'requires' => array(),
            'recommends' => array(),
            'conflicts_with' => array(),
        );
    }

    /**
     * Explicitly say which icon should be used.
     *
     * @return URLPATH Icon
     */
    public function get_default_icon()
    {
        return 'themes/default/images/icons/48x48/menu/adminzone/setup/config/config.svg';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'themes/default/images/icons/48x48/menu/adminzone/setup/config/config.svg',
            'themes/default/images/icons/48x48/menu/adminzone/setup/oauth.svg',
            'sources/hooks/systems/sitemap/config_category.php',
            'sources/hooks/systems/config/mobile_pages.php',
            'sources/hooks/systems/config/zone_editor_enabled.php',
            'sources/hooks/systems/config/enable_edit_page_include_buttons.php',
            'sources/hooks/systems/config/enable_edit_page_panel_buttons.php',
            'sources/hooks/systems/config/enable_menu_editor_buttons.php',
            'sources/hooks/systems/config/supports_wide.php',
            'sources/hooks/systems/config/csp_enabled.php',
            'sources/hooks/systems/config/csp_exceptions.php',
            'sources/hooks/systems/config/csp_whitelisted_plugins.php',
            'sources/hooks/systems/config/csp_allowed_iframe_ancestors.php',
            'sources/hooks/systems/config/csp_allowed_iframe_descendants.php',
            'sources/hooks/systems/config/csp_allow_eval_js.php',
            'sources/hooks/systems/config/csp_allow_dyn_js.php',
            'sources/hooks/systems/config/csp_allow_insecure_resources.php',
            'sources/hooks/systems/config/csp_report_issues.php',
            'sources/hooks/systems/config/trusted_sites_1.php',
            'sources/hooks/systems/config/trusted_sites_2.php',
            'sources/hooks/systems/config/page_after_login.php',
            'sources/hooks/systems/config/csrf_token_expire_fresh.php',
            'sources/hooks/systems/config/csrf_token_expire_new.php',
            'sources/hooks/systems/config/header_menu_call_string.php',
            'sources/hooks/systems/config/max_moniker_length.php',
            'sources/hooks/systems/config/enable_seo_fields.php',
            'sources/hooks/systems/config/enable_staff_notes.php',
            'sources/hooks/systems/config/filetype_icons.php',
            'sources/hooks/systems/config/wysiwyg_font_units.php',
            'sources/hooks/systems/config/force_local_temp_dir.php',
            'sources/hooks/systems/config/general_safety_listing_limit.php',
            'sources/hooks/systems/config/hack_ban_threshold.php',
            'sources/hooks/systems/config/honeypot_phrase.php',
            'sources/hooks/systems/config/honeypot_url.php',
            'sources/hooks/systems/config/implied_spammer_confidence.php',
            'sources/hooks/systems/config/moz_access_id.php',
            'sources/hooks/systems/config/moz_secret_key.php',
            'sources/hooks/systems/config/moz_paid.php',
            'sources/hooks/systems/config/google_apis_client_id.php',
            'sources/hooks/systems/config/google_apis_client_secret.php',
            'sources/hooks/systems/config/google_apis_api_key.php',
            'adminzone/pages/modules/admin_oauth.php',
            'sources/oauth.php',
            'sources/hooks/systems/oauth/.htaccess',
            'sources/hooks/systems/oauth/google_analytics.php',
            'sources/hooks/systems/oauth/google_search_console.php',
            'sources/hooks/systems/oauth/index.html',
            'lang/EN/oauth.ini',
            'themes/default/templates/OAUTH_SCREEN.tpl',
            'sources/hooks/systems/config/edit_under.php',
            'sources/hooks/systems/config/enable_animations.php',
            'sources/hooks/systems/config/breadcrumb_crop_length.php',
            'sources/hooks/systems/config/brute_force_instant_ban.php',
            'sources/hooks/systems/config/brute_force_login_minutes.php',
            'sources/hooks/systems/config/brute_force_threshold.php',
            'sources/hooks/systems/config/call_home.php',
            'sources/hooks/systems/config/cleanup_files.php',
            'sources/hooks/systems/config/jpeg_quality.php',
            'sources/hooks/systems/config/mail_queue.php',
            'sources/hooks/systems/config/mail_queue_debug.php',
            'sources/hooks/systems/config/modal_user.php',
            'sources/hooks/systems/config/password_cookies.php',
            'sources/hooks/systems/config/proxy.php',
            'sources/hooks/systems/config/proxy_password.php',
            'sources/hooks/systems/config/proxy_port.php',
            'sources/hooks/systems/config/proxy_user.php',
            'sources/hooks/systems/config/session_prudence.php',
            'sources/hooks/systems/config/tornevall_api_password.php',
            'sources/hooks/systems/config/tornevall_api_username.php',
            'sources/hooks/systems/config/message_received_emails.php',
            'sources/hooks/systems/config/use_true_from.php',
            'sources/hooks/systems/config/email_log_days.php',
            'sources/hooks/systems/config/block_top_login.php',
            'sources/hooks/systems/config/block_top_personal_stats.php',
            'sources/hooks/systems/config/fixed_width.php',
            'sources/hooks/systems/config/single_public_zone.php',
            'sources/hooks/systems/config/url_monikers_enabled.php',
            'sources/hooks/systems/config/tasks_background.php',
            'sources/hooks/systems/config/moniker_transliteration.php',
            'sources/hooks/systems/config/vote_member_ip_restrict.php',
            'sources/hooks/systems/config/spam_approval_threshold.php',
            'sources/hooks/systems/config/spam_ban_threshold.php',
            'sources/hooks/systems/config/spam_blackhole_detection.php',
            'sources/hooks/systems/config/forced_preview_option.php',
            'sources/hooks/systems/config/default_preview_guests.php',
            'sources/hooks/systems/config/spam_block_lists.php',
            'sources/hooks/systems/config/spam_block_threshold.php',
            'sources/hooks/systems/config/spam_cache_time.php',
            'sources/hooks/systems/config/spam_check_exclusions.php',
            'sources/hooks/systems/config/spam_check_level.php',
            'sources/hooks/systems/config/spam_check_usernames.php',
            'sources/hooks/systems/config/spam_stale_threshold.php',
            'sources/hooks/systems/config/stopforumspam_api_key.php',
            'sources/hooks/systems/config/login_error_secrecy.php',
            'sources/hooks/systems/config/cdn.php',
            'sources/hooks/systems/config/allow_theme_image_selector.php',
            'sources/hooks/systems/config/maintenance_script_htaccess.php',
            'sources/hooks/systems/config/spam_heuristic_autonomous.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_alien_code.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_autonomous.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_country.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_frequency.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_guest.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_header_absence.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_join_closeness.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_keywords.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_links.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_pasting.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_posting_speed.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_repetition.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_user_agents.php',
            'sources/hooks/systems/config/spam_heuristic_country.php',
            'sources/hooks/systems/config/spam_heuristic_frequency.php',
            'sources/hooks/systems/config/spam_heuristic_frequency_threshold.php',
            'sources/hooks/systems/config/spam_heuristic_join_closeness.php',
            'sources/hooks/systems/config/spam_heuristic_keywords.php',
            'sources/hooks/systems/config/spam_heuristic_pasting.php',
            'sources/hooks/systems/config/spam_heuristic_posting_speed.php',
            'sources/hooks/systems/config/spam_heuristic_repetition.php',
            'sources/hooks/systems/config/spam_heuristic_user_agents.php',
            'sources/hooks/systems/config/spam_heuristic_confidence_missing_js.php',
            'sources/hooks/systems/config/infinite_scrolling.php',
            'sources/hooks/systems/config/check_broken_urls.php',
            'sources/hooks/systems/config/google_analytics.php',
            'sources/hooks/systems/config/show_personal_sub_links.php',
            'sources/hooks/systems/config/show_content_tagging.php',
            'sources/hooks/systems/config/show_content_tagging_inline.php',
            'sources/hooks/systems/config/show_screen_actions.php',
            'sources/hooks/systems/config/allow_audio_videos.php',
            'sources/hooks/systems/config/allow_ext_images.php',
            'sources/hooks/systems/config/anti_leech.php',
            'sources/hooks/systems/config/auto_submit_sitemap.php',
            'sources/hooks/systems/config/automatic_meta_extraction.php',
            'sources/hooks/systems/config/bcc.php',
            'sources/hooks/systems/config/bottom_show_feedback_link.php',
            'sources/hooks/systems/config/autogrow.php',
            'sources/hooks/systems/config/bottom_show_rules_link.php',
            'sources/hooks/systems/config/bottom_show_privacy_link.php',
            'sources/hooks/systems/config/bottom_show_sitemap_button.php',
            'sources/hooks/systems/config/bottom_show_top_button.php',
            'sources/hooks/systems/config/dkim_private_key.php',
            'sources/hooks/systems/config/dkim_selector.php',
            'sources/hooks/systems/config/crypt_ratchet.php',
            'sources/hooks/systems/config/cc_address.php',
            'sources/hooks/systems/config/security_token_exceptions.php',
            'sources/hooks/systems/config/closed.php',
            'sources/hooks/systems/config/comment_text.php',
            'sources/hooks/systems/config/comments_forum_name.php',
            'sources/hooks/systems/config/copyright.php',
            'sources/hooks/systems/config/deeper_admin_breadcrumbs.php',
            'sources/hooks/systems/config/description.php',
            'sources/hooks/systems/config/detect_lang_browser.php',
            'sources/hooks/systems/config/detect_lang_forum.php',
            'sources/hooks/systems/config/error_handling_database_strict.php',
            'sources/hooks/systems/config/error_handling_deprecated.php',
            'sources/hooks/systems/config/error_handling_errors.php',
            'sources/hooks/systems/config/error_handling_notices.php',
            'sources/hooks/systems/config/error_handling_warnings.php',
            'sources/hooks/systems/config/eager_wysiwyg.php',
            'sources/hooks/systems/config/enable_keyword_density_check.php',
            'sources/hooks/systems/config/enable_markup_webstandards.php',
            'sources/hooks/systems/config/enable_previews.php',
            'sources/hooks/systems/config/enable_spell_check.php',
            'sources/hooks/systems/config/enveloper_override.php',
            'sources/hooks/systems/config/force_meta_refresh.php',
            'sources/hooks/systems/config/forum_in_portal.php',
            'sources/hooks/systems/config/forum_show_personal_stats_posts.php',
            'sources/hooks/systems/config/forum_show_personal_stats_topics.php',
            'sources/hooks/systems/config/global_donext_icons.php',
            'sources/hooks/systems/config/gzip_output.php',
            'sources/hooks/systems/config/has_low_memory_limit.php',
            'sources/hooks/systems/config/url_scheme.php',
            'sources/hooks/systems/config/ip_forwarding.php',
            'sources/hooks/systems/config/ip_strict_for_sessions.php',
            'sources/hooks/systems/config/is_on_emoticon_choosers.php',
            'sources/hooks/systems/config/is_on_strong_forum_tie.php',
            'sources/hooks/systems/config/keywords.php',
            'sources/hooks/systems/config/dynamic_firewall.php',
            'sources/hooks/systems/config/google_geocode_api_key.php',
            'sources/hooks/systems/config/main_forum_name.php',
            'sources/hooks/systems/config/max_download_size.php',
            'sources/hooks/systems/config/maximum_users.php',
            'sources/hooks/systems/config/stats_when_closed.php',
            'sources/hooks/systems/config/cpf_enable_street_address.php',
            'sources/hooks/systems/config/cpf_enable_city.php',
            'sources/hooks/systems/config/cpf_enable_country.php',
            'sources/hooks/systems/config/cpf_enable_name.php',
            'sources/hooks/systems/config/cpf_enable_phone.php',
            'sources/hooks/systems/config/cpf_enable_post_code.php',
            'sources/hooks/systems/config/cpf_enable_county.php',
            'sources/hooks/systems/config/cpf_enable_state.php',
            'sources/hooks/systems/config/background_template_compilation.php',
            'sources/hooks/systems/config/filter_regions.php',
            'sources/hooks/systems/config/cns_show_profile_link.php',
            'sources/hooks/systems/config/show_avatar.php',
            'sources/hooks/systems/config/show_conceded_mode_link.php',
            'sources/hooks/systems/config/show_personal_adminzone_link.php',
            'sources/hooks/systems/config/show_personal_last_visit.php',
            'sources/hooks/systems/config/show_personal_usergroup.php',
            'sources/hooks/systems/config/show_staff_page_actions.php',
            'sources/hooks/systems/config/show_su.php',
            'sources/hooks/systems/config/root_zone_login_theme.php',
            'sources/hooks/systems/config/send_error_emails_ocproducts.php',
            'sources/hooks/systems/config/session_expiry_time.php',
            'sources/hooks/systems/config/show_docs.php',
            'sources/hooks/systems/config/keyset_pagination.php',
            'sources/hooks/systems/config/show_inline_stats.php',
            'sources/hooks/systems/config/show_post_validation.php',
            'sources/hooks/systems/config/simplified_donext.php',
            'sources/hooks/systems/config/site_closed.php',
            'sources/hooks/systems/config/site_name.php',
            'sources/hooks/systems/config/site_scope.php',
            'sources/hooks/systems/config/smtp_from_address.php',
            'sources/hooks/systems/config/smtp_sockets_host.php',
            'sources/hooks/systems/config/smtp_sockets_password.php',
            'sources/hooks/systems/config/smtp_sockets_port.php',
            'sources/hooks/systems/config/smtp_sockets_use.php',
            'sources/hooks/systems/config/smtp_sockets_username.php',
            'sources/hooks/systems/config/ssw.php',
            'sources/hooks/systems/config/yeehaw.php',
            'sources/hooks/systems/config/cookie_notice.php',
            'sources/hooks/systems/config/staff_address.php',
            'sources/hooks/systems/config/thumb_width.php',
            'sources/hooks/systems/config/unzip_cmd.php',
            'sources/hooks/systems/config/unzip_dir.php',
            'sources/hooks/systems/config/use_contextual_dates.php',
            'sources/hooks/systems/config/user_postsize_errors.php',
            'sources/hooks/systems/config/users_online_time.php',
            'sources/hooks/systems/config/valid_images.php',
            'sources/hooks/systems/config/valid_videos.php',
            'sources/hooks/systems/config/valid_audios.php',
            'sources/hooks/systems/config/valid_types.php',
            'sources/hooks/systems/config/website_email.php',
            'sources/hooks/systems/config/long_google_cookies.php',
            'sources/hooks/systems/config/detect_javascript.php',
            'sources/hooks/systems/config/welcome_message.php',
            'sources/hooks/systems/config/remember_me_by_default.php',
            'sources/hooks/systems/config/mobile_support.php',
            'sources/hooks/systems/config/complex_uploader.php',
            'sources/hooks/systems/config/complex_lists.php',
            'sources/hooks/systems/config/wysiwyg.php',
            'sources/hooks/systems/config/editarea.php',
            'sources/hooks/systems/config/autoban.php',
            'sources/hooks/systems/config/grow_template_meta_tree.php',
            'sources/hooks/systems/config/js_overlays.php',
            'sources/hooks/systems/config/likes.php',
            'sources/hooks/systems/config/tree_lists.php',
            'sources/hooks/systems/config/lax_comcode.php',
            'sources/hooks/systems/config/output_streaming.php',
            'sources/hooks/systems/config/imap_folder.php',
            'sources/hooks/systems/config/imap_host.php',
            'sources/hooks/systems/config/imap_password.php',
            'sources/hooks/systems/config/imap_port.php',
            'sources/hooks/systems/config/imap_username.php',
            'sources/hooks/systems/config/fractional_editing.php',
            'sources/hooks/systems/config/site_message.php',
            'sources/hooks/systems/config/site_message_end_datetime.php',
            'sources/hooks/systems/config/site_message_start_datetime.php',
            'sources/hooks/systems/config/site_message_status_level.php',
            'sources/hooks/systems/config/site_message_usergroup_select.php',
            'sources/hooks/systems/addon_registry/core_configuration.php',
            'themes/default/templates/CONFIG_CATEGORY_SCREEN.tpl',
            'adminzone/pages/modules/admin_config.php',
            'lang/EN/config.ini',
            'sources/hooks/systems/config/.htaccess',
            'sources_custom/hooks/systems/config/.htaccess',
            'sources/hooks/systems/config/index.html',
            'sources_custom/hooks/systems/config/index.html',
            'themes/default/templates/XML_CONFIG_SCREEN.tpl',
            'themes/default/javascript/core_configuration.js',
        );
    }

    /**
     * Get mapping between template names and the method of this class that can render a preview of them.
     *
     * @return array The mapping
     */
    public function tpl_previews()
    {
        return array(
            'templates/CONFIG_CATEGORY_SCREEN.tpl' => 'administrative__config_category_screen',
            'templates/XML_CONFIG_SCREEN.tpl' => 'administrative__xml_config_screen',
            'templates/OAUTH_SCREEN.tpl' => 'administrative__oauth_screen',
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declaritive.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__administrative__config_category_screen()
    {
        $groups = array();

        foreach (placeholder_array() as $k => $group) {
            $groups[] = array(
                'GROUP_DESCRIPTION' => lorem_word(),
                'GROUP_NAME' => $group,
                'GROUP' => placeholder_fields(),
                'GROUP_TITLE' => 'ID' . strval($k),
            );
        }

        return array(
            lorem_globalise(do_lorem_template('CONFIG_CATEGORY_SCREEN', array(
                'CATEGORY_DESCRIPTION' => lorem_word_2(),
                '_GROUPS' => placeholder_array(),
                'PING_URL' => placeholder_url(),
                'WARNING_DETAILS' => '',
                'TITLE' => lorem_title(),
                'URL' => placeholder_url(),
                'GROUPS' => $groups,
                'SUBMIT_ICON' => 'buttons--save',
                'SUBMIT_NAME' => lorem_word(),
            )), null, '', true)
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declaritive.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__administrative__xml_config_screen()
    {
        return array(
            lorem_globalise(do_lorem_template('XML_CONFIG_SCREEN', array(
                'XML' => '<test />',
                'POST_URL' => placeholder_url(),
                'TITLE' => lorem_title(),
            )), null, '', true)
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declaritive.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__administrative__oauth_screen()
    {
        $services = array();

        $services[] = array(
            'LABEL' => lorem_phrase(),
            'PROTOCOL' => lorem_word(),
            'AVAILABLE' => true,
            'CONFIGURED' => true,
            'CONFIG_URL' => placeholder_url(),
            'CONNECTED' => true,
            'CONNECT_URL' => placeholder_url(),
            'CLIENT_ID' => lorem_word(),
            'CLIENT_SECRET' => lorem_word(),
            'API_KEY' => null,
            'REFRESH_TOKEN' => lorem_word(),
        );

        return array(
            lorem_globalise(do_lorem_template('OAUTH_SCREEN', array(
                'TITLE' => lorem_title(),
                'SERVICES' => $services,
            )), null, '', true)
        );
    }
}

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
 * @package    core_cns
 */

/**
 * Hook class.
 */
class Hook_profiles_tabs_about
{
    /**
     * Find whether this hook is active.
     *
     * @param  MEMBER $member_id_of The ID of the member who is being viewed
     * @param  MEMBER $member_id_viewing The ID of the member who is doing the viewing
     * @return boolean Whether this hook is active
     */
    public function is_active($member_id_of, $member_id_viewing)
    {
        return true;
    }

    /**
     * Render function for profile tab hooks.
     *
     * @param  MEMBER $member_id_of The ID of the member who is being viewed
     * @param  MEMBER $member_id_viewing The ID of the member who is doing the viewing
     * @param  boolean $leave_to_ajax_if_possible Whether to leave the tab contents NULL, if tis hook supports it, so that AJAX can load it later
     * @return array A tuple: The tab title, the tab contents, the suggested tab order, the icon
     */
    public function render_tab($member_id_of, $member_id_viewing, $leave_to_ajax_if_possible = false)
    {
        $title = do_lang_tempcode('PROFILE');

        $order = 10;

        if (!$GLOBALS['FORUM_DB']->table_is_locked('f_members')) {
            $GLOBALS['FORUM_DB']->query('UPDATE ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_members SET m_profile_views=m_profile_views+1 WHERE id=' . strval($member_id_of), 1);
        }

        require_code('cns_general');
        $need = array(
            'custom_fields',
            'username',
            'photo',
            'photo_thumb',
            'avatar',
            'most_active_forum',
            'time_for_them',
            'timezone',
            'timezone_raw',
            'submit_days_ago',
            'last_submit_time',
            'last_visit_time',
            'online_now',
            'banned',
            'user_agent',
            'operating_system',
            'dob_label',
            'dob',
            'ip_address',
            'posts_details',
            'posts',
            'points',
            'join_date',
            'signature',
            'on_probation_until',
            'primary_group',
            'secondary_groups_named',
            'email_address',
        );
        $member_info = cns_read_in_member_profile($member_id_of, $need, true);

        // Things staff can do with this user
        $modules = array();
        if ((has_privilege($member_id_viewing, 'warn_members')) && (has_actual_page_access($member_id_viewing, 'warnings')) && (addon_installed('cns_warnings'))) {
            $redir_url = get_self_url(true);
            $modules[] = array('audit', do_lang_tempcode('WARN_MEMBER'), build_url(array('page' => 'warnings', 'type' => 'add', 'member_id' => $member_id_of, 'redirect' => protect_url_parameter($redir_url)), get_module_zone('warnings')), 'links/warning_add');
            $modules[] = array('audit', do_lang_tempcode('PUNITIVE_HISTORY'), build_url(array('page' => 'warnings', 'type' => 'history', 'id' => $member_id_of), get_module_zone('warnings')), 'menu/social/warnings');
        }
        if ((addon_installed('actionlog')) && (has_privilege($member_id_viewing, 'view_revisions')) && (has_actual_page_access($member_id_viewing, 'admin_revisions'))) {
            $modules[] = (!addon_installed('cns_forum')) ? null : array('audit', do_lang_tempcode('actionlog:REVISIONS'), build_url(array('page' => 'admin_revisions', 'type' => 'browse', 'username' => $member_info['username']), get_module_zone('admin_revisions')), 'admin/revisions');
        }
        if ((addon_installed('securitylogging')) && (has_actual_page_access($member_id_viewing, 'admin_lookup'))) {
            require_lang('lookup');
            $modules[] = array('audit', do_lang_tempcode('INVESTIGATE_USER'), build_url(array('page' => 'admin_lookup', 'param' => $member_id_of), get_module_zone('admin_lookup')), 'menu/adminzone/tools/users/investigate_user');
        }
        if (has_actual_page_access($member_id_viewing, 'admin_security')) {
            require_lang('security');
            $modules[] = array('audit', do_lang_tempcode('SECURITY_LOG'), build_url(array('page' => 'admin_security', 'member_id' => $member_id_of), get_module_zone('admin_security')), 'menu/adminzone/audit/security_log');
        }
        if (addon_installed('actionlog')) {
            if (has_actual_page_access($member_id_viewing, 'admin_actionlog')) {
                require_lang('actionlog');
                $modules[] = array('audit', do_lang_tempcode('VIEW_ACTIONLOGS'), build_url(array('page' => 'admin_actionlog', 'type' => 'list', 'id' => $member_id_of), get_module_zone('admin_actionlog')), 'menu/adminzone/audit/actionlog');
            }
        }
        if ((has_privilege($member_id_viewing, 'assume_any_member')) && (get_member() != $member_id_of)) {
            $modules[] = array('views', do_lang_tempcode('MASQUERADE_AS_MEMBER'), build_url(array('page' => '', 'keep_su' => $member_info['username']), ''), 'menu/site_meta/user_actions/login');
        }
        if ((has_actual_page_access($member_id_viewing, 'search')) && (addon_installed('search'))) {
            $modules[] = array('content', do_lang_tempcode('SEARCH'), build_url(array('page' => 'search', 'type' => 'results', 'author' => $member_info['username']), get_module_zone('search')), 'buttons/search', 'search');
        }
        if (addon_installed('authors')) {
            $author = $GLOBALS['SITE_DB']->query_value_if_there('SELECT author FROM ' . get_table_prefix() . 'authors WHERE (member_id=' . strval($member_id_of) . ') OR (member_id IS NULL AND ' . db_string_equal_to('author', $member_info['username']) . ')');
            if ((has_actual_page_access($member_id_viewing, 'authors')) && ($author !== null)) {
                $modules[] = array('content', do_lang_tempcode('AUTHOR'), build_url(array('page' => 'authors', 'type' => 'browse', 'id' => $author), get_module_zone('authors')), 'menu/rich_content/authors', 'me');
            }
        }
        require_code('cns_members2');
        if ((!is_guest()) && (cns_may_whisper($member_id_of)) && (has_actual_page_access($member_id_viewing, 'topics')) && (cns_may_make_private_topic()) && ($member_id_viewing != $member_id_of)) {
            $modules[] = (!addon_installed('cns_forum')) ? null : array('contact', do_lang_tempcode('ADD_PRIVATE_TOPIC'), build_url(array('page' => 'topics', 'type' => 'new_pt', 'id' => $member_id_of), get_module_zone('topics')), 'buttons/send', 'reply');
        }
        $extra_sections = array();
        $extra_info_details = array();
        $extra_tracking_details = array();
        $hooks = find_all_hook_obs('modules', 'members', 'Hook_members_');
        foreach ($hooks as $object) {
            if (method_exists($object, 'run')) {
                $hook_result = $object->run($member_id_of);
                $modules = array_merge($modules, $hook_result);
            }
            if (method_exists($object, 'get_info_details')) {
                $hook_result = $object->get_info_details($member_id_of);
                $extra_info_details = array_merge($extra_info_details, $hook_result);
            }
            if (method_exists($object, 'get_tracking_details')) {
                $hook_result = $object->get_tracking_details($member_id_of);
                $extra_tracking_details = array_merge($extra_tracking_details, $hook_result);
            }
            if (method_exists($object, 'get_sections')) {
                $hook_result = $object->get_sections($member_id_of);
                $extra_sections = array_merge($extra_sections, $hook_result);
            }
        }
        if (addon_installed('cns_contact_member')) {
            if ((($GLOBALS['FORUM_DRIVER']->get_member_row_field($member_id_of, 'm_allow_emails') == 1) || (get_option('member_email_receipt_configurability') == '0')) && ($GLOBALS['FORUM_DRIVER']->get_member_row_field($member_id_of, 'm_email_address') != '') && (!is_guest($member_id_of)) && (has_actual_page_access($member_id_viewing, 'contact_member')) && ($member_id_viewing != $member_id_of)) {
                $redirect = get_self_url(true);
                $modules[] = array('contact', do_lang_tempcode('_EMAIL_MEMBER'), build_url(array('page' => 'contact_member', 'redirect' => protect_url_parameter($redirect), 'id' => $member_id_of), get_module_zone('contact_member')), 'links/contact_member', 'reply nofollow');
            }
        }
        require_lang('menus');
        $sections = array('contact' => do_lang_tempcode('CONTACT'), 'profile' => do_lang_tempcode('EDIT_PROFILE'), 'views' => do_lang_tempcode('ACCOUNT'), 'audit' => do_lang_tempcode('AUDIT'), 'content' => do_lang_tempcode('CONTENT'));
        $actions = array();
        sort_maps_by($modules, 1);
        foreach ($sections as $section_code => $section_title) {
            $links = new Tempcode();

            foreach ($modules as $mi => $module) {
                if (count($module) == 4) {
                    list($_section_code, $lang, $url, $icon) = $module;
                    $rel = null;
                } else {
                    list($_section_code, $lang, $url, $icon, $rel) = $module;
                }

                if ($section_code == $_section_code) {
                    $links->attach(do_template('CNS_MEMBER_ACTION', array(
                        '_GUID' => '67b2a640a368c6f53f1b1fa10f922fd0',
                        'ID' => strval($member_id_of),
                        'URL' => $url,
                        'LANG' => $lang,
                        'REL' => $rel,
                        'ICON' => $icon,
                    )));

                    unset($modules[$mi]);
                }
            }
            $actions[$section_code] = $links;
        }

        // Custom fields
        $custom_fields = array();
        $custom_fields_sections = array();
        require_code('encryption');
        $value = null;
        $fields_map = array();
        foreach ($member_info['custom_fields'] as $name => $_value) {
            $value = $_value['RAW'];
            $rendered_value = $_value['RENDERED'];

            $encrypted_value = '';
            if (is_data_encrypted($value)) {
                $encrypted_value = remove_magic_encryption_marker($value);
            } elseif (is_integer($value)) {
                $value = strval($value);
            } elseif (is_float($value)) {
                $value = float_to_raw_string($value, 30);
            }

            if ((get_option('show_empty_cpfs') == '1') || (((!is_object($value)) && ($value != '')) || ((is_object($value)) && (!$value->is_empty())))) {
                $custom_field = array(
                    'RAW_VALUE' => $value,
                    'VALUE' => $rendered_value,
                    'ENCRYPTED_VALUE' => $encrypted_value,
                    'FIELD_ID' => $_value['FIELD_ID'],
                    'FIELD_TYPE' => $_value['TYPE'],
                    'EDITABILITY' => $_value['EDITABILITY'],
                    'EDIT_TYPE' => $_value['EDIT_TYPE'],
                );

                if (strpos($name, ': ') !== false) {
                    $parts = explode(': ', $name, 2);
                    if (!isset($custom_fields_sections[$parts[0]])) {
                        $custom_fields_sections[$parts[0]] = array('CUSTOM_FIELDS_SECTION' => array());
                    }

                    $custom_field['NAME'] = $parts[1];

                    $custom_fields_sections[$parts[0]]['CUSTOM_FIELDS_SECTION'][] = $custom_field;
                } else {
                    $custom_field['NAME'] = $name;

                    $custom_fields[] = $custom_field;
                }

                if ($name == do_lang('KEYWORDS')) {
                    $GLOBALS['SEO_KEYWORDS'] = is_object($value) ? $value->evaluate() : $value;
                }
                if ($name == do_lang('DESCRIPTION')) {
                    $GLOBALS['SEO_DESCRIPTION'] = is_object($value) ? $value->evaluate() : $value;
                }
            }

            $field_codename = strtoupper(trim(preg_replace('#[^\w]+#', '_', $name), '_'));
            $fields_map['FIELD__' . $field_codename . '__RENDERED'] = $rendered_value;
            $fields_map['FIELD__' . $field_codename . '__RAW'] = $value;
        }

        // Look up member's clubs
        $clubs = array();
        if (addon_installed('cns_clubs')) {
            $club_ids = $GLOBALS['FORUM_DRIVER']->get_members_groups($member_id_of, true);
            $club_rows = list_to_map('id', $GLOBALS['FORUM_DB']->query_select('f_groups', array('*'), array('g_is_private_club' => 1), '', 200));
            if (count($club_rows) == 200) {
                $club_rows = null;
            }
            foreach ($club_ids as $club_id) {
                if ($club_rows === null) {
                    $club_rows = list_to_map('id', $GLOBALS['FORUM_DB']->query_select('f_groups', array('*'), array('g_is_private_club' => 1, 'id' => $club_id), '', 200));
                    if (!array_key_exists($club_id, $club_rows)) {
                        continue;
                    }
                    $club_row = $club_rows[$club_id];
                    $club_rows = null;
                } else {
                    if (!array_key_exists($club_id, $club_rows)) {
                        continue;
                    }
                    $club_row = $club_rows[$club_id];
                }

                $club_name = get_translated_text($club_row['g_name'], $GLOBALS['FORUM_DB']);
                $club_forum = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_forums', 'id', array($GLOBALS['FORUM_DB']->translate_field_ref('f_description') => do_lang('FORUM_FOR_CLUB', $club_name)));

                $clubs[] = array(
                    'CLUB_NAME' => $club_name,
                    'CLUB_ID' => strval($club_row['id']),
                    'CLUB_FORUM' => ($club_forum === null) ? '' : strval($club_forum),
                );
            }
        }

        // Render

        $a = (isset($member_info['avatar'])) ? cns_get_member_best_group_property($member_id_of, 'max_avatar_width') : 0;
        $b = (isset($member_info['photo_thumb'])) ? intval(get_option('thumb_width')) : 0;
        $right_margin = (max($a, $b) == 0) ? 'auto' : (strval(max($a, $b) + 6) . 'px');

        $content = do_template('CNS_MEMBER_PROFILE_ABOUT', array(
            '_GUID' => 'fodfjdsfjsdljfdls',
            'MEMBER_ID' => strval($member_id_of),
            'USERNAME' => $member_info['username'],
            'RIGHT_MARGIN' => $right_margin,
            'AVATAR_WIDTH' => strval($a) . 'px',
            'PHOTO_WIDTH' => strval($b) . 'px',
            'PHOTO_URL' => isset($member_info['photo']) ? $member_info['photo'] : '',
            'PHOTO_THUMB_URL' => isset($member_info['photo_thumb']) ? $member_info['photo_thumb'] : '',
            'AVATAR_URL' => isset($member_info['avatar']) ? $member_info['avatar'] : '',
            'CUSTOM_FIELDS_SECTIONS' => $custom_fields_sections,
            'CUSTOM_FIELDS' => $custom_fields,
            'ACTIONS_contact' => $actions['contact'],
            'ACTIONS_profile' => $actions['profile'],
            'ACTIONS_views' => $actions['views'],
            'ACTIONS_audit' => $actions['audit'],
            'ACTIONS_content' => $actions['content'],
            'VIEW_PROFILES' => $member_id_viewing == $member_id_of || has_privilege($member_id_viewing, 'view_profiles'),
            'EXTRA_INFO_DETAILS' => $extra_info_details,
            'EXTRA_TRACKING_DETAILS' => $extra_tracking_details,
            'EXTRA_SECTIONS' => $extra_sections,
            'CLUBS' => $clubs,
            'MOST_ACTIVE_FORUM' => $member_info['most_active_forum'],
            'TIME_FOR_THEM' => $member_info['time_for_them'],
            'TIME_FOR_THEM_RAW' => strval($member_info['time_for_them_raw']),
            'USERS_TIMEZONE' => $member_info['timezone'],
            'USERS_TIMEZONE_RAW' => $member_info['timezone_raw'],
            'SUBMIT_DAYS_AGO' => isset($member_info['submit_days_ago']) ? integer_format($member_info['submit_days_ago']) : null,
            'SUBMIT_TIME_RAW' => isset($member_info['last_submit_time']) ? strval($member_info['last_submit_time']) : null,
            'LAST_VISIT_TIME_RAW' => strval($member_info['last_visit_time']),
            'ONLINE_NOW' => $member_info['online_now'],
            '_ONLINE_NOW' => $member_info['_online_now'],
            'BANNED' => $member_info['banned'] ? do_lang_tempcode('YES') : do_lang_tempcode('NO'),
            'USER_AGENT' => isset($member_info['user_agent']) ? $member_info['user_agent'] : null,
            'OPERATING_SYSTEM' => isset($member_info['operating_system']) ? $member_info['operating_system'] : '',
            'DOB_LABEL' => isset($member_info['dob_label']) ? $member_info['dob_label'] : '',
            'DOB' => isset($member_info['dob']) ? $member_info['dob'] : '',
            '_DOB' => isset($member_info['_dob']) ? strval($member_info['_dob']) : '',
            '_DOB_CENSORED' => isset($member_info['_dob_censored']) ? strval($member_info['_dob_censored']) : '',
            'IP_ADDRESS' => ((has_privilege($member_id_viewing, 'see_ip')) && (isset($member_info['ip_address']))) ? $member_info['ip_address'] : null,
            'COUNT_POSTS' => $member_info['posts_details'],
            '_COUNT_POSTS' => integer_format($member_info['posts']),
            'COUNT_POINTS' => isset($member_info['points']) ? integer_format($member_info['points']) : '',
            'JOIN_DATE' => $member_info['join_date'],
            'JOIN_DATE_RAW' => strval($member_info['join_time']),
            'SIGNATURE' => isset($member_info['signature']) ? $member_info['signature'] : new Tempcode(),
            'ON_PROBATION' => isset($member_info['on_probation_until']) ? strval($member_info['on_probation_until']) : null,
            'PRIMARY_GROUP' => cns_get_group_link($member_info['primary_group'], $member_id_of != $member_id_viewing),
            'PRIMARY_GROUP_ID' => strval($member_info['primary_group']),
            'SECONDARY_GROUPS' => $member_info['secondary_groups_named'],
            'EMAIL_ADDRESS' => isset($member_info['email_address']) ? $member_info['email_address'] : '',
        ) + $fields_map);

        return array($title, $content, $order, 'menu/social/profile');
    }
}

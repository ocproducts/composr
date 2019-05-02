<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_upgrader
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__upgrade_db_upgrade()
{
    require_code('upgrade_lib');
}

/**
 * Do upgrader screen: database upgrade.
 *
 * @ignore
 * @return string Output messages
 */
function upgrader_db_upgrade_screen()
{
    $out = '';

    log_it('UPGRADER_DATABASE_UPGRADE');

    clear_caches_2();

    $version_files = cms_version_number();
    $_version_database_cns = get_value('cns_version');
    if ($_version_database_cns === null) { // LEGACY
        $_version_database_cns = get_value('ocf_version');
    }
    if ($_version_database_cns === null) {
        $_version_database_cns = get_value('version');
    }
    if ($_version_database_cns === null) {
        $version_database_cns = $version_files;
    } else {
        $version_database_cns = floatval($_version_database_cns);
    }

    if (version_specific()) {
        $out .= do_lang('UPGRADER_UPGRADED_CORE_TABLES');
        $something_done = true;
    }

    $done = upgrade_modules();
    if ($done != '') {
        $out .= do_lang('UPGRADER_UPGRADE_MODULES', $done);
        $something_done = true;
    }
    if (!$something_done) {
        $out .= do_lang('NO_UPGRADE_DONE');
    }

    if ($version_database_cns < $version_files) {
        $out .= do_lang('UPGRADER_MUST_UPGRADE_CNS', upgrader_link('upgrader.php?type=db_upgrade_cns', do_lang('UPGRADER_UPGRADE_CNS')));
    }

    return $out;
}

/**
 * Do upgrader screen: Conversr database upgrade.
 *
 * @ignore
 * @return string Output messages
 */
function upgrader_db_upgrade_cns_screen()
{
    $out = '';
    if (cns_upgrade()) {
        $out .= '<p>' . do_lang('SUCCESS') . '</p>';
    } else {
        $out .= do_lang('UPGRADER_NO_CNS_UPGRADE');
    }
    return $out;
}

/**
 * Version specific upgrading. These are things that are relatively major structural changes and therefore will get done outside the module upgrade system.
 *
 * @return boolean Whether anything was done
 */
function version_specific()
{
    // Version specific (rather than component specific) upgrading
    $version_files = cms_version_number();
    $_version_database = get_value('version');
    $version_database = floatval($_version_database);
    if ($_version_database === null) {
        $version_database = $version_files;
    }
    if ($version_database < $version_files) {
        // LEGACY

        if ($version_database < 9.0) {
            $dh = @opendir(get_custom_file_base() . '/imports/mods');
            if ($dh !== false) {
                while (($f = readdir($dh)) !== false) {
                    if (substr($f, -4) == '.tar') {
                        @rename(get_custom_file_base() . '/imports/mods/' . $f, get_file_base() . '/imports/addons/' . $f);
                        sync_file_move(get_custom_file_base() . '/imports/mods/' . $f, get_file_base() . '/imports/addons/' . $f);
                    }
                }
                closedir($dh);
            }
        }
        if ($version_database < 10.0) {
            $GLOBALS['SITE_DB']->add_table_field('config', 'c_value_trans', '?LONG_TRANS');
            $GLOBALS['SITE_DB']->query('UPDATE ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'config SET c_value_trans=config_value,config_value=\'\' WHERE ' . db_string_not_equal_to('config_value', '') . ' AND (' . db_string_equal_to('the_type', 'transtext') . ' OR ' . db_string_equal_to('the_type', 'transline') . ')');

            $GLOBALS['SITE_DB']->rename_table('adminlogs', 'actionlogs');

            @rename(get_custom_file_base() . '/data_custom/breadcrumbs.xml', get_custom_file_base() . '/data_custom/xml_config/breadcrumbs.xml');
            sync_file_move(get_custom_file_base() . '/data_custom/breadcrumbs.xml', get_custom_file_base() . '/data_custom/xml_config/breadcrumbs.xml');
            @rename(get_custom_file_base() . '/data_custom/fields.xml', get_custom_file_base() . '/data_custom/xml_config/fields.xml');
            sync_file_move(get_custom_file_base() . '/data_custom/fields.xml', get_custom_file_base() . '/data_custom/xml_config/fields.xml');

            $remap = array(
                'ocf_post' => 'cns_post',
                'ocf_signature' => 'cns_signature',
            );
            foreach ($remap as $from => $to) {
                $GLOBALS['SITE_DB']->query_update('attachment_refs', array('r_referer_type' => $to), array('r_referer_type' => $from));
            }

            $remap = array(
                'cedi' => 'wiki',
                'contactmember' => 'contact_member',
                'admin_occle' => 'admin_commandr',
                'admin_flagrant' => 'admin_community_billboard', // Not actually bundled, but can take over existing tables now if installed again
                'onlinemembers' => 'usersonline',
                'leaderboard' => 'leader_board',
                'admin_ocf_categories' => 'admin_cns_categories',
                'admin_ocf_customprofilefields' => 'admin_cns_customprofilefields',
                'admin_ocf_emoticons' => 'admin_cns_emoticons',
                'admin_ocf_forums' => 'admin_cns_forums',
                'admin_ocf_groups' => 'admin_cns_groups',
                'admin_ocf_history' => 'admin_cns_history',
                'admin_ocf_join' => 'admin_cns_members',
                'admin_ocf_ldap' => 'admin_cns_ldap',
                'admin_ocf_merge_members' => 'admin_cns_merge_members',
                'admin_ocf_multimoderations' => 'admin_cns_multimoderations',
                'admin_ocf_post_templates' => 'admin_cns_post_templates',
                'admin_ocf_welcome_emails' => 'admin_cns_welcome_emails',
                'cms_cedi' => 'cms_wiki',
                'cms_ocf_groups' => 'cms_cns_groups',
            );
            foreach ($remap as $from => $to) {
                $GLOBALS['SITE_DB']->query_delete('modules', array('module_the_name' => $to));
                $GLOBALS['SITE_DB']->query_update('modules', array('module_the_name' => $to), array('module_the_name' => $from), '', 1);
                $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'menu_items SET i_url=REPLACE(i_url,\'' . $from . '\',\'' . $to . '\')');
            }
            /*
            $deleted_modules = array(
            );
            foreach ($deleted_modules as $module_name) {
                $GLOBALS['SITE_DB']->query_delete('modules', array('module_the_name' => $module_name));
            }
            */
            persistent_cache_delete('MODULES');

            $remap = array(
                'side_ocf_personal_topics' => 'side_cns_private_topics',
                'side_stored_menu' => 'menu',
                'side_root_galleries' => 'side_galleries',
            );
            foreach ($remap as $from => $to) {
                $GLOBALS['SITE_DB']->query_delete('blocks', array('block_name' => $to));
                $GLOBALS['SITE_DB']->query_update('blocks', array('block_name' => $to), array('block_name' => $from), '', 1);
            }
            $deleted_blocks = array(
                'main_feedback',
                'main_sitemap',
                'main_as_zone_access',
                'main_recent_galleries',
                'main_top_galleries',
                'main_recent_cc_entries',
                'main_recent_downloads',
                'main_top_downloads',
                'main_download_tease',
                'main_gallery_tease',
            );
            foreach ($deleted_blocks as $block_name) {
                $GLOBALS['SITE_DB']->query_delete('blocks', array('block_name' => $block_name));
            }

            $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'menu_items SET i_url=REPLACE(i_url,\'ocf_\',\'cns_\')');

            $GLOBALS['SITE_DB']->query('DELETE FROM ' . get_table_prefix() . 'values WHERE the_name LIKE \'' . db_encode_like('%cns_%') . '\'');
            $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'values SET the_name=REPLACE(the_name,\'ocf_\',\'cns_\')');

            $GLOBALS['SITE_DB']->query_update('url_id_monikers', array('m_resource_type' => 'browse'), array('m_resource_type' => 'misc'), '', 1);
            $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'f_custom_fields f JOIN ' . get_table_prefix() . 'translate t ON t.id=f.cf_name SET text_original=\'ocp_street_address\' WHERE text_original=\'ocp_building_name_or_number\'');
            $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'f_custom_fields f JOIN ' . get_table_prefix() . 'translate t ON t.id=f.cf_name SET text_original=REPLACE(text_original,\'ocp_\',\'cms_\') WHERE text_original LIKE \'ocp\_%\'');
            $GLOBALS['SITE_DB']->alter_table_field('msp', 'specific_permission', '*ID_TEXT', 'privilege');
            $GLOBALS['SITE_DB']->alter_table_field('gsp', 'specific_permission', '*ID_TEXT', 'privilege');
            if ($GLOBALS['SITE_DB']->table_exists('pstore_permissions')) {
                $GLOBALS['SITE_DB']->alter_table_field('pstore_permissions', 'p_specific_permission', 'ID_TEXT', 'p_privilege');
            }
            $GLOBALS['SITE_DB']->rename_table('msp', 'member_privileges');
            $GLOBALS['SITE_DB']->rename_table('gsp', 'group_privileges');
            $GLOBALS['SITE_DB']->rename_table('sp_list', 'privilege_list');
            $GLOBALS['SITE_DB']->rename_table('usersubmitban_ip', 'banned_ip');
            $GLOBALS['SITE_DB']->query_update('db_meta_indices', array('i_fields' => 'member_id'), array('i_name' => 'xas'), '', 1);
            $GLOBALS['SITE_DB']->query_update('db_meta', array('m_type' => 'MEMBER'), array('m_type' => 'USER'));
            $GLOBALS['SITE_DB']->query_update('db_meta', array('m_type' => '?MEMBER'), array('m_type' => '?USER'));
            $GLOBALS['SITE_DB']->query_update('db_meta', array('m_type' => '*MEMBER'), array('m_type' => '*USER'));
            $GLOBALS['SITE_DB']->alter_table_field('actionlogs', 'the_user', 'MEMBER', 'member_id');
            $GLOBALS['SITE_DB']->alter_table_field('sessions', 'the_user', 'MEMBER', 'member_id');
            $GLOBALS['SITE_DB']->alter_table_field('sessions', 'the_session', '*ID_TEXT');
            $GLOBALS['SITE_DB']->query_update('privilege_list', array('p_section' => 'FORUMS_AND_MEMBERS'), array('p_section' => 'SECTION_FORUMS'));
            $GLOBALS['SITE_DB']->query_update('privilege_list', array('p_section' => 'BANNERS'), array('p_section' => '_BANNERS'));
            $GLOBALS['SITE_DB']->query_delete('config', array('c_set' => 0)); // Defaults not saved in in same way in v10
            $GLOBALS['SITE_DB']->delete_table_field('config', 'human_name');
            $GLOBALS['SITE_DB']->delete_table_field('config', 'the_type');
            $GLOBALS['SITE_DB']->delete_table_field('config', 'eval');
            $GLOBALS['SITE_DB']->delete_table_field('config', 'the_page');
            $GLOBALS['SITE_DB']->delete_table_field('config', 'section');
            $GLOBALS['SITE_DB']->delete_table_field('config', 'explanation');
            $GLOBALS['SITE_DB']->delete_table_field('config', 'shared_hosting_restricted');
            $GLOBALS['SITE_DB']->delete_table_field('config', 'c_data');
            $GLOBALS['SITE_DB']->alter_table_field('config', 'the_name', '*ID_TEXT', 'c_name');
            $GLOBALS['SITE_DB']->alter_table_field('config', 'config_value', 'LONG_TEXT', 'c_value');
            $GLOBALS['SITE_DB']->add_table_field('config', 'c_needs_dereference', 'BINARY', 0);
            $hooks = find_all_hook_obs('systems', 'config', 'Hook_config_');
            foreach ($hooks as $hook => $ob) {
                $option = $ob->get_details();
                $needs_dereference = ($option['type'] == 'transtext' || $option['type'] == 'transline' || $option['type'] == 'comcodetext' || $option['type'] == 'comcodeline') ? 1 : 0;
                $GLOBALS['SITE_DB']->query_update('config', array('c_needs_dereference' => $needs_dereference), array('c_name' => $hook), '', 1);
            }
            $GLOBALS['SITE_DB']->query_update('zones', array('zone_theme' => 'admin'), array('zone_name' => 'adminzone'), '', 1);
            $GLOBALS['SITE_DB']->query_update('zones', array('zone_theme' => 'admin'), array('zone_name' => 'cms'), '', 1);
            $GLOBALS['SITE_DB']->query_update('db_meta', array('m_type' => 'SHORT_TEXT'), array('m_type' => 'MD5'));
            $GLOBALS['SITE_DB']->query_update('db_meta', array('m_type' => '*SHORT_TEXT'), array('m_type' => '*MD5'));
            rename_config_option('ocf_show_profile_link', 'cns_show_profile_link');

            delete_value('last_implicit_sync');
            delete_value('last_newsletter_drip_send');
            delete_value('last_confirm_reminder_time');
            delete_value('oracle_index_cleanup_last_time');
            delete_value('last_sitemap_time_calc');
            delete_value('last_ticket_lead_time_calc');
            if (get_value('last_welcome_mail_time') !== null) {
                $GLOBALS['SITE_DB']->query_insert('long_values', array('date_and_time' => time(), 'the_value' => get_value('last_welcome_mail_time'), 'the_name' => 'last_welcome_mail_time'));
                delete_value('last_welcome_mail_time');
            }

            foreach (array('INTEGER', 'REAL') as $bad_type) {
                $bad_fields = $GLOBALS['SITE_DB']->query_select('db_meta', array('m_name'), array('m_type' => $bad_type, 'm_table' => 'f_member_custom_fields'));
                foreach ($bad_fields as $bad_field) {
                    $GLOBALS['SITE_DB']->alter_table_field('f_member_custom_fields', $bad_field['m_name'], '?' . $bad_type);
                }
            }

            // This seems to be a legacy problem on some sites, but would crash on v10 if no-multi-lang was enabled. Generally things would corrupt.
            require_code('cns_members');
            $fields = $GLOBALS['SITE_DB']->query('SELECT id FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'f_custom_fields WHERE cf_type IN (\'long_trans\',\'short_trans\')');
            $member_mappings = cns_get_custom_field_mappings(get_member());
            foreach ($fields as $field) {
                $db_field = 'field_' . strval($field['id']);
                if (is_string($member_mappings[$db_field])) {
                    $GLOBALS['SITE_DB']->promote_text_field_to_comcode('f_member_custom_fields', $db_field, 'mf_member_id');
                }
            }

            // For old (and renamed) non-bundled addons
            if ($GLOBALS['SITE_DB']->table_exists('bank')) {
                $GLOBALS['SITE_DB']->alter_table_field('bank', 'divident', 'INTEGER', 'dividend');
                rename_config_option('bank_divident', 'bank_dividend');
            }

            // Delete old files
            @unlink(get_file_base() . '/pages/html_custom/EN/cedi_tree_made.htm');
            @unlink(get_file_base() . '/site/pages/html_custom/EN/cedi_tree_made.htm');
            @unlink(get_file_base() . '/pages/html_custom/EN/download_tree_made.htm');
            @unlink(get_file_base() . '/site/pages/html_custom/EN/download_tree_made.htm');

            // File replacements
            $reps = array(
                '#([^\w])cedi([^\w])#' => '$1wiki$2',
                '#([^\w])seedy([^\w])#' => '$1wiki$2',
                '#ocPortal#' => 'Composr',
                '#ocp_#' => 'cms_',
                '#side_ocf_personal_topics#' => 'side_cns_private_topics',
                '#ocf_#' => 'cns_',
                '# filter="#' => ' select="',
                '# select="#' => ' filter="',
                '# ocselect="#' => ' filter="',
                '# caption="#' => ' title="',
                '#main_feedback#' => 'main_contact_us',
                '#side_stored_menu#' => 'menu',
                '#topsites#' => 'top_sites',
                '#internal_box#' => 'box',
                '#external_box#' => 'box',
                '# type="curved"#' => '',
                '# type=&quot;curved&quot;#' => '',
                '#side_root_galleries#' => 'side_galleries',
                '#\[block\]main_sitemap\[/block\]#' => '{$BLOCK,block=menu,param={$_GET,under},use_page_groupings=1,type=sitemap,quick_cache=1}',
                '#\[attachment([^\[\]]*)\]url_([^\[\]]*)\[/attachment[^\[\]]*\]#' => '[media$1]$2[/media]',
                '#\{\$OCF#' => '{$CNS',
                '#:misc#' => ':browse',
                '#type=misc#' => 'type=browse',
                '#:product=#' => ':type_code=',
                '#&product=#' => '&type_code=',
                '#&amp;product=#' => '&amp;type_code=',
                '#solidborder#' => 'results_table',
            );
            perform_search_replace($reps);
        }

        if ($version_database < 11.0) {
            if ((addon_installed('tickets')) && (get_forum_type() == 'cns')) {
                require_code('tickets');
                require_code('cns_forums_action2');
                $target_forum_id = get_ticket_forum_id(null, false, true);
                if ($target_forum_id !== null) {
                    $forum_id = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_forums', 'id', array('f_name' => 'Reported posts forum'));
                    if ($forum_id !== null) {
                        cns_delete_forum($forum_id, $target_forum_id);
                    }
                    $forum_id = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_forums', 'id', array('f_name' => 'Website "Contact Us" messages'));
                    if ($forum_id !== null) {
                        cns_delete_forum($forum_id, $target_forum_id);
                    }
                }
            }

            if (multi_lang_content()) {
                $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'f_custom_fields f JOIN ' . get_table_prefix() . 'translate t ON t.id=f.cf_name SET text_original=\'cms_payment_card_type\' WHERE text_original=\'cms_payment_type\'');
                $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'f_custom_fields f JOIN ' . get_table_prefix() . 'translate t ON t.id=f.cf_name SET cf_type=\'year_month\' WHERE (text_original=\'cms_payment_card_start_date\' OR text_original=\'cms_payment_card_expiry_date\')');
            } else {
                $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'f_custom_fields SET cf_name=\'cms_payment_card_type\' WHERE cf_name=\'cms_payment_type\'');
                $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'f_custom_fields SET cf_type=\'year_month\' WHERE (cf_name=\'cms_payment_card_start_date\' OR cf_name=\'cms_payment_card_expiry_date\')');
            }
        }

        set_value('version', float_to_raw_string($version_files, intval($version_database), true));

        return true;
    }

    return false;
}

/**
 * Upgrade all modules.
 *
 * @return string List of upgraded/installed modules/blocks
 */
function upgrade_modules()
{
    $out = '';

    require_code('zones2');
    require_code('zones3');

    $ret = upgrade_module('adminzone', 'admin_version');
    if ($ret == 1) {
        $out .= '<li>' . do_lang('UPGRADER_UPGRADED_MODULE', '<kbd>admin_version</kbd>') . '</li>';
    }

    $zones = find_all_zones();
    if (!in_array('adminzone', $zones)) {
        $zones[] = 'adminzone';
    }
    if (!in_array('cms', $zones)) {
        $zones[] = 'cms';
    }
    if (!in_array('site', $zones)) {
        $zones[] = 'site';
    }
    foreach ($zones as $zone) {
        $modules = find_all_modules($zone);
        foreach ($modules as $module => $type) {
            $ret = upgrade_module($zone, $module);
            if ($ret == 1) {
                $out .= '<li>' . do_lang('UPGRADER_UPGRADED_MODULE', '<kbd>' . escape_html($module) . '</kbd>') . '</li>';
            } elseif ($ret == -2) {
                if (reinstall_module($zone, $module)) {
                    $out .= '<li>' . do_lang('UPGRADER_INSTALLED_MODULE', '<kbd>' . escape_html($module) . '</kbd>') . '</li>';
                }
            }
        }
    }

    $blocks = find_all_blocks();
    foreach ($blocks as $block => $type) {
        $ret = upgrade_block($block);
        if ($ret == 1) {
            $out .= '<li>' . do_lang('UPGRADER_UPGRADED_BLOCK', '<kbd>' . escape_html($block) . '</kbd>') . '</li>';
        } elseif ($ret == -2) {
            if (reinstall_block($block)) {
                $out .= '<li>' . do_lang('UPGRADER_INSTALLED_BLOCK', '<kbd>' . escape_html($block) . '</kbd>') . '</li>';
            }
        }
    }

    require_code('addons2');
    $addons = find_all_hooks('systems', 'addon_registry');
    foreach ($addons as $addon => $type) {
        $ret = upgrade_addon_soft($addon);
        if ($ret == 1) {
            $out .= '<li>' . do_lang('UPGRADER_UPGRADED_ADDON', '<kbd>' . escape_html($addon) . '</kbd>') . '</li>';
        } elseif ($ret == -2) {
            reinstall_addon_soft($addon);

            $out .= '<li>' . do_lang('UPGRADER_INSTALLED_ADDON', '<kbd>' . escape_html($addon) . '</kbd>') . '</li>';
        }
    }

    return $out;
}

/**
 * Upgrade Conversr if appropriate.
 *
 * @return boolean Whether anything was done
 */
function cns_upgrade()
{
    $version_files = cms_version_number();
    $_version_database_cns = get_value('cns_version');
    if ($_version_database_cns === null) { // LEGACY
        $_version_database_cns = get_value('ocf_version');
        set_value('cns_version', $_version_database_cns);
        delete_value('ocf_version');
    }
    if ($_version_database_cns === null) {
        $_version_database_cns = get_value('version');
    }
    if ($_version_database_cns === null) {
        $version_database_cns = $version_files;
    } else {
        $version_database_cns = floatval($_version_database_cns);
    }


    if ($version_files != $version_database_cns) {
        global $SITE_INFO;
        $SITE_INFO['db_forums'] = $SITE_INFO['db_site'];
        $SITE_INFO['db_forums_host'] = (!empty($SITE_INFO['db_site_host'])) ? $SITE_INFO['db_site_host'] : 'localhost';
        $SITE_INFO['db_forums_user'] = (!empty($SITE_INFO['db_site_user'])) ? $SITE_INFO['db_site_user'] : 'root';
        $SITE_INFO['db_forums_password'] = array_key_exists('db_site_password', $SITE_INFO) ? $SITE_INFO['db_site_password'] : '';
        $GLOBALS['FORUM_DB'] = $GLOBALS['SITE_DB'];

        require_code('forum/cns');
        $GLOBALS['FORUM_DRIVER'] = object_factory('Forum_driver_cns');
        $GLOBALS['FORUM_DRIVER']->db = $GLOBALS['SITE_DB'];

        require_code('cns_install');
        install_cns($version_database_cns);

        set_value('cns_version', float_to_raw_string($version_files, 10, true));

        return true;
    }
    return false;
}

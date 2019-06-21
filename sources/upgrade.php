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
 * The upgrader.php script handler.
 */
function upgrade_script()
{
    // Init...

    cms_ini_set('ocproducts.xss_detect', '0');

    require_lang('upgrade');
    require_all_core_cms_code();

    cms_extend_time_limit(TIME_LIMIT_EXTEND_slow);

    // Security...

    if (!array_key_exists('given_password', $_POST)) {
        upgrader_output_header();
        upgrader_output_login();
        upgrader_output_footer();
        return;
    }

    $given_password = post_param_string('given_password', false, INPUT_FILTER_NONE);
    require_code('crypt_master');
    if (!check_master_password($given_password)) {
        upgrader_output_header();
        upgrader_output_login(do_lang((get_option('login_error_secrecy') == '1') ? 'MEMBER_INVALID_LOGIN' : 'MEMBER_BAD_PASSWORD'));
        upgrader_output_footer();
        return;
    }

    load_csp(array('csp_enabled' => '0'));

    // Action handling...

    $type = get_param_string('type', 'browse');

    require_code('upgrade_lib');
    require_code('abstract_file_manager');

    upgrader_output_header();

    if (post_param_string('ftp_username', '') != '') {
        $_POST['uses_ftp'] = '1';
        _ftp_info(true); // To give early error if there's a problem
    }

    // Handle shared site upgrading with no per-site UI
    global $SITE_INFO;
    if (isset($SITE_INFO['custom_file_base_stub'])) { // This upgrader script must be called on a particular site with a real DB (e.g. shareddemo.composr.info), but will run for all sites on same install
        require_code('shared_installs');
        $u = current_share_user();
        if ($u !== null) {
            require_code('upgrade_shared_installs');
            echo upgrader_sharedinstall_screen();
            upgrader_output_footer();
            return;
        }
    }

    $show_more_link = true;

    switch ($type) {
        case 'misc': // LEGACY
        case 'browse':
            echo upgrader_menu_screen();
            $show_more_link = false;
            break;

        case 'decache':
            echo upgrader_decache_screen();
            break;

        case 'check_perms':
            require_code('upgrade_perms');
            echo upgrader_check_perms_screen();
            break;

        case 'fix_perms':
            require_code('upgrade_perms');
            echo upgrader_fix_perms_screen();
            break;

        case 'open_site':
            echo upgrader_open_site_screen();
            break;

        case 'close_site':
            echo upgrader_close_site_screen();
            break;

        case 'file_upgrade':
            require_code('upgrade_files');
            appengine_live_guard();
            echo upgrader_file_upgrade_screen();
            $show_more_link = false;
            break;

        case '_file_upgrade':
            require_code('upgrade_files');
            appengine_live_guard();
            echo _upgrader_file_upgrade_screen();
            break;

        case 'integrity_scan':
            require_code('upgrade_integrity_scan');
            echo upgrader_integrity_scan_screen();
            break;

        case '_integrity_scan':
            require_code('upgrade_integrity_scan');
            echo upgrader__integrity_scan_screen();
            break;

        case 'addon_remove':
            require_code('upgrade_integrity_scan');
            echo upgrader_addon_remove_screen();
            break;

        case '_addon_remove':
            require_code('upgrade_integrity_scan');
            echo upgrader__addon_remove_screen();
            break;

        case 'db_upgrade':
            require_code('upgrade_db_upgrade');
            echo upgrader_db_upgrade_screen();
            $something_done = false;
            break;

        case 'db_upgrade_cns': // Only to be launched as a consequent of db_upgrade
            require_code('upgrade_db_upgrade');
            echo upgrader_db_upgrade_cns_screen();
            break;

        case 'theme_upgrade':
            require_code('upgrade_themes');
            appengine_live_guard();
            echo upgrader_theme_upgrade_screen();
            break;

        case 'mysql_repair':
            require_code('upgrade_mysql');
            echo upgrader_mysql_repair_screen();
            break;

        case 'criticise_mysql_fields':
            require_code('upgrade_mysql');
            echo upgrader_criticise_mysql_fields_screen();
            break;
    }

    if ($show_more_link) {
        echo '<hr class="spaced-rule" /><div>' . upgrader_link('upgrader.php?type=browse', do_lang('MORE_OPTIONS')) . '</div>';
    }

    upgrader_output_footer();
}

/**
 * Get hidden form fields for relaying POST information.
 *
 * @return string The hidden form fields for relaying POST information
 */
function post_fields_relay()
{
    $hidden = '';
    foreach (array_keys($_POST) as $key) {
        if (preg_match('#^(news_id$|from_version$|given_password$|ftp_)#', $key) != 0) {
            $hidden .= '<input type="hidden" name="' . escape_html($key) . '" value="' . escape_html(post_param_string($key)) . '" />';
        }
    }
    return $hidden;
}

/**
 * Generate a form-based link to relay POST information to a URL.
 *
 * @param  string $url The URL (something like 'upgrader.php?type=cns')
 * @param  string $text The URL caption text
 * @param  boolean $disabled Whether it is disabled
 * @param  string $js Extra JavaScript
 * @return string The form-based link
 */
function upgrader_link($url, $text, $disabled = false, $js = '')
{
    $hidden = (strpos($url, 'http://compo.sr') !== false || strpos($url, '/index.php') !== false) ? '' : post_fields_relay();
    if (get_param_integer('keep_safe_mode', 0) == 1) {
        $url .= '&keep_safe_mode=1';
    }
    if (get_param_integer('keep_show_loading', 0) == 1) {
        $url .= '&keep_show_loading=1';
    }
    $_icon = 'buttons/proceed';
    if ($text == do_lang('MORE_OPTIONS')) {
        $_icon = 'buttons/back';
    }

    $ret = '<form title="' . escape_html($text) . '" style="display: inline" action="' . escape_html($url) . '" method="post">';
    $ret .= $hidden;
    $icon = do_template('ICON', array('_GUID' => '7a9a0914fc785d0c748f5f3497c4eb2e','NAME' => $_icon));
    $ret .= '<button ' . (empty($js) ? '' : 'onclick="return window.confirm(\'' . addslashes($js) . '\');" ') . 'accesskey="c" ' . ($disabled ? 'disabled="disabled"' : '') . ' class="button-screen-item" type="submit">' . $icon->evaluate() . ' ' . escape_html($text) . '</button>';
    $ret .= '</form>';
    return $ret;
}

/**
 * Output a login page.
 *
 * @param  ?string $message Error message (null: none)
 */
function upgrader_output_login($message = null)
{
    $type = get_param_string('type', 'browse');
    global $SITE_INFO;
    $ftp_username = get_value('ftp_username');
    $ftp_folder = get_value('ftp_directory');
    $ftp_domain = get_value('ftp_domain');
    if ($ftp_domain === null) {
        $ftp_domain = (!empty($SITE_INFO['ftp_domain'])) ? $SITE_INFO['ftp_domain'] : 'localhost';
    }
    if ($ftp_username === null) {
        if (empty($SITE_INFO['ftp_username'])) {
            if (php_function_allowed('posix_getpwuid')) {
                $u_info = posix_getpwuid(website_file_owner());
                $ftp_username = $u_info['name'];
            } else {
                $ftp_username = '';
            }
            if ($ftp_username === null) {
                $ftp_username = '';
            }
        } else {
            $ftp_username = $SITE_INFO['ftp_username'];
        }
    }
    if ($ftp_folder === null) {
        if (empty($SITE_INFO['ftp_folder'])) {
            $dr = $_SERVER['DOCUMENT_ROOT'];
            if (strpos($dr, '/') !== false) {
                $dr_parts = explode('/', $dr);
            } else {
                $dr_parts = explode('\\', $dr);
            }
            $webdir_stub = $dr_parts[count($dr_parts) - 1];
            $pos = strpos($_SERVER['SCRIPT_NAME'], 'upgrader.php');
            if ($pos === false) {
                $pos = strlen($_SERVER['SCRIPT_NAME']);
            } else {
                $pos--;
            }
            $ftp_folder = '/' . $webdir_stub . substr($_SERVER['SCRIPT_NAME'], 0, $pos);
        } else {
            $ftp_folder = $SITE_INFO['ftp_folder'];
        }
    }
    require_lang('installer');
    $l_password = do_lang('MASTER_PASSWORD');
    $l_ftp_info = do_lang('UPGRADER_FTP_INFO');
    $l_ftp_domain = do_lang('FTP_DOMAIN');
    $l_ftp_directory = do_lang('FTP_DIRECTORY');
    $l_ftp_username = do_lang('FTP_USERNAME');
    $l_ftp_password = do_lang('FTP_PASSWORD');
    $l_login = do_lang('_LOGIN');
    $l_login_info = do_lang('UPGRADER_LOGIN_INFO');
    $l_login_info_pass_forget = do_lang('UPGRADER_LOGIN_INFO_PASS_FORGET');
    $l_login_forgot_password_q = do_lang('UPGRADER_LOGIN_FORGOT_PASSWORD_Q');
    if ($message !== null) {
        echo '<p><strong>' . $message . '</strong></p>';
    }
    $news_id = either_param_string('news_id', null); // Comes in via GET, but carries through via POST
    $from_version = either_param_string('from_version', null);
    $url = "upgrader.php?type=" . escape_html($type);
    if (get_param_integer('keep_safe_mode', 0) == 1) {
        $url .= '&keep_safe_mode=1';
    }
    if (get_param_integer('keep_show_loading', 0) == 1) {
        $url .= '&keep_show_loading=1';
    }
    echo "
    <p>{$l_login_info}</p>
    <form title=\"{$l_login}\" action=\"" . escape_html($url) . "\" method=\"post\">
    " . (($news_id === null) ? '' : ('<input type="hidden" name="news_id" value="' . strval($news_id) . '" />')) . "
    " . (($from_version === null) ? '' : ('<input type="hidden" name="from_version" value="' . escape_html($from_version) . '" />')) . "
    <p>
        {$l_password}: <input type=\"password\" name=\"given_password\" value=\"" . escape_html(post_param_string('password', '', INPUT_FILTER_NONE)) . "\" />
    </p>
    ";

    require_code('files');
    if ((is_suexec_like()) || ((!function_exists('ftp_ssl_connect')) && (!function_exists('ftp_connect')))) {
    } else {
        echo "
        <hr class=\"spaced-rule\" />
        {$l_ftp_info}
        <table>
            <tbody>
                    <tr><th>{$l_ftp_domain}:</th><td><input size=\"50\" type=\"text\" name=\"ftp_domain\" value=\"" . escape_html($ftp_domain) . "\" /></td></tr>
                    <tr><th>{$l_ftp_directory}:</th><td><input size=\"50\" type=\"text\" name=\"ftp_folder\" value=\"" . escape_html($ftp_folder) . "\" /></td></tr>
                    <tr><th>{$l_ftp_username}:</th><td><input size=\"50\" type=\"text\" name=\"ftp_username\" value=\"" . escape_html($ftp_username) . "\" /></td></tr>
                    <tr><th>{$l_ftp_password}:</th><td><input size=\"50\" type=\"password\" name=\"ftp_password\" /></td></tr>
            </tbody>
        </table>
        <hr class=\"spaced-rule\" />
        ";
    }

    $login_icon = do_template('ICON', array('_GUID' => 'f6b19594ec3a2fc6b1f26e67affc64b8','NAME' => 'menu/site_meta/user_actions/login'));
    $_login_icon = $login_icon->evaluate();
    echo "
    <p>
        <button class=\"menu--site-meta--user-actions--login button-screen\" type=\"submit\">{$_login_icon} {$l_login}</button>
    </p>
    </form>
    ";

    echo "
    <hr class=\"spaced-rule\" />
    <div style=\"font-size: 0.8em\">
    <h2>{$l_login_forgot_password_q}</h2>
    <p>{$l_login_info_pass_forget}</p>
    </div>
    ";
}

/**
 * Output the upgrader page header.
 */
function upgrader_output_header()
{
    $upgrader_title = do_lang('UPGRADER_UPGRADER_TITLE');
    $upgrader_intro = do_lang('UPGRADER_UPGRADER_INTRO');
    $charset = get_charset();
    $lang = user_lang();
    $dir = do_lang('dir');

    cms_ob_end_clean();
    echo <<<END
<!DOCTYPE html>
    <html lang="{$lang}" dir="{$dir}">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset={$charset}" />

        <title>{$upgrader_title}</title>
        <link rel="icon" href="https://compo.sr/favicon.ico" type="image/x-icon" />

        <style>/*<![CDATA[*/
END;
    @print(file_get_contents(css_enforce('global', 'default')));
    echo <<<END
            .screen-title { text-decoration: underline; display: block; background: url('themes/default/images/icons/menu/adminzone/tools/upgrade.svg') top left no-repeat; background-size: 48px 48px; min-height: 42px; padding: 10px 0 0 60px; }
            a[target="_blank"], a[onclick$="window.open"] { padding-right: 0; }
        /*]]>*/</style>

        <meta name="robots" content="noindex, nofollow" />
    </head>
    <body class="website-body"><div class="global-middle">
        <h1 class="screen-title">{$upgrader_title}</h1>
        <p>{$upgrader_intro}</p><hr class="spaced-rule" />
END;
}

/**
 * Output the upgrader page footer.
 */
function upgrader_output_footer()
{
    echo <<<END
    </div></body>
</html>
END;
}

/**
 * Do upgrader screen: menu.
 *
 * @ignore
 * @return string Output messages
 */
function upgrader_menu_screen()
{
    // Clear cache automatically
    clear_caches_1();

    // Some labels
    $l_choices = do_lang('UPGRADER_CHOICES');
    $l_maintenance = do_lang('UPGRADER_MAINTENANCE');
    $l_upgrading = do_lang('UPGRADER_UPGRADING');
    $l_important = do_lang('IMPORTANT');
    $l_bugs = do_lang('UPGRADER_BUGS');
    $l_release_notes = do_lang('UPGRADER_RELEASE_NOTES');
    $l_refer_release_notes = do_lang('UPGRADER_REFER_RELEASE_NOTES');
    $l_upgrade_steps = do_lang('UPGRADER_UPGRADE_STEPS');
    $l_step = do_lang('UPGRADER_STEP');
    $l_action = do_lang('ACTION');
    $l_estimated_time = do_lang('UPGRADER_ESTIMATED_TIME');
    $l_not_for_patch = do_lang('UPGRADER_NOT_FOR_PATCH');
    $l_customisations = do_lang('UPGRADER_CUSTOMISATIONS');
    $l_error_correction = do_lang('UPGRADER_ERROR_CORRECTION');

    // Show version number
    $a = float_to_raw_string(cms_version_number(), 10, true);
    $b = get_value('version');
    if ($b === null) {
        $b = do_lang('UNKNOWN');
    } else {
        $b = float_to_raw_string(floatval($b), 10, true); // Normalise decimal places
    }
    $l_up_info = do_lang('UPGRADER_UP_INFO' . (($a == $b) ? '_1' : '_2'), $a, $b);

    // Clear cache link
    $l_clear_caches = upgrader_link('upgrader.php?type=decache', do_lang('UPGRADER_CLEAR_CACHES'));

    // Tutorial link
    $l_tutorial = upgrader_link(get_tutorial_url('tut_upgrade'), do_lang('UPGRADER_TUTORIAL'));

    // Backup link
    $l_take_backup = do_lang('UPGRADER_TAKE_BACKUP');

    // Open/close sections and links
    $oc = (get_option('site_closed') == '0') ? do_lang('OPEN') : do_lang('CLOSED');
    $l_fu_closedness = do_lang('UPGRADER_CLOSENESS', $oc);
    $l_close_site = upgrader_link('upgrader.php?type=close_site', do_lang('UPGRADER_CLOSE_SITE'), get_option('site_closed') == '1');
    $l_open_site = upgrader_link('upgrader.php?type=open_site', do_lang('UPGRADER_OPEN_SITE'), get_option('site_closed') == '0');
    $closed = comcode_to_tempcode(get_option('closed'), null, true);
    $closed_url = build_url(array('page' => 'admin_config', 'type' => 'category', 'id' => 'SITE'), get_module_zone('admin_config'), array(), false, false, false, 'group_CLOSED_SITE');

    // Transfer files link
    $news_id = post_param_integer('news_id', null);
    $from_version = post_param_string('from_version', strval(cms_version()) . '.' . cms_version_minor());
    $tar_url = '';
    if ($news_id !== null) {
        require_code('files');
        $fetch_url = 'https://compo.sr/uploads/website_specific/compo.sr/scripts/fetch_release_details.php?format=json&news_id=' . strval($news_id) . '&from_version=' . urlencode($from_version);
        $news = http_get_contents($fetch_url, array('timeout' => 30.0));

        $details = json_decode($news, true);
        if ($details[0] != '') {
            $l_refer_release_notes = $details[0];
            if ($details[2] != '') {
                $l_refer_release_notes .= '<div style="overflow: auto; height: 150px">' . $details[2] . '</div>';
            }
        }
        $tar_url = $details[1];
    }
    $l_download = upgrader_link('upgrader.php?type=file_upgrade&tar_url=' . urlencode(base64_encode($tar_url)), do_lang('UPGRADER_DOWNLOAD'));

    // Integrity scan link
    $l_integrity_scan = upgrader_link('upgrader.php?type=integrity_scan&allow_merging=1', do_lang('UPGRADER_INTEGRITY_SCAN'), false, do_lang('UPGRADER_WILL_MERGE'));
    $l_integrity_scan_no_merging = upgrader_link('upgrader.php?type=integrity_scan', do_lang('UPGRADER_INTEGRITY_SCAN_NO_CSS_MERGE'));

    // Database upgrade link
    $l_db_upgrade = upgrader_link('upgrader.php?type=db_upgrade', do_lang('UPGRADER_DATABASE_UPGRADE'));

    // Theme upgrade link
    $l_theme_upgrade = upgrader_link('upgrader.php?type=theme_upgrade', do_lang('UPGRADER_THEME_UPGRADE'));

    // Error correction links
    $l_safe_mode = upgrader_link('index.php?keep_safe_mode=1', do_lang('UPGRADER_SAFE_MODE'));
    $num_addons = $GLOBALS['SITE_DB']->query_select_value('addons', 'COUNT(*)');
    $l_addon_management = upgrader_link('adminzone/index.php?page=admin_addons&keep_safe_mode=1', do_lang('UPGRADER_ADDON_MANAGEMENT', integer_format($num_addons)), $num_addons == 0);
    $show_permission_buttons = (!GOOGLE_APPENGINE && !is_suexec_like() || $GLOBALS['DEV_MODE']);
    $l_check_perms = upgrader_link('upgrader.php?type=check_perms', do_lang('UPGRADER_CHECK_PERMISSIONS'));
    $l_fix_perms = upgrader_link('upgrader.php?type=fix_perms', do_lang('UPGRADER_FIX_PERMISSIONS'));
    $l_addon_remove = upgrader_link('upgrader.php?type=addon_remove', do_lang('UPGRADER_REMOVE_ADDON_FILES'));
    $show_mysql_buttons = (strpos(get_db_type(), 'mysql') !== false);
    $l_mysql_repair = upgrader_link('upgrader.php?type=mysql_repair', do_lang('MYSQL_REPAIR'));
    $l_criticise_mysql_fields = upgrader_link('upgrader.php?type=criticise_mysql_fields', do_lang('CORRECT_MYSQL_SCHEMA_ISSUES'));

    $out = '';

    $out .= "
        <p>{$l_choices}</p>

        <div style=\"margin: 0 50px\">
            <h2>{$l_maintenance}&hellip;</h2>

            <ul class=\"compact-list\">
                <li>{$l_clear_caches}</li>
            </ul>

            <h2 style=\"margin-top: 2em\">{$l_upgrading}&hellip;</h2>

            <h3>{$l_important}</h3>
            <p>{$l_bugs}</p>

            <h3>{$l_release_notes}</h3>
            <p>{$l_refer_release_notes}</p>

            <h3>{$l_upgrade_steps}</h3>
            <div class=\"wide-table-wrap\"><table class=\"columned-table autosized-table results-table wide-table spaced-table\">
                <thead>
                    <tr>
                        <th>{$l_step}</th>
                        <th>{$l_action}</th>
                        <th>{$l_estimated_time}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr><th>X</th><td>{$l_not_for_patch} {$l_tutorial}</td><td>" . escape_html(display_time_period(60 * 120)) . "</td></tr>

                    <tr><th>1</th><td>{$l_take_backup}</td><td>" . escape_html(display_time_period(60 * 120)) . "</td></tr>

                    <tr><th>2</th><td>{$l_close_site}  {$l_fu_closedness}<br /><q style=\"font-style: italic\">" . $closed->evaluate() . "</q> <span class=\"associated-link\"><a href=\"" . escape_html($closed_url->evaluate()) . "\" title=\"(this link will open in a new window)\" target=\"_blank\">" . do_lang('CHANGE') . "</a></span></td><td>" . escape_html(display_time_period(60)) . "</td></tr>

                    <tr><th>3</th><td>{$l_download}</td><td>" . escape_html(display_time_period(60 * 5)) . "</td></tr>

                    <tr><th>4</th><td>{$l_not_for_patch} {$l_integrity_scan_no_merging}<!-- " . do_lang('OR') . " {$l_integrity_scan}--></td><td>" . str_replace(' ', '&nbsp;', escape_html(display_time_period(60 * 10))) . "&nbsp;&dagger;</td></tr>

                    <tr><th>5</th><td>{$l_not_for_patch} {$l_db_upgrade}<br />{$l_up_info}</td><td>" . escape_html(display_time_period(60 * 5)) . "</td></tr>

                    <tr><th>6</th><td>{$l_not_for_patch} {$l_theme_upgrade}</td><td>" . escape_html(display_time_period(60 * 5)) . "</td></tr>

                    <tr><th>7</th><td>{$l_clear_caches}</td><td>1 minute</td></tr>

                    <tr><th>8</th><td>{$l_open_site}  {$l_fu_closedness}</td><td>1 minute</td></tr>
                </tbody>
            </table></div>

            <p>&dagger; {$l_customisations}</p>

            <h2 style=\"margin-top: 2em\">{$l_error_correction}&hellip;</h2>

            <ul class=\"compact-list\">";
    if ($show_permission_buttons) {
        $out .= "
                <li>{$l_check_perms} / {$l_fix_perms}</li>";
    }
    $out .= "
                <li>{$l_safe_mode}</li>
                <li>{$l_addon_management}</li>
                <li>{$l_addon_remove}</li>";
    if ($show_mysql_buttons) {
        $out .= "
                <li>{$l_mysql_repair}</li>
                <li>{$l_criticise_mysql_fields}</li>";
    }
    $out .= "
            </ul>
        </div>";

    return $out;
}

/**
 * Do upgrader screen: decaching.
 *
 * @ignore
 * @return string Output messages
 */
function upgrader_decache_screen()
{
    clear_caches_2();
    return '<p>' . do_lang('SUCCESS') . '</p>';
}

/**
 * Do upgrader screen: open site.
 *
 * @ignore
 * @return string Output messages
 */
function upgrader_open_site_screen()
{
    log_it('UPGRADER_OPEN_SITE');

    set_option('site_closed', '0');
    return '<p>' . do_lang('SUCCESS') . '</p>';
}

/**
 * Do upgrader screen: close site.
 *
 * @ignore
 * @return string Output messages
 */
function upgrader_close_site_screen()
{
    log_it('UPGRADER_CLOSE_SITE');

    set_option('closed', do_lang('UPGRADER_CLOSED_FOR_UPGRADES', get_site_name()));
    set_option('site_closed', '1');
    return '<p>' . do_lang('SUCCESS') . '</p>';
}

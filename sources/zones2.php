<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/**
 * Standard code module initialisation function.
 */
function init__zones2()
{
    global $CLASS_CACHE;
    $CLASS_CACHE = array();
}

/**
 * Render a Comcode page box.
 *
 * @param  array $row Row to render
 * @param  boolean $give_context Whether to include context (i.e. say WHAT this is, not just show the actual content)
 * @param  boolean $include_breadcrumbs Whether to include breadcrumbs (if there are any)
 * @param  ?ID_TEXT $root Virtual root to use (null: none)
 * @param  ID_TEXT $guid Overridden GUID to send to templates (blank: none)
 * @return tempcode Rendered box
 */
function render_comcode_page_box($row, $give_context = true, $include_breadcrumbs = true, $root = null, $guid = '')
{
    $map = array('page' => $row['the_page']);
    if (!is_null($root)) {
        $map['keep_page_root'] = $root;
    }
    $url = build_url($map, $row['the_zone']);

    $_summary = seo_meta_get_for('comcode_page', $row['the_zone'] . ':' . $row['the_page']);
    $summary = $_summary[1];

    if (get_option('is_on_comcode_page_cache') == '1') { // Try and force a parse of the page
        request_page($row['the_page'], false, $row['the_zone'], null, true);
    }

    $row2 = $GLOBALS['SITE_DB']->query_select('cached_comcode_pages', array('*'), array('the_zone' => $row['the_zone'], 'the_page' => $row['the_page']), '', 1);
    if (array_key_exists(0, $row2)) {
        $cc_page_title = get_translated_text($row2[0]['cc_page_title'], null, null, true);
        if (is_null($cc_page_title)) {
            $cc_page_title = '';
        }

        if ($summary == '') {
            $summary = get_translated_tempcode('zones', $row2[0], 'string_index');
        }
    } else {
        $cc_page_title = '';
    }

    $breadcrumbs = mixed();
    if ($include_breadcrumbs) {
        $breadcrumbs = breadcrumb_segments_to_tempcode(comcode_breadcrumbs($row['the_page'], $row['the_zone'], is_null($root) ? get_param_string('keep_page_root', null) : $root));
    }

    return do_template('COMCODE_PAGE_BOX', array(
        '_GUID' => ($guid != '') ? $guid : 'ac70e0b5a003f8dac1ff42f46af28e1d',
        'TITLE' => $cc_page_title,
        'PAGE' => $row['the_page'],
        'ZONE' => $row['the_zone'],
        'URL' => $url,
        'SUMMARY' => $summary,
        'BREADCRUMBS' => $breadcrumbs,
        'GIVE_CONTEXT' => $give_context,
    ));
}

/**
 * Add a zone.
 *
 * @param  ID_TEXT $zone Name of the zone
 * @param  SHORT_TEXT $title The zone title
 * @param  ID_TEXT $default_page The zones default page
 * @param  SHORT_TEXT $header_text The header text
 * @param  ID_TEXT $theme The theme
 * @param  BINARY $require_session Whether the zone requires a session for pages to be used
 * @param  boolean $uniqify Whether to force the name as unique, if there's a conflict
 * @param  string $base_url The base URL (blank: natural)
 * @return ID_TEXT The name
 */
function actual_add_zone($zone, $title, $default_page = 'start', $header_text = '', $theme = 'default', $require_session = 0, $uniqify = false, $base_url = '')
{
    require_code('type_sanitisation');
    if (!is_alphanumeric($zone, true)) {
        warn_exit(do_lang_tempcode('BAD_CODENAME'));
    }

    if (!is_null($GLOBALS['CURRENT_SHARE_USER'])) {
        warn_exit(do_lang_tempcode('SHARED_INSTALL_PROHIBIT'));
    }

    // Check doesn't already exist
    $test = $GLOBALS['SITE_DB']->query_select_value_if_there('zones', 'zone_header_text', array('zone_name' => $zone));
    if (!is_null($test)) {
        if (file_exists(get_file_base() . '/' . $zone)) { // Ok it's here completely, so we can't create
            if ($uniqify) {
                $zone .= '_' . uniqid('', true);
            } else {
                warn_exit(do_lang_tempcode('ALREADY_EXISTS', escape_html($zone)));
            }
        } else { // In DB, not on disk, so we'll just delete DB record
            persistent_cache_delete(array('ZONE', $zone));
            $GLOBALS['SITE_DB']->query_delete('zones', array('zone_name' => $zone), '', 1);
        }
    }

    require_code('abstract_file_manager');
    if (!file_exists(get_file_base() . '/' . $zone)) {
        // Create structure
        require_code('abstract_file_manager');
        afm_make_directory($zone . '/pages/minimodules_custom', true, true);
        afm_make_directory($zone . '/pages/minimodules', false, true);
        afm_make_directory($zone . '/pages/modules_custom', true, true);
        afm_make_directory($zone . '/pages/modules', false, true);
        $langs = array_keys(find_all_langs(true));
        foreach ($langs as $lang) {
            afm_make_directory($zone . '/pages/comcode_custom/' . $lang, true, true);
            afm_make_directory($zone . '/pages/comcode/' . $lang, false, true);
            afm_make_directory($zone . '/pages/html_custom/' . $lang, true, true);
            afm_make_directory($zone . '/pages/html/' . $lang, false, true);
        }
        afm_make_file($zone . '/index.php', file_get_contents(get_file_base() . '/adminzone/index.php'), false);
        if (file_exists(get_file_base() . '/pages' . DIRECTORY_SEPARATOR . '.htaccess')) {
            afm_make_file($zone . '/pages/.htaccess', file_get_contents(get_file_base() . '/pages' . DIRECTORY_SEPARATOR . '.htaccess'), false);
        }
        $index_php = array('pages/comcode', 'pages/comcode/EN', 'pages/comcode_custom', 'pages/comcode_custom/EN',
                           'pages/html', 'pages/html/EN', 'pages/html_custom', 'pages/html_custom/EN',
                           'pages/modules', 'pages/modules_custom', 'pages');
        foreach ($index_php as $i) {
            afm_make_file($zone . '/' . $i . '/index.html', '', false);
        }
        afm_make_file($zone . '/pages/comcode_custom/EN/panel_right.txt', '', true);
        $GLOBALS['SITE_DB']->query_insert('comcode_pages', array(
            'the_zone' => $zone,
            'the_page' => 'panel_right',
            'p_parent_page' => '',
            'p_validated' => 1,
            'p_edit_date' => null,
            'p_add_date' => time(),
            'p_submitter' => get_member(),
            'p_show_as_edit' => 0,
            'p_order' => 0,
        ));
    }

    afm_make_file($zone . '/pages/comcode_custom/EN/' . filter_naughty($default_page) . '.txt', '[title]' . do_lang('YOUR_NEW_ZONE') . '[/title]' . "\n\n" . do_lang('YOUR_NEW_ZONE_PAGE', $zone . ':' . $default_page) . "\n\n" . '[block]main_comcode_page_children[/block]', true);
    $GLOBALS['SITE_DB']->query_insert('comcode_pages', array(
        'the_zone' => $zone,
        'the_page' => $default_page,
        'p_parent_page' => '',
        'p_validated' => 1,
        'p_edit_date' => null,
        'p_add_date' => time(),
        'p_submitter' => get_member(),
        'p_show_as_edit' => 0,
        'p_order' => 0,
    ));

    $map = array(
        'zone_name' => $zone,
        'zone_default_page' => $default_page,
        'zone_theme' => $theme,
        'zone_require_session' => $require_session,
    );
    $map += insert_lang('zone_title', $title, 1);
    $map += insert_lang('zone_header_text', $header_text, 1);
    $GLOBALS['SITE_DB']->query_insert('zones', $map);

    persistent_cache_delete('ALL_ZONES');

    decache('menu');

    if ((addon_installed('commandr')) && (!running_script('install'))) {
        require_code('resource_fs');
        generate_resourcefs_moniker('zone', $zone, null, null, true);
    }

    save_zone_base_url($zone, $base_url);

    log_it('ADD_ZONE', $zone);

    return $zone;
}

/**
 * Save a zone base URL.
 *
 * @param  ID_TEXT $zone The zone
 * @param  string $base_url The base URL (blank: natural)
 */
function save_zone_base_url($zone, $base_url)
{
    $config_path = get_custom_file_base() . '/_config.php';
    $tmp = fopen($config_path, 'rb');
    @flock($tmp, LOCK_SH);
    $config_file = file_get_contents($config_path);
    @flock($tmp, LOCK_UN);
    fclose($tmp);
    $config_file_before = $config_file;
    $config_file = preg_replace('#\n?\$SITE_INFO[\'ZONE_MAPPING_' . preg_quote($zone, '#') . '\']=array\(\'[^\']+\',\'[^\']+\'\);\n?#', '', $config_file); // Strip any old entry
    if ($base_url != '') { // Add new entry, if appropriate
        if (url_is_local($base_url)) {
            $domain = cms_srv('HTTP_HOST');
            $path = $base_url;
        } else {
            $parsed = @parse_url($base_url);
            if ($parsed === false) {
                warn_exit(do_lang_tempcode('INVALID_ZONE_BASE_URL'));
            }
            $domain = $parsed['host'];
            $path = $parsed['path'];
        }
        $config_file .= "\n\$SITE_INFO['ZONE_MAPPING_" . addslashes($zone) . "']=array('" . addslashes($domain) . "','" . addslashes(trim($path, '/')) . "');\n";
    }

    if ($config_file != $config_file_before) {
        $out = @fopen($config_path, GOOGLE_APPENGINE ? 'wb' : 'ab');
        if ($out === false) {
            intelligent_write_error($config_path);
        }
        @flock($out, LOCK_EX);
        if (!GOOGLE_APPENGINE) {
            ftruncate($out, 0);
        }
        fwrite($out, $config_file);
        @flock($out, LOCK_UN);
        fclose($out);
        sync_file($path);
        fix_permissions($path);
    }
}

/**
 * Upgrade the specified module.
 *
 * @param  ID_TEXT $zone The zone name
 * @param  ID_TEXT $module The module name
 * @return integer 0=No upgrade. -2=Not installed, 1=Upgrade
 */
function upgrade_module($zone, $module)
{
    $rows = $GLOBALS['SITE_DB']->query_select('modules', array('*'), array('module_the_name' => $module), '', 1);
    if (!array_key_exists(0, $rows)) {
        return (-2); // Not installed, so can't upgrade
    }

    $upgrade_from = $rows[0]['module_version'];
    $upgrade_from_hack = $rows[0]['module_hack_version'];

    $module_path = get_file_base() . '/' . _get_module_path($zone, $module);

    $functions = extract_module_functions($module_path, array('info', 'install'), array($upgrade_from, $upgrade_from_hack));
    if ((is_null($functions[1])) && (strpos($module_path, '/modules_custom/') !== false)) {
        $functions = extract_module_functions($module_path, array('info', 'install'), array($upgrade_from, $upgrade_from_hack));
    }
    if (is_null($functions[0])) {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = true;
    } else {
        $info = is_array($functions[0]) ? call_user_func_array($functions[0][0], $functions[0][1]) : eval($functions[0]);
    }

    $ret = 0;
    if ((!is_null($functions[1])) && (array_key_exists('update_require_upgrade', $info))) {
        if ((($upgrade_from < $info['version']) && (array_key_exists('update_require_upgrade', $info)))
            || (($upgrade_from_hack < $info['hack_version']) && (array_key_exists('hack_require_upgrade', $info)))
        ) {
            require_code('database_action');
            require_code('config2');
            require_code('files2');

            if (is_array($functions[1])) {
                call_user_func_array($functions[1][0], $functions[1][1]);
            } else {
                eval($functions[1]);
            }
            $ret = 1;
        }
    }
    if (is_null($info['hacked_by'])) {
        $info['installed_hacked_by'] = '';
    }
    $GLOBALS['SITE_DB']->query_update('modules', array('module_version' => $info['version'], 'module_hack_version' => $info['hack_version'], 'module_hacked_by' => is_null($info['hacked_by']) ? '' : $info['hacked_by']), array('module_the_name' => $module), '', 1);
    persistent_cache_delete('MODULES');

    return $ret;
}

/**
 * Reinstall the specified module.
 *
 * @param  ID_TEXT $zone The zone name
 * @param  ID_TEXT $module The module name
 * @return boolean Whether a module installer had to be run
 */
function reinstall_module($zone, $module)
{
    $GLOBALS['NO_QUERY_LIMIT'] = true;

    $module_path = get_file_base() . '/' . _get_module_path($zone, $module);

    require_code('database_action');
    require_code('config2');
    require_code('files2');

    $GLOBALS['SITE_DB']->query_delete('modules', array('module_the_name' => $module), '', 1);

    $functions = extract_module_functions($module_path, array('info', 'install', 'uninstall'));
    if ((is_null($functions[1])) && (strpos($module_path, '/modules_custom/') !== false)) {
        $functions = extract_module_functions($module_path, array('info', 'install', 'uninstall'));
    }
    if (is_null($functions[0])) {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = true;
    } else {
        $info = is_array($functions[0]) ? call_user_func_array($functions[0][0], $functions[0][1]) : eval($functions[0]);
    }

    if (!is_null($functions[2])) {
        if (is_array($functions[2])) {
            call_user_func_array($functions[2][0], $functions[2][1]);
        } else {
            eval($functions[2]);
        }
    }
    if (is_null($info)) {
        return false;
    }
    if (is_null($info['hacked_by'])) {
        $info['hacked_by'] = '';
    }
    if (!is_null($functions[1])) {
        if (is_array($functions[1])) {
            call_user_func_array($functions[1][0], $functions[1][1]);
        } else {
            eval($functions[1]);
        }
    }
    $GLOBALS['SITE_DB']->query_insert('modules', array('module_the_name' => $module, 'module_author' => $info['author'], 'module_organisation' => $info['organisation'], 'module_hacked_by' => is_null($info['hacked_by']) ? '' : $info['hacked_by'], 'module_hack_version' => $info['hack_version'], 'module_version' => $info['version']));

    persistent_cache_delete('MODULES');

    return (!is_null($functions[1]));
}

/**
 * Completely uninstall the specified module from the system.
 *
 * @param  ID_TEXT $zone The zone name
 * @param  ID_TEXT $module The module name
 */
function uninstall_module($zone, $module)
{
    $module_path = get_file_base() . '/' . _get_module_path($zone, $module);

    require_code('database_action');
    require_code('config2');
    require_code('files2');

    $GLOBALS['SITE_DB']->query_delete('modules', array('module_the_name' => $module), '', 1);
    $GLOBALS['SITE_DB']->query_delete('group_page_access', array('page_name' => $module)); // As some modules will try and install this themselves. Entry point permissions they won't.
    $GLOBALS['SITE_DB']->query_delete('group_privileges', array('the_page' => $module)); // Ditto

    persistent_cache_delete('MODULES');

    if (file_exists($module_path)) {
        $functions = extract_module_functions($module_path, array('uninstall'));
        if ((is_null($functions[0])) && (strpos($module_path, '/modules_custom/') !== false)) {
            $functions = extract_module_functions($module_path, array('uninstall'));
        }
        if (is_null($functions[0])) {
            return;
        }

        if (is_array($functions[0])) {
            call_user_func_array($functions[0][0], $functions[0][1]);
        } else {
            eval($functions[0]);
        }
    }
}

/**
 * Get an array of all the blocks that are currently installed (miniblocks not included).
 *
 * @return array Map of all blocks (name->[sources/sources_custom])
 */
function find_all_blocks()
{
    $out = array();

    $dh = opendir(get_file_base() . '/sources/blocks');
    while (($file = readdir($dh)) !== false) {
        if ((substr($file, -4) == '.php') && (preg_match('#^[\w\-]*$#', substr($file, 0, strlen($file) - 4)) != 0)) {
            $out[substr($file, 0, strlen($file) - 4)] = 'sources';
        }
    }
    closedir($dh);
    if (!in_safe_mode()) {
        $dh = @opendir(get_file_base() . '/sources_custom/blocks');
        if ($dh !== false) {
            while (($file = readdir($dh)) !== false) {
                if ((substr($file, -4) == '.php') && (preg_match('#^[\w\-]*$#', substr($file, 0, strlen($file) - 4)) != 0)) {
                    $out[substr($file, 0, strlen($file) - 4)] = 'sources_custom';
                }
            }
            closedir($dh);
        }
    }

    return $out;
}

/**
 * Make a block codename look nice
 *
 * @param  ID_TEXT $block The raw block codename
 * @return string A nice human readable version of the name
 */
function cleanup_block_name($block)
{
    $title = do_lang('BLOCK_TRANS_NAME_' . $block, null, null, null, null, false);
    if (!is_null($title)) {
        return $title;
    }

    $block = str_replace('_cns_', '_', $block);
    return titleify(str_replace('block_bottom_', 'Bottom: ', str_replace('block_side_', 'Side: ', str_replace('block_main_', 'Main: ', $block))));
}

/**
 * Gets parameters for a block
 *
 * @param  ID_TEXT $block The name of the block to get parameters for
 * @return array A list of parameters the block takes
 */
function get_block_parameters($block)
{
    $block_path = _get_block_path($block);
    $info = extract_module_info($block_path);
    if (is_null($info)) {
        return array();
    }

    $ret = array_key_exists('parameters', $info) ? $info['parameters'] : array();
    if (is_null($ret)) {
        return array();
    }
    return $ret;
}

/**
 * Upgrades a block to the latest version available on your Composr installation. [b]This function can only upgrade to the latest version put into the block directory.[/b] You should not need to use this function.
 *
 * @param  ID_TEXT $block The name of the block to upgrade
 * @return integer 0=No upgrade. -2=Not installed, 1=Upgrade
 */
function upgrade_block($block)
{
    $rows = $GLOBALS['SITE_DB']->query_select('blocks', array('*'), array('block_name' => $block), '', 1);
    if (!array_key_exists(0, $rows)) {
        return (-2); // Not installed, so can't upgrade
    }

    $upgrade_from = $rows[0]['block_version'];
    $upgrade_from_hack = $rows[0]['block_hack_version'];

    $block_path = _get_block_path($block);

    $functions = extract_module_functions($block_path, array('info', 'install'), array($upgrade_from, $upgrade_from_hack));
    if (is_null($functions[0])) {
        return 0;
    }

    $info = is_array($functions[0]) ? call_user_func_array($functions[0][0], $functions[0][1]) : eval($functions[0]);
    if ((!is_null($functions[1])) && (array_key_exists('update_require_upgrade', $info))) {
        if ((($upgrade_from < $info['version']) && (array_key_exists('update_require_upgrade', $info)))
            || (($upgrade_from_hack < $info['hack_version']) && (array_key_exists('hack_require_upgrade', $info)))
        ) {
            require_code('database_action');
            require_code('config2');
            require_code('files2');

            if (is_array($functions[1])) {
                call_user_func_array($functions[1][0], $functions[1][1]);
            } else {
                eval($functions[1]);
            }
            if (is_null($info['hacked_by'])) {
                $info['installed_hacked_by'] = '';
            }
            $GLOBALS['SITE_DB']->query_update('blocks', array('block_version' => $info['version'], 'block_hack_version' => $info['hack_version'], 'block_hacked_by' => is_null($info['hacked_by']) ? '' : $info['hacked_by']), array('block_name' => $block), '', 1);
            return 1;
        }
    }
    return 0;
}

/**
 * Reinstall a block if it has become corrupted for any reason.
 * Again, you should not need to use this function.
 *
 * @param  ID_TEXT $block The name of the block to reinstall
 * @return boolean Whether installation was required
 */
function reinstall_block($block)
{
    $block_path = _get_block_path($block);

    $GLOBALS['SITE_DB']->query_delete('blocks', array('block_name' => $block), '', 1);

    require_code('database_action');
    require_code('config2');
    require_code('files2');

    $functions = extract_module_functions($block_path, array('info', 'install', 'uninstall'));
    if (is_null($functions[0])) {
        return false;
    }

    if (!is_null($functions[2])) {
        if (is_array($functions[2])) {
            call_user_func_array($functions[2][0], $functions[2][1]);
        } else {
            eval($functions[2]);
        }
    }
    $info = is_array($functions[0]) ? call_user_func_array($functions[0][0], $functions[0][1]) : eval($functions[0]);
    if (is_null($info)) {
        return false;
    }
    if (is_null($info['hacked_by'])) {
        $info['hacked_by'] = '';
    }

    $GLOBALS['SITE_DB']->query_insert('blocks', array('block_name' => $block, 'block_author' => $info['author'], 'block_organisation' => $info['organisation'], 'block_hacked_by' => is_null($info['hacked_by']) ? '' : $info['hacked_by'], 'block_hack_version' => $info['hack_version'], 'block_version' => $info['version']));
    if (!is_null($functions[1])) {
        if (is_array($functions[1])) {
            call_user_func_array($functions[1][0], $functions[1][1]);
        } else {
            eval($functions[1]);
        }
        return true;
    }
    return false;
}

/**
 * This function totally uninstalls a block from the system. Yet again, you should not need to use this function.
 *
 * @param  ID_TEXT $block The name of the block to uninstall
 */
function uninstall_block($block)
{
    $block_path = _get_block_path($block);

    require_code('database_action');
    require_code('config2');
    require_code('files2');

    $GLOBALS['SITE_DB']->query_delete('blocks', array('block_name' => $block), '', 1);
    $GLOBALS['SITE_DB']->query_delete('cache_on', array('cached_for' => $block), '', 1);
    $GLOBALS['SITE_DB']->query_delete('cache', array('cached_for' => $block));

    if (file_exists($block_path)) {
        $functions = extract_module_functions($block_path, array('uninstall'));
        if (is_null($functions[0])) {
            return;
        }

        if (is_array($functions[0])) {
            call_user_func_array($functions[0][0], $functions[0][1]);
        } else {
            eval($functions[0]);
        }
    }
}

/**
 * Extract code to execute the requested functions with the requested parameters from the module requested.
 * If it's not a module, returns an empty array.
 *
 * @param  ID_TEXT $zone The zone it is in
 * @param  ID_TEXT $page The page name
 * @param  array $functions Array of functions to be executing
 * @param  ?array $params A list of parameters to pass to our functions (null: none)
 * @return array A list of pieces of code to do the equivalent of executing the requested functions with the requested parameters
 */
function extract_module_functions_page($zone, $page, $functions, $params = null)
{
    $path = zone_black_magic_filterer(get_file_base() . '/' . filter_naughty_harsh($zone) . (($zone == '') ? '' : '/') . 'pages/modules_custom/' . filter_naughty_harsh($page) . '.php');
    if (file_exists($path)) {
        $ret = extract_module_functions($path, $functions, $params);
        if (array_unique(array_values($ret)) != array(null)) {
            return $ret;
        }
    }

    $path = zone_black_magic_filterer(get_file_base() . '/' . filter_naughty_harsh($zone) . (($zone == '') ? '' : '/') . 'pages/modules/' . filter_naughty_harsh($page) . '.php');
    if (!file_exists($path)) {
        $ret = array();
        for ($i = 0; $i < count($functions); $i++) {
            array_push($ret, null);
        }
        return $ret;
    }
    return extract_module_functions($path, $functions, $params);
}

/**
 * Extract the info function from a module at a given path.
 *
 * @param  PATH $path The path to the module
 * @return ?array A module information map (null: module contains no info method)
 */
function extract_module_info($path)
{
    $functions = extract_module_functions($path, array('info'));
    if (is_null($functions[0])) {
        return null;
    }
    return is_array($functions[0]) ? call_user_func_array($functions[0][0], $functions[0][1]) : eval($functions[0]);
}

/**
 * Get an array of all the pages everywhere in the zone (for small sites everything will be returned, for larger ones it depends on the show method).
 *
 * @param  ID_TEXT $zone The zone name
 * @param  boolean $keep_ext_on Whether to leave file extensions on the page name
 * @param  boolean $consider_redirects Whether to take transparent redirects into account
 * @param  integer $show_method Selection algorithm constant
 * @set 0 1 2
 * @param  ?ID_TEXT $page_type Page type to show (null: all)
 * @return array A map of page name to type (modules_custom, etc)
 */
function _find_all_pages_wrap($zone, $keep_ext_on = false, $consider_redirects = false, $show_method = 0, $page_type = null)
{
    $pages = array();
    if ((is_null($page_type)) || ($page_type == 'modules')) {
        if (!in_safe_mode()) {
            $pages += find_all_pages($zone, 'modules_custom', 'php', $keep_ext_on, null, $show_method);
        }
        $pages += find_all_pages($zone, 'modules', 'php', $keep_ext_on, null, $show_method);
    }
    $langs = multi_lang() ? array_keys(find_all_langs()) : array(get_site_default_lang());
    foreach ($langs as $lang) {
        if ((is_null($page_type)) || ($page_type == 'comcode')) {
            if (!in_safe_mode()) {
                $pages += find_all_pages($zone, 'comcode_custom/' . $lang, 'txt', $keep_ext_on, null, $show_method);
            }
            $pages += find_all_pages($zone, 'comcode/' . $lang, 'txt', $keep_ext_on, null, $show_method);
        }
        if ((is_null($page_type)) || ($page_type == 'html')) {
            if (!in_safe_mode()) {
                $pages += find_all_pages($zone, 'html_custom/' . $lang, 'htm', $keep_ext_on, null, $show_method);
            }
            $pages += find_all_pages($zone, 'html/' . $lang, 'htm', $keep_ext_on, null, $show_method);
        }
    }
    if ((is_null($page_type)) || ($page_type == 'minimodules')) {
        if (!in_safe_mode()) {
            $pages += find_all_pages($zone, 'minimodules_custom', 'php', $keep_ext_on, null, $show_method);
        }
        $pages += find_all_pages($zone, 'minimodules', 'php', $keep_ext_on, null, $show_method);
    }

    if (addon_installed('redirects_editor')) {
        if ($consider_redirects) {
            $redirects = $GLOBALS['SITE_DB']->query_select('redirects', array('*'), array('r_from_zone' => $zone));
            foreach ($redirects as $r) {
                if ($r['r_is_transparent'] == 0) {
                    //unset($pages[$r['r_from_page']]); // We don't want to link to anything that is a full redirect    -  Actually, we don't want to hide things too much, could be confusing
                } else {
                    $pages[$r['r_from_page']] = 'redirect:' . $r['r_to_zone'] . ':' . $r['r_to_page'];
                }
            }
        }
    }

    return $pages;
}

/**
 * Get an array of all the pages of the specified type (module, etc) and extension (for small sites everything will be returned, for larger ones it depends on the show method).
 *
 * @param  ID_TEXT $zone The zone name
 * @param  ID_TEXT $type The type (including language, if appropriate)
 * @set    modules modules_custom comcode/EN comcode_custom/EN html/EN html_custom/EN
 * @param  string $ext The file extension to limit us to (without a dot)
 * @param  boolean $keep_ext_on Whether to leave file extensions on the page name
 * @param  ?TIME $cutoff_time Only show pages newer than (null: no restriction)
 * @param  integer $show_method Selection algorithm constant
 * @set 0 1 2
 * @param  ?boolean $custom Whether to search under the custom-file-base (null: auto-decide)
 * @return array A map of page name to type (modules_custom, etc)
 */
function _find_all_pages($zone, $type, $ext = 'php', $keep_ext_on = false, $cutoff_time = null, $show_method = 0, $custom = null)
{
    $out = array();

    $module_path = ($zone == '') ? ('pages/' . filter_naughty($type)) : (filter_naughty($zone) . '/pages/' . filter_naughty($type));

    if (is_null($custom)) {
        $custom = ((strpos($type, 'comcode_custom') !== false) || (strpos($type, 'html_custom') !== false));
        if (($custom) && (get_custom_file_base() != get_file_base())) {
            $out = _find_all_pages($zone, $type, $ext, false, null, $show_method, false);
        }
    }
    $stub = $custom ? get_custom_file_base() : get_file_base();
    $dh = @opendir($stub . '/' . $module_path);
    if ($dh !== false) {
        while (($file = readdir($dh)) !== false) {
            if ((substr($file, -4) == '.' . $ext) && (file_exists($stub . '/' . $module_path . '/' . $file)) && (preg_match('#^[^\.][\w\-]*$#', substr($file, 0, strlen($file) - 4)) != 0)) {
                if (!is_null($cutoff_time)) {
                    if (filectime($stub . '/' . $module_path . '/' . $file) < $cutoff_time) {
                        continue;
                    }
                }

                if ($ext == 'txt') {
                    switch ($show_method) {
                        case FIND_ALL_PAGES__NEWEST: // Only gets newest if it's a large site
                            if (count($out) > 300) {
                                $out = array();
                                $records = $GLOBALS['SITE_DB']->query_select('comcode_pages', array('the_page'), array('the_zone' => $zone), 'ORDER BY p_add_date DESC', 300);
                                foreach ($records as $record) {
                                    $file = $record['the_page'] . '.txt';

                                    if (!file_exists($stub . '/' . $module_path . '/' . $file)) {
                                        continue;
                                    }

                                    if (!is_null($cutoff_time)) {
                                        if (filectime($stub . '/' . $module_path . '/' . $file) < $cutoff_time) {
                                            continue;
                                        }
                                    }

                                    $out[$keep_ext_on ? $file : substr($file, 0, strlen($file) - 4)] = $type;
                                }
                            } else {
                                break;
                            }
                        //break; Actually, no, let it roll on to the next one to get key files too

                        case FIND_ALL_PAGES__PERFORMANT: // Default, chooses selection carefully based on site size
                            if (($show_method == FIND_ALL_PAGES__NEWEST) || (count($out) > 300)) {
                                if ($show_method != FIND_ALL_PAGES__NEWEST) {
                                    $out = array();
                                }
                                $records = $GLOBALS['SITE_DB']->query('SELECT the_page FROM ' . get_table_prefix() . 'comcode_pages WHERE ' . db_string_equal_to('the_zone', $zone) . ' AND (' . db_string_equal_to('the_page', get_zone_default_page($zone)) . ' OR the_page LIKE \'' . db_encode_like('panel\_%') . '\') ORDER BY p_add_date DESC');
                                foreach ($records as $record) {
                                    $file = $record['the_page'] . '.txt';

                                    if (!file_exists($stub . '/' . $module_path . '/' . $file)) {
                                        continue;
                                    }

                                    if (!is_null($cutoff_time)) {
                                        if (filectime($stub . '/' . $module_path . '/' . $file) < $cutoff_time) {
                                            continue;
                                        }
                                    }

                                    $out[$keep_ext_on ? $file : substr($file, 0, strlen($file) - 4)] = $type;
                                }
                                break 2;
                            }
                            break;

                        case FIND_ALL_PAGES__ALL: // Nothing special
                            break;
                    }
                }

                $out[$keep_ext_on ? $file : substr($file, 0, strlen($file) - 4)] = $type;
            }
        }
        closedir($dh);
    }

    if (($zone == '') && (get_option('collapse_user_zones') == '1')) {
        $out += _find_all_pages('site', $type, $ext, $keep_ext_on);
    }

    ksort($out);
    return $out;
}

/**
 * Get an array of all the modules.
 *
 * @param  ID_TEXT $zone The zone name
 * @return array A map of page name to type (modules_custom, etc)
 */
function _find_all_modules($zone)
{
    if (in_safe_mode()) {
        return find_all_pages($zone, 'modules');
    }
    return find_all_pages($zone, 'modules') + find_all_pages($zone, 'modules_custom');
}

/**
 * Update the .htaccess file with the latest zone names.
 */
function sync_htaccess_with_zones()
{
    $url_scheme = get_option('url_scheme');
    $change_htaccess = (($url_scheme == 'HTM') || ($url_scheme == 'SIMPLE'));
    $htaccess_path = get_file_base() . '/.htaccess';
    if (($change_htaccess) && (file_exists($htaccess_path)) && (is_writable_wrap($htaccess_path))) {
        $zones = find_all_zones();

        $htaccess = file_get_contents($htaccess_path);
        $htaccess = preg_replace('#\(site[^\)]*#', '(' . implode('|', $zones), $htaccess);
        $myfile = fopen($htaccess_path, GOOGLE_APPENGINE ? 'wb' : 'wt');
        fwrite($myfile, $htaccess);
        fclose($myfile);
        fix_permissions($htaccess_path);
        sync_file($htaccess_path);
    }
}

/**
 * Check a zone name doesn't conflict, according to our URL scheme.
 *
 * @param  ID_TEXT $zone The zone name
 */
function check_zone_name($zone)
{
    $url_scheme = get_option('url_scheme');
    if (($url_scheme == 'SIMPLE') || ($url_scheme == 'HTM')) {
        if ($url_scheme == 'SIMPLE') {
            // No naming a zone the same as a root directory (a std dir)
            if ((file_exists(get_file_base() . '/' . $zone)) || (file_exists(get_custom_file_base() . '/' . $zone))) {
                require_lang('zones');
                warn_exit(do_lang_tempcode('CONFLICTING_ZONE_NAME'));
            }
        }

        // No naming a zone the same as a welcome zone page
        if (_request_page($zone, '') !== false) {
            require_lang('zones');
            warn_exit(do_lang_tempcode('CONFLICTING_ZONE_NAME__PAGE'));
        }
    }
}

/**
 * Check a page name doesn't conflict, according to our URL scheme.
 *
 * @param  ID_TEXT $zone The zone name
 * @param  ID_TEXT $page The page name
 */
function check_page_name($zone, $page)
{
    if ($zone == '') {
        $url_scheme = get_option('url_scheme');
        if ($url_scheme == 'SIMPLE') {
            // No naming a welcome zone page the same as a root directory (be it a std dir or a zone name)
            if ((file_exists(get_file_base() . '/' . $page)) || (file_exists(get_custom_file_base() . '/' . $page))) {
                require_lang('zones');
                warn_exit(do_lang_tempcode('CONFLICTING_PAGE_NAME'));
            }
        }
        if ($url_scheme == 'HTM') {
            // No naming a welcome zone page the same as a zone
            if ((file_exists(get_file_base() . '/' . $page . '/index.php')) || (file_exists(get_custom_file_base() . '/' . $page . '/index.php'))) {
                require_lang('zones');
                warn_exit(do_lang_tempcode('CONFLICTING_PAGE_NAME'));
            }
        }
    }
}

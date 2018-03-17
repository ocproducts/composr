<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


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
 * Special code to render Admin Zone Comcode pages with special significances.
 *
 * @param  ID_TEXT $codename The page being loaded
 */
function adminzone_special_cases($codename)
{
    /*
    The current design does not require these, but this code may be useful in the future.
    If we put it back, we should do it with hooks, for proper modularity.

    if (($codename == DEFAULT_ZONE_PAGE_NAME) && (get_page_name() == DEFAULT_ZONE_PAGE_NAME) && (get_option('show_docs') !== '0')) {
        require_lang('menus');
        set_helper_panel_text(comcode_lang_string('menus:DOC_ADMIN_ZONE'));
        set_helper_panel_tutorial('tut_adminzone');
    } elseif (($codename == 'netlink') && (get_page_name() == 'netlink')) {
        set_helper_panel_text(comcode_lang_string('menus:DOC_NETLINK'));
        set_helper_panel_tutorial('tut_msn');
    }
    */
}

/**
 * Get extended breadcrumbs for the Admin Zone (called by breadcrumbs_get_default_stub).
 *
 * @return array Extra breadcrumbs
 */
function adminzone_extended_breadcrumbs()
{
    global $BREADCRUMB_SET_PARENTS, $SMART_CACHE;

    $breadcrumbs = array();

    $link = $SMART_CACHE->get('extended_breadcrumbs');
    if ($link !== null) {
        list($link_map, $link_zone, $link_lang) = $link;

        if ($link_lang !== null) {
            $title = do_lang_tempcode($link_lang); // The language string ID version of the page grouping we found our current module was in
            $page_link = build_page_link($link_map, $link_zone);
            $breadcrumbs[] = array($page_link, $title);
        }

        return $breadcrumbs;
    }

    if ((count($BREADCRUMB_SET_PARENTS) > 0) && (!is_object($BREADCRUMB_SET_PARENTS[0][0]))) { // Ideally
        // Works by finding where our oldest ancestor connects on to the do-next menus, and carries from there
        list($zone, $attributes,) = page_link_decode($BREADCRUMB_SET_PARENTS[0][0]);
        $type = array_key_exists('type', $attributes) ? $attributes['type'] : 'browse';
        $page = $attributes['page'];
        if ($page == '_SELF') {
            $page = get_page_name();
        }
        if ($zone == '_SEARCH') {
            $zone = get_module_zone($page);
        }
        if ($zone == '_SELF') {
            $zone = get_zone_name();
        }
    } else {
        // Works by finding where we connect on to the do-next menus, and carries from there
        $type = get_param_string('type', 'browse');
        $page = get_page_name();
        $zone = get_zone_name();
    }

    if (($page != 'admin') && ($page != 'cms')) {
        require_lang('menus');

        // Loop over menus, hunting for connection
        $hooks = find_all_hooks('systems', 'page_groupings');
        $_hooks = array();
        $page_looking = $page;
        $page_looking = preg_replace('#^(cms|admin)_#', '', $page_looking);
        if (array_key_exists($page_looking, $hooks)) {
            $_hooks[$page_looking] = $hooks[$page_looking];
            unset($hooks[$page_looking]);
            $hooks = array_merge($_hooks, $hooks);
        }
        foreach ($hooks as $hook => $sources_dir) {
            $path = get_file_base() . '/' . $sources_dir . '/hooks/systems/page_groupings/' . $hook . '.php';
            $run_function = extract_module_functions($path, array('run'));
            if ($run_function[0] !== null) {
                $info = is_array($run_function[0]) ? call_user_func_array($run_function[0][0], $run_function[0][1]) : cms_eval($run_function[0], $path);

                foreach ($info as $i) {
                    if ($i === null) {
                        continue;
                    }

                    if ((is_array($i[2])) && ($page == $i[2][0]) && ($i[0] != '') && (((!isset($i[2][1]['type'])) && ($type == 'browse')) || ((isset($i[2][1]['type'])) && (($type == $i[2][1]['type']) || ($i[2][1]['type'] == 'browse')))) && ($zone == $i[2][2])) {
                        if ($i[0] == 'cms') {
                            $link_zone = 'cms';
                            $link_map = array('page' => 'cms', 'type' => ($i[0] == 'cms') ? null : $i[0]);
                        } else {
                            $link_zone = 'adminzone';
                            $link_map = array('page' => 'admin', 'type' => $i[0]);
                        }
                        $link_lang = 'menus:' . strtoupper($i[0]);

                        $SMART_CACHE->set('extended_breadcrumbs', array($link_map, $link_zone, $link_lang));

                        $title = do_lang_tempcode($link_lang); // The language string ID version of the page grouping we found our current module was in
                        $page_link = build_page_link($link_map, $link_zone);
                        $breadcrumbs[] = array($page_link, $title);

                        return $breadcrumbs;
                    }
                }
            }
        }
    }

    $SMART_CACHE->set('extended_breadcrumbs', array(null, null, null));

    return $breadcrumbs;
}

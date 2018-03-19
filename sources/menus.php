<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_menus
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__menus()
{
    if (!defined('INCLUDE_SITEMAP_NO')) {
        define('INCLUDE_SITEMAP_NO', 0);
        define('INCLUDE_SITEMAP_OVER', 1);
        define('INCLUDE_SITEMAP_UNDER', 2);
    }
}

/**
 * Take a menu identifier, and return a menu created from it.
 *
 * @param  ID_TEXT $type The type of the menu (determines which templates to use)
 * @param  SHORT_TEXT $menu The menu identifier to use (may be the name of a editable menu, or syntax to load from the Sitemap)
 * @param  boolean $silent_failure Whether to silently return blank if the menu does not exist
 * @param  boolean $apply_highlighting Whether to apply current-screen highlighting
 * @return array A pair: The generated Tempcode of the menu, the menu nodes
 */
function build_menu($type, $menu, $silent_failure = false, $apply_highlighting = true)
{
    $is_sitemap_menu = (preg_match('#^[' . URL_CONTENT_REGEXP . ']+$#', $menu) == 0);

    if ($is_sitemap_menu) {
        $root = _build_sitemap_menu($menu);

        if ($root === null) {
            return array(new Tempcode(), array());
        }
    } else {
        $root = _build_stored_menu($menu);

        // Empty?
        if (count($root['children']) == 0) {
            if ($silent_failure) {
                return array(new Tempcode(), array());
            }

            $redirect = get_self_url(true, true);
            $_add_url = build_url(array('page' => 'admin_menus', 'type' => 'edit', 'id' => $menu, 'menu_type' => $type, 'redirect' => $redirect), 'adminzone');
            $add_url = $_add_url->evaluate();

            $content = do_template('INLINE_WIP_MESSAGE', array('_GUID' => '276e6600571b8b4717ca742b6e9da17a', 'MESSAGE' => do_lang_tempcode('MISSING_MENU', escape_html($menu), escape_html($add_url))));
            return array($content, array());
        }
    }

    // Render
    $content = _render_menu($root, null, $type, true, $apply_highlighting);

    $content->handle_symbol_preprocessing(); // Optimisation: we are likely to have lots of page-links in here, so we want to spawn them to be detected for mass moniker loading

    if (strpos(serialize($root), 'keep_') === false) {/*Will only work if there are no keep_ parameters within the menu itself, as the quick caching will get confused by that*/
        $content = apply_quick_caching($content);
    }

    // Edit link
    if (((!$is_sitemap_menu) || ($menu == get_option('header_menu_call_string'))) && (has_actual_page_access(get_member(), 'admin_menus'))) {
        // We have to build up URL using Tempcode as it needs SELF_URL nested as unevaluated Tempcode, for cache-safety
        $page_link = get_module_zone('admin_menus') . ':admin_menus:edit';
        if (!$is_sitemap_menu) {
            $page_link .= ':' . $root['content_id'];
        }
        $page_link .= ':clickable_sections=' . strval((($type == 'popup') || ($type == 'dropdown')) ? 1 : 0);
        $page_link .= ':menu_type=' . urlencode($type);
        $page_link .= ':redirect=';
        $_page_link = make_string_tempcode($page_link);
        $self_url = symbol_tempcode('SELF_URL', array('1'));
        $self_url = build_closure_tempcode(TC_LANGUAGE_REFERENCE, 'dont_escape_trick', array($self_url), array(UL_ESCAPED));
        $_page_link->attach($self_url);

        $url = symbol_tempcode('PAGE_LINK', array($_page_link, '0', '0', '0'));

        $_content = new Tempcode(); // Done to preserve tree structure, special_page_type=tree
        $_content->attach($content);
        $_content->attach(do_template('MENU_STAFF_LINK', array(
            '_GUID' => 'a5209ec65425bed1207e2f667d9116f6',
            'TYPE' => $type,
            'EDIT_URL' => $url,
            'NAME' => $is_sitemap_menu ? '' : $menu,
        )));
        $content = $_content;
    }

    return array($content, $root);
}

/**
 * Take a menu identifier, and return the editable menu.
 *
 * @param  SHORT_TEXT $menu The menu identifier to use (the name of a editable menu)
 * @return array The menu branch structure
 *
 * @ignore
 */
function _build_stored_menu($menu)
{
    // Load items
    $root = persistent_cache_get(array('MENU', $menu));
    if ($root === null) {
        $items = $GLOBALS['SITE_DB']->query_select('menu_items', array('*'), array('i_menu' => $menu), 'ORDER BY i_order');

        // Search for top-level items, to build root branch
        $root = _get_menu_root_wrapper();
        $root['content_id'] = $menu;
        foreach ($items as $item) {
            if ($item['i_parent'] === null) {
                $root['children'] = array_merge($root['children'], _build_stored_menu_branch($item, $items));
            }
        }

        persistent_cache_set(array('MENU', $menu, user_lang()), $root);
    }
    return $root;
}

/**
 * Take a menu identifier, and return a Sitemap-based menu created from it.
 *
 * @param  SHORT_TEXT $menu The menu identifier to use (syntax to load from the Sitemap)
 * @return array The Sitemap node structure (called a 'branch structure' for menus)
 * @ignore
 */
function _build_sitemap_menu($menu)
{
    static $cache = array();
    if (isset($cache[$menu])) {
        return $cache[$menu];
    }

    require_code('sitemap');

    $root = _get_menu_root_wrapper();

    $nodes = explode(' + ', $menu);
    foreach ($nodes as $_node) {
        // Default call options
        $page_link = '';
        $valid_node_types = null;
        $child_cutoff = 50;
        $max_recurse_depth = null;
        $options = SITEMAP_GEN_CHECK_PERMS;
        $include = 'children';
        $title = mixed();
        $icon = mixed();

        // Parse options
        if ($menu != '') {
            $bits = explode(',', $_node);
            $page_link = array_shift($bits);
            foreach ($bits as $bit) {
                $bit_parts = explode('=', $bit, 2);
                if (isset($bit_parts[1])) {
                    $setting = $bit_parts[1];
                    switch ($bit_parts[0]) {
                        case 'valid_node_types':
                            $valid_node_types = explode('|', $setting);
                            break;

                        case 'child_cutoff':
                            $child_cutoff = ($setting == '') ? null : intval($setting);
                            break;

                        case 'max_recurse_depth':
                            $max_recurse_depth = ($setting == '') ? null : intval($setting);
                            break;

                        case 'use_page_groupings':
                            if ($setting == '1') {
                                $options |= SITEMAP_GEN_USE_PAGE_GROUPINGS;
                            }
                            break;

                        case 'consider_secondary_categories':
                            if ($setting == '1') {
                                $options |= SITEMAP_GEN_CONSIDER_SECONDARY_CATEGORIES;
                            }
                            break;

                        case 'consider_validation':
                            if ($setting == '1') {
                                $options |= SITEMAP_GEN_CONSIDER_VALIDATION;
                            }
                            break;

                        case 'collapse_zones':
                            if ($setting == '1') {
                                $options |= SITEMAP_GEN_COLLAPSE_ZONES;
                            }
                            break;

                        case 'include':
                            $include = $setting;
                            break;

                        case 'title':
                            $title = $setting;
                            break;

                        case 'icon':
                            $icon = $setting;
                            break;
                    }
                }
            }
        }

        $node = retrieve_sitemap_node(
            $page_link,
            /*$callback=*/
            null,
            $valid_node_types,
            $child_cutoff,
            $max_recurse_depth,
            /*$options=*/
            $options,
            /*$zone=*/
            '_SEARCH',
            SITEMAP_GATHER_DESCRIPTION | SITEMAP_GATHER_IMAGE
        );

        if ($node === null) {
            continue;
        }

        if ($title !== null) {
            $node['title'] = comcode_to_tempcode($title);
        }

        if ($icon !== null) {
            if (find_theme_image('icons/24x24/' . $icon, true) == '' && find_theme_image('icons/32x32/' . $icon, true) != '') {
                $node['extra_meta']['image'] = find_theme_image('icons/32x32/' . $icon);
                $node['extra_meta']['image_2x'] = '';
            } else {
                $node['extra_meta']['image'] = find_theme_image('icons/24x24/' . $icon);
                $node['extra_meta']['image_2x'] = find_theme_image('icons/48x48/' . $icon);
            }
        }

        switch ($include) {
            case 'children':
                $root['children'] = array_merge($root['children'], $node['children']);
                break;

            case 'node':
                $root['children'][] = $node;
                break;
        }
    }

    $cache[$menu] = $root;

    return $root;
}

/**
 * Get root branch (an empty shell).
 *
 * @return array The root branch
 *
 * @ignore
 */
function _get_menu_root_wrapper()
{
    return array(
        'title' => '',
        'content_type' => 'root',
        'content_id' => null,
        'modifiers' => array(),
        'only_on_page' => '',
        'page_link' => null,
        'url' => null,
        'extra_meta' => array(
            'description' => null,
            'image' => null,
            'image_2x' => null,
        ),
        'has_possible_children' => true,
        'children' => array(),
    );
}

/**
 * Build a menu branch map from a database row.
 *
 * @param  array $item The database row
 * @param  array $items List of all the database rows for this menu
 * @return array A list of menu branches
 *
 * @ignore
 */
function _build_stored_menu_branch($item, $items)
{
    $is_page_link = !looks_like_url($item['i_url']);

    $title = get_translated_tempcode('menu_items', $item, 'i_caption');

    $modifiers = array();
    if ($item['i_new_window'] == 1) {
        $modifiers['new_window'] = true;
    }
    if ($item['i_check_permissions'] == 1) {
        $modifiers['check_perms'] = true;
    }
    if ($item['i_expanded'] == 1) {
        $modifiers['expanded'] = 1;
    }

    $branch = array(
        'title' => $title,
        'content_type' => ($title->is_empty()) ? 'spacer' : 'stored_branch',
        'content_id' => null,
        'modifiers' => $modifiers,
        'only_on_page' => $item['i_page_only'],
        'page_link' => $is_page_link ? $item['i_url'] : null,
        'url' => $is_page_link ? null : $item['i_url'],
        'extra_meta' => array(
            'description' => get_translated_tempcode('menu_items', $item, 'i_caption_long'),
            'image' => ($item['i_theme_img_code'] == '') ? null : find_theme_image($item['i_theme_img_code']),
            'image_2x' => ($item['i_theme_img_code'] == '') ? null : str_replace(array('/1x/', '/24x24/'), array('/2x/', '/48x48/'), find_theme_image($item['i_theme_img_code'])),
        ),
        'has_possible_children' => true,
        'children' => array(),
    );

    foreach ($items as $_item) {
        if (($_item['i_parent'] == $item['id']) && ($_item['id'] != $item['id']/*Don't let DB errors cause crashes*/)) {
            $branch['children'] = array_merge($branch['children'], _build_stored_menu_branch($_item, $items));
        }
    }

    $branches = array(&$branch);

    if ($is_page_link) {
        // TODO: Category permissions? #140 on tracker

        if ($item['i_include_sitemap'] != INCLUDE_SITEMAP_NO) {
            $extra_branch = _build_sitemap_menu($item['i_url']);

            if (isset($extra_branch['children'])) {
                $page_link_append = '';
                if (strpos($item['i_url'], ':root') !== false) {
                    $page_link_append .= substr($item['i_url'], strpos($item['i_url'], ':root'));
                } elseif (strpos($item['i_url'], ':keep_') !== false) {
                    $page_link_append .= substr($item['i_url'], strpos($item['i_url'], ':keep_'));
                }
                if ($page_link_append != '') {
                    _append_to_page_links($extra_branch['children'], $page_link_append);
                }

                switch ($item['i_include_sitemap']) {
                    case INCLUDE_SITEMAP_OVER:
                        $branches = $extra_branch['children'];
                        break;

                    case INCLUDE_SITEMAP_UNDER:
                        $known_existing_page_links = array();
                        _find_child_page_links($branch['children'], $known_existing_page_links);
                        foreach ($extra_branch['children'] as $child) {
                            if (!isset($known_existing_page_links[$child['page_link']])) {
                                $branch['children'][] = $child;
                            }
                        }
                        break;
                }
            }
        }
    }

    return $branches;
}

/**
 * Find all page-links under a list of children, recursively.
 *
 * @param  array $branches Branches
 * @param  array $page_links Page-links found
 *
 * @ignore
 */
function _find_child_page_links($branches, &$page_links)
{
    foreach ($branches as $branch) {
        $page_links[$branch['page_link']] = true;

        if ($branch['children'] !== null) {
            _find_child_page_links($branch['children'], $page_links);
        }
    }
}

/**
 * Append to all page-links in a branch structure.
 *
 * @param  array $branches Branches
 * @param  string $page_link_append What to append to the page-links
 *
 * @ignore
 */
function _append_to_page_links(&$branches, $page_link_append)
{
    foreach ($branches as &$branch) {
        if ($branch['page_link'] !== null) {
            $branch['page_link'] .= $page_link_append;
        }
        _append_to_page_links($branch['children'], $page_link_append);
    }
}

/**
 * Render a menu to Tempcode.
 *
 * @param  array $menu Menu details
 * @param  ?MEMBER $source_member The member the menu is being built as (null: current member)
 * @param  ID_TEXT $type The menu type (determines what templates get used)
 * @param  boolean $as_admin Whether to generate Comcode with admin privilege
 * @param  boolean $apply_highlighting Whether to apply current-screen highlighting
 * @return Tempcode The generated Tempcode of the menu
 *
 * @ignore
 */
function _render_menu($menu, $source_member, $type, $as_admin = false, $apply_highlighting = true)
{
    if ($source_member === null) {
        $source_member = get_member();
    }

    $codename = $menu['content_id'];
    if ($codename === null) {
        $codename = '';
    }

    // Pre-process to calculate the true number of rendered items
    $new_children = array();
    if (isset($menu['children'])) {
        foreach ($menu['children'] as $child) {
            $branch = _render_menu_branch($child, $codename, $source_member, 0, $type, $as_admin, $menu['children'], $apply_highlighting, 1);

            if ($branch[0] !== null) {
                $new_children[] = $branch[0];
            }
        }
    }
    $num = count($new_children);

    // Render out top level
    $content = new Tempcode();
    foreach ($new_children as $i => $child) {
        if (is_object($child)) {
            $content->attach($child);
        } else {
            $content->attach(do_template('MENU_BRANCH_' . filter_naughty_harsh($type, true), $child + array(
                '_GUID' => 'b5209ec65425bed1207e2f667d9116f6',
                'POSITION' => strval($i),
                'FIRST' => $i == 0,
                'LAST' => $i == $num - 1,
                'BRETHREN_COUNT' => strval($num),
                'MENU' => $codename,
            ), null, false, 'MENU_BRANCH_tree'));
        }
    }

    return do_template('MENU_' . filter_naughty_harsh($type, true), array(
        'CONTENT' => $content,
        'MENU' => $codename,
        'JAVASCRIPT_HIGHLIGHTING' => !$apply_highlighting,
        'NUM_BRANCHES' => strval($num),
    ), null, false, 'MENU_tree');
}

/**
 * Render a menu branch to Tempcode.
 *
 * @param  array $branch The branch
 * @param  SHORT_TEXT $codename An identifier for the menu (will be used as a unique ID by menu JavaScript code)
 * @param  MEMBER $source_member The member the menu is being built as
 * @param  integer $level The depth into the menu that this branch resides at
 * @param  ID_TEXT $type The menu type (determines what templates get used)
 * @param  boolean $as_admin Whether to generate Comcode with admin privilege
 * @param  array $all_branches Array of all other branches
 * @param  boolean $apply_highlighting Whether to apply current-screen highlighting
 * @param  integer $the_level The level
 * @return array A pair: array of parameters of the menu branch (or null if unrenderable, or Tempcode of something to attach), and whether it is expanded
 *
 * @ignore
 */
function _render_menu_branch($branch, $codename, $source_member, $level, $type, $as_admin, $all_branches, $apply_highlighting, $the_level = 1)
{
    if ($branch['only_on_page'] != '') {
        if (strpos($branch['only_on_page'], '{') !== false) {
            require_code('tempcode_compiler');
            $branch['only_on_page'] = static_evaluate_tempcode(template_to_tempcode($branch['only_on_page']));
        }
        if (($branch['only_on_page'] != '') && (!match_key_match($branch['only_on_page']))) {
            return array(null, false); // We are not allowed to render this on this page
        }
    }

    // Spacers
    if ($branch['content_type'] == 'spacer') {
        return array(
            do_template(
                'MENU_SPACER_' . filter_naughty_harsh($type, true),
                array(
                    '_GUID' => 'c5209ec65425bed1207e2f667d9116f6',

                    // Useful contextual information
                    'MENU' => $codename,
                    'TOP_LEVEL' => $the_level == 1,
                    'THE_LEVEL' => strval($the_level),
                ),
                null,
                false,
                'MENU_SPACER_tree'
            ),
            false
        );
    }

    // Normal branches...

    // Work out the page-link
    if ($branch['page_link'] === null) { // Try and convert URL to a page-link, if we can
        $page_link = ($branch['url'] == '') ? '' : url_to_page_link($branch['url']);
    } else {
        $page_link = $branch['page_link'];
    }

    // Work out details from the URL/page-link
    $current_zone = false;
    $current_page = false;
    if ($page_link != '') {
        $users_current_zone = get_zone_name();
        $dp = get_zone_default_page($users_current_zone);

        list($zone_name, $map, $hash) = page_link_decode($page_link);
        if (!isset($map['page'])) {
            $map['page'] = get_zone_default_page($zone_name);
        }

        // If we need to check access
        if (isset($branch['modifiers']['check_perms'])) {
            if (!has_zone_access(get_member(), $zone_name)) {
                return array(null, false);
            }
            if (!has_page_access(get_member(), $map['page'], $zone_name)) {
                return array(null, false);
            }
        }

        // Scan for Tempcode symbols etc
        foreach ($map as $key => $val) {
            if (strpos($val, '{') !== false) {
                require_code('tempcode_compiler');
                $map[$key] = template_to_tempcode($val);
            }
        }

        $url = build_url($map, $zone_name, null, false, false, false, $hash);

        // See if this is current page
        if ($apply_highlighting) {
            $somewhere_definite = false;
            $_parts = array();
            foreach ($all_branches as $_branch) {
                if (($_branch['page_link'] !== null) && (preg_match('#([' . URL_CONTENT_REGEXP . ']*):([' . URL_CONTENT_REGEXP . ']+|[^/]|$)((:(.*))*)#', $_branch['page_link'], $_parts) != 0)) {
                    if ($_parts[1] == $users_current_zone) {
                        $somewhere_definite = true;
                    }
                }
            }
            global $REDIRECTED_TO_CACHE;
            $current_zone = (($zone_name == $users_current_zone) || (($REDIRECTED_TO_CACHE !== null) && ($zone_name == $REDIRECTED_TO_CACHE['r_to_zone']) && (!$somewhere_definite))); // This code is a bit smart, as zone menus usually have a small number of zones on them - redirects will be counted into the zone redirected to, so long as there is no more suitable zone and so long as it is not a transparent redirect
            if (($zone_name == $users_current_zone) || (($REDIRECTED_TO_CACHE !== null) && ($zone_name == $REDIRECTED_TO_CACHE['r_to_zone']) && (isset($map['page'])) && ($map['page'] == $REDIRECTED_TO_CACHE['r_to_page']))) {
                $current_page = true;

                $v = mixed();

                foreach ($map as $k => $v) {
                    if (is_integer($v)) {
                        $v = strval($v);
                    }
                    if (is_object($v)) {
                        $v = $v->evaluate();
                    }
                    if (($v == '') && ($k == 'page')) {
                        $v = 'start';
                        if ($zone_name == $users_current_zone) { // More precision if current zone (don't want to do query for any zone)
                            global $ZONE;
                            $v = $ZONE['zone_default_page'];
                        }
                    }
                    $pv = get_param_string($k, ($k == 'page') ? $dp : null, true);
                    if ($k == 'page') {
                        $v = str_replace('_', '-', $v);
                    }
                    if (($pv !== $v) && (($k != 'page') || ($REDIRECTED_TO_CACHE === null) || (($REDIRECTED_TO_CACHE !== null) && (($v !== $REDIRECTED_TO_CACHE['r_to_page']) || ($zone_name != $REDIRECTED_TO_CACHE['r_to_zone'])))) && (($k != 'type') || ($v != 'browse') || ($pv !== null)) && (($v != $dp) || ($k != 'page') || (get_page_name() != '')) && (substr($k, 0, 5) != 'keep_')) {
                        $current_page = false;
                        break;
                    }
                }
            }
        } else {
            $current_page = false;
            $current_zone = false;
        }

    } else { // URL
        // Carefully translate symbols in the URL
        $_url = $branch['url'];
        if (is_object($_url)) {
            $url = $_url;
        } else {
            $url = new Tempcode();
            if ($_url !== null) {
                $sym_pos = mixed();
                $sym_pos = strpos($_url, '{$');
                if ($sym_pos !== false) { // Specially encoded $ symbols
                    require_code('tempcode_compiler');
                    $url = template_to_tempcode($url->evaluate());
                } else {
                    $url = make_string_tempcode($_url);
                }
            }
        }
    }

    // Pre-process to calculate the true number of rendered items
    $new_children = array();
    $expand_this = false;
    if (isset($branch['children'])) {
        foreach ($branch['children'] as $child) {
            list($children2, $_expand_this) = _render_menu_branch($child, $codename, $source_member, $level + 1, $type, $as_admin, $all_branches, $apply_highlighting, $the_level + 1);
            if ($_expand_this) {
                $expand_this = true;
            }
            if (($children2 !== '') && ($children2 !== null)) {
                $new_children[] = $children2;
            }
        }
    }
    $num = count($new_children);

    // Render out branches at this level
    $children = new Tempcode();
    foreach ($new_children as $i => $child) {
        if (is_object($child)) {
            $children->attach($child);
        } else {
            $children->attach(do_template('MENU_BRANCH_' . filter_naughty_harsh($type, true), $child + array(
                '_GUID' => 'd5209ec65425bed1207e2f667d9116f6',
                'POSITION' => strval($i),
                'FIRST' => $i == 0,
                'LAST' => $i == $num - 1,
                'BRETHREN_COUNT' => strval($num),
                'MENU' => $codename,
            ), null, false, 'MENU_BRANCH_tree'));
        }
    }
    if (($children->is_empty()) && ($url->is_empty())) {
        return array(null, false); // Nothing here!
    }

    // Caption and tooltip
    $caption = $branch['title'];
    $tooltip = isset($branch['extra_meta']['description']) ? $branch['extra_meta']['description'] : new Tempcode();

    // How to display
    if ((!isset($branch['modifiers']['expanded'])) && (!$expand_this) && (!$current_page) && ($url->is_empty())) {
        $display = has_js() ? 'none' : 'block'; // We remap to 'none' using JS. If no JS, it remains visible. Once we have learn't we have JS, we don't need to do it again
    } else {
        $display = 'block';
    }

    // Access key
    if ($page_link === '_SEARCH:help') {
        $accesskey = '6';
    } elseif ($page_link === '_SEARCH:rules') {
        $accesskey = '7';
    } elseif ($page_link === '_SEARCH:staff:type=browse') {
        $accesskey = '5';
    } else {
        $accesskey = '';
    }

    // Other properties
    $new_window = isset($branch['modifiers']['new_window']);

    // Image
    $img = isset($branch['extra_meta']['image']) ? $branch['extra_meta']['image'] : '';
    $img_2x = empty($branch['extra_meta']['image_2x']) ? $img : $branch['extra_meta']['image_2x'];

    // Render!
    $rendered_branch = array(
        // Basic properties
        'CAPTION' => $caption,
        'IMG' => $img,
        'IMG_2X' => $img_2x,

        // Link properties
        'URL' => $url,
        'PAGE_LINK' => $page_link,
        'ACCESSKEY' => $accesskey,
        'NEW_WINDOW' => $new_window,
        'TOOLTIP' => $tooltip,

        // To do with children
        'CHILDREN' => $children,
        'NUM_CHILDREN' => strval($num),
        'DISPLAY' => $display,

        // Useful contextual information
        'MENU' => $codename,
        'TOP_LEVEL' => $the_level == 1,
        'THE_LEVEL' => strval($the_level),

        // Hints for current-page rendering
        'CURRENT' => $current_page,
        'CURRENT_ZONE' => $current_zone,
    );

    return array($rendered_branch, $current_page || $expand_this);
}

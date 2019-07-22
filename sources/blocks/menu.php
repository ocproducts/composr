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
 * @package    core_menus
 */

/**
 * Block class.
 */
class Block_menu
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled)
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = false;
        $info['parameters'] = array('title', 'type', 'param', 'tray_status', 'silent_failure', 'javascript_highlighting');
        return $info;
    }

    /**
     * Find caching details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled)
     */
    public function caching_environment()
    {
        /* Ideally we would not cache as we would need to cache for all screens due to context sensitive link display (either you're here or match key filtering). However in most cases that only happens per page, so we will cache per page -- and people can turn off caching via the standard block parameter for that if needed.*/
        $info = array();
        $info['cache_on'] = array('block_menu__cache_on');
        $info['special_cache_flags'] = CACHE_AGAINST_DEFAULT | CACHE_AGAINST_PERMISSIVE_GROUPS;
        $info['ttl'] = (get_value('disable_block_timeout') === '1') ? 60 * 60 * 24 * 365 * 5/*5 year timeout*/ : 60 * 24 * 140;
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters
     * @return Tempcode The result of execution
     */
    public function run($map)
    {
        $block_id = get_block_id($map);

        global $LANGS_REQUESTED;
        $bak = $LANGS_REQUESTED;

        $menu = isset($map['param']) ? $map['param'] : '';
        if ($menu == '') {
            // Sitemap takes lots of memory
            disable_php_memory_limit();
        }

        $type = isset($map['type']) ? $map['type'] : 'embossed';
        if ($type != 'dropdown' && $type != 'tree' && $type != 'embossed' && $type != 'popup' && $type != 'select' && $type != 'sitemap' && $type != 'mobile') {
            $exists = file_exists(get_file_base() . '/themes/default/templates/MENU_BRANCH_' . $type . '.tpl');
            if (!$exists) {
                $exists = file_exists(get_custom_file_base() . '/themes/default/templates_custom/MENU_BRANCH_' . $type . '.tpl');
            }
            $theme = $GLOBALS['FORUM_DRIVER']->get_theme();
            if ((!$exists) && ($theme != 'default')) {
                $exists = file_exists(get_custom_file_base() . '/themes/' . $theme . '/templates/MENU_BRANCH_' . $type . '.tpl');
                if (!$exists) {
                    $exists = file_exists(get_custom_file_base() . '/themes/' . $theme . '/templates_custom/MENU_BRANCH_' . $type . '.tpl');
                }
            }
            if (!$exists) {
                $type = 'tree';
            }
        }

        $title = (isset($map['title']) ? $map['title'] : '');

        $silent_failure = ((isset($map['silent_failure']) ? $map['silent_failure'] : '0') == '1');

        $tray_status = isset($map['tray_status']) ? $map['tray_status'] : '';

        $javascript_highlighting = ((isset($map['javascript_highlighting']) ? $map['javascript_highlighting'] : '1') == '1');

        require_code('menus');
        list($content, $root) = build_menu($type, $menu, false, !$javascript_highlighting);
        if (strpos(serialize($root), 'keep_') === false) {
            $LANGS_REQUESTED = $bak; // We've flattened with apply_quick_caching, we don't need to load up all those language files next time
        }

        if ($title != '') {
            $content = do_template('BLOCK_MENU', array(
                '_GUID' => 'ae46aa37a9c5a526f43b26a391164436',
                'BLOCK_ID' => $block_id,
                'CONTENT' => $content,
                'TYPE' => $type,
                'PARAM' => $menu,
                'TRAY_STATUS' => $tray_status,
                'TITLE' => comcode_to_tempcode($map['title'], null, true),
                'JAVASCRIPT_HIGHLIGHTING' => $javascript_highlighting,
            ));
        }

        return $content;
    }
}

/**
 * Find the cache signature for the block.
 *
 * @param  array $map The block parameters
 * @return array The cache signature
 */
function block_menu__cache_on($map)
{
    /*
    Menu caching is problematic. "Is active" caching theoretically would need doing against each URL.
     (or to use JavaScript, or Tempcode pre-processing, to implement that -- but that would be messy)
    We therefore assume that menu links are maximally distinguished by zone&page&type parameters.
     (special case -- catalogue index screens are also distinguished by ID, as catalogues vary a lot)

    There is a simple workaround if our assumptions don't hold up. Just turn off caching for the
    particular menu block instance. cache="0". It won't hurt very much, menus are relatively fast,
    except for large drop-down sets.
    */

    $menu = isset($map['param']) ? $map['param'] : '';

    require_code('permissions');
    $show_edit_link = ((substr($menu, 0, 1) != '_') && (substr($menu, 0, 3) != '!!!') && (has_actual_page_access(get_member(), 'admin_menus')));

    $javascript_highlighting = ((isset($map['javascript_highlighting']) ? $map['javascript_highlighting'] : '1') == '1');

    $ret = array(
        has_keep_parameters(),
        $show_edit_link,
        $menu,
        isset($map['type']) ? $map['type'] : 'embossed',
        isset($map['title']) ? $map['title'] : '',
        ((isset($map['silent_failure']) ? $map['silent_failure'] : '0') == '1'),
        isset($map['tray_status']) ? $map['tray_status'] : '',
    );

    if (!$javascript_highlighting) {
        $page = get_page_name();
        $url_type = get_param_string('type', 'browse');

        $ret = array_merge($ret, array(
            get_zone_name(),
            $page,
            $url_type,
            ($page == 'catalogues' && $url_type == 'index') ? get_param_string('id', '') : '', // Catalogues need a little extra work to distinguish them
        ));
    }

    return $ret;
}

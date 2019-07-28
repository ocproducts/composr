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
 * @package    core_permission_management
 */

/**
 * Hook class.
 */
class Hook_sitemap_privilege_category extends Hook_sitemap_base
{
    /**
     * Find if a page-link will be covered by this node.
     *
     * @param  ID_TEXT $page_link The page-link
     * @param  integer $options A bitmask of SITEMAP_GEN_* options
     * @return integer A SITEMAP_NODE_* constant
     */
    public function handles_page_link($page_link, $options)
    {
        $matches = array();
        if (preg_match('#^([^:]*):admin_permissions:privileges#', $page_link, $matches) != 0) {
            $zone = $matches[1];
            $page = 'admin_permissions';

            require_code('site');
            $test = _request_page($page, $zone);
            if (($test !== false) && (($test[0] == 'MODULES_CUSTOM') || ($test[0] == 'MODULES'))) { // Ensure the relevant module really does exist in the given zone
                if ($matches[0] != $page_link) {
                    return SITEMAP_NODE_HANDLED;
                }
                return SITEMAP_NODE_HANDLED_VIRTUALLY;
            }
        }
        return SITEMAP_NODE_NOT_HANDLED;
    }

    /**
     * Find details of a virtual position in the sitemap. Virtual positions have no structure of their own, but can find child structures to be absorbed down the tree. We do this for modularity reasons.
     *
     * @param  ID_TEXT $page_link The page-link we are finding
     * @param  ?string $callback Callback function to send discovered page-links to (null: return)
     * @param  ?array $valid_node_types List of node types we will return/recurse-through (null: no limit)
     * @param  ?integer $child_cutoff Maximum number of children before we cut off all children (null: no limit)
     * @param  ?integer $max_recurse_depth How deep to go from the sitemap root (null: no limit)
     * @param  integer $recurse_level Our recursion depth (used to limit recursion, or to calculate importance of page-link, used for instance by XML Sitemap [deeper is typically less important])
     * @param  integer $options A bitmask of SITEMAP_GEN_* options
     * @param  ID_TEXT $zone The zone we will consider ourselves to be operating in (needed due to transparent redirects feature)
     * @param  integer $meta_gather A bitmask of SITEMAP_GATHER_* constants, of extra data to include
     * @param  boolean $return_anyway Whether to return the structure even if there was a callback. Do not pass this setting through via recursion due to memory concerns, it is used only to gather information to detect and prevent parent/child duplication of default entry points.
     * @return ?array List of node structures (null: working via callback)
     */
    public function get_virtual_nodes($page_link, $callback = null, $valid_node_types = null, $child_cutoff = null, $max_recurse_depth = null, $recurse_level = 0, $options = 0, $zone = '_SEARCH', $meta_gather = 0, $return_anyway = false)
    {
        $nodes = ($callback === null || $return_anyway) ? array() : null;

        if (($valid_node_types !== null) && (!in_array('_privilege_category', $valid_node_types))) {
            return $nodes;
        }

        if (($options & SITEMAP_GEN_REQUIRE_PERMISSION_SUPPORT) != 0) {
            return $nodes;
        }

        $page = $this->_make_zone_concrete($zone, $page_link);

        require_all_lang();

        $_sections = list_to_map('p_section', $GLOBALS['SITE_DB']->query_select('privilege_list', array('DISTINCT p_section')));
        foreach ($_sections as $i => $s) {
            $test = do_lang($i, null, null, null, null, false);
            if ($test !== null) {
                $_sections[$i] = $test;
            } else {
                unset($_sections[$i]);
            }
        }
        cms_mb_asort($_sections, SORT_NATURAL | SORT_FLAG_CASE);

        if ($child_cutoff !== null) {
            if (count($_sections) > $child_cutoff) {
                return $nodes;
            }
        }

        foreach (array_keys($_sections) as $category) {
            $child_page_link = $zone . ':' . $page . ':privileges:' . $category;
            $node = $this->get_node($child_page_link, $callback, $valid_node_types, $child_cutoff, $max_recurse_depth, $recurse_level, $options, $zone, $meta_gather);
            if (($callback === null || $return_anyway) && ($node !== null)) {
                $nodes[] = $node;
            }
        }

        return $nodes;
    }

    /**
     * Find details of a position in the Sitemap.
     *
     * @param  ID_TEXT $page_link The page-link we are finding
     * @param  ?string $callback Callback function to send discovered page-links to (null: return)
     * @param  ?array $valid_node_types List of node types we will return/recurse-through (null: no limit)
     * @param  ?integer $child_cutoff Maximum number of children before we cut off all children (null: no limit)
     * @param  ?integer $max_recurse_depth How deep to go from the Sitemap root (null: no limit)
     * @param  integer $recurse_level Our recursion depth (used to limit recursion, or to calculate importance of page-link, used for instance by XML Sitemap [deeper is typically less important])
     * @param  integer $options A bitmask of SITEMAP_GEN_* options
     * @param  ID_TEXT $zone The zone we will consider ourselves to be operating in (needed due to transparent redirects feature)
     * @param  integer $meta_gather A bitmask of SITEMAP_GATHER_* constants, of extra data to include
     * @param  ?array $row Database row (null: lookup)
     * @param  boolean $return_anyway Whether to return the structure even if there was a callback. Do not pass this setting through via recursion due to memory concerns, it is used only to gather information to detect and prevent parent/child duplication of default entry points.
     * @return ?array Node structure (null: working via callback / error)
     */
    public function get_node($page_link, $callback = null, $valid_node_types = null, $child_cutoff = null, $max_recurse_depth = null, $recurse_level = 0, $options = 0, $zone = '_SEARCH', $meta_gather = 0, $row = null, $return_anyway = false)
    {
        $matches = array();
        preg_match('#^([^:]*):([^:]*):([^:]*):([^:]*)#', $page_link, $matches);
        $page = $matches[2];
        $privilege_category = $matches[4];

        require_all_lang();
        if ($privilege_category == 'SECTION_FORUMS') {
            $title = do_lang('FORUMS_AND_MEMBERS');
        } else {
            $title = do_lang($privilege_category);
        }

        $struct = array(
            'title' => make_string_tempcode($title),
            'content_type' => '_privilege_category',
            'content_id' => null,
            'modifiers' => array(),
            'only_on_page' => '',
            'page_link' => $page_link,
            'url' => null,
            'extra_meta' => array(
                'description' => null,
                'image' => null,
                'add_time' => null,
                'edit_time' => null,
                'submitter' => null,
                'views' => null,
                'rating' => null,
                'meta_keywords' => null,
                'meta_description' => null,
                'categories' => null,
                'validated' => null,
                'db_row' => null,
            ),
            'permissions' => array(),
            'has_possible_children' => false,
            'children' => null,

            // These are likely to be changed in individual hooks
            'sitemap_priority' => SITEMAP_IMPORTANCE_LOW,
            'sitemap_refreshfreq' => 'yearly',

            'privilege_page' => null,
        );

        if (!$this->_check_node_permissions($struct, $options)) {
            return null;
        }

        if ($callback !== null) {
            call_user_func($callback, $struct);
        }

        return ($callback === null || $return_anyway) ? $struct : null;
    }
}

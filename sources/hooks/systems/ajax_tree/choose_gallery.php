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
 * @package    galleries
 */

/**
 * Hook class.
 */
class Hook_ajax_tree_choose_gallery
{
    /**
     * Run function for ajax-tree hooks. Generates XML for a tree list, which is interpreted by JavaScript and expanded on-demand (via new calls).
     *
     * @param  ?ID_TEXT $id The ID to do under (null: root)
     * @param  array $options Options being passed through
     * @param  ?ID_TEXT $default The ID to select by default (null: none)
     * @return string XML in the special category,entry format
     */
    public function run($id, $options, $default = null)
    {
        require_code('galleries');
        require_lang('galleries');

        push_query_limiting(false);

        $must_accept_images = array_key_exists('must_accept_images', $options) ? $options['must_accept_images'] : false;
        $must_accept_videos = array_key_exists('must_accept_videos', $options) ? $options['must_accept_videos'] : false;
        $must_accept_something = array_key_exists('must_accept_something', $options) ? $options['must_accept_something'] : false;
        $filter = array_key_exists('filter', $options) ? $options['filter'] : null;
        $purity = array_key_exists('purity', $options) ? $options['purity'] : false;
        $member_id = array_key_exists('member_id', $options) ? $options['member_id'] : null;
        $compound_list = array_key_exists('compound_list', $options) ? $options['compound_list'] : false;
        $addable_filter = array_key_exists('addable_filter', $options) ? $options['addable_filter'] : false;
        $editable_filter = array_key_exists('editable_filter', $options) ? ($options['editable_filter']) : false;
        if ($id === null) {
            $stripped_id = null;
        } else {
            $stripped_id = ($compound_list ? preg_replace('#,.*$#', '', $id) : $id);
        }
        $tree = get_gallery_tree(($id === null) ? 'root' : $stripped_id, '', null, true, $filter, false, false, $purity, $compound_list, ($id === null) ? 0 : 1, $member_id, $addable_filter, $editable_filter);

        $levels_to_expand = array_key_exists('levels_to_expand', $options) ? ($options['levels_to_expand']) : intval(get_value('levels_to_expand__' . substr(get_class($this), 5), null, true));
        $options['levels_to_expand'] = max(0, $levels_to_expand - 1);

        if (!has_actual_page_access(null, 'galleries')) {
            $tree = $compound_list ? array(array(), '') : array();
        }

        if ($compound_list) {
            list($tree,) = $tree;
        }

        $out = '';

        $out .= '<options>' . xmlentities(json_encode($options)) . '</options>';

        for ($i = 0; $i < count($tree); $i++) {
            $t = $tree[$i];

            $_id = $compound_list ? $t['compound_list'] : $t['id'];
            if ($stripped_id === $t['id']) {
                // Possible when we look under as a root
                if (array_key_exists('children', $t)) {
                    $tree = $t['children'];
                    $i = 0;
                }
                continue;
            }
            $title = $t['title'];
            if (is_object($title)) {
                $title = strip_html($title->evaluate());
            }
            $has_children = ($t['child_count'] != 0);
            $selectable =
                (($editable_filter !== true) || ($t['editable'])) &&
                (($addable_filter !== true) || ($t['addable'])) &&
                (((($t['accept_images']) || ($t['accept_videos'])) && (!$t['is_member_synched'])) || (!$must_accept_something)) &&
                ((($t['accept_videos']) && (!$t['is_member_synched'])) || (!$must_accept_videos)) &&
                ((($t['accept_images']) && (!$t['is_member_synched'])) || (!$must_accept_images));

            if ((!$has_children) || (strpos($_id, 'member_') !== false)) {
                if (($editable_filter) && (!$t['editable'])) {
                    continue;
                }
                if (($addable_filter) && (!$t['addable'])) {
                    continue;
                }
            }

            $tag = 'category'; // category
            $out .= '<' . $tag . ' id="' . xmlentities($_id) . '" title="' . xmlentities($title) . '" has_children="' . ($has_children ? 'true' : 'false') . '" selectable="' . ($selectable ? 'true' : 'false') . '"></' . $tag . '>';

            if ($levels_to_expand > 0) {
                $out .= '<expand>' . xmlentities($_id) . '</expand>';
            }
        }

        // Mark parent cats for pre-expansion
        if (($default !== null) && ($default != '')) {
            $cat = $default;
            while (($cat !== null) && ($cat != '')) {
                $out .= '<expand>' . $cat . '</expand>';
                $cat = $GLOBALS['SITE_DB']->query_select_value_if_there('galleries', 'parent_id', array('name' => $cat));
            }
        }

        pop_query_limiting();

        $tag = 'result'; // result
        return '<' . $tag . '>' . $out . '</' . $tag . '>';
    }

    /**
     * Generate a simple selection list for the ajax-tree hook. Returns a normal <select> style <option>-list, for fallback purposes.
     *
     * @param  ?ID_TEXT $id The ID to do under (null: root) - not always supported
     * @param  array $options Options being passed through
     * @param  ?ID_TEXT $it The ID to select by default (null: none)
     * @return Tempcode The nice list
     */
    public function simple($id, $options, $it = null)
    {
        $must_accept_images = array_key_exists('must_accept_images', $options) ? $options['must_accept_images'] : false;
        $must_accept_videos = array_key_exists('must_accept_videos', $options) ? $options['must_accept_videos'] : false;
        $filter = array_key_exists('filter', $options) ? $options['filter'] : null;
        $purity = array_key_exists('purity', $options) ? $options['purity'] : false;
        $member_id = array_key_exists('member_id', $options) ? $options['member_id'] : null;
        $compound_list = array_key_exists('compound_list', $options) ? $options['compound_list'] : false;
        $addable_filter = array_key_exists('addable_filter', $options) ? $options['addable_filter'] : false;
        $editable_filter = array_key_exists('editable_filter', $options) ? ($options['editable_filter']) : false;

        require_code('galleries');

        return create_selection_list_gallery_tree($it, $filter, $must_accept_images, $must_accept_videos, $purity, $compound_list, $member_id, $addable_filter, $editable_filter);
    }
}

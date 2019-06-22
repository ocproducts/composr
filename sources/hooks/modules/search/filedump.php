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
 * @package    filedump
 */

/**
 * Hook class.
 */
class Hook_search_filedump extends FieldsSearchHook
{
    /**
     * Find details for this search hook.
     *
     * @param  boolean $check_permissions Whether to check permissions
     * @param  ?MEMBER $member_id The member ID to check with (null: current member)
     * @return ~?array Map of search hook details (null: hook is disabled) (false: access denied)
     */
    public function info($check_permissions = true, $member_id = null)
    {
        if (!addon_installed('filedump')) {
            return null;
        }

        if ($member_id === null) {
            $member_id = get_member();
        }

        if ($check_permissions) {
            if (!has_actual_page_access($member_id, 'filedump')) {
                return false;
            }
        }

        require_code('files2');
        if (count(get_directory_contents(get_custom_file_base() . '/uploads/filedump')) == 0) {
            return null;
        }

        require_lang('filedump');

        $info = array();
        $info['lang'] = do_lang_tempcode('FILEDUMP');
        $info['default'] = (get_option('search_filedump') == '1');
        $info['extra_sort_fields'] = array('file_size' => do_lang_tempcode('FILE_SIZE'));

        $info['permissions'] = array(
            array(
                'type' => 'zone',
                'zone_name' => get_module_zone('filedump'),
            ),
            array(
                'type' => 'page',
                'zone_name' => get_module_zone('filedump'),
                'page_name' => 'filedump',
            ),
        );

        return $info;
    }

    /**
     * Get details for an ajax-tree-list of entries for the content covered by this search hook.
     *
     * @return array A pair: the hook, and the options
     */
    public function ajax_tree()
    {
        return array('choose_filedump_file', array('compound_list' => false, 'folder' => true));
    }

    /**
     * Run function for search results.
     *
     * @param  string $content Search string
     * @param  boolean $only_search_meta Whether to only do a META (tags) search
     * @param  ID_TEXT $direction Order direction
     * @param  integer $max Start position in total results
     * @param  integer $start Maximum results to return in total
     * @param  boolean $only_titles Whether only to search titles (as opposed to both titles and content)
     * @param  string $content_where Where clause that selects the content according to the main search string (SQL query fragment) (blank: full-text search)
     * @param  SHORT_TEXT $author Username/Author to match for
     * @param  ?MEMBER $author_id Member-ID to match for (null: unknown)
     * @param  mixed $cutoff Cutoff date (TIME or a pair representing the range)
     * @param  string $sort The sort type (gets remapped to a field in this function)
     * @set title add_date
     * @param  integer $limit_to Limit to this number of results
     * @param  string $boolean_operator What kind of boolean search to do
     * @set or and
     * @param  string $where_clause Where constraints known by the main search code (SQL query fragment)
     * @param  string $search_under Comma-separated list of categories to search under
     * @param  boolean $boolean_search Whether it is a boolean search
     * @return array List of maps (template, orderer)
     */
    public function run($content, $only_search_meta, $direction, $max, $start, $only_titles, $content_where, $author, $author_id, $cutoff, $sort, $limit_to, $boolean_operator, $where_clause, $search_under, $boolean_search)
    {
        require_lang('zones');

        // Calculate our where clause (search)
        if ($author != '') {
            return array();
        }

        require_code('files2');

        if ($search_under == '!') {
            $search_under = '';
        }

        $files = get_directory_contents(get_custom_file_base() . '/uploads/filedump' . (($search_under == '') ? '' : ('/' . $search_under)));
        $_rows = $GLOBALS['SITE_DB']->query_select('filedump');
        $rows = array();
        foreach ($_rows as $row) {
            $rows[$row['path']] = $row;
        }
        $i = 0;
        $out = array();
        foreach ($files as $_path) {
            if ($search_under != '') {
                $_path = $search_under . '/' . $_path;
            }

            $path = get_custom_file_base() . '/uploads/filedump/' . $_path;
            if (!$this->_handle_date_check_runtime($cutoff, filemtime($path))) {
                continue;
            }
            if (in_memory_search_match(array('content' => $content, 'conjunctive_operator' => $boolean_operator), $path)) {
                $caption = array_key_exists($_path, $rows) ? $rows[$_path] : $_path;
                $dirs = explode('/', dirname($_path));

                $pre = '';
                $file_breadcrumbs = array();
                $breadcrumbs_page_link = build_page_link(array('page' => 'filedump', 'place' => $pre . '/'), get_module_zone('filedump'));
                $file_breadcrumbs[] = array($breadcrumbs_page_link, do_lang_tempcode('ROOT'));
                foreach ($dirs as $dir) {
                    $breadcrumbs_page_link = build_page_link(array('page' => 'filedump', 'place' => $pre . $dir . '/'), get_module_zone('filedump'));
                    $file_breadcrumbs[] = array($breadcrumbs_page_link, $dir);

                    $pre .= $dir . '/';
                }

                $url = get_custom_base_url() . '/uploads/filedump/' . $_path;

                require_code('images');
                if (!is_image($url, IMAGE_CRITERIA_WEBSAFE, true)) {
                    $tpl = paragraph(hyperlink($url, $caption, true, true), 'dfdsfu09wl;f');
                    if ($file_breadcrumbs != array()) {
                        $tpl->attach(paragraph(do_lang_tempcode('LOCATED_IN', breadcrumb_segments_to_tempcode($file_breadcrumbs)), '', 'breadcrumbs'));
                    }

                    $out[$i]['template'] = do_template('SIMPLE_PREVIEW_BOX', array(
                        '_GUID' => '51bc0cf751f4ccbd0b7f1a247b092368',
                        'ID' => $_path,
                        'TITLE' => basename($_path),
                        'SUMMARY' => $tpl,
                        'RESOURCE_TYPE' => '_filedump_file',
                    ));
                } else {
                    $tpl = do_image_thumb($url, $caption, true, false, null, null, true);

                    $out[$i]['template'] = do_template('SIMPLE_PREVIEW_BOX', array(
                        '_GUID' => '61bc0cf751f4ccbd0b7f1a247b092368',
                        'TITLE' => basename($_path),
                        'SUMMARY' => $tpl,
                        'BREADCRUMBS' => $file_breadcrumbs,
                        'URL' => $url,
                        'RESOURCE_TYPE' => '_filedump_file_image',
                    ));
                }

                if ($sort == 'title') {
                    $out[$i]['orderer'] = $path;
                } elseif ($sort == 'add_date') {
                    $out[$i]['orderer'] = filectime($path);
                } elseif ($sort == 'file_size') {
                    $out[$i]['orderer'] = filesize($path);
                }

                $i++;
            }
        }

        return $out;
    }
}

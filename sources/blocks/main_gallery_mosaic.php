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
 * @package    galleries
 */

/**
 * Block class.
 */
class Block_main_gallery_mosaic
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
        $info['version'] = 1;
        $info['locked'] = false;
        $info['parameters'] = array('param', 'filter', 'video_filter', 'select', 'video_select', 'zone', 'title', 'sort', 'days', 'render_if_empty', 'max', 'start', 'pagination', 'root', 'as_guest', 'check');
        return $info;
    }

    /**
     * Find caching details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled)
     */
    public function caching_environment()
    {
        $info = array();
        $info['cache_on'] = <<<'PHP'
            (preg_match('#<\w+>#', ((array_key_exists('filter', $map) ? $map['filter'] : '') . (array_key_exists('video_filter', $map) ? $map['video_filter'] : ''))) != 0) 
                ? null : array(
                    array_key_exists('as_guest', $map) ? ($map['as_guest'] == '1') : false, 
                    get_param_integer($block_id . '_max', array_key_exists('max', $map) ? intval($map['max']) : null), 
                    get_param_integer($block_id . '_start', array_key_exists('start', $map) ? intval($map['start']) : 0), 
                    ((array_key_exists('pagination', $map) ? $map['pagination'] : '0') == '1'), 
                    ((array_key_exists('root', $map)) && ($map['root'] != '')) ? $map['root'] : get_param_string('keep_gallery_root', null), 
                    array_key_exists('filter', $map) ? $map['filter'] : '', 
                    array_key_exists('video_filter', $map) ? $map['video_filter'] : '', 
                    array_key_exists('render_if_empty', $map) ? $map['render_if_empty'] : '0', 
                    array_key_exists('days', $map) ? $map['days'] : '', 
                    array_key_exists('sort', $map) ? $map['sort'] : 'add_date DESC', get_param_integer('mge_start', 0),
                    array_key_exists('param', $map) ? $map['param'] : db_get_first_id(), 
                    array_key_exists('zone', $map) ? $map['zone'] : '', 
                    (($map === null) || (!array_key_exists('select', $map))) ? '*' : $map['select'], 
                    (($map === null) || (!array_key_exists('video_select', $map))) ? '*' : $map['video_select'], 
                    array_key_exists('title', $map) ? $map['title'] : '', 
                    array_key_exists('check', $map) ? ($map['check'] == '1') : true,
                )
PHP;
        $info['special_cache_flags'] = CACHE_AGAINST_DEFAULT | CACHE_AGAINST_PERMISSIVE_GROUPS;
        if (addon_installed('content_privacy')) {
            $info['special_cache_flags'] |= CACHE_AGAINST_MEMBER;
        }
        $info['ttl'] = (get_value('disable_block_timeout') === '1') ? 60 * 60 * 24 * 365 * 5/*5 year timeout*/ : 60 * 2;
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
        $error_msg = new Tempcode();
        if (!addon_installed__messaged('galleries', $error_msg)) {
            return $error_msg;
        }

        require_css('galleries');
        require_lang('galleries');
        require_code('galleries');
        require_code('images');
        require_code('feedback');
        require_javascript('galleries');

        $block_id = get_block_id($map);

        $check_perms = array_key_exists('check', $map) ? ($map['check'] == '1') : true;

        $max = get_param_integer($block_id . '_max', array_key_exists('max', $map) ? intval($map['max']) : get_default_gallery_max());
        $start = get_param_integer($block_id . '_start', array_key_exists('start', $map) ? intval($map['start']) : 0);
        $do_pagination = ((array_key_exists('pagination', $map) ? $map['pagination'] : '0') == '1');
        $root = ((array_key_exists('root', $map)) && ($map['root'] != '')) ? $map['root'] : get_param_string('keep_gallery_root', null);

        if (empty($map['param'])) {
            $cat = $GLOBALS['SITE_DB']->query_select_value_if_there('images', 'cat', array(), 'GROUP BY cat ORDER BY COUNT(*) DESC');
            if ($cat === null) {
                $cat = 'root';
            }
        } else {
            $cat = $map['param'];
        }

        $cat_raw = trim($cat, '>*');
        if ($cat == 'root') {
            $cat_select = db_string_equal_to('cat', $cat);
        } else {
            require_code('selectcode');
            $cat_select = selectcode_to_sqlfragment($cat, 'cat', 'galleries', 'parent_id', 'cat', 'name', false, false);
        }

        $title = array_key_exists('title', $map) ? $map['title'] : '';
        $zone = array_key_exists('zone', $map) ? $map['zone'] : get_module_zone('galleries');

        $where_sup = '';
        if ((!has_privilege(get_member(), 'see_unvalidated')) && (addon_installed('unvalidated'))) {
            $where_sup .= ' AND r.validated=1';
        }

        // Selectcode
        if (!array_key_exists('select', $map)) {
            $map['select'] = '*';
        }
        if ($map['select'] != '*') {
            require_code('selectcode');
            $where_sup .= ' AND ' . selectcode_to_sqlfragment($map['select'], 'id');
        }
        if (!array_key_exists('video_select', $map)) {
            $map['video_select'] = '*';
        }
        if ($map['video_select'] != '*') {
            require_code('selectcode');
            $where_sup .= ' AND ' . selectcode_to_sqlfragment($map['video_select'], 'id');
        }

        // Day filtering
        $_days = array_key_exists('days', $map) ? $map['days'] : '';
        $days = ($_days == '') ? null : intval($_days);
        if ($days !== null) {
            $where_sup .= ' AND add_date>=' . strval(time() - $days * 60 * 60 * 24);
        }

        // Sorting
        $sort = array_key_exists('sort', $map) ? $map['sort'] : 'add_date DESC';
        if (($sort != 'fixed_random ASC') && ($sort != 'average_rating DESC') && ($sort != 'average_rating ASC') && ($sort != 'compound_rating DESC') && ($sort != 'compound_rating ASC') && ($sort != 'add_date DESC') && ($sort != 'add_date ASC') && ($sort != 'edit_date DESC') && ($sort != 'edit_date ASC') && ($sort != 'url DESC') && ($sort != 'url ASC')) {
            $sort = 'add_date DESC';
        }
        list($_sort, $_dir) = explode(' ', $sort, 2);

        // Filtercode support
        $extra_filter_sql = '';
        $extra_join_sql = '';
        require_code('filtercode');
        if (!array_key_exists('filter', $map)) {
            $map['filter'] = '';
        }
        if (!array_key_exists('video_filter', $map)) {
            $map['video_filter'] = '';
        }
        if ($map['filter'] != '') {
            list($extra_filter, $extra_join, $extra_where) = filtercode_to_sql($GLOBALS['SITE_DB'], parse_filtercode($map['filter']), 'image');
            $extra_filter_sql .= implode('', $extra_filter);
            $extra_join_sql .= implode('', $extra_join);
            $where_sup .= $extra_where;
        }
        if ($map['video_filter'] != '') {
            list($extra_filter, $extra_join, $extra_where) = filtercode_to_sql($GLOBALS['SITE_DB'], parse_filtercode($map['video_filter']), 'video');
            $extra_filter_sql .= implode('', $extra_filter);
            $extra_join_sql .= implode('', $extra_join);
            $where_sup .= $extra_where;
        }

        $extra_join_image = '';
        $extra_join_video = '';
        $extra_where_image = '';
        $extra_where_video = '';

        if (addon_installed('content_privacy')) {
            require_code('content_privacy');
            $as_guest = array_key_exists('as_guest', $map) ? ($map['as_guest'] == '1') : false;
            $viewing_member_id = $as_guest ? $GLOBALS['FORUM_DRIVER']->get_guest_id() : null;
            list($privacy_join_image, $privacy_where_image) = get_privacy_where_clause('image', 'r', $viewing_member_id);
            list($privacy_join_video, $privacy_where_video) = get_privacy_where_clause('video', 'r', $viewing_member_id);
            $extra_join_image .= $privacy_join_image;
            $extra_join_video .= $privacy_join_video;
            $extra_where_image .= $privacy_where_image;
            $extra_where_video .= $privacy_where_video;
        }

        if (get_option('filter_regions') == '1') {
            require_code('locations');
            $extra_where_image .= sql_region_filter('image', 'r.id');
            $extra_where_video .= sql_region_filter('video', 'r.id');
        }

        if ((!$GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) && ($check_perms)) {
            $extra_join_sql .= get_permission_join_clause('gallery', 'cat');
            $where_sup .= get_permission_where_clause(get_member(), get_permission_where_clause_groups(get_member()));
        }

        // Get rows
        if ($do_pagination) {
            $total_images = $GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(*)' . $extra_filter_sql . ' FROM ' . get_table_prefix() . 'images r' . $extra_join_sql . $extra_join_image . ' WHERE ' . $cat_select . $where_sup . $extra_where_image, false, true);
            $total_videos = $GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(*)' . $extra_filter_sql . ' FROM ' . get_table_prefix() . 'videos r' . $extra_join_sql . $extra_join_video . ' WHERE ' . $cat_select . $where_sup . $extra_where_video, false, true);
        } else {
            $total_images = 0;
            $total_videos = 0;
        }
        if ($_sort == 'average_rating') {
            $rating_sort = ',(SELECT AVG(rating) FROM ' . get_table_prefix() . 'rating WHERE ' . db_string_equal_to('rating_for_type', 'images') . ' AND rating_for_id=' . db_cast('r.id', 'CHAR') . ') AS average_rating';
        } elseif ($_sort == 'compound_rating') {
            $rating_sort = ',(SELECT SUM(rating-1) FROM ' . get_table_prefix() . 'rating WHERE ' . db_string_equal_to('rating_for_type', 'images') . ' AND rating_for_id=' . db_cast('r.id', 'CHAR') . ') AS compound_rating';
        } elseif ($_sort == 'fixed_random') {
            $rating_sort = ',(' . db_function('MOD', array('r.id', date('d'))) . ') AS fixed_random';
        } else {
            $rating_sort = '';
        }
        $rows_images = $GLOBALS['SITE_DB']->query('SELECT *' . $rating_sort . $extra_filter_sql . ' FROM ' . get_table_prefix() . 'images r' . $extra_join_sql . $extra_join_image . ' WHERE ' . $cat_select . $where_sup . $extra_where_image . ' ORDER BY ' . $sort, $max + $start, 0, false, true);
        if ($_sort == 'average_rating') {
            $rating_sort = ',(SELECT AVG(rating) FROM ' . get_table_prefix() . 'rating WHERE ' . db_string_equal_to('rating_for_type', 'videos') . ' AND rating_for_id=' . db_cast('r.id', 'CHAR') . ') AS average_rating';
        } elseif ($_sort == 'compound_rating') {
            $rating_sort = ',(SELECT SUM(rating-1) FROM ' . get_table_prefix() . 'rating WHERE ' . db_string_equal_to('rating_for_type', 'videos') . ' AND rating_for_id=' . db_cast('r.id', 'CHAR') . ') AS compound_rating';
        } elseif ($_sort == 'fixed_random') {
            $rating_sort = ',(' . db_function('MOD', array('r.id', date('d'))) . ') AS fixed_random';
        } else {
            $rating_sort = '';
        }
        $rows_videos = $GLOBALS['SITE_DB']->query('SELECT *' . $rating_sort . $extra_filter_sql . ' FROM ' . get_table_prefix() . 'videos r' . $extra_join_sql . $extra_join_video . ' WHERE ' . $cat_select . $where_sup . $extra_where_video . ' ORDER BY ' . $sort, $max + $start, 0, false, true);

        // Sort
        $combined = array();
        foreach ($rows_images as $row_image) {
            $combined[] = array($row_image, 'image', $row_image[$_sort]);
        }
        foreach ($rows_videos as $row_video) {
            $combined[] = array($row_video, 'video', $row_video[$_sort]);
        }
        sort_maps_by($combined, ($_dir == 'DESC') ? '!2' : '2');

        // Display
        $entries = new Tempcode();
        foreach ($combined as $i => $c) {
            if ($i >= $start) {
                $just_media_row = db_map_restrict($c[0], array('id', 'description'));

                switch ($c[1]) {
                    case 'image':
                        // Display image
                        $row_image = $c[0];
                        $entry_title = get_translated_text($row_image['title']);
                        $view_url = build_url(array('page' => ($zone == '_SELF' && running_script('index')) ? get_page_name() : 'galleries', 'type' => 'image', 'id' => $row_image['id'], 'root' => $root), $zone);
                        $full_url = $row_image['url'];
                        $file_size = url_is_local($full_url) ? file_exists(get_custom_file_base() . '/' . rawurldecode($full_url)) ? strval(filesize(get_custom_file_base() . '/' . rawurldecode($full_url))) : '' : '';
                        if (url_is_local($full_url)) {
                            $full_url = get_custom_base_url() . '/' . $full_url;
                        }
                        $thumb = do_image_thumb($full_url, '', false, false, 500, 500, true);
                        $thumb_url = $row_image['thumb_url'];
                        if (url_is_local($thumb_url)) {
                            $thumb_url = get_custom_base_url() . '/' . $thumb_url;
                        }

                        $entry_rating_details = ($row_image['allow_rating'] == 1) ? display_rating($view_url, get_translated_text($row_image['title']), 'images', strval($row_image['id']), 'RATING_INLINE_STATIC', $row_image['submitter']) : null;

                        $_edit_url = new Tempcode();
                        if (has_delete_permission('mid', get_member(), $row_image['submitter'], 'cms_galleries', array('gallery', $row_image['cat']))) {
                            $_edit_url = build_url(array('page' => 'cms_galleries', 'type' => '__edit', 'id' => $row_image['id'], 'redirect' => protect_url_parameter(SELF_REDIRECT_RIP)), get_module_zone('cms_galleries'));
                            if ($row_image['submitter'] == get_member()) {
                                $GLOBALS['DO_NOT_CACHE_THIS'] = true; // If delete was due to groups, groups is a cache key anyways
                            }
                        }

                        $entry_map = array(
                            '_GUID' => '13c77543f8034f14adff4bd27ec5112e',
                            'RATING_DETAILS' => $entry_rating_details,
                            'TITLE' => $entry_title,
                            'DESCRIPTION' => get_translated_tempcode('images', $just_media_row, 'description'),
                            'ID' => strval($row_image['id']),
                            'MEDIA_TYPE' => 'image',
                            'FILE_SIZE' => $file_size,
                            'SUBMITTER' => strval($row_image['submitter']),
                            'FULL_URL' => $full_url,
                            'THUMB_URL' => $thumb_url,
                            'CAT' => $row_image['cat'],
                            'THUMB' => $thumb,
                            'VIEW_URL' => $view_url,
                            'VIEWS' => strval($row_image['image_views']),
                            'ADD_DATE_RAW' => strval($row_image['add_date']),
                            'EDIT_DATE_RAW' => ($row_image['edit_date'] === null) ? '' : strval($row_image['edit_date']),
                            'START' => strval($start),
                            '_EDIT_URL' => $_edit_url,
                        );
                        $entries->attach(do_template('GALLERY_MOSAIC_IMAGE', $entry_map));

                        break;

                    case 'video':
                        // Display video
                        $row_video = $c[0];
                        $entry_title = get_translated_text($row_video['title']);
                        $view_url = build_url(array('page' => ($zone == '_SELF' && running_script('index')) ? get_page_name() : 'galleries', 'type' => 'video', 'id' => $row_video['id'], 'root' => $root), $zone);
                        $thumb_url = $row_video['thumb_url'];
                        if (($thumb_url != '') && (url_is_local($thumb_url))) {
                            $thumb_url = get_custom_base_url() . '/' . $thumb_url;
                        }
                        if ($thumb_url == '') {
                            $thumb_url = find_theme_image('na');
                        }
                        $thumb = do_image_thumb($thumb_url);
                        $full_url = $row_video['url'];
                        if (url_is_local($full_url)) {
                            $full_url = get_custom_base_url() . '/' . $full_url;
                        }
                        $thumb_url = $row_video['thumb_url'];
                        if (($thumb_url != '') && (url_is_local($thumb_url))) {
                            $thumb_url = get_custom_base_url() . '/' . $thumb_url;
                        }

                        $entry_rating_details = ($row_video['allow_rating'] == 1) ? display_rating($view_url, get_translated_text($row_video['title']), 'videos', strval($row_video['id']), 'RATING_INLINE_STATIC', $row_video['submitter']) : null;

                        $_edit_url = new Tempcode();
                        if (has_delete_permission('mid', get_member(), $row_video['submitter'], 'cms_galleries', array('gallery', $row_video['cat']))) {
                            $_edit_url = build_url(array('page' => 'cms_galleries', 'type' => '__edit_other', 'id' => $row_video['id'], 'redirect' => protect_url_parameter(SELF_REDIRECT_RIP)), get_module_zone('cms_galleries'));
                            if ($row_video['submitter'] == get_member()) {
                                $GLOBALS['DO_NOT_CACHE_THIS'] = true; // If delete was due to groups, groups is a cache key anyways
                            }
                        }

                        $entry_map = array(
                            '_GUID' => 'f98f86cc362c45d9bdccd93be062a286',
                            'RATING_DETAILS' => $entry_rating_details,
                            'TITLE' => $entry_title,
                            'DESCRIPTION' => get_translated_tempcode('videos', $just_media_row, 'description'),
                            'ID' => strval($row_video['id']),
                            'MEDIA_TYPE' => 'video',
                            'CAT' => $row_video['cat'],
                            'THUMB' => $thumb,
                            'VIEW_URL' => $view_url,
                            'SUBMITTER' => strval($row_video['submitter']),
                            'FULL_URL' => $full_url,
                            'THUMB_URL' => $thumb_url,
                            'VIDEO_DETAILS' => show_video_details($row_video),
                            'VIEWS' => strval($row_video['video_views']),
                            'ADD_DATE_RAW' => strval($row_video['add_date']),
                            'EDIT_DATE_RAW' => ($row_video['edit_date'] === null) ? '' : strval($row_video['edit_date']),
                            'START' => strval($start),
                            '_EDIT_URL' => $_edit_url,
                        );
                        $entries->attach(do_template('GALLERY_MOSAIC_VIDEO', $entry_map));
                        break;
                }
            }

            if (($i + 1) === $start + $max) {
                break;
            }
        }

        // Empty? Bomb out somehow
        if ($entries->is_empty_shell()) {
            if ((!isset($map['render_if_empty'])) || ($map['render_if_empty'] == '0')) {
                $submit_url = new Tempcode();
                $add_name = null;
                if ((has_actual_page_access(null, 'cms_galleries', null, null)) && (has_submit_permission('mid', get_member(), get_ip_address(), 'cms_galleries', array('galleries', $cat_raw))) && (can_submit_to_gallery($cat_raw))) {
                    if ($GLOBALS['SITE_DB']->query_select_value_if_there('galleries', 'accept_images', array('name' => $cat_raw)) !== null) {
                        $submit_url = build_url(array('page' => 'cms_galleries', 'type' => 'add', 'cat' => $cat_raw, 'redirect' => protect_url_parameter(SELF_REDIRECT_RIP)), get_module_zone('cms_galleries'));
                        $add_name = do_lang_tempcode('ADD_IMAGE');
                    } elseif ($GLOBALS['SITE_DB']->query_select_value_if_there('galleries', 'accept_videos', array('name' => $cat_raw)) !== null) {
                        $submit_url = build_url(array('page' => 'cms_galleries', 'type' => 'add_other', 'cat' => $cat_raw, 'redirect' => protect_url_parameter(SELF_REDIRECT_RIP)), get_module_zone('cms_galleries'));
                        $add_name = do_lang_tempcode('ADD_VIDEO');
                    }
                }
                return do_template('BLOCK_NO_ENTRIES', array(
                    '_GUID' => 'ee9810cf08be42d788086ebb09d83963',
                    'BLOCK_ID' => $block_id,
                    'HIGH' => false,
                    'TITLE' => $title,
                    'MESSAGE' => do_lang_tempcode('NO_ENTRIES'),
                    'ADD_NAME' => $add_name,
                    'SUBMIT_URL' => $submit_url,
                ));
            }
        }

        // Pagination
        $pagination = new Tempcode();
        if ($do_pagination) {
            require_code('templates_pagination');
            $_selectors = array_map('intval', explode(',', get_option('gallery_selectors')));
            $pagination = pagination(do_lang('MEDIA'), $start, $block_id . '_start', $max, $block_id . '_max', $total_videos + $total_images, false, 5, $_selectors);
        }

        // Render
        return do_template('BLOCK_MAIN_GALLERY_MOSAIC', array(
            '_GUID' => '87187ebeb42d4c029b74d7cf773c49bd',
            'BLOCK_ID' => $block_id,
            'IMAGE_FILTER' => $map['filter'],
            'VIDEO_FILTER' => $map['video_filter'],
            'DAYS' => $_days,
            'SORT' => $sort,
            'BLOCK_PARAMS' => block_params_arr_to_str(array('block_id' => $block_id) + $map),
            'PAGINATION' => $pagination,
            'TITLE' => $title,
            'CAT' => $cat_raw,
            'ENTRIES' => $entries,
            'TOTAL_VIDEOS' => strval($total_videos),
            'TOTAL_IMAGES' => strval($total_images),
            'TOTAL' => strval($total_videos + $total_images),
            'START' => strval($start),
            'MAX' => strval($max),
            'START_PARAM' => $block_id . '_start',
            'MAX_PARAM' => $block_id . '_max',
            'EXTRA_GET_PARAMS' => (get_param_integer($block_id . '_max', null) === null) ? null : ('&' . $block_id . '_max=' . urlencode(strval($max))),
        ));
    }
}

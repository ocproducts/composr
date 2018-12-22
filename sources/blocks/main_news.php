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
 * @package    news
 */

/**
 * Block class.
 */
class Block_main_news
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
        $info['parameters'] = array('param', 'member_based', 'select', 'select_and', 'multiplier', 'fallback_full', 'fallback_archive', 'blogs', 'historic', 'zone', 'title', 'show_in_full', 'no_links', 'attach_to_url_filter', 'render_if_empty', 'filter', 'start', 'pagination', 'as_guest', 'optimise', 'check');
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
        $info['cache_on'] = 'array(array_key_exists(\'optimise\',$map)?$map[\'optimise\']:\'0\',preg_match(\'#<\w+>#\',(array_key_exists(\'filter\',$map)?$map[\'filter\']:\'\'))!=0)?null:array(((array_key_exists(\'pagination\',$map)?$map[\'pagination\']:\'0\')==\'1\'),array_key_exists(\'title\',$map)?escape_html($map[\'title\']):\'(default title)\',array_key_exists(\'as_guest\',$map)?($map[\'as_guest\']==\'1\'):false,get_param_integer($block_id.\'_start\',array_key_exists(\'start\',$map)?intval($map[\'start\']):0),array_key_exists(\'filter\',$map)?$map[\'filter\']:\'\',array_key_exists(\'show_in_full\',$map)?$map[\'show_in_full\']:\'0\',array_key_exists(\'render_if_empty\',$map)?$map[\'render_if_empty\']:\'0\',((array_key_exists(\'attach_to_url_filter\',$map)?$map[\'attach_to_url_filter\']:\'0\')==\'1\'),array_key_exists(\'no_links\',$map)?$map[\'no_links\']:0,array_key_exists(\'title\',$map)?$map[\'title\']:\'\',array_key_exists(\'member_based\',$map)?$map[\'member_based\']:\'0\',array_key_exists(\'blogs\',$map)?$map[\'blogs\']:\'-1\',array_key_exists(\'historic\',$map)?$map[\'historic\']:\'\',array_key_exists(\'param\',$map)?intval($map[\'param\']):14,array_key_exists(\'multiplier\',$map)?floatval($map[\'multiplier\']):0.5,array_key_exists(\'fallback_full\',$map)?intval($map[\'fallback_full\']):3,array_key_exists(\'fallback_archive\',$map)?intval($map[\'fallback_archive\']):6,array_key_exists(\'select\',$map)?$map[\'select\']:\'\',array_key_exists(\'zone\',$map)?$map[\'zone\']:get_module_zone(\'news\'),array_key_exists(\'select_and\',$map)?$map[\'select_and\']:\'\',array_key_exists(\'check\',$map)?($map[\'check\']==\'1\'):true)';
        $info['special_cache_flags'] = CACHE_AGAINST_DEFAULT | CACHE_AGAINST_PERMISSIVE_GROUPS;
        if (addon_installed('content_privacy')) {
            $info['special_cache_flags'] |= CACHE_AGAINST_MEMBER;
        }
        $info['ttl'] = (get_value('disable_block_timeout') === '1') ? 60 * 60 * 24 * 365 * 5/*5 year timeout*/ : 60;
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
        if (!addon_installed__messaged('news', $error_msg)) {
            return $error_msg;
        }

        if (!addon_installed('news_shared')) {
            return do_template('RED_ALERT', array('_GUID' => 'd791iqh0ytnpf0azwolpxojd881q9ir2', 'TEXT' => do_lang_tempcode('MISSING_ADDON', escape_html('news_shared'))));
        }

        require_lang('cns');
        require_lang('news');
        require_css('news');
        require_code('news');
        require_code('images');

        $block_id = get_block_id($map);

        $check_perms = array_key_exists('check', $map) ? ($map['check'] == '1') : true;

        // Read in parameters
        $days = isset($map['param']) ? intval($map['param']) : 14;
        $multiplier = isset($map['multiplier']) ? floatval($map['multiplier']) : 0.5;
        $fallback_full = isset($map['fallback_full']) ? intval($map['fallback_full']) : 3;
        $fallback_archive = isset($map['fallback_archive']) ? intval($map['fallback_archive']) : 6;
        $zone = isset($map['zone']) ? $map['zone'] : get_module_zone('news');
        $historic = isset($map['historic']) ? $map['historic'] : '';
        $filter = isset($map['filter']) ? $map['filter'] : '';
        $blogs = isset($map['blogs']) ? intval($map['blogs']) : -1;
        $member_based = (isset($map['member_based'])) && ($map['member_based'] == '1');
        $attach_to_url_filter = ((isset($map['attach_to_url_filter']) ? $map['attach_to_url_filter'] : '0') == '1');
        $optimise = (array_key_exists('optimise', $map)) && ($map['optimise'] == '1');

        // Pagination
        $start = get_param_integer($block_id . '_start', isset($map['start']) ? intval($map['start']) : 0);
        if ($start != 0) {
            $days = 0;
        }
        $do_pagination = ((isset($map['pagination']) ? $map['pagination'] : '0') == '1');

        // Read in news categories ahead, for performance
        global $NEWS_CATS_CACHE;
        if (!isset($NEWS_CATS_CACHE)) {
            $NEWS_CATS_CACHE = $GLOBALS['SITE_DB']->query_select('news_categories', array('*'), array('nc_owner' => null));
            $NEWS_CATS_CACHE = list_to_map('id', $NEWS_CATS_CACHE);
        }

        // Work out how many days to show
        $days_full = floatval($days) * $multiplier;
        $days_outline = floatval($days) - $days_full;

        // News query
        $select = isset($map['select']) ? $map['select'] : '*';
        $select_and = isset($map['select_and']) ? $map['select_and'] : '';
        $q_filter = '1=1';
        if ($select != '*') {
            $q_filter .= ' AND ' . $this->generate_selectcode_sql($select);
        }
        if (($select_and != '') && ($select_and != '*')) {
            $q_filter .= ' AND ' . $this->generate_selectcode_sql($select_and);
        }
        if ($blogs === 0) {
            if ($q_filter != '') {
                $q_filter .= ' AND ';
            }
            $q_filter .= 'nc_owner IS NULL';
        } elseif ($blogs === 1) {
            if ($q_filter != '') {
                $q_filter .= ' AND ';
            }
            $q_filter .= '(nc_owner IS NOT NULL)';
        }
        if ($blogs != -1) {
            $join = ' LEFT JOIN ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news_categories c ON c.id=r.news_category';
        } else {
            $join = '';
        }

        // Filtercode
        if ($filter != '') {
            require_code('filtercode');
            list($filter_extra_select, $filter_extra_join, $filter_extra_where) = filtercode_to_sql($GLOBALS['SITE_DB'], parse_filtercode($filter), 'news');
            $extra_select_sql = implode('', $filter_extra_select);
            $join .= implode('', $filter_extra_join);
            $q_filter .= $filter_extra_where;
        } else {
            $extra_select_sql = '';
        }

        if (addon_installed('content_privacy')) {
            require_code('content_privacy');
            $as_guest = array_key_exists('as_guest', $map) ? ($map['as_guest'] == '1') : false;
            $viewing_member_id = $as_guest ? $GLOBALS['FORUM_DRIVER']->get_guest_id() : null;
            list($privacy_join, $privacy_where) = get_privacy_where_clause('news', 'r', $viewing_member_id);
            $join .= $privacy_join;
            $q_filter .= $privacy_where;
        }

        if (get_option('filter_regions') == '1') {
            require_code('locations');
            $q_filter .= sql_region_filter('news', 'r.id');
        }

        if ((!$GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) && ($check_perms)) {
            $join .= get_permission_join_clause('news', 'news_category');
            $q_filter .= get_permission_where_clause(get_member(), get_permission_where_clause_groups(get_member()));
        }

        // Read in rows
        $max_rows = $GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(DISTINCT r.id) FROM ' . get_table_prefix() . 'news r LEFT JOIN ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news_category_entries d ON d.news_entry=r.id' . $join . ' WHERE ' . $q_filter . ((!has_privilege(get_member(), 'see_unvalidated')) ? ' AND validated=1' : ''), false, true);
        if ($historic == '') {
            $rows = ($days_full == 0.0) ? array() : $GLOBALS['SITE_DB']->query('SELECT *,r.id AS p_id' . $extra_select_sql . ' FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news r LEFT JOIN ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news_category_entries d ON d.news_entry=r.id' . $join . ' WHERE ' . $q_filter . ((!has_privilege(get_member(), 'see_unvalidated')) ? ' AND validated=1' : '') . ' AND date_and_time>=' . strval(time() - 60 * 60 * 24 * intval($days_full)) . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY r.id' : '') . ' ORDER BY r.date_and_time DESC', max($fallback_full + $fallback_archive, 30)/*reasonable limit*/, 0, false, false, array('title' => 'SHORT_TRANS', 'news' => 'LONG_TRANS', 'news_article' => 'LONG_TRANS'));
            if (!isset($rows[0])) { // Nothing recent, so we work to get at least something
                $rows = ($fallback_full == 0) ? array() : $GLOBALS['SITE_DB']->query('SELECT *,r.id AS p_id' . $extra_select_sql . ' FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news r LEFT JOIN ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news_category_entries d ON r.id=d.news_entry' . $join . ' WHERE ' . $q_filter . ((!has_privilege(get_member(), 'see_unvalidated')) ? ' AND validated=1' : '') . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY r.id' : '') . ' ORDER BY r.date_and_time DESC', $fallback_full, $start, false, true, array('title' => 'SHORT_TRANS', 'news' => 'LONG_TRANS', 'news_article' => 'LONG_TRANS'));
                $rows2 = ($fallback_archive == 0) ? array() : $GLOBALS['SITE_DB']->query('SELECT *,r.id AS p_id' . $extra_select_sql . ' FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news r LEFT JOIN ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news_category_entries d ON r.id=d.news_entry' . $join . ' WHERE ' . $q_filter . ((!has_privilege(get_member(), 'see_unvalidated')) ? ' AND validated=1' : '') . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY r.id' : '') . ' ORDER BY r.date_and_time DESC', $fallback_archive, $fallback_full + $start, false, true, array('title' => 'SHORT_TRANS', 'news' => 'LONG_TRANS', 'news_article' => 'LONG_TRANS'));
            } else {
                $rows2 = $GLOBALS['SITE_DB']->query('SELECT *,r.id AS p_id' . $extra_select_sql . ' FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news r LEFT JOIN ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news_category_entries d ON r.id=d.news_entry' . $join . ' WHERE ' . $q_filter . ((!has_privilege(get_member(), 'see_unvalidated')) ? ' AND validated=1' : '') . ' AND date_and_time>=' . strval(time() - 60 * 60 * 24 * intval($days_full + $days_outline)) . ' AND date_and_time<' . strval(time() - 60 * 60 * 24 * intval($days_full)) . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY r.id' : '') . ' ORDER BY r.date_and_time DESC', max($fallback_full + $fallback_archive, 30)/*reasonable limit*/, 0, false, false, array('title' => 'SHORT_TRANS', 'news' => 'LONG_TRANS', 'news_article' => 'LONG_TRANS'));
            }
        } else {
            if (php_function_allowed('set_time_limit')) {
                @set_time_limit(100);
            }
            $start = 0;
            do {
                $_rows = $GLOBALS['SITE_DB']->query('SELECT *,r.id AS p_id' . $extra_select_sql . ' FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news r LEFT JOIN ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news_category_entries d ON r.id=d.news_entry' . $join . ' WHERE ' . $q_filter . ((!has_privilege(get_member(), 'see_unvalidated')) ? ' AND validated=1' : '') . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY r.id' : '') . ' ORDER BY r.date_and_time DESC', 200, $start, false, true);
                $rows = array();
                $rows2 = array();
                foreach ($_rows as $row) {
                    $ok = false;
                    switch ($historic) {
                        case 'month':
                            if ((date('m', utctime_to_usertime($row['date_and_time'])) == date('m', utctime_to_usertime())) && (date('Y', utctime_to_usertime($row['date_and_time'])) != date('Y', utctime_to_usertime()))) {
                                $ok = true;
                            }
                            break;

                        case 'week':
                            if ((date('W', utctime_to_usertime($row['date_and_time'])) == date('W', utctime_to_usertime())) && (date('Y', utctime_to_usertime($row['date_and_time'])) != date('Y', utctime_to_usertime()))) {
                                $ok = true;
                            }
                            break;

                        case 'day':
                            if ((date('d', utctime_to_usertime($row['date_and_time'])) == date('d', utctime_to_usertime())) && (date('m', utctime_to_usertime($row['date_and_time'])) == date('m', utctime_to_usertime())) && (date('Y', utctime_to_usertime($row['date_and_time'])) != date('Y', utctime_to_usertime()))) {
                                $ok = true;
                            }
                            break;
                    }
                    if ($ok) {
                        if (count($rows) < $fallback_full) {
                            $rows[] = $row;
                        } elseif (count($rows2) < $fallback_archive) {
                            $rows2[] = $row;
                        } else {
                            break 2;
                        }
                    }
                }
                $start += 200;
            } while (count($_rows) == 200);
            unset($_rows);
        }
        $rows = remove_duplicate_rows($rows, 'p_id');

        // Shared calculations
        $show_in_full = (isset($map['show_in_full'])) && ($map['show_in_full'] == '1');
        $show_author = (addon_installed('authors')) && (!$member_based);
        $prop_url = array();
        if ($attach_to_url_filter) {
            $prop_url += propagate_filtercode();
        }
        if ($select != '*') {
            $prop_url['select'] = $select;
        }
        if (($select_and != '*') && ($select_and != '')) {
            $prop_url['select_and'] = $select_and;
        }
        if ($blogs != -1) {
            $prop_url['blog'] = $blogs;
        }
        $allow_comments_shared = (get_option('is_on_comments') == '1') && (!has_no_forum());
        $base_url = get_base_url();

        // Render loop
        $news_text = new Tempcode();
        foreach ($rows as $i => $myrow) {
            $just_news_row = db_map_restrict($myrow, array('id', 'title', 'news', 'news_article'));

            // Basic details
            $id = $myrow['p_id'];
            $date = get_timezoned_date_time_tempcode($myrow['date_and_time']);
            $news_title = get_translated_tempcode('news', $just_news_row, 'title');
            $news_title_plain = get_translated_text($myrow['title']);

            // Author
            $author_url = new Tempcode();
            if ($show_author) {
                $url_map = array('page' => 'authors', 'type' => 'browse', 'id' => $myrow['author']);
                if ($attach_to_url_filter) {
                    $url_map += propagate_filtercode();
                }
                $author_url = build_url($url_map, get_module_zone('authors'));
            }
            $author = $myrow['author'];

            // Text
            if ($optimise) {
                if ($show_in_full) {
                    $news = get_translated_tempcode__and_simplify('news', $just_news_row, 'news_article');
                    $truncate = false;
                    if ($news->is_empty()) {
                        $news = get_translated_tempcode__and_simplify('news', $just_news_row, 'news');
                    }
                } else {
                    $news = get_translated_tempcode__and_simplify('news', $just_news_row, 'news');
                    if ($news->is_empty()) {
                        $news = get_translated_tempcode__and_simplify('news', $just_news_row, 'news_article');
                        $truncate = true;
                    } else {
                        $truncate = false;
                    }
                }
            } else {
                if ($show_in_full) {
                    $news = get_translated_tempcode('news', $just_news_row, 'news_article');
                    $truncate = false;
                    if ($news->is_empty()) {
                        $news = get_translated_tempcode('news', $just_news_row, 'news');
                    }
                } else {
                    $news = get_translated_tempcode('news', $just_news_row, 'news');
                    if ($news->is_empty()) {
                        $news = get_translated_tempcode('news', $just_news_row, 'news_article');
                        $truncate = true;
                    } else {
                        $truncate = false;
                    }
                }
            }

            // URL
            $tmp = array('page' => ($zone == '_SELF' && running_script('index')) ? get_page_name() : 'news', 'type' => 'view', 'id' => $id) + $prop_url;
            $full_url = build_url($tmp, $zone);

            // Category
            if (!isset($NEWS_CATS_CACHE[$myrow['news_category']])) {
                $_news_cats = $GLOBALS['SITE_DB']->query_select('news_categories', array('*'), array('id' => $myrow['news_category']), '', 1);
                if (isset($_news_cats[0])) {
                    $NEWS_CATS_CACHE[$myrow['news_category']] = $_news_cats[0];
                } else {
                    $myrow['news_category'] = db_get_first_id();
                }
            }
            $news_cat_row = $NEWS_CATS_CACHE[$myrow['news_category']];

            $category = get_translated_text($news_cat_row['nc_title']);
            if ($myrow['news_image'] != '') {
                $img_raw = $myrow['news_image'];
                if (url_is_local($img_raw)) {
                    $img_raw = $base_url . '/' . $img_raw;
                }
                $img = $img_raw;
            } else {
                $img_raw = get_news_category_image_url($news_cat_row['nc_img']);
                $img = $img_raw;
            }

            // SEO
            $seo_bits = (get_value('disable_tags') === '1') ? array('', '') : seo_meta_get_for('news', strval($id));

            // Render
            $map2 = array(
                'GIVE_CONTEXT' => false,
                'TAGS' => get_loaded_tags('news', explode(',', $seo_bits[0])),
                'ID' => strval($id),
                'TRUNCATE' => $truncate,
                'BLOG' => $blogs === 1,
                'SUBMITTER' => strval($myrow['submitter']),
                'CATEGORY' => $category,
                '_CATEGORY' => strval($myrow['news_category']),
                'IMG' => $img,
                '_IMG' => $img_raw,
                'DATE' => $date,
                'DATE_RAW' => strval($myrow['date_and_time']),
                'NEWS_TITLE' => $news_title,
                'NEWS_TITLE_PLAIN' => $news_title_plain,
                'AUTHOR' => $author,
                'AUTHOR_URL' => $author_url,
                'NEWS' => $news,
                'FULL_URL' => $full_url,
            );
            if (($allow_comments_shared) && ($myrow['allow_comments'] >= 1)) {
                $map2['COMMENT_COUNT'] = '1';
            }
            $news_text->attach(do_template('NEWS_BOX', $map2));
        }
        $news_text2 = new Tempcode();
        foreach ($rows2 as $j => $myrow) {
            $just_news_row = db_map_restrict($myrow, array('id', 'title', 'news', 'news_article'));

            // Basic details
            $date = get_timezoned_date_time_tempcode($myrow['date_and_time']);

            // URL
            $tmp = array('page' => ($zone == '_SELF' && running_script('index')) ? get_page_name() : 'news', 'type' => 'view', 'id' => $myrow['p_id']) + $prop_url;
            $url = build_url($tmp, $zone);

            // Title
            $title = get_translated_tempcode('news', $just_news_row, 'title');
            $title_plain = get_translated_text($myrow['title']);

            // Render
            $seo_bits = (get_value('disable_tags') === '1') ? array('', '') : seo_meta_get_for('news', strval($myrow['p_id']));
            $map2 = array('_GUID' => 'd81bda3a0912a1e708af6bb1f503b296', 'TAGS' => get_loaded_tags('news', explode(',', $seo_bits[0])), 'BLOG' => $blogs === 1, 'ID' => strval($myrow['p_id']), 'SUBMITTER' => strval($myrow['submitter']), 'DATE' => $date, 'DATE_RAW' => strval($myrow['date_and_time']), 'FULL_URL' => $url, 'NEWS_TITLE_PLAIN' => $title_plain, 'NEWS_TITLE' => $title);
            if (($allow_comments_shared) && ($myrow['allow_comments'] >= 1)) {
                $map2['COMMENT_COUNT'] = '1';
            }
            $news_text2->attach(do_template('NEWS_BRIEF', $map2));
        }

        // Work out management URLs
        $tmp = array('page' => ($zone == '_SELF' && running_script('index')) ? get_page_name() : 'news', 'type' => 'browse');
        if ($select != '*') {
            $tmp[is_numeric($select) ? 'id' : 'select'] = $select;
        }
        if (($select_and != '*') && ($select_and != '')) {
            $tmp['select_and'] = $select_and;
        }
        if ($blogs != -1) {
            $tmp['blog'] = $blogs;
        }
        $archive_url = build_url($tmp, $zone);
        $_is_on_rss = get_option('is_rss_advertised', true);
        $is_on_rss = ($_is_on_rss === null) ? 0 : intval($_is_on_rss); // Set to zero if we don't want to show RSS links
        $submit_url = new Tempcode();
        $management_page = ($blogs === 1) ? 'cms_blogs' : 'cms_news';
        if ((($blogs !== 1) || (has_privilege(get_member(), 'have_personal_category', 'cms_news'))) && (has_actual_page_access(null, $management_page, null, null)) && (has_submit_permission(($blogs === 1) ? 'mid' : 'high', get_member(), get_ip_address(), $management_page))) {
            $map2 = array('page' => $management_page, 'type' => 'add');
            if (is_numeric($select)) {
                $map2['cat'] = $select; // select news cat by default, if we are only showing one news cat in this block
            } elseif ($select != '*') {
                $pos_a = strpos($select, ',');
                $pos_b = strpos($select, '-');
                if ($pos_a !== false) {
                    $first_cat = substr($select, 0, $pos_a);
                } elseif ($pos_b !== false) {
                    $first_cat = substr($select, 0, $pos_b);
                } else {
                    $first_cat = '';
                }
                if (is_numeric($first_cat)) {
                    $map2['cat'] = $first_cat;
                }
            }
            $map2['redirect'] = protect_url_parameter(SELF_REDIRECT_RIP);
            $submit_url = build_url($map2, get_module_zone($management_page));
        }

        // Block title
        $_title = isset($map['title']) ? protect_from_escaping(escape_html($map['title'])) : do_lang_tempcode(($blogs == 1) ? 'BLOGS_POSTS' : 'NEWS');

        // Feed URLs
        $atom_url = new Tempcode();
        $rss_url = new Tempcode();
        if ($is_on_rss == 1) {
            $atom_url = make_string_tempcode(find_script('backend') . '?type=atom&mode=news&select=' . urlencode($select));
            $atom_url->attach(symbol_tempcode('KEEP'));
            $rss_url = make_string_tempcode(find_script('backend') . '?type=rss2&mode=news&select=' . urlencode($select));
            $rss_url->attach(symbol_tempcode('KEEP'));
        }

        // Wipe out management/feed URLs if no links was requested
        if ((isset($map['no_links'])) && ($map['no_links'] == '1')) {
            $submit_url = new Tempcode();
            $archive_url = new Tempcode();
            $atom_url = new Tempcode();
            $rss_url = new Tempcode();
        }

        if ((count($rows) == 0) && (count($rows2) == 0)) {
            if ((!isset($map['render_if_empty'])) || ($map['render_if_empty'] == '0')) {
                return do_template('BLOCK_NO_ENTRIES', array(
                    '_GUID' => '9d7065af4dd4026ffb34243fd931f99d',
                    'BLOCK_ID' => $block_id,
                    'HIGH' => false,
                    'TITLE' => $_title,
                    'MESSAGE' => do_lang_tempcode(($blogs == 1) ? 'BLOG_NO_NEWS' : 'NO_NEWS'),
                    'ADD_NAME' => do_lang_tempcode(($blogs == 1) ? 'ADD_NEWS_BLOG' : 'ADD_NEWS'),
                    'SUBMIT_URL' => $submit_url,
                ));
            }
        }

        // Pagination
        $pagination = null;
        if ($do_pagination) {
            require_code('templates_pagination');
            $pagination = pagination(do_lang_tempcode('NEWS'), $start, $block_id . '_start', $fallback_full + $fallback_archive, $block_id . '_max', $max_rows);
        }

        return do_template('BLOCK_MAIN_NEWS', array(
            '_GUID' => '01f5fbd2b0c7c8f249023ecb4254366e',
            'BLOCK_ID' => $block_id,
            'BLOCK_PARAMS' => block_params_arr_to_str(array('block_id' => $block_id) + $map),
            'BLOG' => $blogs === 1,
            'TITLE' => $_title,
            'CONTENT' => $news_text,
            'BRIEF' => $news_text2,
            'FILTER' => $filter,
            'ARCHIVE_URL' => $archive_url,
            'SUBMIT_URL' => $submit_url,
            'RSS_URL' => $rss_url,
            'ATOM_URL' => $atom_url,
            'PAGINATION' => $pagination,
            'START' => strval($start),
            'MAX' => strval($fallback_full + $fallback_archive),
            'START_PARAM' => $block_id . '_start',
            'MAX_PARAM' => $block_id . '_max',
        ));
    }

    /**
     * Generate Selectcode SQL.
     *
     * @param  string $select The Selectcode
     * @return string The SQL
     */
    protected function generate_selectcode_sql($select)
    {
        require_code('selectcode');
        $selects_1 = selectcode_to_sqlfragment($select, 'r.id', 'news_categories', null, 'r.news_category', 'id');
        $selects_2 = selectcode_to_sqlfragment($select, 'r.id', 'news_categories', null, 'd.news_category', 'id');
        if ((strpos($select, '~') === false) && (strpos($select, '!') === false)) {
            $q_filter = '(' . $selects_1 . ' OR ' . $selects_2 . ')';
        } else {
            $q_filter = '(' . $selects_1 . ' AND (' . $selects_2 . ' OR d.news_entry_category IS NULL))';
        }
        return $q_filter;
    }
}

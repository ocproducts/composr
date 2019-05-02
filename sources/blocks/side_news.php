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
 * @package    news
 */

/**
 * Block class.
 */
class Block_side_news
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
        $info['parameters'] = array('param', 'blogs', 'historic', 'zone', 'select', 'select_and', 'title', 'as_guest', 'check');
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
        $info['cache_on'] = 'array(array_key_exists(\'title\',$map)?$map[\'title\']:\'\',array_key_exists(\'blogs\',$map)?$map[\'blogs\']:\'-1\',array_key_exists(\'historic\',$map)?$map[\'historic\']:\'\',array_key_exists(\'as_guest\',$map)?($map[\'as_guest\']==\'1\'):false,array_key_exists(\'zone\',$map)?$map[\'zone\']:get_module_zone(\'news\'),array_key_exists(\'select\',$map)?$map[\'select\']:\'\',array_key_exists(\'param\',$map)?intval($map[\'param\']):5,array_key_exists(\'select_and\',$map)?$map[\'select_and\']:\'\',array_key_exists(\'check\',$map)?($map[\'check\']==\'1\'):true)';
        $info['special_cache_flags'] = CACHE_AGAINST_DEFAULT | CACHE_AGAINST_PERMISSIVE_GROUPS;
        if (addon_installed('content_privacy')) {
            $info['special_cache_flags'] |= CACHE_AGAINST_MEMBER;
        }
        $info['ttl'] = (get_value('disable_block_timeout') === '1') ? 60 * 60 * 24 * 365 * 5/*5 year timeout*/ : 15;
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
            return do_template('RED_ALERT', array('_GUID' => '2xrvldyykmd1p8qonelxje3rgzstfpwt', 'TEXT' => do_lang_tempcode('MISSING_ADDON', escape_html('news_shared'))));
        }

        require_lang('news');
        require_css('news');
        require_code('news');

        $block_id = get_block_id($map);

        $check_perms = array_key_exists('check', $map) ? ($map['check'] == '1') : true;

        $max = empty($map['param']) ? 5 : intval($map['param']);
        $zone = array_key_exists('zone', $map) ? $map['zone'] : get_module_zone('news');
        $blogs = array_key_exists('blogs', $map) ? intval($map['blogs']) : -1;
        $historic = array_key_exists('historic', $map) ? $map['historic'] : '';
        $select_and = array_key_exists('select_and', $map) ? $map['select_and'] : '';

        global $NEWS_CATS_CACHE;
        if (!isset($NEWS_CATS_CACHE)) {
            $NEWS_CATS_CACHE = $GLOBALS['SITE_DB']->query_select('news_categories', array('*'), array('nc_owner' => null));
            $NEWS_CATS_CACHE = list_to_map('id', $NEWS_CATS_CACHE);
        }

        $content = new Tempcode();

        // News Query
        $select = isset($map['select']) ? $map['select'] : '*';
        if ($select == '*') {
            $q_filter = '1=1';
        } else {
            require_code('selectcode');
            $selects_1 = selectcode_to_sqlfragment($select, 'r.id', 'news_categories', null, 'p.news_category', 'id');
            $selects_2 = selectcode_to_sqlfragment($select, 'r.id', 'news_categories', null, 'd.news_category', 'id');
            $q_filter = '(' . $selects_1 . ' OR ' . $selects_2 . ')';
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
            $join = ' LEFT JOIN ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'news_categories c ON c.id=p.news_category';
        } else {
            $join = '';
        }

        if ($select_and != '') {
            $selects_and_1 = selectcode_to_sqlfragment($select_and, 'r.id', 'news_categories', null, 'p.news_category', 'id');
            $selects_and_2 = selectcode_to_sqlfragment($select_and, 'r.id', 'news_categories', null, 'd.news_category', 'id');
            $q_filter .= ' AND (' . $selects_and_1 . ' OR ' . $selects_and_2 . ')';
        }

        if (addon_installed('content_privacy')) {
            require_code('content_privacy');
            $as_guest = array_key_exists('as_guest', $map) ? ($map['as_guest'] == '1') : false;
            $viewing_member_id = $as_guest ? $GLOBALS['FORUM_DRIVER']->get_guest_id() : null;
            list($privacy_join, $privacy_where) = get_privacy_where_clause('news', 'p', $viewing_member_id);
            $join .= $privacy_join;
            $q_filter .= $privacy_where;
        }

        if (get_option('filter_regions') == '1') {
            require_code('locations');
            $q_filter .= sql_region_filter('news', 'p.id');
        }

        if ((!$GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) && ($check_perms)) {
            $join .= get_permission_join_clause('news', 'news_category', 'a', 'ma', 'p');
            $q_filter .= get_permission_where_clause(get_member(), get_permission_where_clause_groups(get_member()));
        }

        if ($historic == '') {
            $news = $GLOBALS['SITE_DB']->query('SELECT p.* FROM ' . get_table_prefix() . 'news p LEFT JOIN ' . get_table_prefix() . 'news_category_entries d ON d.news_entry=p.id' . $join . ' WHERE ' . $q_filter . ' AND validated=1' . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY p.id' : '') . ' ORDER BY date_and_time DESC', $max, 0, false, true);
        } else {
            if (php_function_allowed('set_time_limit')) {
                @set_time_limit(100);
            }
            $start = 0;
            do {
                $_rows = $GLOBALS['SITE_DB']->query('SELECT p.* FROM ' . get_table_prefix() . 'news p LEFT JOIN ' . get_table_prefix() . 'news_category_entries d ON p.id=d.news_entry' . $join . ' WHERE ' . $q_filter . ' AND validated=1' . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY p.id' : '') . ' ORDER BY p.date_and_time DESC', 200, $start, false, true);
                $news = array();
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
                            if ((date('d', utctime_to_usertime($row['date_and_time'])) == date('d', utctime_to_usertime())) && (date('Y', utctime_to_usertime($row['date_and_time'])) != date('Y', utctime_to_usertime()))) {
                                $ok = true;
                            }
                            break;
                    }
                    if ($ok) {
                        if (count($news) < $max) {
                            $news[] = $row;
                        } else {
                            break;
                        }
                    }
                }
                $start += 200;
            } while ((count($_rows) == 200) && (count($news) < $max));
            unset($_rows);
        }
        $news = remove_duplicate_rows($news, 'id');

        $_title = do_lang_tempcode(($blogs === 1) ? 'BLOGS_POSTS' : 'NEWS');
        if ((array_key_exists('title', $map)) && ($map['title'] != '')) {
            $_title = protect_from_escaping(escape_html($map['title']));
        }

        $base_url = get_base_url();

        foreach ($news as $myrow) {
            $url_map = array('page' => 'news', 'type' => 'view', 'id' => $myrow['id']);
            if ($select != '*') {
                $url_map['select'] = $select;
            }
            if (($select_and != '*') && ($select_and != '')) {
                $url_map['select_and'] = $select_and;
            }
            if ($blogs === 1) {
                $url_map['blog'] = 1;
            }
            $full_url = build_url($url_map, $zone);

            $just_news_row = db_map_restrict($myrow, array('id', 'title', 'news', 'news_article'));

            $news_title = get_translated_tempcode('news', $just_news_row, 'title');

            $date = cms_strftime(do_lang('date_concise_near_date'), utctime_to_usertime($myrow['date_and_time']));

            $summary = get_translated_tempcode('news', $just_news_row, 'news');
            if ($summary->is_empty()) {
                $summary = get_translated_tempcode('news', $just_news_row, 'news_article');
            }

            if (!array_key_exists($myrow['news_category'], $NEWS_CATS_CACHE)) {
                $_news_cats = $GLOBALS['SITE_DB']->query_select('news_categories', array('*'), array('id' => $myrow['news_category']), '', 1);
                if (array_key_exists(0, $_news_cats)) {
                    $NEWS_CATS_CACHE[$myrow['news_category']] = $_news_cats[0];
                }
            }
            $news_cat_row = $NEWS_CATS_CACHE[$myrow['news_category']];

            $category = get_translated_text($news_cat_row['nc_title']);
            if ($myrow['news_image'] != '') {
                $img_raw = $myrow['news_image'];
                if (url_is_local($img_raw)) {
                    $img_raw = $base_url . '/' . $img_raw;
                }
            } else {
                $img_raw = get_news_category_image_url($news_cat_row['nc_img']);
            }

            $content->attach(do_template('BLOCK_SIDE_NEWS_SUMMARY', array(
                '_GUID' => 'f7bc5288680e68641ca94ca4a3111d4a',
                'BLOCK_ID' => $block_id,
                'IMG_URL' => $img_raw,
                'AUTHOR' => $myrow['author'],
                'ID' => strval($myrow['id']),
                'SUBMITTER' => strval($myrow['submitter']),
                'CATEGORY' => $category,
                'BLOG' => $blogs === 1,
                'FULL_URL' => $full_url,
                'NEWS' => $summary,
                'NEWS_TITLE' => $news_title,
                '_DATE' => strval($myrow['date_and_time']),
                'DATE' => $date,
            )));
        }

        // Work out management URLs
        $tmp = array('page' => 'news', 'type' => 'browse');
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

        if ((($blogs !== 1) || (has_privilege(get_member(), 'have_personal_category', 'cms_news'))) && (has_actual_page_access(null, ($blogs === 1) ? 'cms_blogs' : 'cms_news', null, null)) && (has_submit_permission(($blogs === 1) ? 'mid' : 'high', get_member(), get_ip_address(), ($blogs === 1) ? 'cms_blogs' : 'cms_news'))) {
            $map2 = array('page' => ($blogs === 1) ? 'cms_blogs' : 'cms_news', 'type' => 'add', 'redirect' => protect_url_parameter(SELF_REDIRECT_RIP));
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
            if ($historic == '') {
                $submit_url = build_url($map2, get_module_zone(($blogs === 1) ? 'cms_blogs' : 'cms_news'));
            }
        }

        return do_template('BLOCK_SIDE_NEWS', array(
            '_GUID' => '611b83965c4b6e42fb4a709d94c332f7',
            'BLOCK_ID' => $block_id,
            'BLOG' => $blogs === 1,
            'TITLE' => $_title,
            'CONTENT' => $content,
            'SUBMIT_URL' => $submit_url,
            'ARCHIVE_URL' => $archive_url,
        ));
    }
}

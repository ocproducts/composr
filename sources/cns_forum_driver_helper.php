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
 * @package    core_cns
 */

/* This file exists to alleviate PHP memory usage. It shaves over 100KB of memory need for any Conversr request. */

/**
 * Get a map between emoticon codes and templates representing the HTML-image-code for this emoticon. The emoticons presented of course depend on the forum involved.
 *
 * @param  object $this_ref Link to the real forum driver
 * @param  ?MEMBER $member_id Only emoticons the given member can see (null: don't care)
 * @return array The map
 *
 * @ignore
 */
function _helper_apply_emoticons($this_ref, $member_id = null)
{
    global $IN_MINIKERNEL_VERSION;
    if ($IN_MINIKERNEL_VERSION) {
        return array();
    }

    $extra = '';
    if ($member_id === null) {
        global $EMOTICON_LEVELS;
        if ($this_ref->EMOTICON_CACHE !== null) {
            return $this_ref->EMOTICON_CACHE;
        }
    } else {
        $extra = has_privilege(get_member(), 'use_special_emoticons') ? '' : ' AND e_is_special=0';
    }
    $this_ref->EMOTICON_CACHE = array();
    $EMOTICON_LEVELS = array();

    $query = 'SELECT e_code,e_theme_img_code,e_relevance_level FROM ' . $this_ref->db->get_table_prefix() . 'f_emoticons WHERE e_relevance_level<4' . $extra;
    if ($this_ref->db->has_expression_ordering()) {
        $query .= ' ORDER BY LENGTH(e_code) DESC';
    }
    $rows = $this_ref->db->query($query);
    foreach ($rows as $myrow) {
        $tpl = 'EMOTICON_IMG_CODE_THEMED';
        $this_ref->EMOTICON_CACHE[$myrow['e_code']] = array($tpl, $myrow['e_theme_img_code'], $myrow['e_code']);
        $EMOTICON_LEVELS[$myrow['e_code']] = $myrow['e_relevance_level'];
    }
    if (!$this_ref->db->has_expression_ordering()) {
        uksort($this_ref->EMOTICON_CACHE, '_strlen_sort');
        $this_ref->EMOTICON_CACHE = array_reverse($this_ref->EMOTICON_CACHE);
    }
    return $this_ref->EMOTICON_CACHE;
}

/**
 * Makes a post in the specified forum, in the specified topic according to the given specifications. If the topic doesn't exist, it is created along with a spacer-post.
 * Spacer posts exist in order to allow staff to delete the first true post in a topic. Without spacers, this would not be possible with most forum systems. They also serve to provide meta information on the topic that cannot be encoded in the title (such as a link to the content being commented upon).
 *
 * @param  object $this_ref Link to the real forum driver
 * @param  SHORT_TEXT $forum_name The forum name
 * @param  SHORT_TEXT $topic_identifier The topic identifier (usually <content-type>_<content-id>)
 * @param  MEMBER $member_id The member ID
 * @param  LONG_TEXT $post_title The post title
 * @param  LONG_TEXT $post The post content in Comcode format
 * @param  string $content_title The topic title; must be same as content title if this is for a comment topic
 * @param  string $topic_identifier_encapsulation_prefix This is put together with the topic identifier to make a more-human-readable topic title or topic description (hopefully the latter and a $content_title title, but only if the forum supports descriptions)
 * @param  ?URLPATH $content_url URL to the content (null: do not make spacer post)
 * @param  ?TIME $time The topic time (null: use current time)
 * @param  ?IP $ip The post IP address (null: use current members IP address)
 * @param  ?BINARY $validated Whether the post is validated (null: unknown, find whether it needs to be marked unvalidated initially). This only works with the Conversr driver.
 * @param  ?BINARY $topic_validated Whether the topic is validated (null: unknown, find whether it needs to be marked unvalidated initially). This only works with the Conversr driver.
 * @param  boolean $skip_post_checks Whether to skip post checks
 * @param  SHORT_TEXT $poster_name_if_guest The name of the poster
 * @param  ?AUTO_LINK $parent_id ID of post being replied to (null: N/A)
 * @param  boolean $staff_only Whether the reply is only visible to staff
 * @param  ?ID_TEXT $no_notify_for__notification_code DO NOT send notifications to: The notification code (null: no restriction)
 * @param  ?SHORT_TEXT $no_notify_for__code_category DO NOT send notifications to: The category within the notification code (null: none / no restriction)
 * @param  ?TIME $time_post The post time (null: use current time)
 * @param  ?MEMBER $spacer_post_member_id Owner of comment topic (null: Guest)
 * @return array Topic ID (may be null), and whether a hidden post has been made
 *
 * @ignore
 */
function _helper_make_post_forum_topic($this_ref, $forum_name, $topic_identifier, $member_id, $post_title, $post, $content_title, $topic_identifier_encapsulation_prefix, $content_url, $time, $ip, $validated, $topic_validated, $skip_post_checks, $poster_name_if_guest, $parent_id, $staff_only, $no_notify_for__notification_code, $no_notify_for__code_category, $time_post, $spacer_post_member_id)
{
    if (is_null($time)) {
        $time = time();
    }
    if (is_null($ip)) {
        $ip = get_ip_address();
    }
    if (is_null($spacer_post_member_id)) {
        $spacer_post_member_id = $this_ref->get_guest_id();
    }

    require_code('comcode_check');
    check_comcode($post, null, false, null, true);

    require_code('cns_topics');
    require_code('cns_posts');
    require_lang('cns');
    require_code('cns_posts_action');
    require_code('cns_posts_action2');

    if (!is_integer($forum_name)) {
        $forum_id = $this_ref->forum_id_from_name($forum_name);
        if (is_null($forum_id)) {
            warn_exit(do_lang_tempcode('MISSING_FORUM', escape_html($forum_name)), false, true);
        }
    } else {
        $forum_id = (integer)$forum_name;
    }

    $topic_id = $this_ref->find_topic_id_for_topic_identifier($forum_name, $topic_identifier, $topic_identifier_encapsulation_prefix);

    $update_caching = false;
    $support_attachments = false;
    if (!get_mass_import_mode()) {
        $update_caching = true;
        $support_attachments = true;
    }

    if (is_null($topic_id)) {
        $is_starter = true;

        require_code('cns_topics_action');
        $topic_id = cns_make_topic($forum_id, $topic_identifier_encapsulation_prefix . ': #' . $topic_identifier, '', $topic_validated, 1, 0, 0, null, null, false, 0, null, is_null($content_url) ? '' : $content_url);

        if (strpos($topic_identifier, ':') !== false) {
            // Sync comment_posted ones to also monitor the forum ones; no need for opposite way as comment ones already trigger forum ones
            $start = 0;
            $max = 300;
            require_code('notifications');
            $ob = _get_notification_ob_for_code('comment_posted');
            do {
                list($members, $possibly_has_more) = $ob->list_members_who_have_enabled('comment_posted', $topic_identifier, null, $start, $max);

                foreach ($members as $to_member_id => $setting) {
                    enable_notifications('cns_topic', strval($topic_id), $to_member_id);
                }

                $start += $max;
            } while ($possibly_has_more);
        }

        // Make spacer post
        if (!is_null($content_url)) {
            $spacer_post_title = $content_title;
            $home_link = hyperlink($content_url, $content_title, false, true);
            $spacer_post = '[semihtml]' . do_lang('SPACER_POST', $home_link->evaluate(), '', '', get_site_default_lang()) . '[/semihtml]';
            $spacer_post_username = ($spacer_post_member_id == ($this_ref->get_guest_id()) ? do_lang('SYSTEM') : $this_ref->get_username($spacer_post_member_id));
            cns_make_post($topic_id, $spacer_post_title, $spacer_post, 0, true, 1, 0, $spacer_post_username, $ip, $time, $spacer_post_member_id, null, null, null, false, $update_caching, $forum_id, $support_attachments, $content_title, null, false, false, false, false, null, false);
            $is_starter = false;
        }

        $is_new = true;
    } else {
        $is_starter = false;
        $is_new = false;
    }
    $GLOBALS['LAST_TOPIC_ID'] = $topic_id;
    $GLOBALS['LAST_TOPIC_IS_NEW'] = $is_new;
    if ($post == '') {
        return array(null, false);
    }
    cns_check_post($post, $topic_id, $member_id);
    $poster_name = $poster_name_if_guest;
    if ($poster_name == '') {
        $poster_name = $this_ref->get_username($member_id);
    }
    $post_id = cns_make_post($topic_id, $post_title, $post, 0, $is_starter, $validated, 0, $poster_name, $ip, $time_post, $member_id, ($staff_only ? $GLOBALS['FORUM_DRIVER']->get_guest_id() : null), null, null, false, $update_caching, $forum_id, $support_attachments, $content_title, null, false, $skip_post_checks, false, false, $parent_id, false);
    $GLOBALS['LAST_POST_ID'] = $post_id;

    if ($is_new) {
        // Broken cache now for the rest of this page view - fix by flushing
        global $TOPIC_IDENTIFIERS_TO_IDS_CACHE;
        $TOPIC_IDENTIFIERS_TO_IDS_CACHE = array();
    }

    // Send out notifications
    $_url = build_url(array('page' => 'topicview', 'type' => 'findpost', 'id' => $post_id), 'forum', null, false, false, true, 'post_' . strval($post_id));
    $url = $_url->evaluate();
    if (addon_installed('cns_forum')) {
        cns_send_topic_notification($url, $topic_id, $forum_id, $member_id, $is_new, $post, $content_title, null, false, $no_notify_for__notification_code, $no_notify_for__code_category);
    }

    $is_hidden = false;
    if (!get_mass_import_mode()) {
        $validated_actual = $this_ref->db->query_select_value('f_posts', 'p_validated', array('id' => $post_id));
        if ($validated_actual == 0) {
            require_code('site');
            attach_message(do_lang_tempcode('SUBMIT_UNVALIDATED', 'topic'), 'inform');
            $is_hidden = true;
        }
    }

    return array($topic_id, $is_hidden);
}

/**
 * Get an array of topics in the given forum. Each topic is an array with the following attributes:
 * - id, the topic ID
 * - title, the topic title
 * - lastusername, the username of the last poster
 * - lasttime, the timestamp of the last reply
 * - closed, a Boolean for whether the topic is currently closed or not
 * - firsttitle, the title of the first post
 * - firstpost, the first post (only set if $show_first_posts was true)
 *
 * @param  object $this_ref Link to the real forum driver
 * @param  mixed $name The forum name or an array of forum IDs
 * @param  integer $limit The limit
 * @param  integer $start The start position
 * @param  integer $max_rows The total rows (not a parameter: returns by reference)
 * @param  SHORT_TEXT $filter_topic_title The topic title filter
 * @param  SHORT_TEXT $filter_topic_description The topic description filter
 * @param  boolean $show_first_posts Whether to show the first posts
 * @param  string $date_key The date key to sort by
 * @set    lasttime firsttime
 * @param  boolean $hot Whether to limit to hot topics
 * @param  boolean $open_only Open tickets only
 * @return ?array The array of topics (null: error/none)
 * @ignore
 */
function _helper_show_forum_topics($this_ref, $name, $limit, $start, &$max_rows, $filter_topic_title, $filter_topic_description, $show_first_posts, $date_key, $hot, $open_only)
{
    if (is_integer($name)) {
        $id_list = 't_forum_id=' . strval($name);
    } elseif (!is_array($name)) {
        $id = $this_ref->forum_id_from_name($name);
        if (is_null($id)) {
            return null;
        }
        $id_list = 't_forum_id=' . strval($id);
    } else {
        $id_list = '';
        foreach (array_keys($name) as $id) {
            if ($id_list != '') {
                $id_list .= ' OR ';
            }
            $id_list .= 't_forum_id=' . strval($id);
        }
        if ($id_list == '') {
            return null;
        }
    }

    $post_query_select = 'p.p_title,top.id,p.p_poster,p.p_poster_name_if_guest,p.id AS p_id,p_post';
    if (!multi_lang_content()) {
        $post_query_select .= ',p_post__text_parsed,p_post__source_user';
    }
    $post_query_where = 'p_validated=1 AND p_topic_id=top.id ' . not_like_spacer_posts($GLOBALS['SITE_DB']->translate_field_ref('p_post'));
    $post_query_sql = 'SELECT ' . $post_query_select . ' FROM ' . $this_ref->db->get_table_prefix() . 'f_posts p' . $this_ref->db->prefer_index('f_posts', 'in_topic', false);
    if (multi_lang_content()) {
        $post_query_sql .= ' LEFT JOIN ' . $this_ref->db->get_table_prefix() . 'translate t_p_post ON t_p_post.id=p.p_post ';
    }
    $post_query_sql .= ' WHERE ' . $post_query_where;

    if ($hot) {
        $hot_topic_definition = intval(get_option('hot_topic_definition'));
        $topic_filter_sup = ' AND t_cache_num_posts/((t_cache_last_time-t_cache_first_time)/60/60/24+1)>' . strval($hot_topic_definition);
    } else {
        $topic_filter_sup = '';
    }
    if (($filter_topic_title == '') && ($filter_topic_description == '')) {
        if (($filter_topic_title == '') && ($filter_topic_description == '')) {
            $query = 'SELECT * FROM ' . $this_ref->db->get_table_prefix() . 'f_topics top' . $GLOBALS['FORUM_DB']->prefer_index('f_topics', 'unread_forums', false);
            $query .= ' WHERE (' . $id_list . ')' . $topic_filter_sup;
            $query_simplified = $query;

            if (get_option('is_on_strong_forum_tie') == '1') { // So topics with no validated posts, or only spacer posts, are not drawn out only to then be filtered layer (meaning we don't get enough result). Done after $max_rows calculated as that would be slow with this clause
                $query .= ' AND (t_cache_first_member_id>' . strval(db_get_first_id()) . ' OR t_cache_num_posts>1 OR EXISTS(' . $post_query_sql . '))';
            }
        } else {
            $query = '';
            $query_simplified = '';
            $topic_filters = array();
            if ($filter_topic_title != '') {
                $topic_filters[] = 't_cache_first_title LIKE \'' . db_encode_like($filter_topic_title) . '\'';
            }
            if ($filter_topic_description != '') {
                $topic_filters[] = 't_description LIKE \'' . db_encode_like($filter_topic_description) . '\'';
            }
            foreach ($topic_filters as $topic_filter) {
                $query_more = '';
                if ($query != '') {
                    $query_more .= ' UNION ';
                }
                $query_more .= 'SELECT * FROM ' . $this_ref->db->get_table_prefix() . 'f_topics top' . $GLOBALS['FORUM_DB']->prefer_index('f_topics', 'in_forum', false);
                $query_more .= ' WHERE (' . $id_list . ') AND ' . $topic_filter . $topic_filter_sup;
                $query .= $query_more;
                $query_simplified .= $query_more;

                if (get_option('is_on_strong_forum_tie') == '1') { // So topics with no validated posts, or only spacer posts, are not drawn out only to then be filtered layer (meaning we don't get enough result). Done after $max_rows calculated as that would be slow with this clause
                    $query .= ' AND (t_cache_first_member_id>' . strval(db_get_first_id()) . ' OR t_cache_num_posts>1 OR EXISTS(' . $post_query_sql . '))';
                }
            }
        }
    } else {
        $query = '';
        $query_simplified = '';
        $topic_filters = array();
        if ($filter_topic_title != '') {
            $topic_filters[] = 't_cache_first_title LIKE \'' . db_encode_like($filter_topic_title) . '\'';
        }
        if ($filter_topic_description != '') {
            $topic_filters[] = 't_description LIKE \'' . db_encode_like($filter_topic_description) . '\'';
        }
        foreach ($topic_filters as $topic_filter) {
            $query_more = '';
            if ($query != '') {
                $query_more .= ' UNION ';
            }
            $query_more .= 'SELECT * FROM ' . $this_ref->db->get_table_prefix() . 'f_topics top WHERE (' . $id_list . ') AND ' . $topic_filter . $topic_filter_sup;
            $query .= $query_more;
            $query_simplified .= $query_more;

            if (get_option('is_on_strong_forum_tie') == '1') { // So topics with no validated posts, or only spacer posts, are not drawn out only to then be filtered layer (meaning we don't get enough result). Done after $max_rows calculated as that would be slow with this clause
                $query .= ' AND (t_cache_first_member_id>' . strval(db_get_first_id()) . ' OR t_cache_num_posts>1 OR EXISTS(' . $post_query_sql . '))';
            }
        }
    }
    if ($open_only) {
        $query .= ' AND t_is_open = 1';
    }

    $max_rows = $this_ref->db->query_value_if_there(preg_replace('#(^| UNION )SELECT \* #', '${1}SELECT COUNT(*) ', $query_simplified), false, true);

    if ($limit == 0) {
        return array();
    }
    $order_by = (($date_key == 'lasttime') ? 't_cache_last_time' : 't_cache_first_time') . ' DESC';
    $rows = $this_ref->db->query($query . ' ORDER BY ' . $order_by, $limit, $start, false, true);

    $post_query_sql .= ' ORDER BY p_time,p.id';

    $out = array();
    foreach ($rows as $i => $r) {
        $out[$i] = array();
        $out[$i]['id'] = $r['id'];
        $out[$i]['num'] = $r['t_cache_num_posts'];
        $out[$i]['title'] = $r['t_cache_first_title'];
        $out[$i]['description'] = $r['t_description'];
        $out[$i]['firstusername'] = $r['t_cache_first_username'];
        $out[$i]['lastusername'] = $r['t_cache_last_username'];
        $out[$i]['firstmemberid'] = $r['t_cache_first_member_id'];
        $out[$i]['lastmemberid'] = $r['t_cache_last_member_id'];
        $out[$i]['firsttime'] = $r['t_cache_first_time'];
        $out[$i]['lasttime'] = $r['t_cache_last_time'];
        $out[$i]['closed'] = 1 - $r['t_is_open'];
        $out[$i]['forum_id'] = $r['t_forum_id'];

        $_post_query_sql = str_replace('top.id', strval($out[$i]['id']), $post_query_sql);
        $fp_rows = $this_ref->db->query($_post_query_sql, 1, null, false, true/*, array('p_post' => 'LONG_TRANS__COMCODE') we already added it further up*/);
        if (!array_key_exists(0, $fp_rows)) {
            unset($out[$i]);
            continue;
        }
        $out[$i]['firstusername'] = $fp_rows[0]['p_poster_name_if_guest'];
        $out[$i]['firstmemberid'] = $fp_rows[0]['p_poster'];
        $out[$i]['firsttitle'] = $fp_rows[0]['p_title'];
        if ($show_first_posts) {
            $post_row = db_map_restrict($fp_rows[0], array('p_post')) + array('id' => $fp_rows[0]['p_id']);
            $out[$i]['firstpost_language_string'] = $fp_rows[0]['p_post'];
            $out[$i]['firstpost'] = get_translated_tempcode('f_posts', $post_row, 'p_post', $GLOBALS['FORUM_DB']);
        }
    }
    if (count($out) != 0) {
        return $out;
    }
    return null;
}

/**
 * Get a bit of SQL to make sure that a DB field is not like a spacer post in any of the languages.
 *
 * @param  ID_TEXT $field The field name
 * @return string The SQL
 */
function not_like_spacer_posts($field)
{
    $ret = '';
    $langs = find_all_langs();
    foreach (array_keys($langs) as $lang) {
        if ((@filesize(get_file_base() . '/lang/' . $lang . '/global.ini')) || (@filesize(get_file_base() . '/lang_custom/' . $lang . '/global.ini'))) { // Check it's a real lang and not a stub dir
            $ret .= ' AND ' . $field . ' NOT LIKE \'%' . db_encode_like(do_lang('SPACER_POST_MATCHER', '', '', '', $lang) . '%') . '\'';
        }
    }
    return $ret;
}

/**
 * Get an array of maps for the topic in the given forum.
 *
 * @param  object $this_ref Link to the real forum driver
 * @param  ?integer $topic_id The topic ID (null: does not exist)
 * @param  ?integer $count The comment count will be returned here by reference (null: no return)
 * @param  ?integer $max Maximum comments to returned (null: no limit)
 * @param  integer $start Comment to start at
 * @param  boolean $mark_read Whether to mark the topic read
 * @param  boolean $reverse Whether to show in reverse
 * @param  boolean $light_if_threaded Whether to only load minimal details if it is a threaded topic
 * @param  ?array $post_ids List of post IDs to load (null: no filter)
 * @param  boolean $load_spacer_posts_too Whether to load spacer posts
 * @param  ID_TEXT $sort Preferred sort order (appropriate will use rating if threaded, other
 * @set date compound_rating average_rating
 * @return mixed The array of maps (Each map is: title, message, member, date) (-1 for no such forum, -2 for no such topic)
 * @ignore
 */
function _helper_get_forum_topic_posts($this_ref, $topic_id, &$count, $max, $start, $mark_read = true, $reverse = false, $light_if_threaded = false, $post_ids = null, $load_spacer_posts_too = false, $sort = 'date')
{
    if ($topic_id === null) {
        $count = 0;
        return (-2);
    }

    require_code('cns_topics');

    $is_threaded = $this_ref->topic_is_threaded($topic_id);

    $extra_where = '';
    if ($post_ids !== null) {
        if (count($post_ids) == 0) {
            $count = 0;
            return array();
        }
        $extra_where = ' AND (';
        foreach ($post_ids as $i => $id) {
            if ($i != 0) {
                $extra_where .= ' OR ';
            }
            $extra_where .= 'p.id=' . strval($id);
        }
        $extra_where .= ')';
    }

    $where = '(' . cns_get_topic_where($topic_id) . ')';
    if (!$load_spacer_posts_too) {
        $where .= not_like_spacer_posts($GLOBALS['SITE_DB']->translate_field_ref('p_post'));
    }
    $where .= $extra_where;

    $order = $reverse ? 'p_time DESC,p.id DESC' : 'p_time ASC,p.id ASC';
    if ($sort == 'compound_rating') {
        $order = (($reverse ? 'compound_rating DESC' : 'compound_rating ASC') . ',' . $order);
    } elseif ($sort == 'average_rating') {
        $order = (($reverse ? 'average_rating DESC' : 'average_rating ASC') . ',' . $order);
    }

    if (($light_if_threaded) && ($is_threaded)) {
        $select = 'p.id,p.p_parent_id,p.p_intended_solely_for,p.p_poster';
    } else {
        $select = 'p.*';
    }
    if (($is_threaded) || ($sort == 'compound_rating') || ($sort == 'average_rating')) {
        $select .= ',COALESCE((SELECT AVG(rating) FROM ' . $this_ref->db->get_table_prefix() . 'rating WHERE ' . db_string_equal_to('rating_for_type', 'post') . ' AND rating_for_id=p.id),5) AS average_rating';
        $select .= ',COALESCE((SELECT SUM(rating-1) FROM ' . $this_ref->db->get_table_prefix() . 'rating WHERE ' . db_string_equal_to('rating_for_type', 'post') . ' AND rating_for_id=p.id),0) AS compound_rating';
    }
    $rows = $this_ref->db->query('SELECT ' . $select . ' FROM ' . $this_ref->db->get_table_prefix() . 'f_posts p' . $GLOBALS['FORUM_DB']->prefer_index('f_posts', 'in_topic', false) . ' WHERE ' . $where . ' ORDER BY ' . $order, $max, $start, false, true, array('p_post' => 'LONG_TRANS__COMCODE'));
    $count = $this_ref->db->query_select_value('f_topics', 't_cache_num_posts', array('id' => $topic_id));//This may be slow for large topics: $this_ref->db->query_value_if_there('SELECT COUNT(*) FROM ' . $this_ref->db->get_table_prefix() . 'f_posts p' . $GLOBALS['FORUM_DB']->prefer_index('f_posts', 'in_topic', false) . ' WHERE ' . $where, false, true, array('p_post' => 'LONG_TRANS__COMCODE'));

    $out = array();
    foreach ($rows as $myrow) {
        if (($myrow['p_intended_solely_for'] === null) || (($myrow['p_poster'] == get_member()) && (!is_guest($myrow['p_poster']))) || ($myrow['p_intended_solely_for'] == get_member()) || (($myrow['p_intended_solely_for'] == $this_ref->get_guest_id()) && ($this_ref->is_staff(get_member())))) {
            $temp = $myrow; // Takes all Conversr properties

            // Then sanitised for normal forum driver API too (involves repetition)
            $temp['parent_id'] = $myrow['p_parent_id'];
            if ((!$light_if_threaded) || (!$is_threaded)) {
                $temp['title'] = $myrow['p_title'];
                $post_row = db_map_restrict($myrow, array('id', 'p_post'));
                $temp['message'] = get_translated_tempcode('f_posts', $post_row, 'p_post', $GLOBALS['FORUM_DB']);
                $temp['message_comcode'] = get_translated_text($post_row['p_post'], $GLOBALS['FORUM_DB']);
                $temp['member'] = $myrow['p_poster'];
                if ($myrow['p_poster_name_if_guest'] != '') {
                    $temp['username'] = $myrow['p_poster_name_if_guest'];
                }
                $temp['date'] = $myrow['p_time'];
                $temp['staff_only'] = ($myrow['p_intended_solely_for'] !== null);
                $temp['skip_sig'] = $myrow['p_skip_sig'];
            }

            $out[] = $temp;
        }
    }

    if ($mark_read) {
        require_code('cns_topics');
        if ((get_option('post_read_history_days') != '0') && (get_value('avoid_normal_topic_read_history') !== '1')) {
            if (!$GLOBALS['SITE_DB']->table_is_locked('f_read_logs')) {
                cns_ping_topic_read($topic_id);
            }
        }
    }

    return $out;
}

/**
 * Load extra details for a list of posts. Does not need to return anything if forum driver doesn't support partial post loading (which is only useful for threaded topic partial-display).
 *
 * @param  object $this_ref Link to the real forum driver
 * @param  AUTO_LINK $topic_id Topic the posts come from
 * @param  array $post_ids List of post IDs
 * @return array Extra details
 *
 * @ignore
 */
function _helper_get_post_remaining_details($this_ref, $topic_id, $post_ids)
{
    $count = 0;
    $ret = _helper_get_forum_topic_posts($this_ref, $topic_id, $count, null, 0, false, false, false, $post_ids, true);
    if (is_integer($ret)) {
        return array();
    }
    return $ret;
}

/**
 * Get an emoticon chooser template.
 *
 * @param  object $this_ref Link to the real forum driver
 * @param  string $field_name The ID of the form field the emoticon chooser adds to
 * @return Tempcode The emoticon chooser template
 *
 * @ignore
 */
function _helper_get_emoticon_chooser($this_ref, $field_name)
{
    if (get_option('is_on_emoticon_choosers') == '0') {
        return new Tempcode();
    }

    $use_special = has_privilege(get_member(), 'use_special_emoticons');

    $do_caching = has_caching_for('block');

    $em = mixed();
    if ($do_caching) {
        $cache_identifier = serialize($use_special);
        $em = get_cache_entry('_emoticon_chooser', $cache_identifier, CACHE_AGAINST_NOTHING_SPECIAL, 10000);

        if ($em !== null) {
            return $em;
        }
    }

    $extra_where = $use_special ? array() : array('e_is_special' => 0);
    $emoticons = $this_ref->db->query_select('f_emoticons', array('*'), array('e_relevance_level' => 0) + $extra_where, 'ORDER BY e_code');
    $em = new Tempcode();
    foreach ($emoticons as $emo) {
        $code = $emo['e_code'];
        if ($GLOBALS['XSS_DETECT']) {
            ocp_mark_as_escaped($code);
        }

        $em->attach(do_template('EMOTICON_CLICK_CODE', array('_GUID' => '1a75f914e09f2325ad96ad679bcffe88', 'FIELD_NAME' => $field_name, 'CODE' => $code, 'IMAGE' => apply_emoticons($code))));
    }

    if ($do_caching) {
        require_code('caches2');

        $em = apply_quick_caching($em);

        put_into_cache('_emoticon_chooser', 60 * 60 * 24, $cache_identifier, null, null, '', null, get_users_timezone(get_member()), $em);
    }

    return $em;
}

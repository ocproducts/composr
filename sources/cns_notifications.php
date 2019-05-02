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
 * @package    core_cns
 */

/**
 * Get the personal post rows for the current member.
 *
 * @param  ?integer $limit The maximum number of rows to get (gets newest first) (null: no limit)
 * @param  boolean $unread Whether to only get unread ones
 * @param  boolean $include_inline Whether to include inline personal posts
 * @param  ?TIME $time_barrier Only since this date (null: no limit)
 * @return array The personal post rows (with corresponding topic details)
 */
function cns_get_pp_rows($limit = 5, $unread = true, $include_inline = true, $time_barrier = null)
{
    $cache_key = serialize(array($limit, $unread, $include_inline, $time_barrier));

    static $private_post_rows_cache = array();
    if (isset($private_post_rows_cache[$cache_key])) {
        return $private_post_rows_cache[$cache_key];
    }

    if (!addon_installed('cns_forum')) {
        return array();
    }

    $member_id = get_member();

    $query = '';

    $unread_clause = '';
    if ($unread) {
        $unread_clause = '
            t_cache_last_time > ' . strval(time() - 60 * 60 * 24 * intval(get_option('post_read_history_days'))) . ' AND
            (l_time IS NULL OR l_time < p.p_time) AND
        ';
    }

    $time_clause = '';
    if ($time_barrier !== null) {
        $time_clause = '
            t_cache_last_time>' . strval($time_barrier) . ' AND
        ';
    }

    // NB: The "p_intended_solely_for" bit in the PT clauses is because inline private posts do not register as the t_cache_last_post_id even if they are the most recent post. We want to ensure we join to the most recent post.

    // PT from and PT from
    foreach (array('t_pt_from', 't_pt_to') as $pt_target) {
        $query .= 'SELECT t.*,l.*,p.*,p.id AS p_id,t.id as t_id';
        if (multi_lang_content()) {
            $query .= ',t_cache_first_post AS p_post_first';
        } else {
            $query .= ',p2.p_post AS p_post_first,p2.p_post__text_parsed AS p_post_first__text_parsed,p2.p_post__source_user AS p_post_first__source_user';
        }
        $query .= ' FROM
        ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_topics t
        LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_read_logs l ON (t.id=l_topic_id AND l_member_id=' . strval($member_id) . ')
        JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_posts p ON (p.id=t.t_cache_last_post_id)';
        if (!multi_lang_content()) {
            $query .= ' LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_posts p2 ON p2.id=t.t_cache_first_post_id';
        }
        $query .= ' WHERE
        ' . $unread_clause . $time_clause . '
        ' . $pt_target . '=' . strval($member_id) . '
        ' . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY t.id' : '');

        $query .= ' UNION ';
    }

    // PT invited to
    $query .= 'SELECT t.*,l.*,p.*,p.id AS p_id,t.id as t_id';
    if (multi_lang_content()) {
        $query .= ',t_cache_first_post AS p_post_first';
    } else {
        $query .= ',p2.p_post AS p_post_first,p2.p_post__text_parsed AS p_post_first__text_parsed,p2.p_post__source_user AS p_post_first__source_user';
    }
    $query .= ' FROM
    ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_topics t
    LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_special_pt_access i ON (i.s_topic_id=t.id)
    LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_read_logs l ON (t.id=l_topic_id AND l_member_id=' . strval($member_id) . ')
    JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_posts p ON (p.id=t.t_cache_last_post_id)';
    if (!multi_lang_content()) {
        $query .= ' LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_posts p2 ON p2.id=t.t_cache_first_post_id';
    }
    $query .= ' WHERE
    ' . $unread_clause . $time_clause . '
    i.s_member_id=' . strval($member_id) . '
    ' . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY t.id' : '');

    if ($include_inline) {
        $query .= ' UNION ';

        // Inline personal post to
        $query .= 'SELECT t.*,l.*,p.*,p.id AS p_id,t.id as t_id';
        if (multi_lang_content()) {
            $query .= ',t_cache_first_post AS p_post_first';
        } else {
            $query .= ',p2.p_post AS p_post_first,p2.p_post__text_parsed AS p_post_first__text_parsed,p2.p_post__source_user AS p_post_first__source_user';
        }
        $query .= ' FROM
        ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_posts p
        JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_topics t ON (p_topic_id=t.id AND p.p_intended_solely_for=' . strval($member_id) . ')
        LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_read_logs l ON (t.id=l_topic_id AND l_member_id=' . strval($member_id) . ')';
        if (!multi_lang_content()) {
            $query .= ' LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_posts p2 ON p2.id=t.t_cache_first_post_id';
        }
        $query .= ' WHERE
        ' . $unread_clause . $time_clause . '
        p.p_intended_solely_for=' . strval($member_id) . '
        ' . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY t.id' : '');
    }

    $query .= ' ORDER BY t_cache_last_time DESC';

    $ret = $GLOBALS['FORUM_DB']->query($query, $limit, 0, false, true);
    $ret = remove_duplicate_rows($ret, 't_id');

    $private_post_rows_cache[$cache_key] = $ret;

    return $ret;
}

/**
 * Calculate Conversr notifications and render.
 *
 * @param  MEMBER $member_id Member to look up for
 * @return array A pair: Number of notifications, Rendered notifications
 */
function generate_notifications($member_id)
{
    static $notifications_cache = null;
    if (isset($notifications_cache[$member_id])) {
        return $notifications_cache[$member_id];
    }

    $do_caching = has_caching_for('block');

    $notifications = null;
    if ($do_caching) {
        $cache_identifier = serialize(array());
        $_notifications = get_cache_entry('_new_pp', $cache_identifier, CACHE_AGAINST_MEMBER, 10000);

        if ($_notifications !== null) {
            list($__notifications, $num_unread_pps) = $_notifications;
            $notifications = new Tempcode();
            if (!$notifications->from_assembly($__notifications, true)) {
                $notifications = null;
            }
        }
    }

    if ($notifications === null) {
        push_query_limiting(false);

        $unread_pps = cns_get_pp_rows();
        $notifications = new Tempcode();
        $num_unread_pps = 0;
        foreach ($unread_pps as $unread_pp) {
            $just_post_row = db_map_restrict($unread_pp, array('id', 'p_post'), array('id' => 'p_id'));

            $by_id = (($unread_pp['t_cache_first_member_id'] === null) || ($unread_pp['t_forum_id'] !== null)) ? $unread_pp['p_poster'] : $unread_pp['t_cache_first_member_id'];
            $by = is_guest($by_id) ? do_lang('SYSTEM') : $GLOBALS['CNS_DRIVER']->get_username($by_id);
            $u_title = $unread_pp['t_cache_first_title'];
            if ($unread_pp['t_forum_id'] === null) {
                $type = do_lang_tempcode(($unread_pp['t_cache_first_post_id'] == $unread_pp['id']) ? 'NEW_PT_NOTIFICATION' : 'NEW_PP_NOTIFICATION');
                $num_unread_pps++;
                $reply_url = build_url(array('page' => 'topics', 'type' => 'new_post', 'id' => $unread_pp['p_topic_id'], 'quote' => $unread_pp['id']), get_module_zone('topics'));

                $additional_posts = $GLOBALS['FORUM_DB']->query_value_if_there('SELECT COUNT(*) AS cnt FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_posts WHERE p_topic_id=' . strval($unread_pp['p_topic_id']) . ' AND id>' . strval($unread_pp['id']));
            } else {
                $type = do_lang_tempcode('NEW_INLINE_PERSONAL_POST');
                if ($unread_pp['p_title'] != '') {
                    $u_title = $unread_pp['p_title'];
                }
                $reply_url = build_url(array('page' => 'topics', 'type' => 'new_post', 'id' => $unread_pp['p_topic_id'], 'quote' => $unread_pp['id'], 'intended_solely_for' => $unread_pp['p_poster']), get_module_zone('topics'));

                $additional_posts = 0;
            }
            $time_raw = $unread_pp['p_time'];
            $date = get_timezoned_date_time($unread_pp['p_time']);
            $topic_url = $GLOBALS['CNS_DRIVER']->post_url($unread_pp['id'], null, true);
            $post = get_translated_tempcode('f_posts', $just_post_row, 'p_post', $GLOBALS['FORUM_DB']);
            $description = $unread_pp['t_description'];
            if ($description != '') {
                $description = ' (' . $description . ')';
            }
            $profile_url = is_guest($by_id) ? new Tempcode() : $GLOBALS['CNS_DRIVER']->member_profile_url($by_id, true);
            $redirect = get_self_url(true, true);
            $ignore_url = build_url(array('page' => 'topics', 'type' => 'mark_read_topic', 'id' => $unread_pp['p_topic_id'], 'timestamp' => time(), 'redirect' => protect_url_parameter($redirect)), get_module_zone('topics'));
            $ignore_url_2 = build_url(array('page' => 'topics', 'type' => 'mark_read_topic', 'id' => $unread_pp['p_topic_id'], 'timestamp' => time(), 'redirect' => protect_url_parameter($redirect), 'ajax' => 1), get_module_zone('topics'));
            $notifications->attach(do_template('CNS_NOTIFICATION', array(
                '_GUID' => '3b224ea3f4da2f8f869a505b9756970a',
                'ADDITIONAL_POSTS' => integer_format($additional_posts),
                '_ADDITIONAL_POSTS' => strval($additional_posts),
                'ID' => strval($unread_pp['id']),
                'U_TITLE' => $u_title,
                'IGNORE_URL' => $ignore_url,
                'IGNORE_URL_2' => $ignore_url_2,
                'REPLY_URL' => $reply_url,
                'TOPIC_URL' => $topic_url,
                'POST' => $post,
                'DESCRIPTION' => $description,
                'DATE' => $date,
                'TIME_RAW' => strval($time_raw),
                'BY' => $by,
                'PROFILE_URL' => $profile_url,
                'TYPE' => $type,
            )));
        }

        if ($do_caching) {
            require_code('caches2');
            set_cache_entry('_new_pp', 60 * 24, $cache_identifier, array($notifications->to_assembly(), $num_unread_pps));
        }

        pop_query_limiting();
    }

    if ($do_caching) {
        $notifications_cache[$cache_identifier] = array($notifications, $num_unread_pps);
    }

    return array($notifications, $num_unread_pps);
}

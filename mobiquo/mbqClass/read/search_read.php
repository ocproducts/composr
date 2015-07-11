<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    cns_tapatalk
 */
class CMSSearchRead
{
    /**
     * Search topics.
     *
     * @param  string         Keywords
     * @param  integer      Start position
     * @param  integer      Max position
     * @param  ?MEMBER      Member ID (null: no filter)
     * @param  ?string      Username (null: no filter)
     * @param  ?AUTO_LINK   Forum ID (null: no filter)
     * @param  ?boolean      Title only (null: no filter)
     * @param  ?TIME         Time since (null: no filter)
     * @param  ?array         Only in these forums (null: no filter)
     * @param  ?array         Not in these forums (null: no filter)
     * @return array A pair: total topics, topics
     */
    function search_topics($keywords, $start, $max, $userid = null, $searchuser = null, $forumid = null, $titleonly = false, $searchtime = null, $only_in = null, $not_in = null)
    {
        cms_verify_parameters_phpdoc();

        require_code('database_search');
        $table_prefix = get_table_prefix();
        $boolean_operator = 'AND';

        $sql = ' FROM ' . $table_prefix . 'f_topics t JOIN ' . $table_prefix . 'f_forums f ON f.id=t.t_forum_id JOIN ' . $table_prefix . 'f_posts p ON t.t_cache_first_post_id=p.id WHERE ';

        $sql .= 't_forum_id IN (' . get_allowed_forum_sql() . ')';

        if ($keywords != '') {
            $sql1 = '';
            if (!$titleonly) {
                $sql1 .= preg_replace('#\?#', 'p_title', build_content_where($keywords, false, $boolean_operator));
                if ($sql1 != '') {
                    $sql1 .= ' OR ';
                }
            }
            $sql1 .= preg_replace('#\?#', 't_description', build_content_where($keywords, false, $boolean_operator));
            if ($sql1 != '') {
                $sql .= ' AND (' . $sql1 . ')';
            }
        }

        if (addon_installed('unvalidated')) {
            $sql .= ' AND t_validated=1';
        }

        if (!is_null($userid)) {
            $sql .= ' AND t_cache_first_member_id=' . strval($userid);
        }

        if (!is_null($searchuser)) {
            $_userid = $GLOBALS['FORUM_DRIVER']->get_member_from_username($searchuser);
            if (is_null($_userid)) {
                warn_exit(do_lang_tempcode('_USER_NO_EXIST', escape_html($searchuser)));
            }
            $sql .= ' AND t_cache_first_member_id=' . strval($_userid);
        }

        if (!is_null($forumid)) {
            $sql .= ' AND t_forum_id=' . strval($forumid);
        }

        if (!is_null($searchtime)) {
            $sql .= ' AND t_cache_last_time>' . strval(time() - $searchtime);
        }

        if (!is_null($only_in)) {
            if (count($only_in) == 0) {
                $sql .= ' AND 1=0';
            } else {
                $sql .= ' AND t_forum_id IN (' . implode(',', array_map('strval', array_map('intval', $only_in))) . ')';
            }
        }

        if (!is_null($not_in)) {
            if (count($not_in) == 0) {
                $sql .= ' AND 1=1';
            } else {
                $sql .= ' AND t_forum_id NOT IN (' . implode(',', array_map('strval', array_map('intval', $not_in))) . ')';
            }
        }

        $sql .= ' ORDER BY t_cache_last_time DESC';

        $full_sql = 'SELECT *,f.id as forum_id,t.id AS topic_id,p.id AS post_id' . $sql;
        $topics = (get_allowed_forum_sql() == '') ? array() : $GLOBALS['FORUM_DB']->query($full_sql, $max, $start);
        $total_topic_num = (get_allowed_forum_sql() == '') ? 0 : $GLOBALS['FORUM_DB']->query_value_null_ok_full('SELECT COUNT(*)' . $sql);

        return array($total_topic_num, $topics);
    }

    /**
     * Search posts.
     *
     * @param  string         Keywords
     * @param  integer      Start position
     * @param  integer      Max position
     * @param  ?MEMBER      Member ID (null: no filter)
     * @param  ?string      Username (null: no filter)
     * @param  ?AUTO_LINK   Forum ID (null: no filter)
     * @param  ?AUTO_LINK   Topic ID (null: no filter)
     * @param  ?TIME         Time since (null: no filter)
     * @param  ?array         Only in these forums (null: no filter)
     * @param  ?array         Not in these forums (null: no filter)
     * @return array A pair: total topics, topics
     */
    function search_posts($keywords, $start, $max, $userid = null, $searchuser = null, $forumid = null, $topicid = null, $searchtime = null, $only_in = null, $not_in = null)
    {
        cms_verify_parameters_phpdoc();

        require_code('database_search');
        $table_prefix = $GLOBALS['FORUM_DB']->get_table_prefix();
        $boolean_operator = 'AND';

        if (multi_lang_content()) {
            $search_sql = preg_replace('#\?#', 'trans.text_original', build_content_where($keywords, false, $boolean_operator));
            if ($search_sql == '') {
                $search_sql = '1=1';
            }
            $sql = '
				FROM ' . $table_prefix . 'f_posts p
				JOIN ' . $table_prefix . 'translate trans ON trans.id=p.p_post
				JOIN ' . $table_prefix . 'f_topics t ON p.p_topic_id=t.id
				JOIN ' . $table_prefix . 'f_forums f ON t.t_forum_id=f.id
				WHERE ' . $search_sql;
        } else {
            $search_sql = preg_replace('#\?#', 'p_post', build_content_where($keywords, false, $boolean_operator));
            if ($search_sql == '') {
                $search_sql = '1=1';
            }
            $sql = '
				FROM ' . $table_prefix . 'f_posts p
				JOIN ' . $table_prefix . 'f_topics t ON p.p_topic_id=t.id
				JOIN ' . $table_prefix . 'f_forums f ON t.t_forum_id=f.id
				WHERE ' . $search_sql;
        }
        $sql .= ' AND p_cache_forum_id IN (' . get_allowed_forum_sql() . ')';
        if (addon_installed('unvalidated')) {
            $sql .= ' AND p_validated=1';
        }
        if (!has_privilege(get_member(), 'view_other_pt')) {
            $sql .= ' AND (p_intended_solely_for IS NULL OR p_intended_solely_for=' . strval(get_member()) . ' OR p_poster=' . strval(get_member()) . ')';
        }

        if (!is_null($userid)) {
            $sql .= ' AND p_poster=' . strval($userid);
        }

        if (!is_null($searchuser)) {
            $_userid = $GLOBALS['FORUM_DRIVER']->get_member_from_username($searchuser);
            if (is_null($_userid)) {
                warn_exit(do_lang_tempcode('_USER_NO_EXIST', escape_html($searchuser)));
            }
            $sql .= ' AND p_poster=' . strval($_userid);
        }

        if (!is_null($forumid)) {
            $sql .= ' AND p_cache_forum_id=' . strval($forumid);
        }

        if (!is_null($topicid)) {
            $sql .= ' AND p_topic_id=' . strval($topicid);
        }

        if (!is_null($searchtime)) {
            $sql .= ' AND p_time>' . strval(time() - $searchtime);
        }

        if (!is_null($only_in)) {
            if (count($only_in) == 0) {
                $sql .= ' AND 1=0';
            } else {
                $sql .= ' AND p_cache_forum_id IN (' . implode(',', array_map('strval', array_map('intval', $only_in))) . ')';
            }
        }

        if (!is_null($not_in)) {
            if (count($not_in) == 0) {
                $sql .= ' AND 1=1';
            } else {
                $sql .= ' AND p_cache_forum_id NOT IN (' . implode(',', array_map('strval', array_map('intval', $not_in))) . ')';
            }
        }

        $sql .= ' ORDER BY p_time DESC,p.id DESC';

        if (function_exists('set_time_limit')) {
            @set_time_limit(10);
        }

        $full_sql = 'SELECT *,t.id AS topic_id,p.id AS post_id,t.t_cache_first_title,f.id AS forum_id,f.f_name' . $sql;
        $posts = (get_allowed_forum_sql() == '') ? array() : $GLOBALS['FORUM_DB']->query($full_sql, $max, $start);
        $total_post_num = (get_allowed_forum_sql() == '') ? 0 : $GLOBALS['FORUM_DB']->query_value_null_ok_full('SELECT COUNT(*)' . $sql);

        return array($total_post_num, $posts);
    }
}

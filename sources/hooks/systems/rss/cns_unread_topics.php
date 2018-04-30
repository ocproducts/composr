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
 * @package    cns_forum
 */

/**
 * Hook class.
 */
class Hook_rss_cns_unread_topics
{
    /**
     * Run function for RSS hooks.
     *
     * @param  string $_filters A list of categories we accept from
     * @param  TIME $cutoff Cutoff time, before which we do not show results from
     * @param  string $prefix Prefix that represents the template set we use
     * @set RSS_ ATOM_
     * @param  string $date_string The standard format of date to use for the syndication type represented in the prefix
     * @param  integer $max The maximum number of entries to return, ordering by date
     * @return ?array A pair: The main syndication section, and a title (null: error)
     */
    public function run($_filters, $cutoff, $prefix, $date_string, $max)
    {
        if (!addon_installed('cns_forum')) {
            return null;
        }

        if (get_forum_type() != 'cns') {
            return null;
        }
        if (!has_actual_page_access(get_member(), 'forumview')) {
            return null;
        }
        if (is_guest()) {
            return null;
        }

        $condition = 'l_time<t_cache_last_time OR (l_time IS NULL AND t_cache_last_time>' . strval(time() - 60 * 60 * 24 * intval(get_option('post_read_history_days'))) . ')';
        $query = 'SELECT *,t.id AS t_id';
        if (multi_lang_content()) {
            $query .= ',t_cache_first_post AS p_post';
        } else {
            $query .= ',p_post,p_post__text_parsed,p_post__source_user';
        }
        $query .= ' FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_topics t LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_read_logs l ON t.id=l.l_topic_id AND l.l_member_id=' . strval(get_member());
        if (!multi_lang_content()) {
            $query .= ' LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_posts p ON p.id=t.t_cache_first_post_id';
        }
        $query .= ' WHERE (' . $condition . ') AND t_forum_id IS NOT NULL ' . ((!has_privilege(get_member(), 'see_unvalidated')) ? ' AND t_validated=1 ' : '');
        $query .= ' AND t_cache_last_time>' . strval($cutoff);
        $query .= ' ORDER BY t_cache_last_time DESC';
        if (multi_lang_content()) {
            $rows = $GLOBALS['FORUM_DB']->query($query, $max, 0, false, false, array('t_cache_first_post' => 'LONG_TRANS__COMCODE'));
        } else {
            $rows = $GLOBALS['FORUM_DB']->query($query, $max, 0, false);
        }
        $categories = collapse_2d_complexity('id', 'f_name', $GLOBALS['FORUM_DB']->query('SELECT id,f_name FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_forums WHERE f_cache_num_posts>0'));

        $content = new Tempcode();
        foreach ($rows as $row) {
            if ((($row['t_forum_id'] !== null) || ($row['t_pt_to'] == get_member())) && (has_category_access(get_member(), 'forums', strval($row['t_forum_id'])))) {
                $id = strval($row['t_id']);
                $author = $row['t_cache_first_username'];

                $news_date = date($date_string, $row['t_cache_first_time']);
                $edit_date = date($date_string, $row['t_cache_last_time']);
                if ($edit_date == $news_date) {
                    $edit_date = '';
                }

                $news_title = xmlentities($row['t_cache_first_title']);
                $post_row = db_map_restrict($row, array('p_post')) + array('id' => $row['t_cache_first_post_id']);
                $_summary = get_translated_tempcode('f_posts', $post_row, 'p_post', $GLOBALS['FORUM_DB']);
                $summary = xmlentities($_summary->evaluate());
                $news = '';

                $category = array_key_exists($row['t_forum_id'], $categories) ? $categories[$row['t_forum_id']] : do_lang('NA');
                $category_raw = strval($row['t_forum_id']);

                $view_url = build_url(array('page' => 'topicview', 'id' => $row['t_id']), get_module_zone('topicview'));

                if ($prefix == 'RSS_') {
                    $if_comments = do_template('RSS_ENTRY_COMMENTS', array('_GUID' => '517e4d1be810446bda57d8632dadb4d6', 'COMMENT_URL' => $view_url, 'ID' => $id), null, false, null, '.xml', 'xml');
                } else {
                    $if_comments = new Tempcode();
                }

                $content->attach(do_template($prefix . 'ENTRY', array('VIEW_URL' => $view_url, 'SUMMARY' => $summary, 'EDIT_DATE' => $edit_date, 'IF_COMMENTS' => $if_comments, 'TITLE' => $news_title, 'CATEGORY_RAW' => $category_raw, 'CATEGORY' => $category, 'AUTHOR' => $author, 'ID' => $id, 'NEWS' => $news, 'DATE' => $news_date), null, false, null, '.xml', 'xml'));
            }
        }

        require_lang('cns');
        return array($content, do_lang('TOPICS_UNREAD'));
    }
}

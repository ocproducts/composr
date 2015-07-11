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
class CMSPostRead
{
    /**
     * Get Comcode for quoting a post.
     *
     * @param  array            Post IDs
     * @return array Tuple of result details
     */
    function get_quote_post($post_ids)
    {
        cms_verify_parameters_phpdoc();

        $quote_title = null;
        $quote_content = '';

        foreach ($post_ids as $post_id) {
            $table_prefix = $GLOBALS['FORUM_DB']->get_table_prefix();
            $post_details = $GLOBALS['FORUM_DB']->query_select('f_posts p JOIN ' . $table_prefix . 'f_topics t on t.id=p.p_topic_id', array('*', 'p.id AS post_id', 't.id AS topic_id'), array('p.id' => $post_id), '', 1);

            if (!isset($post_details[0])) {
                continue;
            }

            if (!has_post_access($post_id, null, $post_details[0])) {
                continue;
            }

            if ($quote_title === null) {
                $quote_title = do_lang('QUOTE_MESSAGE_REPLY', $post_details[0]['p_title']);
            }

            $poster = $post_details[0]['p_poster_name_if_guest'];
            if ($poster == '') {
                $poster = $GLOBALS['FORUM_DRIVER']->get_username($post_details[0]['p_poster']);
                if (is_null($poster)) {
                    $poster = do_lang('UNKNOWN');
                }
            }

            $quote_content .= '[quote="' . addslashes($poster) . '"]' . get_translated_text($post_details[0]['p_post'], $GLOBALS['FORUM_DB']) . "[/quote]\n";
        }

        return array($quote_title, $quote_content);
    }

    /**
     * Load up basic details of a post.
     *
     * @param  AUTO_LINK        Post ID
     * @return array Post
     */
    function get_raw_post($post_id)
    {
        cms_verify_parameters_phpdoc();

        $table_prefix = $GLOBALS['FORUM_DB']->get_table_prefix();
        $post_details = $GLOBALS['FORUM_DB']->query_select('f_posts p JOIN ' . $table_prefix . 'f_topics t on t.id=p.p_topic_id', array('*', 'p.id AS post_id', 't.id AS topic_id'), array('p.id' => $post_id), '', 1);

        if (!isset($post_details[0])) {
            warn_exit(do_lang_tempcode('MISSING_RESOURCE'));
        }

        $post = $post_details[0];
        if (!has_post_access($post_id, null, $post)) {
            access_denied('I_ERROR');
        }

        $edit_reason = '';
        if (has_actual_page_access(get_member(), 'admin_actionlog')) {
            $_edit_reason = $GLOBALS['FORUM_DB']->query_value_null_ok('f_moderator_logs', 'l_reason', array('l_the_type' => 'EDIT_POST', 'l_param_a' => strval($post_id)));
            if (!is_null($_edit_reason)) {
                $edit_reason = $_edit_reason;
            }
        }

        $content = prepare_post_for_tapatalk($post);

        return array(
            'post_id' => $post_id,
            'post_title' => $post['p_title'],
            'post_username' => $GLOBALS['FORUM_DRIVER']->get_username($post['p_poster']),
            'post_content' => $content,
            'edit_reason' => $edit_reason,
            'attachments' => get_post_attachments($post_id),
        );
    }

    /**
     * Render a topic.
     *
     * @param  AUTO_LINK        Topic ID
     * @param  ?integer        Start position for topic post retrieval (null: return no posts)
     * @param  ?integer        Maximum topic posts retrieved (null: return no posts)
     * @param  boolean        Whether to return HTML for post data
     * @return object Mobiquo array
     */
    function get_topic($topic_id, $start, $max, $return_html)
    {
        cms_verify_parameters_phpdoc();

        if (!has_topic_access($topic_id)) {
            access_denied('I_ERROR');
        }

        cns_ping_topic_read($topic_id);

        return render_topic_to_tapatalk($topic_id, $return_html, $start, $max);
    }
}

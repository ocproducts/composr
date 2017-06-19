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
 * @package    cns_forum
 */

/**
 * Hook class.
 */
class Hook_task_cns_topics_recache
{
    /**
     * Run the task hook.
     *
     * @return ?array A tuple of at least 2: Return mime-type, content (either Tempcode, or a string, or a filename and file-path pair to a temporary file), map of HTTP headers if transferring immediately, map of ini_set commands if transferring immediately (null: show standard success message)
     */
    public function run()
    {
        cns_require_all_forum_stuff();

        // Topics and posts
        $start = 0;
        do {
            $topics = $GLOBALS['FORUM_DB']->query_select('f_topics', array('id', 't_forum_id'), array(), '', 500, $start);
            foreach ($topics as $topic) {
                require_code('cns_posts_action2');
                cns_force_update_topic_caching($topic['id'], null, true, true);

                // NB: p_cache_forum_id must not be intval'd as may be null
                if ($topic['t_forum_id'] === null) {
                    $topic['t_forum_id'] = null;
                }
                $GLOBALS['FORUM_DB']->query_update('f_posts', array('p_cache_forum_id' => ($topic['t_forum_id'] === null) ? null : $topic['t_forum_id']), array('p_topic_id' => ($topic['id'] === null) ? null : $topic['id']));
            }

            $start += 500;
        } while (array_key_exists(0, $topics));

        // Polls
        $start = 0;
        do {
            $polls = $GLOBALS['FORUM_DB']->query_select('f_polls', array('id'), array(), '', 500, $start);
            foreach ($polls as $poll) {
                $total_votes = $GLOBALS['FORUM_DB']->query_select_value('f_poll_votes', 'COUNT(*)', array('pv_poll_id' => $poll['id']));
                $GLOBALS['FORUM_DB']->query_update('f_polls', array('po_cache_total_votes' => $total_votes), array('id' => $poll['id']), '', 1);

                $answers = $GLOBALS['FORUM_DB']->query_select('f_poll_answers', array('id'), array('pa_poll_id' => $poll['id']));
                foreach ($answers as $answer) {
                    $votes = $GLOBALS['FORUM_DB']->query_select_value('f_poll_votes', 'COUNT(*)', array('pv_answer_id' => $answer['id'], 'pv_poll_id' => $poll['id']));
                    $GLOBALS['FORUM_DB']->query_update('f_poll_answers', array('pa_cache_num_votes' => $votes), array('id' => $answer['id']), '', 1);
                }
            }

            $start += 500;
        } while (array_key_exists(0, $polls));

        return null;
    }
}

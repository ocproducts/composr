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
 * @package    core_feedback_features
 */

/**
 * Hook class.
 */
class Hook_preview_comments
{
    /**
     * Find whether this preview hook applies.
     *
     * @return array Triplet: Whether it applies, the attachment ID type (may be null), whether the forum DB is used [optional]
     */
    public function applies()
    {
        $applies = ((addon_installed('cns_forum')) && (get_page_name() != 'topicview') && (post_param_integer('_comment_form_post', 0) == 1) && (post_param_string('hidFileID_file0', null) === null) && (post_param_string('file0', null) === null));
        return array($applies, null, false);
    }

    /**
     * Run function for preview hooks.
     *
     * @return array A pair: The preview, the updated post Comcode (may be null)
     */
    public function run()
    {
        // Find review, if there is one
        $individual_review_ratings = array();
        $review_rating = post_param_string('review_rating', '');
        if ($review_rating != '') {
            $individual_review_ratings[''] = array(
                'REVIEW_TITLE' => '',
                'REVIEW_RATING' => $review_rating,
            );
        }

        $poster_name = $GLOBALS['FORUM_DRIVER']->get_username(get_member());
        $post_comcode = post_param_string('post');
        $post = comcode_to_tempcode($post_comcode);

        // Conversr renderings of poster
        require_code('cns_members2');
        $poster_details = render_member_box(get_member(), false, false, array(), false);
        if (addon_installed('cns_forum')) {
            if (is_guest()) {
                $poster = do_template('CNS_POSTER_MEMBER', array('_GUID' => 'adbfe268015ca904c3f61020a7b0adde', 'ONLINE' => true, 'ID' => strval(get_member()), 'POSTER_DETAILS' => $poster_details, 'PROFILE_URL' => $GLOBALS['FORUM_DRIVER']->member_profile_url(get_member(), true), 'POSTER_USERNAME' => $poster_name));
            } else {
                $poster = do_template('CNS_POSTER_GUEST', array('_GUID' => '3992f4e69ac72a5b57289e5e802f5f48', 'IP_LINK' => '', 'POSTER_DETAILS' => $poster_details, 'POSTER_USERNAME' => $poster_name));
            }
        } else {
            $poster = make_string_tempcode(escape_html($poster_name)); // Should never happen actually, as applies discounts hook from even running
        }

        $highlight = false;
        $timestamp = time();
        $time = get_timezoned_date_time(time());
        $poster_url = $GLOBALS['FORUM_DRIVER']->member_profile_url(get_member());
        $title = post_param_string('title', '');
        $tpl = do_template('POST', array(
            '_GUID' => 'fe6913829896c0f0a615ecdb11fc5271',
            'INDIVIDUAL_REVIEW_RATINGS' => $individual_review_ratings,
            'HIGHLIGHT' => $highlight,
            'TITLE' => $title,
            'TIME_RAW' => strval($timestamp),
            'TIME' => $time,
            'POSTER_ID' => strval(get_member()),
            'POSTER_URL' => $poster_url,
            'POSTER_NAME' => $poster_name,
            'POSTER' => $poster,
            'POSTER_DETAILS' => $poster_details,
            'ID' => '',
            'POST' => $post,
            'POST_COMCODE' => $post_comcode,
            'POST_NUMBER' => '',
            'CHILDREN' => '',
            'OTHER_IDS' => '',
            'RATING' => '',
            'EMPHASIS' => '',
            'BUTTONS' => '',
            'TOPIC_ID' => '',
            'UNVALIDATED' => '',
            'IS_SPACER_POST' => false,
            'LAST_EDITED_RAW' => '',
            'LAST_EDITED' => '',
            'NUM_TO_SHOW_LIMIT' => '0',
            'SIGNATURE' => '',
            'IS_UNREAD' => false,
            'IS_THREADED' => false,
        ));
        return array($tpl, null);
    }
}

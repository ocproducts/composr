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
 * Add a topic.
 * This does not create the first post, you need to do an cns_make_post call for that. Conversr allows topics with zero posts.
 *
 * @param  ?AUTO_LINK $forum_id The ID of the forum the topic will be in (null: Private Topic)
 * @param  SHORT_TEXT $description Description of the topic
 * @param  SHORT_TEXT $emoticon The theme image code of the emoticon for the topic
 * @param  ?BINARY $validated Whether the topic is validated (null: detect whether it should be)
 * @param  BINARY $open Whether the topic is open
 * @param  BINARY $pinned Whether the topic is pinned
 * @param  BINARY $cascading Whether the topic is cascading
 * @param  ?MEMBER $pt_from If it is a Private Topic, who is it 'from' (null: not a Private Topic)
 * @param  ?MEMBER $pt_to If it is a Private Topic, who is it 'to' (null: not a Private Topic)
 * @param  boolean $check_perms Whether to check the poster has permissions for the given topic settings
 * @param  integer $num_views The number of times the topic has been viewed
 * @param  ?AUTO_LINK $id Force an ID (null: don't force an ID)
 * @param  SHORT_TEXT $description_link Link related to the topic (e.g. link to view a ticket).
 * @return AUTO_LINK The ID of the newly created topic
 */
function cns_make_topic($forum_id, $description = '', $emoticon = '', $validated = null, $open = 1, $pinned = 0, $cascading = 0, $pt_from = null, $pt_to = null, $check_perms = true, $num_views = 0, $id = null, $description_link = '')
{
    if ($pinned === null) {
        $pinned = 0;
    }
    if ($description === null) {
        $description = '';
    }
    if ($num_views === null) {
        $num_views = 0;
    }

    if (!running_script('install')) {
        require_code('antispam');
        inject_action_spamcheck(post_param_string('poster_name_if_guest', null), post_param_string('email', null));
    }

    if ($check_perms) {
        require_code('cns_topics');
        if (!cns_may_post_topic($forum_id, get_member())) {
            access_denied('I_ERROR');
        }

        if ($pt_to !== null) {
            decache_private_topics($pt_to);
        }

        if ($forum_id !== null) {
            require_code('cns_posts_action');
            cns_decache_cms_blocks($forum_id);
        }

        require_code('cns_forums');
        if (!cns_may_moderate_forum($forum_id)) {
            $pinned = 0;
            $open = 1;
            $cascading = 0;
        }
    }

    if (($validated === null) || (($check_perms) && ($validated == 1))) {
        if (($forum_id !== null) && (!has_privilege(get_member(), 'bypass_validation_midrange_content', 'topics', array('forums', $forum_id)))) {
            $validated = 0;
        } else {
            $validated = 1;
        }
    }

    if (!addon_installed('unvalidated')) {
        $validated = 1;
    }
    $map = array(
        't_pinned' => $pinned,
        't_cascading' => $cascading,
        't_forum_id' => $forum_id,
        't_pt_from' => $pt_from,
        't_pt_to' => $pt_to,
        't_description' => cms_mb_substr($description, 0, 255),
        't_description_link' => cms_mb_substr($description_link, 0, 255),
        't_emoticon' => $emoticon,
        't_num_views' => $num_views,
        't_validated' => $validated,
        't_is_open' => $open,
        't_poll_id' => null,
        't_cache_first_post_id' => null,
        't_cache_first_time' => null,
        't_cache_first_title' => '',
        't_cache_first_username' => '',
        't_cache_first_member_id' => null,
        't_cache_last_post_id' => null,
        't_cache_last_time' => null,
        't_cache_last_title' => '',
        't_cache_last_username' => '',
        't_cache_last_member_id' => null,
        't_cache_num_posts' => 0,
        't_pt_from_category' => '',
        't_pt_to_category' => '',
    );
    if (multi_lang_content()) {
        $map['t_cache_first_post'] = null;
    } else {
        $map['t_cache_first_post'] = '';
        $map['t_cache_first_post__text_parsed'] = '';
    }
    if ($id !== null) {
        $map['id'] = $id;
    }

    $topic_id = $GLOBALS['FORUM_DB']->query_insert('f_topics', $map, true);

    if ((addon_installed('commandr')) && (!running_script('install')) && (!get_mass_import_mode())) {
        require_code('resource_fs');
        generate_resource_fs_moniker('topic', strval($topic_id), null, null, true);
    }

    require_code('member_mentions');
    dispatch_member_mention_notifications('topic', strval($topic_id));

    if ($forum_id === null) {
        decache_private_topics($pt_from);
        decache_private_topics($pt_to);
    }

    if (!get_mass_import_mode()) {
        set_value('cns_topic_count', strval(intval(get_value('cns_topic_count')) + 1));

        if ($pt_to !== null) {
            log_it('PRIVATE_TOPIC', strval($pt_to), $GLOBALS['FORUM_DRIVER']->get_username($pt_to));
        }
    }

    return $topic_id;
}

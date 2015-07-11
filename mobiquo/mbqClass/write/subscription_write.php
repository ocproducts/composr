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
class CMSSubscriptionWrite
{
    /**
     * Set up notifications on a forum.
     *
     * @param  AUTO_LINK        Forum ID
     */
    function subscribe_forum($forum_id)
    {
        cms_verify_parameters_phpdoc();

        if (is_guest()) {
            access_denied('NOT_AS_GUEST');
        }

        $member_id = get_member();

        $notification_code = 'cns_topic';
        require_code('notifications');

        enable_notifications($notification_code, 'forum:' . strval($forum_id), $member_id);
    }

    /**
     * Remove notifications on a forum.
     *
     * @param  ?AUTO_LINK    Forum ID (null: all)
     */
    function unsubscribe_forum($forum_id)
    {
        cms_verify_parameters_phpdoc();

        if (is_guest()) {
            access_denied('NOT_AS_GUEST');
        }

        $member_id = get_member();

        $notification_code = 'cns_topic';
        require_code('notifications');

        if (is_null($forum_id)) {
            $subscriptions = $GLOBALS['SITE_DB']->query_select('notifications_enabled', array('l_code_category'), array('l_notification_code' => $notification_code, 'l_member_id' => $member_id), ' AND l_code_category LIKE \'forum:%\'');
            foreach ($subscriptions as $subs) {
                disable_notifications($notification_code, $subs['l_code_category'], $member_id);
            }
        } else {
            disable_notifications($notification_code, 'forum:' . strval($forum_id), $member_id);
        }
    }

    /**
     * Set up notifications on a topic.
     *
     * @param  AUTO_LINK        Topic ID
     */
    function subscribe_topic($topic_id)
    {
        cms_verify_parameters_phpdoc();

        if (is_guest()) {
            access_denied('NOT_AS_GUEST');
        }

        $member_id = get_member();

        $notification_code = 'cns_topic';
        require_code('notifications');

        enable_notifications($notification_code, strval($topic_id), $member_id);
    }

    /**
     * Remove notifications on a topic.
     *
     * @param  ?AUTO_LINK    Topic ID (null: all)
     */
    function unsubscribe_topic($topic_id)
    {
        cms_verify_parameters_phpdoc();

        if (is_guest()) {
            access_denied('NOT_AS_GUEST');
        }

        $member_id = get_member();

        $notification_code = 'cns_topic';
        require_code('notifications');

        if (is_null($topic_id)) {
            $subscriptions = $GLOBALS['SITE_DB']->query_select('notifications_enabled', array('l_code_category'), array('l_notification_code' => $notification_code, 'l_member_id' => $member_id), ' AND l_code_category NOT LIKE \'forum:%\'');
            foreach ($subscriptions as $subs) {
                if (is_numeric($subs['l_code_category'])) {
                    disable_notifications($notification_code, $subs['l_code_category'], $member_id);
                }
            }
        } else {
            disable_notifications($notification_code, strval($topic_id), $member_id);
        }
    }
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    points
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__points2()
{
    require_code('points');
}

/**
 * Transfer gift-points into the specified member's account, courtesy of the system.
 *
 * @param  SHORT_TEXT $reason The reason for the transfer
 * @param  integer $amount The size of the transfer
 * @param  MEMBER $member_id The member the transfer is to
 * @param  boolean $include_in_log Whether to include a log line
 */
function system_gift_transfer($reason, $amount, $member_id, $include_in_log = true)
{
    require_lang('points');
    require_code('points');

    if (is_guest($member_id)) {
        return;
    }
    if ($amount == 0) {
        return;
    }

    if ($include_in_log) {
        $map = array(
            'date_and_time' => time(),
            'amount' => $amount,
            'gift_from' => $GLOBALS['FORUM_DRIVER']->get_guest_id(),
            'gift_to' => $member_id,
            'anonymous' => 1,
        );
        $map += insert_lang_comcode('reason', $reason, 4);
        $GLOBALS['SITE_DB']->query_insert('gifts', $map);
    }

    $_before = point_info($member_id);
    $before = array_key_exists('points_gained_given', $_before) ? $_before['points_gained_given'] : 0;
    $new = strval($before + $amount);
    $GLOBALS['FORUM_DRIVER']->set_custom_field($member_id, 'points_gained_given', $new);

    global $TOTAL_POINTS_CACHE, $POINT_INFO_CACHE;
    if (array_key_exists($member_id, $TOTAL_POINTS_CACHE)) {
        $TOTAL_POINTS_CACHE[$member_id] += $amount;
    }
    if ((array_key_exists($member_id, $POINT_INFO_CACHE)) && (array_key_exists('points_gained_given', $POINT_INFO_CACHE[$member_id]))) {
        $POINT_INFO_CACHE[$member_id]['points_gained_given'] += $amount;
    }

    if (get_forum_type() == 'cns') {
        require_code('cns_posts_action');
        require_code('cns_posts_action2');
        cns_member_handle_promotion($member_id);
    }
}

/**
 * Give a member some points, from another member.
 *
 * @param  integer $amount The amount being given
 * @param  MEMBER $recipient_id The member receiving the points
 * @param  MEMBER $sender_id The member sending the points
 * @param  SHORT_TEXT $reason The reason for the gift
 * @param  boolean $anonymous Does the sender want to remain anonymous?
 * @param  boolean $send_email Whether to send out an email about it
 */
function give_points($amount, $recipient_id, $sender_id, $reason, $anonymous = false, $send_email = true)
{
    require_lang('points');
    require_code('points');

    $your_username = $GLOBALS['FORUM_DRIVER']->get_username($sender_id);
    $your_displayname = $GLOBALS['FORUM_DRIVER']->get_username($sender_id, true);
    $map = array(
        'date_and_time' => time(),
        'amount' => $amount,
        'gift_from' => $sender_id,
        'gift_to' => $recipient_id,
        'anonymous' => $anonymous ? 1 : 0,
    );
    $map += insert_lang_comcode('reason', $reason, 4);
    $GLOBALS['SITE_DB']->query_insert('gifts', $map);
    $sender_gift_points_used = point_info($sender_id);
    $sender_gift_points_used = array_key_exists('gift_points_used', $sender_gift_points_used) ? $sender_gift_points_used['gift_points_used'] : 0;
    $GLOBALS['FORUM_DRIVER']->set_custom_field($sender_id, 'gift_points_used', strval($sender_gift_points_used + $amount));
    $temp_points = point_info($recipient_id);
    $GLOBALS['FORUM_DRIVER']->set_custom_field($recipient_id, 'points_gained_given', strval((array_key_exists('points_gained_given', $temp_points) ? $temp_points['points_gained_given'] : 0) + $amount));
    $their_username = $GLOBALS['FORUM_DRIVER']->get_username($recipient_id);
    if (is_null($their_username)) {
        warn_exit(do_lang_tempcode('_MEMBER_NO_EXIST', $recipient_id));
    }
    $their_displayname = $GLOBALS['FORUM_DRIVER']->get_username($recipient_id, true);
    $yes = $GLOBALS['FORUM_DRIVER']->get_member_email_allowed($recipient_id);
    if (($yes) && ($send_email)) {
        $_url = build_url(array('page' => 'points', 'type' => 'member', 'id' => $recipient_id), get_module_zone('points'), null, false, false, true);
        $url = $_url->evaluate();
        require_code('notifications');
        if ($anonymous) {
            $message_raw = do_lang('GIVEN_POINTS_FOR_ANON', comcode_escape(get_site_name()), comcode_escape(integer_format($amount)), array(comcode_escape($reason), comcode_escape($url)), get_lang($recipient_id));
            dispatch_notification('received_points', null, do_lang('YOU_GIVEN_POINTS', integer_format($amount), null, null, get_lang($recipient_id)), $message_raw, array($recipient_id), A_FROM_SYSTEM_UNPRIVILEGED);
        } else {
            $message_raw = do_lang('GIVEN_POINTS_FOR', comcode_escape(get_site_name()), comcode_escape(integer_format($amount)), array(comcode_escape($reason), comcode_escape($url), comcode_escape($your_displayname), comcode_escape($your_username), comcode_escape($their_username)), get_lang($recipient_id));
            dispatch_notification('received_points', null, do_lang('YOU_GIVEN_POINTS', integer_format($amount), null, null, get_lang($recipient_id)), $message_raw, array($recipient_id), $sender_id, 3, false, false, null, null, '', '', '', '', null, true);
        }
        $message_raw = do_lang('MEMBER_GIVEN_POINTS_FOR', comcode_escape($their_displayname), comcode_escape(integer_format($amount)), array(comcode_escape($reason), comcode_escape($url), comcode_escape($your_displayname), comcode_escape($your_username), comcode_escape($their_username)), get_site_default_lang());
        dispatch_notification('receive_points_staff', null, do_lang('MEMBER_GIVEN_POINTS', integer_format($amount), null, null, get_site_default_lang()), $message_raw, null, $sender_id);
    }

    global $TOTAL_POINTS_CACHE, $POINT_INFO_CACHE;
    if (array_key_exists($recipient_id, $TOTAL_POINTS_CACHE)) {
        $TOTAL_POINTS_CACHE[$recipient_id] += $amount;
    }
    if ((array_key_exists($recipient_id, $POINT_INFO_CACHE)) && (array_key_exists('points_gained_given', $POINT_INFO_CACHE[$recipient_id]))) {
        $POINT_INFO_CACHE[$recipient_id]['points_gained_given'] += $amount;
    }
    if ((array_key_exists($sender_id, $POINT_INFO_CACHE)) && (array_key_exists('gift_points_used', $POINT_INFO_CACHE[$sender_id]))) {
        $POINT_INFO_CACHE[$sender_id]['gift_points_used'] += $amount;
    }

    if (get_forum_type() == 'cns') {
        require_code('cns_posts_action');
        require_code('cns_posts_action2');
        cns_member_handle_promotion($recipient_id);
    }

    if (!$anonymous) {
        require_code('users2');
        if (has_actual_page_access(get_modal_user(), 'points')) {
            require_code('activities');
            syndicate_described_activity(((is_null($recipient_id)) || (is_guest($recipient_id))) ? 'points:_ACTIVITY_GIVE_POINTS' : 'points:ACTIVITY_GIVE_POINTS', $reason, integer_format($amount), '', '_SEARCH:points:member:' . strval($recipient_id), '', '', 'points', 1, null, false, $recipient_id);
        }
    }
}

/**
 * Charge points from a specified member's account.
 *
 * @param  MEMBER $member_id The member that is being charged
 * @param  integer $amount The amount being charged
 * @param  SHORT_TEXT $reason The reason for the charging
 */
function charge_member($member_id, $amount, $reason)
{
    require_lang('points');
    require_code('points');

    $_before = point_info($member_id);
    $before = array_key_exists('points_used', $_before) ? intval($_before['points_used']) : 0;
    $new = $before + $amount;
    $GLOBALS['FORUM_DRIVER']->set_custom_field($member_id, 'points_used', strval($new));
    add_to_charge_log($member_id, $amount, $reason);

    global $TOTAL_POINTS_CACHE, $POINT_INFO_CACHE;
    if (array_key_exists($member_id, $TOTAL_POINTS_CACHE)) {
        $TOTAL_POINTS_CACHE[$member_id] -= $amount;
    }
    if ((array_key_exists($member_id, $POINT_INFO_CACHE)) && (array_key_exists('points_used', $POINT_INFO_CACHE[$member_id]))) {
        $POINT_INFO_CACHE[$member_id]['points_used'] += $amount;
    }
}

/**
 * Add an entry to the change log.
 *
 * @param  MEMBER $member_id The member that is being charged
 * @param  integer $amount The amount being charged
 * @param  SHORT_TEXT $reason The reason for the charging
 * @param  ?TIME $time The time this is recorded to have happened (null: use current time)
 */
function add_to_charge_log($member_id, $amount, $reason, $time = null)
{
    if (is_null($time)) {
        $time = time();
    }
    $map = array(
        'member_id' => $member_id,
        'amount' => $amount,
        'date_and_time' => $time,
    );
    $map += insert_lang_comcode('reason', $reason, 4);
    $GLOBALS['SITE_DB']->query_insert('chargelog', $map);
}

/**
 * Reverse a particular gift point transaction.
 *
 * @param  AUTO_LINK $id The transaction ID
 */
function reverse_point_gift_transaction($id)
{
    $rows = $GLOBALS['SITE_DB']->query_select('gifts', array('*'), array('id' => $id), '', 1);
    if (!array_key_exists(0, $rows)) {
        warn_exit(do_lang_tempcode('MISSING_RESOURCE'));
    }
    $myrow = $rows[0];
    $amount = $myrow['amount'];
    $sender_id = $myrow['gift_from'];
    $recipient_id = $myrow['gift_to'];

    $GLOBALS['SITE_DB']->query_delete('gifts', array('id' => $id), '', 1);
    if (!is_guest($sender_id)) {
        $_sender_gift_points_used = point_info($sender_id);
        $sender_gift_points_used = array_key_exists('gift_points_used', $_sender_gift_points_used) ? $_sender_gift_points_used['gift_points_used'] : 0;
        $GLOBALS['FORUM_DRIVER']->set_custom_field($sender_id, 'gift_points_used', strval($sender_gift_points_used - $amount));
    }
    $temp_points = point_info($recipient_id);
    $GLOBALS['FORUM_DRIVER']->set_custom_field($recipient_id, 'points_gained_given', strval((array_key_exists('points_gained_given', $temp_points) ? $temp_points['points_gained_given'] : 0) - $amount));
}

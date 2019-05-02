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
 * @package    points
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__points()
{
    global $TOTAL_POINTS_CACHE;
    $TOTAL_POINTS_CACHE = array();
    global $POINTS_USED_CACHE;
    $POINTS_USED_CACHE = array();
    global $POINT_INFO_CACHE;
    $POINT_INFO_CACHE = array();
}

/**
 * Get the price of the specified item for sale (only for tableless items).
 *
 * @param  ID_TEXT $item The name of the item
 * @return integer The price of the item
 */
function get_product_price_points($item)
{
    return $GLOBALS['SITE_DB']->query_select_value('ecom_prods_prices', 'price_points', array('name' => $item));
}

/**
 * Get the total points in the specified member's account; some of these will probably have been spent already.
 *
 * @param  MEMBER $member_id The member
 * @param  ?TIME $timestamp Time to get for (null: now)
 * @return integer The number of points the member has
 */
function total_points($member_id, $timestamp = null)
{
    if (!has_privilege($member_id, 'use_points')) {
        return 0;
    }

    global $TOTAL_POINTS_CACHE;

    if ($timestamp === null) {
        if (isset($TOTAL_POINTS_CACHE[$member_id])) {
            return $TOTAL_POINTS_CACHE[$member_id];
        }
    }

    $_points_gained = point_info($member_id);

    $points_joining = intval(get_option('points_joining'));
    $points_gained_chat = isset($_points_gained['points_gained_chat']) ? $_points_gained['points_gained_chat'] : 0;
    $points_chat = intval(get_option('points_chat', true));
    $points_gained_wiki = isset($_points_gained['points_gained_wiki']) ? $_points_gained['points_gained_wiki'] : 0;
    $points_wiki = intval(get_option('points_wiki', true));
    $points_gained_posting = $GLOBALS['FORUM_DRIVER']->get_post_count($member_id);
    $points_posting = intval(get_option('points_posting'));
    $points_gained_given = isset($_points_gained['points_gained_given']) ? $_points_gained['points_gained_given'] : 0;
    $points_gained_visiting = isset($_points_gained['points_gained_visiting']) ? $_points_gained['points_gained_visiting'] : 0;
    $points_visiting = intval(get_option('points_per_daily_visit'));
    $points_gained_rating = isset($_points_gained['points_gained_rating']) ? $_points_gained['points_gained_rating'] : 0;
    $points_rating = intval(get_option('points_rating'));
    $points_gained_voting = isset($_points_gained['points_gained_voting']) ? $_points_gained['points_gained_voting'] : 0;
    $points_voting = intval(get_option('points_voting'));
    $points_per_day = intval(get_option('points_per_day'));
    $points_gained_auto = intval(floor(floatval(time() - $GLOBALS['FORUM_DRIVER']->get_member_join_timestamp($member_id)) / floatval(60 * 60 * 24)));

    if ($timestamp !== null) {
        if (addon_installed('chat')) {
            $points_gained_chat -= min($points_gained_chat, $GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(*) FROM ' . get_table_prefix() . 'chat_messages WHERE date_and_time>' . strval($timestamp) . ' AND member_id=' . strval($member_id)));
        }
        if (addon_installed('wiki')) {
            $points_gained_wiki -= min($points_gained_wiki, $GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(*) FROM ' . get_table_prefix() . 'wiki_posts WHERE date_and_time>' . strval($timestamp) . ' AND member_id=' . strval($member_id)));
        }
        if (get_forum_type() == 'cns') {
            $points_gained_posting -= min($points_gained_posting, @intval($GLOBALS['FORUM_DB']->query_value_if_there('SELECT SUM(f_post_count_increment) FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_posts p JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_forums f ON f.id=p.p_cache_forum_id WHERE p_time>' . strval($timestamp) . ' AND p_poster=' . strval($member_id))));
        }
        $_points_gained_given = $GLOBALS['SITE_DB']->query_value_if_there('SELECT SUM(amount) FROM ' . get_table_prefix() . 'gifts WHERE date_and_time>' . strval($timestamp) . ' AND gift_to=' . strval($member_id));
        $points_gained_given -= min($points_gained_given, @intval($_points_gained_given));
        $points_gained_rating -= min($points_gained_rating, $GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(*) FROM ' . get_table_prefix() . 'rating WHERE rating_time>' . strval($timestamp) . ' AND rating_member=' . strval($member_id)));
        if (addon_installed('polls')) {
            $points_gained_voting -= min($points_gained_voting, $GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(*) FROM ' . get_table_prefix() . 'poll_votes v JOIN ' . get_table_prefix() . 'poll p ON p.id=v.v_poll_id WHERE add_time>' . strval($timestamp) . ' AND v_voter_id=' . strval($member_id)));
        }
        $points_gained_auto -= min($points_gained_auto, intval(floor(floatval(time() - $timestamp) / floatval(60 * 60 * 24))));

        if ($timestamp < $GLOBALS['FORUM_DRIVER']->get_member_join_timestamp($member_id)) {
            $points_joining = 0;
        }
    }

    $points = 0;
    $points += $points_joining;
    $points += $points_gained_chat * $points_chat;
    $points += $points_gained_wiki * $points_wiki;
    $points += $points_gained_posting * $points_posting;
    $points += $points_gained_given;
    $points += $points_gained_visiting * $points_visiting;
    $points += $points_gained_rating * $points_rating;
    $points += $points_gained_voting * $points_voting;
    $points += $points_gained_auto * $points_per_day;

    if ($timestamp === null) {
        $TOTAL_POINTS_CACHE[$member_id] = $points;
    }

    return $points;
}

/**
 * Get the total points the specified member has used (spent).
 *
 * @param  MEMBER $member_id The member
 * @return integer The number of points the member has spent
 */
function points_used($member_id)
{
    global $POINTS_USED_CACHE;
    if (isset($POINTS_USED_CACHE[$member_id])) {
        return $POINTS_USED_CACHE[$member_id];
    }

    $_points = point_info($member_id);
    $points = isset($_points['points_used']) ? $_points['points_used'] : 0;
    $POINTS_USED_CACHE[$member_id] = $points;

    return $points;
}

/**
 * Get the total points the specified member has.
 *
 * @param  MEMBER $member_id The member
 * @return integer The number of points the member has
 */
function available_points($member_id)
{
    if (!has_privilege($member_id, 'use_points')) {
        return 0;
    }

    return total_points($member_id) - points_used($member_id);
}

/**
 * Get all sorts of information about a specified member's point account.
 *
 * @param  MEMBER $member_id The member the point info is of
 * @return array The map containing the members point info (fields as enumerated in description)
 */
function point_info($member_id)
{
    require_code('lang');
    require_lang('points');

    global $POINT_INFO_CACHE;
    if (isset($POINT_INFO_CACHE[$member_id])) {
        return $POINT_INFO_CACHE[$member_id];
    }

    $values = $GLOBALS['FORUM_DRIVER']->get_custom_fields($member_id);
    if ($values === null) {
        $values = array();
    }

    $POINT_INFO_CACHE[$member_id] = array();
    foreach ($values as $key => $val) {
        if (!isset($val->codename/*faster than is_object*/)) {
            $POINT_INFO_CACHE[$member_id][$key] = intval($val);
        }
    }

    return $POINT_INFO_CACHE[$member_id];
}

/**
 * Get the number of gift points used by the given member.
 *
 * @param  MEMBER $member_id The member we want it for
 * @return integer The number of gift points used by the member
 */
function get_gift_points_used($member_id)
{
    $_actual_used = $GLOBALS['SITE_DB']->query_select_value_if_there('gifts', 'SUM(amount)', array('gift_from' => $member_id));
    $actual_used = @intval($_actual_used); // Most reliable way
    $_used = point_info($member_id);
    if (!isset($_used['gift_points_used'])) { // Some kind of DB error
        return $actual_used;
    }
    $claimed_used = $_used['gift_points_used'];
    return ($claimed_used < 0) ? $claimed_used : $actual_used; // Still allows $claimed_used to be fiddled to negative give members extra gift points
}

/**
 * Get the number of gifts points to give that the given member has.
 *
 * @param  MEMBER $member_id The member we want it for
 * @return integer The number of gifts points to give that the given member has
 */
function get_gift_points_to_give($member_id)
{
    $used = get_gift_points_used($member_id);
    if (get_forum_type() == 'cns') {
        require_lang('cns');
        require_code('cns_groups');

        $base = cns_get_member_best_group_property($member_id, 'gift_points_base');
        $per_day = cns_get_member_best_group_property($member_id, 'gift_points_per_day');
    } else {
        $base = 25;
        $per_day = 1;
    }
    $available = $base + $per_day * intval(floor((time() - $GLOBALS['FORUM_DRIVER']->get_member_join_timestamp($member_id)) / (60 * 60 * 24))) - $used;

    return $available;
}

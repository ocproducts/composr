<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    group_points
 * @package    composr_homesite_support_credits
 */

/**
 * Get the total points in the specified member's account; some of these will probably have been spent already.
 *
 * @param  MEMBER $member_id The member
 * @param  TIME $timestamp Time to get for (null: now)
 * @return integer The number of points the member has
 */
function total_points($member_id, $timestamp = null)
{
    global $TOTAL_POINTS_CACHE;

    if ($timestamp === null) {
        if (array_key_exists($member_id, $TOTAL_POINTS_CACHE)) {
            return $TOTAL_POINTS_CACHE[$member_id];
        }
    }

    $points = non_overridden__total_points($member_id, $timestamp);

    if ($GLOBALS['SITE_DB']->table_exists('credit_purchases')) {
        $credits = intval($GLOBALS['SITE_DB']->query_select_value('credit_purchases', 'SUM(num_credits)', array('member_id' => $member_id, 'purchase_validated' => 1)));

        if ($timestamp !== null) {
            $credits -= intval($GLOBALS['SITE_DB']->query_value_if_there('SELECT SUM(num_credits) FROM ' . get_table_prefix() . 'credit_purchases WHERE date_and_time>' . strval($timestamp) . ' AND member_id=' . strval($member_id)));
        }

        $points += $credits * 50;
    }

    if ($timestamp === null) {
        $TOTAL_POINTS_CACHE[$member_id] = $points;
    }

    return $points;
}

function get_group_points()
{
    $_group_points = $GLOBALS['SITE_DB']->query_select('group_points', array('*'), array(), '', null, 0, true);
    if ($_group_points === null) {
        $group_points = array();
    } else {
        $group_points = list_to_map('p_group_id', $_group_points);
    }
    return $group_points;
}

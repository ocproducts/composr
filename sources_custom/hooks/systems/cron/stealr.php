<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    stealr
 */

/**
 * Hook class.
 */
class Hook_cron_stealr
{
    /**
     * Run function for CRON hooks. Searches for tasks to perform.
     */
    public function run()
    {
        //if (!addon_installed('stealr')) return;

        require_code('cns_topics_action2');

        require_code('points');

        require_lang('stealr');

        // ensure it is done once per week
        $time = time();
        $last_time = intval(get_value('last_thieving_time'));
        if ($last_time > time() - 24 * 60 * 60 * 7) {
            return;
        }
        set_value('last_thieving_time', strval($time));

        $stealr_type = get_option('stealr_type', true);
        $stealr_type = (isset($stealr_type) && strlen($stealr_type) > 0) ? $stealr_type : 'Members that are inactive, but has lots points';

        $_stealr_number = get_option('stealr_number', true);
        $stealr_number = (isset($_stealr_number) && is_numeric($_stealr_number)) ? intval($_stealr_number) : 1;

        $_stealr_points = get_option('stealr_points', true);
        $stealr_points = (isset($_stealr_points) && is_numeric($_stealr_points)) ? intval($_stealr_points) : 10;

        $stealr_group = get_option('stealr_group', true);
        $stealr_group = (isset($stealr_group) && strlen($stealr_group) > 0) ? $stealr_group : 'Member';

        // start determining the various cases
        if ($stealr_type == 'Members that are inactive, but has lots points') {
            $all_members = $GLOBALS['FORUM_DRIVER']->get_top_posters(1000);
            $points = array();
            foreach ($all_members as $member) {
                $id = $GLOBALS['FORUM_DRIVER']->mrow_id($member);
                $signin_time = $member['m_last_visit_time'];
                $points[$signin_time] = array('points' => available_points($id), 'id' => $id);
            }

            ksort($points);

            //print_r($points);

            $stealr_number = (count($points) > $stealr_number) ? $stealr_number : count($points);
            $theft_count = 0;

            foreach ($points as $member) {
                $theft_count++;

                if ($theft_count > $stealr_number) {
                    break;
                }

                // start stealing
                require_code('points2');
                require_lang('stealr');

                $total_points = $member['points'];
                $stealr_points = ($stealr_points < $total_points) ? $stealr_points : $total_points;

                $give_to_member = $GLOBALS['FORUM_DB']->query('SELECT id FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_members WHERE  id <> ' . strval($GLOBALS['FORUM_DRIVER']->get_guest_id()) . ' AND id <> ' . strval($member['id']) . ' ORDER BY RAND( ) ', 1, null, true);

                $give_to_member = (isset($give_to_member[0]['id']) && $give_to_member[0]['id'] > 0) ? $give_to_member[0]['id'] : 0;

                // get THIEF points
                charge_member($member['id'], $stealr_points, do_lang('STEALR_GET') . ' ' . strval($stealr_points) . ' point(-s) from you.');

                if ($give_to_member > 0) {
                    system_gift_transfer(do_lang('STEALR_GAVE_YOU') . ' ' . strval($stealr_points) . ' point(-s)', $stealr_points, $give_to_member);

                    $thief_displayname = $GLOBALS['FORUM_DRIVER']->get_username($member['id'], true);
                    $target_displayname = $GLOBALS['FORUM_DRIVER']->get_username($give_to_member, true);
                    $thief_username = $GLOBALS['FORUM_DRIVER']->get_username($member['id']);
                    $target_username = $GLOBALS['FORUM_DRIVER']->get_username($give_to_member);
                    $subject = do_lang('STEALR_PT_TOPIC', strval($stealr_points), $thief_displayname, array($target_displayname, $thief_username, $target_username));
                    $body = do_lang('STEALR_PT_TOPIC_POST', strval($stealr_points), $thief_displayname, array($target_displayname, $thief_username, $target_username));

                    require_code('cns_topics_action');
                    require_code('cns_posts_action');

                    $topic_id = cns_make_topic(null, '', '', 1, 1, 0, 0, 0, $member['id'], $give_to_member, false, 0, null, '');

                    $post_id = cns_make_post($topic_id, $subject, $body, 0, true, 1, 0, null, null, null, $give_to_member, null, null, null, false, true, null, true, $subject, 0, null, true, true, true);

                    send_pt_notification($post_id, $subject, $topic_id, $give_to_member, $GLOBALS['FORUM_DRIVER']->mrow_id($member));
                    send_pt_notification($post_id, $subject, $topic_id, $GLOBALS['FORUM_DRIVER']->mrow_id($member), $give_to_member);
                }
            }
        } elseif ($stealr_type == 'Members that are rich') {
            $all_members = $GLOBALS['FORUM_DRIVER']->get_top_posters(100);
            $points = array();
            foreach ($all_members as $member) {
                $id = $GLOBALS['FORUM_DRIVER']->mrow_id($member);
                $points[$id] = available_points($id);
            }
            arsort($points);

            $stealr_number = (count($points) > $stealr_number) ? $stealr_number : count($points);
            $theft_count = 0;

            foreach ($points as $member_id => $av_points) {
                $theft_count++;

                if ($theft_count > $stealr_number) {
                    break;
                }

                // start stealing
                require_code('points2');
                require_lang('stealr');

                $total_points = $av_points;
                $stealr_points = ($stealr_points < $total_points) ? $stealr_points : $total_points;

                $give_to_member = $GLOBALS['FORUM_DB']->query('SELECT id FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_members WHERE  id <> ' . strval($GLOBALS['FORUM_DRIVER']->get_guest_id()) . ' AND id <> ' . strval($member_id) . ' ORDER BY RAND( ) ', 1, null, true);

                $give_to_member = (isset($give_to_member[0]['id']) && $give_to_member[0]['id'] > 0) ? $give_to_member[0]['id'] : 0;

                // get THIEF points
                charge_member($member_id, $stealr_points, do_lang('STEALR_GET') . ' ' . strval($stealr_points) . ' point(-s) from you.');

                if ($give_to_member > 0) {
                    system_gift_transfer(do_lang('STEALR_GAVE_YOU') . ' ' . strval($stealr_points) . ' point(-s)', $stealr_points, $give_to_member);

                    require_code('cns_topics_action');
                    require_code('cns_posts_action');

                    $subject = do_lang('STEALR_PT_TOPIC', strval($stealr_points));
                    $topic_id = cns_make_topic(null, '', '', 1, 1, 0, 0, 0, $member_id, $give_to_member, false, 0, null, '');

                    $post_id = cns_make_post($topic_id, $subject, do_lang('STEALR_PT_TOPIC_POST'), 0, true, 1, 0, null, null, null, $give_to_member, null, null, null, false, true, null, true, $subject, 0, null, true, true, true);

                    send_pt_notification($post_id, $subject, $topic_id, $give_to_member, $member_id);
                    send_pt_notification($post_id, $subject, $topic_id, $member_id, $give_to_member);
                }
            }
        } elseif ($stealr_type == 'Members that are random') {
            $random_members = $GLOBALS['FORUM_DB']->query('SELECT id FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_members WHERE  id <> ' . strval($GLOBALS['FORUM_DRIVER']->get_guest_id()) . ' ORDER BY RAND( ) ', $stealr_number, null, true);

            $stealr_number = (count($random_members) > $stealr_number) ? $stealr_number : count($random_members);

            foreach ($random_members as $member) {
                // start stealing
                require_code('points2');
                require_lang('stealr');

                $total_points = available_points($member['id']);
                $stealr_points = ($stealr_points < $total_points) ? $stealr_points : $total_points;

                $give_to_member = $GLOBALS['FORUM_DB']->query('SELECT id FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_members WHERE  id <> ' . strval($GLOBALS['FORUM_DRIVER']->get_guest_id()) . ' AND id <> ' . strval($member['id']) . ' ORDER BY RAND( ) ', 1, null, true);

                $give_to_member = (isset($give_to_member[0]['id']) && $give_to_member[0]['id'] > 0) ? $give_to_member[0]['id'] : 0;

                // get THIEF points
                charge_member($member['id'], $stealr_points, do_lang('STEALR_GET') . ' ' . strval($stealr_points) . ' point(-s) from you.');

                if ($give_to_member != 0) {
                    system_gift_transfer(do_lang('STEALR_GAVE_YOU') . ' ' . strval($stealr_points) . ' point(-s)', $stealr_points, $give_to_member);

                    require_code('cns_topics_action');
                    require_code('cns_posts_action');

                    $subject = do_lang('STEALR_PT_TOPIC', strval($stealr_points));
                    $topic_id = cns_make_topic(null, '', '', 1, 1, 0, 0, 0, $member['id'], $give_to_member, false, 0, null, '');

                    $post_id = cns_make_post($topic_id, $subject, do_lang('STEALR_PT_TOPIC_POST'), 0, true, 1, 0, null, null, null, $give_to_member, null, null, null, false, true, null, true, $subject, 0, null, true, true, true);

                    send_pt_notification($post_id, $subject, $topic_id, $give_to_member, $member['id']);
                    send_pt_notification($post_id, $subject, $topic_id, $member['id'], $give_to_member);
                }
            }
        } elseif ($stealr_type == 'Members that are in a certain usergroup') {
            $groups = $GLOBALS['FORUM_DRIVER']->get_usergroup_list();

            $group_id = 0;
            foreach ($groups as $id => $group) {
                if ($stealr_group == $group) {
                    $group_id = $id;
                }
            }

            require_code('cns_groups2');
            $members = cns_get_group_members_raw($group_id);

            $stealr_number = (count($members) > $stealr_number) ? $stealr_number : count($members);

            $members_to_steal_ids = array_rand($members, $stealr_number);

            if ($stealr_number == 1) {
                $members_to_steal_ids = array('0' => $members_to_steal_ids);
            }

            foreach ($members_to_steal_ids as $member_rand_key) {
                // start stealing
                require_code('points2');
                require_lang('stealr');

                //echo $members[$member_rand_key];
                $total_points = available_points($members[$member_rand_key]);
                $stealr_points = ($stealr_points < $total_points) ? $stealr_points : $total_points;

                $give_to_member = $GLOBALS['FORUM_DB']->query('SELECT id FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_members WHERE  id <> ' . strval($GLOBALS['FORUM_DRIVER']->get_guest_id()) . ' AND id <> ' . strval($members[$member_rand_key]) . ' ORDER BY RAND( ) ', 1, null, true);

                $give_to_member = (isset($give_to_member[0]['id']) && $give_to_member[0]['id'] > 0) ? $give_to_member[0]['id'] : 0;

                // get THIEF points
                charge_member($members[$member_rand_key], $stealr_points, do_lang('STEALR_GET') . ' ' . strval($stealr_points) . ' point(-s) from you.');

                if ($give_to_member != 0) {
                    system_gift_transfer(do_lang('STEALR_GAVE_YOU') . ' ' . strval($stealr_points) . ' point(-s)', $stealr_points, $give_to_member);

                    require_code('cns_topics_action');
                    $subject = do_lang('STEALR_PT_TOPIC', strval($stealr_points));
                    $topic_id = cns_make_topic(null, '', '', 1, 1, 0, 0, 0, $members[$member_rand_key], $give_to_member, false, 0, null, '');

                    require_code('cns_posts_action');
                    $post_id = cns_make_post($topic_id, $subject, do_lang('STEALR_PT_TOPIC_POST'), 0, true, 1, 0, null, null, null, $give_to_member, null, null, null, false, true, null, true, $subject, 0, null, true, true, true);

                    require_code('cns_topics_action2');
                    send_pt_notification($post_id, $subject, $topic_id, $give_to_member, $stealr_number);
                    send_pt_notification($post_id, $subject, $topic_id, $stealr_number, $give_to_member);
                }
            }
        }
    }
}

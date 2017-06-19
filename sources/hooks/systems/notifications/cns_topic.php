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
class Hook_notification_cns_topic extends Hook_Notification
{
    /**
     * Find whether a handled notification code supports categories.
     * (Content types, for example, will define notifications on specific categories, not just in general. The categories are interpreted by the hook and may be complex. E.g. it might be like a regexp match, or like FORUM:3 or TOPIC:100)
     *
     * @param  ID_TEXT $notification_code Notification code
     * @return boolean Whether it does
     */
    public function supports_categories($notification_code)
    {
        return true;
    }

    /**
     * Standard function to create the standardised category tree
     *
     * @param  ID_TEXT $notification_code Notification code
     * @param  ?ID_TEXT $id The ID of where we're looking under (null: N/A)
     * @return array Tree structure
     */
    public function create_category_tree($notification_code, $id)
    {
        require_code('cns_forums2');

        $notification_category = get_param_string('id', null);
        $done_in_url = ($notification_category === null);

        $total = $GLOBALS['FORUM_DB']->query_select_value('f_forums', 'COUNT(*)');
        if ($total > intval(get_option('general_safety_listing_limit'))/*reasonable limit*/) {
            return parent::create_category_tree($notification_code, $id); // Too many, so just allow removing UI
        }

        if ($id !== null) {
            if (substr($id, 0, 6) != 'forum:') {
                $title = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_topics', 't_cache_first_title', array('id' => intval($id)));

                $page_links = array();
                $page_links[] = array(
                    'id' => $id,
                    'title' => do_lang('A_TOPIC', $title),
                );
                return $page_links;
            }
            $id = substr($id, 6);
        }

        $_page_links = cns_get_forum_tree(null, ($id === null) ? null : intval($id), '', null, null, false, ($id === null) ? 0 : 1);

        $page_links = array();
        foreach ($_page_links as $p) {
            $p['id'] = 'forum:' . strval($p['id']);
            $p['title'] = do_lang('A_FORUM', $p['title']);
            $page_links[] = $p;

            if (!$done_in_url) {
                if ('forum:' . $p['id'] == $notification_category) {
                    $done_in_url = true;
                }
            }
        }

        if ($id === null) { // On root level add monitored topics too
            $max_topic_rows = max(0, 200 - $total);
            $types2 = $GLOBALS['SITE_DB']->query_select('notifications_enabled', array('l_code_category'), array('l_notification_code' => 'cns_topic', 'l_member_id' => get_member()), 'ORDER BY id DESC', $max_topic_rows/*reasonable limit*/);
            if (count($types2) == $max_topic_rows) {
                $types2 = array(); // Too many to consider
            }

            foreach ($types2 as $type) {
                if (is_numeric($type['l_code_category'])) {
                    $title = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_topics', 't_cache_first_title', array('id' => intval($type['l_code_category'])));
                    if ($title !== null) {
                        $page_links[] = array(
                            'id' => $type['l_code_category'],
                            'title' => do_lang('A_TOPIC', $title),
                        );

                        if (!$done_in_url) {
                            if ($type['l_code_category'] == $notification_category) {
                                $done_in_url = true;
                            }
                        }
                    }
                }
            }
        }

        if ((!$done_in_url) && (is_numeric($notification_category))) {
            $title = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_topics', 't_cache_first_title', array('id' => intval($notification_category)));

            $page_links[] = array(
                'id' => $notification_category,
                'title' => do_lang('A_TOPIC', $title),
            );
        }

        return $page_links;
    }

    /**
     * Find a bitmask of settings (email, SMS, etc) a notification code supports for listening on.
     *
     * @param  ID_TEXT $notification_code Notification code
     * @return integer Allowed settings
     */
    public function allowed_settings($notification_code)
    {
        return A__ALL & ~A_INSTANT_PT;
    }

    /**
     * Find the initial setting that members have for a notification code (only applies to the member_could_potentially_enable members).
     *
     * @param  ID_TEXT $notification_code Notification code
     * @param  ?SHORT_TEXT $category The category within the notification code (null: none)
     * @return integer Initial setting
     */
    public function get_initial_setting($notification_code, $category = null)
    {
        return A_NA;
    }

    /**
     * Find the setting that members have for a notification code if they have done some action triggering automatic setting (e.g. posted within a topic).
     *
     * @param  ID_TEXT $notification_code Notification code
     * @param  ?SHORT_TEXT $category The category within the notification code (null: none)
     * @return integer Automatic setting
     */
    public function get_default_auto_setting($notification_code, $category = null)
    {
        return A__STATISTICAL;
    }

    /**
     * Get a list of all the notification codes this hook can handle.
     * (Addons can define hooks that handle whole sets of codes, so hooks are written so they can take wide authority)
     *
     * @return array List of codes (mapping between code names, and a pair: section and labelling for those codes)
     */
    public function list_handled_codes()
    {
        $list = array();
        $list['cns_topic'] = array(do_lang('CONTENT'), do_lang('cns:NOTIFICATION_TYPE_cns_topic'));
        return $list;
    }

    /**
     * Find whether someone has permisson to view any notifications (yes) and possibly if they actually are.
     *
     * @param  ?ID_TEXT $only_if_enabled_on__notification_code Notification code (null: don't check if they are)
     * @param  ?SHORT_TEXT $only_if_enabled_on__category The category within the notification code (null: none)
     * @param  MEMBER $member_id Member to check against
     * @return boolean Whether they do
     */
    protected function _is_member($only_if_enabled_on__notification_code, $only_if_enabled_on__category, $member_id)
    {
        if ($only_if_enabled_on__notification_code === null) {
            return true;
        }

        if (is_numeric($only_if_enabled_on__category)) { // Also merge in people monitoring forum
            $forum_details = $GLOBALS['FORUM_DB']->query_select('f_topics', array('t_forum_id', 't_pt_from', 't_pt_to'), array('id' => intval($only_if_enabled_on__category)));
            $forum_id = $forum_details[0]['t_forum_id'];

            if ($forum_id === null) {
                require_code('cns_topics');
                if (!(($forum_details[0]['t_pt_from'] == $member_id) || ($forum_details[0]['t_pt_to'] == $member_id) || (cns_has_special_pt_access(intval($only_if_enabled_on__category), $member_id)) || (!has_privilege($member_id, 'view_other_pt')))) {
                    return false;
                }
            }
        }

        return notifications_enabled($only_if_enabled_on__notification_code, $only_if_enabled_on__category, $member_id);
    }

    /**
     * Get a list of members who have enabled this notification (i.e. have permission to AND have chosen to or are defaulted to).
     *
     * @param  ID_TEXT $notification_code Notification code
     * @param  ?SHORT_TEXT $category The category within the notification code (null: none)
     * @param  ?array $to_member_ids List of member IDs we are restricting to (null: no restriction). This effectively works as a intersection set operator against those who have enabled.
     * @param  integer $start Start position (for pagination)
     * @param  integer $max Maximum (for pagination)
     * @return array A pair: Map of members to their notification setting, and whether there may be more
     */
    public function list_members_who_have_enabled($notification_code, $category = null, $to_member_ids = null, $start = 0, $max = 300)
    {
        if ((!is_numeric($category)) && ($category !== null)) {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR')); // We should never be accessing as forum:<id>, that is used only behind the scenes
        }

        list($members, $maybe_more) = $this->_all_members_who_have_enabled($notification_code, $category, $to_member_ids, $start, $max);

        if (is_numeric($category)) { // This is a topic. Also merge in people monitoring forum
            $forum_details = $GLOBALS['FORUM_DB']->query_select('f_topics', array('t_forum_id', 't_pt_from', 't_pt_to'), array('id' => intval($category)));
            if (!array_key_exists(0, $forum_details)) {
                return array(array(), false); // Topic deleted already?
            }
            $forum_id = $forum_details[0]['t_forum_id'];

            if ($forum_id !== null) { // Forum
                list($members2, $maybe_more2) = $this->_all_members_who_have_enabled($notification_code, 'forum:' . strval($forum_id), $to_member_ids, $start, $max);
                $members += $members2;
                $maybe_more = $maybe_more || $maybe_more2;
            } else { // Private topic, scan for participation against those already monitoring, for retroactive security (maybe someone lost access)
                require_code('cns_topics');
                $members_new = $members;
                foreach ($members as $member_id => $setting) {
                    if (($forum_details[0]['t_pt_from'] == $member_id) || ($forum_details[0]['t_pt_to'] == $member_id) || (cns_has_special_pt_access(intval($category), $member_id)) || (!has_privilege($member_id, 'view_other_pt'))) {
                        $members_new[$member_id] = $setting;
                    }
                }
                $members = $members_new;
            }
        } else { // This is a forum. Actually this code path should rarely if ever run - we don't dispatch notifications against forums, but topics (see above code branch).
            $forum_id = intval(substr($category, 6));
        }

        if ($forum_id !== null) { // We know PTs have been pre-filtered before notification is sent out, to limit them
            list($members, $maybe_more) = $this->_all_members_who_have_enabled_with_zone_access(array($members, $maybe_more), 'forum', $notification_code, $category, $to_member_ids, $start, $max);
            list($members, $maybe_more) = $this->_all_members_who_have_enabled_with_category_access(array($members, $maybe_more), 'forums', $notification_code, strval($forum_id), $to_member_ids, $start, $max);
        }

        // Filter members who has more than one unread posts in that topic
        if (is_numeric($category)) {
            $members_new = array();
            foreach ($members as $member_id => $setting) {
                $fields = $GLOBALS['FORUM_DRIVER']->get_custom_fields($member_id);
                $smart_topic_notification_enabled = (isset($fields['smart_topic_notification'])) && ($fields['smart_topic_notification'] == '1');

                if ($smart_topic_notification_enabled) { // Maybe we don't send, based on identifying whether they have received a notification already since last reading the topic
                    $read_log_time = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_read_logs', 'l_time', array('l_member_id' => $member_id, 'l_topic_id' => intval($category)));
                    if ($read_log_time !== null) { // Has been visited at some point
                        $num_posts_since = $GLOBALS['FORUM_DB']->query_value_if_there('SELECT COUNT(*) FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_posts WHERE p_intended_solely_for IS NULL AND p_topic_id=' . strval(intval($category)) . ' AND p_time>' . strval($read_log_time));
                        if ($num_posts_since <= 1) { // Ah, just this one new post, so we can notify
                            $members_new[$member_id] = $setting;
                        } // Else we know there have been other posts since and not to send the notification
                    } else { // We assume has never been visited
                        $members_new[$member_id] = $setting;
                        $GLOBALS['FORUM_DB']->query_insert('f_read_logs', array('l_member_id' => $member_id, 'l_topic_id' => $category, 'l_time' => 0)); // So we can count the number of posts since this
                    }
                } else { // Send as normal
                    $members_new[$member_id] = $setting;
                }
            }
            $members = $members_new;
        }

        return array($members, $maybe_more);
    }
}

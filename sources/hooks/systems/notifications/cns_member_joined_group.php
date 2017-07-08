<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

 See text/EN/licence.txt for full licencing information.


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
 * Hook class.
 */
class Hook_notification_cns_member_joined_group extends Hook_Notification
{
    /**
     * Find whether a handled notification code supports categories.
     * (Content types, for example, will define notifications on specific categories, not just in general. The categories are interpreted by the hook and may be complex. E.g. it might be like a regexp match, or like FORUM:3 or TOPIC:100).
     *
     * @param  ID_TEXT $notification_code Notification code
     * @return boolean Whether it does
     */
    public function supports_categories($notification_code)
    {
        return true;
    }

    /**
     * Standard function to create the standardised category tree.
     *
     * @param  ID_TEXT $notification_code Notification code
     * @param  ?ID_TEXT $id The ID of where we're looking under (null: N/A)
     * @return array Tree structure
     */
    public function create_category_tree($notification_code, $id)
    {
        $page_links = array();

        $where = '1=1';
        if (has_privilege(get_member(), 'see_hidden_groups')) {
            $members_groups = $GLOBALS['CNS_DRIVER']->get_members_groups(get_member());
            $where .= ' AND (g_hidden=0 OR g.id IN (' . implode(',', array_map('strval', $members_groups)) . '))';
        }

        $types = $GLOBALS['FORUM_DB']->query('SELECT id,g_name FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_groups g WHERE ' . $where);
        foreach ($types as $type) {
            $page_links[] = array(
                'id' => $type['id'],
                'title' => get_translated_text($type['g_name'], $GLOBALS['FORUM_DB']),
            );
        }
        sort_maps_by($page_links, 'title');

        return $page_links;
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
     * Get a list of all the notification codes this hook can handle.
     * (Addons can define hooks that handle whole sets of codes, so hooks are written so they can take wide authority).
     *
     * @return array List of codes (mapping between code names, and a pair: section and labelling for those codes)
     */
    public function list_handled_codes()
    {
        $list = array();
        $list['cns_member_joined_group'] = array(do_lang('USERGROUPS'), do_lang('cns:NOTIFICATION_TYPE_cns_member_joined_group'));
        return $list;
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
        list($members, $maybe_more) = $this->_all_members_who_have_enabled($notification_code, $category, $to_member_ids, $start, $max);
        list($members, $maybe_more) = $this->_all_members_who_have_enabled_with_page_access(array($members, $maybe_more), 'groups', $notification_code, $category, $to_member_ids, $start, $max);

        if (is_numeric($category)) { // Filter if the group is hidden
            $hidden = $GLOBALS['FORUM_DB']->query_select_value('f_groups', 'g_hidden', array('id' => intval($category)));

            if ($hidden == 1) {
                $members_groups = $GLOBALS['CNS_DRIVER']->get_members_groups(get_member());

                $members_new = array();
                foreach ($members as $member_id => $setting) {
                    if ((has_privilege($member_id, 'see_hidden_groups')) || (in_array(intval($category), $members_groups))) {
                        $members_new[$member_id] = $setting;
                    }
                }
                $members = $members_new;
            }
        }

        return array($members, $maybe_more);
    }
}

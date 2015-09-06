<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    buildr
 */

/**
 * Hook class.
 */
class Hook_members_buildr
{
    /**
     * Find member-related links to inject.
     *
     * @param  MEMBER $member_id The ID of the member we are getting link hooks for
     * @return array List of lists of tuples for results (by link section). Each tuple is: type,title,url
     */
    public function run($member_id)
    {
        if (!addon_installed('buildr')) {
            return array();
        }

        $zone = get_page_zone('buildr', false);
        if (is_null($zone)) {
            return array();
        }
        if (!has_zone_access(get_member(), $zone)) {
            return array();
        }

        $id = $GLOBALS['SITE_DB']->query_select_value_if_there('w_members', 'id', array('id' => $member_id), '', true);
        if (!is_null($id)) {
            require_lang('buildr');
            return array(array('audit', do_lang_tempcode('BUILDR'), build_url(array('page' => 'buildr', 'type' => 'inventory', 'member' => $member_id), get_page_zone('buildr')), 'menu/buildr'));
        }
        return array();
    }
}

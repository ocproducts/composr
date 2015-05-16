<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 */
class Hook_members_filedump
{
    /**
     * Find member-related links to inject.
     *
     * @param  MEMBER $member_id The ID of the member we are getting link hooks for
     * @return array List of lists of tuples for results (by link section). Each tuple is: type,title,url
     */
    public function run($member_id)
    {
        if (!addon_installed('filedump')) {
            return array();
        }

        $zone = get_page_zone('filedump', false);
        if (is_null($zone)) {
            return array();
        }
        if (!has_zone_access(get_member(), $zone)) {
            return array();
        }

        require_lang('filedump');

        $path = $GLOBALS['FORUM_DRIVER']->get_username($member_id);

        return array(array('content', do_lang_tempcode('FILEDUMP'), build_url(array('page' => 'filedump', 'type' => 'browse', 'place' => '/' . $path . '/'), $zone), 'menu/cms/filedump'));
    }
}

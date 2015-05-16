<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    classifieds
 */

/**
 * Hook class.
 */
class Hook_members_classifieds
{
    /**
     * Find member-related links to inject.
     *
     * @param  MEMBER $member_id The ID of the member we are getting link hooks for
     * @return array List of lists of tuples for results (by link section). Each tuple is: type,title,url
     */
    public function run($member_id)
    {
        if (!has_actual_page_access(get_member(), 'classifieds', get_module_zone('classifieds'))) {
            return array();
        }

        require_lang('classifieds');

        $result = array();

        if (($member_id == get_member()) || (has_privilege(get_member(), 'assume_any_member'))) {
            $result[] = array('content', do_lang('CLASSIFIED_ADVERTS'), build_url(array('page' => 'classifieds', 'type' => 'adverts', 'member_id' => $member_id), get_module_zone('classifieds')), 'menu/rich_content/catalogues/classifieds');
        }

        return $result;
    }
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_homesite_support_credits
 */

/**
 * Hook class.
 */
class Hook_members_customers
{
    /**
     * Find member-related links to inject.
     *
     * @param  MEMBER $member_id The ID of the member we are getting link hooks for
     * @return array List of lists of tuples for results (by link section). Each tuple is: type,title,url
     */
    public function run($member_id)
    {
        if (!has_actual_page_access(get_member(), 'admin_ecommerce', get_module_zone('admin_ecommerce'))) {
            return array();
        }

        require_lang('customers');
        return array(
            array('views', do_lang_tempcode('GIVE_CREDITS'), build_url(array('page' => 'admin_ecommerce', 'type' => 'trigger', 'member_id' => $member_id), get_module_zone('admin_ecommerce')), 'menu/_generic_spare/1'),
            array('views', do_lang_tempcode('CHARGE_CUSTOMER'), build_url(array('page' => 'admin_customers', 'type' => 'charge', 'username' => $GLOBALS['FORUM_DRIVER']->get_username($member_id)), get_module_zone('admin_customers')), 'menu/_generic_spare/2'),
        );
    }
}

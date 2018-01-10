<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    referrals
 */

function init__hooks__systems__ecommerce__cart_orders($in)
{
    if (!$GLOBALS['SITE_DB']->table_exists('referees_qualified_for')) {
        return $in;
    }

    require_code('referrals');

    return override_str_replace_exactly(
        "send_shopping_order_purchased_staff_mail(\$order_id);",
        "
        <ditto>
        \$member_id = \$GLOBALS['SITE_DB']->query_select_value('shopping_order', 'c_member', array('id' => \$purchase_id));
        if (\$member_id !== null) {
            assign_referral_awards(\$member_id, 'misc_purchase');
            \$products = \$GLOBALS['SITE_DB']->query_select('shopping_order_details', array('p_id'), array('p_order_id' => \$purchase_id));
            foreach (\$products as \$p) {
                assign_referral_awards(\$member_id, 'purchase_' . strval(\$p['p_id']));
            }
        }
        ",
        $in
    );
}

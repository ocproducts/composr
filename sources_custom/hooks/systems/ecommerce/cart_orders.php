<?php

function init__hooks__systems__ecommerce__cart_orders($in = null)
{
    require_code('referrals');

    return str_replace(
        'purchase_done_staff_mail($purchase_id);',

        '
        purchase_done_staff_mail($purchase_id);
        $member_id = $GLOBALS[\'SITE_DB\']->query_select_value(\'shopping_order\', \'c_member\', array(\'id\' => $purchase_id));
        if (!is_null($member_id)) {
            assign_referral_awards($member_id, \'misc_purchase\');
            $products = $GLOBALS[\'SITE_DB\']->query_select(\'shopping_order_details\', array(\'p_id\'), array(\'order_id\' => $purchase_id));
            foreach ($products as $p) {
                    assign_referral_awards($member_id, \'purchase_\' . strval($p[\'p_id\']));
            }
        }
        ',

        $in
    );
}

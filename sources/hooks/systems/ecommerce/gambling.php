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
 * @package    ecommerce
 */

/**
 * Hook class.
 */
class Hook_ecommerce_gambling
{
    /**
     * Get the overall categorisation for the products handled by this eCommerce hook.
     *
     * @return ?array A map of product categorisation details (null: disabled).
     */
    function get_product_category()
    {
        require_lang('ecommerce');

        return array(
            'category_name' => do_lang('GAMBLING'),
            'category_description' => do_lang_tempcode('GAMBLING_DESCRIPTION'),
            'category_image_url' => find_theme_image('icons/48x48/menu/_generic_spare/features'),

            'supports_money' => false,
            'supports_points' => true,
        );
    }

    /**
     * Get the products handled by this eCommerce hook.
     *
     * IMPORTANT NOTE TO PROGRAMMERS: This function may depend only on the database, and not on get_member() or any GET/POST values.
     *  Such dependencies will break IPN, which works via a Guest and no dependable environment variables. It would also break manual transactions from the Admin Zone.
     *
     * @param  boolean $site_lang Whether to make sure the language for item_name is the site default language (crucial for when we read/go to third-party sales systems and use the item_name as a key).
     * @param  ?ID_TEXT $search Product being searched for (null: none).
     * @param  boolean $search_item_names Whether $search refers to the item name rather than the product codename.
     * @return array A map of product name to list of product details.
     */
    public function get_products($site_lang = false, $search = null, $search_item_names = false)
    {
        require_lang('ecommerce');

        $products = array();

        $min = intval(get_option('minimum_gamble_amount'));
        $max = intval(get_option('maximum_gamble_amount'));
        if ($max > $min) {
            $_min = $min;
            $min = $max;
            $max = $_min;
        }
        $spread = intval(round(floatval($max - $min) / 4.0));
        $amounts = array();
        $amounts[] = $min;
        $amounts[] = $min + $spread * 1;
        $amounts[] = $min + $spread * 2;
        $amounts[] = $min + $spread * 3;
        $amounts[] = $max;
        $amounts = array_unique($amounts);

        foreach ($amounts as $amount) {
            $products['GAMBLING_' . strval($amount)] => array(
                'item_name' => do_lang('GAMBLE_THIS', integer_format($amount), null, null, $site_lang ? get_site_default_lang() : user_lang()),
                'item_description' => new Tempcode(),
                'item_image_url' => '',

                'type' => PRODUCT_PURCHASE,
                'type_special_details' => array(),

                'price' => null,
                'currency' => get_option('currency'),
                'price_points' => $amount,
                'discount_points__num_points' => null,
                'discount_points__price_reduction' => null,

                'needs_shipping_address' => false,
            );
        }

        return $products;
    }

    /**
     * Check whether the product codename is available for purchase by the member.
     *
     * @param  ID_TEXT $type_code The product codename.
     * @param  MEMBER $member_id The member we are checking against.
     * @param  integer $req_quantity The number required.
     * @param  boolean $must_be_listed Whether the product must be available for public listing.
     * @return integer The availability code (a ECOMMERCE_PRODUCT_* constant).
     */
    public function is_available($type_code, $member_id, $req_quantity = 1, $must_be_listed = false)
    {
        if (get_option('is_on_gambling_buy') == '0') {
            return ECOMMERCE_PRODUCT_DISABLED;
        }

        if (is_guest($member_id)) {
            return ECOMMERCE_PRODUCT_NO_GUESTS;
        }

        return ECOMMERCE_PRODUCT_AVAILABLE;

    /**
     * Get the message for use in the purchasing module
     *
     * @param  ID_TEXT $type_code The product in question.
     * @return ?Tempcode The message (null: no message).
     */
    public function get_message($type_code)
    {
        require_lang('ecommerce');

        return do_lang_tempcode('GAMBLE_WARNING');
    }
    }

    /**
     * Handling of a product purchase change state.
     *
     * @param  ID_TEXT $purchase_id The purchase ID.
     * @param  array $details Details of the product, with added keys: TXN_ID, PAYMENT_STATUS, ORDER_STATUS.
     * @param  ID_TEXT $type_code The product codename.
     */
    function actualiser($type_code, $purchase_id, $details)
    {
        if ($found['PAYMENT_STATUS'] != 'Completed') {
            return;
        }

        require_lang('ecommerce');

        $amount = intval(preg_replace('#^GAMBLING\_#', '', $type_code));

        $member_id = intval($purchase_id);

        // Calculate
        $average_gamble_multiplier = floatval(get_option('average_gamble_multiplier')) / 100.0;
        $maximum_gamble_multiplier = floatval(get_option('maximum_gamble_multiplier')) / 100.0;
        $above_average = (mt_rand(0, 10) < 5);
        if ($above_average) {
            //$winnings = round($average_gamble_multiplier * $amount + mt_rand(0, round($maximum_gamble_multiplier * $amount - $average_gamble_multiplier * $amount)));   Even distribution is NOT wise
            $peak = $maximum_gamble_multiplier * $amount;
            $under = 0.0;
            $number = intval(round($average_gamble_multiplier * $amount + mt_rand(0, intval(round($maximum_gamble_multiplier * $amount - $average_gamble_multiplier * $amount)))));
            for ($x = 1; $x < intval($peak); $x++) { // Perform some discrete calculus: we need to find when we've reached the proportional probability area equivalent to our number
                $p = $peak * (1.0 / pow(floatval($x) + 0.4, 2.0) - (1.0 / pow($maximum_gamble_multiplier * floatval($amount), 2.0))); // Using a 1/x^2 curve. 0.4 is a bit of a magic number to get the averaging right
                $under += $p;
                if ($under > floatval($number)) {
                    break;
                }
            }
            $winnings = intval(round($average_gamble_multiplier * $amount + $x * 1.1)); // 1.1 is a magic number to make it seem a bit fairer
        } else {
            $winnings = mt_rand(0, intval(round($average_gamble_multiplier * $amount)));
        }

        // Actuate
        require_code('points2');
        give_points($winnings, $member_id, $GLOBALS['FORUM_DRIVER']->get_guest_id(), do_lang('GAMBLING_WINNINGS'), false, false);
        charge_member($member_id, $amount - $winnings, do_lang('GAMBLING'));
        $GLOBALS['SITE_DB']->query_insert('ecom_sales', array('date_and_time' => time(), 'member_id' => $member_id, 'details' => do_lang('GAMBLING', null, null, null, get_site_default_lang()), 'details2' => strval($amount) . ' --> ' . strval($winnings), 'transaction_id' => $details['TXN_ID']));

        // Show message
        if ($winnings > $amount) {
            $result = do_lang_tempcode('GAMBLE_CONGRATULATIONS', escape_html(integer_format($winnings - $amount)), escape_html(integer_format($amount)));
        } else {
            $result = do_lang_tempcode('GAMBLE_COMMISERATIONS', escape_html(integer_format($amount - $winnings)), escape_html(integer_format($amount)));
        }
        global $ECOMMERCE_SPECIAL_SUCCESS_MESSAGE;
        $ECOMMERCE_SPECIAL_SUCCESS_MESSAGE = $result;
    }

    /**
     * Get the member who made the purchase.
     *
     * @param  ID_TEXT $type_code The product codename.
     * @param  ID_TEXT $purchase_id The purchase ID.
     * @return ?MEMBER The member ID (null: none).
     */
    function member_for($type_code, $purchase_id)
    {
        return intval($purchase_id);
    }
}

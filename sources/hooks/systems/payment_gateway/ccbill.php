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
class Hook_payment_gateway_ccbill
{
    // https://www.ccbill.com/cs/manuals/CCBill_Background_Post_Users_Guide.pdf
    // Requires:
    //  you have to contact support to enable dynamic pricing and generate the encryption key for your account
    //  the "Account ID" (a number given to you) is the Composr "Gateway username" and also "Testing mode gateway username" (it's all the same installation ID)
    //  the "Subaccount ID" is the Composr "Gateway VPN username". You can optionally enter two subaccount IDs separated by a comma, the first one will be used for single transactions and the second for recurring transactions.
    //  your encryption key is the Composr "Gateway VPN password".
    //  create a form with dynamic pricing from the form admin and enter its code name as the "Gateway digest code". You can optionally enter two values separated by a comma; the first one will be used for simple transactions and the second for subscriptions.

    private $length_unit_to_days = array(
        'd' => 1,
        'w' => 7,
        'm' => 30,
        'y' => 365
    );

    private $currency_numeric_to_alphabetic_code = array(
        // Currencies supported by CCBill
        840 => 'USD',
        978 => 'EUR',
        826 => 'GBP',
        124 => 'CAD',
        36 => 'AUD',
        392 => 'JPY',
    );

    private $currency_alphabetic_to_numeric_code = array(
        // Currencies supported by CCBill
        'USD' => 840,
        'EUR' => 978,
        'GBP' => 826,
        'CAD' => 124,
        'AUD' => 36,
        'JPY' => 392,
    );

    /**
     * Find a transaction fee from a transaction amount. Regular fees aren't taken into account.
     *
     * @param  float $amount A transaction amount.
     * @return float The fee
     */
    public function get_transaction_fee($amount)
    {
        return 0.12 * $amount; // A wild guess for now
    }

    /**
     * Get the CCBill account ID
     *
     * @return string The answer.
     */
    private function get_account_id()
    {
        return ecommerce_test_mode() ? get_option('payment_gateway_test_username') : get_option('payment_gateway_username');
    }

    /**
     * Make a transaction (payment) button.
     *
     * @param  ID_TEXT $type_code The product codename.
     * @param  SHORT_TEXT $item_name The human-readable product title.
     * @param  ID_TEXT $purchase_id The purchase ID.
     * @param  float $amount A transaction amount.
     * @param  ID_TEXT $currency The currency to use.
     * @return Tempcode The button.
     */
    public function make_transaction_button($type_code, $item_name, $purchase_id, $amount, $currency)
    {
        if (!isset($this->currency_alphabetic_to_numeric_code[$currency])) {
            warn_exit(do_lang_tempcode('UNRECOGNISED_CURRENCY', 'ccbill', escape_html($currency)));
        }
        $currency = strval($this->currency_alphabetic_to_numeric_code[$currency]);

        $payment_address = $this->get_account_id();
        $form_url = 'https://bill.ccbill.com/jpost/signup.cgi';

        $account_num = $this->get_account_id();
        $subaccount_nums = explode(',', get_option('payment_gateway_vpn_username'));
        $subaccount_num = sprintf('%04d', $subaccount_nums[0]); // First value is for simple transactions, has to be exactly 4 digits
        $form_name = explode(',', get_option('payment_gateway_digest'));
        $form_name = $form_name[0]; // First value is for simple transactions
        // CCBill oddly requires us to pass this parameter for single transactions,
        // this will show up as a confusing "$X.XX for 99 days" message to customers on the CCBill form.
        // To fix this - you need to set up a "custom dynamic description" which removes that message, by contacting CCBill support.
        $form_period = '99';
        $digest = md5(float_to_raw_string($amount) . $form_period . $currency . get_option('payment_gateway_vpn_password'));

        return do_template('ECOM_TRANSACTION_BUTTON_VIA_CCBILL', array(
            '_GUID' => '24a0560541cedd4c45898f4d19e99249',
            'TYPE_CODE' => $type_code,
            'ITEM_NAME' => $item_name,
            'PURCHASE_ID' => $purchase_id,
            'AMOUNT' => float_to_raw_string($amount),
            'CURRENCY' => $currency,
            'PAYMENT_ADDRESS' => $payment_address,
            'FORM_URL' => $form_url,
            'MEMBER_ADDRESS' => $this->_build_member_address(),
            'ACCOUNT_NUM' => $account_num,
            'SUBACCOUNT_NUM' => $subaccount_num,
            'FORM_NAME' => $form_name,
            'FORM_PERIOD' => $form_period,
            'DIGEST' => $digest,
        ));
    }

    /**
     * Make a subscription (payment) button.
     *
     * @param  ID_TEXT $type_code The product codename.
     * @param  SHORT_TEXT $item_name The human-readable product title.
     * @param  ID_TEXT $purchase_id The purchase ID.
     * @param  float $amount A transaction amount.
     * @param  integer $length The subscription length in the units.
     * @param  ID_TEXT $length_units The length units.
     * @set    d w m y
     * @param  ID_TEXT $currency The currency to use.
     * @return Tempcode The button.
     */
    public function make_subscription_button($type_code, $item_name, $purchase_id, $amount, $length, $length_units, $currency)
    {
        if (!isset($this->currency_alphabetic_to_numeric_code[$currency])) {
            warn_exit(do_lang_tempcode('UNRECOGNISED_CURRENCY', 'ccbill', escape_html($currency)));
        }
        $currency = strval($this->currency_alphabetic_to_numeric_code[$currency]);

        $payment_address = $this->get_account_id();
        $form_url = 'https://bill.ccbill.com/jpost/signup.cgi';

        $account_num = $this->get_account_id();
        $subaccount_nums = explode(',', get_option('payment_gateway_vpn_username'));
        $subaccount_num = sprintf('%04d', count($subaccount_nums) === 1 ? $subaccount_nums[0] : $subaccount_nums[1]); // Second value is for subscriptions, has to be exactly 4 digits
        $form_name = explode(',', get_option('ccbill_form_names'));
        $form_name = count($form_name) === 1 ? $form_name[0] : $form_name[1]; // Second value is for subscriptions
        $form_period = strval($length * $this->length_unit_to_days[$length_units]);
        $digest = md5(float_to_raw_string($amount) . $form_period . float_to_raw_string($amount) . $form_period . '99' . $currency . get_option('payment_gateway_vpn_password')); // formPrice.formPeriod.formRecurringPrice.formRecurringPeriod.formRebills.currencyCode.salt

        return do_template('ECOM_SUBSCRIPTION_BUTTON_VIA_CCBILL', array(
            '_GUID' => 'f8c174f38ae06536833f1510027ba233',
            'TYPE_CODE' => $type_code,
            'ITEM_NAME' => $item_name,
            'PURCHASE_ID' => $purchase_id,
            'LENGTH' => strval($length),
            'LENGTH_UNITS' => $length_units,
            'AMOUNT' => float_to_raw_string($amount),
            'CURRENCY' => $currency,
            'PAYMENT_ADDRESS' => $payment_address,
            'FORM_URL' => $form_url,
            'MEMBER_ADDRESS' => $this->_build_member_address(),
            'ACCOUNT_NUM' => $account_num,
            'SUBACCOUNT_NUM' => $subaccount_num,
            'FORM_NAME' => $form_name,
            'FORM_PERIOD' => $form_period,
            'DIGEST' => $digest,
        ));
    }

    /**
     * Get a member address/etc for use in payment buttons.
     *
     * @return array A map of member address details (form field name => address value).
     */
    protected function _build_member_address()
    {
        $member_address = array();
        if (!is_guest()) {
            $member_address['customer_fname'] = get_cms_cpf('firstname');
            $member_address['customer_lname'] = get_cms_cpf('lastname');
            $member_address['address1'] = get_cms_cpf('street_address');
            $member_address['email'] = $GLOBALS['FORUM_DRIVER']->get_member_email_address(get_member());
            $member_address['city'] = get_cms_cpf('city');
            $member_address['state'] = get_cms_cpf('state');
            $member_address['zipcode'] = get_cms_cpf('post_code');
            $member_address['country'] = get_cms_cpf('country');
            $member_address['username'] = $GLOBALS['FORUM_DRIVER']->get_username(get_member());
        }
        return $member_address;
    }

    /**
     * Make a subscription cancellation button.
     *
     * @param  ID_TEXT $purchase_id The purchase ID.
     * @return Tempcode The button
     */
    public function make_cancel_button($purchase_id)
    {
        return do_template('ECOM_SUBSCRIPTION_CANCEL_BUTTON_VIA_CCBILL', array('_GUID' => 'f1aaed809380c3fdca22728393eaef75', 'PURCHASE_ID' => $purchase_id));
    }

    /**
     * Handle IPN's. The function may produce output, which would be returned to the Payment Gateway. The function may do transaction verification.
     *
     * @return ?array A long tuple of collected data (null: no transaction; will only return null when not running the 'ecommerce' script).
     */
    public function handle_ipn_transaction()
    {
        $purchase_id = post_param_integer('customPurchaseId');

        $subscription_id = post_param_string('subscription_id', '');
        $denial_id = post_param_string('denialId', '');
        $response_digest = post_param_string('responseDigest');
        $success_response_digest = md5($subscription_id . '1' . get_option('payment_gateway_vpn_password')); // responseDigest must have this value on success
        $denial_response_digest = md5($denial_id . '0' . get_option('payment_gateway_vpn_password')); // responseDigest must have this value on failure

        if (($response_digest !== $success_response_digest) && ($response_digest !== $denial_response_digest)) {
            if (!running_script('ecommerce')) {
                return null;
            }
            fatal_ipn_exit(do_lang('IPN_UNVERIFIED')); // Hacker?!!!
        }

        $success = ($success_response_digest === $response_digest);
        $is_subscription = (post_param_integer('customIsSubscription') == 1);
        $item_name = $is_subscription ? '' : post_param_string('customItemName');
        $payment_status = $success ? 'Completed' : 'Failed';
        $reason_code = post_param_integer('reasonForDeclineCode', 0);
        $pending_reason = '';
        $memo = '';
        $mc_gross = post_param_string('initialPrice');
        $_mc_currency = post_param_integer('baseCurrency', 0);
        $mc_currency = ($_mc_currency === 0) ? get_option('currency') : $this->currency_numeric_to_alphabetic_code[$_mc_currency];
        $txn_id = post_param_string('consumerUniqueId');

        if (addon_installed('shopping')) {
            list(, $type_code) = find_product_details($item_name, true, true);
            if ($type_code == 'cart_orders') {
                $this->store_shipping_address(intval($purchase_id));
            }
        }

        return array($purchase_id, $item_name, $payment_status, $reason_code, $pending_reason, $memo, $mc_gross, $mc_currency, $txn_id, '');
    }

    /**
     * Store shipping address for orders.
     *
     * @param  AUTO_LINK $order_id Order ID.
     * @return ?mixed Address ID (null: No address record found).
     */
    public function store_shipping_address($order_id)
    {
        if (is_null(post_param_string('address1', null))) {
            return null;
        }

        if (is_null($GLOBALS['SITE_DB']->query_select_value_if_there('shopping_order_addresses', 'id', array('a_order_id' => $order_id)))) {
            $shipping_address = array(
                'a_order_id' => $order_id,
                'a_firstname' => post_param_string('customer_fname', ''),
                'a_lastname' => post_param_string('customer_lname', ''),
                'a_street_address' => trim(post_param_string('address1', '') . "\n" . post_param_string('address2', '')),
                'a_city' => post_param_string('city', ''),
                'a_county' => '',
                'a_state' => post_param_string('state', ''),
                'a_post_code' => post_param_string('zipcode', ''),
                'a_country' => post_param_string('country', ''),
                'a_email' => post_param_string('email', ''),
                'a_phone' => post_param_string('phone_number', ''),
            );
            return $GLOBALS['SITE_DB']->query_insert('shopping_order_addresses', $shipping_address, true);
        }

        return null;
    }

    /**
     * Find whether the hook auto-cancels (if it does, auto cancel the given subscription).
     *
     * @param  AUTO_LINK $subscription_id ID of the subscription to cancel.
     * @return ?boolean True: yes. False: no. (null: cancels via a user-URL-directioning)
     */
    public function auto_cancel($subscription_id)
    {
        // https://www.ccbill.com/cs/manuals/Custom_Cancellation_Software.pdf
        // Can't do it because we don't have customer's username and password ("login_id", "password")

        return false;
    }
}

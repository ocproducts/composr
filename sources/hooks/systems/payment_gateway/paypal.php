<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


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
class Hook_payment_gateway_paypal
{
    /**
     * Get a standardised config map.
     *
     * @return array The config
     */
    public function get_config()
    {
        return array(
            'supports_remote_memo' => true,
        );
    }

    /**
     * Find a transaction fee from a transaction amount. Regular fees aren't taken into account.
     *
     * @param  float $amount A transaction amount
     * @return float The fee
     */
    public function get_transaction_fee($amount)
    {
        return round(0.25 + 0.034 * $amount, 2);
    }

    /**
     * Get the PayPal payment address.
     *
     * @return string The answer
     */
    protected function _get_payment_address()
    {
        return ecommerce_test_mode() ? get_option('payment_gateway_test_username') : get_option('payment_gateway_username');
    }

    /**
     * Get the remote form URL.
     *
     * @return URLPATH The remote form URL
     */
    protected function _get_remote_form_url()
    {
        return ecommerce_test_mode() ? 'https://ipnpb.sandbox.paypal.com/cgi-bin/webscr' : 'https://ipnpb.paypal.com/cgi-bin/webscr';
    }

    /**
     * Generate a transaction ID / trans-expecting ID.
     *
     * @return string A transaction ID
     */
    public function generate_trans_id()
    {
        require_code('crypt');
        return get_secure_random_string();
    }

    /**
     * Make a transaction (payment) button.
     *
     * @param  ID_TEXT $trans_expecting_id Our internal temporary transaction ID
     * @param  ID_TEXT $type_code The product codename
     * @param  SHORT_TEXT $item_name The human-readable product title
     * @param  ID_TEXT $purchase_id The purchase ID
     * @param  float $price Transaction price in money
     * @param  float $tax Transaction tax in money
     * @param  float $shipping_cost Shipping cost
     * @param  ID_TEXT $currency The currency to use
     * @return Tempcode The button
     */
    public function make_transaction_button($trans_expecting_id, $type_code, $item_name, $purchase_id, $price, $tax, $shipping_cost, $currency)
    {
        // https://developer.paypal.com/docs/classic/paypal-payments-standard/integration-guide/formbasics/

        $payment_address = $this->_get_payment_address();
        $form_url = $this->_get_remote_form_url();

        return do_template('ECOM_TRANSACTION_BUTTON_VIA_PAYPAL', array(
            '_GUID' => 'b0d48992ed17325f5e2330bf90c85762',
            'TYPE_CODE' => $type_code,
            'ITEM_NAME' => $item_name,
            'PURCHASE_ID' => $purchase_id,
            'TRANS_EXPECTING_ID' => $trans_expecting_id,
            'PRICE' => float_to_raw_string($price),
            'TAX' => float_to_raw_string($tax),
            'SHIPPING_COST' => float_to_raw_string($shipping_cost),
            'AMOUNT' => float_to_raw_string($price + $tax + $shipping_cost),
            'CURRENCY' => $currency,
            'PAYMENT_ADDRESS' => $payment_address,
            'FORM_URL' => $form_url,
            'MEMBER_ADDRESS' => $this->_build_member_address(),
        ));
    }

    /**
     * Make a transaction (payment) button for multiple shopping cart items.
     * Optional method, provides more detail than make_transaction_button.
     *
     * @param  ID_TEXT $trans_expecting_id Our internal temporary transaction ID
     * @param  array $items Items array
     * @param  float $shipping_cost Shipping cost
     * @param  Tempcode $currency Currency symbol
     * @param  AUTO_LINK $order_id Order ID
     * @return Tempcode The button
     */
    public function make_cart_transaction_button($trans_expecting_id, $items, $shipping_cost, $currency, $order_id)
    {
        if (!addon_installed('shopping')) {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }

        $payment_address = $this->_get_payment_address();

        $form_url = $this->_get_remote_form_url();

        return do_template('ECOM_CART_BUTTON_VIA_PAYPAL', array(
            '_GUID' => '89b7edf976ef0143dd8dfbabd3378c95',
            'ITEMS' => $items,
            'CURRENCY' => $currency,
            'SHIPPING_COST' => $shipping_cost,
            'PAYMENT_ADDRESS' => $payment_address,
            'FORM_URL' => $form_url,
            'MEMBER_ADDRESS' => $this->_build_member_address(),
            'ORDER_ID' => strval($order_id),
            'TRANS_EXPECTING_ID' => $trans_expecting_id,
            'TYPE_CODE' => $items[0]['TYPE_CODE'],
        ));
    }

    /**
     * Make a subscription (payment) button.
     *
     * @param  ID_TEXT $trans_expecting_id Our internal temporary transaction ID
     * @param  ID_TEXT $type_code The product codename
     * @param  SHORT_TEXT $item_name The human-readable product title
     * @param  ID_TEXT $purchase_id The purchase ID
     * @param  float $price Transaction price in money
     * @param  float $tax Transaction tax in money
     * @param  ID_TEXT $currency The currency to use
     * @param  integer $length The subscription length in the units
     * @param  ID_TEXT $length_units The length units
     * @set d w m y
     * @return Tempcode The button
     */
    public function make_subscription_button($trans_expecting_id, $type_code, $item_name, $purchase_id, $price, $tax, $currency, $length, $length_units)
    {
        $payment_address = $this->_get_payment_address();
        $form_url = $this->_get_remote_form_url();
        return do_template('ECOM_SUBSCRIPTION_BUTTON_VIA_PAYPAL', array(
            '_GUID' => '7c8b9ce1f60323e118da1bef416adff3',
            'TYPE_CODE' => $type_code,
            'ITEM_NAME' => $item_name,
            'LENGTH' => strval($length),
            'LENGTH_UNITS' => $length_units,
            'PURCHASE_ID' => $purchase_id,
            'TRANS_EXPECTING_ID' => $trans_expecting_id,
            'PRICE' => float_to_raw_string($price),
            'TAX' => float_to_raw_string($tax),
            'AMOUNT' => float_to_raw_string($price + $tax),
            'CURRENCY' => $currency,
            'PAYMENT_ADDRESS' => $payment_address,
            'FORM_URL' => $form_url,
            'MEMBER_ADDRESS' => $this->_build_member_address(),
        ));
    }

    /**
     * Get a member address/etc for use in payment buttons.
     *
     * @return array A map of member address details (form field name => address value)
     */
    protected function _build_member_address()
    {
        $shipping_email = '';
        $shipping_phone = '';
        $shipping_firstname = '';
        $shipping_lastname = '';
        $shipping_street_address = '';
        $shipping_city = '';
        $shipping_county = '';
        $shipping_state = '';
        $shipping_post_code = '';
        $shipping_country = '';
        $shipping_email = '';
        $shipping_phone = '';
        $cardholder_name = '';
        $card_type = '';
        $card_number = null;
        $card_start_date_year = null;
        $card_start_date_month = null;
        $card_expiry_date_year = null;
        $card_expiry_date_month = null;
        $card_issue_number = null;
        $card_cv2 = null;
        $billing_street_address = '';
        $billing_city = '';
        $billing_county = '';
        $billing_state = '';
        $billing_post_code = '';
        $billing_country = '';
        get_default_ecommerce_fields(null, $shipping_email, $shipping_phone, $shipping_firstname, $shipping_lastname, $shipping_street_address, $shipping_city, $shipping_county, $shipping_state, $shipping_post_code, $shipping_country, $cardholder_name, $card_type, $card_number, $card_start_date_year, $card_start_date_month, $card_expiry_date_year, $card_expiry_date_month, $card_issue_number, $card_cv2, $billing_street_address, $billing_city, $billing_county, $billing_state, $billing_post_code, $billing_country, false, false);

        if ($shipping_street_address == '') {
            $street_address = $billing_street_address;
            $city = $billing_city;
            $county = $billing_county;
            $state = $billing_state;
            $post_code = $billing_post_code;
            $country = $billing_country;
        } else {
            $street_address = $shipping_street_address;
            $city = $shipping_city;
            $county = $shipping_county;
            $state = $shipping_state;
            $post_code = $shipping_post_code;
            $country = $shipping_country;
        }

        $member_address = array();
        $member_address['first_name'] = $shipping_firstname;
        $member_address['last_name'] = $shipping_lastname;
        list($street_address_1, $street_address_2) = split_street_address($street_address, 2);
        $member_address['address1'] = $street_address_1;
        $member_address['address2'] = $street_address_2;
        $member_address['city'] = $city;
        $member_address['state'] = $state;
        $member_address['zip'] = $post_code;
        $member_address['country'] = $country;

        require_code('locations');
        if (find_country_name_from_iso($member_address['country'])  === null) {
            $member_address['country'] = ''; // PayPal only allows valid countries
        }

        if (($member_address['address1'] == '') || ($member_address['city'] == '') || ($member_address['zip'] == '') || ($member_address['country'] == '')) {
            $member_address = array(); // Causes error on PayPal due to it crashing when trying to validate the address
        }

        return $member_address;
    }

    /**
     * Make a subscription cancellation button.
     *
     * @param  ID_TEXT $purchase_id The purchase ID
     * @return Tempcode The button
     */
    public function make_cancel_button($purchase_id)
    {
        return do_template('ECOM_SUBSCRIPTION_CANCEL_BUTTON_VIA_PAYPAL', array('_GUID' => '091d7449161eb5c4f6129cf89e5e8e7e', 'PURCHASE_ID' => $purchase_id));
    }

    /**
     * Handle IPN's. The function may produce output, which would be returned to the Payment Gateway. The function may do transaction verification.
     *
     * @param  boolean $silent_fail Return null on failure rather than showing any error message. Used when not sure a valid & finalised transaction is in the POST environment, but you want to try just in case (e.g. on a redirect back from the gateway).
     * @return ?array A long tuple of collected data. Emulates some of the key variables of the PayPal IPN response (null: no transaction; will only return null when $silent_fail is set).
     */
    public function handle_ipn_transaction($silent_fail)
    {
        $trans_expecting_id = post_param_string('custom');

        $transaction_rows = $GLOBALS['SITE_DB']->query_select('ecom_trans_expecting', array('*'), array('id' => $trans_expecting_id), '', 1);
        if (!array_key_exists(0, $transaction_rows)) {
            if ($silent_fail) {
                return null;
            }
            warn_exit(do_lang_tempcode('MISSING_RESOURCE'));
        }
        $transaction_row = $transaction_rows[0];

        $member_id = $transaction_row['e_member_id'];
        $type_code = $transaction_row['e_type_code'];
        $item_name = $transaction_row['e_item_name'];
        $purchase_id = $transaction_row['e_purchase_id'];

        $reason = post_param_string('reason_code', '');
        $pending_reason = post_param_string('pending_reason', '');
        $memo = post_param_string('memo', '');
        foreach (array_keys($_POST) as $key) { // Custom product options go onto the memo
            $matches = array();
            if (preg_match('#^option_selection(\d+)$#', $key, $matches) != 0) {
                $memo .= "\n" . post_param_string('option_name' . $matches[1], '') . ' = ' . post_param_string('option_selection' . $matches[1], '');
            }
        }
        $txn_id = post_param_string('txn_id', ''); // May be blank for subscription, will be overwritten for them
        $parent_txn_id = post_param_string('parent_txn_id', '-1');
        $_amount = post_param_string('mc_gross', ''); // May be blank for subscription
        $amount = ($_amount == '') ? null : floatval($_amount);
        $_tax = post_param_string('tax', '');
        if ($_tax == '') {
            $tax = null;
        } else {
            $tax = floatval($_tax);
        }
        $currency = post_param_string('mc_currency', get_option('currency')); // May be blank for subscription
        $period = post_param_string('period3', '');

        // Valid transaction types / pre-processing for $item_name based on mapping rules
        $txn_type = post_param_string('txn_type', null);
        switch ($txn_type) {
            // Product
            case 'web_accept':
            case 'cart':
                $is_subscription = false;
                break;

            // Subscription
            case 'subscr_signup':
            case 'subscr_payment':
            case 'subscr_failed':
            case 'subscr_modify':
            case 'subscr_cancel':
            case 'subscr_eot':
                $is_subscription = true;
                break;

            // (Non-supported)
            case 'adjustment':
            case 'express_checkout':
            case 'masspay':
            case 'mp_cancel':
            case 'mp_signup':
            case 'merch_pmt':
            case 'new_case':
            case 'payout':
            case 'recurring_payment':
            case 'recurring_payment_expired':
            case 'recurring_payment_failed':
            case 'recurring_payment_profile_created':
            case 'recurring_payment_profile_cancel':
            case 'recurring_payment_skipped':
            case 'recurring_payment_suspended':
            case 'recurring_payment_suspended_due_to_max_failed_payment':
            case 'send_money':
            case 'virtual_terminal':
            default:
                if ($silent_fail) {
                    return null;
                }
                exit(); // Non-supported for IPN in Composr
        }
        $status = post_param_string('payment_status', '');
        if (($status == 'Pending') && (ecommerce_test_mode())) {
            $status = 'Completed';
        }
        switch ($status) {
            // Subscription
            case '': // We map certain values of txn_type for subscriptions over to payment_status, as subscriptions have no payment status but similar data in txn_type which we do not use
                $_amount = post_param_string('mc_amount3');
                $amount = floatval($_amount);

                switch ($txn_type) {
                    case 'subscr_signup':
                        // SECURITY: Check it's a kind of subscription we would actually have generated
                        if (post_param_integer('recurring') != 1) {
                            if ($silent_fail) {
                                return null;
                            }
                            fatal_ipn_exit(do_lang('IPN_SUB_RECURRING_WRONG'));
                        }

                        // SECURITY: Check user is not giving themselves a free trial (we don't support trials)
                        if ((post_param_string('amount1', '') != '') || (post_param_string('amount2', '') != '') || (post_param_string('mc_amount1', '') != '') || (post_param_string('mc_amount2', '') != '') || (post_param_string('period1', '') != '') || (post_param_string('period2', '') != '')) {
                            if ($silent_fail) {
                                return null;
                            }
                            fatal_ipn_exit(do_lang('IPN_BAD_TRIAL'));
                        }

                        $status = 'Completed';
                        $txn_id = post_param_string('subscr_id');

                        // NB: subscr_date is sent by IPN, but not user-settable. For the more complex PayPal APIs we may need to validate it

                        break;

                    case 'subscr_payment':
                        if ($silent_fail) {
                            return null;
                        }
                        exit(); // We don't need to track individual payments

                    case 'subscr_failed':
                        if ($silent_fail) {
                            return null;
                        }
                        exit(); // PayPal auto-cancels at a configured point ("To avoid unnecessary cancellations, you can specify that PayPal should reattempt failed payments before cancelling subscriptions."). So, we only listen to the actual cancellation signal.

                    case 'subscr_modify':
                        $status = 'SModified';
                        $txn_id = post_param_string('subscr_id') . '-m';
                        break;

                    case 'subscr_cancel':
                        if ($silent_fail) {
                            return null;
                        }
                        exit(); // We ignore cancel transactions as we don't want to process them immediately - we just let things run until the end-of-term (see below). Maybe ideally we would process these in Composr as a separate state, but it would over-complicate things

                    case 'subscr_eot': // NB: An 'eot' means "end of *final* term" (i.e. if a payment fail / cancel / natural last term, has happened). PayPal's terminology is a little dodgy here.
                    case 'recurring_payment_suspended_due_to_max_failed_payment':
                        $status = 'SCancelled';
                        $txn_id = post_param_string('subscr_id') . '-c';
                        break;
                }
                break;

            // Pending
            case 'Pending':
                break;

            // Completed
            case 'Completed':
            case 'Created':
                $status = 'Completed';
                break;

            // (Non-supported)
            case 'Reversed':
            case 'Refunded':
            case 'Denied':
            case 'Expired':
            case 'Failed':
            case 'Canceled_Reversal':
            case 'Voided':
            case 'Processed': // Mass-payments
                if ($silent_fail) {
                    return null;
                }
                exit(); // Non-supported for IPN in Composr
        }

        // SECURITY: Ignore sandbox transactions if we are not in test mode
        if (post_param_integer('test_ipn', 0) == 1) {
            if (!ecommerce_test_mode()) {
                if ($silent_fail) {
                    return null;
                }
                exit();
            }
        }

        // SECURITY: Post back to PayPal system to validate
        if ((!ecommerce_test_mode()) && (!$GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())/*allow debugging if your test IP was intentionally back-doored*/)) {
            require_code('files');
            $pure_post = empty($GLOBALS['PURE_POST']) ? $_POST : $GLOBALS['PURE_POST'];
            $x = 0;
            $res = null;
            do { // Try up to 3 times
                $url = 'https://' . (ecommerce_test_mode() ? 'www.sandbox.paypal.com' : 'www.paypal.com') . '/cgi-bin/webscr';
                $res = http_get_contents($url, array('trigger_error' => false, 'post_params' => $pure_post + array('cmd' => '_notify-validate')));
                $x++;
            } while (($res === null) && ($x < 3));
            if ($res === null) {
                if ($silent_fail) {
                    return null;
                }
                fatal_ipn_exit(do_lang('IPN_SOCKET_ERROR'));
            }
            if (!(strcmp($res, 'VERIFIED') == 0)) {
                if ($silent_fail) {
                    return null;
                }
                fatal_ipn_exit(do_lang('IPN_UNVERIFIED') . ' - ' . $res . ' - ' . flatten_slashed_array($pure_post, true), strpos($res, '<html') !== false);
            }
        }

        // SECURITY: Check it came into our own account
        $receiver_email = post_param_string('receiver_email', null);
        if ($receiver_email === null) {
            $receiver_email = post_param_string('business');
        }
        $primary_paypal_email = get_option('primary_paypal_email');
        if ($primary_paypal_email == '') {
            $primary_paypal_email = $this->_get_payment_address();
        }
        if ($receiver_email != $primary_paypal_email && $receiver_email != $this->_get_payment_address()) {
            if ($silent_fail) {
                return null;
            }
            fatal_ipn_exit(do_lang('IPN_EMAIL_ERROR', $receiver_email, $primary_paypal_email));
        }

        $this->store_shipping_address($trans_expecting_id, $txn_id);

        if (($amount !== null) && ($tax !== null)) {
            $amount -= $tax; // The sent amount includes tax, but we want it without
        }

        return array($trans_expecting_id, $txn_id, $type_code, $item_name, $purchase_id, $is_subscription, $status, $reason, $amount, $tax, $currency, $parent_txn_id, $pending_reason, $memo, $period, $member_id);
    }

    /**
     * Store shipping address for a transaction.
     *
     * @param  ID_TEXT $trans_expecting_id Expected transaction ID
     * @param  ID_TEXT $txn_id Transaction ID
     * @return AUTO_LINK Address ID
     */
    public function store_shipping_address($trans_expecting_id, $txn_id)
    {
        $shipping_address = array(
            'a_firstname' => post_param_string('first_name', ''),
            'a_lastname' => post_param_string('last_name', ''),
            'a_street_address' => trim(post_param_string('address_name', '') . "\n" . post_param_string('address_street', '')),
            'a_city' => post_param_string('address_city', ''),
            'a_county' => '',
            'a_state' => '',
            'a_post_code' => post_param_string('address_zip', ''),
            'a_country' => post_param_string('address_country', ''),
            'a_email' => post_param_string('payer_email', ''),
            'a_phone' => post_param_string('contact_phone', ''),
        );
        return store_shipping_address($trans_expecting_id, $txn_id, $shipping_address);
    }

    /**
     * Get the status message after a URL callback.
     *
     * @return ?string Message (null: none)
     */
    public function get_callback_url_message()
    {
        return get_param_string('message', null, INPUT_FILTER_GET_COMPLEX);
    }

    /**
     * Find whether the hook auto-cancels (if it does, auto cancel the given subscription).
     *
     * @param  AUTO_LINK $subscription_id ID of the subscription to cancel
     * @return ?boolean True: yes. False: no. (null: cancels via a user-URL-directioning)
     */
    public function auto_cancel($subscription_id)
    {
        // To implement this automatically we need to implement the REST API with oAuth, which is quite a lot of work.
        // Should work for make_subscription_button-created subscriptions though, as long as they start "I-" not "S-"
        // http://stackoverflow.com/questions/3809587/can-you-cancel-a-paypal-automatic-payment-via-api-subscription-created-via-hos

        return null;
    }
}

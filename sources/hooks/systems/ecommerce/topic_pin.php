<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

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
class Hook_ecommerce_topic_pin
{
    /**
     * Get the overall categorisation for the products handled by this eCommerce hook.
     *
     * @return ?array A map of product categorisation details (null: disabled)
     */
    public function get_product_category()
    {
        if (!addon_installed('cns_forum')) {
            return null;
        }

        return array(
            'category_name' => do_lang('TOPIC_PINNING'),
            'category_description' => do_lang_tempcode('TOPIC_PINNING_DESCRIPTION'),
            'category_image_url' => find_theme_image('icons/buttons/add_topic'),
        );
    }

    /**
     * Get the products handled by this eCommerce hook.
     *
     * IMPORTANT NOTE TO PROGRAMMERS: This function may depend only on the database, and not on get_member() or any GET/POST values.
     *  Such dependencies will break IPN, which works via a Guest and no dependable environment variables. It would also break manual transactions from the Admin Zone.
     *
     * @param  ?ID_TEXT $search Product being searched for (null: none)
     * @return array A map of product name to list of product details
     */
    public function get_products($search = null)
    {
        require_lang('cns');

        $products = array();

        $price_points = get_option('topic_pin_price_points');

        foreach (array(1, 3, 5, 10, 20, 31, 90) as $days) {
            $products['TOPIC_PIN_' . strval($days)] = automatic_discount_calculation(array(
                'item_name' => do_lang('TOPIC_PINNED_FOR', integer_format($days)),
                'item_description' => new Tempcode(),
                'item_image_url' => '',

                'type' => PRODUCT_PURCHASE,
                'type_special_details' => array(),

                'price' => (get_option('topic_pin_price') == '') ? null : (floatval(get_option('topic_pin_price')) * $days),
                'currency' => get_option('currency'),
                'price_points' => empty($price_points) ? null : (intval($price_points) * $days),
                'discount_points__num_points' => null,
                'discount_points__price_reduction' => null,

                'tax_code' => get_option('topic_pin_tax_code'),
                'shipping_cost' => 0.00,
                'product_weight' => null,
                'product_length' => null,
                'product_width' => null,
                'product_height' => null,
                'needs_shipping_address' => false,
            ));
        }

        return $products;
    }

    /**
     * Check whether the product codename is available for purchase by the member.
     *
     * @param  ID_TEXT $type_code The product codename
     * @param  MEMBER $member_id The member we are checking against
     * @param  integer $req_quantity The number required
     * @param  boolean $must_be_listed Whether the product must be available for public listing
     * @return integer The availability code (a ECOMMERCE_PRODUCT_* constant)
     */
    public function is_available($type_code, $member_id, $req_quantity = 1, $must_be_listed = false)
    {
        if (!addon_installed('cns_forum')) {
            return ECOMMERCE_PRODUCT_INTERNAL_ERROR;
        }

        if (has_no_forum()) {
            return ECOMMERCE_PRODUCT_DISABLED;
        }

        if (get_option('is_on_topic_pin_buy') == '0') {
            return ECOMMERCE_PRODUCT_DISABLED;
        }

        return ECOMMERCE_PRODUCT_AVAILABLE;
    }

    /**
     * Get fields that need to be filled in in the purchasing module.
     *
     * @param  ID_TEXT $type_code The product codename
     * @param  boolean $from_admin Whether this is being called from the Admin Zone. If so, optionally different fields may be used, including a purchase_id field for direct purchase ID input.
     * @return ?array A triple: The fields (null: none), The text (null: none), The JavaScript (null: none)
     */
    public function get_needed_fields($type_code, $from_admin = false)
    {
        require_lang('cns');

        $fields = new Tempcode();
        if (get_forum_type() == 'cns') {
            $set_name = 'topic';
            $required = true;
            $set_title = do_lang_tempcode('FORUM_TOPIC');
            $field_set = alternate_fields_set__start($set_name);

            $field_set->attach(form_input_tree_list(do_lang_tempcode('CHOOSE'), '', 'select_topic_id', null, 'choose_topic', array(), false));

            $field_set->attach(form_input_integer(do_lang_tempcode('IDENTIFIER'), do_lang_tempcode('DESCRIPTION_FORUM_TOPIC_ID'), 'manual_topic_id', null, false));

            $fields->attach(alternate_fields_set__end($set_name, $set_title, '', $field_set, $required));
        } else {
            $fields->attach(form_input_integer(do_lang_tempcode('FORUM_TOPIC'), do_lang_tempcode('ENTER_TOPIC_ID_MANUALLY'), 'manual_topic_id', null, false));
        }

        ecommerce_attach_memo_field_if_needed($fields);

        return array($fields, null, null);
    }

    /**
     * Get the filled in fields and do something with them.
     * May also be called from Admin Zone to get a default purchase ID (i.e. when there's no post context).
     *
     * @param  ID_TEXT $type_code The product codename
     * @param  boolean $from_admin Whether this is being called from the Admin Zone. If so, optionally different fields may be used, including a purchase_id field for direct purchase ID input.
     * @return array A pair: The purchase ID, a confirmation box to show (null for no specific confirmation)
     */
    public function handle_needed_fields($type_code, $from_admin = false)
    {
        require_lang('cns');

        $member_id = get_member();

        $topic_id = post_param_integer('select_topic_id', null);
        if ($topic_id === null) {
            $_topic_id = post_param_string('manual_topic_id', $from_admin ? '' : false);

            if ($_topic_id == '') {
                return array('', null); // Default is blank
            }

            $topic_id = intval($_topic_id);
        }

        if (get_forum_type() == 'cns') {
            $currently_pinned = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_topics', 't_pinned', array('id' => $topic_id));
            if ($currently_pinned === null) {
                warn_exit(do_lang_tempcode('MISSING_RESOURCE', 'topic'));
            }
            if ($currently_pinned == 1) {
                warn_exit(do_lang_tempcode('TOPIC_PINNED_ALREADY'));
            }
        }

        return array(json_encode(array($member_id, $topic_id)), null);
    }

    /**
     * Handling of a product purchase change state.
     *
     * @param  ID_TEXT $type_code The product codename
     * @param  ID_TEXT $purchase_id The purchase ID
     * @param  array $details Details of the product, with added keys: TXN_ID, STATUS, ORDER_STATUS
     * @return boolean Whether the product was automatically dispatched (if not then hopefully this function sent a staff notification)
     */
    public function actualiser($type_code, $purchase_id, $details)
    {
        if ($details['STATUS'] != 'Completed') {
            return false;
        }

        require_lang('cns');

        $days = intval(preg_replace('#^TOPIC_PIN__#', '', $type_code));

        list($member_id, $topic_id) = json_decode($purchase_id);

        if (get_forum_type() == 'cns') {
            $topic_title = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_topics', 't_cache_first_title', array('id' => $topic_id));
            if ($topic_title === null) {
                warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
            }
        } else {
            $topic_title = strval($topic_id);
        }

        $GLOBALS['FORUM_DRIVER']->pin_topic($topic_id);

        $GLOBALS['SITE_DB']->query_insert('ecom_sales', array('date_and_time' => time(), 'member_id' => $member_id, 'details' => do_lang('PIN_SPECIFIC_TOPIC', $topic_title, null, null, get_site_default_lang()), 'details2' => strval($days), 'txn_id' => $details['TXN_ID']));

        return true;
    }

    /**
     * Get the member who made the purchase.
     *
     * @param  ID_TEXT $type_code The product codename
     * @param  ID_TEXT $purchase_id The purchase ID
     * @return ?MEMBER The member ID (null: none)
     */
    public function member_for($type_code, $purchase_id)
    {
        list($member_id) = json_decode($purchase_id);
        return $member_id;
    }
}

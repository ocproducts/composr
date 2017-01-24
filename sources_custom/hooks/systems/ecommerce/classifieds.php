<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    classified_ads
 */

/**
 * Hook class.
 */
class Hook_ecommerce_classifieds
{
    /**
     * Get the overall categorisation for the products handled by this eCommerce hook.
     *
     * @return ?array A map of product categorisation details (null: disabled).
     */
    public function get_product_category()
    {
        require_lang('classifieds');

        return array(
            'category_name' => do_lang('CLASSIFIEDS'),
            'category_description' => do_lang_tempcode('CLASSIFIED_ADVERT_BUY_DESCRIPTION'),
            'category_image_url' => find_theme_image('icons/48x48/menu/rich_content/catalogues/classifieds'),
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
        if (!$GLOBALS['SITE_DB']->table_exists('ecom_classifieds_prices')) {
            return array();
        }

        require_lang('classifieds');

        $num_products_for_sale = $GLOBALS['SITE_DB']->query_select_value('catalogue_entries e JOIN ' . get_table_prefix() . 'ecom_classifieds_prices c ON c.c_catalogue_name=e.c_name', 'COUNT(*)');
        if ($num_products_for_sale == 0) {
            return array();
        }

        $prices = $GLOBALS['SITE_DB']->query_select('ecom_classifieds_prices', array('id', 'c_label', 'c_price'), null, 'ORDER BY c_price');

        $products = array();
        foreach ($prices as $price) {
            if ($price['c_price'] != 0.0) {
                $products['CLASSIFIEDS_ADVERT_' . strval($price['id'])] = automatic_discount_calculation(array(
                    'item_name' => do_lang('CLASSIFIED_ADVERT_BUY', get_translated_text($price['c_label']), null, null, $site_lang ? get_site_default_lang() : user_lang()),
                    'item_description' => new Tempcode(),
                    'item_image_url' => '',

                    'type' => PRODUCT_PURCHASE,
                    'type_special_details' => array(),

                    'price' => float_to_raw_string($price['c_price']),
                    'currency' => get_option('currency'),
                    'price_points' => null,
                    'discount_points__num_points' => null,
                    'discount_points__price_reduction' => null,

                    'needs_shipping_address' => false,
                ));
            }
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
        $purchase_id = get_param_string('id', null);

        if ($purchase_id == null) {
            return ECOMMERCE_PRODUCT_DISABLED; // Can't do from the 'choose' screen, must be linked from classifieds module
        } else {
            $entry_id = intval($purchase_id);
            $validated = $GLOBALS['SITE_DB']->query_select_value_if_there('catalogue_entries', 'ce_validated', array('id' => $entry_id));

            if ($validated === null) {
                return ECOMMERCE_PRODUCT_MISSING;
            }

            if ($validated == 1) {
                return ECOMMERCE_PRODUCT_ALREADY_HAS;
            }
        }

        return ECOMMERCE_PRODUCT_AVAILABLE;
    }

    /**
     * Function for administrators to pick an identifier (only used by admins, usually the identifier would be picked via some other means in the wider Composr codebase).
     *
     * @param  ID_TEXT $type_code Product codename.
     * @return ?Tempcode Input field in standard Tempcode format for fields (null: no identifier).
     */
    public function get_identifier_manual_field_inputter($type_code)
    {
        require_lang('classifieds');
        require_code('catalogues');

        $list = new Tempcode();
        $rows = $GLOBALS['SITE_DB']->query_select('catalogue_entries e JOIN ' . get_table_prefix() . 'ecom_classifieds_prices c ON c.c_catalogue_name=e.c_name', array('e.*'), null, 'GROUP BY e.id ORDER BY ce_add_date DESC');
        foreach ($rows as $row) {
            $data_map = get_catalogue_entry_map($row, null, 'CATEGORY', 'DEFAULT', null, null, array(0));
            $ad_title = $data_map['FIELD_0'];

            $username = $GLOBALS['FORUM_DRIVER']->get_username($row['ce_submitter']);
            if ($username === null) {
                $username = do_lang('UNKNOWN');
            }
            $list->attach(form_input_list_entry(strval($row['id']), get_param_integer('id', null) === $row['id'], do_lang('CLASSIFIED_OF', strval($row['id']), $username, $ad_title)));
        }
        return form_input_list(do_lang_tempcode('ENTRY'), '', 'purchase_id', $list);
    }

    /**
     * Get the filled in fields and do something with them.
     *
     * @param  ID_TEXT $type_code The product codename.
     * @return array A pair: The purchase ID, a confirmation box to show (null for no specific confirmation).
     */
    public function handle_needed_fields($type_code)
    {
        $entry_id = get_param_integer('id', null); // The catalogue entry being paid for
        if ($entry_id === null) {
            warn_exit(do_lang_tempcode('MISSING_RESOURCE')); // Can't do from the 'choose' screen, must be linked from classifieds module
        }

        $matches = array();
        if (preg_match('#^CLASSIFIEDS\_ADVERT\_(\d+)$#', $type_code, $matches) != 0) {
            $entry_catalogue_name = $GLOBALS['SITE_DB']->query_select_value_if_there('catalogue_entries', 'c_name', array('id' => $entry_id));
            if ($entry_catalogue_name === null) {
                warn_exit(do_lang_tempcode('MISSING_RESOURCE'));
            }

            // Check this is a valid purchase for the product
            $classified_price_catalogue_name = $GLOBALS['SITE_DB']->query_select_value_if_there('ecom_classifieds_prices', 'c_catalogue_name', array('id' => intval($matches[1])));
            if ($classified_price_catalogue_name != $entry_catalogue_name) {
                warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
            }
        } else { // Bizarre if this happened
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }

        return array(strval($entry_id), null);
    }

    /**
     * Handling of a product purchase change state.
     *
     * @param  ID_TEXT $type_code The product codename.
     * @param  ID_TEXT $purchase_id The purchase ID.
     * @param  array $details Details of the product, with added keys: TXN_ID, PAYMENT_STATUS, ORDER_STATUS.
     */
    public function actualiser($type_code, $purchase_id, $details)
    {
        if ($details['PAYMENT_STATUS'] != 'Completed') {
            return;
        }

        $classified_type_id = intval(preg_replace('#^CLASSIFIEDS\_ADVERT\_#', '', $type_code));

        $entry_id = intval($purchase_id);

        $member_id = $GLOBALS['SITE_DB']->query_select_value_if_there('catalogue_entries', 'ce_submitter', array('id' => $entry_id));

        $days = $GLOBALS['SITE_DB']->query_select_value_if_there('ecom_classifieds_prices', 'c_days', array('id' => $classified_type_id));

        // Make validated, bump up timer
        $time = $GLOBALS['SITE_DB']->query_select_value_if_there('catalogue_entries', 'ce_last_moved', array('id' => $entry_id));
        if ($time !== null) {
            $time += $days * 60 * 60 * 24;
            $GLOBALS['SITE_DB']->query_update('catalogue_entries', array('ce_validated' => 1, 'ce_last_moved' => $time), array('id' => $entry_id), '', 1);
            decache('main_cc_embed');
            decache('main_recent_cc_entries');
            require_code('catalogues2');
            $cc_id = $GLOBALS['SITE_DB']->query_select_value_if_there('catalogue_entries', 'cc_id', array('id' => $entry_id));
            calculate_category_child_count_cache($cc_id);
        }

        $GLOBALS['SITE_DB']->query_insert('ecom_sales', array('date_and_time' => time(), 'member_id' => $member_id, 'details' => $details['item_name'], 'details2' => strval($entry_id), 'transaction_id' => $details['TXN_ID']));
    }

    /**
     * Get the member who made the purchase.
     *
     * @param  ID_TEXT $type_code The product codename.
     * @param  ID_TEXT $purchase_id The purchase ID.
     * @return ?MEMBER The member ID (null: none).
     */
    public function member_for($type_code, $purchase_id)
    {
        $entry_id = intval($purchase_id);
        return $GLOBALS['SITE_DB']->query_select_value_if_there('catalogue_entries', 'ce_submitter', array('id' => $entry_id));
    }
}

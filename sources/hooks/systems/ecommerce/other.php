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
class Hook_ecommerce_other
{
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
        $products = array(
            'OTHER' => array(
                'item_name' => do_lang('ecommerce:CUSTOM_PRODUCT_OTHER', null, null, null, $site_lang ? get_site_default_lang() : user_lang()),
                'item_description' => new Tempcode(),
                'item_image_url' => '',

                'type' => PRODUCT_OTHER,
                'type_special_details' => array(),

                'price' => null,
                'currency' => get_option('currency'),
                'price_points' => null,
                'discount_points__num_points' => null,
                'discount_points__price_reduction' => null,

                'needs_shipping_address' => false,
            ),
        );
        return $products;
    }
}

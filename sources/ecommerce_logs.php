<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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

/*
We have:
 - Sales log (high-level log of sales, links to other logs; there's a version in the Admin Zone and also for members)
 - Order log (for shopping cart orders only; there's a version in the Admin Zone and also for members)
 - Transactions log (raw log, in Admin Zone only)

This file only contains the code for the sales log and code for viewing an individual order, the other code is not re-used so is coded directly into modules.
*/

/**
 * The UI to view sales logs.
 *
 * @param  ?MEMBER $filter_member_id Member to filter by (null: none)
 * @param  boolean $show_username Whether to show the username column
 * @param  boolean $show_delete Whether to show the deletion column
 * @param  integer $max_default Default maximum number of records to show
 * @return array A pair: The sales table, pagination
 */
function build_sales_table($filter_member_id, $show_username = false, $show_delete = false, $max_default = 20)
{
    require_code('templates_map_table');
    require_code('templates_results_table');
    require_code('templates_columned_table');
    require_code('content');
    require_code('ecommerce');

    $max = get_param_integer('max_ecommerce_logs', $max_default);
    $start = get_param_integer('start_ecommerce_logs', 0);

    $header_row = array();
    $header_row[] = do_lang_tempcode('TRANSACTION');
    if ($show_username) {
        $header_row[] = do_lang_tempcode('USERNAME');
    }
    $header_row[] = do_lang_tempcode('PRODUCT');
    $header_row[] = do_lang_tempcode('DETAILS');
    $header_row[] = do_lang_tempcode('OTHER_DETAILS');
    $header_row[] = do_lang_tempcode('DATE_TIME');
    if ($show_delete) {
        $header_row[] = do_lang_tempcode('ACTIONS');
    }
    $_header_row = columned_table_header_row($header_row);

    $where = array();
    if ($filter_member_id !== null) {
        $where['member_id'] = $filter_member_id;
    }

    $rows = $GLOBALS['SITE_DB']->query_select('ecom_sales s LEFT JOIN ' . get_table_prefix() . 'ecom_transactions t ON t.id=s.txn_id', array('*', 's.id AS s_id', 't.id AS t_id'), $where, 'ORDER BY date_and_time DESC', $max, $start);
    $max_rows = $GLOBALS['SITE_DB']->query_select_value('ecom_sales', 'COUNT(*)', $where);

    $sales_rows = array();
    foreach ($rows as $row) {
        $transaction_row = get_transaction_row($row['txn_id']);

        $transaction_linker = build_transaction_linker($row['txn_id'], $transaction_row['t_status'] != 'Completed', $transaction_row);

        if ($show_username) {
            $member_link = $GLOBALS['FORUM_DRIVER']->member_profile_hyperlink($row['member_id']);
        }

        list($details) = find_product_details($transaction_row['t_type_code']);
        if ($details !== null) {
            $item_name = $details['item_name'];
        } else {
            $item_name = $transaction_row['t_type_code'];
        }

        $product_details_url = get_product_details_url($transaction_row['t_type_code'], true, $filter_member_id);
        $item_link = hyperlink($product_details_url, $item_name, false, true);

        if (strpos($item_name, $row['details']) === false) {
            $details_1 = $row['details'];
            if (strpos($item_name, $row['details2']) === false) {
                $details_2 = $row['details2'];
            } else {
                $details_2 = '';
            }
        } else {
            $details_1 = $row['details2'];
            $details_2 = '';
        }

        $date = get_timezoned_date_time($row['date_and_time']);

        if ($show_delete) {
            $url = build_url(array('page' => 'admin_ecommerce_logs', 'type' => 'delete_sales_log_entry', 'id' => $row['s_id']), get_module_zone('admin_ecommerce_logs'));
            $actions = do_template('COLUMNED_TABLE_ACTION', array(
                '_GUID' => '12e3ea365f1a1ed2e7800293f3203283',
                'NAME' => '#' . strval($row['s_id']),
                'URL' => $url,
                'CONFIRM' => true,
                'ACTION_TITLE' => do_lang_tempcode('DELETE'),
                'ICON' => 'admin/delete',
                'GET' => false,
            ));
        }

        $sales_row = array();
        $sales_row[] = protect_from_escaping($transaction_linker->evaluate());
        if ($show_username) {
            $sales_row[] = $member_link;
        }
        $sales_row[] = $item_link;
        $sales_row[] = $details_1;
        $sales_row[] = $details_2;
        $sales_row[] = $date;
        if ($show_delete) {
            $sales_row[] = $actions;
        }

        $sales_rows[] = $sales_row;
    }
    if (count($sales_rows) == 0) {
        inform_exit(do_lang_tempcode('NO_ENTRIES'));
    }

    $_sales_rows = new Tempcode();
    foreach ($sales_rows as $sales_row) {
        $_sales_rows->attach(columned_table_row($sales_row, true));
    }

    $sales_table = do_template('COLUMNED_TABLE', array('_GUID' => 'd87800ff26e9e5b8f7593fae971faa73', 'HEADER_ROW' => $_header_row, 'ROWS' => $_sales_rows));

    require_code('templates_pagination');
    $pagination = pagination(do_lang('ECOM_PRODUCTS_MANAGE_SALES'), $start, 'start_ecommerce_logs', $max, 'max_ecommerce_logs', $max_rows, false, 5, null, 'tab--ecommerce-logs');

    return array($sales_table, $pagination);
}

/**
 * The UI to view an order.
 *
 * @param  Tempcode $title The screen title
 * @param  AUTO_LINK $id The order ID
 * @param  Tempcode $text Text to include on the order
 * @param  boolean $show_order_actions Whether to show order actions
 * @return Tempcode The order details
 */
function build_order_details($title, $id, $text, $show_order_actions = false)
{
    require_code('locations');

    if (!addon_installed('shopping')) {
        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
    }

    $order_title = do_lang('CART_ORDER', strval($id));

    // Collecting order details
    $order_rows = $GLOBALS['SITE_DB']->query_select('shopping_orders', array('*'), array('id' => $id), '', 1);
    if (!array_key_exists(0, $order_rows)) {
        warn_exit(do_lang_tempcode('MISSING_RESOURCE'));
    }
    $order_row = $order_rows[0];

    $transaction_linker = build_transaction_linker($order_row['txn_id'], $order_row['order_status'] == 'ORDER_STATUS_awaiting_payment');

    $ordered_by_member_id = $order_row['member_id'];
    $ordered_by_username = $GLOBALS['FORUM_DRIVER']->get_username($order_row['member_id']);

    // Order actions...

    if ($show_order_actions) {
        $self_url = get_self_url(true, true);
        $order_actualise_url = build_url(array('page' => 'admin_shopping', 'type' => 'order_act', 'id' => $id, 'redirect' => protect_url_parameter($self_url)), get_module_zone('admin_shopping'));
        $order_actions = do_template('ECOM_ADMIN_ORDER_ACTIONS', array(
            '_GUID' => '6a24f6fb7c23f60b049ebce0f9765736',
            'ORDER_TITLE' => $order_title,
            'ORDER_ACTUALISE_URL' => $order_actualise_url,
            'ORDER_STATUS' => do_lang($order_row['order_status']),
        ));
    } else {
        $order_actions = new Tempcode();
    }

    // Shipping address display...

    $address_rows = $GLOBALS['SITE_DB']->query_select('ecom_trans_addresses', array('*'), array('a_txn_id' => $order_row['txn_id']), '', 1);
    if (array_key_exists(0, $address_rows)) {
        require_lang('cns_special_cpf');

        $address = $address_rows[0];

        $address_parts = array(
            'name' => trim($address['a_firstname'] . ' ' . $address['a_lastname']),
            'street_address' => $address['a_street_address'],
            'city' => $address['a_city'],
            'county' => $address['a_county'],
            'state' => $address['a_state'],
            'post_code' => $address['a_post_code'],
            'country' => $address['a_country'],
            'email' => $address['a_email'],
            'phone' => $address['a_phone'],
        );

        $shipping_address = do_template('ECOM_SHIPPING_ADDRESS', array(
            '_GUID' => '332bc2e28a75cff64e6856bbeda6102e',
            'FIRSTNAME' => $address['a_firstname'],
            'LASTNAME' => $address['a_lastname'],
            'STREET_ADDRESS' => $address['a_street_address'],
            'CITY' => $address['a_city'],
            'COUNTY' => $address['a_county'],
            'STATE' => $address['a_state'],
            'POST_CODE' => $address['a_post_code'],
            'COUNTRY' => find_country_name_from_iso($address['a_country']),
            'EMAIL' => $address['a_email'],
            'PHONE' => $address['a_phone'],
            'FORMATTED_ADDRESS' => get_formatted_address($address_parts),
        ));
    } else {
        $shipping_address = new Tempcode();
    }

    // Show products in the order...

    require_code('templates_results_table');

    $header_row = results_header_row(array(
        do_lang_tempcode('SKU'),
        do_lang_tempcode('PRODUCT_NAME'),
        do_lang_tempcode('PURCHASE_ID'),
        do_lang_tempcode('PRICE'),
        do_lang_tempcode(get_option('tax_system')),
        do_lang_tempcode('QUANTITY'),
        do_lang_tempcode('DISPATCH_STATUS'),
    ));

    $product_rows = $GLOBALS['SITE_DB']->query_select('shopping_order_details', array('*'), array('p_order_id' => $id), 'ORDER BY p_name');
    $product_entries = new Tempcode();
    foreach ($product_rows as $product_row) {
        $product_info_url = get_product_details_url($product_row['p_type_code'], false, $ordered_by_member_id);
        $product_name = $product_row['p_name'];
        $product = hyperlink($product_info_url, $product_name, false, true, do_lang('VIEW'));

        $product_entries->attach(results_entry(array(
            ($product_row['p_sku'] == '') ? do_lang_tempcode('NA_EM') : make_string_tempcode(escape_html($product_row['p_sku'])),
            $product,
            escape_html($product_row['p_purchase_id']),
            ecommerce_get_currency_symbol() . escape_html(float_format($product_row['p_price'])),
            ecommerce_get_currency_symbol() . escape_html(float_format($product_row['p_tax'])),
            escape_html(integer_format($product_row['p_quantity'])),
            do_lang($product_row['p_dispatch_status']),
        ), false, null));
    }
    $results_table = results_table(do_lang_tempcode('catalogues:DEFAULT_CATALOGUE_PRODUCTS_TITLE'), 0, 'start', count($product_rows), 'max', count($product_rows), $header_row, $product_entries);

    // Show screen...

    return do_template('ECOM_ORDER_DETAILS_SCREEN', array(
        '_GUID' => '3ae59a343288eb6aa67e3627b5ea7eda',
        'TITLE' => $title,
        'TEXT' => $text,
        'RESULTS_TABLE' => $results_table,
        'ORDER_NUMBER' => strval($id),
        'ADD_DATE' => get_timezoned_date_time($order_row['add_date']),
        'TOTAL_PRICE' => float_format($order_row['total_price']),
        'TOTAL_TAX' => float_format($order_row['total_tax']),
        'TOTAL_SHIPPING_COST' => float_format($order_row['total_shipping_cost']),
        'CURRENCY' => $order_row['order_currency'],
        'TRANSACTION_LINKER' => $transaction_linker,
        'ORDERED_BY_MEMBER_ID' => strval($ordered_by_member_id),
        'ORDERED_BY_USERNAME' => $ordered_by_username,
        'ORDER_STATUS' => do_lang($order_row['order_status']),
        'NOTES' => $order_row['notes'],
        'ORDER_ACTIONS' => $order_actions,
        'SHIPPING_ADDRESS' => $shipping_address,
    ));
}

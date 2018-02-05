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

/**
 * Hook class.
 */
class Hook_task_export_ecom_transactions
{
    /**
     * Run the task hook.
     *
     * @param  TIME $start_date Date from
     * @param  TIME $end_date Date to
     * @param  string $transaction_status Transaction status filter (blank: no filter)
     * @param  string $type_code Product filter (blank: no filter)
     * @return ?array A tuple of at least 2: Return mime-type, content (either Tempcode, or a string, or a filename and file-path pair to a temporary file), map of HTTP headers if transferring immediately, map of ini_set commands if transferring immediately (null: show standard success message)
     */
    public function run($start_date, $end_date, $transaction_status, $type_code)
    {
        $filename = 'transactions_' . (($transaction_status == '') ? '' : ($transaction_status . '__')) . (($type_code == '') ? '' : ($type_code . '__')) . date('Y-m-d', $start_date) . '--' . date('Y-m-d', $end_date) . '.csv';

        require_code('ecommerce');

        $where = 't_time BETWEEN ' . strval($start_date) . ' AND ' . strval($end_date);
        if ($transaction_status != '') {
            $where .= ' AND ' . db_string_equal_to('t_status', $transaction_status);
        }
        if ($type_code != '') {
            $where .= ' AND ' . db_string_equal_to('t_type_code', $type_code);
        }

        $data = array();

        $query = 'SELECT t.*,t.id AS t_id,a.*
            FROM ' . get_table_prefix() . 'ecom_transactions t
            LEFT JOIN ' . get_table_prefix() . 'ecom_trans_addresses a ON t.id=a.a_txn_id
            WHERE ' . $where . '
            ORDER BY t_time';
        $rows = $GLOBALS['SITE_DB']->query($query);
        remove_duplicate_rows($rows);

        $tax_categories = array();
        foreach ($rows as $_transaction) {
            $tax_derivation = ($_transaction['t_tax_derivation'] == '') ? array() : json_decode($_transaction['t_tax_derivation'], true);
            foreach (array_keys($tax_derivation) as $tax_category) {
                $tax_categories[$tax_category] = true;
            }
        }
        $tax_categories = array_keys($tax_categories);

        foreach ($rows as $i => $_transaction) {
            task_log($this, 'Processing transaction row', $i, count($rows));

            list($details, $product_object) = find_product_details($_transaction['t_type_code']);
            if ($details !== null) {
                $item_name = $details['item_name'];
            } else {
                $item_name = $_transaction['t_type_code'];
            }

            $transaction = array();

            $transaction[do_lang('TRANSACTION')] = $_transaction['t_id'];

            $transaction[do_lang('PARENT')] = $_transaction['t_parent_txn_id'];

            $transaction[do_lang('PURCHASE_ID')] = $_transaction['t_purchase_id'];

            $transaction[do_lang('DATE')] = get_timezoned_date_time($_transaction['t_time']);

            $transaction[do_lang('CURRENCY')] = $_transaction['t_currency'];

            $transaction[do_lang('AMOUNT')] = float_format($_transaction['t_amount']);

            $transaction[do_lang(get_option('tax_system')) . ' (' . do_lang('COUNT_TOTAL') . ')'] = float_format($_transaction['t_tax']);
            $tax_derivation = ($_transaction['t_tax_derivation'] == '') ? array() : json_decode($_transaction['t_tax_derivation'], true);
            foreach ($tax_categories as $tax_category) {
                $transaction[do_lang(get_option('tax_system')) . ' (' . $tax_category . ')'] = float_format(isset($tax_derivation[$tax_category]) ? $tax_derivation[$tax_category] : 0.00);
            }

            $transaction[do_lang('PRODUCT')] = $item_name;

            $transaction[do_lang('STATUS')] = get_transaction_status_string($_transaction['t_status']);

            $transaction[do_lang('REASON')] = trim($_transaction['t_reason'] . '; ' . $_transaction['t_pending_reason'], '; ');

            $transaction[do_lang('NOTES')] = $_transaction['t_memo'];

            $transaction[do_lang('PAYMENT_GATEWAY')] = $_transaction['t_payment_gateway'];

            $transaction[do_lang('OTHER_DETAILS')] = $_transaction['t_invoicing_breakdown'];

            $member_id = null;
            if ($product_object !== null) {
                $member_id = method_exists($product_object, 'member_for') ? $product_object->member_for($_transaction['t_type_code'], $_transaction['t_purchase_id']) : null;
            }
            if ($member_id !== null) {
                $username = $GLOBALS['FORUM_DRIVER']->get_username($member_id);
            } else {
                $username = do_lang('UNKNOWN');
            }
            $transaction[do_lang('MEMBER')] = $username;

            // Put address together
            $address = array();
            if ($_transaction['a_firstname'] . $_transaction['a_lastname'] != '') {
                $address[] = trim($_transaction['a_firstname'] . ' ' . $_transaction['a_lastname']);
            }
            if ($_transaction['a_street_address'] != '') {
                $address[] = $_transaction['a_street_address'];
            }
            if ($_transaction['a_city'] != '') {
                $address[] = $_transaction['a_city'];
            }
            if ($_transaction['a_county'] != '') {
                $address[] = $_transaction['a_county'];
            }
            if ($_transaction['a_state'] != '') {
                $address[] = $_transaction['a_state'];
            }
            if ($_transaction['a_post_code'] != '') {
                $address[] = $_transaction['a_post_code'];
            }
            if ($_transaction['a_country'] != '') {
                $address[] = $_transaction['a_country'];
            }
            if ($_transaction['a_email'] != '') {
                $address[] = do_lang('EMAIL_ADDRESS') . ': ' . $_transaction['a_email'];
            }
            if ($_transaction['a_phone'] != '') {
                $address[] = do_lang('PHONE_NUMBER') . ': ' . $_transaction['a_phone'];
            }
            $full_address = implode("\n", $address);
            $transaction[do_lang('ADDRESS')] = $full_address;

            $data[] = $transaction;
        }

        $headers = array();
        $headers['Content-type'] = 'text/csv';
        $headers['Content-Disposition'] = 'attachment; filename="' . escape_header($filename) . '"';

        $ini_set = array();
        $ini_set['ocproducts.xss_detect'] = '0';

        require_code('files2');
        $outfile_path = cms_tempnam();
        make_csv($data, $filename, false, false, $outfile_path);
        return array('text/csv', array($filename, $outfile_path), $headers, $ini_set);
    }
}

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

require_code('crud_module');

/**
 * Module page class.
 */
class Module_admin_ecommerce_logs
{
    /**
     * Find details of the module.
     *
     * @return ?array Map of module info (null: module is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 1;
        $info['locked'] = false;
        return $info;
    }

    /**
     * Find entry-points available within this module.
     *
     * @param  boolean $check_perms Whether to check permissions.
     * @param  ?MEMBER $member_id The member to check permissions as (null: current user).
     * @param  boolean $support_crosslinks Whether to allow cross links to other modules (identifiable via a full-page-link rather than a screen-name).
     * @param  boolean $be_deferential Whether to avoid any entry-point (or even return null to disable the page in the Sitemap) if we know another module, or page_group, is going to link to that entry-point. Note that "!" and "browse" entry points are automatically merged with container page nodes (likely called by page-groupings) as appropriate.
     * @return ?array A map of entry points (screen-name=>language-code/string or screen-name=>[language-code/string, icon-theme-image]) (null: disabled).
     */
    public function get_entry_points($check_perms = true, $member_id = null, $support_crosslinks = true, $be_deferential = false)
    {
        if (get_value('unofficial_ecommerce') !== '1') {
            if (get_forum_type() != 'cns') {
                return null;
            }
        }

        $ret = array(
            'browse' => array('ECOMMERCE', 'menu/adminzone/audit/ecommerce/ecommerce'),
            'trigger' => array('MANUAL_TRANSACTION', 'menu/rich_content/ecommerce/purchase'),
            'logs' => array('TRANSACTIONS', 'menu/adminzone/audit/ecommerce/transactions'),
            'profit_loss' => array('PROFIT_LOSS', 'menu/adminzone/audit/ecommerce/profit_loss'),
            'cash_flow' => array('CASH_FLOW', 'menu/adminzone/audit/ecommerce/cash_flow'),
            'view_manual_subscriptions' => array('MANUAL_SUBSCRIPTIONS', 'menu/adminzone/audit/ecommerce/subscriptions'),
        );

        if ($support_crosslinks) {
            $ret['_SEARCH:admin_invoices:browse'] = array('INVOICES', 'menu/adminzone/audit/ecommerce/invoices');
            if (addon_installed('shopping')) {
                require_lang('shopping');
                $ret['_SEARCH:admin_orders:browse'] = array('ORDERS', 'menu/adminzone/audit/ecommerce/orders');
            }
        }

        return $ret;
    }

    public $title;

    /**
     * Module pre-run function. Allows us to know metadata for <head> before we start streaming output.
     *
     * @return ?Tempcode Tempcode indicating some kind of exceptional output (null: none).
     */
    public function pre_run()
    {
        $type = get_param_string('type', 'browse');

        require_lang('ecommerce');
        require_css('ecommerce');

        if ($type == 'logs') {
            $this->title = get_screen_title('TRANSACTIONS');
        }

        if ($type != 'logs') {
            set_helper_panel_tutorial('tut_ecommerce');
        }

        if ($type == 'cash_flow') {
            breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('ECOMMERCE'))));
            breadcrumb_set_self(do_lang_tempcode('RESULT'));

            $this->title = get_screen_title('CASH_FLOW');
        }

        if ($type == 'profit_loss') {
            breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('ECOMMERCE'))));
            breadcrumb_set_self(do_lang_tempcode('RESULT'));

            $this->title = get_screen_title('PROFIT_LOSS');
        }

        if ($type == 'browse') {
            $this->title = get_screen_title('TRANSACTIONS');

            set_helper_panel_text(comcode_lang_string('DOC_ECOMMERCE'));
        }

        if ($type == 'trigger') {
            breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('ECOMMERCE'))));

            $this->title = get_screen_title('MANUAL_TRANSACTION');
        }

        if ($type == '_trigger') {
            breadcrumb_set_self(do_lang_tempcode('DONE'));
            $type_code = get_param_string('type_code', null);
            if ($type_code === null) {
                breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('ECOMMERCE')), array('_SELF:_SELF:trigger', do_lang_tempcode('PRODUCT'))));
            } else {
                breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('ECOMMERCE')), array('_SELF:_SELF:trigger', do_lang_tempcode('PRODUCT')), array('_SELF:_SELF:trigger:type_code=' . $type_code, do_lang_tempcode('MANUAL_TRANSACTION'))));
            }

            $this->title = get_screen_title('MANUAL_TRANSACTION');
        }

        if ($type == 'view_manual_subscriptions') {
            $this->title = get_screen_title('MANUAL_SUBSCRIPTIONS');
        }

        if ($type == 'cancel_subscription') {
            $this->title = get_screen_title('CANCEL_MANUAL_SUBSCRIPTION');
        }

        return null;
    }

    /**
     * Execute the module.
     *
     * @return Tempcode The result of execution.
     */
    public function run()
    {
        require_code('ecommerce');
        require_code('ecommerce2');

        if (get_value('unofficial_ecommerce') !== '1') {
            if (get_forum_type() != 'cns') {
                warn_exit(do_lang_tempcode('NO_CNS'));
            }
        }

        if (get_forum_type() == 'cns') {
            cns_require_all_forum_stuff();
        }

        $type = get_param_string('type', 'browse');

        if ($type == 'browse') {
            return $this->browse();
        }
        if ($type == 'logs') {
            return $this->logs();
        }
        if ($type == 'cash_flow') {
            return $this->cash_flow();
        }
        if ($type == 'profit_loss') {
            return $this->profit_loss();
        }
        //if ($type == 'balance_sheet') return $this->balance_sheet();
        if ($type == 'trigger') {
            return $this->trigger();
        }
        if ($type == '_trigger') {
            return $this->_trigger();
        }
        if ($type == 'view_manual_subscriptions') {
            return $this->view_manual_subscriptions();
        }
        if ($type == 'cancel_subscription') {
            return $this->cancel_subscription();
        }

        return new Tempcode();
    }

    /**
     * The do-next manager for before audit management.
     *
     * @return Tempcode The UI
     */
    public function browse()
    {
        require_code('templates_donext');
        return do_next_manager(
            $this->title,
            new Tempcode(),
            array(
                array('menu/adminzone/audit/ecommerce/cash_flow', array('_SELF', array('type' => 'cash_flow'), '_SELF'), do_lang('CASH_FLOW')),
                array('menu/adminzone/audit/ecommerce/profit_loss', array('_SELF', array('type' => 'profit_loss'), '_SELF'), do_lang('PROFIT_LOSS')),
                array('menu/rich_content/ecommerce/purchase', array('_SELF', array('type' => 'trigger'), '_SELF'), do_lang('MANUAL_TRANSACTION')),
                array('menu/adminzone/audit/ecommerce/transactions', array('_SELF', array('type' => 'logs'), '_SELF'), do_lang('LOGS')),
                array('menu/adminzone/audit/ecommerce/invoices', array('admin_invoices', array('type' => 'browse'), get_module_zone('admin_invoices')), do_lang('INVOICES')),
                addon_installed('shopping') ? array('menu/adminzone/audit/ecommerce/orders', array('admin_orders', array('type' => 'browse'), get_module_zone('admin_orders')), do_lang('shopping:ORDERS')) : null,
                array('menu/adminzone/audit/ecommerce/subscriptions', array('_SELF', array('type' => 'view_manual_subscriptions'), '_SELF'), do_lang('MANUAL_SUBSCRIPTIONS')),
            ),
            do_lang('ECOMMERCE')
        );
    }

    /**
     * The UI to view all point transactions ordered by date.
     *
     * @return Tempcode The UI
     */
    public function logs()
    {
        $start = get_param_integer('start', 0);
        $max = get_param_integer('max', 50);
        $sortables = array('t_time' => do_lang_tempcode('DATE'), 't_amount' => do_lang_tempcode('AMOUNT'));
        $test = explode(' ', get_param_string('sort', 't_time DESC', INPUT_FILTER_GET_COMPLEX), 2);
        if (count($test) == 1) {
            $test[1] = 'DESC';
        }
        list($sortable, $sort_order) = $test;
        if (((strtoupper($sort_order) != 'ASC') && (strtoupper($sort_order) != 'DESC')) || (!array_key_exists($sortable, $sortables))) {
            log_hack_attack_and_exit('ORDERBY_HACK');
        }

        $where = array();
        $type_code = get_param_string('type_code', null);
        $id = get_param_string('id', null);
        if ($type_code !== null) {
            $where = array('t_type_code' => $type_code);
            if (($id !== null) && ($id != '')) {
                $where['t_purchase_id'] = $id;
            }
        }
        $max_rows = $GLOBALS['SITE_DB']->query_select_value('transactions', 'COUNT(*)', $where);
        $rows = $GLOBALS['SITE_DB']->query_select('transactions', array('*'), $where, 'ORDER BY ' . $sortable . ' ' . $sort_order, $max, $start);
        if (count($rows) == 0) {
            return inform_screen($this->title, do_lang_tempcode('NO_ENTRIES'));
        }
        $fields = new Tempcode();
        require_code('templates_results_table');
        $fields_title = results_field_title(array(
            do_lang('TRANSACTION'),
            do_lang('IDENTIFIER'),
            do_lang('LINKED_ID'),
            do_lang('DATE'),
            do_lang('AMOUNT'),
            do_lang('CURRENCY'),
            do_lang('PRODUCT'),
            do_lang('STATUS'),
            do_lang('REASON'),
            do_lang('PENDING_REASON'),
            do_lang('NOTES'),
            do_lang('MEMBER')
        ), $sortables, 'sort', $sortable . ' ' . $sort_order);
        foreach ($rows as $myrow) {
            $date = get_timezoned_date_time($myrow['t_time']);

            if ($myrow['t_status'] != 'Completed') {
                $trigger_url = build_url(array('page' => '_SELF', 'type' => 'trigger', 'type_code' => $myrow['t_type_code'], 'id' => $myrow['t_purchase_id']), '_SELF');
                $status = do_template('ECOM_TRANSACTION_LOGS_MANUAL_TRIGGER', array('_GUID' => '5e770b9b30db88032bcc56efe8e3dc23', 'STATUS' => $myrow['t_status'], 'TRIGGER_URL' => $trigger_url));
            } else {
                $status = protect_from_escaping(escape_html($myrow['t_status']));
            }

            // Find member link, if possible
            $member_id = null;
            $product_ob = find_product($myrow['t_type_code']);
            if ($product_ob !== null) {
                $member_id = method_exists($product_ob, 'member_for') ? $product_ob->member_for($myrow['t_purchase_id']) : null;
            }
            if ($member_id !== null) {
                $member_link = $GLOBALS['FORUM_DRIVER']->member_profile_hyperlink($member_id, '', false);
            } else {
                $member_link = do_lang_tempcode('UNKNOWN_EM');
            }

            $fields->attach(results_entry(array(
                $myrow['id'],
                $myrow['t_purchase_id'],
                $myrow['t_parent_txn_id'],
                $date,
                $myrow['t_amount'],
                $myrow['t_currency'],
                $myrow['t_type_code'],
                $status,
                $myrow['t_reason'],
                $myrow['t_pending_reason'],
                $myrow['t_memo'],
                $member_link
            ), true));
        }

        $results_table = results_table(do_lang('TRANSACTIONS'), $start, 'start', $max, 'max', $max_rows, $fields_title, $fields, $sortables, $sortable, $sort_order, 'sort');

        $post_url = build_url(array('page' => '_SELF', 'type' => 'logs'/*, 'start' => $start, 'max' => $max*/, 'sort' => $sortable . ' ' . $sort_order), '_SELF');

        $products = new Tempcode();
        $product_rows = $GLOBALS['SITE_DB']->query_select('transactions', array('DISTINCT t_type_code'), array(), 'ORDER BY t_type_code');
        foreach ($product_rows as $p) {
            $products->attach(form_input_list_entry($p['t_type_code']));
        }

        $tpl = do_template('ECOM_TRANSACTION_LOGS_SCREEN', array('_GUID' => 'a6ba07e4be36ecc85157511e3807df75', 'TITLE' => $this->title, 'PRODUCTS' => $products, 'URL' => $post_url, 'RESULTS_TABLE' => $results_table));

        require_code('templates_internalise_screen');
        return internalise_own_screen($tpl);
    }

    /**
     * The UI to take details on a manually triggered transaction.
     *
     * @return Tempcode The UI.
     */
    public function trigger()
    {
        require_code('form_templates');
        $fields = new Tempcode();

        url_default_parameters__enable();

        // Choose product
        $type_code = get_param_string('type_code', null);
        if ($type_code === null) {
            $products = find_all_products();
            $list = new Tempcode();
            foreach ($products as $type_code => $details) {
                if (!is_string($type_code)) {
                    $type_code = strval($type_code);
                }
                $label = $details[4];
                $label .= ' (' . escape_html($type_code);

                $currency = isset($details[5]) ? $details[5] : get_option('currency');

                if ($details[1] !== null) {
                    $label .= ', ' . escape_html(is_float($details[1]) ? float_to_raw_string($details[1], 2) : $details[1] . ' (' . $currency . ')');
                }
                $label .= ')';
                $list->attach(form_input_list_entry($type_code, do_lang('CUSTOM_PRODUCT_' . $type_code, null, null, null, null, false) === get_param_string('type_code', null), protect_from_escaping($label)));
            }
            $fields->attach(form_input_huge_list(do_lang_tempcode('PRODUCT'), '', 'type_code', $list, null, true));

            $submit_name = do_lang('CHOOSE');

            url_default_parameters__disable();

            return do_template('FORM_SCREEN', array('_GUID' => 'a2fe914c23e378c493f6e1dad0dc11eb', 'TITLE' => $this->title, 'SUBMIT_ICON' => 'buttons__proceed', 'SUBMIT_NAME' => $submit_name, 'FIELDS' => $fields, 'TEXT' => '', 'URL' => get_self_url(), 'GET' => true, 'HIDDEN' => ''));
        }

        $post_url = build_url(array('page' => '_SELF', 'type' => '_trigger', 'redirect' => get_param_string('redirect', null, INPUT_FILTER_URL_INTERNAL)), '_SELF');
        $text = do_lang('MANUAL_TRANSACTION_TEXT');
        $submit_name = do_lang('MANUAL_TRANSACTION');

        $product_ob = find_product($type_code);

        // To work out key
        if (post_param_integer('got_purchase_key_dependencies', 0) == 0) {
            $needed_fields = method_exists($product_ob, 'get_needed_fields') ? $product_ob->get_needed_fields($type_code) : null;
            if ($needed_fields !== null) { // Only do step if we actually have fields - create intermediary step. get_self_url ensures first product-choose step choice is propagated.
                $submit_name = do_lang('PROCEED');
                $extra_hidden = new Tempcode();
                $extra_hidden->attach(form_input_hidden('got_purchase_key_dependencies', '1'));
                if (is_array($needed_fields)) {
                    $extra_hidden->attach($needed_fields[0]);
                }

                url_default_parameters__disable();

                return do_template('FORM_SCREEN', array('_GUID' => '90ee397ac24dcf0b3a0176da9e9c9741', 'TITLE' => $this->title, 'SUBMIT_ICON' => 'buttons__proceed', 'SUBMIT_NAME' => $submit_name, 'FIELDS' => is_array($needed_fields) ? $needed_fields[1] : $needed_fields, 'TEXT' => '', 'URL' => get_self_url(), 'HIDDEN' => $extra_hidden));
            }
        }

        // Remaining fields, customised for product chosen
        if (method_exists($product_ob, 'get_identifier_manual_field_inputter')) {
            $f = $product_ob->get_identifier_manual_field_inputter($type_code);
            if ($f !== null) {
                $fields->attach($f);
            }
        } else {
            $default_purchase_id = get_param_string('id', null);
            if ($default_purchase_id === null) {
                if (method_exists($product_ob, 'set_needed_fields')) {
                    $default_purchase_id = $product_ob->set_needed_fields($type_code);
                } else {
                    $default_purchase_id = strval(get_member());
                }
            }

            $fields->attach(form_input_codename(do_lang_tempcode('IDENTIFIER'), do_lang('MANUAL_TRANSACTION_IDENTIFIER'), 'purchase_id', $default_purchase_id, false));
        }
        $fields->attach(form_input_text(do_lang_tempcode('NOTES'), do_lang('TRANSACTION_NOTES'), 'memo', '', false));

        $products = $product_ob->get_products();
        if ($products[$type_code][0] == PRODUCT_SUBSCRIPTION) {
            $fields->attach(form_input_date(do_lang_tempcode('EXPIRY_DATE'), do_lang_tempcode('DESCRIPTION_CUSTOM_EXPIRY_DATE'), 'cexpiry', false, false, false));
        }

        $fields->attach(do_template('FORM_SCREEN_FIELD_SPACER', array('_GUID' => 'f4e52dff9353fb767afbe0be9808591c', 'SECTION_HIDDEN' => true, 'TITLE' => do_lang_tempcode('ADVANCED'))));
        $fields->attach(form_input_float(do_lang_tempcode('AMOUNT'), do_lang_tempcode('MONEY_AMOUNT_DESCRIPTION', ecommerce_get_currency_symbol()), 'amount', null, false));

        $hidden = new Tempcode();
        $hidden->attach(form_input_hidden('type_code', $type_code));

        url_default_parameters__disable();

        return do_template('FORM_SCREEN', array('_GUID' => '990d955cb14b6681685ec9e1d1448d9d', 'TITLE' => $this->title, 'SUBMIT_ICON' => 'menu__rich_content__ecommerce__purchase', 'SUBMIT_NAME' => $submit_name, 'FIELDS' => $fields, 'TEXT' => $text, 'URL' => $post_url, 'HIDDEN' => $hidden));
    }

    /**
     * The actualiser for a manually triggered transaction.
     *
     * @return Tempcode The result of execution.
     */
    public function _trigger()
    {
        $type_code = post_param_string('type_code');

        $purchase_id = post_param_string('purchase_id', '');
        $memo = post_param_string('memo');
        $mc_gross = post_param_string('amount', '');
        $custom_expiry = post_param_date('cexpiry');
        $mc_currency = get_option('currency');

        $product_object = find_product($type_code);
        $products = $product_object->get_products(true);
        if ($mc_gross == '') {
            $mc_gross = $products[$type_code][1];
            if (isset($products[$type_code][5])) {
                $mc_currency = $products[$type_code][5];
            }
        }
        $payment_status = 'Completed';
        $reason_code = '';
        $pending_reason = '';
        $txn_id = 'manual-' . substr(uniqid('', true), 0, 10);
        $parent_txn_id = '';

        $item_name = $products[$type_code][4];

        if ($products[$type_code][0] == PRODUCT_SUBSCRIPTION) {
            if (($purchase_id == '') || (post_param_string('username', '') != '')) {
                $member_id = get_member();
                $username = post_param_string('username', '');
                if ($username != '') {
                    $_member_id = $GLOBALS['FORUM_DRIVER']->get_member_from_username($username);
                    if ($_member_id !== null) {
                        $member_id = $_member_id;
                    }
                }

                $purchase_id = strval($GLOBALS['SITE_DB']->query_insert('subscriptions', array(
                    's_type_code' => $type_code,
                    's_member_id' => $member_id,
                    's_state' => 'new',
                    's_amount' => $products[$type_code][1],
                    's_purchase_id' => $purchase_id,
                    's_time' => time(),
                    's_auto_fund_source' => '',
                    's_auto_fund_key' => '',
                    's_payment_gateway' => 'manual',
                    's_length' => $products[$type_code][3]['length'],
                    's_length_units' => $products[$type_code][3]['length_units'],
                ), true));
            }

            $item_name = ''; // Flag for handle_confirmed_transaction to know it's a subscription

            if ($custom_expiry !== null) {
                $s_length = $products[$type_code][3]['length'];
                $s_length_units = $products[$type_code][3]['length_units']; // y-year, m-month, w-week, d-day
                $time_period_units = array('y' => 'year', 'm' => 'month', 'w' => 'week', 'd' => 'day');
                $new_s_time = strtotime('-' . strval($s_length) . ' ' . $time_period_units[$s_length_units], $custom_expiry);
                $GLOBALS['SITE_DB']->query_update('subscriptions', array('s_time' => $new_s_time), array('id' => $purchase_id));
            }
        } else {
            if ($purchase_id == '') {
                $member_id = get_member();
                $username = post_param_string('username', '');
                if ($username != '') {
                    $_member_id = $GLOBALS['FORUM_DRIVER']->get_member_from_username($username);
                    if ($_member_id !== null) {
                        $member_id = $_member_id;
                    }
                }

                $purchase_id = strval($member_id);
            }
        }

        handle_confirmed_transaction($purchase_id, $item_name, $payment_status, $reason_code, $pending_reason, $memo, $mc_gross, $mc_currency, $txn_id, $parent_txn_id, '', 'manual', null, false, true);

        $url = get_param_string('redirect', null, INPUT_FILTER_URL_INTERNAL);
        if ($url !== null) {
            return redirect_screen($this->title, $url, do_lang_tempcode('SUCCESS'));
        }

        return inform_screen($this->title, do_lang_tempcode('SUCCESS'));
    }

    /**
     * An interface for choosing between dates.
     *
     * @param  Tempcode $title The title to display.
     * @return Tempcode The result of execution.
     */
    public function _get_between($title)
    {
        require_code('form_templates');

        $fields = new Tempcode();
        $month_start = array(0, 0, intval(date('m')), 1, intval(date('Y')));
        $fields->attach(form_input_date(do_lang_tempcode('FROM'), '', 'from', true, false, false, $month_start, 10, intval(date('Y')) - 9));
        $fields->attach(form_input_date(do_lang_tempcode('TO'), '', 'to', true, false, false, time(), 10, intval(date('Y')) - 9));

        return do_template('FORM_SCREEN', array(
            '_GUID' => '92888622a3ed6b7edbd4d1e5e2b35986',
            'GET' => true,
            'SKIP_WEBSTANDARDS' => true,
            'TITLE' => $title,
            'FIELDS' => $fields,
            'TEXT' => '',
            'HIDDEN' => '',
            'URL' => get_self_url(false, false, array(), false, true),
            'SUBMIT_ICON' => 'buttons__proceed',
            'SUBMIT_NAME' => do_lang_tempcode('PROCEED'),
        ));
    }

    /**
     * Get transaction summaries.
     *
     * @param  TIME $from Start of time range
     * @param  TIME $to End of time range
     * @param  boolean $unpaid_invoices_count Whether to count unpaid invoices into this. This means any invoicing in transactions will be ignored, and instead invoicing will be read directly.
     * @return array A template-ready list of maps of summary for multiple transaction types.
     */
    public function get_types($from, $to, $unpaid_invoices_count = false)
    {
        $types = array(
            'OPENING' => array('TYPE' => do_lang_tempcode('OPENING_BALANCE'), 'AMOUNT' => 0.0, 'SPECIAL' => true),
            'INTEREST_PLUS' => array('TYPE' => do_lang_tempcode('M_INTEREST_PLUS'), 'AMOUNT' => 0.0, 'SPECIAL' => false),
        );
        $products = find_all_products();
        foreach ($products as $type_code => $details) {
            $types[$type_code] = array('TYPE' => $details[4], 'AMOUNT' => 0.0, 'SPECIAL' => false);
        }
        $types += array(
            'COST' => array('TYPE' => do_lang_tempcode('EXPENSES'), 'AMOUNT' => 0.0, 'SPECIAL' => false),
            'TRANS' => array('TYPE' => do_lang_tempcode('TRANSACTION_FEES'), 'AMOUNT' => 0.0, 'SPECIAL' => false),
            'WAGE' => array('TYPE' => do_lang_tempcode('WAGES'), 'AMOUNT' => 0.0, 'SPECIAL' => false),
            'INTEREST_MINUS' => array('TYPE' => do_lang_tempcode('M_INTEREST_MINUS'), 'AMOUNT' => 0.0, 'SPECIAL' => false),
            'TAX' => array('TYPE' => do_lang_tempcode('TAX_GENERAL'), 'AMOUNT' => 0.0, 'SPECIAL' => false),
            'CLOSING' => array('TYPE' => do_lang_tempcode('CLOSING_BALANCE'), 'AMOUNT' => 0.0, 'SPECIAL' => true),
            'PROFIT' => array('TYPE' => do_lang_tempcode('NET_PROFIT'), 'AMOUNT' => 0.0, 'SPECIAL' => true),
        );

        require_code('currency');

        $transactions = $GLOBALS['SITE_DB']->query('SELECT * FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'transactions WHERE t_time<' . strval($to) . ' AND ' . db_string_equal_to('t_status', 'Completed') . ' ORDER BY t_time');
        foreach ($transactions as $transaction) {
            if ($transaction['t_time'] > $from) {
                $types['TRANS']['AMOUNT'] += get_transaction_fee(floatval($transaction['t_amount']), $transaction['t_payment_gateway']);
            }

            if ($unpaid_invoices_count) {
                foreach ($products as $type_code => $details) {
                    if (($transaction['t_type_code'] == $type_code) && ($details[0] == PRODUCT_INVOICE)) {
                        continue 2;
                    }
                }
            }

            $type_code = $transaction['t_type_code'];

            $transaction['t_amount'] = currency_convert(floatval($transaction['t_amount']), $transaction['t_currency'], get_option('currency'));

            $types['CLOSING']['AMOUNT'] += floatval($transaction['t_amount']);

            if ($transaction['t_time'] < $from) {
                $types['OPENING']['AMOUNT'] += floatval($transaction['t_amount']) - get_transaction_fee($transaction['t_amount'], $transaction['t_payment_gateway']);
                continue;
            }

            if (($transaction['t_type_code'] == 'OTHER') && (floatval($transaction['t_amount']) < 0.0)) {
                $types['COST']['AMOUNT'] += floatval($transaction['t_amount']);
            } elseif ($transaction['t_type_code'] == 'TAX') {
                $types['TAX']['AMOUNT'] += floatval($transaction['t_amount']);
            } elseif ($transaction['t_type_code'] == 'INTEREST') {
                $types[$type_code][(floatval($transaction['t_amount']) < 0.0) ? 'INTEREST_MINUS' : 'INTEREST_PLUS']['AMOUNT'] += floatval($transaction['t_amount']);
            } elseif ($transaction['t_type_code'] == 'WAGE') {
                $types['WAGE']['AMOUNT'] += floatval($transaction['t_amount']);
            } else {
                if (!array_key_exists($type_code, $types)) {
                    $types[$type_code] = array('TYPE' => $type_code, 'AMOUNT' => 0.0, 'SPECIAL' => false); // In case product no longer exists
                }
                $types[$type_code]['AMOUNT'] += floatval($transaction['t_amount']);
            }
        }

        if ($unpaid_invoices_count) {
            $invoices = $GLOBALS['SITE_DB']->query('SELECT * FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'invoices WHERE ' . db_string_equal_to('i_state', 'new') . ' AND i_time<' . strval($to) . ' ORDER BY i_time');
            foreach ($invoices as $invoice) {
                $type_code = $invoice['i_type_code'];

                $types['CLOSING']['AMOUNT'] += intval($invoice['i_amount']);

                if ($invoice['i_time'] < $from) {
                    $types['OPENING']['AMOUNT'] += intval($invoice['i_amount']);
                    continue;
                }

                $types[$type_code]['AMOUNT'] += intval($invoice['i_amount']);
            }
        }

        // $types['PROFIT_GROSS'] is not calculated
        $types['PROFIT']['AMOUNT'] = $types['CLOSING']['AMOUNT'] - $types['OPENING']['AMOUNT'] + $types['TAX']['AMOUNT'];
        // $types['PROFIT_NET_TAXED'] is not calculated

        foreach ($types as $item => $details) {
            $types[$item]['AMOUNT'] = float_to_raw_string($types[$item]['AMOUNT']);
        }

        foreach ($types as $i => $t) {
            if (is_float($t['AMOUNT'])) {
                $types[$i]['AMOUNT'] = float_to_raw_string($t['AMOUNT']);
            } elseif (is_integer($t['AMOUNT'])) {
                $types[$i]['AMOUNT'] = strval($t['AMOUNT']);
            }
        }

        return $types;
    }

    /**
     * Show a cash flow diagram.
     *
     * @return Tempcode The result of execution.
     */
    public function cash_flow()
    {
        $d = array(post_param_date('from', true), post_param_date('to', true));
        if ($d[0] === null) {
            return $this->_get_between($this->title);
        }
        list($from, $to) = $d;

        $types = $this->get_types($from, $to);
        unset($types['PROFIT']);

        return do_template('ECOM_CASH_FLOW_SCREEN', array('_GUID' => 'a042e16418417f46c24818890679f38a', 'TITLE' => $this->title, 'TYPES' => $types));
    }

    /**
     * Show a profit/loss account.
     *
     * @return Tempcode The result of execution.
     */
    public function profit_loss()
    {
        $d = array(post_param_date('from', true), post_param_date('to', true));
        if ($d[0] === null) {
            return $this->_get_between($this->title);
        }
        list($from, $to) = $d;

        $types = $this->get_types($from, $to, true);
        unset($types['OPENING']);
        unset($types['CLOSING']);

        return do_template('ECOM_CASH_FLOW_SCREEN', array('_GUID' => '255681ec95e90e36e085d14cf984b725', 'TITLE' => $this->title, 'TYPES' => $types));
    }

    /* *
     * Show a balance sheet. NOT REALLY FEASIBLE: REQUIRES HUMAN INTERPRETATION OF ASSETS, and recording of liabilities
     *
     * @return Tempcode The result of execution.
     */
    /*function balance_sheet()
    {
    }*/

    /**
     * Show manual subscriptions.
     *
     * @return Tempcode The result of execution.
     */
    public function view_manual_subscriptions()
    {
        disable_php_memory_limit();

        $where = array('s_payment_gateway' => 'manual');
        if (get_param_integer('all', 0) == 1) {
            $where = array();
        }

        $subscriptions = $GLOBALS['SITE_DB']->query_select('subscriptions', array('*'), $where, 'ORDER BY s_type_code,s_time', 10000/*reasonable limit*/);
        if (count($subscriptions) == 0) {
            inform_exit(do_lang_tempcode('NO_ENTRIES'));
        }

        $data = array();
        foreach ($subscriptions as $subs) {
            $product_obj = find_product($subs['s_type_code']);
            if ($product_obj === null) {
                continue;
            }

            $products = $product_obj->get_products(true);

            $item_name = $products[$subs['s_type_code']][4];
            $s_length = $products[$subs['s_type_code']][3]['length'];
            $s_length_units = $products[$subs['s_type_code']][3]['length_units']; // y-year, m-month, w-week, d-day
            $time_period_units = array('y' => 'year', 'm' => 'month', 'w' => 'week', 'd' => 'day');
            $expiry_time = strtotime('+' . strval($s_length) . ' ' . $time_period_units[$s_length_units], $subs['s_time']);
            $expiry_date = get_timezoned_date($expiry_time, false);
            $member_link = $GLOBALS['FORUM_DRIVER']->member_profile_hyperlink($subs['s_member_id'], '', false);
            if ($subs['s_state'] == 'cancelled') {
                $cancel_url = new Tempcode();
            } else {
                $cancel_url = build_url(array('page' => '_SELF', 'type' => 'cancel_subscription', 'subscription_id' => $subs['id']), '_SELF');
            }

            $data[$item_name][] = array($member_link, $expiry_date, $cancel_url, $subs['id']);
        }

        $result = new Tempcode();
        foreach ($data as $key => $value) {
            $continues_for_same_product = true;
            foreach ($value as $val) {
                if ($continues_for_same_product) {
                    $result->attach(do_template('ECOM_VIEW_MANUAL_TRANSACTIONS_LINE', array('_GUID' => '979a0e7ca87437bc7ee1035afd16e07c', 'ID' => strval($val[3]), 'SUBSCRIPTION' => $key, 'MEMBER' => $val[0], 'EXPIRY' => $val[1], 'ROWSPAN' => strval(count($data[$key])), 'CANCEL_URL' => $val[2])));
                    $continues_for_same_product = false;
                } else {
                    $result->attach(do_template('ECOM_VIEW_MANUAL_TRANSACTIONS_LINE', array('_GUID' => '4abea40b654471f0fec0961a1e8716e4', 'ID' => '', 'SUBSCRIPTION' => '', 'MEMBER' => $val[0], 'EXPIRY' => $val[1], 'ROWSPAN' => '', 'CANCEL_URL' => $val[2])));
                }
            }
        }

        return do_template('ECOM_VIEW_MANUAL_TRANSACTIONS_SCREEN', array('_GUID' => '35a782b45d391f7766303b05c9422305', 'TITLE' => $this->title, 'CONTENT' => $result));
    }

    /**
     * Cancel a manual subscription.
     *
     * @return Tempcode The result of execution.
     */
    public function cancel_subscription()
    {
        $id = get_param_integer('subscription_id');
        $subscription = $GLOBALS['SITE_DB']->query_select('subscriptions', array('s_type_code', 's_member_id'), array('id' => $id), '', 1);
        if (!array_key_exists(0, $subscription)) {
            warn_exit(do_lang_tempcode('MISSING_RESOURCE'));
        }

        $product_obj = find_product($subscription[0]['s_type_code']);
        $products = $product_obj->get_products(true);
        $item_name = $products[$subscription[0]['s_type_code']][4];
        $username = $GLOBALS['FORUM_DRIVER']->get_username($subscription[0]['s_member_id']);

        $repost_id = post_param_integer('id', null);
        if (($repost_id !== null) && ($repost_id == $id)) {
            require_code('ecommerce');
            handle_confirmed_transaction(strval($id), '', 'SCancelled', '', '', '', '', '', '', '', '', 'manual', null, false, true); // Runs a cancel
            return inform_screen($this->title, do_lang_tempcode('SUCCESS'));
        }

        // We need to get confirmation via POST, for security/confirmation reasons
        $preview = do_lang_tempcode('CANCEL_MANUAL_SUBSCRIPTION_CONFIRM', escape_html($item_name), escape_html($username));
        $fields = form_input_hidden('id', strval($id));
        $map = array('page' => '_SELF', 'type' => get_param_string('type'), 'subscription_id' => $id);
        $url = build_url($map, '_SELF');
        return do_template('CONFIRM_SCREEN', array('_GUID' => '3b76b0e41541d5a38671134e92128d9f', 'TITLE' => $this->title, 'FIELDS' => $fields, 'URL' => $url, 'PREVIEW' => $preview));
    }
}

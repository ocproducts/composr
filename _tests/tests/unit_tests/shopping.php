<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/**
 * Composr test case class (unit testing).
 */
class shopping_test_set extends cms_test_case
{
    public $category_id;
    public $access_mapping;
    public $cms_cat;
    public $shopping_cart;
    public $product_id;

    public function setUp()
    {
        parent::setUp();

        require_code('ecommerce');
        require_code('catalogues');
        require_code('catalogues2');
        require_code('shopping');
        require_lang('catalogues');
        require_lang('shopping');
        require_lang('ecommerce');

        if ($GLOBALS['SITE_DB']->query_select_value_if_there('catalogues', 'c_name', array('c_name' => 'storetesting' . strval(get_member()))) !== null) {
            actual_delete_catalogue('storetesting' . strval(get_member()));
        }

        $this->access_mapping = array(db_get_first_id() => 4);
        // Creating cms catalogues object
        require_code('cms/pages/modules/cms_catalogues.php');
        $this->cms_cat = new Module_cms_catalogues();
        //Creating Shopping cart object
        require_code('site/pages/modules/shopping.php');
        $this->shopping_cart = new Module_shopping();

        $username = $GLOBALS['FORUM_DRIVER']->get_username(get_member());
        $c_name = 'storetesting' . strval(get_member());
        actual_add_catalogue($c_name, insert_lang('c_title', do_lang('DEFAULT_CATALOGUE_PRODUCTS_TITLE'), 2), '', 0, 1, '', 0, 1);
        $this->category_id = $GLOBALS['SITE_DB']->query_select_value('catalogue_categories', 'id', array('c_name' => $c_name));

        $fields = array(
            //    Name                     Description         Type          Defines order  Required  Visible  Searchable
            array('ECOM_CAT_product_title', 'DESCRIPTION_TITLE', 'short_trans', 1, 1, 1, 1),
            array('ECOM_CAT_sku', 'ECOM_CATD_sku', 'codename', 0, 1, 1, 1, 'RANDOM'),
            array('ECOM_CAT_price_pre_tax', 'ECOM_CATD_price_pre_tax', 'float', 0, 1, 1, 1),
            array('ECOM_CAT_stock_level', 'ECOM_CATD_stock_level', 'integer', 0, 0, 1, 0),
            array('ECOM_CAT_stock_level_warn_at', 'ECOM_CATD_stock_level_warn_at', 'integer', 0, 0, 0, 0),
            array('ECOM_CAT_stock_level_maintain', 'ECOM_CATD_stock_level_maintain', 'tick', 0, 1, 0, 0),
            array('ECOM_CAT_tax_type', 'ECOM_CATD_tax_type', 'list', 0, 1, 0, 0, "0%|5%|17.5%", 0),
            array('ECOM_CAT_image', 'ECOM_CATD_image', 'picture', 0, 0, 1, 1),
            array('ECOM_CAT_weight', 'ECOM_CATD_weight', 'float', 0, 1, 0, 0),
            array('ECOM_CAT_description', 'DESCRIPTION_DESCRIPTION', 'long_trans', 0, 1, 1, 1)
        );

        foreach ($fields as $i => $field) {
            actual_add_catalogue_field('storetesting' . strval(get_member()), // $c_name
                lang_code_to_default_content('cf_name', $field[0], false, 3), // $name
                lang_code_to_default_content('cf_description', $field[1], false, 3), // $description
                ($field[2] == 'tick') ? 'list' : $field[2], // $type
                $i, // $order
                $field[3], // $defines_order
                $field[5], // $visible
                $field[6], // $searchable
                array_key_exists(7, $field) ? $field[7] : '', // $default
                $field[4], // $required
                array_key_exists(5, $field) ? $field[5] : 0, // $put_in_category
                array_key_exists(5, $field) ? $field[5] : 0 // $put_in_search
            );
        }

        $catalogue_name = 'storetesting' . strval(get_member());

        //Set Sample post values

        $fields = $GLOBALS['SITE_DB']->query_select('catalogue_fields', array('*'), array('c_name' => $catalogue_name));

        foreach ($fields as $key => $val) {
            $type = $val['cf_type'];

            $id = $val['id'];

            switch ($type) {
                case 'integer':
                    $_POST['field_' . strval($id)] = '4';
                    break;
                case    'short_trans':
                    $_POST['field_' . strval($id)] = 'Test field value';
                    break;
                case    'long_trans':
                    $_POST['field_' . strval($id)] = 'Test field value';
                    break;
                case    'float':
                    $_POST['field_' . strval($id)] = '68.35';
                    break;
                case    'list':
                    if ($val['cf_order'] == 6) { //Order 6 is tax
                        $_POST['field_' . strval($id)] = 'Arizona=7.8%';
                    } elseif ($val['cf_order'] == 5) { //Order 5 yes keep stock "yes/no"
                        $_POST['field_' . strval($id)] = 'yes';
                    }
                    break;
            }
        }

        $map = $this->cms_cat->get_set_field_map($catalogue_name, get_member());

        $this->product_id = actual_add_catalogue_entry($this->category_id, 0, 'test note', 1, 1, 1, $map);
    }

    public function tearDown()
    {
        actual_delete_catalogue('storetesting' . strval(get_member()));
        parent::tearDown();
    }

    public function testAddtoCart()
    {
        $this->shopping_cart->empty_cart();
        $_POST['product_id'] = $this->product_id;
        $_GET['hook'] = 'catalogue_items';
        $this->shopping_cart->add_item_to_cart();
        $_GET['page'] = 'shopping';    // Static setting to indentify the module in payment form
        payment_form();
    }

    public function testHandleTransaction()
    {
        $purchase_id = $GLOBALS['SITE_DB']->query_select_value('shopping_order', 'max(id)', array());
        $item_name = 'Test field value';
        $payment_status = 'Completed';
        $reason_code = '';
        $pending_reason = 'bar';
        $memo = 'foo';
        $mc_gross = '68.35';
        $mc_currency = get_option('currency');
        $txn_id = '0';
        $parent_txn_id = '0';
        $period = '';
        $via = 'paypal';

        handle_confirmed_transaction($purchase_id, $item_name, $payment_status, $reason_code, $pending_reason, $memo, $mc_gross, $mc_currency, $txn_id, $parent_txn_id, $period, $via);
    }
}

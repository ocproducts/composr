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
class ecommerce_tax_test_set extends cms_test_case
{
    public function setUp()
    {
        require_code('ecommerce');
        require_code('config2');
    }

    public function testEUTax()
    {
        // This test will break if tax rates change, so correct it if that happens...

        $_POST['shipping_country'] = 'UK';
        list($tax_derivation, $tax, $tax_tracking, $shipping_tax) = calculate_tax_due(null, 'EU', 100.00);
        $this->assertTrue($tax == 20.0);

        $_POST['shipping_country'] = 'DE';
        list($tax_derivation, $tax, $tax_tracking, $shipping_tax) = calculate_tax_due(null, 'EU', 100.00);
        $this->assertTrue($tax == 19.0);
    }

    public function testUSTax()
    {
        // This test will break if tax rates change, so correct it if that happens...

        $_POST['shipping_street_address'] = '1444 S. Alameda Street';
        $_POST['shipping_city'] = 'Los Angeles';
        $_POST['shipping_county'] = 'CA';
        $_POST['shipping_state'] = 'CA';
        $_POST['shipping_country'] = 'US';
        $_POST['shipping_post_code'] = '90021';
        set_option('business_street_address', '1444 S. Alameda Street');
        set_option('business_city', 'Los Angeles');
        set_option('business_county', '');
        set_option('business_state', 'CA');
        set_option('business_country', 'US');
        set_option('business_post_code', '90021');
        list($tax_derivation, $tax, $tax_tracking, $shipping_tax) = calculate_tax_due(null, 'TIC:00000', 100.00);
        $this->assertTrue($tax == 20.0);

        $_POST['shipping_country'] = 'UK';
        list($tax_derivation, $tax, $tax_tracking, $shipping_tax) = calculate_tax_due(null, 'TIC:00000', 100.00);
        $this->assertTrue($tax == 0.0);
    }

    public function testFlatTax()
    {
        set_option('tax_country_regexp', '^.*$');
        $_POST['shipping_country'] = 'US';
        list($tax_derivation, $tax, $tax_tracking, $shipping_tax) = calculate_tax_due(null, float_to_raw_string(18.0), 100.00);
        $this->assertTrue($tax == 18.0);

        set_option('tax_country_regexp', '^(AT|BE|BG|HR|CY|CZ|DK|EE|FI|FR|DE|GR|HU|IE|IT|LV|LT|LU|MT|NL|PL|PT|RO|SK|SI|ES|SE|UK|AX)$'); // Europe only
        $_POST['shipping_country'] = 'US';
        list($tax_derivation, $tax, $tax_tracking, $shipping_tax) = calculate_tax_due(null, float_to_raw_string(18.0), 100.00);
        $this->assertTrue($tax == 0.0);
    }
}

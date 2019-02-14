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
class currency_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        require_code('currency');

        set_option('currency_api_key', '2785638fbe9e508caa02');
    }

    public function testTypesOk()
    {
        $test_a = currency_convert(10.00, 'USD', 'GBP');
        $test_b = currency_convert(10, 'USD', 'GBP');
        $this->assertTrue($test_a === $test_b); // Floats and integers should convert the same
    }

    public function testCurrencyViaAPI()
    {
        $test = currency_convert(10.00, 'USD', 'GBP');
        $this->assertTrue($test > 0.00);
        $this->assertTrue($test < 10.00); // GBP is worth more
    }
}

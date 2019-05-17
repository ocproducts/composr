<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/**
 * Composr test case class (unit testing).
 */
class weather_test_set extends cms_test_case
{
    public function testWeatherAPI()
    {
        require_code('blocks/side_weather');
        $block = new Block_side_weather();

        $woeid = $block->_get_woeid('Medina, Saudi Arabia');
        $this->assertTrue(is_integer($woeid));

        list(, , $result) = $block->_get_weather_data($woeid);
        $this->assertTrue($result !== null);

        $woeid = $block->_get_woeid('Foobarxxx');
        $this->assertTrue($woeid === null);
    }
}

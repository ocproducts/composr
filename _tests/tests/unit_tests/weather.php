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
        set_option('openweathermap_api_key', 'def011d7920f3a719b6e6154ec42271d'); // Do not use this on a live site!

        require_code('weather');

        $errormsg = '';
        $result = weather_lookup(null, 24.466667, 39.6, 'metric', $errormsg);
        $this->assertTrue(($result !== null) && (array_key_exists('list', $result[0])) && (array_key_exists(0, $result[0]['list'])) && ($result[0]['city']['name'] == 'Medina'), 'Failed to lookup weather forecast by GPS; ' . $errormsg);
        $this->assertTrue(($result !== null) && (array_key_exists('weather', $result[1])) && ($result[1]['name'] == 'Medina'), 'Failed to lookup weather conditions by GPS; ' . $errormsg);

        $errormsg = '';
        $result = weather_lookup('Medina', null, null, 'metric', $errormsg);
        $this->assertTrue(($result !== null) && (array_key_exists('list', $result[0])) && (array_key_exists(0, $result[0]['list'])) && ($result[0]['city']['name'] == 'Medina'), 'Failed to lookup weather forecast by location string; ' . $errormsg);
        $this->assertTrue(($result !== null) && (array_key_exists('weather', $result[1])) && ($result[1]['name'] == 'Medina'), 'Failed to lookup weather conditions by location string; ' . $errormsg);
    }
}

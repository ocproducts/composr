<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

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
class ssl_test_set extends cms_test_case
{
    public function testHTTPSStatus()
    {
        if (strpos(get_base_url(), 'https://') === 0) {
            $this->assertTrue(false, 'Test can only run on HTTP site');
            return;
        }

        global $HTTPS_PAGES_CACHE;

        set_value('disable_ssl_for__' . $_SERVER['HTTP_HOST'], '1');

        $GLOBALS['SITE_DB']->query_insert('https_pages', array('https_page_name' => ':login'), false, true/*in case previous test didn't finish*/);
        $HTTPS_PAGES_CACHE = array();
        $url = build_url(array('page' => 'login'), get_module_zone('login'));
        $contents = http_get_contents($url->evaluate());
        $this->assertTrue(strpos($contents, 'src="http://') === false);

        $GLOBALS['SITE_DB']->query_delete('https_pages', array('https_page_name' => ':login'));
        $HTTPS_PAGES_CACHE = array();
        $url = build_url(array('page' => 'login'), get_module_zone('login'));
        $contents = http_get_contents($url->evaluate());
        $this->assertTrue(strpos($contents, 'src="https://') === false);

        set_value('disable_ssl_for__' . $_SERVER['HTTP_HOST'], '0');
    }
}

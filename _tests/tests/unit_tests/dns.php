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
class dns_test_set extends cms_test_case
{
    public function testGetHostByAddr()
    {
        set_value('slow_php_dns', '1');
        $this->assertTrue(cms_gethostbyaddr('8.8.8.8') == 'google-public-dns-a.google.com');

        set_value('slow_php_dns', '0');
        $this->assertTrue(cms_gethostbyaddr('8.8.8.8') == 'google-public-dns-a.google.com');
    }

    public function testGetHostByName()
    {
        set_value('slow_php_dns', '1');
        $this->assertTrue(cms_gethostbyname('google-public-dns-a.google.com') == '8.8.8.8');

        set_value('slow_php_dns', '0');
        $this->assertTrue(cms_gethostbyname('google-public-dns-a.google.com') == '8.8.8.8');
    }
}

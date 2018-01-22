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
class search_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        $this->establish_admin_session();

        require_code('xml');
    }

    public function testOpenSearch()
    {
        $url = find_script('opensearch');
        $data = http_download_file($url, null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $parsed = new CMS_simple_xml_reader($data);
        global $HTTP_DOWNLOAD_MIME_TYPE;
        $this->assertTrue(strpos($HTTP_DOWNLOAD_MIME_TYPE, 'text/xml') !== false);

        $url = find_script('opensearch') . '?type=suggest&request=abc';
        $data = http_download_file($url, null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(is_array(json_decode($data)));
        global $HTTP_DOWNLOAD_MIME_TYPE;
        $this->assertTrue(strpos($HTTP_DOWNLOAD_MIME_TYPE, 'application/x-suggestions+json') !== false);
    }
}

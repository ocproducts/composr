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
class bot_detection_test_set extends cms_test_case
{
    public function testBotDetection()
    {
        $url = build_url(array('page' => ''), '');

        // Phone
        $uas = array(
            'Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 5 Build/JOP40D) AppleWebKit/535.19 (KHTML, like Gecko; googleweblight) Chrome/38.0.1025.166 Mobile Safari/535.19', // Android
            'Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25', // iPhone
        );
        foreach ($uas as $ua) {
            $data = http_download_file($url->evaluate(), null, true, false, $ua);
            $this->assertTrue(strpos($data, '>Mobile version') === false, 'Issue with ' . $ua);
            $this->assertTrue(strpos($data, '>Non-Mobile version') !== false, 'Issue with ' . $ua);
        }

        // Desktop
        $uas = array(
            'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10136', // Edge
            'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.85 Safari/537.36', // Chrome
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:34.0) Gecko/20100101 Firefox/34.0', // Firefox
            'Mozilla/4.0 (compatible; MSIE 6.0; MSIE 5.5; Windows NT 5.0) Opera 7.02 Bork-edition [en]', // Opera
            'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)', // IE
            'Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25', // iPad
        );
        foreach ($uas as $ua) {
            $data = http_download_file($url->evaluate(), null, true, false, $ua);
            $this->assertTrue(strpos($data, '>Mobile version') !== false, 'Issue with ' . $ua);
            $this->assertTrue(strpos($data, '>Non-Mobile version') === false, 'Issue with ' . $ua);
        }
    }
}

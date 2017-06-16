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
class http_obscure_cases_test_set extends cms_test_case
{
    // COR is very easy to accidentally break due to it running early in bootstrap and not being used much
    public function testCOR()
    {
        $extra_headers = array('Origin' => 'http://example.com');
        $http_verb = 'GET';
        $test = cms_http_request(get_base_url() . '/index.php', array('extra_headers' => $extra_headers, 'http_verb' => $http_verb));
        $this->assertTrue($test->data != '');
        $this->assertTrue(!$this->hasCORHeader('Access-Control-Allow-Origin'));
        $this->assertTrue(!$this->hasCORHeader('Access-Control-Allow-Credentials'));

        $extra_headers = array('Origin' => get_base_url());
        $http_verb = 'GET';
        $test = cms_http_request(get_base_url() . '/index.php', array('extra_headers' => $extra_headers, 'http_verb' => $http_verb));
        $this->assertTrue($test->data != '');
        $this->assertTrue($this->hasCORHeader('Access-Control-Allow-Origin'));
        $this->assertTrue(!$this->hasCORHeader('Access-Control-Allow-Credentials'));

        $extra_headers = array('Origin' => get_base_url());
        $http_verb = 'OPTIONS';
        $test = cms_http_request(get_base_url() . '/index.php', array('extra_headers' => $extra_headers, 'http_verb' => $http_verb));
        $this->assertTrue($test->data == '');
        $this->assertTrue($this->hasCORHeader('Access-Control-Allow-Origin'));
        $this->assertTrue($this->hasCORHeader('Access-Control-Allow-Credentials'));
    }

    protected function hasCORHeader($header)
    {
        global $HTTP_HEADERS;
        $found = false;
        foreach ($HTTP_HEADERS as $line) {
            if (preg_match("#^" . $header . ": .*#i", $line, $matches) != 0) {
                $found = true;
            }
        }
        return $found;
    }
}

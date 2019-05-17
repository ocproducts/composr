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
class http_obscure_cases_test_set extends cms_test_case
{
    // COR is very easy to accidentally break due to it running early in bootstrap and not being used much
    public function testCOR()
    {
        $extra_headers = array('Origin' => 'http://example.com');
        $http_verb = 'GET';
        $response = cms_http_request(get_base_url() . '/index.php', array('extra_headers' => $extra_headers, 'http_verb' => $http_verb));
        $this->assertTrue($response->data != '');
        $this->assertTrue(!$this->has_cor_header($response, 'Access-Control-Allow-Origin'));
        $this->assertTrue(!$this->has_cor_header($response, 'Access-Control-Allow-Credentials'));

        $extra_headers = array('Origin' => get_base_url());
        $http_verb = 'GET';
        $response = cms_http_request(get_base_url() . '/index.php', array('extra_headers' => $extra_headers, 'http_verb' => $http_verb));
        $this->assertTrue($response->data != '');
        $this->assertTrue($this->has_cor_header($response, 'Access-Control-Allow-Origin'));
        $this->assertTrue(!$this->has_cor_header($response, 'Access-Control-Allow-Credentials'));

        $extra_headers = array('Origin' => get_base_url());
        $http_verb = 'OPTIONS';
        $response = cms_http_request(get_base_url() . '/index.php', array('extra_headers' => $extra_headers, 'http_verb' => $http_verb));
        $this->assertTrue($response->data == '');
        $this->assertTrue($this->has_cor_header($response, 'Access-Control-Allow-Origin'));
        $this->assertTrue($this->has_cor_header($response, 'Access-Control-Allow-Credentials'));
    }

    protected function has_cor_header($response, $header)
    {
        $found = false;
        foreach ($response->headers as $line) {
            $matches = array();
            if (preg_match("#^" . $header . ": .*#i", $line) != 0) {
                $found = true;
            }
        }
        return $found;
    }
}

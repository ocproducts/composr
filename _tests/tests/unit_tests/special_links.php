<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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
class special_links_test_set extends cms_test_case
{
    public function testISBN()
    {
        $c = http_get_contents('https://www.bookfinder.com/search/?isbn=0241968984&mode=isbn&st=sr&ac=qr', array('trigger_error' => false, 'timeout' => 10.0, 'ua' => false/*seems to dislike bots*/));
        $this->assertTrue(strpos($c, 'No Place to Hide') !== false, 'External link not working, fix test and use within Composr (separate)');

        if (php_function_allowed('usleep')) {
            usleep(1000000);
        }

        $c = http_get_contents('https://www.bookfinder.com/search/?isbn=978-0241968987&mode=isbn&st=sr&ac=qr', array('trigger_error' => false, 'timeout' => 10.0, 'ua' => false/*seems to dislike bots*/));
        $this->assertTrue(strpos($c, 'No Place to Hide') !== false, 'External link not working, fix test and use within Composr (separate)');
    }

    public function testLookupLinks()
    {
        $this->assertTrue(strpos(http_get_contents('http://whatismyipaddress.com/ip/12.34.56.78', array('trigger_error' => false)), 'AT&T Services') !== false, 'External link not working, fix test and use within Composr (separate) [LOOKUP_SCREEN.tpl, COMMANDR_WHOIS.tpl]');
        $this->assertTrue(strpos(http_get_contents('https://ping.eu/ping/?host=12.34.56.78', array('trigger_error' => false)), 'Ping') !== false, 'External link not working, fix test and use within Composr (separate) [LOOKUP_SCREEN.tpl, COMMANDR_WHOIS.tpl]');
        $this->assertTrue(strpos(http_get_contents('https://ping.eu/traceroute/?host=12.34.56.78', array('trigger_error' => false)), 'Traceroute') !== false, 'External link not working, fix test and use within Composr (separate) [LOOKUP_SCREEN.tpl, COMMANDR_WHOIS.tpl]');
    }

    public function testWhoIsLink()
    {
        $this->assertTrue(strpos(http_get_contents('http://whois.domaintools.com/compo.sr', array('trigger_error' => false)), 'Whois Record') !== false, 'External link not working, fix test and use within Composr (separate) [WARN_SPAM_URLS.tpl]');
    }

    public function testHealthCheckLinks()
    {
        $urls = array(
            'https://seositecheckup.com/' => true,
            'https://www.google.com/webmasters/tools/home' => false,
            'https://www.bing.com/toolbox/webmaster/' => false,
            'https://webmaster.yandex.com/' => false,
            'https://www.thehoth.com/' => true,
            'https://serps.com/tools/' => true,
            'https://validator.w3.org/' => true,
            'https://jigsaw.w3.org/css-validator/' => true,
            'https://achecker.ca/checker/index.php' => true,
            'https://www.bing.com/toolbox/markup-validator' => true,
            'https://search.google.com/structured-data/testing-tool/' => true,
            'https://webmaster.yandex.com/tools/microtest/' => false,
            'https://developers.facebook.com/tools/debug/sharing/' => true,
            'https://www.woorank.com/' => true,
            'https://website.grader.com/' => true,
            'https://developers.google.com/speed/pagespeed/insights/' => true,
            'https://www.ssllabs.com/ssltest/' => true,
            'https://glockapps.com/spam-testing/' => true,
        );
        foreach ($urls as $url => $test_no_redirecting) {
            $result = cms_http_request($url, array('trigger_error' => false));
            $this->assertTrue(is_string($result->data), 'External link (' . $url . ') not working, fix test and use within Composr (separate)');
            if ($test_no_redirecting) {
                $this->assertTrue($result->download_url == $url, 'External link (' . $url . ') redirecting elsewhere, fix test and use within Composr (separate)');
            }
        }
    }

    public function testMiscLinks()
    {
        $this->assertTrue(is_string(http_get_contents('http://www.google.com/search?as_lq=' . urlencode('http://example.com/'), array('trigger_error' => false))), 'Google backreferences link broken');

        $this->assertTrue(is_string(http_get_contents('https://duckduckgo.com/?q=tile+background&iax=images&ia=images', array('trigger_error' => false))), 'DuckDuckGo search broken');
    }
}

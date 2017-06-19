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
class url_management_test_set extends cms_test_case
{
    public function testUrlToPageLink()
    {
        $zone_pathed = (get_option('collapse_user_zones') == '1') ? '' : 'site/';
        $zone = (get_option('collapse_user_zones') == '1') ? '' : 'site';

        $test = url_to_page_link(get_base_url() . '/' . $zone_pathed . 'pg/downloads/browse/test?foo=bar');
        $this->assertTrue($test == $zone . ':downloads:browse:test:foo=bar', 'Got wrong page-link for decode on PG scheme (' . $test . '), ' . $test);

        $test = url_to_page_link(get_base_url() . '/' . $zone_pathed . 'downloads/browse/test?foo=bar');
        $this->assertTrue($test == $zone . ':downloads:browse:test:foo=bar', 'Got wrong page-link for decode on SIMPLE scheme (' . $test . '), ' . $test);

        $test = url_to_page_link(get_base_url() . '/' . $zone_pathed . 'downloads/browse/test.htm?foo=bar');
        $this->assertTrue($test == $zone . ':downloads:browse:test:foo=bar', 'Got wrong page-link for decode on HTM scheme (' . $test . '), ' . $test);

        $test = url_to_page_link(get_base_url() . '/' . $zone_pathed . 'index.php?page=downloads&type=browse&id=test&&foo=bar');
        $this->assertTrue($test == $zone . ':downloads:browse:test:foo=bar', 'Got wrong page-link for decode on RAW scheme (' . $test . '), ' . $test);
    }

    public function testCycle()
    {
        $test_zone = 'adminzone';
        $test_attributes = array('page' => DEFAULT_ZONE_PAGE_NAME, 'type' => 'bar', 'x' => 'y');
        $test_hash = 'fish';

        $test_url = build_url($test_attributes, $test_zone, array(), false, false, true, $test_hash);
        $test_page_link = $test_zone . ':' . DEFAULT_ZONE_PAGE_NAME . ':bar:x=y#' . $test_hash;

        $_url = $test_url->evaluate();
        $page_link = url_to_page_link($_url);
        $this->assertTrue($page_link == $test_page_link, $page_link . ' vs ' . $test_page_link);

        list($zone, $attributes, $hash) = page_link_decode($test_page_link);
        $this->assertTrue($zone == $test_zone);
        $this->assertTrue($attributes == $test_attributes);
        $this->assertTrue($hash == $test_hash);
    }
}

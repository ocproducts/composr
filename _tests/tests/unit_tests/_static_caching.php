<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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
class _static_caching_test_set extends cms_test_case
{
    public function testStaticCacheWorks()
    {
        $config_file_path = get_file_base() . '/_config.php';
        $config_file = file_get_contents($config_file_path);
        file_put_contents($config_file_path, $config_file . "\n\n\$SITE_INFO['fast_spider_cache'] = '1';\n\$SITE_INFO['any_guest_cached_too'] = '1';");
        fix_permissions($config_file_path);

        $url = build_url(array('page' => ''), '');

        http_get_contents($url->evaluate()); // Prime cache

        $time_before = microtime(true);
        $data = http_get_contents($url->evaluate());
        $time_after = microtime(true);

        if (function_exists('gzencode')) {
            $data = gzdecode($data);
        }

        $time = $time_after - $time_before;

        $this->assertTrue($time < 0.1, 'Took too long, ' . float_format($time) . ' seconds');

        $this->assertTrue(strpos($data, 'global.css') !== false);
        $this->assertTrue(strpos($data, '</html>') !== false);

        file_put_contents($config_file_path, $config_file);
    }

    public function testFailover()
    {
        $url = build_url(array('page' => ''), '');
        $url2 = build_url(array('page' => 'xxx-does-not-exist' . uniqid('', true)), '');

        $test_url = get_base_url() . '/does-not-exist.abc';

        $config_file_path = get_file_base() . '/_config.php';
        $config_file = file_get_contents($config_file_path);
        file_put_contents($config_file_path, $config_file . "\n\n\$SITE_INFO['fast_spider_cache'] = '1';\n\$SITE_INFO['any_guest_cached_too'] = '1';\n\$SITE_INFO['failover_mode'] = 'auto_off';\n\$SITE_INFO['failover_check_urls'] = '" . $test_url . "';\n\$SITE_INFO['failover_cache_miss_message'] = 'FAILOVER_CACHE_MISS';\n\$SITE_INFO['failover_email_contact'] = 'test@example.com';");
        fix_permissions($config_file_path);

        $result = http_get_contents($url->evaluate(), array('trigger_error' => false)); // Prime cache
        $this->assertTrue($result !== null, 'Failed to prime cache');

        $detect_url = find_script('failover_script');
        $result = http_get_contents($detect_url, array('trigger_error' => false)); // Should trigger failover, due to broken URL
        $this->assertTrue($result !== null, 'Failed to call failover script');

        clearstatcache();
        $this->assertTrue(strpos(file_get_contents(get_file_base() . '/_config.php'), "\$SITE_INFO['failover_mode'] = 'auto_on';") !== false, 'Failover should have activated but did not');

        $result = http_get_contents($url->evaluate(), array('ignore_http_status' => true, 'trigger_error' => false)); // Should be failed over, but cached
        $this->assertTrue(strpos($result, '</body>') !== false, 'Failover should have been able to use static cache but did not');

        $result = http_get_contents($url2->evaluate(), array('ignore_http_status' => true, 'trigger_error' => false)); // Should be failed over, but cached
        $this->assertTrue(strpos($result, 'FAILOVER_CACHE_MISS') !== false, 'Failover cache miss message not found');

        file_put_contents($config_file_path, $config_file);
    }
}

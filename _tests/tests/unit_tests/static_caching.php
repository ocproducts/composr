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
class static_caching_test_set extends cms_test_case
{
    public function testStaticCacheWorks()
    {
        $config_file_path = get_file_base() . '/_config.php';
        $config_file = file_get_contents($config_file_path);
        file_put_contents($config_file_path, $config_file . "\n\n\$SITE_INFO['fast_spider_cache'] = '1';\n\$SITE_INFO['any_guest_cached_too'] = '1';");
        fix_permissions($config_file_path);

        $url = build_url(array('page' => ''), '');

        http_download_file($url->evaluate()); // Prime cache

        $time_before = microtime(true);
        $data = http_download_file($url->evaluate());
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
}

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
class extra_logging_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        $this->establish_admin_session();
    }

    public function testProfiler()
    {
        $glob_cmd = get_file_base() . '/data_custom/profiling--*.log';

        clearstatcache();
        $before = glob($glob_cmd);

        set_value('enable_profiler', '1');
        $url = build_url(array('page' => ''), 'forum');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        set_value('enable_profiler', '0');

        clearstatcache();
        $after = glob($glob_cmd);

        $this->assertTrue(count($after) > count($before), 'Profiling files after = ' . integer_format(count($after)));

        foreach ($after as $path) {
            if (strpos($path, 'in-progress') === false) {
                unlink($path);
            }
        }
    }

    public function testMemoryMonitorSlowURLs()
    {
        set_value('monitor_slow_urls', '1');

        $log_path = get_file_base() . '/data_custom/errorlog.php';
        cms_file_put_contents_safe($log_path, '');
        $url = build_url(array('page' => 'faq', 'cache' => 0), 'docs');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos(cms_file_get_contents_safe($log_path), 'Over time limit @'));

        set_value('monitor_slow_urls', '0');
    }

    public function testMemoryTracking()
    {
        set_value('memory_tracking', '1');

        $log_path = get_file_base() . '/data_custom/errorlog.php';
        cms_file_put_contents_safe($log_path, '');
        $url = build_url(array('page' => ''), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos(cms_file_get_contents_safe($log_path), 'Memory usage above memory_tracking'));

        set_value('memory_tracking', '0');
    }

    public function testSpecialPageTypeMemory()
    {
        $url = build_url(array('page' => '', 'special_page_type' => 'memory'), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos($data, 'Memory usage:') !== false);
    }

    public function testSpecialPageTypeIDELinkage()
    {
        $url = build_url(array('page' => '', 'special_page_type' => 'ide_linkage'), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos($data, 'txmt://') !== false);
    }

    public function testSpecialPageTypeQuery()
    {
        $url = build_url(array('page' => '', 'special_page_type' => 'query'), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos($data, 'View queries') !== false);
    }

    public function testSpecialPageTypeTranslateContent()
    {
        $url = build_url(array('page' => '', 'special_page_type' => 'lang_EN'), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos($data, 'Translate/re-phrase Composr into English') !== false);
    }

    public function testSpecialPageTypeValidate()
    {
        $url = build_url(array('page' => '', 'special_page_type' => 'code'), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos($data, 'Standards checker notices') !== false);
    }

    public function testSpecialPageTypeThemeImages()
    {
        $url = build_url(array('page' => '', 'special_page_type' => 'theme_images'), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos($data, 'Theme image editing') !== false);
    }

    public function testSpecialPageTypeTemplates()
    {
        $url = build_url(array('page' => '', 'special_page_type' => 'templates'), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos($data, 'Templates') !== false);
    }

    public function testSpecialPageTypeTree()
    {
        $url = build_url(array('page' => '', 'special_page_type' => 'tree'), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos($data, 'Template tree') !== false);
    }

    public function testSpecialPageTypeShowMarkers()
    {
        $url = build_url(array('page' => '', 'special_page_type' => 'show_markers'), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos($data, '<!-- START-TEMPLATE=HTML_HEAD -->') !== false);
    }

    public function testSpecialPageTypeShowEditLinks()
    {
        $url = build_url(array('page' => '', 'special_page_type' => 'show_edit_links'), '');
        $data = http_download_file($url->evaluate(), null, true, false, 'Composr', null, array(get_session_cookie() => get_session_id()));
        $this->assertTrue(strpos($data, 'admin-themes') !== false);
    }

    public function testErrorLog()
    {
        $path = get_file_base() . '/data_custom/errorlog.php';
        clearstatcache();
        $size_before = filesize($path);
        error_log('Testing');
        clearstatcache();
        $size_after = filesize($path);
        $this->assertTrue($size_after > $size_before);
    }

    public function testPermissionChecksLog()
    {
        $path = get_file_base() . '/data_custom/permissioncheckslog.php';
        cms_file_put_contents_safe($path, '');

        clearstatcache();
        $size_before = filesize($path);
        $url = build_url(array('page' => ''), '');
        $data = http_download_file($url->evaluate());
        clearstatcache();
        $size_after = filesize($path);
        $this->assertTrue($size_after > $size_before);

        unlink($path);
    }

    public function testQueryLog()
    {
        $path = get_file_base() . '/data_custom/queries.log';
        cms_file_put_contents_safe($path, '');

        clearstatcache();
        $size_before = filesize($path);
        $url = build_url(array('page' => ''), '');
        $data = http_download_file($url->evaluate());
        clearstatcache();
        $size_after = filesize($path);
        $this->assertTrue($size_after > $size_before);

        unlink($path);
    }
}

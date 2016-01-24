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
class _installer_test_set extends cms_test_case
{
    public function testQuickInstaller()
    {
        $_GET['skip_quick'] = '0';
        $_GET['skip_manual'] = '0';
        $_GET['skip_bundled'] = '0';
        $_GET['skip_mszip'] = '0';

        if (php_function_allowed('set_time_limit')) {
            set_time_limit(300);
        }

        require_code('version2');
        require_code('make_release');

        $builds_path = get_builds_path();
        $version_dotted = get_version_dotted();
        $install_path = $builds_path . '/builds/' . $version_dotted . '/install.php';

        $url = get_custom_base_url() . '/exports/builds/' . $version_dotted . '/install.php';

        if (!is_file($install_path)) {
            make_installers();
        }

        http_download_file($url);

        $this->assertTrue($GLOBALS['HTTP_MESSAGE'] == '200');
    }

    public function testDoesNotFullyCrash()
    {
        $test = http_download_file(get_base_url() . '/install.php', null, false);
        $this->assertTrue($GLOBALS['HTTP_MESSAGE'] == '200');
        $this->assertTrue(strpos($test, 'type="submit"') !== false); // Has start button: meaning something worked
    }

    public function testFullInstallSafeMode()
    {
        // Assumes we're using a blank root password, which is typically the case on development) - or you have it in $SITE_INFO['mysql_root_password']
        global $SITE_INFO;
        require_code('install_headless');
        $success = do_install_to('test', 'root', isset($SITE_INFO['mysql_root_password']) ? $SITE_INFO['mysql_root_password'] : '', 'cms_unit_test_', true);
        $this->assertTrue($success);
    }

    public function testFullInstallNotSafeMode()
    {
        // Assumes we're using a blank root password, which is typically the case on development) - or you have it in $SITE_INFO['mysql_root_password']
        global $SITE_INFO;
        require_code('install_headless');
        $success = do_install_to('test', 'root', isset($SITE_INFO['mysql_root_password']) ? $SITE_INFO['mysql_root_password'] : '', 'cms_unit_test_', false);
        $this->assertTrue($success);
    }
}

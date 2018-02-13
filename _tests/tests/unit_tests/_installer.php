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
class _installer_test_set extends cms_test_case
{
    public function testIsMySQL()
    {
        $this->assertTrue(strpos(get_db_type(), 'mysql') !== false, 'Test can only run with MySQL');
    }

    public function testQuickInstaller()
    {
        if (strpos(get_db_type(), 'mysql') === false) {
            return;
        }

        $_GET['skip_quick'] = '0';
        $_GET['skip_manual'] = '0';
        $_GET['skip_bundled'] = '0';
        $_GET['skip_mszip'] = '0';

        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(0);
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

        $http_result = cms_http_request($url);

        $this->assertTrue($http_result->message == '200');
    }

    public function testDoesNotFullyCrash()
    {
        if (strpos(get_db_type(), 'mysql') === false) {
            return;
        }

        $http_result = cms_http_request(get_base_url() . '/install.php?skip_slow_checks=1', array('trigger_error' => false, 'timeout' => 60));

        $this->assertTrue($http_result->message == '200', 'Wrong HTTP status code ' . $http_result->message);

        $success = (strpos($http_result->data, 'type="submit"') !== false);
        if ((!$success) && (isset($_GET['debug']))) {
            @var_dump($http_result->data);
            exit();
        }
        $this->assertTrue($success, 'No submit button found'); // Has start button: meaning something worked
    }

    public function testFullInstallSafeMode()
    {
        if (strpos(get_db_type(), 'mysql') === false) {
            return;
        }

        $result = $this->doHeadlessInstall(true);
        if (!$result) {
            return;
        }

        $result = $this->doHeadlessInstall(false);
        if (!$result) {
            return;
        }
    }

    private function doHeadlessInstall($safe_mode)
    {
        if (strpos(get_db_type(), 'mysql') === false) {
            return;
        }

        $database = 'test';
        $table_prefix = 'cms_installer_test_';

        // Cleanup old install
        $tables = $GLOBALS['SITE_DB']->query('SHOW TABLES FROM ' . $database, null, 0, true);
        if ($tables === null) {
            $tables = array();
        }
        foreach ($tables as $table) {
            if (substr($table['Tables_in_' . $database], 0, strlen($table_prefix)) == $table_prefix) {
                $GLOBALS['SITE_DB']->query('DROP TABLE ' . $database . '.' . $table['Tables_in_' . $database]);
            }
        }

        // Assumes we're using a blank root password, which is typically the case on development) - or you have it in $SITE_INFO['mysql_root_password']
        global $SITE_INFO;
        require_code('install_headless');
        for ($i = 0; $i < 2; $i++) { // 1st trial is clean DB, 2nd trial is dirty DB
            $success = do_install_to($database, (strpos(get_db_site(), 'mysql') === false) ? get_db_site_user() : 'root', isset($SITE_INFO['mysql_root_password']) ? $SITE_INFO['mysql_root_password'] : '', $table_prefix, $safe_mode);
            $fail_message = 'Failed on trial #' . strval($i + 1);
            $fail_message .= ($safe_mode ? '(safe mode)' : '(no safe mode)');
            if (!isset($_GET['debug'])) {
                $fail_message .= ' -- append &debug=1 to the URL to get debug output';
            }
            $this->assertTrue($success, $fail_message);

            if (!$success) {
                return false; // Don't do further trials if there's an error
            }
        }

        return true;
    }
}

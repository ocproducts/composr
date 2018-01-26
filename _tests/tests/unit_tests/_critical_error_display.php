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
class _critical_error_display_test_set extends cms_test_case
{
    public function testCriticalErrorScreen()
    {
        $e_path = get_file_base() . '/_critical_error.html';
        file_put_contents($e_path, 'xxx123');

        $dir = get_custom_file_base() . '/critical_errors';
        @mkdir($dir, 0777);

        $c_path = get_file_base() . '/_config.php';
        rename($c_path, $c_path . '.old');
        $result = http_get_contents(get_base_url() . '/index.php');
        $this->assertTrue(strpos($result, '_critical_error.html') !== false);
        rename($c_path . '.old', $c_path);

        unlink($e_path);

        require_code('files');
        deldir_contents($dir);
    }
}

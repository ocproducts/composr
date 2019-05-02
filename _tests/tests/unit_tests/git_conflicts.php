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
class git_conflicts_test_set extends cms_test_case
{
    public function testValidCode()
    {
        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(300);
        }

        require_code('files2');

        $files = get_directory_contents(get_file_base(), '', IGNORE_SHIPPED_VOLATILE | IGNORE_UNSHIPPED_VOLATILE | IGNORE_FLOATING, true, true, array('php', 'tpl', 'css', 'js', 'xml', 'txt', 'sh'));
        $files[] = 'install.php';
        foreach ($files as $path) {
            if ((basename($path) == 'MessageFormatter.php') || (basename($path) == 'phpstub.php')) {
                continue;
            }

            $c = file_get_contents(get_file_base() . '/' . $path);
            $this->assertTrue(strpos($c, '<<<' . '<') === false, $path);
        }
    }
}

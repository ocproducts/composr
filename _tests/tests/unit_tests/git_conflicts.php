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
class git_conflicts_test_set extends cms_test_case
{
    public function testValidCode()
    {
        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(300);
        }

        require_code('files2');

        $files = get_directory_contents(get_file_base(), '', IGNORE_CUSTOM_DIR_GROWN_CONTENTS | IGNORE_BUNDLED_VOLATILE, true, true, array('php'));
        $files[] = 'install.php';
        foreach ($files as $path) {
            if ((basename($path) == 'MessageFormatter.php') || (basename($path) == 'phpstub.php')) {
                continue;
            }

            $this->assertTrue(strpos(file_get_contents(get_file_base() . '/' . $path), '<<<' . '<') === false, $path);
        }
    }
}

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
class _copyright_test_set extends cms_test_case
{
    public function testCodeCopyrightDates()
    {
        require_code('files2');

        $files = get_directory_contents(get_file_base(), '', IGNORE_SHIPPED_VOLATILE | IGNORE_UNSHIPPED_VOLATILE | IGNORE_FLOATING | IGNORE_CUSTOM_THEMES, true, true, array('php', 'css'));
        $files[] = 'install.php';
        foreach ($files as $path) {
            $code = file_get_contents(get_file_base() . '/' . $path);
            $matches = array();
            if (preg_match('#Copyright \(c\) ocProducts, 2004-(\d+)#', $code, $matches) != 0) {
                $this->assertTrue(intval($matches[1]) >= intval(date('Y')), 'Old copyright date for ' . $path . ' (replace the whole PHP header, to ensure consistency)');
            }
        }
    }
}

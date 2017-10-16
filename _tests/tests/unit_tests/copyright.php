<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

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
class copyright_test_set extends cms_test_case
{
    public function testCodeCopyrightDates()
    {
        require_code('files2');
        $files = get_directory_contents(get_file_base());
        foreach ($files as $file) {
            if (((substr($file, -4) == '.php') || (substr($file, -4) == '.css')) && (substr($file, 0, 8) != 'exports/') && (strpos($file, '/_unnamed_/') === false)) {
                $code = file_get_contents(get_file_base() . '/' . $file);
                $matches = array();
                if (preg_match('#Copyright \(c\) ocProducts, 2004-(\d+)#', $code, $matches) != 0) {
                    $this->assertTrue(intval($matches[1]) >= intval(date('Y')), 'Old copyright date for ' . $file . ' (replace the whole PHP header, to ensure consistency)');
                }
            }
        }
    }
}

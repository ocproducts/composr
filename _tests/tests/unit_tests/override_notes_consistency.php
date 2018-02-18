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
class override_notes_consistency_test_set extends cms_test_case
{
    public function testOverrideNotesConsistency()
    {
        require_code('files2');

        $files = get_directory_contents(get_file_base(), '', IGNORE_FLOATING, true, true, array('php'));
        $files[] = 'install.php';
        foreach ($files as $path) {
            if (file_exists(dirname($path) . '/index.php')) {
                continue; // Zone directory, no override support
            }

            $c = file_get_contents(get_file_base() . '/' . $path);

            if (strpos($c, 'CQC: No check') !== false) {
                continue;
            }
            if (strpos($c, 'CQC: No API check') !== false) {
                continue;
            }

            if (strpos($path, '_custom/') === false) {
                $this->assertTrue(strpos($c, 'NOTE TO PROGRAMMERS:') !== false, 'Missing "NOTE TO PROGRAMMERS:" in ' . $path);
            } else {
                $this->assertFalse(strpos($c, 'NOTE TO PROGRAMMERS:') !== false, 'Undesirable "NOTE TO PROGRAMMERS:" in ' . $path);
            }
        }
    }
}

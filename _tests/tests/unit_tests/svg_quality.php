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
class svg_quality_test_set extends cms_test_case
{
    public function testNoHiddenRaster()
    {
        require_code('files2');
        $contents = get_directory_contents(get_file_base() . '/themes/default/', get_file_base() . '/themes/default/');

        foreach ($contents as $file) {
            if (substr($file, -4) == '.svg') {
                $c = file_get_contents($file);
                $this->assertTrue(strpos($c, '<image') === false);
            }
        }
    }
}

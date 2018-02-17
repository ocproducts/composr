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
class missing_colour_equations_test_set extends cms_test_case
{
    public function testMissingColourEquations()
    {
        $dont_check = array(
            'commandr.css',
            'install.css',
            'widget_plupload.css',
            'widget_color.css',
            'widget_date.css',
            'widget_select2.css',
            'phpinfo.css',
            'jquery_ui.css',
        );

        $dh = opendir(get_file_base() . '/themes/default/css');
        while (($file = readdir($dh)) !== false) {
            if (substr($file, -4) == '.css') {
                if (in_array($file, $dont_check)) {
                    continue;
                }

                $c = file_get_contents(get_file_base() . '/themes/default/css/' . $file);
                $matches = array();
                $count = preg_match_all('/^.+(\#[0-9A-Fa-f]{3,6})(.*)$/m', $c, $matches);
                for ($i = 0; $i < $count; $i++) {
                    if (strpos($matches[0][$i], '{$') === false) {
                        $line = substr_count(substr($c, 0, strpos($c, $matches[0][$i])), "\n") + 1;
                        $this->assertTrue(false, 'Missing colour equation in ' . $file . ':' . strval($line) . ' for ' . $matches[1][$i]);
                    }
                }
            }
        }
        closedir($dh);
    }
}

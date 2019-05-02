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
class js_lang_references_test_set extends cms_test_case
{
    public function testLangReferences()
    {
        $core_ini_files_contents = '';
        foreach (array(
            'lang/EN/global.ini',
            'lang_custom/EN/global.ini',
            'lang/EN/critical_error.ini',
            'lang_custom/EN/critical_error.ini',
        ) as $path) {
            if (is_file(get_file_base() . '/' . $path)) {
                $core_ini_files_contents .= file_get_contents(get_file_base() . '/' . $path);
            }
        }

        foreach (array('javascript', 'javascript_custom') as $subdir) {
            $path = get_file_base() . '/themes/default/' . $subdir;
            $dh = opendir($path);
            while (($file = readdir($dh)) !== false) {
                if (strtolower(substr($file, -3)) == '.js') {
                    $c = file_get_contents($path . '/' . $file);

                    $matches = array();
                    $num_matches = preg_match_all('#\{\!(\w+)[\},;^\*]#m', $c, $matches);
                    for ($i = 0; $i < $num_matches; $i++) {
                        $str = $matches[1][$i];
                        $this->assertTrue(strpos($core_ini_files_contents, "\n" . $str . '=') !== false, $file . '/' . $str . ' needs to have explicit file referencing');
                    }
                }
            }
            closedir($dh);
        }
    }
}

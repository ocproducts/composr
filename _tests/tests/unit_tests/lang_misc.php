<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

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
class lang_misc_test_set extends cms_test_case
{
    public function testUnknownReferences()
    {
        require_code('lang_compile');

        disable_php_memory_limit();
        require_all_lang();

        $all_code = '';
        $files = $this->do_dir(get_file_base(), '', 'php');
        foreach ($files as $file) {
            $c = file_get_contents($file);
            $all_code .= $c;
        }
        $files = $this->do_dir(get_file_base(), '', 'tpl');
        foreach ($files as $file) {
            $c = file_get_contents($file);
            $all_code .= $c;
        }
        $files = $this->do_dir(get_file_base() . '/themes', 'themes', 'js');
        foreach ($files as $file) {
            $c = file_get_contents($file);
            if (strpos($c, '/*{$,Parser hint: pure}*/') === false) {
                $all_code .= $c;
            }
        }
        $files = $this->do_dir(get_file_base(), '', 'txt');
        foreach ($files as $file) {
            $c = file_get_contents($file);
            $all_code .= $c;
        }
        $files = $this->do_dir(get_file_base(), '', 'xml');
        foreach ($files as $file) {
            $c = file_get_contents($file);
            $all_code .= $c;
        }
        $all_code .= file_get_contents(get_file_base() . '/install.php');

        $num_matches = preg_match_all('#do\_lang(\_tempcode)?\(\'([^\']*)\'[\),]#', $all_code, $matches);
        for ($i = 0; $i < $num_matches; $i++) {
            $str = $matches[2][$i];
            $this->process_str_reference($str);
        }

        $num_matches = preg_match_all('#get_screen_title\(\'([^\']*)\'\)#', $all_code, $matches);
        for ($i = 0; $i < $num_matches; $i++) {
            $str = $matches[1][$i];
            $this->process_str_reference($str);
        }

        $num_matches = preg_match_all('#[^\\\\]\{\!([\w:]+)[^\}]*\}#', $all_code, $matches);
        for ($i = 0; $i < $num_matches; $i++) {
            $str = $matches[1][$i];
            $this->process_str_reference($str);
        }
    }

    private function process_str_reference($str)
    {
        $this->assertTrue(do_lang($str, null, null, null, null, false) !== null, 'Cannot find referenced lang string ' . $str);

        if (strpos($str, ':') !== false) {
            list($file, $just_str) = explode(':', $str, 2);
            $map = get_lang_file_map(fallback_lang(), $file, false) + get_lang_file_map(fallback_lang(), $file, true);
            $this->assertTrue(isset($map[$just_str]), 'Incorrect implicit require_lang for ' . $str);
        }
    }

    private function do_dir($dir, $dir_stub, $ext)
    {
        $files = array();

        if (($dh = opendir($dir)) !== false) {
            while (($file = readdir($dh)) !== false) {
                if (($file[0] != '.') && (!should_ignore_file((($dir_stub == '') ? '' : ($dir_stub . '/')) . $file, IGNORE_BUNDLED_VOLATILE | IGNORE_CUSTOM_DIR_SUPPLIED_CONTENTS | IGNORE_CUSTOM_DIR_GROWN_CONTENTS))) {
                    if (is_file($dir . '/' . $file)) {
                        if (substr($file, -strlen($ext) - 1, strlen($ext) + 1) == '.' . $ext) {
                            $files[] = $dir . '/' . $file;
                        }
                    } elseif (is_dir($dir . '/' . $file)) {
                        $_files = $this->do_dir($dir . '/' . $file, (($dir_stub == '') ? '' : ($dir_stub . '/')) . $file, $ext);
                        $files = array_merge($_files, $files);
                    }
                }
            }
            closedir($dh);
        }

        return $files;
    }
}

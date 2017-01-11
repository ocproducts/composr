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
class privilege_existence_test_set extends cms_test_case
{
    public function testCode()
    {
        require_code('files');

        $matches = array();
        $done = array();

        $privileges = array_flip(collapse_1d_complexity('the_name', $GLOBALS['SITE_DB']->query_select('privilege_list', array('the_name'))));

        require_code('files2');
        $contents = get_directory_contents(get_file_base());

        foreach ($contents as $f) {
            $file_type = get_file_extension($f);

            if ($file_type == 'php') {
                $c = file_get_contents(get_file_base() . '/' . $f);

                $num_matches = preg_match_all('#add_privilege\(\'[^\']+\', \'([^\']+)\'#', $c, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $privilege = $matches[1][$i];

                    $privileges[$privilege] = true;
                }
            }
        }

        foreach ($contents as $f) {
            if (should_ignore_file($f, IGNORE_CUSTOM_DIR_GROWN_CONTENTS)) {
                continue;
            }

            $file_type = get_file_extension($f);

            if ($file_type == 'php') {
                $c = file_get_contents(get_file_base() . '/' . $f);

                $num_matches = preg_match_all('#has_privilege\((get_member\(\)|\$\w+), \'([^\']+)\'\)#', $c, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $privilege = $matches[2][$i];

                    if (isset($done[$privilege])) {
                        continue;
                    }

                    $this->assertTrue(isset($privileges[$privilege]), 'Missing referenced privilege (.php): ' . $privilege);

                    $done[$privilege] = true;
                }
            }

            if ($file_type == 'tpl' || $file_type == 'txt') {
                $c = file_get_contents(get_file_base() . '/' . $f);

                $num_matches = preg_match_all('#\{\$HAS_PRIVILEGE,(\w+)\}#', $c, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $privilege = $matches[1][$i];

                    if (isset($done[$privilege])) {
                        continue;
                    }

                    $this->assertTrue(isset($privileges[$privilege]), 'Missing referenced privilege (' . $file_type . '): ' . $privilege);

                    $done[$privilege] = true;
                }
            }
        }
    }
}

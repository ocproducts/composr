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
class maintenance_codes_test_set extends cms_test_case
{
    public function testMaintenanceCodeReferences()
    {
        $myfile = fopen(get_custom_file_base() . '/data/maintenance_status.csv', 'rb');

        $header_row = fgetcsv($myfile); // Header row
        unset($header_row[0]);

        $codenames = array();
        while (($row = fgetcsv($myfile)) !== false) {
            $codename = $row[0];
            $codenames[$codename] = true;
        }

        // Test PHP code
        require_code('files2');
        $contents = get_directory_contents(get_file_base());
        foreach ($contents as $c) {
            if (substr($c, -4) == '.php') {
                $_c = file_get_contents(get_file_base() . '/' . $c);
                $matches = array();
                $num_matches = preg_match_all('#is_maintained\(\'([^\']*)\'\)#', $_c, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $codename = $matches[1][$i];
                    $this->assertTrue(isset($codenames[$codename]), 'Broken maintenance code referenced in PHP code, ' . $codename);
                }
            }
        }

        // Test config options
        $config_hooks = find_all_hook_obs('systems', 'config', 'Hook_config_');
        foreach ($config_hooks as $file => $ob) {
            $details = $ob->get_details();
            if (isset($details['maintenance_code'])) {
                $codename = $details['maintenance_code'];
                $this->assertTrue(isset($codenames[$codename]), 'Broken maintenance code referenced in config option, ' . $codename);
            }
        }

        // Test tutorials
        $path = get_file_base() . '/docs/pages/comcode_custom/EN';
        $dh = opendir($path);
        while (($f = readdir($dh)) !== false) {
            if ($f[0] == '.') {
                continue;
            }

            if (substr($f, -4) == '.txt') {
                $contents = file_get_contents($path . '/' . $f);

                $matches = array();
                $num_matches = preg_match_all('#\{\$IS_MAINTAINED,(\w+),#', $contents, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $codename = $matches[1][$i];
                    $this->assertTrue(isset($codenames[$codename]), 'Broken maintenance code reference in tutorial, ' . $codename);
                }
            }
        }
        closedir($dh);
    }

    public function testTestReferences()
    {
        $myfile = fopen(get_custom_file_base() . '/data/maintenance_status.csv', 'rb');

        $header_row = fgetcsv($myfile); // Header row
        unset($header_row[0]);

        while (($row = fgetcsv($myfile)) !== false) {
            $testing = isset($row[6]) ? $row[6] : '';

            $matches = array();
            if (preg_match('#(\w+) automated test#', $testing, $matches) != 0) {
                $test = $matches[1];
                $this->assertTrue(is_file(get_file_base() . '/_tests/tests/unit_tests/' . $test . '.php'), 'Could not find referenced test, ' . $test);
            }
        }
    }
}

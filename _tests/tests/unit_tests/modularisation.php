<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

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
class modularisation_test_set extends cms_test_case
{
    public function setUp()
    {
        if (function_exists('set_time_limit')) {
            @set_time_limit(0);
        }

        parent::setUp();
    }

    public function testModularisation()
    {
        global $GFILE_ARRAY;

        $addon_data = array();
        $dh = opendir(get_file_base() . '/sources/hooks/systems/addon_registry');
        while (($file = readdir($dh)) !== false) {
            if (substr($file, -4) != '.php') {
                continue;
            }
            if ($file[0] == '.') {
                continue;
            }
            require_code('hooks/systems/addon_registry/' . basename($file, '.php'));
            $ob = eval('return new Hook_addon_registry_' . basename($file, '.php') . '();');
            $addon_data[basename($file, '.php')] = $ob->get_file_list();
        }

        $seen = array();
        foreach ($addon_data as $d) {
            foreach ($d as $file) {
                if (array_key_exists($file, $seen)) {
                    $this->assertTrue(false, 'Double referenced: ' . $file);
                }
                $seen[$file] = 1;
            }
        }

        safe_ini_set('memory_limit', '500M');

        $GFILE_ARRAY = array();
        $this->do_dir();
        $unput_files = array();
        foreach ($GFILE_ARRAY as $path) {
            $found = false;
            foreach ($addon_data as $section_name => $section) {
                foreach ($section as $fileindex => $file) {
                    if ($file == $path) {
                        if ((substr($file, -4) == '.php') && ($file != 'data_custom/errorlog.php')) {
                            $data = file_get_contents(get_file_base() . '/' . $file);
                            $matches = array();
                            $m_count = preg_match('#@package\s+(\w+)#', $data, $matches);
                            if (($m_count != 0) && ($matches[1] != $section_name)) {
                                $this->assertTrue(false, '@package wrong for <a href="txmt://open?url=file://' . htmlentities(get_file_base() . '/' . $file) . '">' . htmlentities($path) . '</a> (should be ' . $section_name . ')');
                            } elseif (($m_count == 0) && ($file != '_config.php') && ($file != 'data_custom/errorlog.php')) {
                                $this->assertTrue(false, 'No @package for <a href="txmt://open?url=file://' . htmlentities(get_file_base() . '/' . $file) . '">' . htmlentities($path) . '</a> (should be ' . $section_name . ')');
                            }
                        }

                        $found = true;
                        unset($section[$fileindex]);
                        $addon_data[$section_name] = $section;
                        break 2;
                    }
                }
            }
            if (!$found) {
                $data = @file_get_contents(get_file_base() . '/' . $path);
                $matches = array();
                $m_count = preg_match('#@package\s+(\w+)#', $data, $matches);
                if ($m_count != 0) {
                    $unput_files[$matches[1]][] = $path;
                } else {
                    $this->assertTrue(false, 'Could not find the addon for... \'' . htmlentities($path) . '\',');
                }
            }
        }

        ksort($unput_files);
        foreach ($unput_files as $addon => $paths) {
            echo '<br /><strong>' . htmlentities($addon) . '</strong>';
            foreach ($paths as $path) {
                $this->assertTrue(false, 'Could not find the addon for... \'' . $path . '\',');
            }
        }
        foreach ($addon_data as $section_name => $section) {
            if (!file_exists(get_file_base() . '/sources/hooks/systems/addon_registry/' . $section_name . '.php')) {
                $this->assertTrue(false, 'Addon files missing / not in main distribution / referenced twice... \'sources/hooks/systems/addon_registry/' . $section_name . '.php\',');
            }
            foreach ($section as $file) {
                if (($file != '_notes_') && ($file != '_requires_') && ($file != 'data_custom/execute_temp.php') && ($file != 'data_custom/firewall_rules.txt')) {
                    $this->assertTrue(false, 'Addon files missing / not in main distribution / referenced twice... \'' . htmlentities($file) . '\',');
                }
            }
        }
    }

    public function do_dir($dir = '')
    {
        global $GFILE_ARRAY;

        require_code('files');

        $full_dir = get_file_base() . '/' . $dir;
        $dh = opendir($full_dir);
        while (($file = readdir($dh)) !== false) {
            if (should_ignore_file($dir . $file, IGNORE_CUSTOM_DIR_GROWN_CONTENTS | IGNORE_NONBUNDLED_SCATTERED | IGNORE_CUSTOM_ZONES | IGNORE_CUSTOM_THEMES | IGNORE_NON_EN_SCATTERED_LANGS | IGNORE_BUNDLED_UNSHIPPED_VOLATILE, 0)) {
                continue;
            }

            $is_dir = is_dir($full_dir . $file);

            if ($is_dir) {
                $this->do_dir($dir . $file . '/');
            } else {
                $GFILE_ARRAY[] = $dir . $file;
            }
        }
    }

    public function tearDown()
    {
        parent::tearDown();
    }
}

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
class modularisation_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(300);
        }
    }

    public function testModularisation()
    {
        $addon_data = array();
        $hooks = find_all_hook_obs('systems', 'addon_registry', 'Hook_addon_registry_');
        foreach ($hooks as $hook => $ob) {
            $addon_data[$hook] = $ob->get_file_list();
        }

        $seen = array();
        foreach ($addon_data as $addon_name => $d) {
            if ($addon_name == 'all_icons') {
                continue;
            }

            foreach ($d as $path) {
                $this->assertTrue(((!array_key_exists($path, $seen)) || (strpos($path, '_custom') !== false)), 'Double referenced: ' . $path);
                $seen[$path] = true;

                if (preg_match('#^themes/default/images/icons/#', $path) != 0) {
                    $this->assertTrue(in_array($path, $addon_data['all_icons']), 'All icons must be in all_icons addon: ' . $path);
                }
            }
        }

        safe_ini_set('memory_limit', '500M');

        require_code('files2');
        $unput_files = array();
        $ignore = IGNORE_CUSTOM_DIR_GROWN_CONTENTS | IGNORE_NONBUNDLED_EXTREMELY_SCATTERED | IGNORE_CUSTOM_ZONES | IGNORE_CUSTOM_THEMES | IGNORE_NON_EN_SCATTERED_LANGS | IGNORE_BUNDLED_UNSHIPPED_VOLATILE | IGNORE_REVISION_FILES;
        //$ignore = IGNORE_NONBUNDLED_EXTREMELY_SCATTERED | IGNORE_CUSTOM_THEMES | IGNORE_NON_EN_SCATTERED_LANGS | IGNORE_BUNDLED_UNSHIPPED_VOLATILE; Uncomment for more careful testing
        $files = get_directory_contents(get_file_base(), '', $ignore);
        foreach ($files as $path) {
            if (preg_match('#^docs#', $path) == 0) {
                continue;
            }

            if ($path == 'sources_custom/hooks/systems/content_meta_aware/temp_test.php') {
                continue;
            }

            $found = false;
            foreach ($addon_data as $addon_name => $addon_files) {
                foreach ($addon_files as $fileindex => $_path) {
                    if ($_path == $path) {
                        if (substr($_path, -4) == '.php') {
                            $data = file_get_contents(get_file_base() . '/' . $_path);

                            if ((strpos($data, 'ocProducts') !== false || (!should_ignore_file($_path, IGNORE_NONBUNDLED_SCATTERED)) || ($_path == 'install.php')) && ($_path != '_config.php') && ($_path != 'data_custom/errorlog.php') && ($_path != 'tracker/config_inc.php')) {
                                $matches = array();
                                $m_count = preg_match_all('#@package\s+(\w+)#', $data, $matches);
                                $problem = ($m_count != 0) && ($matches[1][0] != $addon_name) && (@$matches[1][1] != $addon_name/*FUDGE: should ideally do a loop, but we'll assume max of 2 packages for now*/);
                                $this->assertTrue(!$problem, '@package wrong for <a href="txmt://open?url=file://' . htmlentities(get_file_base() . '/' . $_path) . '">' . htmlentities($path) . '</a> (should be ' . $addon_name . ')');
                                if (!$problem) {
                                    $this->assertTrue($m_count > 0, 'No @package for <a href="txmt://open?url=file://' . htmlentities(get_file_base() . '/' . $_path) . '">' . htmlentities($path) . '</a> (should be ' . $addon_name . ')');
                                }
                            }
                        }

                        $found = true;

                        unset($addon_files[$fileindex]);
                        $addon_data[$addon_name] = $addon_files;
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
                }
                $this->assertTrue($m_count == 0, 'Could not find the addon for... \'' . htmlentities($path) . '\',');
            }
        }

        ksort($unput_files);
        foreach ($unput_files as $addon => $paths) {
            echo '<br /><strong>' . htmlentities($addon) . '</strong>';
            foreach ($paths as $path) {
                $this->assertTrue(false, 'Could not find the addon for... \'' . $path . '\',');
            }
        }
        foreach ($addon_data as $addon_name => $addon_files) {
            $ok = (file_exists(get_file_base() . '/sources/hooks/systems/addon_registry/' . $addon_name . '.php') || file_exists(get_file_base() . '/sources_custom/hooks/systems/addon_registry/' . $addon_name . '.php'));
            $this->assertTrue($ok, 'Addon registry files missing / referenced twice... \'sources/hooks/systems/addon_registry/' . $addon_name . '.php\',');
            foreach ($addon_files as $path) {
                $ok = ($path == 'data_custom/execute_temp.php') || ($path == 'data_custom/firewall_rules.txt') || (file_exists($path));
                $this->assertTrue($ok, 'Addon files missing... \'' . htmlentities($path) . '\',');
            }
        }
    }
}

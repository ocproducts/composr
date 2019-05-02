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
class addon_references_test_set extends cms_test_case
{
    protected $files;

    public function setUp()
    {
        parent::setUp();

        require_code('files2');

        $this->files = get_directory_contents(get_file_base(), '', IGNORE_SHIPPED_VOLATILE | IGNORE_UNSHIPPED_VOLATILE | IGNORE_FLOATING | IGNORE_CUSTOM_THEMES, true, true, array('php', 'tpl'));
        $this->files[] = 'install.php';
    }

    public function testPHP()
    {
        foreach ($this->files as $path) {
            if (substr($path, -4) != '.php') {
                continue;
            }

            $c = file_get_contents(get_file_base() . '/' . $path);
            $matches = array();
            $num_matches = preg_match_all('#addon_installed\(\'([^\']*)\'\)#', $c, $matches);
            for ($i = 0; $i < $num_matches; $i++) {
                $addon = $matches[1][$i];
                $this->assertTrue(addon_installed($addon), 'Could not find PHP-referenced addon, ' . $addon);
            }
        }
    }

    public function testTemplates()
    {
        foreach ($this->files as $path) {
            if (substr($path, -4) != '.tpl') {
                continue;
            }

            $c = file_get_contents(get_file_base() . '/' . $path);
            $matches = array();
            $num_matches = preg_match_all('#\{\$ADDON_INSTALLED,(\w+)\}#', $c, $matches);
            for ($i = 0; $i < $num_matches; $i++) {
                $addon = $matches[1][$i];
                $this->assertTrue(addon_installed($addon), 'Could not find template-referenced addon, ' . $addon);
            }
        }
    }
}

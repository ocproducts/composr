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
class tutorial_nav_paths_test_set extends cms_test_case
{
    public function testInvalidPaths()
    {
        $config_hooks = find_all_hook_obs('systems', 'config', 'Hook_config_');

        require_all_lang();

        $paths_found = array();

        $path = get_custom_file_base() . '/docs/pages/comcode_custom/EN';
        $dh = opendir($path);
        while (($f = readdir($dh)) !== false) {
            if (substr($f, -4) == '.txt') {
                $c = file_get_contents($path . '/' . $f);

                $matches = array();
                $num_matches = preg_match_all('#Admin Zone > Setup > Configuration > (\w[\w /]+\w)( > (\w[\w /]+\w))?#', $c, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $category = $matches[1][$i];
                    $group = isset($matches[3][$i]) ? $matches[3][$i] : '';
                    $total = $matches[0][$i];

                    $paths_found[$total] = array($category, $group);
                }

                $matches = array();
                $num_matches = preg_match_all('#[^>] Content Management > #', $c, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $this->assertTrue(false, 'Start CMS zone breadcrumbs from the Admin Zone');
                }
            }
        }
        closedir($dh);

        foreach ($paths_found as $total => $_parts) {
            list($category, $group) = $_parts;

            $ok = false;

            if ($category == 'Installation Options') {
                $ok = true;
            }

            foreach ($config_hooks as $ob) {
                $details = $ob->get_details();
                if ((strip_tags(do_lang('CONFIG_CATEGORY_' . $details['category'])) == $category) && (($group == '') || (strip_tags(do_lang($details['group'])) == $group))) {
                    $ok = true;
                    break;
                }
            }

            $this->assertTrue($ok, 'Could not find ' . $total. '; category=' . $category . '; group=' . $group);
        }
    }
}

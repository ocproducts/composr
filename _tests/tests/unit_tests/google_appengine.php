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
class google_appengine_test_set extends cms_test_case
{
    public function testPregConstraint()
    {
        require_code('files2');

        $files = get_directory_contents(get_file_base(), '', IGNORE_BUNDLED_VOLATILE | IGNORE_NONBUNDLED_SCATTERED | IGNORE_CUSTOM_DIR_SUPPLIED_CONTENTS | IGNORE_CUSTOM_DIR_GROWN_CONTENTS, true, true, array('php'));
        $files[] = 'install.php';
        foreach ($files as $path) {
            $c = file_get_contents(get_file_base() . '/' . $path);

            if (preg_match('#preg_(replace|replace_callback|match|match_all|grep|split)\(\'(.)[^\']*(?<!\\\\)\\2[^\']*e#', $c) != 0) {
                $this->assertTrue(false, 'regexp /e not allowed (in ' . $path . ')');
            }

            /*
            Think Google AppEngine was since fixed, and we use this for symlink resolution
            if ((strpos($c, '\'SCRIPT_FILENAME\'') !== false) && ($path != 'sources/minikernel.php') && ($path != 'sources/global.php') && ($path != 'sources/global2.php') && ($path != 'sources/phpstub.php')) {
                $this->assertTrue(false, 'SCRIPT_FILENAME does not work stably across platforms (in ' . $path . ')');
            }
            */
        }
    }
}

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
class standard_dir_files_test_set extends cms_test_case
{
    public function setUp()
    {
        if (php_function_allowed('set_time_limit')) {
            set_time_limit(0);
        }

        parent::setUp();
    }

    public function testStandardDirFiles()
    {
        $this->do_dir(get_file_base());
    }

    public function do_dir($dir)
    {
        $contents = 0;

        require_code('files');

        if (($dh = opendir($dir)) !== false) {
            while (($file = readdir($dh)) !== false) {
                if (should_ignore_file(preg_replace('#^' . preg_quote(get_file_base() . '/', '#') . '#', '', $dir . '/') . $file, IGNORE_NONBUNDLED_VERY_SCATTERED | IGNORE_CUSTOM_DIR_SUPPLIED_CONTENTS, 0)) {
                    continue;
                }

                if ($file == 'test-a') {
                    continue;
                }

                if (is_dir($dir . '/' . $file)) {
                    $this->do_dir($dir . '/' . $file);
                } else {
                    $contents++;
                }
            }
        }

        if ($contents > 0) {
            if ((!file_exists($dir . '/index.php')) && (!file_exists($dir . '/index.html')) && (strpos($dir, 'ckeditor') === false) && (strpos($dir, 'personal_dicts') === false)) {
                $this->assertTrue(false, 'touch "' . $dir . '/index.html" ; git add -f "' . $dir . '/index.html"');
            }

            if ((!file_exists($dir . DIRECTORY_SEPARATOR . '.htaccess')) && (!file_exists($dir . '/index.php')) && (!file_exists($dir . '/html_custom')) && (!file_exists($dir . '/EN')) && (strpos($dir, 'ckeditor') === false) && (strpos($dir, 'uploads') === false) && (preg_match('#/data(/|$|\_)#', $dir) == 0) && (strpos($dir, 'themes') === false) && (strpos($dir, 'exports') === false)) {
                $this->assertTrue(false, 'cp "' . get_file_base() . '/sources/.htaccess" "' . $dir . '/.htaccess" ; git add "' . $dir . '/.htaccess"');
            }
        }
    }

    public function testParallelHookDirs()
    {
        foreach (array('systems', 'blocks', 'modules') as $dir) {
            $a = array();
            $dh = opendir(get_file_base() . '/sources/hooks/' . $dir);
            while (($f = readdir($dh)) !== false) {
                $a[] = $f;
            }
            closedir($dh);
            sort($a);

            $b = array();
            $dh = opendir(get_file_base() . '/sources_custom/hooks/' . $dir);
            while (($f = readdir($dh)) !== false) {
                $b[] = $f;
            }
            closedir($dh);
            sort($b);

            $diff = array_diff($a, $b);
            $this->assertTrue(count($diff) == 0, 'Missing in sources/' . $dir . ': ' . serialize($diff));

            $diff = array_diff($b, $a);
            $this->assertTrue(count($diff) == 0, 'Missing in sources_custom/' . $dir . ': ' . serialize($diff));
        }
    }
}

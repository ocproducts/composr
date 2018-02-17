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
class standard_dir_files_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(300);
        }
    }

    public function testStandardDirFiles()
    {
        $this->do_dir(get_file_base(), '');
    }

    protected function do_dir($dir, $dir_stub)
    {
        $contents_count = 0;

        require_code('files');

        $dh = opendir($dir);
        if ($dh !== false) {
            while (($file = readdir($dh)) !== false) {
                if (should_ignore_file((($dir_stub == '') ? '' : ($dir_stub . '/')) . $file, IGNORE_NONBUNDLED_VERY_SCATTERED | IGNORE_CUSTOM_DIR_SUPPLIED_CONTENTS | IGNORE_CUSTOM_THEMES)) {
                    continue;
                }

                if ($file == 'test-a') {
                    continue;
                }

                if (is_dir($dir . '/' . $file)) {
                    $this->do_dir($dir . '/' . $file, (($dir_stub == '') ? '' : ($dir_stub . '/')) . $file);
                } else {
                    $contents_count++;
                }
            }
            closedir($dh);
        }

        if ($contents_count > 0) {
            if (
                (!file_exists($dir . '/index.php')) &&
                (strpos($dir, 'ckeditor') === false) &&
                (strpos($dir, 'personal_dicts') === false) &&
                (strpos($dir, 'uploads/website_specific') === false)
            ) {
                $this->assertTrue(file_exists($dir . '/index.html'), 'touch "' . $dir . '/index.html" ; git add -f "' . $dir . '/index.html"');
            }

            if (
                (!file_exists($dir . '/index.php')) &&
                (!file_exists($dir . '/html_custom')) &&
                (!file_exists($dir . '/EN')) &&
                (strpos($dir, 'ckeditor') === false) &&
                (strpos($dir, 'uploads') === false) &&
                (preg_match('#/data(/|$|_)#', $dir) == 0)
                && (strpos($dir, 'themes') === false) &&
                (strpos($dir, 'exports') === false)
            ) {
                $this->assertTrue(file_exists($dir . '/.htaccess'), 'cp "' . get_file_base() . '/sources/.htaccess" "' . $dir . '/.htaccess" ; git add "' . $dir . '/.htaccess"');
            }
        }
    }

    public function testParallelHookDirs()
    {
        foreach (array('systems', 'blocks', 'modules') as $dir) {
            $a = array();
            $_dir = get_file_base() . '/sources/hooks/' . $dir;
            $dh = opendir($_dir);
            while (($file = readdir($dh)) !== false) {
                if ($file == '.DS_Store') {
                    continue;
                }

                if (is_file($_dir . '/' . $file . 'index.html')) {
                    $a[] = $file;
                }
            }
            closedir($dh);
            sort($a);

            $b = array();
            $_dir = get_file_base() . '/sources_custom/hooks/' . $dir;
            $dh = opendir($_dir);
            while (($file = readdir($dh)) !== false) {
                if ($file == '.DS_Store') {
                    continue;
                }

                if (is_file($_dir . '/' . $file . 'index.html')) {
                    $b[] = $file;
                }
            }
            closedir($dh);
            sort($b);

            $diff = array_diff($a, $b);
            $this->assertTrue(count($diff) == 0, 'Missing in sources_custom/hooks/' . $dir . ': ' . serialize($diff));

            $diff = array_diff($b, $a);
            $this->assertTrue(count($diff) == 0, 'Missing in sources/hooks/' . $dir . ': ' . serialize($diff));
        }
    }
}

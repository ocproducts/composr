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
class standard_dir_files_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        cms_extend_time_limit(TIME_LIMIT_EXTEND_slow);
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
                if (should_ignore_file((($dir_stub == '') ? '' : ($dir_stub . '/')) . $file, IGNORE_FLOATING | IGNORE_CUSTOM_THEMES | IGNORE_CUSTOM_LANGS)) {
                    continue;
                }

                // Exceptions
                if ($dir_stub == '') {
                    if (in_array($file, array('tracker'))) {
                        continue;
                    }
                } elseif ($dir_stub == 'sources_custom') {
                    if (in_array($file, array('ILess', 'aws', 'sabredav', 'photobucket', 'spout', 'Transliterator', 'swift_mailer'))) {
                        continue;
                    }
                } elseif ($dir_stub == 'sources_custom/composr_mobile_sdk') {
                    if (in_array($file, array('ios', 'android'))) {
                        continue;
                    }
                } elseif ($dir_stub == 'data') {
                    if (in_array($file, array('ckeditor'))) {
                        continue;
                    }
                } elseif ($dir_stub == 'uploads/website_specific') {
                    if (in_array($file, array(get_db_site(), 'test'))) {
                        continue;
                    }
                } elseif ($dir_stub == '_tests/codechecker') {
                    if (in_array($file, array('netbeans'))) {
                        continue;
                    }
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
                (!file_exists($dir . '/index.php')) // Not in a zone (needs to run as default)
            ) {
                $this->assertTrue(file_exists($dir . '/index.html'), 'touch "' . $dir . '/index.html" ; git add -f "' . $dir . '/index.html"');
            }

            if (
                (!file_exists($dir . '/index.php')) && // Not in a zone (needs to run)
                (!file_exists($dir . '/html_custom')) && // Not in an HTML directory (want to be able to call by hand)
                (!file_exists($dir . '/EN')) && // Not in a pages directory (as parent of HTML directory)
                (strpos($dir, '/uploads') === false) && // Not from uploads (we need to download from)
                (preg_match('#/data(/|$|_)#', $dir) == 0) && // Not from data (scripts need to run)
                (strpos($dir, '/themes') === false) && // Not from themes (we need to download from)
                (strpos($dir, '/exports') === false) && // Not in exports (we need to download from)
                (!file_exists($dir . '/mobiquo.php')) && // Not in mobiquo (we need to call Tapatalk)
                (!file_exists($dir . '/appbanner.js')) && // Not in mobiquo (we need to call Tapatalk)
                (!file_exists($dir . '/tapatalk-banner-logo.png')) // Not in mobiquo (we need to call Tapatalk)
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

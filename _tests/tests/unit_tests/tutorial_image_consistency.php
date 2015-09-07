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
class tutorial_image_consistency_test_set extends cms_test_case
{
    private $images;
    private $images_referenced;

    public function setUp()
    {
        require_code('images');

        $this->images = array();
        $path = get_file_base() . '/data_custom/images/docs';
        $dh = opendir($path);
        while (($f = readdir($dh)) !== false) {
            if ($f[0] == '.') {
                continue;
            }

            if (is_dir($path . '/' . $f)) {
                $dh2 = opendir($path . '/' . $f);
                while (($f2 = readdir($dh2)) !== false) {
                    if (is_image($f2)) {
                        $this->images[$f . '/' . $f2] = true;
                    }
                }
                closedir($dh2);
            } else {
                if (is_image($f)) {
                    $this->images[$f] = true;
                }
            }
        }
        closedir($dh);

        $this->images_referenced = array();
        $path = get_file_base() . '/docs/pages/comcode_custom/EN';
        $dh = opendir($path);
        while (($f = readdir($dh)) !== false) {
            if (substr($f, -4) == '.txt') {
                $contents = file_get_contents($path . '/' . $f);

                $matches = array();
                $num_matches = preg_match_all('#data_custom/images/docs/([^"\'\s]*\.(gif|jpg|jpeg|png))#', $contents, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $this->images_referenced[$matches[1][$i]] = $path . '/' . $f;
                }

                $matches = array();
                $num_matches = preg_match_all('#\[media[^\[\]]*]data_custom/images/docs/([^\[\]]*)\[/media\]#', $contents, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $this->images_referenced[$matches[1][$i]] = $path . '/' . $f;
                }
            }
        }
        closedir($dh);
    }

    public function testNoUnmatchedScreenshots()
    {
        foreach (array_keys($this->images_referenced) as $x) {
            $this->assertTrue(isset($this->images[$x]), 'Missing screenshot referenced in a doc: ' . $x);
        }
    }

    public function testNoMissingScreenshots()
    {
        $exceptions = array(
            'install_step2_1.png',
            'install_step3_1.png',
        );

        foreach (array_keys($this->images) as $x) {
            if (in_array($x, $exceptions)) {
                continue;
            }

            $this->assertTrue(isset($this->images_referenced[$x]), 'Unused screenshot: ' . $x);
        }
    }

    // The below aren't true tests, they help us meet our image layout requirements

    /*public function testNoFilesInRoot()
    {
        $path = get_file_base() . '/data_custom/images/docs';

        foreach ($this->images_referenced as $x => $tutorial_path) {
            if (isset($this->images[$x])) {
                if (strpos($x, '/') === false) {
                    $path2 = $path . '/' . basename($tutorial_path, '.txt');
                    @mkdir($path2);
                    rename($path . '/'. $x, $path2 . '/' . $x);
                    file_put_contents($tutorial_path, str_replace($x, basename($tutorial_path, '.txt') . '/' . $x, file_get_contents($tutorial_path)));
                }
            }
        }
    }*/

    /*public function testLowerCaseFilenames()
    {
        $path = get_file_base() . '/data_custom/images/docs';

        foreach ($this->images_referenced as $x => $tutorial_path) {
            if (isset($this->images[$x])) {
                if (strtolower($x) != $x) {
                    $path2 = $path . '/' . $x;
                    $path3 = $path . '/' . strtolower($x);
                    rename($path2, $path3);
                    file_put_contents($tutorial_path, str_replace($x, strtolower($x), file_get_contents($tutorial_path)));
                }
            }
        }
    }*/

    /*public function testUnderScores()
    {
        $path = get_file_base() . '/data_custom/images/docs';

        foreach ($this->images_referenced as $x => $tutorial_path) {
            if (isset($this->images[$x])) {
                if (strpos($x, '-') !== false) {
                    $path2 = $path . '/' . $x;
                    $path3 = $path . '/' . str_replace('-', '_', $x);
                    rename($path2, $path3);
                    file_put_contents($tutorial_path, str_replace($x, str_replace('-', '_', $x), file_get_contents($tutorial_path)));
                }
            }
        }
    }*/
}

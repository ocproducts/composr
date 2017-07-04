<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

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
    private $images_referenced_by_tutorial;

    public function setUp()
    {
        require_code('images');
        require_code('tutorials');

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
                    if (is_image($f2, IMAGE_CRITERIA_WEBSAFE)) {
                        $this->images[$f . '/' . $f2] = true;
                    }
                }
                closedir($dh2);
            } else {
                if (is_image($f, IMAGE_CRITERIA_WEBSAFE)) {
                    $this->images[$f] = true;
                }
            }
        }
        closedir($dh);

        $this->images_referenced = array();
        $this->images_referenced_by_tutorial = array();
        $path = get_file_base() . '/docs/pages/comcode_custom/EN';
        $dh = opendir($path);
        while (($f = readdir($dh)) !== false) {
            if (substr($f, -4) == '.txt') {
                $tutorial = basename($f, '.txt');

                $contents = remove_code_block_contents(file_get_contents($path . '/' . $f));

                $matches = array();
                $num_matches = preg_match_all('#data_custom/images/docs/([^"\'\s]*\.(gif|jpg|jpeg|png))#', $contents, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $this->images_referenced[$matches[1][$i]] = $path . '/' . $f;
                }

                $matches = array();
                $num_matches = preg_match_all('#\[media[^\[\]]*]data_custom/images/docs/([^\[\]]*)\[/media\]#', $contents, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $dir = dirname($matches[1][$i]);
                    if (!isset($this->images_referenced_by_tutorial[$tutorial])) {
                        $this->images_referenced_by_tutorial[$tutorial] = array();
                    }
                    $this->images_referenced_by_tutorial[$tutorial][] = $dir;

                    $this->images_referenced[$matches[1][$i]] = $path . '/' . $f;
                }
            }
        }
        closedir($dh);
    }

    public function testNoWrongDirs()
    {
        foreach ($this->images_referenced_by_tutorial as $tutorial => $files) {
            foreach ($files as $dir) {
                $this->assertTrue(($dir == $tutorial) || ($dir == '.'), 'Image from wrong directory referenced for ' . $tutorial . ' (' . $dir . ')');
            }
        }
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
            'tut_install/install_step2_1.png',
            'tut_install/install_step3_1.png',
        );

        foreach (array_keys($this->images) as $x) {
            if (in_array($x, $exceptions)) {
                continue;
            }

            $this->assertTrue(isset($this->images_referenced[$x]), 'Unused screenshot: ' . $x);
        }
    }
}

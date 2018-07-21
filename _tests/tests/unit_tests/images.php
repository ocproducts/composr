<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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
class images_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        require_code('images');
    }

    public function testIsImage()
    {
        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_NONE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.ico', IMAGE_CRITERIA_NONE, /*$as_admin*/false));

        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpg', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpeg', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpe', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));
        $this->assertTrue(is_image('test.gif', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.ico', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));
        // May not be in PHP build $this->assertTrue(is_image('test.webp', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));
        // May not be in PHP build $this->assertTrue(is_image('test.bmp', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.dat', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));

        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpg', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpeg', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpe', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.gif', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.ico', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        // May not be in PHP build $this->assertTrue(is_image('test.webp', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        // May not be in PHP build $this->assertTrue(is_image('test.bmp', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.dat', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));

        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpg', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpeg', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpe', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.gif', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.ico', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.webp', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        // Won't be in valid_images if not in PHP build $this->assertTrue(is_image('test.bmp', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.dat', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));

        $this->assertTrue(!is_image('test.svg', IMAGE_CRITERIA_GD_READ, /*$as_admin*/true));
        $this->assertTrue(!is_image('test.svg', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.svg', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/true));

        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_RASTER, /*$as_admin*/true));
        $this->assertTrue(!is_image('test.svg', IMAGE_CRITERIA_RASTER, /*$as_admin*/true));
        $this->assertTrue(!is_image('test.png', IMAGE_CRITERIA_VECTOR, /*$as_admin*/true));
        $this->assertTrue(is_image('test.svg', IMAGE_CRITERIA_VECTOR, /*$as_admin*/true));
    }

    public function testImageSizing()
    {
        $this->assertTrue(is_array(cms_getimagesize(get_file_base() . '/themes/default/images/button1.png')));
        $this->assertTrue(is_array(cms_getimagesize(get_base_url() . '/themes/default/images/button1.png')));
        $this->assertTrue(!isset($GLOBALS['REQUIRED_CODE']['http'])); // Should have been able to do the above using the filesystem, via a URL->path conversion
        $this->assertTrue(is_array(cms_getimagesize('https://compo.sr/themes/composr_homesite/images_custom/composr_homesite/composr_full_logo.png')));
        $this->assertTrue(cms_getimagesize(get_file_base() . '/themes/default/images/not_here.png') === false);
    }

    public function testBasicThumbnailing()
    {
        $temp_bak = cms_tempnam();

        // Should not get larger
        $temp = $temp_bak;
        $test = convert_image('themes/default/images/button1.png', $temp, /*$width*/100, /*$height*/150, /*$box_width*/null, false, 'png', /*$using_path*/false, /*$only_make_smaller*/true);
        $this->assertTrue(cms_getimagesize($temp) == array(100, 22));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // Should get to exact size
        $temp = $temp_bak;
        $test = convert_image('themes/default/images/button1.png', $temp, /*$width*/100, /*$height*/150, /*$box_width*/null, false, 'png', /*$using_path*/false, /*$only_make_smaller*/false);
        $this->assertTrue(cms_getimagesize($temp) == array(100, 22)); // not 100x150 because we don't add padding in convert_image
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // Should get to exact size
        $temp = $temp_bak;
        $test = convert_image('themes/default/images/button1.png', $temp, /*$width*/null, /*$height*/null, /*$box_width*/120, false, 'png', /*$using_path*/false, /*$only_make_smaller*/false);
        $this->assertTrue(cms_getimagesize($temp) == array(120, 26));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // With a path
        $temp = $temp_bak;
        $test = convert_image(get_file_base() . '/themes/default/images/button1.png', $temp, /*$width*/null, /*$height*/null, /*$box_width*/120, false, 'png', /*$using_path*/true, /*$only_make_smaller*/false);
        $this->assertTrue(cms_getimagesize($temp) == array(120, 26));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // With an absolute URL
        $temp = $temp_bak;
        $test = convert_image(get_base_url() . '/themes/default/images/button1.png', $temp, /*$width*/null, /*$height*/null, /*$box_width*/120, false, 'png', /*$using_path*/false, /*$only_make_smaller*/false);
        $this->assertTrue(cms_getimagesize($temp) == array(120, 26));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        @unlink($temp_bak);
    }

    public function testIsAnimated()
    {
        require_code('images_cleanup_pipeline');

        $this->assertTrue(is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/under_construction_animated.gif'), 'gif'));
        $this->assertTrue(!is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/flags/ZM.gif'), 'gif'));

        $this->assertTrue(is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/cns_emoticons/rockon.gif.png'), 'png'));
        $this->assertTrue(!is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/video_thumb.png'), 'png'));
    }
}

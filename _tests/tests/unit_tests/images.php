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
        $this->assertTrue(!is_image('test.dat', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));

        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpg', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpeg', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpe', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.gif', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.ico', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        // May not be in PHP build $this->assertTrue(is_image('test.webp', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.dat', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));

        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpg', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpeg', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.jpe', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(is_image('test.gif', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.ico', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.webp', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
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
        $this->assertTrue(is_array(cms_getimagesize(get_custom_file_base() . '/themes/default/images/icons/48x48/status/warn.png')));
        $GGLOBALS['HTTP_DOWNLOAD_SIZE'] = null;
        $this->assertTrue(is_array(cms_getimagesize(get_custom_base_url() . '/themes/default/images/icons/48x48/status/warn.png')));
        $this->assertTrue(!isset($GLOBALS['HTTP_DOWNLOAD_SIZE'])); // Should have been able to do the above using the filesystem, via a URL->path conversion
        $this->assertTrue(is_array(cms_getimagesize('http://compo.sr/themes/composr_homesite/images_custom/composr_homesite/composr_full_logo.png')));
        $this->assertTrue(cms_getimagesize(get_custom_file_base() . '/themes/default/images/icons/48x48/status/not_here.png') === false);
    }

    public function testBasicThumbnailing()
    {
        $temp_bak = cms_tempnam();

        // Should not get larger
        $temp = $temp_bak;
        $test = convert_image('themes/default/images/icons/48x48/status/warn.png', $temp, /*$width*/100, /*$height*/150, /*$box_width*/-1, false, null, /*$using_path*/false, /*$only_make_smaller*/true);
        $this->assertTrue(cms_getimagesize($temp) == array(48, 48));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // Should get to exact size
        $temp = $temp_bak;
        $test = convert_image('themes/default/images/icons/48x48/status/warn.png', $temp, /*$width*/100, /*$height*/150, /*$box_width*/-1, false, null, /*$using_path*/false, /*$only_make_smaller*/false);
        $this->assertTrue(cms_getimagesize($temp) == array(100, 100)); // not 100x150 because we don't add padding in convert_image
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // Should get to exact size
        $temp = $temp_bak;
        $test = convert_image('themes/default/images/icons/48x48/status/warn.png', $temp, /*$width*/-1, /*$height*/-1, /*$box_width*/120, false, null, /*$using_path*/false, /*$only_make_smaller*/false);
        $this->assertTrue(cms_getimagesize($temp) == array(120, 120));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // With a path
        $temp = $temp_bak;
        $test = convert_image(get_file_base() . '/themes/default/images/icons/48x48/status/warn.png', $temp, /*$width*/-1, /*$height*/-1, /*$box_width*/120, false, null, /*$using_path*/true, /*$only_make_smaller*/false);
        $this->assertTrue(cms_getimagesize($temp) == array(120, 120));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // With an absolute URL
        $temp = $temp_bak;
        $test = convert_image(get_base_url() . '/themes/default/images/icons/48x48/status/warn.png', $temp, /*$width*/-1, /*$height*/-1, /*$box_width*/120, false, null, /*$using_path*/false, /*$only_make_smaller*/false);
        $this->assertTrue(cms_getimagesize($temp) == array(120, 120));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }


        @unlink($temp_bak);
    }
}

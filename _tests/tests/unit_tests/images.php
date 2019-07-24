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
        $this->assertTrue(is_array(cms_getimagesize_url(get_base_url() . '/themes/default/images/button1.png')));
        $this->assertTrue(!isset($GLOBALS['REQUIRED_CODE']['http'])); // Should have been able to do the above using the filesystem, via a URL->path conversion
        $this->assertTrue(is_array(cms_getimagesize_url('https://compo.sr/themes/composr_homesite/images_custom/composr_homesite/composr_full_logo.png')));
        $this->assertTrue(cms_getimagesize(get_file_base() . '/themes/default/images/not_here.png') === false);
    }

    public function testBasicThumbnailing()
    {
        $temp_bak = cms_tempnam();

        // Should not get larger
        $temp = $temp_bak;
        $test = convert_image('themes/default/images/button1.png', $temp, /*$width*/100, /*$height*/150, /*$box_width*/null, false, 'png', /*$using_path*/false, /*$only_make_smaller*/true);
        $this->assertTrue(array_slice(cms_getimagesize($temp), 0, 2) == array(100, 22));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // Should get to exact size
        $temp = $temp_bak;
        $test = convert_image('themes/default/images/button1.png', $temp, /*$width*/100, /*$height*/150, /*$box_width*/null, false, 'png', /*$using_path*/false, /*$only_make_smaller*/false);
        $this->assertTrue(array_slice(cms_getimagesize($temp), 0, 2) == array(100, 22)); // not 100x150 because we don't add padding in convert_image
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // Should get to exact size
        $temp = $temp_bak;
        $test = convert_image('themes/default/images/button1.png', $temp, /*$width*/null, /*$height*/null, /*$box_width*/120, false, 'png', /*$using_path*/false, /*$only_make_smaller*/false);
        $this->assertTrue(array_slice(cms_getimagesize($temp), 0, 2) == array(120, 26));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // With a path
        $temp = $temp_bak;
        $test = convert_image(get_file_base() . '/themes/default/images/button1.png', $temp, /*$width*/null, /*$height*/null, /*$box_width*/120, false, 'png', /*$using_path*/true, /*$only_make_smaller*/false);
        $this->assertTrue(array_slice(cms_getimagesize($temp), 0, 2) == array(120, 26));
        if ($temp_bak != $temp) {
            @unlink($temp);
        }

        // With an absolute URL
        $temp = $temp_bak;
        $test = convert_image(get_base_url() . '/themes/default/images/button1.png', $temp, /*$width*/null, /*$height*/null, /*$box_width*/120, false, 'png', /*$using_path*/false, /*$only_make_smaller*/false);
        $this->assertTrue(array_slice(cms_getimagesize($temp), 0, 2) == array(120, 26));
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

    public function testConvertImageDimensions() {
        require_code('images');
        require_code('images2');
        $file_aspects = array(
            16 => 9,
            9 => 16,
            4 => 3,
            3 => 4,
            1 => 1
        );
        $file_types = array('png', 'jpg', 'jpeg', 'gif');

        function runDimensionTest($extension, $start_width, $start_height, $convert_width, $convert_height, $box_width, $only_make_smaller, $expected_width, $expected_height, &$additional_information) {
            $additional_information = '';
            $path = cms_tempnam();
            $successful = convert_image(get_file_base() . '/_tests/assets/images/' . $start_width . 'x' . $start_height . '.' . $extension, $path, $convert_width, $convert_height, $box_width, true, null, true, $only_make_smaller);
            if ($successful) {
                list($image_width, $image_height) = getimagesize($path);
                if (($image_width !== $expected_width && $expected_width !== -1) || ($image_height !== $expected_height && $expected_height !== -1)) {
                    $additional_information = 'Instead, the dimensions of the new image were ' . $image_width . 'x' . $image_height . '.';
                    $successful = false;
                } else {
                    $additional_information = 'The test passed.';
                }
            } else {
                $additional_information = 'Instead, convert_image failed.';
            }
            unlink($path);
            return $successful;
        }

        function runTransparencyTest($file, $convert_width, $convert_height, $transparency, &$additional_information) {
            $path = cms_tempnam();

            $ret = _runTransparencyTest($path, $file, $convert_width, $convert_height, $transparency, $additional_information);
            if (!$ret) {
                require_code('mime_types');
                echo '<br style="clear: both" />';
                echo '<img style="float: left; width: 50px; margin-right: 10px; margin-bottom: 10px" src="data:' . get_mime_type(get_file_extension($file), false) . ';base64,' . base64_encode(file_get_contents($path)) .'" />';
            }

            unlink($path);

            return $ret;
        }
 
        function _runTransparencyTest(&$path, $file, $convert_width, $convert_height, $transparency, &$additional_information) {
            $additional_information = '';

            if (!convert_image(get_file_base() . '/_tests/assets/images/' . $file, $path, $convert_width, $convert_height, -1, true, null, true, false)) {
                $additional_information = 'convert_image failed.';
                return false;
            }

            $file_contents = file_get_contents($path);
            if (!$file_contents) {
                $additional_information = 'The contents of the generated convert_image file could not be read.';
                return false;
            }

            $image_resource = imagecreatefromstring($file_contents);
            if (!$image_resource) {
                $additional_information = 'A PHP image resource could not be created from the contents of the file.';
                return false;
            }

            $transparent_pixel = imagecolorat($image_resource, intval($convert_width / 4), intval($convert_height / 2));
            $transparent_data = imagecolorsforindex($image_resource, $transparent_pixel);
            if ($transparent_data['alpha'] !== $transparency) {
                $additional_information = 'Expected pixel ' . intval($convert_width / 4) . 'x' . intval($convert_height / 2) . ' to have ' . $transparency . ' alpha, but instead it was ' . $transparent_data['alpha'];
                return false;
            }

            $visible_pixel = imagecolorat($image_resource, intval($convert_width * 0.75), intval($convert_height / 2));
            $visible_data = imagecolorsforindex($image_resource, $visible_pixel);
            if ($visible_data['alpha'] !== 0) {
                $additional_information = 'Expected pixel ' . intval($convert_width * 0.75) . 'x' . intval($convert_height / 2) . ' to have 0 alpha, but instead it was ' . $visible_data['alpha'];
                return false;
            }

            return true;
        }

        foreach ($file_types as $extension) {
            foreach ($file_aspects as $width => $height) {
                $additional_information;

                // Grow tests
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width * 2, $height * 2, -1, false, $width * 2, $height * 2, $additional_information), 'Double width and height of ' . $width . 'x' . $height . '.' . $extension . '. We expected the new image to be ' . $width * 2 . 'x' . $height * 2 . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width * 2, $height * 3, -1, false, $width * 2, $height * 2, $additional_information), 'Double width, 3x height of ' . $width . 'x' . $height . '.' . $extension . '. We expected the new image to be ' . $width * 2 . 'x' . $height * 2 . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width * 3, $height * 2, -1, false, $width * 2, $height * 2, $additional_information), 'Double height, 3x width of ' . $width . 'x' . $height . '.' . $extension . '. We expected the new image to be ' . $width * 2 . 'x' . $height * 2 . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width, $height, -1, false, $width, $height, $additional_information), 'Keep the same width and height of ' . $width . 'x' . $height . '.' . $extension . '. We expected the image to remain the same. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width * 2, -1, -1, false, $width * 2, $height * 2, $additional_information), 'Double width, ignore (-1) height of ' . $width . 'x' . $height . '.' . $extension . '. We expected the new image to be ' . $width * 2 . 'x' . $height * 2 . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, -1, $height * 2, -1, false, $width * 2, $height * 2, $additional_information), 'Double height, ignore (-1) width of ' . $width . 'x' . $height . '.' . $extension . '. We expected the new image to be ' . $width * 2 . 'x' . $height * 2 . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, -1, -1, 32, false, ($width > $height ? 32 : -1), ($height > $width ? 32 : -1), $additional_information), 'Use box width 16 of ' . $width . 'x' . $height . '.' . $extension . '. We expected the new image to be ' . ($width > $height ? 32 : $width) . 'x' . ($height > $width ? 32 : $height) . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, -1, -1, 8, false, ($width > $height ? 8 : -1), ($height > $width ? 8 : -1), $additional_information), 'Use box width 4 of ' . $width . 'x' . $height . '.' . $extension . '. We expected the new image to be ' . ($width > $height ? 8 : $width) . 'x' . ($height > $width ? 8 : $height) . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, -1, -1, 2, false, ($width > $height ? 2 : -1), ($height > $width ? 2 : -1), $additional_information), 'Use box width 1 of ' . $width . 'x' . $height . '.' . $extension . '. We expected the new image to be ' . ($width > $height ? 2 : $width) . 'x' . ($height > $width ? 2 : $height) . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width * 2, $height * 2, -1, true, $width, $height, $additional_information), 'Double width and height with only make smaller = true of ' . $width . 'x' . $height . '.' . $extension . '. We expected the image to remain the same (enforce only make smaller). ' . $additional_information);

                // Shrink tests
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width, $height, -1, false, $width, $height, $additional_information), 'Half the width and height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. We expected the new image to be ' . $width . 'x' . $height . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width, $height * 2, -1, false, $width, $height, $additional_information), 'Half width, keep height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. We expected the new image to be ' . $width . 'x' . $height . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width * 2, $height, -1, false, $width, $height, $additional_information), 'Half height, keep width of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. We expected the new image to be ' . $width . 'x' . $height . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width * 2, $height * 2, -1, false, $width * 2, $height * 2, $additional_information), 'Keep the same width and height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. We expected the image to remain the same. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width, -1, -1, false, $width, -1, $additional_information), 'Half the width, ignore height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. We expected the new image to be ' . $width . 'x' . $height . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, -1, $height, -1, false, -1, $height, $additional_information), 'Half the height, ignore width of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. We expected the new image to be ' . $width . 'x' . $height . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, -1, -1, 16, false, ($width > $height ? 16 : -1), ($height > $width ? 16 : -1), $additional_information), 'Use box width 16 of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. We expected the new image to be ' . ($width > $height ? 16 : $width * 2) . 'x' . ($height > $width ? 16 : $height * 2) . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, -1, -1, 4, false, ($width > $height ? 4 : -1), ($height > $width ? 4 : -1), $additional_information), 'Use box width 4 of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. We expected the new image to be ' . ($width > $height ? 4 : $width * 2) . 'x' . ($height > $width ? 4 : $height * 2) . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, -1, -1, 1, false, ($width > $height ? 1 : -1), ($height > $width ? 1 : -1), $additional_information), 'Use box width 1 of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. We expected the new image to be ' . ($width > $height ? 1 : $width * 2) . 'x' . ($height > $width ? 1 : $height * 2) . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width, $height, -1, true, $width, $height, $additional_information), 'Half the width and height with only make smaller = true of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . 'We expected the new image to be ' . $width . 'x' . $height . '. ' . $additional_information);

                // TODO: Add test cases for cropping and padding in v11 after refactoring convert_image
            }

            // Edge Cases
            if ($extension === 'png' || $extension === 'gif') {
                $this->assertTrue(runTransparencyTest('transparent.' . $extension, 16, 16, 127, $additional_information), 'Increased 8x8 transparent.' . $extension . ' to 16x16 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);
                $this->assertTrue(runTransparencyTest('transparent.' . $extension, 4, 4, 127, $additional_information), 'Decreased 8x8 transparent.' . $extension . ' to 4x4 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);
                if ($extension === 'png') {
                    $this->assertTrue(runTransparencyTest('translucent.' . $extension, 16, 16, 63, $additional_information), 'Increased 8x8 translucent.' . $extension . ' to 16x16 and tested for 50 percent opacity on the left side and 100 percent opacity on the right side. ' . $additional_information);
                    $this->assertTrue(runTransparencyTest('translucent.' . $extension, 4, 4, 63, $additional_information), 'Decreased 8x8 translucent.' . $extension . ' to 4x4 and tested for 50 percent opacity on the left side and 100 percent opacity on the right side. ' . $additional_information);
                }
            }
        }
    }
}

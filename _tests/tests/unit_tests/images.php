<?php

/*

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
class images_test_set extends cms_test_case
{

    public function testIsAnimated()
    {
        require_code('images_cleanup_pipeline');

        $this->assertTrue(is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/under_construction_animated.gif'), 'gif'));
        $this->assertTrue(!is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/flags/ZM.gif'), 'gif'));

        //$this->assertTrue(is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/TODO'), 'png'));  TODO: Enable in v11 with an APNG
        $this->assertTrue(!is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/video_thumb.png'), 'png'));
    }

    public function testConvertImageDimensions()
    {
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

        // Helper functions

        function convertImage($file, &$path, $convert_width, $convert_height, $box_width, $only_make_smaller, &$additional_information)
        {
            $path = cms_tempnam();
            if (!convert_image($file, $path, $convert_width, $convert_height, $box_width, true, null, true, $only_make_smaller)) {
                $additional_information = 'convert_image failed.';
                return false;
            }
            return true;
        }

        function checkImageSize(&$path, $expected_width, $expected_height, &$additional_information)
        {
            list($image_width, $image_height) = getimagesize($path);
            if (($image_width !== $expected_width && $expected_width !== -1) || ($image_height !== $expected_height && $expected_height !== -1)) {
                $additional_information = 'Expected dimensions of the converted image to be ' . $expected_width . 'x' . $expected_height . '. Instead, the dimensions were ' . $image_width . 'x' . $image_height . '.';
                return false;
            }
            return array($image_width, $image_height);
        }

        function getImageContents(&$path, &$additional_information)
        {
            $file_contents = file_get_contents($path);
            if (!$file_contents) {
                $additional_information = 'The contents of the generated convert_image file could not be read.';
                return false;
            }
            return $file_contents;
        }

        function createImageFromString($file_contents, &$additional_information)
        {
            $image_resource = imagecreatefromstring($file_contents);
            if (!$image_resource) {
                $additional_information = 'A PHP image resource could not be created from the string contents of the image.';
                return false;
            }
            return $image_resource;
        }

        function testColor($image_resource, $x, $y, $expected_red, $expected_green, $expected_blue, $expected_alpha, $tolerance, &$additional_information)
        {
            $pixel = imagecolorat($image_resource, $x, $y);
            $data = imagecolorsforindex($image_resource, $pixel);
            if (($expected_red !== -1 && abs($expected_red - $data['red']) >= $tolerance) || ($expected_green !== -1 && abs($expected_green - $data['green']) >= $tolerance) || ($expected_blue !== -1 && abs($expected_blue - $data['blue']) >= $tolerance) || ($expected_alpha !== -1 && abs($expected_alpha - $data['alpha']) >= ($tolerance / 2))) {
                $additional_information = 'Expected pixel ' . strval($x) . 'x' . strval($y) . ' to be rgba(' . $expected_red . ', ' . $expected_green . ', ' . $expected_blue . ', ' . $expected_alpha . ') +- rgba(' . $tolerance . ', ' . $tolerance . ', ' . $tolerance . ', ' . float_to_raw_string($tolerance / 2) . '), but instead got rgba(' . $data['red'] . ', ' . $data['green'] . ', ' . $data['blue'] . ', ' . $data['alpha'] . ').';
                return false;
            }
            return true;
        }

        function testImageStringsAreSame($string1, $string2, &$additional_information)
        {
            if ($string1 !== $string2) {
                $additional_information = 'Expected the contents of the converted image to be exactly the same as the original image, but instead they were different.';
                return false;
            }
            return true;
        }

        // Test functions

        function runDimensionTest($extension, $start_width, $start_height, $convert_width, $convert_height, $box_width, $only_make_smaller, $expected_width, $expected_height, &$additional_information)
        {
            $additional_information = '';
            $path = '';

            if (!convertImage(get_file_base() . '/_tests/assets/images/' . $start_width . 'x' . $start_height . '.' . $extension, $path, $convert_width, $convert_height, $box_width, $only_make_smaller, $additional_information)) {
                return false;
            }

            if (!checkImageSize($path, $expected_width, $expected_height, $additional_information)) {
                return false;
            }

            unlink($path);

            return true;
        }

        function runTransparencyTest($file, $convert_width, $convert_height, $transparency, &$additional_information)
        {
            $additional_information = '';
            $path = '';

            if (!convertImage(get_file_base() . '/_tests/assets/images/' . $file, $path, $convert_width, $convert_height, -1, false, $additional_information)) {
                return false;
            }

            $dimensions = checkImageSize($path, -1, -1, $additional_information);
            if (!$dimensions) {
                return false;
            }

            $file_contents = getImageContents($path, $additional_information);
            if (!$file_contents) {
                return false;
            }

            $image_resource = createImageFromString($file_contents, $additional_information);
            if (!$image_resource) {
                return false;
            }

            if (!testColor($image_resource, intval($dimensions[0] / 4), intval($dimensions[1] / 2), -1, -1, -1, $transparency, 4, $additional_information)) {
                return false;
            }

            unlink($path);

            return true;
        }

        function runQuadrantTest($file, $convert_width, $convert_height, &$additional_information)
        {
            $additional_information = '';
            $path = '';

            if (!convertImage(get_file_base() . '/_tests/assets/images/' . $file, $path, $convert_width, $convert_height, -1, false, $additional_information)) {
                return false;
            }

            $dimensions = checkImageSize($path, -1, -1, $additional_information);
            if (!$dimensions) {
                return false;
            }

            $file_contents = getImageContents($path, $additional_information);
            if (!$file_contents) {
                return false;
            }

            $image_resource = createImageFromString($file_contents, $additional_information);
            if (!$image_resource) {
                return false;
            }

            // Test red quadrant in upper left corner
            if (!testColor($image_resource, intval($dimensions[0] / 4), intval($dimensions[1] / 4), 255, 0, 0, 0, 16, $additional_information)) {
                return false;
            }

            // Test green quadrant in upper right corner
            if (!testColor($image_resource, intval($dimensions[0] * 0.75), intval($dimensions[1] / 4), 0, 255, 0, 0, 16, $additional_information)) {
                return false;
            }

            // Test blue quadrant in lower left corner
            if (!testColor($image_resource, intval($dimensions[0] / 4), intval($dimensions[1] * 0.75), 0, 0, 255, 0, 16, $additional_information)) {
                return false;
            }

            // Test white quadrant in lower right corner
            if (!testColor($image_resource, intval($dimensions[0] * 0.75), intval($dimensions[1] * 0.75), 255, 255, 255, 0, 16, $additional_information)) {
                return false;
            }

            unlink($path);

            return true;
        }

        function runEXIFTest($file, $convert_width, $convert_height, $expected_width, $expected_height, $test_x, $test_y, $expected_red, $expected_green, $expected_blue, $expected_alpha, &$additional_information)
        {
            $additional_information = '';
            $path = '';

            if (!convertImage(get_file_base() . '/_tests/assets/images/' . $file, $path, $convert_width, $convert_height, -1, false, $additional_information)) {
                return false;
            }

            // Test image dimensions
            $dimensions = checkImageSize($path, $expected_width, $expected_height, $additional_information);
            if (!$dimensions) {
                return false;
            }

            $file_contents = getImageContents($path, $additional_information);
            if (!$file_contents) {
                return false;
            }

            $image_resource = createImageFromString($file_contents, $additional_information);
            if (!$image_resource) {
                return false;
            }

            // Test specific pixel color
            if (!testColor($image_resource, $test_x, $test_y, $expected_red, $expected_green, $expected_blue, $expected_alpha, 8, $additional_information)) {
                return false;
            }

            unlink($path);

            return true;
        }

        function runSvgTest($file, $convert_width, $convert_height, &$additional_information)
        {
            $additional_information = '';
            $path = get_file_base() . '/_tests/assets/images/' . $file;

            $contents_original = getImageContents($path, $additional_information);
            if (!$contents_original) {
                return false;
            }

            if (!convertImage(get_file_base() . '/_tests/assets/images/' . $file, $path, $convert_width, $convert_height, -1, false, $additional_information)) {
                return false;
            }

            $contents_modified = getImageContents($path, $additional_information);
            if (!$contents_modified) {
                return false;
            }

            if (!testImageStringsAreSame($contents_original, $contents_modified, $additional_information)) {
                return false;
            }

            return true;
        }

        foreach ($file_types as $extension) {
            foreach ($file_aspects as $width => $height) {
                $additional_information = '';

                // Grow tests
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width * 2, $height * 2, -1, false, $width * 2, $height * 2, $additional_information), 'Double width and height of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width * 2, $height * 3, -1, false, $width * 2, $height * 2, $additional_information), 'Double width, 3x height of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width * 3, $height * 2, -1, false, $width * 2, $height * 2, $additional_information), 'Double height, 3x width of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width, $height, -1, false, $width, $height, $additional_information), 'Keep the same width and height of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width * 2, -1, -1, false, $width * 2, $height * 2, $additional_information), 'Double width, ignore (-1) height of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, -1, $height * 2, -1, false, $width * 2, $height * 2, $additional_information), 'Double height, ignore (-1) width of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, -1, -1, 32, false, ($width > $height ? 32 : -1), ($height > $width ? 32 : -1), $additional_information), 'Use box width 16 of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, -1, -1, 8, false, ($width > $height ? 8 : -1), ($height > $width ? 8 : -1), $additional_information), 'Use box width 4 of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, -1, -1, 2, false, ($width > $height ? 2 : -1), ($height > $width ? 2 : -1), $additional_information), 'Use box width 1 of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width, $height, $width * 2, $height * 2, -1, true, $width, $height, $additional_information), 'Double width and height with only make smaller = true of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);

                // Shrink tests
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width, $height, -1, false, $width, $height, $additional_information), 'Half the width and height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width, $height * 2, -1, false, $width, $height, $additional_information), 'Half width, keep height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width * 2, $height, -1, false, $width, $height, $additional_information), 'Half height, keep width of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width * 2, $height * 2, -1, false, $width * 2, $height * 2, $additional_information), 'Keep the same width and height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width, -1, -1, false, $width, -1, $additional_information), 'Half the width, ignore height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, -1, $height, -1, false, -1, $height, $additional_information), 'Half the height, ignore width of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, -1, -1, 16, false, ($width > $height ? 16 : -1), ($height > $width ? 16 : -1), $additional_information), 'Use box width 16 of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, -1, -1, 4, false, ($width > $height ? 4 : -1), ($height > $width ? 4 : -1), $additional_information), 'Use box width 4 of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, -1, -1, 1, false, ($width > $height ? 1 : -1), ($height > $width ? 1 : -1), $additional_information), 'Use box width 1 of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue(runDimensionTest($extension, $width * 2, $height * 2, $width, $height, -1, true, $width, $height, $additional_information), 'Half the width and height with only make smaller = true of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);

                // TODO: Add test cases for cropping and padding in v11 after refactoring convert_image
            }

            // Edge case: transparency and translucent (50% opacity) tests
            if ($extension === 'png' || $extension === 'gif') { // jpg and jpeg does not support transparency
                $this->assertTrue(runTransparencyTest('transparent.' . $extension, 16, 16, 127, $additional_information), 'Increased 8x8 transparent.' . $extension . ' to 16x16 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);
                $this->assertTrue(runTransparencyTest('transparent.' . $extension, 8, 8, 127, $additional_information), '8x8 transparent.' . $extension . '. Kept size the same. Tested for transparency on the left side and visible color on the right side. ' . $additional_information);
                $this->assertTrue(runTransparencyTest('transparent.' . $extension, 4, 4, 127, $additional_information), 'Decreased 8x8 transparent.' . $extension . ' to 4x4 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);
                if ($extension === 'png') { // Only png supports alpha channel transparency
                    $this->assertTrue(runTransparencyTest('translucent.' . $extension, 16, 16, 63, $additional_information), 'Increased 8x8 translucent.' . $extension . ' to 16x16 and tested for 50 percent opacity on the left side and 100 percent opacity on the right side. ' . $additional_information);
                    $this->assertTrue(runTransparencyTest('translucent.' . $extension, 8, 8, 63, $additional_information), '8x8 translucent.' . $extension . '. Kept size the same. Tested for 50 percent opacity on the left side and 100 percent opacity on the right side. ' . $additional_information);
                    $this->assertTrue(runTransparencyTest('translucent.' . $extension, 4, 4, 63, $additional_information), 'Decreased 8x8 translucent.' . $extension . ' to 4x4 and tested for 50 percent opacity on the left side and 100 percent opacity on the right side. ' . $additional_information);
                }
            }

            // Edge case: Quadrant color test
            $this->assertTrue(runQuadrantTest('quadrant.' . $extension, 16, 16, $additional_information), 'Increased 8x8 quadrant.' . $extension . ' to 16x16 and tested for quadrant colors (top->bottom, left->right) red, green, blue, white. ' . $additional_information);
            $this->assertTrue(runQuadrantTest('quadrant.' . $extension, 8, 8, $additional_information), '8x8 quadrant.' . $extension . '. Kept size the same. Tested for quadrant colors (top->bottom, left->right) red, green, blue, white. ' . $additional_information);
            //$this->assertTrue(runQuadrantTest('quadrant.' . $extension, 4, 4, $additional_information), 'Decreased 8x8 quadrant.' . $extension . ' to 4x4 and tested for quadrant colors (top->bottom, left->right) red, green, blue, white. ' . $additional_information);
        }

        // Edge Case: palette-alpha PNG transparency test
        $this->assertTrue(runTransparencyTest('transparent_palette_alpha.png', 16, 16, 127, $additional_information), 'Increased 8x8 transparent_palette_alpha.png to 16x16 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);
        $this->assertTrue(runTransparencyTest('transparent_palette_alpha.png', 8, 8, 127, $additional_information), '8x8 transparent_palette_alpha.png. Kept size the same. Tested for transparency on the left side and visible color on the right side. ' . $additional_information);
        $this->assertTrue(runTransparencyTest('transparent_palette_alpha.png', 4, 4, 127, $additional_information), 'Decreased 8x8 transparent_palette_alpha.png to 4x4 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);

        // Edge Case: palette-binary PNG transparency test
        $this->assertTrue(runTransparencyTest('transparent_palette_binary.png', 16, 16, 127, $additional_information), 'Increased 8x8 transparent_palette_binary.png to 16x16 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);
        $this->assertTrue(runTransparencyTest('transparent_palette_binary.png', 8, 8, 127, $additional_information), '8x8 transparent_palette_binary.png. Kept size the same. Tested for transparency on the left side and visible color on the right side. ' . $additional_information);
        $this->assertTrue(runTransparencyTest('transparent_palette_binary.png', 4, 4, 127, $additional_information), 'Decreased 8x8 transparent_palette_binary.png to 4x4 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);

        // Edge Case: EXIF rotation test via dimension test and pixel color test
        $this->assertTrue(runEXIFTest('exifrotated.jpg', 4896, 6528, 4896, 6528, 4850, 250, 205, 164, 85, 0, $additional_information), 'exifrotated.jpg EXIF rotation test (size and color). Doubled the original size. ' . $additional_information);
        //$this->assertTrue(runEXIFTest('exifrotated.jpg', 2448, 3264, 2448, 3264, 2425, 175, 205, 164, 85, 0, $additional_information), 'ExifRotated.jpg EXIF rotation test (size and color). Kept the original size. ' . $additional_information);
        $this->assertTrue(runEXIFTest('exifrotated.jpg', 1224, 1632, 1224, 1632, 1212, 62, 206, 165, 86, 0, $additional_information), 'xxifrotated.jpg EXIF rotation test (size and color). Halved the original size. ' . $additional_information);

        // Edge case: SVG image content tests
        $this->assertTrue(runSvgTest('tux.svg', 670, 788, $additional_information), 'tux.svg contents test. Double the original size. ' . $additional_information);
        $this->assertTrue(runSvgTest('tux.svg', 335, 394, $additional_information), 'tux.svg contents test. Kept the original size. ' . $additional_information);
        $this->assertTrue(runSvgTest('tux.svg', 167, 197, $additional_information), 'tux.svg contents test. Half the original size. ' . $additional_information);
    }

}

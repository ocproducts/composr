<?php

/*

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
        require_code('images2');
    }

    public function testIsImage()
    {
        if (($this->only !== null) && ($this->only != 'testIsImage')) {
            return;
        }
        
        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_NONE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.ico', IMAGE_CRITERIA_NONE, /* $as_admin */ false));

        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_GD_READ, /* $as_admin */ false));
        $this->assertTrue(is_image('test.jpg', IMAGE_CRITERIA_GD_READ, /* $as_admin */ false));
        $this->assertTrue(is_image('test.jpeg', IMAGE_CRITERIA_GD_READ, /* $as_admin */ false));
        $this->assertTrue(is_image('test.jpe', IMAGE_CRITERIA_GD_READ, /* $as_admin */ false));
        $this->assertTrue(is_image('test.gif', IMAGE_CRITERIA_GD_READ, /* $as_admin */ false));
        $this->assertTrue(!is_image('test.ico', IMAGE_CRITERIA_GD_READ, /* $as_admin */ false));
        // May not be in PHP build $this->assertTrue(is_image('test.webp', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));
        // May not be in PHP build $this->assertTrue(is_image('test.bmp', IMAGE_CRITERIA_GD_READ, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.dat', IMAGE_CRITERIA_GD_READ, /* $as_admin */ false));

        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_GD_WRITE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.jpg', IMAGE_CRITERIA_GD_WRITE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.jpeg', IMAGE_CRITERIA_GD_WRITE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.jpe', IMAGE_CRITERIA_GD_WRITE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.gif', IMAGE_CRITERIA_GD_WRITE, /* $as_admin */ false));
        $this->assertTrue(!is_image('test.ico', IMAGE_CRITERIA_GD_WRITE, /* $as_admin */ false));
        // May not be in PHP build $this->assertTrue(is_image('test.webp', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        // May not be in PHP build $this->assertTrue(is_image('test.bmp', IMAGE_CRITERIA_GD_WRITE, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.dat', IMAGE_CRITERIA_GD_WRITE, /* $as_admin */ false));

        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_WEBSAFE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.jpg', IMAGE_CRITERIA_WEBSAFE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.jpeg', IMAGE_CRITERIA_WEBSAFE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.jpe', IMAGE_CRITERIA_WEBSAFE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.gif', IMAGE_CRITERIA_WEBSAFE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.ico', IMAGE_CRITERIA_WEBSAFE, /* $as_admin */ false));
        $this->assertTrue(!is_image('test.webp', IMAGE_CRITERIA_WEBSAFE, /* $as_admin */ false));
        // Won't be in valid_images if not in PHP build $this->assertTrue(is_image('test.bmp', IMAGE_CRITERIA_WEBSAFE, /*$as_admin*/false));
        $this->assertTrue(!is_image('test.dat', IMAGE_CRITERIA_WEBSAFE, /* $as_admin */ false));

        $this->assertTrue(!is_image('test.svg', IMAGE_CRITERIA_GD_READ, /* $as_admin */ true));
        $this->assertTrue(!is_image('test.svg', IMAGE_CRITERIA_WEBSAFE, /* $as_admin */ false));
        $this->assertTrue(is_image('test.svg', IMAGE_CRITERIA_WEBSAFE, /* $as_admin */ true));

        $this->assertTrue(is_image('test.png', IMAGE_CRITERIA_RASTER, /* $as_admin */ true));
        $this->assertTrue(!is_image('test.svg', IMAGE_CRITERIA_RASTER, /* $as_admin */ true));
        $this->assertTrue(!is_image('test.png', IMAGE_CRITERIA_VECTOR, /* $as_admin */ true));
        $this->assertTrue(is_image('test.svg', IMAGE_CRITERIA_VECTOR, /* $as_admin */ true));
    }

    public function testImageSizing()
    {
        if (($this->only !== null) && ($this->only != 'testImageSizing')) {
            return;
        }
        
        $this->assertTrue(is_array(cms_getimagesize(get_file_base() . '/themes/default/images/button1.png')));
        $this->assertTrue(is_array(cms_getimagesize_url(get_base_url() . '/themes/default/images/button1.png')));
        $this->assertTrue(!isset($GLOBALS['REQUIRED_CODE']['http'])); // Should have been able to do the above using the filesystem, via a URL->path conversion
        $this->assertTrue(is_array(cms_getimagesize_url('https://compo.sr/themes/composr_homesite/images_custom/composr_homesite/composr_full_logo.png')));
        $this->assertTrue(cms_getimagesize(get_file_base() . '/themes/default/images/not_here.png') === false);
    }

    public function testIsAnimated()
    {
        if (($this->only !== null) && ($this->only != 'testIsAnimated')) {
            return;
        }

        require_code('images_cleanup_pipeline');

        $this->assertTrue(is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/under_construction_animated.gif'), 'gif'));
        $this->assertTrue(!is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/flags/ZM.gif'), 'gif'));

        $this->assertTrue(is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/cns_emoticons/rockon.gif.png'), 'png'));
        $this->assertTrue(!is_animated_image(file_get_contents(get_file_base() . '/themes/default/images/video_thumb.png'), 'png'));
    }

    // Define helper functions used by testConvertImage and testConvertImagePlus

    protected function convertImage($path_source, &$path, $convert_width, $convert_height, $box_size, $only_make_smaller, &$additional_information)
    {
        foreach (array($path_source, preg_replace('#^' . preg_quote(get_file_base() . '/') . '#', get_base_url() . '/', $path_source)) as $_source) {
            $convert = convert_image($_source, $path, $convert_width, $convert_height, $box_size, true, null, true, $only_make_smaller);
            if ($convert === null) {
                $additional_information = 'convert_image failed on ' . $_source . '.';
                return false;
            }
        }

        return true;
    }

    protected function convertImagePlus($path_source, $dimensions, $algorithm, $where, $only_make_smaller, &$additional_information)
    {
        $convert = convert_image_plus($path_source, $dimensions, 'temp', null, null, $algorithm, $where, '#000000', $only_make_smaller);
        if ($convert === null) {
            $additional_information = 'convert_image_plus failed on ' . $path_source;
            return false;
        }

        return preg_replace('#^' . preg_quote(get_file_base() . '/') . '#', get_base_url() . '/', rawurldecode($convert));
    }

    protected function checkImageSize(&$path, $expected_width, $expected_height, &$additional_information)
    {
        list($image_width, $image_height) = getimagesize($path);
        if (($expected_width !== null && $image_width !== $expected_width) || ($expected_height !== null && $image_height !== $expected_height)) {
            $additional_information = 'Expected dimensions of the converted image to be ' . $expected_width . 'x' . $expected_height . '. Instead, the dimensions were ' . $image_width . 'x' . $image_height . '.';
            return false;
        }
        return array($image_width, $image_height);
    }

    protected function getImageContents(&$path, &$additional_information)
    {
        $file_contents = file_get_contents($path);
        if (!$file_contents) {
            $additional_information = 'The contents of the generated image file could not be read.';
            return false;
        }
        return $file_contents;
    }

    protected function createImageFromString($file_contents, &$additional_information)
    {
        $image_resource = imagecreatefromstring($file_contents);
        if (!$image_resource) {
            $additional_information = 'A PHP image resource could not be created from the string contents of the image.';
            return false;
        }
        return $image_resource;
    }

    protected function checkColor($file, $path, $image_resource, $x, $y, $expected_red, $expected_green, $expected_blue, $expected_alpha, $tolerance, &$additional_information)
    {
        $pixel = imagecolorat($image_resource, $x, $y);
        $data = imagecolorsforindex($image_resource, $pixel);
        if (($expected_red !== null && abs($expected_red - $data['red']) >= $tolerance) || ($expected_green !== null && abs($expected_green - $data['green']) >= $tolerance) || ($expected_blue !== null && abs($expected_blue - $data['blue']) >= $tolerance) || ($expected_alpha !== null && abs($expected_alpha - $data['alpha']) >= ($tolerance / 2))) {
            $additional_information = 'Expected pixel ' . strval($x) . 'x' . strval($y) . ' to be rgba(' . $expected_red . ', ' . $expected_green . ', ' . $expected_blue . ', ' . $expected_alpha . ') +- rgba(' . $tolerance . ', ' . $tolerance . ', ' . $tolerance . ', ' . float_to_raw_string($tolerance / 2) . '), but instead got rgba(' . $data['red'] . ', ' . $data['green'] . ', ' . $data['blue'] . ', ' . $data['alpha'] . ').';
            require_code('mime_types');
            echo '<br style="clear: both" />';
            echo '<img style="float: left; width: 50px; margin-right: 10px; margin-bottom: 10px" src="data:' . get_mime_type(get_file_extension($file), false) . ';base64,' . base64_encode(file_get_contents($path)) . '" />';
            return false;
        }
        return true;
    }

    protected function checkImageStringsAreSame($string1, $string2, &$additional_information)
    {
        if ($string1 !== $string2) {
            $additional_information = 'Expected the contents of the converted image to be exactly the same as the original image, but instead they were different.';
            return false;
        }
        return true;
    }

    protected function runDimensionTest($file, $convert_width, $convert_height, $box_size, $only_make_smaller, $expected_width, $expected_height, &$additional_information)
    {
        $additional_information = '';
        $path = cms_tempnam();

        if (!$this->convertImage($file, $path, $convert_width, $convert_height, $box_size, $only_make_smaller, $additional_information)) {
            return false;
        }

        if (!$this->checkImageSize($path, $expected_width, $expected_height, $additional_information)) {
            return false;
        }

        unlink($path);

        return true;
    }

    protected function runDimensionTestPlus($url, $dimensions, $expected_width, $expected_height, $algorithm, $where, $only_make_smaller, &$additional_information)
    {
        $additional_information = '';
        $thumbnail = $this->convertImagePlus($url, $dimensions, $algorithm, $where, $only_make_smaller, $additional_information);

        if (!$thumbnail) {
            return false;
        }

        if (!$this->checkImageSize($thumbnail, $expected_width, $expected_height, $additional_information)) {
            return false;
        }

        return true;
    }

    protected function runTransparencyTest($file, $convert_width, $convert_height, $transparency, &$additional_information)
    {
        $additional_information = '';
        $path = cms_tempnam();

        if (!$this->convertImage($file, $path, $convert_width, $convert_height, null, false, $additional_information)) {
            return false;
        }

        $dimensions = $this->checkImageSize($path, null, null, $additional_information);
        if (!$dimensions) {
            return false;
        }

        $file_contents = $this->getImageContents($path, $additional_information);
        if (!$file_contents) {
            return false;
        }

        $image_resource = $this->createImageFromString($file_contents, $additional_information);
        if (!$image_resource) {
            return false;
        }

        if (!$this->checkColor($file, $path, $image_resource, intval($dimensions[0] / 4), intval($dimensions[1] / 2), null, null, null, $transparency, 4, $additional_information)) {
            return false;
        }

        unlink($path);

        return true;
    }

    protected function runQuadrantTest($file, $convert_width, $convert_height, &$additional_information)
    {
        $additional_information = '';
        $path = cms_tempnam();

        if (!$this->convertImage($file, $path, $convert_width, $convert_height, null, false, $additional_information)) {
            return false;
        }

        $dimensions = $this->checkImageSize($path, null, null, $additional_information);
        if (!$dimensions) {
            return false;
        }

        $file_contents = $this->getImageContents($path, $additional_information);
        if (!$file_contents) {
            return false;
        }

        $image_resource = $this->createImageFromString($file_contents, $additional_information);
        if (!$image_resource) {
            return false;
        }

        // Test red quadrant in upper left corner
        if (!$this->checkColor($file, $path, $image_resource, intval($dimensions[0] / 4), intval($dimensions[1] / 4), 255, 0, 0, 0, 16, $additional_information)) {
            return false;
        }

        // Test green quadrant in upper right corner
        if (!$this->checkColor($file, $path, $image_resource, intval($dimensions[0] * 0.75), intval($dimensions[1] / 4), 0, 255, 0, 0, 16, $additional_information)) {
            return false;
        }

        // Test blue quadrant in lower left corner
        if (!$this->checkColor($file, $path, $image_resource, intval($dimensions[0] / 4), intval($dimensions[1] * 0.75), 0, 0, 255, 0, 16, $additional_information)) {
            return false;
        }

        // Test white quadrant in lower right corner
        if (!$this->checkColor($file, $path, $image_resource, intval($dimensions[0] * 0.75), intval($dimensions[1] * 0.75), 255, 255, 255, 0, 16, $additional_information)) {
            return false;
        }

        unlink($path);

        return true;
    }

    protected function runEXIFTest($file, $convert_width, $convert_height, $expected_width, $expected_height, $test_x, $test_y, $expected_red, $expected_green, $expected_blue, $expected_alpha, &$additional_information)
    {
        $additional_information = '';
        $path = cms_tempnam();

        if (!$this->convertImage($file, $path, $convert_width, $convert_height, null, false, $additional_information)) {
            return false;
        }

        // Test image dimensions
        $dimensions = $this->checkImageSize($path, $expected_width, $expected_height, $additional_information);
        if (!$dimensions) {
            return false;
        }

        $file_contents = $this->getImageContents($path, $additional_information);
        if (!$file_contents) {
            return false;
        }

        $image_resource = $this->createImageFromString($file_contents, $additional_information);
        if (!$image_resource) {
            return false;
        }

        // Test specific pixel color
        if (!$this->checkColor($file, $path, $image_resource, $test_x, $test_y, $expected_red, $expected_green, $expected_blue, $expected_alpha, 8, $additional_information)) {
            return false;
        }

        unlink($path);

        return true;
    }

    protected function runSvgTest($file, $convert_width, $convert_height, &$additional_information)
    {
        $additional_information = '';
        $path = cms_tempnam();
        $path_original = $file;

        $contents_original = $this->getImageContents($path_original, $additional_information);
        if (!$contents_original) {
            return false;
        }

        if (!$this->convertImage($path_original, $path, $convert_width, $convert_height, null, false, $additional_information)) {
            return false;
        }

        $contents_modified = $this->getImageContents($path, $additional_information);
        if (!$contents_modified) {
            return false;
        }

        if (!$this->checkImageStringsAreSame($contents_original, $contents_modified, $additional_information)) {
            return false;
        }

        unlink($path);

        return true;
    }

    public function testConvertImage()
    {
        if (($this->only !== null) && ($this->only != 'testConvertImage')) {
            return;
        }
        
        $file_aspects = array(
            16 => 9,
            9 => 16,
            4 => 3,
            3 => 4,
            1 => 1
        );
        $file_types = array('png', 'jpg', 'jpeg', 'gif');
        $additional_information = '';

        // Test functions
        // Tests

        foreach ($file_types as $extension) {
            foreach ($file_aspects as $width => $height) {

                // Grow tests
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width * 2, $height * 2, null, false, $width * 2, $height * 2, $additional_information), 'Double width and height of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width * 2, $height * 3, null, false, $width * 2, $height * 2, $additional_information), 'Double width, 3x height of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width * 3, $height * 2, null, false, $width * 2, $height * 2, $additional_information), 'Double height, 3x width of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width, $height, null, false, $width, $height, $additional_information), 'Keep the same width and height of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width * 2, null, null, false, $width * 2, $height * 2, $additional_information), 'Double width, ignore (null) height of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, null, $height * 2, null, false, $width * 2, $height * 2, $additional_information), 'Double height, ignore (null) width of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, null, null, 32, false, ($width > $height ? 32 : null), ($height > $width ? 32 : null), $additional_information), 'Use box width 16 of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, null, null, 8, false, ($width > $height ? 8 : null), ($height > $width ? 8 : null), $additional_information), 'Use box width 4 of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, null, null, 2, false, ($width > $height ? 2 : null), ($height > $width ? 2 : null), $additional_information), 'Use box width 1 of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width * 2, $height * 2, null, true, $width, $height, $additional_information), 'Double width and height with only make smaller = true of ' . $width . 'x' . $height . '.' . $extension . '. ' . $additional_information);

                // Shrink tests
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width, $height, null, false, $width, $height, $additional_information), 'Half the width and height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width, $height * 2, null, false, $width, $height, $additional_information), 'Half width, keep height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width * 2, $height, null, false, $width, $height, $additional_information), 'Half height, keep width of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width * 2, $height * 2, null, false, $width * 2, $height * 2, $additional_information), 'Keep the same width and height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width, null, null, false, $width, null, $additional_information), 'Half the width, ignore height of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, null, $height, null, false, null, $height, $additional_information), 'Half the height, ignore width of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, null, null, 16, false, ($width > $height ? 16 : null), ($height > $width ? 16 : null), $additional_information), 'Use box width 16 of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, null, null, 4, false, ($width > $height ? 4 : null), ($height > $width ? 4 : null), $additional_information), 'Use box width 4 of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, null, null, 1, false, ($width > $height ? 1 : null), ($height > $width ? 1 : null), $additional_information), 'Use box width 1 of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);
                $this->assertTrue($this->runDimensionTest(get_file_base() . '/_tests/assets/images/' . $width . 'x' . $height . '.' . $extension, $width, $height, null, true, $width, $height, $additional_information), 'Half the width and height with only make smaller = true of ' . $width * 2 . 'x' . $height * 2 . '.' . $extension . '. ' . $additional_information);

                // TODO: Add test cases for cropping and padding in v11 after refactoring convert_image
            }

            // Edge case: transparency and translucent (50% opacity) tests
            if ($extension === 'png' || $extension === 'gif') { // jpg and jpeg does not support transparency
                $this->assertTrue($this->runTransparencyTest(get_file_base() . '/_tests/assets/images/transparent.' . $extension, 16, 16, 127, $additional_information), 'Increased 8x8 transparent.' . $extension . ' to 16x16 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);
                $this->assertTrue($this->runTransparencyTest(get_file_base() . '/_tests/assets/images/transparent.' . $extension, 8, 8, 127, $additional_information), '8x8 transparent.' . $extension . '. Kept size the same. Tested for transparency on the left side and visible color on the right side. ' . $additional_information);
                $this->assertTrue($this->runTransparencyTest(get_file_base() . '/_tests/assets/images/transparent.' . $extension, 4, 4, 127, $additional_information), 'Decreased 8x8 transparent.' . $extension . ' to 4x4 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);
                if ($extension === 'png') { // Only png supports alpha channel transparency
                    $this->assertTrue($this->runTransparencyTest(get_file_base() . '/_tests/assets/images/translucent.' . $extension, 16, 16, 63, $additional_information), 'Increased 8x8 translucent.' . $extension . ' to 16x16 and tested for 50 percent opacity on the left side and 100 percent opacity on the right side. ' . $additional_information);
                    $this->assertTrue($this->runTransparencyTest(get_file_base() . '/_tests/assets/images/translucent.' . $extension, 8, 8, 63, $additional_information), '8x8 translucent.' . $extension . '. Kept size the same. Tested for 50 percent opacity on the left side and 100 percent opacity on the right side. ' . $additional_information);
                    $this->assertTrue($this->runTransparencyTest(get_file_base() . '/_tests/assets/images/translucent.' . $extension, 4, 4, 63, $additional_information), 'Decreased 8x8 translucent.' . $extension . ' to 4x4 and tested for 50 percent opacity on the left side and 100 percent opacity on the right side. ' . $additional_information);
                }
            }

            // Edge case: Quadrant color test
            $this->assertTrue($this->runQuadrantTest(get_file_base() . '/_tests/assets/images/quadrant.' . $extension, 16, 16, $additional_information), 'Increased 8x8 quadrant.' . $extension . ' to 16x16 and tested for quadrant colors (top->bottom, left->right) red, green, blue, white. ' . $additional_information);
            $this->assertTrue($this->runQuadrantTest(get_file_base() . '/_tests/assets/images/quadrant.' . $extension, 8, 8, $additional_information), '8x8 quadrant.' . $extension . '. Kept size the same. Tested for quadrant colors (top->bottom, left->right) red, green, blue, white. ' . $additional_information);
            //$this->assertTrue($this->runQuadrantTest(get_file_base() . '/_tests/assets/images/quadrant.' . $extension, 4, 4, $additional_information), 'Decreased 8x8 quadrant.' . $extension . ' to 4x4 and tested for quadrant colors (top->bottom, left->right) red, green, blue, white. ' . $additional_information);
        }

        // Edge Case: 8-bit palette-alpha PNG transparency test
        $this->assertTrue($this->runTransparencyTest(get_file_base() . '/_tests/assets/images/transparent_8bit.png', 16, 16, 127, $additional_information), 'Increased 8x8 transparent_8bit.png to 16x16 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);
        $this->assertTrue($this->runTransparencyTest(get_file_base() . '/_tests/assets/images/transparent_8bit.png', 8, 8, 127, $additional_information), '8x8 transparent_8bit.png. Kept size the same. Tested for transparency on the left side and visible color on the right side. ' . $additional_information);
        $this->assertTrue($this->runTransparencyTest(get_file_base() . '/_tests/assets/images/transparent_8bit.png', 4, 4, 127, $additional_information), 'Decreased 8x8 transparent_8bit.png to 4x4 and tested for transparency on the left side and visible color on the right side. ' . $additional_information);

        // Edge Case: EXIF rotation test via dimension test and pixel color test
        $this->assertTrue($this->runEXIFTest(get_file_base() . '/_tests/assets/images/exifrotated.jpg', 4896, 6528, 4896, 6528, 4850, 250, 205, 164, 85, 0, $additional_information), 'exifrotated.jpg EXIF rotation test (size and color). Doubled the original size. ' . $additional_information);
        //$this->assertTrue($this->runEXIFTest(get_file_base() . '/_tests/assets/images/exifrotated.jpg', 2448, 3264, 2448, 3264, 2425, 175, 205, 164, 85, 0, $additional_information), 'ExifRotated.jpg EXIF rotation test (size and color). Kept the original size. ' . $additional_information);
        $this->assertTrue($this->runEXIFTest(get_file_base() . '/_tests/assets/images/exifrotated.jpg', 1224, 1632, 1224, 1632, 1212, 62, 206, 165, 86, 0, $additional_information), 'xxifrotated.jpg EXIF rotation test (size and color). Halved the original size. ' . $additional_information);

        // Edge case: SVG image content tests
        $this->assertTrue($this->runSvgTest(get_file_base() . '/_tests/assets/images/tux.svg', 670, 788, $additional_information), 'tux.svg contents test. Double the original size. ' . $additional_information);
        $this->assertTrue($this->runSvgTest(get_file_base() . '/_tests/assets/images/tux.svg', 335, 394, $additional_information), 'tux.svg contents test. Kept the original size. ' . $additional_information);
        $this->assertTrue($this->runSvgTest(get_file_base() . '/_tests/assets/images/tux.svg', 167, 197, $additional_information), 'tux.svg contents test. Half the original size. ' . $additional_information);
    }

    public function testConvertImagePlus()
    {
        if (($this->only !== null) && ($this->only != 'testConvertImagePlus')) {
            return;
        }
        
        $additional_information = '';
        
        $this->cleanupFromConvertImagePlus();
        
        // Basic box tests
        $this->assertTrue($this->runDimensionTestPlus('https://compo.sr/themes/composr_homesite/images_custom/composr_homesite/composr_full_logo.png', '159x59', 159, 59, 'box', 'both', false, $additional_information), 'convert_image_plus with Composr logo. Box algorithm where = both. 158x59 dimensions. ' . $additional_information);
        $this->assertTrue($this->runDimensionTestPlus('https://compo.sr/themes/composr_homesite/images_custom/composr_homesite/composr_full_logo.png', '159x', 159, 59, 'box', 'both', false, $additional_information), 'convert_image_plus with Composr logo. Box algorithm where = both. 158x dimensions. ' . $additional_information);
        $this->assertTrue($this->runDimensionTestPlus('https://compo.sr/themes/composr_homesite/images_custom/composr_homesite/composr_full_logo.png', 'x59', 59, 22, 'box', 'both', false, $additional_information), 'convert_image_plus with Composr logo. Box algorithm where = both. x59 dimensions. ' . $additional_information);
        $this->assertTrue($this->runDimensionTestPlus('https://compo.sr/themes/composr_homesite/images_custom/composr_homesite/composr_full_logo.png', null, intval(get_option('thumb_width')), null, 'box', 'both', false, $additional_information), 'convert_image_plus with Composr logo. Box algorithm where = both. null dimensions. ' . $additional_information);
        
        // Basic width tests
        $this->assertTrue($this->runDimensionTestPlus('https://compo.sr/themes/composr_homesite/images_custom/composr_homesite/composr_full_logo.png', '480x', 480, null, 'box', 'width', false, $additional_information), 'convert_image_plus with Composr logo. Width algorithm where = both. 480x dimensions. ' . $additional_information);
        $this->assertTrue($this->runDimensionTestPlus('https://compo.sr/themes/composr_homesite/images_custom/composr_homesite/composr_full_logo.png', 'x360', 360, 135, 'box', 'height', false, $additional_information), 'convert_image_plus with Composr logo. Height algorithm where = both. x360 dimensions. ' . $additional_information);

        $this->cleanupFromConvertImagePlus();
    }

    protected function cleanupFromConvertImagePlus()
    {
        $dh = opendir(get_custom_file_base() . '/temp');
        if ($dh !== false) {
            while (($file = readdir($dh)) !== false) {
                if (substr($file, -4) == '.png') {
                    unlink(get_custom_file_base() . '/temp/' . $file);
                }
            }
            closedir($dh);
        }
    }
}

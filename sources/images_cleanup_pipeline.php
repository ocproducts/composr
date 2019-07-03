<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__images_cleanup_pipeline()
{
    if (!defined('IMG_OP__ADJUST_ORIENTATION')) {
        define('IMG_OP__NONE', 0);
        define('IMG_OP__ADJUST_ORIENTATION', 1);
        define('IMG_OP__STRIP_GAMMA', 2);
        define('IMG_OP__CONSTRAIN_DIMENSIONS', 4);
        define('IMG_OP__RECOMPRESS_LOSSLESS', 8);
        define('IMG_OP__RECOMPRESS_LOSSY', 16);
        define('IMG_OP__WATERMARK', 32);

        define('IMG_RECOMPRESS_NONE', 0);
        define('IMG_RECOMPRESS_LOSSLESS', 1);
        define('IMG_RECOMPRESS_LOSSY', 2);
    }

    require_code('images');
    require_code('images2');
}

/**
 * Cleanup an image to make it web-appropriate.
 * This code is intentionally cowardly - it will just silently return if there are errors.
 *
 * @param  PATH $path The image path
 * @param  ?ID_TEXT $filename The image filename (null: get from path)
 * @param  integer $recompress_mode How to recompress, an IMG_RECOMPRESS_* constant
 * @param  ?integer $maximum_dimension The size of the bounding box (null: none)
 * @param  ?array $watermarks Watermark corners (top-left, top-right, bottom-left, bottom-right) (null: none)
 */
function handle_images_cleanup_pipeline($path, $filename = null, $recompress_mode = 1, $maximum_dimension = null, $watermarks = null)
{
    disable_php_memory_limit();
    if (!check_memory_limit_for($path, false)) {
        return;
    }

    if (!function_exists('imagecreatefromstring')) {
        return;
    }

    if ($filename === null) {
        $filename = basename($path);
    }

    if (!is_image($filename, IMAGE_CRITERIA_GD_READ | IMAGE_CRITERIA_GD_WRITE)) {
        return;
    }

    $ext = get_file_extension($filename);

    $ops = IMG_OP__NONE;

    if (($ext == 'jpg') || ($ext == 'jpeg')) {
        if (get_option('repair_images') == '1') {
            $ops = $ops | IMG_OP__ADJUST_ORIENTATION;
        }
    }

    if (($ext == 'jpg') || ($ext == 'jpeg') || ($ext == 'webp')) {
        if (($recompress_mode & IMG_RECOMPRESS_LOSSY) != 0) {
            $ops = $ops | IMG_OP__RECOMPRESS_LOSSY;
        }
    }

    if ($ext == 'png') {
        if (get_option('repair_images') == '1') {
            $ops = $ops | IMG_OP__STRIP_GAMMA;
        }
    }

    if (($ext == 'png') || ($ext == 'gif')) {
        if (get_option('repair_images') == '1') { // Will happen anyway if re-saving, but don't promote re-saving for no reason if repair_images is not enabled
            if ($recompress_mode != IMG_RECOMPRESS_NONE) {
                $ops = $ops | IMG_OP__RECOMPRESS_LOSSLESS;
            }
        }
    }

    if ($maximum_dimension !== null) {
        $image_size = cms_getimagesize($path);
        if ($image_size === false) {
            return;
        }
        list($width, $height) = $image_size;
        if ($width === null) {
            return;
        }
        if ($height === null) {
            return;
        }

        if (($width > $maximum_dimension) || ($height > $maximum_dimension)) {
            $ops = $ops | IMG_OP__CONSTRAIN_DIMENSIONS;
        }
    }

    if (($watermarks !== null) && (addon_installed('galleries'))) {
        $ops = $ops | IMG_OP__WATERMARK;
    }

    if ($ops == IMG_OP__NONE) {
        return;
    }

    $c = @cms_file_get_contents_safe($path);
    if ($c === false) {
        return;
    }

    if (is_animated_image($c, $ext)) {
        return;
    }

    $image = cms_imagecreatefromstring($c, $ext);
    if ($image === false) {
        return;
    }

    $made_change = false;

    if (($ops & IMG_OP__ADJUST_ORIENTATION) != 0) {
        $exif = function_exists('exif_read_data') ? @exif_read_data($path) : false;

        $result = adjust_pic_orientation($image, $exif);
        $image = $result[0];
        $reorientated = $result[1];
        $made_change = $made_change || $result[1];
    } else {
        $reorientated = false;
    }

    if (($ops & IMG_OP__STRIP_GAMMA) != 0) {
        $made_change = true; // Just re-saving will do what we want
    }

    if (($ops & IMG_OP__RECOMPRESS_LOSSLESS) != 0) {
        if (($ext == 'png') || ($ext == 'gif')) {
            $made_change = true; // Just re-saving will do what we want
        }
    }

    if (($ops & IMG_OP__RECOMPRESS_LOSSY) != 0) {
        $made_change = true; // Just re-saving will do what we want
    }

    if (($ops & IMG_OP__CONSTRAIN_DIMENSIONS) != 0) {
        $result = adjust_pic_size($image, $maximum_dimension);
        $image = $result[0];
        $made_change = $made_change || $result[1];
    }

    if (($ops & IMG_OP__WATERMARK) != 0) {
        $result = add_pic_watermarking($image, $watermarks);
        $image = $result[0];
        $made_change = $made_change || $result[1];
    }

    // Save
    if ($made_change) {
        $tmp_path = cms_tempnam();

        $test = cms_imagesave($image, $tmp_path, $ext, ($ops & IMG_OP__RECOMPRESS_LOSSY) != 0);

        if ($test) {
            if (($ext == 'jpg') || ($ext == 'jpeg')) {
                copy_exif_data($path, $tmp_path, $reorientated);
            }

            @unlink($path) or intelligent_write_error($path);
            @rename($tmp_path, $path) or intelligent_write_error($path);

            if ($test) {
                sync_file($path);
                fix_permissions($path);
            }
        }
    }

    // Clean up
    imagedestroy($image);
}

/**
 * Whether an image file is animated.
 *
 * @param  string $c Image data
 * @param  string $ext Image extension
 * @return boolean Whether it is animated
 */
function is_animated_image($c, $ext)
{
    if ($ext == 'png') {
        $idat_pos = strpos($c, 'IDAT');
        if (($idat_pos !== false) && (strpos(substr($c, 0, $idat_pos), 'acTL') !== false)) {
            // It's an APNG, we cannot mess with it
            return true;
        }
    }

    if ($ext == 'gif') {
        $str_loc = 0;
        $count = 0;
        while ($count < 2) // There is no point in continuing after we find a 2nd frame
        {
            $where1 = strpos($c, "\x00\x21\xF9\x04", $str_loc);
            if ($where1 === false) {
                break;
            }
            else {
                $str_loc = $where1 + 1;
                $where2 = strpos($c, "\x00\x2C", $str_loc);
                if ($where2 === false) {
                    break;
                } else {
                    if ($where1 + 8 == $where2) {
                        $count++;
                    }
                    $str_loc = $where2 + 1;
                }
            }
        }
        if ($count > 1) {
            // It's an animated gif, we cannot mess with it
            return  true;
        }
    }

    return false;
}

/**
 * Adjust an image to take into account EXIF rotation.
 *
 * Based on a comment in:
 * http://stackoverflow.com/questions/3657023/how-to-detect-shot-angle-of-photo-and-auto-rotate-for-website-display-like-desk.
 *
 * @param  resource $image GD image resource
 * @param  ~array $exif EXIF details (false: could not load)
 * @return array A pair: Adjusted GD image resource, Whether a change was made
 */
function adjust_pic_orientation($image, $exif)
{
    if ((function_exists('imagerotate')) && ($exif !== false) && (isset($exif['Orientation']))) {
        $orientation = $exif['Orientation'];
        if ($orientation != 1) {
            $mirror = false;
            $deg = 0;

            switch ($orientation) {
                case 2:
                    $mirror = true;
                    break;
                case 3:
                    $deg = 180;
                    break;
                case 4:
                    $deg = 180;
                    $mirror = true;
                    break;
                case 5:
                    $deg = 270;
                    $mirror = true;
                    break;
                case 6:
                    $deg = 270;
                    break;
                case 7:
                    $deg = 90;
                    $mirror = true;
                    break;
                case 8:
                    $deg = 90;
                    break;
            }

            if ($deg != 0) {
                $dest = imagerotate($image, floatval($deg), 0);
                imagedestroy($image);
                $image = $dest;
            }

            if ($mirror) {
                imagepalettetotruecolor($image);

                $width = imagesx($image);
                $height = imagesy($image);

                $src_x = $width - 1;
                $src_y = 0;
                $src_width = -$width;
                $src_height = $height;

                $dest = imagecreatetruecolor($width, $height);
                imagealphablending($dest, false);
                if (function_exists('imagesavealpha')) {
                    imagesavealpha($dest, true);
                }

                if (imagecopyresampled($dest, $image, 0, 0, $src_x, $src_y, $width, $height, $src_width, $src_height)) {
                    imagedestroy($image);
                    $image = $dest;
                }
            }

            return array($image, true);
        }
    }
    return array($image, false);
}

/**
 * Adjust an image to a maximum bounding box size.
 *
 * @param  resource $image GD image resource
 * @param  integer $maximum_dimension The size of the bounding box
 * @return array A pair: Adjusted GD image resource, Whether a change was made
 */
function adjust_pic_size($image, $maximum_dimension)
{
    $width = imagesx($image);
    $height = imagesy($image);

    if (($width < $maximum_dimension) && ($height < $maximum_dimension)) {
        return array($image, false);
    }

    if ($width > $height) {
        // Scale so width is $maximum_dimension
        $_width = $maximum_dimension;
        $_height = intval($maximum_dimension * (floatval($height) / floatval($width)));
    } else {
        // Scale so height is $maximum_dimension
        $_width = intval($maximum_dimension * (floatval($width) / floatval($height)));
        $_height = $maximum_dimension;
    }

    imagepalettetotruecolor($image);

    $dest = imagecreatetruecolor($_width, $_height);
    imagealphablending($dest, false);
    if (function_exists('imagesavealpha')) {
        imagesavealpha($dest, true);
    }

    imagecopyresampled($dest, $image, 0, 0, 0, 0, $_width, $_height, $width, $height);

    imagedestroy($image);
    $image = $dest;

    return array($image, true);
}

/**
 * Add image watermarking.
 *
 * @param  resource $image GD image resource
 * @param  array $watermarks Watermark corners (top-left, top-right, bottom-left, bottom-right)
 * @return array A pair: Adjusted GD image resource, Whether a change was made
 */
function add_pic_watermarking($image, $watermarks)
{
    if (!addon_installed('galleries')) {
        return array($image, false);
    }

    require_code('galleries2');

    $made_change = false;

    list($watermark_top_left, $watermark_top_right, $watermark_bottom_left, $watermark_bottom_right) = $watermarks;

    if (!empty($watermark_top_left)) {
        _watermark_corner($image, $watermark_top_left, 0, 0);
        $made_change = true;
    }
    if (!empty($watermark_top_right)) {
        _watermark_corner($image, $watermark_top_right, 1, 0);
        $made_change = true;
    }
    if (!empty($watermark_bottom_left)) {
        _watermark_corner($image, $watermark_bottom_left, 0, 1);
        $made_change = true;
    }
    if (!empty($watermark_bottom_right)) {
        _watermark_corner($image, $watermark_bottom_right, 1, 1);
        $made_change = true;
    }

    return array($image, $made_change);
}

/**
 * Copy EXIF data from one file to another.
 *
 * @param  PATH $src_path File to copy from
 * @param  PATH $dest_path File to copy to (must exist!)
 * @param  boolean $reorientated Whether we did a reorientation and thus need to throw out the reorientation header
 * @return boolean Success status
 */
function copy_exif_data($src_path, $dest_path, $reorientated = false)
{
    // Function transfers EXIF (APP1) and IPTC (APP13) from $src_path and adds it to $dest_path
    // JPEG file has format 0xFFD8 + [APP0] + [APP1] + ... [APP15] + <image data> where [APPi] are optional
    // Segment APPi (where i=0x0 to 0xF) has format 0xFFEi + 0xMM + 0xLL + <data> (where 0xMM is
    //   most significant 8 bits of (strlen(<data>) + 2) and 0xLL is the least significant 8 bits
    //   of (strlen(<data>) + 2)

    if (!function_exists('getimagesize')) {
        return false;
    }

    $image_info = array();
    @getimagesize($src_path, $image_info);

    // Prepare EXIF data bytes from source file
    $exif_data = (is_array($image_info) && array_key_exists('APP1', $image_info)) ? $image_info['APP1'] : null;
    if ($exif_data !== null) {
        $exif_length = strlen($exif_data) + 2;
        if ($exif_length > 0xFFFF) {
            return false; // More than maximum data, we suspect an error
        }

        if ($reorientated) {
            // We need to strip the orientation tag...

            // (https://www.media.mit.edu/pia/Research/deepview/exif.html)

            $ok_still = true;

            $exif_data_offset = 6; // Exif then 0x0000

            $u = unpack('n', substr($exif_data, $exif_data_offset, 2));
            $little_endian = ($u[1] == 0x4949);
            $exif_data_offset += 2;

            // (0x002A always)
            $exif_data_offset += 2;

            $u = unpack($little_endian ? 'V' : 'N', substr($exif_data, $exif_data_offset, 4));
            $exif_data_offset += $u[1] - 4/*because offset includes the previous 4 bytes before the offset*/;

            $u = unpack($little_endian ? 'v' : 'n', substr($exif_data, $exif_data_offset, 2));
            $num_tags = $u[1];
            $exif_data_offset += 2;

            // Go through the 'directory'
            $_exif_data = substr($exif_data, 0, $exif_data_offset);
            for ($i = 0; $i < $num_tags; $i++) {
                $next_dir_entry = substr($exif_data, $exif_data_offset + ($i * 12), 2);
                if (strlen($next_dir_entry) < 2) {
                    $ok_still = false;
                }
                $u = unpack($little_endian ? 'v' : 'n', $next_dir_entry);
                if ($u[1] != 0x0112) {
                    $_exif_data .= substr($exif_data, $exif_data_offset + ($i * 12), 12);
                } else { // Mangle it to an unknown tag (fffe) so it won't be read as orientation (removing the tag would be hard, we'd need to rewrite all offsets)
                    $_exif_data .= hex2bin('fffe') . substr($exif_data, $exif_data_offset + ($i * 12) + 2, 10);
                }
            }

            if ($ok_still) {
                $_exif_data .= substr($exif_data, $exif_data_offset + ($i * 12)); // Anything left over
                $exif_data = $_exif_data;
            }
        }

        // Construct EXIF segment
        $exif_data = chr(0xFF) . chr(0xE1) . chr(($exif_length >> 8) & 0xFF) . chr($exif_length & 0xFF) . $exif_data;
    }

    // Prepare IPTC data bytes from source file
    $iptc_data = (is_array($image_info) && array_key_exists('APP13', $image_info)) ? $image_info['APP13'] : null;
    if ($iptc_data !== null) {
        $iptc_length = strlen($iptc_data) + 2;
        if ($iptc_length > 0xFFFF) {
            return false; // More than maximum data, we suspect an error
        }

        // Construct IPTC segment
        $iptc_data = chr(0xFF) . chr(0xED) . chr(($iptc_length >> 8) & 0xFF) . chr($iptc_length & 0xFF) . $iptc_data;
    }

    $existing_content = @cms_file_get_contents_safe($dest_path);
    if ($existing_content === false) {
        return false;
    }
    if (strlen($existing_content) == 0) {
        return false;
    }

    $header_content = substr($existing_content, 0, 2);
    $chunks_to_save = ''; // Variable accumulates new & original metadata segments
    $existing_content = substr($existing_content, 2); // Contains pre-existing chunks; keeps getting segments removed from the front, until it just contains trailing data

    $exif_already_added = ($exif_data === null);
    $iptc_already_added = ($iptc_data === null);

    while ((cms_unpack_to_uinteger(substr($existing_content, 0, 2)) & 0xFFF0) === 0xFFE0) {
        $segment_len = (cms_unpack_to_uinteger(substr($existing_content, 2, 2)) & 0xFFFF);
        $segment_number = (cms_unpack_to_uinteger(substr($existing_content, 1, 1)) & 0x0F); // Last 4 bits of second byte is metadata segment number
        if ($segment_len <= 2) {
            return false; // Error
        }

        $this_existing_segment = substr($existing_content, 0, $segment_len + 2);

        if (($segment_number >= 1) && (!$exif_already_added)) {
            // Chunks should be in order, EXIF goes here
            $chunks_to_save .= $exif_data;
            $exif_already_added = true;
            if (($segment_number === 1) && ($exif_data !== null)) { // We already got a new EXIF chunk for this from getimagesize(), so don't mark to add
                $this_existing_segment = '';
            }
        }

        if (($segment_number >= 13) && (!$iptc_already_added)) {
            // Chunks should be in order, IPTC goes here
            $chunks_to_save .= $iptc_data;
            $iptc_already_added = true;
            if (($segment_number === 13) && ($iptc_data !== null)) { // We already got a new IPTC chunk for this from getimagesize(), so don't mark to add
                $this_existing_segment = '';
            }
        }

        $chunks_to_save .= $this_existing_segment; // Copy chunk through

        $existing_content = substr($existing_content, $segment_len + 2);
    }

    if (!$exif_already_added) { // Add EXIF data if not added already
        $chunks_to_save .= $exif_data;
    }
    if (!$iptc_already_added) { // Add IPTC data if not added already
        $chunks_to_save .= $iptc_data;
    }

    $trailing_content = $existing_content;

    cms_file_put_contents_safe($dest_path, $header_content . $chunks_to_save . $trailing_content, FILE_WRITE_SYNC_FILE | FILE_WRITE_FIX_PERMISSIONS);

    return true;
}

/**
 * Try to further compress a PNG file, via palette tricks and maximum gzip compression.
 *
 * @param  PATH $path File path
 * @param  boolean $lossy Whether to do a lossy convert
 */
function png_compress($path, $lossy = false)
{
    if (!is_file($path)) {
        return;
    }

    $img = cms_imagecreatefrom($path, 'png');
    if ($img === false) {
        return; // Error, e.g. "is not a valid PNG file"
    }
    if (!imageistruecolor($img)) {
        if (function_exists('imagepalettetotruecolor')) {
            imagepalettetotruecolor($img);
        } else {
            imagedestroy($img);
            return;
        }
    }

    // Has alpha?
    $width = imagesx($img);
    $height = imagesy($img);
    $has_alpha = false;
    for ($y = 0; $y < $height; $y++) {
        for ($x = 0; $x < $width; $x++) {
            $at = imagecolorat($img, $x, $y);
            $parsed_colour = imagecolorsforindex($img, $at);
            if ((isset($parsed_colour['alpha'])) && ($parsed_colour['alpha'] != 0)) {
                $has_alpha = true;
                if ($parsed_colour['alpha'] != 127) {
                    // Blended alpha, cannot handle as anything other than a proper 32-bit PNG
                    imagedestroy($img);
                    return;
                }
            }
        }
    }

    // Produce JPEG version, if relevant
    $trying_jpeg = (!$has_alpha) && ($lossy) && (get_value('save_jpegs_as_png') === '1');
    if ($trying_jpeg) {
        imagejpeg($img, $path . '.jpeg_tmp', intval(get_option('jpeg_quality'))); // We will ultimately save as a .png which is actually the JPEG. We rely on Composr, and browsers, doing their magic detection of images (not just relying on mime types)
        $jpeg_size = filesize($path . '.jpeg_tmp');
    }

    // Check we don't have too many colours for 8-bit
    $colours = array();
    for ($y = 0; $y < $height; $y++) {
        for ($x = 0; $x < $width; $x++) {
            $at = imagecolorat($img, $x, $y);
            if ($lossy) {
                $at = $at & ~bindec('00001111' . '00001111' . '00001111' . '00111111'); // Reduce to a colour resolution of 16 distinct values on each of RGB, and 4 on A
            }
            $colours[$at] = true;
            if (count($colours) > 300) { // Give some grace, but >300 is unworkable (at least 44 too many)
                // Too many colours for 8-bit...

                // Try as a JPEG?
                if ($trying_jpeg) {
                    $png_size = filesize($path);
                    if ($jpeg_size < $png_size) {
                        unlink($path);
                        rename($path . '.jpeg_tmp', $path);
                    } else {
                        unlink($path . '.jpeg_tmp');
                    }
                }

                // Return
                imagedestroy($img);
                return;
            }
        }
    }

    // Try as 8-bit...

    if ($has_alpha) {
        $alphabg = imagecolorallocate($img, 255, 0, 255);
        imagecolortransparent($img, $alphabg);
        for ($y = 0; $y < $height; $y++) {
            for ($x = 0; $x < $width; $x++) {
                $at = imagecolorat($img, $x, $y);
                $parsed_colour = imagecolorsforindex($img, $at);
                if ((isset($parsed_colour['alpha'])) && ($parsed_colour['alpha'] != 0)) {
                    imagesetpixel($img, $x, $y, $alphabg);
                }
            }
        }
    }

    imagetruecolortopalette($img, true, 256);

    imagesavealpha($img, false); // No alpha, only transparency

    imagepng($img, $path, 9);

    if ($trying_jpeg) {
        $png_size = filesize($path); // Find size of 8-bit PNG
        if ($jpeg_size < $png_size) {
            unlink($path);
            rename($path . '.jpeg_tmp', $path);
        } else {
            unlink($path . '.jpeg_tmp');
        }
    }

    fix_permissions($path);
    sync_file($path);

    imagedestroy($img);
}

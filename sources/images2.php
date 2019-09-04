<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/*EXTRA FUNCTIONS: shell_exec*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/**
 * (Helper for ensure_thumbnail).
 *
 * @param  URLPATH $full_url The full URL to the image which will-be/is thumbnailed
 * @param  URLPATH $thumb_url The URL to the thumbnail (blank: no thumbnail yet)
 * @param  ID_TEXT $thumb_dir The directory, relative to the Composr install's uploads directory, where the thumbnails are stored. MINUS "_thumbs"
 * @param  ID_TEXT $table The name of the table that is storing what we are doing the thumbnail for
 * @param  AUTO_LINK $id The ID of the table record that is storing what we are doing the thumbnail for
 * @param  ID_TEXT $thumb_field_name The name of the table field where thumbnails are saved
 * @param  ?integer $thumb_width The thumbnail width to use (null: default)
 * @param  boolean $only_make_smaller Whether to apply a 'never make the image bigger' rule for thumbnail creation (would affect very small images)
 * @return URLPATH The URL to the thumbnail
 */
function _ensure_thumbnail($full_url, $thumb_url, $thumb_dir, $table, $id, $thumb_field_name = 'thumb_url', $thumb_width = null, $only_make_smaller = false)
{
    if ($thumb_width === null) {
        $thumb_width = intval(get_option('thumb_width'));
    }

    // Create new path
    $url_parts = explode('/', $full_url);
    $i = 0;
    $_file = $url_parts[count($url_parts) - 1];
    $dot_pos = strrpos($_file, '.');
    $ext = substr($_file, $dot_pos + 1);
    if ((!is_saveable_image($_file)) && (get_file_extension($_file) != 'svg')) {
        $ext .= '.png';
    }
    $_file = preg_replace('#[^\w]#', 'x', substr($_file, 0, $dot_pos));
    $thumb_path = '';
    do {
        $file = rawurldecode($_file) . (($i == 0) ? '' : ('_' . strval($i)));
        $thumb_path = get_custom_file_base() . '/uploads/' . $thumb_dir . '_thumbs/' . $file . '.' . $ext;
        $i++;
    } while (file_exists($thumb_path));
    if (@file_put_contents($thumb_path, '') === false) { // Lock it in ASAP, to stop race conditions
        intelligent_write_error($thumb_path);
    }
    sync_file($thumb_path);
    $thumb_url = cms_rawurlrecode('uploads/' . $thumb_dir . '_thumbs/' . rawurlencode($file) . '.' . $ext);
    if ((substr($table, 0, 2) == 'f_') && (get_forum_type() == 'cns')) {
        $GLOBALS['FORUM_DB']->query_update($table, array($thumb_field_name => $thumb_url), array('id' => $id), '', 1);
    } else {
        $GLOBALS['SITE_DB']->query_update($table, array($thumb_field_name => $thumb_url), array('id' => $id), '', 1);
    }

    $from = str_replace(' ', '%20', $full_url);
    if (url_is_local($from)) {
        $from = get_custom_base_url() . '/' . $from;
    }
    if (is_video($from, false, true)) {
        if (addon_installed('galleries')) {
            require_code('galleries2');
            create_video_thumb($full_url, $thumb_path);
        }
    } else {
        convert_image($from, $thumb_path, -1, -1, intval($thumb_width), false);
        if (!file_exists($thumb_path) && file_exists($thumb_path . '.png'/*convert_image maybe had to change the extension*/)) {
            $thumb_url .= '.png';
        }
    }

    return get_custom_base_url() . '/' . $thumb_url;
}

/**
 * (Helper for convert_image).
 *
 * @param  string $from The URL to the image to resize. May be either relative or absolute. If $using_path is set it is actually a path
 * @param  PATH $to The file path (including filename) to where the resized image will be saved
 * @param  integer $width The maximum width we want our new image to be (-1 means "don't factor this in")
 * @param  integer $height The maximum height we want our new image to be (-1 means "don't factor this in")
 * @param  integer $box_width This is only considered if both $width and $height are -1. If set, it will fit the image to a box of this dimension (suited for resizing both landscape and portraits fairly)
 * @param  boolean $exit_on_error Whether to exit Composr if an error occurs
 * @param  ?string $ext2 The file extension to save with (null: same as our input file)
 * @param  boolean $using_path Whether $from was in fact a path, not a URL
 * @param  boolean $only_make_smaller Whether to apply a 'never make the image bigger' rule for thumbnail creation (would affect very small images)
 * @param  ?array $thumb_options This optional parameter allows us to specify cropping or padding for the image. See comments in the function. (null: no details passed)
 * @return boolean Success
 *
 * @ignore
 */
function _convert_image($from, $to, $width, $height, $box_width = -1, $exit_on_error = true, $ext2 = null, $using_path = false, $only_make_smaller = false, $thumb_options = null)
{
    disable_php_memory_limit();

    if (!file_exists(dirname($to))) {
        require_code('files2');
        make_missing_directory(dirname($to));
    }

    // Load
    $ext = get_file_extension($from);
    if ($using_path) {
        if ((!check_memory_limit_for($from, $exit_on_error)) || ($ext == 'svg'/*SVG is pass-through*/)) {
            if ($using_path) {
                copy($from, $to);
                fix_permissions($to);
                sync_file($to);
            }
            return true;
        }
        $from_file = @cms_file_get_contents_safe($from);
        $exif = function_exists('exif_read_data') ? @exif_read_data($from) : false;
    } else {
        $file_path_stub = convert_url_to_path($from);
        if (!is_null($file_path_stub)) {
            if ((!check_memory_limit_for($from, $exit_on_error)) || ($ext == 'svg'/*SVG is pass-through*/)) {
                if ($using_path) {
                    copy($file_path_stub, $to);
                    fix_permissions($to);
                    sync_file($to);
                }
                return true;
            }
            $from_file = @cms_file_get_contents_safe($file_path_stub);
            $exif = function_exists('exif_read_data') ? @exif_read_data($file_path_stub) : false;
        } else {
            $from_file = http_download_file($from, 1024 * 1024 * 20/*reasonable limit*/, false);
            if (is_null($from_file)) {
                $from_file = false;
                $exif = false;
            } else {
                require_code('files');
                cms_file_put_contents_safe($to, $from_file, FILE_WRITE_FIX_PERMISSIONS | FILE_WRITE_SYNC_FILE);
                $exif = function_exists('exif_read_data') ? @exif_read_data($to) : false;
                if ($ext == 'svg') { // SVG is pass-through
                    return true;
                }
            }
        }
    }
    if ($from_file === false) {
        if ($exit_on_error) {
            warn_exit(do_lang_tempcode('CANNOT_ACCESS_URL', escape_html($from)));
        }
        require_code('site');
        if (get_value('no_cannot_access_url_messages') !== '1') {
            attach_message(do_lang_tempcode('CANNOT_ACCESS_URL', escape_html($from)), 'warn');
        }
        return false;
    }

    $source = cms_imagecreatefromstring($from_file, $ext);
    if ($source === false) {
        if ($exit_on_error) {
            warn_exit(do_lang_tempcode('CORRUPT_FILE', escape_html($from)));
        }
        require_code('site');
        attach_message(do_lang_tempcode('CORRUPT_FILE', escape_html($from)), 'warn');
        return false;
    }

    // We need to do some specific cleanup. Most of the other pipeline cleanup will automatically happen during the thumbnailing process (and probably have already run for the source image anyway)
    require_code('images_cleanup_pipeline');
    list($source, $reorientated) = adjust_pic_orientation($source, $exif);

    //$source = remove_white_edges($source);    Not currently enabled, as PHP seems to have problems with alpha transparency reading

    // Derive actual width x height, for the given maximum box (maintain aspect ratio)
    // ===============================================================================
    $sx = imagesx($source);
    $sy = imagesy($source);

    // The typical case is to copy the full image from source to destination (PHP may be doing scaling, but that's irrelevant to this)
    $copy_width = $sx;
    $copy_height = $sy;

    $red = null;

    if (is_null($thumb_options)) {
        if ($width === 0) {
            $width = 1;
        }
        if ($height === 0) {
            $height = 1;
        }

        // If we're not sure if this is gonna stretch to fit a width or stretch to fit a height
        if (($width == -1) && ($height == -1)) {
            if ($sx > $sy) {
                $width = $box_width;
            } else {
                $height = $box_width;
            }
        }

        if (($width != -1) && ($height != -1)) {
            if ((floatval($sx) / floatval($width)) > (floatval($sy) / floatval($height))) {
                $_width = $width;
                $_height = intval($sy * ($width / $sx));
            } else {
                $_height = $height;
                $_width = intval($sx * ($height / $sy));
            }
        } elseif ($height == -1) {
            $_width = $width;
            $_height = intval($width / ($sx / $sy));
        } elseif ($width == -1) {
            $_height = $height;
            $_width = intval($height / ($sy / $sx));
        }
        if (($_width >= $sx) && ($only_make_smaller)) {
            $_width = $sx;
            $_height = $sy;

            if (!$reorientated) {
                // We can just escape, nothing to do...

                imagedestroy($source);

                if (($using_path) && ($from == $to)) {
                    return true;
                }

                if ($using_path) {
                    copy($from, $to);
                    fix_permissions($to);
                    sync_file($to);
                } else {
                    require_code('files');
                    cms_file_put_contents_safe($to, $from_file, FILE_WRITE_FIX_PERMISSIONS | FILE_WRITE_SYNC_FILE);
                }
                return true;
            }
        }
        if ($_width < 1) {
            $_width = 1;
        }
        if ($_height < 1) {
            $_height = 1;
        }

        // Pad out options for imagecopyresized
        // $dst_im,$src_im,$dst_x,$dst_y,$src_x,$src_y,$dst_w,$dst_h,$src_w,$src_h
        $dest_x = 0;
        $dest_y = 0;
        $source_x = 0;
        $source_y = 0;
    } else {
        // Thumbnail-specific (for the moment) behaviour. We require the ability
        // to crop (ie. window-off a section of the image), and pad (ie. provide a
        // background around the image). We keep this separate to the above code
        // because that already works well across various aspects of the site.
        //
        // Format of the array is 'type'=>'crop' or 'type'=>'pad'; 'where'=>'end',
        // 'where'=>'start' or 'where'=>'both'. For padding, there is an optional
        // 'background'=>'RRGGBBAA' or 'background'=>'RRGGBB' for colored padding
        // with or without transparency.

        // Grab the dimensions we would get if we didn't crop or scale
        $wrong_x = intval(round(floatval($sx) / $thumb_options['scale']));
        $wrong_y = intval(round(floatval($sy) / $thumb_options['scale']));

        // Handle cropping here
        if ($thumb_options['type'] == 'crop') {
            // See which direction we're cropping in
            if (intval(round(floatval($sx) / $thumb_options['scale'])) != $width) {
                $crop_direction = 'x';
            } else {
                $crop_direction = 'y';
            }
            // We definitely have to crop, since symbols.php only tells us to crop
            // if it has to. Thus we know we're going to fill the output image, the
            // only question is with what part of the source image?

            // Get the amount we'll lose from the source
            if ($crop_direction == 'x') {
                $crop_off = intval(($sx - ($width * $thumb_options['scale'])));
            } elseif ($crop_direction == 'y') {
                $crop_off = intval(($sy - ($height * $thumb_options['scale'])));
            }

            // Now we see how much to chop off the start (we don't care about the
            // end, as this will be handled by using an appropriate window size)
            $displacement = 0;
            if (($thumb_options['where'] == 'start') || (($thumb_options['where'] == 'start_if_vertical') && ($crop_direction == 'y')) || (($thumb_options['where'] == 'start_if_horizontal') && ($crop_direction == 'x'))) {
                $displacement = 0;
            } elseif (($thumb_options['where'] == 'end') || (($thumb_options['where'] == 'end_if_vertical') && ($crop_direction == 'y')) || (($thumb_options['where'] == 'end_if_horizontal') && ($crop_direction == 'x'))) {
                $displacement = intval(floatval($crop_off));
            } else {
                $displacement = intval(floatval($crop_off) / 2.0);
            }

            // Now we convert this to the right x and y start locations for the
            // window
            $source_x = ($crop_direction == 'x') ? $displacement : 0;
            $source_y = ($crop_direction == 'y') ? $displacement : 0;

            // Now we set the width and height of our window, which will be scaled
            // versions of the width and height of the output
            $sx = intval(($width * $thumb_options['scale']));
            $sy = intval(($height * $thumb_options['scale']));

            $copy_width = intval(($width * $thumb_options['scale_to']));
            $copy_height = intval(($height * $thumb_options['scale_to']));

            // We start at the origin of our output
            $dest_x = 0;
            $dest_y = 0;

            // and it is always the full size it can be (or else we'd be cropping
            // too much)
            $_width = $width;
            $_height = $height;
        } elseif ($thumb_options['type'] == 'pad') {
            // Padding code lives here. We definitely need to pad some excess space
            // because otherwise symbols.php would not call us. Thus we need a
            // background (can be transparent). Let's see if we've been given one.
            if (array_key_exists('background', $thumb_options) && !is_null($thumb_options['background'])) {
                if (substr($thumb_options['background'], 0, 1) == '#') {
                    $thumb_options['background'] = substr($thumb_options['background'], 1);
                }

                // We've been given a background, let's find out what it is
                if (strlen($thumb_options['background']) == 8) {
                    // We've got an alpha channel
                    $using_alpha = true;
                    $red_str = substr($thumb_options['background'], 0, 2);
                    $green_str = substr($thumb_options['background'], 2, 2);
                    $blue_str = substr($thumb_options['background'], 4, 2);
                    $alpha_str = substr($thumb_options['background'], 6, 2);
                } else {
                    // We've not got an alpha channel
                    $using_alpha = false;
                    $red_str = substr($thumb_options['background'], 0, 2);
                    $green_str = substr($thumb_options['background'], 2, 2);
                    $blue_str = substr($thumb_options['background'], 4, 2);
                }
                $red = intval($red_str, 16);
                $green = intval($green_str, 16);
                $blue = intval($blue_str, 16);
                if ($using_alpha) {
                    $alpha = intval($alpha_str, 16);
                }
            } else {
                // We've not got a background, so let's find a representative color
                // for the image by resampling the whole thing to 1 pixel.
                $temp_img = imagecreatetruecolor(1, 1);        // Make an image to map on to
                imagecopyresampled($temp_img, $source, 0, 0, 0, 0, 1, 1, $sx, $sy);        // Map the source image on to the 1x1 image
                $rgb_index = imagecolorat($temp_img, 0, 0);        // Grab the color index of the single pixel
                $rgb_array = imagecolorsforindex($temp_img, $rgb_index);        // Get the channels for it
                $red = $rgb_array['red'];        // Grab the red
                $green = $rgb_array['green'];        // Grab the green
                $blue = $rgb_array['blue'];        // Grab the blue

                // Sort out if we're using alpha
                $using_alpha = ((array_key_exists('alpha', $rgb_array)) && ($rgb_array['alpha'] > 0));
                if ($using_alpha) {
                    $alpha = 255 - ($rgb_array['alpha'] * 2 + 1);
                }

                // Destroy the temporary image
                imagedestroy($temp_img);
            }

            // Now we need to work out how much padding we're giving, and where

            // The axis
            if (intval(round(floatval($sx) / $thumb_options['scale'])) != $width) {
                $pad_axis = 'x';
            } else {
                $pad_axis = 'y';
            }

            // The amount
            if ($pad_axis == 'x') {
                $padding = intval(round(floatval($width) - (floatval($sx) / $thumb_options['scale'])));
            } else {
                $padding = intval(round(floatval($height) - (floatval($sy) / $thumb_options['scale'])));
            }

            // The distribution
            if (($thumb_options['where'] == 'start') || (($thumb_options['where'] == 'start_if_vertical') && ($pad_axis == 'y')) || (($thumb_options['where'] == 'start_if_horizontal') && ($pad_axis == 'x'))) {
                $pad_amount = 0;
            } elseif (($thumb_options['where'] == 'end') || (($thumb_options['where'] == 'end_if_vertical') && ($pad_axis == 'y')) || (($thumb_options['where'] == 'end_if_horizontal') && ($pad_axis == 'x'))) {
                $pad_amount = $padding;
            } else {
                $pad_amount = intval(floatval($padding) / 2.0);
            }

            // Now set all of the parameters needed for blitting our image
            // $sx and $sy are fine, since they cover the whole image
            $source_x = 0;
            $source_y = 0;
            $_width = ($pad_axis == 'x') ? ($width - $padding) : $width;
            $_height = ($pad_axis == 'y') ? ($height - $padding) : $height;
            $dest_x = ($pad_axis == 'x') ? $pad_amount : 0;
            $dest_y = ($pad_axis == 'y') ? $pad_amount : 0;
        }
    }

    if (($_width == $sx) && ($_height == $sy) && ($dest_x == 0) && ($dest_y == 0) && (!$reorientated)) {
        // We can just escape, nothing to do...

        imagedestroy($source);

        if (($using_path) && ($from == $to)) {
            return true;
        }

        if ($using_path) {
            copy($from, $to);
            fix_permissions($to);
            sync_file($to);
        } else {
            require_code('files');
            cms_file_put_contents_safe($to, $from_file, FILE_WRITE_FIX_PERMISSIONS | FILE_WRITE_SYNC_FILE);
        }
        return true;
    }

    unset($from_file);

    // Resample/copy
    $gd_version = get_gd_version();
    if ($gd_version >= 2.0) { // If we have GD2
        // Set the background if we have one
        if (!is_null($thumb_options) && !is_null($red)) {
            $dest = imagecreatetruecolor($width, $height);
            imagealphablending($dest, false);
            if ((function_exists('imagecolorallocatealpha')) && ($using_alpha)) {
                $back_col = imagecolorallocatealpha($dest, $red, $green, $blue, 127 - intval(floatval($alpha) / 2.0));
            } else {
                $back_col = imagecolorallocate($dest, $red, $green, $blue);
            }
            imagefilledrectangle($dest, 0, 0, $width, $height, $back_col);
            if (function_exists('imagesavealpha')) {
                imagesavealpha($dest, true);
            }
        } else {
            $dest = imagecreatetruecolor($_width, $_height);
            imagealphablending($dest, false);
            if (function_exists('imagesavealpha')) {
                imagesavealpha($dest, true);
            }

            $transparent = imagecolortransparent($source);
            if ($transparent >= imagecolorstotal($source)) { // Workaround for corrupt images
                $transparent = -1;
            }
            if ($transparent != -1) {
                $_transparent = imagecolorsforindex($source, $transparent);
                $__transparent = imagecolorallocatealpha($dest, $_transparent['red'], $_transparent['green'], $_transparent['blue'], 127);
                imagecolortransparent($dest, $__transparent);
                imagefilledrectangle($dest, 0, 0, $_width, $_height, $__transparent);
                imagealphablending($dest, true); // Do not want to copy old transparent index over in imagecopyresampled (if we did this command always it would mess up for 32 bit images as those need the blending off)
            }
        }

        imagecopyresampled($dest, $source, $dest_x, $dest_y, $source_x, $source_y, $_width, $_height, $copy_width, $copy_height);
    } else { // LEGACY Old GD version, no truecolor support
        // Set the background if we have one
        if (!is_null($thumb_options) && !is_null($red)) {
            $dest = imagecreate($width, $height);

            $back_col = imagecolorallocate($dest, $red, $green, $blue);
            imagefill($dest, 0, 0, $back_col);
        } else {
            $dest = imagecreate($_width, $_height);
        }
        imagecopyresized($dest, $source, $dest_x, $dest_y, $source_x, $source_y, $_width, $_height, $copy_width, $copy_height);
    }

    // Clean up
    imagedestroy($source);

    // Save
    if (is_null($ext2)) {
        $ext2 = get_file_extension($to);
        if ($ext2 == '') {
            $ext2 = get_file_extension($from);
            if ($ext2 == '') {
               $ext2 = null;
            }
        }
    }

    // If we've got transparency then we have to save as PNG
    if (!is_null($thumb_options) && isset($using_alpha) && $using_alpha) {
        $ext2 = 'png';
    }

    if ($ext2 == 'png') {
        if ((strtolower(substr($to, -4)) != '.png') && (get_file_extension($to) != '')) {
            $to .= '.png';
        }
    }

    $lossy = ($width <= 300 && $width != -1 || $height <= 300 && $height != -1 || $box_width <= 300 && $box_width != -1);

    $unknown_format = false;
    $test = cms_imagesave($dest, $to, $ext2, $lossy, $unknown_format);

    if (!$test) {
        if ($unknown_format) {
            if ($exit_on_error) {
                warn_exit(do_lang_tempcode('UNKNOWN_FORMAT', escape_html($ext2)));
            }
            require_code('site');
            attach_message(do_lang_tempcode('UNKNOWN_FORMAT', escape_html($ext2)), 'warn');
        } else {
            if ($exit_on_error) {
                warn_exit(do_lang_tempcode('ERROR_IMAGE_SAVE', @strval($php_errormsg)));
            }
            require_code('site');
            attach_message(do_lang_tempcode('ERROR_IMAGE_SAVE', @strval($php_errormsg)), 'warn');
        }
        return false;
    }

    // Clean up
    imagedestroy($dest);

    return true;
}

/**
 * Check we can load the given file, given our memory limit.
 *
 * @param  PATH $file_path The file path we are trying to load
 * @param  boolean $exit_on_error Whether to exit Composr if an error occurs
 * @return boolean Success status
 */
function check_memory_limit_for($file_path, $exit_on_error = true)
{
    $ov = ini_get('memory_limit');

    $_what_we_will_allow = get_value('real_memory_available_mb');
    $what_we_will_allow = is_null($_what_we_will_allow) ? null : (intval($_what_we_will_allow) * 1024 * 1024);

    if ((substr($ov, -1) == 'M') || (!is_null($what_we_will_allow))) {
        if (is_null($what_we_will_allow)) {
            $total_memory_limit_in_bytes = intval(substr($ov, 0, strlen($ov) - 1)) * 1024 * 1024;

            $what_we_will_allow = $total_memory_limit_in_bytes - memory_get_usage() - 1024 * 1024 * 8; // 8 is for 8MB extra space needed to finish off
        }

        $details = @getimagesize($file_path);
        if ($details !== false) { // Check it is not corrupt. If it is corrupt, we will give an error later
            $magic_factor = 3.0; /* factor of inefficiency by experimentation */

            $channels = 4;//array_key_exists('channels', $details) ? $details['channels'] : 3; it will be loaded with 4
            $bits_per_channel = 8;//array_key_exists('bits', $details) ? $details['bits'] : 8; it will be loaded with 8
            $bytes = ($details[0] * $details[1]) * ($bits_per_channel / 8) * ($channels + 1) * $magic_factor;

            if ($bytes > floatval($what_we_will_allow)) {
                $max_dim = intval(sqrt(floatval($what_we_will_allow) / 4.0 / $magic_factor/*4 1 byte channels*/));

                // Can command line imagemagick save the day?
                $imagemagick = find_imagemagick();
                if ($imagemagick !== null) {
                    $shrink_command = $imagemagick . ' ' . escapeshellarg_wrap($file_path);
                    $shrink_command .= ' -resize ' . strval(intval(floatval($max_dim) / 1.5)) . 'x' . strval(intval(floatval($max_dim) / 1.5));
                    $shrink_command .= ' ' . escapeshellarg_wrap($file_path);
                    $err_cond = -1;
                    $output_arr = array();
                    if (php_function_allowed('shell_exec')) {
                        $err_cond = @shell_exec($shrink_command);
                        if (!is_null($err_cond)) {
                            return true;
                        }
                    }
                }

                $message = do_lang_tempcode('IMAGE_TOO_LARGE_FOR_THUMB', escape_html(integer_format($max_dim)), escape_html(integer_format($max_dim)));
                if (!$exit_on_error) {
                    attach_message($message, 'warn');
                } else {
                    warn_exit($message);
                }

                return false;
            }
        }
    }

    return true;
}

/**
 * Find the path to imagemagick.
 *
 * @return ?PATH Path to imagemagick (null: not found)
 */
function find_imagemagick()
{
    $imagemagick = '/usr/bin/convert';
    if (!@file_exists($imagemagick)) {
        $imagemagick = '/usr/local/bin/convert';
    }
    if (!@file_exists($imagemagick)) {
        $imagemagick = '/opt/local/bin/convert';
    }
    if (!@file_exists($imagemagick)) {
        $imagemagick = '/opt/cloudlinux/bin/convert';
    }
    if (!@file_exists($imagemagick)) {
        return null;
    }
    return $imagemagick;
}

/**
 * Remove white/transparent edges from an image.
 *
 * @param  resource $source GD image resource
 * @return resource Trimmed image
 */
function remove_white_edges($source)
{
    $width = imagesx($source);
    $height = imagesy($source);

    // From top
    $remove_from_top = 0;
    for ($y = 0; $y < $height; $y++) {
        for ($x = 0; $x < $width; $x++) {
            $_color = imagecolorat($source, $x, $y);
            if ($_color != 0) {
                break 2;
            }
        }
        $remove_from_top++;
    }

    // From bottom
    $remove_from_bottom = 0;
    for ($y = $height - 1; $y >= 0; $y--) {
        for ($x = 0; $x < $width; $x++) {
            $color = imagecolorsforindex($source, imagecolorat($source, $x, $y));
            if (($color['red'] != 0 || $color['green'] != 0 || $color['blue'] != 0) && ($color['alpha'] != 127)) {
                break 2;
            }
        }
        $remove_from_bottom++;
    }

    // From left
    $remove_from_left = 0;
    for ($x = 0; $x < $width; $x++) {
        for ($y = 0; $y < $height; $y++) {
            $color = imagecolorsforindex($source, imagecolorat($source, $x, $y));
            if (($color['red'] != 0 || $color['green'] != 0 || $color['blue'] != 0) && ($color['alpha'] != 127)) {
                break 2;
            }
        }
        $remove_from_left++;
    }

    // From right
    $remove_from_right = 0;
    for ($x = $width - 1; $x >= 0; $x--) {
        for ($y = 0; $y < $height; $y++) {
            $color = imagecolorsforindex($source, imagecolorat($source, $x, $y));
            if (($color['red'] != 0 || $color['green'] != 0 || $color['blue'] != 0) && ($color['alpha'] != 127)) {
                break 2;
            }
        }
        $remove_from_right++;
    }

    // Any changes?
    if ($remove_from_top + $remove_from_bottom + $remove_from_left + $remove_from_right == 0 || $remove_from_left == $width || $remove_from_top == $height) {
        return $source;
    }

    // Do trimming...

    $target_width = $width - $remove_from_left - $remove_from_right;
    $target_height = $height - $remove_from_top - $remove_from_bottom;

    $dest = imagecreatetruecolor($target_width, $target_height);
    imagealphablending($dest, false);
    if (function_exists('imagesavealpha')) {
        imagesavealpha($dest, true);
    }

    $transparent = imagecolortransparent($source);
    if ($transparent >= imagecolorstotal($source)) { // Workaround for corrupt images
        $transparent = -1;
    }
    if ($transparent != -1) {
        $_transparent = imagecolorsforindex($source, $transparent);
        $__transparent = imagecolorallocatealpha($dest, $_transparent['red'], $_transparent['green'], $_transparent['blue'], 127);
        imagecolortransparent($dest, $__transparent);
        imagefilledrectangle($dest, 0, 0, $width, $height, $__transparent);
    }

    if (imagecopyresampled($dest, $source, 0, 0, $remove_from_left, $remove_from_top, $target_width, $target_height, $target_width, $target_height)) {
        imagedestroy($source);
        $source = $dest;
    }

    return $source;
}

/**
 * Get the version number of GD on the system. It should only be called if GD is known to be on the system, and in use
 *
 * @return float The version of GD installed
 */
function get_gd_version()
{
    $info = gd_info();
    $matches = array();
    if (preg_match('#(\d(\.|))+#', $info['GD Version'], $matches) != 0) {
        $version = $matches[0];
    } else {
        $version = $info['version'];
    }
    return floatval($version);
}


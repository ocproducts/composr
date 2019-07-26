<?php

/*

  Composr
  Copyright (c) ocProducts, 2004-2019

  See text/EN/licence.txt for full licensing information.


  NOTE TO PROGRAMMERS:
  Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
 * *** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

 */

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */
/* EXTRA FUNCTIONS: shell_exec|imagefilledrectangle */

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

    $is_vector = is_image($full_url, IMAGE_CRITERIA_VECTOR);

    if ($is_vector) {
        $thumb_url = $full_url;
    } else {
        require_code('urls2');
        list($thumb_path, $thumb_url) = find_unique_path('uploads/' . $thumb_dir . '_thumbs', rawurldecode(basename($full_url)), true);
    }

    // Update database
    $db = get_db_for($table);
    $db->query_update($table, array($thumb_field_name => $thumb_url), array('id' => $id), '', 1);

    if (!$is_vector) {
        // Do thumbnail conversion
        if (is_video($full_url, false, true)) {
            if (addon_installed('galleries')) {
                require_code('galleries2');
                create_video_thumb($full_url, $thumb_path);
            }
        } else {
            $thumb_url = convert_image($full_url, $thumb_path, null, null, intval($thumb_width), false);
        }
    }

    // Return
    if (url_is_local($thumb_url)) {
        $thumb_url = get_custom_base_url() . '/' . $thumb_url;
    }
    return $thumb_url;
}

/**
 * Resize an image to the specified size, but retain the aspect ratio. Has some advanced thumbnailing options.
 * This function works as a higher-level front-end to _convert_image. It doesn't deal in direct filepaths and error responses, it tries it's best and with additional higher level functionality.
 * See tut_tempcode.txt's explanation of the {$THUMBNAIL,...} symbol for a more detailed explanation.
 *
 * @param  URLPATH $orig_url URL to generate thumbnail from
 * @param  ?string $dimensions A dimension string, may be a number, or 2 numbers separated by "x" (null: default thumbnail size)
 * @param  PATH $output_dir Output directory
 * @param  ?string $filename Core filename to use within the overall output filename (null: auto-generate using $orig_url)
 * @param  ?URLPATH $fallback_image Fallback URL if we fail (null: use $orig_url)
 * @param  string $algorithm Algorithm to use
 * @set box width height crop pad pad_horiz_crop_horiz pad_vert_crop_vert
 * @param  string $where Where to cut from or pad
 * @set start end both start_if_vertical start_if_horizontal end_if_vertical end_if_horizontal
 * @param  ?string $background Background colour to use for padding, RGB/RGBA style and the "#" may be omitted -- or 'none' (null: choose the average colour in the image)
 * @param  boolean $only_make_smaller Only ever make the output smaller than the source image, no blowing small images up
 * @return URLPATH Generated thumbnail
 *
 * @ignore
 */
function convert_image_plus($orig_url, $dimensions = null, $output_dir = 'uploads/auto_thumbs', $filename = null, $fallback_image = null, $algorithm = 'box', $where = 'both', $background = null, $only_make_smaller = false)
{
    cms_profile_start_for('convert_image_plus');

    if ($dimensions === null) {
        $dimensions = get_option('thumb_width');
    }
    $exp_dimensions = array_map('intval', explode('x', $dimensions, 2));
    if ($exp_dimensions[0] == 0) {
        $exp_dimensions[0] = null;
    }
    if ((count($exp_dimensions) == 1) || ($exp_dimensions[1] == 0)) {
        $exp_dimensions[1] = null;
    }
    
    // Exit if no dimensions were provided. There's no reason to create a thumbnail without dimensions.
    if ($exp_dimensions[0] === null && $exp_dimensions[1] === null) {
        return warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
    }
    
    if (url_is_local($orig_url)) {
        $orig_url = get_custom_base_url() . '/' . $orig_url;
    }

    if ($filename === null) {
        $ext = get_file_extension($orig_url);
        if (!is_image('example.' . $ext, IMAGE_CRITERIA_WEBSAFE, true)) {
            $ext = 'png';
        }
        $filename = url_to_filename($orig_url);
        if (substr($filename, -4) != '.' . $ext) {
            $filename .= '.' . $ext;
        }
    }

    if ($fallback_image === null) {
        $fallback_image = $orig_url;
    }

    $file_prefix = '/' . $output_dir . '/thumb__' . $dimensions . '__' . $algorithm . '__' . $where;
    if ($background !== null) {
        $file_prefix .= '__' . str_replace('#', '', $background);
    }
    $save_path = get_custom_file_base() . $file_prefix . '__' . $filename;
    $thumbnail_url = get_custom_base_url() . $file_prefix . '__' . rawurlencode($filename);

    // Only bother calculating the image if we've not already made one with these options
    if (is_file($save_path)) {
        cms_profile_end_for('convert_image_plus', $orig_url);
        return $thumbnail_url;
    }

    // Can't operate without GD
    if (!function_exists('imagetypes')) {
        cms_profile_end_for('convert_image_plus', $orig_url);
        return $fallback_image;
    }

    disable_php_memory_limit();
    $old_limit = cms_extend_time_limit(TIME_LIMIT_EXTEND_modest);

    // Branch based on the type of thumbnail we're making
    switch ($algorithm) {
        case 'crop':
        case 'pad':
        case 'pad_horiz_crop_horiz':
        case 'pad_vert_crop_vert':
            // We need to shrink a bit and crop/pad...

            require_code('files');

            // Find dimensions of the source
            $sizes = cms_getimagesize_url($orig_url);
            if (($sizes === false) || ($sizes[0] === null) || ($sizes[1] === null)) {
                cms_profile_end_for('convert_image_plus', $orig_url);

                cms_set_time_limit($old_limit);

                if (($fallback_image != '') && ($fallback_image != $orig_url)) {
                    return convert_image_plus($fallback_image, $dimensions, $output_dir, $filename, '', $algorithm, $where, $background, $only_make_smaller);
                }
                return $fallback_image;
            }
            list($source_x, $source_y) = $sizes;

            // Work out aspect ratios
            $source_aspect = floatval($source_x) / floatval($source_y);
            if ($exp_dimensions[0] === null || $exp_dimensions[1] === null) {
                $destination_aspect = $source_aspect;
            } else {
                $destination_aspect = floatval($exp_dimensions[0]) / floatval($exp_dimensions[1]);
            }
            
            // If either width or height was not specified in dimensions, set one according to aspect ratio to avoid division by zero.
            if ($exp_dimensions[0] === null) {
                $exp_dimensions[0] = ($exp_dimensions[1] * $source_aspect);
            }
            if ($exp_dimensions[1] === null) {
                $exp_dimensions[1] = ($exp_dimensions[0] * (1 / $source_aspect));
            }
            
            // NB: We will test the scaled sizes, rather than the ratios directly, so that differences too small to affect the integer dimensions will be tolerated.
            // We only need to crop/pad if the aspect ratio differs from what we want
            if ($source_aspect > $destination_aspect) {
                // The image is wider than the output

                if (($algorithm == 'crop') || ($algorithm == 'pad_horiz_crop_horiz')) {
                    // Is it too wide, requiring cropping?
                    $scale_to = floatval($source_y) / floatval($exp_dimensions[1]);
                    $will_modify_image = intval(round(floatval($source_x) / $scale_to)) != $exp_dimensions[0];
                } else {
                    // Is the image too short, requiring padding?
                    $scale_to = floatval($source_x) / floatval($exp_dimensions[0]);
                    $will_modify_image = intval(round(floatval($source_y) / $scale_to)) != $exp_dimensions[1];
                }
            } elseif ($source_aspect < $destination_aspect) {
                // The image is taller than the output

                if (($algorithm == 'crop') || ($algorithm == 'pad_vert_crop_vert')) {
                    // Is it too tall, requiring cropping?
                    $scale_to = floatval($source_x) / floatval($exp_dimensions[0]);
                    $will_modify_image = intval(round(floatval($source_y) / $scale_to)) != $exp_dimensions[1];
                } else {
                    // Is the image too narrow, requiring padding?
                    $scale_to = floatval($source_y) / floatval($exp_dimensions[1]);
                    $will_modify_image = intval(round(floatval($source_x) / $scale_to)) != $exp_dimensions[0];
                }
            } else {
                // They're the same, within the tolerances of floating point arithmetic. Just scale it.
                if ($source_x != $exp_dimensions[0] || $source_y != $exp_dimensions[1]) {
                    $scale_to = floatval($source_x) / floatval($exp_dimensions[0]);
                    $will_modify_image = true;
                } else {
                    $will_modify_image = false;
                }
            }

            // We have a special case here, since we can "pad" an image with nothing, i.e. shrink it to fit within the output dimensions and just leave the output file potentially less wide/high than those. This means we don't need to modify the image contents either, just scale it
            if (($algorithm == 'pad' || $algorithm == 'pad_horiz_crop_horiz' || $algorithm == 'pad_vert_crop_vert') && ($where == 'both') && ($background === 'none')) {
                $will_modify_image = false;
            }

            // Now do the cropping, padding and scaling
            if ($will_modify_image) {
                $thumbnail_url = @_convert_image($orig_url, $save_path, $exp_dimensions[0], $exp_dimensions[1], null, false, null, false, $only_make_smaller, array('type' => $algorithm, 'background' => $background, 'where' => $where, 'scale_to' => $scale_to));
            } else {
                // Just resize
                $thumbnail_url = @_convert_image($orig_url, $save_path, $exp_dimensions[0], $exp_dimensions[1], null, false, null, false, $only_make_smaller);
            }
            break;

        case 'width':
        case 'height':
            // We just need to scale to the given dimension
            $thumbnail_url = @_convert_image($orig_url, $save_path, ($algorithm == 'width') ? $exp_dimensions[0] : null, ($algorithm == 'height') ? $exp_dimensions[1] : null, null, false, null, false, $only_make_smaller);
            break;

        case 'box':
        default:
            // We just need to scale to the given dimension
            $thumbnail_url = @_convert_image($orig_url, $save_path, null, null, ($exp_dimensions[0] === null) ? $exp_dimensions[1] : $exp_dimensions[0], false, null, false, $only_make_smaller);
            break;
    }

    cms_profile_end_for('convert_image_plus', $orig_url);

    cms_set_time_limit($old_limit);

    return $thumbnail_url;
}

/**
 * (Helper for convert_image / convert_image_plus).
 *
 * @param  string $from The URL to the image to resize. May be either relative or absolute. If $using_path is set it is actually a path
 * @param  PATH $to The file path (including filename) to where the resized image will be saved. May be changed by reference if it cannot save an image of the requested file type for some reason
 * @param  ?integer $width The maximum width we want our new image to be (null: don't factor this in)
 * @param  ?integer $height The maximum height we want our new image to be (null: don't factor this in)
 * @param  ?integer $box_size This is only considered if both $width and $height are null. If set, it will fit the image to a box of this dimension (suited for resizing both landscape and portraits fairly) (null: use width or height)
 * @param  boolean $exit_on_error Whether to exit Composr if an error occurs
 * @param  ?string $ext2 The file extension representing the file type to save with (null: same as our input file)
 * @param  boolean $using_path Whether $from was in fact a path, not a URL
 * @param  boolean $only_make_smaller Whether to apply a 'never make the image bigger' rule for thumbnail creation (would affect very small images)
 * @param  ?array $thumb_options This optional parameter allows us to specify cropping or padding for the image. See comments in the function. (null: no details passed)
 * @return URLPATH The thumbnail URL (blank: URL is outside of base URL)
 *
 * @ignore
 */
function _convert_image($from, &$to, $width, $height, $box_size = null, $exit_on_error = true, $ext2 = null, $using_path = false, $only_make_smaller = false, $thumb_options = null)
{
    disable_php_memory_limit();
    $old_limit = cms_extend_time_limit(TIME_LIMIT_EXTEND_modest);

    if (!file_exists(dirname($to))) {
        require_code('files2');
        make_missing_directory(dirname($to));
    }

    // Load
    $ext = get_file_extension($from);
    if ($using_path) {
        if ((!check_memory_limit_for($from, $exit_on_error)) || ($ext == 'svg'/* SVG is pass-through */)) {
            if ($using_path) {
                copy($from, $to);
                fix_permissions($to);
                sync_file($to);
            }
            cms_set_time_limit($old_limit);
            return $from;
        }
        $from_file = @cms_file_get_contents_safe($from);
        $exif = function_exists('exif_read_data') ? @exif_read_data($from) : false;
    } else {
        $file_path_stub = convert_url_to_path($from);
        if ($file_path_stub !== null) {
            if ((!check_memory_limit_for($from, $exit_on_error)) || ($ext == 'svg'/* SVG is pass-through */)) {
                cms_set_time_limit($old_limit);
                return $from;
            }
            $from_file = @cms_file_get_contents_safe($file_path_stub);
            $exif = function_exists('exif_read_data') ? @exif_read_data($file_path_stub) : false;
        } else {
            $from_file = http_get_contents($from, array('trigger_error' => false, 'byte_limit' => 1024 * 1024 * 20/* reasonable limit */));
            if ($from_file === null) {
                $from_file = false;
                $exif = false;
            } else {
                require_code('files');
                cms_file_put_contents_safe($to, $from_file, FILE_WRITE_FIX_PERMISSIONS | FILE_WRITE_SYNC_FILE);
                $exif = function_exists('exif_read_data') ? @exif_read_data($to) : false;
                if ($ext == 'svg') { // SVG is pass-through
                    cms_set_time_limit($old_limit);
                    return $from;
                }
            }
        }
    }
    if ($from_file === false) {
        if ($exit_on_error) {
            warn_exit(do_lang_tempcode('CANNOT_ACCESS_URL', escape_html($from)), false, true);
        }
        require_code('site');
        if (get_value('disable_cannot_access_url_messages') !== '1') {
            attach_message(do_lang_tempcode('CANNOT_ACCESS_URL', escape_html($from)), 'warn', false, true);
        }
        cms_set_time_limit($old_limit);
        return $from;
    }

    $source = cms_imagecreatefromstring($from_file, $ext);
    if ($source === false) {
        if ($exit_on_error) {
            warn_exit(do_lang_tempcode('CORRUPT_FILE', escape_html($from)), false, true);
        }
        require_code('site');
        attach_message(do_lang_tempcode('CORRUPT_FILE', escape_html($from)), 'warn', false, true);
        cms_set_time_limit($old_limit);
        return $from;
    }
    imagepalettetotruecolor($source);

    // We need to do some specific cleanup. Most of the other pipeline cleanup will automatically happen during the thumbnailing process (and probably have already run for the source image anyway)
    require_code('images_cleanup_pipeline');
    list($source, $reorientated) = adjust_pic_orientation($source, $exif);

    //$source = remove_white_edges($source);    Not currently enabled, as PHP seems to have problems with alpha transparency reading
    // Derive actual width x height, for the given maximum box (maintain aspect ratio)
    $sx = imagesx($source);
    $sy = imagesy($source);

    // Fix bad parameters
    if ($width === 0) {
        $width = 1;
    }
    if ($height === 0) {
        $height = 1;
    }

    $red = null;

    if ($thumb_options === null) {
        // Simpler algorithm
        // If we're not sure if this is gonna stretch to fit a width or stretch to fit a height
        if (($width === null) && ($height === null)) {
            if ($sx > $sy) {
                $width = $box_size;
            } else {
                $height = $box_size;
            }
        }

        if (($width !== null) && ($height !== null)) {
            if ((floatval($sx) / floatval($width)) > (floatval($sy) / floatval($height))) {
                $_width = $width;
                $_height = intval($sy * ($width / $sx));
            } else {
                $_height = $height;
                $_width = intval($sx * ($height / $sy));
            }
        } elseif ($height === null) {
            $_width = $width;
            $_height = intval($width / ($sx / $sy));
        } elseif ($width === null) {
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
                    cms_set_time_limit($old_limit);
                    return $from;
                }

                if ($using_path) {
                    copy($from, $to);
                    fix_permissions($to);
                    sync_file($to);
                } else {
                    require_code('files');
                    cms_file_put_contents_safe($to, $from_file, FILE_WRITE_FIX_PERMISSIONS | FILE_WRITE_SYNC_FILE);
                }
                cms_set_time_limit($old_limit);
                return _image_path_to_url($to);
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
        // The ability to crop (ie. window-off a section of the image), and pad (ie. provide a background around the image).
        // We keep this separate to the above code because the algorithm is more complex.
        // For documentation of the $thumb_options see the tut_tempcode.txt's description of the {$THUMBNAIL,...} symbol.
        // Grab the dimensions we would get if we didn't crop or scale
        $wrong_x = intval(round(floatval($sx) / $thumb_options['scale_to']));
        $wrong_y = intval(round(floatval($sy) / $thumb_options['scale_to']));

        // Handle cropping here
        if (($thumb_options['type'] == 'crop') || (($thumb_options['type'] == 'pad_horiz_crop_horiz') && ($wrong_x > $width)) || (($thumb_options['type'] == 'pad_vert_crop_vert') && ($wrong_y > $height))) {
            // See which direction we're cropping in
            if (intval(round(floatval($sx) / $thumb_options['scale_to'])) != $width) {
                $crop_direction = 'x';
            } else {
                $crop_direction = 'y';
            }
            // We definitely have to crop, since $thumb_options only tells us to crop if it has to. Thus we know we're going to fill the output image.
            // The only question is with what part of the source image?
            // Get the amount we'll lose from the source
            if ($crop_direction == 'x') {
                $crop_off = intval(($sx - ($width * $thumb_options['scale_to'])));
            } elseif ($crop_direction == 'y') {
                $crop_off = intval(($sy - ($height * $thumb_options['scale_to'])));
            }

            // Now we see how much to chop off the start (we don't care about the end, as this will be handled by using an appropriate window size)
            $displacement = 0;
            if (($thumb_options['where'] == 'start') || (($thumb_options['where'] == 'start_if_vertical') && ($crop_direction == 'y')) || (($thumb_options['where'] == 'start_if_horizontal') && ($crop_direction == 'x'))) {
                $displacement = 0;
            } elseif (($thumb_options['where'] == 'end') || (($thumb_options['where'] == 'end_if_vertical') && ($crop_direction == 'y')) || (($thumb_options['where'] == 'end_if_horizontal') && ($crop_direction == 'x'))) {
                $displacement = intval(floatval($crop_off));
            } else {
                $displacement = intval(floatval($crop_off) / 2.0);
            }

            // Now we convert this to the right x and y start locations for the window
            $source_x = ($crop_direction == 'x') ? $displacement : 0;
            $source_y = ($crop_direction == 'y') ? $displacement : 0;

            // Now we set the width and height of our window, which will be scaled versions of the width and height of the output
            $sx = intval(($width * $thumb_options['scale_to']));
            $sy = intval(($height * $thumb_options['scale_to']));

            // We start at the origin of our output
            $dest_x = 0;
            $dest_y = 0;

            // and it is always the full size it can be (or else we'd be cropping too much)
            $_width = $width;
            $_height = $height;
            
            // Handle padding here
        } elseif ($thumb_options['type'] == 'pad' || (($thumb_options['type'] == 'pad_horiz_crop_horiz') && ($wrong_x < $width)) || (($thumb_options['type'] == 'pad_vert_crop_vert') && ($wrong_y < $height))) {
            // We definitely need to pad some excess space because otherwise $thumb_options would not call us.
            // Thus we need a background (can be transparent). Let's see if we've been given one.
            if (array_key_exists('background', $thumb_options) && ($thumb_options['background'] !== null)) {
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
                // We've not got a background, so let's find a representative color for the image by resampling the whole thing to 1 pixel.
                $temp_img = imagecreatetruecolor(1, 1); // Make an image to map on to
                imagecopyresampled($temp_img, $source, 0, 0, 0, 0, 1, 1, $sx, $sy); // Map the source image on to the 1x1 image
                $rgb_index = imagecolorat($temp_img, 0, 0); // Grab the color index of the single pixel
                $rgb_array = imagecolorsforindex($temp_img, $rgb_index); // Get the channels for it
                $red = $rgb_array['red']; // Grab the red
                $green = $rgb_array['green']; // Grab the green
                $blue = $rgb_array['blue']; // Grab the blue
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
            if (intval(round(floatval($sx) / $thumb_options['scale_to'])) != $width) {
                $pad_axis = 'x';
            } else {
                $pad_axis = 'y';
            }

            // The amount
            if ($pad_axis == 'x') {
                $padding = intval(round(floatval($width) - (floatval($sx) / $thumb_options['scale_to'])));
            } else {
                $padding = intval(round(floatval($height) - (floatval($sy) / $thumb_options['scale_to'])));
            }

            // The distribution
            if (($thumb_options['where'] == 'start') || (($thumb_options['where'] == 'start_if_vertical') && ($pad_axis == 'y')) || (($thumb_options['where'] == 'start_if_horizontal') && ($pad_axis == 'x'))) {
                $pad_amount = 0;
            } elseif (($thumb_options['where'] == 'end') || (($thumb_options['where'] == 'end_if_vertical') && ($pad_axis == 'y')) || (($thumb_options['where'] == 'end_if_horizontal') && ($pad_axis == 'x'))) {
                $pad_amount = $padding;
            } else {
                $pad_amount = intval(floatval($padding) / 2.0);
            }

            // Now set all of the parameters needed for blitting our image $sx and $sy are fine, since they cover the whole image
            $source_x = 0;
            $source_y = 0;
            $_width = ($pad_axis == 'x') ? intval(round(floatval($sx) / $thumb_options['scale_to'])) : $width;
            $_height = ($pad_axis == 'y') ? intval(round(floatval($sy) / $thumb_options['scale_to'])) : $height;
            $dest_x = ($pad_axis == 'x') ? $pad_amount : 0;
            $dest_y = ($pad_axis == 'y') ? $pad_amount : 0;
        }
    }

    // Set the background if we have one
    if (($thumb_options !== null) && ($red !== null)) {
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
    }

    if (($_width == $sx) && ($_height == $sy)) {
        // We can just escape, nothing to do...
        imagedestroy($source);

        if (($using_path) && ($from == $to)) {
            cms_set_time_limit($old_limit);
            return $from;
        }

        if ($using_path) {
            copy($from, $to);
            fix_permissions($to);
            sync_file($to);
        } else {
            require_code('files');
            cms_file_put_contents_safe($to, $from_file, FILE_WRITE_FIX_PERMISSIONS | FILE_WRITE_SYNC_FILE);
        }
        cms_set_time_limit($old_limit);
        return $to;
    }

    unset($from_file);
    
    // Resample/copy
    imagecopyresampled($dest, $source, $dest_x, $dest_y, $source_x, $source_y, $_width, $_height, $sx, $sy);

    // Clean up
    imagedestroy($source);

    // Save...

    if ($ext2 === null) {
        $ext2 = get_file_extension($to);
        if ($ext2 == '') {
            $ext2 = get_file_extension($from);
            if ($ext2 == '') {
                $ext2 = null;
            }
        }
    }
    // If we've got transparency then we have to save as PNG
    if (($thumb_options !== null) && (isset($using_alpha)) && ($using_alpha) || ($ext2 == '')) {
        $ext2 = 'png';
    }

    if ($ext2 == 'png') {
        if ((strtolower(substr($to, -4)) != '.png') && (get_file_extension($to) != '')) {
            $to .= '.png';
        }
    }

    $lossy = ($width <= 300 && $width !== null || $height <= 300 && $height !== null || $box_size <= 300 && $box_size !== null);

    $unknown_format = false;
    $test = cms_imagesave($dest, $to, $ext2, $lossy, $unknown_format);

    if (!$test) {
        if ($unknown_format) {
            if ($exit_on_error) {
                warn_exit(do_lang_tempcode('UNKNOWN_FORMAT', escape_html($ext2)), false, true);
            }
            require_code('site');
            attach_message(do_lang_tempcode('UNKNOWN_FORMAT', escape_html($ext2)), 'warn', false, true);
        } else {
            if ($exit_on_error) {
                warn_exit(do_lang_tempcode('ERROR_IMAGE_SAVE', cms_error_get_last()), false, true);
            }
            require_code('site');
            attach_message(do_lang_tempcode('ERROR_IMAGE_SAVE', cms_error_get_last()), 'warn', false, true);
        }
        cms_set_time_limit($old_limit);
        return $from;
    }

    // Clean up
    imagedestroy($dest);

    fix_permissions($to);
    sync_file($to);

    cms_set_time_limit($old_limit);
    return _image_path_to_url($to);
}

/**
 * Convert an image path to a URL, as convert_image returns a URL not a path.
 *
 * @param  PATH $to_path Path
 * @return URLPATH URL
 */
function _image_path_to_url($to_path)
{
    $file_base = get_custom_file_base();
    if (substr($to_path, 0, strlen($file_base) + 1) != $file_base . '/') {
        //fatal_exit(do_lang_tempcode('INTERNAL_ERROR')); // Nothing in the code should be trying to generate a thumbnail outside the base directory
        return '';
    }

    $to_url = str_replace('%2F', '/', rawurlencode(substr($to_path, strlen($file_base) + 1)));
    return $to_url;
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
    $what_we_will_allow = ($_what_we_will_allow === null) ? null : (intval($_what_we_will_allow) * 1024 * 1024);

    if ((substr($ov, -1) == 'M') || ($what_we_will_allow !== null)) {
        if ($what_we_will_allow === null) {
            $total_memory_limit_in_bytes = intval(substr($ov, 0, strlen($ov) - 1)) * 1024 * 1024;

            $what_we_will_allow = $total_memory_limit_in_bytes - memory_get_usage() - 1024 * 1024 * 8; // 8 is for 8MB extra space needed to finish off
        }

        $details = @getimagesize($file_path);
        if ($details !== false) { // Check it is not corrupt. If it is corrupt, we will give an error later
            $magic_factor = 3.0; /* factor of inefficiency by experimentation */

            $channels = 4; //array_key_exists('channels', $details) ? $details['channels'] : 3; it will be loaded with 4
            $bits_per_channel = 8; //array_key_exists('bits', $details) ? $details['bits'] : 8; it will be loaded with 8
            $bytes = ($details[0] * $details[1]) * ($bits_per_channel / 8) * ($channels + 1) * $magic_factor;

            if ($bytes > floatval($what_we_will_allow)) {
                $max_dim = intval(sqrt(floatval($what_we_will_allow) / 4.0 / $magic_factor/* 4 1 byte channels */));

                // Can command line imagemagick save the day?
                $imagemagick = find_imagemagick();
                if ($imagemagick !== null) {
                    $shrink_command = $imagemagick . ' ' . cms_escapeshellarg($file_path);
                    $shrink_command .= ' -resize ' . strval(intval(floatval($max_dim) / 1.5)) . 'x' . strval(intval(floatval($max_dim) / 1.5));
                    $shrink_command .= ' ' . cms_escapeshellarg($file_path);
                    $err_cond = -1;
                    $output_arr = array();
                    if (php_function_allowed('shell_exec')) {
                        $err_cond = @shell_exec($shrink_command);
                        if ($err_cond !== null) {
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
    imagepalettetotruecolor($source);

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

    if (imagecopyresampled($dest, $source, 0, 0, $remove_from_left, $remove_from_top, $target_width, $target_height, $target_width, $target_height)) {
        imagedestroy($source);
        $source = $dest;
    }

    return $source;
}

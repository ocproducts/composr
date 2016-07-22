<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    comcode_html_whitelist
 */

if (!function_exists('init__comcode_renderer')) {
    function init__comcode_renderer($in)
    {
        $before = 'if ((isset($DANGEROUS_TAGS[$tag])) && (!$comcode_dangerous))';
        $after = 'if ((isset($DANGEROUS_TAGS[$tag])) && (!$comcode_dangerous) && (!comcode_white_listed($tag, $marker, $comcode)))';
        $in = str_replace($before, $after, $in);

        $before = '$urls = get_url(\'\', \'file\' . $_id, \'uploads/attachments\', 2, CMS_UPLOAD_ANYTHING, (!array_key_exists(\'thumb\', $attributes)) || ($attributes[\'thumb\']!=\'0\'), \'\', \'\', true, true, true, true);';
        $after = $before . "
            \$gallery = post_param_string('gallery' . \$_id, '');
            if (\$gallery != '') {
                \$urls_gal = get_url('', 'file' . \$_id, 'uploads/galleries', 0, CMS_UPLOAD_ANYTHING, true, '', '', true, true, true, true);
                require_code('galleries2');

                \$description = post_param_string('caption' . \$_id, array_key_exists('description', \$attributes)?\$attributes['description']:'');

                if (is_video(\$urls_gal[0], has_privilege(\$source_member, 'comcode_dangerous'))) {
                    \$video_width = array_key_exists('width', \$attributes) ? intval(\$attributes['width']) : null;
                    \$video_height = array_key_exists('height', \$attributes) ? intval(\$attributes['height']) : null;
                    \$video_height = array_key_exists('length', \$attributes) ? intval(\$attributes['length']) : 30;
                    if ((\$video_width === null) || (\$video_height === null)) {
                        require_code('galleries2');
                        \$vid_details = get_video_details(get_custom_file_base().'/' . rawurldecode(\$urls_gal[0]), \$urls_gal[2], true);
                        if (\$vid_details !== false) {
                            list(\$video_width, \$video_height, \$video_length) = \$vid_details;
                            }
                    }

                    if (\$video_length === null) {
                        \$video_length = 30;
                    }
                    if (\$video_width === null) {
                        \$video_width = 300;
                    }
                    if (\$video_height === null) {
                        \$video_height = 200;
                    }

                    add_video('', \$gallery, \$description, \$urls_gal[0], \$urls_gal[1], 1, 1, 1, 1, '', \$video_length, \$video_width, \$video_height);
                }

                if (is_image(\$urls_gal[0], IMAGE_CRITERIA_WEBSAFE, has_privilege(get_member(), 'comcode_dangerous'))) {
                    add_image('', \$gallery, \$description, \$urls_gal[0], \$urls_gal[1], 1, 1, 1, 1, '');
                }
            }
        ";
        $in = str_replace($before, $after, $in);

        return $in;
    }
}

function comcode_white_listed($tag, $marker, $comcode)
{
    $start_pos = strrpos(substr($comcode, 0, $marker), '[' . $tag);
    $end_pos = $marker - $start_pos;
    $comcode_portion_at_and_after = substr($comcode, $start_pos);
    $comcode_portion = substr($comcode_portion_at_and_after, 0, $end_pos);

    require_code('textfiles');
    static $whitelists = null;
    if ($whitelists === null) {
        $whitelists = explode("\n", read_text_file('comcode_whitelist'));
    }

    if (in_array($comcode_portion, $whitelists)) {
        return true;
    }
    foreach ($whitelists as $whitelist) {
        if ((substr($whitelist, 0, 1) == '/') && (substr($whitelist, -1) == '/') && (preg_match($whitelist, $comcode_portion) != 0)) {
            return true;
        }
    }

    return false;
}

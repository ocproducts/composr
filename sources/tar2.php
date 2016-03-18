<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


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
 * Convert a ZIP file to a TAR file.
 *
 * @param  PATH $in_path The path of the TAR file to convert
 * @param  ?PATH $out_path The path of the ZIP file to save to (null: make up a temporary path)
 * @return PATH The TAR path. A temp file that must be deleted
 */
function convert_zip_to_tar($in_path, $out_path = null)
{
    if (php_function_allowed('set_time_limit')) {
        set_time_limit(200);
    }

    require_code('tar');
    require_code('files');

    if ((!function_exists('zip_open')) && (get_option('unzip_cmd') == '')) {
        warn_exit(do_lang_tempcode('ZIP_NOT_ENABLED'));
    }
    if (!function_exists('zip_open')) {
        require_code('m_zip');
        $mzip = true;
    } else {
        $mzip = false;
    }

    $in_file = zip_open($in_path);
    if (is_integer($in_file)) {
        require_code('failure');
        warn_exit(zip_error($in_file, $mzip));
    }

    if (is_null($out_path)) {
        $out_path = cms_tempnam();
    }
    $out_file = tar_open($out_path, 'wb');

    while (false !== ($entry = zip_read($in_file))) {
        // Load in file
        zip_entry_open($in_file, $entry);

        $_file = zip_entry_name($entry);

        $temp_path = cms_tempnam();
        $temp_file = @fopen($temp_path, 'wb') or intelligent_write_error($temp_path);
        $more = mixed();
        do {
            $more = zip_entry_read($entry);
            if (fwrite($temp_file, $more) < strlen($more)) {
                warn_exit(do_lang_tempcode('COULD_NOT_SAVE_FILE'));
            }
        } while (($more !== false) && ($more != ''));
        fclose($temp_file);

        tar_add_file($out_file, $_file, $temp_path, 0644, null, true, false, true);

        @unlink($temp_path);

        zip_entry_close($entry);
    }

    zip_close($in_file);
    tar_close($out_file);

    return $out_path;
}

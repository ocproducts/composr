<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    excel_support
 */

/**
 * Output data to a CSV file.
 *
 * @param  array $data List of maps, each map representing a row
 * @param  ID_TEXT $filename Filename to output
 * @param  boolean $headers Whether to output CSV headers
 * @param  boolean $output_and_exit Whether to output/exit when we're done instead of return
 * @param  ?PATH $outfile_path File to spool into (null: none)
 * @param  ?mixed $callback Callback for dynamic row insertion (null: none). Only implemented for the excel_support addon. Is passed: row just done, next row (or NULL), returns rows to insert
 * @param  ?array $meta_data List of maps, each map representing meta-data of a row; supports 'url' (NULL: none)
 * @return string CSV data (we might not return though, depending on $exit; if $outfile_path is not NULL, this will be blank)
 */
function make_csv($data, $filename = 'data.csv', $headers = true, $output_and_exit = true, $outfile_path = null, $callback = null, $meta_data = null)
{
    if (version_compare(PHP_VERSION, '5.3.0') < 0) {
        return non_overridden__make_csv($data, $filename, $headers, $output_and_exit, $outfile_path, $callback, $meta_data);
    }

    require_code('files_spout');

    require_code('character_sets');

    $ext = get_file_extension($filename);

    if ($headers) {
        require_code('mime_types');
        if ($ext != 'html' && $ext != 'htm') {
            header('Content-type: ' . get_mime_type($ext, true));
        } else {
            header('Content-type: text/html; charset=UTF-8');
        }
        if (($ext != 'html') && ($ext != 'htm')) {
            header('Content-Disposition: attachment; filename="' . str_replace(chr(13), '', str_replace(chr(10), '', addslashes($filename))) . '"');
        } else {
            header('Content-Disposition: inline');
        }
    }

    return spreadsheet_export__spout($ext, $data, $filename, $headers, $output_and_exit, $outfile_path, $callback, $meta_data);
}

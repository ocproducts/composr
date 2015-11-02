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

use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;

function spreadsheet_export__spout($ext, $data, $filename, $headers, $output_and_exit, $outfile_path, $callback, $meta_data)
{
    require_code('spout/vendor/autoload');

    ini_set('default_charset', get_charset());

    switch ($ext) {
        case 'xls':
            $type = Type::XLS;
            break;

        case 'xlsx':
            $type = Type::XLSX;
            break;

        case 'html':
        case 'htm':
            $type = Type::HTM;
            break;

        case 'csv':
        default:
            $type = Type::CSV;
            break;
    }
    $writer = WriterFactory::create($type);
    if (method_exists($writer, 'setShouldUseInlineStrings')) {
        $writer->setShouldUseInlineStrings(false); // Inline strings are buggy in Excel, line-breaks don't initially show, until a new input within Excel shifts it to shared strings mode
    }

    if (is_null($outfile_path)) {
        if (!$output_and_exit) {
            ob_start();
        }
        $writer->openToFile('php://output');
    } else {
        $writer->openToFile($outfile_path);
    }

    // Add our data
    $row = 0;
    foreach ($data as $_i => $line) {
        if ($row == 0) // Header
        {
            $single_row = array();
            foreach (array_keys($line) as $column => $val) {
                $val = convert_to_internal_encoding($val, get_charset(), 'utf-8');

                $single_row[] = $val;
            }
            $writer->addRow($single_row);

            $row++;
        }

        // Main data
        $single_row = array();
        foreach (array_values($line) as $column => $val) {
            if (is_null($val)) {
                $val = '';
            } elseif (!is_string($val)) {
                $val = strval($val);
            }

            $val = convert_to_internal_encoding($val, get_charset(), 'utf-8');

            $single_row[] = $val;
        }
        if (isset($meta_data[$_i])) {
            $writer->addRow($single_row, $meta_data[$_i]);
        } else {
            $writer->addRow($single_row);
        }

        $row++;

        // Callback to insert extra data?
        if (is_callable($callback)) {
            $new_rows = call_user_func_array($callback, array($line, isset($data[$_i + 1]) ? $data[$_i + 1] : null));
            foreach ($new_rows as $new_line) {
                $single_row = array();
                foreach (array_values($new_line) as $column => $val) {
                    if (is_null($val)) {
                        $val = '';
                    } elseif (!is_string($val)) {
                        $val = strval($val);
                    }

                    $val = convert_to_internal_encoding($val, get_charset(), 'utf-8');

                    $single_row[] = $val;
                }
                $writer->addRow($single_row);

                $row++;
            }
        }
    }

    $writer->close();

    if ($output_and_exit) {
        if (!is_null($outfile_path)) {
            readfile($outfile_path);
            @unlink($outfile_path);
        }

        $out = '';

        $GLOBALS['SCREEN_TEMPLATE_CALLED'] = '';

        @ini_set('ocproducts.xss_detect', '0');

        exit();
    } else {
        if (is_null($outfile_path)) {
            $out = ob_get_clean();
        } else {
            $out = '';
        }
    }

    return $out;
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    excel_support
 */

use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;

function spreadsheet_export__spout($ext, $data, $filename, $headers, $output_and_exit, $outfile_path, $callback, $metadata)
{
    require_code('character_sets');

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

    if ($outfile_path === null) {
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
        if ($row == 0) { // Header
            $single_row = array();
            foreach (array_keys($line) as $column => $val) {
                if ($val === null) {
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

        // Main data
        $single_row = array();
        foreach (array_values($line) as $column => $val) {
            if ($val === null) {
                $val = '';
            } elseif (!is_string($val)) {
                $val = strval($val);
            }

            $val = convert_to_internal_encoding($val, get_charset(), 'utf-8');

            $single_row[] = $val;
        }
        if (isset($metadata[$_i])) {
            $writer->addRow($single_row, empty($metadata[$_i]) ? array() : $metadata[$_i]);
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
                    if ($val === null) {
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
        if ($outfile_path !== null) {
            cms_ob_end_clean();
            readfile($outfile_path);

            @unlink($outfile_path);
        }

        $out = '';

        $GLOBALS['SCREEN_TEMPLATE_CALLED'] = '';

        @ini_set('ocproducts.xss_detect', '0');

        exit();
    } else {
        if ($outfile_path === null) {
            $out = ob_get_clean();
        } else {
            $out = '';
        }
    }

    return $out;
}

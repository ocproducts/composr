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
 * Find file meta information for adding to a ZIP file
 *
 * @param  PATH $path The full path to the folder to add
 * @param  PATH $subpath The subpath relative to the path (should be left as the default '', as this is used for the recursion to distinguish the adding base path from where it's currently looking)
 * @return array A list of maps that stores time,full_path,name, for each file
 */
function zip_scan_folder($path, $subpath = '')
{
    require_code('files');

    $_full = ($path == '') ? $subpath : ($path . '/' . $subpath);
    if ($_full == '') {
        $_full = '.';
    }
    $info = array();
    $dh = @opendir($_full);
    if ($dh !== false) {
        while (($entry = readdir($dh)) !== false) {
            $_subpath = ($subpath == '') ? $entry : ($subpath . '/' . $entry);
            if (!should_ignore_file($_subpath)) {
                $full = ($path == '') ? $_subpath : ($path . '/' . $_subpath);
                if (!is_readable($full)) {
                    continue;
                }
                if (is_dir($full)) {
                    $info2 = zip_scan_folder($path, $_subpath);
                    $info = array_merge($info, $info2);
                } else {
                    $mtime = filemtime($full);
                    $info[] = array('full_path' => $full, 'name' => $_subpath, 'time' => $mtime);
                }
            }
        }
        closedir($dh);
    }
    return $info;
}

/**
 * Calculate CRC32 for a file. Based on a function in the PHP docs.
 *
 * @param  PATH $filename The file
 * @return ?integer The CRC (null: error)
 */
function crc32_file($filename)
{
    if (function_exists('hash_file')) {
        $crc = hash_file('crc32b', $filename);

        // Detect PHP bug http://bugs.php.net/bug.php?id=45028
        $reverse = false;
        $tempnam = cms_tempnam();
        $myfile = fopen($tempnam, 'wb');
        fwrite($myfile, 'test');
        fclose($myfile);
        $crc_test = hash_file('crc32b', $tempnam);
        @unlink($tempnam);
        if ($crc_test == '0c7e7fd8') {
            $reverse = true;
        }

        if (!$reverse) {
            return hexdec($crc);
        }
        return hexdec(substr($crc, 6, 2) . substr($crc, 4, 2) . substr($crc, 2, 2) . substr($crc, 0, 2));
    }

    return crc32(file_get_contents($filename));
}

/**
 * Create a ZIP file.
 *
 * @param  array $file_array A list of maps (time,data/full_path,name) covering everything to ZIP up
 * @param  boolean $stream Whether to stream the output direct to the browser
 * @param  boolean $get_offsets Whether to return the tuple
 * @param  ?PATH $outfile_path File to spool into (null: none). $stream will be forced to false
 * @return mixed The data for the ZIP file OR a tuple: data, offsets, sizes; will be blank if $stream is true or $outfile_path is not null
 */
function create_zip_file($file_array, $stream = false, $get_offsets = false, $outfile_path = null)
{
    $outfile = mixed();
    if (!is_null($outfile_path)) {
        $stream = false;
        $outfile = fopen($outfile_path, 'w+b');
    }

    if ($stream) {
        safe_ini_set('ocproducts.xss_detect', '0');

        flush(); // Works around weird PHP bug that sends data before headers, on some PHP versions
    }

    $out = '';

    $offset = 0;
    $offsets = array();
    $sizes = array();

    // Write files
    foreach ($file_array as $i => $file) {
        $file_array[$i]['offset'] = $offset;

        $date = getdate($file['time']);
        if ((!array_key_exists('data', $file)) || (is_null($file['data']))) {
            $crc = crc32_file($file['full_path']);
            $uncompressed_size = filesize($file['full_path']);
        } else {
            $crc = crc32($file['data']);
            $uncompressed_size = strlen($file['data']);
        }
        $file_array[$i]['crc'] = $crc;
        $compressed_size = $uncompressed_size;

        $now_date = (($date['year'] - 1980) << 25) | ($date['mon'] << 21) | ($date['mday'] << 16) | ($date['hours'] << 11) | ($date['minutes'] << 5) | ($date['seconds'] >> 1);
        $file_array[$i]['date'] = $now_date;

        $offsets[$file['name']] = $offset + 30 + strlen($file['name']);

        $out .= pack('VvvvVVVVvv', 0x04034b50, 10, 0, 0, $now_date, $crc, $compressed_size, $uncompressed_size, strlen($file['name']), 0);
        $out .= $file['name'];

        if ($stream) {
            echo $out;
            $offset += strlen($out) + $uncompressed_size;
            if ((!array_key_exists('data', $file)) || (is_null($file['data']))) {
                readfile($file['full_path']);
            } else {
                echo $file['data'];
            }
            $out = '';
        } else {
            if (!is_null($outfile)) {
                if ((!array_key_exists('data', $file)) || (is_null($file['data']))) {
                    $tmp = fopen($file['full_path'], 'rb');
                    while (!feof($tmp)) {
                        $data = fread($tmp, 1024 * 1024);
                        if ($data !== false) {
                            fwrite($outfile, $data);
                        }
                    }
                    fclose($tmp);
                    $offset += filesize($file['full_path']);
                } else {
                    fwrite($outfile, $file['data']);
                    $offset += strlen($file['data']);
                }
            } else {
                if ((!array_key_exists('data', $file)) || (is_null($file['data']))) {
                    $out .= file_get_contents($file['full_path']);
                } else {
                    $out .= $file['data'];
                }
                $offset = strlen($out);
            }
        }

        if ((!array_key_exists('data', $file)) || (is_null($file['data']))) {
            $sizes[$file['name']] = filesize($file['full_path']);
        } else {
            $sizes[$file['name']] = strlen($file['data']);
        }
    }

    // Write directory
    $size = 0;
    foreach ($file_array as $file) {
        if ((!array_key_exists('data', $file)) || (is_null($file['data']))) {
            $uncompressed_size = filesize($file['full_path']);
        } else {
            $uncompressed_size = strlen($file['data']);
        }

        $compressed_size = $uncompressed_size;

        $packed = pack('VvvvvVVVVvvvvvVV', 0x02014b50, 20, 10, 0, 0, $file['date'], $file['crc'], $compressed_size, $uncompressed_size, strlen($file['name']), 0, 0, 0, 0, 32, $file['offset']);
        $size += strlen($packed) + strlen($file['name']);
        $out .= $packed;
        $out .= $file['name'];

        if ($stream) {
            echo $out;
            $out = '';
        } else {
            if (!is_null($outfile)) {
                fwrite($outfile, $out);
                $out = '';
            }
        }
    }

    // End of file data
    $out .= pack('VvvvvVVv', 0x06054b50, 0, 0, count($file_array), count($file_array), $size, $offset, 0); // =46 bytes
    if ($stream) {
        echo $out;
        $out = '';
    } else {
        if (!is_null($outfile)) {
            fwrite($outfile, $out);
            $out = '';
        }
    }

    if ($get_offsets) {
        return array($out, $offsets, $sizes);
    }

    return $out;
}

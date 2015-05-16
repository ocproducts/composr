<?php

/*EXTRA FUNCTIONS: tempnam*/

ini_set('display_errors', '1');
ini_set('allow_url_fopen', '1');
error_reporting(E_ALL);
if (function_exists('set_time_limit')) {
    @set_time_limit(0);
}

$get_url = (isset($_GET['file']) && strlen(trim($_GET['file'])) > 0) ? $_GET['file'] : '';
$filename = rawurldecode(basename($get_url));

if ($get_url != '') {
    if (substr($get_url, 0, 4) != 'http') {
        exit('Security issue');
    }
    $matches = array();
    preg_match('/[^?]*/', $filename, $matches);
    $string = $matches[0];
    //split the string by the literal dot in the filename
    $pattern = preg_split('/\./', $string, -1, PREG_SPLIT_OFFSET_CAPTURE);
    //get the last dot position
    $lastdot = $pattern[count($pattern) - 1][1];
    //now extract the filename using the basename function
    $filename = basename(substr($string, 0, $lastdot - 1));

    preg_match('/[^?]*/', $get_url, $matches);
    $string = $matches[0];

    $pattern = preg_split('/\./', $string, -1, PREG_SPLIT_OFFSET_CAPTURE);

    $ext = '';
    if (count($pattern) > 1) {
        $filenamepart = $pattern[count($pattern) - 1][0];
        preg_match('/[^?]*/', $filenamepart, $matches);
        $ext = $matches[0];
    }

    $input_file = ($ext != '') ? $filename . '.' . $ext : $filename;

    $save_to_file = preg_replace('#\\\#', '/', realpath('./')) . '/queue/' . $input_file;

    //start upload
    $read = fopen(str_replace(' ', '%20', $get_url), "rb");

    /* Open a file for writing */
    $tmp_name = tempnam(('/tmp'), 'transcodereceive');
    $fp = fopen($tmp_name, "wb");

    /* Read the data 1 KB at a time
    and write to the file */
    while (($data = fread($read, 1024)) !== false) {
        fwrite($fp, $data);
    }

    rename($tmp_name, $save_to_file);

    /* Close the streams */
    fclose($fp);
    fclose($read);
}

echo 'Copied';

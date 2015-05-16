<?php

$get_url = (isset($_GET['file']) && strlen(trim($_GET['file'])) > 0) ? $_GET['file'] : '';
$filename = rawurldecode(basename($get_url));

if ($get_url != '') {
    rename(getcwd() . '/done/' . $filename, getcwd() . '/sent/' . $filename);
}

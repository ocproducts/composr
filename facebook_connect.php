<?php

$cache_expire = 60 * 60 * 24 * 365;
header('Expires: ' . gmdate('D, d M Y H:i:s', time() + $cache_expire) . ' GMT');
header_remove('Last-Modified');
header('Cache-Control: public, max-age=' . strval($cache_expire));
header_remove('Pragma');

echo '<script src="//connect.facebook.net/en_US/all.js"></script>';

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    facebook_support
 */

header('X-Robots-Tag: noindex');

$cache_expire = 60 * 60 * 24 * 365;
header('Expires: ' . gmdate('D, d M Y H:i:s', time() + $cache_expire) . ' GMT');
header_remove('Last-Modified');
header('Cache-Control: public, max-age=' . strval($cache_expire));
header_remove('Pragma');

echo '<script src="//connect.facebook.net/en_US/all.js"></script>';

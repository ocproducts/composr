<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    confluence
 */

function init__confluence2()
{
    require_code('confluence');
}

function confluence_proxy_script()
{
    global $CONFLUENCE_SUBDOMAIN;

    $url = qualify_url(cms_srv('QUERY_STRING'), get_confluence_base_url());

    list($output, $mime_type) = confluence_call_url($url);

    safe_ini_set('ocproducts.xss_detect', '0');

    if ((preg_match('#^image/#i', $mime_type) != 0) || (stripos($mime_type, 'svg') !== false)) {
        $mime_type = 'application/octet-stream';
        header('Location: ' . $url);
    }

    header('Content-Type: ' . $mime_type);

    echo $output;
}

<?php

function init__confluence()
{
    global $CONFLUENCE_SUBDOMAIN, $CONFLUENCE_SPACE, $CONFLUENCE_USERNAME, $CONFLUENCE_PASSWORD;
    $CONFLUENCE_SUBDOMAIN = 'composrtest';
    $CONFLUENCE_SPACE = 'TEST';
    $CONFLUENCE_USERNAME = 'chris+test';
    $CONFLUENCE_PASSWORD = 'cfstest';
}

function confluence_proxy_script()
{
    global $CONFLUENCE_SUBDOMAIN, $CONFLUENCE_SPACE, $CONFLUENCE_USERNAME, $CONFLUENCE_PASSWORD;

    $url = qualify_url(cms_srv('QUERY_STRING'), 'https://' . $CONFLUENCE_SUBDOMAIN . '.atlassian.net/');

    $auth = array($CONFLUENCE_USERNAME, $CONFLUENCE_PASSWORD);
    $output = http_download_file($url, null, true, false, 'Composr', null, null, null, null, null, null, null, $auth);

    safe_ini_set('ocproducts.xss_detect', '0');

    global $HTTP_DOWNLOAD_MIME_TYPE;
    header('Content-type: ' . $HTTP_DOWNLOAD_MIME_TYPE);

    echo $output;
}

function confluence_query($query)
{
    global $CONFLUENCE_SUBDOMAIN, $CONFLUENCE_SPACE, $CONFLUENCE_USERNAME, $CONFLUENCE_PASSWORD;

    require_code('json');

    $url = 'https://' . $CONFLUENCE_SUBDOMAIN . '.atlassian.net/wiki/rest/api/' . $query;
    $auth = array($CONFLUENCE_USERNAME, $CONFLUENCE_PASSWORD);
    $json = http_download_file($url, null, true, false, 'Composr', null, null, null, null, null, null, null, $auth);
    return json_decode($json, true);
}

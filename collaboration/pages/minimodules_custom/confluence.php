<?php

global $CONFLUENCE_SUBDOMAIN, $CONFLUENCE_SPACE, $CONFLUENCE_USERNAME, $CONFLUENCE_PASSWORD;

require_code('confluence');

$current_page = preg_replace('#\.htm.*$#', '', substr(cms_srv('REQUEST_URI'), strlen(parse_url(get_base_url(), PHP_URL_PATH)) + strlen(get_zone_name()) + 2));
$pages = confluence_query('content?spaceKey=' . $CONFLUENCE_SPACE . '&limit=10000');
foreach ($pages['results'] as $page) {
    $id = $page['id'];
    $title = $page['title'];
    $link = substr($page['_links']['webui'], strlen('/display/' . $CONFLUENCE_SPACE . '/'));

    if ($link == $current_page) {
        $full = confluence_query('content/' . $id . '?expand=body.styled_view,container');
        $html = $full['body']['styled_view']['value'];
        $html = preg_replace('# src="([^"]+)"#', ' src="' . find_script('confluence_proxy') . '?$1"', $html);
        echo $html;
        return;
    }
}

exit('Page not found');

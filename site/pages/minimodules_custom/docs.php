<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    confluence
 */

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

$error_msg = new Tempcode();
if (!addon_installed__messaged('confluence', $error_msg)) {
    return $error_msg;
}

require_code('confluence');
require_css('confluence');

/*
If you want to host multiple spaces you can clone this module and add some extra code like the below.

global $CONFLUENCE_SPACE;
$CONFLUENCE_SPACE = 'EXAMPLE';
*/

list($content_type, $id, $posting_day) = confluence_current_page_id();

if ($content_type == 'page') {
    $query = 'content/' . strval($id) . '?expand=body.view,container';
    $full = confluence_query($query);
    if (isset($full['results'])) {
        $html = $full['results'][0]['body']['view']['value'];
    } else {
        $html = $full['body']['view']['value'];
    }
} else {
    $query = 'content?expand=body.view,container&type=' . urlencode($content_type) . '&title=' . urlencode($id) . '&postingDay=' . urlencode($posting_day);
    $full = confluence_query($query);
    if (!isset($full['results'][0])) {
        warn_exit(do_lang_tempcode('MISSING_RESOURCE'));
    }
    $html = $full['results'][0]['body']['view']['value'];
}


$html = confluence_clean_page($html);

$root_id = confluence_root_id();

return do_template('CONFLUENCE_SCREEN', array('_GUID' => '33a65e7f6832fac49cbb1f8e77a9c7b0', 'HTML' => $html, 'ROOT_ID' => strval($root_id),
));

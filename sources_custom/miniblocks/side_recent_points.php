<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

$max = array_key_exists('max', $map) ? intval($map['max']) : 10;
$truncate_to = array_key_exists('truncate_to', $map) ? intval($map['truncate_to']) : 5;

$gifts = $GLOBALS['SITE_DB']->query('SELECT * FROM ' . get_table_prefix() . 'gifts g WHERE gift_from<>' . strval($GLOBALS['FORUM_DRIVER']->get_guest_id()) . ' ORDER BY g.id DESC', $max, null, false, false, array('reason' => 'SHORT_TRANS__COMCODE'));
echo '<div class="wide_table_wrap"><table class="columned_table results_table wide_table autosized_table">';

echo '<thead><tr>';
//echo '<th>From</th>';
echo '<th>To</th>';
echo '<th>&times;</th>';
echo '<th>For</th>';
echo '</tr></thead>';
echo '<tbody>';

require_code('templates_interfaces');

foreach ($gifts as $gift) {
    $amount = $gift['amount'];
    $from_name = $GLOBALS['FORUM_DRIVER']->get_username($gift['gift_from'], true);
    if (is_null($from_name)) {
        $from_name = '(Deleted)';
    }
    $to_name = $GLOBALS['FORUM_DRIVER']->get_username($gift['gift_to'], true);
    if (is_null($to_name)) {
        $from_name = '(Deleted)';
    }
    $from_url = build_url(array('page' => 'points', 'type' => 'member', 'id' => $gift['gift_from']), get_module_zone('points'));
    $to_url = build_url(array('page' => 'points', 'type' => 'member', 'id' => $gift['gift_to']), get_module_zone('points'));
    $reason = get_translated_text($gift['reason']);

    if (is_null($from_name)) {
        continue;
    }
    if (is_null($to_name)) {
        continue;
    }
    if ($amount <= 0) {
        continue;
    }

    $from_link = hyperlink($from_url, $from_name, false, true);
    $to_link = do_template('MEMBER_TOOLTIP', array('_GUID' => '0cdd0adf612cf0f50a732daa79718d09', 'SUBMITTER' => strval($gift['gift_to'])));//hyperlink($to_url, $to_name, false, true);

    echo '<tr>';
// echo '<td>'.$from_link->evaluate().'</td>';
    echo '<td>' . $to_link->evaluate() . '</td>';
    echo '<td>' . escape_html(integer_format($amount)) . '</td>';
    if (trim($reason) != '') {
        $blah = tpl_crop_text_mouse_over($reason . (($gift['anonymous'] == 0) ? ' (' . $from_name . ')' : ' (Anonymous)'), $truncate_to);
        echo '<td>' . $blah->evaluate() . '</td>';
    }
    echo '</tr>';
}
echo '</tbody>';

echo '</table></div>';

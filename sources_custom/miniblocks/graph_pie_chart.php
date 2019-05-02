<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    sortable_tables
 */

$error_msg = new Tempcode();
if (!addon_installed__messaged('sortable_tables', $error_msg)) {
    return $error_msg;
}

require_code('graphs');

$width = empty($map['width']) ? null : $map['width'];
$height = empty($map['height']) ? null : $map['height'];

$show_data_labels = empty($map['show_data_labels']) ? true : ($map['show_data_labels'] == '1');

$color_pool = empty($map['color_pool']) ? array() : explode(',', $map['color_pool']);

$file = empty($map['file']) ? 'uploads/website_specific/graph_test/pie_chart.csv' : $map['file'];

cms_ini_set('auto_detect_line_endings', '1'); // TODO: Remove with #3032
$myfile = fopen(get_custom_file_base() . '/' . $file, 'rb');
// TODO: #3032
$datapoints = array();
while (($line = fgetcsv($myfile)) !== false) {
    if (implode('', $line) == '') {
        continue;
    }

    if (count($line) < 2) {
        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
    }

    $datapoints[] = array(
        'label' => $line[0],
        'value' => $line[1],
        'tooltip' => implode(',', array_slice($line, 2)),
    );
}
fclose($myfile);

$tpl = graph_pie_chart($datapoints, $show_data_labels, $color_pool, $width, $height);
$tpl->evaluate_echo();

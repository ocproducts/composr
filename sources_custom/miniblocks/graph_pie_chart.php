<?php

require_code('graphs');

$width = empty($map['width']) ? null : $map['width'];
$height = empty($map['height']) ? null : $map['height'];

$show_data_labels = empty($map['show_data_labels']) ? true : ($map['show_data_labels'] == '1');

$color_pool = empty($map['color_pool']) ? array() : explode(',', $map['color_pool']);

$file = empty($map['file']) ? 'uploads/website_specific/graph_test/pie_chart.csv' : $map['file'];

$myfile = fopen(get_custom_file_base() . '/' . $file, 'rb');
$data = array();
while (($line = fgetcsv($myfile)) !== false) {
    if (implode('', $line) == '') {
        continue;
    }

    if (count($line) != 2) {
        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
    }

    $data[$line[0]] = $line[1];
}
fclose($myfile);

$tpl = graph_pie_chart($data, $show_data_labels, $color_pool, $width, $height);
$tpl->evaluate_echo();

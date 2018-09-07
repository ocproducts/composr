<?php

require_code('graphs');

$width = empty($map['width']) ? null : $map['width'];
$height = empty($map['height']) ? null : $map['height'];

$x_axis_label = empty($map['x_axis_label']) ? '' : $map['x_axis_label'];
$y_axis_label = empty($map['y_axis_label']) ? '' : $map['y_axis_label'];

$begin_at_zero = empty($map['begin_at_zero']) ? true : ($map['begin_at_zero'] == '1');

$color = empty($map['color']) ? null : $map['color'];

$file = empty($map['file']) ? 'uploads/website_specific/graph_test/scatter_diagram.csv' : $map['file'];

$myfile = fopen(get_custom_file_base() . '/' . $file, 'rb');
$datapoints = array();
while (($line = fgetcsv($myfile)) !== false) {
    if (implode('', $line) == '') {
        continue;
    }

    if ((count($line) < 2) || (count($line) > 3)) {
        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
    }

    $datapoints[] = array(
        'x' => $line[0],
        'y' => $line[1],
        'label' => implode(',', array_slice($line, 2)),
    );
}
fclose($myfile);

$tpl = graph_scatter_diagram($datapoints, $x_axis_label, $y_axis_label, $begin_at_zero, $color, $width, $height);
$tpl->evaluate_echo();

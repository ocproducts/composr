<?php

function _generate_graph_id()
{
    return md5(uniqid('', true));
}

function _normalise_graph_dims(&$width, &$height)
{
    if ($width === null) {
        $width = '';
    }
    if ($height === null) {
        $height = '';
    }
    // ^ If both are blank, it'll be responsive

    if (is_numeric($width)) {
        $width = $width . 'px';
    }
    if (is_numeric($height)) {
        $height = $height . 'px';
    }
}

function _generate_graph_color_pool(&$color_pool)
{
    $color_pool[] = '#c24a4a';
    $color_pool[] = '#4a4ac2';
    $color_pool[] = '#c2c24a';
}

function _search_graph_color_pool($i, $color_pool)
{
    return $color_pool[$i % count($color_pool)];
}

// 1 measure of scattered data across two uneven dimensions, with a feature to label each point individually
function graph_scatter_diagram($datapoints, $x_axis_label = '', $y_axis_label = '', $begin_at_zero = false, $color = null, $width = null, $height = null)
{
    if ($color === null) {
        $color_pool = array();
        _generate_graph_color_pool($color_pool);
        $color = $color_pool[0];
    }

    $id = _generate_graph_id();

    _normalise_graph_dims($width, $height);

    $_datapoints = array();
    foreach ($datapoints as $p) {
        $_datapoints[] = array(
            'X' => @strval($p['x']),
            'Y' => @strval($p['y']),
            'LABEL' => array_key_exists('label', $p) ? $p['label'] : '',
        );
    }

    return do_template('GRAPH_SCATTER_DIAGRAM', array(
        'ID' => $id,
        'WIDTH' => $width,
        'HEIGHT' => $height,
        'X_AXIS_LABEL' => $x_axis_label,
        'Y_AXIS_LABEL' => $y_axis_label,
        'DATAPOINTS' => $_datapoints,
        'COLOR' => $color,
        'BEGIN_AT_ZERO' => $begin_at_zero,
    ));
}

// Multiple measures across one even dimension (x) and one uneven dimension (y)
function graph_line_chart($datasets, $x_labels = null, $x_axis_label = '', $y_axis_label = '', $begin_at_zero = true, $show_data_labels = true, $color_pool = array(), $width = null, $height = null)
{
    _generate_graph_color_pool($color_pool);

    $id = _generate_graph_id();

    _normalise_graph_dims($width, $height);

    if (count($datasets) == 0) {
        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
    }

    if ($x_labels === null) {
        $x_labels = range(0, count($dataset[0]['data']));
    }

    $_datasets = array();
    foreach ($datasets as $i => $dataset) {
        if (count($dataset['data']) != count($x_labels)) {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }

        $_datasets[] = array(
            'LABEL' => $dataset['label'],
            'COLOR' => isset($dataset['color']) ? $dataset['color'] : _search_graph_color_pool($i, $color_pool),
            'DATA' => @array_map('strval', $dataset['data']),
        );
    }

    return do_template('GRAPH_LINE_CHART', array(
        'ID' => $id,
        'WIDTH' => $width,
        'HEIGHT' => $height,
        'X_LABELS' => $x_labels,
        'X_AXIS_LABEL' => $x_axis_label,
        'Y_AXIS_LABEL' => $y_axis_label,
        'DATASETS' => $_datasets,
        'BEGIN_AT_ZERO' => $begin_at_zero,
        'SHOW_DATA_LABELS' => $show_data_labels,
    ));
}

// 1 measure across one small even dimension (different segments) and one uneven dimension (angle) [unlabelled dimensions]
function graph_pie_chart($data, $show_data_labels = true, $color_pool = array(), $width = null, $height = null)
{
    _generate_graph_color_pool($color_pool);

    $id = _generate_graph_id();

    _normalise_graph_dims($width, $height);

    $i = 0;
    $_data = array();
    foreach ($data as $label => $value) {
        $_data[] = array(
            'LABEL' => $label,
            'VALUE' => $value,
            'COLOR' => _search_graph_color_pool($i, $color_pool),
        );
        $i++;
    }

    return do_template('GRAPH_PIE_CHART', array(
        'ID' => $id,
        'WIDTH' => $width,
        'HEIGHT' => $height,
        'DATA' => $_data,
        'SHOW_DATA_LABELS' => $show_data_labels,
    ));
}

// 1 measure across one large even dimension (x) and one uneven dimension (y)
function graph_bar_chart($data, $x_axis_label = '', $y_axis_label = '', $begin_at_zero = true, $show_data_labels = true, $color_pool = array(), $width = null, $height = null)
{
    _generate_graph_color_pool($color_pool);

    $id = _generate_graph_id();

    _normalise_graph_dims($width, $height);

    $i = 0;
    $_data = array();
    foreach ($data as $label => $value) {
        $_data[] = array(
            'LABEL' => $label,
            'VALUE' => $value,
            'COLOR' => _search_graph_color_pool($i, $color_pool),
        );
        $i++;
    }

    return do_template('GRAPH_BAR_CHART', array(
        'ID' => $id,
        'WIDTH' => $width,
        'HEIGHT' => $height,
        'X_AXIS_LABEL' => $x_axis_label,
        'Y_AXIS_LABEL' => $y_axis_label,
        'DATA' => $_data,
        'BEGIN_AT_ZERO' => $begin_at_zero,
        'SHOW_DATA_LABELS' => $show_data_labels,
    ));
}

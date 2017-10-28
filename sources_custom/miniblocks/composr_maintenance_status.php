<?php

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

$myfile = fopen(get_custom_file_base() . '/data/maintenance_status.csv', 'rb');

$header_row = fgetcsv($myfile); // Header row
unset($header_row[0]);

$rows = array();
while (($row = fgetcsv($myfile)) !== false) {
    $codename = $row[0];
    unset($row[0]);
    $rows[$codename] = array('DATA' => array_values($row), 'CODENAME' => $codename);
}
ksort($rows, SORT_NATURAL | SORT_FLAG_CASE);

fclose($myfile);

return do_template('BLOCK_COMPOSR_MAINTENANCE_STATUS', array(
    'HEADER_ROW' => array_values($header_row),
    'ROWS' => $rows,
));
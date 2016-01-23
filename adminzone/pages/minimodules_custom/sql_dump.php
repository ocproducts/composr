<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    xml_db_manage
 */

/*EXTRA FUNCTIONS: shell_exec*/

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

disable_php_memory_limit();
if (php_function_allowed('set_time_limit')) {
    set_time_limit(0);
}
$GLOBALS['NO_DB_SCOPE_CHECK'] = true;

$filename = 'composr-' . get_site_name() . '.' . date('Y-m-d') . '.sql';

if (!isset($_GET['testing'])) {
    header('Content-Type: application/octet-stream' . '; authoritative=true;');
    header('Content-Disposition: attachment; filename="' . str_replace("\r", '', str_replace("\n", '', addslashes($filename))) . '"');
} else {
    header('Content-type: text/plain; charset=' . get_charset());
}

require_code('database_toolkit');

if ((strpos(ini_get('disallowed_functions'), 'shell_exec') === false) && (strpos(get_db_type(), 'mysql') !== false)) {
    $cmd = 'mysqldump -h' . get_db_site_host() . ' -u' . get_db_site_user() . ' -p' . get_db_site_password() . ' ' . get_db_site() . ' 2>&1';
    $filename = 'dump_' . uniqid('', true) . '.sql';
    $target_file = get_custom_file_base() . '/' . $filename;
    $cmd .= ' > ' . $target_file;
    $msg = shell_exec($cmd);
    if (($msg != '') || (filesize($target_file) == 0)) {
        /*echo 'Error'; For debugging
        if ($msg!='') echo ' - '.$msg; */
    } else {
        require_code('site2');
        smart_redirect(get_custom_base_url() . '/' . $filename);
        exit();
    }
}/* else*/
{
    $st = get_sql_dump(false, false, null, null, null, true);
    foreach ($st as $s) {
        echo $s;
        echo "\n\n";
    }
}

$GLOBALS['SCREEN_TEMPLATE_CALLED'] = '';
exit();

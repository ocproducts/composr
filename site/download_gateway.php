<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    downloads
 */

// Find Composr base directory, and chdir into it
global $FILE_BASE, $RELATIVE_PATH;
$FILE_BASE = (strpos(__FILE__, './') === false) ? __FILE__ : realpath(__FILE__);
$FILE_BASE = dirname($FILE_BASE);
if (!is_file($FILE_BASE . '/sources/global.php')) {
    $RELATIVE_PATH = basename($FILE_BASE);
    $FILE_BASE = dirname($FILE_BASE);
} else {
    $RELATIVE_PATH = '';
}
if (!is_file($FILE_BASE . '/sources/global.php')) {
    $FILE_BASE = $_SERVER['SCRIPT_FILENAME']; // this is with symlinks-unresolved (__FILE__ has them resolved); we need as we may want to allow zones to be symlinked into the base directory without getting path-resolved
    $FILE_BASE = dirname($FILE_BASE);
    if (!is_file($FILE_BASE . '/sources/global.php')) {
        $RELATIVE_PATH = basename($FILE_BASE);
        $FILE_BASE = dirname($FILE_BASE);
    } else {
        $RELATIVE_PATH = '';
    }
}
@chdir($FILE_BASE);

global $FORCE_INVISIBLE_GUEST;
$FORCE_INVISIBLE_GUEST = false;
global $EXTERNAL_CALL;
$EXTERNAL_CALL = false;
if (!is_file($FILE_BASE . '/sources/global.php')) {
    exit('<!DOCTYPE html>' . "\n" . '<html lang="EN"><head><title>Critical startup error</title></head><body><h1>Composr startup error</h1><p>The second most basic Composr startup file, sources/global.php, could not be located. This is almost always due to an incomplete upload of the Composr system, so please check all files are uploaded correctly.</p><p>Once all Composr files are in place, Composr must actually be installed by running the installer. You must be seeing this message either because your system has become corrupt since installation, or because you have uploaded some but not all files from our manual installer package: the quick installer is easier, so you might consider using that instead.</p><p>ocProducts maintains full documentation for all procedures and tools, especially those for installation. These may be found on the <a href="http://compo.sr">Composr website</a>. If you are unable to easily solve this problem, we may be contacted from our website and can help resolve it for you.</p><hr /><p style="font-size: 0.8em">Composr is a website engine created by ocProducts.</p></body></html>');
}
require($FILE_BASE . '/sources/global.php');

$id = get_param_integer('id');
$result = $GLOBALS['SITE_DB']->query_select('download_downloads', array('name', 'url_redirect'), array('id' => $id), '', 1);
if (!isset($result[0])) {
	warn_exit(do_lang_tempcode('MISSING_RESOURCE'));
}
$name = $result[0]['name'];
$url = $result[0]['url_redirect'];
$keep = symbol_tempcode('KEEP', array('0', '1'));
$download_url = find_script('dload') . '?id=' . strval($id) . '&final_link=1' . $keep->evaluate();
if (get_option('anti_leech') == 1) {
	$download_url .= '&for_session=' . md5(strval(get_session_id()));
}
if (!looks_like_url($url)) {
	list($zone,$attributes) = page_link_decode($url);
	$url = find_script('iframe') . '?zone=' . urlencode($zone);
	foreach ($attributes as $key => $val) {
	 $url .= '&' . $key . '=' . urlencode($val);
	}
}
attach_to_screen_header('<meta http-equiv="refresh" content="2; URL=' . $download_url . '">');
if (get_param_integer('final_link', 0) == 0 && $url != '') {
     $tpl = do_template('DOWNLOAD_GATEWAY', array('NAME' => $name, 'ID' => strval($id), 'DOWNLOAD_URL' => $download_url, 'URL' => $url));
     $tpl_wrapped = globalise($tpl, null, '', true);
     $tpl_wrapped->evaluate_echo();
     exit();
}

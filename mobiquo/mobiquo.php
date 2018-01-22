<?php /*

 Composr
 Copyright (c) ocProducts/Tapatalk, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    cns_tapatalk
 */

/*EXTRA FUNCTIONS: Mobiquo.**/

define('IN_MOBIQUO', true);
define('FORUM_ROOT', dirname(__FILE__));

if (isset($_GET['welcome'])) {
    include(dirname(__FILE__) . '/smartbanner/app.php');
    exit();
}

define('COMMON_CLASS_PATH_READ', dirname(__FILE__) . '/mbqClass/read');
define('COMMON_CLASS_PATH_WRITE', dirname(__FILE__) . '/mbqClass/write');
define('COMMON_CLASS_PATH_ACL', dirname(__FILE__) . '/mbqClass/acl');
define('COMMON_CLASS_PATH_INCLUDE', dirname(__FILE__) . '/include');

include(COMMON_CLASS_PATH_INCLUDE . '/mobiquo_functions.php');
include(COMMON_CLASS_PATH_INCLUDE . '/common_functions.php');
include(COMMON_CLASS_PATH_INCLUDE . '/forum_functions.php');
include(COMMON_CLASS_PATH_INCLUDE . '/member_functions.php');
include(COMMON_CLASS_PATH_INCLUDE . '/permission_functions.php');
include(COMMON_CLASS_PATH_INCLUDE . '/pm_functions.php');

require(dirname(__FILE__) . '/lib/mobiquo.php');

initialise_composr();

// This is needed here, due to the $xmlrpc* globals being needed in server_define, regardless of protocol
require(dirname(__FILE__) . '/lib/xmlrpc.php');
require(dirname(__FILE__) . '/lib/xmlrpcs.php');

initialise_mobiquo();

include(COMMON_CLASS_PATH_INCLUDE . '/server_define.php');

global $MOBIQUO_SERVER;
$headers = apache_request_headers();
$content_type = isset($headers['Content-Type']) ? $headers['Content-Type'] : '';

switch ($content_type) {
    case 'application/json':
        require(dirname(__FILE__) . '/lib/mobiquo_json.php');
        $MOBIQUO_SERVER = new MobiquoServerJSON();
        break;
    case 'text/xml':
        require(dirname(__FILE__) . '/lib/mobiquo_xmlrpc.php');
        $MOBIQUO_SERVER = new MobiquoServerXMLRPC();
        break;
    default:
        if (isset($_POST['method_name']) || isset($_GET['method_name'])) {
            require(dirname(__FILE__) . '/lib/mobiquo_post.php');
            $MOBIQUO_SERVER = new MobiquoServerPOST();
        } else {
            require(dirname(__FILE__) . '/lib/mobiquo_xmlrpc.php');
            $MOBIQUO_SERVER = new MobiquoServerXMLRPC();
        }
        break;
}

require(dirname(__FILE__) . '/lib/classTTConnection.php');
require(dirname(__FILE__) . '/lib/classTTCipherEncrypt.php');
require(dirname(__FILE__) . '/lib/TapatalkPush.php');

$request_method_name = $MOBIQUO_SERVER->get_method_name();

header('Mobiquo_is_login: ' . (is_guest() ? 'false' : 'true'));

global $SERVER_DEFINE;
if (!empty($request_method_name) && isset($SERVER_DEFINE[$request_method_name])) {
    $filename = request_helper_get_file($request_method_name);
    require_once(dirname(__FILE__) . '/api/' . $filename . '.php');
}

if ((is_file(TAPATALK_LOG)) && (is_writable_wrap(TAPATALK_LOG))) {
    // Request
    $log_file = fopen(TAPATALK_LOG, 'at');
    flock($log_file, LOCK_EX);
    fseek($log_file, 0, SEEK_END);
    fwrite($log_file, TAPATALK_REQUEST_ID . ' -- ' . date('Y-m-d H:i:s') . " *REQUEST*:\n");
    fwrite($log_file, 'GET: ' . serialize($_GET) . "\n");
    fwrite($log_file, 'COOKIE: ' . serialize($_COOKIE) . "\n");
    if (count($_POST) == 0) {
        $post_data = @file_get_contents('php://input');
        fwrite($log_file, 'POST: ' . $post_data . "\n");
    } else {
        fwrite($log_file, 'POST: ' . serialize($_POST) . "\n");
    }
    fwrite($log_file, 'FILES: ' . serialize($_FILES) . "\n");
    fwrite($log_file, 'USERNAME: ' . $GLOBALS['FORUM_DRIVER']->get_username(get_member()) . "\n");
    fwrite($log_file, "\n\n");
    flock($log_file, LOCK_UN);
    fclose($log_file);

    // Response
    ob_start();
    ob_start();
    function _do_response_logging()
    {
        $log_file = fopen(TAPATALK_LOG, 'at');
        flock($log_file, LOCK_EX);
        fseek($log_file, 0, SEEK_END);
        fwrite($log_file, TAPATALK_REQUEST_ID . ' -- ' . date('Y-m-d H:i:s') . " *RESPONSE*:\n");
        fwrite($log_file, 'HEADERS: ' . serialize(headers_list()) . "\n");
        fwrite($log_file, ob_get_contents() . "\n");
        fwrite($log_file, "\n\n");
        flock($log_file, LOCK_UN);
        fclose($log_file);

        @ob_end_flush();
    }

    register_shutdown_function('_do_response_logging');
}

require_code('failure');
set_throw_errors();

$MOBIQUO_SERVER->dispatch_request();

exit();

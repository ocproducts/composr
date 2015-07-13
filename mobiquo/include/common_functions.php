<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    cns_tapatalk
 */

/*EXTRA FUNCTIONS: json_encode*/

if (!defined('IN_MOBIQUO') && !function_exists('get_base_url')) {
    exit('May not call this directly');
}

if (!function_exists('apache_request_headers')) {
    /**
     * Get HTTP headers.
     *
     * @return array List of headers
     */
    function apache_request_headers()
    {
        $headers = array();
        foreach ($_SERVER as $h => $v) {
            $matches = array();
            if (preg_match('#^HTTP\_(.+)$', $h, $matches)) {
                $headers[$matches[1]] = $v;
            }
        }
        return $headers;
    }
}

/**
 * Bootstrap Composr.
 */
function initialise_composr()
{
    global $FILE_BASE, $RELATIVE_PATH;
    $FILE_BASE = dirname(dirname(dirname(__FILE__)));
    $RELATIVE_PATH = 'data_custom';

    global $FORCE_INVISIBLE_GUEST;
    $FORCE_INVISIBLE_GUEST = false;
    global $EXTERNAL_CALL;
    $EXTERNAL_CALL = true;

    if (!is_file($FILE_BASE . '/sources/global.php')) {
        exit(json_encode(array('status' => 'Required system file is missing')));
    }
    require_once($FILE_BASE . '/sources/global.php');

    error_reporting(E_ALL);
    ini_set('ocproducts.type_strictness', '0'); // Much Tapatalk client code will not be compatible with this

    cns_require_all_forum_stuff();

    require_lang('tapatalk');

    require_code('developer_tools');

    require_code('character_sets');
}

/**
 * Find pagination positions.
 *
 * @param  array $params Parameters
 * @param  integer $start_param_num Start parameter index
 * @param  integer $end_param_num End parameter index
 * @param  integer $default_max Default maximum parameter
 * @return array A pair: start position, max results
 */
function get_pagination_positions($params, $start_param_num, $end_param_num, $default_max)
{
    $start = isset($params[$start_param_num]) ? intval($params[$start_param_num]) : 0;
    if (isset($params[$end_param_num])) {
        $max = intval($params[$end_param_num]) - $start + 1;
    } else {
        $max = $default_max;
    }

    if ($max < 0 || $max > 50) {
        warn_exit('Out-of-range');
    }

    return array($start, $max);
}

/**
 * Find pagination positions, for different pattern of parameters.
 *
 * @param  array $params Parameters
 * @param  integer $page_param_num Page parameter index
 * @param  integer $max_param_num Max parameter index
 * @param  integer $default_max Default maximum parameter
 * @return array A pair: start position, max results
 */
function get_pagination_positions__by_page($params, $page_param_num, $max_param_num, $default_max)
{
    if (count($params) > 1) {
        $page = $params[$page_param_num];
        $max = $params[$max_param_num];
        $start = ($page - 1) * $max;
    } else {
        $start = 0;
        $max = $default_max;
    }

    if ($max < 0 || $max > 50) {
        warn_exit('Out-of-range');
    }

    return array($start, $max);
}

/**
 * Add attachments to some Comcode.
 *
 * @param  string $comcode Comcode
 * @param  array $attachment_ids Attachment IDs
 * @return string Comcode
 */
function add_attachments_from_comcode($comcode, $attachment_ids)
{
    foreach ($attachment_ids as $attachment_id) {
        $comcode .= "\n\n" . '[attachment]' . strval($attachment_id) . '[/attachment]';
    }
    return $comcode;
}

/**
 * Take attachments out of some Comcode.
 *
 * @param  string $comcode Comcode
 * @return string Comcode
 */
function strip_attachments_from_comcode($comcode)
{
    return preg_replace('#\n*\[attachment(_safe)?( [^\[\]]*)?\].*\[/attachment(_safe)?\]#U', '', $comcode);
}

/**
 * Strip out some Comcode so we can display on mobile.
 *
 * @param  string $data Comcode
 * @return string Rawer text
 */
function tapatalk_strip_comcode($data)
{
    $data = strip_attachments_from_comcode($data);

    $data = preg_replace('#\[url(\s[^\[\]*])?\]\s*(\[img(\s[^\[\]*])?\].*\[/img\])\s*\[/url\]#Us', '$1', $data); // No clickable images allowed

    // Certain tags are allowed, so rewrite them to not be stripped
    $protected_tags = array(
        'url',
        'img',
        'quote',
    );
    foreach ($protected_tags as $tag) {
        $data = preg_replace('#(\[)(/)?(' . $tag . ')([\s=][^\[\]]*)?(\])#Us', '#@#$2$3$4#@#', $data);
    }

    $data = strip_comcode($data);

    // Put protected tags back
    foreach ($protected_tags as $tag) {
        $data = preg_replace('#(\#@\#)(/)?(' . $tag . ')([\s=][^\[\]]*)?(\#@\#)#Us', '[$2$3$4]', $data);
    }

    $data = trim($data);

    return $data;
}

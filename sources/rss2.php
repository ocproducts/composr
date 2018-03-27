<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    syndication
 */

/**
 * Handle RSS cloud registrations.
 */
function backend_cloud_script()
{
    if (!addon_installed('syndication')) {
        warn_exit(do_lang_tempcode('MISSING_ADDON', escape_html('syndication')));
    }

    // Closed site
    $site_closed = get_option('site_closed');
    if (($site_closed == '1') && (!has_privilege(get_member(), 'access_closed_site')) && (!$GLOBALS['IS_ACTUALLY_ADMIN'])) {
        header('Content-type: text/plain; charset=' . get_charset());
        @exit(get_option('closed'));
    }

    $path = post_param_string('path', '');
    $procedure = post_param_string('registerProcedure', '');
    $protocol = post_param_string('protocol', '');
    if ($protocol == 'soap') {
        exit('false');
    }
    if ($protocol == 'http-post') {
        exit('false');
    }
    $port = post_param_integer('port', 80);
    // $watching_channel = $_POST['channels'];
    $status = _cloud_register_them($path, $procedure, $protocol, $port, get_param_string('type', ''));
    if (!$status) {
        exit('false');
    }
    exit('true');
}

/**
 * Set up an RSS cloud registration.
 *
 * @param  SHORT_TEXT $path The news category title
 * @param  ID_TEXT $procedure The procedure they are interested in
 * @param  ID_TEXT $protocol The protocol they are using
 * @param  integer $port The port to connect to them on
 * @param  string $watching_channel The channel they are interested in
 * @return boolean Success status
 *
 * @ignore
 */
function _cloud_register_them($path, $procedure, $protocol, $port, $watching_channel)
{
    $before = $GLOBALS['SITE_DB']->query_select_value_if_there('news_rss_cloud', 'register_time', array('watching_channel' => $watching_channel, 'rem_path' => $path, 'rem_ip' => get_ip_address()));
    if ($before !== null) {
        return false;
    }
    $GLOBALS['SITE_DB']->query_insert('news_rss_cloud', array('watching_channel' => $watching_channel, 'rem_procedure' => $procedure, 'rem_port' => $port, 'rem_path' => $path, 'rem_protocol' => $protocol, 'rem_ip' => get_ip_address(), 'register_time' => time()));
    return true;
}

/**
 * Handle RSS/Atom output.
 */
function rss_backend_script()
{
    if (!addon_installed('syndication')) {
        warn_exit(do_lang_tempcode('MISSING_ADDON', escape_html('syndication')));
    }

    // Closed site
    $site_closed = get_option('site_closed');
    if (($site_closed == '1') && (!has_privilege(get_member(), 'access_closed_site')) && (get_ip_address() != $_SERVER['SERVER_ADDR']) && (!$GLOBALS['IS_ACTUALLY_ADMIN'])) {
        header('Content-type: text/plain; charset=' . get_charset());
        @exit(get_option('closed'));
    }

    if (get_option('is_on_rss') == '0') {
        return;
    }

    $type = get_param_string('type', 'RSS2');
    $mode = get_param_string('mode', 'opml');
    require_lang('rss');
    require_code('xml');

    load_csp(array('csp_enabled' => '0')); // FUDGE: We need this for XSLT to work. We cannot put a nonce on an XSLT import, and we can't whitelist specific scripts

    if ($type == 'xslt-rss') {
        // Feed stylesheet for RSS
        header('Content-Type: text/xsl');
        require_css('rss');
        $js = get_custom_base_url() . substr(javascript_enforce('xsl_mopup'), strlen(get_custom_file_base()));
        $echo = do_template('RSS_XSLT', array('_GUID' => 'c443e0195c935117cf0d9a7bc2730d7a', 'XSL_MOPUP' => $js), null, false, null, '.xml', 'xml');
        $echo->evaluate_echo();
        return;
    }
    if ($type == 'xslt-atom') {
        // Feed stylesheet for Atom
        header('Content-Type: text/xsl');
        require_css('rss');
        $js = get_custom_base_url() . substr(javascript_enforce('xsl_mopup'), strlen(get_custom_file_base()));
        $echo = do_template('ATOM_XSLT', array('_GUID' => '27fec456a6b3144aa847130e74463d99', 'XSL_MOPUP' => $js), null, false, null, '.xml', 'xml');
        $echo->evaluate_echo();
        return;
    }
    if ($type == 'xslt-opml') {
        // Feed stylesheet for Atom
        header('Content-Type: text/xsl');
        require_css('rss');
        $js = get_custom_base_url() . substr(javascript_enforce('xsl_mopup'), strlen(get_custom_file_base()));
        $echo = do_template('OPML_XSLT', array('_GUID' => 'c0c6bd1d7a0e263768a2208061f799f5', 'XSL_MOPUP' => $js), null, false, null, '.xml', 'xml');
        $echo->evaluate_echo();
        return;
    }

    $type = strtoupper($type);
    if (($type != 'RSS2') && ($type != 'ATOM')) {
        $type = 'RSS2';
    }
    if ($type == 'RSS2') {
        $prefix = 'RSS_';
    } else {
        $prefix = 'ATOM_';
    }

    if ($type == 'RSS2') {
        $date_string = 'r';
    } else {
        $offset_seconds = intval(date('Z'));
        $offset_minutes = abs(intval(round(floatval($offset_seconds) / 60.0)));
        $offset_hours = intval(round(floatval($offset_minutes) / 60.0));
        $offset_minutes -= $offset_hours * 60;
        $offset = sprintf('%02d:%02d', $offset_hours, $offset_minutes);
        $date_string = 'Y-m-d\\TH:i:s';
        if ($offset_seconds >= 0) {
            $date_string .= '+';
        } else {
            $date_string .= '-';
        }
        for ($i = 0; $i < strlen($offset); $i++) {
            $date_string .= '\\' . $offset[$i];
        }
    }

    $date = date($date_string);

    $site_about = xmlentities(get_option('description'));
    $logo_url = xmlentities(find_theme_image('logo/standalone_logo'));
    $copyright = xmlentities(trim(str_replace('&copy;', '', str_replace('$CURRENT_YEAR', date('Y'), get_option('copyright')))));

    $cutoff = get_param_integer('cutoff', time() - 60 * 60 * 24 * get_param_integer('days', 30));
    $max = get_param_integer('max', 100);
    $select = get_param_string('select', '*', INPUT_FILTER_GET_COMPLEX);
    if ($select == '') {
        $select = '*';
    }

    if ($mode == 'opml') {
        header('Content-Type: text/xml');

        $_feeds = find_all_hook_obs('systems', 'rss', 'Hook_rss_');
        $feeds = array();
        foreach ($_feeds as $feed => $object) {
            if ((get_forum_type() != 'cns') && (substr($feed, 0, 4) == 'cns_')) {
                continue;
            }
            $feed_title = titleify($feed);

            // Try and get a better feed title
            require_code('selectcode');
            $_content = $object->run('', time(), 'ATOM_', '', 0);
            if ($_content === null) {
                continue;
            }
            if (is_array($_content)) {
                list(, $feed_title) = $_content;
            }

            $feeds[] = array('MODE' => $feed, 'TITLE' => $feed_title);
        }
        $echo = do_template('OPML_WRAPPER', array('_GUID' => '712b78d1b4c23aefc8a92603477f84ed', 'FEEDS' => $feeds, 'ABOUT' => $site_about, 'DATE' => $date), null, false, null, '.xml', 'xml');
        $echo->evaluate_echo();

        require_code('site');
        save_static_caching($echo, 'text/xml');

        return;
    }

    require_code('hooks/systems/rss/' . filter_naughty_harsh($mode), true);
    $object = object_factory('Hook_rss_' . filter_naughty_harsh($mode));
    require_code('selectcode');
    $_content = $object->run($select, $cutoff, $prefix, $date_string, $max);
    $mode_nice = $mode;
    if (is_array($_content)) {
        list($content, $mode_nice) = $_content;
    } else {
        $content = ($_content === null) ? array() : $_content;
    }

    if ($type == 'RSS2') {
        // Change a full URL into constituent parts
        $base_url = get_base_url();
        $port = 80;
        $end_protocol_pos = strpos($base_url, '://');
        $colon_pos = strpos($base_url, ':', $end_protocol_pos + 1);
        if ($colon_pos !== false) {
            $after_port_pos = strpos($base_url, '/', $colon_pos);
            if ($after_port_pos === false) {
                $after_port_pos = strlen($base_url);
            }
            $port = intval(substr($base_url, $colon_pos, $after_port_pos - $colon_pos));
        }
        $start_path_pos = strpos($base_url, '/', $end_protocol_pos + 4);
        if ($start_path_pos !== false) {
            $local_base_url = substr($base_url, $start_path_pos);
        } else {
            $local_base_url = '';
        }

        $rss_cloud = do_template('RSS_CLOUD', array('_GUID' => 'a47c40a4c137ea1e5abfc71346547313', 'TYPE' => ($type == 'news') ? '' : $type, 'PORT' => strval($port), 'LOCAL_BASE_URL' => $local_base_url), null, false, null, '.xml', 'xml');
    } else {
        $rss_cloud = new Tempcode();
    }

    // Firefox (and probably other browsers, but I didn't test) doesn't want to display Atom feeds inline if they're sent as text/xml+atom, even if the Content-Disposition is sent to inline :(
    header('Content-Type: text/xml'); // application/rss+xml ?

    if ($_SERVER['REQUEST_METHOD'] == 'HEAD') {
        return;
    }

    $echo = do_template($prefix . 'WRAPPER', array('SELECT' => $select, 'CUTOFF' => strval($cutoff), 'MODE' => $mode, 'MODE_NICE' => $mode_nice, 'RSS_CLOUD' => $rss_cloud, 'VERSION' => cms_version_pretty(), 'COPYRIGHT' => $copyright, 'DATE' => $date, 'LOGO_URL' => $logo_url, 'ABOUT' => $site_about, 'CONTENT' => $content, 'SELF_URL' => get_self_url_easy()), null, false, null, '.xml', 'xml');
    $echo->evaluate_echo();

    if ($mode != 'comments') {
        require_code('site');

        // This is just signalling to the static cache in this case, as there's no HTML <head>
        inform_non_canonical_parameter('cutoff');
        inform_non_canonical_parameter('days');
        inform_non_canonical_parameter('max');
        inform_non_canonical_parameter('select');

        save_static_caching($echo, 'text/xml');
    }
}

/**
 * Get enclosure details from a URL, as efficiently as possible.
 *
 * @param  URLPATH $url The (possibly short) URL to get details for
 * @param  URLPATH $enclosure_url The full URL to get details for
 * @return array A pair: the length of the data, the mime type
 */
function get_enclosure_details($url, $enclosure_url)
{
    $enclosure_length = '0';
    if ((url_is_local($url)) && (file_exists(get_custom_file_base() . '/' . rawurldecode($url)))) {
        $enclosure_length = strval(@filesize(get_custom_file_base() . '/' . rawurldecode($url)));
        require_code('mime_types');
        $enclosure_type = get_mime_type(get_file_extension($url), false);
    } else {
        $http_response = cms_http_request($enclosure_url, array('trigger_error' => false, 'byte_limit' => 0));
        $enclosure_length = strval($http_response->download_size);
        if ($enclosure_length === null) {
            $enclosure_length = strval(strlen(http_get_contents($enclosure_url)));
        }
        $enclosure_type = $http_response->download_mime_type;
    }
    return array($enclosure_length, $enclosure_type);
}

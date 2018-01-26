<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    stats
 */

/**
 * Function to find Alexa details of the site.
 *
 * @param  string $url The URL of the site which you want to find out information on.)
 * @return array Returns a pair with the rank, and the amount of links
 */
function get_alexa_rank($url)
{
    $test = get_value_newer_than('alexa__' . md5($url), time() - 60 * 60 * 24 * 5, true);
    if ($test !== null) {
       return unserialize($test);
    }

    require_code('files');
    $p = array();
    $result = http_get_contents('http://data.alexa.com/data?cli=10&dat=s&url=' . urlencode($url), array('trigger_error' => false, 'timeout' => 1.0));
    if (preg_match('#<POPULARITY [^<>]*TEXT="([0-9]+){1,}"#si', $result, $p) != 0) {
        $rank = integer_format(intval($p[1]));
    } else {
        $rank = '';
    }
    if (preg_match('#<LINKSIN [^<>]*NUM="([0-9]+){1,}"#si', $result, $p) != 0) {
        $links = integer_format(intval($p[1]));
    } else {
        $links = '';
    }

    // we would like, but cannot get (without an API key)...
    /*
        time on site
        reach (as a percentage)
        page views
        audience (i.e. what country views the site most)
     */

    $ret = array($rank, $links);

    set_value('alexa__' . md5($url), serialize($ret), true);

    return $ret;
}

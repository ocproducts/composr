<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    analysr
 */

/**
 * Hook class.
 */
class Hook_stats_external
{
    /**
     * Show a stats section.
     *
     * @return Tempcode The result of execution
     */
    public function run()
    {
        $bits = new Tempcode();
        $map = array();
        $url = get_base_url();
        list($rank, $links, $speed) = get_alexa_rank($url);
        if ($rank != '') {
            $map['Alexa rank'] = $rank;
        }
        if ($links != '') {
            $map['Back links'] = protect_from_escaping('<a title="Show back links" href="http://www.google.co.uk/search?as_lq=' . urlencode($url) . '">' . $links . '</a>');
        }
        if ($speed != '') {
            $map['Speed'] = $speed;
        }
        foreach ($map as $key => $val) {
            $bits->attach(do_template('BLOCK_SIDE_STATS_SUBLINE', array('_GUID' => 'fa391b1b773cd8a4b283cb6617af898b', 'KEY' => $key, 'VALUE' => ($val === null) ? '' : $val)));
        }
        $section = do_template('BLOCK_SIDE_STATS_SECTION', array('_GUID' => '0d26b94a7903aab57d76d72da53eca98', 'SECTION' => 'Meta stats', 'CONTENT' => $bits));

        return $section;
    }
}

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
        $rank = do_lang('NA');
    }
    if (preg_match('#<LINKSIN [^<>]*NUM="([0-9]+){1,}"#si', $result, $p) != 0) {
        $links = integer_format(intval($p[1]));
    } else {
        $links = '';
    }
    if (preg_match('#<SPEED [^<>]*PCT="([0-9]+){1,}"#si', $result, $p) != 0) {
        $speed = 'Top ' . integer_format(100 - intval($p[1])) . '%';
    } else {
        $speed = '';
    }

    // we would like, but cannot get (without an API key)...
    /*
        time on site
        reach (as a percentage)
        page views
        audience (i.e. what country views the site most)
     */

    $ret = array($rank, $links, $speed);

    set_value('alexa__' . md5($url), serialize($ret), true);

    return $ret;
}

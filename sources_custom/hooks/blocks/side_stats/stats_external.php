<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

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
     * @return Tempcode The result of execution.
     */
    public function run()
    {
        $bits = new Tempcode();
        $map = array();
        $url = get_base_url();
        list($rank, $links, $speed) = getAlexaRank($url);
        $page_rank = getPageRank($url);
        if ($page_rank != '') {
            $map['Google PageRank'] = $page_rank;
        }
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
            $bits->attach(do_template('BLOCK_SIDE_STATS_SUBLINE', array('_GUID' => 'fa391b1b773cd8a4b283cb6617af898b', 'KEY' => $key, 'VALUE' => is_null($val) ? '' : $val)));
        }
        $section = do_template('BLOCK_SIDE_STATS_SECTION', array('_GUID' => '0d26b94a7903aab57d76d72da53eca98', 'SECTION' => 'Meta stats', 'CONTENT' => $bits));

        return $section;
    }
}

function getAlexaRank($url)
{
    $test = get_value_newer_than('alexa__' . md5($url), time() - 60 * 60 * 24 * 5, true);
    if ($test !== null) {
        return unserialize($test);
    }

    require_code('files');
    $p = array();
    $result = http_download_file('http://data.alexa.com/data?cli=10&dat=s&url=' . urlencode($url), null, false, false, 'Composr', null, null, null, null, null, null, null, null, 1.0);
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

// Convert a string to a 32-bit integer
function StrToNum($str, $check, $magic)
{
    // This is external code which doesn't live up to Composr's strictness level
    require_code('developer_tools');
    destrictify();

    $int_32_unit = 4294967296;  // 2^32

    $length = strlen($str);
    for ($i = 0; $i < $length; $i++) {
        $check *= $magic;
        //If the float is beyond the boundaries of integer (usually +/- 2.15e+9=2^31),
        //  the result of converting to integer is undefined
        //  refer to http://www.php.net/manual/en/language.types.integer.php
        if ($check >= $int_32_unit) {
            $check = ($check - $int_32_unit * intval($check / $int_32_unit));
            //if the check less than -2^31
            $check = ($check < -2147483648) ? ($check + $int_32_unit) : $check;
        }
        $check += ord($str[$i]);
    }

    restrictify();

    return $check;
}

// Generate a hash for a url
function HashURL($string)
{
    $check1 = StrToNum($string, 0x1505, 0x21);
    $check2 = StrToNum($string, 0, 0x1003F);

    $check1 = $check1 >> 2;
    $check1 = (($check1 >> 4) & 0x3FFFFC0) | ($check1 & 0x3F);
    $check1 = (($check1 >> 4) & 0x3FFC00) | ($check1 & 0x3FF);
    $check1 = (($check1 >> 4) & 0x3C000) | ($check1 & 0x3FFF);

    $t1 = (((($check1 & 0x3C0) << 4) | ($check1 & 0x3C)) << 2) | ($check2 & 0xF0F);
    $t2 = @(((($check1 & 0xFFFFC000) << 4) | ($check1 & 0x3C00)) << 0xA) | ($check2 & 0xF0F0000);

    return ($t1 | $t2);
}

// Generate a checksum for the hash string
function CheckHash($hash_num)
{
    $check_byte = 0;
    $flag = 0;

    $hash_str = sprintf('%u', $hash_num);
    $length = strlen($hash_str);

    for ($i = $length - 1; $i >= 0; $i--) {
        $re = intval($hash_str[$i]);
        if (1 === ($flag % 2)) {
            $re += $re;
            $re = intval($re / 10) + ($re % 10);
        }
        $check_byte += $re;
        $flag++;
    }

    $check_byte = $check_byte % 10;
    if (0 !== $check_byte) {
        $check_byte = 10 - $check_byte;
        if (1 === ($flag % 2)) {
            if (1 === ($check_byte % 2)) {
                $check_byte += 9;
            }

            $check_byte = $check_byte >> 1;
        }
    }

    return '7' . strval($check_byte) . $hash_str;
}

// Return the pagerank checksum hash
function getch($url)
{
    return CheckHash(HashURL($url));
}

// Return the pagerank figure
function getpr($url)
{
    $ch = getch($url);
    $errno = '0';
    $errstr = '';
    $data = http_download_file('http://toolbarqueries.google.com/search?client=navclient-auto&ch=' . urlencode($ch) . '&features=Rank&q=info:' . $url, null, false);
    if (is_null($data)) {
        return '';
    }

    $pos = strpos($data, "Rank_");
    if ($pos !== false) {
        $pr = substr($data, $pos + 9);
        $pr = trim($pr);
        $pr = str_replace("\n", '', $pr);
        return $pr;
    }

    return '';
}

// Return the pagerank figure
function getPageRank($url)
{
    $test = get_value_newer_than('pr__' . md5($url), time() - 60 * 60 * 24 * 5, true);
    if ($test !== null) {
        return unserialize($test);
    }

    if (preg_match('/^(http:\/\/)?([^\/]+)/i', $url) == 0) {
        $url = 'http://' . $url;
    }
    $pr = getpr($url);

    set_value('pr__' . md5($url), serialize($pr), true);

    return $pr;
}

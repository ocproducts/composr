<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 */
class Block_side_last_fm
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = false;
        $info['parameters'] = array('username', 'period', 'display', 'title', 'width', 'height');
        return $info;
    }

    /**
     * Find cacheing details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled).
     */
    public function cacheing_environment()
    {
        $info = array();
        $info['cache_on'] = 'array(array_key_exists(\'username\',$map)?$map[\'username\']:\'\', array_key_exists(\'display\',$map)?$map[\'display\']:\'\', array_key_exists(\'period\',$map)?$map[\'period\']:\'\', array_key_exists(\'title\',$map)?$map[\'title\']:\'\', array_key_exists(\'width\',$map)?$map[\'width\']:\'100%\', array_key_exists(\'height\',$map)?$map[\'height\']:\'100%\')';
        $info['ttl'] = 15;
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters.
     * @return tempcode The result of execution.
     */
    public function run($map)
    {
        i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

        require_lang('last_fm');
        require_code('files');

        $display = (!empty($map['display'])) ? $map['display'] : 'artists';
        $period = (!empty($map['period'])) ? intval($map['period']) : 12;
        $username = array_key_exists('username', $map) ? $map['username'] : '';
        $width = (!empty($map['width'])) ? $map['width'] : '100%';//default: 100%
        $height = (!empty($map['height'])) ? $map['height'] : '100%';//default: 100%
        $title = (!empty($map['title'])) ? $map['title'] : do_lang_tempcode('BLOCK_LAST_FM_TITLE');

        if ($username == '') {
            $profile_url = 'http://www.last.fm/';
        } else {
            $profile_url = 'http://www.last.fm/user/' . $username;
        }

        if ($height != '100%') {
            $out = '<div style="overflow: auto; width: ' . $width . '!important; height: ' . $height . '!important;">';
        } else {
            $out = '<div style="overflow: auto; width: ' . $width . '!important;">';
        }

        $rss_url = '';

        if ($username == '') {
            if ($display == 'artists') {
                $rss_url = 'http://ws.audioscrobbler.com/2.0/chart/topartists.xml';
            } elseif ($display == 'albums') {
                $rss_url = 'http://ws.audioscrobbler.com/2.0/chart/topalbums.xml';
            } elseif ($display == 'tracks') {
                $rss_url = 'http://ws.audioscrobbler.com/2.0/chart/toptracks.xml';
            }
        } else {
            if ($display == 'artists') {
                $rss_url = 'http://ws.audioscrobbler.com/2.0/user/' . $username . '/topartists.xml';
            } elseif ($display == 'albums') {
                $rss_url = 'http://ws.audioscrobbler.com/2.0/user/' . $username . '/topalbums.xml';
            } elseif ($display == 'tracks') {
                $rss_url = 'http://ws.audioscrobbler.com/2.0/user/' . $username . '/toptracks.xml';
            }
        }

        if ($period == 3) {
            $rss_url .= '?period=3month';
        } elseif ($period == 6) {
            $rss_url .= '?period=6month';
        } elseif ($period == 12) {
            $rss_url .= '?period=12month';
        } elseif ($period == 'overall' || $period == '' || !isset($period)) {
            $rss_url .= '?period=overall';
        }

        //read XML into array
        $xml = xml2ary(http_download_file($rss_url));

        if (preg_match('#toptracks\.xml#', $rss_url)) {
            if (isset($xml['toptracks']['_c']['track']) && is_array($xml['toptracks']['_c']['track'])) {
                foreach ($xml['toptracks']['_c']['track'] as $track) {
                    $track_name = (isset($track['_c']['name']['_v']) && strlen($track['_c']['name']['_v']) > 0) ? $track['_c']['name']['_v'] : '';

                    $playcount = (isset($track['_c']['playcount']['_v']) && $track['_c']['playcount']['_v'] > 0) ? $track['_c']['playcount']['_v'] : 0;

                    $track_url = (isset($track['_c']['url']['_v']) && strlen($track['_c']['url']['_v']) > 0) ? $track['_c']['url']['_v'] : '';

                    $artist = (isset($track['_c']['artist']['_c']['name']['_v']) && strlen($track['_c']['artist']['_c']['name']['_v']) > 0) ? $track['_c']['artist']['_c']['name']['_v'] : '';

                    $artist_url = (isset($track['_c']['artist']['_c']['url']['_v']) && strlen($track['_c']['artist']['_c']['url']['_v']) > 0) ? $track['_c']['artist']['_c']['url']['_v'] : '';

                    $images = array();

                    if (isset($track['_c']['image']) && is_array($track['_c']['image'])) {
                        foreach ($track['_c']['image'] as $image) {
                            if (isset($image['_a']['size']) && strlen($image['_a']['size']) > 0) {
                                $images[$image['_a']['size']] = (isset($image['_v']) && strlen($image['_v']) > 0) ? $image['_v'] : '';
                            }
                        }
                    }

                    $track_images = (isset($images['medium'])) ? $images['medium'] : '';
                    if ($track_images == '' && count($images) > 0) {
                        $track_images = array_shift($images);
                    }

                    if ($track_images != '') {
                        $out .= '<div class="float_surrounder"><img width="64" src="' . $track_images . '" style="float: left; margin: 3px;" /><a href="' . $track_url . '" target="_blank">' . $track_name . '</a><br />';
                        $out .= '<a href="' . $artist_url . '" target="_blank" style="font-style: italic;">' . $artist . '</a><br />';
                        $out .= 'Total Plays: ' . $playcount . '</div><br />';
                    } else {
                        $out .= '<div class="float_surrounder"><a href="' . $track_url . '" target="_blank">' . $track_name . '</a><br />';
                        $out .= '<a href="' . $artist_url . '" target="_blank" style="font-style: italic;">' . $artist . '</a><br />';
                        $out .= 'Total Plays: ' . $playcount . '</div><br />';
                    }
                }
            }
        } elseif (preg_match('#topartists\.xml#', $rss_url)) {
            if (isset($xml['topartists']['_c']['artist']) && is_array($xml['topartists']['_c']['artist'])) {
                foreach ($xml['topartists']['_c']['artist'] as $artist_item) {
                    $playcount = (isset($artist_item['_c']['playcount']['_v']) && $artist_item['_c']['playcount']['_v'] > 0) ? $artist_item['_c']['playcount']['_v'] : 0;

                    $artist = (isset($artist_item['_c']['name']['_v']) && strlen($artist_item['_c']['name']['_v']) > 0) ? $artist_item['_c']['name']['_v'] : '';

                    $artist_url = (isset($artist_item['_c']['url']['_v']) && strlen($artist_item['_c']['url']['_v']) > 0) ? $artist_item['_c']['url']['_v'] : '';

                    $images = array();

                    if (isset($artist_item['_c']['image']) && is_array($artist_item['_c']['image'])) {
                        foreach ($artist_item['_c']['image'] as $image) {
                            if (isset($image['_a']['size']) && strlen($image['_a']['size']) > 0) {
                                $images[$image['_a']['size']] = (isset($image['_v']) && strlen($image['_v']) > 0) ? $image['_v'] : '';
                            }
                        }
                    }

                    $artist_image = (isset($images['medium'])) ? $images['medium'] : '';
                    if ($artist_image == '' && count($images) > 0) {
                        $artist_image = array_shift($images);
                    }

                    if ($artist_image != '') {
                        $out .= '<div class="float_surrounder"><img width="64" src="' . $artist_image . '" style="float: left; margin: 3px;" />';
                        $out .= '<a href="' . $artist_url . '" target="_blank" style="font-style: italic;">' . $artist . '</a><br />';
                        $out .= 'Total Plays: ' . $playcount . '</div><br />';
                    } else {
                        $out .= '<a href="' . $artist_url . '" target="_blank" style="font-style: italic;">' . $artist . '</a><br />';
                        $out .= 'Total Plays: ' . $playcount . '</div><br />';
                    }
                }
            }
        } elseif (preg_match('#topalbums\.xml#', $rss_url)) {
            if (isset($xml['topalbums']['_c']['album']) && is_array($xml['topalbums']['_c']['album'])) {
                foreach ($xml['topalbums']['_c']['album'] as $album) {
                    $album_name = (isset($album['_c']['name']['_v']) && strlen($album['_c']['name']['_v']) > 0) ? $album['_c']['name']['_v'] : '';

                    $playcount = (isset($album['_c']['playcount']['_v']) && $album['_c']['playcount']['_v'] > 0) ? $album['_c']['playcount']['_v'] : 0;

                    $album_url = (isset($album['_c']['url']['_v']) && strlen($album['_c']['url']['_v']) > 0) ? $album['_c']['url']['_v'] : '';

                    $artist = (isset($album['_c']['artist']['_c']['name']['_v']) && strlen($album['_c']['artist']['_c']['name']['_v']) > 0) ? $album['_c']['artist']['_c']['name']['_v'] : '';

                    $artist_url = (isset($album['_c']['artist']['_c']['url']['_v']) && strlen($album['_c']['artist']['_c']['url']['_v']) > 0) ? $album['_c']['artist']['_c']['url']['_v'] : '';

                    $images = array();

                    if (isset($album['_c']['image']) && is_array($album['_c']['image'])) {
                        foreach ($album['_c']['image'] as $image) {
                            if (isset($image['_a']['size']) && strlen($image['_a']['size']) > 0) {
                                $images[$image['_a']['size']] = (isset($image['_v']) && strlen($image['_v']) > 0) ? $image['_v'] : '';
                            }
                        }
                    }

                    $album_images = (isset($images['medium'])) ? $images['medium'] : '';
                    if ($album_images == '' && count($images) > 0) {
                        $album_images = array_shift($images);
                    }

                    if ($album_images != '') {
                        $out .= '<div class="float_surrounder"><img width="64" src="' . $album_images . '" style="float: left; margin: 3px;" /><a href="' . $album_url . '" target="_blank">' . $album_name . '</a><br />';
                        $out .= '<a href="' . $artist_url . '" target="_blank" style="font-style: italic;">' . $artist . '</a><br />';
                        $out .= 'Total Plays: ' . $playcount . '</div><br />';
                    } else {
                        $out .= '<div class="float_surrounder"><a href="' . $album_url . '" target="_blank">' . $album_name . '</a><br />';
                        $out .= '<a href="' . $artist_url . '" target="_blank" style="font-style: italic;">' . $artist . '</a><br />';
                        $out .= 'Total Plays: ' . $playcount . '</div><br />';
                    }
                }
            }
        }

        $out .= '<br style="" /><a href="' . escape_html($profile_url) . '" target="_blank" style="font-style: italic;">Click here for more...</a></div>';

        return do_template('BLOCK_SIDE_LAST_FM', array('_GUID' => '6fd41bbdbd441d4d82691e0e7e8cd3ee', 'TITLE' => $title, 'CONTENT' => $out));
    }
}

// XML to Array
function xml2ary(&$string)
{
    $parser = xml_parser_create();
    xml_parser_set_option($parser, XML_OPTION_CASE_FOLDING, 0);
    $vals = array();
    $index = array();
    xml_parse_into_struct($parser, $string, $vals, $index);
    xml_parser_free($parser);

    $mnary = array();
    $ary = &$mnary;
    foreach ($vals as $r) {
        $t = $r['tag'];
        if ($r['type'] == 'open') {
            if (isset($ary[$t])) {
                if (isset($ary[$t][0])) {
                    $ary[$t][] = array();
                } else {
                    $ary[$t] = array($ary[$t], array());
                }
                $cv = &$ary[$t][count($ary[$t]) - 1];
            } else {
                $cv = &$ary[$t];
            }
            if (isset($r['attributes'])) {
                foreach ($r['attributes'] as $k => $v) {
                    $cv['_a'][$k] = $v;
                }
            }
            $cv['_c'] = array();
            $cv['_c']['_p'] = &$ary;
            $ary = &$cv['_c'];
        } elseif ($r['type'] == 'complete') {
            if (isset($ary[$t])) { // same as open
                if (isset($ary[$t][0])) {
                    $ary[$t][] = array();
                } else {
                    $ary[$t] = array($ary[$t], array());
                }
                $cv = &$ary[$t][count($ary[$t]) - 1];
            } else {
                $cv = &$ary[$t];
            }
            if (isset($r['attributes'])) {
                foreach ($r['attributes'] as $k => $v) {
                    $cv['_a'][$k] = $v;
                }
            }
            $cv['_v'] = (isset($r['value']) ? $r['value'] : '');
        } elseif ($r['type'] == 'close') {
            $ary = &$ary['_p'];
        }
    }

    _del_p($mnary);
    return $mnary;
}

// _Internal: Remove recursion in result array
function _del_p(&$ary)
{
    foreach ($ary as $k => $v) {
        if ($k === '_p') {
            unset($ary[$k]);
        } elseif (is_array($ary[$k])) {
            _del_p($ary[$k]);
        }
    }
}

// Array to XML
function ary2xml($cary, $d = 0, $forcetag = '')
{
    $res = array();
    foreach ($cary as $tag => $r) {
        if (isset($r[0])) {
            $res[] = ary2xml($r, $d, $tag);
        } else {
            if ($forcetag) {
                $tag = $forcetag;
            }
            $sp = str_repeat("\t", $d);
            $res[] = "$sp<$tag";
            if (isset($r['_a'])) {
                foreach ($r['_a'] as $at => $av) {
                    $res[] = " $at=\"$av\"";
                }
            }
            $res[] = ">" . ((isset($r['_c'])) ? "\n" : '');
            if (isset($r['_c'])) {
                $res[] = ary2xml($r['_c'], $d + 1);
            } elseif (isset($r['_v'])) {
                $res[] = $r['_v'];
            }
            $res[] = (isset($r['_c']) ? $sp : '') . "</$tag>\n";
        }
    }
    return implode('', $res);
}

// Insert element into array
function ins2ary(&$ary, $element, $pos)
{
    $ar1 = array_slice($ary, 0, $pos);
    $ar1[] = $element;
    $ary = array_merge($ar1, array_slice($ary, $pos));
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/*EXTRA FUNCTIONS: iconv\_.+*/

/**
 * Performs lots of magic to make sure data encodings are converted correctly. Input, and output too (as often stores internally in UTF or performs automatic dynamic conversions from internal to external charsets).
 * Roll on PHP6 that has a true internal UTF string model. For now, anyone who uses UTF will get some (albeit minor) imperfections from PHP's manipulations of the strings.
 *
 * @param  boolean $known_utf8 Whether we know we are working in UTF-8. This is the case for AJAX calls.
 *
 * @ignore
 */
function _convert_data_encodings($known_utf8 = false)
{
    global $VALID_ENCODING, $CONVERTED_ENCODING;

    if ((array_key_exists('KNOWN_UTF8', $GLOBALS)) && ($GLOBALS['KNOWN_UTF8'])) {
        $known_utf8 = true;
    }

    $charset = get_charset();

    $done_something = false;

    // Conversion of parameters that might be in the wrong character encoding (e.g. JavaScript uses UTF to make requests regardless of document encoding, so the stuff needs converting)
    //  If we don't have any PHP extensions (mbstring etc) that can perform the detection/conversion, our code will take this into account and use utf8_decode at points where it knows that it's being communicated with by JavaScript.
    if (@strlen(ini_get('unicode.runtime_encoding')) > 0) {
        safe_ini_set('default_charset', $charset);
        safe_ini_set('unicode.runtime_encoding', $charset);
        safe_ini_set('unicode.output_encoding', $charset);
        safe_ini_set('unicode.semantics', '1');

        $done_something = true;
    } elseif (($known_utf8) && /*test method works...*/
              (will_be_unicode_neutered(serialize($_GET) . serialize($_POST))) && (in_array(strtolower($charset), array('iso-8859-1', 'iso-8859-15', 'koi8-r', 'big5', 'gb2312', 'big5-hkscs', 'shift_jis', 'euc-jp')))
    ) { // Preferred as it will sub entities where there's no equivalent character
        do_environment_utf8_conversion($charset);

        $done_something = true;
    } elseif ((function_exists('iconv')) && (get_value('disable_iconv') !== '1')) {
        $encoding = $known_utf8 ? 'UTF-8' : $charset;
        if (!function_exists('iconv_set_encoding') || @iconv_set_encoding('input_encoding', $encoding)) {
            if (function_exists('iconv_set_encoding')) {
                @iconv_set_encoding('output_encoding', $charset);
                @iconv_set_encoding('internal_encoding', $charset);
            }
            ini_set('default_charset', $charset);
            foreach ($_GET as $key => $val) {
                if (is_string($val)) {
                    $_GET[$key] = iconv($encoding, $charset . '//TRANSLIT', $val);
                } elseif (is_array($val)) {
                    foreach ($val as $i => $v) {
                        $_GET[$key][$i] = iconv($encoding, $charset . '//TRANSLIT', $v);
                    }
                }
            }
            foreach ($_POST as $key => $val) {
                if (is_string($val)) {
                    $_POST[$key] = iconv($encoding, $charset . '//TRANSLIT', $val);
                } elseif (is_array($val)) {
                    foreach ($val as $i => $v) {
                        $_POST[$key][$i] = iconv($encoding, $charset . '//TRANSLIT', $v);
                    }
                }
            }
        } else {
            $VALID_ENCODING = false;
        }
        $done_something = true;
    } elseif ((function_exists('mb_convert_encoding')) && (get_value('disable_mbstring') !== '1')) {
        if (function_exists('mb_list_encodings')) {
            $VALID_ENCODING = in_array(strtolower($charset), array_map('strtolower', mb_list_encodings()));
        } else {
            $VALID_ENCODING = true;
        }

        if ($VALID_ENCODING) {
            $encoding = $known_utf8 ? 'UTF-8' : '';
            if ((function_exists('mb_http_input')) && ($encoding == '')) {
                if (count($_POST) != 0) {
                    $encoding = mb_http_input('P');
                    if ((!is_string($encoding)) || ($encoding == 'pass')) {
                        $encoding = '';
                    }
                }
            }
            if ((function_exists('mb_http_input')) && ($encoding == '')) {
                $encoding = mb_http_input('G');
                if ((!is_string($encoding)) || ($encoding == 'pass')) {
                    $encoding = '';
                }
                if ((function_exists('mb_detect_encoding')) && ($encoding == '') && (cms_srv('REQUEST_URI') != '')) {
                    $encoding = mb_detect_encoding(urldecode(cms_srv('REQUEST_URI')), $charset . ',UTF-8,ISO-8859-1');
                    if ((!is_string($encoding)) || ($encoding == 'pass')) {
                        $encoding = '';
                    }
                }
            }
            if ($encoding != '') {
                foreach ($_GET as $key => $val) {
                    if (is_string($val)) {
                        $_GET[$key] = mb_convert_encoding($val, $charset, $encoding);
                    } elseif (is_array($val)) {
                        foreach ($val as $i => $v) {
                            $_GET[$key][$i] = mb_convert_encoding($v, $charset, $encoding);
                        }
                    }
                }
                foreach ($_POST as $key => $val) {
                    if (is_string($val)) {
                        $_POST[$key] = mb_convert_encoding($val, $charset, $encoding);
                    } elseif (is_array($val)) {
                        foreach ($val as $i => $v) {
                            $_POST[$key][$i] = mb_convert_encoding($v, $charset, $encoding);
                        }
                    }
                }
                foreach ($_FILES as $key => $val) {
                    $_FILES[$key]['name'] = mb_convert_encoding($val['name'], $charset, $encoding);
                }
            }
            if (function_exists('mb_http_output')) {
                mb_http_output($charset);
            }
        }

        $done_something = true;
    } elseif (($known_utf8) && ($charset != 'utf-8')) { // This is super-easy, but it's imperfect as it assumes ISO-8859-1 -- hence our worst option
        do_simple_environment_utf8_conversion();

        $done_something = true;
    }

    if ($done_something) {
        $CONVERTED_ENCODING = true;
    }
}

/**
 * Convert a unicode character number to a unicode string. Callback for preg_replace.
 *
 * @param  array $matches Regular expression match array.
 * @return ~string Converted data (false: could not convert).
 */
function unichrm_hex($matches)
{
    return unichr(hexdec($matches[1]));
}

/**
 * Convert a unicode character number to a unicode string. Callback for preg_replace.
 *
 * @param  array $matches Regular expression match array.
 * @return ~string Converted data (false: could not convert).
 */
function unichrm($matches)
{
    return unichr(intval($matches[1]));
}

/**
 * Convert a unicode character number to a HTML-entity enabled string, using lower ASCII characters where possible.
 *
 * @param  integer $c Character number.
 * @return ~string Converted data (false: could not convert).
 */
function unichr($c)
{
    if ($c <= 0x7F) {
        return chr($c);
    } else {
        return '#&' . strval($c) . ';';
    }
}

/**
 * Convert text to an entity format via unicode, compatible with the GD TTF functions. Originally taken from php manual but heavily modified. Passed text is assumed to be in the get_charset() character set.
 *
 * @param  string $data Input text.
 * @return string Output 7-bit unicode-entity-encoded ASCII text.
 */
function foxy_utf8_to_nce($data = '')
{
    if ($data == '') {
        return $data;
    }

    $input_charset = get_charset();
    if ($input_charset != 'utf-8') {
        if (function_exists('unicode_decode')) {
            $test = @unicode_decode($data, $input_charset);
            if ($test !== false) {
                $data = $test;
            } else {
                return $data;
            }
        } elseif ((function_exists('iconv')) && (get_value('disable_iconv') !== '1')) {
            $test = @iconv($input_charset, 'utf-8', $data);
            if ($test !== false) {
                $data = $test;
            } else {
                return $data;
            }
        } elseif ((function_exists('mb_convert_encoding')) && (get_value('disable_mbstring') !== '1')) {
            if (function_exists('mb_list_encodings')) {
                static $good_encodings = array();
                if (!isset($good_encodings[$input_charset])) {
                    $good_encodings[$input_charset] = (in_array(strtolower($input_charset), array_map('strtolower', mb_list_encodings())));
                }
                $valid_encoding = $good_encodings[$input_charset];
            } else {
                $valid_encoding = true;
            }
            if ($valid_encoding) {
                $test = @mb_convert_encoding($data, 'utf-8', $input_charset);
                if ($test !== false) {
                    $data = $test;
                } else {
                    return $data;
                }
            }
        } elseif ((strtolower($input_charset) == 'utf-8') && (strtolower(substr('utf-8', 0, 3)) != 'utf')) {
            $test = utf8_decode($data); // Imperfect as it assumes ISO-8859-1, but it's our last resort.
            if ($test !== false) {
                $data = $test;
            } else {
                return $data;
            }
        } else {
            return $data;
        }
    }

    $max_count = 5; // flag-bits in $max_mark ( 1111 1000==5 times 1)
    $max_mark = 248; // marker for a (theoretical ;-)) 5-byte-char and mask for a 4-byte-char;

    $html = '';
    for ($str_pos = 0; $str_pos < strlen($data); $str_pos++) {
        $old_chr = $data[$str_pos];
        $old_val = ord($data[$str_pos]);
        $new_val = 0;

        $utf8_marker = 0;

        // skip non-utf-8-chars
        if ($old_val > 127) {
            $mark = $max_mark;
            for ($byte_ctr = $max_count; $byte_ctr > 2; $byte_ctr--) {
                // actual byte is utf-8-marker?
                if (($old_val & $mark) == (($mark << 1) & 255)) {
                    $utf8_marker = $byte_ctr - 1;
                    break;
                }
                $mark = ($mark << 1) & 255;
            }
        }

        // marker found: collect following bytes
        if (($utf8_marker > 1) && (isset($data[$str_pos + 1]))) {
            $str_off = 0;
            $new_val = $old_val & (127 >> $utf8_marker);
            for ($byte_ctr = $utf8_marker; $byte_ctr > 1; $byte_ctr--) {
                // check if following chars are UTF8 additional data blocks
                // UTF8 and ord() > 127
                if ((ord($data[$str_pos + 1]) & 192) == 128) {
                    $new_val = $new_val << 6;
                    $str_off++;
                    // no need for Addition, bitwise OR is sufficient
                    // 63: more UTF8-bytes; 0011 1111
                    $new_val = $new_val | (ord($data[$str_pos + $str_off]) & 63);
                }
                // no UTF8, but ord() > 127
                // nevertheless convert first char to NCE
                else {
                    $new_val = $old_val;
                }
            }
            // build NCE-Code
            $html .= '&#' . strval($new_val) . ';';
            // Skip additional UTF-8-Bytes
            $str_pos = $str_pos + $str_off;
        } else {
            $html .= chr($old_val);
            $new_val = $old_val;
        }
    }
    return $html;
}

/**
 * Turn utf-8 characters into unicode HTML entities. Useful as GD truetype functions need this. Based on function in PHP code comments.
 *
 * @param  string $utf8 Input.
 * @return string Output.
 */
function utf8tohtml($utf8)
{
    $result = '';
    for ($i = 0; $i < strlen($utf8); $i++) {
        $char = $utf8[$i];
        $ascii = ord($char);
        if ($ascii < 128) {
            // one-byte character
            $result .= $char;
        } elseif ($ascii < 192) {
            // non-utf8 character or not a start byte
        } elseif ($ascii < 224) {
            // two-byte character
            $ascii1 = ord($utf8[$i + 1]);
            $unicode = (63 & $ascii) * 64 +
                       (63 & $ascii1);
            $result .= '&#' . strval($unicode) . ';';
            $i += 1;
        } elseif ($ascii < 240) {
            // three-byte character
            $ascii1 = ord($utf8[$i + 1]);
            $ascii2 = ord($utf8[$i + 2]);
            $unicode = (15 & $ascii) * 4096 +
                       (63 & $ascii1) * 64 +
                       (63 & $ascii2);
            $result .= '&#' . strval($unicode) . ';';
            $i += 2;
        } elseif ($ascii < 248) {
            // four-byte character
            $ascii1 = ord($utf8[$i + 1]);
            $ascii2 = ord($utf8[$i + 2]);
            $ascii3 = ord($utf8[$i + 3]);
            $unicode = (15 & $ascii) * 262144 +
                       (63 & $ascii1) * 4096 +
                       (63 & $ascii2) * 64 +
                       (63 & $ascii3);
            $result .= '&#' . strval($unicode) . ';';
            $i += 3;
        }
    }
    return $result;
}

/**
 * Do a UTF8 conversion on the environmental GET/POST parameters (ISO-8859-1 charset, which PHP supports internally).
 */
function do_simple_environment_utf8_conversion()
{
    foreach ($_GET as $key => $val) {
        if (is_string($val)) {
            $_GET[$key] = utf8_decode($val);
        } elseif (is_array($val)) {
            foreach ($val as $i => $v) {
                $_GET[$key][$i] = utf8_decode($v);
            }
        }
    }
    foreach ($_POST as $key => $val) {
        if (is_string($val)) {
            $_POST[$key] = utf8_decode($val);
        } elseif (is_array($val)) {
            foreach ($val as $i => $v) {
                $_POST[$key][$i] = utf8_decode($v);
            }
        }
    }
    foreach ($_FILES as $key => $val) {
        $_FILES[$key]['name'] = utf8_decode($val['name']);
    }
}

/**
 * Do a UTF8 conversion on the environmental GET/POST parameters.
 *
 * @param  string $from_charset Charset that was used to encode the environmental data.
 */
function do_environment_utf8_conversion($from_charset)
{
    foreach ($_GET as $key => $val) {
        if (is_string($val)) {
            $test = entity_utf8_decode($val, $from_charset);
            if ($test !== false) {
                $_GET[$key] = $test;
            }
        } elseif (is_array($val)) {
            foreach ($val as $i => $v) {
                $test = entity_utf8_decode($v, $from_charset);
                if ($test !== false) {
                    $_GET[$key][$i] = $test;
                }
            }
        }
    }
    foreach ($_POST as $key => $val) {
        if (is_string($val)) {
            $test = entity_utf8_decode($val, $from_charset);
            if ($test !== false) {
                $_POST[$key] = $test;
            }
        } elseif (is_array($val)) {
            foreach ($val as $i => $v) {
                $test = entity_utf8_decode($v, $from_charset);
                if ($test !== false) {
                    $_POST[$key][$i] = $test;
                }
            }
        }
    }
    foreach ($_FILES as $key => $val) {
        $test = entity_utf8_decode($val['name'], $from_charset);
        if ($test !== false) {
            $_FILES[$key]['name'] = $test;
        }
    }
}

/**
 * Guard for entity_utf8_decode. Checks that the data can be stripped so there is no unicode left. Either the htmlentities function must convert mechanically to entity-characters or all higher ascii character codes (which are actually unicode control codes in a unicode interpretation) that are used happen to be linked to named entities.
 * PHP's utf-8 support may not be great. For example, we have seen emoji characters not converting.
 *
 * @param  string $data Data to check.
 * @return boolean Whether we are good to execute entity_utf8_decode.
 */
function will_be_unicode_neutered($data)
{
    $data = @htmlentities($data, ENT_COMPAT, 'UTF-8');
    if ($data == '') {
        return false; // Some servers fail at the first step
    }
    for ($i = 0; $i < strlen($data); $i++) {
        if (ord($data[$i]) > 0x7F) {
            return false;
        }
    }
    return true;
}

/**
 * Convert some data from one encoding to the internal encoding.
 *
 * @param  string $data Data to convert.
 * @param  ?string $input_charset Charset to convert from (null: that read by the last http_download_file call).
 * @param  ?string $internal_charset Charset to convert to (null: current encoding).
 * @return string Converted data.
 */
function convert_to_internal_encoding($data, $input_charset = null, $internal_charset = null)
{
    if (preg_match('#^[\x00-\x7f]$#', $data) != 0) { // All ASCII
        return $data;
    }

    global $VALID_ENCODING;

    convert_data_encodings(); // In case it hasn't run yet. We need $VALID_ENCODING to be set.

    if (is_null($input_charset)) {
        $input_charset = $GLOBALS['HTTP_CHARSET'];
    }
    if (($input_charset === '') || (is_null($input_charset))) {
        return $data;
    }

    if (is_null($internal_charset)) {
        $internal_charset = get_charset();
    }

    if ((strtolower($input_charset) == 'utf-8') && /*test method works...*/
        (will_be_unicode_neutered($data)) && (in_array(strtolower($internal_charset), array('iso-8859-1', 'iso-8859-15', 'koi8-r', 'big5', 'gb2312', 'big5-hkscs', 'shift_jis', 'euc-jp')))
    ) { // Preferred as it will sub entities where there's no equivalent character
        $test = entity_utf8_decode($data, $internal_charset);
        if ($test !== false) {
            return $test;
        }
    }
    if ((function_exists('unicode_decode')) && ($internal_charset != 'utf-8') && ($input_charset == 'utf-8') && ($VALID_ENCODING)) {
        $test = @unicode_decode($data, $input_charset);
        if ($test !== false) {
            return $test;
        }
    }
    if ((function_exists('unicode_encode')) && ($internal_charset == 'utf-8') && ($input_charset != 'utf-8') && ($VALID_ENCODING)) {
        $test = @unicode_encode($data, $input_charset);
        if ($test !== false) {
            return $test;
        }
    }
    if ((function_exists('iconv')) && ($VALID_ENCODING) && (get_value('disable_iconv') !== '1')) {
        $test = @iconv($input_charset, $internal_charset . '//TRANSLIT', $data);
        if ($test !== false) {
            return $test;
        }
    }
    if ((function_exists('mb_convert_encoding')) && ($VALID_ENCODING) && (get_value('disable_mbstring') !== '1')) {
        if (function_exists('mb_list_encodings')) {
            static $good_encodings = array();
            if (!isset($good_encodings[$input_charset])) {
                $good_encodings[$input_charset] = (in_array(strtolower($input_charset), array_map('strtolower', mb_list_encodings())));
            }
            $good_encoding = $good_encodings[$input_charset];
        } else {
            $good_encoding = true;
        }

        if ($good_encoding) {
            $test = @mb_convert_encoding($data, $internal_charset, $input_charset);
            if ($test !== false) {
                return $test;
            }
        }
    }
    if ((strtolower($input_charset) == 'utf-8') && (strtolower(substr($internal_charset, 0, 3)) != 'utf')) {
        $test = utf8_decode($data); // Imperfect as it assumes ISO-8859-1, but it's our last resort.
        if ($test !== false) {
            return $test;
        }
    }
    if ((strtolower($internal_charset) == 'utf-8') && (strtolower(substr($input_charset, 0, 3)) != 'utf')) {
        $test = utf8_encode($data); // Imperfect as it assumes ISO-8859-1, but it's our last resort.
        if ($test !== false) {
            return $test;
        }
    }

    return $data;
}

/**
 * Convert some data from UTF to a character set PHP supports, using HTML entities where there's no direct match.
 *
 * @param  string $data Data to convert.
 * @param  string $internal_charset Charset to convert to.
 * @return ~string Converted data (false: could not convert).
 */
function entity_utf8_decode($data, $internal_charset)
{
    $encoded = htmlentities($data, ENT_COMPAT, 'UTF-8'); // Only works on some servers, which is why we test the utility of it before running this function. NB: It is fine that this will double encode any pre-existing entities- as the double encoding will trivially be undone again later (amp can always decode to a lower ascii character)
    if ((strlen($encoded) == 0) && ($data != '')) {
        $encoded = htmlentities($data, ENT_COMPAT);
    }

    $test = mixed();
    $test = @html_entity_decode($encoded, ENT_COMPAT, $internal_charset); // this is nice because it will leave equivalent entities where it can't get a character match; Comcode supports those entities
    if ((strlen($test) == 0) && ($data != '')) {
        $test = false;
    }
    if ($test === false) {
        $test = preg_replace_callback('/&#x([0-9a-f]+);/i', 'unichrm_hex', $encoded); // imperfect as it can only translate lower ascii back, but better than nothing. htmlentities would have encoded key other ones as named entities though which get_html_translation_table can handle
        $test = preg_replace_callback('/&#([0-9]+);/', 'unichrm', $test); // imperfect as it can only translate lower ascii back, but better than nothing. htmlentities would have encoded key other ones as named entities though which get_html_translation_table can handle
        if (strtolower($internal_charset) == 'iso-8859-1') { // trans table only valid for this charset. Else we just need to live with things getting turned into named entities. However we don't allow this function to be called if this code branch would be skipped here.
            require_code('xml');
            $test2 = convert_bad_entities($test, $internal_charset);
            if ((strlen($test2) != 0) || ($data == '')) {
                $test = $test2;
            }
        }
    }
    if ($test !== false) {
        $data = $test;
        $shortcuts = array('(EUR-)' => '&euro;', '{f.}' => '&fnof;', '-|-' => '&dagger;', '=|=' => '&Dagger;', '{%o}' => '&permil;', '{~S}' => '&Scaron;', '{~Z}' => '&#x17D;', '(TM)' => '&trade;', '{~s}' => '&scaron;', '{~z}' => '&#x17E;', '{.Y.}' => '&Yuml;', '(c)' => '&copy;', '(r)' => '&reg;', '---' => '&mdash;', '--' => '&ndash;', '...' => '&hellip;', '==>' => '&rarr;', '<==' => '&larr;');
        foreach ($shortcuts as $to => $from) {
            $data = str_replace($from, $to, $data);
        }
    } else {
        $data = false;
    }
    return $data;
}

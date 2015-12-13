<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    comcode_html_whitelist
 */

if (!function_exists('init__comcode_compiler')) {
    function init__comcode_compiler($in = null)
    {
        $new_code = '
            require_code(\'textfiles\');
            $whitelists = explode("\n", read_text_file(\'comcode_whitelist\', null, true));
            foreach ($whitelists as $w) {
                if (trim($w) != \'\') {
                    if ($w[0] != \'/\') $w = preg_quote($w, \'#\'); else $w = substr($w, 1, strlen($w) - 2);
                    $allowed_html_seqs[] = $w;
                }
            }
        ';
        $in = str_replace('if ($as_admin)', $new_code . ' if ($as_admin)', $in);

        $new_code = '
            global $OBSCURE_REPLACEMENTS;
            $OBSCURE_REPLACEMENTS = array();
            require_code(\'textfiles\');
            $whitelists = explode("\n", read_text_file(\'comcode_whitelist\', null, true));
            foreach ($whitelists as $i => $w) {
                if (trim($w) != \'\') {
                    if ($w[0] != \'/\') $w = preg_quote($w, \'#\'); else $w = substr($w, 1, strlen($w) - 2);
                    $ahead = preg_replace_callback(\'#\' . $w . \'#\', \'obscure_html_callback\', $ahead);
                }
            }

            hard_filter_input_data__html($ahead);
        ';
        $in = str_replace('hard_filter_input_data__html($ahead);', $new_code, $in);

        $new_code = '
            require_code(\'input_filter\');
            foreach ($OBSCURE_REPLACEMENTS as $rep => $from) {
                $ahead = str_replace($rep, $from, $ahead);
            }
        ';
        $in = str_replace('// Tidy up', $new_code, $in);

        return $in;
    }
}

function obscure_html_callback($matches)
{
    global $OBSCURE_REPLACEMENTS;
    $rep = uniqid('', true);
    $OBSCURE_REPLACEMENTS[$rep] = $matches[0];
    return $rep;
}

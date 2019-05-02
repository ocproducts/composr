<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/**
 * Clean common ugliness from some text. E.g. copy and paste problems.
 *
 * @param  string $d Input
 * @param  string $heading Heading to not allow to be repeated at start (blank: none)
 * @return string Output
 */
function deep_clean($d, $heading = '')
{
    $d = unixify_line_format($d);

    $is_html = (preg_match('#<(span|p|div|br|img|b|i|strong|em|table|a|h1|h2|h3|h4|h5|h6|li|blockquote)( |>)#', $d) != 0);

    if ($is_html) {
        // Wrapper divs
        while (cms_preg_match_safe('#^\s*<div[^<>]*>#i', $d) != 0 && cms_preg_match_safe('#</div>\s*$#i', $d) != 0) {
            $matches = array();
            $count = preg_match_all('#</?div[^<>]*>#i', $d, $matches);
            $nesting_tally = 0;
            for ($i = 0; $i < $count; $i++) {
                $nesting_tally += (strpos($matches[0][$i], '/') === false) ? 1 : -1;
                if ($i != $count - 1) {
                    if ($nesting_tally <= 0) {
                        break 2; // Opener got closed before end
                    }
                }
            }
            if ($nesting_tally == 0) { // Tags do balance, so it closed right at the end
                $d = cms_preg_replace_safe('#^\s*<div[^<>]*>#', '', $d);
                $d = cms_preg_replace_safe('#</div>\s*$#s', '', $d);
            } else {
                break;
            }
        }
    }

    // Strip heading if it appears at the top
    if (!empty($heading)) {
        if ($is_html) {
            $d = cms_preg_replace_safe('#^\s*<h\d[^<>]*>\s*' . preg_quote($heading, '') . '\s*</h\d>#', '', $d);
            $d = cms_preg_replace_safe('#^\s*' . preg_quote($heading, '') . '\s*([^\w])#', '$1', $d);
        } else {
            $d = cms_preg_replace_safe('#^\s*' . preg_quote($heading, '') . '\s*\r?\n#', '', $d);
        }
    }

    // Deep trim
    if ($is_html) {
        $d = cms_trim($d, true);
    } else {
        $d = trim($d);
    }

    // Upper case -> Title Case
    if ((preg_match('#[a-z]#', $d) == 0) && (strpos($d, ' ') !== false)) {
        $d = cms_mb_ucwords($d);
    }

    // Strip white backgrounds
    if ($is_html) {
        $d = str_replace('; background-color: rgb(255, 255, 255)', '', $d);
    }

    // Convert indented "paragraphs" via nbsp into real paragraphs
    if ($is_html) {
        $d = cms_preg_replace_safe('#(<br[^<>]*>|<p( [^<>]*)?' . '>|<div( [^<>]*)?' . '>)\s*(&nbsp;)+#i', '$1', $d);
    }

    if ($is_html) {
        if (strpos($d, 'blockquote') !== false) {
            // All using blockquote instead of paragraphs/divs
            if ((preg_match('#<(p|div)( [^<>]*)?' . '>#i', $d) == 0) && (substr_count($d, '<blockquote') >= 5)) {
                $d = preg_replace('#(</?)blockquote([^<>]*>)#i', '$1p$2', $d);
            }
        }
    }

    if ($is_html) {
        // All paragraphs/divs/etc with certain CSS properties
        $matches = array();
        $count = preg_match_all('#<(p|div|blockquote|ul|ol)( [^<>]*)?' . '>#i', $d, $matches);
        if ($count > 2) {
            $css_properties = array('line-height', 'font-size', 'margin', 'padding', 'font-family', 'background-color', 'vertical-align', 'outline', 'border');
            foreach ($css_properties as $property) {
                $versions = array();
                $non_matches = 0;
                $regexp = '#([;"]\s*)(' . preg_quote($property, '#') . ':[^;]*)([;"])#';
                for ($i = 0; $i < $count; $i++) {
                    $matches2 = array();
                    if (preg_match($regexp, $matches[0][$i], $matches2) != 0) {
                        if (!isset($versions[$matches2[2]])) {
                            $versions[$matches2[2]] = 0;
                        }
                        $versions[$matches2[2]]++;
                    } else {
                        $non_matches++;
                    }
                }
                if ((count($versions) == 1) && ((float)$non_matches < 0.2 * (float)$count)) {
                    $d = preg_replace('#"\s*' . preg_quote($property, '#') . ':[^;"]*"\s*#', '""', $d); // Only property
                    $d = preg_replace('#"\s*' . preg_quote($property, '#') . ':[^;"]*;\s*#', '"', $d); // First property
                    $d = preg_replace('#\s*;\s*' . preg_quote($property, '#') . ':[^;"]*;?"#', '"', $d); // Last property
                    $d = preg_replace('#\s*;\s*' . preg_quote($property, '#') . ':[^;"]*\s*;\s*#', '; ', $d); // Middle property
                }
            }
        }

        // Inherits/nones
        do {
            $orig_d = $d;
            $d = preg_replace('#"\s*[\w\-]+: *(inherit|none|0|0px|rgb\(0, 0, 0\))"\s*#', '""', $d); // Only property
            $d = preg_replace('#"\s*[\w\-]+: *(inherit|none|0|0px|rgb\(0, 0, 0\));\s*#', '"', $d); // First property
            $d = preg_replace('#\s*;\s*[\w\-]+: *(inherit|none|0|0px|rgb\(0, 0, 0\));?"#', '"', $d); // Last property
            $d = preg_replace('#\s*;\s*[\w\-]+: *(inherit|none|0|0px|rgb\(0, 0, 0\))\s*;\s*#', '; ', $d); // Middle property
            $changed = ($orig_d != $d);
        } while ($changed);

        $d = str_replace(' style=""', '', $d);
    }

    if ($is_html) {
        // All using br and no paragraphs
        if ((preg_match('#<(p|div)( [^<>]*)?' . '>#i', $d) == 0) && (substr_count($d, '<br') >= 5)) {
            $d = '<p>' . cms_preg_replace_safe('#(<br[^<>]*>\s*)+#i', '</p>' . "\n" . '<p>', $d) . '</p>';
        }
    }

    column_cleanup($d);

    return $d;
}

/**
 * Remove forced columnisation (word-wrapping). Useful if pasted from PDFs.
 *
 * @param  string $text Comcode / HTML
 */
function column_cleanup(&$text)
{
    $text = str_replace('<br>', '<br />', $text);
    $temp_text = cms_strip_tags($text, '<br>');
    $temp_text = html_entity_decode($temp_text, ENT_QUOTES);
    $lines = explode('<br />', $temp_text);
    if (count($lines) > 5) { // Statistically significant
        $lengths = array();
        foreach ($lines as $line) {
            $lengths[] = strlen($line);
        }
        $mean_length = (int)(array_sum($lengths) / count($lengths));
        if ($mean_length > 5) { // Statistically significant
            $dist = 0;
            foreach ($lines as $line) {
                $dist += abs(strlen($line) - $mean_length);
            }
            $sd = ((float)$dist) / ((float)count($lines));
            if ($sd < 0.6 * (float)$mean_length) { // Standard deviation within 60%
                $sentence_ends = array('!', '?', '.', '>');

                $lines = explode('<br />', $text);
                $text = '';
                foreach ($lines as $i => $line) {
                    $text .= $line;
                    $line_end_char = substr($line, -1);
                    if ($i != count($lines) - 1) {
                        if (in_array($line_end_char, $sentence_ends)) {
                            $text .= '<br /><br />';
                        } else {
                            $text .= ' ';
                        }
                    }
                }
            }
        }
    }
}

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

// Server-side font rendering code

/**
 * Find whether the server supports TTF.
 *
 * @return boolean Whether TTF is supported
 */
function has_ttf()
{
    // TODO: In v11 make health check for TTF use this (grep for imagettftext)

    static $result = null;
    if ($result !== null) {
        return $result;
    }

    if (!function_exists('imagettftext')) {
        $result = false;
        return $result;
    }

    if (!array_key_exists('FreeType Support', gd_info())) {
        $result = false;
        return $result;
    }

    if (@imagettfbbox(26.0, 0.0, get_file_base() . '/data/fonts/FreeMono.ttf', 'test') === false) {
        $result = false;
        return $result;
    }

    $result = true;
    return $result;
}

/**
 * Enforce TTF support.
 */
function check_ttf()
{
    if (!has_ttf()) {
        return do_lang_tempcode('REQUIRES_TTF');
    }
}

/**
 * Find the default font to use.
 *
 * @param  boolean $mono Whether we want a monospaced font
 * @return string Default font file name (without .ttf)
 */
function find_default_font($mono = false)
{
    // We have some knowledge of fonts we like, even though we don't bundle them all (for file-size and licensing reasons)
    if ($mono) {
        $precedence = array(
            'Courier New Bold', // Microsoft (preferred, defacto standard)
            'Courier New', // Microsoft (preferred, defacto standard)
            'FreeMonoBold', // GNU FreeFont (bundled)
            'FreeMono', // GNU FreeFont (bundled)
            'LiberationMono-Bold', // Liberation fonts
            'LiberationMono', // Liberation fonts
            'UbuntuMono-Bold', // Ubuntu
            'UbuntuMono', // Ubuntu
            'FiraMono-Bold', // Firefox OS
            'FiraMono', // Firefox OS
            'RobotoMono-Bold', // Google
            'RobotoMono', // Google
        );
    } else {
        $precedence = array(
            'Segoe UI', // Microsoft (preferred, defacto standard)
            'Tahoma', // Microsoft (preferred, defacto standard)
            'Verdana', // Microsoft (preferred, defacto standard)
            'FreeSans', // GNU FreeFont (bundled)
            'FreeSerif', // GNU FreeFont (bundled)
            'Calibri', // Microsoft
            'Arial', // Microsoft
            'Microsoft Sans Serif', // Microsoft
            'Trebuchet MS', // Microsoft
            'Georgia', // Microsoft
            'Times New Roman', // Microsoft(ish)
            'LiberationSans', // Liberation fonts
            'LiberationSerif', // Liberation fonts
            'DejaVuSans', // DejaVu fonts (fork of Bitstream Vera)
            'DejaVuSerif', // DejaVu fonts (fork of Bitstream Vera)
            'Ubuntu', // Ubuntu
            'FiraSans', // Firefox OS
            'Roboto', // Google
            'OpenSans', // Google
        );
    }

    $all_fonts = find_all_fonts(true);
    foreach ($precedence as $font) {
        if (array_key_exists($font, $all_fonts)) {
            return $font;
        }
    }

    // We could not find a font with the right character support, so we'll compromise
    $all_fonts = find_all_fonts();
    foreach ($precedence as $font) {
        if (array_key_exists($font, $all_fonts)) {
            return $font;
        }
    }

    fatal_exit(do_lang_tempcode('INTERNAL_ERROR'));
    return '';
}

/**
 * Find all available fonts.
 *
 * @param boolean $test_character_support Test the font supports the characters in the site title (a rough way to check it is a reasonable font to use on this site).
 * @return array A map between font name and label to use for the font.
 */
function find_all_fonts($test_character_support = false)
{
    if (($test_character_support) && (has_ttf())) {
        $test_text = get_site_name();
        require_code('character_sets');
    }

    $fonts = array();
    foreach (array(get_file_base() . '/data_custom/fonts', get_file_base() . '/data/fonts') as $path) {
        $dh = @opendir($path);
        if ($dh !== false) {
            while (($f = readdir($dh))) {
                if (substr($f, -4) == '.ttf') {
                    if (($test_character_support) && (has_ttf())) {
                        $_test_text = cms_preg_replace_safe('#\s#', '', $test_text);
                        $_chars = array();
                        $len = cms_mb_strlen($_test_text);
                        for ($i = 0; $i < $len; $i++) {
                            $char = cms_mb_substr($_test_text, $i, 1);
                            if (trim($char) != '') {
                                $bounds = @imagettfbbox(26.0, 0.0, $path . '/' . $f, foxy_utf8_to_nce($char));
                                $_chars[$char] = serialize($bounds);
                            }
                        }
                        if ((count(array_unique($_chars)) == 1) && (count($_chars) > 1)) {
                            continue; // It's all box outlines due to unsupported characters
                        }
                    }

                    $font = basename($f, '.ttf');

                    $font_label = $font;
                    do {
                        $_font_label = $font_label;
                        $font_label = preg_replace('#\s*(Italic|It|Oblique)($| )#i', ' Italic$2', $font_label);
                        $font_label = preg_replace('#\s*(Extra Bold)($| )#i', ' Extra Bold$2', $font_label);
                        $font_label = preg_replace('#\s*(Bold|Bd)($| )#i', ' Bold$2', $font_label);
                        $font_label = preg_replace('#\s*(Semi Bold)($| )#i', ' Semi Bold$2', $font_label);
                        $font_label = preg_replace('#\s*(Black)($| )#i', ' Black$2', $font_label);
                        $font_label = preg_replace('#\s*(Medium)($| )#i', ' Medium$2', $font_label);
                        $font_label = preg_replace('#\s*(Medium|Regular)($| )#i', ' Regular$2', $font_label);
                        $font_label = preg_replace('#\s*(Light)($| )#i', ' Light$2', $font_label);
                        $font_label = preg_replace('#\s*(Extra Light)($| )#i', ' Extra Light$2', $font_label);
                        $font_label = preg_replace('#\s*(Thin)($| )#i', ' Thin$2', $font_label);
                    }
                    while ($font_label != $_font_label);
                    $font_label = str_replace('Italic', ' Italic', $font_label);
                    $font_label = trim(preg_replace('#\s+#', ' ', $font_label));

                    $fonts[$font] = $font_label;
                }
            }
            closedir($dh);
        }
    }

    ksort($fonts);

    return $fonts;
}

/**
 * Find the path to a font.
 *
 * @param  string $font Font file name (without .ttf)
 * @return PATH The file path
 */
function find_font_path($font)
{
    $file_base = get_custom_file_base() . '/data_custom/fonts/';
    if (!file_exists($file_base . '/' . $font . '.ttf')) {
        $file_base = get_file_base() . '/data/fonts/';
    }
    return $file_base . $font . '.ttf';
}

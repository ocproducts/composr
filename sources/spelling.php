<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/*EXTRA FUNCTIONS: pspell\_.+|enchant\_.+*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_form_interfaces
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__spelling()
{
    if (!defined('WORD_REGEXP')) {
        define('WORD_REGEXP', '#([a-zA-Z0-9\']+)#');
        define('WORD_REGEXP_UNICODE', '#([\w\']+)#u');
    }

    global $SPELL_LINKS;
    $SPELL_LINKS = array();
}

/**
 * Clean some HTML for use in the spellcheck, but nothing with tags.
 *
 * @param  string $html Input string
 * @return string Cleaned
 */
function clean_simple_html_for_spellcheck($html)
{
    return @html_entity_decode($html, ENT_QUOTES);
}

/**
 * Clean some HTML for use in the spellcheck.
 *
 * @param  string $html Input string
 * @return string Cleaned
 */
function clean_html_for_spellcheck($html)
{
    require_code('comcode_from_html');
    $comcode = semihtml_to_comcode($html, true);
    $text = clean_comcode_for_spellcheck($comcode);
    return $text;
}

/**
 * Clean some Comcode for use in the spellcheck.
 *
 * @param  string $comcode Input string
 * @return string Cleaned
 */
function clean_comcode_for_spellcheck($comcode)
{
    foreach (array('tt', 'code', 'codebox') as $tag) { // Strip whole tags
        $comcode = preg_replace('#\[' . $tag . '[^\[\]]*\].*\[/' . $tag . '\]#Us', '', $comcode);
    }

    $text = strip_comcode($comcode);
    return $text;
}

/**
 * Fix spellings in input string.
 *
 * @param  string $text Input string
 * @return string Fixed input string
 */
function spell_correct_phrase($text)
{
    if (_find_spell_checker() === null) {
        return $text;
    }

    $errors = run_spellcheck($text);

    $regexp = (get_charset() == 'utf-8') ? WORD_REGEXP_UNICODE : WORD_REGEXP;
    $parts = preg_split($regexp, $text, -1, PREG_SPLIT_DELIM_CAPTURE);

    $out = '';
    foreach ($parts as $part) {
        if ((isset($errors[cms_mb_strtolower($part)])) && (count($errors[cms_mb_strtolower($part)]) != 0)) {
            $out .= $errors[cms_mb_strtolower($part)][0];
        } else {
            $out .= $part;
        }
    }

    return $out;
}

/**
 * Run a spellcheck on some text.
 *
 * @param  string $text Text to scan for words in (should be plain text, not be HTML or Comcode text)
 * @param  ?ID_TEXT $lang Language to check in (null: current language)
 * @param  boolean $skip_known_words_in_db Whether to avoid spellchecking known keywords etc
 * @param  boolean $provide_corrections Whether to provide corrections
 * @param  boolean $unicode_accepted Whether Unicode is accepted
 * @return array A map of misspellings, lower case bad word => array of corrections
 */
function run_spellcheck($text, $lang = null, $skip_known_words_in_db = true, $provide_corrections = true, $unicode_accepted = true)
{
    $spell_checker = _find_spell_checker();

    if ($spell_checker === null) {
        return array();
    }

    $words = _find_words($text, $unicode_accepted);
    if (count($words) == 0) {
        return array();
    }

    $errors = array();

    // Initialise
    $spell_link = spellcheck_initialise($lang);
    if ($spell_link === null) {
        return array();
    }
    if ($skip_known_words_in_db) {
        $okay_words = array(
            // Some common Composr terms that should not be corrected
            'comcode',
            'tempcode',
            'selectcode',
            'filtercode',
        );

        $or_list = '';
        foreach ($words as $word) {
            if ($or_list != '') {
                $or_list .= ' OR ';
            }
            $or_list .= db_string_equal_to('w_replacement', $word);
        }
        if (addon_installed('wordfilter')) {
            $_non_words = $GLOBALS['SITE_DB']->query('SELECT w_replacement FROM ' . get_table_prefix() . 'wordfilter WHERE ' . $or_list);
            foreach ($_non_words as $_non_word) {
                if ($_non_word['w_replacement'] != '') {
                    $okay_words[] = $_non_word['w_replacement'];
                }
            }
        }

        if (multi_lang_content()) {
            $or_list = '';
            foreach ($words as $word) {
                if ($or_list != '') {
                    $or_list .= ' OR ';
                }
                $or_list .= db_string_equal_to('text_original', $word);
            }
            $_non_words = $GLOBALS['SITE_DB']->query('SELECT DISTINCT text_original AS meta_keyword FROM ' . get_table_prefix() . 'seo_meta_keywords k JOIN ' . get_table_prefix() . 'translate t ON k.meta_keyword=t.id WHERE ' . $or_list);
        } else {
            $or_list = '';
            foreach ($words as $word) {
                if ($or_list != '') {
                    $or_list .= ' OR ';
                }
                $or_list .= db_string_equal_to('meta_keyword', $word);
            }
            $_non_words = $GLOBALS['SITE_DB']->query('SELECT DISTINCT meta_keyword FROM ' . get_table_prefix() . 'seo_meta_keywords WHERE ' . $or_list);
        }
        foreach ($_non_words as $_non_word) {
            if ($_non_word['meta_keyword'] != '') {
                $okay_words[] = $_non_word['meta_keyword'];
            }
        }

        add_spellchecker_words_temp($spell_link, $okay_words);
    }

    // Run checks
    switch ($spell_checker) {
        case 'pspell':
            foreach ($words as $word) {
                if (!pspell_check($spell_link, $word)) {
                    if ($provide_corrections) {
                        $corrections = pspell_suggest($spell_link, $word);
                        $errors[$word] = $corrections;
                    } else {
                        $errors[$word] = null;
                    }
                }
            }
            break;

        case 'enchant':
            list($broker, $dict, $personal_dict) = $spell_link;
            foreach ($words as $word) {
                if ($provide_corrections) {
                    $corrections = array();
                    if ((!enchant_dict_quick_check($dict, $word, $corrections)) && (!enchant_dict_quick_check($personal_dict, $word, $corrections))) {
                        $errors[$word] = $corrections;
                    }
                } else {
                    if ((!enchant_dict_check($dict, $word)) && (!enchant_dict_check($personal_dict, $word))) {
                        $errors[$word] = null;
                    }
                }
            }
            //enchant_broker_free($broker); Seems to crash on some PHP versions
            break;

        case 'mock':
            foreach ($words as $word) {
                if (!in_array($word, $spell_link)) {
                    $errors[$word] = $provide_corrections ? array() : null;
                }
            }
            break;
    }

    return $errors;
}

/**
 * Find all the words in some text.
 *
 * @param  string $text Text to scan for words in (should be plain text, not be HTML text)
 * @param  boolean $unicode_accepted Whether Unicode is accepted
 * @return array List of words
 */
function _find_words($text, $unicode_accepted = true)
{
    $text = str_replace('_', '-', $text); // Underscores as dashes

    $text = preg_replace('#\w+://[^\s]*#', '', $text); // Strip URLs

    $words = array();

    if (function_exists('fix_bad_unicode')) {
        $text = fix_bad_unicode($text);
    }

    $_words = array();
    $is_unicode = ((get_charset() == 'utf-8') && ($unicode_accepted));
    $regexp = $is_unicode ? WORD_REGEXP_UNICODE : WORD_REGEXP;
    $num_matches = preg_match_all($regexp, $text, $_words);
    if (($num_matches === false) && (preg_last_error() == PREG_BAD_UTF8_ERROR)) {
        $regexp = WORD_REGEXP;
        $num_matches = preg_match_all($regexp, $text, $_words);
    }

    for ($i = 0; $i < $num_matches; $i++) {
        $word = $_words[1][$i];

        if ($is_unicode) {
            if (cms_mb_strtoupper($word) == $word) { // Full caps means acronym
                continue;
            }
            if (cms_mb_strlen($word) == 1) { // Too short for a word
                continue;
            }
            if (cms_mb_strlen($word) > 25) { // No really long 'words'
                continue;
            }
        } else {
            if (strtoupper($word) == $word) { // Full caps means acronym
                continue;
            }
            if (strlen($word) == 1) { // Too short for a word
                continue;
            }
            if (strlen($word) > 25) { // No really long 'words'
                continue;
            }
        }

        if (preg_match('#\d#', $word) != 0) { // No 'words' can actually have numbers in
            continue;
        }

        $word = trim($word, "'"); // Strip back quotes or group possession apostrophe

        $word = preg_replace('#\'s$#', '', $word); // Strip back possession structure

        $word = $is_unicode ? cms_mb_strtolower($word) : strtolower($word);

        $words[$word] = true;
    }

    return array_keys($words);
}

/**
 * Initialise the spellcheck engine.
 * Will re-use connections, so if you want to call this call add_spellchecker_words_temp with it, before calling a spellchecker, that works.
 *
 * @param  ?ID_TEXT $lang Language to check in (null: current language)
 * @return ?mixed Spellchecker (null: error)
 *
 * @ignore
 */
function spellcheck_initialise($lang = null)
{
    $spell_checker = _find_spell_checker();

    if ($spell_checker === null) {
        return null;
    }

    if ($lang === null) {
        $lang = user_lang();
    }
    $lang = function_exists('do_lang') ? do_lang('dictionary') : 'en_GB'; // Default to UK English (as per Composr)

    global $SPELL_LINKS;
    if (isset($SPELL_LINKS[$lang])) {
        return $SPELL_LINKS[$lang];
    }

    $charset = function_exists('do_lang') ? do_lang('charset') : 'utf-8';

    $spelling = function_exists('do_lang') ? do_lang('dictionary_variant') : 'british';
    if ($spelling == $lang) {
        $spelling = '';
    }

    $p_dict_path = sl_get_custom_file_base() . '/data_custom/spelling/personal_dicts';

    switch ($spell_checker) {
        case 'pspell':
            $charset = str_replace('ISO-', 'iso', str_replace('iso-', 'iso', $charset));

            $pspell_config = @pspell_config_create($lang, $spelling, '', $charset);
            if ($pspell_config === false) { // Fallback
                $pspell_config = @pspell_config_create('en', $spelling, '', $charset);
                if ($pspell_config === false) {
                    return null;
                }
            }
            pspell_config_personal($pspell_config, $p_dict_path . '/' . $lang . '.pws');
            $spell_link = @pspell_new_config($pspell_config);

            if ($spell_link === false) { // Fallback: Might be that we had a late fail on initialising that language
                $pspell_config = @pspell_config_create('en', $spelling, '', $charset);
                if ($pspell_config === false) {
                    return null;
                }
                pspell_config_personal($pspell_config, $p_dict_path . '/' . $lang . '.pws');
                $spell_link = @pspell_new_config($pspell_config);
                if ($spell_link === false) {
                    return null;
                }
            }

            break;

        case 'enchant':
            $broker = enchant_broker_init();

            if (!enchant_broker_dict_exists($broker, $lang)) {
                $lang = 'en';
            }

            $personal_dict = enchant_broker_request_pwl_dict($broker, $p_dict_path . '/' . user_lang() . '.pwl');

            $dict = enchant_broker_request_dict($broker, $lang);

            $spell_link = array($broker, $dict, $personal_dict);

            break;

        case 'mock':
            $spell_link = array();
            break;
    }

    $SPELL_LINKS[$lang] = &$spell_link;

    return $spell_link;
}

/**
 * Shutdown the spellchecker.
 */
function spellchecker_shutdown()
{
    $spell_checker = _find_spell_checker();

    if ($spell_checker === null) {
        return null;
    }

    global $SPELL_LINKS;
    foreach ($SPELL_LINKS as $spell_link) {
        switch ($spell_checker) {
            case 'pspell':
                pspell_clear_session($spell_link);
                break;

            case 'enchant':
                enchant_broker_free($spell_link[0]);
                break;
        }
    }
}

/**
 * Find the active spell checker.
 *
 * @return ?string Spell checker (null: none)
 */
function _find_spell_checker()
{
    if (function_exists('get_value')) {
        $spell_checker = get_value('force_spell_checker');
        if ($spell_checker !== null) {
            return $spell_checker;
        }
    }

    if (function_exists('pspell_check')) {
        return 'pspell';
    }

    if (function_exists('enchant_dict_check')) {
        return 'enchant';
    }

    if (strpos($_SERVER['PHP_SELF'], 'code_quality.php') !== false) {
        // Allow testing even if pspell not working
        return 'mock';
    }

    return null;
}

/**
 * Find the path to where data is stored.
 *
 * @return string Relative path
 */
function sl_get_custom_file_base()
{
    if (function_exists('get_custom_file_base')) {
        return get_custom_file_base();
    }

    return dirname(dirname(__FILE));
}

/**
 * Add words to the spellchecker's temporary session dictionary.
 *
 * @param  mixed $spell_link Spellchecker
 * @param  array $words List of words
 */
function add_spellchecker_words_temp($spell_link, $words)
{
    $spell_checker = _find_spell_checker();

    if ($spell_checker === null) {
        return;
    }

    if ($spell_link === null) {
        return;
    }

    switch ($spell_checker) {
        case 'pspell':
            foreach ($words as $word) {
                pspell_add_to_session($spell_link, $word);
            }
            break;

        case 'enchant':
            list($broker, $dict, $personal_dict) = $spell_link;
            foreach ($words as $word) {
                enchant_dict_add_to_session($dict, $word);
            }
            break;

        case 'mock':
            $spell_link[] = strtolower($word);
            break;
    }
}

/**
 * Add words to the spellchecker's saved dictionary.
 *
 * @param  array $words List of words
 */
function add_spellchecker_words($words)
{
    $spell_checker = _find_spell_checker();

    if ($spell_checker === null) {
        return;
    }

    $spell_link = spellcheck_initialise();

    if ($spell_link === null) {
        return;
    }

    switch ($spell_checker) {
        case 'pspell':
            foreach ($words as $word) {
                pspell_add_to_personal($spell_link, $word);
            }
            pspell_save_wordlist($spell_link);
            break;

        case 'enchant':
            list($broker, $dict, $personal_dict) = $spell_link;
            foreach ($words as $word) {
                enchant_dict_add_to_personal($personal_dict, $word);
            }
            //enchant_broker_free($broker); Seems to crash on some PHP versions

            break;
    }
}

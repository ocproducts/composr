<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_rich_media
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__comcode()
{
    global $COMCODE_PARSE_URLS_CHECKED;
    $COMCODE_PARSE_URLS_CHECKED = 0;

    global $OVERRIDE_SELF_ZONE;
    $OVERRIDE_SELF_ZONE = null; // This is not pretty, but needed to properly scope links for search results.

    global $VALID_COMCODE_TAGS;
    $VALID_COMCODE_TAGS = null;

    global $LAX_COMCODE;
    $LAX_COMCODE = array(!function_exists('get_option') || get_option('lax_comcode') === '1');

    if (!defined('COMCODE_NORMAL')) {
        define('COMCODE_NORMAL', 0);
        define('COMCODE_SEMIPARSE_MODE', 1); // Whether to parse so as to create something that would fit inside a semihtml tag. It means we generate HTML, with Comcode written into it where the tag could never be reverse-converted (e.g. a block).
        define('COMCODE_PREPARSE_MODE', 2); // Whether this is being pre-parsed, to pick up errors before row insertion.
        define('COMCODE_IS_ALL_SEMIHTML', 4); // Whether to treat this whole thing as being wrapped in semihtml, but apply normal security otherwise.
        define('COMCODE_STRUCTURE_SWEEP', 8); // Whether we are only doing this parse to find the title structure.
        define('COMCODE_CHECK_ONLY', 16); // Whether to only check the Comcode. It's best to use the check_comcode function which will in turn use this parameter.
        define('COMCODE_IN_CODE_TAG', 32); // Whether the parse context is already in a code tag.
    }
}

/**
 * Add new lax Comcode setting. Set whether the lax Comcode parser should be used, which is important for any Comcode not being interactively added (i.e. existing Comcode should not cause errors, even if it is poor quality).
 *
 * @param  boolean $setting New setting
 */
function push_lax_comcode($setting)
{
    global $LAX_COMCODE;
    array_push($LAX_COMCODE, $setting);
}

/**
 * Remove last lax Comcode setting.
 */
function pop_lax_comcode()
{
    global $LAX_COMCODE;
    array_pop($LAX_COMCODE);
}

/**
 * See lax Comcode setting.
 *
 * @return boolean Last setting
 */
function peek_lax_comcode()
{
    global $LAX_COMCODE;
    return end($LAX_COMCODE);
}

/**
 * Set up the VALID_COMCODE_TAGS global. It uses a bit of memory, so for performance we do it on-demand.
 */
function init_valid_comcode_tags()
{
    global $VALID_COMCODE_TAGS;

    if ($VALID_COMCODE_TAGS !== null) {
        return;
    }

    /** A list of all valid Comcode tags that we recognise.
     *
     * @global array $VALID_COMCODE_TAGS
     */
    $VALID_COMCODE_TAGS = array(
        'samp' => true, 'q' => true, 'var' => true, 'overlay' => true, 'tooltip' => true,
        'section' => true, 'section_controller' => true,
        'big_tab' => true, 'big_tab_controller' => true, 'tabs' => true, 'tab' => true,
        'carousel' => true, 'cite' => true, 'ins' => true, 'del' => true, 'dfn' => true, 'address' => true, 'acronym' => true, 'abbr' => true, 'contents' => true, 'concepts' => true, 'list' => true,
        'flash' => true, 'media_set' => true, 'media' => true, 'indent' => true, 'staff_note' => true, 'menu' => true, 'b' => true, 'i' => true, 'u' => true, 's' => true, 'sup' => true, 'sub' => true,
        'if_in_group' => true, 'title' => true, 'size' => true, 'color' => true, 'highlight' => true, 'font' => true, 'tt' => true, 'box' => true, 'img' => true,
        'url' => true, 'email' => true, 'reference' => true, 'page' => true, 'codebox' => true, 'no_parse' => true, 'code' => true, 'hide' => true,
        'quote' => true, 'block' => true, 'semihtml' => true, 'html' => true, 'concept' => true, 'thumb' => true,
        'attachment' => true, 'attachment_safe' => true, 'align' => true, 'left' => true, 'center' => true, 'right' => true,
        'snapback' => true, 'post' => true, 'topic' => true, 'include' => true, 'random' => true, 'ticker' => true, 'jumping' => true, 'surround' => true, 'pulse' => true, 'shocker' => true,
        'require_css' => true, 'require_javascript' => true,
    );
    //if (addon_installed('ecommerce')) {
    $VALID_COMCODE_TAGS['currency'] = true;
    //}
}

/**
 * Set up the POTENTIAL_JS_NAUGHTY_ARRAY global. It uses a bit of memory, so for performance we do it on-demand.
 */
function init_potential_js_naughty_array()
{
    // We're not allowed to specify any of these as entities
    global $POTENTIAL_JS_NAUGHTY_ARRAY;
    $POTENTIAL_JS_NAUGHTY_ARRAY = array(
        'd' => true, /*'a' => true, 't' => true, 'a' => true,*/
        'j' => true, 'a' => true, 'v' => true, 's' => true, 'c' => true, 'r' => true, 'i' => true, 'p' => true, 't' => true,
        'J' => true, 'A' => true, 'V' => true, 'S' => true, 'C' => true, 'R' => true, 'I' => true, 'P' => true, 'T' => true,
        ' ' => true, "\t" => true, "\n" => true, "\r" => true, ':' => true, '/' => true, '*' => true, '\\' => true,
    );
    $POTENTIAL_JS_NAUGHTY_ARRAY[chr(0)] = true;
}

/**
 * Make text usable inside a string inside Comcode.
 *
 * @param  string $in Raw text
 * @return string Escaped text
 */
function comcode_escape($in)
{
    return str_replace('{', '\\{', str_replace('[', '\\[', str_replace('"', '\\"', str_replace('\\', '\\\\', $in))));
}

/**
 * Convert (X)HTML into Comcode.
 *
 * @param  LONG_TEXT $html The HTML to be converted
 * @param  boolean $force Whether to force full conversion regardless of settings
 * @return LONG_TEXT The equivalent Comcode
 */
function html_to_comcode($html, $force = true)
{
    // First we don't allow this to be semi-html
    $html = str_replace('[', '&#091;', $html);

    require_code('comcode_from_html');

    return semihtml_to_comcode($html, $force);
}

/**
 * Get the text with all the emoticon codes replaced with the correct XHTML. Emoticons are determined by your forum system.
 * This is not used in the normal Comcode chain - it's for non-Comcode things that require emoticons (actually in reality it is used in the Comcode chain if the optimiser sees that a full parse is not needed).
 *
 * @param  string $text The text to add emoticons to (assumption: that this is XHTML)
 * @return string The XHTML with the image-substitution of emoticons
 */
function apply_emoticons($text)
{
    if ($text == '') {
        return '';
    }

    require_code('comcode_renderer');
    if (preg_match('#^[A-Za-z0-9\s]*$#', $text) != 0) {
        return $text; // Nothing interesting here
    }
    return _apply_emoticons($text);
}

/**
 * Convert the specified Comcode (unknown format) into a Tempcode tree. You shouldn't output the Tempcode tree to the browser, as it looks really horrible. If you are in a rare case where you need to output directly (not through templates), you should call the evaluate method on the Tempcode object, to convert it into a string.
 *
 * @param  LONG_TEXT $comcode The Comcode to convert
 * @param  ?MEMBER $source_member The member the evaluation is running as. This is a security issue, and you should only run as an administrator if you have considered where the Comcode came from carefully (null: current member)
 * @param  boolean $as_admin Whether to explicitly execute this with admin rights. There are a few rare situations where this should be done, for data you know didn't come from a member, but is being evaluated by one. Note that if this is passed false, and $source_member is an admin, it will be parsed using admin privileges anyway.
 * @param  ?string $pass_id A special identifier that can identify this resource in a sea of our resources of this class; usually this can be ignored, but may be used to provide a binding between JavaScript in evaluated Comcode, and the surrounding environment (null: no explicit binding)
 * @param  ?object $db The database connector to use (null: standard site connector)
 * @param  integer $flags A bitmask of COMCODE_* flags
 * @param  array $highlight_bits A list of words to highlight
 * @param  ?MEMBER $on_behalf_of_member The member we are running on behalf of, with respect to how attachments are handled; we may use this members attachments that are already within this post, and our new attachments will be handed to this member (null: member evaluating)
 * @return Tempcode The Tempcode generated
 */
function comcode_to_tempcode($comcode, $source_member = null, $as_admin = false, $pass_id = null, $db = null, $flags = 0, $highlight_bits = array(), $on_behalf_of_member = null)
{
    $matches = array();
    if (preg_match('#^\{\!([A-Z_]+)\}$#', $comcode, $matches) != 0) {
        return do_lang_tempcode($matches[1]);
    }

    // Optimised code path (still has to support emoticons though, as those are arbitrary)
    $attachments = (count($_FILES) != 0);
    foreach ($_POST as $key => $value) {
        if (is_integer($key)) {
            $key = strval($key);
        }

        if (preg_match('#^hidFileID_#i', $key) != 0) {
            $attachments = true;
        }
    }
    if ((!$attachments || ($GLOBALS['IN_MINIKERNEL_VERSION'])) && (preg_match('#^[\w\-\(\) \.,:;/"\!\?]*$#'/*NB: No apostophes allowed in here, as they get changed by escape_html and can interfere then with apply_emoticons*/, $comcode) != 0) && (strpos($comcode, '  ') === false) && (strpos($comcode, '://') === false) && (strpos($comcode, '--') === false) && (get_page_name() != 'search')) {
        if (running_script('stress_test_loader')) {
            return make_string_tempcode(escape_html($comcode));
        }
        return make_string_tempcode(apply_emoticons(escape_html($comcode)));
    }

    // Full code path...

    require_code('comcode_renderer');
    $long = (cms_mb_strlen($comcode) > 1000);
    if ($long) {
        cms_profile_start_for('comcode_to_tempcode/LONG');
    }
    $ret = _comcode_to_tempcode($comcode, $source_member, $as_admin, $pass_id, $db, $flags, $highlight_bits, $on_behalf_of_member);
    if ($long) {
        cms_profile_end_for('comcode_to_tempcode/LONG', ($source_member === null) ? '' : ('owned by member #' . strval($source_member)));
    }
    return $ret;
}

/**
 * Make some Comcode more readable by humans.
 *
 * @param  string $in Plain-text/Comcode
 * @param  boolean $for_extract Whether this is for generating an extract that does not need to be fully comprehended (i.e. favour brevity)
 * @param  array $tags_to_preserve List of tags to preserve
 * @return string Purified plain-text
 */
function strip_comcode($in, $for_extract = false, $tags_to_preserve = array())
{
    $text = $in;

    if ($text == '') {
        return '';
    }

    static $done = array();
    if (isset($done[$text])) {
        return $done[$text];
    }

    $input_text = $text;

    $matches = array();
    if (preg_match('#^(\[semihtml\])?([\w\-\(\) \.,:;/"\'\!\?]*)(\[/semihtml\])?$#', $text, $matches) != 0) {
        $done[$text] = $matches[2];
        return $matches[2]; // Optimisation
    }

    require_code('comcode_to_text');
    $text = _strip_comcode($text, $for_extract, $tags_to_preserve);

    $done[$text] = $text;
    return $text;
}

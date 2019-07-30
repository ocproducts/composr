<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_language_editing
 */

/**
 * Hook class.
 */
class Hook_translation_google_translate
{
    /**
     * Whether this translation hook is available.
     *
     * @param  ?LANGUAGE_NAME $from Source language (null: do not consider)
     * @param  ?LANGUAGE_NAME $to Destination language (null: do not consider)
     * @param  ?string $errormsg Error message (returned by reference) (null: not set yet)
     * @return boolean Whether it is
     */
    public function has_translation($from, $to, &$errormsg)
    {
        if (get_option('google_apis_api_key') == '') {
            return false;
        }
        if (get_option('google_translate_enabled') == '0') {
            return false;
        }

        if ($from !== null) {
            $_from = $this->get_google_lang_code($from, $errormsg);
            if ($_from === null) {
                return false;
            }
        }
        if ($to !== null) {
            $_to = $this->get_google_lang_code($to, $errormsg);
            if ($_to === null) {
                return false;
            }
        }

        return true;
    }

    /**
     * Translate some text.
     *
     * @param  integer $context A TRANS_TEXT_CONTEXT_* constant
     * @param  ?LANGUAGE_NAME $from Source language (null: autodetect from the text itself)
     * @param  LANGUAGE_NAME $to Destination language
     * @param  ?string $errormsg Error message (returned by reference) (null: not set yet)
     * @return mixed Context metadata for the particular translation effort
     */
    public function get_translation_context($context, $from, $to, &$errormsg)
    {
        if ($from !== null) {
            $_from = $this->get_google_lang_code($from, $errormsg);
            if ($_from === null) {
                return null;
            }
        } else {
            $_from = null;
        }
        $_to = $this->get_google_lang_code($to, $errormsg);
        if ($_to === null) {
            return null;
        }

        return array($_from, $_to);
    }

    /**
     * Translate some text.
     *
     * @param  string $text The text to translate
     * @param  integer $context A TRANS_TEXT_CONTEXT_* constant
     * @param  mixed $context_metadata Context metadata for the particular translation effort
     * @param  ?LANGUAGE_NAME $from Source language (null: autodetect from the text itself)
     * @param  LANGUAGE_NAME $to Destination language
     * @param  ?string $errormsg Error message (returned by reference) (null: not set yet)
     * @return ?string Translated text (null: some kind of error)
     */
    public function translate_text($text, $context, $context_metadata, $from, $to, &$errormsg)
    {
        if ($context_metadata === null) {
            return null; // Should never happen as has_translation would have returned false
        }

        list($_from, $_to) = $context_metadata;

        $url = 'https://translation.googleapis.com/language/translate/v2';
        $request = array(
            'q' => $text,
            'source' => $_from,
            'target' => $_to,
        );
        switch ($context) {
            case TRANS_TEXT_CONTEXT_autodetect:
                break;

            case TRANS_TEXT_CONTEXT_plain:
                $request['format'] = 'text';
                break;

            case TRANS_TEXT_CONTEXT_html_block:
            case TRANS_TEXT_CONTEXT_html_inline:
            case TRANS_TEXT_CONTEXT_html_raw:
                $request['format'] = 'html';
                break;
        }

        $result = $this->_google_translate_api_request($url, $request, $errormsg);

        if (!isset($result['data']['translations'][0]['translatedText'])) {
            return null;
        }

        return $result['data']['translations'][0]['translatedText'];
    }

    /**
     * Put a result within some surrounding text, based on the display context.
     * Some translation backends require output text to be displayed in a certain way.
     *
     * @param  string $text_result Result text
     * @param  integer $context A TRANS_TEXT_CONTEXT_* constant
     * @param  mixed $context_metadata Context metadata for the particular translation effort
     * @return string Output text
     */
    public function put_result_into_context($text_result, $context, $context_metadata)
    {
        if ($context_metadata === null) {
            return $text_result; // Should never happen
        }

        list($_from, $_to) = $context_metadata;

        $ret = $text_result;
        switch ($context) {
            case TRANS_TEXT_CONTEXT_autodetect:
            case TRANS_TEXT_CONTEXT_plain:
            case TRANS_TEXT_CONTEXT_html_raw:
                $ret = $text_result;
                break;

            case TRANS_TEXT_CONTEXT_html_block:
            case TRANS_TEXT_CONTEXT_html_inline:
                $tag = ($context == TRANS_TEXT_CONTEXT_html_block) ? 'div' : 'span';
                $ret = '<' . $tag . ' lang="' . $_to . '-x-mtfrom-' . $_from . '">' . $text_result . '</' . $tag . '>';
                if ($context == TRANS_TEXT_CONTEXT_html_block) {
                    $ret .= '<div>' . $this->get_translation_credit() . '</div>';
                }
                break;
        }

        return $ret;
    }

    /**
     * Get HTML to provide credit to the translation backend, as appropriate.
     *
     * @return string Credit HTML
     */
    public function get_translation_credit()
    {
        $powered_by = do_lang('POWERED_BY', 'Google Translate');
        $lnw = do_lang('LINK_NEW_WINDOW');
        $img = find_theme_image('google_translate');
        return '<a href="http://translate.google.com/" target="_blank" title="' . $powered_by . ' ' . $lnw . '"><img src="' . escape_html($img) . '" alt="" /></a>';
    }

    /**
     * Convert a standard language codename to a Google Translate code.
     *
     * @param  LANGUAGE_NAME $in The code to convert
     * @param  ?string $errormsg Error message (returned by reference) (null: not set yet)
     * @return ?string The converted code (null: none found)
     */
    protected function get_google_lang_code($in, &$errormsg = null)
    {
        $url = 'https://translation.googleapis.com/language/translate/v2/languages';
        $ret = str_replace('_', '-', strtolower($in));

        // Now check the language actually exists...

        require_code('http');
        $errormsg = null;
        $result = unserialize(cache_and_carry(array($this, '_google_translate_api_request'), array($url, null, &$errormsg)));

        if (!isset($result['data']['languages'])) {
            return null;
        }

        foreach ($result['data']['languages'] as $lang) {
            if ($lang['language'] == $ret) {
                return $ret;
            }
        }

        return null;
    }

    /**
     * Call a Google Translate API.
     * Needs to be public as it is used in a callback.
     *
     * @param  URLPATH $url API URL to call
     * @param  ?array $request Request data (null: GET request)
     * @param  ?string $errormsg Error message (returned by reference) (null: not set yet)
     * @return ?array Result (null: some kind of error)
     */
    public function _google_translate_api_request($url, $request = null, &$errormsg = null)
    {
        $key = get_option('google_apis_api_key');
        $url .= '?key=' . urlencode($key);

        if ($request === null) {
            $_request = null;
        } else {
            $_request = json_encode($request);
        }

        $_result = http_get_contents($url, array('ignore_http_status' => true, 'trigger_error' => false, 'post_params' => ($_request === null) ? null : array($_request), 'timeout' => 0.5, 'raw_post' => ($request !== null), 'http_verb' => ($request === null) ? 'GET' : 'POST', 'raw_content_type' => 'application/json'));

        $result = @json_decode($_result, true);
        if (($result === false) || (array_key_exists('error', $result))) {
            $errormsg = (array_key_exists('error', $result) ? $result['error']['message'] : $_result);
            if (php_function_allowed('error_log')) {
                error_log('Google Translate issue: ' . $_result, 0);
            }

            return null;
        }
        return $result;
    }
}

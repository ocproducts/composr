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
class Hook_translation_bing_translator
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
        if (get_option('azure_api_key') == '') {
            return false;
        }
        if (get_option('bing_translator_enabled') == '0') {
            return false;
        }

        if ($from !== null) {
            $_from = $this->get_bing_lang_code($from, $errormsg);
            if ($_from === null) {
                return false;
            }
        }
        if ($to !== null) {
            $_to = $this->get_bing_lang_code($to, $errormsg);
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
            $_from = $this->get_bing_lang_code($from, $errormsg);
            if ($_from === null) {
                return null;
            }
        } else {
            $_from = null;
        }
        $_to = $this->get_bing_lang_code($to, $errormsg);
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

        $url = 'https://api.cognitive.microsofttranslator.com/translate?api-version=3.0';
        if ($from !== null) {
            $url .= '&from=' . urlencode($from);
        }
        $url .= '&to=' . urlencode($to);
        switch ($context) {
            case TRANS_TEXT_CONTEXT_autodetect:
                if (preg_match('#(&\w+;|<([a-z]+|[A-Z]+)[ />])#', $text) != 0) {
                    $url .= '&textType=html';
                } else {
                    $url .= '&textType=plain';
                }
                break;

            case TRANS_TEXT_CONTEXT_plain:
                $url .= '&textType=plain';
                break;

            case TRANS_TEXT_CONTEXT_html_block:
            case TRANS_TEXT_CONTEXT_html_inline:
            case TRANS_TEXT_CONTEXT_html_raw:
                $url .= '&textType=html';
                break;
        }


        $request = array(
            array(
                'Text' => $text,
            )
        );

        $result = $this->_bing_translator_api_request($url, $request, $errormsg);

        if (!isset($result[0]['translations'][0]['text'])) {
            return null;
        }

        return $result[0]['translations'][0]['text'];
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
        return $text_result;
    }

    /**
     * Get HTML to provide credit to the translation backend, as appropriate.
     *
     * @return string Credit HTML
     */
    public function get_translation_credit()
    {
        return '';
    }

    /**
     * Convert a standard language codename to a Bing Translator code.
     *
     * @param  LANGUAGE_NAME $in The code to convert
     * @param  ?string $errormsg Error message (returned by reference) (null: not set yet)
     * @return ?string The converted code (null: none found)
     */
    protected function get_bing_lang_code($in, &$errormsg = null)
    {
        // Pre-cleanup
        $remap = array('ZH' => 'zh-Hant');
        $ret = str_replace(array_keys($remap), array_values($remap), $in);
        $ret = str_replace('_', '-', strtolower($in));

        $url = 'https://api.cognitive.microsofttranslator.com/languages?api-version=3.0&scope=translation';

        // Now check the language actually exists...

        require_code('http');
        $errormsg = null;
        $result = unserialize(cache_and_carry(array($this, '_bing_translator_api_request'), array($url, null, &$errormsg)));

        if (isset($result['translation'][$ret])) {
            return $ret;
        }

        return null;
    }

    /**
     * Call a Bing Translator API.
     * Needs to be public as it is used in a callback.
     *
     * @param  URLPATH $url API URL to call
     * @param  ?array $request Request data (null: GET request)
     * @param  ?string $errormsg Error message (returned by reference) (null: not set yet)
     * @return ?array Result (null: some kind of error)
     */
    public function _bing_translator_api_request($url, $request = null, &$errormsg = null)
    {
        $key = get_option('azure_api_key');

        if ($request === null) {
            $_request = null;
        } else {
            $_request = json_encode($request);
        }

        $options = array(
            'ignore_http_status' => true,
            'trigger_error' => false,
            'post_params' => ($_request === null) ? null : array($_request),
            'timeout' => 0.5,
            'raw_post' => ($request !== null),
            'http_verb' => ($request === null) ? 'GET' : 'POST',
            'raw_content_type' => 'application/json',
            'extra_headers' => array('Ocp-Apim-Subscription-Key' => $key),
        );
        $_result = http_get_contents($url, $options);

        $result = @json_decode($_result, true);
        if (($result === false) || (array_key_exists('error', $result))) {
            $errormsg = (array_key_exists('error', $result) ? $result['error']['message'] : $_result);
            if (php_function_allowed('error_log')) {
                error_log('Bing Translator issue: ' . $_result, 0);
            }

            return null;
        }
        return $result;
    }
}

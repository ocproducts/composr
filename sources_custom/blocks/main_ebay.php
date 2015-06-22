<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 */
class Block_main_ebay
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Babu';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = false;
        $info['parameters'] = array('type', 'seller', 'query', 'domain', 'lang');
        return $info;
    }

    /**
     * Find caching details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled).
     */
    public function caching_environment()
    {
        $info = array();
        $info['cache_on'] = 'array(array_key_exists(\'type\',$map)?$map[\'type\']:\'\',array_key_exists(\'seller\',$map)?$map[\'seller\']:\'\',array_key_exists(\'query\',$map)?$map[\'query\']:\'\',array_key_exists(\'lang\',$map)?$map[\'lang\']:\'\')';
        $info['ttl'] = (get_value('no_block_timeout') === '1') ? 60 * 60 * 24 * 365 * 5/*5 year timeout*/ : 15;
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

        require_lang('ebay');

        if (!array_key_exists('seller', $map)) {
            return do_lang_tempcode('NO_PARAMETER_SENT', 'seller');
        }

        $height = (isset($map['height']) && intval($map['height']) > 0) ? $map['height'] : '350';
        $width = (isset($map['width']) && intval($map['width']) > 0) ? $map['width'] : '350';
        $domain = (isset($map['domain']) && $map['domain'] != '') ? $map['domain'] : 'com';
        $title = (isset($map['title']) && $map['title'] != '') ? $map['title'] : do_lang_tempcode('BLOCK_EBAY_TITLE');
        $lang = (isset($map['lang']) && $map['lang'] != '') ? ('&lang=' . $map['lang']) : '';

        $type = (isset($map['type']) && strlen($map['type']) > 0) ? $map['type'] : 'store';
        $seller = $map['seller'];//'yourrightchoice';//ecomelectronics
        $query = (isset($map['query']) && strlen($map['query']) > 0) ? preg_replace('#\s#', '+', $map['query']) : ''; //i.e. Gadgets

        $out = '';

        if ($type == 'seller') {
            //ebay seller: yourrightchoice
            $out .= '<object width="' . $width . '" height="' . $height . '"><param name="movie" value="http://togo.ebay.' . $domain . '/togo/seller.swf" /><param name="flashvars" value="base=http://togo.ebay.' . $domain . '/togo/' . $lang . '&seller=' . $seller . '" /><embed src="http://togo.ebay.' . $domain . '/togo/seller.swf" type="application/x-shockwave-flash" width="' . $width . '" height="' . $height . '" flashvars="base=http://togo.ebay.' . $domain . '/togo/' . $lang . '&seller=' . $seller . '"></embed></object>';
        } else {
            //e-bay store code using i.e. seller id=ecomelectronics :
            $out .= '<object width="' . $width . '" height="' . $height . '"><param name="movie" value="http://togo.ebay.' . $domain . '/togo/store.swf" /><param name="flashvars" value="base=http://togo.ebay.' . $domain . '/togo/' . $lang . '&seller=' . $seller . '&query=' . $query . '" /><embed src="http://togo.ebay.' . $domain . '/togo/store.swf" type="application/x-shockwave-flash" width="' . $width . '" height="' . $height . '" flashvars="base=http://togo.ebay.' . $domain . '/togo/' . $lang . '&seller=' . $seller . '&query=' . $query . '"></embed></object>';
        }

        return do_template('BLOCK_MAIN_EBAY', array('_GUID' => 'ffda4477bf08164f80dd45ef2985dfe9', 'TITLE' => $title, 'CONTENT' => ($out)));
    }
}

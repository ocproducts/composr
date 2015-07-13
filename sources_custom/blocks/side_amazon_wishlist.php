<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 */
/*EXTRA FUNCTIONS: simplexml_load_string|hash_hmac*/

/**
 * Block class.
 */
class Block_side_amazon_wishlist
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
        $info['parameters'] = array('wishlist_id', 'access_key', 'secret_key', 'domain', 'title');
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
        $info['cache_on'] = 'array(array_key_exists(\'wishlist_id\',$map)?$map[\'wishlist_id\']:\'\',array_key_exists(\'access_key\',$map)?$map[\'access_key\']:\'\',array_key_exists(\'secret_key\',$map)?$map[\'secret_key\']:\'\',array_key_exists(\'domain\',$map)?$map[\'domain\']:\'\',array_key_exists(\'title\',$map)?$map[\'title\']:\'\')';
        $info['ttl'] = (get_value('no_block_timeout') === '1') ? 60 * 60 * 24 * 365 * 5/*5 year timeout*/ : 60 * 5;
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters.
     * @return Tempcode The result of execution.
     */
    public function run($map)
    {
        i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

        require_lang('amazon');

        global $SECRET_KEY;
        $title = (isset($map['title']) && strlen($map['title']) > 0) ? $map['title'] : do_lang_tempcode('BLOCK_AMAZON_WISHLIST_TITLE');
        if (!array_key_exists('wishlist_id', $map)) {
            return do_lang_tempcode('NO_PARAMETER_SENT', 'wishlist_id');
        }
        if (!array_key_exists('access_key', $map)) {
            return do_lang_tempcode('NO_PARAMETER_SENT', 'access_key');
        }
        if (!array_key_exists('secret_key', $map)) {
            return do_lang_tempcode('NO_PARAMETER_SENT', 'secret_key');
        }
        $wishlist_id = $map['wishlist_id'];
        $access_key = $map['access_key'];
        $SECRET_KEY = $map['secret_key'];
        $domain = $map['domain'];//'com';//could be also 'co.uk'

        $out = '';

        require_code('files');
        require_css('amazon_wishlist');

        $i = 0;
        do {
            $i++;

            $url = $this->createSignature('http://webservices.amazon.' . $domain . '/onca/xml?AWSAccessKeyId=' . $access_key . '&ListId=' . $wishlist_id . '&ListType=WishList&Operation=ListLookup&ProductPage=' . strval($i) . '&ResponseGroup=Request,ListFull&Service=AWSECommerceService&Timestamp=' . gmdate('Y-m-d\TH:i:s\Z') . '&Version=2008-09-17');

            $xml_url = http_download_file($url);
            $items = simplexml_load_string($xml_url);

            if (!empty($items->Lists->List->ListItem)) {
                foreach ($items->Lists->List->ListItem as $item) {
                    if ($item->QuantityReceived == '0') {
                        $url = $this->createSignature('http://webservices.amazon.' . $domain . '/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=' . $access_key . '&Operation=ItemLookup&IdType=ASIN&ItemId=' . $item->Item->ASIN . '&MerchantId=All&ResponseGroup=Medium&Timestamp=' . gmdate('Y-m-d\TH:i:s\Z') . '&Version=2007-07-16');

                        $xml_url = http_download_file($url);
                        $item_details = simplexml_load_string($xml_url);

                        $out .= '<div class="amazon_wishlist"><img src="' . $item_details->Items->Item->SmallImage->URL . '" width="22"  /> <a href="' . $item_details->Items->Item->DetailPageURL . '" title="' . escape_html($item->Item->ItemAttributes->Title) . '">' . $item->Item->ItemAttributes->Title . '</a></div><br />';
                    }
                }
            }
        } while ($items->Lists->List->TotalPages > $i);

        return do_template('BLOCK_SIDE_AMAZON_WISHLIST', array('_GUID' => '3c5da7ade6aca4c30a3842e00d686d90', 'TITLE' => $title, 'CONTENT' => $out));
    }

    /**
     * Function to create the signature for amazon web service.
     *
     * @param  SHORT_TEXT $url Amazon web service URL
     * @param  LONG_TEXT $params additional url params
     * @return SHORT_TEXT Amazon web service URL with signature
     */
    public function createSignature($url, $params = '')
    {
        global $SECRET_KEY;
        $url_parts = parse_url($url);
        $query = array();
        parse_str($url_parts['query'], $query);
        uksort($query, 'strcasecmp');
        foreach ($query as $key => $value) {
            $params .= $key . '=' . str_replace(array(':', ','), array('%3A', '%2C'), $value) . '&';
        }
        $signature = base64_encode(hash_hmac('sha256', "GET\n" . $url_parts['host'] . "\n" . $url_parts['path'] . "\n" . substr($params, 0, -1), $SECRET_KEY, true));
        $return = 'http://' . $url_parts['host'] . $url_parts['path'] . '?' . $params . 'Signature=' . str_replace(array('+', '='), array('%2B', '%3D'), $signature);

        return $return;
    }
}

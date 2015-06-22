<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 */
class Block_side_amazon_affiliate_sales
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Kamen Blaginov';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = false;
        $info['parameters'] = array('associates_id', 'product_line', 'subject_keywords', 'items_number');
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
        $info['cache_on'] = 'array(array_key_exists(\'associates_id\',$map)?$map[\'associates_id\']:\'\',array_key_exists(\'product_line\',$map)?$map[\'product_line\']:\'\',array_key_exists(\'subject_keywords\',$map)?$map[\'subject_keywords\']:\'\',array_key_exists(\'items_number\',$map)?$map[\'items_number\']:\'\')';
        $info['ttl'] = (get_value('no_block_timeout') === '1') ? 60 * 60 * 24 * 365 * 5/*5 year timeout*/ : 60 * 5;
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

        require_lang('amazon');

        if (!array_key_exists('associates_id', $map)) {
            return do_lang_tempcode('NO_PARAMETER_SENT', 'associates_id');
        }
        if (!array_key_exists('product_line', $map)) {
            return do_lang_tempcode('NO_PARAMETER_SENT', 'product_line');
        }
        if (!array_key_exists('subject_keywords', $map)) {
            return do_lang_tempcode('NO_PARAMETER_SENT', 'subject_keywords');
        }
        if (!array_key_exists('items_number', $map)) {
            return do_lang_tempcode('NO_PARAMETER_SENT', 'items_number');
        }

        $associates_id = $map['associates_id'];//'we4u-20';//
        $product_line = $map['product_line'];
        $subject_keywords = preg_replace('#\s#', '+', $map['subject_keywords']);
        $n = (isset($map['items_number']) && intval($map['items_number']) > 0) ? intval($map['items_number']) : 3;

        $out = '';

        for ($i = 0; $i < $n; $i++) {
            $out .= '<iframe src="http://rcm.amazon.com/e/cm?lt1=_blank&t=' . escape_html($associates_id) . '&o=1&p=8&l=st1&mode=' . escape_html($product_line) . '&search=' . escape_html($subject_keywords) . '&t1=_blank&lc1=00FFFF&bg1=FFFFFF&f=ifr" marginwidth="0" marginheight="0" width="120px" height="240" border="0" frameborder="0" style="width: 120px; border:none;" scrolling="no"></iframe><br /><br />';
        }

        return do_template('BLOCK_SIDE_AMAZON_AFFILIATES', array(
            '_GUID' => '5edc2fd386f1688fca8e0e6eefa5f455',
            'TITLE' => do_lang_tempcode('BLOCK_AMAZON_AFFILIATE_SALES_TITLE'),
            'CONTENT' => $out,
            'ASSOCIATES_ID' => $associates_id,
            'PRODUCT_LINE' => $product_line,
            'SUBJECT_KEYWORDS' => $subject_keywords,
        ));
    }
}

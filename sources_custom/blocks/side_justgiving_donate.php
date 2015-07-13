<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 */
class Block_side_justgiving_donate
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = false;
        $info['parameters'] = array('eggid');
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
        $info['cache_on'] = 'array(array_key_exists(\'eggid\',$map)?$map[\'eggid\']:0)';
        $info['ttl'] = 60 * 5;
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

        require_lang('justgiving_donate');

        if (!array_key_exists('eggid', $map)) {
            return do_lang_tempcode('NO_PARAMETER_SENT', 'eggid');
        }

        $eggid = $map['eggid'];

        return do_template('BLOCK_SIDE_JUSTGIVING_DONATE', array('_GUID' => 'f2fcc049804d8305eb0d8fe2cee81626', 'TITLE' => do_lang_tempcode('BLOCK_JUSTGIVING_DONATE_TITLE'), 'EGGID' => $eggid));
    }
}

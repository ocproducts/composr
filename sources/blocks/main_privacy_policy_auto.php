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
 * @package    core_privacy
 */

/**
 * Block class.
 */
class Block_main_privacy_policy_auto
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled)
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 1;
        $info['locked'] = false;
        $info['parameters'] = array();
        return $info;
    }

    /**
     * Find caching details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled)
     */
    public function caching_environment()
    {
        $info = array();
        $info['cache_on'] = 'array()';
        $info['ttl'] = 60 * 60 * 24 * 365 * 5/*5 year timeout*/;
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters
     * @return Tempcode The result of execution
     */
    public function run($map)
    {
        require_code('privacy');

        $cookies = array();

        $sections = array();

        $sections[do_lang('COOKIES')] = array(
            'HEADING' => do_lang_tempcode('COOKIES'),
            'POSITIVE' => array(),
            'GENERAL' => array(),
        );

        $hook_obs = find_all_hook_obs('systems', 'privacy', 'Hook_privacy_');
        foreach ($hook_obs as $hook_ob) {
            $info = $hook_ob->info();

            foreach ($info['cookies'] as $name => $details) {
                $cookies[] = array(
                    'NAME' => $name,
                    'REASON' => $details['reason'],
                );
            }

            foreach ($info['positive'] as $name => $details) {
                if (!array_key_exists($name, $sections)) {
                    $sections[$name] = array(
                        'HEADING' => $name,
                        'POSITIVE' => array(),
                        'GENERAL' => array(),
                    );
                }

                $sections[$name]['POSITIVE'] = array(
                    'EXPLANATION' => $details['explanation'],
                );
            }

            foreach ($info['general'] as $name => $details) {
                if (!array_key_exists($name, $sections)) {
                    $sections[$name] = array(
                        'HEADING' => $name,
                        'POSITIVE' => array(),
                        'GENERAL' => array(),
                    );
                }

                $sections[$name]['GENERAL'] = array(
                    'ACTION' => $details['action'],
                    'REASON' => $details['reason'],
                );
            }
        }

        return do_template('BLOCK_MAIN_PRIVACY_POLICY_AUTO', array(
            '_GUID' => '0abf65878c508bf244836589a8cc45da',
            'SECTIONS' => $sections,
            'COOKIES' => $cookies,
        ));
    }
}

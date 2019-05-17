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
 * @package    commandr
 */

/**
 * Hook class.
 */
class Hook_commandr_command_closed
{
    /**
     * Run function for Commandr hooks.
     *
     * @param  array $options The options with which the command was called
     * @param  array $parameters The parameters with which the command was called
     * @param  object $commandr_fs A reference to the Commandr filesystem object
     * @return array Array of stdcommand, stdhtml, stdout, and stderr responses
     */
    public function run($options, $parameters, &$commandr_fs)
    {
        require_code('config2');

        if ((array_key_exists('h', $options)) || (array_key_exists('help', $options))) {
            return array('', do_command_help('closed', array('h', 'o', 'c'), array(true)), '', '');
        } else {
            if ((array_key_exists('o', $options)) || (array_key_exists('open', $options))) {
                set_option('site_closed', '0');
            }
            if ((array_key_exists('c', $options)) || (array_key_exists('close', $options))) {
                if (!array_key_exists(0, $parameters)) {
                    return array('', '', '', do_lang('MISSING_PARAM', '1', 'closed'));
                }
                set_option('site_closed', '1');
                set_option('closed', $parameters[0]);
            }
            return array('', '', do_lang('SUCCESS'), '');
        }
    }
}

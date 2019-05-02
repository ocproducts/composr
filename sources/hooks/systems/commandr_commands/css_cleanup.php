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
class Hook_commandr_command_css_cleanup
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
        if ((array_key_exists('h', $options)) || (array_key_exists('help', $options))) {
            return array('', do_command_help('css_cleanup', array('h'), array(true, true)), '', '');
        } else {
            if (!array_key_exists(0, $parameters)) {
                return array('', '', '', do_lang('MISSING_PARAM', '1', 'css_cleanup'));
            }
            if (!array_key_exists(1, $parameters)) {
                return array('', '', '', do_lang('MISSING_PARAM', '2', 'css_cleanup'));
            }

            require_code('css_cleanup');

            for ($i = 1; $i < count($parameters); $i++) {
                $parameter = $parameters[$i];

                switch ($parameter) {
                    case 'DirSimplify':
                        $ob = new DirSimplify($parameters[0]);
                        break;

                    case 'EmToPx':
                        $ob = new EmToPx($parameters[0]);
                        break;

                    default:
                        return array('', '', '', do_lang('MISSING_RESOURCE'));
                }

                $css_files = $ob->work_out_changes();
                $ob->save_changes();
            }

            $result = do_lang('SUCCESS');

            return array('', $result, '', '');
        }
    }
}

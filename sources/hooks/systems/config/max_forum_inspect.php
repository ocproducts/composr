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
 * @package    cns_forum
 */

/**
 * Hook class.
 */
class Hook_config_max_forum_inspect
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'MAX_FORUM_INSPECT',
            'type' => 'integer',
            'category' => 'PERFORMANCE',
            'group' => 'SECTION_FORUMS',
            'explanation' => 'CONFIG_OPTION_max_forum_inspect',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'required' => true,

            'public' => false,

            'addon' => 'cns_forum',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!addon_installed('cns_forum')) {
            return null;
        }

        return (get_forum_type() != 'cns') ? null : '300';
    }
}

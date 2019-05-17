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
 * @package    users_online_block
 */

/**
 * Hook class.
 */
class Hook_config_usersonline_show_newest_member
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'SHOW_NEWEST_MEMBER',
            'type' => 'tick',
            'category' => 'BLOCKS',
            'group' => 'USERS_ONLINE_BLOCK',
            'explanation' => 'CONFIG_OPTION_usersonline_show_newest_member',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'required' => true,

            'public' => false,

            'addon' => 'users_online_block',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!addon_installed('users_online_block')) {
            return null;
        }

        return ((has_no_forum()) || (get_forum_type() != 'cns')) ? null : '1';
    }
}

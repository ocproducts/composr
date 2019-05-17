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
 * @package    news
 */

/**
 * Hook class.
 */
class Hook_config_points_ADD_NEWS
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'ADD_NEWS',
            'type' => 'integer',
            'category' => 'POINTS',
            'group' => 'COUNT_POINTS_GIVEN',
            'explanation' => 'CONFIG_OPTION_points_ADD_NEWS',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'required' => true,

            'public' => false,

            'addon' => 'news',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!addon_installed('news')) {
            return null;
        }

        return addon_installed('points') ? '225' : null;
    }
}

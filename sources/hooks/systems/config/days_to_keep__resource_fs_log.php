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
class Hook_config_days_to_keep__resource_fs_log
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'DAYS_TO_KEEP__RESOURCE_FS_LOG',
            'type' => 'integer',
            'category' => 'PRIVACY',
            'group' => 'LOGS',
            'explanation' => 'CONFIG_OPTION_days_to_keep__resource_fs_log',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'required' => false,

            'public' => false,

            'addon' => 'commandr',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!is_file(get_custom_file_base() . '/data_custom/resource_fs.log')) {
            return null;
        }
        return '365';
    }
}

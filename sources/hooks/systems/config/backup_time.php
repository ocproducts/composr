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
 * @package    backup
 */

/**
 * Hook class.
 */
class Hook_config_backup_time
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'BACKUP_REGULARITY',
            'type' => 'integer',
            'category' => 'ADMIN',
            'group' => 'CHECK_LIST',
            'explanation' => 'CONFIG_OPTION_backup_time',
            'shared_hosting_restricted' => '1',
            'list_options' => '',
            'required' => false,

            'public' => false,

            'addon' => 'backup',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!addon_installed('backup')) {
            return null;
        }

        return '168';
    }
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    sugarcrm
 */

/**
 * Hook class.
 */
class Hook_config_sugarcrm_member_sync_types
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'SUGARCRM_MEMBER_SYNC_TYPES',
            'type' => 'list',
            'category' => 'COMPOSR_APIS',
            'group' => 'SUGARCRM_MEMBER_SYNC',
            'explanation' => 'CONFIG_OPTION_sugarcrm_member_sync_types',
            'shared_hosting_restricted' => '0',
            'list_options' => 'contacts|leads|leads_guarded|both|both_guarded',
            'order_in_category_group' => 2,
            'required' => true,
            'public' => false,

            'addon' => 'sugarcrm',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!addon_installed('sugarcrm')) {
            return null;
        }

        return 'both';
    }
}

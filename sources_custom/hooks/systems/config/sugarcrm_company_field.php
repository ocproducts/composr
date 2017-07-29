<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    sugarcrm
 */

/**
 * Hook class.
 */
class Hook_config_sugarcrm_company_field
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'SUGARCRM_COMPANY_FIELD',
            'type' => 'line',
            'category' => 'COMPOSR_APIS',
            'group' => 'SUGARCRM',
            'explanation' => 'CONFIG_OPTION_sugarcrm_company_field',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'order_in_category_group' => 5,
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
        return 'Company';
    }
}

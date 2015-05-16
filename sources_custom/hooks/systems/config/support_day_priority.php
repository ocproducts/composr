<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_homesite_support_credits
 */

/**
 * Hook class.
 */
class Hook_config_support_day_priority
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'SUPPORT_PRIORITY_DAY_MINUTES',
            'type' => 'float',
            'category' => 'FEATURE',
            'group' => 'SECTION_CUSTOMERS',
            'explanation' => 'CONFIG_OPTION_support_day_priority',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'order_in_category_group' => 7,

            'addon' => 'composr_homesite_support_credits',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        return '7';
    }
}

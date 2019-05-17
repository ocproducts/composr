<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    classified_ads
 */

/**
 * Hook class.
 */
class Hook_config_classifieds_tax_code
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'CLASSIFIEDS_TAX_CODE',
            'type' => 'tax_code',
            'category' => 'FEATURE',
            'group' => 'CLASSIFIEDS',
            'explanation' => 'CONFIG_OPTION_classifieds_tax_code',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'required' => true,
            'public' => false,

            'addon' => 'classified_ads',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!addon_installed('classified_ads')) {
            return null;
        }

        return '0%';
    }
}

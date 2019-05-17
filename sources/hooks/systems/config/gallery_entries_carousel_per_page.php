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
 * @package    galleries
 */

/**
 * Hook class.
 */
class Hook_config_gallery_entries_carousel_per_page
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'GALLERY_ENTRIES_CAROUSEL_PER_PAGE',
            'type' => 'integer',
            'category' => 'GALLERY',
            'group' => 'BROWSING_GALLERIES',
            'explanation' => 'CONFIG_OPTION_gallery_entries_carousel_per_page',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'required' => true,

            'public' => false,

            'addon' => 'galleries',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!addon_installed('galleries')) {
            return null;
        }

        return '50';
    }
}

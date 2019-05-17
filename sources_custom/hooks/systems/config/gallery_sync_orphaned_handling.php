<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    gallery_syndication
 */

/**
 * Hook class.
 */
class Hook_config_gallery_sync_orphaned_handling
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'GALLERY_SYNC_ORPHANED_HANDLING',
            'type' => 'list',
            'category' => 'GALLERY',
            'group' => 'GALLERY_SYNDICATION',
            'explanation' => 'CONFIG_OPTION_gallery_sync_orphaned_handling',
            'shared_hosting_restricted' => '0',
            'list_options' => '1|2|3',
            'order_in_category_group' => 2,
            'required' => true,
            'public' => false,

            'addon' => 'gallery_syndication',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!addon_installed('gallery_syndication')) {
            return null;
        }

        return '2';
    }
}

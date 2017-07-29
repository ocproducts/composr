<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    jestr
 */

/**
 * Hook class.
 */
class Hook_config_jestr_name_changes
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'JESTER_NAME_CHANGES',
            'type' => 'text',
            'category' => 'FEATURE',
            'group' => 'JESTER_TITLE',
            'explanation' => 'CONFIG_OPTION_jestr_name_changes',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'required' => false,
            'public' => false,

            'addon' => 'jestr',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        return "Angelic\nBaubles\nChristmas\nDasher\nEvergreen\nFestive\nGifted\nHoliday\nIcicles\nJolly\nKingly\nEnlightened\nMerry\nNoel\nOrnamental\nParty\nKingly\nRudolph\nSeasonal\nTinsel\nYuletide\nVisionary\nWiseman\nXmas\nYuletide\nXmas";
    }
}

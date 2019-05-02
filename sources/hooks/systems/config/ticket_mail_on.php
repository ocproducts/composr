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
 * @package    tickets
 */

/**
 * Hook class.
 */
class Hook_config_ticket_mail_on
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'TICKET_MAIL_ON',
            'type' => 'tick',
            'category' => 'MESSAGES',
            'group' => 'SUPPORT_TICKETS_MAIL',
            'explanation' => 'CONFIG_OPTION_ticket_mail_on',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'order_in_category_group' => 1,

            'required' => true,
            'public' => false,
            'addon' => 'tickets',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!function_exists('imap_open')) {
            return null;
        }

        if (!addon_installed('tickets')) {
            return null;
        }

        if (GOOGLE_APPENGINE) {
            return null;
        }

        return '0';
    }
}

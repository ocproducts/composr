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
 * @package    cns_forum
 */

/**
 * Hook class.
 */
class Hook_config_enable_mark_topic_unread
{
    /**
     * Gets the details relating to the config option.
     *
     * @return ?array The details (null: disabled)
     */
    public function get_details()
    {
        return array(
            'human_name' => 'ENABLE_MARK_TOPIC_UNREAD',
            'type' => 'tick',
            'category' => 'FORUMS',
            'group' => 'FORUM_TOPICS',
            'explanation' => 'CONFIG_OPTION_enable_mark_topic_unread',
            'shared_hosting_restricted' => '0',
            'list_options' => '',
            'required' => true,

            'public' => false,

            'addon' => 'cns_forum',
        );
    }

    /**
     * Gets the default value for the config option.
     *
     * @return ?string The default value (null: option is disabled)
     */
    public function get_default()
    {
        if (!addon_installed('cns_forum')) {
            return null;
        }

        return '1';
    }
}

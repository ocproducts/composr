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
 * @package    core_rich_media
 */

/**
 * Hook class.
 */
class Hook_comcode_page_hints_no_smart_conversion
{
    /**
     * Get details describing the page hint.
     *
     * @return ?array Map of details (null: UI disabled for this hint)
     */
    public function get_details()
    {
        if (get_option('eager_wysiwyg') == '0') {
            return null; // Always going to avoid smart conversion
        }

        if (!has_privilege(get_member(), 'allow_html')) {
            return null; // User has no real choice
        }

        require_lang('comcode');
        return array(
            'label' => do_lang_tempcode('PAGE_HINT_SMART_CONVERSION_LABEL'),
            'description' => do_lang_tempcode('PAGE_HINT_SMART_CONVERSION_DESCRIPTION'),
            'inverted' => true,
        );
    }
}

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
 * @package    commandr
 */

/**
 * Hook class.
 */
class Hook_snippet_commandr
{
    /**
     * Run function for snippet hooks. Generates XHTML to insert into a page using AJAX.
     *
     * @return Tempcode The snippet
     */
    public function run()
    {
        if (!addon_installed('commandr')) {
            warn_exit(do_lang_tempcode('MISSING_ADDON', escape_html('commandr')));
        }

        if (!addon_installed('import')) {
            warn_exit(do_lang_tempcode('MISSING_ADDON', escape_html('import')));
        }

        if ($GLOBALS['CURRENT_SHARE_USER'] !== null) {
            warn_exit(do_lang_tempcode('SHARED_INSTALL_PROHIBIT'));
        }

        if (has_actual_page_access(get_member(), 'admin_commandr')) {
            require_code('commandr');
            require_lang('commandr');

            $title = get_screen_title('COMMANDR');

            return do_template('COMMANDR_MAIN', array(
                '_GUID' => '2f29170f4f8320a26fad66e0d0f52b7a',
                'COMMANDS' => '',
                'SUBMIT_URL' => build_url(array('page' => 'admin_commandr'), 'adminzone'),
                'PROMPT' => do_lang_tempcode('COMMAND_PROMPT', escape_html($GLOBALS['FORUM_DRIVER']->get_username(get_member()))),
            ));
        }

        return new Tempcode();
    }
}

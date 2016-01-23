<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    facebook_support
 */

/**
 * Hook class.
 */
class Hook_startup_facebook
{
    public function run($MICRO_BOOTUP, $MICRO_AJAX_BOOTUP)
    {
        if (running_script('index')) {
            require_javascript('facebook');
            require_code('site');

            $tpl = do_template('FACEBOOK_FOOTER', null, null, true, null, '.tpl', 'templates', 'default');
            attach_to_screen_footer($tpl);
        }
    }
}

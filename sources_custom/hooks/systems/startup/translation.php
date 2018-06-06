<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    translation
 */

/**
 * Hook class.
 */
class Hook_startup_translation
{
    public function run()
    {
        if (!addon_installed('translation')) {
            return;
        }

        define('TRANS_TEXT_CONTEXT_plain', 0);
        define('TRANS_TEXT_CONTEXT_html_block', 1);
        define('TRANS_TEXT_CONTEXT_html_inline', 2);
    }
}

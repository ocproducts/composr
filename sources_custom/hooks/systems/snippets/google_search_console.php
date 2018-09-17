<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    google_analytics
 */

/**
 * Hook class.
 */
class Hook_snippet_google_search_console
{
    /**
     * Run function for snippet hooks. Generates XHTML to insert into a page using AJAX.
     *
     * @return Tempcode The snippet
     */
    public function run()
    {
        if (!addon_installed('google_analytics')) {
            return new Tempcode();
        }

        require_code('google_analytics');

        $days = get_param_integer('days');

        return _render_google_search_console_keywords(null, $days, true);
    }
}

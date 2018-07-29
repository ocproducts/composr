<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    health_check
 */

/**
 * Hook class.
 */
class Hook_actionlog_health_check extends Hook_actionlog
{
    /**
     * Get details of action log entry types handled by this hook.
     *
     * @return array Map of handler data in standard format
     */
    public function get_handlers()
    {
        if (!addon_installed('health_check')) {
            return array();
        }

        require_lang('health_check');

        return array(
            'HEALTH_CHECK' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => null,
                'written_context_index' => null,
                'followup_page_links' => array(
                    'HEALTH_CHECK' => '_SEARCH:admin_health_check',
                ),
            ),
        );
    }
}

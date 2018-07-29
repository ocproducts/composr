<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    giftr
 */

/**
 * Hook class.
 */
class Hook_actionlog_giftr extends Hook_actionlog
{
    /**
     * Get details of action log entry types handled by this hook.
     *
     * @return array Map of handler data in standard format
     */
    public function get_handlers()
    {
        if (!addon_installed('giftr')) {
            return array();
        }

        require_lang('giftr');

        return array(
            'ADD_GIFT' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'EDIT_THIS_GIFT' => '_SEARCH:admin_giftr:_edit:{ID}',
                    'ADD_GIFT' => '_SEARCH:admin_giftr:add',
                ),
            ),
            'EDIT_GIFT' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'EDIT_THIS_GIFT' => '_SEARCH:admin_giftr:_edit:{ID}',
                    'ADD_GIFT' => '_SEARCH:admin_giftr:add',
                ),
            ),
            'DELETE_GIFT' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'ADD_GIFT' => '_SEARCH:admin_giftr:add',
                ),
            ),
        );
    }
}

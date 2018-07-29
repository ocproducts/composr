<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    workflows
 */

/**
 * Hook class.
 */
class Hook_actionlog_workflows extends Hook_actionlog
{
    /**
     * Get details of action log entry types handled by this hook.
     *
     * @return array Map of handler data in standard format
     */
    public function get_handlers()
    {
        if (!addon_installed('workflows')) {
            return array();
        }

        require_lang('workflows');

        return array(
            'ADD_WORKFLOW' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'EDIT_WORKFLOW' => '_SEARCH:admin_workflows:_edit:{ID}',
                    'ADD_WORKFLOW' => '_SEARCH:admin_workflows:add',
                ),
            ),
            'EDIT_WORKFLOW' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'EDIT_WORKFLOW' => '_SEARCH:admin_workflows:_edit:{ID}',
                    'ADD_WORKFLOW' => '_SEARCH:admin_workflows:add',
                ),
            ),
            'DELETE_WORKFLOW' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'ADD_WORKFLOW' => '_SEARCH:admin_workflows:add',
                ),
            ),
        );
    }
}

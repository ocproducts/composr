<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_tutorials
 */

/**
 * Hook class.
 */
class Hook_actionlog_composr_tutorials extends Hook_actionlog
{
    /**
     * Get details of action log entry types handled by this hook.
     *
     * @return array Map of handler data in standard format
     */
    protected function get_handlers()
    {
        if (!addon_installed('composr_tutorials')) {
            return array();
        }

        require_lang('tutorials');

        return array(
            'ADD_TUTORIAL' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '{URL}',
                    'EDIT_THIS_TUTORIAL' => '_SEARCH:cms_tutorials:_edit:{ID}',
                    'ADD_TUTORIAL' => '_SEARCH:cms_tutorials:add',
                ),
            ),
            'EDIT_TUTORIAL' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '{URL}',
                    'EDIT_THIS_TUTORIAL' => '_SEARCH:cms_tutorials:_edit:{ID}',
                    'ADD_TUTORIAL' => '_SEARCH:cms_tutorials:add',
                ),
            ),
            'DELETE_TUTORIAL' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'ADD_TUTORIAL' => '_SEARCH:cms_tutorials:add',
                ),
            ),
        );
    }

    /**
     * Get details of action log entry types handled by this hook.
     *
     * @param  array $actionlog_row Action log row
     * @param  ?string $identifier The identifier associated with this action log entry (null: unknown / none)
     * @param  ?string $written_context The written context associated with this action log entry (null: unknown / none)
     * @param  array $bindings Default bindings
     */
    protected function get_extended_actionlog_bindings($actionlog_row, $identifier, $written_context, &$bindings)
    {
        switch ($actionlog_row['the_type']) {
            case 'ADD_TUTORIAL':
            case 'EDIT_TUTORIAL':
                $url = $GLOBALS['SITE_DB']->query_select_value_if_there('tutorials_external', 't_url', array('id' => intval($identifier)));
                if ($url !== null) {
                    $bindings += array(
                        'URL' => $url,
                    );
                }
                break;
        }
    }
}

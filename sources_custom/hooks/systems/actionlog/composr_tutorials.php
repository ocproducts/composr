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
     * Get details of action log entry types handled by this hook. For internal use, although may be used by the base class.
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
                    'VIEW' => 'TODO',
                    'EDIT_THIS_TUTORIAL' => '_SEARCH:cms_tutorials:_edit:_ID_',
                    'ADD_TUTORIAL' => '_SEARCH:cms_tutorials:add',
                ),
            ),
            'EDIT_TUTORIAL' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => 'TODO',
                    'EDIT_THIS_TUTORIAL' => '_SEARCH:cms_tutorials:_edit:_ID_',
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
}

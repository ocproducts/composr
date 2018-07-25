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
 * @package    cns_warnings
 */

/**
 * Hook class.
 */
class Hook_actionlog_cns_warnings extends Hook_actionlog
{
    /**
     * Get details of action log entry types handled by this hook. For internal use, although may be used by the base class.
     *
     * @return array Map of handler data in standard format
     */
    protected function get_handlers()
    {
        if (get_forum_type() != 'cns') {
            return array();
        }

        if (!addon_installed('cns_warnings')) {
            return array();
        }

        require_lang('cns_warnings');

        return array(
            'MARK_AS_SPAMMER' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'member',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW_PROFILE' => '_SEARCH:members:view:_ID_',
                ),
            ),
            'START_PROBATION' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'member',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW_PROFILE' => '_SEARCH:members:view:_ID_',
                ),
            ),
            'STOP_PROBATION' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'member',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW_PROFILE' => '_SEARCH:members:view:_ID_',
                ),
            ),
            'EXTEND_PROBATION' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'member',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW_PROFILE' => '_SEARCH:members:view:_ID_',
                ),
            ),
            'REDUCE_PROBATION' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'member',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW_PROFILE' => '_SEARCH:members:view:_ID_',
                ),
            ),
        );
    }
}

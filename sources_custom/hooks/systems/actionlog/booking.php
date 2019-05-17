<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    booking
 */

/**
 * Hook class.
 */
class Hook_actionlog_booking extends Hook_actionlog
{
    /**
     * Get details of action log entry types handled by this hook.
     *
     * @return array Map of handler data in standard format
     */
    public function get_handlers()
    {
        if (!addon_installed('booking')) {
            return array();
        }

        require_lang('booking');

        return array(
            'ADD_BOOKABLE' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'EDIT_THIS_BOOKABLE' => '_SEARCH:cms_booking:_edit:{ID}',
                    'ADD_BOOKABLE' => '_SEARCH:cms_booking:add',
                    'ADD_BOOKABLE_SUPPLEMENT' => '_SEARCH:cms_booking:add_category',
                    'ADD_BOOKABLE_BLACKED' => '_SEARCH:cms_booking:add_other',
                ),
            ),
            'EDIT_BOOKABLE' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'EDIT_THIS_BOOKABLE' => '_SEARCH:cms_booking:_edit:{ID}',
                    'ADD_BOOKABLE' => '_SEARCH:cms_booking:add',
                    'ADD_BOOKABLE_SUPPLEMENT' => '_SEARCH:cms_booking:add_category',
                    'ADD_BOOKABLE_BLACKED' => '_SEARCH:cms_booking:add_other',
                ),
            ),
            'DELETE_BOOKABLE' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'ADD_BOOKABLE' => '_SEARCH:cms_booking:add',
                ),
            ),
            'ADD_BOOKABLE_BLACKED' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'EDIT_THIS_BOOKABLE_BLACKED' => '_SEARCH:cms_booking:_edit_other:{ID}',
                    'ADD_BOOKABLE_BLACKED' => '_SEARCH:cms_booking:add_other',
                ),
            ),
            'EDIT_BOOKABLE_BLACKED' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'EDIT_THIS_BOOKABLE_BLACKED' => '_SEARCH:cms_booking:_edit_other:{ID}',
                    'ADD_BOOKABLE_BLACKED' => '_SEARCH:cms_booking:add_other',
                ),
            ),
            'DELETE_BOOKABLE_BLACKED' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'ADD_BOOKABLE_BLACKED' => '_SEARCH:cms_booking:add_other',
                ),
            ),
            'ADD_BOOKABLE_SUPPLEMENT' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'EDIT_THIS_BOOKABLE_SUPPLEMENT' => '_SEARCH:cms_booking:_edit_category:{ID}',
                    'ADD_BOOKABLE_SUPPLEMENT' => '_SEARCH:cms_booking:add_category',
                ),
            ),
            'EDIT_BOOKABLE_SUPPLEMENT' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'EDIT_THIS_BOOKABLE_SUPPLEMENT' => '_SEARCH:cms_booking:_edit_category:{ID}',
                    'ADD_BOOKABLE_SUPPLEMENT' => '_SEARCH:cms_booking:add_category',
                ),
            ),
            'DELETE_BOOKABLE_SUPPLEMENT' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => null,
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'ADD_BOOKABLE_SUPPLEMENT' => '_SEARCH:cms_booking:add_category',
                ),
            ),
        );
    }
}

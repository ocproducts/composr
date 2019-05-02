<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    galleries
 */

/**
 * Hook class.
 */
class Hook_actionlog_galleries extends Hook_actionlog
{
    /**
     * Get details of action log entry types handled by this hook.
     *
     * @return array Map of handler data in standard format
     */
    public function get_handlers()
    {
        if (!addon_installed('galleries')) {
            return array();
        }

        require_lang('galleries');

        return array(
            'ADD_GALLERY' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'gallery',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '_SEARCH:galleries:browse:{ID}',
                    'EDIT_THIS_GALLERY' => '_SEARCH:cms_galleries:_edit_category:{ID}',
                    'ADD_GALLERY' => '_SEARCH:cms_galleries:add_category',
                    'ADD_IMAGE' => '_SEARCH:cms_galleries:add:cat={ID}',
                    'ADD_VIDEO' => '_SEARCH:cms_galleries:add_other:cat={ID}',
                ),
            ),
            'EDIT_GALLERY' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'gallery',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '_SEARCH:galleries:browse:{ID}',
                    'EDIT_THIS_GALLERY' => '_SEARCH:cms_galleries:_edit_category:{ID}',
                    'ADD_GALLERY' => '_SEARCH:cms_galleries:add_category',
                    'ADD_IMAGE' => '_SEARCH:cms_galleries:add:cat={ID}',
                    'ADD_VIDEO' => '_SEARCH:cms_galleries:add_other:cat={ID}',
                ),
            ),
            'DELETE_GALLERY' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'gallery',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'ADD_GALLERY' => '_SEARCH:cms_galleries:add_category',
                ),
            ),
            'ADD_IMAGE' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'image',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '_SEARCH:galleries:image:{ID}',
                    'EDIT_THIS_IMAGE' => '_SEARCH:cms_galleries:_edit:{ID}',
                    'ADD_IMAGE' => '_SEARCH:cms_galleries:add:cat={CAT,OPTIONAL}',
                ),
            ),
            'EDIT_IMAGE' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'image',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '_SEARCH:galleries:image:{ID}',
                    'EDIT_THIS_IMAGE' => '_SEARCH:cms_galleries:_edit:{ID}',
                    'ADD_IMAGE' => '_SEARCH:cms_galleries:add:cat={CAT,OPTIONAL}',
                ),
            ),
            'DELETE_IMAGE' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'image',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'ADD_IMAGE' => '_SEARCH:cms_galleries:add',
                ),
            ),
            'ADD_VIDEO' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'video',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '_SEARCH:galleries:video:{ID}',
                    'EDIT_THIS_VIDEO' => '_SEARCH:cms_galleries:_edit_other:{ID}',
                    'ADD_VIDEO' => '_SEARCH:cms_galleries:add_other:cat={CAT,OPTIONAL}',
                ),
            ),
            'EDIT_VIDEO' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'video',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '_SEARCH:galleries:video:{ID}',
                    'EDIT_THIS_VIDEO' => '_SEARCH:cms_galleries:_edit_other:{ID}',
                    'ADD_VIDEO' => '_SEARCH:cms_galleries:add_other:cat={CAT,OPTIONAL}',
                ),
            ),
            'DELETE_VIDEO' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'video',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'ADD_VIDEO' => '_SEARCH:cms_galleries:add_other',
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
            case 'ADD_IMAGE':
            case 'EDIT_IMAGE':
                $cat = $GLOBALS['SITE_DB']->query_select_value_if_there('images', 'cat', array('id' => intval($identifier)));
                if ($cat !== null) {
                    $bindings += array(
                        'CAT' => $cat,
                    );
                }
                break;

            case 'ADD_VIDEO':
            case 'EDIT_VIDEO':
                $cat = $GLOBALS['SITE_DB']->query_select_value_if_there('videos', 'cat', array('id' => intval($identifier)));
                if ($cat !== null) {
                    $bindings += array(
                        'CAT' => $cat,
                    );
                }
                break;
        }
    }
}

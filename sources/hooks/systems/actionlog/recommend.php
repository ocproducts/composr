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
 * @package    recommend
 */

/**
 * Hook class.
 */
class Hook_actionlog_recommend extends Hook_actionlog
{
    /**
     * Get details of action log entry types handled by this hook.
     *
     * @return array Map of handler data in standard format
     */
    public function get_handlers()
    {
        if (!addon_installed('recommend')) {
            return array();
        }

        require_lang('recommend');

        return array(
            'RECOMMEND' => array(
                'flags' => ACTIONLOG_FLAGS_NONE | ACTIONLOG_FLAG__USER_ACTION,
                'cma_hook' => null,
                'identifier_index' => null,
                'written_context_index' => null,
                'followup_page_links' => array(
                ),
            ),
        );
    }
}
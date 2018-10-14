<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    quizzes
 */

/**
 * Hook class.
 */
class Hook_actionlog_quizzes extends Hook_actionlog
{
    /**
     * Get details of action log entry types handled by this hook.
     *
     * @return array Map of handler data in standard format
     */
    public function get_handlers()
    {
        if (!addon_installed('quizzes')) {
            return array();
        }

        require_lang('quiz');

        return array(
            'ADD_QUIZ' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'quiz',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '_SEARCH:quiz:do:{ID}',
                    'ADD_QUIZ' => '_SEARCH:cms_quiz:add',
                    'EDIT_THIS_QUIZ' => '_SEARCH:cms_quiz:_edit:{ID}',
                ),
            ),
            'EDIT_QUIZ' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'quiz',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '_SEARCH:quiz:do:{ID}',
                    'ADD_QUIZ' => '_SEARCH:cms_quiz:add',
                    'EDIT_THIS_QUIZ' => '_SEARCH:cms_quiz:_edit:{ID}',
                ),
            ),
            'DELETE_QUIZ' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'quiz',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'ADD_QUIZ' => '_SEARCH:cms_quiz:add',
                ),
            ),
            'DELETE_QUIZ_RESULTS' => array(
                'flags' => ACTIONLOG_FLAGS_NONE,
                'cma_hook' => 'quiz',
                'identifier_index' => 0,
                'written_context_index' => 1,
                'followup_page_links' => array(
                    'VIEW' => '_SEARCH:quiz:do:{ID}',
                    'ADD_QUIZ' => '_SEARCH:cms_quiz:add',
                    'EDIT_THIS_QUIZ' => '_SEARCH:cms_quiz:_edit:{ID}',
                ),
            ),
        );
    }
}
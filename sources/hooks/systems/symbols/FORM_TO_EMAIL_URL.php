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
 * @package    core_feedback_features
 */

/**
 * Hook class.
 */
class Hook_symbol_FORM_TO_EMAIL_URL
{
    /**
     * Run function for symbol hooks. Searches for tasks to perform.
     *
     * @param  array $param Symbol parameters
     * @return string Result
     */
    public function run($param)
    {
        $url = find_script('form_to_email');
        if (isset($param[0])) {
            $redirect_url = static_evaluate_tempcode(build_url(array('page' => $param[0]), '_SEARCH'));
        } else {
            $redirect_url = get_self_url(true);
        }
        $url .= '?redirect=' . cms_urlencode(static_evaluate_tempcode(protect_url_parameter($redirect_url)));
        $url .= keep_symbol(array());
        return $url;
    }
}

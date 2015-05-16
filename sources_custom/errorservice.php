<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_homesite
 */

function init__errorservice()
{
    define('CMS_SOLUTION_FORUM', 283);
}

/**
 * Handler for compo.sr error message web service.
 */
function get_problem_match()
{
    $version = get_param_string('version');
    $error_message = get_param_string('error_message', false, true);

    $ret = get_problem_match_worker($error_message);
    header('Content-type: text/plain; charset=' . get_charset());
    if (!is_null($ret)) {
        $output = $ret[2]->evaluate();

        // Possible rebranding
        $brand = get_param_string('product');
        if (($brand != 'Composr') && ($brand != '')) {
            $brand_base_url = get_param_string('product_site', '');
            if ($brand_base_url != '') {
                $output = str_replace('Composr', $brand, $output);
                $output = str_replace('ocProducts', 'The Developers', $output);
                $output = str_replace(get_brand_base_url(), $brand_base_url, $output);
            }
        }
        echo $output;
    }
}

/**
 * Find a match for a problem in the database.
 *
 * @param  string $error_message The error that occurred
 * @return ?array A tuple: the post ID, the full Comcode, the Tempcode, the language string ID  (probably caller will only use post ID and Tempcode - but all available)
 */
function get_problem_match_worker($error_message)
{
    // Find matches. Stored in forum topics.
    $_data = $GLOBALS['FORUM_DB']->query_select('f_posts', array('*'), array('p_cache_forum_id' => CMS_SOLUTION_FORUM));
    $matches = array();
    foreach ($_data as $d) {
        $regexp = str_replace('\.\.\.', '.*', str_replace('xxx', '.*', preg_quote($d['p_title'], '#')));
        if (preg_match('#' . $regexp . '#', $error_message) != 0) {
            $matches[$d['p_title']] = array(
                $d['id'],
                get_translated_text($d['p_post'], $GLOBALS['FORUM_DB']),
                get_translated_tempcode('f_posts', $d, 'p_post', $GLOBALS['FORUM_DB'])
            );
        }
    }

    // Sort by how good the match is (string length)
    uksort($matches, 'strlen_sort');

    // Return best-match result, after a cleanup
    return array_pop($matches);
}

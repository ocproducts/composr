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
 * @package    wiki
 */

/**
 * Get the number of Wiki+ pages currently in the database.
 *
 * @return integer The number of pages in the Wiki+ database
 */
function get_num_wiki_pages()
{
    $value = get_value_newer_than('num_wiki_pages', time() - 60 * 60 * 24);

    if ($value === null) {
        $_value = $GLOBALS['SITE_DB']->query_select_value('wiki_pages', 'COUNT(*)');
        if (!($_value > 0)) {
            $_value = 0;
        }
        $value = strval($_value);
        set_value('num_wiki_pages', $value);
    }

    return intval($value);
}

/**
 * Get the number of Wiki+ posts currently in the database.
 *
 * @return integer The number of posts in the Wiki+ database
 */
function get_num_wiki_posts()
{
    $value = get_value_newer_than('num_wiki_posts', time() - 60 * 60 * 24);

    if ($value === null) {
        $_value = $GLOBALS['SITE_DB']->query_select_value('wiki_posts', 'COUNT(*)');
        if (!($_value > 0)) {
            $_value = 0;
        }
        $value = strval($_value);
        set_value('num_wiki_posts', $value);
    }

    return intval($value);
}

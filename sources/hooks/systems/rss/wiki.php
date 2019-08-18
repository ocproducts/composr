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
 * Hook class.
 */
class Hook_rss_wiki
{
    /**
     * Run function for RSS hooks.
     *
     * @param  string $_filters A list of categories we accept from
     * @param  TIME $cutoff Cutoff time, before which we do not show results from
     * @param  string $prefix Prefix that represents the template set we use
     * @set RSS_ ATOM_
     * @param  string $date_string The standard format of date to use for the syndication type represented in the prefix
     * @param  integer $max The maximum number of entries to return, ordering by date
     * @return ?array A pair: The main syndication section, and a title (null: error)
     */
    public function run($_filters, $cutoff, $prefix, $date_string, $max)
    {
        if (!addon_installed('wiki')) {
            return null;
        }

        if (!has_actual_page_access(get_member(), 'wiki')) {
            return null;
        }

        $filters = selectcode_to_sqlfragment($_filters, 'id', 'wiki_children', 'parent_id', 'parent_id', 'child_id');

        $content = new Tempcode();
        $query = 'SELECT * FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'wiki_pages p WHERE ' . $filters . ' AND ((add_date>' . strval($cutoff) . ' OR edit_date>' . strval($cutoff);
        $query .= ' OR EXISTS(SELECT * FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'wiki_posts o WHERE o.page_id=p.id AND date_and_time>' . strval($cutoff) . '))';
        $query .= ')';
        $query .= ' ORDER BY add_date DESC';
        $rows = $GLOBALS['SITE_DB']->query($query, $max);
        foreach ($rows as $row) {
            $id = strval($row['id']);

            if (!has_category_access(get_member(), 'wiki_page', $id)) {
                continue;
            }

            $author = '';

            $news_date = date($date_string, $row['add_date']);
            $edit_date = '';

            $news_title = xmlentities(escape_html(get_translated_text($row['title'])));
            $_summary = get_translated_tempcode('wiki_pages', $row, 'the_description');
            $summary = xmlentities($_summary->evaluate());
            $news = '';

            $category = '';
            $category_raw = '';

            $view_url = build_url(array('page' => 'wiki', 'type' => 'browse', 'id' => ($row['id'] == db_get_first_id()) ? null : $row['id']), get_module_zone('wiki'), array(), false, false, true);

            $if_comments = new Tempcode();

            $content->attach(do_template($prefix . 'ENTRY', array('VIEW_URL' => $view_url, 'SUMMARY' => $summary, 'EDIT_DATE' => $edit_date, 'IF_COMMENTS' => $if_comments, 'TITLE' => $news_title, 'CATEGORY_RAW' => $category_raw, 'CATEGORY' => $category, 'AUTHOR' => $author, 'ID' => $id, 'NEWS' => $news, 'DATE' => $news_date), null, false, null, '.xml', 'xml'));
        }

        require_lang('wiki');
        return array($content, do_lang('WIKI_PAGES'));
    }
}

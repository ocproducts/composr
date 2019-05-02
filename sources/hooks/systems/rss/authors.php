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
 * @package    authors
 */

/**
 * Hook class.
 */
class Hook_rss_authors
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
        if (!addon_installed('authors')) {
            return null;
        }

        if (!has_actual_page_access(get_member(), 'authors')) {
            return null;
        }

        $content = new Tempcode();
        $rows = $GLOBALS['SITE_DB']->query_select('authors', array('*'), array(), '', 1000);
        if (count($rows) == 1000) {
            return null; // Too much
        }
        foreach ($rows as $i => $row) {
            if ($i == $max) {
                break;
            }

            $id = $row['author'];
            $author = '';

            $news_date = '';
            $edit_date = '';

            $news_title = xmlentities(escape_html($row['author']));
            $_summary = get_translated_tempcode('authors', $row, 'description');
            $summary = xmlentities($_summary->evaluate());
            $news = '';

            $category = '';
            $category_raw = '';

            $view_url = build_url(array('page' => 'authors', 'type' => 'browse', 'id' => $row['author']), get_module_zone('authors'), array(), false, false, true);

            $if_comments = new Tempcode();

            $content->attach(do_template($prefix . 'ENTRY', array('VIEW_URL' => $view_url, 'SUMMARY' => $summary, 'EDIT_DATE' => $edit_date, 'IF_COMMENTS' => $if_comments, 'TITLE' => $news_title, 'CATEGORY_RAW' => $category_raw, 'CATEGORY' => $category, 'AUTHOR' => $author, 'ID' => $id, 'NEWS' => $news, 'DATE' => $news_date), null, false, null, '.xml', 'xml'));
        }

        require_lang('authors');
        return array($content, do_lang('AUTHORS'));
    }
}

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
 * @package    calendar
 */

/**
 * Hook class.
 */
class Hook_rss_calendar
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
        if (!addon_installed('calendar')) {
            return null;
        }

        if (!has_actual_page_access(get_member(), 'calendar')) {
            return null;
        }

        $method = get_param_string('method', 'happened'); // happened|happening|stream_in

        if ($method == 'happening') {
            if ($cutoff < time()) {
                $cutoff += (time() - $cutoff) * 2;
            }
        }

        $filters = selectcode_to_sqlfragment($_filters, 'c.id', 'calendar_types', null, 'e_type', 'id');

        $content = new Tempcode();

        $_categories = $GLOBALS['SITE_DB']->query('SELECT c.id,c.t_title FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'calendar_types c WHERE ' . $filters, null, 0, false, true, array('t_title' => 'SHORT_TRANS__COMCODE'));
        foreach ($_categories as $i => $_category) {
            $_categories[$i]['_t_title'] = get_translated_text($_category['t_title']);
        }
        $categories = collapse_2d_complexity('id', '_t_title', $_categories);

        require_code('calendar');

        if ($method == 'happened') {
            $period_start = utctime_to_usertime($cutoff);
            $period_end = utctime_to_usertime(time());
            $rows = calendar_matches(get_member(), get_member(), !has_privilege(get_member(), 'assume_any_member'), $period_start, $period_end, null, false, get_param_integer('private', null));
        } elseif ($method == 'happening') {
            $period_start = utctime_to_usertime(time());
            $period_end = utctime_to_usertime($cutoff);
            $rows = calendar_matches(get_member(), get_member(), !has_privilege(get_member(), 'assume_any_member'), $period_start, $period_end, null, false, get_param_integer('private', null));
        } else { // stream_in
            $period_start = utctime_to_usertime(time() - 60 * 60 * 24 * 365 * 5);
            $period_end = utctime_to_usertime(time() + 60 * 60 * 24 * 365 * 5);
            $rows = calendar_matches(get_member(), get_member(), !has_privilege(get_member(), 'assume_any_member'), $period_start, $period_end, null, false, get_param_integer('private', null));
            foreach ($rows as $i => $_row) {
                if (!array_key_exists('id', $_row[1])) {
                    unset($rows[$i]); // RSS event
                }

                if ($_row[1]['e_add_date'] < $cutoff) {
                    unset($rows[$i]);
                }
            }
        }

        $rows = array_reverse($rows);
        foreach ($rows as $i => $_row) {
            if ($i == $max) {
                break;
            }

            $row = $_row[1];

            $id = strval($_row[0]);
            $author = '';

            // The "add" date'll be actually used for the event time
            $_news_date = $_row[2];
            $news_date = date($date_string, usertime_to_utctime($_news_date));

            // The edit date'll be the latest of add/edit
            $edit_date = ($row['e_edit_date'] === null) ? date($date_string, $row['e_add_date']) : date($date_string, $row['e_edit_date']);

            $just_event_row = db_map_restrict($row, array('id', 'e_content'));

            $news_title = xmlentities(escape_html(get_translated_text($row['e_title'])));
            $_summary = get_translated_tempcode('calendar_events', $just_event_row, 'e_content');
            $summary = xmlentities($_summary->evaluate());
            $news = '';

            $category = array_key_exists($row['e_type'], $categories) ? $categories[$row['e_type']] : '';
            $category_raw = strval($row['e_type']);

            $view_url = build_url(array('page' => 'calendar', 'type' => 'view', 'id' => $_row[0]), get_module_zone('calendar'), array(), false, false, true);

            if (!array_key_exists('allow_comments', $row)) {
                $row['allow_comments'] = 1;
            }
            if (($prefix == 'RSS_') && (get_option('is_on_comments') == '1') && ($row['allow_comments'] >= 1)) {
                $if_comments = do_template('RSS_ENTRY_COMMENTS', array('_GUID' => '202a32693ce54d9ce960b72e66714df0', 'COMMENT_URL' => $view_url, 'ID' => $id), null, false, null, '.xml', 'xml');
            } else {
                $if_comments = new Tempcode();
            }

            $content->attach(do_template($prefix . 'ENTRY', array('VIEW_URL' => $view_url, 'SUMMARY' => $summary, 'EDIT_DATE' => $edit_date, 'IF_COMMENTS' => $if_comments, 'TITLE' => $news_title, 'CATEGORY_RAW' => $category_raw, 'CATEGORY' => $category, 'AUTHOR' => $author, 'ID' => $id, 'NEWS' => $news, 'DATE' => $news_date), null, false, null, '.xml', 'xml'));
        }

        require_lang('calendar');
        return array($content, do_lang('CALENDAR'));
    }
}

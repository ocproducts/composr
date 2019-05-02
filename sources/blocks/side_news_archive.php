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
 * @package    news
 */

/**
 * Block class.
 */
class Block_side_news_archive
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled)
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = false;
        $info['parameters'] = array('select', 'zone', 'title');
        return $info;
    }

    /**
     * Find caching details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled)
     */
    public function caching_environment()
    {
        $info = array();
        $info['cache_on'] = 'array(array_key_exists(\'title\',$map)?$map[\'title\']:do_lang(\'ARCHIVES\'),array_key_exists(\'zone\',$map)?$map[\'zone\']:get_module_zone(\'news\'),array_key_exists(\'select\',$map)?$map[\'select\']:\'*\')';
        $info['special_cache_flags'] = CACHE_AGAINST_DEFAULT;
        $info['ttl'] = (get_value('disable_block_timeout') === '1') ? 60 * 60 * 24 * 365 * 5/*5 year timeout*/ : 15;
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters
     * @return Tempcode The result of execution
     */
    public function run($map)
    {
        $error_msg = new Tempcode();
        if (!addon_installed__messaged('news', $error_msg)) {
            return $error_msg;
        }

        if (!addon_installed('news_shared')) {
            return do_template('RED_ALERT', array('_GUID' => 'jgoer1lzlefihrpu4tank2j9e7uwmf17', 'TEXT' => do_lang_tempcode('MISSING_ADDON', escape_html('news_shared'))));
        }

        require_lang('news');

        $block_id = get_block_id($map);

        $zone = array_key_exists('zone', $map) ? $map['zone'] : get_module_zone('news');
        $select = array_key_exists('select', $map) ? $map['select'] : '*';

        if ($select == '*') {
            require_code('selectcode');
            $selects_1 = selectcode_to_sqlfragment($select, 'p.news_category', 'news_categories', null, 'p.news_category', 'id'); // Note that the parameters are fiddled here so that category-set and record-set are the same, yet SQL is returned to deal in an entirely different record-set (entries' record-set)
            $selects_2 = selectcode_to_sqlfragment($select, 'd.news_entry_category', 'news_categories', null, 'd.news_category', 'id'); // Note that the parameters are fiddled here so that category-set and record-set are the same, yet SQL is returned to deal in an entirely different record-set (entries' record-set)
            $q_filter = '(' . $selects_1 . ' OR ' . $selects_2 . ')';
        } else {
            $q_filter = '1=1';
        }

        $rows = $GLOBALS['SITE_DB']->query('SELECT p.id,p.date_and_time FROM ' . get_table_prefix() . 'news p LEFT JOIN ' . get_table_prefix() . 'news_category_entries d ON d.news_entry=p.id WHERE ' . $q_filter . (((!has_privilege(get_member(), 'see_unvalidated')) && (addon_installed('unvalidated'))) ? ' AND validated=1' : '') . ($GLOBALS['DB_STATIC_OBJECT']->can_arbitrary_groupby() ? ' GROUP BY p.id' : '') . ' ORDER BY date_and_time DESC');
        $rows = remove_duplicate_rows($rows, 'id');
        $rows = array_reverse($rows);

        if (count($rows) == 0) {
            return do_template('RED_ALERT', array('_GUID' => '2kkpdv5vq2zbhuu4j4n6gteucgi1mee1', 'TEXT' => do_lang_tempcode('NO_ENTRIES')));
        }
        $first = $rows[0]['date_and_time'];
        $last = $rows[count($rows) - 1]['date_and_time'];

        $current_month = intval(date('m', utctime_to_usertime($first)));
        $current_year = intval(date('Y', utctime_to_usertime($first)));

        $last_month = intval(date('m', utctime_to_usertime($last)));
        $last_year = intval(date('Y', utctime_to_usertime($last)));

        $years = array();
        $years[$current_year] = array('YEAR' => strval($current_year), 'TIMES' => array());

        require_lang('dates');

        $offset = 0;
        $period_start = $first;

        while (true) {
            $period_start = usertime_to_utctime(mktime(0, 0, 0, $current_month, 0, $current_year));
            $period_end = usertime_to_utctime(mktime(0, 0, 0, $current_month + 1, 0, $current_year)) - 1;

            while ($rows[$offset]['date_and_time'] < $period_start) {
                $offset++;
                if (!isset($rows[$offset]['date_and_time'])) {
                    break 2;
                }
            }

            if ($rows[$offset]['date_and_time'] <= $period_end) {
                while ((isset($rows[$offset]['date_and_time'])) && ($rows[$offset]['date_and_time'] <= $period_end)) {
                    $offset++;
                }
                $offset--;

                $month_string = '';
                switch (strval($current_month)) {
                    case '1':
                        $month_string = do_lang('JANUARY');
                        break;
                    case '2':
                        $month_string = do_lang('FEBRUARY');
                        break;
                    case '3':
                        $month_string = do_lang('MARCH');
                        break;
                    case '4':
                        $month_string = do_lang('APRIL');
                        break;
                    case '5':
                        $month_string = do_lang('MAY');
                        break;
                    case '6':
                        $month_string = do_lang('JUNE');
                        break;
                    case '7':
                        $month_string = do_lang('JULY');
                        break;
                    case '8':
                        $month_string = do_lang('AUGUST');
                        break;
                    case '9':
                        $month_string = do_lang('SEPTEMBER');
                        break;
                    case '10':
                        $month_string = do_lang('OCTOBER');
                        break;
                    case '11':
                        $month_string = do_lang('NOVEMBER');
                        break;
                    case '12':
                        $month_string = do_lang('DECEMBER');
                        break;
                }

                $url = build_url(array('page' => 'news', 'type' => 'browse', 'select' => $select, 'module_start' => count($rows) - $offset - 1, 'year' => $current_year, 'month' => $current_month), $zone);

                array_unshift($years[$current_year]['TIMES'], array('URL' => $url, 'MONTH' => strval($current_month), 'MONTH_STRING' => $month_string));
            }

            if ($current_month != 12) {
                $current_month++;
            } else {
                $current_month = 1;
                $current_year++;
                $years[$current_year] = array('YEAR' => strval($current_year), 'TIMES' => array());
            }
        }

        $years = array_reverse($years);

        $title = array_key_exists('title', $map) ? $map['title'] : do_lang('ARCHIVES');

        return do_template('BLOCK_SIDE_NEWS_ARCHIVE', array(
            '_GUID' => '10d6267d943ad77a4025a4e286c41ee7',
            'BLOCK_ID' => $block_id,
            'YEARS' => $years,
            'TITLE' => $title,
        ));
    }
}

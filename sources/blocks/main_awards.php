<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    awards
 */

/**
 * Block class.
 */
class Block_main_awards
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled).
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
        $info['parameters'] = array('param', 'zone', 'give_context', 'include_breadcrumbs', 'guid');
        return $info;
    }

    /**
     * Find caching details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled).
     */
    public function caching_environment()
    {
        $info = array();
        $info['cache_on'] = '(count($_POST)!=0 || get_param_integer(\'keep_non_rated\',0)==1)?null:array(array_key_exists(\'guid\',$map)?$map[\'guid\']:\'\',(array_key_exists(\'give_context\',$map)?$map[\'give_context\']:\'0\')==\'1\',(array_key_exists(\'include_breadcrumbs\',$map)?$map[\'include_breadcrumbs\']:\'0\')==\'1\',array_key_exists(\'param\',$map)?$map[\'param\']:strval(db_get_first_id()),array_key_exists(\'zone\',$map)?$map[\'zone\']:\'_SEARCH\')';
        $info['special_cache_flags'] = CACHE_AGAINST_DEFAULT | CACHE_AGAINST_PERMISSIVE_GROUPS;
        $info['ttl'] = (get_value('no_block_timeout') === '1') ? 60 * 60 * 24 * 365 * 5/*5 year timeout*/ : 60 * 24; // Intentionally, do randomisation acts as 'of the day'
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters.
     * @return Tempcode The result of execution.
     */
    public function run($map)
    {
        require_lang('awards');
        require_code('awards');

        $award = empty($map['param']) ? $GLOBALS['SITE_DB']->query_select_value('award_types', 'MIN(id)') : intval($map['param']);
        $zone = array_key_exists('zone', $map) ? $map['zone'] : '_SEARCH';

        $guid = array_key_exists('guid', $map) ? $map['guid'] : '';
        $give_context = (array_key_exists('give_context', $map) ? $map['give_context'] : '0') == '1';
        $include_breadcrumbs = (array_key_exists('include_breadcrumbs', $map) ? $map['include_breadcrumbs'] : '0') == '1';

        $_award_type_row = $GLOBALS['SITE_DB']->query_select('award_types', array('*'), array('id' => $award), '', 1);
        if (!array_key_exists(0, $_award_type_row)) {
            return do_lang_tempcode('MISSING_RESOURCE', 'award_type');
        }
        $award_type_row = $_award_type_row[0];
        $award_title = get_translated_text($award_type_row['a_title']);
        $award_description = get_translated_text($award_type_row['a_description']);

        if ((!file_exists(get_file_base() . '/sources/hooks/systems/content_meta_aware/' . filter_naughty_harsh($award_type_row['a_content_type']) . '.php')) && (!file_exists(get_file_base() . '/sources_custom/hooks/systems/content_meta_aware/' . filter_naughty_harsh($award_type_row['a_content_type']) . '.php'))) {
            return paragraph(do_lang_tempcode('NO_SUCH_CONTENT_TYPE', $award_type_row['a_content_type']), '', 'red_alert');
        }

        require_code('content');
        $object = get_content_object($award_type_row['a_content_type']);
        $info = $object->info();
        if (is_null($info)) {
            return do_lang_tempcode('IMPOSSIBLE_TYPE_USED');
        }

        $submit_url = $info['add_url'];
        if (!is_null($submit_url)) {
            $submit_url = page_link_to_url($submit_url);
        } else {
            $submit_url = '';
        }
        if (!has_actual_page_access(null, $info['cms_page'], null, null)) {
            $submit_url = '';
        }
        if (!has_category_access(get_member(), 'award', strval($award))) {
            $submit_url = '';
        }
        if ($submit_url != '') {
            extend_url($submit_url, 'award=' . strval($award));
        }

        require_code('content');

        $sup = '';
        do {
            $rows = $GLOBALS['SITE_DB']->query('SELECT * FROM ' . get_table_prefix() . 'award_archive WHERE a_type_id=' . strval($award) . ' ' . $sup . ' ORDER BY date_and_time DESC', 1, null, false, true);
            if (!array_key_exists(0, $rows)) {
                return do_template('BLOCK_NO_ENTRIES', array(
                    '_GUID' => ($guid != '') ? $guid : 'f32b50770fd6581c4a2c839a1ed25801',
                    'HIGH' => false,
                    'TITLE' => $award_title,
                    'MESSAGE' => do_lang_tempcode('NO_AWARD'),
                    'ADD_NAME' => content_language_string($award_type_row['a_content_type'], 'ADD'),
                    'SUBMIT_URL' => str_replace('=!', '__ignore=1', $submit_url),
                ));
            }
            $myrow = $rows[0];

            $submit_url = str_replace('!', $myrow['content_id'], $submit_url);

            $award_content_row = content_get_row($myrow['content_id'], $info);
            $sup = ' AND date_and_time<' . strval($myrow['date_and_time']);
        } while (is_null($award_content_row));

        $archive_url = build_url(array('page' => 'awards', 'type' => 'award', 'id' => $award), get_module_zone('awards'));

        $rendered_content = $object->run($award_content_row, $zone, $give_context, $include_breadcrumbs, null, false, $guid);

        if (($award_type_row['a_hide_awardee'] == 1) || (is_guest($myrow['member_id']))) {
            $awardee = '';
            $awardee_username = '';
            $awardee_profile_url = '';
        } else {
            $awardee = strval($myrow['member_id']);
            $awardee_username = $GLOBALS['FORUM_DRIVER']->get_username($myrow['member_id']);
            if (is_null($awardee_username)) {
                $awardee_username = do_lang('UNKNOWN');
            }
            $awardee_profile_url = $GLOBALS['FORUM_DRIVER']->member_profile_url($myrow['member_id'], true, true);
        }

        return do_template('BLOCK_MAIN_AWARDS', array(
            '_GUID' => ($guid != '') ? $guid : '99f092e35db0c17f407f40ed55c42cfd',
            'TITLE' => $award_title,
            'TYPE' => $award_type_row['a_content_type'],
            'DESCRIPTION' => $award_description,
            'AWARDEE_PROFILE_URL' => $awardee_profile_url,
            'AWARDEE' => $awardee,
            'AWARDEE_USERNAME' => $awardee_username,
            'RAW_AWARD_DATE' => strval($myrow['date_and_time']),
            'AWARD_DATE' => get_timezoned_date_tempcode($myrow['date_and_time']),
            'CONTENT' => $rendered_content,
            'SUBMIT_URL' => $submit_url,
            'ARCHIVE_URL' => $archive_url,
        ));
    }
}

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
 * @package    core
 */

/**
 * Block class.
 */
class Block_main_content
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
        $info['parameters'] = array('param', 'id', 'select', 'select_b', 'title', 'zone', 'no_links', 'give_context', 'include_breadcrumbs', 'render_if_empty', 'guid', 'as_guest', 'check');
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
        $info['cache_on'] = 'array(array_key_exists(\'as_guest\',$map)?($map[\'as_guest\']==\'1\'):false,array_key_exists(\'render_if_empty\',$map)?$map[\'render_if_empty\']:\'1\',array_key_exists(\'guid\',$map)?$map[\'guid\']:\'\',(array_key_exists(\'give_context\',$map)?$map[\'give_context\']:\'0\')==\'1\',(array_key_exists(\'include_breadcrumbs\',$map)?$map[\'include_breadcrumbs\']:\'0\')==\'1\',array_key_exists(\'no_links\',$map)?$map[\'no_links\']:0,array_key_exists(\'title\',$map)?$map[\'title\']:null,array_key_exists(\'param\',$map)?$map[\'param\']:\'download\',array_key_exists(\'id\',$map)?$map[\'id\']:\'\',array_key_exists(\'select\',$map)?$map[\'select\']:\'\',array_key_exists(\'select_b\',$map)?$map[\'select_b\']:\'\',array_key_exists(\'zone\',$map)?$map[\'zone\']:\'_SEARCH\',array_key_exists(\'check\',$map)?($map[\'check\']==\'1\'):true)';
        $info['special_cache_flags'] = CACHE_AGAINST_DEFAULT | CACHE_AGAINST_PERMISSIVE_GROUPS;
        if (addon_installed('content_privacy')) {
            $info['special_cache_flags'] |= CACHE_AGAINST_MEMBER;
        }
        $info['ttl'] = (get_value('disable_block_timeout') === '1') ? 60 * 60 * 24 * 365 * 5/*5 year timeout*/ : 60 * 24; // Intentionally, do randomisation acts as 'of the day'
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
        $block_id = get_block_id($map);

        $check_perms = array_key_exists('check', $map) ? ($map['check'] == '1') : true;

        $guid = isset($map['guid']) ? $map['guid'] : '';
        if (isset($map['param'])) {
            $content_type = $map['param'];
        } else {
            if (addon_installed('downloads')) {
                $content_type = 'download';
            } else {
                $hooks = find_all_hooks('systems', 'content_meta_aware');
                $content_type = key($hooks);
            }
        }
        $content_id = isset($map['id']) ? $map['id'] : null;
        if ($content_id === '') {
            return do_template('RED_ALERT', array('_GUID' => 'rt44x3hfhc4frhbenjk01ka042716x6g', 'TEXT' => do_lang_tempcode('NO_PARAMETER_SENT', escape_html('id')))); // Might have happened due to some bad chaining in a template
        }
        $randomise = ($content_id === null);
        $zone = isset($map['zone']) ? $map['zone'] : '_SEARCH';
        $select = isset($map['select']) ? $map['select'] : '';
        $select_b = isset($map['select_b']) ? $map['select_b'] : '';
        $title = isset($map['title']) ? $map['title'] : null;
        $give_context = (isset($map['give_context']) ? $map['give_context'] : '0') == '1';
        $include_breadcrumbs = (isset($map['include_breadcrumbs']) ? $map['include_breadcrumbs'] : '0') == '1';

        if ((!file_exists(get_file_base() . '/sources/hooks/systems/content_meta_aware/' . filter_naughty_harsh($content_type, true) . '.php')) && (!file_exists(get_file_base() . '/sources_custom/hooks/systems/content_meta_aware/' . filter_naughty_harsh($content_type, true) . '.php'))) {
            return do_template('RED_ALERT', array('_GUID' => 'qt44x3hfhc4frhbenjk01ka042716x6g', 'TEXT' => do_lang_tempcode('NO_SUCH_CONTENT_TYPE', escape_html($content_type))));
        }

        require_code('content');
        $object = get_content_object($content_type);
        $info = $object->info(null, true);
        if ($info === null) {
            return do_template('RED_ALERT', array('_GUID' => 'agcqadouhjf6yfynwluv02fjy17e1vw9', 'TEXT' => do_lang_tempcode('IMPOSSIBLE_TYPE_USED')));
        }
        if ($title === null) {
            if ($content_id === null) {
                $title = do_lang('RANDOM_CONTENT', do_lang($info['content_type_label']));
            } else {
                $title = do_lang($info['content_type_label']);
            }
        }
        if (((!array_key_exists('id_field_numeric', $info)) || ($info['id_field_numeric'])) && ($content_id !== null) && (!is_numeric($content_id))) {
            list(, $resource_page, $resource_type) = explode(':', $info['view_page_link_pattern']);
            $content_id = $info['db']->query_select_value_if_there('url_id_monikers', 'm_resource_id', array('m_resource_page' => $resource_page, 'm_resource_type' => $resource_type, 'm_moniker' => $content_id));
            if ($content_id === null) {
                return do_template('RED_ALERT', array('_GUID' => 'wqehgloobwa1s6ibn9tmgweefw8aiogt', 'TEXT' => do_lang_tempcode('MISSING_RESOURCE')));
            }
        }

        global $TABLE_LANG_FIELDS_CACHE;
        $lang_fields = isset($TABLE_LANG_FIELDS_CACHE[$info['table']]) ? $TABLE_LANG_FIELDS_CACHE[$info['table']] : array();
        foreach ($lang_fields as $lang_field => $lang_field_type) {
            unset($lang_fields[$lang_field]);
            $lang_fields['r.' . $lang_field] = $lang_field_type;
        }

        $submit_url = $info['add_url'];
        if ($submit_url !== null) {
            $submit_url = page_link_to_url($submit_url);
        } else {
            $submit_url = '';
        }
        if (!has_actual_page_access(null, $info['cms_page'], null, null)) {
            $submit_url = '';
        }

        // Randomisation mode
        if ($randomise) {
            $category_type_access = null;
            $category_type_select = null;
            if (is_array($info['category_field'])) {
                $category_field_access = $info['category_field'][0];
                $category_field_select = $info['category_field'][1];
            } else {
                $category_field_access = $info['category_field'];
                $category_field_select = $info['category_field'];
            }
            if (array_key_exists('category_type', $info)) {
                if (is_array($info['category_type'])) {
                    $category_type_access = $info['category_type'][0];
                    $category_type_select = $info['category_type'][1];
                } else {
                    $category_type_access = $info['category_type'];
                    $category_type_select = $info['category_type'];
                }
            }

            $where = '1=1';
            $query = 'FROM ' . get_table_prefix() . $info['table'] . ' r';

            if ((!$GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) && ($check_perms)) {
                if (addon_installed('content_privacy')) {
                    require_code('content_privacy');
                    $as_guest = array_key_exists('as_guest', $map) ? ($map['as_guest'] == '1') : false;
                    $viewing_member_id = $as_guest ? $GLOBALS['FORUM_DRIVER']->get_guest_id() : null;
                    list($privacy_join, $privacy_where) = get_privacy_where_clause($content_type, 'r', $viewing_member_id);
                    $query .= $privacy_join;
                    $where .= $privacy_where;
                }

                $groups = get_permission_where_clause_groups(get_member(), true, 'a.');
                $groups2 = get_permission_where_clause_groups(get_member(), true, 'a2.');

                if ($category_field_access !== null) {
                    if ($category_type_access === '<zone>') {
                        $query .= ' LEFT JOIN ' . get_table_prefix() . 'group_zone_access a ON (r.' . $category_field_access . '=a.zone_name)';
                        $query .= ' LEFT JOIN ' . get_table_prefix() . 'group_zone_access ma ON (r.' . $category_field_access . '=ma.zone_name)';
                    } elseif ($category_type_access === '<page>') {
                        $query .= ' LEFT JOIN ' . get_table_prefix() . 'group_page_access a ON (r.' . $category_field_select . '=a.page_name AND r.' . $category_field_access . '=a.zone_name AND (' . $groups . '))';
                        $query .= ' LEFT JOIN ' . get_table_prefix() . 'group_zone_access a2 ON (r.' . $category_field_access . '=a2.zone_name)';
                        $query .= ' LEFT JOIN ' . get_table_prefix() . 'group_zone_access ma2 ON (r.' . $category_field_access . '=ma2.zone_name)';
                    } else {
                        $query .= get_permission_join_clause($category_type_select, $category_field_select, 'a', 'ma');
                    }
                }
                if (($category_field_select !== null) && ($category_field_select != $category_field_access) && ($info['category_type'] !== '<page>') && ($info['category_type'] !== '<zone>')) {
                    $query .= get_permission_join_clause($category_type_select, $category_field_select, 'a2', 'ma2');
                }

                if ($category_field_access !== null) {
                    if ($info['category_type'] === '<page>') {
                        $where .= ' AND (a.group_id IS NULL) AND (' . $groups2 . ') AND (a2.group_id IS NOT NULL)';
                        // NB: too complex to handle member-specific page permissions in this
                    } else {
                        $where .= get_permission_where_clause(get_member(), $groups, 'a', 'ma');
                    }
                }
                if (($category_field_select !== null) && ($category_field_select != $category_field_access) && ($info['category_type'] !== '<page>')) {
                    $where .= get_permission_where_clause(get_member(), $groups2, 'a2', 'ma2');
                }

                if (array_key_exists('where', $info)) {
                    $where .= ' AND ';
                    $where .= $info['where'];
                }
            }

            if ((array_key_exists('validated_field', $info)) && ($info['validated_field'] != '')) {
                $where .= ' AND ';
                $where .= $info['validated_field'] . '=1';
            }

            $x1 = '';
            $x2 = '';
            if (($select != '') && ($category_field_access !== null)) {
                $x1 = $this->build_select($select, $info, 'r.' . $category_field_access, is_array($info['category_is_string']) ? $info['category_is_string'][0] : $info['category_is_string']);
                $parent_spec__table_name = array_key_exists('parent_spec__table_name', $info) ? $info['parent_spec__table_name'] : null;
                if (($parent_spec__table_name !== null) && ($parent_spec__table_name != $info['table'])) {
                    $query .= ' LEFT JOIN ' . $info['db']->get_table_prefix() . $parent_spec__table_name . ' parent ON parent.' . $info['parent_spec__field_name'] . '=r.' . (is_array($info['id_field']) ? implode(',', $info['id_field']) : $info['id_field']);
                }
            }
            if (($select_b != '') && ($category_field_select !== null)) {
                $x2 = $this->build_select($select_b, $info, 'r.' . $category_field_select, is_array($info['category_is_string']) ? $info['category_is_string'][1] : $info['category_is_string']);
            }

            if ($where . $x1 . $x2 != '') {
                if ($where == '') {
                    $where = '1=1';
                }
                $query .= ' WHERE ' . $where;
                if ($x1 != '') {
                    $query .= ' AND (' . $x1 . ')';
                }
                if ($x2 != '') {
                    $query .= ' AND (' . $x2 . ')';
                }
            }

            $rows = $info['db']->query('SELECT COUNT(*) as cnt ' . $query);

            $cnt = $rows[0]['cnt'];
            if ($cnt == 0) {
                return do_template('BLOCK_NO_ENTRIES', array(
                    '_GUID' => ($guid != '') ? $guid : '13f060922a5ab6c370f218b2ecc6fe9c',
                    'BLOCK_ID' => $block_id,
                    'HIGH' => true,
                    'TITLE' => $title,
                    'MESSAGE' => do_lang_tempcode('NO_ENTRIES', escape_html($content_type)),
                    'ADD_NAME' => content_language_string($content_type, 'ADD'),
                    'SUBMIT_URL' => str_replace('=%21', '__ignore=1', $submit_url),
                ));
            }

            $rows = $info['db']->query('SELECT *,r.' . (is_array($info['id_field']) ? implode(',', $info['id_field']) : $info['id_field']) . ' ' . $query, 1, mt_rand(0, $cnt - 1), false, false, $lang_fields);
            $award_content_row = $rows[0];

            // Get content ID
            $content_id = extract_content_str_id_from_data($award_content_row, $info);
        } // Select mode
        else {
            if ($content_type == 'comcode_page') { // FUDGE
                // Try and force a parse of the page, so it's in the system
                $bits = explode(':', $content_id);
                push_output_state();
                $result = request_page(array_key_exists(1, $bits) ? $bits[1] : get_comcode_zone($bits[0]), false, $bits[0], 'comcode_custom', true);
                restore_output_state();
                if ($result->is_empty()) {
                    return do_template('RED_ALERT', array('_GUID' => 'txon5apczl07u2gq77ags8mfu8bra1e7', 'TEXT' => do_lang_tempcode('MISSING_RESOURCE')));
                }
            }

            $wherea = get_content_where_for_str_id($content_id, $info, 'r');

            $rows = $info['db']->query_select($info['table'] . ' r', array('r.*'), $wherea, '', 1, null, false, $lang_fields);
            if (!array_key_exists(0, $rows)) {
                if ((isset($map['render_if_empty'])) && ($map['render_if_empty'] == '0')) {
                    return new Tempcode();
                }

                return do_template('BLOCK_NO_ENTRIES', array(
                    '_GUID' => ($guid != '') ? $guid : '12d8cdc62cd78480b83c8daaaa68b686',
                    'BLOCK_ID' => $block_id,
                    'HIGH' => true,
                    'TITLE' => $title,
                    'MESSAGE' => do_lang_tempcode('MISSING_RESOURCE', escape_html($content_type)),
                    'ADD_NAME' => content_language_string($content_type, 'ADD'),
                    'SUBMIT_URL' => str_replace('=%21', '__ignore=1', $submit_url),
                ));
            }
            $award_content_row = $rows[0];
        }

        if ($award_content_row === null) {
            return paragraph(do_lang_tempcode('MISSING_RESOURCE', escape_html($content_type)), '57tjnb3voib8igzw6v5gyplj9uzyqg9e', 'nothing-here');
        }

        $submit_url = str_replace('%21', $content_id, $submit_url);

        if ($info['archive_url'] !== null) {
            $archive_url = page_link_to_tempcode_url($info['archive_url']);
        } else {
            $archive_url = new Tempcode();
        }

        $rendered_content = $object->run($award_content_row, $zone, $give_context, $include_breadcrumbs, null, false, $guid);

        if ((isset($map['no_links'])) && ($map['no_links'] == '1')) {
            $submit_url = '';
            $archive_url = new Tempcode();
        }

        $raw_date = ($info['date_field'] == '') ? null : $award_content_row[$info['date_field']];
        return do_template('BLOCK_MAIN_CONTENT', array(
            '_GUID' => ($guid != '') ? $guid : 'fce1eace6008d650afc0283a7be9ec30',
            'BLOCK_ID' => $block_id,
            'TYPE' => do_lang_tempcode($info['content_type_label']),
            'TITLE' => $title,
            'RAW_AWARD_DATE' => ($raw_date === null) ? '' : strval($raw_date),
            'AWARD_DATE' => ($raw_date === null) ? new Tempcode() : get_timezoned_date_time_tempcode($raw_date),
            'CONTENT' => $rendered_content,
            'SUBMIT_URL' => $submit_url,
            'ARCHIVE_URL' => $archive_url,
        ));
    }

    /**
     * Make a select SQL fragment.
     *
     * @param  string $select The select string
     * @param  array $info Map of details of our content type
     * @param  string $category_field_select The field name of the category to select against
     * @param  boolean $category_is_string Whether the category is a string
     * @return string SQL fragment
     */
    protected function build_select($select, $info, $category_field_select, $category_is_string)
    {
        $parent_spec__table_name = array_key_exists('parent_spec__table_name', $info) ? $info['parent_spec__table_name'] : $info['table'];
        $parent_field_name = array_key_exists('parent_category_field', $info) ? ('r' . $info['parent_category_field']) : null;
        $parent_spec__parent_name = array_key_exists('parent_spec__parent_name', $info) ? $info['parent_spec__parent_name'] : null;
        $parent_spec__field_name = array_key_exists('parent_spec__field_name', $info) ? $info['parent_spec__field_name'] : null;
        require_code('selectcode');
        return selectcode_to_sqlfragment($select, $category_field_select, $parent_spec__table_name, $parent_spec__parent_name, $parent_field_name, $parent_spec__field_name, !$category_is_string, !$category_is_string);
    }
}

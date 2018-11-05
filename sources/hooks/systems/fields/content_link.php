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
 * @package    core_fields
 */

/**
 * Hook class.
 */
class Hook_fields_content_link
{
    /**
     * Find what field types this hook can serve. This method only needs to be defined if it is not serving a single field type with a name corresponding to the hook itself.
     *
     * @return array Map of field type to field type title
     */
    public function get_field_types()
    {
        static $ret = null;
        if ($ret !== null) {
            return $ret;
        }

        $hooks = find_all_hooks('systems', 'content_meta_aware');
        $ret = array();
        foreach (array_keys($hooks) as $hook) {
            if ($hook != 'catalogue_entry'/*got a better field hook specifically for catalogue entries*/) {
                if ((is_file(get_file_base() . '/sources_custom/hooks/systems/content_meta_aware/' . $hook . '.php')) || (is_file(get_file_base() . '/sources/hooks/systems/content_meta_aware/' . $hook . '.php'))) {
                    $ret['at_' . $hook] = do_lang_tempcode('FIELD_TYPE_content_link_x', escape_html($hook));
                }
            }
        }
        return $ret;
    }

    // ==============
    // Module: search
    // ==============

    /**
     * Get special Tempcode for inputting this field.
     *
     * @param  array $field The field details
     * @return ?array Specially encoded input detail rows (null: nothing special)
     */
    public function get_search_inputter($field)
    {
        return null;
    }

    /**
     * Get special SQL from POSTed parameters for this field.
     *
     * @param  array $field The field details
     * @param  integer $i We're processing for the ith row
     * @param string $table_alias Table alias for catalogue entry table
     * @return ?array Tuple of SQL details (array: extra trans fields to search, array: extra plain fields to search, string: an extra table segment for a join, string: the name of the field to use as a title, if this is the title, extra WHERE clause stuff) (null: nothing special)
     */
    public function inputted_to_sql_for_search($field, $i, $table_alias = 'r')
    {
        return exact_match_sql($field, $i, null, $table_alias);
    }

    // ===================
    // Backend: fields API
    // ===================

    /**
     * Get some info bits relating to our field type, that helps us look it up / set defaults.
     *
     * @param  ?array $field The field details (null: new field)
     * @param  ?boolean $required Whether a default value cannot be blank (null: don't "lock in" a new default value) (may be passed as false also if we want to avoid "lock in" of a new default value, but in this case possible cleanup of $default may still happen where appropriate)
     * @param  ?string $default The given default value as a string (null: don't "lock in" a new default value) (blank: only "lock in" a new default value if $required is true)
     * @return array Tuple of details (row-type,default-value-to-use,db row-type)
     */
    public function get_field_value_row_bits($field, $required = null, $default = null)
    {
        return array('short_unescaped', $default, 'short');
    }

    /**
     * Convert a field value to something renderable.
     *
     * @param  array $field The field details
     * @param  mixed $ev The raw value
     * @return mixed Rendered field (Tempcode or string)
     */
    public function render_field_value($field, $ev)
    {
        if (is_object($ev)) {
            return $ev;
        }

        if ($ev == '') {
            return '';
        }

        $type = preg_replace('#^choose\_#', '', substr($field['cf_type'], 3));

        require_code('content');
        list($title, , $info) = content_get_details($type, $ev);
        if ($info === null) {
            return new Tempcode();
        }

        $page_link = str_replace('_WILD', $ev, $info['view_page_link_pattern']);
        $url = page_link_to_tempcode_url($page_link);

        return hyperlink($url, $title, false, true);
    }

    // ======================
    // Frontend: fields input
    // ======================

    /**
     * Get form inputter.
     *
     * @param  string $_cf_name The field name
     * @param  string $_cf_description The field description
     * @param  array $field The field details
     * @param  ?string $actual_value The actual current value of the field (null: none)
     * @param  boolean $new Whether this is for a new entry
     * @return ?Tempcode The Tempcode for the input field (null: skip the field - it's not input)
     */
    public function get_field_inputter($_cf_name, $_cf_description, $field, $actual_value, $new)
    {
        $options = array();
        $type = substr($field['cf_type'], 3);

        $input_name = empty($field['cf_input_name']) ? ('field_' . strval($field['id'])) : $field['cf_input_name'];

        // Nice tree list selection
        if ((is_file(get_file_base() . '/sources/hooks/systems/ajax_tree/choose_' . $type . '.php')) || (is_file(get_file_base() . '/sources_custom/hooks/systems/ajax_tree/choose_' . $type . '.php'))) {
            require_code('content');
            list($nice_label) = content_get_details($type, $actual_value);
            return form_input_tree_list($_cf_name, $_cf_description, $input_name, null, 'choose_' . $type, $options, $field['cf_required'] == 1, $actual_value, false, null, false, $nice_label);
        }

        // Simple list selection...

        require_code('content');
        $ob = get_content_object($type);
        $info = $ob->info();
        if ($info === null) {
            return new Tempcode();
        }
        $db = $GLOBALS[(substr($info['table'], 0, 2) == 'f_') ? 'FORUM_DB' : 'SITE_DB'];
        $select = array();
        append_content_select_for_id($select, $info);
        if (!is_null($info['title_field'])) {
            $select[] = $info['title_field'];
        }
        $rows = $db->query_select($info['table'], $select, null, is_null($info['add_time_field']) ? '' : ('ORDER BY ' . $info['add_time_field'] . ' DESC'), 2000/*reasonable limit*/);

        $_list = array();
        foreach ($rows as $row) {
            $id = extract_content_str_id_from_data($row, $info);
            if (is_null($info['title_field'])) {
                $text = $id;
            } else {
                $text = $info['title_field_dereference'] ? get_translated_text($row[$info['title_field']], $info['connection']) : $row[$info['title_field']];
            }
            $_list[$id] = $text;
        }
        if (count($_list) < 2000) {
            asort($_list);
        }

        $list_tpl = new Tempcode();
        if ((($field['cf_required'] == 0) || ($actual_value === '') || (is_null($actual_value)))) {
            $list_tpl->attach(form_input_list_entry('', true, do_lang_tempcode('NA_EM')));
        }
        foreach ($_list as $id => $text) {
            if (!is_string($id)) {
                $id = strval($id);
            }
            $list_tpl->attach(form_input_list_entry($id, is_null($actual_value) ? false : ($actual_value === $id), $text));
        }

        return form_input_list($_cf_name, $_cf_description, $input_name, $list_tpl, null, false, $field['cf_required'] == 1);
    }

    /**
     * Find the posted value from the get_field_inputter field
     *
     * @param  boolean $editing Whether we were editing (because on edit, it could be a fractional edit)
     * @param  array $field The field details
     * @param  ?string $upload_dir Where the files will be uploaded to (null: do not store an upload, return null if we would need to do so)
     * @param  ?array $old_value Former value of field (null: none)
     * @return ?string The value (null: could not process)
     */
    public function inputted_to_field_value($editing, $field, $upload_dir = 'uploads/catalogues', $old_value = null)
    {
        $id = $field['id'];
        $tmp_name = 'field_' . strval($id);
        return post_param_string($tmp_name, $editing ? STRING_MAGIC_NULL : '');
    }
}

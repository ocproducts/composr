<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

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

/*EXTRA FUNCTIONS: find_country_name_from_iso|get_nested_csv_structure*/

/**
 * Hook class.
 */
class Hook_fields_list
{
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
        $current = get_param_string('option_' . strval($field['id']), '');

        $fields = array();
        $type = '_LIST';
        $special = new Tempcode();
        $special->attach(form_input_list_entry('', get_param_string('option_' . strval($field['id']), '') == '', '---'));
        $display = array_key_exists('trans_name', $field) ? $field['trans_name'] : get_translated_text($field['cf_name']); // 'trans_name' may have been set in CPF retrieval API, might not correspond to DB lookup if is an internal field
        $list = $this->get_input_list_map($field, true);
        foreach ($list as $l => $written) {
            $special->attach(form_input_list_entry($l, $current != '' && $current === $l, $written));
        }
        return array('NAME' => strval($field['id']), 'DISPLAY' => $display, 'TYPE' => $type, 'SPECIAL' => $special);
    }

    /**
     * Get special SQL from POSTed parameters for this field.
     *
     * @param  array $field The field details
     * @param  integer $i We're processing for the ith row
     * @return ?array Tuple of SQL details (array: extra trans fields to search, array: extra plain fields to search, string: an extra table segment for a join, string: the name of the field to use as a title, if this is the title, extra WHERE clause stuff) (null: nothing special)
     */
    public function inputted_to_sql_for_search($field, $i)
    {
        return exact_match_sql($field, $i, 'long');
    }

    // ===================
    // Backend: fields API
    // ===================

    /**
     * Get some info bits relating to our field type, that helps us look it up / set defaults.
     *
     * @param  ?array $field The field details (null: new field)
     * @param  ?boolean $required Whether a default value cannot be blank (null: don't "lock in" a new default value)
     * @param  ?string $default The given default value as a string (null: don't "lock in" a new default value)
     * @return array Tuple of details (row-type,default-value-to-use,db row-type)
     */
    public function get_field_value_row_bits($field, $required = null, $default = null)
    {
        if ($required !== null) {
            if (($required) && ($default == '')) {
                $default = preg_replace('#\|.*#', '', $default);
                $default = preg_replace('#=.*#', '', $default);
            }
        }
        return array('long_unescaped', $default, 'long');
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
        return escape_html($ev);
    }

    // ======================
    // Frontend: fields input
    // ======================

    /**
     * Get field list.
     *
     * @param  array $field The field details
     * @param  ?boolean $dynamic_choices Whether to put custom choices from previous data back into the main list (null: decide based on field options)
     * @return array List
     */
    private function get_input_list_map($field, $dynamic_choices = null)
    {
        $default = $field['cf_default'];

        if (addon_installed('nested_cpf_csv_lists') && substr(strtolower($default), -4) == '.csv') {
            $csv_heading = option_value_from_field_array($field, 'csv_heading', '');

            require_code('nested_csv');
            $csv_structure = get_nested_csv_structure();

            $list = array();
            foreach ($csv_structure['csv_files'][$default]['data'] as $row) {
                if ($csv_heading == '') {
                    $l = array_shift($row);
                    $list[$l] = $l;
                } else {
                    $l = $row[$csv_heading];
                    $list[$l] = $l;
                }
            }
        } else {
            if ($default == '') {
                $list = array();
            } else {
                if (substr_count($default, '|') + 1 == substr_count($default, '=')) {
                    foreach (explode('|', $default) as $l) {
                        list($l, $written) = explode('=', $l);
                        $list[$l] = $written;
                    }
                } else {
                    foreach (explode('|', $default) as $l) {
                        $list[$l] = $l;
                    }
                }
            }
        }

        $custom_values = option_value_from_field_array($field, 'custom_values', 'off');

        if ($custom_values == 'on') { // Only makes sense to allow dynamic choices if custom values are enterable
            if (is_null($dynamic_choices)) {
                $dynamic_choices = (option_value_from_field_array($field, 'dynamic_choices', 'off') == 'on');
            }
            if (isset($field['c_name'])) {
                $existing_data = $GLOBALS['SITE_DB']->query_select('catalogue_efv_long', array('DISTINCT cv_value AS d'), array('cf_id' => $field['id']));
            } else {
                $existing_data = $GLOBALS['FORUM_DB']->query_select('f_member_custom_fields', array('DISTINCT field_' . strval($field['id']) . ' AS d'));
            }
            foreach ($existing_data as $d) {
                if ($d['d'] != '') {
                    $parts = explode("\n", $d['d']);
                    $list += array_combine($parts, $parts);
                }
            }
        }

        return $list;
    }
 
    /**
     * Get form inputter.
     *
     * @param  string $_cf_name The field name
     * @param  string $_cf_description The field description
     * @param  array $field The field details
     * @param  ?string $actual_value The actual current value of the field (null: none)
     * @return ?Tempcode The Tempcode for the input field (null: skip the field - it's not input)
     */
    public function get_field_inputter($_cf_name, $_cf_description, $field, $actual_value)
    {
        $default = $field['cf_default'];

        $list = $this->get_input_list_map($field);

        $input_name = empty($field['cf_input_name']) ? ('field_' . strval($field['id'])) : $field['cf_input_name'];

        $custom_values = option_value_from_field_array($field, 'custom_values', 'off');
        $selected = ($actual_value !== null && $actual_value !== '' && $actual_value !== $field['cf_default']);
        $custom_value = ($selected && !array_key_exists($actual_value, $list));

        $value_remap = option_value_from_field_array($field, 'value_remap', 'none');

        $auto_sort = option_value_from_field_array($field, 'auto_sort', 'off');
        if ($auto_sort == 'on') {
            asort($list);
        }

        $input_size = max(1, intval(option_value_from_field_array($field, 'input_size', '9')));

        $widget = option_value_from_field_array($field, 'widget', 'dropdown');

        switch ($widget) {
            case 'radio':
                $list_tpl = new Tempcode();
                if (($field['cf_required'] == 0) && (!array_key_exists('', $list))) {
                    $list_tpl->attach(form_input_radio_entry($input_name, '', !$selected, do_lang_tempcode('NA_EM')));
                }

                foreach ($list as $l => $l_nice) {
                    $list_tpl->attach(form_input_radio_entry($input_name, $l, $l === $actual_value, protect_from_escaping(comcode_to_tempcode($l_nice, null, true))));
                }

                if ($custom_values == 'on') {
                    $list_tpl->attach(do_template('FORM_SCREEN_INPUT_RADIO_LIST_COMBO_ENTRY', array('_GUID' => '4eb01c365b63d4ef09fd99b5c05ca3d5', 'TABINDEX' => strval(get_form_field_tabindex()),
                        'NAME' => $input_name,
                        'VALUE' => $custom_value ? $actual_value : '',
                    )));
                }

                return form_input_radio($_cf_name, $_cf_description, $input_name, $list_tpl, $field['cf_required'] == 1);

            case 'inline':
            case 'dropdown':
            case 'inline_huge':
            case 'dropdown_huge':
            default:
                if ($custom_values == 'on') {
                    $list_tpl = new Tempcode();

                    if (($field['cf_required'] == 0) || (!$selected) && (!array_key_exists('', $list))) {
                        $list_tpl->attach(form_input_list_entry('', !$selected, do_lang_tempcode('NA_EM')));
                    }

                    foreach ($list as $l => $l_nice) {
                        $list_tpl->attach(form_input_list_entry($l, false, protect_from_escaping(comcode_to_tempcode($l_nice, null, true))));
                    }

                    $required = $field['cf_required'] == 1;

                    return form_input_combo($_cf_name, $_cf_description, $input_name, $custom_value ? $actual_value : '', $list_tpl, null, $required);
                } else {
                    $list_tpl = new Tempcode();

                    if ((($field['cf_required'] == 0) || ($actual_value === '') || (is_null($actual_value))) && (!array_key_exists('', $list))) {
                        $list_tpl->attach(form_input_list_entry('', true, do_lang_tempcode('NA_EM')));
                    }

                    foreach ($list as $l => $l_nice) {
                        $selected = ($l === $actual_value || is_null($actual_value) && $l == do_lang('OTHER') && $field['cf_required'] == 1);
                        $list_tpl->attach(form_input_list_entry($l, $selected, protect_from_escaping(comcode_to_tempcode($l_nice, null, true))));
                    }

                    if ($widget == 'dropdown_huge' || $widget == 'inline_huge') {
                        return form_input_huge_list($_cf_name, $_cf_description, $input_name, $list_tpl, null, ($widget == 'inline_huge'), $field['cf_required'] == 1, $input_size);
                    }

                    return form_input_list($_cf_name, $_cf_description, $input_name, $list_tpl, null, ($widget == 'inline'), $field['cf_required'] == 1, null, $input_size);
                }
        }
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

        $custom_values = option_value_from_field_array($field, 'custom_values', 'off');
        if ($custom_values == 'on') {
            $test = post_param_string($tmp_name . '_custom', null);
            if (!empty($test)) {
                return $test;
            }
        }

        return post_param_string($tmp_name, $editing ? STRING_MAGIC_NULL : '');
    }
}

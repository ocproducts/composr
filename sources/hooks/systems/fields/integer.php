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
 * @package    core_fields
 */

/**
 * Hook class.
 */
class Hook_fields_integer
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
        $type = '_INTEGER';
        $extra = '';
        $display = array_key_exists('trans_name', $field) ? $field['trans_name'] : get_translated_text($field['cf_name']);

        $range_search = (option_value_from_field_array($field, 'range_search', 'off') == 'on');
        if ($range_search) {
            $type .= '_RANGE';
            $special = get_param_string('option_' . strval($field['id']) . '_from', '') . ';' . get_param_string('option_' . strval($field['id']) . '_to', '');
        } else {
            $special = get_param_string('option_' . strval($field['id']), '');
        }

        return array('NAME' => strval($field['id']) . $extra, 'DISPLAY' => $display, 'TYPE' => $type, 'SPECIAL' => $special);
    }

    /**
     * Get special SQL from POSTed parameters for this field.
     *
     * @param  array $field The field details
     * @param  integer $i We're processing for the ith row
     * @param  string $table_alias Table alias for catalogue entry table
     * @return ?array Tuple of SQL details (array: extra trans fields to search, array: extra plain fields to search, string: an extra table segment for a join, string: the name of the field to use as a title, if this is the title, extra WHERE clause stuff) (null: nothing special)
     */
    public function inputted_to_sql_for_search($field, $i, $table_alias = 'r')
    {
        $range_search = (option_value_from_field_array($field, 'range_search', 'off') == 'on');
        if ($range_search) {
            return null;
        }

        return exact_match_sql($field, $i, 'integer', null, $table_alias);
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
        if (($default !== null) && (strtoupper($default) == 'AUTO_INCREMENT') && ($field !== null) && ($field['id'] !== null)) { // We need to calculate a default even if not required, because the defaults are programmatic
            $default = ($field === null) ? '0' : $this->get_field_auto_increment($field['id'], intval($default));
        } else {
            if ($required !== null) {
                if (($required) && ($default == '')) {
                    $default = '0';
                }
            }
        }
        return array('integer_unescaped', $default, 'integer');
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
            if ($ev->evaluate() == do_lang('NA_EM')) {
                return '';
            }

            return $ev;
        }

        if ($ev == '') {
            return '';
        }

        if (($GLOBALS['XSS_DETECT']) && (ocp_is_escaped($ev))) {
            ocp_mark_as_escaped($ev);
        }
        return $ev;
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
        $default = option_value_from_field_array($field, 'default', $field['cf_default']);

        if ($new && strtoupper($default) == 'AUTO_INCREMENT') {
            return null;
        }

        if ($actual_value === do_lang('NA')) {
            $actual_value = null;
        }

        $input_name = empty($field['cf_input_name']) ? ('field_' . strval($field['id'])) : $field['cf_input_name'];
        $autocomplete = ($new && !empty($field['cf_autofill_type'])) ? (($field['cf_autofill_hint'] ? $field['cf_autofill_hint'] . ' ' : '') . $field['cf_autofill_type']) : null;
        return form_input_integer($_cf_name, $_cf_description, $input_name, (($actual_value === null) || ($actual_value === '')) ? null : intval($actual_value), $field['cf_required'] == 1, null, null, $autocomplete);
    }

    /**
     * Find the posted value from the get_field_inputter field.
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
        $default = option_value_from_field_array($field, 'default', $field['cf_default']);
        if (!$editing && strtoupper($default) == 'AUTO_INCREMENT') {
            return $this->get_field_auto_increment($id, $field['cf_default']);
        }
        $ret = post_param_string($tmp_name, $editing ? STRING_MAGIC_NULL : '');
        if (is_numeric($ret)) { // TODO: #3046 in tracker
            $test = intval($ret);
            if ($test > 2147483647) {
                $ret = '2147483647';
            } elseif ($test < -2147483648) {
                $ret = '-2147483648';
            }
        }
        return $ret;
    }

    /**
     * Get a fresh value for an auto_increment valued field.
     *
     * @param  AUTO_LINK $field_id The field ID
     * @param  string $default The field default
     * @return ?string The value (null: could not process)
     */
    public function get_field_auto_increment($field_id, $default = '')
    {
        // Get most recent value, to start with- we will iterate forward on it
        $value = $GLOBALS['SITE_DB']->query_select_value_if_there('catalogue_efv_integer', 'cv_value', array('cf_id' => $field_id), 'ORDER BY ce_id DESC');
        if ($value === null) {
            $value = intval($default) - 1;
        }

        $test = null;
        do {
            $value++;

            $test = $GLOBALS['SITE_DB']->query_select_value_if_there('catalogue_efv_integer', 'ce_id', array('cv_value' => $value, 'cf_id' => $field_id));
        } while ($test !== null);

        return strval($value);
    }
}

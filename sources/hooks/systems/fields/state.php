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
class Hook_fields_state
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
        return null;
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
        return null;
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
            $ev = $ev->evaluate();
        }

        if ($ev == '') {
            return '';
        }

        if (get_option('business_country') == 'US') { // TaxCloud needs exact states, and Americans are a bit pampered, so show an explicit list
            require_code('locations');

            global $USA_STATE_LIST;
            if (isset($USA_STATE_LIST[$ev])) {
                $ev = $USA_STATE_LIST[$ev];
            }
        }

        return escape_html($ev);
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
        if ($actual_value === null) {
            $actual_value = ''; // Plug anomaly due to unusual corruption
        }

        $input_name = empty($field['cf_input_name']) ? ('field_' . strval($field['id'])) : $field['cf_input_name'];
        $autocomplete = ($new && $field['cf_autofill_type']) ? (($field['cf_autofill_hint'] ? $field['cf_autofill_hint'] . ' ' : '') . $field['cf_autofill_type']) : null;

        $definitely_usa = (get_option('cpf_enable_country') == '0') && (get_option('business_country') == 'US');
        if (get_option('business_country') == 'US') { // TaxCloud needs exact states, and Americans are a bit pampered, so show an explicit list
            require_code('locations');
            $state_list = new Tempcode();
            $state_list->attach(form_input_list_entry('', '' == $actual_value, do_lang_tempcode('NA_EM')));
            $state_list->attach(create_usa_state_selection_list(array($actual_value)));
            return form_input_list($_cf_name, $_cf_description, $input_name, $state_list, null, false, $field['cf_required'] == 1, null, 5, $autocomplete);
        }

        return form_input_line($_cf_name, $_cf_description, $input_name, $actual_value, $field['cf_required'] == 1, null, null, 'text', null, null, null, null, $autocomplete);
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
        return post_param_string($tmp_name, $editing ? STRING_MAGIC_NULL : '');
    }
}

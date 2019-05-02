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
class Hook_fields_time
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
        $type = '_JUST_TIME';
        $special = $this->get_search_filter_from_env($field);
        $extra = '';
        $display = array_key_exists('trans_name', $field) ? $field['trans_name'] : get_translated_text($field['cf_name']);

        $range_search = (option_value_from_field_array($field, 'range_search', 'off') == 'on');
        if ($range_search) {
            $type .= '_RANGE';
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

        return exact_match_sql($field, $i, 'short', $this->get_search_filter_from_env($field), $table_alias);
    }

    /**
     * Get a search filter string from the environment.
     *
     * @param  array $field The field details
     * @return string Filter
     */
    public function get_search_filter_from_env($field)
    {
        $range_search = (option_value_from_field_array($field, 'range_search', 'off') == 'on');
        if ($range_search) {
            $from = $this->input_from('option_' . strval($field['id']) . '_from', true);
            $to = $this->input_from('option_' . strval($field['id']) . '_to', true);
            return $from . ';' . $to;
        }

        return $this->input_from('option_' . strval($field['id']), true);
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
        if ($required !== null) {
            if (($required) && ($default == '')) {
                $default = date('H:i:s', utctime_to_usertime());
            }
        }
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

        if ($ev != '') {
            if (strtoupper($ev) == 'NOW') {
                $time = time();
            } else {
                // Y-m-d H:i:s
                $time_bits = explode(':', $ev, 3);
                if ($time_bits[0] == '') {
                    return '';
                }
                if (!array_key_exists(1, $time_bits)) {
                    $time_bits[1] = '00';
                }
                if (!array_key_exists(2, $time_bits)) {
                    $time_bits[2] = '00';
                }
                $time = mktime(intval($time_bits[0]), intval($time_bits[1]), intval($time_bits[2]));
                //$time = utctime_to_usertime($time);   No, as we have no idea what date it is for, so cannot do DST changes
            }
            $ev = get_timezoned_time($time, true, true);
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
        $time = mixed();

        if (($actual_value === null) || ($actual_value == '') || ($actual_value[0] == ':')) {
            $time = null;
        } elseif ($actual_value == 'NOW') {
            $time = time();
        } else {
            // H:i:s
            $time_bits = explode(':', $actual_value, 3);
            if (!array_key_exists(1, $time_bits)) {
                $time_bits[1] = '00';
            }
            if (!array_key_exists(2, $time_bits)) {
                $time_bits[2] = '00';
            }

            $time = array(intval($time_bits[1]), intval($time_bits[0]), intval(date('m')), intval(date('d')), intval(date('Y')));
        }
        $input_name = empty($field['cf_input_name']) ? ('field_' . strval($field['id'])) : $field['cf_input_name'];
        return form_input_date($_cf_name, $_cf_description, $input_name, $field['cf_required'] == 1, ($field['cf_required'] == 0) && ($time === null), true, $time, 1, 1900, null, false, null, false);
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
        if (fractional_edit()) {
            return STRING_MAGIC_NULL;
        }

        $id = $field['id'];
        $stub = 'field_' . strval($id);
        return $this->input_from($stub);
    }

    /**
     * Input a value.
     *
     * @param  string $stub Name of environment variable
     * @param  boolean $get Use GET parameter instead of POST parameter
     * @return string String representation
     */
    protected function input_from($stub, $get = false)
    {
        if ($get) {
            $time = get_param_string($stub, null);
        } else {
            $time = post_param_string($stub, null);
        }
        if ($time !== null) {
            $matches = array();
            if (preg_match('#^(\d\d):(\d\d)$#', $time, $matches) != 0) {
                $hour = intval($matches[1]);
                $minute = intval($matches[2]);
            } else {
                $hour = null;
                $minute = null;
            }
        } else {
            if ($get) {
                $hour = get_param_integer($stub . '_hour', null);
                $minute = get_param_integer($stub . '_minute', null);
            } else {
                $hour = post_param_integer($stub . '_hour', null);
                $minute = post_param_integer($stub . '_minute', null);
            }
        }

        if (($hour === null) && ($minute === null)) {
            return '';
        }

        return (($hour === null) ? '' : strval($hour)) . ':' . str_pad((($minute === null) ? '' : strval($minute)), 2, '0', STR_PAD_LEFT);
    }
}

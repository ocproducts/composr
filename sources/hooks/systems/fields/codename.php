<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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
class Hook_fields_codename
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
     * @param string $table_alias Table alias for catalogue entry table
     * @return ?array Tuple of SQL details (array: extra trans fields to search, array: extra plain fields to search, string: an extra table segment for a join, string: the name of the field to use as a title, if this is the title, extra WHERE clause stuff) (null: nothing special)
     */
    public function inputted_to_sql_for_search($field, $i, $table_alias = 'r')
    {
        require_code('database_search');
        return exact_match_sql($field, $i, 'short', null, $table_alias);
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
        if (($default !== null) && (strtoupper($default) === 'RANDOM') && ($field !== null) && ($field['id'] !== null)) { // We need to calculate a default even if not required, because the defaults are programmatic
            $default = $this->get_field_random($field['id'], $default);
        }
        return array('short_text', $default, 'short');
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
        if ($new && strtoupper($default) == 'RANDOM') {
            return null;
        }

        if ($actual_value === null) {
            $actual_value = ''; // Plug anomaly due to unusual corruption
        }
        $input_name = empty($field['cf_input_name']) ? ('field_' . strval($field['id'])) : $field['cf_input_name'];
        return form_input_codename($_cf_name, $_cf_description, $input_name, $actual_value, $field['cf_required'] == 1);
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
        if (!$editing && strtoupper($default) == 'RANDOM') {
            return $this->get_field_random($id, $field['cf_default']);
        }

        require_code('type_sanitisation');
        $value = post_param_string($tmp_name, $editing ? STRING_MAGIC_NULL : '');
        if (($value != '') && ($value != STRING_MAGIC_NULL)) {
            if (!is_alphanumeric($value, true)) {
                if (strpos($value, '://') !== false) { // strip out from URL, if full URL was entered
                    $value = basename($value);
                    $_POST[$tmp_name] = $value; // Copy back, so fractional editing knows
                } else {
                    warn_exit(do_lang_tempcode('BAD_CODENAME'));
                }
            }
        }
        return $value;
    }

    /**
     * Get a fresh value for a random valued field.
     *
     * @param  AUTO_LINK $field_id The field ID
     * @param  string $default The field default
     * @return ?string The value (null: could not process)
     */
    public function get_field_random($field_id, $default = '')
    {
        $rand_array = '1234567890abcdefghijklmnopqrstuvwxyz';
        $c = strlen($rand_array) - 1;
        if (($default == '') || ($default === null)) {
            $length = 10;
        } else {
            $length = intval($default);
            if ($length == 0) {
                $length = 10;
            }
        }
        $test = null;
        do {
            $value = '';
            for ($i = 0; $i < $length; $i++) {
                $value .= $rand_array[mt_rand(0, $c)];
            }

            if (!addon_installed('catalogues')) {
                break;
            }
            $test = $GLOBALS['SITE_DB']->query_select_value_if_there('catalogue_efv_short', 'ce_id', array('cv_value' => $value, 'cf_id' => $field_id));
        } while ($test !== null);

        return $value;
    }
}

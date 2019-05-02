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
 * @package    ecommerce
 */

/**
 * Hook class.
 */
class Hook_fields_tax_code
{
    /**
     * Find what field types this hook can serve. This method only needs to be defined if it is not serving a single field type with a name corresponding to the hook itself.
     *
     * @return array Map of field type to field type title
     */
    public function get_field_types()
    {
        if (!addon_installed('ecommerce')) {
            return array();
        }

        return array('tax_code' => do_lang_tempcode('FIELD_TYPE_tax_code'));
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

        $tax_code = $ev;

        require_code('ecommerce');

        $in_money = (option_value_from_field_array($field, 'in_money', 'off') == 'on');

        // Render as money...

        if ($in_money) {
            list(, $tax, , ) = calculate_tax_due(null, $tax_code, 100.00/*So we get a percentage*/);

            require_code('currency');
            return currency_convert_wrap($tax, null, CURRENCY_DISPLAY_TEMPLATED);
        }

        // Render as a tax rate...

        if (preg_match('#^TIC:#', $tax_code) != 0) {
            $current_tic = intval(substr($tax_code, 4));
            require_code('files2');
            list($__tics) = cache_and_carry('cms_http_request', array('https://taxcloud.net/tic/?format=text'));
            $_tics = explode("\n", $__tics);
            foreach ($_tics as $tic_line) {
                if (strpos($tic_line, '=') !== false) {
                    list($tic, $tic_label) = explode('=', $tic_line, 2);
                    if (intval($tic) == $current_tic) {
                        return escape_html($tic_label);
                    }
                }
            }
            return escape_html($tax_code);
        }

        if ($tax_code == 'EU') {
            return do_lang_tempcode('TAX_EU');
        }

        if (substr($tax_code, -1) == '%') {
            return escape_html(float_format(floatval(substr($tax_code, 0, strlen($tax_code) - 1)), 2, true) . '%');
        }

        require_code('currency');
        return currency_convert_wrap(floatval($tax_code), null, CURRENCY_DISPLAY_TEMPLATED);
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
        require_code('ecommerce');

        if ($actual_value == '') {
            $actual_value = null;
        }
        if ($actual_value === null) {
            if (isset($field['id'])) {
                $query = 'SELECT cv_value,count(cv_value) AS qty FROM ' . get_table_prefix() . 'catalogue_efv_short WHERE cf_id=' . strval($field['id']);
                $query .= ' GROUP BY cv_value ORDER BY qty DESC';
                $val = $GLOBALS['SITE_DB']->query_value_if_there($query); // We need the mode here, not the mean
                $actual_value = ($val === null) ? '0.0' : $val;
            }
        }
        $input_name = empty($field['cf_input_name']) ? ('field_' . strval($field['id'])) : $field['cf_input_name'];
        return form_input_tax_code($_cf_name, $_cf_description, $input_name, $actual_value, $field['cf_required'] == 1);
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
        require_code('ecommerce');

        $id = $field['id'];
        $tmp_name = 'field_' . strval($id);
        $tax_code = post_param_tax_code($tmp_name, $editing ? STRING_MAGIC_NULL : '');
        return $tax_code;
    }
}

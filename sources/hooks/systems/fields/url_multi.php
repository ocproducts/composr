<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

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
class Hook_fields_url_multi
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
     * @param  ?boolean $required Whether a default value cannot be blank (null: don't "lock in" a new default value) (may be passed as false also if we want to avoid "lock in" of a new default value, but in this case possible cleanup of $default may still happen where appropriate)
     * @param  ?string $default The given default value as a string (null: don't "lock in" a new default value) (blank: only "lock in" a new default value if $required is true)
     * @return array Tuple of details (row-type,default-value-to-use,db row-type)
     */
    public function get_field_value_row_bits($field, $required = null, $default = null)
    {
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

        if ($ev == '') {
            return '';
        }
        if ($ev == 'http://') {
            return '';
        }

        $out = array();
        $evs = explode("\n", $ev);
        foreach ($evs as $ev) {
            require_code('http');
            $meta_details = get_webpage_meta_details($ev);
            $link_captions_title = $meta_details['t_title'];

            if ($link_captions_title == '') {
                $link_captions_title = urldecode(basename($ev));
            }

            $out[$ev] = $link_captions_title;
        }

        $auto_sort = option_value_from_field_array($field, 'auto_sort', 'off');
        if ($auto_sort == 'on') {
            @asort($out, SORT_NATURAL | SORT_FLAG_CASE);
        }

        $ret = new Tempcode();
        foreach ($out as $ev => $link_captions_title) {
            $ret->attach(paragraph(hyperlink((url_is_local($ev) ? (get_base_url() . '/') : '') . $ev, $link_captions_title, true, true)));
        }
        return $ret;
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
        return form_input_line_multi($_cf_name, $_cf_description, $input_name, ($actual_value == '') ? array() : explode("\n", $actual_value), ($field['cf_required'] == 1) ? 1 : 0, null, 'url');
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
        $i = 0;
        $value = '';
        do {
            $tmp_name = 'field_' . strval($id) . '_' . strval($i);
            $_value = post_param_string($tmp_name, null);
            if (($_value === null) && ($i == 0)) {
                return $editing ? STRING_MAGIC_NULL : '';
            }
            if (($_value !== null) && ($_value != '')) {
                if ($_value != STRING_MAGIC_NULL) {
                    $_value = fixup_protocolless_urls($_value);
                }
                if ($_value == 'http://') {
                    $_value = '';
                }
                if ($value != '') {
                    $value .= "\n";
                }
                $value .= $_value;
            }
            $i++;
        } while ($_value !== null);
        return $value;
    }
}

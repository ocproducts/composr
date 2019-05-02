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
class Hook_fields_theme_image
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

        require_code('themes2');
        $images = get_all_image_ids_type('', true, null, null, true);
        $ret = array();
        foreach ($images as $image) {
            $ret['th_' . $image] = do_lang_tempcode('FIELD_TYPE_theme_image_x', escape_html($image));
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
     * @param  string $table_alias Table alias for catalogue entry table
     * @return ?array Tuple of SQL details (array: extra trans fields to search, array: extra plain fields to search, string: an extra table segment for a join, string: the name of the field to use as a title, if this is the title, extra WHERE clause stuff) (null: nothing special)
     */
    public function inputted_to_sql_for_search($field, $i, $table_alias = 'r')
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
        return array('short_text', $default, 'short');
    }

    /**
     * Convert a field value to something renderable.
     *
     * @param  array $field The field details
     * @param  mixed $ev The raw value
     * @param  integer $i Position in fieldset
     * @param  ?array $only_fields List of fields the output is being limited to (null: N/A)
     * @return mixed Rendered field (Tempcode or string)
     */
    public function render_field_value($field, $ev, $i, $only_fields)
    {
        if (is_object($ev)) {
            return $ev;
        }

        if ($ev == '') {
            return '';
        }

        $img_url = find_theme_image($ev);
        if (!array_key_exists('c_name', $field)) {
            $field['c_name'] = 'other';
        }
        $tpl_set = $field['c_name'];

        set_extra_request_metadata(array(
            'image' => $img_url,
        ));

        $width = option_value_from_field_array($field, 'width', '');
        $height = option_value_from_field_array($field, 'height', '');

        return do_template('CATALOGUE_' . $tpl_set . '_FIELD_PICTURE', array(
            'I' => ($only_fields === null) ? '-1' : strval($i),
            'CATALOGUE' => $field['c_name'],
            'URL' => $img_url,
            'THUMB_URL' => $img_url,
            'WIDTH' => $width,
            'HEIGHT' => $height,
        ), null, false, 'CATALOGUE_DEFAULT_FIELD_PICTURE');
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
        $ids = get_all_image_ids_type(substr($field['cf_type'], 3), true);
        $input_name = empty($field['cf_input_name']) ? ('field_' . strval($field['id'])) : $field['cf_input_name'];
        return form_input_theme_image($_cf_name, $_cf_description, $input_name, $ids, null, $actual_value, null, $field['cf_required'] == 0);
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

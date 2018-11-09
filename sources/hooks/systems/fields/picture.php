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
class Hook_fields_picture
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
        return array('short_unescaped', $default, 'short');
    }

    /**
     * Convert a field value to something renderable.
     *
     * @param  array $field The field details
     * @param  mixed $ev The raw value
     * @param  integer $i Position in fieldset
     * @param  ?array $only_fields List of fields the output is being limited to (null: N/A)
     * @param  ?ID_TEXT $table The table we store in (null: N/A)
     * @param  ?AUTO_LINK $id The ID of the row in the table (null: N/A)
     * @param  ?ID_TEXT $id_field Name of the ID field in the table (null: N/A)
     * @param  ?ID_TEXT $field_id_field Name of the field ID field in the table (null: N/A)
     * @param  ?ID_TEXT $url_field Name of the URL field in the table (null: N/A)
     * @return mixed Rendered field (Tempcode or string)
     */
    public function render_field_value(&$field, $ev, $i, $only_fields, $table = null, $id = null, $id_field = null, $field_id_field = null, $url_field = null)
    {
        if (is_object($ev)) {
            return $ev;
        }

        if ($ev == '') {
            return '';
        }
        if ($ev == STRING_MAGIC_NULL) {
            return ''; // LEGACY: Fix to bad data that got in
        }

        $img_url = $ev;
        if (url_is_local($img_url)) {
            $img_url = get_custom_base_url() . '/' . $img_url;
        }

        $new_name = url_to_filename($ev);
        require_code('images');
        $file_thumb = get_custom_file_base() . '/uploads/auto_thumbs/' . $new_name;
        if (!file_exists($file_thumb)) {
            $img_thumb_url = convert_image($img_url, $file_thumb, null, null, intval(get_option('thumb_width')), false);
        } else {
            $img_thumb_url = get_custom_base_url() . '/uploads/auto_thumbs/' . rawurlencode($new_name);
        }

        if (!array_key_exists('c_name', $field)) {
            $field['c_name'] = 'other';
        }
        $tpl_set = $field['c_name'];

        set_extra_request_metadata(array(
            'image' => $img_url,
        ));

        if (url_is_local($ev)) {
            $keep = symbol_tempcode('KEEP');
            $download_url = find_script('catalogue_file') . '?file=' . urlencode(basename($img_url)) . '&table=' . urlencode($table) . '&id=' . urlencode(strval($id)) . '&id_field=' . urlencode($id_field) . '&url_field=' . urlencode($url_field);
            $download_url .= '&inline=1';
            if ($field_id_field !== null) {
                $download_url .= '&field_id_field=' . urlencode($field_id_field) . '&field_id=' . urlencode(strval($field['id']));
            }
            $download_url .= $keep->evaluate();

            if ((($table === 'catalogue_efv_short') || ($table === 'catalogue_efv_long')) && ($id !== null)) {
                $c_name = $GLOBALS['SITE_DB']->query_select_value('catalogue_entries', 'c_name', array('id' => $id));
                if (substr($c_name, 0, 1) != '_') { // Doesn't work on custom fields (this is documented)
                    $cc_id = $GLOBALS['SITE_DB']->query_select_value('catalogue_entries', 'cc_id', array('id' => $id));
                    if (!has_category_access(get_member(), 'catalogues_catalogue', $c_name)) {
                        $download_url = '';
                    }
                    if (!has_category_access(get_member(), 'catalogues_category', strval($cc_id))) {
                        $download_url = '';
                    }
                    if ((is_file(get_file_base() . '/site/catalogue_file.php')) && (!has_zone_access(get_member(), 'site'))) {
                        $download_url = '';
                    }
                }
            }
        } else {
            $download_url = $img_url;
        }

        $width = option_value_from_field_array($field, 'width', '');
        $height = option_value_from_field_array($field, 'height', '');

        return do_template('CATALOGUE_' . $tpl_set . '_FIELD_PICTURE', array(
            'I' => ($only_fields === null) ? '-1' : strval($i),
            'CATALOGUE' => $field['c_name'],
            'URL' => $download_url,
            'THUMB_URL' => $img_thumb_url,
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
     * @return ?array A pair: The Tempcode for the input field, Tempcode for hidden fields (null: skip the field - it's not input)
     */
    public function get_field_inputter($_cf_name, $_cf_description, $field, $actual_value, $new)
    {
        $say_required = ($field['cf_required'] == 1) && (($actual_value == '') || ($actual_value === null));
        $input_name = empty($field['cf_input_name']) ? ('field_' . strval($field['id'])) : $field['cf_input_name'];
        require_code('images');
        $ffield = form_input_upload($_cf_name, $_cf_description, $input_name, $say_required, ($field['cf_required'] == 1) ? null/*so unlink option not shown*/ : $actual_value, null, true, get_allowed_image_file_types());

        $hidden = new Tempcode();
        handle_max_file_size($hidden, 'image');

        return array($ffield, $hidden);
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
        if ($upload_dir === null) {
            return null;
        }

        $id = $field['id'];
        $tmp_name = 'field_' . strval($id);
        if (!fractional_edit()) {
            require_code('uploads');
            $temp = get_url($tmp_name . '_url', $tmp_name, $upload_dir, 0, CMS_UPLOAD_IMAGE);
            $value = $temp[0];
            if (($editing) && ($value == '') && (post_param_integer($tmp_name . '_unlink', 0) != 1)) {
                return ($old_value === null) ? '' : $old_value['cv_value'];
            }

            if (($old_value !== null) && ($old_value['cv_value'] != '') && (($value != '') || (post_param_integer('custom_' . strval($field['id']) . '_value_unlink', 0) == 1))) {
                @unlink(get_custom_file_base() . '/' . rawurldecode($old_value['cv_value']));
                sync_file(rawurldecode($old_value['cv_value']));
            }
        } else {
            $value = STRING_MAGIC_NULL;
        }

        return $value;
    }

    /**
     * The field is being deleted, so delete any necessary data.
     *
     * @param  mixed $value Current field value
     */
    public function cleanup($value)
    {
        if ($value['cv_value'] != '') {
            @unlink(get_custom_file_base() . '/' . rawurldecode($value['cv_value']));
            sync_file(rawurldecode($value['cv_value']));
        }
    }
}

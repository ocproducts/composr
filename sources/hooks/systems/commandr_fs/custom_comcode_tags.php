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
 * @package    custom_comcode
 */

require_code('resource_fs');

/**
 * Hook class.
 */
class Hook_commandr_fs_custom_comcode_tags extends Resource_fs_base
{
    public $file_resource_type = 'custom_comcode_tag';

    /**
     * Standard Commandr-fs function for seeing how many resources are. Useful for determining whether to do a full rebuild.
     *
     * @param  ID_TEXT $resource_type The resource type
     * @return integer How many resources there are
     */
    public function get_resources_count($resource_type)
    {
        return $GLOBALS['SITE_DB']->query_select_value('custom_comcode', 'COUNT(*)');
    }

    /**
     * Standard Commandr-fs function for searching for a resource by label.
     *
     * @param  ID_TEXT $resource_type The resource type
     * @param  LONG_TEXT $label The resource label
     * @return array A list of resource IDs
     */
    public function find_resource_by_label($resource_type, $label)
    {
        $ret = $GLOBALS['SITE_DB']->query_select('custom_comcode', array('tag_tag'), array('tag_tag' => $label));
        return collapse_1d_complexity('tag_tag', $ret);
    }

    /**
     * Standard Commandr-fs date fetch function for resource-fs hooks. Defined when getting an edit date is not easy.
     *
     * @param  array $row Resource row (not full, but does contain the ID)
     * @return ?TIME The edit date or add date, whichever is higher (null: could not find one)
     */
    protected function _get_file_edit_date($row)
    {
        $query = 'SELECT MAX(date_and_time) FROM ' . get_table_prefix() . 'actionlogs WHERE ' . db_string_equal_to('param_a', $row['tag_tag']) . ' AND  (' . db_string_equal_to('the_type', 'ADD_CUSTOM_COMCODE_TAG') . ' OR ' . db_string_equal_to('the_type', 'EDIT_CUSTOM_COMCODE_TAG') . ')';
        return $GLOBALS['SITE_DB']->query_value_if_there($query);
    }

    /**
     * Standard Commandr-fs add function for resource-fs hooks. Adds some resource with the given label and properties.
     *
     * @param  LONG_TEXT $filename Filename OR Resource label
     * @param  string $path The path (blank: root / not applicable)
     * @param  array $properties Properties (may be empty, properties given are open to interpretation by the hook but generally correspond to database fields)
     * @return ~ID_TEXT The resource ID (false: error, could not create via these properties / here)
     */
    public function file_add($filename, $path, $properties)
    {
        list($properties, $label) = $this->_file_magic_filter($filename, $path, $properties, $this->file_resource_type);

        $tag = $this->_create_name_from_label($label);
        $title = $this->_default_property_str($properties, 'title');
        $description = $this->_default_property_str($properties, 'description');
        $replace = $this->_default_property_str($properties, 'replace');
        $example = $this->_default_property_str($properties, 'example');
        $parameters = $this->_default_property_str($properties, 'parameters');
        $enabled = $this->_default_property_int($properties, 'enabled');
        $dangerous_tag = $this->_default_property_int($properties, 'dangerous_tag');
        $block_tag = $this->_default_property_int($properties, 'block_tag');
        $textual_tag = $this->_default_property_int($properties, 'textual_tag');

        require_code('custom_comcode');
        $tag = add_custom_comcode_tag($tag, $title, $description, $replace, $example, $parameters, $enabled, $dangerous_tag, $block_tag, $textual_tag, true);

        $this->_resource_save_extend($this->file_resource_type, $tag, $filename, $label, $properties);

        return $tag;
    }

    /**
     * Standard Commandr-fs load function for resource-fs hooks. Finds the properties for some resource.
     *
     * @param  SHORT_TEXT $filename Filename
     * @param  string $path The path (blank: root / not applicable). It may be a wildcarded path, as the path is used for content-type identification only. Filenames are globally unique across a hook; you can calculate the path using ->search.
     * @return ~array Details of the resource (false: error)
     */
    public function file_load($filename, $path)
    {
        list($resource_type, $resource_id) = $this->file_convert_filename_to_id($filename);

        $rows = $GLOBALS['SITE_DB']->query_select('custom_comcode', array('*'), array('tag_tag' => $resource_id), '', 1);
        if (!array_key_exists(0, $rows)) {
            return false;
        }
        $row = $rows[0];

        $properties = array(
            'label' => $row['tag_tag'],
            'title' => get_translated_text($row['tag_title']),
            'description' => get_translated_text($row['tag_description']),
            'replace' => $row['tag_replace'],
            'example' => $row['tag_example'],
            'parameters' => $row['tag_parameters'],
            'enabled' => $row['tag_enabled'],
            'dangerous_tag' => $row['tag_dangerous_tag'],
            'block_tag' => $row['tag_block_tag'],
            'textual_tag' => $row['tag_textual_tag'],
        );
        $this->_resource_load_extend($resource_type, $resource_id, $properties, $filename, $path);
        return $properties;
    }

    /**
     * Standard Commandr-fs edit function for resource-fs hooks. Edits the resource to the given properties.
     *
     * @param  ID_TEXT $filename The filename
     * @param  string $path The path (blank: root / not applicable)
     * @param  array $properties Properties (may be empty, properties given are open to interpretation by the hook but generally correspond to database fields)
     * @return ~ID_TEXT The resource ID (false: error, could not create via these properties / here)
     */
    public function file_edit($filename, $path, $properties)
    {
        list($resource_type, $resource_id) = $this->file_convert_filename_to_id($filename);
        list($properties,) = $this->_file_magic_filter($filename, $path, $properties, $this->file_resource_type);

        $label = $this->_default_property_str($properties, 'label');
        $tag = $this->_create_name_from_label($label);
        $title = $this->_default_property_str($properties, 'title');
        $description = $this->_default_property_str($properties, 'description');
        $replace = $this->_default_property_str($properties, 'replace');
        $example = $this->_default_property_str($properties, 'example');
        $parameters = $this->_default_property_str($properties, 'parameters');
        $enabled = $this->_default_property_int($properties, 'enabled');
        $dangerous_tag = $this->_default_property_int($properties, 'dangerous_tag');
        $block_tag = $this->_default_property_int($properties, 'block_tag');
        $textual_tag = $this->_default_property_int($properties, 'textual_tag');

        $tag = edit_custom_comcode_tag($resource_id, $tag, $title, $description, $replace, $example, $parameters, $enabled, $dangerous_tag, $block_tag, $textual_tag, true);

        $this->_resource_save_extend($this->file_resource_type, $resource_id, $filename, $label, $properties);

        return $resource_id;
    }

    /**
     * Standard Commandr-fs delete function for resource-fs hooks. Deletes the resource.
     *
     * @param  ID_TEXT $filename The filename
     * @param  string $path The path (blank: root / not applicable)
     * @return boolean Success status
     */
    public function file_delete($filename, $path)
    {
        list($resource_type, $resource_id) = $this->file_convert_filename_to_id($filename);

        delete_custom_comcode_tag($resource_id);

        return true;
    }
}

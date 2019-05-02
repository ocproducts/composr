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
 * @package    newsletter
 */

require_code('resource_fs');

/**
 * Hook class.
 */
class Hook_commandr_fs_newsletters extends Resource_fs_base
{
    public $file_resource_type = 'newsletter';

    /**
     * Standard Commandr-fs function for seeing how many resources are. Useful for determining whether to do a full rebuild.
     *
     * @param  ID_TEXT $resource_type The resource type
     * @return integer How many resources there are
     */
    public function get_resources_count($resource_type)
    {
        return $GLOBALS['SITE_DB']->query_select_value('newsletters', 'COUNT(*)');
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
        $_ret = $GLOBALS['SITE_DB']->query_select('newsletters', array('id'), array($GLOBALS['SITE_DB']->translate_field_ref('title') => $label), 'ORDER BY id');
        $ret = array();
        foreach ($_ret as $r) {
            $ret[] = strval($r['id']);
        }
        return $ret;
    }

    /**
     * Whether the filesystem hook is active.
     *
     * @return boolean Whether it is
     */
    public function is_active()
    {
        return addon_installed('newsletter');
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

        require_code('newsletter');

        $description = $this->_default_property_str($properties, 'description');

        $id = add_newsletter($label, $description);

        if (isset($properties['archive'])) {
            table_from_portable_rows('newsletter_archive', $properties['archive'], array('newsletter' => $id), TABLE_REPLACE_MODE_BY_EXTRA_FIELD_DATA);
        }

        if (isset($properties['subscribers'])) {
            table_from_portable_rows('newsletter_subscribe', $properties['subscribers'], array('newsletter_id' => $id), TABLE_REPLACE_MODE_BY_EXTRA_FIELD_DATA);
        }

        $this->_resource_save_extend($this->file_resource_type, strval($id), $filename, $label, $properties);

        return strval($id);
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

        $rows = $GLOBALS['SITE_DB']->query_select('newsletters', array('*'), array('id' => intval($resource_id)), '', 1);
        if (!array_key_exists(0, $rows)) {
            return false;
        }
        $row = $rows[0];

        $properties = array(
            'label' => get_translated_text($row['title']),
            'description' => get_translated_text($row['description']),
            'archive' => table_to_portable_rows('newsletter_archive', /*skip*/array('id'), array('newsletter' => intval($resource_id))),
            'subscribers' => table_to_portable_rows('newsletter_subscribe', /*skip*/array(), array('newsletter_id' => intval($resource_id))),
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

        require_code('newsletter');

        $label = $this->_default_property_str($properties, 'label');
        $description = $this->_default_property_str($properties, 'description');

        edit_newsletter(intval($resource_id), $label, $description);

        if (isset($properties['archive'])) {
            table_from_portable_rows('newsletter_archive', $properties['archive'], array('newsletter' => intval($resource_id)), TABLE_REPLACE_MODE_BY_EXTRA_FIELD_DATA);
        }

        if (isset($properties['subscribers'])) {
            table_from_portable_rows('newsletter_subscribe', $properties['subscribers'], array('newsletter_id' => intval($resource_id)), TABLE_REPLACE_MODE_BY_EXTRA_FIELD_DATA);
        }

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

        require_code('newsletter');
        delete_newsletter(intval($resource_id));

        return true;
    }
}

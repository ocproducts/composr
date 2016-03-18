<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    galleries
 */

require_code('resource_fs');

/**
 * Hook class.
 */
class Hook_commandr_fs_galleries extends Resource_fs_base
{
    public $folder_resource_type = 'gallery';
    public $file_resource_type = array('image', 'video');

    /**
     * Standard Commandr-fs function for seeing how many resources are. Useful for determining whether to do a full rebuild.
     *
     * @param  ID_TEXT $resource_type The resource type
     * @return integer How many resources there are
     */
    public function get_resources_count($resource_type)
    {
        switch ($resource_type) {
            case 'image':
            case 'video':
                return $GLOBALS['SITE_DB']->query_select_value($resource_type . 's', 'COUNT(*)');

            case 'gallery':
                return $GLOBALS['SITE_DB']->query_select_value('galleries', 'COUNT(*)');
        }
        return 0;
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
        switch ($resource_type) {
            case 'image':
            case 'video':
                $_ret = $GLOBALS['SITE_DB']->query_select($resource_type . 's', array('id'), array($GLOBALS['SITE_DB']->translate_field_ref('title') => $label), 'ORDER BY id');
                $ret = array();
                foreach ($_ret as $r) {
                    $ret[] = strval($r['id']);
                }
                return $ret;

            case 'gallery':
                $ret = $GLOBALS['SITE_DB']->query_select('galleries', array('name'), array($GLOBALS['SITE_DB']->translate_field_ref('fullname') => $label));
                return collapse_1d_complexity('name', $ret);
        }
        return array();
    }

    /**
     * Standard Commandr-fs date fetch function for resource-fs hooks. Defined when getting an edit date is not easy.
     *
     * @param  array $row Resource row (not full, but does contain the ID)
     * @return ?TIME The edit date or add date, whichever is higher (null: could not find one)
     */
    protected function _get_folder_edit_date($row)
    {
        $query = 'SELECT MAX(date_and_time) FROM ' . get_table_prefix() . 'actionlogs WHERE ' . db_string_equal_to('param_a', $row['name']) . ' AND  (' . db_string_equal_to('the_type', 'ADD_GALLERY') . ' OR ' . db_string_equal_to('the_type', 'EDIT_GALLERY') . ')';
        return $GLOBALS['SITE_DB']->query_value_if_there($query);
    }

    /**
     * Standard Commandr-fs add function for resource-fs hooks. Adds some resource with the given label and properties.
     *
     * @param  LONG_TEXT $filename Filename OR Resource label
     * @param  string $path The path (blank: root / not applicable)
     * @param  array $properties Properties (may be empty, properties given are open to interpretation by the hook but generally correspond to database fields)
     * @return ~ID_TEXT The resource ID (false: error)
     */
    public function folder_add($filename, $path, $properties)
    {
        list($category_resource_type, $category) = $this->folder_convert_filename_to_id($path);
        if ($category == '') {
            $category = 'root';
        }/*return false;*/ // Can't create more than one root

        list($properties, $label) = $this->_folder_magic_filter($filename, $path, $properties, $this->folder_resource_type);

        require_code('galleries2');

        $name = $this->_default_property_str($properties, 'name'); // We don't use name for the label, although we do default name from label. Without other resource types we do use codenames as labels as often there is no other choice of label (even if there is a title, it's often optional).
        if ($name == '') {
            $name = $this->_create_name_from_label($label);
        }
        $description = $this->_default_property_str($properties, 'description');
        $notes = $this->_default_property_str($properties, 'notes');
        $parent_id = $category;
        $accept_images = $this->_default_property_int_modeavg($properties, 'accept_images', 'galleries', 1);
        $accept_videos = $this->_default_property_int_modeavg($properties, 'accept_videos', 'galleries', 1);
        $is_member_synched = $this->_default_property_int($properties, 'is_member_synched');
        $flow_mode_interface = $this->_default_property_int($properties, 'flow_mode_interface');
        $rep_image = $this->_default_property_urlpath($properties, 'rep_image');
        $watermark_top_left = $this->_default_property_urlpath($properties, 'watermark_top_left');
        $watermark_top_right = $this->_default_property_urlpath($properties, 'watermark_top_right');
        $watermark_bottom_left = $this->_default_property_urlpath($properties, 'watermark_bottom_left');
        $watermark_bottom_right = $this->_default_property_urlpath($properties, 'watermark_bottom_right');
        $allow_rating = $this->_default_property_int_modeavg($properties, 'allow_rating', 'galleries', 1);
        $allow_comments = $this->_default_property_int_modeavg($properties, 'allow_comments', 'galleries', 1);
        $add_date = $this->_default_property_time($properties, 'add_date');
        $g_owner = $this->_default_property_member_null($properties, 'owner');
        $meta_keywords = $this->_default_property_str($properties, 'meta_keywords');
        $meta_description = $this->_default_property_str($properties, 'meta_description');
        $name = add_gallery($name, $label, $description, $notes, $parent_id, $accept_images, $accept_videos, $is_member_synched, $flow_mode_interface, $rep_image, $watermark_top_left, $watermark_top_right, $watermark_bottom_left, $watermark_bottom_right, $allow_rating, $allow_comments, false, $add_date, $g_owner, $meta_keywords, $meta_description, true);

        $this->_resource_save_extend($this->folder_resource_type, $name, $filename, $label, $properties);

        return $name;
    }

    /**
     * Standard Commandr-fs load function for resource-fs hooks. Finds the properties for some resource.
     *
     * @param  SHORT_TEXT $filename Filename
     * @param  string $path The path (blank: root / not applicable). It may be a wildcarded path, as the path is used for content-type identification only. Filenames are globally unique across a hook; you can calculate the path using ->search.
     * @return ~array Details of the resource (false: error)
     */
    public function folder_load($filename, $path)
    {
        list($resource_type, $resource_id) = $this->folder_convert_filename_to_id($filename);

        $rows = $GLOBALS['SITE_DB']->query_select('galleries', array('*'), array('name' => $resource_id), '', 1);
        if (!array_key_exists(0, $rows)) {
            return false;
        }
        $row = $rows[0];

        list($meta_keywords, $meta_description) = seo_meta_get_for($resource_type, strval($row['id']));

        $properties = array(
            'label' => get_translated_text($row['fullname']),
            'name' => $row['name'],
            'description' => get_translated_text($row['description']),
            'notes' => $row['notes'],
            'accept_images' => $row['accept_images'],
            'accept_videos' => $row['accept_videos'],
            'is_member_synched' => $row['is_member_synched'],
            'flow_mode_interface' => $row['flow_mode_interface'],
            'rep_image' => remap_urlpath_as_portable($row['rep_image']),
            'watermark_top_left' => remap_urlpath_as_portable($row['watermark_top_left']),
            'watermark_top_right' => remap_urlpath_as_portable($row['watermark_top_right']),
            'watermark_bottom_left' => remap_urlpath_as_portable($row['watermark_bottom_left']),
            'watermark_bottom_right' => remap_urlpath_as_portable($row['watermark_bottom_right']),
            'allow_rating' => $row['allow_rating'],
            'allow_comments' => $row['allow_comments'],
            'add_date' => remap_time_as_portable($row['add_date']),
            'owner' => remap_resource_id_as_portable('member', $row['g_owner']),
            'meta_keywords' => $meta_keywords,
            'meta_description' => $meta_description,
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
    public function folder_edit($filename, $path, $properties)
    {
        list($category_resource_type, $category) = $this->folder_convert_filename_to_id($path);
        list($resource_type, $resource_id) = $this->folder_convert_filename_to_id($filename);
        list($properties, $label) = $this->_folder_magic_filter($filename, $path, $properties, $this->folder_resource_type);

        require_code('galleries2');

        $label = $this->_default_property_str($properties, 'label');
        $name = $this->_default_property_str_null($properties, 'name');
        if ($name === null) {
            $name = $this->_create_name_from_label($label);
        }
        $description = $this->_default_property_str($properties, 'description');
        $notes = $this->_default_property_str($properties, 'notes');
        $parent_id = $category;
        $accept_images = $this->_default_property_int_modeavg($properties, 'accept_images', 'galleries', 1);
        $accept_videos = $this->_default_property_int_modeavg($properties, 'accept_videos', 'galleries', 1);
        $is_member_synched = $this->_default_property_int($properties, 'is_member_synched');
        $flow_mode_interface = $this->_default_property_int($properties, 'flow_mode_interface');
        $rep_image = $this->_default_property_urlpath($properties, 'rep_image', true);
        $watermark_top_left = $this->_default_property_urlpath($properties, 'watermark_top_left', true);
        $watermark_top_right = $this->_default_property_urlpath($properties, 'watermark_top_right', true);
        $watermark_bottom_left = $this->_default_property_urlpath($properties, 'watermark_bottom_left', true);
        $watermark_bottom_right = $this->_default_property_urlpath($properties, 'watermark_bottom_right', true);
        $allow_rating = $this->_default_property_int_modeavg($properties, 'allow_rating', 'galleries', 1);
        $allow_comments = $this->_default_property_int_modeavg($properties, 'allow_comments', 'galleries', 1);
        $add_time = $this->_default_property_time($properties, 'add_date');
        $g_owner = $this->_default_property_member_null($properties, 'owner');
        $meta_keywords = $this->_default_property_str($properties, 'meta_keywords');
        $meta_description = $this->_default_property_str($properties, 'meta_description');

        $name = edit_gallery($resource_id, $name, $label, $description, $notes, $parent_id, $accept_images, $accept_videos, $is_member_synched, $flow_mode_interface, $rep_image, $watermark_top_left, $watermark_top_right, $watermark_bottom_left, $watermark_bottom_right, $meta_keywords, $meta_description, $allow_rating, $allow_comments, $g_owner, $add_time, true, true);

        $this->_resource_save_extend($this->folder_resource_type, $name, $filename, $label, $properties);

        return $name;
    }

    /**
     * Standard Commandr-fs delete function for resource-fs hooks. Deletes the resource.
     *
     * @param  ID_TEXT $filename The filename
     * @param  string $path The path (blank: root / not applicable)
     * @return boolean Success status
     */
    public function folder_delete($filename, $path)
    {
        list($resource_type, $resource_id) = $this->folder_convert_filename_to_id($filename);

        require_code('galleries2');
        delete_gallery($resource_id);

        return true;
    }

    /**
     * Get the filename for a resource ID. Note that filenames are unique across all folders in a filesystem.
     *
     * @param  ID_TEXT $resource_type The resource type
     * @param  ID_TEXT $resource_id The resource ID
     * @return ID_TEXT The filename
     */
    public function file_convert_id_to_filename($resource_type, $resource_id)
    {
        if ($resource_type == 'video') {
            return 'VIDEO-' . parent::file_convert_id_to_filename($resource_type, $resource_id, 'video');
        }

        return parent::file_convert_id_to_filename($resource_type, $resource_id);
    }

    /**
     * Get the resource ID for a filename. Note that filenames are unique across all folders in a filesystem.
     *
     * @param  ID_TEXT $filename The filename, or filepath
     * @return array A pair: The resource type, the resource ID
     */
    public function file_convert_filename_to_id($filename)
    {
        if (substr($filename, 0, 6) == 'VIDEO-') {
            return parent::file_convert_filename_to_id(substr($filename, 6), 'video');
        }

        return parent::file_convert_filename_to_id($filename, 'image');
    }

    /**
     * Standard Commandr-fs add function for resource-fs hooks. Adds some resource with the given label and properties.
     *
     * @param  LONG_TEXT $filename Filename OR Resource label
     * @param  string $path The path (blank: root / not applicable)
     * @param  array $properties Properties (may be empty, properties given are open to interpretation by the hook but generally correspond to database fields)
     * @param  ?ID_TEXT $force_type Resource type to try to force (null: do not force)
     * @return ~ID_TEXT The resource ID (false: error, could not create via these properties / here)
     */
    public function file_add($filename, $path, $properties, $force_type = null)
    {
        list($category_resource_type, $category) = $this->folder_convert_filename_to_id($path);

        if (is_null($category)) {
            return false; // Folder not found
        }

        require_code('galleries2');

        $is_image = (((empty($properties['url'])) || (is_image($properties['url']))) && (empty($properties['video_length'])) || ($force_type === 'image')) && ($force_type !== 'video');

        list($properties, $label) = $this->_file_magic_filter($filename, $path, $properties, $is_image ? 'image' : 'video');

        $description = $this->_default_property_str($properties, 'description');
        $url = $this->_default_property_urlpath($properties, 'url');
        $thumb_url = $this->_default_property_urlpath($properties, 'thumb_url');
        $validated = $this->_default_property_int_null($properties, 'validated');
        if (is_null($validated)) {
            $validated = 1;
        }
        $notes = $this->_default_property_str($properties, 'notes');
        $submitter = $this->_default_property_member($properties, 'submitter');
        $add_date = $this->_default_property_time($properties, 'add_date');
        $edit_date = $this->_default_property_time_null($properties, 'edit_date');
        $views = $this->_default_property_int($properties, 'views');
        $meta_keywords = $this->_default_property_str($properties, 'meta_keywords');
        $meta_description = $this->_default_property_str($properties, 'meta_description');
        $regions = empty($properties['regions']) ? array() : $properties['regions'];

        require_code('images');
        if ($is_image) {
            $allow_rating = $this->_default_property_int_modeavg($properties, 'allow_rating', 'images', 1);
            $allow_comments = $this->_default_property_int_modeavg($properties, 'allow_comments', 'images', 1);
            $allow_trackbacks = $this->_default_property_int_modeavg($properties, 'allow_trackbacks', 'images', 1);

            $accept_images = $GLOBALS['SITE_DB']->query_select_value_if_there('galleries', 'accept_images', array('name' => $category));
            if ($accept_images === 0) {
                return false;
            }

            $id = add_image($label, $category, $description, $url, $thumb_url, $validated, $allow_rating, $allow_comments, $allow_trackbacks, $notes, $submitter, $add_date, $edit_date, $views, null, $meta_keywords, $meta_description, $regions);

            $this->_resource_save_extend('image', strval($id), $filename, $label, $properties);
        } else {
            $allow_rating = $this->_default_property_int_modeavg($properties, 'allow_rating', 'videos', 1);
            $allow_comments = $this->_default_property_int_modeavg($properties, 'allow_comments', 'videos', 1);
            $allow_trackbacks = $this->_default_property_int_modeavg($properties, 'allow_trackbacks', 'videos', 1);

            $accept_videos = $GLOBALS['SITE_DB']->query_select_value_if_there('galleries', 'accept_videos', array('name' => $category));
            if ($accept_videos === 0) {
                return false;
            }

            $video_length = $this->_default_property_int($properties, 'video_length');
            $video_width = $this->_default_property_int_null($properties, 'video_width');
            if (is_null($video_width)) {
                $video_width = 720;
            }
            $video_height = $this->_default_property_int_null($properties, 'video_height');
            if (is_null($video_height)) {
                $video_height = 576;
            }

            $id = add_video($label, $category, $description, $url, $thumb_url, $validated, $allow_rating, $allow_comments, $allow_trackbacks, $notes, $video_length, $video_width, $video_height, $submitter, $add_date, $edit_date, $views, null, $meta_keywords, $meta_description, $regions);

            $this->_resource_save_extend('video', strval($id), $filename, $label, $properties);
        }

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

        $rows = $GLOBALS['SITE_DB']->query_select($resource_type . 's', array('*'), array('id' => intval($resource_id)), '', 1);
        if (!array_key_exists(0, $rows)) {
            return false;
        }
        $row = $rows[0];

        list($meta_keywords, $meta_description) = seo_meta_get_for($resource_type, strval($row['id']));

        $properties = array(
            'label' => get_translated_text($row['title']),
            'description' => get_translated_text($row['description']),
            'url' => remap_urlpath_as_portable($row['url']),
            'thumb_url' => remap_urlpath_as_portable($row['thumb_url']),
            'validated' => $row['validated'],
            'allow_rating' => $row['allow_rating'],
            'allow_comments' => $row['allow_comments'],
            'allow_trackbacks' => $row['allow_trackbacks'],
            'notes' => $row['notes'],
            'meta_keywords' => $meta_keywords,
            'meta_description' => $meta_description,
            'submitter' => remap_resource_id_as_portable('member', $row['submitter']),
            'add_date' => remap_time_as_portable($row['add_date']),
            'edit_date' => remap_time_as_portable($row['edit_date']),
            'regions' => collapse_1d_complexity('region', $GLOBALS['SITE_DB']->query_select('content_regions', array('region'), array('content_type' => $resource_type, 'content_id' => strval($row['id'])))),
        );
        $this->_resource_load_extend($resource_type, $resource_id, $properties, $filename, $path);

        if ($resource_type == 'video') {
            $properties += array(
                'views' => $row['video_views'],
                'video_length' => $row['video_length'],
                'video_width' => $row['video_width'],
                'video_height' => $row['video_height'],
            );
        } else {
            $properties += array(
                'views' => $row['image_views'],
            );
        }

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
        list($category_resource_type, $category) = $this->folder_convert_filename_to_id($path);

        list($properties,) = $this->_file_magic_filter($filename, $path, $properties, $resource_type);

        if (is_null($category)) {
            return false; // Folder not found
        }

        require_code('galleries2');

        $label = $this->_default_property_str($properties, 'label');
        $description = $this->_default_property_str($properties, 'description');
        $url = $this->_default_property_urlpath($properties, 'url', true);
        $thumb_url = $this->_default_property_urlpath($properties, 'thumb_url', true);
        $validated = $this->_default_property_int_null($properties, 'validated');
        if (is_null($validated)) {
            $validated = 1;
        }
        $notes = $this->_default_property_str($properties, 'notes');
        $submitter = $this->_default_property_member($properties, 'submitter');
        $add_time = $this->_default_property_time($properties, 'add_date');
        $edit_time = $this->_default_property_time($properties, 'edit_date');
        $views = $this->_default_property_int($properties, 'views');
        $meta_keywords = $this->_default_property_str($properties, 'meta_keywords');
        $meta_description = $this->_default_property_str($properties, 'meta_description');
        $regions = empty($properties['regions']) ? array() : $properties['regions'];

        if ($resource_type == 'image') {
            $allow_rating = $this->_default_property_int_modeavg($properties, 'allow_rating', 'images', 1);
            $allow_comments = $this->_default_property_int_modeavg($properties, 'allow_comments', 'images', 1);
            $allow_trackbacks = $this->_default_property_int_modeavg($properties, 'allow_trackbacks', 'images', 1);

            $accept_images = $GLOBALS['SITE_DB']->query_select_value_if_there('galleries', 'accept_images', array('name' => $category));
            if ($accept_images === 0) {
                return false;
            }

            edit_image(intval($resource_id), $label, $category, $description, $url, $thumb_url, $validated, $allow_rating, $allow_comments, $allow_trackbacks, $notes, $meta_keywords, $meta_description, $edit_time, $add_time, $views, $submitter, $regions, true);

            $this->_resource_save_extend('image', $resource_id, $filename, $label, $properties);
        } else {
            $allow_rating = $this->_default_property_int_modeavg($properties, 'allow_rating', 'videos', 1);
            $allow_comments = $this->_default_property_int_modeavg($properties, 'allow_comments', 'videos', 1);
            $allow_trackbacks = $this->_default_property_int_modeavg($properties, 'allow_trackbacks', 'videos', 1);

            $accept_videos = $GLOBALS['SITE_DB']->query_select_value_if_there('galleries', 'accept_videos', array('name' => $category));
            if ($accept_videos === 0) {
                return false;
            }

            $video_length = $this->_default_property_int($properties, 'video_length');
            $video_width = $this->_default_property_int_null($properties, 'video_width');
            if (is_null($video_width)) {
                $video_width = 720;
            }
            $video_height = $this->_default_property_int_null($properties, 'video_height');
            if (is_null($video_height)) {
                $video_height = 576;
            }

            edit_video(intval($resource_id), $label, $category, $description, $url, $thumb_url, $validated, $allow_rating, $allow_comments, $allow_trackbacks, $notes, $video_length, $video_width, $video_height, $meta_keywords, $meta_description, $edit_time, $add_time, $views, $submitter, $regions, true);

            $this->_resource_save_extend('video', $resource_id, $filename, $label, $properties);
        }

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

        require_code('galleries2');
        require_code('images');
        if ($resource_type == 'image') {
            delete_image(intval($resource_id));
        } else {
            delete_video(intval($resource_id));
        }

        return true;
    }
}

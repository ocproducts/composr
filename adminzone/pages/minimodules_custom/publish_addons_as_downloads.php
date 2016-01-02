<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    addon_publish
 */

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

// Find existing category ID for a named category. Insert into the database if the category does not exist
function find_addon_category_download_category($category_name, $parent_id = null)
{
    if (is_null($parent_id)) {
        $parent_id = db_get_first_id();
    }

    require_code('downloads2');
    $id = $GLOBALS['SITE_DB']->query_select_value_if_there('download_categories', 'id', array('parent_id' => $parent_id, $GLOBALS['SITE_DB']->translate_field_ref('category') => $category_name));
    if (is_null($id)) {
        $description = '';
        switch ($category_name) {
            // Some categories may have hard-coded default descriptions. Any others will default to blank.
            case 'Themes':
                $description = "Themes provide a new look to Composr.\n\nThemes are a kind of addon. You can actually install the themes listed here directly from inside Composr.\n\nGo to Admin Zone > Structure > Addons. Follow the \"Import non-bundled addon(s)\" link.\n\nThese are themes that have been released for this version of Composr. Themes that have been released for earlier versions would need upgrading -- you may wish to browse through them also, and contact the author if you\'d like them upgraded.";
                break;
        }

        $cat_id = add_download_category($category_name, $parent_id, $description, '', '');
        require_code('permissions2');
        set_global_category_access('downloads', $cat_id);
        return $cat_id;
    }

    return $id;
}

function get_addons_list_under_category($category_name)
{
    $addons_here = array();

    $addons = find_all_hooks('systems', 'addon_registry');
    foreach ($addons as $addon => $place) {
        if ($place == 'sources_custom') {
            require_code('hooks/systems/addon_registry/' . $addon);
            $ob = object_factory('Hook_addon_registry_' . $addon);
            if (method_exists($ob, 'get_category')) {
                $category_name_here = $ob->get_category();
            } else {
                $category_name_here = 'Uncategorised/Unstable';
            }

            if ($category_name_here == $category_name) {
                $addons_here[] = $addon;
            }
        }
    }

    return $addons_here;
}

// Returns list of categories
function find_addon_category_list()
{
    $categories = array();

    $addons = find_all_hooks('systems', 'addon_registry');
    foreach ($addons as $addon => $place) {
        if ($place == 'sources_custom') {
            require_code('hooks/systems/addon_registry/' . $addon);
            $ob = object_factory('Hook_addon_registry_' . $addon);
            if (method_exists($ob, 'get_category')) {
                $category_name = $ob->get_category();
            } else {
                $category_name = 'Uncategorised/Unstable';
            }

            $categories[] = $category_name;
        }
    }

    return array_unique($categories);
}

define('DOWNLOAD_OWNER', 2); // Hard-coded ID of user that gets ownership of the downloads

require_code('addons2');
require_code('version');
require_code('version2');
require_code('downloads2');
require_code('files');
require_code('tar');

$target_cat = get_param_string('cat', null);
if ($target_cat === null) {
    exit('Please pass the target category name in the URL (?cat=name).');
}
$version_branch = get_param_string('version_branch', null);
if ($version_branch === null) {
    exit('Please pass the branch version in the URL (?version_branch=num.x).');
}

$parent_id = $GLOBALS['SITE_DB']->query_select_value_if_there('download_categories', 'id', array('parent_id' => 1, $GLOBALS['SITE_DB']->translate_field_ref('category') => 'Addons'));
$c_main_id = find_addon_category_download_category($target_cat, $parent_id);

// Addons...

if (get_param_integer('import_addons', 1) == 1) {
    $addon_count = 0;

    $categories = find_addon_category_list();
    foreach ($categories as $category) {
        $cid = find_addon_category_download_category($category, $c_main_id);
        $addon_arr = get_addons_list_under_category($category);
        foreach ($addon_arr as $addon) {
            $addon_count++;

            $file = $addon . '-' . $version_branch . '.tar';
            $from = get_custom_file_base() . '/exports/addons/' . $addon . '-' . $version_branch . '.tar';
            $to = get_custom_file_base() . '/uploads/downloads/' . $file;
            @unlink($to);
            if (!file_exists($from)) {
                warn_exit('Missing: ' . $from);
            }
            if (!file_exists($to)) {
                copy($from, $to);
            }

            $addon_url = 'uploads/downloads/' . urlencode($file);

            $fsize = filesize(get_file_base() . '/' . urldecode($addon_url));

            $test = $GLOBALS['SITE_DB']->query_select_value_if_there('download_downloads', 'url', array('url' => $addon_url));
            if (is_null($test)) {
                $tar = tar_open($from, 'rb');
                $info_file = tar_get_file($tar, 'addon.inf', true);
                $info = better_parse_ini_file(null, $info_file['data']);
                tar_close($tar);

                $name = titleify($info['name']);
                $description = $info['description'];
                $author = $info['author'];
                $dependencies = $info['dependencies'];
                $incompatibilities = $info['incompatibilities'];
                $category = $info['category'];
                $licence = $info['licence'];
                $copyright_attribution = implode("\n", $info['copyright_attribution']);

                if ($dependencies != '') {
                    $description .= "\n\n[title=\"2\"]System Requirements / Dependencies[/title]\n\n" . $dependencies;
                }
                if ($incompatibilities != '') {
                    $description .= "\n\n[title=\"2\"]Incompatibilities[/title]\n\n" . $incompatibilities;
                }
                if ($licence != '') {
                    $description .= "\n\n[title=\"2\"]Licence[/title]\n\n" . $licence;
                }
                if ($copyright_attribution != '') {
                    $description .= "\n\n[title=\"2\"]Additional credits/attributions[/title]\n\n" . $copyright_attribution;
                }

                $download_owner = $GLOBALS['FORUM_DRIVER']->get_member_from_username($author);
                if (is_null($download_owner)) {
                    $download_owner = DOWNLOAD_OWNER;
                }
                $download_id = add_download($cid, $name, $addon_url, $description, $author, '', null, 1, 1, 2, 1, '', $addon . '.tar', $fsize, 0, 0, null, null, 0, 0, $download_owner);

                $screenshot_url = 'data_custom/images/addon_screenshots/' . $addon . '.png';
                if (file_exists(get_custom_file_base() . '/' . $screenshot_url)) {
                    add_image('', 'download_' . strval($download_id), '', $screenshot_url, '', 1, 0, 0, 0, '', null, null, null, 0);
                }
            }
        }
    }

    if ($addon_count == 0) {
        echo '<p>No addons to import</p>';
    } else {
        echo '<p>All addons have been imported as downloads</p>';
    }
}

// Now themes...

if (get_param_integer('import_themes', 1) == 1) {
    $cid = find_addon_category_download_category('Themes', $c_main_id);
    $cid = find_addon_category_download_category('Professional Themes', $cid);

    $dh = opendir(get_custom_file_base() . '/exports/addons');
    $theme_count = 0;
    while (($file = readdir($dh)) !== false) {
        if (preg_match('#^theme-.*\.tar$#', $file) != 0) {
            $theme_count++;

            $from = get_custom_file_base() . '/exports/addons/' . $file;
            $new_file = basename($file, '.tar') . '-' . $version_branch . '.tar';
            $to = get_custom_file_base() . '/uploads/downloads/' . $new_file;
            @unlink($to);
            copy($from, $to);
            $addon_url = 'uploads/downloads/' . urlencode($new_file);

            $fsize = filesize(get_file_base() . '/' . urldecode($addon_url));

            $test = $GLOBALS['SITE_DB']->query_select_value_if_there('download_downloads', 'url', array('url' => $addon_url));
            if (is_null($test)) {
                $tar = tar_open($from, 'rb');
                $info_file = tar_get_file($tar, 'addon.inf', true);
                $info = better_parse_ini_file(null, $info_file['data']);
                tar_close($tar);

                $name = $info['name'];
                $description = $info['description'];
                $author = $info['author'];

                $download_owner = $GLOBALS['FORUM_DRIVER']->get_member_from_username($author);
                if (is_null($download_owner)) {
                    $download_owner = DOWNLOAD_OWNER;
                }
                $download_id = add_download($cid, $name, $addon_url, $description, $author, '', null, 1, 1, 2, 1, '', $new_file, $fsize, 0, 0, null, null, 0, 0, $download_owner);

                $screenshot_url = 'data_custom/images/addon_screenshots/' . urlencode(preg_replace('#^theme-#', 'theme__', preg_replace('#\d+$#', '', basename($file, '.tar'))) . '.png');
                if (file_exists(get_custom_file_base() . '/' . $screenshot_url)) {
                    add_image('', 'download_' . strval($download_id), '', $screenshot_url, '', 1, 0, 0, 0, '', null, null, null, 0);
                }
            }
        }
    }
    closedir($dh);

    if ($theme_count == 0) {
        echo '<p>No themes to import</p>';
    } else {
        echo '<p>All themes have been imported as downloads</p>';
    }
}

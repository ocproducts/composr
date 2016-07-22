<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    addon_publish
 */

// Find existing category ID for a named category. Insert into the database if the category does not exist
function find_addon_category_download_category($category_name, $parent_id = null/*null means under "Addons" category*/, $description = null)
{
    static $cache = array();

    if (isset($cache[$category_name][$parent_id])) {
        return $cache[$category_name][$parent_id];
    }

    if ($parent_id === null) {
        $parent_id = $GLOBALS['SITE_DB']->query_select_value('download_categories', 'id', array('parent_id' => db_get_first_id(), $GLOBALS['SITE_DB']->translate_field_ref('category') => 'Addons'));
        // ^ Result must return, composr_homesite_install.php added the category

        if (isset($cache[$category_name][$parent_id])) {
            return $cache[$category_name][$parent_id];
        }

        if ($description === null) {
            // Copy version category description from parent ("Addons")
            $description = get_translated_text($GLOBALS['SITE_DB']->query_select_value('download_categories', 'description', array('id' => $parent_id)));
            $description = str_replace('[title="2"]Choose Composr version below[/title]', '[title="2"]Choose addon category below[/title]', $description);
        }
    }

    require_code('downloads2');
    $id = $GLOBALS['SITE_DB']->query_select_value_if_there('download_categories', 'id', array('parent_id' => $parent_id, $GLOBALS['SITE_DB']->translate_field_ref('category') => $category_name));
    if ($id === null) {
        // Missing, add it...

        if ($description === null) {
            $description = '';
            switch ($category_name) {
                // Some categories may have hard-coded default descriptions. Any others will default to blank.
                case 'Themes':
                    $description = "Themes provide a new look to Composr.\n\nThemes are a kind of addon. You can actually install the themes listed here directly from inside Composr.\n\nGo to Admin Zone > Structure > Addons. Follow the \"Import non-bundled addon(s)\" link.\n\nThese are themes that have been released for this version of Composr. Themes that have been released for earlier versions would need upgrading -- you may wish to browse through them also, and contact the author if you\'d like them upgraded.";
                    break;
            }
        }

        if (substr($category_name, 0, 8) == 'Version ') {
            $theme_image = 'tutorial_icons/installation';
        } else {
            switch ($category_name) {
                case 'Addons':
                    $theme_image = 'tutorial_icons/addon';
                    break;

                case 'Composr Releases':
                    $theme_image = 'tutorial_icons/installation';
                    break;

                case 'Admin Utilities':
                    $theme_image = 'tutorial_icons/administration';
                    break;

                case 'Development':
                    $theme_image = 'tutorial_icons/development';
                    break;

                case 'Fun and Games':
                    $theme_image = 'tutorial_icons/fun_and_games';
                    break;

                case 'Graphical':
                    $theme_image = 'tutorial_icons/galleries';
                    break;

                case 'Information Display':
                    $theme_image = 'tutorial_icons/configuration';
                    break;

                case 'New Features':
                    $theme_image = 'tutorial_icons/upgrading';
                    break;

                case 'Themes':
                    $theme_image = 'tutorial_icons/design_and_themeing';
                    break;

                case 'Professional Themes':
                    $theme_image = 'tutorial_icons/ecommerce';
                    break;

                case 'Third Party Integration':
                    $theme_image = 'tutorial_icons/third_party_integration';
                    break;

                case 'Translations':
                    $theme_image = 'tutorial_icons/internationalisation';
                    break;

                case 'Uncategorised/Alpha':
                    $theme_image = 'tutorial_icons/maintenance';
                    break;

                default:
                    $theme_image = 'tutorial_icons/' . strtolower(str_replace(' ', '_', $category_name));
                    break;
            }
        }
        $rep_image = find_theme_image($theme_image, true, true);
        if ($rep_image == '') {
            fatal_exit('Could not find a theme image, ' . $theme_image);
        }

        $id = add_download_category($category_name, $parent_id, $description, '', $rep_image);
        require_code('permissions2');
        set_global_category_access('downloads', $id);
    }

    $cache[$category_name][$parent_id] = $id;

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
                $category_name_here = 'Uncategorised/Alpha';
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
                $category_name = 'Uncategorised/Alpha';
            }

            $categories[] = $category_name;
        }
    }

    return array_unique($categories);
}


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
 * @package    core
 */

/**
 * An option has disappeared somehow - find it via searching our code-base for it's install code. It doesn't get returned, just loaded up. This function will produce a fatal error if we cannot find it.
 *
 * @return boolean Whether to run in multi-lang mode
 *
 * @ignore
 */
function _multi_lang()
{
    global $MULTI_LANG_CACHE;

    $_dir = opendir(get_file_base() . '/lang/');
    $_langs = array();
    while (false !== ($file = readdir($_dir))) {
        if (($file != fallback_lang()) && ($file[0] != '.') && ($file[0] != '_') && ($file != 'index.html') && ($file != 'langs.ini') && ($file != 'map.ini')) {
            if (is_dir(get_file_base() . '/lang/' . $file)) {
                $_langs[$file] = 'lang';
            }
        }
    }
    closedir($_dir);
    if (!in_safe_mode()) {
        $_dir = @opendir(get_custom_file_base() . '/lang_custom/');
        if ($_dir !== false) {
            while (false !== ($file = readdir($_dir))) {
                if (($file != fallback_lang()) && ($file[0] != '.') && ($file[0] != '_') && ($file != 'index.html') && ($file != 'langs.ini') && ($file != 'map.ini') && (!isset($_langs[$file]))) {
                    if (is_dir(get_custom_file_base() . '/lang_custom/' . $file)) {
                        $_langs[$file] = 'lang_custom';
                    }
                }
            }
            closedir($_dir);
        }
        if (get_custom_file_base() != get_file_base()) {
            $_dir = @opendir(get_file_base() . '/lang_custom/');
            if ($_dir !== false) {
                while (false !== ($file = readdir($_dir))) {
                    if (($file != fallback_lang()) && ($file[0] != '.') && ($file[0] != '_') && ($file != 'index.html') && ($file != 'langs.ini') && ($file != 'map.ini') && (!isset($_langs[$file]))) {
                        if (is_dir(get_file_base() . '/lang_custom/' . $file)) {
                            $_langs[$file] = 'lang_custom';
                        }
                    }
                }
                closedir($_dir);
            }
        }
    }

    foreach ($_langs as $lang => $dir) {
        if (/*optimisation*/is_file((($dir == 'lang_custom') ? get_custom_file_base() : get_file_base()) . '/' . $dir . '/' . $lang . '/global.ini')) {
            $MULTI_LANG_CACHE = true;
            break;
        }

        $_dir2 = @opendir((($dir == 'lang_custom') ? get_custom_file_base() : get_file_base()) . '/' . $dir . '/' . $lang);
        if ($_dir2 !== false) {
            while (false !== ($file2 = readdir($_dir2))) {
                if (substr($file2, -4) == '.ini') {
                    $MULTI_LANG_CACHE = true;
                    break;
                }
            }
            closedir($_dir2);
        }
    }

    return $MULTI_LANG_CACHE;
}

/**
 * Get the default value of a config option.
 *
 * @param  ID_TEXT $name The name of the option
 * @return ?SHORT_TEXT The value (null: disabled)
 */
function get_default_option($name)
{
    $path = 'hooks/systems/config/' . filter_naughty_harsh($name, true);
    if (!is_file(get_file_base() . '/sources/' . $path . '.php') && !is_file(get_file_base() . '/sources_custom/' . $path . '.php')) {
        return null;
    }

    require_code($path);
    $ob = object_factory('Hook_config_' . filter_naughty_harsh($name, true));

    $value = $ob->get_default();
    if ($value === null) {
        $value = ''; // Cannot save a null. We don't need to save as null anyway, options are only disabled when they wouldn't have been used anyway
    }

    return $value;
}

/**
 * Set a configuration option with the specified values.
 * Note that you may wish to also empty the template cache after running this function. Config options may have been set into template(s).
 *
 * @param  ID_TEXT $name The name of the value
 * @param  LONG_TEXT $value The value
 * @param  BINARY $will_be_formally_set Whether this was a human-set value
 */
function set_option($name, $value, $will_be_formally_set = 1)
{
    global $CONFIG_OPTIONS_CACHE;

    if ($will_be_formally_set == 1) {
        $previous_value = get_option($name);
    }

    require_code('hooks/systems/config/' . filter_naughty_harsh($name));
    $ob = object_factory('Hook_config_' . filter_naughty_harsh($name), true);
    if ($ob === null) {
        return;
    }
    $option = $ob->get_details();

    $needs_dereference = ($option['type'] == 'transtext' || $option['type'] == 'transline' || $option['type'] == 'comcodetext' || $option['type'] == 'comcodeline') ? 1 : 0;

    if (!isset($CONFIG_OPTIONS_CACHE[$name])) {
        // If not installed with a DB setting row, install it; even if it's just the default, we need it for performance
        $map = array(
            'c_name' => $name,
            'c_set' => $will_be_formally_set,
            'c_value' => $value,
            'c_needs_dereference' => $needs_dereference,
        );
        if ($needs_dereference == 1) {
            $map = insert_lang('c_value_trans', $value, 1) + $map;
        } else {
            $map['c_value_trans'] = multi_lang_content() ? null : '';
        }

        // For use by get_option during same script execution
        $CONFIG_OPTIONS_CACHE[$name] = $map + array('_cached_string_value' => $value);

        if ($will_be_formally_set == 0 && $GLOBALS['IN_MINIKERNEL_VERSION']) {
            return; // Don't save in the installer
        }

        // Save insert
        $GLOBALS['SITE_DB']->query_insert('config', $map, false, true/*block race condition errors*/);
    } else {
        // Save edit
        $map = array(
            'c_set' => $will_be_formally_set,
            'c_value' => $value,
        );
        if ($needs_dereference == 1) { // Translated
            $current_value = multi_lang_content() ? $CONFIG_OPTIONS_CACHE[$name]['c_value_trans'] : $CONFIG_OPTIONS_CACHE[$name]['c_value'];
            if ($current_value === null) {
                $map += insert_lang('c_value_trans', $value, 1);
            } else {
                $map += lang_remap('c_value_trans', $current_value, $value);
            }
            $GLOBALS['SITE_DB']->query_update('config', $map, array('c_name' => $name), '', 1);
        } else { // Not translated
            $GLOBALS['SITE_DB']->query_update('config', $map, array('c_name' => $name), '', 1);
        }

        // For use by get_option during same script execution
        $CONFIG_OPTIONS_CACHE[$name] = $map + array('_cached_string_value' => $value) + $CONFIG_OPTIONS_CACHE[$name];
    }

    // Log it
    if ((function_exists('log_it')) && ($will_be_formally_set == 1) && ($previous_value != $value)) {
        require_lang('config');
        log_it('CONFIGURATION', $name, $value);
    }

    // Clear caches
    if (function_exists('persistent_cache_delete')) {
        persistent_cache_delete('OPTIONS');
    }
    if (class_exists('Self_learning_cache')) {
        Self_learning_cache::erase_smart_cache();
    }
}

/**
 * Update a reference stored in a config option.
 *
 * @param  SHORT_TEXT $old_setting The old value
 * @param  SHORT_TEXT $setting The name value
 * @param  ID_TEXT $type The type
 */
function config_update_value_ref($old_setting, $setting, $type)
{
    $hooks = find_all_hook_obs('systems', 'config', 'Hook_config_');
    $all_options = array();
    foreach ($hooks as $hook => $ob) {
        $option = $ob->get_details();
        if (($option['type'] == $type) && (get_option($hook) == $old_setting)) {
            $GLOBALS['SITE_DB']->query_update('config', array('c_value' => $setting), array('c_name' => $hook), '', 1);
        }
    }
}

/**
 * Get a URL to where to edit a config option.
 *
 * @param  ID_TEXT $name The config option name
 * @return ?URLPATH URL to set the config option (null: no such option exists)
 */
function config_option_url($name)
{
    $value = get_option($name, true);
    if ($value === null) {
        return null;
    }

    require_code('hooks/systems/config/' . filter_naughty_harsh($name));
    $ob = object_factory('Hook_config_' . filter_naughty_harsh($name));
    $option = $ob->get_details();

    $_config_url = build_url(array('page' => 'admin_config', 'type' => 'category', 'id' => $option['category']), get_module_zone('admin_config'));
    $config_url = $_config_url->evaluate();
    $config_url .= '#group_' . $option['group'];

    return $config_url;
}

/**
 * Deletes a specified config option permanently from the database.
 *
 * @param  ID_TEXT $name The codename of the config option
 */
function delete_config_option($name)
{
    $rows = $GLOBALS['SITE_DB']->query_select('config', array('*'), array('c_name' => $name), '', 1);
    if (array_key_exists(0, $rows)) {
        $myrow = $rows[0];
        if (($myrow['c_needs_dereference'] == 1) && (is_numeric($myrow['c_value']))) {
            delete_lang($myrow['c_value_trans']);
        }
        $GLOBALS['SITE_DB']->query_delete('config', array('c_name' => $name), '', 1);
        /*global $CONFIG_OPTIONS_CACHE;  Don't do this, it will cause problems in some parts of the code
        unset($CONFIG_OPTIONS_CACHE[$name]);*/
    }
    if (function_exists('persistent_cache_delete')) {
        persistent_cache_delete('OPTIONS');
    }
}

/**
 * Rename a config option.
 *
 * @param  ID_TEXT $old The old name
 * @param  ID_TEXT $new The new name
 */
function rename_config_option($old, $new)
{
    $GLOBALS['SITE_DB']->query_delete('config', array('c_name' => $new), '', 1);

    $GLOBALS['SITE_DB']->query_update('config', array('c_name' => $new), array('c_name' => $old), '', 1);

    if (function_exists('persistent_cache_delete')) {
        persistent_cache_delete('OPTIONS');
    }
}

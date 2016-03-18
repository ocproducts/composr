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
 * @package    core
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__caches3()
{
    global $ERASED_TEMPLATES_ONCE;
    $ERASED_TEMPLATES_ONCE = false;

    // Special ways of decaching templates
    define('TEMPLATE_DECACHE_BASE', '\{\+START,INCLUDE');
    // -
    define('TEMPLATE_DECACHE_WITH_LANG', '\{\!|\{\$CHARSET' . '|' . TEMPLATE_DECACHE_BASE);
    define('TEMPLATE_DECACHE_WITH_THEME_IMAGE', '\{\$IMG' . '|' . TEMPLATE_DECACHE_BASE);
    define('TEMPLATE_DECACHE_WITH_CONFIG', '\{\!|\{\$IMG|\{\$SITE_NAME|\{\$CONFIG_OPTION|\{\$SITE_SCOPE|\{\$DOMAIN|\{\$STAFF_ADDRESS|\{\$SHOW_DOCS|\{\$COPYRIGHT|\{\$VALID_FILE_TYPES\{\$BRAND_|\{\$INLINE_STATS|\{\$CURRENCY_SYMBOL' . '|' . TEMPLATE_DECACHE_BASE);
    define('TEMPLATE_DECACHE_WITH_ADDON', '\{\$ADDON_INSTALLED' . '|' . TEMPLATE_DECACHE_WITH_CONFIG);
    // -
    define('TEMPLATE_DECACHE_WITH_ANYTHING_INTERESTING', TEMPLATE_DECACHE_WITH_ADDON); // because TEMPLATE_DECACHE_WITH_ADDON actually does include everything already, via chaining
}

/**
 * Automatically empty caches.
 *
 * @param  boolean $changed_base_url Whether the base URL has just been changed
 */
function auto_decache($changed_base_url)
{
    delete_value('cdn');
    erase_block_cache();
    erase_cached_templates(!$changed_base_url);
    erase_comcode_cache();
    erase_cached_language();
    if (class_exists('Self_learning_cache')) {
        Self_learning_cache::erase_smart_cache();
    }
    erase_persistent_cache();
    if ($changed_base_url) {
        erase_comcode_page_cache();
        set_value('last_base_url', get_base_url(false), true);
    }
}

/**
 * Rebuild the specified caches.
 *
 * @param  ?array $caches The caches to rebuild (null: all)
 * @return Tempcode Any messages returned
 */
function composr_cleanup($caches = null)
{
    require_lang('cleanup');

    $max_time = intval(round(floatval(ini_get('max_execution_time')) / 1.5));
    if ($max_time < 60 * 4) {
        if (php_function_allowed('set_time_limit')) {
            set_time_limit(0);
        }
    }
    send_http_output_ping();
    $messages = new Tempcode();
    $hooks = find_all_hooks('systems', 'cleanup');
    if ((array_key_exists('cns', $hooks)) && (array_key_exists('cns_topics', $hooks))) {
        // A little re-ordering
        $temp = $hooks['cns'];
        unset($hooks['cns']);
        $hooks['cns'] = $temp;
    }

    if (!is_null($caches)) {
        foreach ($caches as $cache) {
            if (array_key_exists($cache, $hooks)) {
                require_code('hooks/systems/cleanup/' . filter_naughty_harsh($cache));
                $object = object_factory('Hook_cleanup_' . filter_naughty_harsh($cache), true);
                if (is_null($object)) {
                    continue;
                }
                $messages->attach($object->run());
            } else {
                $messages->attach(paragraph(do_lang_tempcode('_MISSING_RESOURCE', escape_html($cache))));
            }
        }
    } else {
        foreach (array_keys($hooks) as $hook) {
            require_code('hooks/systems/cleanup/' . filter_naughty_harsh($hook));
            $object = object_factory('Hook_cleanup_' . filter_naughty_harsh($hook), true);
            if (is_null($object)) {
                continue;
            }
            $info = $object->info();
            if ($info['type'] == 'cache') {
                $messages->attach($object->run());
            }
        }
    }

    log_it('CLEANUP_TOOLS');
    return $messages;
}

/**
 * Erase the block cache.
 *
 * @param  boolean $erase_cache_signatures_too Erase cache signatures too
 * @param  ?ID_TEXT $theme Only erase caching for this theme (null: all themes)
 */
function erase_block_cache($erase_cache_signatures_too = false, $theme = null)
{
    cms_profile_start_for('erase_tempcode_cache');

    if ($erase_cache_signatures_too) {
        $GLOBALS['SITE_DB']->query_delete('cache_on', null, '', null, null, true);
    }

    $where_map = mixed();
    if ($theme !== null) {
        $where_map = array('the_theme' => $theme);
    }
    $GLOBALS['SITE_DB']->query_delete('cache', $where_map);

    erase_persistent_cache(); // Block caching may be directly in here

    cms_profile_end_for('erase_tempcode_cache');
}

/**
 * Erase the Comcode cache. Warning: This can take a long time on large sites, so is best to avoid.
 */
function erase_comcode_cache()
{
    static $done_once = false; // Useful to stop it running multiple times in admin_cleanup module, as this code takes time
    if ($done_once) {
        return;
    }

    cms_profile_start_for('erase_comcode_cache');

    if (multi_lang_content()) {
        if ((substr(get_db_type(), 0, 5) == 'mysql') && (!is_null($GLOBALS['SITE_DB']->query_select_value_if_there('db_meta_indices', 'i_fields', array('i_table' => 'translate', 'i_name' => 'decache'))))) {
            $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'translate FORCE INDEX (decache) SET text_parsed=\'\' WHERE ' . db_string_not_equal_to('text_parsed', '')/*this WHERE is so indexing helps*/);
        } else {
            $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . 'translate SET text_parsed=\'\' WHERE ' . db_string_not_equal_to('text_parsed', '')/*this WHERE is so indexing helps*/);
        }
    } else {
        global $TABLE_LANG_FIELDS_CACHE;
        foreach ($TABLE_LANG_FIELDS_CACHE as $table => $fields) {
            foreach (array_keys($fields) as $field) {
                if (strpos($field, '__COMCODE') !== false) {
                    $GLOBALS['SITE_DB']->query('UPDATE ' . get_table_prefix() . $table . ' SET ' . $field . '__text_parsed=\'\' WHERE ' . db_string_not_equal_to($field . '__text_parsed', '')/*this WHERE is so indexing helps*/);
                }
            }
        }
    }

    $done_once = true;

    cms_profile_end_for('erase_comcode_cache');
}

/**
 * Erase the thumbnail cache.
 */
function erase_thumb_cache()
{
    $thumb_fields = $GLOBALS['SITE_DB']->query('SELECT m_name,m_table FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'db_meta WHERE m_name LIKE \'' . db_encode_like('%thumb_url') . '\'');
    foreach ($thumb_fields as $field) {
        if ($field['m_table'] == 'videos') {
            continue;
        }

        $GLOBALS['SITE_DB']->query_update($field['m_table'], array($field['m_name'] => ''));
    }
    $full = get_custom_file_base() . '/uploads/auto_thumbs';
    $dh = @opendir($full);
    if ($dh !== false) {
        while (($file = readdir($dh)) !== false) {
            @unlink($full . '/' . $file);
        }
        closedir($dh);
    }
}

/**
 * Erase the language cache.
 */
function erase_cached_language()
{
    cms_profile_start_for('erase_cached_language');

    $langs = find_all_langs(true);
    foreach (array_merge(array_keys($langs), array('')) as $lang) {
        $path = get_custom_file_base() . '/caches/lang/' . $lang;
        $_dir = @opendir($path);
        if ($_dir === false) {
            require_code('files2');
            make_missing_directory($path);
        } else {
            while (false !== ($file = readdir($_dir))) {
                if (substr($file, -4) == '.lcd') {
                    if (running_script('index')) {
                        $key = 'page__' . get_zone_name() . '__' . get_page_name();
                    } else {
                        $key = 'script__' . md5(serialize(cms_srv('SCRIPT_NAME')) . serialize($_GET));
                    }
                    if ($key . '.lcd' == $file) {
                        continue; // Will be open/locked
                    }

                    $i = 0;
                    while ((@unlink($path . '/' . $file) === false) && ($i < 5)) {
                        if (!file_exists($path . '/' . $file)) {
                            break; // Race condition, gone already
                        }
                        sleep(1); // May be race condition, lock
                        $i++;
                    }
                    if ($i >= 5) {
                        if ((file_exists($path . '/' . $file)) && (substr($file, 0, 5) != 'page_') && (substr($file, 0, 7) != 'script_')) {
                            @unlink($path . '/' . $file) or intelligent_write_error($path . '/' . $file);
                        }
                    }
                }
            }
            closedir($_dir);
        }
    }

    // Re-initialise language stuff
    global $LANGS_REQUESTED;
    $langs_requested_copy = $LANGS_REQUESTED;
    init__lang();
    $LANGS_REQUESTED = $langs_requested_copy;
    require_all_open_lang_files();

    if (class_exists('Self_learning_cache')) {
        Self_learning_cache::erase_smart_cache();
    }

    cms_profile_end_for('erase_cached_language');
}

/**
 * Erase all template caches (caches in all themes).
 *
 * @param  boolean $preserve_some Whether to preserve CSS and JS files that might be linked to between requests
 * @param  ?array $only_templates Only erase specific templates with the following filename, excluding suffix(es) (null: erase all)
 * @param  ?string $raw_file_regexp The original template must contain a match for this regular expression (null: no restriction)
 */
function erase_cached_templates($preserve_some = false, $only_templates = null, $raw_file_regexp = null)
{
    if ($only_templates === array()) {
        return; // Optimisation
    }

    cms_profile_start_for('erase_cached_templates');

    global $ERASED_TEMPLATES_ONCE;
    $ERASED_TEMPLATES_ONCE = true;

    require_code('themes2');
    $themes = array_keys(find_all_themes());
    $langs = find_all_langs(true);

    if ($raw_file_regexp !== null) {
        $all_template_data = array();

        $base_dirs = array(get_custom_file_base());
        if (get_custom_file_base() != get_file_base()) {
            $base_dirs[] = get_file_base();
        }

        $theme_dirs = array(
            'css',
            'css_custom',
            'javascript',
            'javascript_custom',
            'templates',
            'templates_custom',
            'text',
            'text_custom',
            'xml',
            'xml_custom',
        );

        foreach ($base_dirs as $base_dir) {
            foreach ($themes as $theme) {
                foreach ($theme_dirs as $theme_dir) {
                    $dir_path = $base_dir . '/themes/' . $theme . '/' . $theme_dir;
                    $_dir = @opendir($dir_path);
                    if ($_dir !== false) {
                        while (false !== ($file = readdir($_dir))) {
                            // Basic filter
                            if ($file[0] == '.' || $file == 'index.html') {
                                continue;
                            }

                            if (!isset($all_template_data[$file])) {
                                $all_template_data[$file] = array();
                            }
                            $all_template_data[$file][] = file_get_contents($dir_path . '/' . $file);
                        }
                        closedir($_dir);
                    }
                }
            }
        }
    }

    foreach ($themes as $theme) {
        $using_less = (addon_installed('less')) || /*LESS-regeneration is too intensive and assumed cache-safe anyway*/
                      is_file(get_custom_file_base() . '/themes/' . $theme . '/css/global.less') || 
                      is_file(get_custom_file_base() . '/themes/' . $theme . '/css_custom/global.less');

        foreach (array_keys($langs) as $lang) {
            $path = get_custom_file_base() . '/themes/' . $theme . '/templates_cached/' . $lang . '/';
            $_dir = @opendir($path);
            if ($_dir === false) {
                require_code('files2');
                make_missing_directory($path);
            } else {
                while (false !== ($file = readdir($_dir))) {
                    // Basic filter
                    if ($file[0] == '.' || $file == 'index.html') {
                        continue;
                    }

                    // $only_templates filter
                    if (($only_templates !== null) && (!in_array(preg_replace('#\..*$#', '', $file), $only_templates))) {
                        continue;
                    }

                    $file_template_name = preg_replace('#(\.tcp|\.tcd|\.gz|_mobile|_non_minified|_ssl)#', '', $file);

                    // $using_less filter (we never want to force the main global.less file to be decached, too expensive)
                    if (($using_less) && ($file_template_name == 'global.less')) {
                        continue;
                    }

                    // $preserve_some filter
                    if (
                        ($preserve_some)
                        &&
                        (
                            (substr($file_template_name, -3) == '.js')
                            ||
                            (substr($file_template_name, -4) == '.css')
                        )
                    ) {
                        continue;
                    }

                    // $raw_file_regexp filter
                    if ($raw_file_regexp !== null) {
                        $may_delete = false;
                        if (isset($all_template_data[$file_template_name])) {
                            foreach ($all_template_data[$file_template_name] as $c) {
                                if (preg_match('#' . $raw_file_regexp . '#', $c) != 0) {
                                    $may_delete = true;
                                    break;
                                }
                            }
                        }
                        if (!$may_delete) {
                            continue;
                        }
                    }

                    // Do deletion
                    $i = 0;
                    while ((@unlink($path . $file) === false) && ($i < 5)) {
                        if (!file_exists($path . $file)) {
                            break; // Successful delete
                        }
                        sleep(1); // May be race condition, lock
                        $i++;
                    }
                    if ($i >= 5) {
                        if (file_exists($path . $file)) {
                            @unlink($path . $file) or intelligent_write_error($path . $file);
                        }
                    }
                }
                closedir($_dir);
            }
        }
    }
    foreach (array_keys($langs) as $lang) {
        $path = get_custom_file_base() . '/site/pages/html_custom/' . $lang . '/';
        $_dir = @opendir($path);
        if ($_dir !== false) {
            while (false !== ($file = readdir($_dir))) {
                if (substr($file, -14) == '_tree_made.htm') {
                    @unlink($path . $file);
                }
            }
            closedir($_dir);
        }
    }

    if (!$GLOBALS['IN_MINIKERNEL_VERSION']) {
        $zones = find_all_zones();
        foreach ($zones as $zone) {
            delete_value('merged__' . $zone . '.css');
            delete_value('merged__' . $zone . '.js');
            delete_value('merged__' . $zone . '__admin.css');
            delete_value('merged__' . $zone . '__admin.js');
        }
    }

    // Often the back button will be used to return to a form, so we need to ensure we have not broken the JavaScript
    if ((function_exists('get_member')) && (!$GLOBALS['BOOTSTRAPPING'])) {
        javascript_enforce('validation');
        javascript_enforce('editing');
    }

    if (class_exists('Self_learning_cache')) {
        Self_learning_cache::erase_smart_cache();
    }

    cms_profile_end_for('erase_cached_templates');

    // Rebuild ones needed for this session
    if (!$preserve_some && !$GLOBALS['IN_MINIKERNEL_VERSION']) {
        global $JAVASCRIPTS, $CSSS;
        if (is_array($JAVASCRIPTS)) {
            foreach (array_keys($JAVASCRIPTS) as $j) {
                javascript_enforce($j);
            }
        }
        if (is_array($CSSS)) {
            foreach (array_keys($CSSS) as $c) {
                css_enforce($c);
            }
        }
    }
}

/**
 * Erase the Comcode page cache
 */
function erase_comcode_page_cache()
{
    $GLOBALS['NO_QUERY_LIMIT'] = true;

    do {
        $rows = $GLOBALS['SITE_DB']->query_select('cached_comcode_pages', array('string_index'), null, '', 50, null, true, array());
        if (is_null($rows)) {
            $rows = array();
        }
        foreach ($rows as $row) {
            delete_lang($row['string_index']);
            $GLOBALS['SITE_DB']->query_delete('cached_comcode_pages', array('string_index' => $row['string_index']));
        }
    } while (count($rows) != 0);
    erase_persistent_cache();

    $GLOBALS['NO_QUERY_LIMIT'] = false;
}

/**
 * Erase the theme images cache
 */
function erase_theme_images_cache()
{
    $GLOBALS['SITE_DB']->query('DELETE FROM ' . get_table_prefix() . 'theme_images WHERE path LIKE \'themes/%/images/%\'');

    Self_learning_cache::erase_smart_cache();

    $paths = $GLOBALS['SITE_DB']->query_select('theme_images', array('path', 'id'));
    foreach ($paths as $path) {
        if ($path['path'] == '') {
            $GLOBALS['SITE_DB']->query_delete('theme_images', $path, '', 1);
        } elseif (preg_match('#^themes/[^/]+/images_custom/#', $path['path']) != 0) {
            if ((!file_exists(get_custom_file_base() . '/' . rawurldecode($path['path']))) && (!file_exists(get_file_base() . '/' . rawurldecode($path['path'])))) {
                $GLOBALS['SITE_DB']->query_delete('theme_images', $path, '', 1);
            }
        }
    }
}

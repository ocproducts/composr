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
 * @package    core_themeing
 */

/**
 * Try and find some CDNs to use.
 *
 * @return string List of CDNs
 */
function autoprobe_cdns()
{
    require_code('files');

    $base_url = get_base_url();
    $parsed = parse_url($base_url);
    if (!array_key_exists('path', $parsed)) {
        $parsed['path'] = '';
    }
    $domain_name = $parsed['host'];

    if ($domain_name == 'localhost') {
        set_value('cdn', '');
        return '';
    }

    $server_ip = cms_srv('REMOTE_ADDR');
    $try = array(
        'cdn' . '.' . $domain_name,
        ($server_ip == '127.0.0.1' || substr($server_ip, 0, 8) == '192.168.' || substr($server_ip, 0, 5) == '10.0.') ? null : $server_ip,
        (substr($domain_name, 0, 4) == 'www.') ? preg_replace('#^www\.#', '', $domain_name) : ('www' . '.' . $domain_name),
        'ftp' . '.' . $domain_name,
        'mail' . '.' . $domain_name,
        /*'smtp' . '.' . $domain_name,  Let's be at least somewhat reasonable ;-)
        'imap' . '.' . $domain_name,
        'pop' . '.' . $domain_name,
        'webmail' . '.' . $domain_name,*/
    );

    $detected_cdns = '';
    $expected = file_get_contents(get_file_base() . '/themes/default/images/icons/16x16/editor/comcode.png');
    foreach ($try as $t) {
        if ($t === null) {
            continue;
        }

        if (preg_match('#^' . preg_quote($t, '#') . '($|\.|/|:)#', $domain_name) == 0) { // Don't use it if it is in the base URL
            $test_url = 'http://' . $t . $parsed['path'] . '/themes/default/images/icons/16x16/editor/comcode.png';

            $test_result = http_get_contents($test_url, array('trigger_error' => false, 'timeout' => 0.25));

            if (($test_result !== null) && ($test_result == $expected)) {
                if ($detected_cdns != '') {
                    $detected_cdns .= ',';
                }
                $detected_cdns .= $t;
            }
        }
    }

    set_value('cdn', $detected_cdns);
    return $detected_cdns;
}

/**
 * Get an array listing all the themes present.
 *
 * @return array A map of all themes (name=>title) OR if requested a map of theme name to full theme details
 */
function find_all_themes()
{
    if ($GLOBALS['IN_MINIKERNEL_VERSION']) {
        return array('default' => do_lang('DEFAULT'));
    }

    require_code('files');

    $themes = array();
    $_dir = opendir(get_file_base() . '/themes/');
    while (false !== ($file = readdir($_dir))) {
        if ((strpos($file, '.') === false) && (is_dir(get_file_base() . '/themes/' . $file))) {
            $themes[$file] = get_theme_option('title', null, $file);
        }
    }
    closedir($_dir);
    if (get_custom_file_base() != get_file_base()) {
        $_dir = @opendir(get_custom_file_base() . '/themes/');
        if ($_dir !== false) {
            while (false !== ($file = readdir($_dir))) {
                if ((strpos($file, '.') === false) && (is_dir(get_file_base() . '/themes/' . $file))) {
                    $themes[$file] = get_theme_option('title', null, $file);
                }
            }
            closedir($_dir);
        }
    }

    // Sort
    asort($themes, SORT_NATURAL | SORT_FLAG_CASE);

    // Default theme should go first
    if (isset($themes['default'])) {
        $temp = $themes['default'];
        $temp_2 = $themes;
        $themes = array('default' => $temp) + $temp_2;
    }

    // Admin theme should go last
    if (isset($themes['admin'])) {
        $temp = $themes['admin'];
        unset($themes['admin']);
        $themes['admin'] = $temp;
    }

    return $themes;
}

/**
 * Get a UI list for choosing a theme.
 *
 * @param  ?ID_TEXT $theme The theme to select by default (null: no specific default)
 * @param  boolean $no_rely Whether to skip the 'rely on forums' entry
 * @param  boolean $show_everything Whether to forget about permissions for this list
 * @param  ID_TEXT $default_message_string The language string to use for the default answer
 * @return Tempcode The list
 */
function create_selection_list_themes($theme = null, $no_rely = false, $show_everything = false, $default_message_string = 'RELY_FORUMS')
{
    if (!$no_rely) {
        $entries = form_input_list_entry('-1', false, do_lang_tempcode($default_message_string));
    } else {
        $entries = new Tempcode();
    }
    $themes = find_all_themes();
    foreach ($themes as $_theme => $title) {
        if (($show_everything) || (has_category_access(get_member(), 'theme', $_theme))) {
            $selected = ($theme == $_theme);
            $entries->attach(form_input_list_entry($_theme, $selected, $title));
        }
    }
    if ($entries->is_empty()) {
        $entries->attach(form_input_list_entry('default', false, $themes['default']));
    }
    return $entries;
}

/**
 * Get all the templates for a theme.
 *
 * @param  ID_TEXT $theme The theme to search for
 * @param  string $directory Subdirectory type to look in
 * @set    templates javascript xml text css
 * @param  ?string $suffix File type suffix of template file (e.g. .tpl) (null: calculate for the $directory norm)
 * @set    .tpl .js .xml .txt .css
 * @param  boolean $this_theme_only Just for this theme
 * @return array A map of the files (file=>path)
 */
function get_template_files_list($theme, $directory, $suffix = null, $this_theme_only = false)
{
    if ($suffix === null) {
        switch ($directory) {
            case 'templates':
                $suffix = '.tpl';
                break;

            case 'javascript':
                $suffix = '.js';
                break;

            case 'xml':
                $suffix = '.xml';
                break;

            case 'text':
                $suffix = '.txt';
                break;

            case 'css':
                $suffix = '.css';
                break;
        }
    }

    $out = array();
    if (($theme == 'default') || (!$this_theme_only)) {
        $out = array_merge($out, _get_template_files_list(get_file_base(), 'default/' . $directory, $suffix));
        $out = array_merge($out, _get_template_files_list(get_custom_file_base(), 'default/' . $directory . '_custom', $suffix));
    }
    if ($theme != 'default') {
        $out = array_merge($out, _get_template_files_list(get_custom_file_base(), $theme . '/' . $directory, $suffix));
        $out = array_merge($out, _get_template_files_list(get_custom_file_base(), $theme . '/' . $directory . '_custom', $suffix));
    }
    ksort($out);

    return $out;
}

/**
 * Get all the template files / revisions for a template file, in a certain directory.
 *
 * @param  PATH $base_dir The path to search relative to
 * @param  PATH $subdir The subdirectory to search
 * @param  string $suffix File type suffix of template file (e.g. .tpl)
 * @set    .tpl .js .xml .txt .css
 * @return array A map of the files (file=>path)
 *
 * @ignore
 */
function _get_template_files_list($base_dir, $subdir, $suffix)
{
    $_dir = @opendir($base_dir . '/themes/' . $subdir);
    if ($_dir !== false) {
        // Find all the themes
        $files_list = array();
        while (false !== ($file = readdir($_dir))) {
            if (strtolower(substr($file, -strlen($suffix))) == $suffix) {
                $files_list[$file] = $base_dir . '/themes/' . $subdir . '/' . $file;
            }
        }
        closedir($_dir);
        return $files_list;
    }
    return array();
}

/**
 * Find where a template is.
 *
 * @param  ID_TEXT $file The file
 * @param  ID_TEXT $subdir The theme subdirectory we're working against
 * @param  ID_TEXT $theme The theme
 * @return ?PATH The path (null: not found)
 */
function find_template_path($file, $subdir, $theme)
{
    static $cache = array();
    if (isset($cache[$file][$subdir][$theme])) {
        return $cache[$file][$subdir][$theme];
    }

    $suffix = '.' . get_file_extension($file);
    $_file = basename($file, $suffix);
    list($searched_theme, $searched_directory, $searched_suffix) = find_template_place($_file, get_site_default_lang(), $theme, $suffix, $subdir);
    if ($searched_theme === null) {
        return null;
    }
    $template_path = get_custom_file_base() . '/themes/' . $searched_theme . $searched_directory . $_file . $suffix;
    if (!is_file($template_path)) {
        $template_path = get_file_base() . '/themes/' . $searched_theme . $searched_directory . $_file . $suffix;
        if (!is_file($template_path)) {
            $template_path = null;
        }
    }

    $cache[$file][$subdir][$theme] = $template_path;

    return $template_path;
}

/**
 * Find GUIDs used for a template, for use with the template editor.
 *
 * @param  ID_TEXT $file The template (including subdirectory and suffix)
 * @param  ?ID_TEXT $active_guid GUID currently in use, to highlight; e.g. opening up the editor on a template instance within a screen meta-tree (null: none)
 * @return array List of GUID details (template-ready)
 */
function find_template_guids($file, $active_guid = null)
{
    $suffix = '.' . get_file_extension($file);
    $clean_file = basename($file, $suffix);

    $guids = array();
    $_guids = @unserialize(@file_get_contents(get_file_base() . '/data/guids.dat'));
    if (($_guids !== false) && (array_key_exists($clean_file, $_guids))) {
        foreach ($_guids[$clean_file] as $_guid) {
            $guids[] = array(
                'GUID_FILENAME' => $_guid[0],
                'GUID_LINE' => integer_format($_guid[1]),
                'GUID_GUID' => $_guid[2],
                'GUID_IS_LIVE' => ($_guid[2] === $active_guid),
            );
        }
    }
    return $guids;
}

/**
 * Find parameters used by a template.
 *
 * @param  ID_TEXT $file The template (including subdirectory and suffix)
 * @return array List of template parameters
 */
function find_template_parameters($file)
{
    $parameters = array();

    require_code('lorem');
    $all_previews = find_all_previews__by_template();
    if (array_key_exists($file, $all_previews)) {
        list($hook, $function) = $all_previews[$file];
        global $LOREM_AVOID_GLOBALISE;
        $LOREM_AVOID_GLOBALISE = true;
        $temp = render_screen_preview($file, $hook, $function);
    }

    global $KNOWN_TEMPLATE_PARAMETERS;
    $_file = basename($file, '.' . get_file_extension($file));
    if (isset($KNOWN_TEMPLATE_PARAMETERS[$_file])) {
        return $KNOWN_TEMPLATE_PARAMETERS[$_file];
    }

    // No screen preview, so look inside the template instead...

    $template_path = find_template_path(basename($file), dirname($file), 'default');
    if ($template_path === null) {
        return $parameters;
    }

    $matches = array();
    $cnt = preg_match_all('#\{([\w]\w*)[\*;%\#]?\}#', cms_file_get_contents_safe($template_path), $matches);
    $p_done = array();
    for ($j = 0; $j < $cnt; $j++) {
        $parameters[] = $matches[1][$j];
    }

    return array_unique($parameters);
}

/**
 * A theme image has been passed through by POST, either as a file (a new theme image), or as a reference to an existing one. Get the image code from the POST data.
 * Note that post_param_image is a more comprehensive function, if you accept other types of inputs too.
 *
 * @param  ID_TEXT $type The type of theme image
 * @param  boolean $required Whether a code is required
 * @param  ID_TEXT $field_file Form field for uploading
 * @param  ID_TEXT $field_choose Form field for choosing
 * @param  ?object $db Database connector (null: site database)
 * @param  ?PATH $upload_to Where to upload the theme images to (null: something sensible)
 * @return ID_TEXT The (possibly randomised) theme image code
 */
function post_param_theme_img_code($type, $required = false, $field_file = 'file', $field_choose = 'theme_img_code', $db = null, $upload_to = null)
{
    if ($db === null) {
        $db = $GLOBALS['SITE_DB'];
    }

    if ($upload_to === null) {
        $upload_to = 'themes/default/images_custom/' . $type;
        @mkdir(get_custom_file_base() . '/' . $upload_to, 0777);
        if (file_exists(get_custom_file_base() . '/' . $upload_to)) {
            fix_permissions(get_custom_file_base() . '/' . $upload_to);
        } else {
            $upload_to = 'themes/default/images_custom';
        }
    }

    require_code('uploads');
    is_plupload(true);
    if (((array_key_exists($field_file, $_FILES)) && ((is_plupload()) || (is_uploaded_file($_FILES[$field_file]['tmp_name']))))) {
        $urls = get_url('', $field_file, $upload_to, 0, CMS_UPLOAD_IMAGE, false);

        $theme_img_code = $type . '/' . basename($urls[2], '.' . get_file_extension($urls[2]));
        if ($GLOBALS['SITE_DB']->query_select_value_if_there('theme_images', 'id', array('id' => $theme_img_code)) !== null) {
            $theme_img_code = $type . '/' . uniqid('', true);
        }

        $db->query_insert('theme_images', array('id' => $theme_img_code, 'theme' => 'default', 'path' => $urls[0], 'lang' => get_site_default_lang()));

        Self_learning_cache::erase_smart_cache();
    } else {
        $theme_img_code = post_param_string($field_choose, '');

        if ($theme_img_code == '') {
            if (!$required) {
                return '';
            }
            warn_exit(do_lang_tempcode('IMPROPERLY_FILLED_IN_UPLOAD'));
        }
    }
    return $theme_img_code;
}

/**
 * An image has been passed through by POST, either as a file (a new upload), a url, a reference to an existing theme image, or as a filedump reference.
 * Used with form_input_upload_multi_source.
 * Get the image URL from the POST data.
 *
 * @param  ID_TEXT $name Form field prefix (input type suffixes will be added automatically)
 * @param  ?PATH $upload_to Where to upload to (null: the correct place for $theme_image_type)
 * @param  ?ID_TEXT $theme_image_type The directory of theme images to store under (null: do not support theme images)
 * @param  boolean $required Whether an image is required
 * @param  boolean $is_edit Whether this is an edit operation
 * @param  ?string $filename Pass the filename back by reference (null: do not pass)
 * @param  ?string $thumb_url Pass the thumbnail back by reference (null: do not pass & do not collect a thumbnail)
 * @return ?URLPATH The URL (either to an independent upload, or the theme image, or a filedump URL) (null: leave alone, when doing an edit operation)
 */
function post_param_image($name = 'image', $upload_to = null, $theme_image_type = null, $required = true, $is_edit = false, &$filename = null, &$thumb_url = null)
{
    $thumb_specify_name = $name . '__thumb__url';
    $test = post_param_string($thumb_specify_name, '');
    if ($test == '') {
        $thumb_specify_name = $name . '__thumb__filedump';
    }

    // Upload
    // ------

    if ($upload_to === null) {
        $upload_to = 'themes/default/images_custom/' . $theme_image_type;
        @mkdir(get_custom_file_base() . '/' . $upload_to, 0777);
        if (file_exists(get_custom_file_base() . '/' . $upload_to)) {
            fix_permissions(get_custom_file_base() . '/' . $upload_to);
        } else {
            $upload_to = 'themes/default/images_custom';
        }
    }

    require_code('uploads');
    $field_file = $name . '__upload';
    $thumb_attach_name = $name . '__thumb__upload';
    if ((is_plupload()) || (((array_key_exists($field_file, $_FILES)) && (is_uploaded_file($_FILES[$field_file]['tmp_name']))))) {
        $urls = get_url('', $field_file, $upload_to, 0, CMS_UPLOAD_IMAGE, $thumb_url !== null, $thumb_specify_name, $thumb_attach_name);

        if (substr($urls[0], 0, 8) != 'uploads/') {
            $http_result = cms_http_request($urls[0], array('trigger_error' => false, 'byte_limit' => 0));
            if (($http_result->data === null) && ($http_result->message_b !== null)) {
                attach_message($http_result->message_b, 'warn');
            }
        }

        if ($thumb_url !== null) {
            $thumb_url = $urls[1];
        }
        $filename = $urls[2];

        return $urls[0];
    }

    // URL
    // ---

    $field_url = $name . '__url';
    $url = post_param_string($field_url, '');
    if ($url != '') {
        $filename = urldecode(preg_replace('#\?.*#', '', basename($url)));

        // Get thumbnail
        $urls = get_url($field_url, '', $upload_to, 0, CMS_UPLOAD_IMAGE, $thumb_url !== null, $thumb_specify_name, $thumb_attach_name);
        if ($thumb_url !== null) {
            $thumb_url = $urls[1];
        }

        return $url;
    }

    // Filedump
    // --------

    if (addon_installed('filedump')) {
        $field_filedump = $name . '__filedump';
        $url = post_param_string($field_filedump, '');
        if ($url != '') {
            $filename = urldecode(basename($url));

            // Get thumbnail
            $urls = get_url($field_filedump, '', $upload_to, 0, CMS_UPLOAD_IMAGE, $thumb_url !== null, $thumb_specify_name, $thumb_attach_name);
            if ($thumb_url !== null) {
                $thumb_url = $urls[1];
            }

            return $url;
        }
    }

    // Theme image
    // -----------

    $field_choose = $name . '__theme_image';
    $theme_img_code = post_param_string($field_choose, '');
    if ($theme_img_code != '') {
        $url = find_theme_image($theme_img_code, false, true);

        $filename = urldecode(preg_replace('#\?.*#', '', basename($url)));

        // Get thumbnail
        $_POST[$field_url] = $url; // FUDGE
        $urls = get_url($field_url, '', $upload_to, 0, CMS_UPLOAD_IMAGE, $thumb_url !== null, $thumb_specify_name, $thumb_attach_name);
        if ($thumb_url !== null) {
            $thumb_url = $urls[1];
        }

        return $url;
    }

    // ---

    if (!$required) {
        if (($is_edit) && (post_param_integer($field_file . '_unlink', 0) != 1)) {
            return null;
        }

        return '';
    }

    warn_exit(do_lang_tempcode('IMPROPERLY_FILLED_IN_UPLOAD'));
}

/**
 * Size down a category representative image.
 *
 * @param  URLPATH $rep_image The rep image
 * @return URLPATH The rep image
 */
function resize_rep_image($rep_image)
{
    if (($rep_image != '') && (get_value('resize_rep_images') !== '0')) {
        require_code('images');
        $_rep_image = $rep_image;
        if (url_is_local($rep_image)) {
            $_rep_image = get_custom_base_url() . '/' . $rep_image;
        }
        $rep_image_path = get_custom_file_base() . '/uploads/repimages/' . basename(rawurldecode($rep_image));
        $rep_image = convert_image($_rep_image, $rep_image_path, null, null, intval(get_option('thumb_width')), true, null, false, true);
    }

    return $rep_image;
}

/**
 * Recursively find theme images under the specified details. Does not find custom theme images, as it doesn't check the DB.
 *
 * @param  ID_TEXT $theme The theme
 * @param  string $subdir The subdirectory to search under
 * @param  array $langs A map (lang=>true) of the languages in the system, so the codes may be filtered out of the image codes in our result list
 * @return array A map, theme-image-code=>URL
 */
function find_images_do_dir($theme, $subdir, $langs)
{
    $full = (($theme == 'default' || $theme == 'admin') ? get_file_base() : get_custom_file_base()) . '/themes/' . filter_naughty($theme) . '/' . filter_naughty($subdir);
    $out = array();

    $_dir = @opendir($full);
    if ($_dir !== false) {
        while (false !== ($file = readdir($_dir))) {
            if (($file != '.') && ($file != '..')) {
                if (is_dir($full . $file)) {
                    $out = array_merge($out, find_images_do_dir($theme, $subdir . $file . '/', $langs));
                } else {
                    $ext = substr($file, -4);
                    if (($ext == '.png') || ($ext == '.gif') || ($ext == '.jpg') || ($ext == 'jpeg')) {
                        $_file = explode('.', $file);
                        $_subdir = $subdir;
                        foreach (array_keys($langs) as $lang) {
                            $_subdir = str_replace('/' . $lang . '/', '/', $_subdir);
                        }
                        $_subdir = preg_replace('#(^|/)images(_custom)?/#', '', $_subdir);
                        $out[$_subdir . $_file[0]] = 'themes/' . rawurlencode($theme) . '/' . $subdir . rawurlencode($file);
                    }
                }
            }
        }

        closedir($_dir);
    }

    return $out;
}

/**
 * Get all the image IDs (both already known, and those uncached) of a certain type (i.e. under a subdirectory).
 *
 * @param  ID_TEXT $type The type of image (e.g. 'cns_emoticons')
 * @param  boolean $recurse Whether to search recursively; i.e. in subdirectories of the type subdirectory
 * @param  ?object $db The database connector to work over (null: site db)
 * @param  ?ID_TEXT $theme The theme to search in, in addition to the default theme (null: no other)
 * @param  boolean $dirs_only Whether to only return directories (advanced option, rarely used)
 * @param  boolean $db_only Whether to only return from the database (advanced option, rarely used)
 * @param  array $skip The list of files/directories to skip
 * @return array The list of image IDs
 */
function get_all_image_ids_type($type, $recurse = false, $db = null, $theme = null, $dirs_only = false, $db_only = false, $skip = array())
{
    if ($db === null) {
        $db = $GLOBALS['SITE_DB'];
    }

    static $cache = array();
    $cache_sig = serialize(array($type, $recurse, $theme, $dirs_only, $db_only, $skip));
    if ($db === $GLOBALS['SITE_DB']) {
        if (isset($cache[$cache_sig])) {
            return $cache[$cache_sig];
        }
    }

    require_code('images');
    require_code('files');

    global $THEME_IMAGES_CACHE;

    if ($theme === null) {
        $theme = 'default';
    }

    if ((substr($type, 0, 4) == 'cns_') && (file_exists(get_file_base() . '/themes/default/images/avatars/index.html'))) { // Allow debranding of theme img dirs
        $type = substr($type, 4);
    }

    if (substr($type, -1) == '/') {
        $type = substr($type, 0, strlen($type) - 1);
    }

    $ids = array();

    if ((!$db_only) && ((!$db->is_forum_db()) || ($dirs_only) || (!is_on_multi_site_network()))) {
        _get_all_image_ids_type($ids, get_file_base() . '/themes/default/images/' . (($type == '') ? '' : ($type . '/')), $type, $recurse, $dirs_only, $skip);
        _get_all_image_ids_type($ids, get_file_base() . '/themes/default/images/' . get_site_default_lang() . '/' . (($type == '') ? '' : ($type . '/')), $type, $recurse, $dirs_only, $skip);
        if ($theme != 'default') {
            _get_all_image_ids_type($ids, get_custom_file_base() . '/themes/' . $theme . '/images/' . (($type == '') ? '' : ($type . '/')), $type, $recurse, $dirs_only, $skip);
            _get_all_image_ids_type($ids, get_custom_file_base() . '/themes/' . $theme . '/images/' . get_site_default_lang() . '/' . (($type == '') ? '' : ($type . '/')), $type, $recurse, $dirs_only, $skip);
        }
        _get_all_image_ids_type($ids, get_file_base() . '/themes/default/images_custom/' . (($type == '') ? '' : ($type . '/')), $type, $recurse, $dirs_only, $skip);
        _get_all_image_ids_type($ids, get_file_base() . '/themes/default/images_custom/' . get_site_default_lang() . '/' . (($type == '') ? '' : ($type . '/')), $type, $recurse, $dirs_only, $skip);
        if ($theme != 'default') {
            _get_all_image_ids_type($ids, get_custom_file_base() . '/themes/' . $theme . '/images_custom/' . (($type == '') ? '' : ($type . '/')), $type, $recurse, $dirs_only, $skip);
            _get_all_image_ids_type($ids, get_custom_file_base() . '/themes/' . $theme . '/images_custom/' . get_site_default_lang() . '/' . (($type == '') ? '' : ($type . '/')), $type, $recurse, $dirs_only, $skip);
        }
    }

    if (!$dirs_only) {
        $query = 'SELECT DISTINCT id,path,theme FROM ' . $db->get_table_prefix() . 'theme_images WHERE ';
        if (!$db_only) {
            $query .= 'path NOT LIKE \'' . db_encode_like('themes/default/images/%') . '\' AND ' . db_string_not_equal_to('path', 'themes/default/images/blank.gif') . ' AND ';
        }
        $query .= '(' . db_string_equal_to('theme', $theme) . ' OR ' . db_string_equal_to('theme', 'default') . ') AND id LIKE \'' . db_encode_like($type . '%') . '\' ORDER BY path';
        $rows = $db->query($query);
        foreach ($rows as $row) {
            if ($row['path'] == '') {
                continue;
            }

            foreach ($skip as $s) {
                if (preg_match('#(^|/)' . preg_quote($s, '#') . '(/|$)#', $row['path']) != 0) {
                    continue 2;
                }
            }

            if ((url_is_local($row['path'])) && (!file_exists(((substr($row['path'], 0, 15) == 'themes/default/') ? get_file_base() : get_custom_file_base()) . '/' . rawurldecode($row['path'])))) {
                continue;
            }
            if ($row['path'] != 'themes/default/images/blank.gif') { // We sometimes associate to blank.gif to essentially delete images so they can never be found again
                // Optimisation to avoid having to build the full theme image table for a new theme in one step (huge numbers of queries)
                if (!multi_lang()) {
                    if (($theme == $row['theme']) || (($row['theme'] == 'default') && (!isset($THEME_IMAGES_CACHE['site'][$row['id']])))) {
                        $THEME_IMAGES_CACHE['site'][$row['id']] = $row['path'];
                    }
                }

                $ids[] = $row['id'];
            } else {
                $key = array_search($row['id'], $ids);
                if (is_integer($key)) {
                    unset($ids[$key]);
                }
            }
        }
    }
    sort($ids);

    $ret = array_unique($ids);

    if ($db === $GLOBALS['SITE_DB']) {
        $cache[$cache_sig] = $ret;
    }

    return $ret;
}

/**
 * Get all the image IDs (both already known, and those uncached) of a certain type (i.e. under a subdirectory).
 *
 * @param  array $ids The list of image IDs found so far. This list will be appended as we proceed
 * @param  ID_TEXT $dir The specific theme image subdirectory we are currently looking under
 * @param  ID_TEXT $type The type of image (e.g. 'cns_emoticons')
 * @param  boolean $recurse Whether to search recursively; i.e. in subdirectories of the type subdirectory
 * @param  boolean $dirs_only Whether to only return directories (advanced option, rarely used)
 * @param  array $skip The list of files/directories to skip
 *
 * @ignore
 */
function _get_all_image_ids_type(&$ids, $dir, $type, $recurse, $dirs_only, $skip)
{
    $has_skip = ($skip !== array());

    $_dir = @opendir($dir);
    if ($_dir !== false) {
        while (false !== ($file = readdir($_dir))) {
            if ($file[0] == '.' || $file == 'index.html') {
                continue; // Optimisation, so no need for should_ignore_file call
            }
            if ($has_skip && in_array($file, $skip)) {
                continue;
            }

            $path = $dir . (($dir != '') ? '/' : '') . $file;
            $is_dir = is_dir($path);

            if ($is_dir) {
                if (($recurse) && (!should_ignore_file($file, IGNORE_ACCESS_CONTROLLERS)) && ((strlen($file) != 2) || (strtoupper($file) != $file))) {
                    $type_path = $type . (($type != '') ? '/' : '');

                    if ($dirs_only) {
                        $ids[] = $type_path . $file;
                    }
                    _get_all_image_ids_type($ids, $path, $type_path . $file, true, $dirs_only, $skip);
                }
            } else {
                if (!$dirs_only) {
                    if ((preg_match('#^[' . URL_CONTENT_REGEXP . ']+\.(png|jpg|gif)$#', $file) != 0/*optimisation*/) || (!should_ignore_file($file, IGNORE_ACCESS_CONTROLLERS))) {
                        $type_path = $type . (($type != '') ? '/' : '');

                        $dot_pos = strrpos($file, '.');
                        if ($dot_pos === false) {
                            $dot_pos = strlen($file);
                        }
                        if (is_image($file, IMAGE_CRITERIA_NONE)) {
                            $ids[] = $type_path . substr($file, 0, $dot_pos);
                        }
                    }
                }
            }
        }
        closedir($_dir);
    }
}

/**
 * Get Tempcode for a radio list to choose an image from the image FILES in the theme.
 *
 * @param  string $selected_path The currently selected image path (blank for none)
 * @param  URLPATH $base_url The base URL to where we are searching for images
 * @param  PATH $base_path The base-path to where we are searching for images
 * @return Tempcode The generated Tempcode
 */
function combo_get_image_paths($selected_path, $base_url, $base_path)
{
    $out = new Tempcode();

    $paths = get_image_paths($base_url, $base_path);
    $i = 0;
    foreach ($paths as $pretty => $url) {
        $checked = (($url == $selected_path) || (($selected_path == '') && ($i == 0)));
        $out->attach(do_template('FORM_SCREEN_INPUT_RADIO_LIST_ENTRY_PICTURE', array('_GUID' => 'd2ff01291e5f0c0e4cf4ee5b6061593c', 'CHECKED' => $checked, 'NAME' => 'path', 'VALUE' => $url, 'URL' => $url, 'PRETTY' => $pretty)));
        $i++;
    }

    return $out;
}

/**
 * Search under a base path for image FILE URLs.
 *
 * @param  URLPATH $base_url The base URL to where we are searching for images
 * @param  PATH $base_path The base-path to where we are searching for images
 * @return array path->url map of found images
 */
function get_image_paths($base_url, $base_path)
{
    $out = array();

    require_code('images');
    require_code('files');

    $handle = @opendir($base_path);
    if ($handle !== false) {
        while (false !== ($file = readdir($handle))) {
            if (!should_ignore_file($file, IGNORE_ACCESS_CONTROLLERS)) {
                $this_path = $base_path . $file;
                if (is_file($this_path)) {
                    if (is_image($file, IMAGE_CRITERIA_NONE)) {
                        $this_url = $base_url . rawurlencode($file);
                        $out[$this_path] = $this_url;
                    }
                } elseif ((strlen($file) != 2) || (strtoupper($file) != $file)) {
                    $out = array_merge($out, get_image_paths($base_url . $file . '/', $base_path . $file . '/'));
                }
            }
        }
        closedir($handle);
    }

    return $out;
}

/**
 * Get all the themes image codes. THIS DOES NOT SEARCH THE DB - DO NOT USE UNLESS IT'S ON A PURE PACKAGED THEME.
 *
 * @param  PATH $base_path The base-path to where we are searching for images
 * @param  PATH $search_under The path to search under, relative to the base-path. This is not the same as the base-path, as we are cropping paths to the base-path
 * @param  boolean $recurse Whether to search recursively from the given directory
 * @return array A list of image codes
 */
function get_all_image_codes($base_path, $search_under, $recurse = true)
{
    $out = array();

    require_code('images');
    require_code('files');

    if (!file_exists($base_path . '/' . $search_under)) {
        return array();
    }
    $handle = @opendir($base_path . '/' . $search_under);
    if ($handle !== false) {
        while (false !== ($file = readdir($handle))) {
            if (!should_ignore_file($file, IGNORE_ACCESS_CONTROLLERS)) {
                $full_path = $base_path . '/' . $search_under . '/' . $file;
                if (is_file($full_path)) {
                    if (is_image($file, IMAGE_CRITERIA_NONE)) {
                        $dot_pos = strrpos($file, '.');
                        if ($dot_pos === false) {
                            $dot_pos = strlen($file);
                        }
                        $_file = substr($file, 0, $dot_pos);
                        $short_path = ($search_under == '') ? $_file : ($search_under . '/' . $_file);
                        $out[$short_path] = 1;
                    }
                } elseif ((strlen($file) != 2) || (strtoupper($file) != $file)) {
                    if ($recurse) {
                        $out += get_all_image_codes($base_path, $search_under . '/' . $file);
                    }
                }
            }
        }
        closedir($handle);
    }

    return $out;
}

/**
 * Get Tempcode for a dropdown to choose a theme from the themes present.
 *
 * @param  ?ID_TEXT $it The currently selected image ID (null: none selected)
 * @param  ?string $filter An SQL where clause (including the WHERE), that filters the query somehow (null: none)
 * @param  boolean $do_id Whether to show IDs as the list entry captions, rather than paths
 * @param  boolean $include_all Whether to include images not yet used (i.e not in theme_images map yet)
 * @return Tempcode Tempcode for a list selection of theme images
 * @param  string $under Only include images under this path. Including a trailing slash unless you specifically want to filter allowing filename stubs as well as paths (blank: no limitation)
 */
function create_selection_list_theme_images($it = null, $filter = null, $do_id = false, $include_all = false, $under = '')
{
    $out = new Tempcode();
    if (!$include_all) {
        $rows = $GLOBALS['SITE_DB']->query('SELECT id,path FROM ' . get_table_prefix() . 'theme_images WHERE ' . db_string_equal_to('theme', $GLOBALS['FORUM_DRIVER']->get_theme()) . ' ' . $filter . ' ORDER BY path');
        foreach ($rows as $myrow) {
            $id = $myrow['id'];

            if (substr($id, 0, strlen($under)) != $under) {
                continue;
            }

            $selected = ($id == $it);

            $out->attach(form_input_list_entry($id, $selected, ($do_id) ? $id : $myrow['path']));
        }
    } else {
        $rows = get_all_image_ids_type($under, true);
        foreach ($rows as $id) {
            if (substr($id, 0, strlen($under)) != $under) {
                continue;
            }

            $selected = ($id == $it);

            $out->attach(form_input_list_entry($id, $selected));
        }
    }

    return $out;
}

/**
 * Delete a theme image used for a resource that was added, but only if the theme image is now unused.
 *
 * @param  ?ID_TEXT $new The new theme image (null: no new one)
 * @param  ID_TEXT $old The old theme image we might be tidying up
 * @param  ID_TEXT $table Table to check against
 * @param  ID_TEXT $field Field in table
 * @param  ?object $db Database connector to check against (null: site database)
 */
function tidy_theme_img_code($new, $old, $table, $field, $db = null)
{
    if ($new === $old) {
        return; // Still being used
    }

    $path = ($old == '') ? null : find_theme_image($old, true, true);
    if (($path === null) || ($path == '')) {
        return;
    }

    if ((strpos($path, '/images_custom/') !== false) && ($GLOBALS['SITE_DB']->query_select_value('theme_images', 'COUNT(DISTINCT id)', array('path' => $path)) == 1)) {
        if ($db === null) {
            $db = $GLOBALS['SITE_DB'];
        }
        $count = $db->query_select_value($table, 'COUNT(*)', array($field => $old));
        if ($count == 0) {
            @unlink(get_custom_file_base() . '/' . $path);
            sync_file(get_custom_file_base() . '/' . $path);
            $GLOBALS['SITE_DB']->query_delete('theme_images', array('id' => $old));
        }
    }
}

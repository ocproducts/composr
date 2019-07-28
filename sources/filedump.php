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
 * @package    filedump
 */

/**
 * Find broken filedump links, and try and find how to fix it.
 *
 * @return array Filedump broken links, to replacement path (or null)
 */
function find_broken_filedump_links()
{
    $paths_broken = array();

    require_code('files2');
    $all_files = get_directory_contents(get_custom_file_base() . '/uploads/filedump', '', IGNORE_ACCESS_CONTROLLERS, true);

    $paths_used = find_filedump_links();
    foreach ($paths_used as $path => $details) {
        if (!$details['exists']) {
            foreach ($all_files as $file) {
                if (basename($file) == basename($path)) {
                    $paths_broken[$path] = '/' . $file;
                    continue 2;
                }
            }
            $paths_broken[$path] = null;
        }
    }

    return $paths_broken;
}

/**
 * Remap pre-existing filedump links from one path to another.
 *
 * @param  string $from Old path (give a path relative to uploads/filedump, with leading slash)
 * @param  string $to New path (give a path relative to uploads/filedump, with leading slash)
 */
function update_filedump_links($from, $to)
{
    if ($to == '') {
        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
    }
    if (substr($to, 0, 1) != '/') {
        $to = '/' . $to;
    }

    $current = find_filedump_links($from);

    $from = str_replace('%2F', '/', rawurlencode($from));
    $to = str_replace('%2F', '/', rawurlencode($to));

    $patterns = array(
        '#"uploads/filedump(' . preg_quote($from, '#') . ')"#' => '"uploads/filedump' . $to . '"',
        '#\]uploads/filedump(' . preg_quote($from, '#') . ')\[#' => ']uploads/filedump' . $to . '[',
        '#\]url_uploads/filedump(' . preg_quote($from, '#') . ')\[#' => ']url_uploads/filedump' . $to . '[',
        '#"' . preg_quote(get_custom_base_url(), '#') . '/uploads/filedump(' . preg_quote($from, '#') . ')"#' => '"' . get_custom_base_url() . '/uploads/filedump' . $to . '"',
        '#\]' . preg_quote(get_custom_base_url(), '#') . '/uploads/filedump(' . preg_quote($from, '#') . ')\[#' => ']' . get_custom_base_url() . '/uploads/filedump' . $to . '[',
        '#\]url_' . preg_quote(get_custom_base_url(), '#') . '/uploads/filedump(' . preg_quote($from, '#') . ')\[#' => ']url_' . get_custom_base_url() . '/uploads/filedump' . $to . '[',
    );

    foreach ($current as $details) {
        foreach ($details['references'] as $ref) {
            if (is_array($ref)) {
                $old_comcode = get_translated_text($ref[0][$ref[1]]);
            } else {
                list($zone, $page, $lang) = explode(':', $ref, 3);
                $path = get_custom_file_base() . (($zone == '') ? '' : '/') . $zone . '/pages/comcode_custom/' . $lang . '/' . $page . '.txt';
                $old_comcode = file_get_contents($path);
            }

            $new_comcode = $old_comcode;
            foreach ($patterns as $pattern_from => $pattern_to) {
                $new_comcode = preg_replace($pattern_from, $pattern_to, $new_comcode);
            }

            if (is_array($ref)) {
                lang_remap_comcode($ref[1], $ref[0][$ref[1]], $new_comcode);
            } else {
                require_code('files');
                cms_file_put_contents_safe($path, $new_comcode, FILE_WRITE_FIX_PERMISSIONS | FILE_WRITE_SYNC_FILE);
            }
        }
    }
}

/**
 * Find all filedump links used.
 *
 * @param  string $focus Focus on a particular filedump file (give a path relative to uploads/filedump, with leading slash) (blank: no filter)
 * @return array Filedump links used, and where
 */
function find_filedump_links($focus = '')
{
    $paths_used = array();

    $_focus = str_replace('%2F', '/', rawurlencode($focus));

    // Comcode
    global $TABLE_LANG_FIELDS_CACHE;
    foreach ($TABLE_LANG_FIELDS_CACHE as $table => $fields) {
        foreach ($fields as $field_name => $field_type) {
            if (strpos($field_type, 'LONG_TRANS__COMCODE') !== false) {
                $query = 'SELECT r.* FROM ' . get_table_prefix() . $table . ' r WHERE 1=1';
                $_field_name = $GLOBALS['SITE_DB']->translate_field_ref($field_name);
                if ($GLOBALS['SITE_DB']->has_full_text()) { // For efficiency, pre-filter via full-text search
                    $index_name = $GLOBALS['SITE_DB']->query_select_value_if_there('db_meta_indices', 'i_name', array('i_table' => $table, 'i_fields' => $field_name), ' AND i_name LIKE \'' . db_encode_like('#%') . '\'');
                    if ($index_name !== null) {
                        $query .= ' AND ' . preg_replace('#\?#', $_field_name, $GLOBALS['SITE_DB']->full_text_assemble('filedump', false));
                    }
                }
                if ($focus == '') {
                    $query .= ' AND ' . $_field_name . ' LIKE \'' . db_encode_like('%uploads/filedump/%') . '\'';
                } else {
                    $query .= ' AND ' . $_field_name . ' LIKE \'' . db_encode_like('%uploads/filedump' . $_focus . '%') . '\'';
                }
                $db = get_db_for($table);
                $results = $db->query($query, null, 0, false, false, array($field_name => $field_type));
                foreach ($results as $r) {
                    extract_filedump_links(get_translated_text($r[$field_name]), array($r, $field_name), $focus, $paths_used);
                }
            }
        }
    }

    // Comcode pages
    $zones = find_all_zones(false, false, true);
    $langs = array_keys(find_all_langs());
    foreach ($zones as $zone) {
        $pages = find_all_pages_wrap($zone, false, false, FIND_ALL_PAGES__ALL, 'comcode');
        foreach ($pages as $page => $page_type) {
            if (is_integer($page)) {
                $page = strval($page);
            }
            foreach ($langs as $lang) {
                $path = get_custom_file_base() . (($zone == '') ? '' : '/') . $zone . '/pages/comcode_custom/' . $lang . '/' . $page . '.txt';
                if (is_file($path)) {
                    $comcode = file_get_contents($path);
                    extract_filedump_links($comcode, $zone . ':' . $page . ':' . $lang, $focus, $paths_used);
                }
            }
        }
    }

    return $paths_used;
}

/**
 * Find filedump links within some Comcode (an approximation).
 *
 * @param  string $comcode Comcode to scan
 * @param  mixed $identifier An identifier for where this Comcode was from
 * @param  string $focus Focus on a particular filedump file (give a path relative to uploads/filedump), with leading slash (blank: no filter)
 * @param  array $paths_used Paths found (passed by reference)
 */
function extract_filedump_links($comcode, $identifier, $focus, &$paths_used)
{
    $_focus = str_replace('%2F', '/', rawurlencode($focus));

    if ($focus == '') {
        $patterns = array(
            '#"uploads/filedump(/[^"]+)"#',
            '#\]uploads/filedump(/[^\[\]]+)\[#',
            '#\]url_uploads/filedump(/[^\[\]]+)\[#',
            '#"' . preg_quote(get_custom_base_url(), '#') . '/uploads/filedump(/[^"]+)"#',
            '#\]' . preg_quote(get_custom_base_url(), '#') . '/uploads/filedump(/[^\[\]]+)\[#',
            '#\]url_' . preg_quote(get_custom_base_url(), '#') . '/uploads/filedump(/[^\[\]]+)\[#',
        );
    } else {
        $patterns = array(
            '#"uploads/filedump(' . preg_quote($_focus, '#') . ')"#',
            '#\]uploads/filedump(' . preg_quote($_focus, '#') . ')\[#',
            '#\]url_uploads/filedump(' . preg_quote($_focus, '#') . ')\[#',
            '#"' . preg_quote(get_custom_base_url(), '#') . '/uploads/filedump(' . preg_quote($_focus, '#') . ')"#',
            '#\]' . preg_quote(get_custom_base_url(), '#') . '/uploads/filedump(' . preg_quote($_focus, '#') . ')\[#',
            '#\]url_' . preg_quote(get_custom_base_url(), '#') . '/uploads/filedump(' . preg_quote($_focus, '#') . ')\[#',
        );
    }

    foreach ($patterns as $pattern) {
        $matches = array();
        $num_matches = preg_match_all($pattern, $comcode, $matches);
        for ($i = 0; $i < $num_matches; $i++) {
            $decoded = urldecode(html_entity_decode($matches[1][$i], ENT_QUOTES)); // This is imperfect (raw naming that coincidentally matches entity encoding will break), but good enough

            if (strpos($decoded, '*') !== false) { // False positive, some kind of exemplar test
                continue;
            }

            $path = get_custom_file_base() . '/uploads/filedump' . $decoded;

            if (!isset($paths_used[$decoded])) {
                $paths_used[$decoded] = array(
                    'exists' => is_file($path),
                    'references' => array(),
                );
            }

            if (!in_array($identifier, $paths_used[$decoded]['references'])) {
                $paths_used[$decoded]['references'][] = $identifier;
            }
        }
    }
}


/**
 * Check a filedump file uploaded correctly.
 *
 * @param  array $file The $_FILES-array-style row
 * @return ?Tempcode Error message (null: none)
 */
function check_filedump_uploaded($file)
{
    require_lang('filedump');

    require_code('files2');

    require_code('uploads');
    is_plupload(true);

    // Error?
    if ((!is_plupload()) && (!is_uploaded_file($file['tmp_name']))) {
        $max_size = get_max_file_size();
        if (($file['error'] == 1) || ($file['error'] == 2)) {
            return do_lang_tempcode('FILE_TOO_BIG', escape_html(integer_format($max_size)));
        } elseif ((isset($file)) && (($file['error'] == 3) || ($file['error'] == 6) || ($file['error'] == 7))) {
            return do_lang_tempcode('ERROR_UPLOADING_' . strval($file['error']));
        } else {
            return do_lang_tempcode('ERROR_UPLOADING');
        }
    }

    // Too big?
    $max_size = get_max_file_size();
    if ($file['size'] > $max_size) {
        return do_lang_tempcode('FILE_TOO_BIG', escape_html(integer_format(intval($max_size))));
    }

    return null;
}

/**
 * Add a filedump file to the system, moving in the file and adding a description to the database.
 *
 * @param  string $subpath Whether it is being stored under uploads/filedump
 * @param  string $filename The filename
 * @param  string $tmp_path The temporary file path
 * @param  string $description The description
 * @param  ?boolean $plupload_based Whether this is a Plupload (i.e. from a faked $_FILES-array-row) (null: work out from environment)
 * @param  boolean $check_permissions Check access permissions
 * @return ?Tempcode Error message (null: no error)
 */
function add_filedump_file($subpath, &$filename, $tmp_path, $description = '', $plupload_based = null, $check_permissions = true)
{
    require_lang('filedump');

    if ($plupload_based === null) {
        $plupload_based = is_plupload();
    }

    if ($check_permissions) {
        if (!has_privilege(get_member(), 'upload_filedump')) {
            access_denied('I_ERROR');
        }
    }

    _check_filedump_filename($subpath, $filename, $check_permissions);

    $full = get_custom_file_base() . '/uploads/filedump' . $subpath . $filename;

    // Conflict?
    $owner = $GLOBALS['SITE_DB']->query_select_value_if_there('filedump', 'the_member', array('name' => cms_mb_substr($filename, 0, 80), 'subpath' => cms_mb_substr($subpath, 0, 80)));
    if ((!$check_permissions) || (($owner !== null) && ($owner == get_member())) || (has_privilege(get_member(), 'delete_anything_filedump'))) {
        @unlink($full);
    }
    if (file_exists($full)) { // Could not delete apparently
        return do_lang_tempcode('OVERWRITE_ERROR');
    }

    // Save in file
    if ($plupload_based) {
        $test = @rename($tmp_path, $full);
        if (!$test) {
            return do_lang_tempcode('FILE_MOVE_ERROR', escape_html($filename), escape_html('uploads/filedump' . $subpath));
        }
    } else {
        $test = @move_uploaded_file($tmp_path, $full);
        if (!$test) {
            return do_lang_tempcode('FILE_MOVE_ERROR', escape_html($filename), escape_html('uploads/filedump' . $subpath));
        }
    }
    fix_permissions($full);
    sync_file($full);

    // Add description
    $description_l = $GLOBALS['SITE_DB']->query_select_value_if_there('filedump', 'the_description', array('name' => cms_mb_substr($filename, 0, 80), 'subpath' => cms_mb_substr($subpath, 0, 80)));
    if ($description_l !== null) {
        delete_lang($description_l);
        $GLOBALS['SITE_DB']->query_delete('filedump', array('name' => cms_mb_substr($filename, 0, 80), 'subpath' => cms_mb_substr($subpath, 0, 80)), '', 1);
    }
    $map = array(
        'name' => cms_mb_substr($filename, 0, 80),
        'subpath' => cms_mb_substr($subpath, 0, 80),
        'the_member' => get_member(),
    );
    $map += insert_lang('the_description', $description, 3);
    $GLOBALS['SITE_DB']->query_insert('filedump', $map);

    // Logging etc
    require_code('notifications');
    $subject = do_lang('FILEDUMP_NOTIFICATION_MAIL_SUBJECT', get_site_name(), $filename, $subpath);
    $mail = do_notification_lang('FILEDUMP_NOTIFICATION_MAIL', comcode_escape(get_site_name()), comcode_escape($filename), array(comcode_escape($subpath), comcode_escape($description)));
    dispatch_notification('filedump', $subpath, $subject, $mail);
    log_it('FILEDUMP_UPLOAD', $filename, $subpath);
    require_code('users2');
    if (has_actual_page_access(get_modal_user(), 'filedump', get_module_zone('filedump'))) {
        require_code('activities');
        syndicate_described_activity('filedump:ACTIVITY_FILEDUMP_UPLOAD', $subpath . '/' . $filename, '', '', '', '', '', 'filedump');
    }

    return null;
}

/**
 * Check a filedump filename is going to be valid / repair it if possible.
 *
 * @param  string $subpath Whether it is being stored under uploads/filedump
 * @param  string $filename The filename
 * @param  boolean $check_permissions Check access permissions
 *
 * @ignore
 */
function _check_filedump_filename(&$subpath, &$filename, $check_permissions = true)
{
    $subpath = filter_naughty($subpath);

    // Security
    if ($check_permissions) {
        if ((!has_privilege(get_member(), 'upload_anything_filedump')) || (get_file_base() != get_custom_file_base()/*demonstratr*/)) {
            check_extension($filename);
        }
    }

    // Don't allow double file extensions, huge security risk with Apache
    $filename = str_replace('.', '-', basename($filename, '.' . get_file_extension($filename))) . '.' . get_file_extension($filename);
}

/**
 * Input a filedump filename.
 *
 * @param  ?string $it Current selection (null: none)
 * @param  boolean $only_images Restrict to image input
 * @param  ?ID_TEXT $base The base path to do under (null: root)
 * @return Tempcode Selection list
 */
function nice_get_filedump_files($it, $only_images = false, $base = null)
{
    $out = '';

    require_code('images');
    require_code('files2');
    $full_path = get_custom_file_base() . '/uploads/filedump';
    if (!empty($base)) {
        $full_path .= '/' . $base;
    }
    $tree = get_directory_contents($full_path, '');
    cms_mb_sort($tree, SORT_NATURAL | SORT_FLAG_CASE);

    foreach ($tree as $f) {
        if ((!$only_images) || (is_image($f, IMAGE_CRITERIA_WEBSAFE, true))) {
            $rel = ($base === null) ? $f : preg_replace('#^' . preg_quote($base, '#') . '/#', '', $f);
            $out .= '<option value="' . escape_html('uploads/filedump/' . $f) . '"' . (($it === $f) ? ' selected="selected"' : '') . '>' . escape_html($rel) . '</option>' . "\n";
        }
    }

    return make_string_tempcode($out);
}

/**
 * Input a filedump file-path.
 *
 * @param  ?string $it Current selection (null: none)
 * @param  ?ID_TEXT $base The base path to do under (null: root)
 * @return Tempcode Selection list
 */
function nice_get_filedump_places($it, $base = null)
{
    $out = '';

    require_code('images');
    require_code('files2');
    $full_path = get_custom_file_base() . '/uploads/filedump';
    if (!empty($base)) {
        $full_path .= '/' . $base;
    }

    $directories = get_directory_contents($full_path, '', IGNORE_ACCESS_CONTROLLERS, true, false);
    $directories[] = '';
    cms_mb_sort($directories, SORT_NATURAL | SORT_FLAG_CASE);

    foreach ($directories as $d) {
        $rel = ($base === null) ? $d : preg_replace('#^' . preg_quote($base, '#') . '/#', '', $d);
        $out .= '<option value="/' . escape_html($d) . (($d == '') ? '' : '/') . '"' . (($it === $d) ? ' selected="selected"' : '') . '>/' . escape_html($rel) . '</option>' . "\n";
    }

    return make_string_tempcode($out);
}

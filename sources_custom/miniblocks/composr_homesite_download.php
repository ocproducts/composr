<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_homesite
 */

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

require_lang('composr_homesite');
require_code('composr_homesite');
require_lang('downloads');

// Put together details about releases
$t = $GLOBALS['SITE_DB']->query_select_value_if_there('download_downloads', 'name', array($GLOBALS['SITE_DB']->translate_field_ref('description') => 'This is the latest version.'));
if (is_null($t)) {
    $t = $GLOBALS['SITE_DB']->query_select_value_if_there('download_downloads', 'name', array('author' => 'ocProducts', 'validated' => 1));
    if ($t !== null) {
        $t = preg_replace('# \(.*#', '', $t);
    }
}
$_releases = array();
if ($t !== null) {
    $latest = get_translated_text($t);
    $release_quick = do_release($latest, 'QUICK_');
    if (!is_null($release_quick)) {
        $_releases += $release_quick;
    }
    $release_manual = do_release($latest . ' (manual)', 'MANUAL_');
    if (!is_null($release_manual)) {
        $_releases += $release_manual;
    }
    $release_bleedingquick = do_release('(bleeding-edge)', 'BLEEDINGQUICK_', is_null($release_quick) ? null : $release_quick['QUICK_VERSION']);
    if (!is_null($release_bleedingquick)) {
        $_releases += $release_bleedingquick;
    }
    $release_bleedingmanual = do_release('(bleeding-edge, manual)', 'BLEEDINGMANUAL_', is_null($release_manual) ? null : $release_manual['MANUAL_VERSION']);
    if (!is_null($release_bleedingmanual)) {
        $_releases += $release_bleedingmanual;
    }
}

if ($_releases === array()) {
    $latest = do_lang('NA');
    $releases = paragraph(do_lang_tempcode('CMS_BETWEEN_VERSIONS'));
} else {
    $releases = do_template('CMS_DOWNLOAD_RELEASES', $_releases);
}

return do_template('CMS_DOWNLOAD_BLOCK', array('_GUID' => '4c4952e40ed96ab52461adce9989832d', 'RELEASES' => $releases, 'VERSION' => $latest));

/**
 * Get template variables for a release.
 *
 * @param  SHORT_TEXT $name A substring of the title of the download.
 * @param  string $prefix Prefix to put on the template params.
 * @param  ?string $version_must_be_newer_than The version this must be newer than (null: no check).
 * @return ?array Map of template variables (null: could not find).
 */
function do_release($name, $prefix, $version_must_be_newer_than = null)
{
    $sql = 'SELECT d.*,d.id AS d_id FROM ' . get_table_prefix() . 'download_downloads d USE INDEX(downloadauthor) WHERE ' . db_string_equal_to('author', 'ocProducts') . ' AND validated=1 AND ' . $GLOBALS['SITE_DB']->translate_field_ref('name') . ' LIKE \'' . db_encode_like('%' . $name) . '\' ORDER BY add_date DESC';
    $rows = $GLOBALS['SITE_DB']->query($sql, 1, null, false, false, array('name' => 'SHORT_TRANS'));
    if (!array_key_exists(0, $rows)) {
        return null; // Shouldn't happen, but let's avoid transitional errors
    }

    if (!is_null($version_must_be_newer_than)) {
        if (strpos($version_must_be_newer_than, '.') === false) {
            $version_must_be_newer_than .= '.0.0'; // Weird, but PHP won't do version_compare right without it
        }
    }

    $myrow = $rows[0];

    $id = $myrow['d_id'];

    $num_downloads = $myrow['num_downloads'];

    $keep = symbol_tempcode('KEEP');
    $url = find_script('dload', false, 1) . '?id=' . strval($id) . $keep->evaluate();

    require_code('version2');
    $t = get_translated_text($myrow['name']);
    $t = preg_replace('# \(.*#', '', $t);
    $version = get_version_dotted__from_anything($t);

    require_code('files');
    $filesize = clean_file_size($myrow['file_size']);

    if (!is_null($version_must_be_newer_than)) {
        if (version_compare($version_must_be_newer_than, $version) == 1) {
            return null;
        }
    }

    $ret = array();
    $ret[$prefix . 'VERSION'] = $version;
    $ret[$prefix . 'NAME'] = $name;
    $ret[$prefix . 'FILESIZE'] = $filesize;
    $ret[$prefix . 'NUM_DOWNLOADS'] = number_format($num_downloads);
    $ret[$prefix . 'URL'] = $url;
    return $ret;
}

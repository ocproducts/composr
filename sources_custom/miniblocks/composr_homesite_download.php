<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_homesite
 */

if (!function_exists('do_release')) {
    /**
     * Get template variables for a release.
     *
     * @param  SHORT_TEXT $name_suffix A substring of the title of the download.
     * @param  string $prefix Prefix to put on the template params.
     * @param  ?string $version_must_be_newer_than The version this must be newer than (null: no check).
     * @return ?array Map of template variables (null: could not find).
     */
    function do_release($name_suffix, $prefix, $version_must_be_newer_than = null)
    {
        if ($GLOBALS['DEV_MODE']) {
            $t = 'Composr version 1337';

            $myrow = array(
                'd_id' => 123,
                'num_downloads' => 321,
                'name' => $name_suffix,
                'file_size' => 12345,
            );
        } else {
            $sql = 'SELECT d.num_downloads,d.name,d.file_size,d.id AS d_id FROM ' . get_table_prefix() . 'download_downloads d';
            if (strpos(get_db_type(), 'mysql') !== false) {
                $sql .= ' FORCE INDEX (downloadauthor)';
            }
            $sql .= ' WHERE ' . db_string_equal_to('author', 'ocProducts') . ' AND validated=1 AND ' . $GLOBALS['SITE_DB']->translate_field_ref('name') . ' LIKE \'' . db_encode_like('%' . $name_suffix) . '\' ORDER BY add_date DESC';
            $rows = $GLOBALS['SITE_DB']->query($sql, 1, null, false, false, array('name' => 'SHORT_TRANS'));
            if (!array_key_exists(0, $rows)) {
                return null; // Shouldn't happen, but let's avoid transitional errors
            }

            $myrow = $rows[0];
        }

        if ($version_must_be_newer_than !== null) {
            if (strpos($version_must_be_newer_than, '.') === false) {
                $version_must_be_newer_than .= '.0.0'; // Weird, but PHP won't do version_compare right without it
            }
        }

        $id = $myrow['d_id'];

        $num_downloads = $myrow['num_downloads'];

        $keep = symbol_tempcode('KEEP');
        $url = find_script('dload', false, 1) . '?id=' . strval($id) . $keep->evaluate();

        require_code('version2');
        $t = get_translated_text($myrow['name']);
        $t = preg_replace('# \(.*#', '', $t);
        $version = get_version_pretty__from_dotted(get_version_dotted__from_anything($t));

        require_code('files');
        $filesize = clean_file_size($myrow['file_size']);

        if ($version_must_be_newer_than !== null) {
            if (version_compare($version_must_be_newer_than, $version) == 1) {
                return null;
            }
        }

        $ret = array();
        $ret[$prefix . 'VERSION'] = $version;
        $ret[$prefix . 'NAME'] = $name_suffix;
        $ret[$prefix . 'FILESIZE'] = $filesize;
        $ret[$prefix . 'NUM_DOWNLOADS'] = integer_format($num_downloads);
        $ret[$prefix . 'URL'] = $url;
        return $ret;
    }
}

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

require_lang('composr_homesite');
require_code('composr_homesite');
require_lang('downloads');

// Put together details about releases
$t = get_latest_version_pretty();
if (($t === null) && ($GLOBALS['DEV_MODE'])) {
    $t = '1337';
}
$releases_tpl_map = array();
if ($t !== null) {
    $latest = $t;

    $release_quick = do_release('Composr version ' . $latest, 'QUICK_');
    $release_manual = do_release('Composr version ' . $latest . ' (manual)', 'MANUAL_');
    $release_bleedingquick = do_release('(bleeding-edge)', 'BLEEDINGQUICK_', ($release_quick === null) ? null : $release_quick['QUICK_VERSION']);
    $release_bleedingmanual = do_release('(bleeding-edge, manual)', 'BLEEDINGMANUAL_', ($release_manual === null) ? null : $release_manual['MANUAL_VERSION']);

    if ($release_quick !== null) {
        $releases_tpl_map += $release_quick;
    } else {
        if ($release_manual !== null) {
            if ($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
                attach_message('Could not find quick version but there is a manual one.', 'warn');
            }
        }
    }

    if ($release_manual !== null) {
        $releases_tpl_map += $release_manual;
    } else {
        if ($release_quick !== null) {
            if ($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
                attach_message('Could not find manual version but there is a quick one.', 'warn');
            }
        }
    }

    if (($release_quick !== null) && ($release_manual !== null)) {
        if ($release_quick['VERSION'] != $release_manual['VERSION']) {
            if ($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
                attach_message('Latest quick and manual versions are mismatching.', 'warn');
            }
        }
    }

    if ($release_bleedingquick !== null) {
        $releases_tpl_map += $release_bleedingquick;
    } else {
        if ($release_bleedingmanual !== null) {
            if ($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
                attach_message('Could not find quick bleeding-edge version but there is a manual one.', 'warn');
            }
        }
    }

    if ($release_bleedingmanual !== null) {
        $releases_tpl_map += $release_bleedingmanual;
    } else {
        if ($release_bleedingquick !== null) {
            if ($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
                attach_message('Could not find manual bleeding-edge version but there is a quick one.', 'warn');
            }
        }
    }

    if (($release_bleedingquick !== null) && ($release_bleedingmanual !== null)) {
        if ($release_bleedingquick['VERSION'] != $release_bleedingmanual['VERSION']) {
            if ($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
                attach_message('Latest quick and manual bleeding-edge versions are mismatching.', 'warn');
            }
        }
    }

    if ($release_quick['VERSION'] !== null || $release_bleedingquick['VERSION'] !== null) {
        if ($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
            $_latest = isset($release_quick['VERSION']) ? $release_quick['VERSION'] : $release_bleedingquick['VERSION'];

            $title = 'Composr ' . $_latest . ' released!';
            $news_post_id = $GLOBALS['SITE_DB']->query_select_value_if_there('news', 'id', array('title' => $title, 'validated' => 1));
            if ($news_post_id === null) {
                attach_message('Could not find matching release news post, ' . $title . '.', 'warn');
            }

            // LEGACY
            $omni_post_id = null;
            if ($release_quick === null) {
                $omni_post_id = 2;
            }
            if ($omni_post_id !== null) {
                if ($news_post_id !== null) {
                    $news_in_gap = $GLOBALS['SITE_DB']->query_value_if_there('SELECT id FROM ' . get_table_prefix() . 'news WHERE id>' . strval($omni_post_id) . ' AND id<' . $news_post_id . ' AND validated=1');
                    if ($news_in_gap > 1) {
                        attach_message('Too much news on front page, between omni-upgrader and latest version news post.', 'warn');
                    }
                }

                $news_article = get_translated_text($GLOBALS['SITE_DB']->query_select_value('news', 'news_article', array('id' => $omni_post_id)));
                $path = 'uploads/downloads/composr_upgrader-' . get_version_dotted__from_anything($_latest) . '.cms';
                if (strpos($news_article, $path) === false) {
                    attach_message('Omni-upgrader not correct for news post #' . strval($omni_post_id) . ', should be ' . $path . '.', 'warn');
                }
            }
        }
    }
} else {
    if ($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
        attach_message('Could not find any versions.', 'warn');
    }
}

if ($releases_tpl_map === array()) {
    $latest = do_lang('NA');
    $releases_tpl = paragraph(do_lang_tempcode('CMS_BETWEEN_VERSIONS'));
} else {
    $releases_tpl = do_template('CMS_DOWNLOAD_RELEASES', $releases_tpl_map);
}

return do_template('CMS_DOWNLOAD_BLOCK', array('_GUID' => '4c4952e40ed96ab52461adce9989832d', 'RELEASES' => $releases_tpl, 'VERSION' => $latest));

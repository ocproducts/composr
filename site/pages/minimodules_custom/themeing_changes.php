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

require_code('composr_homesite');
require_code('diff');

$releases = get_release_tree();

// Unzip all releases
foreach ($releases as $version => $release) {
    $full_path = get_file_base() . '/uploads/website_specific/compo.sr/upgrades/full/' . $version;

    if (file_exists($full_path)) {
        continue;
    }

    @mkdir($full_path, 0777, true);
    if (!url_is_local($release['url'])) {
        warn_exit(escape_html('Non-local URL found (' . $release['url'] . '). Unexpected.'));
    }
    recursive_unzip(get_file_base() . '/' . rawurldecode($release['url']), $full_path);
}

$title = get_screen_title('Themeing compatibility changes', false);
$title->evaluate_echo();

echo '<p>This auto-generated page shows all the default theme CSS changes made between versions.</p>';

$out = '';

// Do diffs between all releases
$css_path_old = null;
$version_old = null;
foreach (array_keys($releases) as $version) {
    $full_path = get_file_base() . '/uploads/website_specific/compo.sr/upgrades/full/' . $version;
    $css_path_new = $full_path . '/themes/default/css';
    $version_new = $version;

    if ($css_path_old !== null) {
        $out_for_jump = '';

        $dh = opendir($css_path_new);
        if ($dh !== false) {
            $files = array();
            while (($f = readdir($dh)) !== false) {
                $files[] = $f;
            }
            closedir($dh);
            sort($files);

            foreach ($files as $f) {
                if ((substr($f, -4) == '.css') && (is_file($css_path_old . '/' . $f))) {
                    $diff = diff_simple($css_path_old . '/' . $f, $css_path_new . '/' . $f, true);
                    if (trim($diff) != '' && trim($diff) != '<br />') {
                        $out_for_jump .= '<h3>' . escape_html($f) . '</h3>';
                        $out_for_jump .= '<div style="overflow: auto;">';
                        $out_for_jump .= '<code style="white-space: pre">';
                        $out_for_jump .= $diff;
                        $out_for_jump .= '</code>';
                        $out_for_jump .= '</div>';
                    }
                }
            }
        }

        if ($out_for_jump != '') {
            $out_for_jump = '<h2>' . escape_html($version_old) . ' &rarr; ' . escape_html($version_new) . '</h2>' . $out_for_jump;

            $out = $out_for_jump . $out;
        }
    }

    $css_path_old = $css_path_new;
    $version_old = $version_new;
}

echo $out;

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

restrictify();
safe_ini_set('ocproducts.xss_detect', '0');

$_title = get_screen_title('Composr addon building tool', false);
$_title->evaluate_echo();

echo '<p>This has built all the addons into <kbd>exports/addons</kbd>. The make_release script you probably came from gives details on how to get these live on compo.sr.</p>';

echo '<p>What follows is details if you are republishing addons and want to easily put out "This is updated" messages into the comment topics. It\'s not necessary because just uploading the TARs will make the inbuilt Composr check script see the addon is updated compared to when a user installed it. However, it is nice to keep users updated if you have time.</p>';

echo '<hr />';

require_code('addons2');
require_code('version');
require_code('version2');

if (php_function_allowed('set_time_limit')) {
    set_time_limit(0);
}

$only = get_param_string('only', null);

$done_addon = false;

$addons = find_all_hooks('systems', 'addon_registry');
foreach ($addons as $name => $place) {
    if (($only !== null) && ($only !== $name)) {
        continue;
    }

    if ((get_param_integer('export_bundled_addons', 0) == 0) && ($place == 'sources')) {// We are not normally concerned about these, but maybe it is useful sometimes
        continue;
    }
    if ((get_param_integer('export_addons', 1) == 0) && ($place == 'sources_custom')) {
        continue;
    }

    $addon_info = read_addon_info($name);

    // Archive it off to exports/addons
    $file = preg_replace('#^[\_\.\-]#', 'x', preg_replace('#[^\w\.\-]#', '_', $name)) . '-' . $addon_info['version'] . '.tar';

    $new_addon_files = array();
    foreach ($addon_info['files'] as $_file) {
        if (substr($_file, -9) != '.editfrom') {// This would have been added back in automatically
            $new_addon_files[] = $_file;
        }
    }

    create_addon(
        $file,
        $new_addon_files,
        $addon_info['name'],
        implode(',', $addon_info['incompatibilities']),
        implode(',', $addon_info['dependencies']),
        $addon_info['author'],
        $addon_info['organisation'],
        $addon_info['version'],
        $addon_info['category'],
        implode("\n", $addon_info['copyright_attribution']),
        $addon_info['licence'],
        $addon_info['description'],
        'exports/addons'
    );

    $done_addon = true;

	echo nl2br(escape_html(update_addon_descriptions($file, $name, $addon_info['description'])));
}
if ($done_addon) {
    echo "<p>Addons have been exported to <kbd>export/addons/</kbd></p>\n";
}

if (get_param_integer('export_themes', 0) == 1) {
    require_code('themes2');
    require_code('files');
    require_code('files2');
    $themes = find_all_themes();

    $page_files = get_directory_contents(get_custom_file_base() . '/', '');
    foreach (array_keys($themes) as $theme) {
        if (($only !== null) && ($only !== $theme)) {
            continue;
        }

        if ($theme == 'default') {
            continue;
        }

        $name = '';
        $incompatibilities = '';
        $dependencies = '';
        $author = 'ocProducts';
        $organisation = 'ocProducts Ltd';
        $version = '1.0';
        $copyright_attribution = '';
        $licence = '(Unstated)';
        $description = '';
        $ini_file = (($theme == 'default') ? get_file_base() : get_custom_file_base()) . '/themes/' . filter_naughty($theme) . '/theme.ini';
        if (file_exists($ini_file)) {
            $details = better_parse_ini_file($ini_file);

            if (array_key_exists('title', $details)) {
                $name = $details['title'];
            }
            if (array_key_exists('description', $details)) {
                $description = $details['description'];
            }
            if ((array_key_exists('author', $details)) && ($details['author'] != 'admin')) {
                $author = $details['author'];
            }
            if (array_key_exists('dependencies', $details)) {
                $dependencies = $details['dependencies'];
            }
            if (array_key_exists('organisation', $details)) {
                $organisation = $details['organisation'];
            }
            if (array_key_exists('version', $details)) {
                $version = $details['version'];
            }
            if (array_key_exists('copyright_attribution', $details)) {
                $copyright_attribution = implode("\n", $details['copyright_attribution']);
            }
            if (array_key_exists('licence', $details)) {
                $licence = $details['licence'];
            }
        }

        $file = 'theme-' . preg_replace('#^[\_\.\-]#', 'x', preg_replace('#[^\w\.\-]#', '_', $theme)) . '-' . get_version_branch() . '.tar';

        $files2 = array();
        $theme_files = get_directory_contents(get_custom_file_base() . '/themes/' . $theme, 'themes/' . $theme);
        foreach ($theme_files as $file2) {
            if ((substr($file2, -4) != '.tcp') && (substr($file2, -4) != '.tcd') && (substr($file2, -9) != '.editfrom')) {
                $files2[] = $file2;
            }
        }
        foreach ($page_files as $file2) {
            $matches = array();
            $regexp = '#^((\w+)/)?pages/comcode_custom/[^/]*/' . preg_quote($theme, '#') . '\_\_([\w\_]+)\.txt$#';
            if ((preg_match($regexp, $file2, $matches) != 0) && ($matches[1] != 'docs' . strval(cms_version()))) {
                $files2[] = dirname($file2) . '/' . substr(basename($file2), strlen($theme) + 2);
            }
        }

        $_GET['keep_theme_test'] = '1';
        $_GET['theme'] = $theme;

        create_addon(
            $file,
            $files2,
            $name,
            $incompatibilities,
            $dependencies,
            $author,
            $organisation,
            $version,
            'Themes',
            $copyright_attribution,
            $licence,
            $description,
            'exports/addons'
        );

		echo nl2br(escape_html(update_addon_descriptions($file, $name, $description)));
    }

    if ($only !== null) {
        echo "<p>All themes have been exported to <kbd>export/addons/</kbd></p>\n";
    }
}

echo "<hr /><p><strong>Done</strong></p>\n";

function update_addon_descriptions($file, $name, $description)
{
    $_description = addslashes($description);
return <<<END
	:\$GLOBALS['SITE_DB']->query_update('download_downloads', array('description' => '{$_description}'), array('url' => 'uploads/downloads/' . rawurlencode('{$file}')));
END;
}

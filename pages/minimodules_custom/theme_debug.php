<?php

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

echo '<p>Pick a theme&hellip;</p><ul class="spaced_list">';

$GLOBALS['NO_QUERY_LIMIT'] = true;

require_code('images');

// Find default images
$default_images = array();
foreach (array(get_custom_file_base() . '/themes/default/images', get_custom_file_base() . '/themes/default/images/EN') as $dir) {
    $dh = opendir($dir);
    while (($f = readdir($dh)) !== false) {
        if (is_image($f)) {
            $img_code = basename($f, '.' . get_file_extension($f));
            $default_images[$img_code] = 1;
        }
    }
    closedir($dh);
}

// Go through each theme
require_code('themes2');
$themes = find_all_themes();
if (count($themes) == 1) {
    warn_exit(do_lang_tempcode('NO_ENTRIES'));
}
foreach (array_keys($themes) as $theme) {
    if ($theme != 'default') {
        $groups = $GLOBALS['FORUM_DRIVER']->get_usergroup_list(true, true);
        foreach (array_keys($groups) as $gid) {
            $GLOBALS['SITE_DB']->query_insert('group_category_access', array('group_id' => $gid, 'module_the_name' => 'theme', 'category_name' => $theme), false, true);
        }

        echo '<li>';
        echo '<a href="' . static_evaluate_tempcode(build_url(array('page' => 'start', 'keep_theme_test' => '1', 'keep_theme' => $theme), '')) . '">' . escape_html($theme) . '</a><br />
                            <span class="associated_details">(Other useful views:
                                        <a href="' . static_evaluate_tempcode(build_url(array('page' => 'start', 'keep_theme_test' => '1', 'keep_theme' => $theme, 'keep_theme_seed' => '664422', 'keep_theme_algorithm' => 'hsv', 'keep_theme_source' => $theme), '')) . '">with brown seed</a> /
                                        <a href="' . static_evaluate_tempcode(build_url(array('page' => 'start', 'keep_theme_test' => '1', 'keep_theme' => $theme, 'keep_su' => 'Guest'), '')) . '">as Guest</a> /
                                        <a href="' . static_evaluate_tempcode(build_url(array('page' => 'cms_news', 'type' => 'add', 'keep_theme_test' => '1', 'keep_theme' => $theme), 'cms')) . '">Add News Form</a> /
                                        <a href="' . static_evaluate_tempcode(build_url(array('page' => 'news', 'keep_theme_test' => '1', 'type' => 'view', 'id' => 1, 'keep_theme' => $theme), 'site')) . '">News screen</a> /
                                        <a href="' . static_evaluate_tempcode(build_url(array('page' => '', 'keep_theme_test' => '1', 'keep_theme' => $theme), 'forum')) . '">forumview</a>)
                            </span>';

        // Find unreferenced images
        $dh = opendir(get_custom_file_base() . '/themes/' . $theme . '/images_custom');
        $images = array();
        while (($f = readdir($dh)) !== false) {
            if (is_image($f)) {
                $img_code = basename($f, '.' . get_file_extension($f));
                if (isset($images[$img_code])) {
                    echo '<br />Duplicated theme image: ' . escape_html($img_code);
                }
                $images[$img_code] = 1;
            }
        }
        $images_copy = $images + $default_images;
        closedir($dh);
        $missing_images = array();
        foreach (array(get_custom_file_base() . '/themes/' . $theme . '/css_custom', get_custom_file_base() . '/themes/' . $theme . '/templates_custom', get_custom_file_base() . '/themes/' . $theme . '/xml_custom', get_custom_file_base() . '/themes/' . $theme . '/text_custom', get_custom_file_base() . '/pages/comcode_custom/EN') as $dir) {
            $dh = opendir($dir);
            while (($f = readdir($dh)) !== false) {
                if ((substr($f, -4) == '.css') || (substr($f, -4) == '.tpl') || (substr($f, -3) == '.js') || (substr($f, -4) == '.xml') || ((substr($f, -4) == '.txt') && (strpos($dir, '/themes/') !== false)) || ((substr($f, -4) == '.txt') && (substr($f, 0, strlen($theme . '__')) == $theme . '__'))) {
                    $contents = file_get_contents($dir . '/' . $f);

                    // Test comment/brace balancing
                    if (substr($f, -4) == '.css') {
                        if (substr_count($contents, '{') != substr_count($contents, '}')) {
                            echo '<br />Mismatched braces in ' . escape_html($f);
                        }
                        if (substr_count($contents, '/*') != substr_count($contents, '*/')) {
                            echo '<br />Mismatched comments in ' . escape_html($f);
                        }
                    }

                    // Find missing images
                    $matches = array();
                    $num_matches = preg_match_all('#\{\$IMG.?,([^{}]+)\}#', $contents, $matches);
                    for ($i = 0; $i < $num_matches; $i++) {
                        if ((!isset($images_copy[$matches[1][$i]])) && (strpos($matches[1][$i], '/') === false/*we assume subdir images are fine, as non-default ones won't usually be in subdirs and we have not written recursive search code*/)) {
                            $missing_images[$matches[1][$i]] = 1;
                        }
                    }

                    // See if any of the theme images were used
                    foreach (array_keys($images) as $image) {
                        if (strpos($contents, ',' . $image . '}') !== false) {
                            unset($images[$image]);
                        }
                    }
                }
            }
            closedir($dh);
        }
        foreach (array_keys($images) as $image) {
            echo '<br />Unused theme image: ' . escape_html($image);
        }

        foreach (array_keys($missing_images) as $image) {
            echo '<br />Missing theme image: ' . escape_html($image);
        }

        echo '</li>';
    }
}

echo '</ul>';

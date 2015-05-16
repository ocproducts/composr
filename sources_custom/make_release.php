<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_release_build
 */

/*EXTRA FUNCTIONS: shell_exec|escapeshellarg*/

function init__make_release()
{
    require_code('files2');

    // Make sure builds folder exists
    get_builds_path();

    // Tracking
    global $MAKE_INSTALLERS__FILE_ARRAY, $MAKE_INSTALLERS__DIR_ARRAY, $MAKE_INSTALLERS__TOTAL_DIRS, $MAKE_INSTALLERS__TOTAL_FILES;
    $MAKE_INSTALLERS__FILE_ARRAY = array();
    $MAKE_INSTALLERS__DIR_ARRAY = array();
    $MAKE_INSTALLERS__TOTAL_DIRS = 0;
    $MAKE_INSTALLERS__TOTAL_FILES = 0;
}

function make_installers($skip_file_grab = false)
{
    global $MAKE_INSTALLERS__FILE_ARRAY, $MAKE_INSTALLERS__DIR_ARRAY, $MAKE_INSTALLERS__TOTAL_DIRS, $MAKE_INSTALLERS__TOTAL_FILES;

    require_code('files');

    // Start output
    $out = '';
    $out .= '<p>A Composr build is being compiled and packed up into installation packages.</p>';

    require_code('version2');
    $version_dotted = get_version_dotted();
    $version_branch = get_version_branch();

    // Make necessary directories
    $builds_path = get_builds_path();
    if (!file_exists($builds_path . '/builds/build/')) {
        @mkdir($builds_path . '/builds/build/', 0777) or warn_exit('Could not make temporary build folder');
        fix_permissions($builds_path . '/builds/build/', 0777);
    }
    if (!$skip_file_grab) {
        deldir_contents($builds_path . '/builds/build/' . $version_branch . '/');
    }
    if (!file_exists($builds_path . '/builds/build/' . $version_branch . '/')) {
        mkdir($builds_path . '/builds/build/' . $version_branch . '/', 0777) or warn_exit('Could not make branch build folder');
        fix_permissions($builds_path . '/builds/build/' . $version_branch . '/', 0777);
    }
    if (!file_exists($builds_path . '/builds/' . $version_dotted . '/')) {
        mkdir($builds_path . '/builds/' . $version_dotted . '/', 0777) or warn_exit('Could not make version build folder');
        fix_permissions($builds_path . '/builds/' . $version_dotted . '/', 0777);
    }

    if (!$skip_file_grab) {
        @copy(get_file_base() . '/install.php', $builds_path . '/builds/build/' . $version_branch . '/install.php');
        fix_permissions($builds_path . '/builds/build/' . $version_branch . '/install.php');

        // Get file data array
        $out .= '<ul>';
        $out .= populate_build_files_array();
        $out .= '</ul>';

        make_files_manifest();
    }

    //header('Content-type: text/plain; charset=' . get_charset());var_dump(array_keys($MAKE_INSTALLERS__FILE_ARRAY));exit(); Useful for testing quickly what files will be built

    // What we'll be building
    $bundled = $builds_path . '/builds/' . $version_dotted . '/composr-' . $version_dotted . '.tar';
    $quick_zip = $builds_path . '/builds/' . $version_dotted . '/composr_quick_installer-' . $version_dotted . '.zip';
    $manual_zip = $builds_path . '/builds/' . $version_dotted . '/composr_manualextraction_installer-' . $version_dotted . '.zip';
    $mszip = $builds_path . '/builds/' . $version_dotted . '/composr-' . $version_dotted . '-webpi.zip'; // Aka msappgallery, related to webmatrix

    // Flags
    $make_quick = (get_param_integer('skip_quick', 0) == 0);
    $make_manual = (get_param_integer('skip_manual', 0) == 0);
    $make_bundled = (get_param_integer('skip_bundled', 0) == 0);
    $make_mszip = (get_param_integer('skip_mszip', 0) == 0);

    if (function_exists('set_time_limit')) {
        @set_time_limit(0);
    }
    disable_php_memory_limit();

    // Build quick installer
    if ($make_quick) {
        // Write out our installer data file
        require_code('tar');
        $data_file = tar_open($builds_path . '/builds/' . $version_dotted . '/data.cms', 'wb');
        $zip_file_array = array();
        $offsets = array();
        $sizes = array();
        foreach ($MAKE_INSTALLERS__FILE_ARRAY as $path => $data) {
            $offsets[$path] = tar_add_file($data_file, $path, $data, 0644, filemtime(get_file_base() . '/' . $path));
            $sizes[$path] = strlen($data);
        }
        tar_close($data_file);
        fix_permissions($builds_path . '/builds/' . $version_dotted . '/data.cms');
        $archive_size = filesize($builds_path . '/builds/' . $version_dotted . '/data.cms');
        // The installer does an md5 check to check integrity - prepare for it
        $md5_test_path = 'data/images/advertise_here.png';
        $md5 = md5(file_get_contents($builds_path . '/builds/build/' . $version_branch . '/' . $md5_test_path));

        // Write out our PHP installer file
        $file_count = count($MAKE_INSTALLERS__FILE_ARRAY);
        $size_list = '';
        $offset_list = '';
        $file_list = '';
        foreach (array_keys($MAKE_INSTALLERS__FILE_ARRAY) as $path) { // $MAKE_INSTALLERS__FILE_ARRAY is Current path->contents. We need number->path, so we can count through them without having to have the array with us. We end up with this in string form, as it goes in our file
            $out .= do_build_file_output($path);
            $size_list .= '\'' . $path . '\'=>' . strval($sizes[$path]) . ',' . "\n";
            $offset_list .= '\'' . $path . '\'=>' . strval($offsets[$path]) . ',' . "\n";
            $file_list .= '\'' . $path . '\',';
        }

        // Build install.php, which has to have all our data.cms file offsets put into it (data.cms is an uncompressed zip, but the quick installer cheats - it can't truly read arbitrary zips)
        $code = file_get_contents(get_file_base() . '/install.php');
        $auto_installer = fopen($builds_path . '/builds/' . $version_dotted . '/install.php', 'wb');
        $installer_start = "<?php
            /* QUICK INSTALLER CODE starts */

            global \$FILE_ARRAY,\$SIZE_ARRAY,\$OFFSET_ARRAY,\$DIR_ARRAY,\$DATADOTCMS_FILE;
            \$OFFSET_ARRAY = array({$offset_list});
            \$SIZE_ARRAY = array({$size_list});
            \$FILE_ARRAY = array({$file_list});
            \$DATADOTCMS_FILE = fopen('data.cms','rb');
            if (\$DATADOTCMS_FILE === false) warn_exit('data.cms missing / inaccessible');
            if (filesize('data.cms') != {$archive_size}) warn_exit('data.cms not fully uploaded, or wrong version for this installer');
            if (md5(file_array_get('{$md5_test_path}')) != '{$md5}') warn_exit('data.cms corrupt. Must not be uploaded in text mode');

            function file_array_get(\$path)
            {
                global \$OFFSET_ARRAY,\$SIZE_ARRAY,\$DATADOTCMS_FILE,\$FILE_BASE;

                if (substr(\$path,0,strlen(\$FILE_BASE.'/')) == \$FILE_BASE.'/')
                    \$path = substr(\$path,strlen(\$FILE_BASE.'/'));

                if (!isset(\$OFFSET_ARRAY[\$path])) return;
                \$offset = \$OFFSET_ARRAY[\$path];
                \$size = \$SIZE_ARRAY[\$path];
                if (\$size == 0) return '';
                fseek(\$DATADOTCMS_FILE,\$offset,SEEK_SET);
                if (\$size>1024*1024) {
                    return array(\$size,\$DATADOTCMS_FILE,\$offset);
                }
                \$data = fread(\$DATADOTCMS_FILE,\$size);
                return \$data;
            }

            function file_array_exists(\$path)
            {
                global \$OFFSET_ARRAY;
                return (isset(\$OFFSET_ARRAY[\$path]));
            }

            function file_array_get_at(\$i)
            {
                global \$FILE_ARRAY;
                \$name = \$FILE_ARRAY[\$i];
                return array(\$name,file_array_get(\$name));
            }

            function file_array_count()
            {
                return {$file_count};
            }";
        $installer_start = preg_replace('#^\t{3}#m', '', $installer_start); // Format it correctly
        fwrite($auto_installer, $installer_start);
        global $MAKE_INSTALLERS__DIR_ARRAY;
        foreach ($MAKE_INSTALLERS__DIR_ARRAY as $dir) {
            fwrite($auto_installer, '$DIR_ARRAY[]=\'' . $dir . '\';' . "\n");
        }
        fwrite($auto_installer, '/* QUICK INSTALLER CODE ends */ ?' . '>');
        fwrite($auto_installer, $code);
        fclose($auto_installer);
        fix_permissions($builds_path . '/builds/' . $version_dotted . '/install.php');

        @unlink($quick_zip);

        chdir($builds_path . '/builds/' . $version_dotted);
        $cmd = 'zip -r -9 ' . escapeshellarg($quick_zip) . ' ' . escapeshellarg('data.cms') . ' ' . escapeshellarg('install.php');
        $output2 = $cmd . ':' . "\n" . shell_exec($cmd);

        chdir(get_file_base() . '/data_custom/builds');
        $cmd = 'zip -r -9 ' . escapeshellarg($quick_zip) . ' ' . escapeshellarg('readme.txt');
        $output2 .= $cmd . ':' . "\n" . shell_exec($cmd);
        $out .= do_build_zip_output($quick_zip, $output2);

        chdir(get_file_base());
    }

    /*
    The other installers are built up file-by-file...
    */

    // Build manual
    if ($make_manual) {
        @unlink($manual_zip);

        // Do the main work
        chdir($builds_path . '/builds/build/' . $version_branch);
        $cmd = 'zip -r -9 ' . escapeshellarg($manual_zip) . ' *';
        $output2 = shell_exec($cmd);
        $out .= do_build_zip_output($manual_zip, $output2);

        chdir(get_file_base());
    }

    // Build bundled version (Installatron, Bitnami, ...)
    if ($make_bundled) {
        @unlink($bundled);
        @unlink($bundled . '.gz');

        // Copy some files we need
        copy(get_file_base() . '/install.sql', $builds_path . '/builds/build/' . $version_branch . '/install.sql');
        fix_permissions($builds_path . '/builds/build/' . $version_branch . '/install.sql');
        copy(get_file_base() . '/_config.php.template', $builds_path . '/builds/build/' . $version_branch . '/_config.php.template');
        fix_permissions($builds_path . '/builds/build/' . $version_branch . '/_config.php.template');

        // Do the main work
        chdir($builds_path . '/builds/build/' . $version_branch);
        $cmd = 'tar -cvf ' . escapeshellarg($bundled) . ' * --mode=a+X';
        $output2 = '';
        $cmd_result = shell_exec($cmd);
        if ($cmd_result !== null) {
            $output2 .= $cmd_result;
        }
        chdir(get_file_base() . '/data_custom/builds');
        $cmd = 'tar -rvf ' . escapeshellarg($bundled) . ' readme.txt --mode=a+X';
        $cmd_result = shell_exec($cmd);
        if ($cmd_result !== null) {
            $output2 .= $cmd_result;
        }
        //$out.=do_build_zip_output($v,$output2);  Don't mention, as will get auto-deleted after gzipping anyway
        chdir($builds_path . '/builds/build/' . $version_branch);
        $cmd = 'gzip -n ' . escapeshellarg($bundled);
        shell_exec($cmd);
        @unlink($bundled);
        $out .= do_build_zip_output($bundled . '.gz', $output2);

        // Remove those files we copied
        unlink($builds_path . '/builds/build/' . $version_branch . '/install.sql');
        unlink($builds_path . '/builds/build/' . $version_branch . '/_config.php.template');

        chdir(get_file_base());
    }

    // Build Microsoft version
    if ($make_mszip) {
        @unlink($mszip);
        if (file_exists($builds_path . '/builds/build/composr/')) {
            deldir_contents($builds_path . '/builds/build/composr/');
        }

        // Move files out temporarily
        rename($builds_path . '/builds/build/' . $version_branch . '/_config.php', $builds_path . '/builds/build/_config.php');
        rename($builds_path . '/builds/build/' . $version_branch . '/install.php', $builds_path . '/builds/build/install.php');

        // Put temporary files in main folder
        copy(get_file_base() . '/_config.php.template', $builds_path . '/builds/build/' . $version_branch . '/_config.php.template');
        fix_permissions($builds_path . '/builds/build/' . $version_branch . '/_config.php.template');

        // Copy some stuff we need
        for ($i = 1; $i <= 4; $i++) {
            copy(get_file_base() . '/install' . strval($i) . '.sql', $builds_path . '/builds/build/install' . strval($i) . '.sql');
            fix_permissions($builds_path . '/builds/build/install' . strval($i) . '.sql');
        }
        copy(get_file_base() . '/user.sql', $builds_path . '/builds/build/user.sql');
        fix_permissions($builds_path . '/builds/build/user.sql');
        copy(get_file_base() . '/postinstall.sql', $builds_path . '/builds/build/postinstall.sql');
        fix_permissions($builds_path . '/builds/build/postinstall.sql');
        copy(get_file_base() . '/manifest.xml', $builds_path . '/builds/build/manifest.xml');
        fix_permissions($builds_path . '/builds/build/manifest.xml');
        copy(get_file_base() . '/parameters.xml', $builds_path . '/builds/build/parameters.xml');
        fix_permissions($builds_path . '/builds/build/parameters.xml');

        // Temporary renaming
        rename($builds_path . '/builds/build/' . $version_branch, $builds_path . '/builds/build/composr');

        // Do the main work
        chdir($builds_path . '/builds/build');
        $cmd = 'zip -r -9 -v ' . escapeshellarg($mszip) . ' composr manifest.xml parameters.xml install1.sql install2.sql install3.sql install4.sql user.sql postinstall.sql';
        $output2 = shell_exec($cmd);
        $out .= do_build_zip_output($mszip, $output2);

        // Undo temporary renaming
        rename($builds_path . '/builds/build/composr', $builds_path . '/builds/build/' . $version_branch);

        // Move back files moved out temporarily
        rename($builds_path . '/builds/build/_config.php', $builds_path . '/builds/build/' . $version_branch . '/_config.php');
        rename($builds_path . '/builds/build/install.php', $builds_path . '/builds/build/' . $version_branch . '/install.php');

        // Remove temporary files from main folder
        unlink($builds_path . '/builds/build/' . $version_branch . '/_config.php.template');

        chdir(get_file_base());
    }

    // We're done, show the result

    $details = '';
    require_code('files');
    if ($make_quick) {
        $details .= '<li>' . $quick_zip . ' file size: ' . clean_file_size(filesize($quick_zip)) . '</li>';
    }
    if ($make_manual) {
        $details .= '<li>' . $manual_zip . ' file size: ' . clean_file_size(filesize($manual_zip)) . '</li>';
    }
    if ($make_mszip) {
        $details .= '<li>' . $mszip . ' file size: ' . clean_file_size(filesize($mszip)) . '</li>';
    }
    if ($make_bundled) {
        $details .= '<li>' . $bundled . '.gz file size: ' . clean_file_size(filesize($bundled . '.gz')) . '</li>';
    }

    $out .= '
        <h2>Statistics</h2>
        <ul>
            <li>Total files compiled: ' . integer_format($MAKE_INSTALLERS__TOTAL_FILES) . '</li>
            <li>Total directories traversed: ' . integer_format($MAKE_INSTALLERS__TOTAL_DIRS) . '</li>
            ' . $details . '
        </ul>';

    // To stop ocProducts-PHP complaining about non-synched files
    global $_CREATED_FILES, $_MODIFIED_FILES;
    $_CREATED_FILES = array();
    $_MODIFIED_FILES = array();

    return $out;
}

function get_builds_path()
{
    $builds_path = get_file_base() . '/exports';
    if (!file_exists($builds_path . '/builds')) {
        mkdir($builds_path . '/builds', 0777) or warn_exit('Could not make master build folder');
        fix_permissions($builds_path . '/builds', 0777);
    }
    return $builds_path;
}

function copy_r($path, $dest)
{
    if (is_dir($path)) {
        @mkdir($dest, 0777);
        fix_permissions($dest, 0777);
        $objects = scandir($path);
        if (count($objects) > 0) {
            foreach ($objects as $file) {
                if (($file == '.') || ($file == '..')) {
                    continue;
                }

                if (is_dir($path . '/' . $file)) {
                    copy_r($path . '/' . $file, $dest . '/' . $file);
                } else {
                    copy($path . '/' . $file, $dest . '/' . $file);
                    fix_permissions($dest . '/' . $file);
                }
            }
        }
        return true;
    } elseif (is_file($path)) {
        return copy($path, $dest);
    } else {
        return false;
    }
}

function do_build_file_output($path)
{
    global $MAKE_INSTALLERS__TOTAL_FILES;
    $MAKE_INSTALLERS__TOTAL_FILES++;
    return '<li>File "' . escape_html($path) . '" compiled.</li>';
}

function do_build_directory_output($path)
{
    global $MAKE_INSTALLERS__TOTAL_DIRS;
    $MAKE_INSTALLERS__TOTAL_DIRS++;
    return '<li>Directory "' . escape_html($path) . '" traversed.</li>';
}

function do_build_zip_output($file, $new_output)
{
    $version_dotted = get_version_dotted();

    $builds_path = get_builds_path();
    return '
        <div class="zip_surround">
        <h2>Compiling ZIP file "<a href="' . escape_html($file) . '" title="Download the file.">' . escape_html($builds_path . $version_dotted . '/' . $file) . '</a>"</h2>
        <p>' . nl2br(trim(escape_html($new_output))) . '</p>
        </div>';
}

function populate_build_files_array($dir = '', $pretend_dir = '')
{
    require_code('files');

    disable_php_memory_limit();

    global $MAKE_INSTALLERS__FILE_ARRAY, $MAKE_INSTALLERS__DIR_ARRAY;

    $builds_path = get_builds_path();

    $out = '';

    $version_branch = get_version_branch();

    // Imply files into the root that we would have skipped
    if ($pretend_dir == '') {
        $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . '_config.php'] = '';
    }
    if ($pretend_dir == 'data_custom/') {
        $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . 'execute_temp.php'] = file_get_contents(get_file_base() . '/data_custom/execute_temp.php.bundle');
    }

    // Go over files in the directory
    $full_dir = get_file_base() . '/' . $dir;
    $dh = opendir($full_dir);
    while (($file = readdir($dh)) !== false) {
        $is_dir = is_dir(get_file_base() . '/' . $dir . $file);

        if (should_ignore_file($pretend_dir . $file, IGNORE_NONBUNDLED_SCATTERED | IGNORE_CUSTOM_DIR_CONTENTS | IGNORE_CUSTOM_ZONES | IGNORE_CUSTOM_THEMES | IGNORE_NON_EN_SCATTERED_LANGS | IGNORE_BUNDLED_UNSHIPPED_VOLATILE, 0)) {
            continue;
        }

        if ($is_dir) {
            $num_files = count($MAKE_INSTALLERS__FILE_ARRAY);
            $MAKE_INSTALLERS__DIR_ARRAY[] = $pretend_dir . $file;
            @mkdir($builds_path . '/builds/build/' . $version_branch . '/' . $pretend_dir . $file, 0777);
            fix_permissions($builds_path . '/builds/build/' . $version_branch . '/' . $pretend_dir . $file, 0777);
            $_out = populate_build_files_array($dir . $file . '/', $pretend_dir . $file . '/');
            if ($num_files == count($MAKE_INSTALLERS__FILE_ARRAY)) { // Empty, effectively (maybe was from a non-bundled addon) - don't use it
                array_pop($MAKE_INSTALLERS__DIR_ARRAY);
                rmdir($builds_path . '/builds/build/' . $version_branch . '/' . $pretend_dir . $file);
            } else {
                $out .= $_out;
            }
        } else {
            // Reset volatile files to how they should be by default (see also list in install.php)
            if (($pretend_dir . $file) == '_config.php') {
                $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . $file] = '';
            } elseif (($pretend_dir . $file) == 'themes/map.ini') {
                $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . $file] = 'default=default' . "\n";
            } elseif ($pretend_dir . $file == 'data_custom/functions.dat') {
                $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . $file] = '';
            } elseif ($pretend_dir . $file == 'cms_sitemap.xml') {
                $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . $file] = '';
            } elseif ($pretend_dir . $file == 'cms_news_sitemap.xml') {
                $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . $file] = '';
            } elseif ($pretend_dir . $file == 'data_custom/errorlog.php') {
                $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . $file] = "<?php return; ?" . ">\n";
            } elseif ($pretend_dir . $file == 'data_custom/execute_temp.php') { // So that code can't be executed
                continue; // We'll add this back in later
            } // Update time of version in version.php
            elseif ($pretend_dir . $file == 'sources/version.php') {
                $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . $file] = preg_replace('/\d{10}/', strval(time()), file_get_contents(get_file_base() . '/' . $dir . $file), 1); // Copy file as-is
            } else {
                $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . $file] = file_get_contents(get_file_base() . '/' . $dir . $file);
            }

            // Write the file out
            $tmp = fopen($builds_path . '/builds/build/' . $version_branch . '/' . $pretend_dir . $file, 'wb');
            fwrite($tmp, $MAKE_INSTALLERS__FILE_ARRAY[$pretend_dir . $file]);
            fclose($tmp);
            fix_permissions($builds_path . '/builds/build/' . $version_branch . '/' . $pretend_dir . $file);
        }
    }

    $out .= do_build_directory_output($pretend_dir);
    return $out;
}

function make_files_manifest() // Builds files.dat, the Composr file manifest (used for integrity checks)
{
    global $MAKE_INSTALLERS__FILE_ARRAY;

    disable_php_memory_limit();

    require_code('version2');

    if (count($MAKE_INSTALLERS__FILE_ARRAY) == 0) {
        populate_build_files_array();
    }

    $files = array();
    foreach ($MAKE_INSTALLERS__FILE_ARRAY as $file => $contents) {
        if ($file == 'data/files.dat') {
            continue;
        }

        if ($file == 'sources/version.php') {
            $contents = preg_replace('/\d{10}/', '', $contents); // Not interested in differences in file time
        }

        $files[$file] = array(sprintf('%u', crc32(preg_replace('#[\r\n\t ]#', '', $contents))));
    }

    $file_manifest = serialize($files);

    $myfile = fopen(get_file_base() . '/data/files.dat', 'wb');
    fwrite($myfile, $file_manifest);
    fclose($myfile);
    fix_permissions(get_file_base() . '/data/files.dat');

    $MAKE_INSTALLERS__FILE_ARRAY['data/files.dat'] = $file_manifest;

    // Write the file out
    require_code('version2');
    $version_branch = get_version_branch();
    $builds_path = get_builds_path();
    $tmp = fopen($builds_path . '/builds/build/' . $version_branch . '/data/files.dat', 'wb');
    fwrite($tmp, $file_manifest);
    fclose($tmp);
    fix_permissions($builds_path . '/builds/build/' . $version_branch . '/data/files.dat');
}

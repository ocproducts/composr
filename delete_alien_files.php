<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    meta_toolkit
 */

// Find Composr base directory, and chdir into it
global $FILE_BASE, $RELATIVE_PATH;
$FILE_BASE = (strpos(__FILE__, './') === false) ? __FILE__ : realpath(__FILE__);
$FILE_BASE = dirname($FILE_BASE);
if (!is_file($FILE_BASE . '/sources/global.php')) {
    $RELATIVE_PATH = basename($FILE_BASE);
    $FILE_BASE = dirname($FILE_BASE);
} else {
    $RELATIVE_PATH = '';
}
if (!is_file($FILE_BASE . '/sources/global.php')) {
    $FILE_BASE = $_SERVER['SCRIPT_FILENAME']; // this is with symlinks-unresolved (__FILE__ has them resolved); we need as we may want to allow zones to be symlinked into the base directory without getting path-resolved
    $FILE_BASE = dirname($FILE_BASE);
    if (!is_file($FILE_BASE . '/sources/global.php')) {
        $RELATIVE_PATH = basename($FILE_BASE);
        $FILE_BASE = dirname($FILE_BASE);
    } else {
        $RELATIVE_PATH = '';
    }
}
@chdir($FILE_BASE);

global $FORCE_INVISIBLE_GUEST;
$FORCE_INVISIBLE_GUEST = false;
global $EXTERNAL_CALL;
$EXTERNAL_CALL = true;
if (!is_file($FILE_BASE . '/sources/global.php')) {
    exit('<!DOCTYPE html>' . "\n" . '<html lang="EN"><head><title>Critical startup error</title></head><body><h1>Composr startup error</h1><p>The second most basic Composr startup file, sources/global.php, could not be located. This is almost always due to an incomplete upload of the Composr system, so please check all files are uploaded correctly.</p><p>Once all Composr files are in place, Composr must actually be installed by running the installer. You must be seeing this message either because your system has become corrupt since installation, or because you have uploaded some but not all files from our manual installer package: the quick installer is easier, so you might consider using that instead.</p><p>ocProducts maintains full documentation for all procedures and tools, especially those for installation. These may be found on the <a href="http://compo.sr">Composr website</a>. If you are unable to easily solve this problem, we may be contacted from our website and can help resolve it for you.</p><hr /><p style="font-size: 0.8em">Composr is a website engine created by ocProducts.</p></body></html>');
}
require($FILE_BASE . '/sources/global.php');

header('Content-type: text/plain; charset=' . get_charset());

safe_ini_set('ocproducts.xss_detect', '0');

$cli = ((php_sapi_name() == 'cli') && (empty($_SERVER['REMOTE_ADDR'])) && (empty($_ENV['REMOTE_ADDR'])));
if (!$cli) {
    exit('Must run this script on command line, for security reasons');
}

require_code('files');
require_code('files2');

$files_to_always_keep = array(
    'delete_addons.php',
    'themes/default/templates_custom/MAIL.tpl',
);
$addons_definitely_not_wanted = array();
$extra_files_to_delete = array();

if (git_repos() != 'master') {
    $addons_definitely_not_wanted[] = 'installer';
    $extra_files_to_delete[] = 'install_ok';
    $extra_files_to_delete[] = 'data_custom/images/addon_screenshots';
}

foreach ($extra_files_to_delete as $file) {
    if (file_exists(get_file_base() . '/' . $file)) {
        if (is_dir(get_file_base() . '/' . $file)) {
            echo 'rm -f ' . escapeshellarg($file) . "\n";
        } else {
            echo 'rm -rf ' . escapeshellarg($file) . "\n";
        }
    }
}

global $GFILE_ARRAY;
$GFILE_ARRAY = array();
do_dir();

// Non-installed addons
$hooks = find_all_hooks('systems', 'addon_registry');
$installed_addons = collapse_1d_complexity('addon_name', $GLOBALS['SITE_DB']->query_select('addons', array('addon_name')));
$intersection = array_intersect(array_keys($hooks), $installed_addons);
if ($intersection == array()) {
    echo 'All addons seem still installed. You should uninstall from within Composr.';
} else {
    foreach ($hooks as $hook => $hook_type) {
        require_code('hooks/systems/addon_registry/' . $hook);
        $ob = object_factory('Hook_addon_registry_' . $hook);
        $files = $ob->get_file_list();
        foreach ($files as $file) {
            if ((!in_array($file, $files_to_always_keep)) && ((!in_array($hook, $installed_addons)) || (in_array($hook, $addons_definitely_not_wanted)))) {
                if (file_exists(get_file_base() . '/' . $file)) {
                    echo 'rm -f ' . escapeshellarg($file) . "\n";
                }
            }
            unset($GFILE_ARRAY[$file]);
        }
    }
}

// Alien files (non-ignored files not within one of the known addons)
foreach (array_keys($GFILE_ARRAY) as $file) {
    echo 'rm -f ' . escapeshellarg($file) . "\n";
}

// Empty dirs
$directories = get_directory_contents(get_file_base(), get_file_base(), true, true, false);
foreach ($directories as $directory) {
    $_files = get_directory_contents($directory, '', true, false, true);
    $_directories = get_directory_contents($directory, '', true, false, false);
    if ((count($_files) == 0) && (count($_directories) == 0)) {
        echo 'rmdir ' . escapeshellarg($directory) . "\n";
    }
}

function do_dir($dir = '')
{
    global $GFILE_ARRAY;

    $full_dir = get_file_base() . '/' . $dir;
    $dh = opendir($full_dir);
    while (($file = readdir($dh)) !== false) {
        $ignore = IGNORE_CUSTOM_DIR_GROWN_CONTENTS | IGNORE_NONBUNDLED_EXTREMELY_SCATTERED | IGNORE_CUSTOM_ZONES | IGNORE_CUSTOM_THEMES | IGNORE_NON_EN_SCATTERED_LANGS | IGNORE_BUNDLED_UNSHIPPED_VOLATILE;
        if (should_ignore_file($dir . $file, $ignore, 0)) {
            continue;
        }

        $is_dir = is_dir($full_dir . $file);

        if ($is_dir) {
            do_dir($dir . $file . '/');
        } else {
            $GFILE_ARRAY[$dir . $file] = true;
        }
    }
}

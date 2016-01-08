<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    rootkit_detector
 */

/*EXTRA FUNCTIONS: mysql\_.+*/

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

$type = isset($_GET['type']) ? $_GET['type'] : '';

rd_do_header();

if (!function_exists('mysql_connect')) {
    echo '<p>MySQL extension needed</p>';
    rd_do_footer();
    exit();
}

if ($type == '') {
    echo <<<END
		<p>Be warned that this is a tool for experts, who wish to take active extra measures to make sure their website is not hacked against their knowledge. This is the most ominous security problem for many, because it means that their own website could be spreading customer information or compromised software downloads. When we say this script is for experts, we mean it - this script is strictly separated from any other Composr file and thus stands alone without access to our quality and standards frameworks.</p>
		<p>This detector will provide you with a portion of text that identifies the state of the most critical areas of Composr. You can then take the text, and save it in a file on your computer. You then run this tool again at a later date and use a tool such as <a href="http://winmerge.sourceforge.net/">WinMerge</a> to compare the results - seeing what has changed.</p>
		<p>This tool will not find out if areas of your site have been vandalised, because there is way too much information to scan and present for that to be viable. Instead, it focuses on compromised file systems, Composr permissions, and database-stored PHP/Commandr-Code. It only checks staff settings on the local Conversr, not on any other third-party forum.</p>
		<p>It is important that you upload a new copy of this script before you run it, in case this script itself has been compromised.</p>
		<p>This script may take some time to run, as it computes hashes over a large number of files. It requires the 'mysql' module for usage on a MySQL database. If a different database is being used, then custom changes will be required to this script.</p>
		<p>This script cannot extract database access details from your config file because the config file itself (which is an executable file for Composr) may have been configured to give out fake details to this script. Therefore you will need to enter them here, and the config file will only be used for accessing the Composr password (which will be extracted using a non-executive method).</p>

		<div>
			<p>Composr master password: <input type="password" name="password" /></p>
			<p>Database host: <input type="text" name="db_host" value="localhost" /></p>
			<p>Database name: <input type="text" name="db_name" value="cns" /></p>
			<p>Database table prefix: <input type="text" name="db_prefix" value="cms_" /></p>
			<p>Database username: <input type="text" name="db_user" value="root" /></p>
			<p>Database password: <input type="password" name="db_password" /></p>
END;

    if (isset($_SERVER['APPLICATION_ID'])) {// Google App Engine
        echo <<<END
			<p>E-mail results to (required): <input type="text" name="email" /></p>
END;
    }

    echo <<<END
			<input class="buttons__proceed button_screen" type="submit" value="Begin" />
		</div>
END;
} else {
    // Load POSTed settings
    $settings = array();
    foreach ($_POST as $key => $val) {
        if (get_magic_quotes_gpc()) {
            $val = stripslashes($val);
        }
        $settings[$key] = $val;
    }

    // Google App Engine
    if (isset($_SERVER['APPLICATION_ID'])) {
        if (isset($_GET['settings'])) { // Running out of the task queue
            $settings = unserialize(get_magic_quotes_gpc() ? stripslashes($_GET['settings']) : $_GET['settings']);
        } else { // Put into the task queue
            require_once('google/appengine/api/taskqueue/PushTask.php');

            $pushtask = '\google\appengine\api\taskqueue\PushTask'; // So does not give a parser error on older versions of PHP
            $task = new $pushtask('/rootkit_detection.php', array('type' => 'go', 'settings' => serialize($settings)));
            $task_name = $task->add();

            echo '<p>The task has been added to the GAE task queue.</p>';
            rd_do_footer();
            exit();
        }
    }

    // Find and check password
    if (!defined('EXTERNAL_ROOTKIT_DETECTION_CALL')) {
        $config_file = file_get_contents($FILE_BASE . '/_config.php');
        $matches = array();
        if (preg_match('#\$SITE_INFO\[\'master_password\'\] = \'([^\']*)\';#', $config_file, $matches) == 0) {
            exit(':(');
        }
        global $SITE_INFO;
        $SITE_INFO = array('master_password' => $matches[1]);
        if (!rk_check_master_password($settings['password'])) {
            echo '<p>Incorrect master password</p>';
            rd_do_footer();
            exit();
        }
    }

    // Connect to DB
    $db = mysql_connect($settings['db_host'], $settings['db_user'], $settings['db_password']);
    if ($db === false) {
        echo '<p>Could not connect (1)</p>';
        rd_do_footer();
        exit();
    }
    if (!mysql_select_db($settings['db_name'], $db)) {
        echo '<p>Could not connect (2)</p>';
        rd_do_footer();
        exit();
    }

    $results = '';

    // Check database
    $prefix = $settings['db_prefix'];
    if (file_exists($FILE_BASE . '/sources/hooks/systems/addon_registry/calendar_events.php')) {
        $multi_lang_content = isset($SITE_INFO['multi_lang_content']) ? ($SITE_INFO['multi_lang_content'] == '1') : true;
        if ($multi_lang_content) {
            $r = mysql_query('SELECT * FROM ' . $prefix . 'calendar_events e LEFT JOIN ' . $prefix . 'translate t on e.e_content=t.id WHERE e_type=1 ORDER BY e.id', $db);
            if ($r !== false) {
                while (($row = mysql_fetch_assoc($r)) !== false) {
                    $results .= "Cronjob: {$row['id']}=" . md5($row['text_original']) . "\n";
                }
            }
        } else {
            $r = mysql_query('SELECT * FROM ' . $prefix . 'calendar_events e WHERE e_type=1 ORDER BY e.id', $db);
            if ($r !== false) {
                while (($row = mysql_fetch_assoc($r)) !== false) {
                    $results .= "Cronjob: {$row['id']}=" . md5($row['e_content']) . "\n";
                }
            }
        }
    }
    $r = mysql_query('SELECT * FROM ' . $prefix . 'f_groups WHERE g_is_super_admin=1 OR g_is_super_moderator=1 ORDER BY id', $db);
    $staff_groups = array();
    $pg = '';
    while (($row = mysql_fetch_assoc($r)) !== false) {
        if ($pg != '') {
            $pg .= ' OR ';
        }
        $pg .= 'm_primary_group=' . strval($row['id']);
        $staff_groups[] = $row['id'];
        $results .= "Staff-group: {$row['id']}=N/A\n";
    }
    $r = mysql_query('SELECT * FROM ' . $prefix . 'f_members WHERE ' . $pg . ' ORDER BY id', $db);
    while (($row = mysql_fetch_assoc($r)) !== false) {
        $results .= "In-staff-group (primary): {$row['id']}=N/A\n";
    }
    $r = mysql_query('SELECT * FROM ' . $prefix . 'f_group_members WHERE (' . str_replace('m_primary_group', 'gm_group_id', $pg) . ') AND gm_validated=1 ORDER BY gm_member_id', $db);
    while (($row = mysql_fetch_assoc($r)) !== false) {
        $results .= "In-staff-group (secondary): {$row['gm_member_id']}=N/A\n";
    }
    $r = mysql_query('SELECT * FROM ' . $prefix . 'group_zone_access WHERE zone_name=\'cms\' OR zone_name=\'adminzone\' OR zone_name=\'collaboration\' ORDER BY zone_name,group_id', $db);
    while (($row = mysql_fetch_assoc($r)) !== false) {
        $results .= "Zone-access: {$row['zone_name']}/{$row['group_id']}=N/A\n";
    }
    $r = mysql_query('SELECT * FROM ' . $prefix . 'group_privileges WHERE the_value=1 ORDER BY privilege,the_page,module_the_name,category_name,group_id', $db);
    while (($row = mysql_fetch_assoc($r)) !== false) {
        if ($row['module_the_name'] == 'galleries') {
            continue;
        }
        $results .= "Privileges: {$row['privilege']}/{$row['the_page']}/{$row['module_the_name']}/{$row['category_name']}/{$row['group_id']}={$row['the_value']}\n";
    }
    $r = mysql_query('SELECT * FROM ' . $prefix . 'member_zone_access WHERE zone_name=\'cms\' OR zone_name=\'adminzone\' OR zone_name=\'collaboration\' ORDER BY zone_name,member_id', $db);
    while (($row = mysql_fetch_assoc($r)) !== false) {
        $results .= "Member-Zone-access: {$row['zone_name']}/{$row['member_id']}=N/A\n";
    }
    $r = mysql_query('SELECT * FROM ' . $prefix . 'member_privileges WHERE the_value=1 ORDER BY privilege,the_page,module_the_name,category_name,member_id', $db);
    while (($row = mysql_fetch_assoc($r)) !== false) {
        if ($row['module_the_name'] == 'galleries') {
            continue;
        }
        $results .= "Member-Privileges: {$row['privilege']}/{$row['the_page']}/{$row['module_the_name']}/{$row['category_name']}/{$row['member_id']}={$row['the_value']}\n";
    }

    // Check files
    if (php_function_allowed('set_time_limit')) {
        set_time_limit(0);
    }
    $files = rd_do_dir('');
    foreach ($files as $file) {
        if (preg_match('#^data_custom/errorlog\.php$#', $file)!=0) {
            continue;
        }
        if (preg_match('#^servers/composr.info/_config\.php$#', $file)!=0) {
            continue;
        }

        if (filesize($FILE_BASE . '/' . $file) != 0) {
            $results .= 'File: ' . $file . '=';
            $results .= md5_file($FILE_BASE . '/' . $file);
            $results .= "\n";
        }
    }

    if (!empty($settings['email'])) { // Will only be the case on Google App Engine
        require_once('google/appengine/api/mail/Message.php');

        $message = '\google\appengine\api\mail\Message'; // So does not give a parser error on older versions of PHP
        $task = new $message(array(
            'to' => $settings['email'],
            'subject' => 'Rootkit detection results',
            'textBody' => $results,
        ));
        $task_name = $task->add();
    }

    $results = htmlentities($results);
    echo <<<END
		<p>This is the result of the scan. Please save this to your own computer somewhere secure, and if you have run this tool previously, run a diff between those results and these. It is up to you to interpret the results - basically the diff will tell you what has been added and changed, and if you see anything you cannot fully explain, you may wish to investigate. This tool has been designed to empower, and to some extent promote secure practice, but it is only really useful in expert hands (there's no point ocProducts making it easier, as the security principles and analysis involved require expert knowledge in themself).</p>
		<textarea style="width: 100%" rows="30" cols="100" name="results">{$results}</textarea>
END;
}

rd_do_footer();

/**
 * Search inside a directory for files.
 *
 * @param  SHORT_TEXT $dir The directory path to search.
 * @return array The HTML for the list box selection.
 */
function rd_do_dir($dir)
{
    $out = array();
    $_dir = ($dir == '') ? '.' : $dir;
    $dh = @opendir($_dir);
    if ($dh !== false) {
        while (($file = readdir($dh)) !== false) {
            if (!in_array($file, array('.', '..', 'website_specific'))) {
                if (is_file($_dir . '/' . $file)) {
                    $path = $dir . (($dir != '') ? '/' : '') . $file;
                    if (substr($path, -4) == '.php') {
                        $out[] = $path;
                    }
                } elseif (is_dir($_dir . '/' . $file)) {
                    $out = array_merge($out, rd_do_dir($dir . (($dir != '') ? '/' : '') . $file));
                }
            }
        }
    }
    return $out;
}

/**
 * Output the config editors page header.
 */
function rd_do_header()
{
    echo <<<END
<!DOCTYPE html>
	<html lang="EN">
	<head>
		<title>Composr rootkit detector</title>
		<link rel="icon" href="http://compo.sr/favicon.ico" type="image/x-icon" />
		<style>/*<![CDATA[*/
END;
    @print(preg_replace('#/\*\s*\*/\s*#', '', str_replace('url(\'\')', 'none', str_replace('url("")', 'none', preg_replace('#\{\$[^\}]*\}#', '', preg_replace('#\{\$\?,\{\$MOBILE\},([^,]+),([^,]+)\}#', '$2', file_get_contents($GLOBALS['FILE_BASE'] . '/themes/default/css/global.css')))))));
    echo <<<END
			.screen_title { text-decoration: underline; display: block; background: url('themes/default/images/icons/48x48/menu/_generic_admin/tool.png') top left no-repeat; min-height: 42px; padding: 10px 0 0 60px; }
			.button_screen { padding: 0.5em 0.3em !important; }
			a[target="_blank"], a[onclick$="window.open"] { padding-right: 0; }
		/*]]>*/</style>
	</head>
	<body class="website_body" style="margin: 1em"><div class="global_middle">
		<h1 class="screen_title">Composr rootkit detector</h1>
		<form title="Proceed" action="rootkit_detection.php?type=go" method="post">
END;
}

/**
 * Output the config editors page footer.
 */
function rd_do_footer()
{
    echo <<<END
		</form>
	</div></body>
</html>
END;
}

/**
 * Check the given master password is valid.
 *
 * @param  SHORT_TEXT $password_given Given master password
 * @return boolean Whether it is valid
 */
function rk_check_master_password($password_given)
{
    global $SITE_INFO;
    if (!array_key_exists('master_password', $SITE_INFO)) {
        exit('No master password defined in _config.php currently so cannot authenticate');
    }
    $actual_password_hashed = $SITE_INFO['master_password'];
    if ((function_exists('password_verify')) && (strpos($actual_password_hashed, '$') !== false)) {
        return password_verify($password_given, $actual_password_hashed);
    }
    $salt = '';
    if ((substr($actual_password_hashed, 0, 1) == '!') && (strlen($actual_password_hashed) == 33)) {
        $actual_password_hashed = substr($actual_password_hashed, 1);
        $salt = 'cms';

        // LEGACY
        if ($actual_password_hashed != md5($password_given . $salt)) {
            $salt = 'ocp';
        }
    }
    return (((strlen($password_given) != 32) && ($actual_password_hashed == $password_given)) || ($actual_password_hashed == md5($password_given . $salt)));
}

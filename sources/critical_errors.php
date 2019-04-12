<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

if ((isset($_SERVER['argv'][0])) && (strpos($_SERVER['argv'][0], 'critical_errors.php') !== false)) {
    $cli = ((function_exists('php_sapi_name')) && (strpos(ini_get('disable_functions'), 'php_sapi_name') === false) && (php_sapi_name() == 'cli') && (empty($_SERVER['REMOTE_ADDR'])) && (empty($_ENV['REMOTE_ADDR'])));
    if ($cli) {
        // Critical error monitoring mode
        chdir(dirname(__DIR__));
        if (is_dir('critical_errors')) {
            if (php_function_allowed('set_time_limit')) {
                @set_time_limit(0);
            }
            require_once('_config.php');
            global $SITE_INFO;
            $email_to = isset($SITE_INFO['email_to']) ? $SITE_INFO['email_to'] : ('webmaster@' . $SITE_INFO['domain']);
            echo 'Monitoring for logged critical errors; we will email ' . $email_to . ' if we find anything.' . "\n";
            $last_run = time();
            while (true) {
                $dh = opendir('critical_errors');
                while (($f = readdir($dh)) !== false) {
                    if (substr($f, -4) == '.log') {
                        if (filemtime('critical_errors/' . $f) >= $last_run) {
                            echo 'Found and emailing error ' . $f . "\n";
                            mail($email_to, 'Critical error logged', 'Critical error logged -- see critical_errors/' . $f . ' on the server.');
                            break; // Enough, don't send more than once per 10 seconds
                        }
                    }
                }
                closedir($dh);
                $last_run = time();
                if (php_function_allowed('usleep')) {
                    usleep(10000000);
                }
            }
        }
    }
}

if (!function_exists('critical_error')) {
    /**
     * Exit with a nicely formatted critical error.
     *
     * @param  string $code The error message code
     * @param  ?string $relay Relayed additional details (null: nothing relayed)
     * @param  boolean $exit Whether to actually exit
     */
    function critical_error($code, $relay = null, $exit = true)
    {
        error_reporting(0);

        while (ob_get_level() > 0) { // Emergency output, potentially, so kill off any active buffer
            @ob_end_clean();
        }
        ob_start();

        if (($relay !== null) && (function_exists('_sanitise_error_msg'))) {
            $relay = _sanitise_error_msg($relay);
        }

        if (!headers_sent()) {
            if ((function_exists('browser_matches')) && (($relay === null) || (strpos($relay, 'Allowed memory') === false))) {
                if ((!browser_matches('ie')) && (strpos($_SERVER['SERVER_SOFTWARE'], 'IIS') === false)) {
                    if ($code == 'BANNED') {
                        http_response_code(403);
                    } else {
                        http_response_code(500);
                    }
                }
            }
        }

        $error = 'Unknown critical error type: this should not happen, so please report this to ocProducts.';

        $may_show_footer = true;

        switch ($code) {
            case 'CORRUPT_OVERRIDE':
                $error = 'An override seems to no longer be compatible, ' . htmlentities($relay) . '.';
                break;
            case 'MISSING_SOURCE':
                $error = 'A source-code (' . $relay . ') file is missing/corrupt/incompatible.';
                break;
            case 'PASSON':
                $error = $relay;
                break;
            case 'YOU_ARE_BANNED':
                $error = 'The member you are masquerading as has been banned. We cannot finish initialising the virtualised environment for this reason.';
                $may_show_footer = false;
                break;
            case 'BANNED':
                $error = 'The IP address you are accessing this website from (' . get_ip_address() . ') has been banished from this website. If you believe this is a mistake, contact the staff to have it resolved (typically, postmaster@' . get_domain() . ' will be able to reach them).</div>' . "\n" . '<div>If you are yourself staff, you should be able to unban yourself by editing the <kbd>banned_ip</kbd> table in a database administation tool, by removing rows that qualify against yourself. This error is raised to a critical error to reduce the chance of this IP address being able to further consume server resources.';
                $may_show_footer = false;
                break;
            case 'TEST':
                $error = 'This is a test error.';
                break;
            case 'BUSY':
                $error = 'This is a less-critical error that has been elevated for quick dismissal due to high server load.</div>' . "\n" . '<div style="padding-left: 50px">' . $relay;
                break;
            case 'EMERGENCY':
                $error = 'This is an error that has been elevated to critical error status because it occurred during the primary error mechanism reporting system itself (possibly due to it occurring within the standard output framework). It may be masking a secondary error that occurred before this, but was never output - if so, it is likely strongly related to this one, thus fixing this will fix the other.</div>' . "\n" . '<div style="padding-left: 50px">' . $relay;
                break;
            case 'RELAY':
                $error = 'This is a relayed critical error, which means that this less-critical error has occurred during startup, and thus halted startup.</div>' . "\n" . '<div style="padding-left: 50px">' . $relay;
                break;
            case 'FILE_DOS':
                $error = 'This website was prompted to download a file (' . htmlentities($relay) . ') which seemingly has a never-ending chain of redirections. Because this could be a denial of service attack, execution has been terminated.';
                break;
            case 'DATABASE_FAIL':
                $error = 'The website\'s first database query (checking the page request is not from a banned IP address or reading the site configuration) has failed. This almost always means that the database is not set up correctly, which in turns means that either backend database configuration has changed (perhaps the database has been emptied), or the configuration file (_config.php) has been incorrectly altered (perhaps to point to an empty database), or you have moved servers and not updated your _config.php settings properly or placed your database. It could also mean that the <kbd>' . get_table_prefix() . 'banned_ip</kbd> table or <kbd>' . get_table_prefix() . 'config</kbd> table alone is missing or corrupt, but this is unlikely. As this is an error due to the website\'s environment being externally altered by unknown means, the website cannot continue to function or solve the problem itself.';
                break;
            case '_CONFIG.PHP_MISSING':
                $install_url = 'install.php';
                if (!file_exists($install_url)) {
                    $install_url = '../install.php';
                }
                if (file_exists($install_url)) {
                    $error = 'The top-level configuration file (<kbd>_config.php</kbd>) is missing. You probably have not yet installed, so <a href="' . $install_url . '">run the installer</a>.';
                } else {
                    $error = 'The top-level configuration file (<kbd>_config.php</kbd>) is missing. This file is created during installation. If you have not yet installed, use an official ocProducts installation package. If somehow <kbd>_config.php</kbd> was deleted then replace <kbd>_config.php</kbd> from backup.';
                }
                break;
            case '_CONFIG.PHP_EMPTY':
                $install_url = 'install.php';
                if (!file_exists($install_url)) {
                    $install_url = '../install.php';
                }
                if (file_exists($install_url)) {
                    $error = 'The top-level configuration file (<kbd>_config.php</kbd>) is empty. You probably have not yet installed, so <a href="' . $install_url . '">run the installer</a>.';
                } else {
                    $error = 'The top-level configuration file (<kbd>_config.php</kbd>) is empty. This file is created during installation. If you have not yet installed, use an official ocProducts installation package. If somehow <kbd>_config.php</kbd> was blanked out then replace <kbd>_config.php</kbd> from backup.';
                }
                break;
            case '_CONFIG.PHP_CORRUPTED':
                $error = 'The top-level configuration file (<kbd>_config.php</kbd>) appears to be corrupt. Perhaps it was incorrectly uploaded, or a typo was made. It must be valid PHP code.';
                break;
            case 'CRIT_LANG':
                $error = 'The most basic critical error language file (lang/' . fallback_lang() . '/critical_error.ini) is missing. It is likely that other files are also, for whatever reason, missing from this Composr installation.';
                break;
        }

        global $SITE_INFO;

        $edit_url = 'config_editor.php';
        if (!file_exists($edit_url)) {
            $edit_url = '../' . $edit_url;
        }
        if (isset($SITE_INFO['base_url'])) {
            $edit_url = $SITE_INFO['base_url'] . '/config_editor.php';
        }

        $extra = '';

        $script_name = isset($_SERVER['SCRIPT_NAME']) ? $_SERVER['SCRIPT_NAME'] : (isset($_ENV['SCRIPT_NAME']) ? $_ENV['SCRIPT_NAME'] : '');
        $in_upgrader = (strpos($script_name, 'upgrader.php') !== false);

        if (
            (strpos($error, 'Allowed memory') === false) &&
            ((($relay === null)) || (strpos($relay, 'Stack trace') === false)) &&
            (
                (($_SERVER['REMOTE_ADDR'] == $_SERVER['SERVER_ADDR']) && ($_SERVER['HTTP_X_FORWARDED_FOR'] == '')) ||
                ((isset($SITE_INFO['backdoor_ip'])) && ($_SERVER['REMOTE_ADDR'] == $SITE_INFO['backdoor_ip']) && ($_SERVER['HTTP_X_FORWARDED_FOR'] == '')) ||
                ((preg_match('#^localhost(\.|\:|$)#', $_SERVER['HTTP_HOST']) != 0) && (function_exists('get_base_url')) && (substr(get_base_url(), 0, 16) == 'http://localhost')) ||
                ($in_upgrader)
            )
        ) {
            $_trace = debug_backtrace();
            $extra = '<div class="box guid-{_GUID}"><div class="box-inner"><h2>Stack trace&hellip;</h2>';
            foreach ($_trace as $stage) {
                $traces = '';
                foreach ($stage as $key => $value) {
                    try {
                        if ((is_object($value) && (is_a($value, 'Tempcode'))) || (is_array($value) && (strlen(serialize($value)) > 500))) {
                            $_value = gettype($value);
                        } else {
                            $_value = gettype($value);
                            switch ($_value) {
                                case 'integer':
                                    $_value = strval($value);
                                    break;
                                case 'string':
                                    $_value = $value;
                                    break;
                                default:
                                    if (strpos($error, 'Allowed memory') === false) { // Actually we don't call this code path for memory limit issues any more, as stack trace is useless (comes from the catch_fatal_errors function)
                                        $_value = serialize($value);
                                    }
                                    break;
                            }
                        }
                    } catch (Exception $e) { // Can happen for SimpleXMLElement
                        $_value = '...';
                    }

                    global $SITE_INFO;
                    if ((isset($SITE_INFO['db_site_password'])) && (strlen($SITE_INFO['db_site_password']) > 4)) {
                        $_value = str_replace($SITE_INFO['db_site_password'], '(password removed)', $_value);
                    }
                    if ((isset($SITE_INFO['db_forums_password'])) && (strlen($SITE_INFO['db_forums_password']) > 4)) {
                        $_value = str_replace($SITE_INFO['db_forums_password'], '(password removed)', $_value);
                    }

                    $traces .= ucfirst($key) . ' -> ' . htmlentities($_value) . '<br />' . "\n";
                }
                $extra .= '<p>' . $traces . '</p>' . "\n";
            }
            $extra .= '</div></div>';
        }

        $headers_sent = headers_sent();
        if (!$headers_sent) {
            @header('Content-type: text/html; charset=utf-8');
            echo '<' . '!DOCTYPE html>';
            echo <<<END
<html lang="EN">
<head>
    <title>Critical error</title>
    <style><![CDATA[
END;
            if (strpos($error, 'Allowed memory') === false) {
                $file_contents = file_get_contents($GLOBALS['FILE_BASE'] . '/themes/default/css/global.css');
            } else {
                $file_contents = ''; // Can't load files if dying due to memory limit
            }
            $css = ((preg_replace('#/\*\s*\*/\s*#', '', str_replace('url(\'\')', 'none', str_replace('url("")', 'none', preg_replace('#\{\$[^\}]*\}#', '', preg_replace('#\{\$\?,\{\$MOBILE\},([^,]+),([^,]+)\}#', '$2', $file_contents)))))));
            echo htmlentities($css);
            echo <<<END
        .screen-title { text-decoration: underline; display: block; min-height: 42px; padding: 3px 0 0 0; }
        .button-screen { padding: 0.5em 0.3em !important; }
        a[target="_blank"], a[onclick$="window.open"] { padding-right: 0; }
    ]]></style>
</head>
<body><div class="global-middle">
END;
        }
        echo '<h1 class="screen-title">Critical error &ndash; bailing out</h1>' . "\n" . '<div class="red-alert" role="error">' . $error . '</div>' . "\n";
        flush();
        if (($in_upgrader) && (strpos($error, 'Allowed memory') === false)) {
            require_code('upgrade_integrity_scan');
            echo '<div class="box guid-{_GUID}"><div class="box-inner"><h2>Integrity check</h2><p><strong>If you think this problem could be due to corruption caused by a failed upgrade (e.g. time-out during extraction), check the following integrity check&hellip;</strong></p>', run_integrity_check(true), '</div></div><br />';
        }
        flush();
        echo $extra, "\n";
        if ($may_show_footer) {
            echo '<p>Details here are intended only for the website/system-administrator, not for regular website users.<br />&raquo; <strong>If you are a regular website user, please let the website staff deal with this problem.</strong></p>' . "\n" . '<p class="associated-details">Depending on the error, and only if the website installation finished, you may need to <a href="#!" onclick="if (!window.confirm(\'Are you staff on this site?\')) return false; this.href=\'' . htmlentities($edit_url) . '\';">edit the installation options</a> (the <kbd>_config.php</kbd> file).</p>' . "\n" . '<p class="associated-details">ocProducts maintains full documentation for all procedures and tools (including <a href="https://compo.sr/docs/tut-disaster.htm">disaster recovery</a>). These may be found on the <a href="http://compo.sr">Composr website</a>. If you are unable to easily solve this problem, we may be contacted from our website and can help resolve it for you.</p>' . "\n" . '<hr />' . "\n" . '<p style="font-size: 0.8em"><a href="https://compo.sr/">Composr</a> is a <abbr title="Content Management System">CMS</abbr> for building websites, developed by ocProducts.</p>' . "\n";
        }
        echo '</div></body>' . "\n" . '</html>';
        $GLOBALS['SCREEN_TEMPLATE_CALLED'] = '';

        echo '<!--ERROR-->';

        $contents = ob_get_contents();
        $dir = get_custom_file_base() . '/critical_errors';
        if ((is_dir($dir)) && ((!isset($_GET['page'])) || ($_GET['page'] != '_critical_error')) && ((!isset($GLOBALS['SEMI_DEV_MODE'])) || (!$GLOBALS['SEMI_DEV_MODE']) || (!empty($_GET['keep_dev_mode']) && ($_GET['keep_dev_mode'] == '0')))) {
            $code = uniqid('', true);
            file_put_contents($dir . '/' . $code . '.log', $contents);
            ob_end_clean();

            if ($code == 'BANNED') {
                http_response_code(403);
            } else {
                http_response_code(500);
            }
            global $RELATIVE_PATH, $SITE_INFO;
            if (isset($SITE_INFO['base_url'])) {
                $back_path = $SITE_INFO['base_url'];
            } else {
                $back_path = preg_replace('#[^/]+#', '..', $RELATIVE_PATH);
            }
            if (is_file(get_custom_file_base() . '/_critical_error.html')) {
                $url = (($back_path == '') ? '' : ($back_path . '/')) . '_critical_error.html?error_code=' . urlencode($code);
            } else {
                $url = (($back_path == '') ? '' : ($back_path . '/')) . 'index.php?page=_critical_error&error_code=' . urlencode($code);
            }
            @header('Location: ' . $url);
            echo '<meta http-equiv="refresh" content="0;url=' . htmlentities($url) . '" />';
        } else {
            ob_end_flush();
        }

        if (php_function_allowed('error_log')) {
            @error_log('Composr critical error: ' . $error, 0);
        }

        if ($exit) {
            exit();
        }
    }
}

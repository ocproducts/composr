<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_release_build
 */

/*
This script builds all the web-server script files that contain rewrite rules (e.g. recommended.htaccess), from the ones defined in here.

Also see url_remappings.php for the Composr side of things (and to a lesser extent, urls.php and urls2.php).

Also see chmod_consistency.php for the equivalent for chmodding rules, and make_release.php for manifest building.
*/

$cli = ((php_sapi_name() == 'cli') && (empty($_SERVER['REMOTE_ADDR'])) && (empty($_ENV['REMOTE_ADDR'])));
if (!$cli) {
    header('Content-type: text/plain');
    exit('Must run this script on command line, for security reasons');
}

header('Content-type: text/plain');

$zones = array('', 'site', 'forum', 'adminzone', 'cms', 'collaboration');

$zone_list = '';
foreach ($zones as $zone) {
    if ($zone == '') {
        continue; // We don't need to put this one in
    }
    if ($zone_list != '') {
        $zone_list .= '|';
    }
    $zone_list .= $zone;
}

// Define our rules

$rewrite_rules = array(
    array(
        'Redirect away from modules called directly by URL. Helpful as it allows you to "run" a module file in a debugger and still see it running.',
        array(
            array('^([^=]*)pages/(modules|modules_custom)/([^/]*)\.php$', '$1index.php\?page=$3', array('L', 'QSA', 'R'), true),
        ),
    ),

    // Traditional Composr form, /pg/

    array(
        'PG STYLE: These have a specially reduced form (no need to make it too explicit that these are Wiki+). We shouldn\'t shorten them too much, or the actual zone or base URL might conflict',
        array(
            array('^([^=]*)pg/s/([^\&\?]*)/index\.php$', '$1index.php\?page=wiki&id=$2', array('L', 'QSA'), true),
        ),
    ),

    array(
        'PG STYLE: These are standard patterns',
        array(
            array('^([^=]*)pg/([^/\&\?]*)/([^/\&\?]*)/([^\&\?]*)/index\.php(.*)$', '$1index.php\?page=$2&type=$3&id=$4$5', array('L', 'QSA'), true),
            array('^([^=]*)pg/([^/\&\?]*)/([^/\&\?]*)/index\.php(.*)$', '$1index.php\?page=$2&type=$3$4', array('L', 'QSA'), true),
            array('^([^=]*)pg/([^/\&\?]*)/index\.php(.*)$', '$1index.php\?page=$2$3', array('L', 'QSA'), true),
            array('^([^=]*)pg/index\.php(.*)$', '$1index.php\?page=$3', array('L', 'QSA'), true),
        ),
    ),

    array(
        'PG STYLE: Now the same as the above sets, but without any additional parameters (and thus no index.php)',
        array(
            array('^([^=]*)pg/s/([^\&\?]*)$', '$1index.php\?page=wiki&id=$2', array('L', 'QSA'), true),
            array('^([^=]*)pg/([^/\&\?]*)/([^/\&\?]*)/([^\&\?]*)/$', '$1index.php\?page=$2&type=$3&id=$4', array('L', 'QSA'), true),
            array('^([^=]*)pg/([^/\&\?]*)/([^/\&\?]*)/([^\&\?]*)$', '$1index.php\?page=$2&type=$3&id=$4', array('L', 'QSA'), true),
            array('^([^=]*)pg/([^/\&\?]*)/([^/\&\?]*)$', '$1index.php\?page=$2&type=$3', array('L', 'QSA'), true),
            array('^([^=]*)pg/([^/\&\?]*)$', '$1index.php\?page=$2', array('L', 'QSA'), true),
        ),
    ),

    array(
        'PG STYLE: And these for those nasty situations where index.php was missing and we couldn\'t do anything about it (usually due to keep_session creeping into a semi-cached URL)',
        array(
            array('^([^=]*)pg/s/([^\&\?\.]*)&(.*)$', '$1index.php\?$3&page=wiki&id=$2', array('L', 'QSA'), true),
            array('^([^=]*)pg/([^/\&\?\.]*)/([^/\&\?\.]*)/([^/\&\?\.]*)&(.*)$', '$1index.php\?$5&page=$2&type=$3&id=$4', array('L', 'QSA'), true),
            array('^([^=]*)pg/([^/\&\?\.]*)/([^/\&\?\.]*)&(.*)$', '$1index.php\?$4&page=$2&type=$3', array('L', 'QSA'), true),
            array('^([^=]*)pg/([^/\&\?\.]*)&(.*)$', '$1index.php\?$3&page=$2', array('L', 'QSA'), true),
        ),
    ),

    // New-style Composr form, .htm

    array(
        'HTM STYLE: These have a specially reduced form (no need to make it too explicit that these are Wiki+). We shouldn\'t shorten them too much, or the actual zone or base URL might conflict',
        array(
            array('^(' . $zone_list . ')/s/([^\&\?]*)\.htm$', '$1/index.php\?page=wiki&id=$2', array('L', 'QSA'), true),
            array('^s/([^\&\?]*)\.htm$', 'index\.php\?page=wiki&id=$1', array('L', 'QSA'), true),
        ),
    ),

    array(
        'HTM STYLE: These are standard patterns',
        array(
            array('^(' . $zone_list . ')/([^/\&\?]+)/([^/\&\?]*)/([^\&\?]*)\.htm$', '$1/index.php\?page=$2&type=$3&id=$4', array('L', 'QSA'), true),
            array('^(' . $zone_list . ')/([^/\&\?]+)/([^/\&\?]*)\.htm$', '$1/index.php\?page=$2&type=$3', array('L', 'QSA'), true),
            array('^(' . $zone_list . ')/([^/\&\?]+)\.htm$', '$1/index.php\?page=$2', array('L', 'QSA'), true),
            array('^([^/\&\?]+)/([^/\&\?]*)/([^\&\?]*)\.htm$', 'index.php\?page=$1&type=$2&id=$3', array('L', 'QSA'), true),
            array('^([^/\&\?]+)/([^/\&\?]*)\.htm$', 'index.php\?page=$1&type=$2', array('L', 'QSA'), true),
            array('^([^/\&\?]+)\.htm$', 'index.php\?page=$1', array('L', 'QSA'), true),
        ),
    ),

    // New-style Composr form, simple

    array(
        'SIMPLE STYLE: These have a specially reduced form (no need to make it too explicit that these are Wiki+). We shouldn\'t shorten them too much, or the actual zone or base URL might conflict',
        array(
            array('^(' . $zone_list . ')/s/([^\&\?]*)$', '$1/index.php\?page=wiki&id=$2', array('L', 'QSA'), false),
            array('^s/([^\&\?]*)$', 'index\.php\?page=wiki&id=$1', array('L', 'QSA'), false),
        ),
    ),

    array(
        'SIMPLE STYLE: These are standard patterns',
        array(
            array('^(' . $zone_list . ')/([^/\&\?]+)/([^/\&\?]*)/([^\&\?]*)$', '$1/index.php\?page=$2&type=$3&id=$4', array('L', 'QSA'), false),
            array('^(' . $zone_list . ')/([^/\&\?]+)/([^/\&\?]*)$', '$1/index.php\?page=$2&type=$3', array('L', 'QSA'), false),
            array('^(' . $zone_list . ')/([^/\&\?]+)$', '$1/index.php\?page=$2', array('L', 'QSA'), false),
            array('^([^/\&\?]+)/([^/\&\?]*)/([^\&\?]*)$', 'index.php\?page=$1&type=$2&id=$3', array('L', 'QSA'), false),
            array('^([^/\&\?]+)/([^/\&\?]*)$', 'index.php\?page=$1&type=$2', array('L', 'QSA'), false),
            array('^([^/\&\?]+)$', 'index.php\?page=$1', array('L', 'QSA'), false),
        ),
    ),
);

// Write rules to google_appengine.php and app.yaml (Google App Engine)
write_to('sources/google_appengine.php', 'GAE1', "\t" . '// RULES START', "\t// RULES END", 1, $rewrite_rules);
write_to('data/modules/google_appengine/app.yaml', 'GAE2', 'handlers:' . "\n", "- url: ^.*\.(css", 0, $rewrite_rules);

// Write rules to plain.htaccess (Apache, CGI PHP)
write_to('plain.htaccess', 'Apache', '<IfModule mod_rewrite.c>', '</IfModule>', 0, $rewrite_rules);

// Write rules to recommended.htaccess (Apache, PHP module)
write_to('recommended.htaccess', 'Apache', '<IfModule mod_rewrite.c>', '</IfModule>', 0, $rewrite_rules);

// Write rules to install.php (quick installer)
write_to('install.php', 'Apache', '/*REWRITE RULES START*/$clauses[]=<<<END', 'END;/*REWRITE RULES END*/', 0, $rewrite_rules);

// Write rules to web.config (new IIS)
write_to('web.config', 'IIS', '<rules>', '</rules>', 4, $rewrite_rules);

// Write rules to cms.hdf (Hip Hop PHP)
write_to('cms.hdf', 'HPHP', 'RewriteRules {', "\t\t}", 3, $rewrite_rules);

function write_to($file_path, $type, $match_start, $match_end, $indent_level, $rewrite_rules)
{
    if (!file_exists($file_path)) {
        $file_path = '../' . $file_path;
    }

    $existing = file_get_contents($file_path);

    switch ($type) {
        case 'Apache':
            $new = $match_start;

            $rules_txt = '';
            if ($type == 'Apache') {
                $rules_txt .= '

                    # Needed for mod_rewrite. Disable this line if your server does not have AllowOverride permission (can be one cause of Internal Server Errors)
                    Options +FollowSymLinks

                    RewriteEngine on

                    # If rewrites are directing to bogus URLs, try adding a "RewriteBase /" line, or a "RewriteBase /subdir" line if you\'re in a subdirectory. Requirements vary from server to server.
                    ';
            }
            $rules_txt .= '
            # Anything that would point to a real file should actually be allowed to do so. If you have a "RewriteBase /subdir" command, you may need to change to "%{DOCUMENT_ROOT}/subdir/$1".
            RewriteCond %{DOCUMENT_ROOT}/$1 -f [OR]
            RewriteCond %{DOCUMENT_ROOT}/$1 -l [OR]
            RewriteCond %{DOCUMENT_ROOT}/$1 -d
            RewriteRule (.*) - [L]

            # WebDAV implementation (requires the non-bundled WebDAV addon)
            RewriteRule ^webdav(/.*|$) data_custom/webdav.php [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]

            ';
            foreach ($rewrite_rules as $x => $rewrite_rule_block) {
                if ($x != 0) {
                    $rules_txt .= "\n";
                }
                list($comment, $rewrite_rule_set) = $rewrite_rule_block;
                $rules_txt .= '# ' . $comment . "\n";
                foreach ($rewrite_rule_set as $rewrite_rule) {
                    list($rule, $to, $_flags, $enabled) = $rewrite_rule;
                    $_flags = implode(',', $_flags);
                    $rules_txt .= ($enabled ? '' : '#') . 'RewriteRule ' . $rule . ' ' . $to . ' [' . $_flags . ']' . "\n";
                }
            }
            $rules_txt = preg_replace('#^\t*#m', str_repeat("\t", $indent_level), $rules_txt);
            $new .= $rules_txt;
            $new .= $match_end;
            break;

        case 'IIS':
            $new = $match_start . "\n";
            $rules_txt = '';
            $i = 0;
            foreach ($rewrite_rules as $x => $rewrite_rule_block) {
                if ($x != 0) {
                    $rules_txt .= "\n\n\n";
                }
                list($comment, $rewrite_rule_set) = $rewrite_rule_block;
                $rules_txt .= '<!-- ' . $comment . '-->' . "\n\n";
                foreach ($rewrite_rule_set as $y => $rewrite_rule) {
                    list($rule, $to, $flags, $enabled) = $rewrite_rule;

                    $type_str = in_array('R', $flags) ? 'type="Redirect" redirectType="Found"' : 'type="Rewrite"';

                    if ($y != 0) {
                        $rules_txt .= "\n\n";
                    }

                    if (!$enabled) {
                        $rules_txt .= '<--';
                    }
                    $rules_txt .= '<rule name="Imported Rule ' . strval($i + 1) . '" stopProcessing="' . (in_array('L', $flags) ? 'true' : 'false') . '">
                               <match url="' . htmlentities($rule) . '" ignoreCase="false" />
                               <action ' . $type_str . ' url="' . htmlentities($rule) . '" appendQueryString="' . (in_array('QSA', $flags) ? 'true' : 'false') . '" />
                            </rule>';
                    if (!$enabled) {
                        $rules_txt .= '-->';
                    }
                }
                $i++;
            }
            $rules_txt = preg_replace('#^\t*#m', str_repeat("\t", $indent_level), $rules_txt);
            $new .= $rules_txt;
            $new .= "\n\t\t\t" . $match_end;
            break;

        case 'GAE1':
            $new = $match_start;
            $rules_txt = '';
            foreach ($rewrite_rules as $x => $rewrite_rule_block) {
                list($comment, $rewrite_rule_set) = $rewrite_rule_block;
                foreach ($rewrite_rule_set as $y => $rewrite_rule) {
                    list($rule, $to, $flags, $enabled) = $rewrite_rule;

                    $rules_txt .= "\n" . ($enabled ? '' : '//') . "if (preg_match('#{$rule}#',\$uri,\$matches)!=0)\n" . ($enabled ? '' : '//') . "\t{\n\t_roll_gae_redirect(\$matches,'{$to}');\n\treturn null;\n\t}";
                }
            }
            $rules_txt = preg_replace('#^#m', str_repeat("\t", $indent_level), $rules_txt) . "\n";
            $new .= $rules_txt;
            $new .= $match_end;
            break;

        case 'GAE2':
            $new = $match_start;
            $rules_txt = '';
            foreach ($rewrite_rules as $x => $rewrite_rule_block) {
                list($comment, $rewrite_rule_set) = $rewrite_rule_block;
                foreach ($rewrite_rule_set as $y => $rewrite_rule) {
                    list($rule, $to, $flags, $enabled) = $rewrite_rule;

                    if (substr($rule, 0, 1) == '^') {
                        $rule = substr($rule, 1);
                    }
                    if (substr($rule, -1) == '$') {
                        $rule = substr($rule, 0, strlen($rule) - 1);
                    }

                    $rules_txt .=
                        ($enabled ? '' : '#') . '- url: /' . $rule . "\n" .
                        ($enabled ? '' : '#') . '  script: ' . preg_replace('#\?.*$#', '', str_replace(array('\\', '$'), array('', '\\'), $to)) . "\n";
                }
            }
            $rules_txt = preg_replace('#^\t*#m', str_repeat("\t", $indent_level), $rules_txt);
            $new .= $rules_txt;
            $new .= $match_end;
            break;

        case 'HPHP':
            $new = $match_start;
            $rules_txt = '';
            $i = 0;
            foreach ($rewrite_rules as $x => $rewrite_rule_block) {
                if ($x != 0) {
                    $rules_txt .= "\n";
                }
                list($comment, $rewrite_rule_set) = $rewrite_rule_block;
                $rules_txt .= "\n" . '# ' . $comment . "\n";
                foreach ($rewrite_rule_set as $y => $rewrite_rule) {
                    list($rule, $to, $flags, $enabled) = $rewrite_rule;

                    if ($y != 0) {
                        $rules_txt .= "\n\n";
                    }

                    $rules_txt .= ($enabled ? '' : '#') . 'rule' . strval($i + 1) . ' {
                                        ' . ($enabled ? '' : '#') . 'pattern = ' . $rule . '
                                        ' . ($enabled ? '' : '#') . 'to = ' . $to . '
                                        ' . ($enabled ? '' : '#') . 'qsa = ' . (in_array('QSA', $flags) ? 'true' : 'false') . '
                            ' . ($enabled ? '' : '#') . '}';
                }
                $i++;
            }
            $rules_txt = preg_replace('#^\t*#m', str_repeat("\t", $indent_level), $rules_txt);
            $new .= "\n" . $rules_txt;
            $new .= "\n\t\t" . $match_end;
            break;
    }

    $updated = preg_replace('#' . preg_quote($match_start, '#') . '.*' . preg_quote($match_end, '#') . '#s', 'xxxRULES-GO-HERExxx', $existing);
    $updated = str_replace('xxxRULES-GO-HERExxx', $new, $updated);

    $myfile = fopen($file_path, 'wb');
    fwrite($myfile, $updated);
    fclose($myfile);

    echo 'Done ' . $file_path . "\n";
}

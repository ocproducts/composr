<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 You may not distribute a modified version of this file, unless it is solely as a Composr modification.
 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composrcom
 */

// Find Composr base directory, and chdir into it
global $FILE_BASE, $RELATIVE_PATH;
$FILE_BASE = realpath(__FILE__);
$deep = 'uploads/website_specific/compo.sr/scripts/';
$FILE_BASE = str_replace($deep, '', $FILE_BASE);
$FILE_BASE = str_replace(str_replace('/', '\\', $deep), '', $FILE_BASE);
if (substr($FILE_BASE, -4) == '.php') {
    $a = strrpos($FILE_BASE, '/');
    $b = strrpos($FILE_BASE, '\\');
    $FILE_BASE = dirname($FILE_BASE);
}
$RELATIVE_PATH = '';
@chdir($FILE_BASE);

global $FORCE_INVISIBLE_GUEST;
$FORCE_INVISIBLE_GUEST = true;
global $EXTERNAL_CALL;
$EXTERNAL_CALL = false;
if (!is_file($FILE_BASE . '/sources/global.php')) {
    exit('<html><head><title>Critical startup error</title></head><body><h1>Composr startup error</h1><p>The second most basic Composr startup file, sources/global.php, could not be located. This is almost always due to an incomplete upload of the Composr system, so please check all files are uploaded correctly.</p><p>Once all Composr files are in place, Composr must actually be installed by running the installer. You must be seeing this message either because your system has become corrupt since installation, or because you have uploaded some but not all files from our manual installer package: the quick installer is easier, so you might consider using that instead.</p><p>ocProducts maintains full documentation for all procedures and tools, especially those for installation. These may be found on the <a href="http://compo.sr">Composr website</a>. If you are unable to easily solve this problem, we may be contacted from our website and can help resolve it for you.</p><hr /><p style="font-size: 0.8em">Composr is a website engine created by ocProducts.</p></body></html>');
}
require($FILE_BASE . '/sources/global.php');

require_lang('composrcom');

//if (get_ip_address()!='86.141.238.33') return old_style();

header('Content-type: text/plain; charset=' . get_charset());
if (get_param_integer('html', 0) == 1) {
    header('Content-type: text/html');
    echo '<script src="/themes/default/templates_cached/EN/javascript.js"></script>';
}

// Different ways at looking at the version number
require_code('version2');
$dotted = get_version_dotted__from_anything(get_param_string('version'));
list($intended, $qualifier, $qualifier_number, $long_version) = get_version_components__from_dotted($dotted);
$version_pretty = get_version_pretty__from_dotted($dotted);
if (!is_null($qualifier)) {
    $long_version_with_qualifier = $long_version . ' ' . $qualifier . $qualifier_number;
}

/*
VARIABLE KEY:

version: complete minimal version string intended for humans
long_version: maximal dotted version number
intended: minimal dotted version number
qualifier: NULL or alpha or beta or RC
qualifier_number: NULL or integer
*/

// Find our version
$our_version = null;
if (preg_match('#^[\d\.]+$#', $intended) != 0) { // If we understand the format
    $download_row = find_download($version_pretty);
    if (!is_null($download_row)) {
        $our_version = array(
            'version' => $version_pretty,
            'download_description' => strip_download_description($download_row['nice_description']),
            'add_date' => $download_row['add_date'],
        );
    }
} else {
    old_style();
    return;
} // We can't do our clever stuff as we don't recognise the version number formatting. This should never happen, but better to allow it.

// Possible next versions, in order of decreasing distance (i.e. we search from right to left until we find a match). Will never recommend a beta or RC unless you're already on the same track of them
$bits = explode('.', $intended);
for ($i = 0; $i < 3; $i++) {
    if (!isset($bits[$i])) {
        $bits[$i] = 0;
    } else {
        $bits[$i] = intval($bits[$i]);
    }
}
$possible_next_versions = array();
$stub = '';
for ($i = 0; $i < 3; $i++) {
    if ((is_null($qualifier)) || ($i != 2)) {
        $x = $stub . (($stub == '') ? '' : '.') . strval($bits[$i] + 1);
        $possible_next_versions[] = $x;
    } elseif ($qualifier == 'RC') {
        $x = $stub . (($stub == '') ? '' : '.') . strval($bits[$i] + (($i == 2) ? 0 : 1));
        $possible_next_versions[] = $x;
        $x = $stub . (($stub == '') ? '' : '.') . strval($bits[$i]) . ' RC' . strval($qualifier_number + 1);
        $possible_next_versions[] = $x;
    } elseif ($qualifier == 'beta') {
        $x = $stub . (($stub == '') ? '' : '.') . strval($bits[$i] + (($i == 2) ? 0 : 1));
        $possible_next_versions[] = $x;
        $x = $stub . (($stub == '') ? '' : '.') . strval($bits[$i]) . ' RC1';
        $possible_next_versions[] = $x;
        $x = $stub . (($stub == '') ? '' : '.') . strval($bits[$i]) . ' beta' . strval($qualifier_number + 1);
        $possible_next_versions[] = $x;
    } elseif ($qualifier == 'alpha') {
        $x = $stub . (($stub == '') ? '' : '.') . strval($bits[$i] + (($i == 2) ? 0 : 1));
        $possible_next_versions[] = $x;
        $x = $stub . (($stub == '') ? '' : '.') . strval($bits[$i]) . ' RC1';
        $possible_next_versions[] = $x;
        $x = $stub . (($stub == '') ? '' : '.') . strval($bits[$i]) . ' beta1';
        $possible_next_versions[] = $x;
        $x = $stub . (($stub == '') ? '' : '.') . strval($bits[$i]) . ' alpha' . strval($qualifier_number + 1);
        $possible_next_versions[] = $x;
    }

    if ($stub != '') {
        $stub .= '.';
    }
    $stub .= strval($bits[$i]);
}

// Strip down to canonical again
foreach ($possible_next_versions as $x => $pos) {
    $possible_next_versions[$x] = preg_replace('#(\.0)+($| )#', '${2}', $pos);
}

// Find closest next version
$possible_next_versions = array_reverse($possible_next_versions);
$next_upgrade_version = null;
foreach ($possible_next_versions as $pos_version) {
    if ($pos_version == $version_pretty) {
        continue;
    }

    $row = find_version($pos_version);
    if (!is_null($row)) {
        $download_row = find_download($pos_version);
        $next_upgrade_version = array(
            'version' => $pos_version,
            'news_id' => $row['id'],
            'download_description' => is_null($download_row) ? '' : strip_download_description($download_row['nice_description']),
            'add_date' => $row['add_date'],
        );
        break;
    }
}

// Find best version for major, minor, and patch.
$stub = '';
$higher_versions = array(null, null, null);
global $DOWNLOAD_ROWS;
for ($i = 0; $i < 3; $i++) { // Loop over each release level
    $found = null;
    $looking_for = 'Composr Version ' . $stub; // Starts with blank stub, which will match highest version. Subsequent iterations bind to the version numbers and find boundewd maximum highest version under that version prefix.

    foreach (array_reverse($DOWNLOAD_ROWS) as $row) { // Iterate, newest to oldest
        // If it's on the release level being inspected, and we're either on a qualifier (alpha/beta/RC) already, or this isn't having a qualifier (i.e. we don't want to suggest someone go to a bleeding-edge version)
        if ((substr($row['nice_title'], 0, strlen($looking_for)) == $looking_for) && ((!is_null($qualifier)) || ((strpos($row['nice_title'], 'RC') === false) && (strpos($row['nice_title'], 'beta') === false) && (strpos($row['nice_title'], 'alpha') === false)))) {
            // $this_version will hold the version we're currently looking at, comparing to the version the user has
            // Lots of work to split up version numbering
            $this_version = preg_replace('# \(.*#', '', substr($row['nice_title'], strlen($looking_for) - strlen($stub)));
            $this_bits = explode('.', preg_replace('# .*$#', '', $this_version));
            $this_qualifier = (strpos($this_version, ' ') === false) ? mixed() : preg_replace('#^.* #', '', $this_version); // Extract qualifier from $this_version, which btw is a "pretty version" format version number
            $different = false; // Used to ensure the version really is different to the one we're on
            for ($j = 0; $j <= $i; $j++) {
                if (!array_key_exists($j, $this_bits)) {
                    $this_bits[$j] = '0';
                }
                if (!is_numeric($this_bits[$j])) {
                    break;
                }
                if (($bits[$j] != $this_bits[$j])) {
                    $different = true;
                }
            }
            for (; $j < 3; $j++) {
                if (!array_key_exists($j, $this_bits)) {
                    $this_bits[$j] = '0';
                }
            }
            if (!is_null($this_qualifier)) {
                if ($this_qualifier !== ($qualifier . strval($qualifier_number))) {
                    $different = true;
                }
            } elseif (!is_null($qualifier)) {
                $different = true;
            }

            $news_row = find_version($this_version);

            // If different and better version
            $this_assembled = implode('.', $this_bits) . (is_null($this_qualifier) ? '' : ('.' . $this_qualifier));
            $assembled = implode('.', $bits) . (is_null($qualifier) ? '' : ('.' . $qualifier . $qualifier_number));
            if ((version_compare($this_assembled, $assembled) >= 0) && ($different) && (!is_null($news_row))) {
                if (get_param_integer('test', 0) == 1) {
                    @var_dump(implode('.', $this_bits) . (is_null($this_qualifier) ? '' : ('.' . $this_qualifier)));
                    @var_dump(implode('.', $bits) . (is_null($qualifier) ? '' : ('.' . $qualifier . $qualifier_number)));
                }

                if (is_null($found)) { // Only set $found if not already. We were iterating downloads in reverse order, so the newest is found first via this
                    $found = array( // Outside
                                    'version' => $this_version,
                                    'news_id' => $news_row['id'],
                                    'download_description' => '', // We set this blank here as if this is the latest version then the download description is only going to say that, which is not interesting to us.
                                    'add_date' => $row['add_date'],
                    );
                } else {
                    if (strlen($found['download_description']) < 3000) { // If was already found and we have release details in this download description, append it, it's still good advice for the upgrade level
                        if ($found['download_description'] != '') {
                            $found['download_description'] .= "\n---\n";
                        }
                        $found['download_description'] .= strip_download_description($row['nice_description']); // We chain all the download descriptions together; each says why the version involved is out of date, so together it is like a "why upgrade" history. The news posts on the other hand say what a new version itself offers.
                    }
                }
            } elseif (!$different) {
                if (!is_null($found)) {
                    if (strlen($found['download_description']) < 3000) {
                        if ($found['download_description'] != '') {
                            $found['download_description'] .= "\n---\n";
                        }
                        $found['download_description'] .= strip_download_description($row['nice_description']); // We chain all the download descriptions together; each says why the version involved is out of date, so together it is like a "why upgrade" history. The news posts on the other hand say what a new version itself offers.
                    }
                }
            }
        }
    }

    // If the best yet for any valid release level, remember it
    if (!is_null($found)) {
        for ($_i = 0; $_i < $i; $_i++) {
            if (($higher_versions[$_i] !== null) && ($higher_versions[$_i]['version'] == $found['version'])) {
                $found = null;
            }
        }

        $higher_versions[$i] = $found;
    }

    if ($stub != '') {
        $stub .= '.';
    }
    $stub .= strval($bits[$i]);
}

// Output it all (descriptions, news links, etc)
// Current version
echo '<h3 class="notes_about">Notes about your current version (' . escape_html($long_version_with_qualifier) . ')</h3>';
$has_jump = (!is_null($higher_versions[0])) || (!is_null($higher_versions[1])) || (!is_null($higher_versions[2]));
if (!is_null($our_version)) {
    if (!$has_jump) {
        $descrip = $our_version['download_description'] . ' You are running the latest version.';
    } else {
        $descrip = 'You are <strong>not</strong> running the latest version. Browse the <a title="Composr news archive (this link will open in a new window)" target="_blank" href="' . escape_html(static_evaluate_tempcode(build_url(array('page' => 'news'), 'site'))) . '">Composr news archive</a> for a full list of the updates or see below for recommended paths.';
    }
    echo '<p>' . $descrip . '</p>';
} else {
    echo '<p>' . do_lang('CMS_NON_EXISTANT_VERSION') . '</p>';
}
/*if (false) { // Info isn't actually helpful, as the download_description above contains it also
	echo '<h3>Next version</h3>';
	// Next version
	if (!is_null($next_upgrade_version)) {
		// NB: $has_jump should always be true in this branch, unless there are holes in the version DB
		echo '<p>You are running an outdated version. The closest version is <a onclick="window.open(this.href,null,\'status=yes,toolbar=no,location=no,menubar=no,resizable=yes,scrollbars=yes,width=976,height=600\'); return false;" target="_blank" title="Version '.escape_html($next_upgrade_version['version']).' (this link will open in a new window)" href="'.escape_html(static_evaluate_tempcode(build_url(array('page'=>'news','type'=>'view','id'=>$next_upgrade_version['news_id'],'wide_high'=>1),'site'))).'">version '.escape_html($next_upgrade_version['version']).'</a>, but read on for the latest recommended upgrade paths.</p>';
	} elseif ((!is_null($our_version)) && (!$has_jump)) {
		echo '<p>You are running the latest version.</p>';
	} else {
		echo '<p>Sorry, details of the next version is not in our database.</p>';
	}
} else
{
	if ((is_null($next_upgrade_version)) && (!is_null($our_version)) && (!$has_jump)) {
		echo '<p>You are running the latest version.</p>';
	}
}*/
// Latest versions
if ($has_jump) {
    echo '<h3>Latest recommended upgrade paths</h3>';

    $upgrade_type = array('major upgrade, may break compatibility of customisations', 'feature upgrade', 'easy patch upgrade');
    for ($i = 0; $i <= 2; $i++) {
        if (!is_null($higher_versions[$i])) {
            $discontinued = array('1', '2', '2.1', '2.5', '2.6', '3', '3.1', '3.2');
            $note = '';
            foreach ($discontinued as $d) {
                if ((strlen($d) == 1) && ($higher_versions[$i]['version'] != $d)) {
                    $d .= '.0';
                }
                if ((substr($higher_versions[$i]['version'], 0, strlen($d) + 1) == $d . '.') || ($higher_versions[$i]['version'] == $d)) {
                    $note = ' &ndash; <em>Note that the ' . $d . ' version line is no longer supported</em>';
                }
            }

            $tooltip = comcode_to_tempcode('[title="2"]Inbetween versions[/title]' . $higher_versions[$i]['download_description']);

            $upgrade_url = static_evaluate_tempcode(build_url(array('page' => 'news', 'type' => 'view', 'id' => $higher_versions[$i]['news_id'], 'from_version' => $long_version_with_qualifier, 'wide_high' => 1), 'site'));
            echo '<p class="version">';

            // First line of details
            echo '<span class="version_number">' . escape_html($higher_versions[$i]['version']) . '</span>';
            echo ' ';
            echo '<span class="version_news_link">[ <a onclick="window.open(this.href,null,\'status=yes,toolbar=no,location=no,menubar=no,resizable=yes,scrollbars=yes,width=976,height=600\'); return false;" target="_blank" title="' . $upgrade_type[$i] . ' news post (this link will open in a new window)" href="' . escape_html($upgrade_url) . '">view news post</a> ]</span>';
            echo ' ';

            // Output upgrader link
            $out = '';
            $upgrade_script = (($bits[0] >= 4) ? 'upgrader.php' : 'force_upgrade.php');
            if (isset($found['news_id'])) {
                $upgrade_script .= '?news_id=' . strval($higher_versions[$i]['news_id']);
            }
            $out = "
			<span class=\"version_button\" id=\"link_pos_" . strval($i) . "\"></span>
			<script>// <![CDATA[
				var div=document.getElementById('link_pos_" . strval($i) . "');
				var upgrader_link=get_base_url()+'/" . $upgrade_script . "';
				var h='<form style=\"display: inline\" action=\"'+upgrader_link+'\" target=\"_blank\" method=\"post\"><input class=\"menu__adminzone__tools__upgrade button_screen_item\" type=\"submit\" title=\"Upgrade to " . escape_html($higher_versions[$i]['version']) . "\" value=\"Launch upgrader\" /<\/form>';
				if (window.setInnerHTML)
				{
					setInnerHTML(div,h);
				} else
				{
					div.innerHTML=h;
				}
			//]]></script>
			";

            // Next line of details
            echo '<span class="version_details">(' . $upgrade_type[$i] . ', released ' . display_time_period(time() - $higher_versions[$i]['add_date']) . ' ago)</span>';
            echo ' ';
            echo '<span class="version_note">' . $note . '</span>';
            echo ' ';
            echo '<img class="version_help_icon" onmouseout="if (typeof window.deactivateTooltip!=\'undefined\') deactivateTooltip(this,event);" onmousemove="if (typeof window.activateTooltip!=\'undefined\') repositionTooltip(this,event);" onmouseover="if (this.parentNode.title!=undefined) this.parentNode.title=\'\'; if (typeof window.activateTooltip!=\'undefined\') activateTooltip(this,event,\'' . escape_html(str_replace("\n", '\n', addslashes($tooltip->evaluate()))) . '\',\'600px\',null,null,false,true);" alt="Help" src="' . escape_html(find_theme_image('icons/16x16/help')) . '" />';
            echo ' ';

            echo '</p>';

            // Noscript version
            $out = "
			<noscript>
				<form style=\"display: inline\" action=\"../" . $upgrade_script . "\" target=\"_blank\" method=\"post\">
					<input class=\"menu__adminzone__tools__upgrade button_screen_item\" type=\"submit\" title=\"Upgrade to " . escape_html($higher_versions[$i]['version']) . "\" value=\"Launch upgrader\" />
				</form>
			</noscript>
			";
            echo str_replace("\n", '', str_replace("\r", '', $out));
        }
    }
}

function strip_download_description($d)
{
    return static_evaluate_tempcode(comcode_to_tempcode(preg_replace('#A new version, [\.\d\w]+ is available\. #', '', preg_replace('# There may have been other upgrades since .* - see .+\.#', '', $d))));
}

function find_version($version_pretty)
{
    global $NEWS_ROWS;
    load_news_rows();

    foreach ($NEWS_ROWS as $news_row) {
        if ($news_row['nice_title'] == $version_pretty . ' released') {
            return $news_row;
        }
        if ($news_row['nice_title'] == 'Composr ' . $version_pretty . ' released') {
            return $news_row;
        }
        if ($news_row['nice_title'] == $version_pretty . ' released!') {
            return $news_row;
        }
        if ($news_row['nice_title'] == 'Composr ' . $version_pretty . ' released!') {
            return $news_row;
        }
    }

    return null;
}

function find_download($version_pretty)
{
    global $DOWNLOAD_ROWS;
    load_download_rows();

    $download_row = null;
    foreach ($DOWNLOAD_ROWS as $_download_row) {
        if (((preg_replace('# \(.*#', '', $_download_row['nice_title']) == 'Composr Version ' . $version_pretty) || (preg_replace('#(\.0)* \(.*#', '', $_download_row['nice_title']) == 'Composr Version ' . preg_replace('#(\.0)*#', '', $version_pretty))) && (strpos($_download_row['nice_title'], 'manual') === false)) {
            $download_row = $_download_row;
            break;
        }
    }

    return $download_row;
}

function load_news_rows()
{
    global $NEWS_ROWS;
    if (!isset($NEWS_ROWS)) {
        if (get_param_integer('test_mode', 0) == 1) { // Test data
            $NEWS_ROWS = array(
                array('id' => 2, 'nice_title' => 'Composr 3 released', 'add_date' => time() - 60 * 60 * 8),
                array('id' => 3, 'nice_title' => '3.1 released', 'add_date' => time() - 60 * 60 * 5),
                array('id' => 4, 'nice_title' => '3.1.1 released', 'add_date' => time() - 60 * 60 * 5),
                array('id' => 5, 'nice_title' => 'Composr 3.2 beta1 released', 'add_date' => time() - 60 * 60 * 4),
                array('id' => 6, 'nice_title' => 'Composr 3.2 released', 'add_date' => time() - 60 * 60 * 3),
                array('id' => 7, 'nice_title' => 'Composr 4 released', 'add_date' => time() - 60 * 60 * 1),
            );
        } else {
            $NEWS_ROWS = $GLOBALS['SITE_DB']->query_select('news', array('n.*', 'date_and_time AS add_date'), array('validated' => 1, 'news_category' => 29), 'ORDER BY add_date');
            foreach ($NEWS_ROWS as $i => $row) {
                $NEWS_ROWS[$i]['nice_title'] = get_translated_text($row['title']);
            }
        }
    }
}

function load_download_rows()
{
    global $DOWNLOAD_ROWS;
    if (!isset($DOWNLOAD_ROWS)) {
        if (get_param_integer('test_mode', 0) == 1) { // Test data
            $DOWNLOAD_ROWS = array(
                array('id' => 20, 'nice_title' => 'Composr Version 3', 'add_date' => time() - 60 * 60 * 8, 'nice_description' => '[Test message] This is 3. Yo peeps. 3.1 is the biz.'),
                array('id' => 30, 'nice_title' => 'Composr Version 3.1', 'add_date' => time() - 60 * 60 * 5, 'nice_description' => '[Test message] This is 3.1.1. 3.1.1 is out dudes.'),
                array('id' => 35, 'nice_title' => 'Composr Version 3.1.1', 'add_date' => time() - 60 * 60 * 5, 'nice_description' => '[Test message] This is 3.1.1. 3.2 is out dudes.'),
                array('id' => 40, 'nice_title' => 'Composr Version 3.2 beta1', 'add_date' => time() - 60 * 60 * 4, 'nice_description' => '[Test message] This is 3.2 beta1. 3.2 beta2 is out.'),
                array('id' => 50, 'nice_title' => 'Composr Version 3.2', 'add_date' => time() - 60 * 60 * 3, 'nice_description' => '[Test message] This is 3.2. 4 is out.'),
                array('id' => 60, 'nice_title' => 'Composr Version 4', 'add_date' => time() - 60 * 60 * 1, 'nice_description' => '[Test message] This is the 4 and you can find bug reports somewhere.'),
            );
        } else {
            $sql = 'SELECT d.* FROM ' . get_table_prefix() . 'download_downloads d FORCE INDEX (recent_downloads) WHERE validated=1 AND ' . $GLOBALS['SITE_DB']->translate_field_ref('name') . ' LIKE \'' . db_encode_like('Composr Version %') . '\' ORDER BY add_date';
            $DOWNLOAD_ROWS = $GLOBALS['SITE_DB']->query($sql, null, null, false, false, array('name' => 'SHORT_TRANS', 'description' => 'LONG_TRANS__COMCODE'));
            foreach ($DOWNLOAD_ROWS as $i => $row) {
                $DOWNLOAD_ROWS[$i]['nice_title'] = get_translated_text($row['name']);
                $DOWNLOAD_ROWS[$i]['nice_description'] = get_translated_text($row['description']);
            }
        }
    }
}

// ===========================
//		OLD SIMPLE STYLE
// ===========================

function old_style()
{
    require_code('version2');
    $dotted = get_version_dotted__from_anything(get_param_string('version'));
    $version_pretty = get_version_pretty__from_dotted($dotted);

    $rows = $GLOBALS['SITE_DB']->query_select_value_if_there('download_downloads', array('*'), array('validated' => 1, $GLOBALS['SITE_DB']->translate_field_ref('name') => 'Composr Version ' . $version_pretty));

    if (!array_key_exists(0, $rows)) {
        echo do_lang('CMS_NON_EXISTANT_VERSION');
    } else {
        $description = get_translated_tempcode('download_downloads', $rows[0], 'description');
        echo $description->evaluate();
    }
}

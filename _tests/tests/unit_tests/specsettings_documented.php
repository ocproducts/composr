<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/**
 * Composr test case class (unit testing).
 */
class specsettings_documented_test_set extends cms_test_case
{
    public function setUp()
    {
        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(0);
        }

        require_code('files2');

        parent::setUp();
    }

    public function testSymbols()
    {
        $symbols_file = file_get_contents(get_file_base() . '/sources/symbols.php');
        $directives_start_pos = strpos($symbols_file, 'if ($type == TC_DIRECTIVE)');

        $tempcode_tutorial = file_get_contents(get_file_base() . '/docs/pages/comcode_custom/EN/tut_tempcode.txt');

        $matches = array();
        $num_matches = preg_match_all('#^\t\t\tcase \'(\w+)\':#m', $symbols_file, $matches);
        for ($i = 0; $i < $num_matches; $i++) {
            if ((strpos($symbols_file, $matches[0][$i]) < $directives_start_pos) && (strpos($symbols_file, $matches[0][$i] . ' // LEGACY') === false)) {
                $symbol = $matches[1][$i];
                $this->assertTrue(strpos($tempcode_tutorial, '{$' . $symbol) !== false, 'Missing documented symbol, {$' . $symbol . '}');
            }
        }
    }

    public function testConfigSettings()
    {
        $config_editor_code = file_get_contents(get_file_base() . '/config_editor.php');

        $found = array();

        $files = get_directory_contents(get_file_base());
        foreach ($files as $f) {
            if ((substr($f, -4) == '.php') && (basename($f) != 'shared_installs.php') && (strpos($f, '_tests') === false) && (strpos($f, '_custom') === false) && (strpos($f, 'sources/forum/') === false) && (strpos($f, 'exports/') === false) && ($f != '_config.php') && (basename($f) != 'errorlog.php') && (basename($f) != 'phpstub.php') && (basename($f) != 'permissioncheckslog.php')) {
                $c = file_get_contents(get_file_base() . '/' . $f);
                $matches = array();
                $num_matches = preg_match_all('#(\$SITE_INFO|\$GLOBALS\[\'SITE_INFO\'\])\[\'([^\'"]+)\'\]#', $c, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $var = $matches[2][$i];
                    if (
                        (/*Can't just flip so simply*/$var != 'multi_lang_content') &&
                        (/*string replace array*/$var != 'reps') &&
                        (/*AFM*/strpos($var, 'ftp_') === false) &&
                        (/*demonstratr*/strpos($var, 'throttle_') === false) &&
                        (/*demonstratr*/strpos($var, 'custom_') === false) &&
                        (/*Demonstratr*/$var != 'mysql_demonstratr_password') &&
                        (/*Demonstratr*/$var != 'mysql_root_password') &&
                        (/*Custom domains*/strpos($var, 'ZONE_MAPPING') === false) &&
                        (/*Legacy password name*/$var != 'admin_password') &&
                        (/*XML dev environment*/strpos($var, '_chain') === false)
                    ) {
                        $found[$var] = 1;
                    }
                }
            }
        }

        $found = array_keys($found);
        sort($found);

        foreach ($found as $var) {
            $this->assertTrue(strpos($config_editor_code, '\'' . $var . '\' => \'') !== false, 'Missing config_editor UI for ' . $var);
        }
    }

    public function testValueOptions()
    {
        $codebook_text = file_get_contents(get_file_base() . '/docs/pages/comcode_custom/EN/codebook_3.txt');

        $found = array();

        $files = get_directory_contents(get_file_base());
        foreach ($files as $f) {
            if ((substr($f, -4) == '.php') && (basename($f) != 'upgrade.php') && (basename($f) != 'shared_installs.php') && (strpos($f, '_tests') === false) && (strpos($f, '_custom') === false) && (strpos($f, 'sources/forum/') === false) && (strpos($f, 'exports/') === false) && (basename($f) != 'errorlog.php') && (basename($f) != 'phpstub.php') && (basename($f) != 'permissioncheckslog.php')) {
                $c = file_get_contents(get_file_base() . '/' . $f);
                $matches = array();
                $num_matches = preg_match_all('#get\_value\(\'([^\']+)\'\)#', $c, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $var = $matches[1][$i];
                    if ((!file_exists(get_file_base() . '/sources/hooks/systems/disposable_values/' . $var . '.php')) && ($var != 'user_peak') && ($var != 'user_peak_week') && (substr($var, 0, 5) != 'last_') && (substr($var, 0, 4) != 'ftp_') && ($var != 'uses_ftp') && ($var != 'commandr_watched_chatroom') && (substr($var, 0, 8) != 'delurk__') && (substr($var, 0, 7) != 'backup_') && ($var != 'version') && ($var != 'cns_version') && ($var != 'newsletter_whatsnew') && ($var != 'newsletter_send_time') && ($var != 'site_salt') && ($var != 'sitemap_building_in_progress') && ($var != 'setupwizard_completed') && ($var != 'site_bestmember') && ($var != 'oracle_index_cleanup_last_time') && ($var != 'timezone') && ($var != 'users_online') && ($var != 'ran_once')) {// Quite a few are set in code
                        $found[$var] = 1;
                    }
                }
            }
        }

        $found = array_keys($found);
        sort($found);

        foreach ($found as $var) {
            $this->assertTrue(strpos($codebook_text, '[tt]' . $var . '[/tt]') !== false, 'Missing Code Book listing for hidden value, ' . $var);
        }
    }

    public function testKeepSettings()
    {
        $codebook_text = file_get_contents(get_file_base() . '/docs/pages/comcode_custom/EN/codebook_3.txt');

        $found = array();

        $files = get_directory_contents(get_file_base());
        foreach ($files as $f) {
            if ((substr($f, -4) == '.php') && (basename($f) != 'shared_installs.php') && (strpos($f, '_tests') === false) && (strpos($f, '_custom') === false) && (strpos($f, 'sources/forum/') === false) && (basename($f) != 'errorlog.php') && (basename($f) != 'phpstub.php') && (basename($f) != 'permissioncheckslog.php')) {
                $c = file_get_contents($f);
                $matches = array();
                $num_matches = preg_match_all('#get\_param(\_integer)?\(\'(keep_[^\']+)\'[,\)]#', $c, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $var = $matches[2][$i];
                    $found[$var] = 1;
                }
            }
        }

        $found = array_keys($found);
        sort($found);

        foreach ($found as $var) {
            $this->assertTrue(strpos($codebook_text, '[tt]' . $var . '[/tt]') !== false, 'Missing Code Book listing for keep setting, ' . $var);
        }
    }
}

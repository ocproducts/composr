<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

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
class lang_test_set extends cms_test_case
{
    public function setUp()
    {
        require_code('lang_compile');

        parent::setUp();
    }

    public function testLangMistakes()
    {
        $verbose = false;

        $dh = opendir(get_file_base() . '/lang/EN/');
        while (($file = readdir($dh)) !== false) {
            if (substr($file, -4) != '.ini') {
                continue;
            }
            if ($file[0] == '.') {
                continue;
            }

            $input = array();
            _get_lang_file_map(get_file_base() . '/lang/EN/' . $file, $input, null, false);

            foreach ($input as $key => $string) {
                $this->check($file, $key, $string, $verbose);
            }
        }
        closedir($dh);

        $path = get_file_base() . '/docs/pages/comcode_custom/EN/';
        $dh = opendir($path);
        while (($file = readdir($dh)) !== false) {
            if (substr($file, -4) != '.txt') {
                continue;
            }
            if ($file[0] == '.') {
                continue;
            }

            $this->check($file, null, file_get_contents($path . $file), $verbose);
        }
        closedir($dh);
    }

    private function check($file, $key, $string, $verbose)
    {
        $string = preg_replace('#https?://[^ ]*#', '', $string);
        $string = preg_replace('#\{\$[^\{\}]*\}#', '', $string);
        $string = preg_replace('#\[code.*\[/code\]#s', '', $string);
        $string = preg_replace('#\[codebox.*\[/codebox\]#s', '', $string);

        $matches = array();

        // Support debranding
        if (!is_null($key)) {
            if (strpos($string, 'Composr') !== false && $key != 'NO_PHP_IN_TEMPLATES' && $key != 'WHAT_TO_EXPECT' && $key != 'DESCRIPTION_INCLUDE_CMS_ADVERT' && $key != 'INCLUDE_CMS_ADVERT' && $key != 'UNINSTALL_WARNING' && $key != 'SOFTWARE_CHAT_EXTRA' && (strpos($key, 'SETUPWIZARD') === false) && $key != 'CANNOT_CONNECT_HOME' && $key != 'NO_GD_ON_SERVER' && $key != 'MYSQL_TOO_OLD' && $key != 'LOW_MEMORY_LIMIT' && $key != 'NO_ZIP_ON_SERVER' && $key != 'CONFIG_OPTION_network_links' && $key != 'WARNING_MBSTRING_FUNC_OVERLOAD' && $key != 'DISABLED_FUNCTION' && $file != 'lang.ini' && $file != 'version.ini' && $file != 'debrand.ini' && $file != 'import.ini' && $file != 'installer.ini' && $file != 'upgrade.ini' && $file != 'commandr.ini' && $file != 'addons.ini') {
                $this->assertTrue(false, 'The word \'Composr\' was used in ' . $file . ' (' . $key . '). This should probably be changed to \'the software\'.');
            }
        }

        // Hyphen wanted (we want our canonical way)
        if ((stripos($string, 'email') !== false) && (stripos($string, '/') === false) && (stripos($string, 'codename') === false)) {
            $this->assertTrue(false, 'The term \'email\' was used in ' . $file . '. This should be changed to \'e-mail\'.');
        }
        if (stripos($string, 'comma separated') !== false) {
            $this->assertTrue(false, 'The phrase \'comma separated\' was used in ' . $file . '. This should be changed to \'comma-separated\'.');
        }
        if ((preg_match('#[^e]built in[^t]#', $string) != 0) && (strpos($string, 'in a ') === false)) {
            $this->assertTrue(false, 'The phrase \'built in\' was used in ' . $file . '. This should be changed to \'built-in\'.');
        }

        // No hyphen wanted (we want our canonical way)
        if (stripos($string, 'add-on') !== false) {
            $this->assertTrue(false, 'The word \'add-on\' was used in ' . $file . '. This should be changed to \'addon\'.');
        }
        if (stripos($string, 'user-group') !== false) {
            $this->assertTrue(false, 'The term \'user-group\' was used in ' . $file . '. This should be changed to \'usergroup\'.');
        }
        if (stripos($string, 'set-up') !== false) {
            $this->assertTrue(false, 'The phrase \'set-up\' was used in ' . $file . '. This might need to be changed to \'setup\', depending on the usage.');
        }

        // No space wanted (we want our canonical way)
        if (stripos($string, 'chat room') !== false) {
            $this->assertTrue(false, 'The phrase \'chat room\' was used in ' . $file . '. This should be changed to \'chatroom\'.');
        }
        if ((stripos($string, 'user name') !== false) && (stripos($string, 'user named') === false)) {
            $this->assertTrue(false, 'The term \'user name\' was used in ' . $file . '. This should be changed to \'username\'.');
        }
        if (stripos($string, 'web site') !== false) {
            $this->assertTrue(false, 'The phrase \'web site\' was used in ' . $file . '. This should be changed to \'website\'.');
        }

        // Wrong way of writing proper noun (we want our canonical way)
        if ((stripos($string, 'unvalidated') !== false) && ($file !== 'tut_addon_index.txt')) {
            $this->assertTrue(false, 'The word \'unvalidated\' was used in ' . $file . '. This should be changed to \'non-validated\'.');
        }
        if (preg_match('#([^\]/A-Za-z"\_<]+)comcode([^A-Za-z"]+)#', $string) != 0) {
            $this->assertTrue(false, 'The term \'comcode\' was used in ' . $file . '. This should be changed to \'Comcode\'.');
        }
        if (!is_null($key)) {
            if (stripos($string, 'supermember') !== false) {
                $this->assertTrue(false, 'The term \'supermember\' was used in ' . $file . '. This should be changed to \'super-member\'.');
            }
        }
        if (preg_match('#([^A-Za-z]+)Javascript([^A-Za-z]+)#', $string) != 0) {
            $this->assertTrue(false, 'The word \'Javascript\' was used in ' . $file . '. This should be changed to \'JavaScript\'.');
        }
        if (preg_match('#([^/\.A-Za-z]+)tar([^A-Za-z]+)#', $string) != 0) {
            $this->assertTrue(false, 'The filetype \'tar\' was used in ' . $file . '. This should be changed to \'TAR\'.');
        }
        if (preg_match('#([^/\_\-\.A-Za-z]+)zip([^A-Za-z]+)#', $string) != 0) {
            $this->assertTrue(false, 'The filetype \'zip\' was used in ' . $file . '. This should be changed to \'ZIP\'.');
        }

        // Old-fashioned words
        if (stripos($string, 'amongst') !== false) {
            $this->assertTrue(false, 'The word \'amongst\' was used in ' . $file . '. This should be changed to \'among\'.');
        }
        if (stripos($string, 'whilst') !== false) {
            $this->assertTrue(false, 'The word \'whilst\' was used in ' . $file . '. This should be changed to \'while\'.');
        }

        // Common spelling errors
        $common_spelling_mistakes = array(
            'cacheing' => 'caching',
            'publically' => 'publicly',
            'seperate' => 'separate',
            'adhoc' => 'ad hoc',
            'yness' => 'iness',
            'overidden' => 'overridden',
            'nieve' => 'naive',
            'in-situe' => 'in-situ',
            'infact' => 'in fact',
            'conveniant' => 'convenient',
            'conveniance' => 'convenience',
            'routeable' => 'routable',
            'supercede' => 'supersede',
            'targetted' => 'targeted',
            'targetting' => 'targeting',
            'fulfills' => 'fulfils',
            'progmatically' => 'programatically',
            'persistant' => 'persistent',
        );
        foreach ($common_spelling_mistakes as $from => $to) {
            if (stripos($string, $from) !== false) {
                $this->assertTrue(false, $from . ' should be ' . $to . ' in ' . $file . '.');
            }
        }

        // Common grammar errors
        if ((stripos($string, 'URL\'s') !== false) && ($file != 'tut_importer.txt')) {
            $this->assertTrue(false, 'The acronym \'URL\'s\' was used in ' . $file . '. This should be changed to \'URLs\'.');
        }
        if (stripos($string, 'ID\'s') !== false) {
            $this->assertTrue(false, 'The term \'ID\'s\' was used in ' . $file . '. This should be changed to \'IDs\'.');
        }
        if (preg_match('#([^A-Za-z]>+)id([^A-Za-z=<]+)#', $string) != 0) {
            $this->assertTrue(false, 'The acronym \'id\' was used in ' . $file . '. This should be changed to \'ID\'.');
        }
        if (preg_match('#([^\$:\_A-Za-z\[\]></\']+)url([^\}A-Za-z=\']+)#', $string, $matches) != 0) {
            $this->assertTrue(false, 'The acronym \'url\' was used in ' . $file . '. (prefix is ' . $matches[1] . ') This should be changed to \'URL\'.');
        }
        if (stripos($string, 'thankyou') !== false) {
            $this->assertTrue(false, 'The word \'thankyou\' was used in ' . $file . '. This should be changed to \'thank you\'.');
        }


        // Extra checks that give lots of false-positives
        if ($verbose) {
            if (stripos($string, 'user') !== false) {
                $this->assertTrue(false, 'The term \'user\' was used in ' . $file . '. This might need to be changed to \'member\', depending on the circumstances.');
            }

            if (preg_match('#([A-Za-z]+)s( |-)#', $string) != 0) {
                $this->assertTrue(false, 'A word in ' . $file . ' ended with an \'s\', but did not contain an apostrophe. This might be a case of mistaken plurality.');
            }

            if (preg_match('#([A-Za-z]+)\'s#', $string) != 0) {
                $this->assertTrue(false, 'A word in ' . $file . ' has an apostrophe, confirm it is intended..');
            }

            if (preg_match('#([a-z]+)( |-)([A-Z]{1})([a-z]+)#', $string) != 0) {
                $this->assertTrue(false, 'A word in ' . $file . ' that was in the middle of the string started with a capital letter. This might be a badly capitalised string.');
            }

            //if (stripos($string,'center')!==false) $this->assertTrue(false,'The word \'center\' was used in '.$file.'. This should be changed to \'centre\'.');
        }
    }

    public function tearDown()
    {
        parent::tearDown();
    }
}

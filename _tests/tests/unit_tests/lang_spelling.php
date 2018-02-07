<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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
class lang_spelling_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        require_code('lang_compile');
    }

    public function testLangMistakes()
    {
        $verbose = (get_param_integer('verbose', 0) == 1);

        $dh = opendir(get_file_base() . '/lang/EN/');
        while (($file = readdir($dh)) !== false) {
            if (substr($file, -4) != '.ini') {
                continue;
            }
            if ($file[0] == '.') {
                continue;
            }

            $input = array();
            _get_lang_file_map(get_file_base() . '/lang/EN/' . $file, $input, 'strings', false, false, 'EN');

            foreach ($input as $key => $string) {
                $this->check($file, $key, $string, $verbose);
            }
        }
        closedir($dh);

        $dirs = array(
            'text',
            'text/EN',
            'pages/comcode/EN',
            'site/pages/comcode/EN',
            'docs/pages/comcode_custom/EN',
        );
        if ((function_exists('git_repos')) && (git_repos() == 'composr_homesite')) {
            $dirs = array_merge($dirs, array(
                'text_custom',
                'text_custom/EN',
                'pages/comcode_custom/EN',
                'site/pages/comcode_custom/EN',
            ));
        }
        foreach ($dirs as $dir) {
            $path = get_file_base() . '/' . $dir;
            $dh = opendir($path);
            while (($file = readdir($dh)) !== false) {
                if (substr($file, -4) != '.txt') {
                    continue;
                }
                if ($file[0] == '.') {
                    continue;
                }
                if ($file == 'synonyms.txt') {
                    continue;
                }

                $this->check($file, null, file_get_contents($path . '/' . $file), $verbose);
            }
            closedir($dh);
        }

        $files = array(
            'uploads/website_specific/compo.sr/errorservice.csv',
        );
        foreach ($files as $file) {
            $path = get_file_base() . '/';
            $this->check($file, null, file_get_contents($path . '/' . $file), $verbose);
        }
    }

    private function check($file, $key, $string, $verbose)
    {
        $string = preg_replace('#https?://[^ ]*#', '', $string);
        $string = preg_replace('#\{\$[^\{\}]*\}#', '', $string);
        $string = preg_replace('#\[code.*\[/code\]#s', '', $string);
        $string = preg_replace('#\[codebox.*\[/codebox\]#s', '', $string);
        $string = preg_replace('#\[tt.*\[/tt\]#s', '', $string);

        $matches = array();

        // Support debranding
        if ($key !== null) {
            if (
                (strpos($string, 'Composr') !== false) &&
                $key != 'NO_PHP_IN_TEMPLATES' &&
                $key != 'FORUM_BASE_URL_INVALID' &&
                $key != 'WHAT_TO_EXPECT' &&
                $key != 'DESCRIPTION_INCLUDE_CMS_ADVERT' &&
                $key != 'INCLUDE_CMS_ADVERT' &&
                $key != 'UNINSTALL_WARNING' &&
                $key != 'SOFTWARE_CHAT_EXTRA' &&
                $key != 'CONFIG_CATEGORY_COMPOSR_APIS' &&
                $key != 'CONFIG_CATEGORY_DESCRIPTION__COMPOSR_APIS' &&
                (strpos($key, 'SETUPWIZARD') === false) &&
                $key != 'CANNOT_CONNECT_HOME' &&
                $key != 'NO_GD_ON_SERVER' &&
                $key != 'MYSQL_TOO_OLD' &&
                $key != 'LOW_MEMORY_LIMIT' &&
                $key != 'NO_ZIP_ON_SERVER' &&
                $key != 'CONFIG_OPTION_network_links' &&
                $key != 'WARNING_MBSTRING_FUNC_OVERLOAD' &&
                $key != 'DISABLED_FUNCTION' &&
                $file != 'lang.ini' &&
                $file != 'version.ini' &&
                $file != 'debrand.ini' &&
                $file != 'import.ini' &&
                $file != 'installer.ini' &&
                $file != 'upgrade.ini' &&
                $file != 'commandr.ini' &&
                $file != 'addons.ini'
            ) {
                $this->assertTrue(false, 'The word \'Composr\' was used in ' . $file . ' (' . $key . '). This should probably be changed to \'the software\'.');
            }
        }

        // Bad use of it's. Imperfect test, but would rather have it anyway due to the prevalence of these mistakes. People can expand contractions to workaround.
        if (preg_match('#it\'s (own|permission|id |definition|filename|contents|run|database|parent|child|cach|interface|use |various|result|properties)#', $string) != 0) {
            $this->assertTrue(false, 'The phrase "it\'s own" was used in ' . $file . '. This should be changed to "its own". There could be more infractions that we could not auto-detect.');
        }

        // Hyphen wanted (we want our canonical way)
        if ((preg_match('#([^\[\]\|"\'/_])email#', $string, $matches) != 0) && (($key === null) || (stripos($string, '/') === false) && (stripos($string, 'codename') === false)) && (stripos($string, 'Automatic code inserts after this') === false) && (basename($file) != 'tut_facebook.txt')) {
            $prefix = $matches[1];
            $this->assertTrue(false, 'The term \'email\' was used in ' . $file . '. (prefix is ' . $prefix . ') This should be changed to \'e-mail\'.');
        }
        if (stripos($string, 'comma separated') !== false) {
            $this->assertTrue(false, 'The phrase \'comma separated\' was used in ' . $file . '. This should be changed to \'comma-separated\'.');
        }
        if (stripos($string, 'front end') !== false) {
            $this->assertTrue(false, 'The phrase \'front end\' was used in ' . $file . '. This should be changed to \'front-end\'.');
        }
        if (stripos($string, 'back end') !== false) {
            $this->assertTrue(false, 'The phrase \'back end\' was used in ' . $file . '. This should be changed to \'back-end\'.');
        }
        if (stripos($string, 'meta tree') !== false) {
            $this->assertTrue(false, 'The phrase \'meta tree\' was used in ' . $file . '. This should be changed to \'meta-tree\'.');
        }
        if ((stripos($string, 'screen reader') !== false) || (stripos($string, 'screenreader') !== false)) {
            $this->assertTrue(false, 'The phrase \'screen reader\' was used in ' . $file . '. This should be changed to \'screen-reader\'.');
        }
        if (preg_match('#([^\[\]<>\|"\'/_])popup#', $string, $matches) != 0) {
            $this->assertTrue(false, 'The phrase \'popup\' was used in ' . $file . '. This should be changed to \'pop-up\'.');
        }
        if ((preg_match('#[^e]built in[^t]#', $string) != 0) && (strpos($string, 'in a ') === false)) {
            $this->assertTrue(false, 'The phrase \'built in\' was used in ' . $file . '. This should be changed to \'built-in\'.');
        }

        // No hyphen wanted (we want our canonical way)
        if ((stripos($string, 'set-up') !== false) && (($key === null) || (!in_array($key, array('CONFIG_OPTION_taxcloud_api_key', 'CONFIG_OPTION_taxcloud_api_id'))))) {
            $this->assertTrue(false, 'The phrase \'set-up\' was used in ' . $file . '. This might need to be changed to \'setup\', depending on the usage.');
        }
        if (stripos($string, 'add-on') !== false) {
            $this->assertTrue(false, 'The word \'add-on\' was used in ' . $file . '. This should be changed to \'addon\'.');
        }
        if (stripos($string, 'safe-mode') !== false) {
            $this->assertTrue(false, 'The word \'safe-mode\' was used in ' . $file . '. This should be changed to \'safe mode\'.');
        }
        if (stripos($string, 'base-URL') !== false) {
            $this->assertTrue(false, 'The word \'base-URL\' was used in ' . $file . '. This should be changed to \'base URL\'.');
        }

        // Space wanted
        if (stripos($string, 'de-facto') !== false) {
            $this->assertTrue(false, 'The word \'de-facto\' was used in ' . $file . '. This should be changed to \'de facto\'.');
        }
        if (stripos($string, 'defacto') !== false) {
            $this->assertTrue(false, 'The word \'defacto\' was used in ' . $file . '. This should be changed to \'de facto\'.');
        }
        if ($key !== 'WARNING_DB_OVERWRITE') {
            if (stripos($string, 'upper-case') !== false) {
                $this->assertTrue(false, 'The word \'upper-case\' was used in ' . $file . '. This should be changed to \'upper case\'.');
            }
            if (stripos($string, 'lower-case') !== false) {
                $this->assertTrue(false, 'The word \'lower-case\' was used in ' . $file . '. This should be changed to \'lower case\'.');
            }
            if (stripos($string, 'uppercase') !== false) {
                $this->assertTrue(false, 'The word \'uppercase\' was used in ' . $file . '. This should be changed to \'upper case\'.');
            }
            if (stripos($string, 'lowercase') !== false) {
                $this->assertTrue(false, 'The word \'lowercase\' was used in ' . $file . '. This should be changed to \'lower case\'.');
            }
        }
        if (stripos($string, 'PHP info') !== false) {
            $this->assertTrue(false, 'The word \'PHP info\' was used in ' . $file . '. This should be changed to \'PHP-Info\'.');
        }

        // No space or hyphen wanted (we want our canonical way)
        if (stripos($string, 'user[ -]group') !== false) {
            $this->assertTrue(false, 'The term \'user-group\' was used in ' . $file . '. This should be changed to \'usergroup\'.');
        }
        if (preg_match('#chat[ -]room#i', $string) != 0) {
            $this->assertTrue(false, 'The phrase \'chat room\' or \'chat-room\' was used in ' . $file . '. This should be changed to \'chatroom\'.');
        }
        if (preg_match('#user[ -]name[^d]#i', $string) != 0) {
            $this->assertTrue(false, 'The term \'user name\' was used in ' . $file . '. This should be changed to \'username\'.');
        }
        if (preg_match('#web[ -]site#i', $string) != 0) {
            $this->assertTrue(false, 'The phrase \'web site\' or \'web-site\' was used in ' . $file . '. This should be changed to \'website\'.');
        }
        if (preg_match('#web[ -]host#i', $string) != 0) {
            $this->assertTrue(false, 'The phrase \'web host\' or \'web-host\' was used in ' . $file . '. This should be changed to \'webhost\'.');
        }
        if (preg_match('#meta[ -]data([^A-Za-z"]+)#i', $string) != 0) {
            $this->assertTrue(false, 'The phrase \'meta data\' or \'meta-data\' was used in ' . $file . '. This should be changed to \'metadata\'.');
        }
        if (stripos($string, 'PHP info') !== false) {
            $this->assertTrue(false, 'The word \'PHP info\' was used in ' . $file . '. This should be changed to \'PHP-Info\'.');
        }

        // Wrong way of writing proper noun (we want our canonical way)
        if ((stripos($string, 'unvalidated') !== false) && ($file !== 'tut_addon_index.txt') && ($file !== 'sup_set_up_a_workflow_in_composr.txt')) {
            $this->assertTrue(false, 'The word \'unvalidated\' was used in ' . $file . '. This should be changed to \'non-validated\'.');
        }
        if (preg_match('#([^\]/A-Za-z"_<\']+)comcode([^A-Za-z"\']+)#', $string) != 0) {
            $this->assertTrue(false, 'The term \'comcode\' was used in ' . $file . '. This should be changed to \'Comcode\'.');
        }
        if (strpos($string, 'wiki+') !== false) {
            $this->assertTrue(false, 'The term \'wiki+\' was used in ' . $file . '. This should be changed to \'Wiki+\'.');
        }
        if (preg_match('#([^A-Za-z]+)(PHP-Doc|phpdoc|phpDoc)([^A-Za-z]+)#', $string) != 0) {
            $this->assertTrue(false, 'A misspelling of \'PHPDoc\' occurred in ' . $file . '.');
        }
        if (preg_match('#([^A-Za-z]+)(PHP-Storm|phpStorm)([^A-Za-z]+)#', $string) != 0) {
            $this->assertTrue(false, 'A misspelling of \'PhpStorm\' occurred in ' . $file . '.');
        }
        if (preg_match('#([^A-Za-z]+)CloudFlare([^A-Za-z]+)#', $string) != 0) {
            $this->assertTrue(false, 'The word \'CloudFlare\' was used in ' . $file . '. This should be changed to \'Cloudflare\'.');
        }
        if (preg_match('#([^A-Za-z]+)Javascript([^A-Za-z]+)#', $string) != 0) {
            $this->assertTrue(false, 'The word \'Javascript\' was used in ' . $file . '. This should be changed to \'JavaScript\'.');
        }
        if (preg_match('#([^A-Za-z]+)mySQL([^A-Za-z]+)#', $string) != 0) {
            $this->assertTrue(false, 'The word \'mySQL\' was used in ' . $file . '. This should be changed to \'MySQL\'.');
        }
        if (preg_match('#([^/\.A-Za-z>]+)tar([^A-Za-z]+)#', $string) != 0) {
            $this->assertTrue(false, 'The filetype \'tar\' was used in ' . $file . '. This should be changed to \'TAR\'.');
        }
        if ((preg_match('#([^/_\-\.A-Za-z]+)zip([^A-Za-z]+)#', $string) != 0) && (($key === null) || (!in_array($key, array('ZIP_NEEDED_FOR_USA', 'INVALID_ZIP_FOR_USA', 'CONFIG_OPTION_business_post_code'))))) {
            $this->assertTrue(false, 'The filetype \'zip\' was used in ' . $file . '. This should be changed to \'ZIP\'.');
        }
        if (preg_match('#([^\]/A-Za-z"_<]+)internet#', $string) != 0) {
            $this->assertTrue(false, 'The term \'internet\' was used in ' . $file . '. This should be changed to \'Internet\'.');
        }
        if (stripos($string, 'e-commerce') !== false) {
            $this->assertTrue(false, 'The phrase \'e-commerce\' was used in ' . $file . '. This should be changed to \'eCommerce\'.');
        }
        if (stripos($string, 'CommandrFS') !== false) {
            $this->assertTrue(false, 'The phrase \'CommandrFS\' was used in ' . $file . '. This should be changed to \'Commandr-fs\'.');
        }
        if (strpos($string, 'Commandr-FS') !== false) {
            $this->assertTrue(false, 'The phrase \'Commandr-FS\' was used in ' . $file . '. This should be changed to \'Commandr-fs\'.');
        }
        if (stripos($string, 'ResourceFS') !== false) {
            $this->assertTrue(false, 'The phrase \'ResourceFS\' was used in ' . $file . '. This should be changed to \'Resource-fs\'.');
        }
        if (strpos($string, 'Resource-FS') !== false) {
            $this->assertTrue(false, 'The phrase \'Resource-FS\' was used in ' . $file . '. This should be changed to \'Resource-fs\'.');
        }
        if (strpos($string, 'OpenGraph') !== false) {
            $this->assertTrue(false, 'The phrase \'OpenGraph\' was used in ' . $file . '. This should be changed to \'Open Graph\'.');
        }
        if (strpos($string, 'ReCAPTCHA') !== false) {
            $this->assertTrue(false, 'The phrase \'ReCAPTCHA\' was used in ' . $file . '. This should be changed to \'reCAPTCHA\'.');
        }
        if (strpos($string, 'RECAPTCHA') !== false) {
            $this->assertTrue(false, 'The phrase \'RECAPTCHA\' was used in ' . $file . '. This should be changed to \'reCAPTCHA\'.');
        }
        // page-link, but we can't test for that because "page link" is a valid phrase too

        // Our canonical way of writing "Open Source"
        if (strpos($string, 'open source') !== false) {
            $this->assertTrue(false, 'The phrase \'open source\' was used in ' . $file . '. This should be changed to \'Open Source\'.');
        }
        if (stripos($string, 'open-source') !== false) {
            $this->assertTrue(false, 'The phrase \'open-source\' was used in ' . $file . '. This should be changed to \'Open Source\'.');
        }
        if (strpos($string, 'Open source') !== false) {
            $this->assertTrue(false, 'The phrase \'Open source\' was used in ' . $file . '. This should be changed to \'Open Source\'.');
        }

        // Bad use of acronyms
        if (stripos($string, 'CMS system') !== false) {
            $this->assertTrue(false, 'The phrase \'CMS system\' was used in ' . $file . '. That would expand to Content Management System System. The plural of CMS is CMSs.');
        }

        // Bad way of writing PHP versions etc
        if (stripos($string, 'PHP5.') !== false || stripos($string, 'PHP7.') !== false) {
            $this->assertTrue(false, 'PHP version written missing a space in ' . $file . '.');
        }
        if (stripos($string, 'end of life') !== false) {
            $this->assertTrue(false, 'Use dashes for end-of-life, ' . $file . '.');
        }

        // Cron
        if (preg_match('#(^|[^\w])(cron|CRON)([^\w]|$)#', $string) != 0) {
            $this->assertTrue(false, 'The word \'Cron\' was misspelled in ' . $file . '.');
        }

        // Old-fashioned words
        if (stripos($string, 'amongst') !== false) {
            $this->assertTrue(false, 'The word \'amongst\' was used in ' . $file . '. This should be changed to \'among\'.');
        }
        if (stripos($string, 'whilst') !== false) {
            $this->assertTrue(false, 'The word \'whilst\' was used in ' . $file . '. This should be changed to \'while\'.');
        }

        // Weird British english
        if (preg_match('#[^s]tick [^\(]#', $string) != 0) {
            $this->assertTrue(false, 'The word tick was used in ' . $file . ' without being followed by check in brackets in the conventional way.');
        }

        // Common spelling errors
        $common_spelling_mistakes = array(
            'cacheing' => 'caching',
            'publically' => 'publicly',
            'seperate' => 'separate',
            'adhoc' => 'ad hoc',
            'yness' => 'iness',
            'overidden' => 'overridden',
            'overide' => 'override',
            'nieve' => 'naive',
            'in-situe' => 'in-situ',
            'infact' => 'in fact',
            'in-fact' => 'in fact',
            'conveniant' => 'convenient',
            'conveniance' => 'convenience',
            'routeable' => 'routable',
            'supercede' => 'supersede',
            'targetted' => 'targeted',
            'targetting' => 'targeting',
            'fulfills' => 'fulfils',
            'progmatically' => 'programatically',
            'persistant' => 'persistent',
            'recieve'=> 'receive',
            'eratic' => 'erratic',
            'psuedo' => 'pseudo',
        );
        if (strpos($file, 'calendar') !== false) {
            $common_spelling_mistakes['occurrence'] = 'recurrence';
        }
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
        if (preg_match('#([^\$:_A-Za-z\[\]></\']+)url([^\}\(A-Za-z=\']+)#', $string, $matches) != 0) {
            $prefix = $matches[1];
            if ($prefix != '="') {
                $this->assertTrue(false, 'The acronym \'url\' was used in ' . $file . '. (prefix is ' . $prefix . ') This should be changed to \'URL\'.');
            }
        }
        if (preg_match('#([^\]/A-Za-z"_<]+)thankyou#i', $string) != 0) {
            $this->assertTrue(false, 'The word \'thankyou\' was used in ' . $file . '. This should be changed to \'thank you\'.');
        }


        // Extra checks that give lots of false-positives
        if ($verbose) {
            foreach (array('user' => 'member', 'color' => 'colour', 'license' => 'licence', 'center' => 'centre') as $from => $to) {
                if (stripos($string, $from) !== false) {
                    $this->assertTrue(false, 'The term \'' . $from . '\' was used in ' . $file . '. This might need to be changed to \'' . $to . '\', depending on the circumstances.');
                }
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

            //if (stripos($string, 'center') !== false) $this->assertTrue(false, 'The word \'center\' was used in ' . $file . '. This should be changed to \'centre\'.');
        }
    }
}

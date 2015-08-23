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
                if (stripos($string, 'thankyou') !== false) {
                    $this->assertTrue(false, 'The word \'thankyou\' was used in ' . $file . '. This should be changed to \'thank you\'.');
                }
                if (stripos($string, 'unvalidated') !== false) {
                    $this->assertTrue(false, 'The word \'unvalidated\' was used in ' . $file . '. This should be changed to \'non-validated\'.');
                }
                if (stripos($string, 'add-on') !== false) {
                    $this->assertTrue(false, 'The word \'add-on\' was used in ' . $file . '. This should be changed to \'addon\'.');
                }
                if (stripos($string, 'preceeding') !== false) {
                    $this->assertTrue(false, 'The word \'preceeding\' was used in ' . $file . '. This should be changed to \'proceeding\'.');
                }
                if (stripos($string, 'cacheing') !== false) {
                    $this->assertTrue(false, 'The word \'cacheing\' was used in ' . $file . '. This should be changed to \'caching\'.');
                }
                if (stripos($string, 'publically') !== false) {
                    $this->assertTrue(false, 'The word \'publically\' was used in ' . $file . '. This should be changed to \'publicly\'.');
                }
                if (stripos($string, 'seperate') !== false) {
                    $this->assertTrue(false, 'The word \'seperate\' was used in ' . $file . '. This should be changed to \'separate\'.');
                }
                if (stripos($string, 'chat room') !== false) {
                    $this->assertTrue(false, 'The phrase \'chat room\' was used in ' . $file . '. This should be changed to \'chatroom\'.');
                }
                if (stripos($string, 'URL\'s') !== false) {
                    $this->assertTrue(false, 'The acronym \'URLs\' was used in ' . $file . '. This should be changed to \'URLs\'.');
                }
                if (stripos($string, 'user-group') !== false) {
                    $this->assertTrue(false, 'The term \'user-group\' was used in ' . $file . '. This should be changed to \'usergroup\'.');
                }
                if (stripos($string, 'supermember') !== false) {
                    $this->assertTrue(false, 'The term \'supermember\' was used in ' . $file . '. This should be changed to \'super-member\'.');
                }
                if (stripos($string, 'user name') !== false) {
                    $this->assertTrue(false, 'The term \'user name\' was used in ' . $file . '. This should be changed to \'username\'.');
                }
                if (stripos($string, 'built in') !== false) {
                    $this->assertTrue(false, 'The phrase \'built in\' was used in ' . $file . '. This should be changed to \'built-in\'.');
                }
                if ((stripos($string, 'email') !== false) && (stripos($string, '/') === false) && (stripos($string, 'codename') === false)) {
                    $this->assertTrue(false, 'The term \'email\' was used in ' . $file . '. This should be changed to \'e-mail\'.');
                }
                if (stripos($string, 'web site') !== false) {
                    $this->assertTrue(false, 'The phrase \'web site\' was used in ' . $file . '. This should be changed to \'website\'.');
                }
                if (stripos($string, 'ID\'s') !== false) {
                    $this->assertTrue(false, 'The term \'ID\'s\' was used in ' . $file . '. This should be changed to \'IDs\'.');
                }
                if (stripos($string, 'comma separated') !== false) {
                    $this->assertTrue(false, 'The phrase \'comma separated\' was used in ' . $file . '. This should be changed to \'comma-separated\'.');
                }

                //if (stripos($string,'center')!==false) $this->assertTrue(false,'The word \'center\' was used in '.$file.'. This should be changed to \'centre\'.');

                if ($file != 'upgrade.ini' && $key != 'NO_PHP_IN_TEMPLATES' && $key != 'WHAT_TO_EXPECT' && $key != 'DESCRIPTION_INCLUDE_CMS_ADVERT' && $key != 'INCLUDE_CMS_ADVERT' && $key != 'UNINSTALL_WARNING' && $key != 'SOFTWARE_CHAT_EXTRA' && (strpos($key, 'SETUPWIZARD') === false) && $key != 'CANNOT_CONNECT_HOME' && $key != 'NO_GD_ON_SERVER' && $key != 'MYSQL_TOO_OLD' && $key != 'LOW_MEMORY_LIMIT' && $key != 'NO_ZIP_ON_SERVER' && $key != 'WARNING_MBSTRING_FUNC_OVERLOAD' && $key != 'DISABLED_FUNCTION' && $file != 'lang.ini' && $file != 'version.ini' && $file != 'debrand.ini' && $file != 'import.ini' && $file != 'installer.ini' && $file != 'commandr.ini' && $file != 'addons.ini' && strpos($string, 'Composr') !== false) {
                    $this->assertTrue(false, 'The word \'Composr\' was used in ' . $file . ' (' . $key . '). This should probably be changed to \'the software\'.');
                }

                if (preg_match('#([^A-Za-z"\_<]+)comcode([^A-Za-z"]+)#', $string) != 0) {
                    $this->assertTrue(false, 'The term \'comcode\' was used in ' . $file . '. This should be changed to \'Comcode\'.');
                }

                if (($verbose) && (stripos($string, 'user') !== false)) {
                    $this->assertTrue(false, 'The term \'user\' was used in ' . $file . '. This might need to be changed to \'member\', depending on the circumstances.');
                }
                if (stripos($string, 'set-up') !== false) {
                    $this->assertTrue(false, 'The phrase \'set-up\' was used in ' . $file . '. This might need to be changed to \'setup\', depending on the usage.');
                }
                if (($verbose) && (strpos($string, '\n') !== false)) {
                    $this->assertTrue(false, 'The \'\n\' linebreak character was used in ' . $file . ' in the language string. This should be checked, to make sure it is really necessary.');
                }

                if (preg_match('#([^A-Za-z]+)Javascript([^A-Za-z]+)#', $string) != 0) {
                    $this->assertTrue(false, 'The word \'Javascript\' was used in ' . $file . '. This should be changed to \'JavaScript\'.');
                }
                if (preg_match('#([^A-Za-z]+)tar([^A-Za-z]+)#', $string) != 0) {
                    $this->assertTrue(false, 'The filetype \'tar\' was used in ' . $file . '. This should be changed to \'TAR\'.');
                }
                if (preg_match('#([^A-Za-z]>+)id([^A-Za-z=<]+)#', $string) != 0) {
                    $this->assertTrue(false, 'The acronym \'id\' was used in ' . $file . '. This should be changed to \'ID\'.');
                }
                if (preg_match('#([^A-Za-z\[\]></\']+)url([^\}A-Za-z=\']+)#', $string) != 0) {
                    $this->assertTrue(false, 'The acronym \'url\' was used in ' . $file . '. This should be changed to \'URL\'.');
                }
                if (preg_match('#([^A-Za-z]+)zip([^A-Za-z]+)#', $string) != 0) {
                    $this->assertTrue(false, 'The filetype \'zip\' was used in ' . $file . '. This should be changed to \'ZIP\'.');
                }

                if (($verbose) && (preg_match('#([A-Za-z]+)s( |-)#', $string) != 0)) {
                    $this->assertTrue(false, 'A word ended with an \'s\', but did not contain an apostrophe. This might be a case of mistaken plurality.');
                }
                if (($verbose) && (preg_match('#([a-z]+)( |-)([A-Z]{1})([a-z]+)#', $string) != 0)) {
                    $this->assertTrue(false, 'A word that was in the middle of the string started with a capital letter. This might be a badly capitalised string.');
                }
                if (($verbose) && (preg_match('#<([A-Za-z]+)>#', $string) != 0)) {
                    $this->assertTrue(false, 'An HTML tag was used in ' . $file . ' in the language string. This should be checked, to make sure it is really necessary; HTML should be confined to the templates.');
                }
            }
        }
        closedir($dh);
    }

    public function tearDown()
    {
        parent::tearDown();
    }
}

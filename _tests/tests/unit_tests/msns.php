<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

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
class msns_test_set extends cms_test_case
{
    public function testNoBadTablePrefixing()
    {
        require_code('files2');
        $php_path = find_php_path();
        $contents = get_directory_contents(get_file_base());
        foreach ($contents as $f) {
            if (in_array($f, array(
                '_tests/tests/unit_tests/msns.php',
                'adminzone/pages/modules/admin_version.php',
                'sources/blocks/main_friends_list.php',
                'sources/hooks/modules/admin_setupwizard/cns_forum.php',
                'sources/hooks/systems/cron/subscription_mails.php',
                'sources/upgrade.php',
            ))) {
                continue;
            }

            if ((substr($f, -4) == '.php') && (basename($f) != 'errorlog.php')) {
                $c = file_get_contents($f);

                $this->assertTrue(strpos($c, ". get_table_prefix() . 'f_") === false, 'Wrong forum table prefix in ' . $f);
            }
        }
    }
}

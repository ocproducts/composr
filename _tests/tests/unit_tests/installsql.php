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
class installsql_test_set extends cms_test_case
{
    public function testInstallSql()
    {
        /*
        NB: We usually make install.sql using the old free Navicat Lite, or phpMyAdmin. This test may not find issues with generation in other software.
        */

        $contents = file_get_contents(get_file_base() . '/install.sql');

        // Not with forced charsets or other contextual noise
        $this->assertTrue(strpos($contents, "\n" . 'SET') === false, 'Contains unwanted context');
        $this->assertTrue(preg_match('#\d+ SET #', $contents) == 0, 'Contains unwanted context');

        // Old way of specifying table types
        $this->assertTrue(strpos($contents, ' TYPE=') === false, 'Change TYPE= to ENGINE=');

        // Not with bundled addons
        $this->assertTrue(strpos($contents, 'CREATE TABLE `cms_workflow_') === false, 'Contains non-bundled addons');

        // Not with wrong table prefixes / multiple installs
        $this->assertTrue(preg_match('#\`cms\d+\_#', $contents) == 0, 'Contains a version-prefixed install');
        $this->assertTrue(preg_match('#\`cms\_#', $contents) == 1, 'Does not contain a standard-prefixed install');

        // Not having been run
        $this->assertTrue(preg_match('#INSERT INTO \`cms\_cache\`#i', $contents) == 0, 'Contains cache data');
        $this->assertTrue(preg_match('#INSERT INTO \`cms\_stats\`#i', $contents) == 0, 'Contains stat data - site should not have been loaded ever yet');

        // Out-dated version
        $v = float_to_raw_string(cms_version_number());
        $this->assertTrue(strpos($contents, '\'version\',\'' . $v . '\'') !== false || strpos($contents, '\'version\', \'' . $v . '\'') !== false, 'Contains wrong version');
    }

    public function testSplitUp()
    {
        // NB: The split up version is for the Microsoft Web Platform installer...

        $contents1 = file_get_contents(get_file_base() . '/install.sql');
        $contents2 = '';
        for ($i = 0; $i < 4; $i++) {
            $this->assertTrue(file_exists(get_file_base() . '/install' . strval($i + 1) . '.sql'), 'Missing file (install' . strval($i + 1) . '.sql)');
            $contents2 .= file_get_contents(get_file_base() . '/install' . strval($i + 1) . '.sql');
            $this->assertTrue(filesize(get_file_base() . '/install' . strval($i + 1) . '.sql') < 300000, 'SQL dump (install' . strval($i + 1) . '.sql) too big, maybe the split points need reconsideration or the table order in install.sql isn\'t alphabetical (try phpMyAdmin, that dumps alphabetically)');
        }

        $this->assertTrue(str_replace("\n", '', $contents1) == str_replace("\n", '', $contents2), 'install*.sql not split from install.sql, but we\'ll try and fix that (try refreshing)');

        $split_points = array(
            '',
            'DROP TABLE IF EXISTS `cms_db_meta`;',
            'DROP TABLE IF EXISTS `cms_f_polls`;',
            'DROP TABLE IF EXISTS `cms_member_privileges`;',
        );

        // Check we can find split points
        $ok = true;
        foreach ($split_points as $p) {
            if ($p != '') {
                if (strpos($contents1, $p) === false) {
                    $ok = false;
                }
            }
        }
        $this->assertTrue($ok, 'Could not find split points in install.sql for automatic install*.sql generation');
        if ($ok) {
            $froms = array();
            foreach ($split_points as $p) {
                if ($p == '') {
                    $from = 0;
                } else {
                    $from = strpos($contents1, $p);
                }
                $froms[] = $from;
            }
            sort($froms);
            for ($i = 0; $i < 4; $i++) {
                $from = $froms[$i];
                if ($i < 3) {
                    $to = $froms[$i + 1];
                    $segment = substr($contents1, $from, $to - $from);
                } else {
                    $segment = substr($contents1, $from);
                }
                file_put_contents(get_file_base() . '/install' . strval($i + 1) . '.sql', $segment);
                fix_permissions(get_file_base() . '/install' . strval($i + 1) . '.sql');
                sync_file(get_file_base() . '/install' . strval($i + 1) . '.sql');
            }
        }
    }
}

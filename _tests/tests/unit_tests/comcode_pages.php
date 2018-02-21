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
class comcode_pages_test_set extends cms_test_case
{
    public function setUp()
    {
        require_code('zones2');
    }

    public function testParsing()
    {
        require_code('files2');
        require_code('comcode_check');
        require_code('failure');

        set_throw_errors(true);

        $only_tutorial = get_param_string('only_tutorial', '') ;
        if ($only_tutorial == '') {
            $files = get_directory_contents(get_file_base(), '', 0, true, true, array('txt'));
        } else {
            $files = array('docs/pages/comcode_custom/EN/' . $only_tutorial . '.txt');
        }

        foreach ($files as $file) {
            if ($file != 'themes/default/text/tempcode_test.txt') {
                continue; // TODO
            }

            if (preg_match('#^(adminzone/pages|buildr/pages|docs/pages|site/pages|pages|themes/default/text|themes/default/text_custom|data/modules/cms_comcode_pages)/#', $file) == 0) {
                continue;
            }

            $c = file_get_contents(get_file_base() . '/' . $file);

            try {
                check_comcode($c);
            }
            catch (Exception $e) {
                $this->assertTrue(false, 'Failed to parse ' . $file . ', ' . $e->getMessage());
            }
        }

        set_throw_errors(false);
    }

    public function testPageTitleDetection()
    {
        if (get_param_string('only_tutorial', '') != '') {
            return;
        }

        $pages = array(
            '[title]Test[/title]' => 'Test',
            '[title="1"]Test[/title]' => 'Test',
            '[title param="1"]Test[/title]' => 'Test',

            '[title x="y"]Test[/title]' => 'Test',
            '[title="1" x="y"]Test[/title]' => 'Test',
            '[title param="1" x="y"]Test[/title]' => 'Test',
            '[title x="y" param="1"]Test[/title]' => 'Test',

            '[title sub="Subtitle"]Test[/title]' => 'Test (Subtitle)',
            '[title="1" sub="Subtitle"]Test[/title]' => 'Test (Subtitle)',
            '[title param="1" sub="Subtitle"]Test[/title]' => 'Test (Subtitle)',
            '[title sub="Subtitle" param="1"]Test[/title]' => 'Test (Subtitle)',

            '[title]
                Test
            [/title]' => 'Test',

            '[title]Foo & Bar[/title]' => 'Foo & Bar',

            '[html][title]Foo &amp; Bar[/title][/html]' => 'Foo & Bar',
            '[semihtml][title]Foo &amp; Bar[/title][/semihtml]' => 'Foo & Bar',
        );

        $path = cms_tempnam();

        foreach ($pages as $page_contents => $expected) {
            file_put_contents($path, $page_contents);
            $got = get_comcode_page_title_from_disk($path, true);
            $this->assertTrue($got == $expected, 'Failed on: ' . $page_contents . '; expected: ' . $expected . '; got: ' . $got);
        }

        foreach ($pages as $page_contents => $expected) {
            file_put_contents($path, $page_contents);
            $_got = get_comcode_page_title_from_disk($path, true, true);
            $got = $_got->evaluate();
            $this->assertTrue($got == escape_html($expected), 'Failed on: ' . $page_contents . '; expected: ' . $expected . '; got: ' . $got);
        }

        $page_contents = '[title sub="Foobar"]Test[/title]';
        file_put_contents($path, $page_contents);
        $got = get_comcode_page_title_from_disk($path, false);
        $this->assertTrue($got == 'Test', 'Failed on: ' . $page_contents);

        $page_contents = '[title="2"]Test[/title]';
        file_put_contents($path, $page_contents);
        $got = get_comcode_page_title_from_disk($path, true);
        $this->assertTrue(strpos($got, 'Test') === false, 'Failed on: ' . $page_contents);

        unlink($path);
    }
}

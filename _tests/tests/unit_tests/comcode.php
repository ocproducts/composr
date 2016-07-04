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
class comcode_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        require_code('comcode');
    }

    public function testComcode()
    {
        $expectations = array(" - foo  " => "<ul><li>foo</li></ul>", " - foo
 - bar" => "<ul><li>foo</li><li>bar</li></ul>", " - foo - bar" => " - foo - bar", "" => " ", " -foo" => "-foo", "-foo" => "-foo", "--foo" => "&ndash;foo", "[b]bar[/b]" => "<strongclass=\"comcode_bold\">bar</strong>");

        foreach ($expectations as $comcode => $html) {
            $actual = comcode_to_tempcode($comcode, null, false, null, null, null, false, false, false, false, false, null, null);

            $actual_altered = str_replace("&nbsp;", "", preg_replace('#\s#', '', $actual->evaluate()));

            $matches = preg_replace('#\s#', '', $html) == $actual_altered;

            $this->assertTrue($matches, '"' . $comcode . '" produced instead of "' . $actual_altered . '" "' . $html . '"');
        }
    }

    public function testMentions()
    {
        global $MEMBER_MENTIONS_IN_COMCODE;

        $tests = array(
            // Positives
            '@test' => true,
            ' @test' => true,
            '@test ' => true,
            ' @test ' => true,
            '@test,' => true,

            // Negatives
            ',@test' => false, // Must be preceded by white-space or nothing
            ',@test,' => false, // "
            'x@test ' => false, // "
            '@testxppp' => false, // Must not have junk on tail-end
        );

        foreach ($tests as $test => $expected) {
            $MEMBER_MENTIONS_IN_COMCODE = array();
            comcode_to_tempcode($test);

            if ($expected) {
                $this->assertTrue(count($MEMBER_MENTIONS_IN_COMCODE) == 1, 'Expected to see a mention for: "' . $test . '"');
            } else 
            {
                $this->assertTrue(count($MEMBER_MENTIONS_IN_COMCODE) == 0, 'Expected to NOT see a mention for: "' . $test . '"');
            }
        }
    }
}

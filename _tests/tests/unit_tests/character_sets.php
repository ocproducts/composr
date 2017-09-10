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
class character_sets_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        require_code('character_sets');
    }

    public function testConvertNormal()
    {
        // ISO-8859-1 --> utf-8...

        // Upper case character set names
        $input = chr(hexdec('a3')); // GBP symbol
        $output = convert_to_internal_encoding($input, 'ISO-8859-1', 'UTF-8');
        $this->assertTrue($output == chr(hexdec('c2')) . chr(hexdec('a3')));

        // Lower case character set names
        $input = chr(hexdec('a3')); // GBP symbol
        $output = convert_to_internal_encoding($input, 'iso-8859-1', 'utf-8');
        $this->assertTrue($output == chr(hexdec('c2')) . chr(hexdec('a3')));

        // utf-8 --> ISO-8859-1...

        // Upper case character set names
        $input = chr(hexdec('c2')) . chr(hexdec('a3')); // GBP symbol
        $output = convert_to_internal_encoding($input, 'UTF-8', 'ISO-8859-1');
        $this->assertTrue($output == chr(hexdec('a3')));

        // Lower case character set names
        $input = chr(hexdec('c2')) . chr(hexdec('a3')); // GBP symbol
        $output = convert_to_internal_encoding($input, 'utf-8', 'iso-8859-1');
        $this->assertTrue($output == chr(hexdec('a3')));
    }

    public function testConvertEntities()
    {
        $input = chr(hexdec('c2')) . chr(hexdec('a3')); // GBP symbol
        $output = convert_to_html_encoding($input);
        $this->assertTrue($output == '&#163;');
    }
}
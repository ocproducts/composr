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
class crypt_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        require_code('crypt');
    }

    public function testRandomNumber()
    {
        $numbers = array();
        for ($i = 0; $i < 1000; $i++) {
            $numbers[] = get_secure_random_number();
        }
        $this->assertTrue(count(array_unique($numbers)) == count($numbers));
    }

    public function testRandomString()
    {
        $strings = array();
        for ($i = 0; $i < 100000; $i++) {
            $strings[] = get_rand_password();
        }
        $this->assertTrue(count(array_unique($strings)) == count($strings));
    }

    public function testRatchet()
    {
        $password = get_rand_password();
        $salt = get_rand_password();
        $pass_hash_salted = ratchet_hash($password, $salt);
        $this->assertTrue(ratchet_hash_verify($password, $salt, $pass_hash_salted));
    }

    public function testObfuscate()
    {
        $email = 'foo@example.com';
        $this->assertTrue(strip_html(obfuscate_email_address($email)) == $email);
    }
}

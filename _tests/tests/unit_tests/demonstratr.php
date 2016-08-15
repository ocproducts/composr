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
class demonstratr_test_set extends cms_test_case
{
    public function testIsMySQL()
    {
        $this->assertTrue(strpos(get_db_type(), 'mysql') !== false, 'Test can only run with MySQL');
    }

    public function testDemonstratrCloneOut()
    {
        if (strpos(get_db_type(), 'mysql') !== false) {
            require_code('composr_homesite');

            global $SITE_INFO;
            if (!isset($SITE_INFO['mysql_root_password'])) {
                $SITE_INFO['mysql_root_password'] = $SITE_INFO['db_site_password'];
            }
            if (!isset($SITE_INFO['mysql_demonstratr_password'])) {
                $SITE_INFO['mysql_demonstratr_password'] = $SITE_INFO['db_site_password'];
            }

            demonstratr_add_site_raw('localhost', 'test', 'info@ocproducts.com', '');
        }
    }
}

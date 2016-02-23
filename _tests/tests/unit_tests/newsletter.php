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
class newsletter_test_set extends cms_test_case
{
    public $news_id;

    public function setUp()
    {
        parent::setUp();

        require_code('newsletter');

        $this->news_id = add_newsletter('New Offer', 'The new offer of the week.');

        $this->assertTrue('New Offer' == get_translated_text($GLOBALS['SITE_DB']->query_select_value('newsletters', 'title', array('id' => $this->news_id))));
    }

    public function testEditNewsletter()
    {
        edit_newsletter($this->news_id, 'Thanks', 'Thank you');

        $this->assertTrue('Thanks' == get_translated_text($GLOBALS['SITE_DB']->query_select_value('newsletters', 'title', array('id' => $this->news_id))));
    }

    public function tearDown()
    {
        delete_newsletter($this->news_id);

        parent::tearDown();
    }
}

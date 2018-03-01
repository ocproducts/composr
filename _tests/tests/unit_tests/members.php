<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/**
 * Composr test case class (unit testing).
 */
class members_test_set extends cms_test_case
{
    protected $member_id;
    protected $access_mapping;

    public function setUp()
    {
        parent::setUp();

        if (get_forum_type() != 'cns') {
            $this->assertTrue(false, 'Test only works with Conversr');
            return;
        }

        require_code('cns_members_action');
        require_code('cns_members_action2');
        require_lang('cns');

        $this->member_id = $GLOBALS['FORUM_DRIVER']->get_member_from_username('testmember');
        if ($this->member_id !== null) {
            cns_delete_member($this->member_id);
        }

        $this->member_id = cns_make_member('testmember', '123456aB$!x', 'test@test.com', array(), 10, 1, 1980, array(), null, null, 1, null, null, '', null, '', 0, 0, 1, '', '', '', 1, 1, null, 1, 1, null, '', true, null, '', 1, null, 0, '*', '');

        $this->assertTrue('testmember' == $GLOBALS['FORUM_DB']->query_select_value('f_members', 'm_username', array('id' => $this->member_id)));
    }

    public function testEditMember()
    {
        if (get_forum_type() != 'cns') {
            return;
        }

        cns_edit_member(
            $this->member_id,
            'testing@test.com',
            0,
            25,
            12,
            1975,
            null,
            null,
            array(),
            '',
            0,
            0,
            0,
            null, // language
            1, // allow_emails
            1, // allow_emails_from_staff
            null, // validated
            null, // username
            null, // password
            null, // highlighted_name
            '*', // pt_allow
            '', // pt_rules_text
            null, // on_probation_until
            null, // auto_mark_read
            null, // join_time
            null, // avatar_url
            null, // signature
            null, // is_perm_banned
            null, // photo_url
            null, // photo_thumb_url
            null, // salt
            null, // password_compatibility_scheme
            false // skip_checks
        );

        $this->assertTrue('testing@test.com' == $GLOBALS['FORUM_DB']->query_select_value('f_members', 'm_email_address', array('id' => $this->member_id)));
    }

    public function tearDown()
    {
        if (get_forum_type() != 'cns') {
            return;
        }

        cns_delete_member($this->member_id);

        parent::tearDown();
    }
}

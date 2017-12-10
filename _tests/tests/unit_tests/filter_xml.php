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
class filter_xml_test_set extends cms_test_case
{
    public function testRemoveShout()
    {
        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <removeShout />
                </qualify>
            </fieldRestrictions>
        ';
        require_code('files');
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $rnd = strval(mt_rand(1,100000));
        $title = 'EXAMPLE' . $rnd;

        $this->establish_admin_session();

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
        );

        require_code('csrf_filter');
        $post['csrf_token'] = generate_csrf_token();

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_download_file($url->evaluate(), null, true, false, 'Composr', $post, array(get_session_cookie() => get_session_id()));

        $rows = $GLOBALS['SITE_DB']->query_select('news', array('*'), null, 'ORDER BY date_and_time DESC', 1);
        $row = $rows[0];
        $this->assertTrue(get_translated_text($row['title']) == 'Example' . $rnd);

        @unlink(get_file_base() . '/data_custom/xml_config/fields.xml');
        sync_file(get_file_base() . '/data_custom/xml_config/fields.xml');
    }
}

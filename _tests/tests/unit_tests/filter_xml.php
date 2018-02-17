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
class filter_xml_test_set extends cms_test_case
{
    public function setUp()
    {
        $this->establish_admin_session();

        require_code('files');
        require_code('csrf_filter');

        parent::setUp();
    }

    public function testNonFilter()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <filter members="100">
                    <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                        <shun>test</shun>
                    </qualify>
                </filter>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $title = 'test';

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('trigger_error' => false, 'post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));
        $this->assertTrue($result !== null);
    }

    public function testFilter()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <filter members="2">
                    <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                        <shun>test</shun>
                    </qualify>
                </filter>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $title = 'test';

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('trigger_error' => false, 'post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));
        $this->assertTrue($result === null);
    }

    public function testNonQualify()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_x" types="add,_add,_edit,__edit" fields="title">
                    <shun>test</shun>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $title = 'test';

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('trigger_error' => false, 'post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));
        $this->assertTrue($result !== null);
    }

    public function testQualify()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <shun>test</shun>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $title = 'test';

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('trigger_error' => false, 'post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));
        $this->assertTrue($result === null);
    }

    public function testRemoveShout()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <removeShout />
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $rnd = strval(mt_rand(1, 100000));
        $title = 'EXAMPLE' . $rnd;

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));

        $rows = $GLOBALS['SITE_DB']->query_select('news', array('*'), array(), 'ORDER BY id DESC', 1);
        $row = $rows[0];
        $this->assertTrue(get_translated_text($row['title']) == 'Example' . $rnd);
    }

    public function testSentenceCase()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <sentenceCase />
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $title = 'this is a test';

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));

        $rows = $GLOBALS['SITE_DB']->query_select('news', array('*'), array(), 'ORDER BY id DESC', 1);
        $row = $rows[0];
        $this->assertTrue(get_translated_text($row['title']) == 'This is a test');
    }

    public function testTitleCase()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <titleCase />
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $title = 'this is a test';

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));

        $rows = $GLOBALS['SITE_DB']->query_select('news', array('*'), array(), 'ORDER BY id DESC', 1);
        $row = $rows[0];
        $this->assertTrue(get_translated_text($row['title']) == 'This Is A Test');
    }

    public function testAppend()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <prepend>foobar</prepend>
                    <append>foobar</append>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $title = 'EXAMPLE';

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));

        $rows = $GLOBALS['SITE_DB']->query_select('news', array('*'), array(), 'ORDER BY id DESC', 1);
        $row = $rows[0];
        $this->assertTrue(get_translated_text($row['title']) == 'foobarEXAMPLEfoobar');
    }

    public function testReplace()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <replace from="blah">foobar</replace>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $title = 'blah';

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));

        $rows = $GLOBALS['SITE_DB']->query_select('news', array('*'), array(), 'ORDER BY id DESC', 1);
        $row = $rows[0];
        $this->assertTrue(get_translated_text($row['title']) == 'foobar');
    }

    public function testDeepClean()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <deepClean />
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $title = ' blah ';

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));

        $rows = $GLOBALS['SITE_DB']->query_select('news', array('*'), array(), 'ORDER BY id DESC', 1);
        $row = $rows[0];
        $this->assertTrue(get_translated_text($row['title']) == 'blah');
    }

    public function testDefaultFields()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add" fields="title">
                    <replace>foobar</replace>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $title = 'EXAMPLE';

        $post = array(
            'title' => $title,
            'main_news_category' => '7',
            'author' => 'admin',
            'validated' => '1',
            'post' => 'Test Test Test Test Test',
            'news' => 'Test Test Test Test Test',
            'csrf_token' => generate_csrf_token(),
            'confirm_double_post' => '1',
        );

        $url = build_url(array('page' => 'cms_news', 'type' => 'add', 'keep_fatalistic' => 1), 'cms');

        $result = http_get_contents($url->evaluate(), array('post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));

        $this->assertTrue(substr_count($result, ' value="foobar"') == 1);
    }

    public function testMinLength()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <minLength>4</minLength>
                    <maxLength>6</maxLength>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $expects = array(
            'xxx' => false,
            'xxxx' => true,
            'xxxxxx' => true,
            'xxxxxxx' => false,
        );

        foreach ($expects as $title => $expect) {
            $post = array(
                'title' => $title,
                'main_news_category' => '7',
                'author' => 'admin',
                'validated' => '1',
                'post' => 'Test Test Test Test Test',
                'news' => 'Test Test Test Test Test',
                'csrf_token' => generate_csrf_token(),
                'confirm_double_post' => '1',
            );

            $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

            $result = http_get_contents($url->evaluate(), array('trigger_error' => false, 'post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));
            if ($expect) {
                $this->assertTrue($result !== null);
            } else {
                $this->assertTrue($result === null);
            }
        }
    }

    public function testPossibilitySet()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <possibilitySet>a,b,c</possibilitySet>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $expects = array(
            'b' => true,
            'x' => false,
        );

        foreach ($expects as $title => $expect) {
            $post = array(
                'title' => $title,
                'main_news_category' => '7',
                'author' => 'admin',
                'validated' => '1',
                'post' => 'Test Test Test Test Test',
                'news' => 'Test Test Test Test Test',
                'csrf_token' => generate_csrf_token(),
                'confirm_double_post' => '1',
            );

            $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

            $result = http_get_contents($url->evaluate(), array('trigger_error' => false, 'post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));
            if ($expect) {
                $this->assertTrue($result !== null);
            } else {
                $this->assertTrue($result === null);
            }
        }
    }

    public function testDisallowedWord()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <disallowedWord>yo*</disallowedWord>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $expects = array(
            'hello' => true,
            'yogurt' => false,
        );

        foreach ($expects as $title => $expect) {
            $post = array(
                'title' => $title,
                'main_news_category' => '7',
                'author' => 'admin',
                'validated' => '1',
                'post' => 'Test Test Test Test Test',
                'news' => 'Test Test Test Test Test',
                'csrf_token' => generate_csrf_token(),
                'confirm_double_post' => '1',
            );

            $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

            $result = http_get_contents($url->evaluate(), array('trigger_error' => false, 'post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));
            if ($expect) {
                $this->assertTrue($result !== null);
            } else {
                $this->assertTrue($result === null);
            }
        }
    }

    public function testDisallowedSubstring()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <disallowedSubstring>blah blah blah</disallowedSubstring>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $expects = array(
            'blah blah' => true,
            'blah blah blah' => false,
            'blah blah blah blah' => false,
        );

        foreach ($expects as $title => $expect) {
            $post = array(
                'title' => $title,
                'main_news_category' => '7',
                'author' => 'admin',
                'validated' => '1',
                'post' => 'Test Test Test Test Test',
                'news' => 'Test Test Test Test Test',
                'csrf_token' => generate_csrf_token(),
                'confirm_double_post' => '1',
            );

            $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

            $result = http_get_contents($url->evaluate(), array('trigger_error' => false, 'post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));
            if ($expect) {
                $this->assertTrue($result !== null);
            } else {
                $this->assertTrue($result === null);
            }
        }
    }

    public function testShun()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <shun>xxx</shun>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $expects = array(
            'foobar' => true,
            'xxx' => false,
        );

        foreach ($expects as $title => $expect) {
            $post = array(
                'title' => $title,
                'main_news_category' => '7',
                'author' => 'admin',
                'validated' => '1',
                'post' => 'Test Test Test Test Test',
                'news' => 'Test Test Test Test Test',
                'csrf_token' => generate_csrf_token(),
                'confirm_double_post' => '1',
            );

            $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

            $result = http_get_contents($url->evaluate(), array('trigger_error' => false, 'post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));
            if ($expect) {
                $this->assertTrue($result !== null);
            } else {
                $this->assertTrue($result === null);
            }
        }
    }

    public function testPattern()
    {
        if (get_db_type() == 'xml') {
            return; // Too slow
        }

        $test_xml = '
            <fieldRestrictions>
                <qualify pages="cms_news" types="add,_add,_edit,__edit" fields="title">
                    <pattern>x+</pattern>
                </qualify>
            </fieldRestrictions>
        ';
        cms_file_put_contents_safe(get_file_base() . '/data_custom/xml_config/fields.xml', $test_xml);

        $expects = array(
            'foobar' => false,
            'xxx' => true,
        );

        foreach ($expects as $title => $expect) {
            $post = array(
                'title' => $title,
                'main_news_category' => '7',
                'author' => 'admin',
                'validated' => '1',
                'post' => 'Test Test Test Test Test',
                'news' => 'Test Test Test Test Test',
                'csrf_token' => generate_csrf_token(),
                'confirm_double_post' => '1',
            );

            $url = build_url(array('page' => 'cms_news', 'type' => '_add', 'keep_fatalistic' => 1), 'cms');

            $result = http_get_contents($url->evaluate(), array('trigger_error' => false, 'post_params' => $post, 'cookies' => array(get_session_cookie() => get_session_id())));
            if ($expect) {
                $this->assertTrue($result !== null);
            } else {
                $this->assertTrue($result === null);
            }
        }
    }

    public function tearDown()
    {
        @unlink(get_file_base() . '/data_custom/xml_config/fields.xml');
        sync_file(get_file_base() . '/data_custom/xml_config/fields.xml');

        parent::tearDown();
    }
}

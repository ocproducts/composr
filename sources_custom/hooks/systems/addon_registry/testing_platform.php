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
 * Hook class.
 */
class Hook_addon_registry_testing_platform
{
    /**
     * Get a list of file permissions to set
     *
     * @param  boolean $runtime Whether to include wildcards represented runtime-created chmoddable files
     * @return array File permissions to set
     */
    public function get_chmod_array($runtime = false)
    {
        return array();
    }

    /**
     * Get the version of Composr this addon is for
     *
     * @return float Version number
     */
    public function get_version()
    {
        return cms_version_number();
    }

    /**
     * Get the addon category
     *
     * @return string The category
     */
    public function get_category()
    {
        return 'Development';
    }

    /**
     * Get the addon author
     *
     * @return string The author
     */
    public function get_author()
    {
        return 'Chris Graham';
    }

    /**
     * Find other authors
     *
     * @return array A list of co-authors that should be attributed
     */
    public function get_copyright_attribution()
    {
        return array('Marcus Baker', 'Jason Sweat', 'Travis Swicegood', 'Perrick Penet', 'Edward Z. Yang', 'ocProducts');
    }

    /**
     * Get the addon licence (one-line summary only)
     *
     * @return string The licence
     */
    public function get_licence()
    {
        return 'LGPL (SimpleTest), tests licensed on the same terms as Composr';
    }

    /**
     * Get the description of the addon
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'The Composr testing platform. Do not run this on a production system as it will interfere with installs and may contain security holes.';
    }

    /**
     * Get a list of tutorials that apply to this addon
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array(
            'codebook',
        );
    }

    /**
     * Get a mapping of dependency types
     *
     * @return array File permissions to set
     */
    public function get_dependencies()
    {
        return array(
            'requires' => array( // Actually, it's all
                'meta_toolkit',
            ),
            'recommends' => array(),
            'conflicts_with' => array()
        );
    }

    /**
     * Explicitly say which icon should be used
     *
     * @return URLPATH Icon
     */
    public function get_default_icon()
    {
        return 'themes/default/images/icons/48x48/menu/_generic_admin/tool.png';
    }

    /**
     * Get a list of files that belong to this addon
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources_custom/hooks/systems/addon_registry/testing_platform.php',
            'lang_custom/EN/phpdoc.ini',
            'sources_custom/php.php',
            'sources_custom/phpstub.php',
            '_tests/codechecker/.htaccess',
            '_tests/codechecker/build.sh',
            '_tests/codechecker/checker.ini',
            '_tests/codechecker/code_quality.php',
            '_tests/codechecker/codechecker.app/.htaccess',
            '_tests/codechecker/codechecker.app/Contents/.htaccess',
            '_tests/codechecker/codechecker.app/Contents/index.html',
            '_tests/codechecker/codechecker.app/Contents/Info.plist',
            '_tests/codechecker/codechecker.app/Contents/MacOS/.htaccess',
            '_tests/codechecker/codechecker.app/Contents/MacOS/codechecker',
            '_tests/codechecker/codechecker.app/Contents/MacOS/index.html',
            '_tests/codechecker/codechecker.app/index.html',
            '_tests/codechecker/codechecker.bat',
            '_tests/codechecker/codechecker.sh',
            '_tests/codechecker/index.html',
            '_tests/codechecker/lex.php',
            '_tests/codechecker/lib.php',
            '_tests/codechecker/netbeans/.htaccess',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/AboutDialog.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_aboutBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_ClearErrorsBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_countBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_errors_actionAdapterClick.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_errors_actionAdapterKey.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_examineFilesBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_files_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_files_actionAdapterClick.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_files_actionAdapterKey.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_ForgetErrorBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_optionsBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_scanFilesBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_scanSignaturesBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_specialBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_templatesBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog1_ViewCodeBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog2_cancelBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog2_closeBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog2_phpPathBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog2_projectPathBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog2_textEditorPathBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Dialog3_closeBtn_actionAdapter.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/FSTransfer.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/index.html',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/Main.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/MainDialog$1.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/MainDialog.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/OptionsDialog.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/ProcessingDialog.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/SearchFile.class',
            '_tests/codechecker/netbeans/build/classes/codequalitychecker/VerticalFlowLayout.class',
            '_tests/codechecker/netbeans/build/built-jar.properties',
            '_tests/codechecker/netbeans/build.xml',
            '_tests/codechecker/netbeans/dist/Code_Quality_Checker.jar',
            '_tests/codechecker/netbeans/dist/README.TXT',
            '_tests/codechecker/netbeans/manifest.mf',
            '_tests/codechecker/netbeans/nbproject/build-impl.xml',
            '_tests/codechecker/netbeans/nbproject/genfiles.properties',
            '_tests/codechecker/netbeans/nbproject/private/config.properties',
            '_tests/codechecker/netbeans/nbproject/private/private.properties',
            '_tests/codechecker/netbeans/nbproject/private/private.xml',
            '_tests/codechecker/netbeans/nbproject/project.properties',
            '_tests/codechecker/netbeans/nbproject/project.xml',
            '_tests/codechecker/java_src/codequalitychecker/AboutDialog.java',
            '_tests/codechecker/java_src/codequalitychecker/index.html',
            '_tests/codechecker/java_src/codequalitychecker/Main.java',
            '_tests/codechecker/java_src/codequalitychecker/MainDialog.java',
            '_tests/codechecker/java_src/codequalitychecker/OptionsDialog.java',
            '_tests/codechecker/java_src/codequalitychecker/ProcessingDialog.java',
            '_tests/codechecker/java_src/codequalitychecker/SearchFile.java',
            '_tests/codechecker/java_src/codequalitychecker/VerticalFlowLayout.java',
            '_tests/codechecker/netbeans/test/.htaccess',
            '_tests/codechecker/netbeans/test/index.html',
            '_tests/codechecker/non_errors.txt',
            '_tests/codechecker/parse.php',
            '_tests/codechecker/phpdoc_parser.php',
            '_tests/codechecker/readme.txt',
            '_tests/codechecker/tests.php',
            '_tests/codechecker/xhtml.php',
            '_tests/html_dump/.htaccess',
            '_tests/html_dump/forum_test_set/.htaccess',
            '_tests/html_dump/forum_test_set/index.html',
            '_tests/html_dump/index.html',
            '_tests/index.php',
            '_tests/cmstest/.htaccess',
            '_tests/cmstest/bootstrap.php',
            '_tests/cmstest/index.html',
            '_tests/cmstest/cms_test_case.php',
            '_tests/readme.txt',
            '_tests/screens_tested/.htaccess',
            '_tests/screens_tested/index.html',
            '_tests/simpletest/.htaccess',
            '_tests/simpletest/authentication.php',
            '_tests/simpletest/browser.php',
            '_tests/simpletest/collector.php',
            '_tests/simpletest/compatibility.php',
            '_tests/simpletest/cookies.php',
            '_tests/simpletest/default_reporter.php',
            '_tests/simpletest/detached.php',
            '_tests/simpletest/docs/.htaccess',
            '_tests/simpletest/docs/en/.htaccess',
            '_tests/simpletest/docs/en/authentication_documentation.html',
            '_tests/simpletest/docs/en/browser_documentation.html',
            '_tests/simpletest/docs/en/docs.css',
            '_tests/simpletest/docs/en/expectation_documentation.html',
            '_tests/simpletest/docs/en/form_testing_documentation.html',
            '_tests/simpletest/docs/en/group_test_documentation.html',
            '_tests/simpletest/docs/en/index.html',
            '_tests/simpletest/docs/en/mock_objects_documentation.html',
            '_tests/simpletest/docs/en/overview.html',
            '_tests/simpletest/docs/en/partial_mocks_documentation.html',
            '_tests/simpletest/docs/en/reporter_documentation.html',
            '_tests/simpletest/docs/en/unit_test_documentation.html',
            '_tests/simpletest/docs/en/web_tester_documentation.html',
            '_tests/simpletest/docs/fr/.htaccess',
            '_tests/simpletest/docs/fr/authentication_documentation.html',
            '_tests/simpletest/docs/fr/browser_documentation.html',
            '_tests/simpletest/docs/fr/docs.css',
            '_tests/simpletest/docs/fr/expectation_documentation.html',
            '_tests/simpletest/docs/fr/form_testing_documentation.html',
            '_tests/simpletest/docs/fr/group_test_documentation.html',
            '_tests/simpletest/docs/fr/index.html',
            '_tests/simpletest/docs/fr/mock_objects_documentation.html',
            '_tests/simpletest/docs/fr/overview.html',
            '_tests/simpletest/docs/fr/partial_mocks_documentation.html',
            '_tests/simpletest/docs/fr/reporter_documentation.html',
            '_tests/simpletest/docs/fr/server_stubs_documentation.html',
            '_tests/simpletest/docs/fr/unit_test_documentation.html',
            '_tests/simpletest/docs/fr/web_tester_documentation.html',
            '_tests/simpletest/docs/index.html',
            '_tests/simpletest/dumper.php',
            '_tests/simpletest/eclipse.php',
            '_tests/simpletest/encoding.php',
            '_tests/simpletest/errors.php',
            '_tests/simpletest/exceptions.php',
            '_tests/simpletest/expectation.php',
            '_tests/simpletest/extensions/.htaccess',
            '_tests/simpletest/extensions/index.html',
            '_tests/simpletest/extensions/pear_test_case.php',
            '_tests/simpletest/extensions/phpunit_test_case.php',
            '_tests/simpletest/extensions/testdox/.htaccess',
            '_tests/simpletest/extensions/testdox/index.html',
            '_tests/simpletest/extensions/testdox/test.php',
            '_tests/simpletest/extensions/testdox.php',
            '_tests/simpletest/form.php',
            '_tests/simpletest/frames.php',
            '_tests/simpletest/http.php',
            '_tests/simpletest/index.html',
            '_tests/simpletest/invoker.php',
            '_tests/simpletest/LICENSE',
            '_tests/simpletest/mock_objects.php',
            '_tests/simpletest/page.php',
            '_tests/simpletest/parser.php',
            '_tests/simpletest/README',
            '_tests/simpletest/reflection_php4.php',
            '_tests/simpletest/reflection_php5.php',
            '_tests/simpletest/remote.php',
            '_tests/simpletest/reporter.php',
            '_tests/simpletest/sample.php',
            '_tests/simpletest/scorer.php',
            '_tests/simpletest/selector.php',
            '_tests/simpletest/shell_tester.php',
            '_tests/simpletest/simpletest.php',
            '_tests/simpletest/socket.php',
            '_tests/simpletest/tag.php',
            '_tests/simpletest/test_browser.php',
            '_tests/simpletest/test_case.php',
            '_tests/simpletest/unit_tester.php',
            '_tests/simpletest/url.php',
            '_tests/simpletest/user_agent.php',
            '_tests/simpletest/VERSION',
            '_tests/simpletest/web_tester.php',
            '_tests/simpletest/xml.php',
            '_tests/tests/.htaccess',
            '_tests/tests/index.html',
            '_tests/tests/regression_tests/.htaccess',
            '_tests/tests/regression_tests/index.html',
            '_tests/tests/testatom.cms',
            '_tests/tests/testrss.cms',

            // It is worth noting that most of these are not true unit tests, but integration tests, or other kinds of test
            //  Pedantry aside - we just want to test as effectively and efficiently and broadly as we can ;-).
            //   Whatever we can quickly achieve as a testing win for our total platform stability/coherence, we go with.
            //   Contributions for deeper, detailed, testing, are very welcome.
            '_tests/tests/unit_tests/.htaccess',
            '_tests/tests/unit_tests/calendar_event.php',
            '_tests/tests/unit_tests/calendar_event_type.php',
            '_tests/tests/unit_tests/gallery_images.php',
            '_tests/tests/unit_tests/template_xss.php',
            '_tests/tests/unit_tests/notifications_all_coded.php',
            '_tests/tests/unit_tests/specsettings_documented.php',
            '_tests/tests/unit_tests/overused_globals.php',
            '_tests/tests/unit_tests/auth.php',
            '_tests/tests/unit_tests/api_classes_documented.php',
            '_tests/tests/unit_tests/lang_ini_size.php',
            '_tests/tests/unit_tests/adminzone_search.php',
            '_tests/tests/unit_tests/tracker_categories.php',
            '_tests/tests/unit_tests/clean_reinstall.php',
            '_tests/tests/unit_tests/authors.php',
            '_tests/tests/unit_tests/awards.php',
            '_tests/tests/unit_tests/banners.php',
            '_tests/tests/unit_tests/comcode_wysiwyg.php',
            '_tests/tests/unit_tests/_bash_parser.php',
            '_tests/tests/unit_tests/backups.php',
            '_tests/tests/unit_tests/bookmark.php',
            '_tests/tests/unit_tests/bump_member_group_timeout.php',
            '_tests/tests/unit_tests/catalogues.php',
            '_tests/tests/unit_tests/catalogues_category.php',
            '_tests/tests/unit_tests/wiki.php',
            '_tests/tests/unit_tests/web_platform.php',
            '_tests/tests/unit_tests/cma_hooks.php',
            '_tests/tests/unit_tests/database_integrity.php',
            '_tests/tests/unit_tests/csrf_tags.php',
            '_tests/tests/unit_tests/chatroom.php',
            '_tests/tests/unit_tests/comcode.php',
            '_tests/tests/unit_tests/comcode_to_text.php',
            '_tests/tests/unit_tests/tutorial_title_structure.php',
            '_tests/tests/unit_tests/comment.php',
            '_tests/tests/unit_tests/xhtml_substr.php',
            '_tests/tests/unit_tests/config_lang_strings.php',
            '_tests/tests/unit_tests/_cqc__function_sigs.php',
            '_tests/tests/unit_tests/cqc_adminzone.php',
            '_tests/tests/unit_tests/cqc_blocks.php',
            '_tests/tests/unit_tests/cqc_cms.php',
            '_tests/tests/unit_tests/cqc_collaboration.php',
            '_tests/tests/unit_tests/cqc_database.php',
            '_tests/tests/unit_tests/cqc_forum.php',
            '_tests/tests/unit_tests/cqc_forumdrivers.php',
            '_tests/tests/unit_tests/cqc_hooks.php',
            '_tests/tests/unit_tests/cqc_rest.php',
            '_tests/tests/unit_tests/cqc_site.php',
            '_tests/tests/unit_tests/cqc_sources.php',
            '_tests/tests/unit_tests/cqc_welcome.php',
            '_tests/tests/unit_tests/css_and_js.php',
            '_tests/tests/unit_tests/dev_environment.php',
            '_tests/tests/unit_tests/sitemap.php',
            '_tests/tests/unit_tests/blocks.php',
            '_tests/tests/unit_tests/_commandr_fs.php',
            '_tests/tests/unit_tests/broken_includes.php',
            '_tests/tests/unit_tests/addon_guards.php',
            '_tests/tests/unit_tests/config.php',
            '_tests/tests/unit_tests/downloads.php',
            '_tests/tests/unit_tests/downloads_category.php',
            '_tests/tests/unit_tests/ecommerce.php',
            '_tests/tests/unit_tests/css_file.php',
            '_tests/tests/unit_tests/emoticon.php',
            '_tests/tests/unit_tests/community_billboard.php',
            '_tests/tests/unit_tests/forum.php',
            '_tests/tests/unit_tests/forum_grouping.php',
            '_tests/tests/unit_tests/theme_images.php',
            '_tests/tests/unit_tests/glossary.php',
            '_tests/tests/unit_tests/galleries.php',
            '_tests/tests/unit_tests/template_no_unused.php',
            '_tests/tests/unit_tests/forum_poll.php',
            '_tests/tests/unit_tests/addon_references.php',
            '_tests/tests/unit_tests/git_conflicts.php',
            '_tests/tests/unit_tests/lang_html_safe.php',
            '_tests/tests/unit_tests/lang_duplication.php',
            '_tests/tests/unit_tests/phpstub_accuracy.php',
            '_tests/tests/unit_tests/lang_grammar.php',
            '_tests/tests/unit_tests/index.html',
            '_tests/tests/unit_tests/iotd.php',
            '_tests/tests/unit_tests/_broken_links.php',
            '_tests/tests/unit_tests/lang_spelling.php',
            '_tests/tests/unit_tests/lang_administrative_split.php',
            '_tests/tests/unit_tests/lang_no_unused.php',
            '_tests/tests/unit_tests/lang_misc.php',
            '_tests/tests/unit_tests/cqc_explicit_fail.php',
            '_tests/tests/unit_tests/menu.php',
            '_tests/tests/unit_tests/themeini_images.php',
            '_tests/tests/unit_tests/addon_screenshots.php',
            '_tests/tests/unit_tests/missing_block_params.php',
            '_tests/tests/unit_tests/missing_colour_equations.php',
            '_tests/tests/unit_tests/permissions.php',
            '_tests/tests/unit_tests/tutorial_image_consistency.php',
            '_tests/tests/unit_tests/tutorial_quality.php',
            '_tests/tests/unit_tests/tutorials_broken_links.php',
            '_tests/tests/unit_tests/moderation.php',
            '_tests/tests/unit_tests/modularisation.php',
            '_tests/tests/unit_tests/url_management.php',
            '_tests/tests/unit_tests/news.php',
            '_tests/tests/unit_tests/news_category.php',
            '_tests/tests/unit_tests/newsletter.php',
            '_tests/tests/unit_tests/cms_merge.php',
            '_tests/tests/unit_tests/should_ignore_file.php',
            '_tests/tests/unit_tests/points.php',
            '_tests/tests/unit_tests/poll.php',
            '_tests/tests/unit_tests/post_template.php',
            '_tests/tests/unit_tests/posts.php',
            '_tests/tests/unit_tests/quiz.php',
            '_tests/tests/unit_tests/rating.php',
            '_tests/tests/unit_tests/database_relations.php',
            '_tests/tests/unit_tests/rss.php',
            '_tests/tests/unit_tests/shopping.php',
            '_tests/tests/unit_tests/standard_dir_files.php',
            '_tests/tests/unit_tests/tempcode.php',
            '_tests/tests/unit_tests/template_previews.php',
            '_tests/tests/unit_tests/ticket_type.php',
            '_tests/tests/unit_tests/_find_broken_screen_links.php',
            '_tests/tests/unit_tests/user.php',
            '_tests/tests/unit_tests/user_banunban.php',
            '_tests/tests/unit_tests/usergroup.php',
            '_tests/tests/unit_tests/warning.php',
            '_tests/tests/unit_tests/welcome_emails.php',
            '_tests/tests/unit_tests/bot_list_sync.php',
            '_tests/tests/unit_tests/_installer.php',
            '_tests/tests/unit_tests/_installer_xml_db.php',
            '_tests/tests/unit_tests/_installer_forum_drivers.php',
            '_tests/tests/unit_tests/_setup_wizard.php',
            '_tests/tests/unit_tests/demonstratr.php',
            '_tests/tests/unit_tests/override_issues.php',
            '_tests/tests/unit_tests/js_ssl_issues.php',
            '_tests/tests/unit_tests/_resource_fs.php',
            '_tests/tests/unit_tests/google_appengine.php',
            '_tests/tests/unit_tests/tutorials_all_linked.php',
            '_tests/tests/unit_tests/addon_setupwizard.php',
            '_tests/tests/unit_tests/override_notes_consistency.php',
            '_tests/tests/unit_tests/copyright.php',
            '_tests/tests/unit_tests/image_compression.php',
            '_tests/tests/unit_tests/xss.php',
            '_tests/tests/unit_tests/core_fields.php',
            '_tests/tests/unit_tests/chmod_consistency.php',
            '_tests/tests/unit_tests/external_code_considerations.php',
            '_tests/tests/unit_tests/tutorials_codebox.php',
            '_tests/tests/unit_tests/_performance.php',
            '_tests/tests/regression_tests/input_filter_post_block.php',
            '_tests/tests/unit_tests/privilege_existence.php',
        );
    }
}

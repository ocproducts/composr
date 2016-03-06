<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 */

// Find Composr base directory, and chdir into it
global $FILE_BASE, $RELATIVE_PATH;
$FILE_BASE = (strpos(__FILE__, './') === false) ? __FILE__ : realpath(__FILE__);
$FILE_BASE = dirname($FILE_BASE);
if (!is_file($FILE_BASE . '/sources/global.php')) {
    $RELATIVE_PATH = basename($FILE_BASE);
    $FILE_BASE = dirname($FILE_BASE);
} else {
    $RELATIVE_PATH = '';
}
if (!is_file($FILE_BASE . '/sources/global.php')) {
    $FILE_BASE = $_SERVER['SCRIPT_FILENAME']; // this is with symlinks-unresolved (__FILE__ has them resolved); we need as we may want to allow zones to be symlinked into the base directory without getting path-resolved
    $FILE_BASE = dirname($FILE_BASE);
    if (!is_file($FILE_BASE . '/sources/global.php')) {
        $RELATIVE_PATH = basename($FILE_BASE);
        $FILE_BASE = dirname($FILE_BASE);
    } else {
        $RELATIVE_PATH = '';
    }
}
@chdir($FILE_BASE);

global $FORCE_INVISIBLE_GUEST;
$FORCE_INVISIBLE_GUEST = false;
global $EXTERNAL_CALL;
$EXTERNAL_CALL = false;
if (!is_file($FILE_BASE . '/sources/global.php')) {
    exit('<!DOCTYPE html>' . "\n" . '<html lang="EN"><head><title>Critical startup error</title></head><body><h1>Composr startup error</h1><p>The second most basic Composr startup file, sources/global.php, could not be located. This is almost always due to an incomplete upload of the Composr system, so please check all files are uploaded correctly.</p><p>Once all Composr files are in place, Composr must actually be installed by running the installer. You must be seeing this message either because your system has become corrupt since installation, or because you have uploaded some but not all files from our manual installer package: the quick installer is easier, so you might consider using that instead.</p><p>ocProducts maintains full documentation for all procedures and tools, especially those for installation. These may be found on the <a href="http://compo.sr">Composr website</a>. If you are unable to easily solve this problem, we may be contacted from our website and can help resolve it for you.</p><hr /><p style="font-size: 0.8em">Composr is a website engine created by ocProducts.</p></body></html>');
}
require($FILE_BASE . '/sources/global.php');

// Put code that you temporarily want executed into the function. DELETE THE CODE WHEN YOU'RE DONE.
// This is useful when performing quick and dirty upgrades (e.g. adding tables to avoid a reinstall)

composr_homesite_install();

/**
 * Execute some install code put into this function.
 */
function composr_homesite_install()
{
    global $SITE_INFO;
    if (get_param_string('password') != $SITE_INFO['master_password']) {
        warn_exit('Must provide correct master password');
    }

    header('Content-type: text/plain');

    require_code('database_action');
    require_code('config2');
    require_code('menus2');
    require_code('permissions2');

    // NB: The following modules are already covered in the installer...
    //  - docs:tutorials
    //  - adminzone:admin_customers
    //  - adminzone:admin_cmsusers
    //  - (installing of docs zone)

    // NB: You may want to run the 'lang' unit test, which does some relevant testing on the pages etc

    // Banners
    // -------

    $GLOBALS['SITE_DB']->query_update('banner_types', array('t_image_width' => 960, 't_image_height' => 319), array('id' => ''), '', 1);
    require_code('banners');
    require_code('banners2');
    $banners = collapse_1d_complexity('name', $GLOBALS['SITE_DB']->query_select('banners', array('name')));
    foreach ($banners as $banner) {
        delete_banner($banner);
    }
    $url = 'pointstore.htm';//static_evaluate_tempcode(build_url(array('page' => 'pointstore'), get_module_zone('pointstore'), null, false, false, true))
    $img = 'themes/composr_homesite/images_custom/composr_homesite/community_advertising.png'; //find_theme_image('composr_homesite/community_advertising')
    add_banner('fallback', $img, '', 'Community advertising', '', null, $url->evaluate(), 1, '', BANNER_FALLBACK, null, 2, 1);

    // Support ticket types
    // --------------------

    require_code('tickets2');
    $ticket_types = array(
        'Feedback',
        'Partnership',
        'Job',
        'Project',
        'Secondment',
        'Professional support',
        'Installation',
        'Upgrade',
    );
    delete_ticket_type(1); // Other
    delete_ticket_type(2); // Complaint
    foreach ($ticket_types as $ticket_type) {
        $cat_id = add_ticket_type($ticket_type);
        set_global_category_access('tickets', $cat_id);
    }

    // Config
    // ------

    set_option('output_streaming', '0'); // Complex layout, we don't want things to jump on decache; also, intrusion detector wants to run with consistency
    set_option('yeehaw', '0');
    set_option('collapse_user_zones', '1');
    set_option('is_on_block_cache', '0'); // Change when live
    set_option('url_scheme', 'HTM');
    set_option('site_closed', '0');
    set_option('site_name', 'Composr CMS');
    set_option('copyright', 'Copyright &copy; ocProducts Ltd 2015');
    set_option('google_analytics', 'UA-72654755-1');
    set_option('staff_address', 'info@compo.sr');
    set_option('website_email', 'info@compo.sr');
    set_option('pd_email', 'payment@compo.sr');
    set_option('ipn', 'payment@compo.sr');
    set_option('ipn_test', 'payment@compo.sr');
    set_option('encryption_key', '{file_base}/uploads/website_specific/ocportal.com/public.pem');
    set_option('decryption_key', '{file_base}/uploads/website_specific/ocportal.com/private.pem');
    set_option('site_scope', 'Composr CMS');
    set_option('primary_paypal_email', 'payment@compo.sr');
    set_option('newsletter_title', 'Composr CMS newsletter');
    set_option('network_links', 'http://compo.sr/data/netlink.php');
    set_option('mail_server', 'localhost');
    set_option('likes', '1');
    set_option('cookie_notice', '1');
    set_option('breadcrumb_crop_length', '60');
    set_option('facebook_appid', '303252706408200');
    set_option('facebook_uid', '80430912569');
    set_option('is_on_highlight_name_buy', '0');
    set_option('is_on_gambling_buy', '0');
    set_option('is_on_topic_pin_buy', '0');
    set_option('email_confirm_join', '0');
    set_option('remember_me_by_default','1');
    set_option('leader_board_size', '8');
    set_option('allowed_post_submitters', "compo.sr\nocproducts.com\nlocalhost\n127.0.0.1\n192.168.1.100\npaypal.com\nsandbox.paypal.com");
    set_option('security_token_exceptions', "_make_release\npurchase\nsubscriptions\ninvoices");
    set_option('keywords', 'cms,content management,website,web property,dynamic,interactive,social media,social networking,forum,community,build,make,create,software,php');

    // Downloads structure
    // -------------------

    require_code('downloads2');
    $cat_id = add_download_category('Composr Releases', db_get_first_id(), "Avoid installing old releases, as they may contain bugs or security holes that we have since fixed.\n\nIf you are trying to upgrade, you're looking in the wrong place. Personalised upgrade packages may be generated from the new version announcements in the [page=\"site:news\"]news archive[/page].", '', find_theme_image('tutorial_icons/installation', false, true));
    set_global_category_access('downloads', $cat_id);
    $cat_id = add_download_category('Addons', db_get_first_id(), "[title=\"2\"]What are addons?[/title]\n\nAddons are new/changed features for Composr. Addons are organised by the version they are targeted for.\n\nApply some caution:\nCommunity members are encouraged to submit addons. The addons don't need validating, except if for submitters in the lowest member rank (fan&nbsp;in&nbsp;training). Therefore you should also exercise some caution when installing these third-party addons.\n\n[title=\"2\"]Contributing addons[/title]\n\nBy submitting an addon, you are giving ocProducts permission to redistribute it -- but also please consider specifying a licence in your download description.\n\nIf you think the addon will be broadly useful and would like to have it added to the auto-maintained non-bundled addons in git (or even the bundled code), go through the [page=\":contact:contribute_code\"]contribution[/page] process.\n\nIf you are not attaching a proper Composr addon (an exported TAR file), then please describe how the addon can be installed in the description.\n\n[title=\"2\"]Choose Composr version below[/title]\n", '', find_theme_image('tutorial_icons/addon', false, true));
    set_global_category_access('downloads', $cat_id);

    /*
    Addons category for a release are added automatically by the publish_addons_as_downloads.php script
    Addons categories underneath are added automatically by the publish_addons_as_downloads.php script also
    Releases category for a release is made by the _make_release.php script
    */

    // Catalogues structure
    // --------------------

    // Partners...

    $partners_description = 'Partners are shown on the public partners page, and with a map. Partners may also be given project referrals (ocProducts will sometimes directly transfer on projects to appropriate people).';
    $partner_types = array(
        'Freelance designer',
        'Freelance developer',
        'Freelance consultant',
        'Small Agency (2-5 full time employees)',
        'Agency (over 5 full time employees)',
        'Other',
    );
    $project_contribution_types = array(
        'Translation(s)',
        'Addon(s)',
        'Theme(s)',
        'Tutorial(s)',
        'Core development',
        'Seminars / public training',
        'Feature sponsorship',
    );

    actual_add_catalogue('partners', 'Composr partners', $partners_description, C_DT_FIELDMAPS, 0, '', 0);
    $cf_name = actual_add_catalogue_field('partners', 'Name / Company', 'Your name, or your organisation\'s name.', 'short_text', null, /*defines_order*/1, /*visible*/1, /*searchable*/1, '', /*required*/1);
    $cf_description = actual_add_catalogue_field('partners', 'Description', 'A short description of your services.', 'long_trans', null, /*defines_order*/0, /*visible*/1, /*searchable*/1, '', /*required*/1);
    $cf_logo = actual_add_catalogue_field('partners', 'Logo', 'A logo, roughly square.', 'picture', null, /*defines_order*/0, /*visible*/1, /*searchable*/0, '', /*required*/1);
    $cf_url = actual_add_catalogue_field('partners', 'URL', 'URL to your website.', 'url', null, /*defines_order*/0, /*visible*/1, /*searchable*/0, '', /*required*/1);
    $cf_type = actual_add_catalogue_field('partners', 'Partner type', 'You must select the most honest type. If you are a freelancer who happens to just know some other complementary freelancers, don\'t say you are an agency.', 'list', null, /*defines_order*/0, /*visible*/1, /*searchable*/0, implode('|', $partner_types), /*required*/1);
    $cf_region = actual_add_catalogue_field('partners', 'Region served', 'Where you are willing to travel to for meetings. Leave as "(Online only)" if you don\'t want to do physical meetings.', 'short_text', null, /*defines_order*/0, /*visible*/1, /*searchable*/1, '(Online only)', /*required*/1);
    $cf_latitude = actual_add_catalogue_field('partners', 'Latitude', 'This public location may be approximate to the nearest town/city, for privacy reasons.', 'float', null, /*defines_order*/0, /*visible*/1, /*searchable*/0, '', /*required*/1);
    $cf_longitude = actual_add_catalogue_field('partners', 'Longitude', 'This public location may be approximate to the nearest town/city, for privacy reasons.', 'float', null, /*defines_order*/0, /*visible*/1, /*searchable*/0, '', /*required*/1);
    $cf_language = actual_add_catalogue_field('partners', 'Language(s)', 'Languages you are comfortable working professionally in.', 'short_text_multi', null, /*defines_order*/0, /*visible*/1, /*searchable*/1, 'English', /*required*/1);
    $cf_contribution = actual_add_catalogue_field('partners', 'Community contributions', 'What kinds of contribution to Composr have you made? You must be entirely truthful, reflect what is already publicly released, and only include work for which you have not been paid for. There is no obligation to have contributions, but clients are likely to consider this evidence of whether someone is contributing back and knowledgeable.', 'list_multi', null, /*defines_order*/0, /*visible*/1, /*searchable*/0, implode('|', $project_contribution_types), /*required*/0, 1, 1, 'show_unset_values=on,auto_sort=frontend');
    $cat_id = actual_add_catalogue_category('partners', 'Composr partners', '', '', null, '');
    set_global_category_access('catalogues_catalogue', 'partners');
    set_global_category_access('catalogues_category', $cat_id);
    $ocproducts = array(
        $cf_name => 'ocProducts',
        $cf_description => 'ocProducts is the primary sponsor for Composr CMS, managing the development and hosting the community. The ocProducts CEO is the original and current Composr lead developer, Chris&nbsp;Graham.',
        $cf_logo => 'uploads/website_specific/compo.sr/partners/ocproducts.png',
        $cf_url => 'http://ocproducts.com',
        $cf_type => 'Agency',
        $cf_region => 'England',
        $cf_latitude => '53.379965',
        $cf_longitude => '-1.469422',
        $cf_language => 'English',
        $cf_contribution => "Addon\nTutorial\nCore development",
    );
    actual_add_catalogue_entry($cat_id, 1, '', 0, 0, 0, $ocproducts);

    // News structure
    // --------------

    require_code('news2');
    $cat_id = add_news_category('Security issues', 'newscats/difficulties', '');
    set_global_category_access('news', $cat_id);
    $cat_id = add_news_category('Announcements', 'newscats/business', '');
    set_global_category_access('news', $cat_id);
    $cat_id = add_news_category('New releases', 'newscats/new_release', '');
    set_global_category_access('news', $cat_id);
    delete_news_category(3); // Difficulties
    delete_news_category(5); // Entertainment
    delete_news_category(6); // Business
    delete_news_category(7); // Art

    // Forum structure
    // ---------------

    require_code('cns_forums_action');
    require_code('cns_forums_action2');

    // Groupings
    cns_edit_forum_grouping(1, 'Water Coolr'/*Was 'General'*/, "Beyond today's Composr (conversing, planning)", 1);
    // (2 = Staff, no change)
    cns_make_forum_grouping('Composing', 'Composing with Composr'); // 3

    // Forums
    $cat_id = cns_make_forum('Introduce yourself', '', 1/*forum grouping*/, null, 1/*parent forum*/, 0/*position*/, 1/*increment*/, 0/*alpha order*/, '', '', '');
    set_global_category_access('forums', $cat_id);
    $deploying_forum_id = cns_make_forum('Deploying', '', 3/*forum grouping*/, null, 1/*parent forum*/, 1/*position*/, 1/*increment*/, 0/*alpha order*/, '', '', '');
    $cat_id = cns_make_forum('Designing', '', 3/*forum grouping*/, null, 1/*parent forum*/, 2/*position*/, 1/*increment*/, 0/*alpha order*/, '', '', '');
    set_global_category_access('forums', $cat_id);
    $cat_id = cns_make_forum('Developing', '', 3/*forum grouping*/, null, 1/*parent forum*/, 3/*position*/, 1/*increment*/, 0/*alpha order*/, '', '', '');
    set_global_category_access('forums', $cat_id);
    $cat_id = cns_make_forum('Addons', '', 3/*forum grouping*/, null, 1/*parent forum*/, 4/*position*/, 1/*increment*/, 0/*alpha order*/, '', '', '');
    set_global_category_access('forums', $cat_id);
    $cat_id = cns_make_forum('Internationalisation', '', 3/*forum grouping*/, null, 1/*parent forum*/, 5/*position*/, 1/*increment*/, 0/*alpha order*/, '', '', '');
    set_global_category_access('forums', $cat_id);
    $cat_id = cns_make_forum('Feature requests and bug tracking', '', 3/*forum grouping*/, null, $deploying_forum_id/*parent forum*/, 1/*position*/, 1/*increment*/, 0/*alpha order*/, '', '', 'tracker');
    set_global_category_access('forums', $cat_id);
    $cat_id = cns_make_forum('FAQ', '', 3/*forum grouping*/, null, $deploying_forum_id/*parent forum*/, 2/*position*/, 1/*increment*/, 0/*alpha order*/, '', '', 'docs/faq.htm');
    set_global_category_access('forums', $cat_id);
    $cat_id = cns_make_forum('Paid support', '', 3/*forum grouping*/, null, $deploying_forum_id/*parent forum*/, 3/*position*/, 1/*increment*/, 0/*alpha order*/, '', '', 'professional_support.htm');
    set_global_category_access('forums', $cat_id);
    $GLOBALS['FORUM_DB']->query_update('f_forums', array('f_position' => -3), array('id' => 10));
    $GLOBALS['FORUM_DB']->query_update('f_forums', array('f_position' => -2), array('id' => 11));
    $GLOBALS['FORUM_DB']->query_update('f_forums', array('f_position' => -1), array('id' => 12));

    // Topics...

    $admin_member_id = $GLOBALS['FORUM_DRIVER']->get_member_from_username('admin');
    require_code('cns_topics_action');
    require_code('cns_posts_action');

    $forum_id = db_get_first_id();
    $title = 'Forum advice and rules';
    $description = 'How to get support, make suggestions, etc';
    $post = "When joining compo.sr you agree to our rules, and when you first visit the forums you click through advice. This topic just repeats this for reference.\n\n[include]_forum_advice[/include]";
    $topic_id = cns_make_topic($forum_id, $description, '', 1, 1, 1/*pinned*/, 0, 1/*cascading*/);
    cns_make_post($topic_id, $title, $post, 0, true, 1, 1, null, null, null, $admin_member_id);
    $GLOBALS['FORUM_DB']->query_update('f_forums', array('f_intro_question' => '[include]_forum_advice[/include]', 'f_intro_question__text_parsed' => '', 'f_intro_question__source_user' => $admin_member_id), array('id' => $forum_id), '', 1);

    $forum_id = $GLOBALS['FORUM_DB']->query_select_value('f_forums', 'id', array('f_name' => 'Introduce yourself'));
    $title = 'Post your location';
    $description = 'Where are you in the world? See where others are.';
    $post = "Show where you are on our map :)! Find other Composr users who might be near you.\n\n[block]main_google_map_users[/block]\n\nTo add your position, either:\n - Grant your web browser permission to know your location\n - Set your location in your profile\n";
    $topic_id = cns_make_topic($forum_id, $description, '', 1, 1, 1/*pinned*/);
    cns_make_post($topic_id, $title, $post, 0, true, 1, 1, null, null, null, $admin_member_id);

    $forum_id = db_get_first_id();
    $title = 'Composr evangelism';
    $description = 'Did someone miss Composr?';
    $post = "[include]_evangelism[/include]";
    $topic_id = cns_make_topic($forum_id, $description, '', 1, 1, 1/*pinned*/, 0, 1/*cascading*/);
    cns_make_post($topic_id, $title, $post, 0, true, 1, 1, null, null, null, $admin_member_id);

    // Theme
    // -----

    $GLOBALS['SITE_DB']->query("UPDATE " . get_table_prefix() . "zones SET zone_theme='composr_homesite' WHERE zone_name IN ('','site','forum','ocproducts','docs','collaboration')");

    // Menu
    // ----

    import_menu_csv(get_custom_file_base() . '/uploads/website_specific/cms_menu_items.csv');

    // SSL
    // ---

    $https_pages = array(
        ':contact',
        ':join',
        ':login',
        ':members',
        ':purchase',
        ':shopping',
        ':points',
    );
    $GLOBALS['SITE_DB']->query_delete('https_pages');
    foreach ($https_pages as $https_page) {
        $GLOBALS['SITE_DB']->query_insert('https_pages', array('https_page_name' => $https_page));
    }

    // Members
    // -------

    $GLOBALS['FORUM_DB']->query_update('f_member_custom_fields', array('field_1' => 'Very humble anonymous admin.'), array('mf_member_id' => 2), '', 1);

    // Usergroups
    // ----------

    $GLOBALS['FORUM_DB']->query_update('f_groups', array('g_name' => 'Community saint'), array('id' => 5), '', 1);
    $GLOBALS['FORUM_DB']->query_update('f_groups', array('g_name' => 'Honoured member', 'g_promotion_threshold' => 3000), array('id' => 6), '', 1);
    $GLOBALS['FORUM_DB']->query_update('f_groups', array('g_name' => 'Well-settled', 'g_promotion_threshold' => 1200), array('id' => 7), '', 1);
    $GLOBALS['FORUM_DB']->query_update('f_groups', array('g_name' => 'Fan in action', 'g_promotion_threshold' => 400), array('id' => 8), '', 1);
    $GLOBALS['FORUM_DB']->query_update('f_groups', array('g_name' => 'Fan in training', 'g_promotion_threshold' => 100), array('id' => 9), '', 1);

    require_code('cns_groups_action');
    cns_make_group('Composr supporters', 0, 0, 0, 'I supposr Composr', '', null, null, null, null, null, null, null, null, null, null, null, null, 3/*gift points per day*/, 0, 0, 0, null, 1, 1/*open membership*/);

    // Remove unneeded CPFs
    // --------------------

    require_code('cns_members_action2');
    cns_delete_boiler_custom_field('interests');
    cns_delete_boiler_custom_field('location');
    cns_delete_boiler_custom_field('occupation');

    // Permissions
    // -----------

    $GLOBALS['SITE_DB']->query_delete('group_zone_access', array('zone_name' => 'cms'));
    $GLOBALS['SITE_DB']->query_delete('group_zone_access', array('zone_name' => 'collaboration'));

    $groups = $GLOBALS['SITE_DB']->query_select('group_zone_access', array('group_id'), array('zone_name' => ''));
    foreach (array('forum', 'site', 'docs', 'ocproducts', 'cms') as $zone) {
        $GLOBALS['SITE_DB']->query_delete('group_zone_access', array('zone_name' => $zone));
        foreach ($groups as $group) {
            $GLOBALS['SITE_DB']->query_insert('group_zone_access', array('zone_name' => $zone, 'group_id' => $group['group_id']));
        }
    }

    // Only allow CMS access in a few places
    $pages = find_all_pages('cms', 'modules');
    foreach (array_keys($pages) as $page) {
        $GLOBALS['SITE_DB']->query_delete('group_page_access', array('page_name' => $page));
        foreach ($groups as $group) {
            if ($page != 'cms_catalogues' && $page != 'cms_downloads' && $page != 'cms_tutorials') {
                $GLOBALS['SITE_DB']->query_insert('group_page_access', array('page_name' => $page, 'zone_name' => 'cms', 'group_id' => $group['group_id']));
            }
        }
    }

    // Some targeted privileges for all except "Fan in training"
    foreach (array(5, 6, 7, 8) as $group_id) {
        // Submit download, without validation
        $map = array('group_id' => $group_id, 'privilege' => 'bypass_validation_midrange_content', 'the_page' => 'cms_downloads', 'module_the_name' => '', 'category_name' => '', 'the_value' => 1);
    	$GLOBALS['SITE_DB']->query_delete('group_privileges', $map);
    	$GLOBALS['SITE_DB']->query_insert('group_privileges', $map);

        // Submit partner entry, without validation
        $map = array('group_id' => $group_id, 'privilege' => 'bypass_validation_midrange_content', 'the_page' => 'cms_catalogues', 'module_the_name' => '', 'category_name' => '', 'the_value' => 1);
    	$GLOBALS['SITE_DB']->query_delete('group_privileges', $map);
    	$GLOBALS['SITE_DB']->query_insert('group_privileges', $map);
    }

    // Nobody public can post releases
    foreach ($groups as $group) {
        $map = array('group_id' => $group['group_id'], 'privilege' => 'submit_midrange_content', 'the_page' => '', 'module_the_name' => 'downloads', 'category_name' => strval($GLOBALS['SITE_DB']->query_select_value('download_categories', 'id', array('category' => 'Composr Releases'))), 'the_value' => 0);
    	$GLOBALS['SITE_DB']->query_delete('group_privileges', $map);
    	$GLOBALS['SITE_DB']->query_insert('group_privileges', $map);
    }

    // Addons
    require_code('addons');
    require_code('addons2');
    $addons = array_keys(find_installed_addons());
    $addons_wanted = array(
        'actionlog',
        'addon_publish',
        'apache_config_files',
        'authors',
        'awards',
        'banners',
        'breadcrumbs',
        'captcha',
        'catalogues',
        'chat',
        'cleanup_repository',
        'cns_avatars',
        'cns_cartoon_avatars',
        'cns_contact_member',
        'cns_cpfs',
        'cns_forum',
        'cns_member_avatars',
        'cns_member_photos',
        'cns_multi_moderations',
        'cns_reported_posts',
        'cns_signatures',
        'cns_tapatalk',
        'cns_thematic_avatars',
        'cns_warnings',
        'commandr',
        'composr_homesite',
        'composr_homesite_support_credits',
        'composr_release_build',
        'composr_tutorials',
        'custom_comcode',
        'data_mappr',
        'downloads',
        'ecommerce',
        'errorlog',
        'facebook_support',
        'forum_blocks',
        'galleries',
        'geshi',
        'getid3',
        'help_page',
        'linux_helper_scripts',
        'match_key_permissions',
        'meta_toolkit',
        'news',
        'newsletter',
        'news_shared',
        'page_management',
        'phpinfo',
        'points',
        'pointstore',
        'quizzes',
        'random_quotes',
        'recommend',
        'redirects_editor',
        'rootkit_detector',
        'search',
        'securitylogging',
        'ssl',
        'staff_messaging',
        'stats',
        'stats_block',
        'syndication',
        'syndication_blocks',
        'tickets',
        'twitter_support',
        'unvalidated',
        'users_online_block',
        'user_mappr',
        'welcome_emails',
        'wordfilter',
        'xml_fields',
    );
    $addons_to_remove = array();
    foreach ($addons as $addon) {
        if ((substr($addon, 0, 4) != 'core') && (!in_array($addon, $addons_wanted))) {
            $addons_to_remove[] = $addon;
        }
    }
    if (php_function_allowed('set_time_limit')) {
        set_time_limit(0);
    }
    foreach ($addons_to_remove as $i => $addon) {
        $GLOBALS['NO_QUERY_LIMIT'] = true;
        uninstall_addon($addon, $i == count($addons_to_remove) - 1);
    }

    echo 'Done';
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

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

    set_option('collapse_user_zones', '1');
    set_option('is_on_block_cache', '0'); // Change when live
    set_option('url_scheme', 'HTM');
    set_option('site_closed', '0');
    set_option('site_name', 'Composr CMS');
    set_option('copyright', 'Copyright &copy; ocProducts Ltd 2015');
    set_option('google_analytics', 'UA-449688-1');
    set_option('staff_address', 'info@compo.sr');
    set_option('website_email', 'info@compo.sr');
    set_option('pd_email', 'info@compo.sr');
    set_option('ipn', 'info@compo.sr');
    set_option('ipn_test', 'info@compo.sr');
    set_option('allowed_post_submitters', "compo.sr\nocproducts.com");
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

    // Downloads structure
    // -------------------

    require_code('downloads2');
    $cat_id = add_download_category('Releases', db_get_first_id(), "Releases of Composr.\n\nAvoid installing old releases, as they may contain bugs or security holes that we have since fixed.\n\nIf you are trying to upgrade, you\'re looking in the wrong place. Personalised upgrade packages may be generated from the new version announcements in the [page=\"site:news\"]news archive[/page].", '', 'uploads/repimages/installation.png');
    set_global_category_access('downloads', $cat_id);
    $cat_id = add_download_category('Addons', db_get_first_id(), "[title=\"2\"]What are addons?[/title]\n\nAddons are new/changed features for Composr. Addons are organised according to the version they are targeted for.\n\nCommunity members are encouraged to submit addons. The addons don\'t need validating, except if you\'re still in the lowest member rank (fan in training). Therefore you should also exercise some caution when installing these third-party addons.\n\n[title=\"2\"]Contributing addons[/title]\n\nBy submitting an addon, you are giving ocProducts permission to redistribute it, but also please consider specifying a licence in your download description.\n\nIf you would like to pass on copyright to ocProducts so that it can be considered for inclusion in a future Composr version, please include this in the \'Notes\' field of the download.\n\nIf you are not attaching a proper Composr addon (an exported TAR file), then please describe how the addon can be installed in the description.\n\n[title=\"2\"]Choose Composr version below[/title]\n", '', 'uploads/repimages/addon.png');
    set_global_category_access('downloads', $cat_id);

    /* These are added automatically by publish_addons_as_downloads.php scripts, underneath particular Addon release categories
    $cat_id = add_download_category('Themes', db_get_first_id(), "", '', 'uploads/repimages/xxx');
    set_global_category_access('downloads', $cat_id);
    $cat_id = add_download_category('Translations', db_get_first_id(), "", '', 'uploads/repimages/xxx');
    set_global_category_access('downloads', $cat_id);
    $cat_id = add_download_category('Addons', db_get_first_id(), "", '', 'uploads/repimages/xxx');
    set_global_category_access('downloads', $cat_id);
    */

    // Catalogues structure
    // --------------------

    // TODO

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
    cns_edit_forum_grouping(1, 'Water Coolr'/*Was 'General'*/, "'Beyond today\'s Composr (discussion, planning, addons)'", 1);
    // (2 = Staff, no change)
    cns_make_forum_grouping('Composing', "Beyond today\'s Composr (discussion, planning, addons)"); // 3

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
    $post = "Show where you are on our map :)! Find other Composr users who might be near you.\n\n[block]main_google_map_users[/block]";
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
    $GLOBALS['FORUM_DB']->query_update('f_groups', array('g_name' => 'Composr supporters'), array('id' => 5), '', 1);

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
    foreach (array('forum', 'site', 'docs', 'ocproducts') as $zone) {
        $GLOBALS['SITE_DB']->query_delete('group_zone_access', array('zone_name' => $zone));
        foreach ($groups as $group) {
            $GLOBALS['SITE_DB']->query_insert('group_zone_access', array('zone_name' => $zone, 'group_id' => $group['group_id']));
        }
    }

    echo 'Done';
}

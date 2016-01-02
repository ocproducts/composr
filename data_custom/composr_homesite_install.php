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

require_code('database_action');
require_code('config2');
require_code('menus2');
go();

/**
 * Execute some install code put into this function.
 */
function go()
{
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
    set_option('primary_paypal_email', 'payment@ocportal.com'); // TODO: Change this when we change the account itself
    set_option('newsletter_title', 'Composr CMS newsletter');
    set_option('network_links', 'http://compo.sr/data/netlink.php');
    set_option('mail_server', 'localhost');
    set_option('likes', '1');
    set_option('cookie_notice', '1');

    // Downloads structure
    // -------------------

    require_code('downloads2');
    add_download_category('Releases', db_get_first_id(), "Releases of Composr.\n\nAvoid installing old releases, as they may contain bugs or security holes that we have since fixed.\n\nIf you are trying to upgrade, you\'re looking in the wrong place. Personalised upgrade packages may be generated from the new version announcements in the [page=\"site:news\"]news archive[/page].", '', 'uploads/repimages/installation.png');
    add_download_category('Addons', db_get_first_id(), "[title=\"2\"]What are addons?[/title]\n\nAddons are new/changed features for Composr. Addons are organised according to the version they are targeted for.\n\nCommunity members are encouraged to submit addons. The addons don\'t need validating, except if you\'re still in the lowest member rank (fan in training). Therefore you should also exercise some caution when installing these third-party addons.\n\n[title=\"2\"]Contributing addons[/title]\n\nBy submitting an addon, you are giving ocProducts permission to redistribute it, but also please consider specifying a licence in your download description.\n\nIf you would like to pass on copyright to ocProducts so that it can be considered for inclusion in a future Composr version, please include this in the \'Notes\' field of the download.\n\nIf you are not attaching a proper Composr addon (an exported TAR file), then please describe how the addon can be installed in the description.\n\n[title=\"2\"]Choose Composr version below[/title]\n", '', 'uploads/repimages/addon.png');

    // Catalogues structure
    // --------------------

    // News structure
    // --------------

    require_code('news2');
    add_news_category('Security issues', 'newscats/business', 'newscats/54bc07a27cae89.30919704'); // TODO: Missing image
    add_news_category('Announcements', 'newscats/business', '');
    add_news_category('New releases', 'newscats/54bc07dea64a38.86061693', ''); // TODO: Missing image
    delete_news_category(3); // Difficulties
    delete_news_category(5); // Entertainment
    delete_news_category(6); // Business
    delete_news_category(7); // Art

    // Forum structure
    // ---------------
}

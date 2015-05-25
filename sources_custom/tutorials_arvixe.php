<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_tutorials
 */

function import_tutorials_from_arvixe()
{
    // LEGACY
    $name_remap = array(
        'ocPortal' => 'Composr',
        'OcCLE' => 'Commandr',
    );

    $title_tags = array(
        'Composr Custom Profile Fields (CPF)' => array('Members'),
        'Add new page wizard' => array('Structure and navigation', 'Content'),
        'Add a Sub Forum to your Composr Forum' => array('Forum', 'Social'),
        'Changing the Composr Forums' => array('Forum', 'Social'),
        'Editing the Composr Front Page' => array('Structure and navigation', 'Content'),
        'Composr 101' => array('Introduction'),
        'Adding an Image Slider to Composr' => array('Structure and navigation', 'Content'),
        'Backing up your Composr Installation' => array('Maintenance'),
        'Recommended Composr Addons' => array('Advice & Guidance', 'Introduction'),
        'Keeping Track of your Composr Site' => array('Administration', 'Analytics'),
        'Partner Sites and De-Branding in Composr' => array('Structure and navigation'),
        'Editing Menus in Composr' => array('Structure and navigation'),
        'Explaining the Composr Quiz Module' => array('Content', 'Feedback features'),
        'Setting up Google Ads in Composr' => array('Banners', 'eCommerce', 'Third Party Integration'),
        'Setting Up Classified Ads on Composr' => array('Catalogues', 'eCommerce', 'Content'),
        'Icons, Smiles & Avatars in Composr' => array('Members', 'Social'),
        'Updating the Members Listing in Composr' => array('Members', 'Social'),
        'Direct Embedding of Videos in Composr' => array('Galleries', 'Content'),
        'Adding an Activity Feed to your Composr Website' => array('Social'),
        'Composr Points Explained' => array('Fun and Games', 'Social'),
        'Editing Site Wide Permissions in Composr' => array('Security', 'Configuration'),
        'Stopping Spammers in Composr' => array('Security', 'Configuration'),
        'Converting an Composr Gallery to a Carrousel' => array('Galleries', 'Content'),
        'Using the If In Group Tag in Composr' => array('Content', 'Security'),
        'Creating a Hidden Members Zone in Composr' => array('Security'),
        'A Detailed Look at the Booking Addon in Composr' => array('eCommerce'),
        'Add a Booking System to your Composr Website' => array('eCommerce'),
        'Embed Documents on a Page in Composr' => array('Content'),
        'Add Your eBay Store to Your Composr Website' => array('eCommerce', 'Third Party Integration'),
        'Install a Theme in Composr' => array('Design & Themeing'),
        'Translation in Composr' => array('Internationalisation'),
        'Configure the News Display in Composr' => array('News', 'Content'),
        'Share the Music you Listen to in Composr' => array('Third Party Integration'),
        'Set Up the Activity Feed Addon in Composr' => array('Social'),
        'Set Up a Workflow in Composr' => array('Collaboration', 'Content'),
        'Add a Download Catalogue in Composr' => array('Content', 'Downloads'),
        'An Overview of Galleries in Composr Part 2' => array('Content', 'Galleries'),
        'An Overview of Galleries in Composr Part 1' => array('Content', 'Galleries'),
        'Add Shoutboxes to Composr' => array('Chatrooms', 'Social'),
        'Add a Chatroom to Composr' => array('Chatrooms', 'Social'),
        'Integrating a YouTube Channel to Composr' => array('Content', 'Galleries', 'Third Party Integration'),
        'Add a Twitter Feed Block to Composr' => array('Social', 'Third Party Integration'),
        'Set a Recurring Event in Composr' => array('Calendar', 'Content'),
        'A Detailed Look at the Composr Calendar System' => array('Calendar', 'Content'),
        'Security in Composr' => array('Security'),
        'Setup a Wiki in Composr' => array('Content', 'Wiki+'),
        'Web Standards in Composr' => array('Web standards & Accessibility'),
        'Taking a More Detailed Look at Composr Catalogues System' => array('Catalogues', 'Content'),
        'Taking a Look at SEO on Composr' => array('SEO'),
        'Creating a Store Locator for Your Composr Website' => array('eCommerce', 'Third Party Integration'),
        'Adding Banners to Your Composr Website' => array('Banners', 'eCommerce'),
        'Adding New Page Options in Composr' => array('Structure and navigation', 'Content'),
        'Add a New Poll to Your Composr Website' => array('Social', 'Content', 'Feedback features'),
        'Add a Survey to an Composr Website' => array('Feedback features', 'Content'),
        'Sending Email Newsletters in Composr Part 2' => array('Newsletters'),
        'Sending Email Newsletters in Composr Part 1' => array('Newsletters'),
        'Setup a Private Members Forum in Composr' => array('Forum', 'Social'),
        'Add a New Zone in Composr' => array('Structure and navigation'),
        'Setup a New Usergroup in Composr' => array('Members', 'Social'),
        'Set Up Short URL’s in Composr' => array('SEO', 'Configuration'),
        'Setting Timed Content for Composr and Your Arvixe Web Hosting' => array('Content'),
        'How to Change Your Favicon and Site Logo in Composr' => array('Design & Themeing'),
        'How to Conduct an Upgrade in Composr' => array('Upgrading', 'Maintenance'),
        'Setting Up a Map of Your Composr User’s Locations' => array('Third Party Integration'),
        'Setting Up a New Composr Forum' => array('Forum', 'Social'),
        'How to Install an Addon in Composr' => array('Structure and navigation'),
        'How to Close or Open Your Composr Website' => array('Maintenance'),
        'Customising Your Composr Website’s Design' => array('Design & Themeing'),
        'How to Add an Information Block to Composr' => array('Content'),
        'Finding Your Way Around the Composr Adminzone Part 2' => array('Introduction', 'Administration'),
        'Finding Your Way Around the Composr Adminzone Part 1' => array('Introduction', 'Administration'),
        'An Introduction to Composr' => array('Introduction'),
    );

    $tag_remap = array();

    require_code('tutorials');

    $GLOBALS['NO_QUERY_LIMIT'] = true;

    $unknown_tags = array();

    $all_tags = list_tutorial_tags();

    $arvixe_tags = array('ocportal'/*LEGACY*/, 'composr');
    foreach ($arvixe_tags as $arvixe_tag) {
        $i = 1;
        do {
            $url = 'http://blog.arvixe.com/tag/' . $arvixe_tag . '/page/' . strval($i) .'/';
            $contents = http_download_file($url, null, false);

            $matches = array();
            $regexp = '#<h2 class="entry-title"><a href="([^"]*)"[^<>]*>(.*)</a></h2>.*Written by ([\w ]+?).*<div class="post-date">([^<>]*)</div>.*<div class="entry-summary">\s*<p>([^<>]*).*<div class="entry-utility">(.*)</div>#Us';
            $num_matches = preg_match_all($regexp, $contents, $matches);
            $found_links = false;
            for ($j = 0; $j < $num_matches; $j++) {
                $found_links = true;

                $url = html_entity_decode($matches[1][$j], ENT_QUOTES, get_charset());
                $title = html_entity_decode($matches[2][$j], ENT_QUOTES, get_charset());
                $author = html_entity_decode(trim($matches[3][$j]), ENT_QUOTES, get_charset());
                $add_date = strtotime(preg_replace('#^.*,(.*) \d\d \d\d.*$#', '$1', $matches[4][$j]));
                $summary = html_entity_decode($matches[5][$j], ENT_QUOTES, get_charset());

                if (substr($title, -strlen(' Released')) == ' Released' || substr($title, -strlen(' Roundup')) == ' Roundup') {
                    // Not a tutorial
                    continue;
                }

                $title = str_replace(array_keys($name_remap), array_values($name_remap), $title);
                $summary = str_replace(array_keys($name_remap), array_values($name_remap), $summary);

                $tags = isset($title_tags[$title]) ? $title_tags[$title] : array();
                $matches_tags = array();
                $regexp_tags = '#<a href="[^"]*" rel="tag">([^<>]+)</a>#Us';
                $num_matches_tags = preg_match_all($regexp_tags, $matches[6][$j], $matches_tags);
                for ($k = 0; $k < $num_matches_tags; $k++) {
                    $tag = $matches_tags[1][$k];
                    if (isset($tag_remap[$tag])) {
                        $tag = $tag_remap[$tag];
                    }
                    if (in_array($tag, $all_tags)) {
                        $tags[] = $tag;
                    } else {
                        $unknown_tags[] =$tag;
                    }
                }

                $test = $GLOBALS['SITE_DB']->query_select_value_if_there('tutorials_external', 'id', array('t_url' => $url));
                if (is_null($test)) {
                    $map = array(
                        't_url' => $url,
                        't_title' => $title,
                        't_summary' => $summary,
                        't_icon' => find_tutorial_image('', $tags, true),
                        't_media_type' => 'document',
                        't_difficulty_level' => 'novice',
                        't_pinned' => 0,
                        't_author' => $author,
                        't_submitter' => $GLOBALS['FORUM_DRIVER']->get_guest_id(),
                        't_views' => 0,
                        't_add_date' => $add_date,
                        't_edit_date' => $add_date,
                    );
                    $id = $GLOBALS['SITE_DB']->query_insert('tutorials_external', $map, true);

                    foreach ($tags as $tag) {
                        $GLOBALS['SITE_DB']->query_insert('tutorials_external_tags', array(
                            't_id' => $id,
                            't_tag' => $tag,
                        ));
                    }
                }
            }

            $i++;
        } while ($found_links);
    }
}

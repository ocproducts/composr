<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

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
class addon_screenshots_test_set extends cms_test_case
{
    public function testNoUnmatchedScreenshots()
    {
        $dh = opendir(get_file_base() . '/data_custom/addon_screenshots');
        while (($f = readdir($dh)) !== false) {
            if ((substr($f, -5) != '.html') && ($f[0] != '.')) {
                $hook = preg_replace('#\..*$#', '', $f);
                $this->assertTrue(is_file(get_file_base() . '/sources_custom/hooks/systems/addon_registry/' . $hook . '.php'), 'Unrecognised addon screenshot: ' . $f);
            }
        }
        closedir($dh);
    }

    public function testNoMissingScreenshots()
    {
        $hooks = find_all_hooks('systems', 'addon_registry');
        foreach ($hooks as $hook => $place) {
            if ($place == 'sources_custom') {
                require_code('hooks/systems/addon_registry/' . $hook);
                $ob = object_factory('Hook_addon_registry_' . $hook);
                if ($ob->get_category() == 'Development') {
                    continue;
                }

                // These are defined as exceptions where we won't enforce our screenshot rule
                if (in_array($hook, array(
                    'ad_success',
                    'better_mail',
                    'calendar_from_6am',
                    'content_read_tracking',
                    'directory_protect',
                    'downloads_followup_email',
                    'extended_media_rendering',
                    'gallery_syndication',
                    'group_points',
                    'image_syndication',
                    'pointstore_to_main',
                    'psds',
                    'simplified_emails',
                    'twitter_support',
                    'usergroup_field_match',
                    'newsletter_no_members',
                    'wiki_sync',
                    'multi_domain_login',
                    'composer',
                    'less',
                ))) {
                    continue;
                }

                $exists = false;
                foreach (array('png', 'gif', 'jpg', 'jpeg') as $ext) {
                    if (is_file(get_file_base() . '/data_custom/addon_screenshots/' . $hook . '.' . $ext)) {
                        $exists = true;
                    }
                }
                $this->assertTrue($exists, 'Missing addon screenshot: ' . $hook);
            }
        }
    }
}

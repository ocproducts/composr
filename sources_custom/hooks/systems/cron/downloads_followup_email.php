<?php /*

Composr/ocProducts is free to use or incorporate this into Composr and assert any copyright.
This notification hook was created using the classifieds notification hook as a template.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  None asserted
 * @package    downloads_followup_email
 */

/**
 * Hook class.
 */
class Hook_cron_downloads_followup_email
{
    /**
     * Run function for CRON hooks. Searches for tasks to perform.
     */
    public function run()
    {
        if (!addon_installed('downloads')) {
            return;
        }
        require_lang('downloads_followup_email');

        $last = get_value('last_downloads_followup_email_send');
        $debug = false;

        // Value can be set in Commandr:
        //    2=debug output with short interval (.01 hour instead of default 24 hours) for manually running cron_bridge.php
        //    1=debug output with normal interval (default 24 hours)
        //    0=no debug output
        // In Commandr :set_value('downloads_followup_email_debug', '1');
        $debug_mode = get_value('downloads_followup_email_debug');
        if ($debug_mode != '0' && $debug_mode != '1' && $debug_mode != '2') {
            $debug_mode = '0';
        }
        if ($debug_mode == '2') {
            $cron_interval = 0.01; // Sets interval to 36 seconds
            $debug = true;
        } else {
            $cron_interval = 24.0; // This default value will be replaced with a config option in the future
            if ($debug_mode == '1') {
                $debug = true;
            }
        }

        $time = time();

        if ($debug) {
            echo "downloads_followup_email: current-timestamp / last-timestamp / difference = " . strval($time) . " / $last / " . float_to_raw_string(round((($time - intval($last)) / 60 / 60), 2)) . " hours\n";
        }
        if ($debug) {
            echo "downloads_followup_email: debug_mode = $debug_mode\n";
        }
        if ($debug) {
            echo "downloads_followup_email: cron_interval = " . float_to_raw_string($cron_interval) . " hours\n";
        }

        /*
        If we just installed, reinstalled after uninstalling more than 2 days ago, or if cron stopped
        working for more than 2 days we will not generate emails for downloads prior to the previous
        48 hours to prevent sending stale notifications for download actions that are not recent.
        */
        if ((is_null($last)) || (intval($last) < $time - 60 * 60 * 48)) {
            $last = strval($time - 60 * 60 * 48);
        }

        if (intval($last) > intval($time - 60 * 60 * $cron_interval)) {
            return; // Don't do more than once per $cron_interval (default is 24 hours)
        }

        if (php_function_allowed('set_time_limit')) {
            set_time_limit(0);
        }

        // Set the templates names to use. Use CUSTOM template if it exists, else use the default template.
        $theme = 'default';
        if (find_template_place('DOWNLOADS_FOLLOWUP_EMAIL_CUSTOM', null, $theme, '.tpl', 'templates') === null) {
            $mail_template = 'DOWNLOADS_FOLLOWUP_EMAIL';
        } else {
            $mail_template = 'DOWNLOADS_FOLLOWUP_EMAIL_CUSTOM';
        }
        if (find_template_place('DOWNLOADS_FOLLOWUP_EMAIL_CUSTOM', null, $theme, '.tpl', 'templates') === null) {
            $download_list_template = 'DOWNLOADS_FOLLOWUP_EMAIL_DOWNLOAD_LIST';
        } else {
            $download_list_template = 'DOWNLOADS_FOLLOWUP_EMAIL_DOWNLOAD_LIST_CUSTOM';
        }

        // Get all distinct member id's (except for guest) from download_logging table where the date_and_time is newer than the last runtime of this hook (or last 48 hours if hook hasn't been run recently)
        $query = "SELECT DISTINCT member_id FROM " . $GLOBALS['SITE_DB']->get_table_prefix() . "download_logging WHERE member_id>1 AND date_and_time>" . $last;
        if ($debug) {
            echo "downloads_followup_email: distinct user query = $query\n";
        }
        $member_ids = $GLOBALS['SITE_DB']->query($query);

        // For each distinct member id, send a download follow-up notification
        foreach ($member_ids as $id) {
            // Create template object to hold download list
            $download_list = new Tempcode();
            $member_id = $GLOBALS['FORUM_DRIVER']->get_guest_id();
            $member_name = 'Guest';
            $member_id = $id['member_id'];
            $member_name = $GLOBALS['FORUM_DRIVER']->get_username($member_id);
            $lang = get_lang($member_id);
            $zone = get_module_zone('downloads');
            $count = 0;

            if ($debug) {
                echo "downloads_followup_email: preparing notification to ID #" . strval($member_id) . " ($member_name) language=$lang\n";
            }

            // Do a query to get list of download IDs the current member ID has downloaded since last run and place them in a content variable
            $query = "SELECT * FROM " . $GLOBALS['SITE_DB']->get_table_prefix() . "download_logging WHERE member_id=" . strval($member_id) . " AND date_and_time>" . $last;
            if ($debug) {
                echo "downloads_followup_email: download IDs query = $query\n";
            }
            $downloads = $GLOBALS['SITE_DB']->query($query);
            foreach ($downloads as $download) {
                // Do a query to get download names and generate links
                $the_download = $GLOBALS['SITE_DB']->query_select('download_downloads', array('*'), array('id' => $download['id']), '', 1);
                $root = get_param_integer('root', db_get_first_id(), true);
                $map = array('page' => 'downloads', 'type' => 'entry', 'id' => $download['id'], 'root' => ($root == db_get_first_id()) ? null : $root);
                $the_download_url = static_evaluate_tempcode(build_url($map, $zone));
                $name = get_translated_text($the_download[0]['name']);

                if ($debug) {
                    echo "downloads_followup_email: download query = $query\n";
                }
                if ($debug) {
                    echo "downloads_followup_email: download name / download filename / download url = " . $name . " / " . $the_download[0]['original_filename'] . " / $the_download_url\n";
                }

                $download_list->attach(do_template($download_list_template, array('DOWNLOAD_NAME' => $name, 'DOWNLOAD_FILENAME' => $the_download[0]['original_filename'], 'DOWNLOAD_URL' => $the_download_url)));
                $count++;
            }
            $s = ''; // Can be used to pluralise the word download in the subject line in the language .ini file if we have more than one download (better than using download(s))
            if ($count > 1) {
                $s = 's';
            }
            $subject_line = do_lang('SUBJECT_DOWNLOADS_FOLLOWUP_EMAIL', get_site_name(), $member_name, $s, $lang, false);
            // Pass download count, download list, and member ID to template.
            $message = static_evaluate_tempcode(do_notification_template($mail_template, array('MEMBER_ID' => strval($member_id), 'DOWNLOAD_LIST' => $download_list, 'DOWNLOAD_COUNT' => strval($count))));

            if ($debug) {
                echo "downloads_followup_email: sending notification (if user allows download followup notifications) to ID #" . strval($member_id) . " ($member_name)\n";
            }
            if ($debug) {
                echo "downloads_followup_email: notifications enabled = " . (notifications_enabled('downloads_followup_email', null, $member_id) ? 'true' : 'false') . "\n";
            }

            // Send actual notification
            dispatch_notification('downloads_followup_email', '', $subject_line, $message, array($member_id), A_FROM_SYSTEM_PRIVILEGED);
        }

        set_value('last_downloads_followup_email_send', strval($time));
    }
}

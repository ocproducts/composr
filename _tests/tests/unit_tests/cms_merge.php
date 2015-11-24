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
class cms_merge_test_set extends cms_test_case
{
    public function testFullTableCoverage()
    {
        $non_core_tables = array(
            'activities',
            'addons',
            'addons_dependencies',
            'addons_files',
            'adminlogs',
            'autosave',
            'bank',
            'blocks',
            'bookable',
            'bookable_blacked',
            'bookable_blacked_for',
            'bookable_codes',
            'bookable_supplement',
            'bookable_supplement_for',
            'booking',
            'booking_supplement',
            'calendar_jobs',
            'captchas',
            'chat_active',
            'chat_events',
            'chat_messages',
            'classifieds_prices',
            'community_billboard',
            'credit_purchases',
            'cron_caching_requests',
            'digestives_consumed',
            'digestives_tin',
            'diseases',
            'edit_pings',
            'feature_lifetime_monitor',
            'f_group_join_log',
            'f_moderator_logs',
            'f_password_history',
            'f_post_history',
            'f_special_pt_access',
            'failedlogins',
            'hackattack',
            'import_parts_done',
            'import_session',
            'incoming_uploads',
            'iotd',
            'ip_country',
            'link_tracker',
            'locations',
            'logged',
            'logged_mail_messages',
            'values_elective',
            'mayfeature',
            'members_diseases',
            'members_gifts',
            'members_mentors',
            'member_tracking',
            'messages_to_render',
            'modules',
            'newsletter_drip_send',
            'commandrchat',
            'giftr',
            'privilege_list',
            'quiz_member_last_visit',
            'referees_qualified_for',
            'referrer_override',
            'credit_charge_log',
            'email_bounces',
            'reported_content',
            'searches_logged',
            'sessions',
            'shopping_logging',
            'sites_advert_pings',
            'sites_deletion_codes',
            'sites_email',
            'sms_log',
            'staff_tips_dismissed',
            'task_queue',
            'temp_block_permissions',
            'test_sections',
            'translate_history',
            'trans_expecting',
            'tutorial_links',
            'url_id_monikers',
            'urls_checked',
            'webstandards_checked_once',
            'video_transcoding',
            'workflows',
            'workflow_content',
            'workflow_content_status',
            'workflow_permissions',
            'workflow_approval_points',
            'tutorials_external',
            'tutorials_external_tags',
            'tutorials_internal',
            'w_attempts',
            'w_attempts',
            'w_inventory',
            'w_itemdef',
            'w_items',
            'w_members',
            'w_messages',
            'w_portals',
            'w_realms',
            'w_rooms',
            'w_travelhistory',

            // You should process orders before importing
            'shopping_cart',
            'shopping_order',
            'shopping_order_addresses',
            'shopping_order_details',

            // These are imported, but the test can't detect it
            'catalogue_efv_float',
            'catalogue_efv_integer',

            // We don't import these, the copy is not the exact equivalent to the original so should identify differently
            'alternative_ids',
        );

        $c = file_get_contents(get_file_base() . '/sources/hooks/modules/admin_import/cms_merge.php');

        $tables = $GLOBALS['SITE_DB']->query_select('db_meta', array('DISTINCT m_table'));
        foreach ($tables as $table) {
            if ((!in_array($table['m_table'], $non_core_tables)) && (strpos($table['m_table'], 'cache') === false)) {
                $this->assertTrue(strpos($c, $table['m_table']) !== false, 'No import defined for ' . $table['m_table']);
            }
        }
    }
}

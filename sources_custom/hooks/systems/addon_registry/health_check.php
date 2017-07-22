<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    health_check
 */

/**
 * Hook class.
 */
class Hook_addon_registry_health_check
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
        return 'New Features';
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
        return array();
    }

    /**
     * Get the addon licence (one-line summary only)
     *
     * @return string The licence
     */
    public function get_licence()
    {
        return 'Licensed on the same terms as Composr';
    }

    /**
     * Get the description of the addon
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'TODO';
    }

    /**
     * Get a list of tutorials that apply to this addon
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array(
            'tut_security',
            'tut_configuration',
            'tut_adv_configuration',
            'tut_markup',
            'tut_seo',
            'tut_email',
            'tut_optimisation',
            'tut_fringe',
            'tut_metadata',
            'tut_cookies',
            'tut_accessibility',
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
            'requires' => array(),
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
        return 'themes/default/images_custom/icons/48x48/menu/adminzone/tools/health_check.png';
    }

    /**
     * Get a list of files that belong to this addon
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources_custom/hooks/systems/addon_registry/health_check.php',
            'lang_custom/EN/health_check.ini',
            'sources_custom/hooks/systems/health_checks/.htaccess',
            'sources_custom/hooks/systems/health_checks/index.html',
            'sources_custom/hooks/systems/health_checks/install_environment.php',
            'sources_custom/hooks/systems/health_checks/cron.php',
            'sources_custom/hooks/systems/health_checks/domains.php',
            'sources_custom/hooks/systems/health_checks/email.php',
            'sources_custom/hooks/systems/health_checks/email_newsletter.php',
            'sources_custom/hooks/systems/health_checks/index.html',
            'sources_custom/hooks/systems/health_checks/integrity.php',
            'sources_custom/hooks/systems/health_checks/marketing.php',
            'sources_custom/hooks/systems/health_checks/marketing_seo.php',
            'sources_custom/hooks/systems/health_checks/marketing_seo_robotstxt.php',
            'sources_custom/hooks/systems/health_checks/mistakes_build.php',
            'sources_custom/hooks/systems/health_checks/mistakes_deploy.php',
            'sources_custom/hooks/systems/health_checks/mistakes_user_ux.php',
            'sources_custom/hooks/systems/health_checks/network.php',
            'sources_custom/hooks/systems/health_checks/performance.php',
            'sources_custom/hooks/systems/health_checks/performance_bloat.php',
            'sources_custom/hooks/systems/health_checks/performance_server.php',
            'sources_custom/hooks/systems/health_checks/security.php',
            'sources_custom/hooks/systems/health_checks/security_hackattack.php',
            'sources_custom/hooks/systems/health_checks/security_ssl.php',
            'sources_custom/hooks/systems/health_checks/stability.php',
            'sources_custom/hooks/systems/health_checks/upkeep.php',
            'sources_custom/hooks/systems/health_checks/upkeep_backups.php',
            'themes/default/images_custom/icons/24x24/menu/adminzone/tools/health_check.png',
            'themes/default/images_custom/icons/24x24/menu/adminzone/tools/index.html',
            'themes/default/images_custom/icons/48x48/menu/adminzone/tools/health_check.png',
            'themes/default/images_custom/icons/48x48/menu/adminzone/tools/index.html',
            'sources_custom/health_check.php',
            'sources_custom/hooks/systems/config/hc_admin_stale_threshold.php',
            'sources_custom/hooks/systems/config/hc_compound_requests_per_second_threshold.php',
            'sources_custom/hooks/systems/config/hc_compound_requests_window_size.php',
            'sources_custom/hooks/systems/config/hc_cpu_pct_threshold.php',
            'sources_custom/hooks/systems/config/hc_cron_threshold.php',
            'sources_custom/hooks/systems/config/hc_disk_space_threshold.php',
            'sources_custom/hooks/systems/config/hc_error_log_day_flood_threshold.php',
            'sources_custom/hooks/systems/config/hc_google_safe_browsing_api_key.php',
            'sources_custom/hooks/systems/config/hc_io_pct_threshold.php',
            'sources_custom/hooks/systems/config/hc_mail_address.php',
            'sources_custom/hooks/systems/config/hc_mail_password.php',
            'sources_custom/hooks/systems/config/hc_mail_server.php',
            'sources_custom/hooks/systems/config/hc_mail_server_port.php',
            'sources_custom/hooks/systems/config/hc_mail_server_type.php',
            'sources_custom/hooks/systems/config/hc_mail_username.php',
            'sources_custom/hooks/systems/config/hc_mail_wait_time.php',
            'sources_custom/hooks/systems/config/hc_page_size_threshold.php',
            'sources_custom/hooks/systems/config/hc_page_speed_threshold.php',
            'sources_custom/hooks/systems/config/hc_process_hang_threshold.php',
            'sources_custom/hooks/systems/config/hc_processes_to_monitor.php',
            'sources_custom/hooks/systems/config/hc_ram_threshold.php',
            'sources_custom/hooks/systems/config/hc_requests_per_second_threshold.php',
            'sources_custom/hooks/systems/config/hc_requests_window_size.php',
            'sources_custom/hooks/systems/config/hc_scan_page_links.php',
            'sources_custom/hooks/systems/config/hc_transfer_latency_threshold.php',
            'sources_custom/hooks/systems/config/hc_uptime_threshold.php',
            'sources_custom/hooks/systems/config/hc_cron_notify_regardless.php',
            'sources_custom/hooks/systems/config/hc_cron_regularity.php',
            'sources_custom/hooks/systems/config/hc_cron_sections_to_run.php',
            'sources_custom/hooks/systems/config/hc_is_test_site.php',
            'sources_custom/hooks/systems/cron/health_check.php',
            'sources_custom/hooks/systems/notifications/health_check.php',
        );
    }
}

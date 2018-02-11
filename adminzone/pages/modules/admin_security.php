<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    securitylogging
 */

/**
 * Module page class.
 */
class Module_admin_security
{
    /**
     * Find details of the module.
     *
     * @return ?array Map of module info (null: module is disabled)
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 5;
        $info['update_require_upgrade'] = true;
        $info['locked'] = true;
        return $info;
    }

    /**
     * Uninstall the module.
     */
    public function uninstall()
    {
        $GLOBALS['SITE_DB']->drop_table_if_exists('hackattack');
    }

    /**
     * Install the module.
     *
     * @param  ?integer $upgrade_from What version we're upgrading from (null: new install)
     * @param  ?integer $upgrade_from_hack What hack version we're upgrading from (null: new-install/not-upgrading-from-a-hacked-version)
     */
    public function install($upgrade_from = null, $upgrade_from_hack = null)
    {
        if ($upgrade_from === null) {
            $GLOBALS['SITE_DB']->create_table('hackattack', array(
                'id' => '*AUTO',
                'url' => 'URLPATH',
                'data_post' => 'LONG_TEXT',
                'user_agent' => 'SHORT_TEXT',
                'referer' => 'SHORT_TEXT',
                'user_os' => 'SHORT_TEXT',
                'member_id' => 'MEMBER',
                'date_and_time' => 'TIME',
                'ip' => 'IP',
                'reason' => 'ID_TEXT',
                'reason_param_a' => 'SHORT_TEXT',
                'reason_param_b' => 'SHORT_TEXT',
                'percentage_score' => 'INTEGER',
            ));
            $GLOBALS['SITE_DB']->create_index('hackattack', 'otherhacksby', array('ip'));
            $GLOBALS['SITE_DB']->create_index('hackattack', 'h_date_and_time', array('date_and_time'));
        }

        if (($upgrade_from !== null) && ($upgrade_from < 3)) { // LEGACY
            $GLOBALS['SITE_DB']->add_table_field('hackattack', 'user_agent', 'SHORT_TEXT');
            $GLOBALS['SITE_DB']->add_table_field('hackattack', 'referer', 'SHORT_TEXT');
            $GLOBALS['SITE_DB']->add_table_field('hackattack', 'user_os', 'SHORT_TEXT');
        }

        if (($upgrade_from !== null) && ($upgrade_from < 4)) { // LEGACY
            $GLOBALS['SITE_DB']->alter_table_field('hackattack', 'the_user', 'MEMBER', 'member_id');
        }

        if (($upgrade_from !== null) && ($upgrade_from < 5)) { // LEGACY
            $GLOBALS['SITE_DB']->add_table_field('hackattack', 'percentage_score', 'INTEGER', 100);
        }
    }

    /**
     * Find entry-points available within this module.
     *
     * @param  boolean $check_perms Whether to check permissions
     * @param  ?MEMBER $member_id The member to check permissions as (null: current user)
     * @param  boolean $support_crosslinks Whether to allow cross links to other modules (identifiable via a full-page-link rather than a screen-name)
     * @param  boolean $be_deferential Whether to avoid any entry-point (or even return null to disable the page in the Sitemap) if we know another module, or page_group, is going to link to that entry-point. Note that "!" and "browse" entry points are automatically merged with container page nodes (likely called by page-groupings) as appropriate.
     * @return ?array A map of entry points (screen-name=>language-code/string or screen-name=>[language-code/string, icon-theme-image]) (null: disabled)
     */
    public function get_entry_points($check_perms = true, $member_id = null, $support_crosslinks = true, $be_deferential = false)
    {
        return array(
            'browse' => array('SECURITY_LOG', 'menu/adminzone/audit/security_log'),
        );
    }

    public $title;
    public $id;
    public $row;

    /**
     * Module pre-run function. Allows us to know metadata for <head> before we start streaming output.
     *
     * @return ?Tempcode Tempcode indicating some kind of exceptional output (null: none)
     */
    public function pre_run()
    {
        $type = get_param_string('type', 'browse');

        require_lang('security');

        set_helper_panel_tutorial('tut_security');

        if ($type == 'browse') {
            inform_non_canonical_parameter('alert_sort');
            inform_non_canonical_parameter('failed_sort');

            $this->title = get_screen_title('SECURITY_LOG');
        }

        if ($type == 'clean') {
            $this->title = get_screen_title('SECURITY_LOG');
        }

        if ($type == 'view') {
            breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('SECURITY_LOG'))));

            $id = get_param_integer('id');
            $rows = $GLOBALS['SITE_DB']->query_select('hackattack', array('*'), array('id' => $id), '', 1);
            $row = $rows[0];

            $date = get_timezoned_date_time($row['date_and_time']);

            $this->title = get_screen_title('VIEW_ALERT', true, array(escape_html($date)));

            $this->id = $id;
            $this->row = $row;
        }

        return null;
    }

    /**
     * Execute the module.
     *
     * @return Tempcode The result of execution
     */
    public function run()
    {
        require_code('lookup');
        require_all_lang();

        $type = get_param_string('type', 'browse');

        if ($type == 'browse') {
            return $this->security_interface();
        }
        if ($type == 'clean') {
            return $this->clean_alerts();
        }
        if ($type == 'view') {
            return $this->alert_view();
        }

        return new Tempcode();
    }

    /**
     * The UI to view security logs.
     *
     * @return Tempcode The UI
     */
    public function security_interface()
    {
        // Failed logins...

        $start = get_param_integer('failed_start', 0);
        $max = get_param_integer('failed_max', 50);

        $sortables = array('date_and_time' => do_lang_tempcode('DATE_TIME'), 'ip' => do_lang_tempcode('IP_ADDRESS'));
        $test = explode(' ', get_param_string('failed_sort', 'date_and_time DESC', INPUT_FILTER_GET_COMPLEX));
        if (count($test) == 1) {
            $test[1] = 'DESC';
        }
        list($_sortable, $sort_order) = $test;
        if (((strtoupper($sort_order) != 'ASC') && (strtoupper($sort_order) != 'DESC')) || (!array_key_exists($_sortable, $sortables))) {
            log_hack_attack_and_exit('ORDERBY_HACK');
        }

        require_code('templates_results_table');

        $header_row = results_header_row(array(do_lang_tempcode('USERNAME'), do_lang_tempcode('DATE_TIME'), do_lang_tempcode('RISK'), do_lang_tempcode('IP_ADDRESS')), $sortables, 'failed_sort', $_sortable . ' ' . $sort_order);

        $member_id = post_param_integer('member_id', null);
        $map = ($member_id !== null) ? array('failed_account' => $GLOBALS['FORUM_DRIVER']->get_username($member_id, false, USERNAME_DEFAULT_NULL)) : null;

        $max_rows = $GLOBALS['SITE_DB']->query_select_value('failedlogins', 'COUNT(*)', $map);

        $rows = $GLOBALS['SITE_DB']->query_select('failedlogins', array('*'), $map, 'ORDER BY ' . $_sortable . ' ' . $sort_order, $max, $start);

        $result_entries = new Tempcode();
        foreach ($rows as $row) {
            $date = get_timezoned_date_time($row['date_and_time']);
            $lookup_url = build_url(array('page' => 'admin_lookup', 'param' => $row['ip']), '_SELF');
            $result_entries->attach(results_entry(array($row['failed_account'], $date, hyperlink($lookup_url, $row['ip'], false, true)), true));
        }

        $failed_logins = results_table(do_lang_tempcode('FAILED_LOGINS'), $start, 'failed_start', $max, 'failed_max', $max_rows, $header_row, $result_entries, $sortables, $_sortable, $sort_order, 'failed_sort', new Tempcode());

        // Hack-attacks...

        $member_id = post_param_integer('member_id', null);
        $map = ($member_id !== null) ? array('member_id' => $member_id) : null;
        list($alerts, $num_alerts) = find_security_alerts($map);

        // Render UI...

        $post_url = build_url(array('page' => '_SELF', 'type' => 'clean', 'start' => $start, 'max' => $max), '_SELF');

        $tpl = do_template('SECURITY_SCREEN', array(
            '_GUID' => 'e0b5e6557686b2320a8ce8166df07328',
            'TITLE' => $this->title,
            'FAILED_LOGINS' => $failed_logins,
            'NUM_FAILED_LOGINS' => strval(count($rows)),
            'ALERTS' => $alerts,
            'NUM_ALERTS' => strval($num_alerts),
            'URL' => $post_url,
        ));

        require_code('templates_internalise_screen');
        return internalise_own_screen($tpl);
    }

    /**
     * Actualiser to delete some unwanted alerts.
     *
     * @return Tempcode The success/redirect screen
     */
    public function clean_alerts()
    {
        // Actualiser
        $count = 0;
        foreach (array_keys($_REQUEST) as $key) {
            if (substr($key, 0, 4) == 'del_') {
                $GLOBALS['SITE_DB']->query_delete('hackattack', array('id' => intval(substr($key, 4))), '', 1);
                $count++;
            }
        }

        if ($count == 0) {
            warn_exit(do_lang_tempcode('NOTHING_SELECTED'));
        }

        // Redirect
        $url = build_url(array('page' => '_SELF', 'type' => 'browse', 'start' => get_param_integer('start'), 'max' => get_param_integer('max')), '_SELF');
        return redirect_screen($this->title, $url, do_lang_tempcode('SUCCESS'));
    }

    /**
     * The UI to view a security alert.
     *
     * @return Tempcode The UI
     */
    public function alert_view()
    {
        $id = $this->id;
        $row = $this->row;

        $lookup_url = build_url(array('page' => 'admin_lookup', 'param' => $row['ip']), '_SELF');
        $member_url = build_url(array('page' => 'admin_lookup', 'param' => $row['member_id']), '_SELF');
        $reason = do_lang($row['reason'], $row['reason_param_a'], $row['reason_param_b']);

        $post = with_whitespace(unixify_line_format($row['data_post']));

        $username = $GLOBALS['FORUM_DRIVER']->get_username($row['member_id']);

        return do_template('SECURITY_ALERT_SCREEN', array(
            '_GUID' => '6c5543151af09c79bf204bea5df61dde',
            'TITLE' => $this->title,
            'USER_AGENT' => $row['user_agent'],
            'REFERER' => $row['referer'],
            'USER_OS' => $row['user_os'],
            'REASON' => $reason,
            'IP' => hyperlink($lookup_url, $row['ip'], false, true),
            'USERNAME' => hyperlink($member_url, $username, false, true),
            'POST' => $post,
            'URL' => $row['url'],
            'PERCENTAGE_SCORE' => integer_format($row['percentage_score']),
        ));
    }
}

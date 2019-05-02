<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    realtime_rain
 */

/**
 * Module page class.
 */
class Module_admin_realtime_rain
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
        $info['version'] = 1;
        $info['locked'] = false;
        return $info;
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
        if (!addon_installed('realtime_rain')) {
            return null;
        }

        return array(
            '!' => array('_REALTIME_RAIN', 'menu/adminzone/audit/realtime_rain'),
        );
    }

    public $title;

    /**
     * Module pre-run function. Allows us to know metadata for <head> before we start streaming output.
     *
     * @return ?Tempcode Tempcode indicating some kind of exceptional output (null: none)
     */
    public function pre_run()
    {
        $error_msg = new Tempcode();
        if (!addon_installed__messaged('realtime_rain', $error_msg)) {
            return $error_msg;
        }

        if (!addon_installed('stats')) {
            warn_exit(do_lang_tempcode('MISSING_ADDON', escape_html('stats')));
        }

        $type = get_param_string('type', 'browse');

        require_lang('realtime_rain');

        $this->title = get_screen_title('REALTIME_RAIN');

        return null;
    }

    /**
     * Execute the module.
     *
     * @return Tempcode The result of execution
     */
    public function run()
    {
        require_javascript('realtime_rain');
        require_css('realtime_rain');

        $min_time = $GLOBALS['SITE_DB']->query_select_value('stats', 'MIN(date_and_time)');
        if ($min_time === null) {
            $min_time = time();
        }
        return do_template('REALTIME_RAIN_OVERLAY', array('_GUID' => 'd7cb1b8286311a9505c3de2d1b9a5185', 'MIN_TIME' => strval($min_time)));
    }
}

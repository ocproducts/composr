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
 * @package    robots_txt
 */

/**
 * Module page class.
 */
class Module_admin_robots_txt
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
        if (!addon_installed('robots_txt')) {
            return null;
        }

        return array(
            '!' => array('ROBOTS_TXT', 'spare/seo'),
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
        if (!addon_installed__messaged('robots_txt', $error_msg)) {
            return $error_msg;
        }

        $type = get_param_string('type', 'browse');

        require_lang('robots_txt');

        require_javascript('core_form_interfaces');
        require_javascript('robots_txt');

        $this->title = get_screen_title('ROBOTS_TXT');

        set_helper_panel_tutorial('tut_seo');
        set_helper_panel_text(comcode_lang_string('DOC_ROBOTS_TXT'));

        return null;
    }

    /**
     * Execute the module.
     *
     * @return Tempcode The result of execution
     */
    public function run()
    {
        require_code('robots_txt');

        $type = get_param_string('type', 'browse');

        if ($type == 'browse') {
            return $this->robots_txt();
        }
        if ($type == '_robots_txt') {
            return $this->_robots_txt();
        }

        return new Tempcode();
    }

    /**
     * The UI to edit the robots.txt file.
     *
     * @return Tempcode The UI
     */
    public function robots_txt()
    {
        $post_url = build_url(array('page' => '_SELF', 'type' => '_robots_txt'), '_SELF');

        $path = find_robots_txt_path();

        return do_template('ROBOTS_TXT_SCREEN', array(
            '_GUID' => '656f56149832d459bce72ca63a1578b9',
            'TITLE' => $this->title,
            'POST_URL' => $post_url,
            'TEXT' => file_exists($path) ? cms_file_get_contents_safe($path) : '',
            'DEFAULT' => get_robots_txt(),
        ));
    }

    /**
     * The UI actualiser edit the robots.txt file.
     *
     * @return Tempcode The UI
     */
    public function _robots_txt()
    {
        require_code('input_filter_2');
        if (get_value('disable_modsecurity_workaround') !== '1') {
            modsecurity_workaround_enable();
        }

        require_code('files');
        $path = find_robots_txt_path();
        $robots_txt = post_param_string('robots_txt', '');

        $robots_txt_msg = null;
        $success = create_robots_txt($robots_txt, $robots_txt_msg, true);
        if (!$success) {
            warn_exit(protect_from_escaping($robots_txt_msg));
        }

        log_it('ROBOTS_TXT');

        return inform_screen($this->title, do_lang_tempcode('SUCCESS'));
    }
}
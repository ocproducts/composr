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
 * @package    core_cns
 */

/**
 * Module page class.
 */
class Module_join
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
        $info['version'] = 2;
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
        if (get_forum_type() != 'cns') {
            return null;
        }
        if ($check_perms && !is_guest($member_id)) {
            return null;
        }

        return array(
            'browse' => array('_JOIN', 'menu/site_meta/user_actions/join'),
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
        $type = get_param_string('type', 'browse');

        require_lang('cns');

        inform_non_canonical_parameter('_lead_source_description');

        $this->title = get_screen_title('__JOIN', true, array(escape_html(get_site_name())));

        if ($type == 'browse') {
            breadcrumb_set_self(do_lang_tempcode('_JOIN'));
        }

        if ($type == 'step2') {
            breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('_JOIN'))));
            breadcrumb_set_self(do_lang_tempcode('DETAILS'));
        }

        if ($type == 'step3') {
            breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('_JOIN'))));
            breadcrumb_set_self(do_lang_tempcode('DONE'));
        }

        if ($type == 'step4') {
            breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('_JOIN'))));
            breadcrumb_set_self(do_lang_tempcode('DONE'));
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
        require_code('cns_join');

        cns_require_all_forum_stuff();

        $type = get_param_string('type', 'browse');

        if ($type == 'browse') {
            check_joining_allowed();
            return (get_option('show_first_join_page') != '1') ? $this->step2() : $this->step1();
        }
        if ($type == 'step2') {
            return $this->step2();
        }
        if ($type == 'step3') {
            return $this->step3();
        }
        if ($type == 'step4') {
            return $this->step4();
        }

        return new Tempcode();
    }

    /**
     * The UI to accept the rules of joining.
     *
     * @return Tempcode The UI
     */
    public function step1()
    {
        if (!is_guest()) {
            warn_exit(do_lang_tempcode('NO_JOIN_LOGGED_IN'));
        }

        // Show rules
        $rules = request_page('_rules', true, get_comcode_zone('_rules'), null, true);
        $map = array('page' => '_SELF', 'type' => 'step2');
        $email_address = trim(get_param_string('email_address', '', INPUT_FILTER_GET_COMPLEX));
        if ($email_address != '') {
            $map['email_address'] = $email_address;
        }
        $redirect = get_param_string('redirect', '', INPUT_FILTER_URL_INTERNAL);
        if ($redirect != '') {
            $map['redirect'] = protect_url_parameter($redirect);
        }
        $url = build_url($map, '_SELF');

        $group_select = new Tempcode();
        $rows = $GLOBALS['FORUM_DB']->query_select('f_groups', array('id', 'g_name', 'g_is_default'), array('g_is_presented_at_install' => 1), 'ORDER BY g_order,' . $GLOBALS['FORUM_DB']->translate_field_ref('g_name'));
        if (count($rows) > 1) {
            foreach ($rows as $group) {
                if (get_param_integer('usergroup', null) === null) {
                    $selected = $group['g_is_default'] == 1;
                } else {
                    $selected = $group['id'] == get_param_integer('usergroup');
                }
                $group_select->attach(form_input_list_entry(strval($group['id']), $selected, get_translated_text($group['g_name'], $GLOBALS['FORUM_DB'])));
            }
        }

        $hidden = new Tempcode();
        $_lead_source_description = either_param_string('_lead_source_description', do_lang('JOINED'));
        if ($_lead_source_description != '') {
            $hidden->attach(form_input_hidden('_lead_source_description', $_lead_source_description));
        }

        return do_template('CNS_JOIN_STEP1_SCREEN', array('_GUID' => '3776e89f3b18e4bd9dd532defe6b1e9e', 'TITLE' => $this->title, 'RULES' => $rules, 'URL' => $url, 'GROUP_SELECT' => $group_select, 'HIDDEN' => $hidden));
    }

    /**
     * The UI to enter profile details.
     *
     * @return Tempcode The UI
     */
    public function step2()
    {
        if (!is_guest()) {
            warn_exit(do_lang_tempcode('NO_JOIN_LOGGED_IN'));
        }

        if ((get_option('show_first_join_page') == '1') && (post_param_integer('confirm', 0) != 1)) {
            warn_exit(do_lang_tempcode('DESCRIPTION_I_AGREE_RULES'));
        }

        $map = array('page' => '_SELF', 'type' => 'step3');
        $redirect = get_param_string('redirect', '', INPUT_FILTER_URL_INTERNAL);
        if ($redirect != '') {
            $map['redirect'] = protect_url_parameter($redirect);
        }
        $url = build_url($map, '_SELF');

        $form = cns_join_form($url);

        return do_template('CNS_JOIN_STEP2_SCREEN', array('_GUID' => '5879db5cf331526a999371f76868233d', 'TITLE' => $this->title, 'FORM' => $form));
    }

    /**
     * The actualiser for joining.
     *
     * @return Tempcode The UI
     */
    public function step3()
    {
        if ((get_option('show_first_join_page') == '1') && (post_param_integer('confirm', 0) != 1)) {
            warn_exit(do_lang_tempcode('DESCRIPTION_I_AGREE_RULES'));
        }

        list($message) = cns_join_actual();

        return inform_screen($this->title, $message);
    }

    /**
     * The actualiser for setting up account confirmation.
     *
     * @return Tempcode The UI
     */
    public function step4()
    {
        // Check confirm code correct
        $_code = get_param_string('code', '-1'); // -1 allowed because people often seem to mess the e-mail link up
        $code = intval($_code);
        if ($code <= 0) {
            require_code('form_templates');
            $fields = new Tempcode();
            $fields->attach(form_input_email(do_lang_tempcode('EMAIL_ADDRESS'), '', 'email', '', true));
            $fields->attach(form_input_integer(do_lang_tempcode('CODE'), '', 'code', null, true));
            $submit_name = do_lang_tempcode('PROCEED');
            return do_template('FORM_SCREEN', array(
                '_GUID' => 'e2c8c3762a308ac7489ec3fb32cc0cf8',
                'TITLE' => $this->title,
                'GET' => true,
                'SKIP_WEBSTANDARDS' => true,
                'HIDDEN' => '',
                'URL' => get_self_url(false, false, array(), false, true),
                'FIELDS' => $fields,
                'TEXT' => do_lang_tempcode('MISSING_CONFIRM_CODE'),
                'SUBMIT_ICON' => 'buttons/proceed',
                'SUBMIT_NAME' => $submit_name,
            ));
        }
        $rows = $GLOBALS['FORUM_DB']->query_select('f_members', array('id', 'm_validated'), array('m_validated_email_confirm_code' => strval($code), 'm_email_address' => trim(get_param_string('email', false, INPUT_FILTER_GET_COMPLEX))));
        if (!array_key_exists(0, $rows)) {
            $rows = $GLOBALS['FORUM_DB']->query_select('f_members', array('id', 'm_validated'), array('m_validated_email_confirm_code' => '', 'm_email_address' => trim(get_param_string('email', false, INPUT_FILTER_GET_COMPLEX))));
            if (!array_key_exists(0, $rows)) {
                warn_exit(do_lang_tempcode('INCORRECT_CONFIRM_CODE'));
            } else {
                $redirect = get_param_string('redirect', '', INPUT_FILTER_URL_INTERNAL);
                $map = array('page' => 'login', 'type' => 'browse');
                if ($redirect != '') {
                    $map['redirect'] = protect_url_parameter($redirect);
                }
                $url = build_url($map, get_module_zone('login'));
                return redirect_screen($this->title, $url, do_lang_tempcode('ALREADY_CONFIRMED_THIS'));
            }
        }
        $id = $rows[0]['id'];
        $validated = $rows[0]['m_validated'];

        // Activate user
        $GLOBALS['FORUM_DB']->query_update('f_members', array('m_validated_email_confirm_code' => ''), array('id' => $id), '', 1);

        delete_cache_entry('main_members');

        if ($validated == 0) {
            return inform_screen($this->title, do_lang_tempcode('AWAITING_MEMBER_VALIDATION'));
        }

        // Alert user to situation
        $map = array('page' => 'login', 'type' => 'browse');
        $page_after_join = get_option('page_after_join');
        if ($page_after_join == '') {
            $redirect = get_param_string('redirect', '', INPUT_FILTER_URL_INTERNAL);
            if ($redirect != '') {
                $map['redirect'] = protect_url_parameter($redirect);
            }
        } else {
            if (strpos($page_after_join, ':') === false) {
                $zone = get_page_zone($page_after_join, false);
                if ($zone === null) {
                    $zone = 'site';
                }
                $map['redirect'] = protect_url_parameter(build_url(array('page' => $page_after_join), $zone));
            } else {
                $map['redirect'] = protect_url_parameter(page_link_to_url($page_after_join));
            }
        }
        $url = build_url($map, get_module_zone('login'));
        return redirect_screen($this->title, $url, do_lang_tempcode('SUCCESSFUL_CONFIRM'));
    }
}

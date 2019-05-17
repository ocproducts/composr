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
class Module_members
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

        $ret = array(
            'browse' => array('MEMBER_DIRECTORY', 'menu/social/members'),
        );
        if (!$check_perms || !is_guest($member_id)) {
            $ret['view'] = array('MY_PROFILE', 'menu/social/profile');
        }
        return $ret;
    }

    public $title;
    public $username;
    public $member_id_of;

    /**
     * Module pre-run function. Allows us to know metadata for <head> before we start streaming output.
     *
     * @return ?Tempcode Tempcode indicating some kind of exceptional output (null: none)
     */
    public function pre_run()
    {
        if (get_forum_type() != 'cns') {
            warn_exit(do_lang_tempcode('NO_CNS'));
        }

        require_code('form_templates'); // Needs to run high so that the anti-click-hacking header is sent

        $type = get_param_string('type', 'browse');

        cns_require_all_forum_stuff();

        require_css('cns');
        require_lang('cns');

        if ($type == 'browse') {
            $this->title = get_screen_title('MEMBER_DIRECTORY');

            require_css('cns_member_directory');
        }

        if ($type == 'view') {
            $username = get_param_string('id', strval(get_member()));
            if ($username == '') {
                $username = strval(get_member());
            }
            if (is_numeric($username)) {
                $member_id_of = get_param_integer('id', get_member());
                if (is_guest($member_id_of)) {
                    if (is_guest()) {
                        access_denied('NOT_AS_GUEST');
                    } else {
                        warn_exit(do_lang_tempcode('MEMBER_NO_EXIST'));
                    }
                }
                $username = $GLOBALS['FORUM_DRIVER']->get_member_row_field($member_id_of, 'm_username');
                if (($username === null) || (is_guest($member_id_of))) {
                    warn_exit(do_lang_tempcode('MEMBER_NO_EXIST'));
                }
            } else {
                $member_id_of = $GLOBALS['FORUM_DRIVER']->get_member_from_username($username);
                if ($member_id_of === null) {
                    set_http_status_code(404);
                    warn_exit(do_lang_tempcode('_MEMBER_NO_EXIST', escape_html($username)));
                }
                if (is_guest($member_id_of)) {
                    if (is_guest()) {
                        access_denied('NOT_AS_GUEST');
                    } else {
                        warn_exit(do_lang_tempcode('MEMBER_NO_EXIST'));
                    }
                }
            }

            $join_time = $GLOBALS['FORUM_DRIVER']->get_member_row_field($member_id_of, 'm_join_time');

            $privacy_ok = true;
            if (addon_installed('content_privacy')) {
                require_code('content_privacy');
                $privacy_ok = has_privacy_access('_photo', strval($member_id_of), get_member());
            }

            $photo_url = $GLOBALS['FORUM_DRIVER']->get_member_photo_url($member_id_of, true);
            $photo_thumb_url = $GLOBALS['FORUM_DRIVER']->get_member_photo_url($member_id_of);

            $avatar_url = $GLOBALS['FORUM_DRIVER']->get_member_avatar_url($member_id_of);

            $member_row = $GLOBALS['FORUM_DRIVER']->get_member_row($member_id_of);

            set_extra_request_metadata(array(
                'identifier' => '_SEARCH:members:view:' . strval($member_id_of),
                'image' => (($avatar_url == '') && (has_privilege(get_member(), 'view_member_photos'))) ? $photo_url : $avatar_url,
            ), $member_row, 'member', strval($member_id_of));

            breadcrumb_set_parents(array(array('_SELF:_SELF:browse' . propagate_filtercode_page_link(), do_lang_tempcode('MEMBERS'))));

            if ((get_value('disable_awards_in_titles') !== '1') && (addon_installed('awards'))) {
                require_code('awards');
                $awards = find_awards_for('member', strval($member_id_of));
            } else {
                $awards = array();
            }

            //$this->title = get_screen_title('MEMBER_ACCOUNT', true, array(make_fractionable_editable('member', $member_id_of, $username)), null, $awards);
            $displayname = $GLOBALS['FORUM_DRIVER']->get_username($member_id_of, true);
            $username = $GLOBALS['FORUM_DRIVER']->get_username($member_id_of);
            $this->title = get_screen_title('MEMBER_ACCOUNT', true, array(escape_html($displayname), escape_html($username)), null, $awards);

            $this->member_id_of = $member_id_of;
            $this->username = $username;

            require_css('cns_member_profiles');
        }

        if ($type == 'unsub') {
            $this->title = get_screen_title('newsletter:NEWSLETTER_UNSUBSCRIBED');
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
        $type = get_param_string('type', 'browse');

        if ($type == 'browse') {
            return $this->directory();
        }
        if ($type == 'view') {
            return $this->profile();
        }
        if ($type == 'unsub') {
            return $this->newsletter_unsubscribe();
        }

        return new Tempcode();
    }

    /**
     * The UI to show the member directory.
     *
     * @return Tempcode The UI
     */
    public function directory()
    {
        $tpl = do_template('CNS_MEMBER_DIRECTORY_SCREEN', array(
            '_GUID' => '096767e9aaabce9cb3e6591b7bcf95b8',
            'TITLE' => $this->title,
        ));

        require_code('templates_internalise_screen');
        return internalise_own_screen($tpl);
    }

    /**
     * The UI to show a member's profile.
     *
     * @return Tempcode The UI
     */
    public function profile()
    {
        disable_php_memory_limit();

        require_code('cns_profiles');
        return render_profile_tabset($this->title, $this->member_id_of, get_member(), $this->username);
    }

    /**
     * The actualiser for unsubscribing from the newsletter.
     *
     * @return Tempcode The UI
     */
    public function newsletter_unsubscribe()
    {
        $id = get_param_integer('id');
        $hash = get_param_string('hash');

        $_subscriber = $GLOBALS['FORUM_DB']->query_select('f_members', array('*'), array('id' => $id), '', 1);
        if (!array_key_exists(0, $_subscriber)) {
            fatal_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }
        $subscriber = $_subscriber[0];

        require_code('crypt');
        $needed_hash = ratchet_hash($subscriber['m_pass_hash_salted'], 'xunsub');

        if ($hash != $needed_hash) {
            warn_exit(do_lang_tempcode('COULD_NOT_UNSUBSCRIBE'));
        }

        $GLOBALS['FORUM_DB']->query_update('f_members', array('m_allow_emails_from_staff' => 0), array('id' => $id), '', 1);

        if (addon_installed('newsletter')) {
            $GLOBALS['SITE_DB']->query_delete('newsletter_subscribe', array('email' => $_subscriber['m_email_address']));
        }

        return inform_screen($this->title, do_lang_tempcode('newsletter:MEMBER_NEWSLETTER_UNSUBSCRIBED', escape_html(get_site_name())));
    }
}

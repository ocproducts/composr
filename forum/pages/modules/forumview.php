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
 * @package    cns_forum
 */

/**
 * Module page class.
 */
class Module_forumview
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
        if (!addon_installed('cns_forum')) {
            return null;
        }

        if (get_forum_type() != 'cns') {
            return null;
        }

        $ret = array(
            '!' => array('ROOT_FORUM', 'menu/social/forum/forums'),
        );

        if ($support_crosslinks) {
            $ret += array(
                '_SEARCH:vforums' => array('VIRTUAL_FORUMS', 'menu/social/forum/vforums/unread_topics'),
            );
        }

        return $ret;
    }

    public $title;
    public $id;
    public $forum_info;
    public $breadcrumbs;
    public $of_member_id;

    /**
     * Module pre-run function. Allows us to know metadata for <head> before we start streaming output.
     *
     * @return ?Tempcode Tempcode indicating some kind of exceptional output (null: none)
     */
    public function pre_run()
    {
        $error_msg = new Tempcode();
        if (!addon_installed__messaged('cns_forum', $error_msg)) {
            return $error_msg;
        }

        if (get_forum_type() != 'cns') {
            warn_exit(do_lang_tempcode('NO_CNS'));
        }

        $type = get_param_string('type', 'browse');

        cns_require_all_forum_stuff();

        require_lang('cns');

        inform_non_canonical_parameter('#^kfs_.*$#');

        if ($type == 'browse') {
            $id = get_param_integer('id', db_get_first_id());

            $_forum_info = $GLOBALS['FORUM_DB']->query_select('f_forums', array('*'), array('id' => $id), '', 1, 0, false);
            if (!array_key_exists(0, $_forum_info)) {
                warn_exit(do_lang_tempcode('MISSING_RESOURCE', 'forum'));
            }
            $forum_info = $_forum_info[0];

            $description_text = get_translated_text($forum_info['f_description'], $GLOBALS['FORUM_DB']);

            set_extra_request_metadata(array(
                'identifier' => '_SEARCH:forumview:browse:' . strval($id),
            ), $forum_info, 'forum', strval($id));

            if ((get_value('disable_awards_in_titles') !== '1') && (addon_installed('awards'))) {
                require_code('awards');
                $awards = ($id === null) ? array() : find_awards_for('forum', strval($id));
            } else {
                $awards = array();
            }

            $forum_name = $forum_info['f_name'];
            $ltitle = do_lang_tempcode('NAMED_FORUM', make_fractionable_editable('forum', $id, $forum_name));

            $this->title = get_screen_title($ltitle, false, array(), null, $awards);

            if (($forum_info['f_redirection'] != '') && (looks_like_url($forum_info['f_redirection']))) {
                require_code('site2');
                redirect_exit($forum_info['f_redirection']);
            }

            set_short_title($forum_name);

            $this->id = $id;
            $this->forum_info = $forum_info;

            set_feed_url('?mode=cns_forumview&select=' . strval($id));

            require_code('cns_forums');
            $breadcrumbs = cns_forum_breadcrumbs($id, $forum_name, $forum_info['f_parent_forum']);
            breadcrumb_set_parents($breadcrumbs);
            $this->breadcrumbs = breadcrumb_segments_to_tempcode($breadcrumbs);
        }

        if ($type == 'pt') {
            $this->title = get_screen_title('PRIVATE_TOPICS');

            $root = get_param_integer('keep_forum_root', db_get_first_id());
            $root_forum_name = $GLOBALS['FORUM_DB']->query_select_value('f_forums', 'f_name', array('id' => $root));
            $breadcrumbs = array();
            $breadcrumbs[] = array(build_page_link(array('page' => '_SELF', 'id' => ($root == db_get_first_id()) ? null : $root), '_SELF'), $root_forum_name);
            $of_member_id = get_param_integer('id', get_member());
            $pt_username = $GLOBALS['FORUM_DRIVER']->get_username($of_member_id);
            $pt_displayname = $GLOBALS['FORUM_DRIVER']->get_username($of_member_id, true);
            $breadcrumbs[] = array('', do_lang_tempcode('PRIVATE_TOPICS_OF', escape_html($pt_displayname), escape_html($pt_username)));
            $this->breadcrumbs = breadcrumb_segments_to_tempcode($breadcrumbs);
            $this->of_member_id = $of_member_id;
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
        require_code('cns_forumview');

        $type = get_param_string('type', 'browse');

        $current_filter_cat = get_param_string('category', '');

        $root = get_param_integer('keep_forum_root', db_get_first_id());

        if ($type == 'pt') { // Not used anymore by default, but code still here
            $id = null;
            $forum_info = array();
            $compound_name = 'kfs';
            $of_member_id = $this->of_member_id;
            $sort_default = 'first_post';
        } else {
            $id = $this->id;
            $forum_info = $this->forum_info;
            $compound_name = 'kfs' . strval($id);
            $of_member_id = null;
            $sort_default = $forum_info['f_order'];
        }

        require_code('cns_general');
        cns_set_context_forum($id);

        require_code('templates_pagination');
        list($max, $start, $sort, $sql_sup, $sql_sup_order_by, $true_start, , $keyset_field_stripped) = get_keyset_pagination_settings('forum_max', intval(get_option('forum_topics_per_page')), 'forum_start', $compound_name, 'sort', $sort_default, 'get_forum_sort_order');

        $test = cns_render_forumview($id, $forum_info, $current_filter_cat, $max, $start, $true_start, get_param_string('order', 'last_post'), $sql_sup, $sql_sup_order_by, $keyset_field_stripped, $root, $of_member_id, $this->breadcrumbs);
        if (is_array($test)) {
            list($content, $forum_name) = $test;
        } else {
            return $test;
        }

        // Members viewing this forum
        if ($id === null) {
            list($num_guests, $num_members, $members_viewing) = array(null, null, null);
        } else {
            require_code('users2');
            list($num_guests, $num_members, $members_viewing) = get_members_viewing_wrap('forumview', '', strval($id), true);
        }

        $tpl = do_template('CNS_FORUM_SCREEN', array(
            '_GUID' => '9e9fd9110effd8a92b7a839a4fea60c5',
            'TITLE' => $this->title,
            'CONTENT' => $content,
            'ID' => ($id === null) ? '' : strval($id),
            'NUM_GUESTS' => ($num_guests === null) ? '' : integer_format($num_guests),
            'NUM_MEMBERS' => ($num_members === null) ? '' : integer_format($num_members),
            'MEMBERS_VIEWING' => $members_viewing,
        ));

        require_code('templates_internalise_screen');
        return internalise_own_screen($tpl);
    }
}

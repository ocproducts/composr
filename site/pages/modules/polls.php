<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    polls
 */

/**
 * Module page class.
 */
class Module_polls
{
    /**
     * Find details of the module.
     *
     * @return ?array Map of module info (null: module is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 6;
        $info['update_require_upgrade'] = true;
        $info['locked'] = false;
        return $info;
    }

    /**
     * Uninstall the module.
     */
    public function uninstall()
    {
        $GLOBALS['SITE_DB']->drop_table_if_exists('poll');
        $GLOBALS['SITE_DB']->drop_table_if_exists('poll_votes');

        delete_privilege('choose_poll');

        delete_privilege('autocomplete_keyword_poll');
        delete_privilege('autocomplete_title_poll');

        $GLOBALS['SITE_DB']->query_delete('trackbacks', array('trackback_for_type' => 'polls'));

        $GLOBALS['FORUM_DRIVER']->install_delete_custom_field('points_gained_voting');
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
            $GLOBALS['SITE_DB']->create_table('poll', array(
                'id' => '*AUTO',
                'question' => 'SHORT_TRANS__COMCODE',
                'option1' => 'SHORT_TRANS__COMCODE',
                'option2' => 'SHORT_TRANS__COMCODE',
                'option3' => '?SHORT_TRANS__COMCODE',
                'option4' => '?SHORT_TRANS__COMCODE',
                'option5' => '?SHORT_TRANS__COMCODE',
                'option6' => '?SHORT_TRANS__COMCODE',
                'option7' => '?SHORT_TRANS__COMCODE',
                'option8' => '?SHORT_TRANS__COMCODE',
                'option9' => '?SHORT_TRANS__COMCODE',
                'option10' => '?SHORT_TRANS__COMCODE',
                'votes1' => 'INTEGER',
                'votes2' => 'INTEGER',
                'votes3' => 'INTEGER',
                'votes4' => 'INTEGER',
                'votes5' => 'INTEGER',
                'votes6' => 'INTEGER',
                'votes7' => 'INTEGER',
                'votes8' => 'INTEGER',
                'votes9' => 'INTEGER',
                'votes10' => 'INTEGER',
                'allow_rating' => 'BINARY',
                'allow_comments' => 'SHORT_INTEGER',
                'allow_trackbacks' => 'BINARY',
                'notes' => 'LONG_TEXT',
                'num_options' => 'SHORT_INTEGER',
                'is_current' => 'BINARY',
                'date_and_time' => '?TIME',
                'submitter' => 'MEMBER',
                'add_time' => 'INTEGER',
                'poll_views' => 'INTEGER',
                'edit_date' => '?TIME'
            ));

            $GLOBALS['SITE_DB']->create_index('poll', 'poll_views', array('poll_views'));
            $GLOBALS['SITE_DB']->create_index('poll', 'get_current', array('is_current'));
            $GLOBALS['SITE_DB']->create_index('poll', 'ps', array('submitter'));
            $GLOBALS['SITE_DB']->create_index('poll', 'padd_time', array('add_time'));
            $GLOBALS['SITE_DB']->create_index('poll', 'date_and_time', array('date_and_time'));

            add_privilege('POLLS', 'choose_poll', false);

            $GLOBALS['SITE_DB']->create_index('poll', 'ftjoin_pq', array('question'));
            $GLOBALS['SITE_DB']->create_index('poll', 'ftjoin_po1', array('option1'));
            $GLOBALS['SITE_DB']->create_index('poll', 'ftjoin_po2', array('option2'));
            $GLOBALS['SITE_DB']->create_index('poll', 'ftjoin_po3', array('option3'));
            $GLOBALS['SITE_DB']->create_index('poll', 'ftjoin_po4', array('option4'));
            $GLOBALS['SITE_DB']->create_index('poll', 'ftjoin_po5', array('option5'));

            $GLOBALS['FORUM_DRIVER']->install_create_custom_field('points_gained_voting', 20, 1, 0, 0, 0, '', 'integer');
        }

        if (($upgrade_from === null) || ($upgrade_from < 5)) {
            $GLOBALS['SITE_DB']->create_table('poll_votes', array(
                'id' => '*AUTO',
                'v_poll_id' => 'AUTO_LINK',
                'v_voter_id' => '?MEMBER',
                'v_voter_ip' => 'IP',
                'v_vote_for' => '?SHORT_INTEGER',
            ));

            $GLOBALS['SITE_DB']->create_index('poll_votes', 'v_voter_id', array('v_voter_id'));
            $GLOBALS['SITE_DB']->create_index('poll_votes', 'v_voter_ip', array('v_voter_ip'));
            $GLOBALS['SITE_DB']->create_index('poll_votes', 'v_vote_for', array('v_vote_for'));
        }

        if (($upgrade_from !== null) && ($upgrade_from < 5)) {
            $polls = $GLOBALS['SITE_DB']->query_select('poll', array('id', 'ip'));
            foreach ($polls as $poll) {
                $voters = explode('-', $poll['ip']);
                foreach ($voters as $voter) {
                    $GLOBALS['SITE_DB']->query_insert('poll_votes', array(
                        'v_poll_id' => $poll['id'],
                        'v_voter_id' => is_numeric($voter) ? intval($voter) : null,
                        'v_voter_ip' => is_numeric($voter) ? '' : $voter,
                        'v_vote_for' => null,
                    ));
                }
            }
            $GLOBALS['SITE_DB']->delete_table_field('poll', 'ip');
        }

        if (($upgrade_from !== null) && ($upgrade_from < 6)) {
            $GLOBALS['SITE_DB']->alter_table_field('poll', 'option6', '?SHORT_TRANS__COMCODE');
            $GLOBALS['SITE_DB']->alter_table_field('poll', 'option7', '?SHORT_TRANS__COMCODE');
        }

        if (($upgrade_from === null) || ($upgrade_from < 6)) {
            $GLOBALS['SITE_DB']->create_index('poll', '#poll_search__combined', array('question', 'option1', 'option2', 'option3', 'option4', 'option5'));

            add_privilege('SEARCH', 'autocomplete_keyword_poll', false);
            add_privilege('SEARCH', 'autocomplete_title_poll', false);
        }
    }

    /**
     * Find entry-points available within this module.
     *
     * @param  boolean $check_perms Whether to check permissions.
     * @param  ?MEMBER $member_id The member to check permissions as (null: current user).
     * @param  boolean $support_crosslinks Whether to allow cross links to other modules (identifiable via a full-page-link rather than a screen-name).
     * @param  boolean $be_deferential Whether to avoid any entry-point (or even return null to disable the page in the Sitemap) if we know another module, or page_group, is going to link to that entry-point. Note that "!" and "browse" entry points are automatically merged with container page nodes (likely called by page-groupings) as appropriate.
     * @return ?array A map of entry points (screen-name=>language-code/string or screen-name=>[language-code/string, icon-theme-image]) (null: disabled).
     */
    public function get_entry_points($check_perms = true, $member_id = null, $support_crosslinks = true, $be_deferential = false)
    {
        return array(
            'browse' => array('POLLS', 'menu/social/polls'),
        );
    }

    public $title;
    public $id;
    public $myrow;
    public $_title;

    /**
     * Module pre-run function. Allows us to know metadata for <head> before we start streaming output.
     *
     * @return ?Tempcode Tempcode indicating some kind of exceptional output (null: none).
     */
    public function pre_run()
    {
        $type = get_param_string('type', 'browse');

        require_lang('polls');

        if ($type == 'browse') {
            $this->title = get_screen_title('POLL_ARCHIVE');
        }

        if ($type == 'view') {
            set_feed_url('?mode=polls&select=');

            $id = get_param_integer('id');

            // Breadcrumbs
            breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('POLL_ARCHIVE'))));

            // Load data
            $rows = $GLOBALS['SITE_DB']->query_select('poll', array('*'), array('id' => $id), '', 1);
            if (!array_key_exists(0, $rows)) {
                return warn_screen($this->title, do_lang_tempcode('MISSING_RESOURCE', 'poll'));
            }
            $myrow = $rows[0];
            $_title = get_translated_text($myrow['question']);

            // Metadata
            set_extra_request_metadata(array(
                'identifier' => '_SEARCH:polls:view:' . strval($id),
            ), $myrow, 'poll', strval($id));

            $this->title = get_screen_title('POLL');

            $this->id = $id;
            $this->myrow = $myrow;
            $this->_title = $_title;
        }

        return null;
    }

    /**
     * Execute the module.
     *
     * @return Tempcode The result of execution.
     */
    public function run()
    {
        require_code('feedback');
        require_code('polls');
        require_css('polls');

        // What are we doing?
        $type = get_param_string('type', 'browse');

        if ($type == 'browse') {
            return $this->view_polls();
        }
        if ($type == 'view') {
            return $this->view();
        }

        return new Tempcode();
    }

    /**
     * The UI to view a list of polls.
     *
     * @return Tempcode The UI
     */
    public function view_polls()
    {
        $content = do_block('main_multi_content', array('param' => 'poll', 'efficient' => '0', 'zone' => '_SELF', 'sort' => 'recent', 'max' => '20', 'no_links' => '1', 'pagination' => '1', 'give_context' => '0', 'include_breadcrumbs' => '0', 'block_id' => 'module', 'guid' => 'module'));

        return do_template('PAGINATION_SCREEN', array('_GUID' => 'bed3e31c98b35fea52a991e381e6cfaa', 'TITLE' => $this->title, 'CONTENT' => $content));
    }

    /**
     * The UI to view a poll.
     *
     * @return Tempcode The UI
     */
    public function view()
    {
        $id = $this->id;
        $myrow = $this->myrow;
        $_title = $this->_title;

        $date_raw = ($myrow['date_and_time'] === null) ? '' : strval($myrow['date_and_time']);
        $add_date_raw = strval($myrow['add_time']);
        $edit_date_raw = ($myrow['edit_date'] === null) ? '' : strval($myrow['edit_date']);
        $date = get_timezoned_date_time($myrow['date_and_time']);
        $add_date = get_timezoned_date_time($myrow['add_time']);
        $edit_date = get_timezoned_date_time($myrow['edit_date']);

        // Views
        if ((get_db_type() != 'xml') && (get_value('no_view_counts') !== '1') && (get_bot_type() === null)) {
            $myrow['poll_views']++;
            if (!$GLOBALS['SITE_DB']->table_is_locked('poll')) {
                $GLOBALS['SITE_DB']->query_update('poll', array('poll_views' => $myrow['poll_views']), array('id' => $id), '', 1, null, false, true);
                persistent_cache_delete('POLL');
            }
        }

        // Feedback
        list($rating_details, $comment_details, $trackback_details) = embed_feedback_systems(
            get_page_name(),
            strval($id),
            $myrow['allow_rating'],
            $myrow['allow_comments'],
            $myrow['allow_trackbacks'],
            ($myrow['date_and_time'] === null) ? 0 : 1,
            $myrow['submitter'],
            build_url(array('page' => '_SELF', 'type' => 'view', 'id' => $id), '_SELF', null, false, false, true),
            $_title,
            find_overridden_comment_forum('polls'),
            $myrow['add_time']
        );

        // Management links
        if ((has_actual_page_access(null, 'cms_polls', null, null)) && (has_edit_permission('high', get_member(), $myrow['submitter'], 'cms_polls'))) {
            $edit_url = build_url(array('page' => 'cms_polls', 'type' => '_edit', 'id' => $id), get_module_zone('cms_polls'));
        } else {
            $edit_url = new Tempcode();
        }

        // Load poll
        $poll_details = do_block('main_poll', array('param' => strval($id)));

        // Render
        return do_template('POLL_SCREEN', array(
            '_GUID' => '1463a42354c3ad154e2c6bb0c96be3b9',
            'TITLE' => $this->title,
            'SUBMITTER' => strval($myrow['submitter']),
            'ID' => strval($id),
            'DATE_RAW' => $date_raw,
            'ADD_DATE_RAW' => $add_date_raw,
            'EDIT_DATE_RAW' => $edit_date_raw,
            'DATE' => $date,
            'ADD_DATE' => $add_date,
            'EDIT_DATE' => $edit_date,
            'VIEWS' => integer_format($myrow['poll_views']),
            'TRACKBACK_DETAILS' => $trackback_details,
            'RATING_DETAILS' => $rating_details,
            'COMMENT_DETAILS' => $comment_details,
            'EDIT_URL' => $edit_url,
            'POLL_DETAILS' => $poll_details,
        ));
    }
}

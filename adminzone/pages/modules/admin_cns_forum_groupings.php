<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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

require_code('crud_module');
require_javascript('cns_forum');

/**
 * Module page class.
 */
class Module_admin_cns_forum_groupings extends Standard_crud_module
{
    protected $lang_type = 'FORUM_GROUPING';
    protected $select_name = 'TITLE';
    protected $archive_entry_point = '_SEARCH:forumview';
    protected $archive_label = 'SECTION_FORUMS';
    protected $extra_donext_whatever = null;
    protected $extra_donext_whatever_title = '';
    protected $do_next_editing_categories = true;
    protected $menu_label = 'SECTION_FORUMS';
    protected $orderer = 'c_title';
    protected $title_is_multi_lang = false;
    protected $donext_entry_content_type = 'forum_grouping';
    protected $donext_category_content_type = null;
    protected $do_preview = null;

    public $js_function_calls = array('moduleAdminCnsForumGroupings');

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

        if ($be_deferential || $support_crosslinks) {
            return null;
        }

        $ret = array(
            'browse' => array('FORUM_GROUPINGS', 'admin/view_this_category'),
            'add' => array('ADD_' . $this->lang_type, 'admin/add'),
            'edit' => array(do_lang_tempcode('menus:ITEMS_HERE', do_lang_tempcode('EDIT_FORUM_GROUPING'), make_string_tempcode(escape_html(integer_format($GLOBALS['FORUM_DB']->query_select_value('f_forum_groupings', 'COUNT(*)'))))), 'admin/view_this_category'),
        ) + parent::get_entry_points();

        return $ret;
    }

    public $title;

    /**
     * Module pre-run function. Allows us to know metadata for <head> before we start streaming output.
     *
     * @param  boolean $top_level Whether this is running at the top level, prior to having sub-objects called
     * @param  ?ID_TEXT $type The screen type to consider for metadata purposes (null: read from environment)
     * @return ?Tempcode Tempcode indicating some kind of exceptional output (null: none)
     */
    public function pre_run($top_level = true, $type = null)
    {
        $error_msg = new Tempcode();
        if (!addon_installed__messaged('cns_forum', $error_msg)) {
            return $error_msg;
        }

        if (get_forum_type() != 'cns') {
            warn_exit(do_lang_tempcode('NO_CNS'));
        }

        $type = get_param_string('type', 'browse');

        require_lang('cns');
        require_css('cns_admin');

        set_helper_panel_tutorial('tut_forums');

        breadcrumb_set_parents(array(array('_SEARCH:admin_cns_forums:browse', do_lang_tempcode('SECTION_FORUMS'))));

        return parent::pre_run($top_level);
    }

    /**
     * Standard crud_module run_start.
     *
     * @return Tempcode The output of the run
     */
    public function run_start()
    {
        $this->extra_donext_whatever_title = do_lang('SECTION_FORUMS');
        $this->extra_donext_whatever = array(
            array('admin/add', array('admin_cns_forums', array('type' => 'add'), get_module_zone('admin_cns_forums')), do_lang_tempcode('ADD_FORUM')),
            array('admin/edit', array('admin_cns_forums', array('type' => 'edit'), get_module_zone('admin_cns_forums')), do_lang_tempcode('EDIT_FORUM')),
        );

        $this->add_one_cat_label = do_lang_tempcode('ADD_FORUM_GROUPING');
        $this->edit_this_cat_label = do_lang_tempcode('EDIT_THIS_FORUM_GROUPING');
        $this->edit_one_cat_label = do_lang_tempcode('EDIT_FORUM_GROUPING');
        $this->categories_title = do_lang_tempcode('FORUM_GROUPINGS');

        cns_require_all_forum_stuff();

        require_code('cns_forums_action');
        require_code('cns_forums_action2');
        require_code('cns_forums2');

        return new Tempcode();
    }

    /**
     * Get Tempcode for a forum grouping template adding/editing form.
     *
     * @param  SHORT_TEXT $title The title (name) of the forum grouping
     * @param  LONG_TEXT $description The description for the forum grouping
     * @param  BINARY $expanded_by_default Whether the forum grouping is expanded by default when shown in the forum view
     * @return array A pair: The input fields, Hidden fields
     */
    public function get_form_fields($title = '', $description = '', $expanded_by_default = 1)
    {
        $fields = new Tempcode();
        $fields->attach(form_input_line(do_lang_tempcode('TITLE'), do_lang_tempcode('DESCRIPTION_TITLE'), 'title', $title, true));
        $fields->attach(form_input_line(do_lang_tempcode('DESCRIPTION'), do_lang_tempcode('DESCRIPTION_DESCRIPTION'), 'description', $description, false));
        $fields->attach(form_input_tick(do_lang_tempcode('EXPANDED_BY_DEFAULT'), do_lang_tempcode('DESCRIPTION_EXPANDED_BY_DEFAULT'), 'expanded_by_default', $expanded_by_default == 1));

        return array($fields, new Tempcode());
    }

    /**
     * Standard crud_module table function.
     *
     * @param  array $url_map Details to go to build_url for link to the next screen
     * @return array A quartet: The choose table, Whether re-ordering is supported from this screen, Search URL, Archive URL
     */
    public function create_selection_list_choose_table($url_map)
    {
        require_code('templates_results_table');

        $current_ordering = get_param_string('sort', 'c_title ASC', INPUT_FILTER_GET_COMPLEX);
        if (strpos($current_ordering, ' ') === false) {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }
        list($sortable, $sort_order) = explode(' ', $current_ordering, 2);
        $sortables = array(
            'c_title' => do_lang_tempcode('TITLE'),
        );
        if (((strtoupper($sort_order) != 'ASC') && (strtoupper($sort_order) != 'DESC')) || (!array_key_exists($sortable, $sortables))) {
            log_hack_attack_and_exit('ORDERBY_HACK');
        }

        $header_row = results_header_row(array(
            do_lang_tempcode('TITLE'),
            do_lang_tempcode('EXPANDED_BY_DEFAULT'),
            do_lang_tempcode('ACTIONS'),
        ), $sortables, 'sort', $sortable . ' ' . $sort_order);

        $result_entries = new Tempcode();

        list($rows, $max_rows) = $this->get_entry_rows(false, $current_ordering);
        foreach ($rows as $row) {
            $edit_url = build_url($url_map + array('id' => $row['id']), '_SELF');

            $result_entries->attach(results_entry(array($row['c_title'], ($row['c_expanded_by_default'] == 1) ? do_lang_tempcode('YES') : do_lang_tempcode('NO'), protect_from_escaping(hyperlink($edit_url, do_lang_tempcode('EDIT'), false, false, do_lang('EDIT') . ' #' . strval($row['id'])))), true));
        }

        $search_url = null;
        $archive_url = null;

        return array(results_table(do_lang($this->menu_label), either_param_integer('start', 0), 'start', either_param_integer('max', 20), 'max', $max_rows, $header_row, $result_entries, $sortables, $sortable, $sort_order), false, $search_url, $archive_url);
    }

    /**
     * Standard crud_module list function.
     *
     * @param  ?ID_TEXT $avoid The entry to not show (null: none to not show)
     * @return Tempcode The selection list
     */
    public function create_selection_list_entries($avoid = null)
    {
        return cns_create_selection_list_forum_groupings(intval($avoid));
    }

    /**
     * Standard crud_module edit form filler.
     *
     * @param  ID_TEXT $_id The entry being edited
     * @return array A triple: fields, hidden-fields, delete-fields
     */
    public function fill_in_edit_form($_id)
    {
        $id = intval($_id);

        $m = $GLOBALS['FORUM_DB']->query_select('f_forum_groupings', array('*'), array('id' => $id), '', 1);
        if (!array_key_exists(0, $m)) {
            warn_exit(do_lang_tempcode('MISSING_RESOURCE', 'forum_grouping'));
        }
        $r = $m[0];

        $delete_fields = new Tempcode();

        list($fields, $hidden) = $this->get_form_fields($r['c_title'], $r['c_description'], $r['c_expanded_by_default']);
        $list = cns_create_selection_list_forum_groupings($id);
        if (!$list->is_empty()) {
            $delete_fields->attach(form_input_list(do_lang_tempcode('TARGET'), do_lang_tempcode('DESCRIPTION_FORUM_MOVE_TARGET'), 'target_forum_grouping', $list));
        }

        return array($fields, $hidden, $delete_fields);
    }

    /**
     * Standard crud_module delete possibility checker.
     *
     * @param  ID_TEXT $id The entry being potentially deleted
     * @return boolean Whether it may be deleted
     */
    public function may_delete_this($id)
    {
        $count = $GLOBALS['FORUM_DB']->query_select_value('f_forum_groupings', 'COUNT(*)');
        return $count > 1;
    }

    /**
     * Standard crud_module add actualiser.
     *
     * @return ID_TEXT The entry added
     */
    public function add_actualisation()
    {
        $tmp = strval(cns_make_forum_grouping(post_param_string('title'), post_param_string('description'), post_param_integer('expanded_by_default', 0)));
        $this->extra_donext_whatever = array(
            array('admin/add', array('admin_cns_forums', array('type' => 'add', 'forum_grouping_id' => $tmp), get_module_zone('admin_cns_forums')), do_lang_tempcode('ADD_FORUM')),
            array('admin/edit', array('admin_cns_forums', array('type' => 'edit'), get_module_zone('admin_cns_forums')), do_lang_tempcode('EDIT_FORUM')),
        );
        return $tmp;
    }

    /**
     * Standard crud_module edit actualiser.
     *
     * @param  ID_TEXT $id The entry being edited
     */
    public function edit_actualisation($id)
    {
        cns_edit_forum_grouping(intval($id), post_param_string('title'), post_param_string('description', STRING_MAGIC_NULL), post_param_integer('expanded_by_default', fractional_edit() ? INTEGER_MAGIC_NULL : 0));
        $this->extra_donext_whatever = array(
            array('admin/add', array('admin_cns_forums', array('type' => 'add', 'forum_grouping_id' => $id), get_module_zone('admin_cns_forums')), do_lang_tempcode('ADD_FORUM')),
            array('admin/edit', array('admin_cns_forums', array('type' => 'edit'), get_module_zone('admin_cns_forums')), do_lang_tempcode('EDIT_FORUM')),
        );
    }

    /**
     * Standard crud_module delete actualiser.
     *
     * @param  ID_TEXT $id The entry being deleted
     */
    public function delete_actualisation($id)
    {
        cns_delete_forum_grouping(intval($id), post_param_integer('target_forum_grouping'));
    }
}

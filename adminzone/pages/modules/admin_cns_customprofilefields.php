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
 * @package    cns_cpfs
 */

require_code('crud_module');

/**
 * Module page class.
 */
class Module_admin_cns_customprofilefields extends Standard_crud_module
{
    protected $lang_type = 'CUSTOM_PROFILE_FIELD';
    protected $select_name = 'NAME';
    protected $menu_label = 'CUSTOM_PROFILE_FIELDS';
    protected $orderer = 'cf_name';
    protected $table = 'f_custom_fields';
    protected $title_is_multi_lang = true;
    protected $donext_entry_content_type = 'cpf';
    protected $donext_category_content_type = null;

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
        if (!addon_installed('cns_cpfs')) {
            return null;
        }

        if (get_forum_type() != 'cns') {
            return null;
        }

        $ret = array();

        if (!$be_deferential && !$support_crosslinks) {
            $ret += array(
                'browse' => array('CUSTOM_PROFILE_FIELDS', 'menu/adminzone/tools/users/custom_profile_fields'),
            );
        }

        $ret += array(
            'stats' => array('CUSTOM_PROFILE_FIELD_STATS', 'menu/adminzone/tools/users/custom_profile_fields'),
            'predefined_content' => array('PREDEFINED_FIELDS', 'admin/import'),
        );

        if (!$be_deferential && !$support_crosslinks) {
            $ret += parent::get_entry_points();
        }

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
        if (!addon_installed__messaged('cns_cpfs', $error_msg)) {
            return $error_msg;
        }

        if (get_forum_type() != 'cns') {
            warn_exit(do_lang_tempcode('NO_CNS'));
        }

        $type = get_param_string('type', 'browse');

        require_lang('cns');
        require_lang('cns_special_cpf');
        require_css('cns_admin');

        set_helper_panel_tutorial('tut_adv_members');

        breadcrumb_set_parents(array(array('_SEARCH:admin_cns_members:browse', do_lang_tempcode('MEMBERS'))));

        $ret = parent::pre_run($top_level);

        if ($type == 'stats') {
            breadcrumb_set_parents(array());
        }

        if ($type == '_stats') {
            breadcrumb_set_parents(array(array('_SELF:_SELF:stats', do_lang_tempcode('CUSTOM_PROFILE_FIELD_STATS'))));
        }

        if ($type == 'predefined_content') {
        }

        if ($type == '_predefined_content') {
            breadcrumb_set_parents(array(array('_SEARCH:admin_cns_members:browse', do_lang_tempcode('MEMBERS')), array('_SELF:_SELF:browse', do_lang_tempcode('CUSTOM_PROFILE_FIELDS')), array('_SELF:_SELF:predefined_content', do_lang_tempcode('PREDEFINED_FIELDS'))));
            breadcrumb_set_self(do_lang_tempcode('DONE'));
        }

        if ($type == 'stats' || $type == '_stats') {
            $this->title = get_screen_title('CUSTOM_PROFILE_FIELD_STATS');
        }

        if ($type == 'predefined_content' || $type == '_predefined_content') {
            $this->title = get_screen_title('PREDEFINED_FIELDS');
        }

        return $ret;
    }

    /**
     * Standard crud_module run_start.
     *
     * @param  ID_TEXT $type The type of module execution
     * @return Tempcode The output of the run
     */
    public function run_start($type)
    {
        cns_require_all_forum_stuff();

        require_code('cns_members_action');
        require_code('cns_members_action2');
        require_lang('fields');
        require_lang('cns_special_cpf');

        $this->add_one_label = do_lang_tempcode('ADD_CUSTOM_PROFILE_FIELD');
        $this->edit_this_label = do_lang_tempcode('EDIT_THIS_CUSTOM_PROFILE_FIELD');
        $this->edit_one_label = do_lang_tempcode('EDIT_CUSTOM_PROFILE_FIELD');

        if ($type == 'browse') {
            return $this->browse();
        }
        if ($type == 'stats') {
            return $this->stats();
        }
        if ($type == '_stats') {
            return $this->_stats();
        }
        if ($type == 'predefined_content') {
            return $this->predefined_content();
        }
        if ($type == '_predefined_content') {
            return $this->_predefined_content();
        }
        return new Tempcode();
    }

    /**
     * The do-next manager for before content management.
     *
     * @return Tempcode The UI
     */
    public function browse()
    {
        require_code('templates_donext');
        return do_next_manager(
            get_screen_title('CUSTOM_PROFILE_FIELDS'),
            comcode_lang_string('DOC_CUSTOM_PROFILE_FIELDS'),
            array(
                array('admin/add', array('_SELF', array('type' => 'add'), '_SELF'), do_lang('ADD_CUSTOM_PROFILE_FIELD')),
                array('admin/edit', array('_SELF', array('type' => 'edit'), '_SELF'), do_lang('EDIT_CUSTOM_PROFILE_FIELD')),
                array('admin/install', array('_SELF', array('type' => 'predefined_content'), '_SELF'), do_lang('PREDEFINED_FIELDS')),
            ),
            do_lang('CUSTOM_PROFILE_FIELDS')
        );
    }

    /**
     * Get Tempcode for adding/editing form.
     *
     * @param  SHORT_TEXT $name The name of the Custom Profile Field
     * @param  LONG_TEXT $description The description of the field
     * @param  LONG_TEXT $default The default value of the field
     * @param  BINARY $public_view Whether the field is publicly viewable
     * @param  BINARY $owner_view Whether the field may be viewed by the owner
     * @param  BINARY $owner_set Whether the owner may set the value of the field
     * @param  BINARY $encrypted Whether the field is encrypted
     * @param  ID_TEXT $type The type of the field
     * @set short_text long_text short_trans long_trans integer upload picture URL list tick
     * @param  BINARY $required Whether the field is required to be filled in
     * @param  BINARY $show_on_join_form Whether the field is to be shown on the join form
     * @param  BINARY $show_in_posts Whether the field is shown in posts
     * @param  BINARY $show_in_post_previews Whether the field is shown in post previews
     * @param  ?integer $order The order the field is given relative to the order of the other Custom Profile Fields (null: last)
     * @param  LONG_TEXT $only_group The usergroups that this field is confined to (comma-separated list)
     * @param  BINARY $locked Whether the field is locked
     * @param  SHORT_TEXT $options Field options
     * @param  ID_TEXT $icon Whether it is required that every member have this field filled in
     * @param  ID_TEXT $section Whether it is required that every member have this field filled in
     * @param  LONG_TEXT $tempcode Whether it is required that every member have this field filled in
     * @return array A pair: the Tempcode for the visible fields, and the Tempcode for the hidden fields
     */
    public function get_form_fields($name = '', $description = '', $default = '', $public_view = 1, $owner_view = 1, $owner_set = 1, $encrypted = 0, $type = 'long_text', $required = 0, $show_on_join_form = 0, $show_in_posts = 0, $show_in_post_previews = 0, $order = null, $only_group = '', $locked = 0, $options = '', $icon = '', $section = '', $tempcode = '')
    {
        $fields = new Tempcode();
        $hidden = new Tempcode();

        require_code('encryption');
        require_lang('fields');

        $allow_full_edit = (get_param_integer('keep_all_cpfs', 0) == 1);

        if (substr($name, 0, 4) != 'cms_' || $allow_full_edit) {
            $fields->attach(form_input_line(do_lang_tempcode('NAME'), do_lang_tempcode('DESCRIPTION_NAME'), 'name', $name, true));
        } else {
            $hidden->attach(form_input_hidden('name', $name));
            attach_message(do_lang_tempcode('INBUILT_CPF_LANG_STRING', escape_html($name)));
        }

        $fields->attach(form_input_line(do_lang_tempcode('DESCRIPTION'), do_lang_tempcode('DESCRIPTION_DESCRIPTION'), 'description', $description, false));
        $fields->attach(form_input_line(do_lang_tempcode('DEFAULT_VALUE'), do_lang_tempcode('DESCRIPTION_DEFAULT_VALUE_CPF'), 'default', $default, false, null, 10000));
        $fields->attach(form_input_tick(do_lang_tempcode('OWNER_VIEW'), do_lang_tempcode('DESCRIPTION_OWNER_VIEW'), 'owner_view', $owner_view == 1));
        $fields->attach(form_input_tick(do_lang_tempcode('OWNER_SET'), do_lang_tempcode('DESCRIPTION_OWNER_SET'), 'owner_set', $owner_set == 1));
        $fields->attach(form_input_tick(do_lang_tempcode('PUBLIC_VIEW'), do_lang_tempcode('DESCRIPTION_PUBLIC_VIEW'), 'public_view', $public_view == 1));
        if ((($locked == 0) || ($allow_full_edit)) && (is_encryption_enabled()) && ($name == '')) {
            require_lang('encryption');
            $fields->attach(form_input_tick(do_lang_tempcode('ENCRYPTED'), do_lang_tempcode('DESCRIPTION_ENCRYPTED'), 'encrypted', $encrypted == 1));
        }

        require_code('fields');
        $type_list = create_selection_list_field_type($type, $name != '');
        if ($locked == 0 || $allow_full_edit) {
            $fields->attach(form_input_list(do_lang_tempcode('TYPE'), do_lang_tempcode('DESCRIPTION_FIELD_TYPE'), 'type', $type_list));
        } else {
            $hidden->attach(form_input_hidden('type', $type));
        }
        $fields->attach(form_input_line(do_lang_tempcode('FIELD_OPTIONS'), do_lang_tempcode('DESCRIPTION_FIELD_OPTIONS', escape_html(get_tutorial_url('tut_fields'))), 'options', $options, false));

        if ($locked == 0 || $allow_full_edit) {
            $fields->attach(form_input_tick(do_lang_tempcode('REQUIRED'), do_lang_tempcode('DESCRIPTION_REQUIRED'), 'required', $required == 1));
        } else {
            $hidden->attach(form_input_hidden('required', strval($required)));
        }

        $fields->attach(form_input_tick(do_lang_tempcode('SHOW_ON_JOIN_FORM'), do_lang_tempcode('DESCRIPTION_SHOW_ON_JOIN_FORM'), 'show_on_join_form', $show_on_join_form == 1));

        $fields->attach(get_order_field('cpf', null, $order));

        $fields->attach(form_input_tick(do_lang_tempcode('SHOW_IN_POSTS'), do_lang_tempcode('DESCRIPTION_SHOW_IN_POSTS'), 'show_in_posts', $show_in_posts == 1));
        $fields->attach(form_input_tick(do_lang_tempcode('SHOW_IN_POST_PREVIEWS'), do_lang_tempcode('DESCRIPTION_SHOW_IN_POST_PREVIEWS'), 'show_in_post_previews', $show_in_post_previews == 1));

        $fields->attach(do_template('FORM_SCREEN_FIELD_SPACER', array('_GUID' => '7648f571ac21b86c2dbe82d3e8378a52', 'SECTION_HIDDEN' => $tempcode == '' && $section == '' && $icon == '', 'TITLE' => do_lang_tempcode('ADVANCED'))));

        $rows = $GLOBALS['FORUM_DB']->query_select('f_groups', array('id', 'g_name', 'g_is_super_admin'), array('g_is_private_club' => 0));
        if ($locked == 0 || $allow_full_edit) {
            $groups = new Tempcode();
            //$groups = form_input_list_entry('-1', false, do_lang_tempcode('_ALL'));
            foreach ($rows as $group) {
                if ($group['id'] != db_get_first_id()) {
                    $groups->attach(form_input_list_entry(strval($group['id']), count(array_intersect(array($group['id']), explode(',', $only_group))) != 0, get_translated_text($group['g_name'], $GLOBALS['FORUM_DB'])));
                }
            }
            $fields->attach(form_input_multi_list(do_lang_tempcode('USERGROUP'), do_lang_tempcode('DESCRIPTION_FIELD_ONLY_GROUP'), 'only_group', $groups));
        } else {
            $hidden->attach(form_input_hidden('only_group', ''));
        }

        require_code('themes2');
        $ids = get_all_image_ids_type('icons', true);
        $fields->attach(form_input_theme_image(do_lang_tempcode('IMAGE'), '', 'icon', $ids, null, $icon, null, true));

        $sections = new Tempcode();
        foreach (array('' => do_lang_tempcode('NA_EM'), 'contact' => do_lang_tempcode('menus:CONTACT')) as $_section => $section_label) {
            $sections->attach(form_input_list_entry($_section, $section == $_section, $section_label));
        }
        $fields->attach(form_input_list(do_lang_tempcode('SECTION'), do_lang_tempcode('DESCRIPTION_CPF_SECTION'), 'section', $sections, null, false, false));

        $fields->attach(form_input_line(do_lang_tempcode('CODE'), do_lang_tempcode('DESCRIPTION_CPF_CODE'), 'tempcode', $tempcode, false, null, null, 'text', null, null, null, 130));

        return array($fields, $hidden);
    }

    /**
     * Standard crud_module table function.
     *
     * @param  array $url_map Details to go to build_url for link to the next screen
     * @return array A pair: The choose table, Whether re-ordering is supported from this screen
     */
    public function create_selection_list_choose_table($url_map)
    {
        require_code('templates_results_table');
        $form_id = 'selection_table';
        $current_ordering = get_param_string('sort', 'cf_order ASC', INPUT_FILTER_GET_COMPLEX);
        if (strpos($current_ordering, ' ') === false) {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }
        list($sortable, $sort_order) = explode(' ', $current_ordering, 2);
        $sortables = array(
            'cf_name' => do_lang_tempcode('NAME'),
            'cf_owner_view' => do_lang_tempcode('OWNER_VIEW'),
            'cf_owner_set' => do_lang_tempcode('OWNER_SET'),
            'cf_public_view' => do_lang_tempcode('PUBLIC_VIEW'),
            'cf_required' => do_lang_tempcode('REQUIRED'),
            'cf_order' => do_lang_tempcode('ORDER'),
        );
        if (((strtoupper($sort_order) != 'ASC') && (strtoupper($sort_order) != 'DESC')) || (!array_key_exists($sortable, $sortables))) {
            log_hack_attack_and_exit('ORDERBY_HACK');
        }

        $num_cpfs = $GLOBALS['FORUM_DB']->query_select_value('f_custom_fields', 'COUNT(*)');

        $standard_ordering = (($current_ordering == 'cf_order ASC') && ($num_cpfs < 200));

        $fh = array(
            do_lang_tempcode('NAME'),
            do_lang_tempcode('OWNER_VIEW'),
            do_lang_tempcode('OWNER_SET'),
            do_lang_tempcode('PUBLIC_VIEW'),
            do_lang_tempcode('REQUIRED'),
        );
        $fh[] = do_lang_tempcode('SHOW_ON_JOIN_FORM');
        //$fh[]=do_lang_tempcode('SHOW_IN_POSTS'); Save space
        //$fh[]=do_lang_tempcode('SHOW_IN_POST_PREVIEWS');
        $fh[] = do_lang_tempcode('ORDER');
        $fh[] = do_lang_tempcode('ACTIONS');
        $header_row = results_header_row($fh, $sortables, 'sort', $sortable . ' ' . $sort_order);

        // Load up filters
        $hooks = find_all_hook_obs('systems', 'cns_cpf_filter', 'Hook_cns_cpf_filter_');
        $to_keep = array();
        foreach ($hooks as $ob) {
            $to_keep += $ob->to_enable();
        }

        // Normalise ordering
        if ($standard_ordering) {
            $rows = $GLOBALS['FORUM_DB']->query_select('f_custom_fields', array('id'), array(), 'ORDER BY cf_order ASC');
            foreach ($rows as $i => $row) {
                $GLOBALS['FORUM_DB']->query_update('f_custom_fields', array('cf_order' => $i), array('id' => $row['id']), '', 1);
            }
        }

        // Load rows, according to pagination
        list($rows, $max_rows) = $this->get_entry_rows(false, $current_ordering, null);

        // Save sorting changes
        if ($standard_ordering) {
            $changed = false;

            foreach ($rows as $row) {
                $new_order = post_param_integer('order_' . strval($row['id']), null);
                if ($new_order !== null) {
                    if ($new_order !== $row['cf_order']) {
                        $this->change_order($row['id'], $row['cf_order'], $new_order);
                        $changed = true;
                    }
                }
            }

            // Reload after sorting changes
            if ($changed) {
                list($rows, $max_rows) = $this->get_entry_rows(false, $current_ordering);
            }
        }

        // Render selection table
        $result_entries = new Tempcode();
        foreach ($rows as $row) {
            $name = get_translated_text($row['cf_name'], $GLOBALS['FORUM_DB']);

            $used = true;
            if ((substr($name, 0, 4) == 'cms_') && (get_param_integer('keep_all_cpfs', 0) != 1)) {
                // See if it gets filtered
                if ((!array_key_exists(substr($name, 4), $to_keep)) && (get_param_integer('edit_unused', 0) != 1)) {
                    $used = false;
                }

                $test = do_lang('SPECIAL_CPF__' . $name, null, null, null, null, false);
                if ($test !== null) {
                    $trans = $test;
                }
            }

            $edit_url = build_url($url_map + array('id' => $row['id']), '_SELF');

            $order = $row['cf_order'];
            if ($standard_ordering) {
                $order_list = '';
                $selected_one = false;
                for ($i = 0; $i < $num_cpfs; $i++) {
                    $selected = ($i === $order);
                    if ($selected) {
                        $selected_one = true;
                    }
                    $order_list .= '<option value="' . strval($i) . '"' . ($selected ? ' selected="selected"' : '') . '>' . strval($i + 1) . '</option>'; // XHTMLXHTML
                }
                if (!$selected_one) {
                    $order_list .= '<option value="' . strval($i) . '" selected="selected">' . (($order == ORDER_AUTOMATED_CRITERIA) ? do_lang('NA') : strval($order + 1)) . '</option>'; // XHTMLXHTML
                }
                $orderer = do_template('COLUMNED_TABLE_ROW_CELL_SELECT', array('_GUID' => '0c35279246e34d94fd4a41c432cdffed', 'LABEL' => do_lang_tempcode('SORT'), 'NAME' => 'order_' . strval($row['id']), 'LIST' => $order_list));
            } else {
                $orderer = make_string_tempcode('#' . escape_html($order + 1));
            }

            $fr = array();
            $fr[] = $name;
            $fr[] = ($row['cf_owner_view'] == 1) ? do_lang_tempcode('YES') : do_lang_tempcode('NO');
            $fr[] = ($row['cf_owner_set'] == 1) ? do_lang_tempcode('YES') : do_lang_tempcode('NO');
            $fr[] = ($row['cf_public_view'] == 1) ? do_lang_tempcode('YES') : do_lang_tempcode('NO');
            $fr[] = ($row['cf_required'] == 1) ? do_lang_tempcode('YES') : do_lang_tempcode('NO');
            $fr[] = ($row['cf_show_on_join_form'] == 1) ? do_lang_tempcode('YES') : do_lang_tempcode('NO');
            //$fr[]=($row['cf_show_in_posts']==1) ? do_lang_tempcode('YES') : do_lang_tempcode('NO');
            //$fr[]=($row['cf_show_in_post_previews']==1) ? do_lang_tempcode('YES') : do_lang_tempcode('NO');
            $fr[] = protect_from_escaping($orderer);
            if ($used) {
                $edit_link = hyperlink($edit_url, do_lang_tempcode('EDIT'), false, false, do_lang('EDIT') . ' #' . strval($row['id']));
            } else {
                $edit_link = do_lang_tempcode('UNUSED_CPF');
            }
            $fr[] = protect_from_escaping($edit_link);

            $result_entries->attach(results_entry($fr, true));
        }
        require_javascript('cns_cpfs');
        $this->js_function_calls_for_choose[] = array('moduleAdminCnsCustomProfileFields_createSelectionListChooseTable', $this->form_id);
        return array(results_table(do_lang($this->menu_label), get_param_integer('start', 0), 'start', either_param_integer('max', 20), 'max', $max_rows, $header_row, $result_entries, $sortables, $sortable, $sort_order, 'sort', null, array(), null, 8, 'gdfg43tfdgdfgdrfgd', true), true);
    }

    /**
     * Change the order of a Custom Profile Field.
     *
     * @param  AUTO_LINK $id The ID
     * @param  integer $old_order Old order
     * @param  integer $new_order New order
     */
    public function change_order($id, $old_order, $new_order)
    {
        $sql = 'SELECT r.id AS r_id,r.cf_order FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_custom_fields r WHERE cf_order BETWEEN ';
        $sql .= strval(min($old_order, $new_order)) . ' AND ' . strval(max($old_order, $new_order));
        $sql .= ' ORDER BY cf_order,' . $GLOBALS['FORUM_DB']->translate_field_ref('cf_name');
        $rows = $GLOBALS['FORUM_DB']->query($sql, null, 0, false, false, array('cf_name' => 'SHORT_TRANS'));

        foreach ($rows as $row) {
            if ($id == $row['r_id']) {
                $_new_order = $new_order;
            } else {
                if ($old_order < $new_order) { // Moving order of $id up
                    $_new_order = $row['cf_order'] - 1;
                } else { // Moving order of $id down
                    $_new_order = $row['cf_order'] + 1;
                }
            }

            $GLOBALS['FORUM_DB']->query_update('f_custom_fields', array('cf_order' => $_new_order), array('id' => $row['r_id']), '', 1);
        }
    }

    /**
     * Standard crud_module delete possibility checker.
     *
     * @param  ID_TEXT $_id The entry being potentially deleted
     * @return boolean Whether it may be deleted
     */
    public function may_delete_this($_id)
    {
        $id = intval($_id);
        $locked = $GLOBALS['FORUM_DB']->query_select_value('f_custom_fields', 'cf_locked', array('id' => $id));
        return ($locked == 0);
    }

    /**
     * Standard crud_module edit form filler.
     *
     * @param  ID_TEXT $id The entry being edited
     * @return array A pair: the Tempcode for the visible fields, and the Tempcode for the hidden fields
     */
    public function fill_in_edit_form($id)
    {
        $rows = $GLOBALS['FORUM_DB']->query_select('f_custom_fields', array('*'), array('id' => intval($id)));
        if (!array_key_exists(0, $rows)) {
            warn_exit(do_lang_tempcode('MISSING_RESOURCE', 'cpf'));
        }
        $myrow = $rows[0];

        $name = get_translated_text($myrow['cf_name'], $GLOBALS['FORUM_DB']);
        $description = get_translated_text($myrow['cf_description'], $GLOBALS['FORUM_DB']);
        $default = $myrow['cf_default'];
        require_code('encryption');
        $encrypted = (($myrow['cf_encrypted'] == 1) && (is_encryption_enabled()));
        $public_view = (($myrow['cf_public_view'] == 1) && (!$encrypted)) ? 1 : 0;
        $owner_view = $myrow['cf_owner_view'];
        $owner_set = $myrow['cf_owner_set'];
        $type = $myrow['cf_type'];
        $required = $myrow['cf_required'];
        $show_in_posts = $myrow['cf_show_in_posts'];
        $show_in_post_previews = $myrow['cf_show_in_post_previews'];
        $order = $myrow['cf_order'];
        $only_group = $myrow['cf_only_group'];
        if (!array_key_exists('cf_show_on_join_form', $myrow)) {
            $GLOBALS['FORUM_DB']->add_table_field('f_custom_fields', 'cf_show_on_join_form', 'BINARY', 0);
            $GLOBALS['FORUM_DB']->query('UPDATE ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_custom_fields SET cf_show_on_join_form=cf_required');
            $rows = $GLOBALS['FORUM_DB']->query_select('f_custom_fields', array('*'), array('id' => intval($id)));
            $myrow = $rows[0];
        }
        $show_on_join_form = $myrow['cf_show_on_join_form'];
        $locked = $myrow['cf_locked'];
        $options = $myrow['cf_options'];
        $icon = $myrow['cf_icon'];
        $section = $myrow['cf_section'];
        $tempcode = $myrow['cf_tempcode'];

        return $this->get_form_fields($name, $description, $default, $public_view, $owner_view, $owner_set, $encrypted, $type, $required, $show_on_join_form, $show_in_posts, $show_in_post_previews, $order, $only_group, $locked, $options, $icon, $section, $tempcode);
    }

    /**
     * Standard crud_module add actualiser.
     *
     * @return ID_TEXT The entry added
     */
    public function add_actualisation()
    {
        $only_group = array_key_exists('only_group', $_POST) ? (is_array($_POST['only_group']) ? implode(',', $_POST['only_group']) : post_param_string('only_group')) : '';
        $id = cns_make_custom_field(
            post_param_string('name'),
            0, // Locked=0
            post_param_string('description'),
            post_param_string('default'),
            post_param_integer('public_view', 0),
            post_param_integer('owner_view', 0),
            post_param_integer('owner_set', 0),
            post_param_integer('encrypted', 0),
            post_param_string('type'),
            post_param_integer('required', 0),
            post_param_integer('show_in_posts', 0),
            post_param_integer('show_in_post_previews', 0),
            post_param_order_field(),
            $only_group,
            post_param_integer('show_on_join_form', 0),
            post_param_string('options'),
            post_param_string('icon'),
            post_param_string('section'),
            post_param_string('tempcode'),
            false
        );
        return strval($id);
    }

    /**
     * Standard crud_module edit actualiser.
     *
     * @param  ID_TEXT $id The entry being edited
     */
    public function edit_actualisation($id)
    {
        $only_group = array_key_exists('only_group', $_POST) ? (is_array($_POST['only_group']) ? implode(',', $_POST['only_group']) : post_param_string('only_group')) : '';
        cns_edit_custom_field(
            intval($id),
            post_param_string('name'),
            post_param_string('description'),
            post_param_string('default'),
            post_param_integer('public_view', 0),
            post_param_integer('owner_view', 0),
            post_param_integer('owner_set', 0),
            post_param_integer('encrypted', 0),
            post_param_integer('required', 0),
            post_param_integer('show_in_posts', 0),
            post_param_integer('show_in_post_previews', 0),
            post_param_order_field(),
            $only_group,
            post_param_string('type'),
            post_param_integer('show_on_join_form', 0),
            post_param_string('options'),
            post_param_string('icon'),
            post_param_string('section'),
            post_param_string('tempcode')
        );
    }

    /**
     * Standard crud_module delete actualiser.
     *
     * @param  ID_TEXT $id The entry being deleted
     */
    public function delete_actualisation($id)
    {
        cns_delete_custom_field(intval($id));
    }

    /**
     * UI for install/uninstall of predefined content.
     *
     * @return Tempcode The UI
     */
    public function predefined_content()
    {
        $fields = _cns_predefined_custom_field_details();

        require_lang('fields');

        require_code('templates_columned_table');
        $header_row = columned_table_header_row(array(
            do_lang_tempcode('IMAGE'),
            do_lang_tempcode('NAME'),
            do_lang_tempcode('SECTION'),
            do_lang_tempcode('TYPE'),
            do_lang_tempcode('CHOOSE'),
        ));

        $_existing_fields = $GLOBALS['FORUM_DB']->query_select('f_custom_fields', array('id', 'cf_name'));
        $existing_fields = array();
        foreach ($_existing_fields as $field) {
            $existing_fields[get_translated_text($field['cf_name'])] = $field['id'];
        }

        foreach (array_keys($fields) as $field_code) {
            $fields[$field_code]['title'] = do_lang('DEFAULT_CPF_' . $field_code . '_NAME');
        }
        sort_maps_by($fields, 'title', false, true);

        $rows = new Tempcode();
        foreach ($fields as $field_code => $details) {
            if ($details['icon'] == '') {
                $icon = '';
            } else {
                $icon = '<img width="24" height="24" alt="" src="' . escape_html(find_theme_image($details['icon'])) . '" />';
            }

            $title = escape_html($details['title']);

            if ($details['section'] == '') {
                $section = do_lang_tempcode('NA');
            } else {
                $section = do_lang_tempcode('menus:CONTACT');
            }

            $type = do_lang_tempcode('FIELD_TYPE_' . $details['type']);

            $choose_action = do_template('COLUMNED_TABLE_ROW_CELL_TICK', array(
                '_GUID' => 'c355b82d286c3f10180b8a0ecddf070f',
                'LABEL' => do_lang_tempcode('CHOOSE'),
                'NAME' => 'select__' . $field_code,
                'VALUE' => '1',
                'HIDDEN' => '',
                'TICKED' => isset($existing_fields[$details['title']]),
            ));

            $rows->attach(columned_table_row(array(
                $icon,
                $title,
                $section,
                $type,
                $choose_action,
            ), false));
        }

        $table = do_template('COLUMNED_TABLE', array('_GUID' => 'b5765aca9ffe84242ca2c9d17f5ec0a6', 'HEADER_ROW' => $header_row, 'ROWS' => $rows));

        return do_template('COLUMNED_TABLE_SCREEN', array(
            '_GUID' => 'ddfa0fb6ea396d3b57cb447bc228a885',
            'TITLE' => $this->title,
            'TEXT' => do_lang_tempcode('PREDEFINED_FIELDS_DESCRIPTION'),
            'TABLE' => $table,
            'SUBMIT_ICON' => 'buttons/save',
            'SUBMIT_NAME' => do_lang_tempcode('PROCEED'),
            'POST_URL' => build_url(array('page' => '_SELF', 'type' => '_predefined_content'), '_SELF'),
        ));
    }

    /**
     * Actualise install/uninstall of predefined content.
     *
     * @return Tempcode The UI
     */
    public function _predefined_content()
    {
        $fields = _cns_predefined_custom_field_details();

        $_existing_fields = $GLOBALS['FORUM_DB']->query_select('f_custom_fields', array('id', 'cf_name'));
        $existing_fields = array();
        foreach ($_existing_fields as $field) {
            $existing_fields[get_translated_text($field['cf_name'])] = $field['id'];
        }

        foreach (array_keys($fields) as $field_code) {
            $ticked = (post_param_integer('select__' . $field_code, 0) == 1);

            $_title = do_lang('DEFAULT_CPF_' . $field_code . '_NAME');

            if ($ticked) {
                if (!isset($existing_fields[$_title])) {
                    cns_make_predefined_content_field($field_code);
                }
            } else {
                if (isset($existing_fields[$_title])) {
                    cns_delete_custom_field($existing_fields[$_title]);
                }
            }
        }

        return inform_screen($this->title, do_lang_tempcode('SUCCESS'));
    }

    /**
     * Show value statistics for a Custom Profile Field (choose).
     *
     * @return Tempcode The UI
     */
    public function stats()
    {
        $fields = new Tempcode();

        $rows = $GLOBALS['FORUM_DB']->query_select('f_custom_fields', array('id', 'cf_name', 'cf_type'));

        require_code('fields');

        $list = new Tempcode();
        $_list = array();
        foreach ($rows as $row) {
            $ob = get_fields_hook($row['cf_type']);
            list(, , $storage_type) = $ob->get_field_value_row_bits(null);

            if (strpos($storage_type, '_trans') === false) {
                $id = $row['id'];
                $text = get_translated_text($row['cf_name'], $GLOBALS['FORUM_DB']);
                $_list[$id] = $text;
            }
        }
        asort($_list, SORT_NATURAL | SORT_FLAG_CASE);
        foreach ($_list as $id => $text) {
            $list->attach(form_input_list_entry(strval($id), false, $text));
        }
        if ($list->is_empty()) {
            return inform_screen($this->title, do_lang_tempcode('NO_ENTRIES'));
        }

        require_lang('dates');
        $fields->attach(form_input_list(do_lang_tempcode('NAME'), '', 'id', $list));
        $fields->attach(form_input_date(do_lang_tempcode('FROM'), do_lang_tempcode('DESCRIPTION_MEMBERS_JOINED_FROM'), 'start', false, false, false, time() - 60 * 60 * 24 * 30, 10, intval(date('Y')) - 10));
        $fields->attach(form_input_date(do_lang_tempcode('TO'), do_lang_tempcode('DESCRIPTION_MEMBERS_JOINED_TO'), 'end', false, false, false, time(), 10, intval(date('Y')) - 10));

        $post_url = build_url(array('page' => '_SELF', 'type' => '_stats'), '_SELF', array(), false, true);
        $submit_name = do_lang_tempcode('CUSTOM_PROFILE_FIELD_STATS');

        return do_template('FORM_SCREEN', array(
            '_GUID' => '393bac2180c9e135ae9c31565ddf7761',
            'GET' => true,
            'SKIP_WEBSTANDARDS' => true,
            'TITLE' => $this->title,
            'HIDDEN' => '',
            'FIELDS' => $fields,
            'TEXT' => '',
            'URL' => $post_url,
            'SUBMIT_ICON' => 'buttons/proceed',
            'SUBMIT_NAME' => $submit_name,
        ));
    }

    /**
     * Show value statistics for a Custom Profile Field (show).
     *
     * @return Tempcode The statistics
     */
    public function _stats()
    {
        $f_name = 'field_' . strval(get_param_integer('id'));
        $_a = post_param_date('start');
        $a = ($_a === null) ? '1=1' : ('m_join_time>' . strval($_a));
        $_b = post_param_date('end');
        $b = ($_b === null) ? '1=1' : ('m_join_time<' . strval($_b));
        $members_in_range = $GLOBALS['FORUM_DB']->query('SELECT ' . $f_name . ',COUNT(' . $f_name . ') AS cnt FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_members m LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_member_custom_fields f ON m.id=f.mf_member_id WHERE ' . $a . ' AND ' . $b . ' GROUP BY ' . $f_name . ' ORDER BY cnt', 300/*reasonable limit*/);
        if (count($members_in_range) == 300) {
            attach_message(do_lang_tempcode('TOO_MUCH_CHOOSE__TOP_ONLY', escape_html(integer_format(300))), 'warn');
        }
        $lines = array();
        foreach ($members_in_range as $row) {
            if ($row[$f_name] !== null) {
                $val = $row[$f_name];

                if ($val == STRING_MAGIC_NULL) {
                    continue;
                }

                $lines[] = array('CNT' => integer_format($row['cnt']), 'VAL' => is_integer($val) ? integer_format($val) : $val);
            }
        }
        if ($lines === array()) {
            warn_exit(do_lang_tempcode('NO_ENTRIES'));
        }

        return do_template('CNS_CPF_STATS_SCREEN', array('_GUID' => 'bb7be7acf936cd008e16bd515f7f39ac', 'TITLE' => $this->title, 'STATS' => $lines));
    }
}

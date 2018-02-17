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
 * @package    news
 */

require_code('crud_module');

/**
 * Module page class.
 */
class Module_cms_blogs extends Standard_crud_module
{
    protected $lang_type = 'NEWS_BLOG';
    protected $select_name = 'TITLE';
    protected $code_require = 'news';
    protected $permissions_require = 'mid';
    protected $permissions_cat_require = 'news';
    protected $permissions_cat_name = 'main_news_category';
    protected $user_facing = true;
    protected $seo_type = 'news';
    protected $content_type = 'news';
    protected $possibly_some_kind_of_upload = true;
    protected $upload = 'image';
    protected $menu_label = 'BLOGS';
    protected $table = 'news';
    protected $orderer = 'title';
    protected $title_is_multi_lang = true;
    protected $privilege_page_name = 'cms_news';

    protected $donext_type = null;

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
        if (!has_privilege(get_member(), 'have_personal_category', 'cms_news')) {
            return null;
        }

        if (get_option('separate_blogs') == '0') {
            return null;
        }

        $ret = array(
            'browse' => array('MANAGE_BLOGS', 'menu/cms/blog'),
        );
        $ret += parent::get_entry_points();
        $ret += array(
            'import_wordpress' => array('IMPORT_WORDPRESS', 'admin/import'),
        );
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
        $type = get_param_string('type', 'browse');

        require_lang('news');

        inform_non_canonical_parameter('validated');
        inform_non_canonical_parameter('cat');

        set_helper_panel_tutorial('tut_news');

        if ($type == 'add' || $type == '_edit') {
            set_helper_panel_text(comcode_lang_string('DOC_NEWS'));
        }

        if ($type == 'import_wordpress' || $type == '_import_wordpress') {
            $this->title = get_screen_title('IMPORT_WORDPRESS');
        }

        if ($type == '_import_wordpress') {
            breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('MANAGE_BLOGS')), array('_SELF:_SELF:import_wordpress', do_lang_tempcode('IMPORT_WORDPRESS'))));
            breadcrumb_set_self(do_lang_tempcode('DONE'));
        }

        return parent::pre_run($top_level);
    }

    /**
     * Standard crud_module run_start.
     *
     * @param  ID_TEXT $type The type of module execution
     * @return Tempcode The output of the run
     */
    public function run_start($type)
    {
        $this->posting_form_title = do_lang_tempcode('BLOG_NEWS_ARTICLE');

        if (is_guest()) {
            access_denied('NOT_AS_GUEST');
        }

        require_code('news2');
        require_css('news');

        // Decide what to do
        if ($type == 'browse') {
            return $this->browse();
        }
        if ($type == 'import_wordpress') {
            return $this->import_wordpress();
        }
        if ($type == '_import_wordpress') {
            return $this->_import_wordpress();
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
            get_screen_title('MANAGE_BLOGS'),
            comcode_lang_string('DOC_BLOGS'),
            array(
                has_privilege(get_member(), 'submit_midrange_content', 'cms_news') ? array('admin/add', array('_SELF', array('type' => 'add'), '_SELF'), do_lang('ADD_NEWS_BLOG')) : null,
                has_privilege(get_member(), 'edit_own_midrange_content', 'cms_news') ? array('admin/edit', array('_SELF', array('type' => 'edit'), '_SELF'), do_lang('EDIT_NEWS_BLOG')) : null,
                has_privilege(get_member(), 'mass_import', 'cms_news') ? array('admin/import', array('_SELF', array('type' => 'import_wordpress'), '_SELF'), do_lang('IMPORT_WORDPRESS')) : null,
            ),
            do_lang('MANAGE_BLOGS')
        );
    }

    /**
     * Standard crud_module table function.
     *
     * @param  array $url_map Details to go to build_url for link to the next screen
     * @return ?array A quartet: The choose table, Whether re-ordering is supported from this screen, Search URL, Archive URL (null: nothing to select)
     */
    public function create_selection_list_choose_table($url_map)
    {
        require_code('templates_results_table');

        $current_ordering = get_param_string('sort', 'date_and_time DESC', INPUT_FILTER_GET_COMPLEX);
        if (strpos($current_ordering, ' ') === false) {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }
        list($sortable, $sort_order) = explode(' ', $current_ordering, 2);
        $sortables = array(
            'title' => do_lang_tempcode('TITLE'),
            'date_and_time' => do_lang_tempcode('ADDED'),
            'news_views' => do_lang_tempcode('COUNT_VIEWS'),
        );
        if (addon_installed('unvalidated')) {
            $sortables['validated'] = do_lang_tempcode('VALIDATED');
        }
        if (((strtoupper($sort_order) != 'ASC') && (strtoupper($sort_order) != 'DESC')) || (!array_key_exists($sortable, $sortables))) {
            log_hack_attack_and_exit('ORDERBY_HACK');
        }

        $fh = array();
        $fh[] = do_lang_tempcode('TITLE');
        $fh[] = do_lang_tempcode('ADDED');
        $fh[] = do_lang_tempcode('COUNT_VIEWS');
        if (addon_installed('unvalidated')) {
            $fh[] = protect_from_escaping(do_template('COMCODE_ABBR', array('_GUID' => '204d1050402b48e5c2c9539763a3fe50', 'TITLE' => do_lang_tempcode('VALIDATED'), 'CONTENT' => do_lang_tempcode('VALIDATED_SHORT'))));
        }
        $fh[] = do_lang_tempcode('ACTIONS');
        $header_row = results_header_row($fh, $sortables, 'sort', $sortable . ' ' . $sort_order);

        $result_entries = new Tempcode();

        $only_owned = has_privilege(get_member(), 'edit_midrange_content', 'cms_news') ? null : get_member();
        list($rows, $max_rows) = $this->get_entry_rows(false, $current_ordering, ($only_owned === null) ? null : array('submitter' => $only_owned), false, ' JOIN ' . get_table_prefix() . 'news_categories c ON c.id=r.news_category AND nc_owner IS NOT NULL');
        if (count($rows) == 0) {
            return null;
        }
        foreach ($rows as $row) {
            $edit_url = build_url($url_map + array('id' => $row['id']), '_SELF');

            $fr = array();
            $fr[] = protect_from_escaping(hyperlink(build_url(array('page' => 'news', 'type' => 'view', 'id' => $row['id']), get_module_zone('news')), get_translated_text($row['title']), false, true));
            $fr[] = get_timezoned_date_time($row['date_and_time']);
            $fr[] = integer_format($row['news_views']);
            if (addon_installed('unvalidated')) {
                $fr[] = ($row['validated'] == 1) ? do_lang_tempcode('YES') : do_lang_tempcode('NO');
            }
            $fr[] = protect_from_escaping(hyperlink($edit_url, do_lang_tempcode('EDIT'), false, true, do_lang('EDIT') . ' #' . strval($row['id'])));

            $result_entries->attach(results_entry($fr, true));
        }

        $search_url = build_url(array('page' => 'search', 'id' => 'news'), get_module_zone('search'));
        $archive_url = build_url(array('page' => 'news'), get_module_zone('news'));

        return array(results_table(do_lang($this->menu_label), get_param_integer('start', 0), 'start', either_param_integer('max', 20), 'max', $max_rows, $header_row, $result_entries, $sortables, $sortable, $sort_order), false, $search_url, $archive_url);
    }

    /**
     * Standard crud_module list function.
     *
     * @return Tempcode The selection list
     */
    public function create_selection_list_entries()
    {
        $only_owned = has_privilege(get_member(), 'edit_midrange_content', 'cms_news') ? null : get_member();
        return create_selection_list_news(null, $only_owned, false, true);
    }

    /**
     * Get Tempcode for a news adding/editing form.
     *
     * @param  ?AUTO_LINK $id The news ID (null: new)
     * @param  ?AUTO_LINK $main_news_category The primary category for the news (null: personal)
     * @param  ?array $news_category A list of categories the news is in (null: not known)
     * @param  SHORT_TEXT $title The news title
     * @param  LONG_TEXT $news The news summary
     * @param  SHORT_TEXT $author The name of the author
     * @param  BINARY $validated Whether the news is validated
     * @param  ?BINARY $allow_rating Whether rating is allowed (null: decide statistically, based on existing choices)
     * @param  ?SHORT_INTEGER $allow_comments Whether comments are allowed (0=no, 1=yes, 2=review style) (null: decide statistically, based on existing choices)
     * @param  ?BINARY $allow_trackbacks Whether trackbacks are allowed (null: decide statistically, based on existing choices)
     * @param  BINARY $send_trackbacks Whether to show the "send trackback" field
     * @param  LONG_TEXT $notes Notes for the video
     * @param  URLPATH $image URL to the image for the news entry (blank: use cat image)
     * @param  ?array $scheduled Scheduled go-live time (null: N/A)
     * @return array A tuple of lots of info (fields, hidden fields, trailing fields)
     */
    public function get_form_fields($id = null, $main_news_category = null, $news_category = null, $title = '', $news = '', $author = '', $validated = 1, $allow_rating = null, $allow_comments = null, $allow_trackbacks = null, $send_trackbacks = 1, $notes = '', $image = '', $scheduled = null)
    {
        list($allow_rating, $allow_comments, $allow_trackbacks) = $this->choose_feedback_fields_statistically($allow_rating, $allow_comments, $allow_trackbacks);

        if ($title == '') {
            $title = get_param_string('title', $title, INPUT_FILTER_GET_COMPLEX);
            $author = get_param_string('author', $author);
            $notes = get_param_string('notes', $notes, INPUT_FILTER_GET_COMPLEX);

            if ($main_news_category === null) {
                $param_cat = get_param_string('cat', '');
                if ($param_cat == '') {
                    $main_news_category = null;
                    $news_category = array();
                } elseif (strpos($param_cat, ',') === false) {
                    $main_news_category = intval($param_cat);
                    $news_category = array();
                } else {
                    require_code('selectcode');
                    $_param_cat = explode(',', $param_cat);
                    $_main_news_category = array_shift($_param_cat);
                    $param_cat = implode(',', $_param_cat);
                    $main_news_category = ($_main_news_category == '') ? null : intval($_main_news_category);
                    $news_category = selectcode_to_idlist_using_db($param_cat, 'id', 'news_categories', 'news_categories', null, 'id', 'id');
                }

                $author = $GLOBALS['FORUM_DRIVER']->get_username(get_member());
            }
        }

        $cats1 = create_selection_list_news_categories($main_news_category, false, true, false, true);
        $cats2 = create_selection_list_news_categories((($news_category === null) || (count($news_category) == 0)) ? array(get_param_integer('cat', null)) : $news_category, false, true, true, false);

        $fields = new Tempcode();
        $fields2 = new Tempcode();
        $hidden = new Tempcode();
        $fields->attach(form_input_line_comcode(do_lang_tempcode('TITLE'), do_lang_tempcode('DESCRIPTION_TITLE'), 'title', $title, true));
        if ($validated == 0) {
            $validated = get_param_integer('validated', 0);
            if (($validated == 1) && (addon_installed('unvalidated'))) {
                attach_message(do_lang_tempcode('WILL_BE_VALIDATED_WHEN_SAVING'));
            }
        }
        if (has_some_cat_privilege(get_member(), 'bypass_validation_' . $this->permissions_require . 'range_content', 'cms_news', $this->permissions_cat_require)) {
            if (addon_installed('unvalidated')) {
                $fields2->attach(form_input_tick(do_lang_tempcode('VALIDATED'), do_lang_tempcode($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member()) ? 'DESCRIPTION_VALIDATED_SIMPLE' : 'DESCRIPTION_VALIDATED', 'news'), 'validated', $validated == 1));
            }
        }
        if ($cats1->is_empty()) {
            warn_exit(do_lang_tempcode('NO_CATEGORIES', 'news_category'));
        }
        if (addon_installed('authors')) {
            $hidden->attach(form_input_hidden('author', $author));
        }
        $fields2->attach(do_template('FORM_SCREEN_FIELD_SPACER', array('_GUID' => 'cff27a28d4d01f8e0255ee645ea210b3', 'SECTION_HIDDEN' => $image == '' && ($title == ''/*=new entry and selected news cats was from URL*/ || ($news_category === null) || $news_category == array()), 'TITLE' => do_lang_tempcode('ADVANCED'))));
        $fields2->attach(form_input_text_comcode(do_lang_tempcode('BLOG_NEWS_SUMMARY'), do_lang_tempcode('DESCRIPTION_NEWS_SUMMARY'), 'news', $news, false));
        if (get_option('enable_secondary_news') == '1') {
            $fields2->attach(form_input_list(do_lang_tempcode('MAIN_CATEGORY'), do_lang_tempcode('DESCRIPTION_MAIN_CATEGORY'), 'main_news_category', $cats1));
        } else {
            $fields2->attach(form_input_hidden('main_news_category', ($main_news_category === null) ? 'personal' : strval($main_news_category)));
        }
        if (get_option('enable_secondary_news') == '1') {
            $fields2->attach(form_input_multi_list(do_lang_tempcode('SECONDARY_CATEGORIES'), do_lang_tempcode('DESCRIPTION_SECONDARY_CATEGORIES', 'news'), 'news_category', $cats2));
        }

        if ((addon_installed('calendar')) && (has_privilege(get_member(), 'scheduled_publication_times'))) {
            $fields2->attach(form_input_date__cron(do_lang_tempcode('PUBLICATION_TIME'), do_lang_tempcode('DESCRIPTION_PUBLICATION_TIME'), 'schedule', false, true, true, $scheduled, intval(date('Y')) - 1970 + 2, 1970));
        }

        require_code('feedback2');
        $fields2->attach(feedback_fields($this->content_type, $allow_rating == 1, $allow_comments == 1, $allow_trackbacks == 1, $send_trackbacks == 1, $notes, $allow_comments == 2));

        require_code('content2');
        $fields2->attach(seo_get_fields($this->seo_type, ($id === null) ? null : strval($id)));

        require_code('activities');
        $fields2->attach(get_syndication_option_fields('news'));

        return array($fields, $hidden, null, null, null, null, make_string_tempcode($fields2->evaluate())/*XHTMLXHTML*/);
    }

    /**
     * Standard crud_module submitter getter.
     *
     * @param  ID_TEXT $id The entry for which the submitter is sought
     * @return array The submitter, and the time of submission (null submission time implies no known submission time)
     */
    public function get_submitter($id)
    {
        $rows = $GLOBALS['SITE_DB']->query_select('news', array('submitter', 'date_and_time'), array('id' => intval($id)), '', 1);
        if (!array_key_exists(0, $rows)) {
            return array(null, null);
        }
        return array($rows[0]['submitter'], $rows[0]['date_and_time']);
    }

    /**
     * Standard crud_module cat getter.
     *
     * @param  ID_TEXT $id The entry for which the cat is sought
     * @return string The cat
     */
    public function get_cat($id)
    {
        $temp = $GLOBALS['SITE_DB']->query_select_value_if_there('news', 'news_category', array('id' => intval($id)));
        if ($temp === null) {
            warn_exit(do_lang_tempcode('MISSING_RESOURCE', 'news'));
        }
        return strval($temp);
    }

    /**
     * Standard crud_module edit form filler.
     *
     * @param  ID_TEXT $_id The entry being edited
     * @return array A tuple of lots of info
     */
    public function fill_in_edit_form($_id)
    {
        $id = intval($_id);

        require_lang('zones');

        $rows = $GLOBALS['SITE_DB']->query_select('news', array('*'), array('id' => intval($id)), '', 1);
        if (!array_key_exists(0, $rows)) {
            warn_exit(do_lang_tempcode('MISSING_RESOURCE', 'news'));
        }
        $myrow = $rows[0];

        $cat = $myrow['news_category'];

        $categories = array();
        $category_query = $GLOBALS['SITE_DB']->query_select('news_category_entries', array('news_entry_category'), array('news_entry' => $id));

        foreach ($category_query as $value) {
            $categories[] = $value['news_entry_category'];
        }

        $scheduled = null;

        if (addon_installed('calendar')) {
            $schedule_code = ':$GLOBALS[\'SITE_DB\']->query_update(\'news\',array(\'date_and_time\'=>$GLOBALS[\'_EVENT_TIMESTAMP\'],\'validated\'=>1),array(\'id\'=>' . strval($id) . '),\'\',1);';
            $past_event = $GLOBALS['SITE_DB']->query_select('calendar_events', array('e_start_day', 'e_start_month', 'e_start_year', 'e_start_hour', 'e_start_minute'), array($GLOBALS['SITE_DB']->translate_field_ref('e_content') => $schedule_code), '', 1);
            $scheduled = array_key_exists(0, $past_event) ? array($past_event[0]['e_start_minute'], $past_event[0]['e_start_hour'], $past_event[0]['e_start_month'], $past_event[0]['e_start_day'], $past_event[0]['e_start_year']) : null;
            if (($scheduled !== null) && (mktime($scheduled[1], $scheduled[0], 0, $scheduled[2], $scheduled[3], $scheduled[4]) < time())) {
                $scheduled = null;
            }
        } else {
            $scheduled = null;
        }

        $ret = $this->get_form_fields($id, $cat, $categories, get_translated_text($myrow['title']), get_translated_text($myrow['news']), $myrow['author'], $myrow['validated'], $myrow['allow_rating'], $myrow['allow_comments'], $myrow['allow_trackbacks'], 0, $myrow['notes'], $myrow['news_image'], $scheduled);
        $ret[2] = new Tempcode();
        $ret[3] = '';
        $ret[4] = false;
        $ret[5] = get_translated_text($myrow['news_article']);
        $ret[7] = get_translated_tempcode('news', $myrow, 'news_article');
        return $ret;
    }

    /**
     * Standard crud_module add actualiser.
     *
     * @return ID_TEXT The ID of the entry added
     */
    public function add_actualisation()
    {
        $author = post_param_string('author', $GLOBALS['FORUM_DRIVER']->get_username(get_member()));
        $news = post_param_string('news');
        $title = post_param_string('title');
        $validated = post_param_integer('validated', 0);
        $news_article = post_param_string('post');
        if (post_param_string('main_news_category') != 'personal') {
            $main_news_category = post_param_integer('main_news_category');
        } else {
            $main_news_category = null;
        }

        $news_category = array();
        if (array_key_exists('news_category', $_POST)) {
            foreach ($_POST['news_category'] as $val) {
                $news_category[] = ($val == 'personal') ? null : intval($val);
            }
        }

        $allow_rating = post_param_integer('allow_rating', 0);
        $allow_comments = post_param_integer('allow_comments', 0);
        $allow_trackbacks = post_param_integer('allow_trackbacks', 0);
        $notes = post_param_string('notes', '');

        $schedule = post_param_date('schedule');
        if ((addon_installed('calendar')) && (has_privilege(get_member(), 'scheduled_publication_times')) && ($schedule !== null) && ($schedule > time())) {
            $validated = 0;
        } else {
            $schedule = null;
        }

        if ($main_news_category !== null) {
            $owner = $GLOBALS['SITE_DB']->query_select_value('news_categories', 'nc_owner', array('id' => intval($main_news_category)));
            if (($owner !== null) && ($owner != get_member())) {
                check_privilege('can_submit_to_others_categories', array('news', $main_news_category), null, 'cms_news');
            }
        }

        $metadata = actual_metadata_get_fields('news', null);

        $id = add_news($title, $news, $author, $validated, $allow_rating, $allow_comments, $allow_trackbacks, $notes, $news_article, $main_news_category, $news_category, $metadata['add_time'], $metadata['submitter'], $metadata['views'], null, null, '');

        require_code('feedback2');
        send_trackbacks(post_param_string('send_trackbacks', ''), $title, $news);

        set_url_moniker('news', strval($id));

        $main_news_category = $GLOBALS['SITE_DB']->query_select_value('news', 'news_category', array('id' => $id));
        $this->donext_type = $main_news_category;

        if (($validated == 1) || (!addon_installed('unvalidated'))) {
            $is_blog = true;

            if (has_actual_page_access(get_modal_user(), 'news')) {
                require_code('activities');
                syndicate_described_activity($is_blog ? 'news:ACTIVITY_ADD_NEWS_BLOG' : 'news:ACTIVITY_ADD_NEWS', $title, '', '', '_SEARCH:news:view:' . strval($id), '', '', 'news', 1, null, true);
            }
        }

        if ($schedule !== null) {
            require_code('calendar');
            $schedule_code = ':$GLOBALS[\'SITE_DB\']->query_update(\'news\',array(\'date_and_time\'=>$GLOBALS[\'_EVENT_TIMESTAMP\'],\'validated\'=>1),array(\'id\'=>' . strval($id) . '),\'\',1);';
            $start_year = intval(date('Y', $schedule));
            $start_month = intval(date('m', $schedule));
            $start_day = intval(date('d', $schedule));
            $start_hour = intval(date('H', $schedule));
            $start_minute = intval(date('i', $schedule));
            require_code('calendar2');
            $event_id = add_calendar_event(db_get_first_id(), '', null, 0, do_lang('PUBLISH_NEWS', $title), $schedule_code, 3, $start_year, $start_month, $start_day, 'day_of_month', $start_hour, $start_minute);
            regenerate_event_reminder_jobs($event_id, true);
        }

        return strval($id);
    }

    /**
     * Standard crud_module edit actualiser.
     *
     * @param  ID_TEXT $_id The entry being edited
     */
    public function edit_actualisation($_id)
    {
        $id = intval($_id);

        $validated = post_param_integer('validated', fractional_edit() ? INTEGER_MAGIC_NULL : 0);

        $news_article = post_param_string('post', STRING_MAGIC_NULL);
        if (post_param_string('main_news_category') != 'personal') {
            $main_news_category = post_param_integer('main_news_category', INTEGER_MAGIC_NULL);
        } else {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }

        $news_category = array();
        if (array_key_exists('news_category', $_POST)) {
            foreach ($_POST['news_category'] as $val) {
                $news_category[] = intval($val);
            }
        }

        $allow_rating = post_param_integer('allow_rating', fractional_edit() ? INTEGER_MAGIC_NULL : 0);
        $allow_comments = post_param_integer('allow_comments', fractional_edit() ? INTEGER_MAGIC_NULL : 0);
        $allow_trackbacks = post_param_integer('allow_trackbacks', fractional_edit() ? INTEGER_MAGIC_NULL : 0);
        $notes = post_param_string('notes', STRING_MAGIC_NULL);

        $this->donext_type = $main_news_category;

        $url = STRING_MAGIC_NULL;

        $owner = $GLOBALS['SITE_DB']->query_select_value_if_there('news_categories', 'nc_owner', array('id' => $main_news_category)); // if_there in case somehow category setting corrupted
        if (($owner !== null) && ($owner != get_member())) {
            check_privilege('can_submit_to_others_categories', array('news', $main_news_category), null, 'cms_news');
        }

        $schedule = post_param_date('schedule');

        if ((addon_installed('calendar')) && (has_privilege(get_member(), 'scheduled_publication_times'))) {
            require_code('calendar2');
            $schedule_code = ':$GLOBALS[\'SITE_DB\']->query_update(\'news\',array(\'date_and_time\'=>$GLOBALS[\'_EVENT_TIMESTAMP\'],\'validated\'=>1),array(\'id\'=>' . strval($id) . '),\'\',1);';
            $past_event = $GLOBALS['SITE_DB']->query_select_value_if_there('calendar_events', 'id', array($GLOBALS['SITE_DB']->translate_field_ref('e_content') => $schedule_code));
            require_code('calendar');
            if ($past_event !== null) {
                delete_calendar_event($past_event);
            }

            if (($schedule !== null) && ($schedule > time())) {
                $validated = 0;

                $start_year = intval(date('Y', $schedule));
                $start_month = intval(date('m', $schedule));
                $start_day = intval(date('d', $schedule));
                $start_hour = intval(date('H', $schedule));
                $start_minute = intval(date('i', $schedule));
                $event_id = add_calendar_event(db_get_first_id(), 'none', null, 0, do_lang('PUBLISH_NEWS', 0, post_param_string('title')), $schedule_code, 3, $start_year, $start_month, $start_day, 'day_of_month', $start_hour, $start_minute);
                regenerate_event_reminder_jobs($event_id, true);
            }
        }

        $title = post_param_string('title', STRING_MAGIC_NULL);

        if (($validated == 1) && ($GLOBALS['SITE_DB']->query_select_value('news', 'validated', array('id' => intval($id))) == 0)) { // Just became validated, syndicate as just added
            $is_blog = true;

            $submitter = $GLOBALS['SITE_DB']->query_select_value('news', 'submitter', array('id' => $id));
            $activity_title = ($is_blog ? 'news:ACTIVITY_ADD_NEWS_BLOG' : 'news:ACTIVITY_ADD_NEWS');
            $activity_title_validate = ($is_blog ? 'news:ACTIVITY_VALIDATE_NEWS_BLOG' : 'news:ACTIVITY_VALIDATE_NEWS');

            if (has_actual_page_access(get_modal_user(), 'news')) { // NB: no category permission check, as syndication choice was explicit, and news categorisation is a bit more complex
                require_code('activities');
                syndicate_described_activity(($submitter != get_member()) ? $activity_title_validate : $activity_title, $title, '', '', '_SEARCH:news:view:' . strval($id), '', '', 'news', 1, null/*$submitter*/, true);
            }
        }

        $metadata = actual_metadata_get_fields('news', strval($id));

        edit_news(intval($id), $title, post_param_string('news', STRING_MAGIC_NULL), post_param_string('author', STRING_MAGIC_NULL), $validated, $allow_rating, $allow_comments, $allow_trackbacks, $notes, $news_article, $main_news_category, $news_category, post_param_string('meta_keywords', STRING_MAGIC_NULL), post_param_string('meta_description', STRING_MAGIC_NULL), $url, $metadata['add_time'], $metadata['edit_time'], $metadata['views'], $metadata['submitter'], array(), true);
    }

    /**
     * Standard crud_module delete actualiser.
     *
     * @param  ID_TEXT $_id The entry being deleted
     */
    public function delete_actualisation($_id)
    {
        $id = intval($_id);

        delete_news($id);
    }

    /**
     * The do-next manager for after news content management.
     *
     * @param  Tempcode $title The title (output of get_screen_title)
     * @param  Tempcode $description Some description to show, saying what happened
     * @param  ?AUTO_LINK $id The ID of whatever was just handled (null: N/A)
     * @return Tempcode The UI
     */
    public function do_next_manager($title, $description, $id = null)
    {
        $cat = $this->donext_type;

        require_code('templates_donext');

        return do_next_manager(
            $this->title,
            $description,
            array(),
            null,
            /* TYPED-ORDERED LIST OF 'LINKS' */
            array('_SELF', array('type' => 'add', 'cat' => $cat), '_SELF'), // Add one
            (($id === null) || (!has_privilege(get_member(), 'edit_own_midrange_content', 'cms_news', array('news', $cat)))) ? null : array('_SELF', array('type' => '_edit', 'id' => $id), '_SELF'), // Edit this
            has_privilege(get_member(), 'edit_own_midrange_content', 'cms_news') ? array('_SELF', array('type' => 'edit'), '_SELF') : null, // Edit one
            ($id === null) ? null : array('news', array('type' => 'view', 'id' => $id, 'blog' => 1), get_module_zone('news')), // View this
            array('news', array('type' => 'browse', 'blog' => 1), get_module_zone('news')), // View archive
            has_privilege(get_member(), 'submit_cat_midrange_content', 'cms_news') ? array('cms_news', array('type' => 'add_category'), '_SELF') : null, // Add one category
            has_privilege(get_member(), 'edit_own_cat_midrange_content', 'cms_news') ? array('cms_news', array('type' => 'edit_category'), '_SELF') : null, // Edit one category
            ($cat === null) ? null : has_privilege(get_member(), 'edit_own_cat_midrange_content', 'cms_news') ? array('cms_news', array('type' => '_edit_category', 'id' => $cat), '_SELF') : null, // Edit this category
            null, // View this category
            array(),
            array(),
            array(),
            null,
            null,
            null,
            null,
            do_lang('BLOG_NEWS_ARTICLE'),
            'news_category'
        );
    }

    /**
     * The UI to import news.
     *
     * @return Tempcode The UI
     */
    public function import_wordpress()
    {
        check_privilege('mass_import', null, null, 'cms_news');

        $lang = post_param_string('lang', user_lang());

        $submit_name = do_lang_tempcode('IMPORT_WORDPRESS');

        /* RSS method */

        require_code('news2');
        $fields = import_rss_fields(true);

        $hidden = form_input_hidden('lang', $lang);

        $xml_post_url = build_url(array('page' => '_SELF', 'type' => '_import_wordpress', 'method' => 'xml'), '_SELF');

        $xml_upload_form = do_template('FORM', array(
            '_GUID' => 'bdcc111acf379bab6f163f2e86d20e03',
            'TABINDEX' => strval(get_form_field_tabindex()),
            'TEXT' => '',
            'HIDDEN' => $hidden,
            'FIELDS' => $fields,
            'SUBMIT_ICON' => 'admin--import',
            'SUBMIT_NAME' => $submit_name,
            'URL' => $xml_post_url,
        ));

        /* Database method */

        $fields = new Tempcode();

        $fields->attach(form_input_line(do_lang_tempcode('WORDPRESS_HOST_NAME'), do_lang_tempcode('DESCRIPTION_WORDPRESS_HOST_NAME'), 'wp_host', 'localhost', false));
        $fields->attach(form_input_line(do_lang_tempcode('WORDPRESS_DB_NAME'), do_lang_tempcode('DESCRIPTION_WORDPRESS_DB_NAME'), 'wp_db', 'wordpress', false));
        $fields->attach(form_input_line(do_lang_tempcode('WORDPRESS_TABLE_PREFIX'), do_lang_tempcode('DESCRIPTION_WORDPRESS_TABLE_PREFIX'), 'wp_table_prefix', 'wp', false));
        $fields->attach(form_input_line(do_lang_tempcode('WORDPRESS_DB_USERNAME'), do_lang_tempcode('DESCRIPTION_WORDPRESS_DB_USERNAME'), 'wp_db_user', 'root', false));
        $fields->attach(form_input_password(do_lang_tempcode('WORDPRESS_DB_PASSWORD'), do_lang_tempcode('DESCRIPTION_WORDPRESS_DB_PASSWORD'), 'wp_db_password', false));

        $fields->attach(do_template('FORM_SCREEN_FIELD_SPACER', array('_GUID' => '27350b4f39d4634a405131716a1f152c', 'SECTION_HIDDEN' => false, 'TITLE' => do_lang_tempcode('ADVANCED'))));

        $fields->attach(form_input_tick(do_lang_tempcode('IMPORT_WORDPRESS_USERS'), do_lang_tempcode('DESCRIPTION_IMPORT_WORDPRESS_USER'), 'wp_import_wordpress_users', true));
        $fields->attach(form_input_tick(do_lang_tempcode('IMPORT_BLOG_COMMENTS'), do_lang_tempcode('DESCRIPTION_IMPORT_BLOG_COMMENTS'), 'wp_import_blog_comments', true));
        if (addon_installed('unvalidated')) {
            $fields->attach(form_input_tick(do_lang_tempcode('AUTO_VALIDATE_ALL_POSTS'), do_lang_tempcode('DESCRIPTION_VALIDATE_ALL_POSTS'), 'wp_auto_validate', true));
        }
        if ($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
            $fields->attach(form_input_tick(do_lang_tempcode('ADD_TO_OWN_ACCOUNT'), do_lang_tempcode('DESCRIPTION_ADD_TO_OWN_ACCOUNT'), 'wp_to_own_account', false));
        }
        $fields->attach(form_input_tick(do_lang_tempcode('IMPORT_TO_BLOG'), do_lang_tempcode('DESCRIPTION_IMPORT_TO_BLOG'), 'wp_import_to_blog', true));
        if (has_privilege(get_member(), 'draw_to_server')) {
            $fields->attach(form_input_tick(do_lang_tempcode('DOWNLOAD_IMAGES'), do_lang_tempcode('DESCRIPTION_DOWNLOAD_IMAGES'), 'wp_download_images', true));
        }

        $hidden = new Tempcode();
        $hidden->attach(form_input_hidden('lang', $lang));
        handle_max_file_size($hidden);

        $db_post_url = build_url(array('page' => '_SELF', 'type' => '_import_wordpress', 'method' => 'db'), '_SELF');

        $db_import_form = do_template('FORM', array(
            '_GUID' => 'df2b4285f538bf94055c75fb8b61be6e',
            'TABINDEX' => strval(get_form_field_tabindex()),
            'TEXT' => '',
            'HIDDEN' => $hidden,
            'FIELDS' => $fields,
            'SUBMIT_ICON' => 'admin--import',
            'SUBMIT_NAME' => $submit_name,
            'URL' => $db_post_url,
        ));

        /* Render */

        return do_template('NEWS_WORDPRESS_IMPORT_SCREEN', array('_GUID' => 'b9dcdd8211c65f3d2acd16e759d451a5', 'TITLE' => $this->title, 'XML_UPLOAD_FORM' => $xml_upload_form, 'DB_IMPORT_FORM' => $db_import_form));
    }

    /**
     * The actualiser to import a wordpress blog.
     *
     * @return Tempcode The UI
     */
    public function _import_wordpress()
    {
        check_privilege('mass_import', null, null, 'cms_news');

        set_mass_import_mode();

        // Wordpress posts, XML file importing method
        if ((get_param_string('method') == 'xml')) {
            $is_validated = post_param_integer('auto_validate', 0);
            if (!addon_installed('unvalidated')) {
                $is_validated = 1;
            }
            $download_images = post_param_integer('download_images', 0);
            if (!has_privilege(get_member(), 'draw_to_server')) {
                $download_images = 0;
            }
            $to_own_account = post_param_integer('add_to_own', 0);
            if (!$GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
                $to_own_account = 1;
            }
            $import_blog_comments = post_param_integer('import_blog_comments', 0);
            $import_to_blog = post_param_integer('import_to_blog', 0);

            $rss_url = post_param_string('rss_feed_url', null, INPUT_FILTER_URL_GENERAL);
            require_code('uploads');
            if (((is_plupload(true)) && (array_key_exists('file_anytype', $_FILES))) || ((array_key_exists('file_anytype', $_FILES)) && (is_uploaded_file($_FILES['file_anytype']['tmp_name'])))) {
                $rss_url = $_FILES['file_anytype']['tmp_name'];
            }
            if ($rss_url === null) {
                warn_exit(do_lang_tempcode('IMPROPERLY_FILLED_IN'));
            }

            require_code('rss');
            $rss = new CMS_RSS($rss_url, true);

            // Cleanup
            if (url_is_local($rss_url)) { // Means it is a temp file
                @unlink($rss_url);
            }

            require_code('tasks');
            $ret = call_user_func_array__long_task(do_lang('IMPORT_WORDPRESS'), $this->title, 'import_rss', array($is_validated, $download_images, $to_own_account, $import_blog_comments, $import_to_blog, $rss));

            return $ret;
        } elseif (get_param_string('method') == 'db') { // Importing directly from wordpress DB
            $is_validated = post_param_integer('wp_auto_validate', 0);
            if (!addon_installed('unvalidated')) {
                $is_validated = 1;
            }
            $download_images = post_param_integer('wp_download_images', 0);
            if (!has_privilege(get_member(), 'draw_to_server')) {
                $download_images = 0;
            }
            $to_own_account = post_param_integer('wp_add_to_own', 0);
            if (!$GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
                $to_own_account = 1;
            }
            $import_blog_comments = post_param_integer('wp_import_blog_comments', 0);
            $import_to_blog = post_param_integer('wp_import_to_blog', 0);
            if (!$GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
                $import_to_blog = 0;
            }
            $import_wordpress_users = (post_param_integer('wp_import_wordpress_users', 0) == 1);

            require_code('tasks');
            return call_user_func_array__long_task(do_lang('IMPORT_WORDPRESS'), $this->title, 'import_wordpress', array($is_validated, $download_images, $to_own_account, $import_blog_comments, $import_to_blog, $import_wordpress_users));
        }

        return new Tempcode(); // Should not get here
    }
}

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
 * @package    core_language_editing
 */

/**
 * Module page class.
 */
class Module_admin_lang
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
        $info['version'] = 2;
        $info['locked'] = false;
        return $info;
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
        $ret = array(
            'browse' => array('TRANSLATE_CODE', 'menu/adminzone/style/language/language'),
        );
        if (!$be_deferential) {
            $ret += array(
                'content' => array('TRANSLATE_CONTENT', 'menu/adminzone/style/language/language_content'),
                'criticise' => array('CRITICISE_LANGUAGE_PACK', 'menu/adminzone/style/language/criticise_language'),
            );
        }
        return $ret;
    }

    /**
     * Uninstall the module.
     */
    public function uninstall()
    {
        require_code('files');

        $langs = find_all_langs(true);
        foreach (array_keys($langs) as $lang) {
            deldir_contents(get_custom_file_base() . '/caches/lang/' . $lang, true);
            // lang_custom purposely left
        }
    }

    public $title;

    /**
     * Module pre-run function. Allows us to know metadata for <head> before we start streaming output.
     *
     * @return ?Tempcode Tempcode indicating some kind of exceptional output (null: none).
     */
    public function pre_run()
    {
        require_code('input_filter_2');
        modsecurity_workaround_enable();

        $type = get_param_string('type', 'browse');

        require_lang('lang');
        require_code('lang2');
        require_code('lang3');
        require_code('lang_compile');

        set_helper_panel_tutorial('tut_intl');

        if ($type == 'criticise') {
            $this->title = get_screen_title('CRITICISE_LANGUAGE_PACK');
        }

        if ($type == 'browse') {
            if (get_param_string('lang', '') == '') {
                set_helper_panel_text(comcode_lang_string('DOC_FIND_LANG_STRING_TIP'));
            }

            breadcrumb_set_parents(array(array('_SELF:_SELF:browse', do_lang_tempcode('CHOOSE'))));
            breadcrumb_set_self(do_lang_tempcode('TRANSLATE_CODE'));

            $lang = filter_naughty_harsh(get_param_string('lang', ''));
            if ($lang == '') {
                $this->title = get_screen_title('TRANSLATE_CODE');
            } else {
                $search = get_param_string('search', '', true);
                if ($search != '') {
                    $this->title = get_screen_title('TRANSLATE_CODE');
                } else {
                    $lang_file = get_param_string('lang_file');
                    $this->title = get_screen_title('_TRANSLATE_CODE', true, array(escape_html($lang_file), escape_html(lookup_language_full_name($lang))));
                }
            }
        }

        if ($type == 'content' || $type == '_content') {
            $this->title = get_screen_title('TRANSLATE_CONTENT');
        }

        if ($type == '_code' || $type == '_code2') {
            $this->title = get_screen_title('TRANSLATE_CODE');
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
        require_code('input_filter_2');
        rescue_shortened_post_request();

        require_javascript('translate');

        require_css('translations_editor');

        $type = get_param_string('type', 'browse');

        if ($type == 'content') {
            return $this->interface_content();
        }
        if ($type == '_content') {
            return $this->set_lang_content();
        }
        if ($type == 'criticise') {
            return $this->criticise();
        }
        if ($type == 'browse') {
            return $this->interface_code();
        }
        if ($type == '_code') {
            return $this->set_lang_code();
        }
        if ($type == '_code2') {
            return $this->set_lang_code_2(); // This is a language string setter called from an external source. Strings may be from many different files
        }

        return new Tempcode();
    }

    /**
     * The UI to choose a language.
     *
     * @param  Tempcode $title The title to show when choosing a language
     * @param  boolean $choose_lang_file Whether to also choose a language file
     * @param  boolean $add_lang Whether the user may add a language
     * @param  mixed $text Text message to show (Tempcode or string)
     * @param  boolean $provide_na Whether to provide an N/A choice
     * @param  ID_TEXT $param_name The name of the parameter for specifying language
     * @return Tempcode The UI
     */
    public function choose_lang($title, $choose_lang_file = false, $add_lang = false, $text = '', $provide_na = true, $param_name = 'lang')
    {
        require_code('form_templates');
        $langs = new Tempcode();
        $langs->attach(create_selection_list_langs(null, $add_lang));

        $javascript = '';

        $fields = new Tempcode();

        if ($add_lang) {
            $set_name = 'language';
            $required = true;
            $set_title = do_lang_tempcode('LANGUAGE');
            $field_set = alternate_fields_set__start($set_name);

            $field_set->attach(form_input_list(do_lang_tempcode('EXISTING'), do_lang_tempcode('DESCRIPTION_LANGUAGE'), $param_name, $langs, null, false, false));

            $field_set->attach(form_input_codename(do_lang_tempcode('NEW'), do_lang_tempcode('DESCRIPTION_NEW_LANG'), 'lang_new', '', false));

            $fields->attach(alternate_fields_set__end($set_name, $set_title, '', $field_set, $required));
        } else {
            $fields->attach(form_input_list(do_lang_tempcode('LANGUAGE'), do_lang_tempcode('DESCRIPTION_LANGUAGE'), $param_name, $langs, null, false, false));
        }

        if ($choose_lang_file) {
            $set_name = 'language_file';
            $required = true;
            $set_title = do_lang_tempcode('LANGUAGE_FILE');
            $field_set = alternate_fields_set__start($set_name);

            $lang_files = new Tempcode();
            $lang_files->attach(form_input_list_entry('', false, do_lang_tempcode('NA_EM')));
            $lang_files->attach(create_selection_list_lang_files());
            $field_set->attach(form_input_list(do_lang_tempcode('CODENAME'), do_lang_tempcode('DESCRIPTION_LANGUAGE_FILE'), 'lang_file', $lang_files, null, true));

            $field_set->attach(form_input_line(do_lang('SEARCH'), '', 'search', '', false));

            $fields->attach(alternate_fields_set__end($set_name, $set_title, '', $field_set, $required));
        }

        $post_url = get_self_url(false, false, null, false, true);

        return do_template('FORM_SCREEN', array(
            '_GUID' => 'ee6bdea3661cb4736173cac818a769e5',
            'GET' => true,
            'SKIP_WEBSTANDARDS' => true,
            'HIDDEN' => '',
            'SUBMIT_ICON' => 'buttons__proceed',
            'SUBMIT_NAME' => do_lang_tempcode('PROCEED'),
            'TITLE' => $title,
            'FIELDS' => $fields,
            'URL' => $post_url,
            'TEXT' => $text,
            'JAVASCRIPT' => $javascript,
        ));
    }

    /**
     * Finds equivalents for a given string, in a different language, by automatic searching of codes and content.
     *
     * @param  string $old The language string we are searching for the equivalent of
     * @param  LANGUAGE_NAME $lang The language we want an equivalent in
     * @return string The match (or blank if no match can be found)
     */
    public function find_lang_matches($old, $lang)
    {
        // Search for pretranslated content
        $potentials = $GLOBALS['SITE_DB']->query_select('translate', array('id'), array('text_original' => $old, 'language' => get_site_default_lang()));
        foreach ($potentials as $potential) {
            $test = $GLOBALS['SITE_DB']->query_select_value_if_there('translate', 'text_original', array('id' => $potential['id'], 'language' => $lang));
            if (!is_null($test)) {
                return $test;
            }
        }

        // Search code strings
        global $LANGUAGE_STRINGS_CACHE;

        if (!array_key_exists(user_lang(), $LANGUAGE_STRINGS_CACHE)) {
            return '';
        }
        $finds = array_keys($LANGUAGE_STRINGS_CACHE[user_lang()], $old);
        foreach ($finds as $find) {
            if ((array_key_exists($lang, $LANGUAGE_STRINGS_CACHE)) && (array_key_exists($find, $LANGUAGE_STRINGS_CACHE[$lang]))) {
                return $LANGUAGE_STRINGS_CACHE[$lang][$find];
            }
        }

        return '';
    }

    /**
     * The UI to criticise a language pack.
     *
     * @return Tempcode The UI
     */
    public function criticise()
    {
        $lang = get_param_string('crit_lang', '');
        if ($lang == '') {
            return $this->choose_lang($this->title, false, false, do_lang_tempcode('CHOOSE_CRITICISE_LIST_LANG_FILE'), false, 'crit_lang');
        }

        $files = '';

        $missing = array();

        if (fallback_lang() == $lang) {
            warn_exit(do_lang_tempcode('CANNOT_CRITICISE_BASE_LANG'));
        }

        $lang_files_base = get_lang_files(fallback_lang());
        $lang_files_criticise = get_lang_files($lang);

        foreach (array_keys($lang_files_base) as $file_base) {
            $file = new Tempcode();

            if (array_key_exists($file_base, $lang_files_criticise)) {
                // Process this file
                $base_map = get_lang_file_map(fallback_lang(), $file_base, true);
                $criticise_map = get_lang_file_map($lang, $file_base);

                foreach ($base_map as $key => $val) {
                    if (array_key_exists($key, $criticise_map)) {
                        $is = $criticise_map[$key];

                        // Perhaps we have a parameter mismatch?
                        if (strpos($val, '{3}') !== false) {
                            $num = 3;
                        } elseif (strpos($val, '{2}') !== false) {
                            $num = 2;
                        } elseif (strpos($val, '{1}') !== false) {
                            $num = 1;
                        } else {
                            $num = 0;
                        }

                        if (strpos($is, '{3}') !== false) {
                            $num_is = 3;
                        } elseif (strpos($is, '{2}') !== false) {
                            $num_is = 2;
                        } elseif (strpos($is, '{1}') !== false) {
                            $num_is = 1;
                        } else {
                            $num_is = 0;
                        }

                        if ($num_is != $num) {
                            $crit = do_template('TRANSLATE_LANGUAGE_CRITICISM', array('_GUID' => '424388712f07bde0a04d89b0f349a0de', 'CRITICISM' => do_lang_tempcode('CRITICISM_PARAMETER_COUNT_MISMATCH', escape_html($key), escape_html($val))));
                            $file->attach($crit);
                        }

                        unset($criticise_map[$key]);
                    } elseif (trim($val) != '') {
                        $crit = do_template('TRANSLATE_LANGUAGE_CRITICISM', array('_GUID' => '1c06d1d7c26ed73787eef6bfd912f57a', 'CRITICISM' => do_lang_tempcode('CRITICISM_MISSING_STRING', escape_html($key), escape_html($val))));
                        $file->attach($crit);
                    }
                }

                foreach ($criticise_map as $key => $val) {
                    $crit = do_template('TRANSLATE_LANGUAGE_CRITICISM', array('_GUID' => '550018f24c0f677c50cd1bba96f24cc8', 'CRITICISM' => do_lang_tempcode('CRITICISM_EXTRA_STRING', escape_html($key))));
                    $file->attach($crit);
                }
            } else {
                $missing[] = $file_base;
            }

            if (!$file->is_empty()) {
                $file_result = do_template('TRANSLATE_LANGUAGE_CRITICISE_FILE', array('_GUID' => '925ae4a8dc34fed864c3072734a9abe5', 'COMPLAINTS' => $file, 'FILENAME' => $file_base));
                $files .= $file_result->evaluate();/*FUDGE*/
            }
        }

        if (count($missing) != 0) {
            foreach ($missing as $missed) {
                $crit = do_template('TRANSLATE_LANGUAGE_CRITICISM', array('_GUID' => 'c19b1e83b5119495b52baf942e829336', 'CRITICISM' => do_lang_tempcode('CRITICISM_MISSING_FILE', escape_html($missed))));
                $file->attach($crit);
            }
            $file_result = do_template('TRANSLATE_LANGUAGE_CRITICISE_FILE', array('_GUID' => '4ffab9265ea8c5a5e99a7b9fb23d15e1', 'COMPLAINTS' => $file, 'FILENAME' => do_lang_tempcode('NA_EM')));
            $files .= $file_result->evaluate();/*FUDGE*/
        }

        return do_template('TRANSLATE_LANGUAGE_CRITICISE_SCREEN', array('_GUID' => '62d6f40ca69609a8fd33704a8a38fb6f', 'TITLE' => $this->title, 'FILES' => $files));
    }

    /**
     * The UI to translate content.
     *
     * @return Tempcode The UI
     */
    public function interface_content()
    {
        if (!multi_lang()) {
            warn_exit(do_lang_tempcode('MULTILANG_OFF'));
        }

        if (!multi_lang_content()) {
            warn_exit(do_lang_tempcode('MULTILANG_OFF_CONTENT'));
        }

        $max = get_param_integer('max', 100);
        $start = get_param_integer('start', 0);

        $lang = choose_language($this->title);
        if (is_object($lang)) {
            return $lang;
        }

        // Find what we haven't translated
        $query = 'FROM ' . get_table_prefix() . 'translate a LEFT JOIN ' . get_table_prefix() . 'translate b ON a.id=b.id AND b.broken=0 AND ' . db_string_equal_to('b.language', $lang) . ' WHERE b.id IS NULL AND ' . db_string_not_equal_to('a.language', $lang) . ' AND ' . db_string_not_equal_to('a.text_original', '');
        $to_translate = $GLOBALS['SITE_DB']->query('SELECT a.* ' . $query . ($GLOBALS['SITE_DB']->can_arbitrary_groupby() ? ' GROUP BY a.id' : '') . ' ORDER BY a.importance_level,a.id DESC', $max/*reasonable limit*/, $start);
        $total = $GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(*) ' . $query);
        if (count($to_translate) == 0) {
            inform_exit(do_lang_tempcode('NOTHING_TO_TRANSLATE'));
        }

        require_all_lang($lang, true);
        require_all_open_lang_files($lang);

        // Make our translation page
        require_code('form_templates');
        $lines = '';
        $google = $this->get_google_code($lang);
        $actions = make_string_tempcode('&nbsp;');
        $last_level = null;
        $too_many = (count($to_translate) == $max);
        $ids_to_lookup = array();
        foreach ($to_translate as $it) {
            $ids_to_lookup[] = $it['id'];
        }
        $names = find_lang_content_names($ids_to_lookup);
        $_to_translate = array();
        foreach ($to_translate as $i => $it) {
            if ($it['importance_level'] == 0) {
                continue; // Corrupt data
            }

            $id = $it['id'];
            $name = $names[$id];
            if (is_null($name)) {
                continue; // Orphaned string
            }

            $_to_translate[] = $it;
        }
        $to_translate = $_to_translate;
        foreach ($to_translate as $i => $it) {
            $old = $it['text_original'];
            $current = $this->find_lang_matches($old, $lang);
            $priority = ($last_level === $it['importance_level']) ? null : do_lang('PRIORITY_' . strval($it['importance_level']));

            $id = $it['id'];
            $name = $names[$id];

            if ($google != '') {
                $actions = do_template('TRANSLATE_ACTION', array('_GUID' => 'f625cf15c9db5e5af30fc772a7f0d5ff', 'LANG_FROM' => $it['language'], 'LANG_TO' => $lang, 'NAME' => 'trans_' . strval($id), 'OLD' => $old));
            }

            check_suhosin_request_quantity(2, strlen('trans_' . $name));

            $line = do_template('TRANSLATE_LINE_CONTENT', array('_GUID' => '87a0f5298ce9532839f3206cd0e06051', 'NAME' => $name, 'ID' => strval($id), 'OLD' => $old, 'CURRENT' => $current, 'ACTIONS' => $actions, 'PRIORITY' => $priority, 'LAST' => !isset($to_translate[$i + 1])));
            $lines .= $line->evaluate(); /*XHTMLXHTML*/

            $last_level = $it['importance_level'];
        }

        $url = build_url(array('page' => '_SELF', 'type' => '_content', 'lang' => $lang, 'start' => $start), '_SELF');

        $_GET['lang'] = $lang;
        require_code('templates_pagination');
        $pagination = pagination(do_lang('TRANSLATE_CONTENT'), $start, 'start', $max, 'max', $total, true);

        return do_template('TRANSLATE_SCREEN_CONTENT_SCREEN', array(
            '_GUID' => 'af732c5e595816db1c6f025c4b8fa6a2',
            'MAX' => integer_format($max),
            'TOTAL' => integer_format($total - $max),
            'LANG_ORIGINAL_NAME' => get_site_default_lang(),
            'LANG_NICE_ORIGINAL_NAME' => lookup_language_full_name(get_site_default_lang()),
            'LANG_NICE_NAME' => lookup_language_full_name($lang),
            'TOO_MANY' => $too_many,
            'GOOGLE' => $google,
            'LANG' => $lang,
            'LINES' => $lines,
            'TITLE' => $this->title,
            'URL' => $url,
            'PAGINATION' => $pagination,
        ));
    }

    /**
     * The actualiser to translate content.
     *
     * @return Tempcode The UI
     */
    public function set_lang_content()
    {
        $lang = choose_language($this->title);
        if (is_object($lang)) {
            return $lang;
        }

        foreach ($_POST as $key => $val) {
            if (!is_string($val)) {
                continue;
            }
            if (substr($key, 0, 6) != 'trans_') {
                continue;
            }

            $lang_id = intval(substr($key, 6));

            if (get_magic_quotes_gpc()) {
                $val = stripslashes($val);
            }

            if ($val != '') {
                $GLOBALS['SITE_DB']->query_delete('translate', array('language' => $lang, 'id' => $lang_id), '', 1);
                $importance_level = $GLOBALS['SITE_DB']->query_select_value_if_there('translate', 'importance_level', array('id' => $lang_id));
                if (!is_null($importance_level)) {
                    $GLOBALS['SITE_DB']->query_insert('translate', array('id' => $lang_id, 'source_user' => get_member(), 'language' => $lang, 'importance_level' => $importance_level, 'text_original' => $val, 'text_parsed' => '', 'broken' => 0));
                }
            }
        }

        log_it('TRANSLATE_CONTENT');

        require_code('caches3');
        erase_block_cache();
        erase_persistent_cache();

        if (get_param_integer('contextual', 0) == 1) {
            return inform_screen($this->title, do_lang_tempcode('SUCCESS'));
        }

        // Show it worked / Refresh
        $url = post_param_string('redirect', null);
        if (is_null($url)) {
            $_url = build_url(array('page' => '_SELF', 'type' => 'content', 'lang' => $lang, 'start' => get_param_integer('start', null)), '_SELF');
            $url = $_url->evaluate();
        }
        return redirect_screen($this->title, $url, do_lang_tempcode('SUCCESS'));
    }

    /**
     * The UI to translate code.
     *
     * @return Tempcode The UI
     */
    public function interface_code()
    {
        $lang = filter_naughty_harsh(get_param_string('lang', ''));
        $lang_new = get_param_string('lang_new', $lang);
        if ($lang_new != '') {
            require_code('type_sanitisation');
            if (!is_alphanumeric($lang_new, true)) {
                warn_exit(do_lang_tempcode('BAD_CODENAME'));
            }

            if (strlen($lang_new) > 5) {
                warn_exit(do_lang_tempcode('INVALID_LANG_CODE'));
            }
            $lang = $lang_new;
        }
        if ($lang == '') {
            $choose_message = do_lang_tempcode(
                'CHOOSE_EDIT_LIST_LANG_FILE',
                escape_html(get_site_default_lang()),
                escape_html(lookup_language_full_name(get_site_default_lang())),
                array(
                    get_base_url() . '/code_editor.php',
                    escape_html(user_lang()),
                    escape_html(lookup_language_full_name(user_lang()))
                )
            );
            return $this->choose_lang($this->title, true, true, $choose_message);
        }

        $base_lang = fallback_lang();

        $map_a = get_file_base() . '/lang/langs.ini';
        $map_b = get_custom_file_base() . '/lang_custom/langs.ini';

        $search = get_param_string('search', '', true);
        if ($search != '') {
            $search = trim($search, '" ');

            require_code('form_templates');
            $fields = new Tempcode();
            global $LANGUAGE_STRINGS_CACHE;
            foreach ($LANGUAGE_STRINGS_CACHE[user_lang()] as $key => $value) {
                if (stripos($value, $search) !== false) {
                    $fields->attach(form_input_text($key, '', 'l_' . $key, str_replace('\n', "\n", $value), false));
                }
            }
            if ($fields->is_empty()) {
                inform_exit(do_lang_tempcode('NO_ENTRIES'));
            }
            $post_url = build_url(array('page' => '_SELF', 'type' => '_code2'), '_SELF');
            $hidden = new Tempcode();
            $hidden->attach(form_input_hidden('redirect', get_self_url(true)));
            $hidden->attach(form_input_hidden('lang', $lang));
            return do_template('FORM_SCREEN', array('_GUID' => '2d7356fd2c4497ceb19450e65331c9c5', 'TITLE' => $this->title, 'HIDDEN' => $hidden, 'FIELDS' => $fields, 'URL' => $post_url, 'TEXT' => '', 'SUBMIT_ICON' => 'buttons__save', 'SUBMIT_NAME' => do_lang('TRANSLATE_CODE')));
        }
        $lang_file = get_param_string('lang_file');
        if (!file_exists($map_b)) {
            $map_b = $map_a;
        }
        require_code('files');
        $map = better_parse_ini_file($map_b);

        // Upgrade to custom if not there yet (or maybe we are creating a new lang - same difference)
        $custom_dir = get_custom_file_base() . '/lang_custom/' . $lang;
        if (!file_exists($custom_dir)) {
            appengine_live_guard();

            require_code('abstract_file_manager');
            force_have_afm_details();

            afm_make_directory('lang_custom/' . $lang, true);

            $cached_dir = get_custom_file_base() . '/caches/lang/' . $lang;
            if (!file_exists($cached_dir)) {
                afm_make_directory('caches/lang/' . $lang, true);
            }

            // Make comcode page dirs
            $zones = find_all_zones();
            foreach ($zones as $zone) {
                $_special_dir = get_custom_file_base() . '/' . $zone . '/pages/comcode_custom/' . $lang;
                if (!file_exists($_special_dir)) {
                    afm_make_directory($zone . (($zone == '') ? '' : '/') . 'pages/comcode_custom/' . $lang, true);
                }
                $_special_dir = get_custom_file_base() . '/' . $zone . '/pages/html_custom/' . $lang;
                if (!file_exists($_special_dir)) {
                    afm_make_directory($zone . (($zone == '') ? '' : '/') . 'pages/html_custom/' . $lang, true);
                }
            }

            // Make templates_cached dirs
            require_code('themes2');
            $themes = find_all_themes();
            foreach (array_keys($themes) as $theme) {
                $_special_dir = get_custom_file_base() . '/themes/' . $theme . '/templates_cached/' . $lang;
                if (!file_exists($_special_dir)) {
                    afm_make_directory('themes/' . $theme . '/templates_cached/' . $lang, true);
                }
            }
        }

        // Get some stuff
        $for_lang = get_lang_file_map($lang, $lang_file);
        $for_base_lang = get_lang_file_map($base_lang, $lang_file, true);
        $descriptions = get_lang_file_section($base_lang, $lang_file);

        // Make our translation page
        $lines = '';
        $google = $this->get_google_code($lang);
        $actions = new Tempcode();
        $next = 0;
        $trans_lot = '';
        $delimit = "\n" . '=-=-=-=-=-=-=-=-' . "\n";
        foreach ($for_base_lang as $name => $old) {
            if (array_key_exists($name, $for_lang)) {
                $current = $for_lang[$name];
            } else {
                $current = '';//$this->find_lang_matches($old, $lang); Too slow / useless for code translation
            }
            if (($current == '') && (strtolower($name) != $name)) {
                $trans_lot .= str_replace('\n', "\n", str_replace(array('{', '}'), array('(((', ')))'), $old)) . $delimit;
            }
        }

        $translated_stuff = array();
        if (($trans_lot != '') && ($google != '')) {
            $result = http_download_file('http://translate.google.com/translate_t', null, false, false, 'Composr', array('text' => $trans_lot, 'langpair' => 'en|' . $google));
            if (!is_null($result)) {
                require_code('character_sets');

                $result = convert_to_internal_encoding($result);

                $matches = array();
                if (preg_match('#<div id=result_box dir="ltr">(.*)</div>#Us', convert_to_internal_encoding($result), $matches) != 0) {
                    $result2 = $matches[1];
                    $result2 = @html_entity_decode($result2, ENT_QUOTES, get_charset());
                    $result2 = preg_replace('#\s?<br>\s?#', "\n", $result2);
                    $result2 = str_replace('> ', '>', str_replace(' <', ' <', str_replace('</ ', '</', str_replace(array('(((', ')))'), array('{', '}'), $result2))));
                    $translated_stuff = explode(trim($delimit), $result2 . "\n");
                }
            }
        }
        foreach ($for_base_lang + $for_lang as $name => $old) {
            if (array_key_exists($name, $for_lang)) {
                $current = $for_lang[$name];
            } else {
                $current = '';//$this->find_lang_matches($old, $lang); Too slow / useless for code translation
            }
            $description = array_key_exists($name, $descriptions) ? $descriptions[$name] : '';
            if (($current == '') && (strtolower($name) != $name) && (array_key_exists($next, $translated_stuff))) {
                $_current = '';
                $translate_auto = trim($translated_stuff[$next]);
                $next++;
            } else {
                $_current = str_replace('\n', "\n", $current);
                $translate_auto = null;
            }
            if ($_current == '') {
                $_current = str_replace('\n', "\n", $old);
            }

            if (($google != '') && (get_option('google_translate_api_key') != '')) {
                $actions = do_template('TRANSLATE_ACTION', array('_GUID' => '9e9a68cb2c1a1e23a901b84c9af2280b', 'LANG_FROM' => get_site_default_lang(), 'LANG_TO' => $lang, 'NAME' => 'trans_' . $name, 'OLD' => $_current));
            }

            $temp = do_template('TRANSLATE_LINE', array('_GUID' => '9cb331f5852ee043e6ad30b45aedc43b', 'TRANSLATE_AUTO' => $translate_auto, 'DESCRIPTION' => $description, 'NAME' => $name, 'OLD' => str_replace('\n', "\n", $old), 'CURRENT' => $_current, 'ACTIONS' => $actions));
            $lines .= $temp->evaluate();
        }

        $url = build_url(array('page' => '_SELF', 'type' => '_code', 'lang_file' => $lang_file, 'lang' => $lang), '_SELF');

        return do_template('TRANSLATE_SCREEN', array('_GUID' => 'b3429f8bd0b4eb79c33709ca43e3207c', 'PAGE' => $lang_file, 'GOOGLE' => (get_option('google_translate_api_key') != '') ? $google : '', 'LANG' => $lang, 'LINES' => $lines, 'TITLE' => $this->title, 'URL' => $url));
    }

    /**
     * Convert a standard language codename to a google code.
     *
     * @param  LANGUAGE_NAME $in The code to convert
     * @return string The converted code (or blank if none can be found)
     */
    public function get_google_code($in)
    {
        if ($in == fallback_lang()) {
            return '';
        }
        return strtolower($in);
    }

    /**
     * The actualiser to translate code (called from this module).
     *
     * @return Tempcode The UI
     */
    public function set_lang_code()
    {
        decache('side_language');
        require_code('caches3');
        erase_block_cache();

        $lang = get_param_string('lang');
        $lang_file = get_param_string('lang_file');

        $for_base_lang = get_lang_file_map(fallback_lang(), $lang_file, true);
        $for_base_lang_2 = get_lang_file_map($lang, $lang_file, false);
        $descriptions = get_lang_file_section(fallback_lang(), $lang_file);
        $runtime_processing = get_lang_file_section(fallback_lang(), $lang_file, 'runtime_processing');

        if ((count($_POST) == 0) && (cms_srv('REQUEST_METHOD') != 'POST')) {
            warn_exit(do_lang_tempcode('IMPROPERLY_FILLED_IN'));
        }

        if (!file_exists(get_custom_file_base() . '/lang_custom/' . filter_naughty($lang))) {
            require_code('files2');
            make_missing_directory(get_custom_file_base() . '/lang_custom/' . filter_naughty($lang));
        }

        $path = get_custom_file_base() . '/lang_custom/' . filter_naughty($lang) . '/' . filter_naughty($lang_file) . '.ini';
        $path_backup = $path . '.' . strval(time());
        if (file_exists($path)) {
            @copy($path, $path_backup) or intelligent_write_error($path_backup);
            sync_file($path_backup);
        }
        $myfile = @fopen($path, GOOGLE_APPENGINE ? 'wb' : 'at');
        if ($myfile === false) {
            intelligent_write_error($path);
        }
        @flock($myfile, LOCK_EX);
        if (!GOOGLE_APPENGINE) {
            ftruncate($myfile, 0);
        }
        fwrite($myfile, "[descriptions]\n");
        foreach ($descriptions as $key => $description) {
            if (fwrite($myfile, $key . '=' . $description . "\n") == 0) {
                warn_exit(do_lang_tempcode('COULD_NOT_SAVE_FILE'), false, true);
            }
        }
        fwrite($myfile, "\n"); // Weird bug with IIS GOOGLE_APPENGINE?'wb':'wt' writing needs this to be on a separate line
        fwrite($myfile, "[runtime_processing]\n");
        foreach ($runtime_processing as $key => $flag) {
            if (fwrite($myfile, $key . '=' . $flag . "\n") == 0) {
                warn_exit(do_lang_tempcode('COULD_NOT_SAVE_FILE'), false, true);
            }
        }
        fwrite($myfile, "\n"); // Weird bug with IIS GOOGLE_APPENGINE?'wb':'wt' writing needs this to be on a separate line
        fwrite($myfile, "[strings]\n");
        foreach (array_unique(array_merge(array_keys($for_base_lang), array_keys($for_base_lang_2))) as $key) {
            $val = post_param_string($key, null);
            if (($val === null) && (!array_key_exists($key, $for_base_lang))) {
                $val = $for_base_lang_2[$key]; // Not in lang, but is in lang_custom, AND not set now - must copy though
            }
            if (($val !== null) && ((!array_key_exists($key, $for_base_lang)) || (str_replace("\n", '\n', $val) != $for_base_lang[$key]))) {
                if (fwrite($myfile, $key . '=' . str_replace("\n", '\n', $val) . "\n") == 0) {
                    warn_exit(do_lang_tempcode('COULD_NOT_SAVE_FILE'), false, true);
                }
            }
        }
        @flock($myfile, LOCK_UN);
        fclose($myfile);
        fix_permissions($path);
        sync_file($path);
        $path_backup2 = $path . '.latest_in_cms_edit';
        @copy($path, $path_backup2) or intelligent_write_error($path_backup2);
        sync_file($path_backup2);

        log_it('TRANSLATE_CODE');

        require_code('caches3');
        erase_cached_language();
        erase_cached_templates(false, null, TEMPLATE_DECACHE_WITH_LANG);
        persistent_cache_delete('LANGS_LIST');

        // Show it worked / Refresh
        $url = build_url(array('page' => '_SELF', 'type' => 'browse'), '_SELF');
        return redirect_screen($this->title, $url, do_lang_tempcode('SUCCESS'));
    }

    /**
     * The actualiser to translate code (called externally, and may operate on many lang files).
     *
     * @return Tempcode The UI
     */
    public function set_lang_code_2()
    {
        $lang = post_param_string('lang');

        if (!file_exists(get_custom_file_base() . '/lang_custom/' . filter_naughty($lang))) {
            require_code('files2');
            make_missing_directory(get_custom_file_base() . '/lang_custom/' . filter_naughty($lang));
        }

        $lang_files = get_lang_files(fallback_lang());

        foreach (array_keys($lang_files) as $lang_file) {
            $for_base_lang = get_lang_file_map(fallback_lang(), $lang_file, true);
            $for_base_lang_2 = get_lang_file_map($lang, $lang_file, false);
            $descriptions = get_lang_file_section(fallback_lang(), $lang_file);
            $runtime_processing = get_lang_file_section(fallback_lang(), $lang_file, 'runtime_processing');

            $out = '';

            $one_changed_from_saved = false;

            foreach ($for_base_lang_2 + $for_base_lang as $key => $disk_val) {
                $val = post_param_string('l_' . $key, str_replace('\n', "\n", array_key_exists($key, $for_base_lang_2) ? $for_base_lang_2[$key] : $disk_val));
                $changed_from_saved = ($val != str_replace('\n', "\n", $disk_val)); // was already changed in language file
                $not_a_default = (!array_key_exists($key, $for_base_lang)); // not in default Composr
                $changed_from_default = !$not_a_default && ($for_base_lang[$key] != $val); // changed from default Composr
                $no_default_file = (!file_exists(get_file_base() . '/lang/' . fallback_lang() . '/' . $lang_file . '.ini')); // whole file is not in default Composr
                if ($changed_from_saved || $not_a_default || $changed_from_default || $no_default_file) {
                    $out .= $key . '=' . str_replace("\n", '\n', $val) . "\n";
                }
                if ($changed_from_saved) {
                    $one_changed_from_saved = true;
                }
            }

            if ($out != '' && $one_changed_from_saved) {
                $path = get_custom_file_base() . '/lang_custom/' . filter_naughty($lang) . '/' . filter_naughty($lang_file) . '.ini';
                $path_backup = $path . '.' . strval(time());
                if (file_exists($path)) {
                    @copy($path, $path_backup) or intelligent_write_error($path_backup);
                    sync_file($path_backup);
                }
                $myfile = @fopen($path, GOOGLE_APPENGINE ? 'wb' : 'at');
                if ($myfile === false) {
                    intelligent_write_error($path);
                }
                @flock($myfile, LOCK_EX);
                if (!GOOGLE_APPENGINE) {
                    ftruncate($myfile, 0);
                }
                if (count($descriptions) != 0) {
                    fwrite($myfile, "[descriptions]\n");
                    foreach ($descriptions as $key => $description) {
                        if (fwrite($myfile, $key . '=' . $description . "\n") == 0) {
                            warn_exit(do_lang_tempcode('COULD_NOT_SAVE_FILE'), false, true);
                        }
                    }
                    fwrite($myfile, "\n"); // Weird bug with IIS GOOGLE_APPENGINE?'wb':'wt' writing needs this to be on a separate line
                }
                if (count($runtime_processing) != 0) {
                    fwrite($myfile, "[runtime_processing]\n");
                    foreach ($runtime_processing as $key => $flag) {
                        if (fwrite($myfile, $key . '=' . $flag . "\n") == 0) {
                            warn_exit(do_lang_tempcode('COULD_NOT_SAVE_FILE'), false, true);
                        }
                    }
                    fwrite($myfile, "\n"); // Weird bug with IIS GOOGLE_APPENGINE?'wb':'wt' writing needs this to be on a separate line
                }
                fwrite($myfile, "[strings]\n");
                fwrite($myfile, $out);
                @flock($myfile, LOCK_UN);
                fclose($myfile);
                fix_permissions($path);
                sync_file($path);
                $path_backup2 = $path . '.latest_in_cms_edit';
                @copy($path, $path_backup2) or intelligent_write_error($path_backup2);
                sync_file($path_backup2);
            }
        }

        log_it('TRANSLATE_CODE');

        require_code('caches3');
        erase_cached_language();
        erase_cached_templates(false, null, TEMPLATE_DECACHE_WITH_LANG);
        persistent_cache_delete('LANGS_LIST');

        // Show it worked / Refresh
        $url = post_param_string('redirect', '');
        if ($url == '') {
            return inform_screen($this->title, do_lang_tempcode('SUCCESS'));
        }
        return redirect_screen($this->title, $url, do_lang_tempcode('SUCCESS'));
    }
}

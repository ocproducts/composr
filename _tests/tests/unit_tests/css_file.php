<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

// Pass &debug=1 for extra checks that would not be expected to ever consistently pass

/**
 * Composr test case class (unit testing).
 */
class css_file_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        require_code('themes2');
        require_code('images');
        require_code('files2');
    }

    public function testClassUsage()
    {
        $debug = get_param_integer('debug', 0);
        $only_theme = get_param_string('only_theme', null);

        $themes = find_all_themes();
        foreach (array_keys($themes) as $theme) {
            if ($theme == '_unnamed_') {
                continue;
            }

            if (($only_theme !== null) && ($theme != $only_theme)) {
                continue;
            }

            $_classes_defined = array_merge($this->findClassesDefined('default'), $this->findClassesDefined($theme));
            sort($_classes_defined);
            $classes_defined = array_flip($_classes_defined);

            $_classes_used = array_merge($this->findClassesUsed('default'), $this->findClassesUsed($theme));
            sort($_classes_used);
            $classes_used = array_flip($_classes_used);

            if ($debug == 1) {
                foreach (array_keys($classes_used) as $class) {
                    // Exceptions
                    if (strpos($class, 'box___') !== false) {
                        continue;
                    }

                    $this->assertTrue(isset($classes_defined[$class]), 'CSS class used but not defined: ' . $class . ' (for theme: ' . $theme . ')');
                }
            }

            foreach (array_keys($classes_defined) as $class) {
                if ($this->isClassDefinedAndIntentionallyNotExplicitlyUsed($class)) {
                    continue;
                }

                $this->assertTrue(isset($classes_used[$class]), 'CSS class defined but not used: ' . $class . ' (for theme: ' . $theme . ')');
            }
        }
    }

    protected function findClassesDefined($theme)
    {
        $out = array();

        $directories = array(
             get_file_base() . '/themes/' . $theme . '/css_custom',
             get_file_base() . '/themes/' . $theme . '/css',
        );

        foreach ($directories as $dir) {
            $d = opendir($dir);
            while (($e = readdir($d)) !== false) {
                if (substr($e, -4) == '.css') {
                    // Exceptions
                    if ($e == 'svg.css') {
                        continue;
                    }

                    $contents = file_get_contents($dir . '/' . $e);
                    $matches = array();
                    $found = preg_match_all('#\.([a-z][a-z_\d\-]*)[ ,:]#i', $contents, $matches);
                    for ($i = 0; $i < $found; $i++) {
                        if ($matches[1][$i] != 'txt') {
                            $out[] = $matches[1][$i];
                        }
                    }
                }
            }
            closedir($d);
        }

        return array_unique($out);
    }

    protected function findClassesUsed($theme)
    {
        $out = array();

        $directories = array(
             get_file_base() . '/themes/' . $theme . '/templates_custom',
             get_file_base() . '/themes/' . $theme . '/templates',
             get_file_base() . '/themes/' . $theme . '/javascript_custom',
             get_file_base() . '/themes/' . $theme . '/javascript',
        );

        foreach ($directories as $dir) {
            $d = opendir($dir);
            while (($e = readdir($d)) !== false) {
                if (substr($e, -4) == '.tpl' || substr($e, -3) == '.js') {
                    $contents = file_get_contents($dir . '/' . $e);
                    $matches = array();
                    $found = preg_match_all('#class="([\w\- ]+)"#', $contents, $matches);
                    for ($i = 0; $i < $found; $i++) {
                        $out = array_merge($out, explode(' ', $matches[1][$i]));
                    }
                }
            }
            closedir($d);
        }

        return array_unique($out);
    }

    public function testSelectorUsage()
    {
        $only_theme = get_param_string('only_theme', null);

        $themes = find_all_themes();
        foreach (array_keys($themes) as $theme) {
            if ($theme == '_unnamed_') {
                continue;
            }

            if (($only_theme !== null) && ($theme != $only_theme)) {
                continue;
            }

            $directories = array(
                 get_file_base() . '/themes/default/css_custom' => ($theme == 'default'),
                 get_file_base() . '/themes/default/css' => ($theme == 'default'),
                 get_file_base() . '/themes/default/templates_custom' => ($theme == 'default'),
                 get_file_base() . '/themes/default/templates' => ($theme == 'default'),
                 get_file_base() . '/themes/default/javascript_custom' => ($theme == 'default'),
                 get_file_base() . '/themes/default/javascript' => ($theme == 'default'),
            );
            if ($theme != 'default') {
                $directories = array_merge($directories, array(
                    get_file_base() . '/themes/' . $theme . '/css_custom' => true,
                    get_file_base() . '/themes/' . $theme . '/css' => true,
                    get_file_base() . '/themes/' . $theme . '/templates_custom' => true,
                    get_file_base() . '/themes/' . $theme . '/templates' => true,
                    get_file_base() . '/themes/' . $theme . '/javascript_custom' => true,
                    get_file_base() . '/themes/' . $theme . '/javascript' => true,
                ));
            }

            $non_css_contents = '';
            $selector_files = array();

            foreach ($directories as $dir => $to_use) {
                $dh = opendir($dir);
                while (($f = readdir($dh)) !== false) {
                    // Exceptions
                    $exceptions = array(
                        'columns.css',
                        'google_search.css',
                        'jquery_ui.css',
                        'mediaelementplayer.css',
                        'openid.css',
                        'skitter.css',
                        'svg.css',
                        'widget_color.css',
                        'widget_date.css',
                        'widget_select2.css',
                    );
                    if (in_array($f, $exceptions)) {
                        continue;
                    }

                    $contents = file_get_contents($dir . '/' . $f);

                    $is_css_file = (substr($f, -4) == '.css');

                    if ($is_css_file) {
                        if (!$to_use) {
                            continue;
                        }

                        // Let's do a few simple CSS checks, less than a proper validator would do
                        if (($is_css_file) && (strpos($contents, '{$,Parser hint: pure}') === false)) {
                            // Test comment/brace balancing
                            $a = substr_count($contents, '{');
                            $b = substr_count($contents, '}');
                            $this->assertTrue($a == $b, 'Mismatched braces in ' . $f . ' in ' . $theme . ', ' . integer_format($a) . ' vs ' . integer_format($b));
                            $a = substr_count($contents, '/*');
                            $b = substr_count($contents, '*/');
                            $this->assertTrue($a == $b, 'Mismatched comments in ' . $f . ' in ' . $theme . ', ' . integer_format($a) . ' vs ' . integer_format($b));

                            // Strip comments
                            $contents = preg_replace('#/\*.*\*/#s', '', $contents);

                            // Test selectors
                            $matches = array();
                            $num_matches = preg_match_all('#^\s*[^@\s].*[^%\s]\s*\{$#m', $contents, $matches); // Finds selectors. However NB: @ is media rules, % is keyframe rules, neither are selectors.
                            for ($i = 0; $i < $num_matches; $i++) {
                                $matches2 = array();
                                $current = $matches[0][$i];
                                $current = /*strip CSS syntax*/preg_replace('#[:@][\w\-]+#', '', $current);
                                $current = /*strip quotes*/preg_replace('#"[^"]*"#', '', $current);
                                $current = /*strip bracketed section*/preg_replace('#\([^\(\)]*\)#', '', $current);
                                $num_matches2 = /*find class/ID words*/preg_match_all('#[\w\-]+#', $current, $matches2);
                                for ($j = 0; $j < $num_matches2; $j++) {
                                    if (!isset($selector_files[$f])) {
                                        $selector_files[$f] = array();
                                    }
                                    $selector_files[$f][$matches2[0][$j]] = true;
                                }
                            }
                        }
                    } else {
                        $non_css_contents .= $contents;
                    }
                }
                closedir($dh);
            }

            foreach ($selector_files as $file => $selectors) {
                ksort($selectors);
                foreach (array_keys($selectors) as $selector) {
                    // Exceptions
                    if ($this->isClassDefinedAndIntentionallyNotExplicitlyUsed($selector)) {
                        continue;
                    }
                    if ($this->isIDDefinedAndIntentionallyNotExplicitlyUsed($selector)) {
                        continue;
                    }

                    $this->assertTrue(strpos($non_css_contents, $selector) !== false, 'Possibly unused CSS selector for theme ' . $theme . ', ' . $file . ': ' . $selector);
                }
            }
        }
    }

    protected function isClassDefinedAndIntentionallyNotExplicitlyUsed($class)
    {
        $prefix_exceptions = array(
            'zone_running_',
            'page_running_',
            'menu__',
            'buttons__',
            'box___block_no_entries_',
            'cns_gcol_',
            'calendar_priority_',
            'cke_',
            'bubble_',
            'attitude_',
            'input_',
            'align',
            'display_type_',
        );
        if (preg_match('#^' . implode('|', $prefix_exceptions) . '#', $class) != 0) {
            return true;
        }

        $exceptions = array(
            'active_item',
            'thick_border',
            'access_restricted_in_list',
            'activated_quote_button',
            'activities_content__remove_failure',
            'activities_content__remove_success',
            'adminzone_search',
            'ajax_loading_block',
            'ajax_tree_magic_button',
            'alert',
            'alt_field',
            'archive_link',
            'associated_breadcrumbs',
            'associated_details_smaller',
            'attachment_left',
            'attachment_right',
            'author_defined',
            'author_undefined',
            'being_dragged',
            'big_tab_active',
            'big_tab_inactive',
            'block_main_members__avatars',
            'block_main_members__media',
            'block_main_members__photos',
            'blue',
            'box___block_main_content',
            'box___block_menu_embossed',
            'box___standardbox_accordion',
            'box_scroll_thumbs',
            'bubble',
            'buildr_self_member',
            'button_screen_item_tall',
            'calendar_active',
            'calendar_current',
            'calendar_day',
            'calendar_free_time',
            'calendar_free_time_hourly',
            'calendar_month_day',
            'calendar_multiple',
            'calendar_year_month_day',
            'chat_lobby_convos_current_tab',
            'chat_lobby_convos_tab_first',
            'chat_lobby_convos_tab_new_messages',
            'chat_lobby_convos_tab_uptodate',
            'chat_message',
            'chat_message_old',
            'chat_operator_staff',
            'chat_options',
            'checked',
            'cms_keep',
            'cms_keep_block',
            'cns_edit_forum_forum',
            'cns_forum_topic_indent',
            'cns_forum_topic_wrapper_column_column6',
            'cns_forum_topic_wrapper_column_column6_shorter',
            'cns_guest_column_b',
            'cns_member_box_avatar_touching',
            'cns_on',
            'cns_post_emphasis',
            'cns_post_map_item_unread',
            'cns_post_personal',
            'column',
            'column_wrapper',
            'column_wrapper_2',
            'com',
            'command_output',
            'comments_sorting_box',
            'confirm',
            'count_0',
            'crossword',
            'cse',
            'css',
            'csstransitions',
            'current',
            'decryption_overlay',
            'delete_cross_button',
            'dh',
            'divider',
            'doc_link',
            'e',
            'faded_tooltip_img',
            'feature_background_image',
            'feature_image',
            'feature_video',
            'feed_link',
            'fieldset',
            'filledin',
            'footer_button_loading',
            'footer_links',
            'form_table_description_above_cell',
            'form_table_description_under_cell',
            'form_table_huge_field_description_is_under',
            'fp_col_block',
            'fp_col_blocks_wrap',
            'fractional_edit',
            'frame',
            'friend_active',
            'friend_inactive',
            'ghost',
            'global_community_message',
            'global_helper_panel_text_over',
            'green',
            'h',
            'has_img',
            'has_item_width',
            'has_preview',
            'have_links',
            'helper_panel',
            'helper_panel_hidden',
            'hero_button',
            'hero_section',
            'highlighted_post',
            'hover',
            'hover__dark',
            'icon_14_export',
            'im_event',
            'im_popup_avatar',
            'im_popup_close_button',
            'image_number',
            'image_number_select',
            'info_slide_dots',
            'info_slide_thumb',
            'js',
            'js_widget',
            'label',
            'leave_native_tooltip',
            'legend',
            'light_table',
            'lightbox_image',
            'linear',
            'link',
            'link__dark',
            'link_exempt2',
            'loading_overlay',
            'magic_image_edit_link',
            'media_link',
            'media_set',
            'menu_editor_selected_field',
            'menu_type__top',
            'message',
            'mobile',
            'moono',
            'mousemove',
            'must_show_together',
            'native_ui_foreground',
            'native_ui_selected',
            'non_current',
            'notes_about',
            'notification',
            'notification_code',
            'notification_has_read',
            'odp_link',
            'ods_link',
            'odt_link',
            'openid_large_btn',
            'openid_small_btn',
            'opens_below',
            'overlay',
            'overlay_close_button',
            'p',
            'pagination_load_more',
            'paused',
            'pdf_link',
            'people_list',
            'pic',
            'play_button',
            'plupload',
            'pointstore_item_tag',
            'popup_spacer',
            'post',
            'ppt_link',
            'preview_box',
            'previous_button',
            'proceed_button_left_2',
            'radio_list_picture',
            'radio_list_picture_na',
            'rating_box',
            'rating_likers',
            'rating_star',
            'rating_star_highlight',
            'rating_stars',
            'red',
            'related_field',
            'required',
            'responsive',
            'rss_copyright',
            'rss_main',
            'rss_main_inner',
            'scroll_thumbs',
            'selected',
            'site_special_message_alt_inner',
            'site_unloading',
            'sitewide_im_popup_body',
            'skip_step_button_wrap_with_req_note',
            'sku',
            'sortable_table',
            'standard_field_name',
            'status_green',
            'status_orange',
            'tabs__member_account__warnings',
            'theme_image__background_theme_image',
            'theme_image__logo_theme_image',
            'theme_image_preview',
            'theme_image_preview_wide',
            'tooltip',
            'tooltip_img',
            'tooltip_nolayout',
            'tooltip_ownlayout',
            'tooltip_with_img',
            'topic_list_title',
            'topic_list_topic',
            'toplevel',
            'toplevel_link',
            'torrent_link',
            'touch_enabled',
            'tpl',
            'tpl_dropdown_row_a',
            'tpl_dropdown_row_b',
            'tree_list_highlighted',
            'tree_list_nonhighlighted',
            'txt_link',
            'unclosed_ticket',
            'unslider',
            'up_alert',
            'v',
            'validated_checkbox',
            'version',
            'version_button',
            'version_details',
            'version_help_icon',
            'version_news_link',
            'version_number',
            'visited',
            'vr',
            'width',
            'wysiwyg_toolbar_color_finder',
            'ze_panel_expanded',
            'ze_textarea',
            'ze_textarea_middle',
            'zebra_0',
            'zebra_1',
            'hide_if_in_panel',
            'hide_if_not_in_panel',
            'AOL',
            'Blogger',
            'ClaimID',
            'Flickr',
            'Google',
            'LiveJournal',
            'MyOpenID',
            'MySpace',
            'OpenID',
            'Technorati',
            'Vidoop',
            'Wordpress',
            'Yahoo',
            'cellDebug',
            'cellDebugA',
            'cellDebugB',
            'cellEmpty',
            'cellEmptyA',
            'cellEmptyB',
            'cellLetter',
            'cellLetterA',
            'cellLetterB',
            'cellNumber',
            'cellNumberA',
            'cellNumberB',
            'crossTable',
            'crossTableA',
            'crossTableB',
            'progressBarComplete',
            'progressBarError',
            'progressBarInProgress',
            'progressBarStatus',
            'progressCancel',
            'progressContainer',
            'progressName',
            'progressWrapper',
            'questionTable',
            'less_compact',
            'ace_layer',
            'ch-timespan',
            'code',
            'coding_standards_tables',
            'date-closed',
            'date-datepicker-button',
            'date-open',
            'external_link',
            'file_changed',
            'file_unchanged',
            'glowing_node',
            'gsc-branding',
            'gsc-input',
            'gsc-search-button',
            'hidden_save_frame',
            'local_payment_merchant_details_simple',
            'main_website_faux',
            'me-cannotplay',
            'me-plugin',
            'mejs-background',
            'mejs-backlight-off',
            'mejs-backlight-on',
            'mejs-captions-translations',
            'mejs-chapter-block',
            'mejs-chapter-block-last',
            'mejs-container',
            'mejs-container-fullscreen',
            'mejs-embed',
            'mejs-fullscreen',
            'mejs-jump-forward-button',
            'mejs-long-video',
            'mejs-loop-off',
            'mejs-loop-on',
            'mejs-pause',
            'mejs-picturecontrols-button',
            'mejs-sourcechooser-button',
            'mejs-sourcechooser-selector',
            'mejs-unfullscreen',
            'mejs-unmute',
            'modern_subtab_bodies',
            'modern_subtab_headers',
            'modern_subtabs',
            'no-svg',
            'popup_blocker_warning',
            'preview_box_inner',
            'radio_list',
            'radio_list_pictures',
            'select2-active',
            'select2-ajax-error',
            'select2-allowclear',
            'select2-arrow',
            'select2-choice',
            'select2-choices',
            'select2-chosen',
            'select2-container',
            'select2-container-active',
            'select2-container-disabled',
            'select2-container-multi',
            'select2-default',
            'select2-disabled',
            'select2-display-none',
            'select2-drop',
            'select2-drop-above',
            'select2-drop-active',
            'select2-drop-auto-width',
            'select2-drop-mask',
            'select2-dropdown-open',
            'select2-hidden-accessible',
            'select2-highlighted',
            'select2-locked',
            'select2-match',
            'select2-measure-scrollbar',
            'select2-more-results',
            'select2-no-results',
            'select2-offscreen',
            'select2-result-label',
            'select2-result-selectable',
            'select2-result-sub',
            'select2-result-unselectable',
            'select2-result-with-children',
            'select2-results',
            'select2-results-dept-1',
            'select2-results-dept-2',
            'select2-results-dept-3',
            'select2-results-dept-4',
            'select2-results-dept-5',
            'select2-results-dept-6',
            'select2-results-dept-7',
            'select2-search',
            'select2-search-choice',
            'select2-search-choice-close',
            'select2-search-choice-focus',
            'select2-search-field',
            'select2-searching',
            'select2-selected',
            'select2-selection-limit',
            'skitter-clean',
            'skitter-minimalist',
            'skitter-round',
            'skitter-square',
            'sp-1',
            'sp-2',
            'sp-3',
            'sp-4',
            'sp-5',
            'sp-6',
            'sp-active',
            'sp-alpha',
            'sp-alpha-enabled',
            'sp-alpha-handle',
            'sp-alpha-inner',
            'sp-button-container',
            'sp-buttons-disabled',
            'sp-cancel',
            'sp-cf',
            'sp-clear',
            'sp-clear-display',
            'sp-clear-enabled',
            'sp-color',
            'sp-container',
            'sp-dd',
            'sp-disabled',
            'sp-dragger',
            'sp-dragging',
            'sp-fill',
            'sp-flat',
            'sp-hidden',
            'sp-hue',
            'sp-initial',
            'sp-initial-disabled',
            'sp-input',
            'sp-input-container',
            'sp-input-disabled',
            'sp-palette',
            'sp-palette-button-container',
            'sp-palette-buttons-disabled',
            'sp-palette-container',
            'sp-palette-disabled',
            'sp-palette-only',
            'sp-picker-container',
            'sp-preview',
            'sp-preview-inner',
            'sp-replacer',
            'sp-sat',
            'sp-slider',
            'sp-thumb-active',
            'sp-thumb-el',
            'sp-top',
            'sp-top-inner',
            'sp-val',
            'sp-validation-error',
            'suggested',
            'table-autofilter',
            'table-filtered',
            'table-sortable',
            'table-sorted-asc',
            'table-sorted-desc',
            'theme_wizard_use_colour',
            'time-spin-btn',
            'time-spin-btn-container',
            'time-spin-btn-down',
            'time-spin-btn-up',
            'ui-accordion',
            'ui-accordion-content',
            'ui-accordion-header',
            'ui-accordion-header-icon',
            'ui-accordion-icons',
            'ui-autocomplete',
            'ui-button',
            'ui-button-icon-only',
            'ui-button-icon-primary',
            'ui-button-icon-secondary',
            'ui-button-icons-only',
            'ui-button-text',
            'ui-button-text-icon-primary',
            'ui-button-text-icon-secondary',
            'ui-button-text-icons',
            'ui-button-text-only',
            'ui-buttonset',
            'ui-corner-all',
            'ui-corner-bl',
            'ui-corner-bottom',
            'ui-corner-br',
            'ui-corner-left',
            'ui-corner-right',
            'ui-corner-tl',
            'ui-corner-top',
            'ui-corner-tr',
            'ui-datepicker',
            'ui-datepicker-buttonpane',
            'ui-datepicker-calendar',
            'ui-datepicker-current',
            'ui-datepicker-group',
            'ui-datepicker-group-last',
            'ui-datepicker-group-middle',
            'ui-datepicker-header',
            'ui-datepicker-month',
            'ui-datepicker-multi',
            'ui-datepicker-multi-2',
            'ui-datepicker-multi-3',
            'ui-datepicker-multi-4',
            'ui-datepicker-next',
            'ui-datepicker-next-hover',
            'ui-datepicker-prev',
            'ui-datepicker-prev-hover',
            'ui-datepicker-row-break',
            'ui-datepicker-rtl',
            'ui-datepicker-title',
            'ui-datepicker-year',
            'ui-dialog',
            'ui-dialog-buttonpane',
            'ui-dialog-buttonset',
            'ui-dialog-content',
            'ui-dialog-title',
            'ui-dialog-titlebar',
            'ui-dialog-titlebar-close',
            'ui-draggable',
            'ui-draggable-handle',
            'ui-front',
            'ui-helper-clearfix',
            'ui-helper-hidden',
            'ui-helper-hidden-accessible',
            'ui-helper-reset',
            'ui-helper-zfix',
            'ui-icon',
            'ui-icon-alert',
            'ui-icon-arrow-1-e',
            'ui-icon-arrow-1-n',
            'ui-icon-arrow-1-ne',
            'ui-icon-arrow-1-nw',
            'ui-icon-arrow-1-s',
            'ui-icon-arrow-1-se',
            'ui-icon-arrow-1-sw',
            'ui-icon-arrow-1-w',
            'ui-icon-arrow-2-e-w',
            'ui-icon-arrow-2-n-s',
            'ui-icon-arrow-2-ne-sw',
            'ui-icon-arrow-2-se-nw',
            'ui-icon-arrow-4',
            'ui-icon-arrow-4-diag',
            'ui-icon-arrowrefresh-1-e',
            'ui-icon-arrowrefresh-1-n',
            'ui-icon-arrowrefresh-1-s',
            'ui-icon-arrowrefresh-1-w',
            'ui-icon-arrowreturn-1-e',
            'ui-icon-arrowreturn-1-n',
            'ui-icon-arrowreturn-1-s',
            'ui-icon-arrowreturn-1-w',
            'ui-icon-arrowreturnthick-1-e',
            'ui-icon-arrowreturnthick-1-n',
            'ui-icon-arrowreturnthick-1-s',
            'ui-icon-arrowreturnthick-1-w',
            'ui-icon-arrowstop-1-e',
            'ui-icon-arrowstop-1-n',
            'ui-icon-arrowstop-1-s',
            'ui-icon-arrowstop-1-w',
            'ui-icon-arrowthick-1-e',
            'ui-icon-arrowthick-1-n',
            'ui-icon-arrowthick-1-ne',
            'ui-icon-arrowthick-1-nw',
            'ui-icon-arrowthick-1-s',
            'ui-icon-arrowthick-1-se',
            'ui-icon-arrowthick-1-sw',
            'ui-icon-arrowthick-1-w',
            'ui-icon-arrowthick-2-e-w',
            'ui-icon-arrowthick-2-n-s',
            'ui-icon-arrowthick-2-ne-sw',
            'ui-icon-arrowthick-2-se-nw',
            'ui-icon-arrowthickstop-1-e',
            'ui-icon-arrowthickstop-1-n',
            'ui-icon-arrowthickstop-1-s',
            'ui-icon-arrowthickstop-1-w',
            'ui-icon-battery-0',
            'ui-icon-battery-1',
            'ui-icon-battery-2',
            'ui-icon-battery-3',
            'ui-icon-blank',
            'ui-icon-bookmark',
            'ui-icon-bullet',
            'ui-icon-calculator',
            'ui-icon-calendar',
            'ui-icon-cancel',
            'ui-icon-carat-1-e',
            'ui-icon-carat-1-n',
            'ui-icon-carat-1-ne',
            'ui-icon-carat-1-nw',
            'ui-icon-carat-1-s',
            'ui-icon-carat-1-se',
            'ui-icon-carat-1-sw',
            'ui-icon-carat-1-w',
            'ui-icon-carat-2-e-w',
            'ui-icon-carat-2-n-s',
            'ui-icon-cart',
            'ui-icon-check',
            'ui-icon-circle-arrow-e',
            'ui-icon-circle-arrow-n',
            'ui-icon-circle-arrow-s',
            'ui-icon-circle-arrow-w',
            'ui-icon-circle-check',
            'ui-icon-circle-close',
            'ui-icon-circle-minus',
            'ui-icon-circle-plus',
            'ui-icon-circle-triangle-e',
            'ui-icon-circle-triangle-n',
            'ui-icon-circle-triangle-s',
            'ui-icon-circle-triangle-w',
            'ui-icon-circle-zoomin',
            'ui-icon-circle-zoomout',
            'ui-icon-circlesmall-close',
            'ui-icon-circlesmall-minus',
            'ui-icon-circlesmall-plus',
            'ui-icon-clipboard',
            'ui-icon-clock',
            'ui-icon-close',
            'ui-icon-closethick',
            'ui-icon-comment',
            'ui-icon-contact',
            'ui-icon-copy',
            'ui-icon-disk',
            'ui-icon-document',
            'ui-icon-document-b',
            'ui-icon-eject',
            'ui-icon-extlink',
            'ui-icon-flag',
            'ui-icon-folder-collapsed',
            'ui-icon-folder-open',
            'ui-icon-gear',
            'ui-icon-grip-diagonal-se',
            'ui-icon-grip-dotted-horizontal',
            'ui-icon-grip-dotted-vertical',
            'ui-icon-grip-solid-horizontal',
            'ui-icon-grip-solid-vertical',
            'ui-icon-gripsmall-diagonal-se',
            'ui-icon-heart',
            'ui-icon-help',
            'ui-icon-home',
            'ui-icon-image',
            'ui-icon-info',
            'ui-icon-key',
            'ui-icon-lightbulb',
            'ui-icon-link',
            'ui-icon-locked',
            'ui-icon-mail-closed',
            'ui-icon-mail-open',
            'ui-icon-minus',
            'ui-icon-minusthick',
            'ui-icon-newwin',
            'ui-icon-note',
            'ui-icon-notice',
            'ui-icon-pause',
            'ui-icon-pencil',
            'ui-icon-person',
            'ui-icon-pin-s',
            'ui-icon-pin-w',
            'ui-icon-play',
            'ui-icon-plus',
            'ui-icon-plusthick',
            'ui-icon-power',
            'ui-icon-print',
            'ui-icon-radio-off',
            'ui-icon-radio-on',
            'ui-icon-refresh',
            'ui-icon-scissors',
            'ui-icon-script',
            'ui-icon-search',
            'ui-icon-seek-end',
            'ui-icon-seek-first',
            'ui-icon-seek-next',
            'ui-icon-seek-prev',
            'ui-icon-seek-start',
            'ui-icon-shuffle',
            'ui-icon-signal',
            'ui-icon-signal-diag',
            'ui-icon-squaresmall-close',
            'ui-icon-squaresmall-minus',
            'ui-icon-squaresmall-plus',
            'ui-icon-star',
            'ui-icon-stop',
            'ui-icon-suitcase',
            'ui-icon-tag',
            'ui-icon-transfer-e-w',
            'ui-icon-transferthick-e-w',
            'ui-icon-trash',
            'ui-icon-triangle-1-e',
            'ui-icon-triangle-1-n',
            'ui-icon-triangle-1-ne',
            'ui-icon-triangle-1-nw',
            'ui-icon-triangle-1-s',
            'ui-icon-triangle-1-se',
            'ui-icon-triangle-1-sw',
            'ui-icon-triangle-1-w',
            'ui-icon-triangle-2-e-w',
            'ui-icon-triangle-2-n-s',
            'ui-icon-unlocked',
            'ui-icon-video',
            'ui-icon-volume-off',
            'ui-icon-volume-on',
            'ui-icon-wrench',
            'ui-icon-zoomin',
            'ui-icon-zoomout',
            'ui-menu',
            'ui-menu-divider',
            'ui-menu-icon',
            'ui-menu-icons',
            'ui-menu-item',
            'ui-priority-primary',
            'ui-priority-secondary',
            'ui-progressbar',
            'ui-progressbar-indeterminate',
            'ui-progressbar-overlay',
            'ui-progressbar-value',
            'ui-resizable',
            'ui-resizable-autohide',
            'ui-resizable-disabled',
            'ui-resizable-e',
            'ui-resizable-handle',
            'ui-resizable-n',
            'ui-resizable-ne',
            'ui-resizable-nw',
            'ui-resizable-s',
            'ui-resizable-se',
            'ui-resizable-sw',
            'ui-resizable-w',
            'ui-selectable',
            'ui-selectable-helper',
            'ui-selectmenu-button',
            'ui-selectmenu-menu',
            'ui-selectmenu-open',
            'ui-selectmenu-optgroup',
            'ui-selectmenu-text',
            'ui-slider',
            'ui-slider-handle',
            'ui-slider-horizontal',
            'ui-slider-range',
            'ui-slider-range-max',
            'ui-slider-range-min',
            'ui-slider-vertical',
            'ui-sortable-handle',
            'ui-spinner',
            'ui-spinner-button',
            'ui-spinner-down',
            'ui-spinner-input',
            'ui-spinner-up',
            'ui-state-active',
            'ui-state-default',
            'ui-state-disabled',
            'ui-state-error',
            'ui-state-error-text',
            'ui-state-focus',
            'ui-state-highlight',
            'ui-state-hover',
            'ui-tabs',
            'ui-tabs-active',
            'ui-tabs-anchor',
            'ui-tabs-collapsible',
            'ui-tabs-loading',
            'ui-tabs-nav',
            'ui-tabs-panel',
            'ui-tooltip',
            'ui-widget',
            'ui-widget-content',
            'ui-widget-header',
            'ui-widget-overlay',
            'ui-widget-shadow',
            'wp-caption',
        );
        if (in_array($class, $exceptions)) {
            return true;
        }

        return false;
    }

    protected function isIDDefinedAndIntentionallyNotExplicitlyUsed($id)
    {
        $prefix_exceptions = array(
            't_1_',
            'jump_to_',
            'sort_filedump_',
            'type_filter_',
            'edit_panel_',
            'info_panel_',
            'settings_panel_',
            'view_panel_',
        );
        if (preg_match('#^' . implode('|', $prefix_exceptions) . '#', $id) != 0) {
            return true;
        }

        $exceptions = array(
            'xslt_introduction',
        );
        if (in_array($id, $exceptions)) {
            return true;
        }

        return false;
    }
}

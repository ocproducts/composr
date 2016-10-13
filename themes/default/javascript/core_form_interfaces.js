(function ($cms) {
    'use strict';

    // Templates:
    // POSTING_FORM
    // - POSTING_FIELD
    function PostingForm() {
        $cms.View.apply(this, arguments);
    }

    $cms.inherits(PostingForm, $cms.View, {
        events: {
            'submit .js-submit-modsec-workaround': 'workaround',
            'click .js-click-toggle-subord-fields': 'toggleSubordinateFields',
            'keypress .js-keypress-toggle-subord-fields': 'toggleSubordinateFields'
        },

        workaround: function (e, target) {
            e.preventDefault();
            modsecurity_workaround(target);
        },

        toggleSubordinateFields: function (e, target) {
            toggle_subordinate_fields(target.parentNode.querySelector('img'), 'fes_attachments_help');
        }
    });

    function FromScreenInputUpload() {
        $cms.View.apply(this, arguments);

        if (options.plupload && !$cms.$IS_HTTPAUTH_LOGIN) {
            preinit_file_input('upload', options.name, null, null, options.filter);
        }

        if (options.syndicationJson !== undefined) {
            show_upload_syndication_options(options.name, options.syndicationJson);
        }
    }

    $cms.inherits(FromScreenInputUpload, $cms.View);

    function FormScreenInputPermission(options) {
        $cms.View.apply(this, arguments);

        this.groupId = options.groupId;
        this.prefix = 'access_' + this.groupId;
        var prefix = this.prefix;

        if (!options.allGlobal) {
            var list = document.getElementById(prefix + '_presets');
            // Test to see what we wouldn't have to make a change to get - and that is what we're set at
            if (!copy_permission_presets(prefix, '0', true)) list.selectedIndex = list.options.length - 4;
            else if (!copy_permission_presets(prefix, '1', true)) list.selectedIndex = list.options.length - 3;
            else if (!copy_permission_presets(prefix, '2', true)) list.selectedIndex = list.options.length - 2;
            else if (!copy_permission_presets(prefix, '3', true)) list.selectedIndex = list.options.length - 1;
        }
    }

    $cms.inherits(FormScreenInputPermission, $cms.View, {
        groupId: null,
        prefix: null,

        events: {
            'click .js-click-copy-perm-presets': 'copyPresets',
            'change .js-change-copy-perm-presets': 'copyPresets',
            'click .js-click-perm-repeating': 'permissionRepeating'
        },

        copyPresets: function (e, select) {
            copy_permission_presets(this.prefix, select.options[select.selectedIndex].value);
            cleanup_permission_list(this.prefix);
        },

        permissionRepeating: function (e, button) {
            var name = this.prefix,
                old_permission_copying = window.permission_copying,
                tr = button.parentNode.parentNode,
                trs = tr.parentNode.getElementsByTagName('tr');

            if (window.permission_copying) {// Undo current copying
                document.getElementById('copy_button_' + window.permission_copying).style.textDecoration = 'none';
                window.permission_copying = null;
                for (var i = 0; i < trs.length; i++) {
                    trs[i].onclick = function () {};
                }
            }

            if (old_permission_copying !== name)  {// Starting a new copying session
                button.style.textDecoration = 'blink';
                window.permission_copying = name;
                window.fauxmodal_alert('{!permissions:REPEAT_PERMISSION_NOTICE;^}');
                for (var i = 0; i < trs.length; i++) {
                    if (trs[i] !== tr) {
                        trs[i].onclick = copy_permissions_function(trs[i], tr);
                    }
                }
            }

            function copy_permissions_function(to_row, from_row) {
                return function () {
                    var inputs_to = to_row.getElementsByTagName('input');
                    var inputs_from = from_row.getElementsByTagName('input');
                    for (var i = 0; i < inputs_to.length; i++) {
                        inputs_to[i].checked = inputs_from[i].checked;
                    }
                    var selects_to = to_row.getElementsByTagName('select');
                    var selects_from = from_row.getElementsByTagName('select');
                    for (var i = 0; i < selects_to.length; i++) {
                        while (selects_to[i].options.length > 0) {
                            selects_to[i].remove(0);
                        }
                        for (var j = 0; j < selects_from[i].options.length; j++) {
                            selects_to[i].add(selects_from[i].options[j].cloneNode(true), null);
                        }
                        selects_to[i].selectedIndex = selects_from[i].selectedIndex;
                        selects_to[i].disabled = selects_from[i].disabled;
                    }
                }
            }
        }
    });

    function FormScreenInputPermissionOverride(options) {
        $cms.View.apply(this, arguments);

        var prefix = 'access_' + options.groupId;

        this.groupId = options.groupId;
        this.prefix  = prefix;

        setup_privilege_override_selector(prefix, options.defaultAccess, options.privilege, options.title, !!options.allGlobal);

        if (!options.allGlobal) {
            var list = document.getElementById(prefix + '_presets');
            // Test to see what we wouldn't have to make a change to get - and that is what we're set at
            if (!copy_permission_presets(prefix, '0', true)) list.selectedIndex = list.options.length - 4;
            else if (!copy_permission_presets(prefix, '1', true)) list.selectedIndex = list.options.length - 3;
            else if (!copy_permission_presets(prefix, '2', true)) list.selectedIndex = list.options.length - 2;
            else if (!copy_permission_presets(prefix, '3', true)) list.selectedIndex = list.options.length - 1;
        }
    }

    $cms.inherits(FormScreenInputPermissionOverride, $cms.View, {
        groupId: null,
        prefix: null,

        events: {
            'click .js-click-perms-overridden': 'permissionsOverridden',
            'change .js-change-perms-overridden': 'permissionsOverridden',
            'mouseover .js-mouseover-show-perm-setting': 'showPermissionSetting'
        },

        permissionsOverridden: function () {
            permissions_overridden(this.prefix);
        },

        showPermissionSetting: function (e, select) {
            if (select.options[select.selectedIndex].value === '-1') {
                show_permission_setting(select);
            }
        }
    });

    function FormStandardEnd() {
        $cms.View.apply(this, arguments);

        this.form = $cms.dom.closest(this.el, 'form');
        this.btnSubmit = this.$('#submit_button');

        window.form_preview_url = options.previewUrl;

        if (options.forcePreviews) {
            this.btnSubmit.style.display = 'none';
        }

        if (options.javascript) {
            eval.call(window, options.javascript);
        }

        if (!options.secondaryForm) {
            this.fixFormEnterKey();
        }

        if (options.supportAutosave && options.formName) {
            if (init_form_saving !== undefined) {
                init_form_saving(options.formName);
            }
        }
    }

    $cms.inherits(FormStandardEnd, $cms.View, {
        form: null,
        btnSubmit: null,

        events: {
            'click .js-click-do-form-preview': 'doFormPreview',
            'click .js-click-do-form-submit': 'doFormSubmit'
        },

        doFormPreview: function (e) {
            var form = this.form,
                separatePreview = !!this.options.separatePreview;

            if (do_form_preview(e, form, window.form_preview_url, separatePreview) && !window.just_checking_requirements) {
                form.submit();
            }
        },

        doFormSubmit: function (e) {
           if (!do_form_submit(this.form, e)) {
               e.preventDefault();
           }
        },

        fixFormEnterKey: function (form) {
            var form = this.form;
            var submit = document.getElementById('submit_button');
            var inputs = form.getElementsByTagName('input');
            var type;
            for (var i = 0; i < inputs.length; i++) {
                type = inputs[i].type;
                if (((type == 'text') || (type == 'password') || (type == 'color') || (type == 'email') || (type == 'number') || (type == 'range') || (type == 'search') || (type == 'tel') || (type == 'url'))
                    && (submit.onclick !== undefined) && (submit.onclick)
                    && ((inputs[i].onkeypress === undefined) || (!inputs[i].onkeypress)))
                    inputs[i].onkeypress = function (event) {
                        if (enter_pressed(event)) submit.onclick(event);
                    };
            }
        }
    });

    $cms.views.FormStandardEnd = FormStandardEnd;
    $cms.views.PostingForm = PostingForm;
    $cms.views.FromScreenInputUpload = FromScreenInputUpload;
    $cms.views.FormScreenInputPermission = FormScreenInputPermission;
    $cms.views.FormScreenInputPermissionOverride = FormScreenInputPermissionOverride;

    $cms.extend($cms.templates, {
        form: function (options) {
            options = options || {};

            if (!!options.isJoinForm) {
                joinForm(options);
            }
        },

        formScreen: function (options) {
            var container = this;

            options = options || {};

            try_to_simplify_iframe_form();

            if (options.iframeUrl) {
                window.setInterval(function() { resize_frame('iframe_under'); }, 1500);

                $cms.dom.on(container, 'click', '.js-checkbox-will-open-new', function (e, checkbox) {
                    var form = $cms.dom.id(container, 'main_form');

                    form.action = checkbox.checked ? options.url : options.iframeUrl;
                    form.elements.opens_below.value = checkbox.checked ? '0' : '1';
                    form.target = checkbox.checked ? '_blank' : 'iframe_under';
                });
            }
        },

        formScreenField_input: function (options) {
            var el = $cms.dom.id('form_table_field_input__' + options.randomisedId);
            if (el) {
                set_up_change_monitor(el.parentElement);
            }
        },

        formScreenInputLine: function formScreenInputLine(options) {
            set_up_comcode_autocomplete(options.name, !!options.wysiwyg);
        },

        formScreenInputCombo: function (options) {
            document.getElementById(options.name).onkeyup();

            if (window.HTMLDataListElement === undefined) {
                document.getElementById(options.name).className = 'input_line';
            }
        },

        formScreenInputHugeComcode: function (options) {
            var textarea = $cms.dom.id(options.name),
                input = $cms.dom.id('form_table_field_input__' + options.randomisedId);

            if (options.required.includes('wysiwyg') && wysiwyg_on()) {
                textarea.readOnly = true;
            }

            if (input) {
                set_up_change_monitor(input.parentElement);
            }

            manage_scroll_height(textarea);
            set_up_comcode_autocomplete(options.name, options.required.includes('wysiwyg'));
        },

        formScreenInputColour: function (options) {
            var label = options.rawField ? ' ' : options.prettyName;

            make_colour_chooser(options.name, options.default, '', options.tabindex, label, 'input_colour' + options._required);
            do_color_chooser();
        },

        formScreenInputTreeList: function formScreenInputTreeList(options) {
            var hook = $cms.filter.url(options.hook),
                rootId = $cms.filter.url(options.rootId),
                opts =  $cms.filter.url(options.options),
                multiSel = !!options.multiSelect;

            $cms.createTreeList(options.name, 'data/ajax_tree.php?hook=' + hook + $cms.$KEEP, rootId, opts, multiSel, options.tabIndex, false, !!options.useServerId);
        },

        formScreenInputPermissionMatrix: function (options) {
            var container = this;
            window.perm_serverid = options.serverId;

            $cms.dom.on(container, 'click', '.js-click-permissions-toggle', function (e, clicked) {
                permissions_toggle(clicked.parentNode)
            });

            function permissions_toggle(cell) {
                var index = cell.cellIndex;
                var table = cell.parentNode.parentNode;
                if (table.localName !== 'table') table = table.parentNode;
                var state_list = null, state_checkbox = null;
                for (var i = 0; i < table.rows.length; i++) {
                    if (i >= 1) {
                        var cell2 = table.rows[i].cells[index];
                        var input = cell2.querySelector('input');
                        if (input) {
                            if (!input.disabled) {
                                if (state_checkbox == null) state_checkbox = input.checked;
                                input.checked = !state_checkbox;
                            }
                        } else {
                            input = cell2.querySelector('select');
                            if (state_list == null) state_list = input.selectedIndex;
                            input.selectedIndex = ((state_list != input.options.length - 1) ? (input.options.length - 1) : (input.options.length - 2));
                            input.disabled = false;

                            permissions_overridden(table.rows[i].id.replace(/_privilege_container$/, ''));
                        }
                    }
                }
            }
        },

        formScreenFieldsSetItem: function formScreenFieldsSetItem(options) {
            var el = $cms.dom.$('#form_table_field_input__' + options.name);

            if (el) {
                set_up_change_monitor(el.parentElement);
            }
        },

        formScreenFieldSpacer: function (options) {
            options || (options = {});
            var container = this,
                title = $cms.filter.id(options.title);

            if (title && options.sectionHidden) {
                $cms.dom.id('fes' + title).click();
            }

            $cms.dom.on(container, 'click', '.js-click-toggle-subord-fields', function (e, clicked) {
                toggle_subordinate_fields(clicked.parentNode.querySelector('img'),'fes' + title + '_help');
            });

            $cms.dom.on(container, 'keypress', '.js-keypress-toggle-subord-fields', function (e, pressed) {
                toggle_subordinate_fields(pressed.parentNode.querySelector('img'),'fes' + title + '_help');
            });

            $cms.dom.on(container, 'click', '.js-click-geolocate-address-fields', function () {
                geolocate_address_fields();
            });
        },

        formScreenInputTick: function (options) {
            var el = this;

            if (options.name === 'validated') {
                $cms.dom.on(el, 'click', function () {
                    el.previousSibling.className = 'validated_checkbox' + (el.checked ? ' checked' : '');
                });
            }

            if (options.name === 'delete') {
                assign_tick_deletion_confirm(options.name);
            }

            function assign_tick_deletion_confirm(name) {
                var el = document.getElementById(name);

                el.onchange = function () {
                    if (this.checked) {
                        window.fauxmodal_confirm(
                            '{!ARE_YOU_SURE_DELETE;^}',
                            function (result) {
                                if (result) {
                                    var form = el.form;
                                    if (!form.action.includes('_post')) {// Remove redirect if redirecting back, IF it's not just deleting an on-page post (Wiki+)
                                        form.action = form.action.replace(/([&\?])redirect=[^&]*/, '$1');
                                    }
                                } else {
                                    el.checked = false;
                                }
                            }
                        );
                    }
                }
            }
        },

        formScreenInputCaptcha: function formScreenInputCaptcha(options) {
            if ($cms.$CONFIG_OPTION.jsCaptcha) {
                $cms.dom.html(document.getElementById('captcha_spot'), options.captcha);
            } else {
                window.addEventListener('pageshow', function () {
                    document.getElementById('captcha_readable').src += '&r=' + $cms.random(); // Force it to reload latest captcha
                });
            }
        },

        formScreenInputList: function formScreenInputList(options, images) {
            var el, selectOptions;

            if (options.inlineList) {
                return;
            }

            el = $cms.dom.id(options.name);
            selectOptions = {
                dropdownAutoWidth: true,
                containerCssClass: 'wide_field'
            };

            if (images.length) {
                selectOptions.formatResult = formatSelectImage;
            }

            if (window.jQuery && (el.options.length > 20)/*only for long lists*/ && (!el.options[0].value.match(/^\d+$/)/*not for lists of numbers*/)) {
                window.jQuery(el).select2(selectOptions);
            }

            function formatSelectImage(o) {
                if (!o.id) {
                    return o.text; // optgroup
                }

                for (var imgId in images) {
                    if (o.id === imgId) {
                        return '<span class="vertical_alignment inline_lined_up"><img style="width: 24px;" src="' + images[imgId] + '" \/> ' + escape_html(o.text) + '</span>';
                    }
                }

                return escape_html(o.text);
            }
        },

        formScreenFieldsSet: function (options) {
            standard_alternate_fields_within(options.setName, !!options.required);
        },

        formScreenInputThemeImageEntry: function (options) {
            var name = $cms.filter.id(options.name),
                code = $cms.filter.id(options.code),
                stem = name + '_' + code,
                e = document.getElementById('w_' + stem),
                img = e.querySelector('img'),
                input = document.getElementById('j_' + stem),
                label = e.querySelector('label'),
                form = input.form;

            e.onkeypress = function (event) {
                if (enter_pressed(event)) {
                    return e.onclick.call([event]);
                }
                return null;
            };

            function click_func(event) {
                choose_picture('j_' + stem, img, name, event);

                if (window.main_form_very_simple !== undefined) form.submit();

                cancel_bubbling(event);
            }
            img.onkeypress = click_func;
            img.onclick = click_func;
            e.onclick = click_func;

            label.className = 'js_widget';

            input.onclick = function () {
                if (this.disabled) return;
                if (window.deselect_alt_url !== undefined) deselect_alt_url(this.form);
                if (window.main_form_very_simple !== undefined) this.form.submit();
                cancel_bubbling(event);
            }
        },

        formScreenInputHuge_input: function (options) {
            var textArea = document.getElementById(options.name),
                el = $cms.dom.$('#form_table_field_input__' + options.randomisedId);

            if (el) {
                set_up_change_monitor(el.parentElement);
            }

            manage_scroll_height(textArea);

            if (!$cms.$MOBILE) {
                $cms.dom.on(textArea, 'change keyup', function () {
                    manage_scroll_height(textArea);
                });
            }
        },

        formScreenInputHugeList_input: function (options) {
            var el = $cms.dom.$('#form_table_field_input__' + options.randomisedId);

            if (!options.inlineList && el) {
                set_up_change_monitor(el.parentElement);
            }
        },

        previewScript: function () {
            var container = this,
                inner = $cms.dom.$(container, '.js-preview-box-scroll');

            if (inner) {
                $cms.dom.on(inner, browser_matches('gecko') ? 'DOMMouseScroll' : 'mousewheel', function (event) {
                    inner.scrollTop -= event.wheelDelta ? event.wheelDelta : event.detail;
                    cancel_bubbling(event);
                    event.preventDefault();
                    return false;
                });
            }

            $cms.dom.on(container, 'click', '.js-click-preview-mobile-button', function (event, el) {
                el.form.action = el.form.action.replace(/keep_mobile=\d/g, 'keep_mobile=' + (el.checked ? '1' : '0'));
                if (window.parent) {
                    try {
                        window.parent.scrollTo(0, find_pos_y(window.parent.document.getElementById('preview_iframe')));
                    } catch (e) {
                    }
                    window.parent.mobile_version_for_preview = !!el.checked;
                    window.parent.document.getElementById('preview_button').onclick(event);
                    return;
                }

                el.form.submit();
            });
        },

        postingField: function postingField(options) {
            var postEl = document.getElementById(options.name);

            if (options.class.includes('wysiwyg')) {
                if ((window.wysiwyg_on) && (wysiwyg_on())) {
                    postEl.readOnly = true; // Stop typing while it loads

                    window.setTimeout(function () {
                        if (postEl.value === postEl.defaultValue) {
                            postEl.readOnly = false; // Too slow, maybe WYSIWYG failed due to some network issue
                        }
                    }, 3000);
                }

                if (options.wordCounter !== undefined) {
                    setup_word_counter(document.getElementById('post'), document.getElementById('word_count_' + options.wordCountId));
                }
            }

            manage_scroll_height(postEl);
            set_up_comcode_autocomplete(options.name, true);

            if (options.initDragDrop) {
                initialise_html5_dragdrop_upload('container_for_' + options.name, options.name);
            }
        },

        previewScriptCode: function (options) {
            var main_window = get_main_cms_window();

            var post = main_window.document.getElementById('post');

            // Replace Comcode
            var old_comcode = main_window.get_textbox(post);
            main_window.set_textbox(post, options.newPostValue.replace(/&#111;/g, 'o').replace(/&#79;/g, 'O'), options.newPostValueHtml);

            // Turn main post editing back on
            if (wysiwyg_set_readonly !== undefined) wysiwyg_set_readonly('post', false);

            // Remove attachment uploads
            var inputs = post.form.elements, upload_button;
            var i, done_one = false;
            for (i = 0; i < inputs.length; i++) {
                if (((inputs[i].type == 'file') || ((inputs[i].type == 'text') && (inputs[i].disabled))) && (inputs[i].value != '') && (inputs[i].name.match(/file\d+/))) {
                    if (inputs[i].plupload_object !== undefined) {
                        if ((inputs[i].value != '-1') && (inputs[i].value != '')) {
                            if (!done_one) {
                                if (old_comcode.indexOf('attachment_safe') == -1) {
                                    window.fauxmodal_alert('{!javascript:ATTACHMENT_SAVED;^}');
                                } else {
                                    if (!main_window.is_wysiwyg_field(post)) // Only for non-WYSIWYG, as WYSIWYG has preview automated at same point of adding
                                        window.fauxmodal_alert('{!javascript:ATTACHMENT_SAVED;^}');
                                }
                            }
                            done_one = true;
                        }

                        if (inputs[i].plupload_object.setButtonDisabled !== undefined) {
                            inputs[i].plupload_object.setButtonDisabled(false);
                        } else {
                            upload_button = main_window.document.getElementById('uploadButton_' + inputs[i].name);
                            if (upload_button) upload_button.disabled = true;
                        }
                        inputs[i].value = '-1';
                    } else {
                        try {
                            inputs[i].value = '';
                        } catch (e) {
                        }
                    }
                    if (inputs[i].form.elements['hidFileID_' + inputs[i].name] !== undefined) {
                        inputs[i].form.elements['hidFileID_' + inputs[i].name].value = '';
                    }
                }
            }
        },

        blockHelperDone: function (options) {
            var element;
            var target_window = window.opener ? window.opener : window.parent;
            element = target_window.document.getElementById(options.fieldName);
            if (!element) {
                target_window = target_window.frames['iframe_page'];
                element = target_window.document.getElementById(options.fieldName);
            }
            var is_wysiwyg = target_window.is_wysiwyg_field(element);

            var comcode, comcode_semihtml;
            comcode = options.comcode;
            window.returnValue = comcode;
            comcode_semihtml = options.comcodeSemihtml;

            var loading_space = document.getElementById('loading_space');

            function shutdown_overlay() {
                var win = window;

                window.setTimeout(function () { // Close master window in timeout, so that this will close first (issue on Firefox) / give chance for messages
                    if (win.faux_close !== undefined)
                        win.faux_close();
                    else
                        win.close();
                }, 200);
            }

            function dispatch_block_helper() {
                var win = window;
                if ((typeof options.saveToId === 'string') && (options.saveToId !== '')) {
                    var ob = target_window.wysiwyg_editors[element.id].document.$.getElementById(options.saveToId);

                    if (options.delete) {
                        ob.parentNode.removeChild(ob);
                    } else {
                        var input_container = document.createElement('div');
                        $cms.dom.html(input_container, comcode_semihtml.replace(/^\s*/, ''));
                        ob.parentNode.replaceChild(input_container.firstElementChild, ob);
                    }

                    target_window.wysiwyg_editors[element.id].updateElement();

                    shutdown_overlay();
                } else {
                    var message = '';
                    if (comcode.indexOf('[attachment') != -1) {
                        if (comcode.indexOf('[attachment_safe') != -1) {
                            if (is_wysiwyg) {
                                message = '';//'{!ADDED_COMCODE_ONLY_SAFE_ATTACHMENT_INSTANT;^}'; Not really needed
                            } else {
                                message = '{!ADDED_COMCODE_ONLY_SAFE_ATTACHMENT;^}';
                            }
                        } else {
                            //message='{!ADDED_COMCODE_ONLY_ATTACHMENT;^}';	Kind of states the obvious
                        }
                    } else {
                        //message='{!ADDED_COMCODE_ONLY;^}';	Kind of states the obvious
                    }

                    target_window.insert_comcode_tag = function (rep_from, rep_to, ret) { // We define as a temporary global method so we can clone out the tag if needed (e.g. for multiple attachment selections)
                        var _comcode_semihtml = comcode_semihtml;
                        var _comcode = comcode;
                        if (rep_from !== undefined) {
                            _comcode_semihtml = _comcode_semihtml.replace(rep_from, rep_to);
                            _comcode = _comcode.replace(rep_from, rep_to);
                        }

                        if (ret !== undefined && ret) {
                            return [_comcode_semihtml, _comcode];
                        }

                        if ((element.value.indexOf(comcode_semihtml) == -1) || (comcode.indexOf('[attachment') == -1)) // Don't allow attachments to add twice
                        {
                            target_window.insert_textbox(element, _comcode, target_window.document.selection ? target_window.document.selection : null, true, _comcode_semihtml);
                        }
                    };

                    if (options.prefix !== undefined) {
                        target_window.insert_textbox(element, options.prefix, target_window.document.selection ? target_window.document.selection : null, true);
                    }
                    target_window.insert_comcode_tag();

                    if (message != '') {
                        window.fauxmodal_alert(
                            message,
                            function () {
                                shutdown_overlay();
                            }
                        );
                    } else {
                        shutdown_overlay();
                    }
                }
            }

            var attached_event_action = false;

            if (options.syncWysiwygAttachments) {
                // WYSIWYG-editable attachments must be synched
                var field = 'file' + options.tagContents.substr(4);
                var upload_element = target_window.document.getElementById(field);
                if (!upload_element) upload_element = target_window.document.getElementById('hidFileID_' + field);
                if ((upload_element.plupload_object !== undefined) && (is_wysiwyg)) {
                    var ob = upload_element.plupload_object;
                    if (ob.state == target_window.plupload.STARTED) {
                        ob.bind('UploadComplete', function () {
                            window.setTimeout(dispatch_block_helper, 100);
                            /*Give enough time for everything else to update*/
                        });
                        ob.bind('Error', shutdown_overlay);

                        // Keep copying the upload indicator
                        var progress = target_window.document.getElementById('fsUploadProgress_' + field).innerHTML;
                        window.setInterval(function () {
                            if (progress != '') {
                                $cms.dom.html(loading_space, progress);
                                loading_space.className = 'spaced flash';
                            }
                        }, 100);

                        attached_event_action = true;
                    }
                }

            }

            if (!attached_event_action) {
                window.setTimeout(dispatch_block_helper, 1000); // Delay it, so if we have in a faux popup it can set up faux_close
            }
        },

        formScreenInputUploadMulti: function (options) {
            if (options.syndicationJson !== undefined) {
                show_upload_syndication_options(options.nameStub, options.syndicationJson);
            }

            if (options.plupload && !$cms.$IS_HTTPAUTH_LOGIN) {
                preinit_file_input('upload_multi', options.nameStub + '_' + options.i, null, null, options.filter);
            }
        },

        formScreenInputRadioList: function (options) {
            if (options.name === undefined) {
                return;
            }

            if (options.code !== undefined) {
                choose_picture('j_' + $cms.filter.id(options.name) + '_' + $cms.filter.id(options.code), null, options.name, null);
            }

            if (options.name === 'delete') {
                assign_radio_deletion_confirm(options.name);
            }

            function assign_radio_deletion_confirm(name) {
                for (var i = 1; i < 3; i++) {
                    var e = document.getElementById('j_' + name + '_' + i);
                    if (e) {
                        e.onchange = function () {
                            if (this.checked) {
                                window.fauxmodal_confirm(
                                    '{!ARE_YOU_SURE_DELETE;^}',
                                    function (result) {
                                        var e = document.getElementById('j_' + name + '_0');
                                        if (e) {
                                            if (result) {
                                                var form = e.form;
                                                form.action = form.action.replace(/([&\?])redirect=[^&]*/, '$1');
                                            } else {
                                                e.checked = true; // Check first radio
                                            }
                                        }
                                    }
                                );
                            }
                        }
                    }
                }
            }
        },

        formScreenInputRadioListComboEntry: function formScreenInputRadioListComboEntry(options) {
            var el = document.getElementById('j_' + $cms.filter.id(options.name) + '_other');
            el.dispatchEvent(new CustomEvent('change', { bubbles: true }));
        },

        formScreenInputVariousTricks: function formScreenInputVariousTricks(options) {
            options || (options = {});

            if (options.customName && !options.customAcceptMultiple) {
                document.getElementById(options.customName + '_value').dispatchEvent(new CustomEvent('change', { bubbles: true }));
            }
        },

        formScreenInputText: function formScreenInputText(options) {
            if (options.required.includes('wysiwyg')) {
                if ((window.wysiwyg_on) && (wysiwyg_on())) {
                    document.getElementById(options.name).readOnly = true;
                }
            }

            manage_scroll_height(document.getElementById(options.name));
        },

        formScreenInputTime: function formScreenInputTime(options) {
            // Uncomment if you want to force jQuery-UI inputs even when there is native browser input support
            //window.jQuery('#' + options.name).inputTime({});
        }
    });

    /* Set up a word count for a form field */
    function setup_word_counter(post, count_element) {
        window.setInterval(function () {
            if (is_wysiwyg_field(post)) {
                try {
                    var text_value = window.CKEDITOR.instances[post.name].getData();
                    var matches = text_value.replace(/<[^<|>]+?>|&nbsp;/gi, ' ').match(/\b/g);
                    var count = 0;
                    if (matches) count = matches.length / 2;
                    $cms.dom.html(count_element, '{!WORDS;^}'.replace('\\{1\\}', count));
                }
                catch (e) {
                }
            }
        }, 1000);
    }

    function permissions_overridden(select) {
        var element = document.getElementById(select + '_presets');
        if (element.options[0].id != select + '_custom_option') {
            var new_option = document.createElement('option');
            $cms.dom.html(new_option, '{!permissions:PINTERFACE_LEVEL_CUSTOM;^}');
            new_option.id = select + '_custom_option';
            new_option.value = '';
            element.insertBefore(new_option, element.options[0]);
        }
        element.selectedIndex = 0;
    }

    function try_to_simplify_iframe_form() {
        var form_cat_selector = document.getElementById('main_form'), elements, i, element, count = 0, found, foundButton;
        if (!form_cat_selector) {
            return;
        }

        elements = $cms.dom.$$(form_cat_selector, 'input, button, select, textarea');
        for (i = 0; i < elements.length; i++) {
            element = elements[i];
            if (((element.localName === 'input') && (element.type !== 'hidden') && (element.type !== 'button') && (element.type !== 'image') && (element.type !== 'submit')) || (element.localName === 'select') || (element.localName === 'textarea')) {
                found = element;
                count++;
            }
            if (((element.localName === 'input') && ((element.type === 'button') || (element.type === 'image') || (element.type === 'submit'))) || (element.localName === 'button')) {
                foundButton = element;
            }
        }

        if ((count === 1) && (found.localName === 'select')) {
            var iframe = document.getElementById('iframe_under');
            found.onchange = function () {
                if (iframe) {
                    if ((iframe.contentDocument) && (iframe.contentDocument.getElementsByTagName('form').length != 0)) {
                        window.fauxmodal_confirm(
                            '{!Q_SURE_LOSE;^}',
                            function (result) {
                                if (result) {
                                    _simplified_form_continue_submit(iframe, form_cat_selector);
                                }
                            }
                        );

                        return null;
                    }
                }

                _simplified_form_continue_submit(iframe, form_cat_selector);

                return null;
            };
            if ((found.getAttribute('size') > 1) || (found.multiple)) found.onclick = found.onchange;
            if (iframe) {
                foundButton.style.display = 'none';
            }
        }
    }

    function _simplified_form_continue_submit(iframe, form_cat_selector) {
        if (check_form(form_cat_selector)) {
            if (iframe) {
                animate_frame_load(iframe, 'iframe_under');
            }
            form_cat_selector.submit();
        }
    }

    /* Geolocation for address fields */
    function geolocate_address_fields() {
        if (!navigator.geolocation) {
            return;
        }
        try {
            navigator.geolocation.getCurrentPosition(function (position) {
                var fields = [
                    '{!cns_special_cpf:SPECIAL_CPF__cms_street_address;^}',
                    '{!cns_special_cpf:SPECIAL_CPF__cms_city;^}',
                    '{!cns_special_cpf:SPECIAL_CPF__cms_county;^}',
                    '{!cns_special_cpf:SPECIAL_CPF__cms_state;^}',
                    '{!cns_special_cpf:SPECIAL_CPF__cms_post_code;^}',
                    '{!cns_special_cpf:SPECIAL_CPF__cms_country;^}'
                ];

                var geocode_url = '{$FIND_SCRIPT;,geocode}';
                geocode_url += '?latitude=' + encodeURIComponent(position.coords.latitude) + '&longitude=' + encodeURIComponent(position.coords.longitude);
                geocode_url += keep_stub();

                do_ajax_request(geocode_url, function (ajax_result) {
                    var parsed = JSON.parse(ajax_result.responseText);
                    if (parsed === null) return;
                    var labels = document.getElementsByTagName('label'), label, field_name, field;
                    for (var i = 0; i < labels.length; i++) {
                        label = $cms.dom.html(labels[i]);
                        for (var j = 0; j < fields.length; j++) {
                            if (fields[j].replace(/^.*: /, '') == label) {
                                if (parsed[j + 1] === null) parsed[j + 1] = '';

                                field_name = labels[i].getAttribute('for');
                                field = document.getElementById(field_name);
                                if (field.localName === 'select') {
                                    field.value = parsed[j + 1];
                                    if (jQuery(field).select2 !== undefined) {
                                        jQuery(field).trigger('change');
                                    }
                                } else {
                                    field.value = parsed[j + 1];
                                }
                            }
                        }
                    }
                });
            });
        } catch (e) { }
    }

    function joinForm(options) {
        var form = document.getElementById('username').form;

        form.elements['username'].onchange = function () {
            if (form.elements['intro_title'])
                form.elements['intro_title'].value = '{!cns:INTRO_POST_DEFAULT;^}'.replace(/\{1\}/g, form.elements['username'].value);
        };

        form.old_submit = form.onsubmit;
        form.onsubmit = function () {
            if ((form.elements['confirm'] !== undefined) && (form.elements['confirm'].type == 'checkbox') && (!form.elements['confirm'].checked)) {
                window.fauxmodal_alert('{!cns:DESCRIPTION_I_AGREE_RULES;^}');
                return false;
            }

            if ((form.elements['email_address_confirm'] !== undefined) && (form.elements['email_address_confirm'].value != form.elements['email_address'].value)) {
                window.fauxmodal_alert('{!cns:EMAIL_ADDRESS_MISMATCH;^}');
                return false;
            }

            if ((form.elements['password_confirm'] !== undefined) && (form.elements['password_confirm'].value != form.elements['password'].value)) {
                window.fauxmodal_alert('{!cns:PASSWORD_MISMATCH;^}');
                return false;
            }

            document.getElementById('submit_button').disabled = true;

            var url = options.usernameCheckScript + '?username=' + encodeURIComponent(form.elements['username'].value);

            if (!do_ajax_field_test(url, 'password=' + encodeURIComponent(form.elements['password'].value))) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }

            if (options.invitesEnabled) {
                url = options.snippetScript + '?snippet=invite_missing&name=' + encodeURIComponent(form.elements['email_address'].value);
                if (!do_ajax_field_test(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            if (options.onePerEmailAddress) {
                url = options.snippetScript + '?snippet=exists_email&name=' + encodeURIComponent(form.elements['email_address'].value);
                if (!do_ajax_field_test(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            if (options.useCaptcha) {
                url = options.snippetScript + '?snippet=captcha_wrong&name=' + encodeURIComponent(form.elements['captcha'].value);
                if (!do_ajax_field_test(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            document.getElementById('submit_button').disabled = false;

            if (form.old_submit) {
                return form.old_submit();
            }

            return true;
        };
    }

    // Hide a 'tray' of trs in a form
    function toggle_subordinate_fields(pic, help_id) {
        var field_input = pic.parentElement.parentElement.parentElement,
            next = field_input.nextElementSibling,
            newDisplayState, newDisplayState2;

        if (!next) {
            return;
        }

        while (next.classList.contains('field_input')) { // Sometimes divs or whatever may have errornously been put in a table by a programmer, skip past them
            next = next.nextElementSibling;
            if (!next || next.classList.contains('form_table_field_spacer')) {// End of section, so no need to keep going
                next = null;
                break;
            }
        }

        if ((!next && (pic.src.includes('expand'))) || (next && (next.style.display === 'none'))) {/* Expanding now */
            pic.src = pic.src.includes('themewizard.php') ? pic.src.replace('expand', 'contract') : $cms.img('{$IMG;,1x/trays/contract}');
            if (pic.srcset !== undefined) {
                pic.srcset = pic.srcset.includes('themewizard.php') ? pic.srcset.replace('expand', 'contract') : ($cms.img('{$IMG;,2x/trays/contract}') + ' 2x');
            }
            pic.alt ='{!CONTRACT;}';
            pic.title = '{!CONTRACT;}';
            newDisplayState = (field_input.localName === 'tr') ? 'table-row' : 'block';
            newDisplayState2 = 'block';
        } else { /* Contracting now */
            pic.src = pic.src.includes('themewizard.php') ? pic.src.replace('contract', 'expand') : $cms.img('{$IMG;,1x/trays/expand}');
            if (pic.srcset !== undefined) {
                pic.srcset = pic.src.includes('themewizard.php') ? pic.srcset.replace('contract', 'expand') : ($cms.img('{$IMG;,2x/trays/expand}') + ' 2x');
            }
            pic.alt = '{!EXPAND;}';
            pic.title = '{!EXPAND;}';
            newDisplayState = 'none';
            newDisplayState2 = 'none';
        }

        // Hide everything until we hit end of section
        var count = 0;
        while (field_input.nextElementSibling) {
            field_input = field_input.nextElementSibling;

            /* Start of next section? */
            if (field_input.classList.contains('form_table_field_spacer')) {
                break; // End of section
            }

            /* Ok to proceed */
            field_input.style.display = newDisplayState;

            if ((newDisplayState2 !== 'none') && (count < 50/*Performance*/)) {
                clear_transition_and_set_opacity(field_input, 0.0);
                fade_transition(field_input, 100, 30, 20);
                count++;
            }
        }
        if (help_id === undefined) {
            help_id = pic.parentNode.id + '_help';
        }
        var help = document.getElementById(help_id);

        while (help !== null) {
            help.style.display = newDisplayState2;
            help = help.nextElementSibling;
            if (help && (help.localName !== 'p')) {
                break;
            }
        }

        trigger_resize();
    }

    function choose_picture(j_id, img_ob, name, event) {
        var j = document.getElementById(j_id);
        if (!j) {
            return;
        }

        if (!img_ob) {
            img_ob = document.getElementById('w_' + j_id.substring(2, j_id.length)).querySelector('img');
            if (!img_ob) {
                return;
            }
        }

        var e = j.form.elements[name];
        for (var i = 0; i < e.length; i++) {
            if (e[i].disabled) continue;
            var img = e[i].parentNode.parentNode.querySelector('img');
            if (img && (img !== img_ob)) {
                if (img.parentNode.classList.has('selected')) {
                    img.parentNode.classList.remove('selected');
                    img.style.outline = '0';
                    if (!browser_matches('ie8+')) {
                        img.style.background = 'none';
                    }
                }
            }
        }

        if (j.disabled) {
            return;
        }
        j.checked = true;
        //if (j.onclick) j.onclick(); causes loop
        if (j.fakeonchange) {
            j.fakeonchange(event);
        }
        img_ob.parentNode.classList.add(' selected');
        img_ob.style.outline = '1px dotted';
    }


    function standard_alternate_fields_within(set_name, something_required) {
        var form = document.getElementById('set_wrapper_' + set_name);

        while (form && (form.localName !== 'form')) {
            form = form.parentNode;
        }
        var fields = form.elements[set_name];
        var field_names = [];
        for (var i = 0; i < fields.length; i++) {
            if (fields[i][0] === undefined) {
                if (fields[i].id.startsWith('choose_')) {
                    field_names.push(fields[i].id.replace(/^choose\_/, ''));
                }
            } else {
                if (fields[i][0].id.startsWith('choose_')) {
                    field_names.push(fields[i][0].id.replace(/^choose\_/, ''));
                }
            }
        }

        standard_alternate_fields(field_names, something_required);

        // Do dynamic set_locked/set_required such that one of these must be set, but only one may be
        function standard_alternate_fields(field_names, something_required, second_run) {
            second_run = !!second_run;

            // Look up field objects
            var fields = [], i, field;

            for (i = 0; i < field_names.length; i++) {
                field = _standard_alternate_fields_get_object(field_names[i]);
                fields.push(field);
            }

            // Set up listeners...
            for (i = 0; i < field_names.length; i++) {
                field = fields[i];
                if ((!field) || (field.alternating === undefined)) {// ... but only if not already set
                    var self_function = function (e) {
                        standard_alternate_fields(field_names, something_required, true);
                    }; // We'll re-call ourself on change
                    _standard_alternate_field_create_listeners(field, self_function);
                }
            }

            // Update things
            for (i = 0; i < field_names.length; i++) {
                field = fields[i];
                if (_standard_alternate_field_is_filled_in(field, second_run, false))
                    return _standard_alternate_field_update_editability(field, fields, something_required);
            }

            // Hmm, force first one chosen then
            for (i = 0; i < field_names.length; i++) {
                if (field_names[i] == '') {
                    var radio_button = document.getElementById('choose_'); // Radio button handles field alternation
                    radio_button.checked = true;
                    return _standard_alternate_field_update_editability(null, fields, something_required);
                }

                field = fields[i];
                if ((field) && (_standard_alternate_field_is_filled_in(field, second_run, true)))
                    return _standard_alternate_field_update_editability(field, fields, something_required);
            }

            function _standard_alternate_field_update_editability(chosen, choices, something_required) {
                for (var i = 0; i < choices.length; i++) {
                    __standard_alternate_field_update_editability(choices[i], chosen, choices[i] != chosen, choices[i] == chosen, something_required);
                }

                // NB: is_chosen may only be null if is_locked is false
                function __standard_alternate_field_update_editability(field, chosen_field, is_locked, is_chosen, something_required) {
                    if ((!field) || (field.nodeName !== undefined)) {
                        ___standard_alternate_field_update_editability(field, chosen_field, is_locked, is_chosen, something_required);
                    } else {// List of fields (e.g. radio list, or just because standard_alternate_fields_within was used)
                        for (var i = 0; i < field.length; i++) {
                            if (field[i].name !== undefined) {// If it is an object, as opposed to some string in the collection
                                ___standard_alternate_field_update_editability(field[i], chosen_field, is_locked, is_chosen, something_required);
                                something_required = false; // Only the first will be required
                            }
                        }
                    }

                    function ___standard_alternate_field_update_editability(field, chosen_field, is_locked, is_chosen, something_required) {
                        if (!field) return;

                        var radio_button = document.getElementById('choose_' + field.name.replace(/\[\]$/, ''));
                        if (!radio_button) radio_button = document.getElementById('choose_' + field.name.replace(/\_\d+$/, '_'));

                        set_locked(field, is_locked, chosen_field);
                        if (something_required) {
                            set_required(field.name.replace(/\[\]$/, ''), is_chosen);
                        }
                    }
                }
            }

            function _standard_alternate_fields_get_object(field_name) {
                // Maybe it's an N/A so no actual field
                if (!field_name) {
                    return null;
                }

                // Try and get direct field
                var field = document.getElementById(field_name);
                if (field) {
                    return field;
                }

                // A radio field, so we need to create a virtual field object to return that will hold our value
                var radio_buttons = [], i, j, e;
                /*JSLINT: Ignore errors*/
                radio_buttons['name'] = field_name;
                radio_buttons['value'] = '';
                for (i = 0; i < document.forms.length; i++) {
                    for (j = 0; j < document.forms[i].elements.length; j++) {
                        e = document.forms[i].elements[j];
                        if (!e.name) continue;

                        if ((e.name.replace(/\[\]$/, '') == field_name) || (e.name.replace(/\_\d+$/, '_') == field_name)) {
                            radio_buttons.push(e);
                            if (e.checked) // This is the checked radio equivalent to our text field, copy the value through to the text field
                            {
                                radio_buttons['value'] = e.value;
                            }
                            if (e.alternating) radio_buttons.alternating = true;
                        }
                    }
                }

                if (radio_buttons.length === 0) {
                    return null;
                }

                return radio_buttons;
            }

            function _standard_alternate_field_is_filled_in(field, second_run, force) {
                if (!field) return false; // N/A input is considered unset

                var is_set = force || ((field.value != '') && (field.value != '-1')) || ((field.virtual_value !== undefined) && (field.virtual_value != '') && (field.virtual_value != '-1'));

                var radio_button = document.getElementById('choose_' + (field ? field.name : '').replace(/\[\]$/, '')); // Radio button handles field alternation
                if (!radio_button) radio_button = document.getElementById('choose_' + field.name.replace(/\_\d+$/, '_'));
                if (second_run) {
                    if (radio_button) return radio_button.checked;
                } else {
                    if (radio_button) radio_button.checked = is_set;
                }
                return is_set;
            }

            function _standard_alternate_field_create_listeners(field, refreshFunction) {
                if ((!field) || (field.nodeName !== undefined)) {
                    __standard_alternate_field_create_listeners(field, refreshFunction);
                } else {
                    var i;
                    for (i = 0; i < field.length; i++) {
                        if (field[i].name !== undefined)
                            __standard_alternate_field_create_listeners(field[i], refreshFunction);
                    }
                    field.alternating = true;
                }

                return null;

                function __standard_alternate_field_create_listeners(field, refreshFunction) {
                    var radio_button = document.getElementById('choose_' + (field ? field.name : '').replace(/\[\]$/, ''));
                    if (!radio_button) radio_button = document.getElementById('choose_' + field.name.replace(/\_\d+$/, '_'));
                    if (radio_button) // Radio button handles field alternation
                    {
                        radio_button.addEventListener('change', refreshFunction);
                    } else { // Filling/blanking out handles field alternation
                        if (field) {
                            field.addEventListener('keyup', refreshFunction);
                            field.addEventListener('change', refreshFunction);
                            field.fakeonchange = refreshFunction;
                        }
                    }
                    if (field) {
                        field.alternating = true;
                    }
                }
            }
        }
    }
}(window.$cms));

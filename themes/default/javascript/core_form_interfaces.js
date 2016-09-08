(function ($, Composr) {
    'use strict';

    Composr.behaviors.coreFormInterfaces = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core_form_interfaces');
                Composr.initializeTemplates(context, 'core_form_interfaces');
            }
        }
    };

    // Templates:
    // POSTING_FORM
    // - POSTING_FIELD
    var PostingForm = Composr.View.extend({
        initialize: function () {
            PostingForm.__super__.initialize.apply(this, arguments);
        },

        events: {
            'submit .js-submit-modsec-workaround': 'workaround'
        },

        workaround: function (e) {
            e.preventDefault();
            modsecurity_workaround(e.currentTarget);
        }
    });

    var FromScreenInputUpload = Composr.View.extend({
        initialize: function (v, options) {
            Composr.View.prototype.initialize.apply(this, arguments);

            if (Composr.is(options.plupload) && Composr.not(Composr.$IS_HTTPAUTH_LOGIN)) {
                preinit_file_input('upload', options.name, null, null, options.filter);
            }

            if (options.syndicationJson !== undefined) {
                show_upload_syndication_options(options.name, options.syndicationJson);
            }
        }
    });

    var FormScreenInputPermission = Composr.View.extend({
        groupId: null,
        prefix: null,
        initialize: function (v, options) {
            FormScreenInputPermission.__super__.initialize.apply(this, arguments);
            this.groupId = options.groupId;
            this.prefix = 'access_' + this.groupId;
            var prefix = this.prefix;

            if (Composr.not(options.allGlobal)) {
                var list = document.getElementById(prefix + '_presets');
                // Test to see what we wouldn't have to make a change to get - and that is what we're set at
                if (!copy_permission_presets(prefix, '0', true)) list.selectedIndex = list.options.length - 4;
                else if (!copy_permission_presets(prefix, '1', true)) list.selectedIndex = list.options.length - 3;
                else if (!copy_permission_presets(prefix, '2', true)) list.selectedIndex = list.options.length - 2;
                else if (!copy_permission_presets(prefix, '3', true)) list.selectedIndex = list.options.length - 1;
            }
        },

        events: {
            'click .js-click-copy-perm-presets': 'copyPresets',
            'change .js-change-copy-perm-presets': 'copyPresets',
            'click .js-click-perm-repeating': 'permissionRepeating'
        },

        copyPresets: function (e) {
            var select = e.currentTarget;
            copy_permission_presets(this.prefix, select.options[select.selectedIndex].value);
            cleanup_permission_list(this.prefix);
        },

        permissionRepeating: function (e) {
            var button = e.currentTarget,
                name = this.prefix,
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
                    if (trs[i] != tr) trs[i].onclick = copy_permissions_function(trs[i], tr);
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

    var FormScreenInputPermissionOverride = Composr.View.extend({
        groupId: null,
        prefix: null,
        initialize: function (v, options) {
            var prefix = 'access_' + options.groupId;

            this.options = options;
            this.groupId = options.groupId;
            this.prefix  = prefix;

            setup_privilege_override_selector(prefix, options.defaultAccess, options.privilege, options.title, Composr.is(options.allGlobal));

            if (Composr.not(options.allGlobal)) {
                var list = document.getElementById(prefix + '_presets');
                // Test to see what we wouldn't have to make a change to get - and that is what we're set at
                if (!copy_permission_presets(prefix, '0', true)) list.selectedIndex = list.options.length - 4;
                else if (!copy_permission_presets(prefix, '1', true)) list.selectedIndex = list.options.length - 3;
                else if (!copy_permission_presets(prefix, '2', true)) list.selectedIndex = list.options.length - 2;
                else if (!copy_permission_presets(prefix, '3', true)) list.selectedIndex = list.options.length - 1;
            }
        },

        events: {
            'click .js-click-perms-overridden': 'permissionsOverridden',
            'change .js-change-perms-overridden': 'permissionsOverridden',
            'mouseover .js-mouseover-show-perm-setting': 'showPermissionSetting'
        },

        permissionsOverridden: function () {
            permissions_overridden(this.prefix);
        },

        showPermissionSetting: function (e) {
            var select = e.currentTarget;

            if (select.options[select.selectedIndex].value === '-1') {
                show_permission_setting(select);
            }
        }
    });

    Composr.views.coreFormInterfaces = {
        PostingForm: PostingForm,
        FromScreenInputUpload: FromScreenInputUpload,
        FormScreenInputPermission: FormScreenInputPermission,
        FormScreenInputPermissionOverride: FormScreenInputPermissionOverride
    };

    Composr.templates.coreFormInterfaces = {
        form: function (options) {
            options = options || {};

            if (Composr.is(options.isJoinForm)) {
                joinForm(options);
            }
        },

        formStandardEnd: function formStandardEnd(options) {
            window.form_preview_url = options.previewUrl;

            if (Composr.is(options.forcePreviews)) {
                document.getElementById('submit_button').style.display = 'none';
            }

            if (Composr.is(options.javascript)) {
                eval.call(window, options.javascript);
            }

            if (Composr.not(options.secondaryForm)) {
                if (typeof window.fix_form_enter_key!=='undefined') {
                    fix_form_enter_key(document.getElementById('submit_button').form);
                }
            }

            if (Composr.is(options.supportAutosave, options.formName)) {
                if (typeof init_form_saving!='undefined') {
                    init_form_saving(options.formName);
                }
            }
        },

        formScreen: function (options) {
            var container = this;

            options = options || {};

            try_to_simplify_iframe_form();

            if (options.iframeUrl) {
                window.setInterval(function() { resize_frame('iframe_under'); }, 1500);
            }

            Composr.dom.on(container, 'click', function (e) {
                var chkBoxOpenNew = Composr.dom.closest(e.target, '.js-checkbox-will-open-new', container);

                if (options.iframeUrl && chkBoxOpenNew) {
                    var form = Composr.dom.id(container, 'main_form');

                    form.action = chkBoxOpenNew.checked ? options.url : options.iframeUrl;
                    form.elements.opens_below.value = chkBoxOpenNew.checked ? '0' : '1';
                    form.target = chkBoxOpenNew.checked ? '_blank' : 'iframe_under';
                }
            });
        },

        formScreenField_input: function (options) {
            var el = Composr.dom.$('#form_table_field_input__' + options.randomisedId);
            if (el) {
                set_up_change_monitor(el.parentElement);
            }
        },

        formScreenInputLine: function formScreenInputLine(options) {
            set_up_comcode_autocomplete(options.name, Composr.is(options.wysiwyg));
        },

        formScreenInputCombo: function (options) {
            document.getElementById(options.name).onkeyup();

            if (typeof window.HTMLDataListElement === 'undefined') {
                document.getElementById(options.name).className = 'input_line';
            }
        },

        formScreenInputHugeComcode: function (options) {
            var textarea = Composr.dom.id(options.name),
                input = Composr.dom.id('form_table_field_input__' + options.randomisedId);

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
            var label = Composr.is(options.rawField) ? ' ' : options.prettyName;

            make_colour_chooser(options.name, options.default, '', options.tabindex, label, 'input_colour' + options._required);
            do_color_chooser();
        },

        formScreenInputTreeList: function formScreenInputTreeList(options) {
            var hook = Composr.filters.urlEncode(options.hook),
                rootId = Composr.filters.urlEncode(options.rootId),
                opts =  Composr.filters.urlEncode(options.options),
                multiSel = Composr.is(options.multiSelect);

            new tree_list(options.name, 'data/ajax_tree.php?hook=' + hook + Composr.$KEEP, rootId, opts, multiSel, options.tabIndex, false, Composr.is(options.useServerId));
        },

        formScreenInputPermissionMatrix: function (options) {
            var container = this;
            window.perm_serverid = options.serverId;

            Composr.dom.on(container, 'click', { '.js-click-permissions-toggle': function () {
                permissions_toggle(this.parentNode)
            }});

            function permissions_toggle(cell) {
                var index = cell.cellIndex;
                var table = cell.parentNode.parentNode;
                if (table.localName !== 'table') table = table.parentNode;
                var state_list = null, state_checkbox = null;
                for (var i = 0; i < table.rows.length; i++) {
                    if (i >= 1) {
                        var cell2 = table.rows[i].cells[index];
                        var input = cell2.getElementsByTagName('input')[0];
                        if (input) {
                            if (!input.disabled) {
                                if (state_checkbox == null) state_checkbox = input.checked;
                                input.checked = !state_checkbox;
                            }
                        } else {
                            input = cell2.getElementsByTagName('select')[0];
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
            var el = Composr.dom.$('#form_table_field_input__' + options.name);

            if (el) {
                set_up_change_monitor(el.parentElement);
            }
        },

        formScreenFieldSpacer: function formScreenFieldSpaces(options) {
            var container = this;
            options || (options = {});

            if (Composr.is(options.title, options.sectionHidden)) {
                var title = Composr.filters.id(options.title);
                Composr.dom.id('fes' + title).click();
            }

            Composr.dom.on(container, 'click', {
                '.js-click-geolocate-address-fields': function (e) {
                    geolocate_address_fields();
                }
            });
        },

        formScreenInputTick: function (options) {
            var el = this;

            if (Composr.$JS_ON && (options.name === 'validated')) {
                Composr.dom.on(el, 'click', function () {
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
            if (Composr.is(Composr.$CONFIG_OPTION.jsCaptcha)) {
                Composr.dom.html(document.getElementById('captcha_spot'), options.captcha);
            } else {
                window.addEventListener('pageshow', function () {
                    document.getElementById('captcha_readable').src += '&r=' + Composr.util.random(); // Force it to reload latest captcha
                });
            }
        },

        formScreenInputList: function formScreenInputList(options, images) {
            var el, selectOptions;

            if (Composr.is(options.inlineList)) {
                return;
            }

            el = Composr.dom.id(options.name);
            selectOptions = {
                dropdownAutoWidth: true,
                containerCssClass: 'wide_field'
            };

            if (images.length) {
                selectOptions.formatResult = formatSelectImage;
            }

            if ((el.options.length > 20)/*only for long lists*/ && (!el.options[0].value.match(/^\d+$/)/*not for lists of numbers*/)) {
                $(el).select2(selectOptions);
            }

            function formatSelectImage(o) {
                if (!o.id) {
                    return o.text; // optgroup
                }

                for (var imgId in images) {
                    if (images.hasOwnProperty(imgId) && (o.id === imgId)) {
                        return '<span class="vertical_alignment inline_lined_up"><img style="width: 24px;" src="' + images[imgId] + '" \/> ' + escape_html(o.text) + '</span>';
                    }
                }

                return escape_html(o.text);
            }
        },

        formScreenFieldsSet: function (options) {
            standard_alternate_fields_within(options.setName, Composr.is());
        },

        formScreenInputThemeImageEntry: function (options) {
            initialise_input_theme_image_entry(Composr.filters.id(options.name), Composr.filters.id(options.code));
        },

        formScreenInputHuge_input: function (options) {
            var textArea = document.getElementById(options.name),
                el = Composr.dom.$('#form_table_field_input__' + options.randomisedId);

            if (el) {
                set_up_change_monitor(el.parentElement);
            }


            manage_scroll_height(textArea);

            if (Composr.not(Composr.$MOBILE)) {
                $(textArea).on('change keyup', function () {
                    manage_scroll_height(textArea);
                });
            }
        },

        formScreenInputHugeList_input: function (options) {
            var el = Composr.dom.$('#form_table_field_input__' + options.randomisedId);
            if (Composr.not(options.inlineList) && el) {
                set_up_change_monitor(el.parentElement);
            }
        },

        previewScript: function previewScript() {
            var inner = Composr.dom.$('.js-preview-box-scroll');

            if (!inner) { return; }

            inner.addEventListener(browser_matches('gecko') ? 'DOMMouseScroll' : 'mousewheel', function (event) {
                inner.scrollTop -= event.wheelDelta ? event.wheelDelta : event.detail;
                cancel_bubbling(event);
                if (event.cancelable) event.preventDefault();
                return false;
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

                if (typeof options.wordCounter !== 'undefined') {
                    setup_word_counter(document.getElementById('post'), document.getElementById('word_count_' + options.wordCountId));
                }
            }

            manage_scroll_height(postEl);
            set_up_comcode_autocomplete(options.name, true);

            if (Composr.is(options.initDragDrop)) {
                initialise_html5_dragdrop_upload('container_for_' + options.name, options.name);
            }
        },

        previewScriptCode: function previewScriptCode(options) {
            var main_window = get_main_cms_window();

            var post = main_window.document.getElementById('post');

            // Replace Comcode
            var old_comcode = main_window.get_textbox(post);
            main_window.set_textbox(post, options.newPostValue.replace(/&#111;/g, 'o').replace(/&#79;/g, 'O'), options.newPostValueHtml);

            // Turn main post editing back on
            if (typeof wysiwyg_set_readonly != 'undefined') wysiwyg_set_readonly('post', false);

            // Remove attachment uploads
            var inputs = post.form.elements, upload_button;
            var i, done_one = false;
            for (i = 0; i < inputs.length; i++) {
                if (((inputs[i].type == 'file') || ((inputs[i].type == 'text') && (inputs[i].disabled))) && (inputs[i].value != '') && (inputs[i].name.match(/file\d+/))) {
                    if (typeof inputs[i].plupload_object != 'undefined') {
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

                        if (typeof inputs[i].plupload_object.setButtonDisabled != 'undefined') {
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
                    if (typeof inputs[i].form.elements['hidFileID_' + inputs[i].name] != 'undefined')
                        inputs[i].form.elements['hidFileID_' + inputs[i].name].value = '';
                }
            }
        },

        blockHelperDone: function blockHelperDone(options) {
            Composr.required(options, ['fieldName', 'comcode', 'comcodeSemihtml', 'saveToId']);

            var element;
            var target_window = window.opener ? window.opener : window.parent;
            element = target_window.document.getElementById(options.fieldName);
            if (!element) {
                target_window = target_window.frames['iframe_page'];
                element = target_window.document.getElementById(options.fieldName);
            }
            element = ensure_true_id(element, options.fieldName);
            var is_wysiwyg = target_window.is_wysiwyg_field(element);

            var comcode, comcode_semihtml;
            comcode = options.comcode;
            window.returnValue = comcode;
            comcode_semihtml = options.comcodeSemihtml;

            var loading_space = document.getElementById('loading_space');

            function shutdown_overlay() {
                var win = window;

                window.setTimeout(function () { // Close master window in timeout, so that this will close first (issue on Firefox) / give chance for messages
                    if (typeof win.faux_close != 'undefined')
                        win.faux_close();
                    else
                        win.close();
                }, 200);
            }

            function dispatch_block_helper() {
                var win = window;
                if ((typeof options.saveToId === 'string') && (options.saveToId !== '')) {
                    var ob = target_window.wysiwyg_editors[element.id].document.$.getElementById(options.saveToId);

                    if (options.delete === '1') {
                        ob.parentNode.removeChild(ob);
                    } else {
                        var input_container = document.createElement('div');
                        Composr.dom.html(input_container, comcode_semihtml.replace(/^\s*/, ''));
                        ob.parentNode.replaceChild(input_container.childNodes[0], ob);
                    }

                    target_window.wysiwyg_editors[element.id].updateElement();

                    shutdown_overlay();
                } else {
                    var message = '';
                    if (comcode.indexOf('[attachment') != -1) {
                        if (comcode.indexOf('[attachment_safe') != -1) {
                            if (is_wysiwyg) {
                                message = '';//'{!ADDED_COMCODE_ONLY_SAFE_ATTACHMENT_INSTANT;}'; Not really needed
                            } else {
                                message = '{!ADDED_COMCODE_ONLY_SAFE_ATTACHMENT;}';
                            }
                        } else {
                            //message='{!ADDED_COMCODE_ONLY_ATTACHMENT;}';	Kind of states the obvious
                        }
                    } else {
                        //message='{!ADDED_COMCODE_ONLY;}';	Kind of states the obvious
                    }

                    target_window.insert_comcode_tag = function (rep_from, rep_to, ret) { // We define as a temporary global method so we can clone out the tag if needed (e.g. for multiple attachment selections)
                        var _comcode_semihtml = comcode_semihtml;
                        var _comcode = comcode;
                        if (typeof rep_from != 'undefined') {
                            _comcode_semihtml = _comcode_semihtml.replace(rep_from, rep_to);
                            _comcode = _comcode.replace(rep_from, rep_to);
                        }

                        if (typeof ret != 'undefined' && ret) {
                            return [_comcode_semihtml, _comcode];
                        }

                        if ((element.value.indexOf(comcode_semihtml) == -1) || (comcode.indexOf('[attachment') == -1)) // Don't allow attachments to add twice
                        {
                            target_window.insert_textbox(element, _comcode, target_window.document.selection ? target_window.document.selection : null, true, _comcode_semihtml);
                        }
                    };

                    if (typeof options.prefix !== 'undefined') {
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

            if (Composr.is(options.syncWysiwygAttachments)) {
                Composr.required(options, ['tagContents']);

                // WYSIWYG-editable attachments must be synched
                var field = 'file' + options.tagContents.substr(4);
                var upload_element = target_window.document.getElementById(field);
                if (!upload_element) upload_element = target_window.document.getElementById('hidFileID_' + field);
                if ((typeof upload_element.plupload_object != 'undefined') && (is_wysiwyg)) {
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
                                Composr.dom.html(loading_space, progress);
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

        formScreenInputUploadMulti: function formScreenInputUploadMulti(options) {
            if (typeof options.syndicationJson !== 'undefined') {
                show_upload_syndication_options(options.nameStub, options.syndicationJson);
            }

            if ((options.plupload === '1') && !Composr.$IS_HTTPAUTH_LOGIN) {
                preinit_file_input('upload_multi', options.nameStub + '_' + options.i, null, null, options.filter);
            }
        },

        formScreenInputRadioList: function formScreenInputRadioList(options) {
            if (typeof options.name === 'undefined') {
                return;
            }

            if (typeof options.code !== 'undefined') {
                choose_picture('j_' + Composr.filters.id(options.name) + '_' + Composr.filters.id(options.code), null, options.name, null);
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
            var el = document.getElementById('j_' + Composr.filters.id(options.name) + '_other');
            el.dispatchEvent(new CustomEvent('change', { bubbles: true }));
        },

        formScreenInputVariousTricks: function formScreenInputVariousTricks(options) {
            options || (options = {});

            if ((typeof options.customName !== 'undefined') && Composr.not(options.customAcceptMultiple)) {
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
            //$('#' + options.name).inputTime({});
        }
    };

    /* Set up a word count for a form field */
    function setup_word_counter(post, count_element) {
        window.setInterval(function () {
            if (is_wysiwyg_field(post)) {
                try {
                    var text_value = window.CKEDITOR.instances[post.name].getData();
                    var matches = text_value.replace(/<[^<|>]+?>|&nbsp;/gi, ' ').match(/\b/g);
                    var count = 0;
                    if (matches) count = matches.length / 2;
                    Composr.dom.html(count_element, '{!WORDS;}'.replace('\\{1\\}', count));
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
            Composr.dom.html(new_option, '{!permissions:PINTERFACE_LEVEL_CUSTOM;^}');
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

        elements = Composr.dom.$$(form_cat_selector, 'input, button, select, textarea');
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
                    '{!cns_special_cpf:SPECIAL_CPF__cms_street_address;}',
                    '{!cns_special_cpf:SPECIAL_CPF__cms_city;}',
                    '{!cns_special_cpf:SPECIAL_CPF__cms_county;}',
                    '{!cns_special_cpf:SPECIAL_CPF__cms_state;}',
                    '{!cns_special_cpf:SPECIAL_CPF__cms_post_code;}',
                    '{!cns_special_cpf:SPECIAL_CPF__cms_country;}'
                ];

                var geocode_url = '{$FIND_SCRIPT;,geocode}';
                geocode_url += '?latitude=' + window.encodeURIComponent(position.coords.latitude) + '&longitude=' + window.encodeURIComponent(position.coords.longitude);
                geocode_url += keep_stub();

                do_ajax_request(geocode_url, function (ajax_result) {
                    var parsed = JSON.parse(ajax_result.responseText);
                    if (parsed === null) return;
                    var labels = document.getElementsByTagName('label'), label, field_name, field;
                    for (var i = 0; i < labels.length; i++) {
                        label = Composr.dom.html(labels[i]);
                        for (var j = 0; j < fields.length; j++) {
                            if (fields[j].replace(/^.*: /, '') == label) {
                                if (parsed[j + 1] === null) parsed[j + 1] = '';

                                field_name = labels[i].getAttribute('for');
                                field = document.getElementById(field_name);
                                if (field.localName === 'select') {
                                    field.value = parsed[j + 1];
                                    if (typeof $(field).select2 != 'undefined') {
                                        $(field).trigger('change');
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
                form.elements['intro_title'].value = '{!cns:INTRO_POST_DEFAULT;}'.replace(/\{1\}/g, form.elements['username'].value);
        };

        form.old_submit = form.onsubmit;
        form.onsubmit = function () {
            if ((typeof form.elements['confirm'] !== 'undefined') && (form.elements['confirm'].type == 'checkbox') && (!form.elements['confirm'].checked)) {
                window.fauxmodal_alert('{!cns:DESCRIPTION_I_AGREE_RULES;}');
                return false;
            }

            if ((typeof form.elements['email_address_confirm'] !== 'undefined') && (form.elements['email_address_confirm'].value != form.elements['email_address'].value)) {
                window.fauxmodal_alert('{!cns:EMAIL_ADDRESS_MISMATCH;}');
                return false;
            }

            if ((typeof form.elements['password_confirm'] !== 'undefined') && (form.elements['password_confirm'].value != form.elements['password'].value)) {
                window.fauxmodal_alert('{!cns:PASSWORD_MISMATCH;}');
                return false;
            }

            document.getElementById('submit_button').disabled = true;

            var url = options.usernameCheckScript + '?username=' + window.encodeURIComponent(form.elements['username'].value);

            if (!do_ajax_field_test(url, 'password=' + window.encodeURIComponent(form.elements['password'].value))) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }

            if (Composr.is(options.invitesEnabled)) {
                url = options.snippetScript + '?snippet=invite_missing&name=' + window.encodeURIComponent(form.elements['email_address'].value);
                if (!do_ajax_field_test(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            if (Composr.is(options.onePerEmailAddress)) {
                url = options.snippetScript + '?snippet=exists_email&name=' + window.encodeURIComponent(form.elements['email_address'].value);
                if (!do_ajax_field_test(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            if (Composr.is(options.useCaptcha)) {
                url = options.snippetScript + '?snippet=captcha_wrong&name=' + window.encodeURIComponent(form.elements['captcha'].value);
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

}(window.jQuery || window.Zepto, window.Composr));

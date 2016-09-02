(function ($, Composr) {
    Composr.behaviors.coreFormInterfaces = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core_form_interfaces');
                Composr.initializeTemplates(context, 'core_form_interfaces');
            }
        }
    };

    var FromScreenInputUpload = Composr.View.extend({
        initialize: function (v, options) {
            Composr.View.prototype.initialize.apply(this, arguments);

            if (Composr.isTruthy(options.plupload) && Composr.isFalsy(Composr.$IS_HTTPAUTH_LOGIN)) {
                preinit_file_input('upload', options.name, null, null, options.filter);
            }

            if (options.syndicationJson !== undefined) {
                show_upload_syndication_options(options.name, options.syndicationJson);
            }
        }
    });

    Composr.views.coreFormInterfaces = {
        FromScreenInputUpload: FromScreenInputUpload
    };

    Composr.templates.coreFormInterfaces = {
        form: function (options) {
            options = options || {};

            if (Composr.isTruthy(options.isJoinForm)) {
                joinForm(options);
            }
        },

        formStandardEnd: function formStandardEnd(options) {
            window.form_preview_url = options.previewUrl;

            if (Composr.isTruthy(options.forcePreviews)) {
                document.getElementById('submit_button').style.display = 'none';
            }

            if (Composr.isTruthy(options.javascript)) {
                eval.call(window, options.javascript);
            }

            if (Composr.isFalsy(options.secondaryForm)) {
                if (typeof window.fix_form_enter_key!=='undefined') {
                    fix_form_enter_key(document.getElementById('submit_button').form);
                }
            }

            if (Composr.areTruthy(options.supportAutosave, options.formName)) {
                if (typeof init_form_saving!='undefined') {
                    init_form_saving(options.formName);
                }
            }
        },

        formScreen: function formScreen(options) {
            var context = this, nonIframeUrl, iframeUrl;

            options = options || {};

            if (window.try_to_simplify_iframe_form !== undefined) {
                try_to_simplify_iframe_form();
            }

            if (options.iframeUrl !== undefined) {
                nonIframeUrl = options.url;
                iframeUrl = options.iframeUrl;
                window.setInterval(function() { resize_frame('iframe_under'); }, 1500);
            }

            context.addEventListener('click', function (e) {
                var chkBoxOpenNew = Composr.dom.closest(e.currentTarget, '.js-checkbox-will-open-new');

                if (chkBoxOpenNew) {
                    var f = document.getElementById('main_form');
                    f.action = this.checked ? nonIframeUrl : iframeUrl;
                    f.elements['opens_below'].value = this.checked ? '0' : '1';
                    f.target = this.checked ? '_blank' : 'iframe_under';
                }
            });
        },

        formScreenField_input: function (options) {
            set_up_change_monitor('form_table_field_input__' + options.randomisedId);
        },

        formScreenInputLine: function formScreenInputLine(options) {
            set_up_comcode_autocomplete(options.name, Composr.isTruthy(options.wysiwyg));
        },

        formScreenInputCombo: function formScreenInputCombo(options) {
            document.getElementById(options.name).onkeyup();

            if (typeof window.HTMLDataListElement === 'undefined') {
                document.getElementById(options.name).className = 'input_line';
            }
        },

        formScreenInputHugeComcode: function formScreenInputHugeComcode(options) {
            if ((typeof options.required === 'string') && options.required.includes('wysiwyg') && wysiwyg_on()) {
                document.getElementById(options.name).readOnly = true;
            }

            set_up_change_monitor('form_table_field_input__' + options.randomisedId);
            manage_scroll_height(document.getElementById(options.name));

            set_up_comcode_autocomplete(options.name, options.required.includes('wysiwyg'));
        },

        formScreenInputColour: function formScreenInputColour(options) {
            var isRawField = options.rawField === '1',
                label = isRawField ? ' ' : options.prettyName;

            make_colour_chooser(options.name, options.default, '', options.tabindex, label, 'input_colour' + options._required);
            do_color_chooser();
        },

        formScreenInputTreeList: function formScreenInputTreeList(options) {
            var hook = Composr.filters.urlEncode(options.hook),
                rootId = Composr.filters.urlEncode(options.rootId),
                opts =  Composr.filters.urlEncode(options.options),
                multiSel = Composr.isTruthy(options.multiSelect);

            new tree_list(options.name, 'data/ajax_tree.php?hook=' + hook + Composr.$KEEP, rootId, opts, multiSel, options.tabIndex, false, Composr.isTruthy(options.useServerId));
        },

        formScreenInputPermission: function formScreenInputPermission(options) {
            if (Number(options.allGlobal) === 0) {
                var list = document.getElementById('access_' + options.groupId + '_presets');
                // Test to see what we wouldn't have to make a change to get - and that is what we're set at
                if (!copy_permission_presets('access_' + options.groupId, '0', true)) list.selectedIndex = list.options.length - 4;
                else if (!copy_permission_presets('access_' + options.groupId, '1', true)) list.selectedIndex = list.options.length - 3;
                else if (!copy_permission_presets('access_' + options.groupId, '2', true)) list.selectedIndex = list.options.length - 2;
                else if (!copy_permission_presets('access_' + options.groupId, '3', true)) list.selectedIndex = list.options.length - 1;
            }
        },

        formScreenInputPermissionOverride: function formScreenInputPermissionOverride(options) {
            var allGlobal = Number(options.allGlobal) === 1;

            setup_privilege_override_selector('access_' + options.groupId, options.defaultAccess, options.privilege, options.title, allGlobal);

            if (!allGlobal) {
                var list = document.getElementById('access_' + options.groupId + '_presets');
                // Test to see what we wouldn't have to make a change to get - and that is what we're set at
                if (!copy_permission_presets('access_' + options.groupId, '0', true)) list.selectedIndex = list.options.length - 4;
                else if (!copy_permission_presets('access_' + options.groupId, '1', true)) list.selectedIndex = list.options.length - 3;
                else if (!copy_permission_presets('access_' + options.groupId, '2', true)) list.selectedIndex = list.options.length - 2;
                else if (!copy_permission_presets('access_' + options.groupId, '3', true)) list.selectedIndex = list.options.length - 1;
            }
        },

        formScreenInputPermissionMatrix: function formScreenInputPermissionMatrix(options) {
            window.perm_serverid = options.serverId;
        },

        formScreenFieldsSetItem: function formScreenFieldsSetItem(options) {
            set_up_change_monitor('form_table_field_input__' + options.name);
        },

        formScreenFieldSpacer: function formScreenFieldSpaces(options) {
            options = options || {};

            if (Composr.areTruthy(options.title, options.sectionHidden)) {
                var title = Composr.filters.identifier(options.title);
                document.getElementById('fes' + title).click();
            }
        },

        formScreenInputTick: function (options) {
            var el = this;

            if (Composr.$JS_ON && (options.name === 'validated')) {
                $(el).on('click', function () {
                    el.previousSibling.className = 'validated_checkbox' + (el.checked ? ' checked' : '');
                })
            }

            if (options.name === 'delete') {
                assign_tick_deletion_confirm(options.name);
            }
        },

        formScreenInputCaptcha: function formScreenInputCaptcha(options, jsCaptcha) {
            if (jsCaptcha === '1') {
                Composr.dom.html(document.getElementById('captcha_spot'), options.captcha);
            } else {
                window.addEventListener('pageshow', function () {
                    document.getElementById('captcha_readable').src += '&r=' + Composr.utils.random(); // Force it to reload latest captcha
                });
            }
        },

        formScreenInputList: function formScreenInputList(options, images) {
            var el, selectOptions;

            if (options.inlineList === '1') return;

            el = document.getElementById(options.name);
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
            standard_alternate_fields_within(options.setName, Composr.isTruthy());
        },

        formScreenInputThemeImageEntry: function (options) {
            initialise_input_theme_image_entry(Composr.filters.id(options.name), Composr.filters.id(options.code));
        },

        formScreenInputHuge_input: function (options) {
            var textArea = document.getElementById(options.name);

            set_up_change_monitor('form_table_field_input__' + options.randomisedId);
            manage_scroll_height(textArea);

            if (Composr.isFalsy(Composr.$MOBILE)) {
                $(textArea).on('change keyup', function () {
                    manage_scroll_height(textArea);
                });
            }
        },

        formScreenInputHugeList_input: function (options) {
            if (Composr.isFalsy(options.inlineList)) {
                set_up_change_monitor('form_table_field_input__' + options.randomisedId);
            }
        },

        previewScript: function previewScript(options) {
            var inner = document.querySelector('.js-preview-box-scroll');

            if (!inner) { return; }

            inner.addEventListener(browser_matches('gecko') ? 'DOMMouseScroll' : 'mousewheel', function (event) {
                inner.scrollTop -= event.wheelDelta ? event.wheelDelta : event.detail;
                cancel_bubbling(event);
                if (typeof event.preventDefault != 'undefined') event.preventDefault();
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

            if (Composr.isTruthy(options.initDragDrop)) {
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

            if (options.syncWysiwygAttachments === '1') {
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
                choose_picture('j_' + Composr.filters.identifier(options.name) + '_' + Composr.filters.identifier(options.code), null, options.name, null);
            }

            if (options.name === 'delete') {
                assign_radio_deletion_confirm(options.name);
            }
        },

        formScreenInputRadioListComboEntry: function formScreenInputRadioListComboEntry(options) {
            var el = document.getElementById('j_' + Composr.filters.identifier(options.name) + '_other');
            el.dispatchEvent(new Event('change'));
        },

        formScreenInputVariousTricks: function formScreenInputVariousTricks(options) {
            options || (options = {});

            if ((typeof options.customName !== 'undefined') && Composr.isFalsy(options.customAcceptMultiple)) {
                document.getElementById(options.customName + '_value').dispatchEvent(new Event('change'));
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

            if (Composr.isTruthy(options.invitesEnabled)) {
                url = options.snippetScript + '?snippet=invite_missing&name=' + window.encodeURIComponent(form.elements['email_address'].value);
                if (!do_ajax_field_test(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            if (Composr.isTruthy(options.onePerEmailAddress)) {
                url = options.snippetScript + '?snippet=exists_email&name=' + window.encodeURIComponent(form.elements['email_address'].value);
                if (!do_ajax_field_test(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            if (Composr.isTruthy(options.useCaptcha)) {
                url = options.snippetScript + '?snippet=captcha_wrong&name=' + window.encodeURIComponent(form.elements['captcha'].value);
                if (!do_ajax_field_test(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            document.getElementById('submit_button').disabled = false;

            if (typeof form.old_submit !== 'undefined' && form.old_submit) {
                return form.old_submit();
            }

            return true;
        };
    }

})(window.jQuery || window.Zepto, Composr);

(function ($, Composr) {
    Composr.templates.coreFormInterfaces = {
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
        },

        formScreenInputColour: function formScreenInputColour(options) {
            var isRawField = options.rawField === '1',
                label = isRawField ? ' ' : options.prettyName;

            make_colour_chooser(options.name, options.default, '', options.tabindex, label, 'input_colour' + options._required);
            do_color_chooser();
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
        }
    };

    Composr.behaviors.coreFormInterfaces = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_form_interfaces');
            }
        }
    };

})(window.jQuery || window.Zepto, Composr);

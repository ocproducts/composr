(function ($cms) {
    'use strict';

    // Templates:
    // POSTING_FORM.tpl
    // - POSTING_FIELD.tpl
    $cms.views.PostingForm = PostingForm;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function PostingForm(params) {
        PostingForm.base(this, 'constructor', arguments);

        if (params.jsFunctionCalls != null) {
            $cms.executeJsFunctionCalls(params.jsFunctionCalls);
        }
    }

    $cms.inherits(PostingForm, $cms.View, {
        events: function () {
            return {
                'submit .js-submit-modsec-workaround': 'workaround',
                'click .js-click-toggle-subord-fields': 'toggleSubordinateFields',
                'keypress .js-keypress-toggle-subord-fields': 'toggleSubordinateFields'
            };
        },

        workaround: function (e, target) {
            e.preventDefault();
            $cms.form.modsecurityWorkaround(target);
        },

        toggleSubordinateFields: function (e, target) {
            toggleSubordinateFields(target.parentNode.querySelector('img'), 'fes_attachments_help');
        }
    });

    $cms.views.FromScreenInputUpload = FromScreenInputUpload;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function FromScreenInputUpload(params) {
        FromScreenInputUpload.base(this, 'constructor', arguments);

        if (params.plupload && !$cms.$IS_HTTPAUTH_LOGIN()) {
            $cms.requireJavascript('plupload').then(function () {
                preinitFileInput('upload', params.name, null, null, params.filter);
            });
        }

        if (params.syndicationJson != null) {
            $cms.requireJavascript('editing').then(function () {
                showUploadSyndicationOptions(params.name, params.syndicationJson);
            });
        }
    }

    $cms.inherits(FromScreenInputUpload, $cms.View);

    $cms.views.FormScreenInputPermission = FormScreenInputPermission;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function FormScreenInputPermission(params) {
        FormScreenInputPermission.base(this, 'constructor', arguments);

        this.groupId = params.groupId;
        this.prefix = 'access_' + this.groupId;
        var prefix = this.prefix;

        if (!params.allGlobal) {
            var list = document.getElementById(prefix + '_presets');
            // Test to see what we wouldn't have to make a change to get - and that is what we're set at
            if (!copyPermissionPresets(prefix, '0', true)) {
                list.selectedIndex = list.options.length - 4;
            } else if (!copyPermissionPresets(prefix, '1', true)) {
                list.selectedIndex = list.options.length - 3;
            } else if (!copyPermissionPresets(prefix, '2', true)) {
                list.selectedIndex = list.options.length - 2;
            } else if (!copyPermissionPresets(prefix, '3', true)) {
                list.selectedIndex = list.options.length - 1;
            }
        }
    }

    $cms.inherits(FormScreenInputPermission, $cms.View, {
        events: function () {
            return {
                'click .js-click-copy-perm-presets': 'copyPresets',
                'change .js-change-copy-perm-presets': 'copyPresets',
                'click .js-click-perm-repeating': 'permissionRepeating'
            };
        },

        copyPresets: function (e, select) {
            copyPermissionPresets(this.prefix, select.options[select.selectedIndex].value);
            cleanupPermissionList(this.prefix);
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

            if (old_permission_copying !== name) {// Starting a new copying session
                button.style.textDecoration = 'blink';
                window.permission_copying = name;
                $cms.ui.alert('{!permissions:REPEAT_PERMISSION_NOTICE;^}');
                for (var j = 0; j < trs.length; j++) {
                    if (trs[j] !== tr) {
                        trs[j].onclick = copyPermissionsFunction(trs[j], tr);
                    }
                }
            }

            function copyPermissionsFunction(to_row, from_row) {
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

    $cms.views.FormScreenInputPermissionOverride = FormScreenInputPermissionOverride;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function FormScreenInputPermissionOverride(params) {
        FormScreenInputPermissionOverride.base(this, 'constructor', arguments);

        var prefix = 'access_' + params.groupId;

        this.groupId = params.groupId;
        this.prefix = prefix;

        setupPrivilegeOverrideSelector(prefix, params.defaultAccess, params.privilege, params.title, !!params.allGlobal);

        if (!params.allGlobal) {
            var list = document.getElementById(prefix + '_presets');
            // Test to see what we wouldn't have to make a change to get - and that is what we're set at
            if (!copyPermissionPresets(prefix, '0', true)) {
                list.selectedIndex = list.options.length - 4;
            } else if (!copyPermissionPresets(prefix, '1', true)) {
                list.selectedIndex = list.options.length - 3;
            } else if (!copyPermissionPresets(prefix, '2', true)) {
                list.selectedIndex = list.options.length - 2;
            } else if (!copyPermissionPresets(prefix, '3', true)) {
                list.selectedIndex = list.options.length - 1;
            }
        }
    }

    $cms.inherits(FormScreenInputPermissionOverride, $cms.View, /**@lends FormScreenInputPermissionOverride#*/{
        events: function () {
            return {
                'click .js-click-perms-overridden': 'permissionsOverridden',
                'change .js-change-perms-overridden': 'permissionsOverridden',
                'mouseover .js-mouseover-show-perm-setting': 'showPermissionSetting'
            };
        },

        permissionsOverridden: function () {
            permissionsOverridden(this.prefix);
        },

        showPermissionSetting: function (e, select) {
            if (select.options[select.selectedIndex].value === '-1') {
                showPermissionSetting(select);
            }
        }
    });

    $cms.views.FormStandardEnd = FormStandardEnd;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function FormStandardEnd(params) {
        FormStandardEnd.base(this, 'constructor', arguments);

        this.backUrl = strVal(params.backUrl);
        this.form = $cms.dom.closest(this.el, 'form');
        this.btnSubmit = this.$('#submit_button');

        window.form_preview_url = params.previewUrl;

        if (params.forcePreviews) {
            this.btnSubmit.style.display = 'none';
        }

        if (params.jsFunctionCalls != null) {
            $cms.executeJsFunctionCalls(params.jsFunctionCalls);
        }

        if (!params.secondaryForm) {
            this.fixFormEnterKey();
        }

        if (params.supportAutosave && params.formName) {
            if (window.initFormSaving !== undefined) {
                initFormSaving(params.formName);
            }
        }
    }

    $cms.inherits(FormStandardEnd, $cms.View, /**@lends FormStandardEnd#*/{
        events: function () {
            return {
                'click .js-click-do-form-preview': 'doFormPreview',
                'click .js-click-do-form-submit': 'doFormSubmit',
                'click .js-click-btn-go-back': 'goBack'
            };
        },

        doFormPreview: function (e) {
            var form = this.form,
                separatePreview = !!this.params.separatePreview;

            if ($cms.form.doFormPreview(e, form, window.form_preview_url, separatePreview) && !window.just_checking_requirements) {
                form.submit();
            }
        },

        doFormSubmit: function (e) {
            if (!$cms.form.doFormSubmit(this.form, e)) {
                e.preventDefault();
            }
        },

        goBack: function (e, btn) {
            if (btn.form.method.toLowerCase() === 'get') {
                window.location = this.backUrl;
            } else {
                btn.form.action = this.backUrl;
                btn.form.submit();
            }
        },

        fixFormEnterKey: function () {
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
                        if ($cms.dom.keyPressed(event, 'Enter')) submit.onclick(event);
                    };
            }
        }
    });


    $cms.templates.formScreenInputPassword = function (params, container) {
        var value = strVal(params.value),
            name = strVal(params.name);

        if ((value === '') && (name === 'edit_password')) {
            // Work around annoying Firefox bug. It ignores autocomplete="off" if a password was already saved somehow
            window.setTimeout(function () {
                $cms.dom.$('#' + name).value = '';
            }, 300);
        }

        $cms.dom.on(container, 'mouseover', '.js-mouseover-activate-password-strength-tooltip', function (e, el) {
            if (el.parentNode.title !== undefined) {
                el.parentNode.title = '';
            }
            $cms.ui.activateTooltip(el, e, '{!PASSWORD_STRENGTH;^}', 'auto');
        });

        $cms.dom.on(container, 'change', '.js-input-change-check-password-strength', function (e, input) {
            if (input.name.includes('2') || input.name.includes('confirm')) {
                return;
            }

            var _ind = $cms.dom.$('#password_strength_' + input.id);
            if (!_ind) {
                return;
            }
            var ind = _ind.querySelector('div');
            var post = 'password=' + encodeUC(input.value);
            if (input.form && (input.form.elements.username !== undefined)) {
                post += '&username=' + input.form.elements['username'].value;
            } else {
                if (input.form && input.form.elements.edit_username !== undefined) {
                    post += '&username=' + input.form.elements['edit_username'].value;
                }
            }
            var strength = $cms.loadSnippet('password_strength', post);
            strength *= 2;
            if (strength > 10) {  // Normally too harsh!
                strength = 10;
            }
            ind.style.width = (strength * 10) + 'px';

            if (strength >= 6) {
                ind.style.backgroundColor = 'green';
            } else if (strength < 4) {
                ind.style.backgroundColor = 'red';
            } else {
                ind.style.backgroundColor = 'orange';
            }

            ind.parentNode.style.display = (input.value.length == 0) ? 'none' : 'block';
        });
    };

    $cms.templates.comcodeEditor = function (params, container) {
        var postingField = strVal(params.postingField);

        $cms.dom.on(container, 'click', '.js-click-do-input-font-posting-field', function () {
            do_input_font(postingField);
        });
    };

    $cms.templates.form = function (params, container) {
        var skippable =  strVal(params.skippable);

        if (params.isJoinForm) {
            joinForm(params);
        }

        $cms.dom.on(container, 'click', '.js-click-btn-skip-step', function () {
            $cms.dom.$('#' + skippable).value = '1';
        });

        $cms.dom.on(container, 'submit', '.js-submit-modesecurity-workaround', function (e, form) {
            e.preventDefault();
            $cms.form.modsecurityWorkaround(form);
        });
    };

    $cms.templates.formScreen = function (params, container) {
        tryToSimplifyIframeForm();

        if (params.iframeUrl) {
            window.setInterval(function () {
                $cms.dom.resizeFrame('iframe_under');
            }, 1500);

            $cms.dom.on(container, 'click', '.js-checkbox-will-open-new', function (e, checkbox) {
                var form = $cms.dom.$(container, '#main_form');

                form.action = checkbox.checked ? params.url : params.iframeUrl;
                form.elements.opens_below.value = checkbox.checked ? '0' : '1';
                form.target = checkbox.checked ? '_blank' : 'iframe_under';
            });
        }

        $cms.dom.on(container, 'click', '.js-btn-skip-step', function () {
            $cms.dom.$('#' + params.skippable).value = '1';
        });
    };

    $cms.templates.formScreenField_input = function (params) {
        var el = $cms.dom.$('#form_table_field_input__' + params.randomisedId);
        if (el) {
            $cms.form.setUpChangeMonitor(el.parentElement);
        }
    };

    $cms.templates.formScreenFieldDescription = function formScreenFieldDescription(params, img) {
        $cms.dom.one(img, 'mouseover', function () {
            if (img.ttitle === undefined) {
                img.ttitle = img.title;
            }
            img.title = '';
            //img.have_links = true;
            img.setAttribute('data-cms-rich-tooltip', '1');
        });
    };

    $cms.templates.formScreenInputLine = function formScreenInputLine(params) {
        $cms.requireJavascript('jquery_autocomplete').then(function () {
            setUpComcodeAutocomplete(params.name, !!params.wysiwyg);
        });
    };

    $cms.templates.formScreenInputCombo = function formScreenInputCombo(params, container) {
        var name = strVal(params.name),
            comboInput = $cms.dom.$('#' + name),
            fallbackList = $cms.dom.$('#' + name + '_fallback_list');

        if (window.HTMLDataListElement === undefined) {
            comboInput.classList.remove('input_line_required');
            comboInput.classList.add('input_line');
        }

        if (fallbackList) {
            fallbackList.disabled = (comboInput.value !== '');

            $cms.dom.on(container, 'keyup', '.js-keyup-toggle-fallback-list', function () {
                fallbackList.disabled = (comboInput.value !== '');
            });
        }
    };

    $cms.templates.formScreenInputUsernameMulti = function formScreenInputUsernameMulti(params, container) {
        $cms.dom.on(container, 'focus', '.js-focus-update-ajax-member-list', function (e, input) {
            if (input.value === '') {
                $cms.form.updateAjaxMemberList(input, null, true, e);
            }
        });

        $cms.dom.on(container, 'keyup', '.js-keyup-update-ajax-member-list', function (e, input) {
            $cms.form.updateAjaxMemberList(input, null, false, e);
        });

        $cms.dom.on(container, 'change', '.js-change-ensure-next-field', function (e, input) {
            ensureNextField(input)
        });

        $cms.dom.on(container, 'keypress', '.js-keypress-ensure-next-field', function (e, input) {
            ensureNextField(input)
        });
    };

    $cms.templates.formScreenInputUsername = function formScreenInputUsername(params, container) {
        $cms.dom.on(container, 'focus', '.js-focus-update-ajax-member-list', function (e, input) {
            if (input.value === '') {
                $cms.form.updateAjaxMemberList(input, null, true, e);
            }
        });

        $cms.dom.on(container, 'keyup', '.js-keyup-update-ajax-member-list', function (e, input) {
            $cms.form.updateAjaxMemberList(input, null, false, e);
        });
    };

    $cms.templates.formScreenInputLineMulti = function (params, container) {
        $cms.dom.on(container, 'keypress', '.js-keypress-ensure-next-field', function (e, input) {
            _ensureNextField(e, input);
        });
    };

    $cms.templates.formScreenInputHugeComcode = function (params) {
        var textarea = $cms.dom.$id(params.name),
            input = $cms.dom.$id('form_table_field_input__' + params.randomisedId);

        if (params.required && params.required.includes('wysiwyg') && wysiwygOn()) {
            textarea.readOnly = true;
        }

        if (input) {
            $cms.form.setUpChangeMonitor(input.parentElement);
        }

        $cms.manageScrollHeight(textarea);
        $cms.requireJavascript('jquery_autocomplete').then(function () {
            setUpComcodeAutocomplete(params.name, params.required && params.required.includes('wysiwyg'));
        });
    };

    $cms.templates.formScreenInputAuthor = function formScreenInputAuthor(params, container) {
        $cms.dom.on(container, 'keyup', '.js-keyup-update-ajax-author-list', function (e, target) {
            $cms.form.updateAjaxMemberList(target, 'author', false, e);
        });
    };

    $cms.templates.formScreenInputColour = function (params) {
        var label = params.rawField ? ' ' : params.prettyName;

        makeColourChooser(params.name, params.default, '', params.tabindex, label, 'input_colour' + params._required);
        doColorChooser();
    };

    $cms.templates.formScreenInputTreeList = function formScreenInputTreeList(params, container) {
        var name = strVal(params.name),
            hook = $cms.filter.url(params.hook),
            rootId = $cms.filter.url(params.rootId),
            opts = $cms.filter.url(params.options),
            multiSelect = !!params.multiSelect && (params.multiSelect !== '0');

        $cms.requireJavascript('tree_list').then(function () {
            $cms.ui.createTreeList(params.name, 'data/ajax_tree.php?hook=' + hook + $cms.$KEEP(), rootId, opts, multiSelect, params.tabIndex, false, !!params.useServerId);
        });

        $cms.dom.on(container, 'change', '.js-input-change-update-mirror', function (e, input) {
            var mirror = document.getElementById(name + '_mirror');
            if (mirror) {
                $cms.dom.toggle(mirror.parentElement, !!input.selected_title);
                $cms.dom.html(mirror, input.selected_title ? $cms.filter.html(input.selected_title) : '{!NA_EM;}');
            }
        });
    };

    $cms.templates.formScreenInputPermissionMatrix = function (params) {
        var container = this;
        window.perm_serverid = params.serverId;

        $cms.dom.on(container, 'click', '.js-click-permissions-toggle', function (e, clicked) {
            permissionsToggle(clicked.parentNode)
        });

        function permissionsToggle(cell) {
            var index = cell.cellIndex,
                table = cell.parentNode.parentNode;

            if (table.localName !== 'table') {
                table = table.parentNode;
            }

            var state_list = null,
                state_checkbox = null;

            for (var i = 0; i < table.rows.length; i++) {
                if (i >= 1) {
                    var cell2 = table.rows[i].cells[index];
                    var input = cell2.querySelector('input');
                    if (input) {
                        if (!input.disabled) {
                            if (state_checkbox == null) {
                                state_checkbox = input.checked;
                            }
                            input.checked = !state_checkbox;
                        }
                    } else {
                        input = cell2.querySelector('select');
                        if (state_list == null) {
                            state_list = input.selectedIndex;
                        }
                        input.selectedIndex = ((state_list != input.options.length - 1) ? (input.options.length - 1) : (input.options.length - 2));
                        input.disabled = false;

                        permissionsOverridden(table.rows[i].id.replace(/_privilege_container$/, ''));
                    }
                }
            }
        }
    };

    $cms.templates.formScreenFieldsSetItem = function formScreenFieldsSetItem(params) {
        var el = $cms.dom.$('#form_table_field_input__' + params.name);

        if (el) {
            $cms.form.setUpChangeMonitor(el.parentElement);
        }
    };

    $cms.templates.formScreenFieldSpacer = function (params) {
        params || (params = {});
        var container = this,
            title = $cms.filter.id(params.title);

        if (title && params.sectionHidden) {
            $cms.dom.$id('fes' + title).click();
        }

        $cms.dom.on(container, 'click', '.js-click-toggle-subord-fields', function (e, clicked) {
            toggleSubordinateFields(clicked.parentNode.querySelector('img'), 'fes' + title + '_help');
        });

        $cms.dom.on(container, 'keypress', '.js-keypress-toggle-subord-fields', function (e, pressed) {
            toggleSubordinateFields(pressed.parentNode.querySelector('img'), 'fes' + title + '_help');
        });

        $cms.dom.on(container, 'click', '.js-click-geolocate-address-fields', function () {
            geolocateAddressFields();
        });
    };

    $cms.templates.formScreenInputTick = function (params) {
        var el = this;

        if (params.name === 'validated') {
            $cms.dom.on(el, 'click', function () {
                el.previousSibling.className = 'validated_checkbox' + (el.checked ? ' checked' : '');
            });
        }

        if (params.name === 'delete') {
            assignTickDeletionConfirm(params.name);
        }

        function assignTickDeletionConfirm(name) {
            var el = document.getElementById(name);

            el.onchange = function () {
                if (this.checked) {
                    $cms.ui.confirm(
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
    };

    $cms.templates.formScreenInputCaptcha = function formScreenInputCaptcha(params, container) {
        if ($cms.$CONFIG_OPTION('js_captcha')) {
            $cms.dom.html($cms.dom.$('#captcha_spot'), params.captcha);
        } else {
            window.addEventListener('pageshow', function () {
                $cms.dom.$('#captcha_readable').src += '&r=' + $cms.random(); // Force it to reload latest captcha
            });
        }

        $cms.dom.on(container, 'click', '.js-click-play-self-audio-link', function (e, link) {
            e.preventDefault();
            $cms.playSelfAudioLink(link);
        });
    };

    $cms.templates.formScreenInputList = function formScreenInputList(params) {
        var selectEl, select2Options, imageSources;

        if (params.inlineList) {
            return;
        }

        selectEl = $cms.dom.$id(params.name);
        select2Options = {
            dropdownAutoWidth: true,
            containerCssClass: 'wide_field'
        };

        if (params.images !== undefined) {
            select2Options.formatResult = formatSelectImage;
            imageSources = JSON.parse(params.imageSources || '{}');
        }

        if (window.jQuery && (typeof window.jQuery(selectEl).select2 != 'undefined') && (selectEl.options.length > 20)/*only for long lists*/ && (!$cms.dom.html(selectEl.options[1]).match(/^\d+$/)/*not for lists of numbers*/)) {
            window.jQuery(selectEl).select2(select2Options);
        }

        function formatSelectImage(opt) {
            if (!opt.id) {
                return opt.text; // optgroup
            }

            for (var imageName in imageSources) {
                if (opt.id === imageName) {
                    return '<span class="vertical_alignment inline_lined_up"><img style="width: 24px;" src="' + imageSources[imageName] + '" \/> ' + $cms.filter.html(opt.text) + '</span>';
                }
            }

            return $cms.filter.html(opt.text);
        }
    };

    $cms.templates.formScreenFieldsSet = function (params) {
        standardAlternateFieldsWithin(params.setName, !!params.required);
    };

    $cms.templates.formScreenInputThemeImageEntry = function (params) {
        var name = $cms.filter.id(params.name),
            code = $cms.filter.id(params.code),
            stem = name + '_' + code,
            el = document.getElementById('w_' + stem),
            img = el.querySelector('img'),
            input = document.getElementById('j_' + stem),
            label = el.querySelector('label'),
            form = input.form;

        el.onkeypress = function (event) {
            if ($cms.dom.keyPressed(event, 'Enter')) {
                return el.onclick.call([event]);
            }

            return null;
        };

        function clickFunc(event) {
            choosePicture('j_' + stem, img, name, event);

            if (window.main_form_very_simple !== undefined) {
                form.submit();
            }

            event.stopPropagation();
        }

        img.onkeypress = clickFunc;
        img.onclick = clickFunc;
        el.onclick = clickFunc;

        label.className = 'js_widget';

        input.onclick = function (event) {
            if (this.disabled) {
                return;
            }

            deselectAltUrl(this.form);

            if (window.main_form_very_simple !== undefined) {
                this.form.submit();
            }
            event.stopPropagation();
        };

        function deselectAltUrl(form) {
            if (form.elements['alt_url'] != null) {
                form.elements['alt_url'].value = '';
            }
        }

    };

    $cms.templates.formScreenInputHuge_input = function (params) {
        var textArea = document.getElementById(params.name),
            el = $cms.dom.$('#form_table_field_input__' + params.randomisedId);

        if (el) {
            $cms.form.setUpChangeMonitor(el.parentElement);
        }

        $cms.manageScrollHeight(textArea);

        if (!$cms.$MOBILE()) {
            $cms.dom.on(textArea, 'change keyup', function () {
                $cms.manageScrollHeight(textArea);
            });
        }
    };

    $cms.templates.formScreenInputHugeList_input = function (params) {
        var el = $cms.dom.$('#form_table_field_input__' + params.randomisedId);

        if (!params.inlineList && el) {
            $cms.form.setUpChangeMonitor(el.parentElement);
        }
    };

    $cms.templates.previewScript = function (params, container) {
        var inner = $cms.dom.$(container, '.js-preview-box-scroll');

        if (inner) {
            $cms.dom.on(inner, $cms.browserMatches('gecko') ? 'DOMMouseScroll' : 'mousewheel', function (event) {
                inner.scrollTop -= event.wheelDelta ? event.wheelDelta : event.detail;
                event.stopPropagation();
                event.preventDefault();
                return false;
            });
        }

        $cms.dom.on(container, 'click', '.js-click-preview-mobile-button', function (event, el) {
            el.form.action = el.form.action.replace(/keep_mobile=\d/g, 'keep_mobile=' + (el.checked ? '1' : '0'));
            if (window.parent) {
                try {
                    window.parent.scrollTo(0, $cms.dom.findPosY(window.parent.document.getElementById('preview_iframe')));
                } catch (e) {
                }
                window.parent.mobile_version_for_preview = !!el.checked;
                $cms.dom.trigger(window.parent.document.getElementById('preview_button'), 'click');
                return;
            }

            el.form.submit();
        });
    };

    $cms.templates.postingField = function postingField(params/* NB: mutiple containers */) {
        var id = strVal(params.id),
            name = strVal(params.name),
            initDragDrop = !!params.initDragDrop,
            postEl = $cms.dom.$('#' + name),
            // Container elements:
            labelRow = $cms.dom.$('#field-' + id +'-label'),
            inputRow = $cms.dom.$('#field-' + id +'-input'),
            attachmentsUiRow = $cms.dom.$('#field-' + id +'-attachments-ui'),
            attachmentsUiInputRow = $cms.dom.$('#field-' + id +'-attachments-ui-input');

        if (params.class.includes('wysiwyg')) {
            if (window.wysiwyg_on && wysiwygOn()) {
                postEl.readOnly = true; // Stop typing while it loads

                window.setTimeout(function () {
                    if (postEl.value === postEl.defaultValue) {
                        postEl.readOnly = false; // Too slow, maybe WYSIWYG failed due to some network issue
                    }
                }, 3000);
            }

            if (params.wordCounter !== undefined) {
                setupWordCounter($cms.dom.$('#post'), $cms.dom.$('#word_count_' + params.wordCountId));
            }
        }

        $cms.manageScrollHeight(postEl);
        $cms.requireJavascript('jquery_autocomplete').then(function () {
            setUpComcodeAutocomplete(name, true);
        });

        if (initDragDrop) {
            $cms.requireJavascript('plupload').then(function () {
                initialiseHtml5DragdropUpload('container_for_' + name, name);
            });
        }

        $cms.dom.on(labelRow, 'click', '.js-click-toggle-wysiwyg', function () {
            toggleWysiwyg(name);
        });

        $cms.dom.on(labelRow, 'click', '.js-link-click-open-field-emoticon-chooser-window', function (e, link) {
            var url = $cms.maintainThemeInLink(link.href);
            $cms.ui.open(url, 'field_emoticon_chooser', 'width=300,height=320,status=no,resizable=yes,scrollbars=no');
        });

        $cms.dom.on(inputRow, 'click', '.js-link-click-open-site-emoticon-chooser-window', function (e, link) {
            var url = $cms.maintainThemeInLink(link.href);
            $cms.ui.open(url, 'site_emoticon_chooser', 'width=300,height=320,status=no,resizable=yes,scrollbars=no');
        });
    };

    $cms.templates.previewScriptCode = function (params) {
        var main_window = $cms.getMainCmsWindow();

        var post = main_window.document.getElementById('post');

        // Replace Comcode
        var old_comcode = main_window.get_textbox(post);
        main_window.set_textbox(post, params.newPostValue.replace(/&#111;/g, 'o').replace(/&#79;/g, 'O'), params.newPostValueHtml);

        // Turn main post editing back on
        if (wysiwygSetReadonly !== undefined) {
            wysiwygSetReadonly('post', false);
        }

        // Remove attachment uploads
        var inputs = post.form.elements, upload_button;
        var i, done_one = false;
        for (i = 0; i < inputs.length; i++) {
            if (((inputs[i].type == 'file') || ((inputs[i].type == 'text') && (inputs[i].disabled))) && (inputs[i].value != '') && (inputs[i].name.match(/file\d+/))) {
                if (inputs[i].plupload_object !== undefined) {
                    if ((inputs[i].value != '-1') && (inputs[i].value != '')) {
                        if (!done_one) {
                            if (old_comcode.indexOf('attachment_safe') == -1) {
                                $cms.ui.alert('{!javascript:ATTACHMENT_SAVED;^}');
                            } else {
                                if (!main_window.$cms.form.isWysiwygField(post)) // Only for non-WYSIWYG, as WYSIWYG has preview automated at same point of adding
                                    $cms.ui.alert('{!javascript:ATTACHMENT_SAVED;^}');
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
    };

    $cms.templates.blockHelperDone = function (params) {
        var element;
        var target_window = window.opener ? window.opener : window.parent;
        element = target_window.document.getElementById(params.fieldName);
        if (!element) {
            target_window = target_window.frames['iframe_page'];
            element = target_window.document.getElementById(params.fieldName);
        }
        var is_wysiwyg = target_window.$cms.form.isWysiwygField(element);

        var comcode, comcode_semihtml;
        comcode = params.comcode;
        window.returnValue = comcode;
        comcode_semihtml = params.comcodeSemihtml;

        var loading_space = document.getElementById('loading_space');

        function shutdownOverlay() {
            window.setTimeout(function () { // Close master window in timeout, so that this will close first (issue on Firefox) / give chance for messages
                if (window.faux_close !== undefined) {
                    window.faux_close();
                } else {
                    window.close();
                }
            }, 200);
        }

        function dispatchBlockHelper() {
            if ((typeof params.saveToId === 'string') && (params.saveToId !== '')) {
                var ob = target_window.wysiwyg_editors[element.id].document.$.getElementById(params.saveToId);

                if (params.delete) {
                    ob.parentNode.removeChild(ob);
                } else {
                    var input_container = document.createElement('div');
                    $cms.dom.html(input_container, comcode_semihtml.replace(/^\s*/, ''));
                    ob.parentNode.replaceChild(input_container.firstElementChild, ob);
                }

                target_window.wysiwyg_editors[element.id].updateElement();

                shutdownOverlay();
            } else {
                var message = '';
                if (comcode.includes('[attachment') && comcode.includes('[attachment_safe')) {
                    if (is_wysiwyg) {
                        message = '';//'!ADDED_COMCODE_ONLY_SAFE_ATTACHMENT_INSTANT;^}'; Not really needed
                    } else {
                        message = '!ADDED_COMCODE_ONLY_SAFE_ATTACHMENT;^}';
                    }
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

                    if ((element.value.indexOf(comcode_semihtml) == -1) || (comcode.indexOf('[attachment') == -1)) { // Don't allow attachments to add twice
                        target_window.insertTextbox(element, _comcode, target_window.document.selection ? target_window.document.selection : null, true, _comcode_semihtml);
                    }
                };

                if (params.prefix !== undefined) {
                    target_window.insertTextbox(element, params.prefix, target_window.document.selection ? target_window.document.selection : null, true);
                }
                target_window.insert_comcode_tag();

                if (message != '') {
                    $cms.ui.alert(message, function () {
                        shutdownOverlay();
                    });
                } else {
                    shutdownOverlay();
                }
            }
        }

        var attached_event_action = false;

        if (params.syncWysiwygAttachments) {
            // WYSIWYG-editable attachments must be synched
            var field = 'file' + params.tagContents.substr(4);
            var upload_element = target_window.document.getElementById(field);
            if (!upload_element) upload_element = target_window.document.getElementById('hidFileID_' + field);
            if ((upload_element.plupload_object !== undefined) && (is_wysiwyg)) {
                var ob = upload_element.plupload_object;
                if (ob.state == target_window.plupload.STARTED) {
                    ob.bind('UploadComplete', function () {
                        window.setTimeout(dispatchBlockHelper, 100);
                        /*Give enough time for everything else to update*/
                    });
                    ob.bind('Error', shutdownOverlay);

                    // Keep copying the upload indicator
                    var progress = $cms.dom.html(target_window.document.getElementById('fsUploadProgress_' + field));
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
            window.setTimeout(dispatchBlockHelper, 1000); // Delay it, so if we have in a faux popup it can set up faux_close
        }
    };

    $cms.templates.formScreenInputUploadMulti = function formScreenInputUploadMulti(params, container) {
        var nameStub = strVal(params.nameStub),
            index = strVal(params.i),
            syndicationJson = strVal(params.syndicationJson);

        if (params.syndicationJson !== undefined) {
            $cms.requireJavascript('editing').then(function () {
                showUploadSyndicationOptions(nameStub, syndicationJson);
            });
        }

        if (params.plupload && !$cms.$IS_HTTPAUTH_LOGIN()) {
            preinitFileInput('upload_multi', nameStub + '_' + index, null, null, params.filter);
        }

        $cms.dom.on(container, 'change', '.js-input-change-ensure-next-field-upload', function (e, input) {
            if (!$cms.dom.keyPressed(e, 'Tab')) {
                ensureNextFieldUpload(input);
            }
        });

        $cms.dom.on(container, 'click', '.js-click-clear-name-stub-input', function (e) {
            var input = $cms.dom.$('#' + nameStub + '_' + index);
            input.value = '';
            if (input.fakeonchange) {
                input.fakeonchange(e);
            }
        });


        function ensureNextFieldUpload(this_field) {
            var mid = this_field.name.lastIndexOf('_'),
                name_stub = this_field.name.substring(0, mid + 1),
                this_num = this_field.name.substring(mid + 1, this_field.name.length) - 0,
                next_num = this_num + 1,
                next_field = document.getElementById('multi_' + next_num),
                name = name_stub + next_num,
                this_id = this_field.id;

            if (!next_field) {
                next_num = this_num + 1;
                this_field = document.getElementById(this_id);
                next_field = document.createElement('input');
                next_field.className = 'input_upload';
                next_field.setAttribute('id', 'multi_' + next_num);
                next_field.addEventListener('change', _ensureNextFieldUpload);
                next_field.setAttribute('type', 'file');
                next_field.name = name_stub + next_num;
                this_field.parentNode.appendChild(next_field);
            }

            function _ensureNextFieldUpload(event) {
                if (!$cms.dom.keyPressed(event, 'Tab')) {
                    ensureNextFieldUpload(this);
                }
            }
        }
    };

    $cms.templates.formScreenInputRadioList = function (params) {
        if (params.name === undefined) {
            return;
        }

        if (params.code !== undefined) {
            choosePicture('j_' + $cms.filter.id(params.name) + '_' + $cms.filter.id(params.code), null, params.name, null);
        }

        if (params.name === 'delete') {
            assignRadioDeletionConfirm(params.name);
        }

        function assignRadioDeletionConfirm(name) {
            for (var i = 1; i < 3; i++) {
                var e = document.getElementById('j_' + name + '_' + i);
                if (e) {
                    e.onchange = function () {
                        if (this.checked) {
                            $cms.ui.confirm(
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
    };

    $cms.templates.formScreenInputMultiList = function formScreenInputMultiList(params, container) {
        $cms.dom.on(container, 'keypress', '.js-keypress-input-ensure-next-field', function (e, input) {
            _ensureNextField(e, input)
        });
    };

    $cms.templates.formScreenInputTextMulti = function formScreenInputTextMulti(params, container) {
        $cms.dom.on(container, 'keypress', '.js-keypress-textarea-ensure-next-field', function (e, textarea) {
            if (!$cms.dom.keyPressed(e, 'Tab')) {
                ensureNextField(textarea);
            }
        });
    };

    $cms.templates.formScreenInputRadioListComboEntry = function formScreenInputRadioListComboEntry(params, container) {
        var nameId = $cms.filter.id(params.name);

        toggleOtherCustomInput();
        $cms.dom.on(container, 'change', '.js-change-toggle-other-custom-input', function () {
            toggleOtherCustomInput();
        });

        function toggleOtherCustomInput() {
            $cms.dom.$('#j_' + nameId + '_other_custom').disabled = !$cms.dom.$('#j_' + nameId + '_other').checked;
        }
    };

    $cms.templates.formScreenInputVariousTricks = function formScreenInputVariousTricks(params, container) {
        var customName = strVal(params.customName);

        if (customName && !params.customAcceptMultiple) {
            var el = document.getElementById(params.customName + '_value');
            $cms.dom.trigger(el, 'change');
        }

        $cms.dom.on(container, 'click', '.js-click-checkbox-toggle-value-field', function (e, checkbox) {
            document.getElementById(customName + '_value').disabled = !checkbox.checked;
        });

        $cms.dom.on(container, 'change', '.js-change-input-toggle-value-checkbox', function (e, input) {
            document.getElementById(customName).checked = (input.value !== '');
            input.disabled = (input.value === '');
        });

        $cms.dom.on(container, 'keypress', '.js-keypress-input-ensure-next-field', function (e, input) {
            _ensureNextField(e, input);
        });
    };

    $cms.templates.formScreenInputText = function formScreenInputText(params) {
        if (params.required.includes('wysiwyg')) {
            if ((window.wysiwyg_on) && (wysiwygOn())) {
                document.getElementById(params.name).readOnly = true;
            }
        }

        $cms.manageScrollHeight(document.getElementById(params.name));
    };

    $cms.templates.formScreenInputTime = function formScreenInputTime(params) {
        // Uncomment if you want to force jQuery-UI inputs even when there is native browser input support
        //window.jQuery('#' + params.name).inputTime({});
    };

    /* Set up a word count for a form field */
    function setupWordCounter(post, count_element) {
        window.setInterval(function () {
            if ($cms.form.isWysiwygField(post)) {
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

    function permissionsOverridden(select) {
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

    function tryToSimplifyIframeForm() {
        var form_cat_selector = document.getElementById('main_form'),
            elements, i, element,
            count = 0, found, foundButton;
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
                        $cms.ui.confirm(
                            '{!Q_SURE_LOSE;^}',
                            function (result) {
                                if (result) {
                                    _simplifiedFormContinueSubmit(iframe, form_cat_selector);
                                }
                            }
                        );

                        return null;
                    }
                }

                _simplifiedFormContinueSubmit(iframe, form_cat_selector);

                return null;
            };
            if ((found.getAttribute('size') > 1) || (found.multiple)) found.onclick = found.onchange;
            if (iframe) {
                foundButton.style.display = 'none';
            }
        }
    }

    function _simplifiedFormContinueSubmit(iframe, form_cat_selector) {
        if ($cms.form.checkForm(form_cat_selector)) {
            if (iframe) {
                $cms.dom.animateFrameLoad(iframe, 'iframe_under');
            }
            form_cat_selector.submit();
        }
    }

    /* Geolocation for address fields */
    function geolocateAddressFields() {
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
                geocode_url += $cms.keepStub();

                $cms.doAjaxRequest(geocode_url, function (ajax_result) {
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
        } catch (ignore) {}
    }

    function joinForm(params) {
        var form = document.getElementById('username').form;

        form.elements['username'].onchange = function () {
            if (form.elements['intro_title'])
                form.elements['intro_title'].value = '{!cns:INTRO_POST_DEFAULT;^}'.replace(/\{1\}/g, form.elements['username'].value);
        };

        form.onsubmit = function () {
            if ((form.elements['confirm'] !== undefined) && (form.elements['confirm'].type == 'checkbox') && (!form.elements['confirm'].checked)) {
                $cms.ui.alert('{!cns:DESCRIPTION_I_AGREE_RULES;^}');
                return false;
            }

            if ((form.elements['email_address_confirm'] !== undefined) && (form.elements['email_address_confirm'].value != form.elements['email_address'].value)) {
                $cms.ui.alert('{!cns:EMAIL_ADDRESS_MISMATCH;^}');
                return false;
            }

            if ((form.elements['password_confirm'] !== undefined) && (form.elements['password_confirm'].value != form.elements['password'].value)) {
                $cms.ui.alert('{!cns:PASSWORD_MISMATCH;^}');
                return false;
            }

            document.getElementById('submit_button').disabled = true;

            var url = params.usernameCheckScript + '?username=' + encodeURIComponent(form.elements['username'].value);

            if (!$cms.form.doAjaxFieldTest(url, 'password=' + encodeURIComponent(form.elements['password'].value))) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }

            if (params.invitesEnabled) {
                url = params.snippetScript + '?snippet=invite_missing&name=' + encodeURIComponent(form.elements['email_address'].value);
                if (!$cms.form.doAjaxFieldTest(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            if (params.onePerEmailAddress) {
                url = params.snippetScript + '?snippet=exists_email&name=' + encodeURIComponent(form.elements['email_address'].value);
                if (!$cms.form.doAjaxFieldTest(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            if (params.useCaptcha) {
                url = params.snippetScript + '?snippet=captcha_wrong&name=' + encodeURIComponent(form.elements['captcha'].value);
                if (!$cms.form.doAjaxFieldTest(url)) {
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
            }

            document.getElementById('submit_button').disabled = false;
        };
    }

    // Hide a 'tray' of trs in a form
    function toggleSubordinateFields(pic, help_id) {
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
            pic.alt = '{!CONTRACT;^}';
            pic.title = '{!CONTRACT;^}';
            newDisplayState = (field_input.localName === 'tr') ? 'table-row' : 'block';
            newDisplayState2 = 'block';
        } else { /* Contracting now */
            pic.src = pic.src.includes('themewizard.php') ? pic.src.replace('contract', 'expand') : $cms.img('{$IMG;,1x/trays/expand}');
            if (pic.srcset !== undefined) {
                pic.srcset = pic.src.includes('themewizard.php') ? pic.srcset.replace('contract', 'expand') : ($cms.img('{$IMG;,2x/trays/expand}') + ' 2x');
            }
            pic.alt = '{!EXPAND;^}';
            pic.title = '{!EXPAND;^}';
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
                $cms.dom.clearTransitionAndSetOpacity(field_input, 0.0);
                $cms.dom.fadeTransition(field_input, 100, 30, 20);
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

        $cms.dom.triggerResize();
    }

    function choosePicture(j_id, img_ob, name, event) {
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
                if (img.parentNode.classList.contains('selected')) {
                    img.parentNode.classList.remove('selected');
                    img.style.outline = '0';
                    img.style.background = 'none';
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
        img_ob.parentNode.classList.add('selected');
        img_ob.style.outline = '1px dotted';
    }


    function standardAlternateFieldsWithin(set_name, something_required) {
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

        standardAlternateFields(field_names, something_required);

        // Do dynamic $cms.form.setLocked/$cms.form.setRequired such that one of these must be set, but only one may be
        function standardAlternateFields(field_names, something_required, second_run) {
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
                        standardAlternateFields(field_names, something_required, true);
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
                    } else {// List of fields (e.g. radio list, or just because standardAlternateFieldsWithin was used)
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

                        $cms.form.setLocked(field, is_locked, chosen_field);
                        if (something_required) {
                            $cms.form.setRequired(field.name.replace(/\[\]$/, ''), is_chosen);
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



// ===========
// Multi-field
// ===========

function _ensureNextField(event, el) {
    if ($cms.dom.keyPressed(event, 'Enter')) {
        gotoNextField(el);
    } else if (!$cms.dom.keyPressed(event, 'Tab')) {
        ensureNextField(el);
    }

    function gotoNextField(thisField) {
        var mid = thisField.id.lastIndexOf('_'),
            name_stub = thisField.id.substring(0, mid + 1),
            this_num = thisField.id.substring(mid + 1, thisField.id.length) - 0,
            next_num = this_num + 1,
            next_field = document.getElementById(name_stub + next_num);

        if (next_field) {
            try {
                next_field.focus();
            } catch (e) {}
        }
    }
}

function ensureNextField(this_field) {
    var mid = this_field.id.lastIndexOf('_'),
        name_stub = this_field.id.substring(0, mid + 1),
        this_num = this_field.id.substring(mid + 1, this_field.id.length) - 0,
        next_num = this_num + 1,
        next_field = document.getElementById(name_stub + next_num),
        name = name_stub + next_num,
        this_id = this_field.id;

    if (!next_field) {
        next_num = this_num + 1;
        this_field = document.getElementById(this_id);
        var next_field_wrap = document.createElement('div');
        next_field_wrap.className = this_field.parentNode.className;
        if (this_field.localName === 'textarea') {
            next_field = document.createElement('textarea');
        } else {
            next_field = document.createElement('input');
            next_field.setAttribute('size', this_field.getAttribute('size'));
        }
        next_field.className = this_field.className.replace(/\_required/g, '');
        if (this_field.form.elements['label_for__' + name_stub + '0']) {
            var nextLabel = document.createElement('input');
            nextLabel.setAttribute('type', 'hidden');
            nextLabel.value = this_field.form.elements['label_for__' + name_stub + '0'].value + ' (' + (next_num + 1) + ')';
            nextLabel.name = 'label_for__' + name_stub + next_num;
            next_field_wrap.appendChild(nextLabel);
        }
        next_field.setAttribute('tabindex', this_field.getAttribute('tabindex'));
        next_field.setAttribute('id', name_stub + next_num);
        if (this_field.onfocus) {
            next_field.onfocus = this_field.onfocus;
        }
        if (this_field.onblur) {
            next_field.onblur = this_field.onblur;
        }
        if (this_field.onkeyup) {
            next_field.onkeyup = this_field.onkeyup;
        }
        next_field.onkeypress = function (event) {
            _ensureNextField(event, next_field);
        };
        if (this_field.onchange) {
            next_field.onchange = this_field.onchange;
        }
        if (this_field.onrealchange != null) {
            next_field.onchange = this_field.onrealchange;
        }
        if (this_field.localName !== 'textarea') {
            next_field.type = this_field.type;
        }
        next_field.value = '';
        next_field.name = (this_field.name.includes('[]') ? this_field.name : (name_stub + next_num));
        next_field_wrap.appendChild(next_field);
        this_field.parentNode.parentNode.insertBefore(next_field_wrap, this_field.parentNode.nextSibling);
    }
}

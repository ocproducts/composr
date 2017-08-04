(function ($cms) {
    'use strict';

    $cms.views.CnsMemberProfileScreen = CnsMemberProfileScreen;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function CnsMemberProfileScreen(params) {
        CnsMemberProfileScreen.base(this, 'constructor', arguments);

        this.memberId = strVal(params.memberId);
        this.tabs = arrVal(params.tabs);

        this.tabs.forEach((function (tab) {
            var tabCode = strVal(tab.tabCode);

            if (tab.tabContent == null) {
                window['load_tab__' + tabCode] = (function (automated) {
                    // Self destruct loader after this first run
                    window['load_tab__' + tabCode] = function () {};

                    if (automated) {
                        scrollTo(0, 0);
                    }

                    $cms.loadSnippet('profile_tab&tab=' + tabCode + '&member_id=' + this.memberId + window.location.search.replace('?', '&'), null, true).then(function (result) {
                        $cms.dom.html('#g_' + tabCode, result.responseText);
                        $cms.dom.findUrlTab();
                    });
                }).bind(this);
            }
        }).bind(this));

        if (this.tabs.length > 1) {
            // we do not want it to scroll down
            var oldHash = window.location.hash;
            window.location.hash = '#';
            $cms.dom.findUrlTab(oldHash);
        }
    }

    $cms.templates.cnsGuestBar = function cnsGuestBar(params, container) {
        $cms.dom.on(container, 'submit', '.js-submit-check-field-login-username', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-checkbox-remember-me-confirm', function (e, checkbox) {
            if (checkbox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}', function (answer) {
                    if (!answer) {
                        checkbox.checked = false;
                    }
                });
            }
        });
    };

    $cms.inherits(CnsMemberProfileScreen, $cms.View, /**@lends CnsMemberProfileScreen#*/ {
        events: function () {
            return {
                'click .js-click-select-tab-g': 'onClickSelectTab'
            };
        },

        onClickSelectTab: function (e, clicked) {
            var tab = clicked.dataset.vwTab;
            if (tab) {
                $cms.ui.selectTab('g', tab);
            }
        }
    });
    
    $cms.templates.blockMainJoinDone = function blockMainJoinDone(params, container) {
        $cms.dom.on(container, 'submit', '.js-submit-ga-track-dl-whitepaper', function (e, form) {
            $cms.gaTrack(null, '{!cns:DOWNLOAD_WHITEPAPER;}', null, function () {
                form.submit();
            });
            e.preventDefault();
        });
    };

    $cms.templates.cnsMemberProfileEdit = function cnsMemberProfileEdit(params, container) {
        $cms.dom.on(container, 'click', '.js-click-select-edit-tab', function (e, clicked) {
            var tabSet = 'edit__',
                tabCode = $cms.filter.id(clicked.dataset.tpTabCode).toLowerCase();
            $cms.inform('Select tab', tabSet + tabCode);
            if (tabCode) {
                $cms.ui.selectTab('g', tabSet + tabCode)
            }
        });
    };

    $cms.templates.cnsMemberDirectoryScreenFilter = function cnsMemberDirectoryScreenFilter(params, container) {
        $cms.dom.on(container, 'keyup', '.js-keyup-input-filter-update-ajax-member-list', function (e, input) {
            $cms.form.updateAjaxMemberList(input, null, false, e);
        });
    };

    $cms.templates.cnsMemberProfileAbout = function cnsMemberProfileAbout(params, container) {
        $cms.dom.on(container, 'click', '.js-click-member-profile-about-decrypt-data', function () {
            decryptData();
        });
    };

    $cms.functions.moduleAdminCnsGroups = function moduleAdminCnsGroups() {
        var form;

        if (document.getElementById('delete')) {
            form = document.getElementById('delete').form;
            var crf = function () {
                if (form.elements['new_usergroup']) {
                    form.elements['new_usergroup'].disabled = (form.elements['delete'] && !form.elements['delete'].checked);
                }
            };
            crf();
            if (form.elements['delete']) {
                form.elements['delete'].onchange = crf;
            }
        }

        if (document.getElementById('is_presented_at_install')) {
            form = document.getElementById('is_presented_at_install').form;
            var crf2 = function () {
                if (form.elements['is_default']) {
                    form.elements['is_default'].disabled = (form.elements['is_presented_at_install'].checked);
                }
                if (form.elements['is_presented_at_install'].checked) {
                    form.elements['is_default'].checked = false;
                }
            };
            crf2();
            form.elements['is_presented_at_install'].onchange = crf2;
            var crf3 = function () {
                if (form.elements['absorb']) {
                    form.elements['absorb'].disabled = (form.elements['is_private_club'] && form.elements['is_private_club'].checked);
                }
            };
            crf3();
            if (form.elements['is_private_club']) {
                form.elements['is_private_club'].onchange = crf3;
            }
        }
    };

    $cms.functions.moduleAdminCnsGroupsRunStart = function moduleAdminCnsGroupsRunStart() {
        var form = document.getElementById('main_form'),
            submitBtn = document.getElementById('submit_button');
        form.addEventListener('submit', function submitCheck(e) {
            submitBtn.disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;^,snippet}?snippet=exists_usergroup&name=' + encodeURIComponent(form.elements['name'].value);
            e.preventDefault();
            $cms.form.doAjaxFieldTest(url).then(function (valid) {
                if (valid) {
                    form.removeEventListener('submit', submitCheck);
                    form.submit();
                } else {
                    submitBtn.disabled = false;
                }
            });
        });
    };

    $cms.functions.moduleAdminCnsEmoticons = function moduleAdminCnsEmoticons() {
        var form = document.getElementById('main_form'),
            submitBtn = document.getElementById('submit_button');
        form.addEventListener('submit', function submitCheck(e) {
            submitBtn.disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;^,snippet}?snippet=exists_emoticon&name=' + encodeURIComponent(form.elements['code'].value);
            e.preventDefault();
            $cms.form.doAjaxFieldTest(url).then(function (valid) {
                if (valid) {
                    form.removeEventListener('submit', submitCheck);
                    form.submit();
                } else {
                    submitBtn.disabled = false;
                }
            });
        });
    };

    $cms.functions.adminCnsMembersDownloadCsv = function adminCnsMembersDownloadCsv() {
        var form = $cms.dom.$('#filename').form;
        crf();
        for (var i = 0; i < form.elements['preset'].length; i++) {
            form.elements['preset'][i].onclick = crf;
        }

        function crf() {
            var preset = $cms.form.radioValue(form.elements['preset']);
            if (preset === '') {
                form.elements['fields_to_use'].disabled = false;
                form.elements['order_by'].disabled = false;
                form.elements['usergroups'].disabled = false;
                form.elements['filename'].value = form.elements['filename'].defaultValue;
            } else {
                form.elements['fields_to_use'].disabled = true;
                form.elements['order_by'].disabled = true;
                form.elements['usergroups'].disabled = true;
                form.elements['filename'].value = form.elements['filename'].defaultValue.replace(/^{$LCASE,{!MEMBERS;}}-/, preset + '-');
            }
        }
    };

    $cms.functions.hookProfilesTabsEditDeleteRenderTab = function hookProfilesTabsEditDeleteRenderTab() {
        var suffix = $cms.filter.id('{!cns:DELETE_MEMBER;^}').toLowerCase();

        window['load_tab__edit__' + suffix] = function () {
            var submitButton = document.getElementById('submit_button'),
                deleteCheckbox = document.getElementById('delete'),
                tab = document.getElementById('t_edit__' + suffix);

            submitButton.disabled = !deleteCheckbox.checked;

            setInterval(function () {
                submitButton.disabled = !deleteCheckbox.checked && tab.classList.contains('tab_active');
            }, 100);
        };
    };

    $cms.functions.hookProfilesTabsEditSettingsRenderTab = function hookProfilesTabsEditSettingsRenderTab() {
        var form = document.getElementById('email_address').form,
            submitBtn = document.getElementById('submit_button');
        form.addEventListener('submit', function submitCheck(e) {
            if (form.elements['edit_password'] !== undefined) {
                if ((form.elements['password_confirm']) && (form.elements['password_confirm'].value !== form.elements['edit_password'].value)) {
                    submitBtn.disabled = false;
                    $cms.ui.alert('{!PASSWORD_MISMATCH;^}');
                    return false;
                }

                if (form.elements['edit_password'].value !== '') {
                    e.preventDefault();
                    var url = '{$FIND_SCRIPT_NOHTTP;^,username_check}?';
                    $cms.form.doAjaxFieldTest(url, 'password=' + encodeURIComponent(form.elements['edit_password'].value)).then(function (valid) {
                        if (valid) {
                            form.removeEventListener('submit', submitCheck);
                            form.submit();
                        } else {
                            submitBtn.disabled = false;
                        }
                    });
                }
            }
        });
    };

    $cms.templates.cnsJoinStep1Screen = function cnsJoinStep1Screen(params, container) {
        $cms.dom.on(container, 'click', '.js-chb-click-toggle-proceed-btn', function (e, checkbox) {
            document.getElementById('proceed_button').disabled = !checkbox.checked;
        });

        $cms.dom.on(container, 'click', '.js-click-set-top-location', function (e, target) {
            window.top.location = strVal(target.dataset.tpTopLocation);
        });
    };


    $cms.templates.cnsViewGroupScreen = function cnsViewGroupScreen(params, container) {
        $cms.dom.on(container, 'submit', '.js-form-submit-add-member-to-group', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements.username)) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'keyup', '.js-input-add-member-username', function (e, input) {
            $cms.form.updateAjaxMemberList(input, null, false, e);
        });
    };

    $cms.templates.cnsEmoticonTable = function cnsEmoticonTable(params, container) {
        $cms.dom.on(container, 'click', '.js-click-do-emoticon', function (e, target) {
            var fieldName = target.dataset.tpFieldName;
            if (fieldName) {
                doEmoticon(fieldName, target, true)
            }
        });
    };

    $cms.templates.joinForm = function (params, container) {
        var skippable =  strVal(params.skippable);

        joinForm(params);

        $cms.dom.on(container, 'click', '.js-click-btn-skip-step', function () {
            $cms.dom.$('#' + skippable).value = '1';
        });

        $cms.dom.on(container, 'submit', '.js-submit-modesecurity-workaround', function (e, form) {
            e.preventDefault();
            $cms.form.modSecurityWorkaround(form);
        });
    };

    window.decryptData = decryptData;
    function decryptData() {
        if (document.getElementById('decryption_overlay')) {
            return;
        }

        var container = document.createElement('div');
        container.className = 'decryption_overlay box';
        container.id = 'decryption_overlay';
        container.style.position = 'absolute';
        container.style.width = '26em';
        container.style.padding = '0.5em';
        container.style.left = ($cms.dom.getWindowWidth() / 2 - 200).toString() + 'px';
        container.style.top = ($cms.dom.getWindowHeight() / 2 - 100).toString() + 'px';
        try {
            scrollTo(0, 0);
        } catch (e) {}

        var title = document.createElement('h2');
        title.appendChild(document.createTextNode('{!encryption:DECRYPT_TITLE;^}'));
        container.appendChild(title);

        var description = document.createElement('p');
        description.appendChild(document.createTextNode('{!encryption:DECRYPT_DESCRIPTION;^}'));
        container.appendChild(description);

        var form = document.createElement('form');
        form.action = window.location.href;
        form.method = 'post';
        container.appendChild(form);

        var label = document.createElement('label');
        label.setAttribute('for', 'decrypt');
        label.appendChild(document.createTextNode('{!encryption:DECRYPT_LABEL;^}'));
        form.appendChild(label);

        var space = document.createTextNode(' ');
        form.appendChild(space);

        var token = document.createElement('input');
        token.type = 'hidden';
        token.name = 'csrf_token';
        token.id = 'csrf_token';
        token.value = $cms.getCsrfToken();
        form.appendChild(token);

        var input = document.createElement('input');
        input.type = 'password';
        input.name = 'decrypt';
        input.id = 'decrypt';
        form.appendChild(input);

        var proceedDiv = document.createElement('div');
        proceedDiv.className = 'proceed_button';
        proceedDiv.style.marginTop = '1em';

        // Cancel button
        var button = document.createElement('input');
        button.type = 'button';
        button.className = 'buttons__cancel button_screen_item';
        button.value = '{!INPUTSYSTEM_CANCEL;^}';
        // Remove the form when it's cancelled
        button.addEventListener('click', function () {
            document.body.removeChild(container);
            return false;
        });
        proceedDiv.appendChild(button);

        // Submit button
        button = document.createElement('input');
        button.type = 'submit';
        button.className = 'buttons__proceed button_screen_item';
        button.value = '{!encryption:DECRYPT;^}';
        // Hide the form upon submission
        button.addEventListener('click', function () {
            container.style.display = 'none';
        });
        proceedDiv.appendChild(button);

        form.appendChild(proceedDiv);

        document.body.appendChild(container);

        setTimeout(function () {
            try {
                input.focus();
            } catch (e) {}
        }, 0);
    }

    function joinForm(params) {
        var form = document.getElementById('username').form,
            submitBtn = document.getElementById('submit_button');

        form.elements['username'].onchange = function () {
            if (form.elements['intro_title'])
                form.elements['intro_title'].value = '{!cns:INTRO_POST_DEFAULT;^}'.replace(/\{1\}/g, form.elements['username'].value);
        };

        form.addEventListener('submit', function submitCheck(e) {
            if ((form.elements['confirm'] !== undefined) && (form.elements['confirm'].type === 'checkbox') && (!form.elements['confirm'].checked)) {
                $cms.ui.alert('{!cns:DESCRIPTION_I_AGREE_RULES;^}');
                return false;
            }

            if ((form.elements['email_address_confirm'] !== undefined) && (form.elements['email_address_confirm'].value != form.elements['email_address'].value)) {
                $cms.ui.alert('{!EMAIL_ADDRESS_MISMATCH;^}');
                return false;
            }

            if ((form.elements['password_confirm'] !== undefined) && (form.elements['password_confirm'].value != form.elements['password'].value)) {
                $cms.ui.alert('{!PASSWORD_MISMATCH;^}');
                return false;
            }

            var checkPromises = [];
            e.preventDefault();
            submitBtn.disabled = true;

            var url = params.usernameCheckScript + '?username=' + encodeURIComponent(form.elements['username'].value);
            checkPromises.push($cms.form.doAjaxFieldTest(url, 'password=' + encodeURIComponent(form.elements['password'].value)));

            if (params.invitesEnabled) {
                url = params.snippetScript + '?snippet=invite_missing&name=' + encodeURIComponent(form.elements['email_address'].value);
                checkPromises.push($cms.form.doAjaxFieldTest(url));
            }

            if (params.onePerEmailAddress) {
                url = params.snippetScript + '?snippet=exists_email&name=' + encodeURIComponent(form.elements['email_address'].value);
                checkPromises.push($cms.form.doAjaxFieldTest(url));
            }

            if (params.useCaptcha) {
                url = params.snippetScript + '?snippet=captcha_wrong&name=' + encodeURIComponent(form.elements['captcha'].value);
                checkPromises.push($cms.form.doAjaxFieldTest(url));
            }

            Promise.all(checkPromises).then(function (validities) {
                if (!validities.includes(false)) {
                    // All valid!
                    form.removeEventListener('submit', submitCheck);
                    form.submit();
                } else {
                    submitBtn.disabled = false;
                }
            });
        });
    }

}(window.$cms));
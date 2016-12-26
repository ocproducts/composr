(function ($cms) {
    'use strict';

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
        var form = document.getElementById('main_form');
        form.old_submit = form.onsubmit;
        form.onsubmit = function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;^,snippet}?snippet=exists_usergroup&name=' + encodeURIComponent(form.elements['name'].value);
            if (!do_ajax_field_test(url)) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
            if (form.old_submit) {
                return form.old_submit();
            }
            return true;
        };
    };

    $cms.functions.moduleAdminCnsEmoticons = function moduleAdminCnsEmoticons() {
        var form = document.getElementById('main_form');
        form.old_submit = form.onsubmit;
        form.onsubmit = function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;^,snippet}?snippet=exists_emoticon&name=' + encodeURIComponent(form.elements['code'].value);
            if (!do_ajax_field_test(url)) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
            if (form.old_submit) {
                return form.old_submit();
            }
            return true;
        };
    };

    $cms.functions.adminCnsMembersDownloadCsv = function adminCnsMembersDownloadCsv() {
        var form = $cms.dom.$('#filename').form;
        crf();
        for (var i = 0; i < form.elements['preset'].length; i++) {
            form.elements['preset'][i].onclick = crf;
        }

        function crf() {
            var preset = radio_value(form.elements['preset']);
            if (preset == '') {
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
        var suffix = $cms.filter.id('{!DELETE_MEMBER;^}').toLowerCase();

        window['load_tab__edit__' + suffix] = function() {
            var submit_button = document.getElementById('submit_button'),
                delete_checkbox = document.getElementById('delete'),
                tab = document.getElementById('t_edit__' + suffix);

            submit_button.disabled = !delete_checkbox.checked;

            window.setInterval(function () {
                submit_button.disabled = !delete_checkbox.checked && tab.classList.contains('tab_active');
            }, 100);
        };
    };

    $cms.functions.hookProfilesTabsEditSettingsRenderTab = function hookProfilesTabsEditSettingsRenderTab() {
        var form = document.getElementById('email_address').form;
        form.prior_profile_edit_submit = form.onsubmit;
        form.onsubmit = function () {
            if (form.elements['edit_password'] !== undefined) {
                if ((form.elements['password_confirm']) && (form.elements['password_confirm'].value != form.elements['edit_password'].value)) {
                    document.getElementById('submit_button').disabled = false;
                    window.fauxmodal_alert('{!PASSWORD_MISMATCH;^}');
                    return false;
                }

                if (form.elements['edit_password'].value != '') {
                    var url = '{$FIND_SCRIPT_NOHTTP;^,username_check}?';
                    if (!do_ajax_field_test(url, 'password=' + encodeURIComponent(form.elements['edit_password'].value))) {
                        document.getElementById('submit_button').disabled = false;
                        return false;
                    }
                }
            }
            if (form.prior_profile_edit_submit) {
                return form.prior_profile_edit_submit();
            }
            return true;
        };
    };

    $cms.templates.cnsJoinStep1Screen = function cnsJoinStep1Screen() {
        var container = this;

        $cms.dom.on(container, 'click', '.js-chb-click-toggle-proceed-btn', function (e, checkbox) {
            document.getElementById('proceed_button').disabled = !checkbox.checked;
        });

        $cms.dom.on(container, 'click', '.js-click-set-top-location', function (e, target) {
            window.top.location = strVal(target.dataset.tpTopLocation);
        });
    };

    $cms.templates.cnsMemberProfileScreen = function cnsMemberProfileScreen(params) {
        var container = this,
            tabFunc = 'load_tab__' + params.tabCode;

        if (params.tabContent === undefined) {
            window[tabFunc] = function (automated) {
                if (automated) {
                    try {
                        window.scrollTo(0, 0);
                    } catch (e) {}
                }

                // Self destruct loader after this first run
                window[tabFunc] = function () {};

                load_snippet('profile_tab&tab=' + params.tabCode + '&member_id=' + params.memberId + window.location.search.replace('?', '&'), null, function (result) {
                    $cms.dom.html(document.getElementById('g_' + params.tabCode), result.responseText);

                    find_url_tab();
                });
            }
        }

        var tabs = +params.tabs || 0;

        if (tabs > 1) {
            // we do not want it to scroll down
            var old_hash = window.location.hash;
            window.location.hash = '#';
            find_url_tab(old_hash);
        }

        $cms.dom.on(container, 'click', '.js-click-select-tab-g', function (e, clicked) {
            var tab = clicked.dataset.tpTab;
            if (tab) {
                select_tab('g', tab);
            }
        });
    };

    $cms.templates.cnsMemberProfileEdit = function cnsMemberProfileEdit(params, container) {
        var tabCode = $cms.filter.id(params.tabCode).toLowerCase();

        $cms.dom.on(container, 'click', '.js-click-select-edit-tab', function () {
            select_tab('g','edit__' + tabCode)
        });
    };

    $cms.templates.cnsMemberDirectoryScreenFilter = function cnsMemberDirectoryScreenFilter(params, container) {
        $cms.dom.on(container, 'keyup', '.js-keyup-input-filter-update-ajax-member-list', function (e, input) {
            update_ajax_member_list(input, null, false, e);
        });
    };

    $cms.templates.cnsMemberProfileAbout = function cnsMemberProfileAbout(params, container) {
        $cms.dom.on(container, 'click', '.js-click-member-profile-about-decrypt-data', function () {
            decrypt_data();
        });
    };

    $cms.templates.cnsViewGroupScreen = function cnsViewGroupScreen(params, container) {
        $cms.dom.on(container, 'submit', '.js-form-submit-add-member-to-group', function (e, form) {
            if (check_field_for_blankness(form.elements.username, e)) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'keyup', '.js-input-add-member-username', function (e, input) {
            update_ajax_member_list(input, null, false, e);
        });
    };

    $cms.templates.cnsEmoticonTable = function cnsEmoticonTable(params, container) {
        $cms.dom.on(container, 'click', '.js-click-do-emoticon', function (e, target) {
            var fieldName = target.dataset.tpFieldName;
            if (fieldName) {
                do_emoticon(fieldName, target, true)
            }
        });
    };
}(window.$cms));
(function ($cms) {

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
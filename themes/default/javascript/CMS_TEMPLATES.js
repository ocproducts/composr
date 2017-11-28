(function ($cms, $util, $dom) {
    'use strict';
    
    /**
     * Addons will add template related methods under this namespace
     * @namespace $cms.templates
     */
    $cms.templates = {};

    $cms.templates.globalHtmlWrap = function () {
        if (document.getElementById('global_messages_2')) {
            var m1 = document.getElementById('global_messages');
            if (!m1) {
                return;
            }
            var m2 = document.getElementById('global_messages_2');
            $dom.append(m1, $dom.html(m2));
            m2.parentNode.removeChild(m2);
        }

        if (boolVal($cms.pageUrl().searchParams.get('wide_print'))) {
            try {
                window.print();
            } catch (ignore) {}
        }
    };

    $cms.templates.installerStepLog = function installerStepLog() {
        /* Code to auto-submit the form after 5 seconds, but only if there were no errors */
        if (document.querySelector('.installer_warning')) {
            return;
        }

        var button = document.getElementById('proceed_button'),
            timer;

        button.countdown = 6;

        continueFunc();
        timer = window.setInterval(continueFunc, 1000);
        button.addEventListener('mouseover', function () {
            if (timer) {
                window.clearInterval(timer);
                timer = null;
            }
        });
        window.addEventListener('unload', function () {
            if (timer) {
                window.clearInterval(timer);
                timer = null;
            }
        });
        button.addEventListener('mouseout', function (e) {
            timer = window.setInterval(continueFunc, 1000);
        });

        function continueFunc() {
            button.value = "{!PROCEED} ({!AUTO_IN} " + button.countdown + ")";
            if (button.countdown === 0) {
                if (timer) {
                    window.clearInterval(timer);
                    timer = null;
                }
                $dom.submit(button.form);
            } else {
                button.countdown--;
            }
        }
    };

    $cms.templates.installerHtmlWrap = function installerHtmlWrap(params, container) {
        var defaultForm = strVal(params.defaultForm);

        var none = document.getElementById(defaultForm);
        if (none) {
            none.checked = true;
        }

        if ((defaultForm !== 'none') && (defaultForm !== 'cns')) {
            var d = document.getElementById('forum_path');
            if (d) {
                d.style.display = 'block';
            }
        }

        var form = document.querySelector('form');
        if (form != null) {
            form.title = '';
        }

        var cns = document.getElementById('cns');
        if (cns) {
            useMultiDbLocker();

            for (var i=0; i < form.elements['forum'].length; i++) {
                form.elements['forum'][i].onclick = useMultiDbLocker;
            }
        }

        function useMultiDbLocker() {
            form.elements['use_multi_db'][0].disabled = cns.checked;
            form.elements['use_multi_db'][1].disabled = cns.checked;
            if (cns.checked) {
                form.elements['use_multi_db'][1].checked = true;
            }
        }
    };

    function toggleInstallerSection(id) {
        // Try and grab our item
        var itm = document.getElementById(id),
            img = document.getElementById('img_' + id);

        if (itm.style.display === 'none') {
            itm.style.display = 'block';
            if (img) {
                img.src = $cms.baseUrl('install.php?type=contract');
                img.alt = img.alt.replace('{!EXPAND;}', '{!CONTRACT;}');
                img.title = img.title.replace('{!EXPAND;}', '{!CONTRACT;}');
            }
        } else {
            itm.style.display = 'none';
            if (img) {
                img.src = $cms.baseUrl('install.php?type=expand');
                img.alt = img.alt.replace('{!CONTRACT;}', '{!EXPAND;}');
                img.title = img.title.replace('{!CONTRACT;}', '{!EXPAND;}');
            }
        }
    }

    $cms.templates.installerStep3 = function installerStep3(params, container) {
        $dom.on(container, 'click', '.js-click-toggle-advanced-db-setup-section', function (e, clicked) {
            var id = strVal(clicked.dataset.tpSection);
            toggleInstallerSection(id);
        });
    };

    $cms.templates.installerForumChoice = function installerForumChoice(params, container) {
        var versions = strVal(params.versions);

        $dom.on(container, 'click', '.js-click-do-forum-choose', function (e, clicked) {
            doForumChoose(clicked, $cms.filter.nl(versions));
        });

        function doForumChoose(el, versions) {
            $dom.html('#versions', versions);

            var type = 'none';
            if ((el.id !== 'none') && (el.id !== 'cns')) {
                type = 'block';
                var label = document.getElementById('sep_forum');
                if (label) {
                    $dom.html(label, el.nextElementSibling.textContent);
                }
            }

            document.getElementById('forum_database_info').style.display = type;
            if (document.getElementById('forum_path')) {
                document.getElementById('forum_path').style.display = type;
            }
        }
    };

    $cms.templates.installerInputLine = function installerInputLine(params, input) {
        $dom.on(input, 'change', function () {
            input.changed = true;
        });
    };

    $cms.templates.installerStep4 = function installerStep4(params, container) {
        var passwordPrompt = strVal(params.passwordPrompt),
            domain = document.getElementById('domain');

        if (domain) {
            domain.addEventListener('change', function () {
                var cs = document.getElementById('Cookie_space_settings');
                if (cs && (cs.style.display === 'none')) {
                    toggleInstallerSection('Cookie_space_settings');
                }
                var cd = document.getElementById('cookie_domain');
                if (cd && (cd.value !== '')) {
                    cd.value = '.' + domain.value;
                }
            });
        }

        var gaeApp = document.getElementById('gae_application');

        if (gaeApp) {
            gaeOnChange();
            gaeApp.addEventListener('change', gaeOnChange);
        }

        function gaeOnChange() {
            var gaeLiveDbSite = document.getElementById('gae_live_db_site'),
                gaeLiveDbSiteHost = document.getElementById('gae_live_db_site_host'),
                gaeBucketName = document.getElementById('gae_bucket_name');

            gaeLiveDbSite.value = gaeLiveDbSite.value.replace(/(<application>|composr)/g, gaeApp.value);
            gaeLiveDbSiteHost.value = gaeLiveDbSiteHost.value.replace(/(<application>|composr)/g, gaeApp.value);
            gaeBucketName.value = gaeBucketName.value.replace(/(<application>|composr)/g, gaeApp.value);
        }

        var step4Form = document.getElementById('form-installer-step-4');

        if (step4Form) {
            step4Form.addEventListener('submit', validateSettings);
        }

        function validateSettings(e) {
            e.preventDefault();

            if ((step4Form.elements['forum_base_url']) && (step4Form.elements['forum_base_url'].type !== 'hidden') && (step4Form.elements['forum_base_url'].value === step4Form.elements['base_url'].value)) {
                window.alert('{!FORUM_BASE_URL_INVALID;/}');
                return;
            }

            if ((step4Form.elements['forum_base_url']) && (step4Form.elements['forum_base_url'].type !== 'hidden') && (step4Form.elements['forum_base_url'].value.substr(-7) === '/forums') && (!step4Form.elements['forum_base_url'].changed)) {
                if (!window.confirm('{!FORUM_BASE_URL_UNCHANGED;/}')) {
                    return;
                }
            }

            for (var i = 0; i < step4Form.elements.length; i++) {
                if ((step4Form.elements[i].classList.contains('required1')) && (step4Form.elements[i].value === '')) {
                    window.alert('{!IMPROPERLY_FILLED_IN;^}');
                    return;
                }
            }

            if (!checkPasswords(step4Form)) {
                return;
            }

            var checkPromises = [], post;

            if ((step4Form.elements['db_site_password'])) {
                var sitePwdCheckUrl = 'install.php?type=ajax_db_details';
                post = 'db_type=' + encodeURIComponent(step4Form.elements['db_type'].value) + '&db_site_host=' + encodeURIComponent(step4Form.elements['db_site_host'].value) + '&db_site=' + encodeURIComponent(step4Form.elements['db_site'].value) + '&db_site_user=' + encodeURIComponent(step4Form.elements['db_site_user'].value) + '&db_site_password=' + encodeURIComponent(step4Form.elements['db_site_password'].value);
                checkPromises.push($cms.form.doAjaxFieldTest(sitePwdCheckUrl, post));
            }

            if (step4Form.elements['db_forums_password']) {
                var forumsPwdCheckUrl = 'install.php?type=ajax_db_details';
                post = 'db_type=' + encodeURIComponent(step4Form.elements['db_type'].value) + '&db_forums_host=' + encodeURIComponent(step4Form.elements['db_forums_host'].value) + '&db_forums=' + encodeURIComponent(step4Form.elements['db_forums'].value) + '&db_forums_user=' + encodeURIComponent(step4Form.elements['db_forums_user'].value) + '&db_forums_password=' + encodeURIComponent(step4Form.elements['db_forums_password'].value);
                checkPromises.push($cms.form.doAjaxFieldTest(forumsPwdCheckUrl, post));
            }

            if (step4Form.elements['ftp_domain']) {
                var ftpDomainCheckUrl = 'install.php?type=ajax_ftp_details';
                post = 'ftp_domain=' + encodeURIComponent(step4Form.elements['ftp_domain'].value) + '&ftp_folder=' + encodeURIComponent(step4Form.elements['ftp_folder'].value) + '&ftp_username=' + encodeURIComponent(step4Form.elements['ftp_username'].value) + '&ftp_password=' + encodeURIComponent(step4Form.elements['ftp_password'].value);
                checkPromises.push($cms.form.doAjaxFieldTest(ftpDomainCheckUrl, post));
            }

            Promise.all(checkPromises).then(function (validities) {
                if (!validities.includes(false)) {
                    // All valid!
                    step4Form.submit();
                }
            });
        }

        /**
         * NOTE: This function also has a copy in PASSWORD_CHECK_JS.tpl so update that as well when modifying here.
         * @param form
         * @return {boolean}
         */
        function checkPasswords(form) {
            if (form.confirm) {
                return true;
            }

            if (form.elements['cns_admin_password_confirm'] != null) {
                if (!checkPassword(form, 'cns_admin_password', '{!ADMIN_USERS_PASSWORD;^}')) {
                    return false;
                }
            }

            if (form.elements['master_password_confirm'] != null) {
                if (!checkPassword(form, 'master_password', '{!MASTER_PASSWORD;^}')) {
                    return false;
                }
            }

            if (passwordPrompt !== '') {
                window.alert(passwordPrompt);
            }

            return true;

            function checkPassword(form, fieldName, fieldLabel) {
                // Check matches with confirm field
                if (form.elements[fieldName + '_confirm'].value !== form.elements[fieldName].value) {
                    window.alert($util.format('{!PASSWORDS_DO_NOT_MATCH;^/}', [fieldLabel]));
                    return false;
                }

                // Check does not match database password
                if (form.elements['db_site_password'] != null) {
                    if ((form.elements[fieldName].value !== '') && (form.elements[fieldName].value === form.elements['db_site_password'].value)) {
                        window.alert($util.format('{!PASSWORDS_DO_NOT_REUSE;^/}', [fieldLabel]));
                        return false;
                    }
                }

                // Check password is secure
                var isSecurePassword = true;
                if (form.elements[fieldName].value.length < 8) {
                    isSecurePassword = false;
                }
                if (!form.elements[fieldName].value.match(/[a-z]/)) {
                    isSecurePassword = false;
                }
                if (!form.elements[fieldName].value.match(/[A-Z]/)) {
                    isSecurePassword = false;
                }
                if (!form.elements[fieldName].value.match(/\d/)) {
                    isSecurePassword = false;
                }
                if (!form.elements[fieldName].value.match(/[^a-zA-Z\d]/)) {
                    isSecurePassword = false;
                }

                if (!isSecurePassword) {
                    return window.confirm($util.format('{!PASSWORD_INSECURE;^}', [fieldLabel])) && window.confirm($util.format('{!CONFIRM_REALLY;^} {!PASSWORD_INSECURE;^}', [fieldLabel]));
                }

                return true;
            }
        }
    };

    $cms.templates.installerStep4SectionHide = function installerStep4SectionHide(params, container) {
        var title = strVal(params.title);

        $dom.on(container, 'click', '.js-click-toggle-title-section', function () {
            toggleInstallerSection($cms.filter.id($cms.filter.nl(title)));
        });
    };

    $cms.templates.blockMainScreenActions = function blockMainScreenActions(params, container) {
        var easySelfUrl = strVal(params.easySelfUrl);

        $dom.on(container, 'click', '.js-click-action-print-screen', function (e, link) {
            $cms.gaTrack(null,'{!recommend:PRINT_THIS_SCREEN;}');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-facebook', function (e, link) {
            $cms.gaTrack(null,'social__facebook');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-twitter', function (e, link) {
            link.setAttribute('href', 'https://twitter.com/share?count=horizontal&counturl=' + easySelfUrl + '&original_referer=' + easySelfUrl + '&text=' + encodeURIComponent(document.title) + '&url=' + easySelfUrl);

            $cms.gaTrack(null,'social__twitter');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-stumbleupon', function (e, link) {
            $cms.gaTrack(null,'social__stumbleupon');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-digg', function (e, link) {
            $cms.gaTrack(null,'social__digg');
        });
    };

    $cms.functions.abstractFileManagerGetAfmForm = function abstractFileManagerGetAfmForm() {
        var usesFtp = document.getElementById('uses_ftp');
        if (!usesFtp) {
            return;
        }

        ftpTicker();
        usesFtp.onclick = ftpTicker;

        function ftpTicker() {
            var form = usesFtp.form;
            form.elements['ftp_domain'].disabled = !usesFtp.checked;
            form.elements['ftp_directory'].disabled = !usesFtp.checked;
            form.elements['ftp_username'].disabled = !usesFtp.checked;
            form.elements['ftp_password'].disabled = !usesFtp.checked;
            form.elements['remember_password'].disabled = !usesFtp.checked;
        }
    };

    $cms.templates.standaloneHtmlWrap = function (params) {
        if (window.parent) {
            $dom.load.then(function () {
                document.body.classList.add('frame');

                try {
                    $dom.triggerResize();
                } catch (e) {}

                setTimeout(function () { // Needed for IE10
                    try {
                        $dom.triggerResize();
                    } catch (e) {}
                }, 1000);
            });
        }

        if (params.isPreview) {
            $cms.form.disablePreviewScripts();
        }
    };

    $cms.templates.jsRefresh = function (params){
        if (!window.location.hash.includes('redirected_once')) {
            window.location.hash = 'redirected_once';
            $dom.submit(document.getElementById(params.formName));
        } else {
            window.history.go(-2); // We've used back button, don't redirect forward again
        }
    };

    $cms.templates.forumsEmbed = function () {
        var frame = this;
        setInterval(function () {
            $dom.resizeFrame(frame.name);
        }, 500);
    };

    $cms.templates.massSelectFormButtons = function (params, delBtn) {
        var form = delBtn.form;

        $dom.on(delBtn, 'click', function () {
            confirmDelete(form, true, function () {
                var idEl = $dom.$id('id'),
                    ids = (idEl.value === '') ? [] : idEl.value.split(',');

                for (var i = 0; i < ids.length; i++) {
                    prepareMassSelectMarker('', params.type, ids[i], true);
                }

                form.method = 'post';
                form.action = params.actionUrl;
                form.target = '_top';
                $dom.submit(form);
            });
        });

        $dom.on('#id', 'change', initialiseButtonVisibility);
        initialiseButtonVisibility();

        function initialiseButtonVisibility() {
            var id = $dom.$('#id'),
                ids = (id.value === '') ? [] : id.value.split(/,/);

            $dom.$('#submit_button').disabled = (ids.length !== 1);
            $dom.$('#mass_select_button').disabled = (ids.length === 0);
        }
    };

    $cms.templates.massSelectDeleteForm = function (e, form) {
        $dom.on(form, 'submit', function (e) {
            e.preventDefault();
            confirmDelete(form, true);
        });
    };

    $cms.templates.groupMemberTimeoutManageScreen = function groupMemberTimeoutManageScreen(params, container) {
        $dom.on(container, 'focus', '.js-focus-update-ajax-member-list', function (e, input) {
            if (input.value === '') {
                $cms.form.updateAjaxMemberList(input, null, true, e);
            }
        });

        $dom.on(container, 'keyup', '.js-keyup-update-ajax-member-list', function (e, input) {
            $cms.form.updateAjaxMemberList(input, null, false, e);
        });
    };

    $cms.templates.uploadSyndicationSetupScreen = function (params) {
        var winParent = window.parent || window.opener,
            id = 'upload_syndicate__' + params.hook + '__' + params.name,
            el = winParent.document.getElementById(id);

        el.checked = true;

        setTimeout(function () {
            if (window.fauxClose !== undefined) {
                window.fauxClose();
            } else {
                window.close();
            }
        }, 4000);
    };

    $cms.templates.blockMainComcodePageChildren = function blockMainComcodePageChildren() {};

    $cms.templates.loginScreen = function loginScreen(params, container) {
        if ((document.activeElement != null) || (document.activeElement !== $dom.$('#password'))) {
            try {
                $dom.$('#login_username').focus();
            } catch (ignore) {}
        }

        $dom.on(container, 'click', '.js-click-checkbox-remember-me-confirm', function (e, checkbox) {
            var checkboxWasFocused = (document.activeElement === checkbox);

            if (checkbox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}').then(function (answer) {
                    if (!answer) {
                        checkbox.checked = false;
                    }

                    if (checkboxWasFocused) {
                        checkbox.focus();
                    }
                });
            }
        });

        $dom.on(container, 'submit', '.js-submit-check-login-username-field', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });
    };

    $cms.templates.blockTopLogin = function (blockTopLogin, container) {
        $dom.on(container, 'submit', '.js-form-top-login', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $dom.on(container, 'click', '.js-click-confirm-remember-me', function (e, checkbox) {
            var checkboxWasFocused = (document.activeElement === checkbox);

            if (checkbox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}').then(function (answer) {
                    if (!answer) {
                        checkbox.checked = false;
                    }

                    if (checkboxWasFocused) {
                        checkbox.focus();
                    }
                });
            }
        });
    };

    $cms.templates.ipBanScreen = function (params, container) {
        var textarea = container.querySelector('#bans');
        $cms.manageScrollHeight(textarea);

        if (!$cms.isMobile()) {
            $dom.on(container, 'keyup', '#bans', function (e, textarea) {
                $cms.manageScrollHeight(textarea);
            });
        }
    };

    $cms.templates.jsBlock = function jsBlock(params) {
        $cms.callBlock(params.blockCallUrl, '', $dom.$id(params.jsBlockId), false, false, null, false, false);
    };

    $cms.templates.massSelectMarker = function (params, container) {
        $dom.on(container, 'click', '.js-chb-prepare-mass-select', function (e, checkbox) {
            prepareMassSelectMarker(params.supportMassSelect, params.type, params.id, checkbox.checked);
        });
    };


    $cms.templates.blockTopPersonalStats = function (params, container) {
        $dom.on(container, 'click', '.js-click-toggle-top-personal-stats', function (e) {
            if (toggleTopPersonalStats(e) === false) {
                e.preventDefault();
            }
        });

        function toggleTopPersonalStats(event) {
            window._toggleMessagingBox(event, 'pts', true);
            window._toggleMessagingBox(event, 'web_notifications', true);
            return window._toggleMessagingBox(event, 'top_personal_stats');
        }
    };

    $cms.templates.blockSidePersonalStatsNo = function blockSidePersonalStatsNo(params, container) {
        $dom.on(container, 'submit', '.js-submit-check-login-username-field', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $dom.on(container, 'click', '.js-click-checkbox-remember-me-confirm', function (e, checkbox) {
            var checkboxWasFocused = (document.activeElement === checkbox);

            if (checkbox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}').then(function (answer) {
                    if (!answer) {
                        checkbox.checked = false;
                    }

                    if (checkboxWasFocused) {
                        checkbox.focus();
                    }
                });
            }
        });
    };

    $cms.templates.memberTooltip = function (params, container) {
        var submitter = strVal(params.submitter);

        $dom.on(container, 'mouseover', '.js-mouseover-activate-member-tooltip', function (e, el) {
            el.cancelled = false;
            $cms.loadSnippet('member_tooltip&member_id=' + submitter, null, true).then(function (result) {
                if (!el.cancelled) {
                    $cms.ui.activateTooltip(el, e, result, 'auto', null, null, false, true);
                }
            });
        });

        $dom.on(container, 'mouseout', '.js-mouseout-deactivate-member-tooltip', function (e, el) {
            $cms.ui.deactivateTooltip(el);
            el.cancelled = true;
        });
    };

    $cms.templates.resultsLauncherContinue = function resultsLauncherContinue(params, link) {
        var max = params.max,
            urlStub = params.urlStub,
            numPages = params.numPages,
            message = $util.format('{!javascript:ENTER_PAGE_NUMBER;^}', [numPages]);

        $dom.on(link, 'click', function () {
            $cms.ui.prompt(message, numPages, function (res) {
                if (!res) {
                    return;
                }

                res = parseInt(res);
                if ((res >= 1) && (res <= numPages)) {
                    $util.navigate(urlStub + (urlStub.includes('?') ? '&' : '?') + 'start=' + (max * (res - 1)));
                }
            }, '{!JUMP_TO_PAGE;^}');
        });
    };

    $cms.templates.doNextItem = function doNextItem(params, container) {
        var rand = params.randDoNextItem,
            url = params.url,
            target = params.target,
            warning = params.warning,
            autoAdd = params.autoAdd;

        $dom.on(container, 'click', function (e) {
            var clickedLink = $dom.closest(e.target, 'a', container);

            if (!clickedLink) {
                $util.navigate(url, target);
                return;
            }

            if (autoAdd) {
                e.preventDefault();
                $cms.ui.confirm('{!KEEP_ADDING_QUESTION;^}', function (answer) {
                    var append = '';
                    if (answer) {
                        append += url.includes('?') ? '&' : '?';
                        append += autoAdd + '=1';
                    }
                    $util.navigate(url + append, target);
                });
                return;
            }

            if (warning && clickedLink.classList.contains('js-click-confirm-warning')) {
                e.preventDefault();
                $cms.ui.confirm(warning, function (answer) {
                    if (answer) {
                        $util.navigate(url, target);
                    }
                });
            }
        });

        var docEl = document.getElementById('doc_' + rand),
            helpEl = document.getElementById('help');

        if (docEl && helpEl) {
            /* Do-next document tooltips */
            $dom.on(container, 'mouseover', function () {
                if ($dom.html(docEl) !== '') {
                    window.origHelperText = $dom.html(helpEl);
                    $dom.html(helpEl, $dom.html(docEl));
                    $dom.fadeIn(helpEl);

                    helpEl.classList.remove('global_helper_panel_text');
                    helpEl.classList.add('global_helper_panel_text_over');
                }
            });

            $dom.on(container, 'mouseout', function () {
                if (window.origHelperText !== undefined) {
                    $dom.html(helpEl, window.origHelperText);
                    $dom.fadeIn(helpEl);

                    helpEl.classList.remove('global_helper_panel_text_over');
                    helpEl.classList.add('global_helper_panel_text');
                }
            });
        }

        if (autoAdd) {
            var links = $dom.$$(container, 'a');

            links.forEach(function (link) {
                link.onclick = function (event) {
                    event.preventDefault();
                    $cms.ui.confirm(
                        '{!KEEP_ADDING_QUESTION;^}',
                        function (test) {
                            if (test) {
                                link.href += link.href.includes('?') ? '&' : '?';
                                link.href += autoAdd + '=1';
                            }

                            $util.navigate(link);
                        }
                    );
                };
            });
        }
    };

    $cms.templates.internalizedAjaxScreen = function internalizedAjaxScreen(params, element) {
        var url = strVal(params.url),
            changeDetectionUrl = strVal(params.changeDetectionUrl),
            refreshTime = Number(params.refreshTime) || 0,
            refreshIfChanged = strVal(params.refreshIfChanged);

        if (changeDetectionUrl && (refreshTime > 0)) {
            window.ajaxScreenDetectInterval = setInterval(function () {
                detectChange(changeDetectionUrl, refreshIfChanged, function () {
                    if (!document.getElementById('post') || (document.getElementById('post').value === '')) {
                        $cms.callBlock(url, '', element, false, true, null, true).then(function () {
                            detectedChange();
                        });
                    }
                });
            }, refreshTime * 1000);
        }

        $dom.internaliseAjaxBlockWrapperLinks(url, element, ['.*'], {}, false, true);
    };

    $cms.templates.ajaxPagination = function ajaxPagination(params) {
        var wrapperEl = $dom.$id(params.wrapperId),
            blockCallUrl = params.blockCallUrl,
            infiniteScrollCallUrl = params.infiniteScrollCallUrl,
            infiniteScrollFunc;

        if (wrapperEl) {
            $dom.internaliseAjaxBlockWrapperLinks(blockCallUrl, wrapperEl, ['^[^_]*_start$', '^[^_]*_max$'], {});

            if (infiniteScrollCallUrl) {
                infiniteScrollFunc = $dom.internaliseInfiniteScrolling.bind(undefined, infiniteScrollCallUrl, wrapperEl);

                $dom.on(window, {
                    scroll: infiniteScrollFunc,
                    touchmove: infiniteScrollFunc,
                    keydown: $dom.infiniteScrollingBlock,
                    mousedown: $dom.infiniteScrollingBlockHold,
                    mousemove: function () {
                        // mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
                        $dom.infiniteScrollingBlockUnhold(infiniteScrollFunc);
                    }
                });

                infiniteScrollFunc();
            }
        } else {
            $util.inform('$cms.templates.ajaxPagination(): Wrapper element not found.');
        }
    };

    $cms.templates.confirmScreen = function confirmScreen(params) {};

    $cms.templates.warnScreen = function warnScreen() {
        if (window.top !== window) {
            $dom.triggerResize();
        }
    };

    $cms.templates.fatalScreen = function fatalScreen() {
        if (window.top !== window) {
            $dom.triggerResize();
        }
    };

    $cms.templates.columnedTableScreen = function columnedTableScreen(params) {
        if (params.jsFunctionCalls != null) {
            $cms.executeJsFunctionCalls(params.jsFunctionCalls);
        }
    };

    $cms.templates.questionUiButtons = function questionUiButtons(params, container) {
        $dom.on(container, 'click', '.js-click-close-window-with-val', function (e, clicked) {
            window.returnValue = clicked.dataset.tpReturnValue;

            if (window.fauxClose !== undefined) {
                window.fauxClose();
            } else {
                try {
                    window.$cms.getMainCmsWindow().focus();
                } catch (ignore) {}

                window.close();
            }
        });
    };

    $cms.templates.buttonScreenItem = function buttonScreenItem(params, btn) {
        var onclickCallFunctions = params.onclickCallFunctions;

        if (onclickCallFunctions != null) {
            $dom.on(btn, 'click', function (e) {
                e.preventDefault();
                $cms.executeJsFunctionCalls(onclickCallFunctions, btn);
            });
        }
    };

    $cms.templates.cropTextMouseOver = function (params, el) {
        var textLarge = $cms.filter.nl(params.textLarge);

        $dom.on(el, 'mouseover', function (e) {
            $cms.ui.activateTooltip(el, e, textLarge, '40%');
        });
    };

    $cms.templates.cropTextMouseOverInline = function (params, el) {
        var textLarge = $cms.filter.nl(params.textLarge);

        $dom.on(el, 'mouseover', function (e) {
            var window = $cms.getMainCmsWindow(true);
            window.$cms.ui.activateTooltip(el, e, textLarge, '40%', null, null, null, false, false, false, window);
        });
    };

    $cms.templates.handleConflictResolution = function (params) {
        var pingUrl = strVal(params.pingUrl);

        if ('{$VALUE_OPTION;,disable_handle_conflict_resolution}' === '1') {
            return;
        }

        if (pingUrl) {
            $cms.doAjaxRequest(pingUrl);

            setInterval(function () {
                $cms.doAjaxRequest(pingUrl);
            }, 12000);
        }
    };

    $cms.templates.indexScreenFancierScreen = function indexScreenFancierScreen(params) {
        if (document.getElementById('search_content')) {
            document.getElementById('search_content').value = strVal(params.rawSearchString);
        }
    };

    $cms.templates.doNextScreen = function doNextScreen(params) {};

    function detectChange(changeDetectionUrl, refreshIfChanged, callback) {
        $cms.doAjaxRequest(changeDetectionUrl, null, 'refresh_if_changed=' + encodeURIComponent(refreshIfChanged)).then(function (xhr) {
            var response = strVal(xhr.responseText);
            if (response === '1') {
                clearInterval(window.ajaxScreenDetectInterval);
                $util.inform('detectChange(): Change detected');
                callback();
            }
        });
    }

    function detectedChange() {
        $util.inform('detectedChange(): Change notification running');

        try {
            window.focus();
        } catch (e) {}

        var soundUrl = 'data/sounds/message_received.mp3',
            baseUrl = (!soundUrl.includes('data_custom') && !soundUrl.includes('uploads/')) ? $cms.getBaseUrlNohttp() : $cms.getCustomBaseUrlNohttp(),
            soundObject = window.soundManager.createSound({ url: baseUrl + '/' + soundUrl });

        if (soundObject && document.hasFocus()/*don't want multiple tabs all pinging*/) {
            soundObject.play();
        }
    }

    $cms.functions.decisionTreeRender = function decisionTreeRender(parameter, value, notice, noticeTitle) {
        value = strVal(value);
        var els = document.getElementById('main_form').elements[parameter];
        if (els.length === undefined) {
            els = [els];
        }
        for (var i = 0; i < els.length; i++) {
            els[i].addEventListener('click', (function (el) {
                return function () {
                    var selected = false;
                    if (el.type === 'checkbox') {
                        selected = (el.checked && (el.value === value)) || (!el.checked && ('' === value));
                    } else {
                        selected = (el.value === value);
                    }
                    if (selected) {
                        $cms.ui.alert(notice, noticeTitle, true);
                    }
                };
            }(els[i])));
        }
    };

    function confirmDelete(form, multi, callback) {
        multi = !!multi;

        $cms.ui.confirm(multi ? '{!_ARE_YOU_SURE_DELETE;^}' : '{!ARE_YOU_SURE_DELETE;^}').then(function (result) {
            if (result) {
                if (callback != null) {
                    callback();
                } else {
                    $dom.submit(form);
                }
            }
        });
    }

    function prepareMassSelectMarker(set, type, id, checked) {
        var massDeleteForm = $dom.$id('mass_select_form__' + set);
        if (!massDeleteForm) {
            massDeleteForm = $dom.$id('mass_select_button').form;
        }
        var key = type + '_' + id;
        var hidden;
        if (massDeleteForm.elements[key] === undefined) {
            hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = key;
            massDeleteForm.appendChild(hidden);
        } else {
            hidden = massDeleteForm.elements[key];
        }
        hidden.value = checked ? '1' : '0';
        massDeleteForm.style.display = 'block';
    }
}(window.$cms, window.$util, window.$dom));

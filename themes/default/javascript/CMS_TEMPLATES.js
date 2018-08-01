(function ($cms, $util, $dom) {
    'use strict';

    /**
     * Addons will add template related methods under this namespace
     * @namespace $cms.templates
     */
    $cms.templates = {};

    $cms.templates.globalHtmlWrap = function () {
        if (document.getElementById('global-messages-2')) {
            var m1 = document.getElementById('global-messages');
            if (!m1) {
                return;
            }
            var m2 = document.getElementById('global-messages-2');
            $dom.append(m1, $dom.html(m2));
            m2.parentNode.removeChild(m2);
        }

        if (boolVal($cms.pageUrl().searchParams.get('wide_print'))) {
            try {
                window.print();
            } catch (ignore) {}
        }
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
            link.href = 'https://twitter.com/share?count=horizontal&counturl=' + easySelfUrl + '&original_referer=' + easySelfUrl + '&text=' + encodeURIComponent(document.title) + '&url=' + easySelfUrl;

            $cms.gaTrack(null,'social__twitter');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-digg', function (e, link) {
            $cms.gaTrack(null,'social__digg');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-linkedin', function (e, link) {
            $cms.gaTrack(null,'social__linkedin');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-pinterest', function (e, link) {
            $cms.gaTrack(null,'social__pinterest');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-tumblr', function (e, link) {
            $cms.gaTrack(null,'social__tumblr');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-vk', function (e, link) {
            $cms.gaTrack(null,'social__vk');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-sina-weibo', function (e, link) {
            $cms.gaTrack(null,'social__sina_weibo');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-tencent-weibo', function (e, link) {
            $cms.gaTrack(null,'social__tencent_weibo');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-qzone', function (e, link) {
            $cms.gaTrack(null,'social__qzone');
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

            $dom.$('#submit-button').disabled = (ids.length !== 1);
            $dom.$('#mass-select-button').disabled = (ids.length === 0);
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
            window.$coreNotifications.toggleMessagingBox(event, 'pts', true);
            window.$coreNotifications.toggleMessagingBox(event, 'web-notifications', true);
            return window.$coreNotifications.toggleMessagingBox(event, 'top-personal-stats');
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

                    helpEl.classList.remove('global-helper-panel-text');
                    helpEl.classList.add('global-helper-panel-text-over');
                }
            });

            $dom.on(container, 'mouseout', function () {
                if (window.origHelperText !== undefined) {
                    $dom.html(helpEl, window.origHelperText);
                    $dom.fadeIn(helpEl);

                    helpEl.classList.remove('global-helper-panel-text-over');
                    helpEl.classList.add('global-helper-panel-text');
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

    $cms.templates.internalisedAjaxScreen = function internalisedAjaxScreen(params, element) {
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
        var wrapperEl = $dom.elArg('#' + params.wrapperId),
            blockCallUrl = params.blockCallUrl,
            infiniteScrollCallUrl = params.infiniteScrollCallUrl,
            infiniteScrollFunc;

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
        var onmousedownCallFunctions = params.onmousedownCallFunctions;

        if (onclickCallFunctions != null) {
            $dom.on(btn, 'click', function (e) {
                e.preventDefault();

                onclickCallFunctions.forEach(function (func) {
                    func.push(e);
                });

                $cms.executeJsFunctionCalls(onclickCallFunctions, btn);
            });
        }

        if (onmousedownCallFunctions != null) {
            $dom.on(btn, 'mousedown', function (e) {
                e.preventDefault();

                onmousedownCallFunctions.forEach(function (func) {
                    func.push(e);
                });

                $cms.executeJsFunctionCalls(onmousedownCallFunctions, btn);
            });
        }
    };

    $cms.functions.spamWarning = function (e) {
        if (e.which == 2/*middle button*/) {
            this.href += '&spam=1';
        }
    }

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
        if (document.getElementById('search-content')) {
            document.getElementById('search-content').value = strVal(params.rawSearchString);
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
        var els = document.getElementById('main-form').elements[parameter];
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
        var massDeleteForm = $dom.$id('mass-select-form--' + set);
        if (!massDeleteForm) {
            massDeleteForm = $dom.$id('mass-select-button').form;
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

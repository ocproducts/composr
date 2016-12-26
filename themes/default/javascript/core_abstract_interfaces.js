(function ($cms) {

    $cms.templates.memberTooltip = function (params, container) {
        var submitter = strVal(params.submitter);

        $cms.dom.on(container, 'mouseover', '.js-mouseover-activate-member-tooltip', function (e, el) {
            el.cancelled = false;
            load_snippet('member_tooltip&member_id=' + submitter, null, function (result) {
                if (!el.cancelled) {
                    activate_tooltip(el, e, result.responseText, 'auto', null, null, false, true);
                }
            });
        });

        $cms.dom.on(container, 'mouseout', '.js-mouseout-deactivate-member-tooltip', function (e, el) {
            deactivate_tooltip(el);
            el.cancelled = true;
        });
    };

    $cms.templates.resultsLauncherContinue = function (params) {
        var link = this,
            max = params.max,
            urlStub = params.urlStub,
            numPages = params.numPages,
            message = $cms.format('{!javascript:ENTER_PAGE_NUMBER;^}', numPages);

        $cms.dom.on(link, 'click', function () {
            window.fauxmodal_prompt(message, numPages, function (res) {
                if (!res) {
                    return;
                }

                res = parseInt(res);
                if ((res >= 1) && (res <= numPages)) {
                    $cms.navigate(urlStub + (urlStub.includes('?') ? '&' : '?') + 'start=' + (max * (res - 1)));
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

        $cms.dom.on(container, 'click', function (e) {
            var clickedLink = $cms.dom.closest(e.target, 'a', container);

            if (!clickedLink) {
                $cms.navigate(url, target);
                return;
            }

            if (autoAdd) {
                e.preventDefault();
                window.fauxmodal_confirm('{!KEEP_ADDING_QUESTION;^}', function (answer) {
                    var append = '';
                    if (answer) {
                        append += url.includes('?') ? '&' : '?';
                        append += autoAdd + '=1';
                    }
                    $cms.navigate(url + append, target);
                });
                return;
            }

            if (warning && clickedLink.classList.contains('js-click-confirm-warning')) {
                e.preventDefault();
                window.fauxmodal_confirm(warning, function (answer) {
                    if (answer) {
                        $cms.navigate(url, target);
                    }
                });
            }
        });

        var docEl = document.getElementById('doc_' + rand),
            helpEl = document.getElementById('help');

        if (docEl && helpEl) {
            /* Do-next document tooltips */
            $cms.dom.on(container, 'mouseover', function () {
                if ($cms.dom.html(docEl) !== '') {
                    window.orig_helper_text = $cms.dom.html(helpEl);
                    $cms.dom.html(helpEl, $cms.dom.html(docEl));
                    clear_transition_and_set_opacity(helpEl, 0.0);
                    fade_transition(helpEl, 100, 30, 4);

                    helpEl.classList.remove('global_helper_panel_text');
                    helpEl.classList.add('global_helper_panel_text_over');
                }
            });

            $cms.dom.on(container, 'mouseout', function () {
                if (window.orig_helper_text !== undefined) {
                    $cms.dom.html(helpEl, window.orig_helper_text);
                    clear_transition_and_set_opacity(helpEl, 0.0);
                    fade_transition(helpEl, 100, 30, 4);

                    helpEl.classList.remove('global_helper_panel_text_over');
                    helpEl.classList.add('global_helper_panel_text');
                }
            });
        }


        if (autoAdd) {
            var links = $cms.dom.$$(container, 'a');

            links.forEach(function (link) {
                link.onclick = function (event) {
                    event.preventDefault();
                    cancel_bubbling(event);
                    window.fauxmodal_confirm(
                        '{!KEEP_ADDING_QUESTION;^}',
                        function (test) {
                            if (test) {
                                link.href += link.href.includes('?') ? '&' : '?';
                                link.href += autoAdd + '=1';
                            }

                            click_link(link);
                        }
                    );
                    return false;
                };
            });
        }
    };

    $cms.templates.internalizedAjaxScreen = function internalizedAjaxScreen(params) {
        var element = this;

        internalise_ajax_block_wrapper_links(params.url, element, ['.*'], {}, false, true);

        if (params.changeDetectionUrl && (Number(params.refreshTime) > 0)) {
            window.detect_interval = window.setInterval(function () {
                detectChange(params.changeDetectionUrl, params.refreshIfChanged, function () {
                    if ((!document.getElementById('post')) || (document.getElementById('post').value === '')) {
                        var _detectedChange = detectedChange;
                        call_block(params.url, '', element, false, _detectedChange, true, null, true);
                    }
                });
            }, params.refreshTime * 1000);
        }
    };

    $cms.templates.ajaxPagination = function ajaxPagination(params) {
        var wrapperEl = $cms.dom.id(params.wrapperId),
            blockCallUrl = params.blockCallUrl,
            infiniteScrollCallUrl = params.infiniteScrollCallUrl,
            infiniteScrollFunc;

        internalise_ajax_block_wrapper_links(blockCallUrl, wrapperEl, ['[^_]*_start', '[^_]*_max'], {});

        if (infiniteScrollCallUrl) {
            infiniteScrollFunc = internalise_infinite_scrolling.bind(undefined, infiniteScrollCallUrl, wrapperEl);

            $cms.dom.on(window, {
                scroll: infiniteScrollFunc,
                touchmove: infiniteScrollFunc,
                keydown: infinite_scrolling_block,
                mousedown: infinite_scrolling_block_hold,
                mousemove: function () {
                    // mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
                    infinite_scrolling_block_unhold(infiniteScrollFunc);
                }
            });

            infiniteScrollFunc();
        }
    };

    $cms.templates.confirmScreen = function confirmScreen(params) {
        if (params.javascript != null) {
            eval.call(window, params.javascript);
        }
    };

    $cms.templates.warnScreen = function warnScreen() {
        if ((window.trigger_resize != null) && (window.top !== window)) {
            trigger_resize();
        }
    };

    $cms.templates.fatalScreen = function fatalScreen() {
        if ((window.trigger_resize != null) && (window.top !== window)) {
            trigger_resize();
        }
    };

    $cms.templates.columnedTableScreen = function columnedTableScreen(params) {
        params = params || {};

        if (params.javascript != null) {
            eval.call(window, params.javascript);
        }
    };

    $cms.templates.questionUiButtons = function questionUiButtons() {
        var container = this;

        $cms.dom.on(container, 'click', '.js-click-close-window-with-val', function (e, clicked) {
            window.returnValue = clicked.dataset.tpReturnValue;

            if (window.faux_close !== undefined) {
                window.faux_close();
            } else {
                try {
                    window.get_main_cms_window().focus();
                } catch (ignore) {}

                window.close();
            }
        });
    };

    function detectChange(change_detection_url, refresh_if_changed, callback) {
        do_ajax_request(change_detection_url, function (result) {
            var response = result.responseText;
            if (response == '1') {
                window.clearInterval(window.detect_interval);

                $cms.log('detectChange(): Change detected');

                callback();
            }
        }, 'refresh_if_changed=' + encodeURIComponent(refresh_if_changed));
    }

    function detectedChange() {
        $cms.log('detectedChange(): Change notification running');

        try {
            window.focus();
        } catch (e) {
        }

        if (window.soundManager !== undefined) {
            var sound_url = 'data/sounds/message_received.mp3',
                base_url = ((sound_url.indexOf('data_custom') === -1) && (sound_url.indexOf('uploads/') === -1)) ? '{$BASE_URL_NOHTTP;}' : '{$CUSTOM_BASE_URL_NOHTTP;}',
                sound_object = window.soundManager.createSound({ url: base_url + '/' + sound_url });

            if (sound_object) {
                sound_object.play();
            }
        }
    }

}(window.$cms));

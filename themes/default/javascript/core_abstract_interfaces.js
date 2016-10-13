(function ($cms) {

    $cms.templates.resultsLauncherContinue = function (opts) {
        var link = this,
            max = opts.max,
            urlStub = opts.urlStub,
            numPages = opts.numPages,
            message = $cms.str('{!javascript:ENTER_PAGE_NUMBER;}', numPages);

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

    $cms.templates.doNextItem = function (opts) {
        var container = this,
            rand = opts.randDoNextItem,
            url = opts.url,
            target = opts.target,
            warning = opts.warning,
            autoAdd = opts.autoAdd;

        $cms.dom.on(container, 'click', function (e) {
            var clickedLink = $cms.dom.closest(e.target, 'a', container);

            if (!clickedLink) {
                $cms.navigate(url, target);
                return;
            }

            if (autoAdd) {
                e.preventDefault();
                window.fauxmodal_confirm('{!KEEP_ADDING_QUESTION;}', function (answer) {
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
                        '{!KEEP_ADDING_QUESTION;}',
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

    $cms.extend($cms.templates, {
        internalizedAjaxScreen: function (options) {
            var element = this;

            internalise_ajax_block_wrapper_links(options.url, element, ['.*'], { }, false, true);

            if ((typeof options.changeDetectionUrl === 'string') && (options.changeDetectionUrl !== '') && (Number(options.refreshTime) > 0)) {
                window.detect_interval = window.setInterval(function () {
                    detectChange(options.changeDetectionUrl, options.refreshIfChanged, function () {
                        if ((!document.getElementById('post')) || (document.getElementById('post').value === '')) {
                            call_block(options.url, '', element, false, null, true, null, true);
                        }
                    });
                }, options.refreshTime * 1000);
            }
        },

        ajaxPagination: function (options) {
            var wrapperEl = $cms.dom.id(options.wrapperId),
                blockCallUrl = options.blockCallUrl,
                infiniteScrollCallUrl = options.infiniteScrollCallUrl,
                infiniteScrollFunc;

            internalise_ajax_block_wrapper_links(blockCallUrl, wrapperEl, ['[^_]*_start', '[^_]*_max'], {});

            if (infiniteScrollCallUrl) {
                infiniteScrollFunc = internalise_infinite_scrolling.bind(undefined, infiniteScrollCallUrl, wrapperEl);

                $cms.dom.on(window, {
                    scroll:  infiniteScrollFunc,
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
        },

        confirmScreen: function confirmScreen(options) {
            options = options || {};

            if (options.javascript !== undefined) {
                eval.call(window, options.javascript);
            }
        },

        warnScreen: function warnScreen() {
            if ((window.trigger_resize !== undefined) && (window.top !== window)) {
                trigger_resize();
            }
        },

        fatalScreen: function fatalScreen() {
            if ((window.trigger_resize !== undefined) && (window.top !== window)) {
                trigger_resize();
            }
        },

        columnedTableScreen: function columnedTableScreen(options) {
            options = options || {};

            if (options.javascript !== undefined) {
                eval.call(window, options.javascript);
            }
        },

        questionUiButtons: function () {
            var container = this;

            $cms.dom.on(container, 'click', 'js-click-close-window-with-val', function (e, clicked) {
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
        }
    });

    function infiniteScrolling (callUrl, wrapperEl) {
        internalise_infinite_scrolling(callUrl, wrapperEl);
    }

    function detectChange(change_detection_url, refresh_if_changed, callback) {
        do_ajax_request(change_detection_url, function (result) {
            var response = result.responseText;
            if (response == '1') {
                try {
                    window.getAttention();
                } catch (e) {
                }

                try {
                    window.focus();
                } catch (e) {
                }

                if (window.soundManager !== undefined) {
                    window.soundManager.play('message_received');
                }

                window.clearInterval(window.detect_interval);

                callback();
            }
        }, 'refresh_if_changed=' + encodeURIComponent(refresh_if_changed));
    }

}(window.$cms));

(function (Composr) {

    Composr.behaviors.coreAbstractInterfaces = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_abstract_interfaces');
            }
        }
    };

    Composr.templates.resultsLauncherContinue = function (opts) {
        var link = this,
            max = opts.max,
            urlStub = opts.urlStub,
            numPages = opts.numPages,
            message = Composr.str('{!javascript:ENTER_PAGE_NUMBER;}', numPages);

        Composr.dom.on(link, 'click', function () {
            window.fauxmodal_prompt(message, numPages, function (res) {
                if (!res) {
                    return;
                }

                res = parseInt(res);
                if ((res >= 1) && (res <= numPages)) {
                    Composr.navigate(urlStub + (urlStub.includes('?') ? '&' : '?') + 'start=' + (max * (res - 1)));
                }
            }, '{!JUMP_TO_PAGE;^}');
        });
    };

    Composr.templates.doNextItem = function (opts) {
        var container = this,
            rand = opts.randDoNextItem,
            url = opts.url,
            target = opts.target,
            warning = opts.warning,
            autoAdd = opts.autoAdd;

        Composr.dom.on(container, 'click', function (e) {
            var clickedLink = Composr.dom.closest(e.target, 'a', container);

            if (!clickedLink) {
                Composr.navigate(url, target);
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
                    Composr.navigate(url + append, target);
                });
                return;
            }

            if (warning && clickedLink.classList.contains('js-click-confirm-warning')) {
                e.preventDefault();
                window.fauxmodal_confirm(warning, function (answer) {
                    if (answer) {
                        Composr.navigate(url, target);
                    }
                });
            }
        });

        var docEl = document.getElementById('doc_' + rand),
            helpEl = document.getElementById('help');

        if (docEl && helpEl) {
            /* Do-next document tooltips */
            Composr.dom.on(container, 'mouseover', function () {
                if (Composr.dom.html(docEl) !== '') {
                    window.orig_helper_text = Composr.dom.html(helpEl);
                    Composr.dom.html(helpEl, Composr.dom.html(docEl));
                    clear_transition_and_set_opacity(helpEl, 0.0);
                    fade_transition(helpEl, 100, 30, 4);

                    helpEl.classList.remove('global_helper_panel_text');
                    helpEl.classList.add('global_helper_panel_text_over');
                }
            });

            Composr.dom.on(container, 'mouseout', function () {
                if (window.orig_helper_text !== undefined) {
                    Composr.dom.html(helpEl, window.orig_helper_text);
                    clear_transition_and_set_opacity(helpEl, 0.0);
                    fade_transition(helpEl, 100, 30, 4);

                    helpEl.classList.remove('global_helper_panel_text_over');
                    helpEl.classList.add('global_helper_panel_text');
                }
            });
        }


        if (autoAdd) {
            var links = Composr.dom.$$(container, 'a');

            for (var i = 0; i < links.length; i++) {
                links[i].onclick = function (_this) {
                    return function (event) {
                        event.preventDefault();
                        cancel_bubbling(event);
                        window.fauxmodal_confirm(
                            '{!KEEP_ADDING_QUESTION;}',
                            function (test) {
                                if (test) {
                                    _this.href += (_this.href.indexOf('?') != -1) ? '&' : '?';
                                    _this.href += autoAdd + '=1';
                                }
                                click_link(_this);
                            }
                        );
                        return false;
                    };
                }(links[i]);
            }
        }
    };

    Composr.templates.coreAbstractInterfaces = {
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
            var wrapperEl = Composr.dom.id(options.wrapperId),
                blockCallUrl = options.blockCallUrl,
                infiniteScrollCallUrl = options.infiniteScrollCallUrl,
                infiniteScrollFunc;

            internalise_ajax_block_wrapper_links(blockCallUrl, wrapperEl, ['[^_]*_start', '[^_]*_max'], {});

            if (infiniteScrollCallUrl) {
                infiniteScrollFunc = internalise_infinite_scrolling.bind(undefined, infiniteScrollCallUrl, wrapperEl);

                Composr.dom.on(window, {
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
            if ((typeof window.trigger_resize !== 'undefined') && (window.top !== window)) {
                trigger_resize();
            }
        },

        fatalScreen: function fatalScreen() {
            if ((typeof window.trigger_resize !== 'undefined') && (window.top !== window)) {
                trigger_resize();
            }
        },

        columnedTableScreen: function columnedTableScreen(options) {
            options = options || {};

            if (options.javascript !== undefined) {
                eval.call(window, options.javascript);
            }
        },

        questionUiButtons: function (options) {
            var container = this;

            Composr.dom.on(container, 'click', 'js-click-close-window-with-val', function (e, clicked) {
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
    };

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

                if (typeof window.soundManager !== 'undefined') {
                    window.soundManager.play('message_received');
                }

                window.clearInterval(window.detect_interval);

                callback();
            }
        }, 'refresh_if_changed=' + window.encodeURIComponent(refresh_if_changed));
    }

}(window.Composr));

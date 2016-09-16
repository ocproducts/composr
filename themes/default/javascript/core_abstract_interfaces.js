(function (Composr) {

    Composr.behaviors.coreAbstractInterfaces = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_abstract_interfaces');
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

                Composr.dom.on(window, 'scroll touchmove', infiniteScrollFunc);
                Composr.dom.on(window, 'keydown', infinite_scrolling_block);
                Composr.dom.on(window, 'mousedown', infinite_scrolling_block_hold);
                Composr.dom.on(window, 'mousemove', function () {
                    // mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
                    infinite_scrolling_block_unhold(infiniteScrollFunc);
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

            if (options.javacsript !== undefined) {
                eval.call(window, options.javascript);
            }
        },

        doNextItem: function doNextItem(options) {
            if (!options.autoAdd) {
                return;
            }

            var as = document.getElementById('do_next_item_' + options.randDoNextItem).getElementsByTagName('a');

            for (var i = 0; i < as.length; i++) {
                as[i].onclick = function (_this) {
                    return function (event) {
                        if (typeof event.preventDefault !== 'undefined') event.preventDefault();
                        cancel_bubbling(event);
                        window.fauxmodal_confirm(
                            '{!KEEP_ADDING_QUESTION;^}',
                            function (test) {
                                if (test) {
                                    _this.href += (_this.href.indexOf('?') != -1) ? '&' : '?';
                                    _this.href += options.autoAdd + '=1';
                                }
                                click_link(_this);
                            }
                        );
                        return false;
                    };
                }(as[i]);
            }
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

}(window.Composr, window._));

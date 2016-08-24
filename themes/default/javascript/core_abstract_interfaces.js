(function ($, Composr) {

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

        ajaxPagination: function (options, urlStem, extraQs, isInfiniteScrollEnabled) {
            var wrapperEl = document.getElementById(options.wrapperId),
                infiniteScrollConfigured = Number(isInfiniteScrollEnabled) === 1,
                allowInfiniteScroll = Number(options.allowInfiniteScroll) === 1,
                keepInfiniteScroll = Composr.queryString.has('keep_infinite_scroll') ?  Number(Composr.queryString.get('keep_infinite_scroll')) !== 0 : true;

            internalise_ajax_block_wrapper_links(urlStem + extraQs, wrapperEl,['[^_]*_start','[^_]*_max'], {});

            // Infinite scrolling hides the pagination when it comes into view, and auto-loads the next link, appending below the current results
            if (isInfiniteScrollEnabled && allowInfiniteScroll && keepInfiniteScroll) {
                function infinite_scrolling() {
                    internalise_infinite_scrolling(urlStem, wrapperEl);
                }

                window.addEventListener('scroll', infinite_scrolling);
                window.addEventListener('touchmove', infinite_scrolling);
                window.addEventListener('keydown', infinite_scrolling_block);
                window.addEventListener('mousedown', infinite_scrolling_block_hold);
                window.addEventListener('mousemove', function () {
                    infinite_scrolling_block_unhold(infinite_scrolling);
                });
                infinite_scrolling();
            }
        },

        warnScreen: function warnScreen(options) {
            if ((typeof window.trigger_resize !== 'undefined') && (window.top != window)) {
                trigger_resize();
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
                            '{!KEEP_ADDING_QUESTION;}',
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

    Composr.behaviors.coreAbstractInterfaces = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_abstract_interfaces');
            }
        }
    };

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

})(window.jQuery || window.Zepto, Composr);

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

        warnScreen: function warnScreen(options) {
            if ((typeof window.trigger_resize !== 'undefined') && (window.top != window)) {
                trigger_resize();
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

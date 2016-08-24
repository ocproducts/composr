(function ($, Composr) {
    Composr.templates.coreAbstractComponents = {
        handleConflictResolution: function handleConflictResolution() {
            if (!Composr.isEmptyOrZero(options.pingUrl)) {
                do_ajax_request(options.pingUrl);

                window.setInterval(function () {
                    do_ajax_request(options.pingUrl, Composr.noop);
                }, 12000);
            }
        }
    };

    Composr.behaviors.coreAbstractComponents = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_abstract_components');
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);
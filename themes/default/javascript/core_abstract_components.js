(function ($, Composr) {
    Composr.behaviors.coreAbstractComponents = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_abstract_components');
            }
        }
    };

    Composr.templates.coreAbstractComponents = {
        handleConflictResolution: function handleConflictResolution(options) {
            options = options || {};

            if (Composr.is(options.pingUrl)) {
                do_ajax_request(options.pingUrl);

                window.setInterval(function () {
                    do_ajax_request(options.pingUrl, function () {});
                }, 12000);
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);
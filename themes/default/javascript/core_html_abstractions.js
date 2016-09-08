(function (Composr) {
    'use strict';

    Composr.behaviors.coreHtmlAbstractions = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_html_abstractions');
            }
        }
    };

    Composr.templates.coreHtmlAbstractions = {
        standaloneHtmlWrap: function (options) {
            if (window.parent) {
                Composr.load.then(function () {
                    document.body.className += ' frame';

                    try {
                        if (typeof window.trigger_resize != 'undefined') trigger_resize();
                    }
                    catch (e) {
                    }

                    window.setTimeout(function () { // Needed for IE10
                        try {
                            if (typeof window.trigger_resize != 'undefined') trigger_resize();
                        }
                        catch (e) {
                        }
                    }, 1000);
                });
            }

            if (Composr.is(options.isPreview)) {
                disable_preview_scripts();
            }
        },

        jsRefresh: function jsRefresh(options) {
            if (window.location.hash.indexOf('redirected_once') === -1) {
                window.location.hash = 'redirected_once';
                document.getElementById(options.formName).submit();
            } else {
                window.history.go(-2); // We've used back button, don't redirect forward again
            }
        }
    };
}(window.Composr));
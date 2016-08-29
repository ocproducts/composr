(function ($, Composr) {
    'use strict';

    Composr.behaviors.corePrimaryLayout = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_primary_layout');
            }
        }
    };

    Composr.templates.corePrimaryLayout = {
        globalHtmlWrap: function () {
            script_load_stuff();

            if (Composr.queryString.has('wide_print')) {
                try { window.print(); } catch (ignore) {}
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);
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
            if (document.getElementById('global_messages_2')) {
                merge_global_messages();
            }

            if (Composr.queryString.has('wide_print')) {
                try { window.print(); } catch (ignore) {}
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);
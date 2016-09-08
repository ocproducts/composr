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
                var m1 = document.getElementById('global_messages');
                if (!m1) return;
                var m2 = document.getElementById('global_messages_2');
                Composr.dom.appendHtml(m1, Composr.dom.html(m2));
                m2.parentNode.removeChild(m2);
            }

            if (Composr.queryString.has('wide_print')) {
                try { window.print(); } catch (ignore) {}
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);
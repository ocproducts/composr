(function ($, Composr) {

    Composr.templates.corePrimaryLayout = {
        globalHtmlWrap: function () {
            script_load_stuff();

            if (query_string_param('wide_print')) {
                try { window.print(); } catch (e) {}
            }
        }
    };

    Composr.behaviors.corePrimaryLayout = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_primary_layout');
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);
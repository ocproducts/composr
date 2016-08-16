(function ($, Composr) {

    // GLOBAL_HTML_WRAP.tpl
    var globalHtmlWrap = _.once(function () {
        script_load_stuff();

        if (query_string_param('wide_print')) {
            try { window.print(); } catch (e) {}
        }
    });

    Composr.behaviors.corePrimaryLayout = {
        attach: function (context) {
            globalHtmlWrap();
        }
    };
})(window.jQuery || window.Zepto, Composr);
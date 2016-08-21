(function ($, Composr) {
    Composr.templates.awards = {};

    Composr.behaviors.awards = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'awards');
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);

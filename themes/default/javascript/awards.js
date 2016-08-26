(function ($, Composr) {
    Composr.behaviors.awards = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'awards');
            }
        }
    };

    Composr.templates.awards = {};
})(window.jQuery || window.Zepto, window.Composr);

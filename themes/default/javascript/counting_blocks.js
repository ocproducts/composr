(function ($, Composr) {
    Composr.templates.countingBlocks = {
        blockMainCountdown: function (options) {
            var el = this;
            window.setInterval(function() {
                countdown(el, ((options.positive === '1') ? -1 : +1) * options.distanceForPrecision , options.tailing);
            }, options.millisecondsForPrecision);
        }
    };

    Composr.behaviors.countingBlocks = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'counting_blocks');
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);

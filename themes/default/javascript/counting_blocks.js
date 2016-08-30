(function ($, Composr) {
    'use strict';

    Composr.behaviors.countingBlocks = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'counting_blocks');
            }
        }
    };

    Composr.templates.countingBlocks = {
        blockMainCount: function (options) {
            if (options.update !== undefined) {
                load_snippet('count', 'name=' + options.update);
            }
        },

        blockMainCountdown: function (options) {
            var el = this;
            window.setInterval(function() {
                countdown(el, ((options.positive === '1') ? -1 : +1) * options.distanceForPrecision, options.tailing);
            }, options.millisecondsForPrecision);
        }
    };
})(window.jQuery || window.Zepto, Composr);

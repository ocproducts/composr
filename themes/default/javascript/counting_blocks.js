(function ($cms) {
    'use strict';

    $cms.extend($cms.templates, {
        blockMainCount: function (params) {
            if (params.update !== undefined) {
                load_snippet('count', 'name=' + params.update);
            }
        },

        blockMainCountdown: function (params) {
            var el = this;
            window.setInterval(function() {
                countdown(el, (params.positive ? -1 : +1) * params.distanceForPrecision, params.tailing);
            }, params.millisecondsForPrecision);
        }
    });
}(window.$cms));

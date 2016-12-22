(function ($cms) {
    'use strict';

    $cms.templates.blockMainCount = function (params) {
        if (params.update !== undefined) {
            load_snippet('count', 'name=' + params.update);
        }
    };

    $cms.templates.blockMainCountdown = function (params, el) {
        window.setInterval(function() {
            countdown(el, (params.positive ? -1 : +1) * params.distanceForPrecision, params.tailing);
        }, params.millisecondsForPrecision);
    };
}(window.$cms));

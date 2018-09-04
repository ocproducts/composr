(function ($cms) {
    'use strict';

    $cms.templates.blockMainCount = function (params) {
        if (params.update !== undefined) {
            $cms.loadSnippet('count', 'name=' + params.update, true);
        }
    };

    $cms.templates.blockMainCountdown = function (params, el) {
        setInterval(function () {
            window.countdown(el, (params.positive ? -1 : +1) * params.distanceForPrecision, params.tailing);
        }, params.millisecondsForPrecision);
    };
}(window.$cms));

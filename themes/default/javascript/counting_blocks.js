(function ($cms) {
    'use strict';

    $cms.templates.blockMainCount = function (params) {
        if (params.update !== undefined) {
            $cms.loadSnippet('count', 'name=' + params.update);
        }
    };

    $cms.templates.blockMainCountdown = function (params, el) {
        window.setInterval(function() {
            countdown(el, (params.positive ? -1 : +1) * params.distanceForPrecision, params.tailing);
        }, params.millisecondsForPrecision);
    };
}(window.$cms));

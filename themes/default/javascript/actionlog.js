(function ($cms) {
    'use strict';

    $cms.templates.revisionsDiffIcon = function revisionsDiffIcon(params, container) {
        $cms.dom.on(container, 'mousemove', function (e) {
            reposition_tooltip(container, e, true);
        });
    };
}(window.$cms));
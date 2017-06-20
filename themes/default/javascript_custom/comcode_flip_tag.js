(function ($cms) {
    'use strict';

    $cms.templates.comcodeFlip = function comcodeFlip(params, container) {
        $cms.dom.on(container, 'click', function () {
            var $container = window.jQuery(container);

            if (container.flipped == null) {
                container.flipped = false;
            }
            if (container.flipped) {
                $container.revertFlip();
            } else {
                $container.flip({
                    color: params.finalColor.includes('#') ? params.finalColor : ('#' + params.finalColor),
                    speed: params.speed,
                    direction: 'tb',
                    content: params.content
                })
            }
            container.flipped = !container.flipped;
        });
    };
}(window.$cms));

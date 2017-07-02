/* TODO: Salman, merge this into global.js (it is a common include and not worth its own request for sake of modularisation) */

(function ($cms) {
    'use strict';

    $cms.templates.blockMainScreenActions = function blockMainScreenActions(params, container) {
        var easySelfUrl = strVal(params.easySelfUrl);

        $cms.dom.on(container, 'click', '.js-click-action-print-screen', function (e, link) {
            $cms.gaTrack(null,'{!recommend:PRINT_THIS_SCREEN;}');
        });

        $cms.dom.on(container, 'click', '.js-click-action-add-to-facebook', function (e, link) {
            $cms.gaTrack(null,'social__facebook');
        });

        $cms.dom.on(container, 'click', '.js-click-action-add-to-twitter', function (e, link) {
            link.setAttribute('href', 'https://twitter.com/share?count=horizontal&counturl=' + easySelfUrl + '&original_referer=' + easySelfUrl + '&text=' + encodeURIComponent(document.title) + '&url=' + easySelfUrl);

            $cms.gaTrack(null,'social__twitter');
        });

        $cms.dom.on(container, 'click', '.js-click-action-add-to-stumbleupon', function (e, link) {
            $cms.gaTrack(null,'social__stumbleupon');
        });

        $cms.dom.on(container, 'click', '.js-click-action-add-to-digg', function (e, link) {
            $cms.gaTrack(null,'social__digg');
        });
    };
}(window.$cms));

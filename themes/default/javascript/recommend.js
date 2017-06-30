/* TODO: Salman, merge this into global.js (it is a common include and not worth its own request for sake of modularisation) */

(function ($cms) {
    'use strict';

    $cms.templates.blockMainScreenActions = function blockMainScreenActions(params, container) {
        var easySelfUrl = strVal(params.easySelfUrl);

        $cms.dom.on(container, 'click', '.js-click-action-add-to-twitter', function (e, link) {
            link.setAttribute('href', 'https://twitter.com/share?count=horizontal&counturl=' + easySelfUrl + '&original_referer=' + easySelfUrl + '&text=' + encodeURIComponent(document.title) + '&url=' + easySelfUrl);
        });
    };
}(window.$cms));
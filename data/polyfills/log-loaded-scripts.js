(function ($cms) {
    'use strict';

    $cms.loadedScripts = [];

    document.addEventListener('load', function (event) {
        if (event.target && (event.target.localName === 'script') ) {
            $cms.loadedScripts.push(event.target);
        }
    }, /*useCapture*/true);

}(window.$cms || (window.$cms = {})));

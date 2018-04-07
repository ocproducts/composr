/*{+START,INCLUDE,POLYFILL_FETCH,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,POLYFILL_GENERAL,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,POLYFILL_KEYBOARDEVENT_KEY,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,POLYFILL_URL,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,POLYFILL_WEB_ANIMATIONS,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,JSON5,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,UTIL,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,DOM,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,CMS,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,CMS_FORM,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,CMS_UI,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,CMS_TEMPLATES,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,CMS_VIEWS,.js,javascript}*//*{+END}*/

/*{+START,INCLUDE,CMS_BEHAVIORS,.js,javascript}*//*{+END}*/

(function ($cms, $util, $dom) {
    'use strict';

    // Start everything
    $dom.ready.then(function () {
        // Allow form submissions by removing this listener attached early in dom_init.js
        window.removeEventListener('submit', $dom.preventFormSubmissionUntilDomReadyListener, /*useCapture*/true);
        delete $dom.preventFormSubmissionUntilDomReadyListener;

        $cms.attachBehaviors(document);
    });
}(window.$cms, window.$util, window.$dom));

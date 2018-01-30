/*{+START,INCLUDE,UTIL,.js,javascript}{+END}*/

/*{+START,INCLUDE,DOM,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS_FORM,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS_UI,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS_TEMPLATES,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS_VIEWS,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS_BEHAVIORS,.js,javascript}{+END}*/

(function ($cms, $util, $dom) {
    'use strict';

    // Start everything
    $dom.ready.then(function () {
        $cms.attachBehaviors(document);
    });
}(window.$cms, window.$util, window.$dom));

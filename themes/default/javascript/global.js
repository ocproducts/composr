/*{+START,INCLUDE,UTIL,.js,javascript}{+END}*/

/*{+START,INCLUDE,DOM,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS,.js,javascript}{+END}*/
 
/*{+START,INCLUDE,CMS.UI,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS.TEMPLATES,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS.VIEWS,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS.BEHAVIORS,.js,javascript}{+END}*/

(function ($cms, $util, $dom) {
    'use strict';
    
    // Start everything
    $dom.ready.then(function () {
        $cms.attachBehaviors(document);
    });
}(window.$cms, window.$util, window.$dom));
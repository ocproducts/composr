(function ($cms) {
    'use strict';
    
    /**
     * Required for $cms.requireCss and $cms.requireJavascript() to work properly as DOM does not currently provide any way to check if a particular element has been already loaded
     * @memberOf $cms
     * @type { WeakMap }
     */
    $cms.elementsLoaded = new WeakMap();
    
    document.addEventListener('load', listener, /*useCapture*/true);
    document.addEventListener('error', listener, /*useCapture*/true);
    
    function listener(event) {
        var loadedEl = event.target, 
            hasLoaded = (event.type === 'load');

        if (!loadedEl) {
            return;
        }
        
        $cms.elementsLoaded.set(loadedEl, hasLoaded);
    }
    
    window.addEventListener('click', function (e) {
        if (e.target && (e.target.localName === 'a') && (e.target.getAttribute('href') === '#!')) {
            //e.preventDefault();
        }
    }, /*useCapture*/true);

    window.addEventListener('submit', function (e) {
        if (e.target && (e.target.localName === 'form') && (e.target.getAttribute('action') === '#!')) {
            //e.preventDefault();
        }
    }, /*useCapture*/true);

}(window.$cms || (window.$cms = {})));

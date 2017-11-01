(function ($cms) {
    'use strict';

    // Workaround for bug, document.readyState == 'interactive' before [defer]'d <script>s are loaded :(
    // https://github.com/jquery/jquery/issues/3271
    /**
     * @memberOf $cms
     * @type {boolean}
     */
    $cms.isDOMContentLoaded = Boolean($cms.isDOMContentLoaded);

    document.addEventListener('DOMContentLoaded', function() {
        $cms.isDOMContentLoaded = true;
    });

    /* Required for $cms.requireCss and $cms.requireJavascript() to work properly as DOM does not currently provide any way to check if a particular stylesheet/script has been already loaded */
    /**
     * @memberOf $cms
     * @type { WeakMap }
     */
    $cms.styleSheetsLoaded = new WeakMap();

    /**
     * @memberOf $cms
     * @type {Array}
     */
    $cms.styleSheetsLoadedListeners = [];

    /**
     * @memberOf $cms
     * @type { WeakMap }
     */
    $cms.scriptsLoaded = new WeakMap();

    /**
     * @memberOf $cms
     * @type {Array}
     */
    $cms.scriptsLoadedListeners = [];
    
    document.addEventListener('load', listener, /*useCapture*/true);
    document.addEventListener('error', listener, /*useCapture*/true);
    
    function listener(event) {
        var loadedEl = event.target;

        if (!loadedEl) {
            return;
        }

        if ((loadedEl.localName === 'link') && (loadedEl.rel === 'stylesheet')) {
            $cms.styleSheetsLoaded.set(loadedEl, true);
            $cms.styleSheetsLoadedListeners.forEach(function (listener) {
                if (typeof listener === 'function') {
                    listener.call(loadedEl, event);
                }
            });
        } else if (loadedEl.localName === 'script') {
            $cms.scriptsLoaded.set(loadedEl, true);
            $cms.scriptsLoadedListeners.forEach(function (listener) {
                if (typeof listener === 'function') {
                    listener.call(loadedEl, event);
                }
            });
        }
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

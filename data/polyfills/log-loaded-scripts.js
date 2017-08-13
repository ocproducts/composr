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
     * @type {Array}
     */
    $cms.styleSheetsLoaded = [];

    /**
     * @memberOf $cms
     * @type {Array}
     */
    $cms.styleSheetsLoadedListeners = [];

    /**
     * @memberOf $cms
     * @type {Array}
     */
    $cms.scriptsLoaded = [];

    /**
     * @memberOf $cms
     * @type {Array}
     */
    $cms.scriptsLoadedListeners = [];

    document.addEventListener('load', function (event) {
        var loadedEl = event.target;

        if (!loadedEl) {
            return;
        }

        if ((loadedEl.localName === 'link') && (loadedEl.rel === 'stylesheet')) {
            $cms.styleSheetsLoaded.push(loadedEl);
            $cms.styleSheetsLoadedListeners.forEach(function (listener) {
                if (typeof listener === 'function') {
                    //console.log('Called $cms.styleSheetsLoadedListeners.* function', listener);
                    listener.call(loadedEl, event);
                }
            });
            //console.log('Stylesheet loaded', loadedEl);
        } else if (loadedEl.localName === 'script') {
            $cms.scriptsLoaded.push(loadedEl);
            $cms.scriptsLoadedListeners.forEach(function (listener) {
                if (typeof listener === 'function') {
                    //console.log('Called $cms.scriptsLoadedListeners.* function', listener);
                    listener.call(loadedEl, event);
                }
            });
            //console.log('Script loaded', loadedEl);
        }
    }, /*useCapture*/true);

    document.addEventListener('error', function (event) {
        var loadedEl = event.target;

        if (!loadedEl) {
            return;
        }

        if ((loadedEl.localName === 'link') && (loadedEl.rel === 'stylesheet')) {
            $cms.styleSheetsLoaded.push(loadedEl);
            $cms.styleSheetsLoadedListeners.forEach(function (listener) {
                if (typeof listener === 'function') {
                    //console.log('Called $cms.styleSheetsLoadedListeners.* function', listener);
                    listener.call(loadedEl, event);
                }
            });
            //console.log('Stylesheet error\'d', loadedEl);
        } else if (loadedEl.localName === 'script') {
            $cms.scriptsLoaded.push(loadedEl);
            $cms.scriptsLoadedListeners.forEach(function (listener) {
                if (typeof listener === 'function') {
                    listener.call(loadedEl, event);
                }
            });
            //console.log('Script error\'d', loadedEl);
        }
    }, /*useCapture*/true);
    
    window.addEventListener('click', function (e) {
        if (e.target && (e.target.localName === 'a') && (e.target.getAttribute('href') === '#!')) {
            e.preventDefault();
        }
    }, /*useCapture*/true);

    window.addEventListener('submit', function (e) {
        if (e.target && (e.target.localName === 'form') && (e.target.getAttribute('action') === '#!')) {
            e.preventDefault();
        }
    }, /*useCapture*/true);

}(window.$cms || (window.$cms = {})));

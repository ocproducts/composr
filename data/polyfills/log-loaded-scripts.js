(function ($cms) {
    'use strict';

    // Workaround for bug, document.readyState == 'interactive' before [defer]'d <script>s are loaded :(
    // https://github.com/jquery/jquery/issues/3271
    $cms.isDOMContentLoaded = false;

    document.addEventListener('DOMContentLoaded', function() {
        $cms.isDOMContentLoaded = true;
    });

    // Required for $cms.requireJavascript() to work properly as DOM does not currently provide any way to check if a particular script has been already loaded
    $cms.scriptsLoaded = [];
    $cms.scriptsLoadedListeners = [];

    document.addEventListener('load', function (event) {
        if (event.target && (event.target.localName === 'script') ) {
            $cms.scriptsLoaded.push(event.target);
            $cms.scriptsLoadedListeners.forEach(function (listener) {
                if (typeof listener === 'function') {
                    //console.log('Called $cms.scriptsLoadedListeners.* function', listener);
                    listener.call(event.target, event);
                }
            });
            console.log('Script loaded', event.target);
        }
    }, /*useCapture*/true);

    document.addEventListener('error', function (event) {
        if (event.target && (event.target.localName === 'script') ) {
            $cms.scriptsLoaded.push(event.target);
            $cms.scriptsLoadedListeners.forEach(function (listener) {
                if (typeof listener === 'function') {
                    listener.call(event.target, event);
                }
            });
            console.log('Script error\'d', event.target);
        }
    }, /*useCapture*/true);

}(window.$cms || (window.$cms = {})));

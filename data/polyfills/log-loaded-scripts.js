(function ($cms) {
    'use strict';

    // Workaround for bug, document.readyState == 'interactive' before [defer]'d <script>s are loaded :(
    // https://github.com/jquery/jquery/issues/3271
    $cms.isDOMContentLoaded = false;

    document.addEventListener('DOMContentLoaded', function() {
        $cms.isDOMContentLoaded = true;
    });

    // Required for $cms.requireJavascript() to work properly as DOM does not currently provide any way to check if a particular script has been already loaded
    $cms.loadedScripts = [];
    document.addEventListener('load', function (event) {
        if (event.target && (event.target.localName === 'script') ) {
            $cms.loadedScripts.push(event.target);
        }
    }, /*useCapture*/true);

}(window.$cms || (window.$cms = {})));

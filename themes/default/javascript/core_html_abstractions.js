(function ($cms) {
    'use strict';

    $cms.templates.standaloneHtmlWrap = function (options) {
        if (window.parent) {
            $cms.load.then(function () {
                document.body.classList.add('frame');

                try {
                    trigger_resize();
                } catch (e) {
                }

                window.setTimeout(function () { // Needed for IE10
                    try {
                        trigger_resize();
                    } catch (e) {
                    }
                }, 1000);
            });
        }

        if (options.isPreview) {
            disable_preview_scripts();
        }
    };

    $cms.templates.jsRefresh = function (options){
        if (!window.location.hash.includes('redirected_once')) {
            window.location.hash = 'redirected_once';
            document.getElementById(options.formName).submit();
        } else {
            window.history.go(-2); // We've used back button, don't redirect forward again
        }
    };
}(window.$cms));
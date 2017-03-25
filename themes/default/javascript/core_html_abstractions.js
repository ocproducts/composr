(function ($cms) {
    'use strict';

    $cms.templates.standaloneHtmlWrap = function (params) {
        if (window.parent) {
            $cms.load.then(function () {
                document.body.classList.add('frame');

                try {
                    trigger_resize();
                } catch (e) {}

                window.setTimeout(function () { // Needed for IE10
                    try {
                        trigger_resize();
                    } catch (e) {}
                }, 1000);
            });
        }

        if (params.isPreview) {
            $cms.form.disablePreviewScripts();
        }
    };

    $cms.templates.jsRefresh = function (params){
        if (!window.location.hash.includes('redirected_once')) {
            window.location.hash = 'redirected_once';
            document.getElementById(params.formName).submit();
        } else {
            window.history.go(-2); // We've used back button, don't redirect forward again
        }
    };
}(window.$cms));
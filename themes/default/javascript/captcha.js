(function ($cms) {
    'use strict';

    $cms.functions.captchaCaptchaAjaxCheck = function captchaCaptchaAjaxCheck() {
        var form = document.getElementById('main_form');

        if (!form) {
            form = document.getElementById('posting_form');
        }

        form.addEventListener('submit', function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=captcha_wrong&name=' + encodeURIComponent(form.elements['captcha'].value);
            if (!$cms.form.doAjaxFieldTest(url)) {
                document.getElementById('captcha').src += '&'; // Force it to reload latest captcha
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
        });
    };
}(window.$cms));
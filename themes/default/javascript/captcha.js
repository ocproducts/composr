(function ($cms) {
    'use strict';

    $cms.functions.captchaCaptchaAjaxCheck = function captchaCaptchaAjaxCheck() {
        var form = document.getElementById('main_form'),
            submitBtn = document.getElementById('submit_button');

        if (!form) {
            form = document.getElementById('posting_form');
        }

        form.addEventListener('submit', function submitCheck(e) {
            submitBtn.disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=captcha_wrong&name=' + encodeURIComponent(form.elements['captcha'].value);
            e.preventDefault();
            $cms.form.doAjaxFieldTest(url).then(function (valid) {
                if (valid) {
                    form.removeEventListener('submit', submitCheck);
                    form.submit();
                } else {
                    document.getElementById('captcha').src += '&'; // Force it to reload latest captcha
                    submitBtn.disabled = false;
                }
            });
        });
    };
}(window.$cms));

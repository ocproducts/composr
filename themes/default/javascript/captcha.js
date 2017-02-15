(function ($cms) {
    'use strict';

    $cms.functions.captchaCaptchaAjaxCheck = function captchaCaptchaAjaxCheck() {
        var form = document.getElementById('main_form');

        if (!form) {
            form = document.getElementById('posting_form');
        }

        form.old_submit_b = form.onsubmit;
        form.onsubmit = function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=captcha_wrong&name=' + encodeURIComponent(form.elements['captcha'].value);
            if (!do_ajax_field_test(url)) {
                document.getElementById('captcha').src += '&'; // Force it to reload latest captcha
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
            if (form.old_submit_b) {
                return form.old_submit_b();
            }
            return true;
        };
    };
}(window.$cms));
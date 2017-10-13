(function ($cms) {
    'use strict';
    /* Called from reCAPTCHA's recaptcha/api.js, when it loads. (See generate_captcha() in sources/captcha.php) */
    window.recaptchaLoaded = recaptchaLoaded;
    
    var recaptchaSiteKey = '{$CONFIG_OPTION;^/,recaptcha_site_key}';
    function recaptchaLoaded() {
        var captchaElement = document.getElementById('captcha'),
            form = $cms.dom.closest(captchaElement, 'form');
        captchaElement.executedFully = false;
        var grecaptchaParameters = {
            sitekey: recaptchaSiteKey,
            callback: function() {
                captchaElement.executedFully = true;
                if (form) {
                    $cms.dom.submit(form);
                }
            },
            theme: '{$?,{$THEME_DARK},dark,light}',
            size: 'invisible'
        };
        if (captchaElement.dataset.tabindex != null) {
            grecaptchaParameters.tabindex = captchaElement.dataset.tabindex;
        }
        window.grecaptcha.render('captcha', grecaptchaParameters, false);
    }

    $cms.defineBehaviors(/**@lends $cms.behaviors*/{
        // Implementation for [data-recaptcha-captcha]
        initializeRecaptchaCaptcha: {
            attach: function attach(context) {
                var els = $cms.dom.$$$(context, '[data-recaptcha-captcha]');
                
                if (els.length > 0) {
                    $cms.requireJavascript('https://www.google.com/recaptcha/api.js?render=explicit&onload=recaptchaLoaded&hl=' + $cms.$LANG().toLowerCase());
                }
            }
        }
    });
    
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
                    $cms.dom.submit(form);
                } else {
                    document.getElementById('captcha').src += '&'; // Force it to reload latest captcha
                    submitBtn.disabled = false;
                }
            });
        });
    };
}(window.$cms));

(function ($cms, $util, $dom) {
    'use strict';
    
    var $CONFIG_OPTION_recaptcha_site_key = '{$CONFIG_OPTION;^,recaptcha_site_key}';

    var onLoadCallbackName = 'recaptchaLoaded' + $util.random();
    
    var recaptchaLoadedPromise = new Promise(function (resolve) {
        /* Called from reCAPTCHA's recaptcha/api.js, when it loads. */
        window[onLoadCallbackName] = function () {
            resolve();
            delete window[onLoadCallbackName];
        };
    });
    
    $cms.defineBehaviors(/**@lends $cms.behaviors*/{
        // Implementation for [data-recaptcha-captcha]
        initializeRecaptchaCaptcha: {
            attach: function attach(context) {
                var captchaEls = $util.once($dom.$$$(context, '[data-recaptcha-captcha]'), 'behavior.initializeRecaptchaCaptcha');

                if (captchaEls.length < 1) {
                    return;
                }
                
                $cms.requireJavascript('https://www.google.com/recaptcha/api.js?render=explicit&onload=' + onLoadCallbackName + '&hl=' + $cms.userLang().toLowerCase());
                
                recaptchaLoadedPromise.then(function () {
                    captchaEls.forEach(function (captchaEl) {
                        var form = $dom.parent(captchaEl, 'form'),
                            grecaptchaParameters;

                        captchaEl.dataset.recaptchaSuccessful = '0';

                        grecaptchaParameters = {
                            sitekey: $CONFIG_OPTION_recaptcha_site_key,
                            callback: function() {
                                captchaEl.dataset.recaptchaSuccessful = '1';
                                $dom.submit(form);
                            },
                            theme: '{$?,{$THEME_DARK},dark,light}',
                            size: 'invisible'
                        };

                        if (captchaEl.dataset.tabindex != null) {
                            grecaptchaParameters.tabindex = captchaEl.dataset.tabindex;
                        }
                        window.grecaptcha.render(captchaEl, grecaptchaParameters, false);
                        
                        $dom.on(form, 'submit', function (e) {
                            if (!captchaEl.dataset.recaptchaSuccessful || (captchaEl.dataset.recaptchaSuccessful === '0')) {
                                e.preventDefault();
                                window.grecaptcha.execute();
                            }
                        });
                    });
                });
            }
        }
    });
    
    $cms.functions.captchaCaptchaAjaxCheck = function captchaCaptchaAjaxCheck() {
        var form = document.getElementById('main_form'),
            captchaEl = form.elements['captcha'],
            submitBtn = document.getElementById('submit_button');

        if (!form) {
            form = document.getElementById('posting_form');
        }

        if ($CONFIG_OPTION_recaptcha_site_key !== '') { // ReCAPTCHA Enabled
            return;
        }
        
        var validValue;
        form.addEventListener('submit', function submitCheck(e) {
            var value = captchaEl.value;
            
            if (value === validValue) {
                return;
            }
            
            var url = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=captcha_wrong&name=' + encodeURIComponent(value);
            e.preventDefault();
            submitBtn.disabled = true;
            $cms.form.doAjaxFieldTest(url).then(function (valid) {
                if (valid) {
                    validValue = value;
                    $dom.submit(form);
                } else {
                    document.getElementById('captcha').src += '&'; // Force it to reload latest captcha
                    submitBtn.disabled = false;
                }
            });
        });
    };
}(window.$cms, window.$util, window.$dom));

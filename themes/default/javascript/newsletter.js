(function ($cms) {
    'use strict';

    $cms.functions.newsletterNewsletterForm = function newsletterNewsletterForm() {
        var form = document.getElementById('password').form;
        form.addEventListener('submit', function () {
            if ((form.elements['password_confirm']) && (form.elements['password_confirm'].value != form.elements['password'].value)) {
                $cms.ui.alert('{!PASSWORD_MISMATCH;^}');
                return false;
            }
        });
    };

    $cms.templates.newsletterPreview = function (params) {
        var frame_id = 'preview_frame',
            html = strVal(params.htmlPreview);

        window.setTimeout(function () {
            var adjusted_preview = html.replace(/<!DOCTYPE[^>]*>/i, '').replace(/<html[^>]*>/i, '').replace(/<\/html>/i, '');
            var de = window.frames[frame_id].document.documentElement;
            var body = de.querySelector('body');
            if (!body) {
                $cms.dom.html(de, adjusted_preview);
            } else {
                var head_element = de.querySelector('head');
                if (!head_element) {
                    head_element = document.createElement('head');
                    de.appendChild(head_element);
                }
                if (!de.querySelector('style') && adjusted_preview.indexOf('<head') != -1) {/*{$,The conditional is needed for Firefox - for some odd reason it is unable to parse any head tags twice}*/
                    $cms.dom.html(head_element, adjusted_preview.replace(/^(.|\n)*<head[^>]*>((.|\n)*)<\/head>(.|\n)*$/i, '$2'));
                }

                $cms.dom.html(body, adjusted_preview.replace(/^(.|\n)*<body[^>]*>((.|\n)*)<\/body>(.|\n)*$/i, '$2'));
            }

            resize_frame(frame_id, 300);
        }, 500);

        window.setInterval(function () {
            resize_frame(frame_id, 300);
        }, 1000);
    };

    $cms.templates.blockMainNewsletterSignup = function (params, container) {
        var nid = strVal(params.nid);

        $cms.dom.on(container, 'submit', '.js-form-submit-newsletter-check-email-field', function (e, form) {
            if ((check_field_for_blankness(form.elements['address' + nid])) && (form.elements['address' + nid].value.match(/^[a-zA-Z0-9\._\-\+]+@[a-zA-Z0-9\._\-]+$/))) {
                $cms.ui.disableFormButtons(form);
                return;
            }

            e.preventDefault();
            $cms.ui.alert('{!javascript:NOT_A_EMAIL;}');
        });
    };

    $cms.templates.periodicNewsletterRemove = function periodicNewsletterRemove(params, container) {
        $cms.dom.on(container, 'click', '.js-click-btn-disable-self', function (e, btn) {
            setTimeout(function () {
                btn.disabled = true;
            }, 100);
        });
    };

}(window.$cms));


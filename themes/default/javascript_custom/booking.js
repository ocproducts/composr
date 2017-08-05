(function ($cms) {
    'use strict';

    $cms.templates.bookingFleshOutScreen = function bookingFleshOutScreen(params, container) {
        $cms.dom.on(container, 'change', 'js-change-recalculate-booking-price', function (e, el) {
            recalculatePrice(el.form);
        });
    };

    function recalculatePrice(form) {
        var post = '', value, type;
        for (var i = 0; i < form.elements.length; i++) {
            if (!form.elements[i].name) continue;
            value = '';
            type = form.elements[i].localName;
            if (type == 'input') {
                type = form.elements[i].type;
            }
            switch (type) {
                case 'hidden':
                case 'text':
                case 'textarea':
                    value = form.elements[i].value;
                    break;
                case 'select':
                    value = form.elements[i].options[form.elements[i].selectedIndex].value;
                    break;
            }
            post += form.elements[i].name + '=' + encodeURIComponent(value) + '&';
        }
        $cms.doAjaxRequest('{$FIND_SCRIPT;,booking_price_ajax}' + $cms.keepStub(true), function (_, xhr) {
            $cms.dom.html(document.getElementById('price'), $cms.filter.html(xhr.responseText));
        }, post);
    }
}(window.$cms));

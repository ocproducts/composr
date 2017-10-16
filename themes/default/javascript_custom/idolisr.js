(function ($cms) {
    'use strict';

    $cms.templates.pointsGive = function pointsGive(params, container) {
        var givePointsFormLastValid;
        
        $cms.dom.on(container, 'submit', '.js-submit-check-form', function (e, form) {
            if (givePointsFormLastValid && (givePointsFormLastValid.getTime() === $cms.form.lastChangeTime(form).getTime())) {
                return;
            }
            
            e.preventDefault();

            $cms.form.checkForm(form, false).then(function (valid) {
                if (valid) {
                    givePointsFormLastValid = $cms.form.lastChangeTime(form);
                    $cms.dom.submit(form);
                }
            });
        });

        $cms.dom.on(container, 'click', '.js-click-check-reason', function (e, el) {
            var reason = document.getElementById('give_reason');
            if ((reason.value.substr(reason.value.indexOf(': ')).length <= 3) && (el.selectedIndex != 0)) {
                reason.value = el.options[el.selectedIndex].value + ': ';
            }
        });

        $cms.dom.on(container, 'change', '.js-change-check-reason', function (e, el) {
            var reason = document.getElementById('give_reason');
            if ((reason.value.substr(reason.value.indexOf(': ')).length <= 3) && (el.selectedIndex != 0)) {
                reason.value = el.options[el.selectedIndex].value + ': ';
            }
        });
    };
}(window.$cms));

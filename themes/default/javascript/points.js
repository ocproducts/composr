(function ($cms) {
    'use strict';

    var givePointsFormLastValid;
    $cms.templates.pointsGive = function pointsGive(params, container) {
        $dom.on(container, 'submit', '.js-submit-check-form', function (e, form) {
            if (givePointsFormLastValid && (givePointsFormLastValid.getTime() === $cms.form.lastChangeTime(form).getTime())) {
                return;
            }

            e.preventDefault();

            $cms.form.checkForm(form, false).then(function (valid) {
                if (valid) {
                    givePointsFormLastValid = $cms.form.lastChangeTime(form);
                    $dom.submit(form);
                }
            });
        });
    };
}(window.$cms));

(function ($cms) {
    'use strict';

    function PointsGive() {
        PointsGive.base(this, 'constructor', arguments);
    }

    $cms.inherits(PointsGive, $cms.View, {
        events: {
            'submit .js-submit-check-form': 'checkForm'
        },

        checkForm: function (e, form) {
            if (!check_form(form)) {
                e.preventDefault();
            }
        }
    });

    $cms.views.PointsGive = PointsGive;

}(window.$cms));
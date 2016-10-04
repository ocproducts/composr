(function (Composr) {
    'use strict';

    var PointsGive = Composr.View.extend({
        events: {
            'submit .js-submit-check-form': 'checkForm'
        },

        checkForm: function (e, form) {
            if (!check_form(form)) {
                e.preventDefault();
            }
        }
    });

}(window.Composr));
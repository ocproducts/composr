(function ($cms) {
    'use strict';

    $cms.views.PointsGive = PointsGive;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function PointsGive() {
        PointsGive.base(this, 'constructor', arguments);
    }

    $cms.inherits(PointsGive, $cms.View, /**@lends PointsGive#*/{
        events: function () {
            return {
                'submit .js-submit-check-form': 'checkForm'
            };
        },

        checkForm: function (e, form) {
            if (!$cms.form.checkForm(form)) {
                e.preventDefault();
            }
        }
    });

}(window.$cms));
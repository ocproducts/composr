(function ($cms) {
    'use strict';

    function PurchaseWizardScreen() {
        PurchaseWizardScreen.base(this, arguments);
        this.formEl = this.$('form.js-form-primary');
    }

    $cms.inherits(PurchaseWizardScreen, $cms.View, {
        formEl: null,
        events: {
            'click .js-click-do-form-submit': 'doFormSubmit'
        },
        doFormSubmit: function (e) {
            if (!do_form_submit(this.formEl, e)) {
                e.preventDefault();
            }
        }
    });

    $cms.views.PurchaseWizardScreen = PurchaseWizardScreen;
}(window.$cms));
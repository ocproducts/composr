(function (Composr) {
    'use strict';

    var PurchaseWizardScreen = Composr.View.extend({
        form: null,
        initialize: function () {
            PurchaseWizardScreen.__super__.initialize.apply(this, arguments);
            this.form = this.$('form.js-form-primary');
        },
        events: {
            'click .js-click-do-form-submit': 'doFormSubmit'
        },
        doFormSubmit: function (e) {
            if (!do_form_submit(this.form, e)) {
                e.preventDefault();
            }
        }
    });

    Composr.views.PurchaseWizardScreen = PurchaseWizardScreen;
}(window.Composr));
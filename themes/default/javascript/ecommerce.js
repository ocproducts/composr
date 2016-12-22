(function ($cms) {
    'use strict';

    function PurchaseWizardScreen() {
        PurchaseWizardScreen.base(this, 'constructor', arguments);
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

    $cms.templates.purchaseWizardStageTerms = function purchaseWizardStageTerms(params, container) {
        $cms.dom.on(container, 'click', '.js-checkbox-click-toggle-proceed-btn', function (e, checkbox) {
            $cms.dom.$('#proceed_button').disabled = !checkbox.checked;
        });

        $cms.dom.on(container, 'click', '.js-click-btn-i-disagree', function (e, btn) {
            if (btn.dataset.tpLocation) {
                window.location = btn.dataset.tpLocation
            }
        });
    };
}(window.$cms));
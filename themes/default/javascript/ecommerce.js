(function ($cms) {
    'use strict';

    $cms.views.PurchaseWizardScreen = PurchaseWizardScreen;
    function PurchaseWizardScreen() {
        PurchaseWizardScreen.base(this, 'constructor', arguments);
        this.formEl = this.$('form.js-form-primary');
    }

    $cms.inherits(PurchaseWizardScreen, $cms.View, {
        formEl: null,
        events: function () {
            return {
                'click .js-click-do-form-submit': 'doFormSubmit'
            };
        },
        doFormSubmit: function (e) {
            if (!$cms.form.doFormSubmit(this.formEl, e)) {
                e.preventDefault();
            }
        }
    });

    $cms.functions.moduleAdminEcommerce = function moduleAdminEcommerce() {
        var _length_units = document.getElementById('length_units'), _length = document.getElementById('length');
        var adjust_lengths = function () {
            var length_units = _length_units.options[_length_units.selectedIndex].value, length = _length.value;
            if (document.getElementById('auto_recur').checked) {
                // Limits based on https://developer.paypal.com/docs/classic/paypal-payments-standard/integration-guide/Appx_websitestandard_htmlvariables/
                if ((length_units == 'd') && ((length < 1) || (length > 90)))
                    _length.value = (length < 1) ? 1 : 90;
                if ((length_units == 'w') && ((length < 1) || (length > 52)))
                    _length.value = (length < 1) ? 1 : 52;
                if ((length_units == 'm') && ((length < 1) || (length > 24)))
                    _length.value = (length < 1) ? 1 : 24;
                if ((length_units == 'y') && ((length < 1) || (length > 5)))
                    _length.value = (length < 1) ? 1 : 5;
            } else {
                if (length < 1)
                    _length.value = 1;
            }
        };
        _length_units.addEventListener('change', adjust_lengths);
        _length.addEventListener('change', adjust_lengths);
    };

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

    $cms.templates.ecomLogosAuthorize = function ecomLogosAuthorize(params, container) {
        window.ANS_customer_id = strVal(params.customerId);

        document.body.appendChild($cms.dom.create('script', null, {
            src: 'https://verify.authorize.net/anetseal/seal.js',
            defer: true
        }));
    };
}(window.$cms));
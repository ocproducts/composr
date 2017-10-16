(function ($cms) {
    'use strict';

    window.$cmsReady.push(function () {
        var addressFields = ['street_address', 'city', 'county', 'state', 'post_code', 'country'];

        addressFields.forEach(function (field) {
            var billing = $cms.dom.$('#billing_' + field),
                shipping = $cms.dom.$('#shipping_' + field);

            if (!billing || !shipping) {
                return; // (continue)
            }

            $cms.dom.on(billing, 'change', function () {
                if (billing.localName === 'select') {
                    if (shipping.selectedIndex === 0) {
                        shipping.selectedIndex = billing.selectedIndex;
                        if (window.jQuery && window.jQuery.fn.select2) {
                            window.jQuery(shipping).trigger('change');
                        }
                    }
                } else {
                    if (shipping.value === '') {
                        shipping.value = billing.value;
                    }
                }
            });
        });
    });

    $cms.templates.ecomShoppingCartScreen = function (params) {
        var container = this,
            typeCodes = strVal(params.typeCodes),
            emptyCaryUrl = strVal(params.emptyCartUrl);

        $cms.dom.on(container, 'click', '.js-click-btn-cart-update', function (e) {
            if (updateCart(typeCodes) === false) {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-btn-cart-empty', function (e, btn) {
            if (confirmEmpty('{!shopping:EMPTY_CONFIRM;}', emptyCaryUrl, btn.form) === false) {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-do-cart-form-submit', function (e, btn) {
            $cms.form.doFormSubmit(btn.form);
        });

        function updateCart(proIds) {
            var proIdsArray = proIds.split(',');

            var tot = proIdsArray.length;

            for (var i = 0; i < tot; i++) {
                var quantityData = 'quantity_' + proIdsArray[i];

                var qval = document.getElementById(quantityData).value;

                if (isNaN(qval)) {
                    $cms.ui.alert('{!shopping:CART_VALIDATION_REQUIRE_NUMBER;^}');
                    return false;
                }
            }
        }

        function confirmEmpty(message, actionUrl, form) {
            $cms.ui.confirm(
                message,
                function () {
                    form.action = actionUrl;
                    $cms.dom.submit(form);
                }
            );
            return false;
        }
    };

    $cms.templates.ecomAdminOrdersScreen = function ecomAdminOrdersScreen(params, container) {
        $cms.dom.on(container, 'submit', '.js-submit-scroll-to-top', function () {
            try {
                scrollTo(0, 0);
            } catch (ignore) {}
        });
    };

    $cms.templates.ecomAdminOrderActions = function ecomAdminOrderActions(params, container) {
        $cms.dom.on(container, 'change', '.js-select-change-action-submit-form', function (e, select) {
            if (select.selectedIndex > 0) {
                $cms.dom.submit(select.form);
            }
        });

        $cms.dom.on(container, 'submit', '.js-submit-confirm-admin-order-actions', function (e, form) {
            var actionName = form.elements.action.value;

            if (actionName === 'dispatch') {
                $cms.ui.confirm(
                    '{!shopping:DISPATCH_CONFIRMATION_MESSAGE;^}',
                    function (result) {
                        if (result) {
                            $cms.ui.disableFormButtons(form);
                            $cms.dom.submit(form);
                        }
                    }
                );
            }

            if (actionName === 'del_order') {
                $cms.ui.confirm(
                    '{!shopping:CANCEL_ORDER_CONFIRMATION_MESSAGE;^}',
                    function (result) {
                        if (result) {
                            $cms.ui.disableFormButtons(form);
                            $cms.dom.submit(form);
                        }
                    }
                );
            }
        });
    };

    $cms.templates.ecomShoppingItemQuantityField = function ecomShoppingItemQuantityField(params, container) {
        $cms.dom.on(container, 'keypress', '.js-keypress-unfade-cart-update-button', function () {
            document.getElementById('cart_update_button').classList.remove('button_faded');
        });
    };

    $cms.templates.ecomShoppingItemRemoveField = function ecomShoppingItemRemoveField(params, container) {
        $cms.dom.on(container, 'click', '.js-click-unfade-cart-update-button', function () {
            document.getElementById('cart_update_button').classList.remove('button_faded');
        });
    };

    window.checkout = checkout;
    function checkout(formName, checkoutUrl) {
        var form = document.getElementById(formName);
        form.action = checkoutUrl;
        $cms.dom.submit(form);
        return true;
    }
}(window.$cms));

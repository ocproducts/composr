(function ($cms) {
    'use strict';

    /* TODO: fix for v11 */
    $cms.ready.then(function() {
        var addressFields = ['street_address', 'city', 'county', 'state', 'post_code', 'country'];

        addressFields.forEach(function (field) {
            var billing = $cms.dom.$('#billing_' + field),
                shipping = $cms.dom.$('#shipping_' + field);

            if (!billing || !shipping) {
                return; // (continue)
            }

            $cms.dom.on(billing, 'change', function () {
                if (billing.localName === 'select') {
                    if (shipping.selectedIndex == 0) {
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
            productIds = strVal(params.productIds),
            emptyCaryUrl = strVal(params.emptyCartUrl);

        $cms.dom.on(container, 'click', '.js-click-btn-cart-update', function (e) {
            if (update_cart(productIds) === false) {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-btn-cart-empty', function (e, btn) {
            if (confirm_empty('{!EMPTY_CONFIRM;}', emptyCaryUrl, btn.form) === false) {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-do-cart-form-submit', function (e, btn) {
            do_form_submit(btn.form, e);
        });

        function update_cart(pro_ids) {
            var pro_ids_array = pro_ids.split(',');

            var tot = pro_ids_array.length;

            for (var i = 0; i < tot; i++) {
                var quantity_data = 'quantity_' + pro_ids_array[i];

                var qval = document.getElementById(quantity_data).value;

                if (isNaN(qval)) {
                    window.fauxmodal_alert('{!shopping:CART_VALIDATION_REQUIRE_NUMBER;^}');
                    return false;
                }
            }
        }

        function confirm_empty(message, action_url, form) {
            window.fauxmodal_confirm(
                message,
                function () {
                    form.action = action_url;
                    form.submit();
                }
            );
            return false;
        }
    };

    $cms.templates.ecomAdminOrdersScreen = function ecomAdminOrdersScreen(params, container) {
        $cms.dom.on(container, 'submit', '.js-submit-scroll-to-top', function (){
            try {
                window.scrollTo(0, 0);
            } catch (ignore) {}
        });
    };

    $cms.templates.ecomAdminOrderActions = function ecomAdminOrderActions() {
        var container = this;

        $cms.dom.on(container, 'change', '.js-select-change-action-submit-form', function (e, select) {
            if (select.selectedIndex > 0) {
                select.form.submit();
            }
        });

        $cms.dom.on(container, 'submit', '.js-submit-confirm-admin-order-actions', function (e, form) {
            var actionName = form.elements.action.value;

            if (actionName === 'dispatch') {
                window.fauxmodal_confirm(
                    '{!shopping:DISPATCH_CONFIRMATION_MESSAGE;^}',
                    function (result) {
                        if (result) {
                            $cms.ui.disableFormButtons(form);
                            form.submit();
                        }
                    }
                );
            }

            if (actionName === 'del_order') {
                window.fauxmodal_confirm(
                    '{!shopping:CANCEL_ORDER_CONFIRMATION_MESSAGE;^}',
                    function (result) {
                        if (result) {
                            $cms.ui.disableFormButtons(form);
                            form.submit();
                        }
                    }
                );
            }
        });
    };

    $cms.templates.echomShoppingItemQuantityField = function echomShoppingItemQuantityField(params, container) {
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
    function checkout(form_name, checkout_url) {
        var form = document.getElementById(form_name);
        form.action = checkout_url;
        form.submit();
        return true;
    }
}(window.$cms));
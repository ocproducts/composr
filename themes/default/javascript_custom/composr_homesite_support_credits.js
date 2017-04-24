(function ($cms) {
    'use strict';

    $cms.templates.blockCreditExpsInner = function blockCreditExpsInner(params, container) {
        update_product_info_display();

        $cms.dom.on(container, 'change', '.js-change-update-product-info-display', function () {
            update_product_info_display();
        });

        function update_product_info_display() {
            var type_code = document.getElementById('type_code');
            var value = type_code.options[type_code.selectedIndex].value;
            var creditsInfo = document.body.querySelectorAll('.creditsInfo');
            for (var i = 0; i < creditsInfo.length; i++) {
                creditsInfo[i].style.display = (creditsInfo[i].id == 'info_' + value) ? 'block' : 'none';
            }
        }
    };
}(window.$cms));
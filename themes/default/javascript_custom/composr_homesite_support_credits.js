(function ($cms) {
    'use strict';

    $cms.templates.mantisTracker = function mantisTracker(params, container) {
        $cms.dom.on(container, 'click', '.js-click-add-voted-class', function (e, el) {
            el.classList.remove('tracker_issue_not_voted');
            el.classList.add('tracker_issue_voted');
        });
    };

    $cms.templates.blockCreditExpsInner = function blockCreditExpsInner(params, container) {
        updateProductInfoDisplay();

        $cms.dom.on(container, 'change', '.js-change-update-product-info-display', function () {
            updateProductInfoDisplay();
        });

        function updateProductInfoDisplay() {
            var typeCode = document.getElementById('type_code');
            var value = typeCode.options[typeCode.selectedIndex].value;
            var creditsInfo = document.body.querySelectorAll('.creditsInfo');
            for (var i = 0; i < creditsInfo.length; i++) {
                creditsInfo[i].style.display = (creditsInfo[i].id == 'info_' + value) ? 'block' : 'none';
            }
        }
    };
}(window.$cms));

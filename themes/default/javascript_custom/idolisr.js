(function ($cms) {
    'use strict';

    $cms.templates.pointsGive = function pointsGive(params, container) {
        $cms.dom.on(container, 'submit', '.js-submit-check-form', function (e, form) {
            if ($cms.form.checkForm(form) === false) {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-check-reason', function () {
            var reason = document.getElementById('give_reason');
            if ((reason.value.substr(reason.value.indexOf(': ')).length <= 3) && (this.selectedIndex != 0)) {
                reason.value = this.options[this.selectedIndex].value + ': ';
            }
        });

        $cms.dom.on(container, 'change', '.js-change-check-reason', function () {
            var reason = document.getElementById('give_reason');
            if ((reason.value.substr(reason.value.indexOf(': ')).length <= 3) && (this.selectedIndex != 0)) {
                reason.value = this.options[this.selectedIndex].value + ': ';
            }
        });
    };
}(window.$cms));
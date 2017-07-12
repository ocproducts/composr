(function ($cms) {
    'use strict';

    $cms.templates.miniblockMainCalculator = function miniblockMainCalculator(params, container) {
        var message = strVal(container.dataset.tpMessage),
            equation = strVal(container.dataset.tpEquation);
        
        $cms.dom.on(container, 'click', '.js-btn-click-calculate-sum', function () {
            if ($cms.form.checkForm(this.form)) {
                $cms.ui.alert(message.replace('xxx', calculateSum(this.form.elements)));
            }
        });

        function calculateSum(elements) {
            for (var i = 0; i < elements.length; i++) {
                if (elements[i].name !== '') {
                    window[elements[i].name] = elements[i].value;
                }
            }
            var ret;
            window.eval('ret = ' + equation);
            return Math.round(ret);
        }
    };
}(window.$cms));

(function ($cms) {
    'use strict';

    $cms.templates.formScreenInputVariousTicks = function formScreenInputVariousTicks(params, container) {
        $cms.dom.on(container, 'keypress', '.js-keypress-ensure-next-field', function (e, el) {
            _ensureNextField(e, el);
        });

        if (!params.customAcceptMultiple) {
            var customName = strVal(params.customName),
                valueCheckbox = container.querySelector('#' + customName),
                valueInput = container.querySelector('#' + customName + '_value');

            $cms.dom.on(container, 'click', '.js-click-value-input-toggle-disabled', function () {
                valueInput.disabled = !valueCheckbox.checked;
            });

            valueCheckbox.checked = (valueInput.value != '');
            valueInput.disabled = (valueInput.value == '');

            $cms.dom.on(container, 'change', '.js-change-value-checkbox-toggle-checked', function () {
                valueCheckbox.checked = (valueInput.value != '');
                valueInput.disabled = (valueInput.value == '');
            });
        }
    };
}(window.$cms));
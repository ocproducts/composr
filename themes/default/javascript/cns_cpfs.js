(function ($cms) {
    'use strict';

    $cms.functions.module_AdminCnsCustomprofilefields_createSelectionListChooseTable = function (formId) {
        formId = strVal(formId);

        var select_elements = document.getElementById(formId).getElementsByTagName('select');
        var select_submit = document.getElementById('selection_submit');
        var select_element_length = select_elements.length;

        for (var counter = 0; counter < select_element_length; counter++) {
            select_elements[counter].addEventListener('change', function () {
                select_elements[0].form.submit();
            });
        }
        select_submit.style.display = 'none';
    };
}(window.$cms));
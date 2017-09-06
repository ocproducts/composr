(function ($cms) {
    'use strict';

    $cms.functions.adminThemeWizardStep1 = function () {
        var form = document.getElementById('main_form'),
            submitBtn = document.getElementById('submit_button');
        form.elements['source_theme'].addEventListener('change', function () {
            var defaultTheme = (form.elements['source_theme'].value === 'default');
            form.elements['algorithm'][0].checked = defaultTheme;
            form.elements['algorithm'][1].checked = !defaultTheme;
        });
        form.addEventListener('submit', function submitCheck(e) {
            submitBtn.disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=exists_theme&name=' + encodeURIComponent(form.elements['themename'].value);
            e.preventDefault();
            $cms.form.doAjaxFieldTest(url).then(function (valid) {
                if (valid) {
                    form.removeEventListener('submit', submitCheck);
                    $cms.dom.submit(form);
                } else {
                    submitBtn.disabled = false;
                }
            });
        });
    };
}(window.$cms));

(function ($cms, $util, $dom) {
    'use strict';

    $cms.functions.adminThemeWizardStep1 = function () {
        var form = document.getElementById('main_form'),
            submitBtn = document.getElementById('submit-button');
        form.elements['source_theme'].addEventListener('change', function () {
            var defaultTheme = (form.elements['source_theme'].value === 'default');
            form.elements['algorithm'][0].checked = defaultTheme;
            form.elements['algorithm'][1].checked = !defaultTheme;
        });
        
        var validValue;
        form.addEventListener('submit', function submitCheck(e) {
            var value = form.elements['themename'].value;
            
            if (value === validValue) {
                return;
            }
            
            submitBtn.disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=exists_theme&name=' + encodeURIComponent(value);
            e.preventDefault();
            $cms.form.doAjaxFieldTest(url).then(function (valid) {
                if (valid) {
                    validValue = value;
                    $dom.submit(form);
                } else {
                    submitBtn.disabled = false;
                }
            });
        });
    };
}(window.$cms, window.$util, window.$dom));

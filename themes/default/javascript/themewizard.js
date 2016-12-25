(function ($cms) {
    'use strict';

    $cms.functions.adminThemewizardStep1 = function () {
        var form = document.getElementById('main_form');
        form.elements['source_theme'].onchange = function () {
            var default_theme = (form.elements['source_theme'].options[form.elements['source_theme'].selectedIndex].value == 'default');
            form.elements['algorithm'][0].checked = default_theme;
            form.elements['algorithm'][1].checked = !default_theme;
        };
        form.old_submit = form.onsubmit;
        form.onsubmit = function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=exists_theme&name=' + encodeURIComponent(form.elements['themename'].value);
            if (!do_ajax_field_test(url)) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
            if (form.old_submit) {
                return form.old_submit();
            }
            return true;
        };
    };

}(window.$cms));
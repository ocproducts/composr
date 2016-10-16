(function ($cms) {
    'use strict';

    $cms.templates.cnsSavedWarning = function cnsSavedWarning(params) {
        var id = $cms.filter.id(params.title);

        document.getElementById('saved_use__' + id).onsubmit = function () {
            var win = get_main_cms_window();

            var explanation = win.document.getElementById('explanation');
            explanation.value = params.explanation;

            var message = win.document.getElementById('message');
            win.insert_textbox(message, params.message, null, false, params.messageHtml);

            if (window.faux_close !== undefined) {
                window.faux_close();
            } else {
                window.close();
            }

            return false;
        };

        document.getElementById('saved_delete__' + id).getElementsByTagName('input')[1].onclick = function () {
            var form = this.form;

            window.fauxmodal_confirm(params.question, function (answer) {
                if (answer) {
                    form.submit();
                }
            });

            return false;
        };
    };

}(window.$cms));

(function ($cms) {
    'use strict';

    $cms.templates.cnsPostTemplateSelect = function (params, container) {
        $cms.dom.on(container, 'click', '.js-click-reset-and-insert-textbox', function (e, button) {
            var form = button.form,
                ins = form.elements.post_template.value;
            if (params.resets) {
                set_textbox(form.elements.post, '');
            }
            insert_textbox(form.elements.post, ins.replace(/\\n/g, '\n'), null, true, escape_html(ins).replace(/\\n/g, '<br />'));
        });
    };
}(window.$cms));
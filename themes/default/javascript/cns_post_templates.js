(function ($cms) {
    'use strict';

    $cms.templates.cnsPostTemplateSelect = function (params, container) {
        $cms.dom.on(container, 'click', '.js-click-reset-and-insert-textbox', function (e, button) {
            var form = button.form,
                ins = form.elements['post_template'].value;
            if (params.resets) {
                setTextbox(form.elements.post, '');
            }
            insertTextbox(form.elements.post, ins.replace(/\\n/g, '\n'), null, true, $cms.filter.html(ins).replace(/\\n/g, '<br />'));
        });
    };
}(window.$cms));

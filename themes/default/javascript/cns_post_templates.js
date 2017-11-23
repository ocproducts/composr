(function ($cms, $util, $dom) {
    'use strict';

    $cms.templates.cnsPostTemplateSelect = function (params, container) {
        var resets = boolVal(params.resets);
        
        $dom.on(container, 'click', '.js-click-reset-and-insert-textbox', function (e, button) {
            var form = button.form,
                ins = form.elements['post_template'].value;
            
            if (resets) {
                window.setTextbox(form.elements['post'], '');
            }
            window.insertTextbox(form.elements['post'], ins.replace(/\\n/g, '\n'), true, $cms.filter.html(ins).replace(/\\n/g, '<br />'));
        });
    };
}(window.$cms, window.$util, window.$dom));

(function ($cms) {
    'use strict';

    $cms.functions.moduleWarningsGetFormFields = function moduleWarningsGetFormFields() {
        document.getElementById('message').disabled = true;
        
        if (document.getElementById('add_private_topic')) {
            document.getElementById('add_private_topic').addEventListener('click', function () {
                document.getElementById('message').disabled = !document.getElementById('add_private_topic').checked;
            });   
        }
    };

    $cms.templates.cnsSavedWarning = function cnsSavedWarning(params) {
        var id = $cms.filter.id(params.title);

        document.getElementById('saved_use__' + id).addEventListener('submit', function () {
            /**@alias window*/
            var win = $cms.getMainCmsWindow();

            var explanation = win.document.getElementById('explanation');
            explanation.value = params.explanation;

            var message = win.document.getElementById('message');
            win.insertTextbox(message, params.message, false, params.messageHtml, true).then(function () {
                if (window.fauxClose !== undefined) {
                    window.fauxClose();
                } else {
                    window.close();
                }

            });
            
            return false;
        });

        document.getElementById('saved_delete__' + id).getElementsByTagName('input')[1].addEventListener('click', function () {
            var form = this.form;

            $cms.ui.confirm(params.question, function (answer) {
                if (answer) {
                    $cms.dom.submit(form);
                }
            });

            return false;
        });
    };
}(window.$cms));

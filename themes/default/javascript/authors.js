(function ($cms) {
    'use strict';

    $cms.templates.authorPopup = function (params, container) {
        $cms.dom.on(container, 'click', '.js-click-set-author-and-close', function (e, clicked) {
            var form = $cms.dom.$($cms.getMainCmsWindow().document, '#posting_form, #main_form'),
                fieldName = clicked.dataset.tpFieldName,
                fieldValue = clicked.dataset.tpAuthor,
                author;

            if (!form) {
                form = $cms.dom.$$($cms.getMainCmsWindow().document, 'form').pop();
            }

            author = form.elements[fieldName];
            author.value = fieldValue;
            if (window.fauxClose !== undefined) {
                window.fauxClose();
            }
        });
    };
}(window.$cms));

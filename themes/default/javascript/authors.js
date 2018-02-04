(function ($cms, $util, $dom) {
    'use strict';

    $cms.templates.authorPopup = function (params, container) {
        $dom.on(container, 'click', '.js-click-set-author-and-close', function (e, clicked) {
            var form = $dom.$($cms.getMainCmsWindow().document, '#posting-form, #main-form'),
                fieldName = clicked.dataset.tpFieldName,
                fieldValue = clicked.dataset.tpAuthor,
                author;

            if (!form) {
                form = $dom.$$($cms.getMainCmsWindow().document, 'form').pop();
            }

            author = form.elements[fieldName];
            author.value = fieldValue;
            if (window.fauxClose !== undefined) {
                window.fauxClose();
            }
        });
    };
}(window.$cms, window.$util, window.$dom));

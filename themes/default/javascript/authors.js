(function (Composr) {
    'use strict';

    Composr.behaviors.authors = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'authors');
            }
        }
    };

    Composr.templates.authors = {
        authorPopup: function () {
            var container = this;

            Composr.dom.on(container, 'click', '.js-click-set-author-and-close', function (e, clicked) {
                var form = Composr.dom.$(get_main_cms_window().document, '#posting_form, #main_form'),
                    fieldName = clicked.dataset.tpFieldName,
                    fieldValue = clicked.dataset.tpAuthor,
                    author;

                if (!form) {
                    form = Composr.dom.$$(get_main_cms_window().document, 'form').pop();
                }

                author = form.elements[fieldName];
                author.value = fieldValue;
                window.faux_close();
            });
        }
    };
}(window.Composr));
(function ($cms) {
    'use strict';

    $cms.views.XmlConfigScreen = XmlConfigScreen;
    function XmlConfigScreen() {
        XmlConfigScreen.base(this, 'constructor', arguments);

        ace_composr_loader('xml', 'xml');
    }

    $cms.inherits(XmlConfigScreen, $cms.View, /**@lends XmlConfigScreen#*/{
        events: function () {
            return {
                'submit .js-form-xml-config': 'submit'
            };
        },

        submit: function (e, form) {
            e.preventDefault();
            $cms.form.modsecurityWorkaround(form);
        }
    });

    $cms.templates.configCategoryScreen = function configCategoryScreen(params, container) {
        $cms.dom.on(container, 'submit', '.js-form-primary-page', function (e, form) {
            $cms.form.modsecurityWorkaround(form);
        });
    };
}(window.$cms));
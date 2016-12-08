(function ($cms) {
    'use strict';

    function XmlConfigScreen() {
        XmlConfigScreen.base(this, 'constructor', arguments);

        ace_composr_loader('xml', 'xml');
    }

    $cms.inherits(XmlConfigScreen, $cms.View, {
        events: {
            'submit .js-form-xml-config': 'submit'
        },

        submit: function (e, form) {
            e.preventDefault();
            modsecurity_workaround(form);
        }
    });

    $cms.views.XmlConfigScreen = XmlConfigScreen;

    $cms.templates.configCategoryScreen = function configCategoryScreen() {
        var container = this;

        $cms.dom.on(container, 'submit', '.js-form-primary-page', function (e, form) {
            modsecurity_workaround(form);
        });
    };
}(window.$cms));
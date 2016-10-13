(function ($cms) {
    'use strict';

    function XmlConfigScreen() {
        $cms.View.apply(this, arguments);

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
}(window.$cms));
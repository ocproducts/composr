(function ($, Composr) {
    'use strict';

    Composr.behaviors.coreConfiguration = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core_configuration');
                Composr.initializeTemplates(context, 'core_configuration');
            }
        }
    };

    var XmlConfigScreen = Composr.View.extend({
        initialize: function () {
            Composr.View.prototype.initialize.apply(this, arguments);

            ace_composr_loader('xml', 'xml');
        },

        events: {
            'submit .js-form-xml-config': 'submit'
        },

        submit: function (e) {
            var form = e.currentTarget;
            e.preventDefault();
            modsecurity_workaround(form);
        }
    });

    Composr.views.coreConfiguration = {
        XmlConfigScreen: XmlConfigScreen
    };

    Composr.templates.coreConfiguration = {};

}(window.jQuery || window.Zepto, Composr));
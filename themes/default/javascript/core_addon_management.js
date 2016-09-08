(function (Composr) {
    'use strict';

    Composr.behaviors.coreAddonManagement = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core_addon_management');
                Composr.initializeTemplates(context, 'core_addon_management');
            }
        }
    };

    var AddonInstallConfirmScreen = Composr.View.extend({
        initialize: function () {
            AddonInstallConfirmScreen.__super__.initialize.apply(this, arguments);
        }
    });

    Composr.views.coreAddonManagement = {
        AddonInstallConfirmScreen: AddonInstallConfirmScreen
    };

    Composr.templates.coreAddonManagement = {};
}(window.Composr));
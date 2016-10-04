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

    // Templates:
    // ADDON_SCREEN.tpl
    // - ADDON_SCREEN_ADDON.tpl
    var AddonScreen = Composr.View.extend({
        events: {
            'click .js-click-check-uninstall-all': 'checkUninstallAll'
        },

        checkUninstallAll: function () {
            var checkboxes = this.$$('input[type="checkbox"][name^="uninstall_"]');

            checkboxes.forEach(function (el) {
                el.checked = true;
            });
        }
    });

    Composr.views.coreAddonManagement = {
        AddonInstallConfirmScreen: AddonInstallConfirmScreen,
        AddonScreen: AddonScreen
    };

    Composr.templates.coreAddonManagement = {};

}(window.Composr));
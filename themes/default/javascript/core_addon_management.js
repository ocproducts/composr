(function ($cms) {
    'use strict';

    function AddonInstallConfirmScreen() {
        $cms.View.apply(this, arguments);
    }

    $cms.inherits(AddonInstallConfirmScreen, $cms.View);

    // Templates:
    // ADDON_SCREEN.tpl
    // - ADDON_SCREEN_ADDON.tpl
    function AddonScreen() {
        $cms.View.apply(this, arguments);
    }

    $cms.inherits(AddonScreen, $cms.View, {
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

    $cms.views.AddonInstallConfirmScreen = AddonInstallConfirmScreen;
    $cms.views.AddonScreen = AddonScreen;
}(window.$cms));
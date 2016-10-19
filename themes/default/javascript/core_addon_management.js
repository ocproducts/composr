(function ($cms) {
    'use strict';

    function AddonInstallConfirmScreen() {
        AddonInstallConfirmScreen.base(this, arguments);
    }

    $cms.inherits(AddonInstallConfirmScreen, $cms.View);

    // Templates:
    // ADDON_SCREEN.tpl
    // - ADDON_SCREEN_ADDON.tpl
    function AddonScreen() {
        AddonScreen.base(this, arguments);
    }

    $cms.inherits(AddonScreen, $cms.View, {
        events: {
            'click .js-click-check-uninstall-all': 'checkUninstallAll',
            'mouseover .js-mouseover-activate-tooltip': 'activateTooltip'
        },

        checkUninstallAll: function () {
            var checkboxes = this.$$('input[type="checkbox"][name^="uninstall_"]');

            checkboxes.forEach(function (el) {
                el.checked = true;
            });
        },

        activateTooltip: function (e, el) {
            var text = el.dataset.vwTooltip;
            if (text) {
                activate_tooltip(el, e, text, '50%');
            }
        }
    });

    $cms.views.AddonInstallConfirmScreen = AddonInstallConfirmScreen;
    $cms.views.AddonScreen = AddonScreen;
}(window.$cms));
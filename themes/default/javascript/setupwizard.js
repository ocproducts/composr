(function ($cms) {
    'use strict';

    $cms.functions.adminSetupwizardStep5 = function () {
        var cuz = document.getElementById('collapse_user_zones');
        cuz.onchange = cuz_func;
        cuz_func();

        function cuz_func() {
            var gza = document.getElementById('guest_zone_access');
            gza.disabled = cuz.checked;
            if (cuz.checked) {
                gza.checked = true;
            }
        }
    };

    $cms.functions.adminSetupwizardStep7 = function () {
        document.getElementById('rules').onchange = function() {
            var items = ['preview_box_balanced', 'preview_box_liberal', 'preview_box_corporate'];
            for (var i = 0; i < items.length; i++) {
                document.getElementById(items[i]).style.display = (this.selectedIndex != i) ? 'none' : 'block';
            }
        }
    };

    $cms.functions.adminSetupwizardStep9 = function () {
        document.getElementById('site_closed').onchange = function () {
            document.getElementById('closed').disabled = !this.checked;
        };
    };
}(window.$cms));
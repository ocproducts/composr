(function ($cms, $util, $dom) {
    'use strict';

    $cms.templates.setupWizard7 = function setupWizard7() {
        $dom.on('#rules', 'click', function () {
            $dom.smoothScroll($dom.findPosY('#rules-set'));
        });
    };

    $cms.functions.adminSetupWizardStep5 = function () {
        var cuz = document.getElementById('single_public_zone');
        if (cuz) {
            cuz.addEventListener('change', cuzFunc);
            cuzFunc();
        }

        function cuzFunc() {
            var gza = document.getElementById('guest_zone_access');
            gza.disabled = cuz.checked;
            if (cuz.checked) {
                gza.checked = true;
            }
        }
    };

    $cms.functions.adminSetupWizardStep7 = function () {
        document.getElementById('rules').addEventListener('change', function () {
            var items = ['preview-box-balanced', 'preview-box-liberal', 'preview-box-corporate'];
            for (var i = 0; i < items.length; i++) {
                document.getElementById(items[i]).style.display = (this.selectedIndex !== i) ? 'none' : 'block';
            }
        });
    };

    $cms.functions.adminSetupWizardStep9 = function () {
        document.getElementById('site_closed').addEventListener('change', function () {
            document.getElementById('closed').disabled = !this.checked;
        });
    };
}(window.$cms, window.$util, window.$dom));

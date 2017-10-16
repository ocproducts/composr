(function ($cms) {
    'use strict';

    $cms.functions.adminBackupInterfaceCalendar = function adminBackupInterfaceCalendar() {
        var dOb = [
            $cms.dom.$('#schedule_day'),
            $cms.dom.$('#schedule_month'),
            $cms.dom.$('#schedule_year'),
            $cms.dom.$('#schedule_hour'),
            $cms.dom.$('#schedule_minute')
        ];

        var hideFunc;
        if (dOb[0] != null) {
            hideFunc = function () {
                $cms.dom.$('#recurrance_days').disabled = ((dOb[0].selectedIndex + dOb[1].selectedIndex + dOb[2].selectedIndex + dOb[3].selectedIndex + dOb[4].selectedIndex) > 0);
            };

            dOb[0].addEventListener('change', hideFunc);
            dOb[1].addEventListener('change', hideFunc);
            dOb[2].addEventListener('change', hideFunc);
            dOb[3].addEventListener('change', hideFunc);
            dOb[4].addEventListener('change', hideFunc);
        } else {
            dOb = [
                $cms.dom.$('#schedule'),
                $cms.dom.$('#schedule_time')
            ];
            hideFunc = function () {
                $cms.dom.$('#recurrance_days').disabled = ((dOb[0].value != '') || (dOb[1].value != ''));
            };
            dOb[0].addEventListener('change', hideFunc);
            dOb[1].addEventListener('change', hideFunc);
        }
        hideFunc();
    };

    $cms.templates.backupLaunchScreen = function backupLaunchScreen() {
        var submitButton = $cms.dom.$('#submit_button'),
            maxSizeField = $cms.dom.$('#max_size');

        if (!submitButton || !maxSizeField) {
            return;
        }

        submitButton.addEventListener('click', function (event) {
            submitButton.disabled = true;
        });

        var button = document.createElement('input');
        button.type = 'button';
        button.className = 'button_micro buttons__proceed';
        button.value = '{!backups:CALCULATE_SIZE;^}';
        button.addEventListener('click', function () {
            var progressTicker = document.createElement('img');
            progressTicker.setAttribute('src', $cms.img('{$IMG;,loading}'));
            progressTicker.style.verticalAlign = 'middle';
            progressTicker.style.marginLeft = '20px';
            button.parentNode.appendChild(progressTicker);

            $cms.loadSnippet('backup_size&max_size=' + encodeURIComponent(maxSizeField.value), null, true).then(function (size) {
                $cms.ui.alert($cms.format('{!backups:CALCULATED_SIZE;^}', [size]));
                button.parentNode.removeChild(progressTicker);
            });
        });

        maxSizeField.parentNode.insertBefore(button, maxSizeField.nextSibling.nextSibling);
    };
}(window.$cms));

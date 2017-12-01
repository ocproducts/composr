(function ($cms, $util, $dom) {
    'use strict';

    $cms.functions.adminBackupInterfaceCalendar = function adminBackupInterfaceCalendar() {
        var dOb = [
            $dom.$('#schedule_day'),
            $dom.$('#schedule_month'),
            $dom.$('#schedule_year'),
            $dom.$('#schedule_hour'),
            $dom.$('#schedule_minute')
        ];

        var hideFunc;
        if (dOb[0] != null) {
            hideFunc = function () {
                $dom.$('#recurrance_days').disabled = ((dOb[0].selectedIndex + dOb[1].selectedIndex + dOb[2].selectedIndex + dOb[3].selectedIndex + dOb[4].selectedIndex) > 0);
            };

            dOb[0].addEventListener('change', hideFunc);
            dOb[1].addEventListener('change', hideFunc);
            dOb[2].addEventListener('change', hideFunc);
            dOb[3].addEventListener('change', hideFunc);
            dOb[4].addEventListener('change', hideFunc);
        } else {
            dOb = [
                $dom.$('#schedule'),
                $dom.$('#schedule_time')
            ];
            hideFunc = function () {
                $dom.$('#recurrance_days').disabled = ((dOb[0].value != '') || (dOb[1].value != ''));
            };
            dOb[0].addEventListener('change', hideFunc);
            dOb[1].addEventListener('change', hideFunc);
        }
        hideFunc();
    };

    $cms.templates.backupLaunchScreen = function backupLaunchScreen() {
        var submitButton = $dom.$('#submit_button'),
            maxSizeField = $dom.$('#max_size');

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
            progressTicker.setAttribute('src', $util.srl('{$IMG;,loading}'));
            progressTicker.style.verticalAlign = 'middle';
            progressTicker.style.marginLeft = '20px';
            button.parentNode.appendChild(progressTicker);

            $cms.loadSnippet('backup_size&max_size=' + encodeURIComponent(maxSizeField.value), null, true).then(function (size) {
                $cms.ui.alert($util.format('{!backups:CALCULATED_SIZE;^}', [size]));
                button.parentNode.removeChild(progressTicker);
            });
        });

        maxSizeField.parentNode.insertBefore(button, maxSizeField.nextSibling.nextSibling);
    };
}(window.$cms, window.$util, window.$dom));

(function ($cms) {
    'use strict';

    $cms.functions.adminBackupInterfaceCalendar = function () {
        var d_ob = [
            $cms.dom.$('#schedule_day'),
            $cms.dom.$('#schedule_month'),
            $cms.dom.$('#schedule_year'),
            $cms.dom.$('#schedule_hour'),
            $cms.dom.$('#schedule_minute')
        ];

        var hide_func;
        if (d_ob[0] != null) {
            hide_func = function () {
                $cms.dom.$('#recurrance_days').disabled = ((d_ob[0].selectedIndex + d_ob[1].selectedIndex + d_ob[2].selectedIndex + d_ob[3].selectedIndex + d_ob[4].selectedIndex) > 0);
            };

            d_ob[0].addEventListener('change', hide_func);
            d_ob[1].addEventListener('change', hide_func);
            d_ob[2].addEventListener('change', hide_func);
            d_ob[3].addEventListener('change', hide_func);
            d_ob[4].addEventListener('change', hide_func);
        } else {
            d_ob = [
                $cms.dom.$('#schedule'),
                $cms.dom.$('#schedule_time')
            ];
            hide_func = function () {
                $cms.dom.$('#recurrance_days').disabled = ((d_ob[0].value != '') || (d_ob[1].value != ''));
            };
            d_ob[0].addEventListener('change', hide_func);
            d_ob[1].addEventListener('change', hide_func);
        }
        hide_func();
    };

    $cms.templates.backupLaunchScreen = function backupLaunchScreen() {
        var submit_button = $cms.dom.$('#submit_button'),
            max_size_field = $cms.dom.$('#max_size');

        if (!submit_button || !max_size_field) {
            return;
        }

        submit_button.addEventListener('click', function (event) {
            submit_button.disabled = true;
        });

        var button = document.createElement('input');
        button.type = 'button';
        button.className = 'button_micro buttons__proceed';
        button.value = '{!backups:CALCULATE_SIZE;^}';
        button.addEventListener('click', function () {
            var progressTicker = document.createElement('img');
            progressTicker.setAttribute('src', '{$IMG;,loading}');
            progressTicker.style.verticalAlign = 'middle';
            progressTicker.style.marginLeft = '20px';
            button.parentNode.appendChild(progressTicker, button);
            window.fauxmodal_alert('{!CALCULATED_SIZE;^}'.replace('\{1\}', load_snippet('backup_size&max_size=' + encodeURIComponent(max_size_field.value))));
            button.parentNode.removeChild(progressTicker);
        });

        max_size_field.parentNode.appendChild(button, max_size_field);
    };
}(window.$cms));
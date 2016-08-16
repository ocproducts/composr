(function ($, Composr) {
    // BACKUP_LAUNCH_SCREEN.tpl
    var backupLaunchScreen = function (context) {
        var submit_button = context.querySelector('#submit_button'),
            max_size_field = context.querySelector('#max_size');
        if (!submit_button || !max_size_field) {
            return;
        }
        submit_button.old_onclick = submit_button.onclick;
        submit_button.onclick = function (event) {
            submit_button.old_onclick(event);
            submit_button.disabled = true;
        };

        var button = document.createElement('input');
        button.type = 'button';
        button.value = '{!CALCULATE_SIZE;}';
        button.onclick = function () {
            var progress_ticker = document.createElement('img');
            progress_ticker.setAttribute('src', '{$IMG;,loading}');
            progress_ticker.style.verticalAlign = 'middle';
            progress_ticker.style.marginLeft = '20px';
            button.parentNode.appendChild(progress_ticker, button);
            window.fauxmodal_alert('{!CALCULATED_SIZE;}'.replace('\{1\}', load_snippet('backup_size&max_size=' + window.encodeURIComponent(max_size_field.value))));
            button.parentNode.removeChild(progress_ticker);
        };
        max_size_field.parentNode.appendChild(button, max_size_field);
    };

    Composr.behaviors.backup = {
        attach: function (context) {
            backupLaunchScreen(context);
        }
    };
})(window.jQuery || window.Zepto, Composr);
(function ($cms) {
    $cms.templates.quizScreen = function quizScreen(params, container) {
        var form = $cms.dom.$(container, '.js-quiz-form'),
            timeout = +params.timeout || 0;

        $cms.dom.on(container, 'submit', '.js-submit-check-form', function (e, form) {
            if (!$cms.form.checkForm(form)) {
                e.preventDefault();
            }
        });

        if (timeout > 0) {
            setTimeout(function () {
                form.submit();
            }, timeout * 1000);

            setInterval(function () {
                iterateCountdown(-1);
            }, 1000);
            iterateCountdown(0); // Because quiz_timer_minutes_and_seconds needs setting correctly
        }

        var e = $cms.dom.$$(form, '.field_input');
        for (var i = 0; i < e.length; i++) {
            $cms.form.setUpChangeMonitor(e[i]);
        }
    };

    function iterateCountdown(dif) {
        var st = document.getElementById('quiz_timer');
        var newValue = window.parseInt($cms.dom.html(st)) + dif;
        if (newValue >= 0) {
            $cms.dom.html(st, newValue);
        }

        var st2 = document.getElementById('quiz_timer_minutes_and_seconds');
        if (st2) {
            if (newValue >= 0) {
                var v = '';
                v += Math.floor(newValue / 60);
                v += ':';
                if (newValue % 60 < 10) v += '0';
                v += newValue % 60;
                $cms.dom.html(st2, v);
            }
        }
    }
}(window.$cms));

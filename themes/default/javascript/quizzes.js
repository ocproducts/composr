(function ($cms) {

    $cms.templates.quizScreen = function quizScreen(params) {
        var container = this,
            form = $cms.dom.$(container, '.js-quiz-form'),
            timeout = +params.timeout || 0;

        $cms.dom.on(container, 'submit', '.js-submit-check-form', function (e, form) {
            if (!check_form(form)) {
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
            set_up_change_monitor(e[i]);
        }
    };

    function iterateCountdown(dif) {
        var st = document.getElementById('quiz_timer');
        var new_value = window.parseInt($cms.dom.html(st)) + dif;
        if (new_value >= 0) {
            $cms.dom.html(st, new_value);
        }

        var st2 = document.getElementById('quiz_timer_minutes_and_seconds');
        if (st2) {
            if (new_value >= 0) {
                var v = '';
                v += Math.floor(new_value / 60);
                v += ':';
                if (new_value % 60 < 10) v += '0';
                v += new_value % 60;
                $cms.dom.html(st2, v);
            }
        }
    }
}(window.$cms));

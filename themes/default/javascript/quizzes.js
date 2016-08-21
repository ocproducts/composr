(function ($, Composr) {

    Composr.templates.quizzes = {
        quizScreen: function quizScreen(options) {
            var timeout = Number(options.timeout);

            if (timeout > 0) {
                setTimeout(function () {
                    document.getElementById('quiz_form').submit();
                }, timeout * 1000);

                setInterval(function () {
                    iterateCountdown(-1);
                }, 1000);
                iterateCountdown(0); // Because quiz_timer_minutes_and_seconds needs setting correctly
            }

            var e = document.getElementById('quiz_form').querySelectorAll('.field_input');
            for (var i = 0; i < e.length; i++) {
                set_up_change_monitor(e[i].childNodes[0]);
            }
        }
    };

    Composr.behaviors.quizzes = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_abstract_interfaces');
            }
        }
    };

    function iterateCountdown(dif) {
        var st = document.getElementById('quiz_timer');
        var new_value = window.parseInt(get_inner_html(st)) + dif;
        if (new_value >= 0) {
            set_inner_html(st, new_value);
        }

        var st2 = document.getElementById('quiz_timer_minutes_and_seconds');
        if (st2) {
            if (new_value >= 0) {
                var v = '';
                v += Math.floor(new_value / 60);
                v += ':';
                if (new_value % 60 < 10) v += '0';
                v += new_value % 60;
                set_inner_html(st2, v);
            }
        }
    }
})(window.jQuery || window.Zepto, Composr);

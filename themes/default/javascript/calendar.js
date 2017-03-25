(function ($cms) {
    'use strict';

    $cms.functions.cmsCalendarRunStart = function cmsCalendarRunStart() {
        var form = document.getElementById('recurrence_pattern').form,
            start = document.getElementById('start'),
            start_day = document.getElementById('start_day'),
            start_month = document.getElementById('start_month'),
            start_year = document.getElementById('start_year'),
            start_time = document.getElementById('start_time'),
            start_hour = document.getElementById('start_hour'),
            start_minute = document.getElementById('start_minute'),
            end_time = document.getElementById('end_time'),
            end_hour = document.getElementById('end_hour'),
            end_minute = document.getElementById('end_minute'),
            do_timezone_conv = document.getElementById('do_timezone_conv'),
            all_day_event = document.getElementById('all_day_event');

        crf();
        for (var i = 0; i < form.elements['recurrence'].length; i++) {
            form.elements['recurrence'][i].addEventListener('click', crf);
        }

        if (start_day) {
            start_day.addEventListener('change', crf);
            start_month.addEventListener('change', crf);
            start_year.addEventListener('change', crf);
        } else {
            start.addEventListener('change', crf);
        }
        if (start_hour) {
            start_hour.addEventListener('change', crf);
            start_minute.addEventListener('change', crf);
        } else {
            start_time.addEventListener('change', crf);
        }

        crf2();
        document.getElementById('all_day_event').onclick = crf2;

        form.addEventListener('submit', function () {
            if (typeof form.elements['end_day'] != 'undefined' && form.elements['end_day'].selectedIndex != 0 || typeof form.elements['end'] != 'undefined' && form.elements['end'].value != '') {
                var start_date, end_date;
                if (start_day) {
                    start_date = new Date(window.parseInt(form.elements['start_year'].value), window.parseInt(form.elements['start_month'].value) - 1, window.parseInt(form.elements['start_day'].value), window.parseInt(form.elements['start_hour'].value), window.parseInt(form.elements['start_minute'].value));
                    end_date = new Date(window.parseInt(form.elements['end_year'].value), window.parseInt(form.elements['end_month'].value) - 1, window.parseInt(form.elements['end_day'].value), window.parseInt(form.elements['end_hour'].value), window.parseInt(form.elements['end_minute'].value));
                } else {
                    start_date = start.value;
                    end_date = end.value;
                }

                if (start_date > end_date) {
                    $cms.ui.alert('{!EVENT_CANNOT_AROUND;}');
                    return false;
                }
            }
        });

        function crf(event) {
            var s = (form.elements['recurrence'][0].checked);
            if (form.elements['recurrence_pattern']) form.elements['recurrence_pattern'].disabled = s;
            if (form.elements['recurrences']) form.elements['recurrences'].disabled = s;
            if (form.elements['seg_recurrences']) form.elements['seg_recurrences'].disabled = s;

            var has_date_set = false;
            if (start_day) {
                has_date_set = (start_day.selectedIndex != 0) && (start_month.selectedIndex != 0) && (start_year.selectedIndex != 0);
            } else {
                has_date_set = (start.value != '');
            }

            if ((typeof event != 'undefined') && (has_date_set)) { // Something changed
                var url = 'calendar_recurrence_suggest';
                url += '&monthly_spec_type=' + encodeURIComponent(radio_value(form.elements['monthly_spec_type']));
                if (start_day) {
                    url += '&date_day=' + encodeURIComponent(start_day.options[start_day.selectedIndex].value);
                    url += '&date_month=' + encodeURIComponent(start_month.options[start_month.selectedIndex].value);
                    url += '&date_year=' + encodeURIComponent(start_year.options[start_year.selectedIndex].value);
                } else {
                    url += '&date=' + encodeURIComponent(start.value);
                }
                if (start_hour) {
                    url += '&date_time_hour=' + encodeURIComponent(start_hour.options[start_hour.selectedIndex].value);
                    url += '&date_time_minute=' + encodeURIComponent(start_minute.options[start_minute.selectedIndex].value);
                } else {
                    url += '&date_time=' + encodeURIComponent(start_time.value);
                }
                url += '&do_timezone_conv=' + (do_timezone_conv.checked ? '1' : '0');
                url += '&all_day_event=' + (all_day_event.checked ? '1' : '0');
                var new_data = load_snippet(url);
                var tr = form.elements['monthly_spec_type'][0];
                while (tr.nodeName.toLowerCase() != 'tr') {
                    tr = tr.parentNode;
                }
                $cms.dom.html(tr, new_data.replace(/<tr [^>]*>/, '').replace(/<\/tr>/, ''));
            }
            var monthly_recurrence = form.elements['recurrence'][3].checked;
            for (var i = 0; i < form.elements['monthly_spec_type'].length; i++) {
                form.elements['monthly_spec_type'][i].disabled = !monthly_recurrence;
            }
        }

        function crf2() {
            var s = document.getElementById('all_day_event').checked;
            if (start_hour) {
                start_hour.disabled = s;
                start_minute.disabled = s;
            } else {
                start_time.disabled = s;
            }
            if (end_hour) {
                end_hour.disabled = s;
                end_minute.disabled = s;
            } else {
                end_time.disabled = s;
            }
        }
    };

    $cms.templates.calendarEventType = function calendarEventType(params, container) {
        $cms.dom.on(container, 'click', '.js-click-toggle-checkbox-event-type', function (e, el) {
            var checkbox = el.querySelector('.js-checkbox-event-type');

            if (e.target !== checkbox) {
                $cms.dom.toggleChecked(checkbox);
            }

        });
    };
}(window.$cms));
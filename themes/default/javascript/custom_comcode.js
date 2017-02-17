(function ($cms) {
    'use strict';

    $cms.functions.moduleAdminCustomComcode = function moduleAdminCustomComcode() {
        var update_func = function () {
            var e = document.getElementById('example');
            e.value = '[' + tag.value;
            var i = 0, param;
            do {
                param = document.getElementById('parameters_' + i);
                if ((param) && (param.value != '')) {
                    e.value += ' ' + param.value.replace('=', '="') + '"';
                }
                i++;
            } while (param != null);
            e.value += '][/' + tag.value + ']';
        };

        var tag = document.getElementById('tag');
        var i = 0, param;
        do {
            param = document.getElementById('parameters_' + i);
            if (param) {
                param.addEventListener('blur', update_func);
            }
            i++;
        } while (param != null);
        tag.addEventListener('blur', function () {
            update_func();
            var title = document.getElementById('title');
            if (title.value == '') {
                title.value = tag.value.substr(0, 1).toUpperCase() + tag.value.substring(1, tag.value.length).replace(/\_/g, ' ');
            }
        });
    };

    $cms.functions.moduleAdminCustomComcodeRunStart = function moduleAdminCustomComcodeRunStart() {
        var form = document.getElementById('main_form');
        form.addEventListener('submit', function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;^,snippet}?snippet=exists_tag&name=' + encodeURIComponent(form.elements['tag'].value);
            if (!do_ajax_field_test(url)) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
        });
    };

}(window.$cms));
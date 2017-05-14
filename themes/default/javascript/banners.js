(function ($cms) {
    'use strict';

    $cms.functions.getBannerFormFields = function getBannerFormFields() {
        if (document.getElementById('campaignremaining')) {
            var form = document.getElementById('campaignremaining').form;
            var crf = function () {
                form.elements['campaignremaining'].disabled = (!form.elements['the_type'][1].checked);
            };
            crf();
            form.elements['the_type'][0].addEventListener('click', crf);
            form.elements['the_type'][1].addEventListener('click', crf);
            form.elements['the_type'][2].addEventListener('click', crf);
        }
    };

    $cms.functions.moduleCmsBannersRunStart = function moduleCmsBannersRunStart() {
        document.getElementById("importancemodulus").onkeyup = function () {
            var _imHere = document.getElementById("im_here");
            if (_imHere) {
                var _imTotal = document.getElementById("im_total"),
                    imHere = window.parseInt(document.getElementById("importancemodulus").value),
                    imTotal = window.parseInt(_imTotal.className.replace("im_", "")) + imHere;

                $cms.dom.html(_imHere, imHere);
                $cms.dom.html(document.getElementById("im_here_2"), imHere);
                $cms.dom.html(_imTotal, imTotal);
                $cms.dom.html(document.getElementById("im_total_2"), imTotal);
            }
        }
    };

    $cms.functions.moduleCmsBannersRunStartAdd = function moduleCmsBannersRunStartAdd() {
        var form = document.getElementById('main_form');
        form.addEventListener('submit', function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=exists_banner&name=' + encodeURIComponent(form.elements['name'].value);
            if (!$cms.form.doAjaxFieldTest(url)) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
        });
    };

    $cms.functions.moduleCmsBannersRunStartAddCategory = function moduleCmsBannersRunStartAddCategory() {
        var form = document.getElementById('main_form');
        form.onsubmit = (function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=exists_banner_type&name=' + encodeURIComponent(form.elements['new_id'].value);
            if (!$cms.form.doAjaxFieldTest(url)) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
        });
    };
}(window.$cms));

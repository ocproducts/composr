(function ($cms) {
    'use strict';

    $cms.functions.getBannerFormFields = function getBannerFormFields() {
        if (document.getElementById('campaignremaining')) {
            var form = document.getElementById('campaignremaining').form;
            var crf = function () {
                form.elements['campaignremaining'].disabled = (!form.elements['the_type'][1].checked);
            };
            crf();
            form.elements['the_type'][0].onclick = crf;
            form.elements['the_type'][1].onclick = crf;
            form.elements['the_type'][2].onclick = crf;
        }
    };

}(window.$cms));

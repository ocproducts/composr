(function ($cms) {
    'use strict';

    $cms.functions.moduleCmsDownloads = function moduleCmsDownloads() {
        var url = document.getElementById('file__url'),
            form = document.getElementsByName('file_size')[0].form;

        crf();
        url.onchange = crf;
        url.onkeyup = crf;

        var cost = document.getElementById('cost');

        if (cost) {
            form = cost.form;
            crf2();
            cost.onchange = crf2;
            cost.onkeyup = crf2;
        }

        function crf() {
            var s = url.value !== '';
            if (form.elements['copy_to_server']) {
                form.elements['copy_to_server'].disabled = !s;
            }
            if (form.elements['file_size']) {
                form.elements['file_size'].disabled = !s;
            }
        }

        function crf2() {
            var s = (cost.value !== '') && (cost.value !== '0');
            if (form.elements['submitter_gets_points']) {
                form.elements['submitter_gets_points'].disabled = !s;
            }
        }
    };
}(window.$cms));

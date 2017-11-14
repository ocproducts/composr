(function ($cms) {
    'use strict';

    $cms.templates.adminZoneSearch = function adminZoneSearch(params, container) {
        var hiddensEl = $dom.$(container, '.js-adminzone-search-hiddens');

        $dom.on(container, 'click', '.js-click-btn-admin-search', function (e, btn) {
            var form = btn.form;

            $dom.html(hiddensEl, btn.dataset.tpHiddens);

            form.action = strVal(btn.dataset.tpActionUrl);
            form.target = (form['new_window'] && form['new_window'].checked) ? '_blank' : '_top';
        });

        $dom.on(container, 'click', '.js-click-btn-admin-search-tutorials', function (e, btn) {
            var form = btn.form;

            $dom.html(hiddensEl, btn.dataset.tpHiddens);

            form.action = strVal(btn.dataset.tpActionUrl);
            form.target = '_blank';
        });
    };
}(window.$cms));

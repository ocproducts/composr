(function ($cms, $util, $dom) {
    'use strict';

    $cms.templates.securityScreen = function securityScreen(params, container) {
        $dom.on(container, 'click', '.js-click-btn-delete-add-form-marked-posts', function (e, btn) {
            if ($cms.form.addFormMarkedPosts(btn.form, 'del_')) {
                $cms.ui.disableButton(btn);
            } else {
                e.preventDefault();
                $cms.ui.alert('{!NOTHING_SELECTED;}');
            }

        });
    };
}(window.$cms, window.$util, window.$dom));

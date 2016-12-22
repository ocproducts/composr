(function ($cms) {
    'use strict';

    $cms.templates.securityScreen = function securityScreen(params, container) {
        $cms.dom.on(container, 'click', '.js-click-btn-delete-add-form-marked-posts', function (e, btn) {
            if (add_form_marked_posts(btn.form, 'del_')) {
                $cms.ui.disableButton(btn);
            } else {
                e.preventDefault();
                window.fauxmodal_alert('{!NOTHING_SELECTED;}');
            }

        });
    };
}(window.$cms));

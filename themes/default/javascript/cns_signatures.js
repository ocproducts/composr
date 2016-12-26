(function ($cms) {
    'use strict';

    $cms.functions.moduleWarningsGetFormFields = function moduleWarningsGetFormFields() {
        document.getElementById('message').disabled = true;
        document.getElementById('add_private_topic').onclick = function() {
            document.getElementById('message').disabled = !document.getElementById('add_private_topic').checked;
        }
    };

    $cms.functions.hookProfilesTabsEditSignatureRenderTab = function hookProfilesTabsEditSignatureRenderTab(size) {
        size = strVal(size);

        var form = document.getElementById('signature').form;
        form.old_submit = form.onsubmit;
        form.onsubmit = function () {
            var post = form.elements.signature;

            if ((!post.value) && (post[1])) {
                post = post[1];
            }
            if (post.value.length > size) {

                window.fauxmodal_alert('{!SIGNATURE_TOO_BIG;^}');
                return false;
            }
            if (form.old_submit) {
                return form.old_submit();
            }
            return true;
        };
    };
}(window.$cms));

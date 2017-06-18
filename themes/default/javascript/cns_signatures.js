(function ($cms) {
    'use strict';

    $cms.functions.moduleWarningsGetFormFields = function moduleWarningsGetFormFields() {
        document.getElementById('message').disabled = true;
        document.getElementById('add_private_topic').addEventListener('click', function () {
            document.getElementById('message').disabled = !document.getElementById('add_private_topic').checked;
        });
    };

    $cms.functions.hookProfilesTabsEditSignatureRenderTab = function hookProfilesTabsEditSignatureRenderTab(size) {
        size = strVal(size);

        var form = document.getElementById('signature').form;
        form.addEventListener('submit', function () {
            var post = form.elements.signature;

            if ((!post.value) && (post[1])) {
                post = post[1];
            }
            if (post.value.length > size) {
                $cms.ui.alert('{!SIGNATURE_TOO_BIG;^}');
                return false;
            }
        });
    };
}(window.$cms));

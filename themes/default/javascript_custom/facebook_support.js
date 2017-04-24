(function ($cms) {
    'use strict';

    $cms.templates.facebookFooter = function facebookFooter(params) {
        if (params.facebookAppid !== '') {
            facebook_init(params.facebookAppid, $cms.baseUrl('facebook_connect.php'), (params.fbConnectFinishingProfile || params.fbConnectLoggedOut), (params.fbConnectUid === '' ? null : params.fbConnectUid), '{$PAGE_LINK;/,:}', '{$PAGE_LINK;/,:login:logout}');
        }
    };
}(window.$cms));
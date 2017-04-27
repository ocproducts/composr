(function ($cms) {
    'use strict';

    $cms.templates.blockMainScreenActions = function blockMainScreenActions(params, container) {
        var easySelfUrl = encodeURIComponent(strVal(params.easySelfUrl));

        $cms.dom.on(container, 'click', '.js-click-add-to-twitter', function (e, el) {
            el.setAttribute('href','http://twitter.com/share?count=horizontal&counturl=' + easySelfUrl + '&original_referer=' + easySelfUrl + '&text='+encodeURIComponent(document.title)+'&url=' + easySelfUrl);
        });
    };

    $cms.templates.blockSidePersonalStatsNo = function blockSidePersonalStatsNo(params, container) {
        $cms.dom.on(container, 'submit', '.js-submit-check-username-for-blankness', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });
    };

    $cms.templates.cnsGuestBar = function cnsGuestBar(params, container) {
        $cms.dom.on(container, 'submit', '.js-submit-check-username-for-blankness', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-confirm-remember-me', function (e, checkox) {
            if (checkox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}', function (answer) {
                    if (!answer) {
                        checkox.checked = false;
                    }
                });
            }
        });
    };

    $cms.templates.facebookFooter = function facebookFooter(params) {
        if (params.facebookAppid !== '') {
            facebook_init(params.facebookAppid, $cms.baseUrl('facebook_connect.php'), (params.fbConnectFinishingProfile || params.fbConnectLoggedOut), (params.fbConnectUid === '' ? null : params.fbConnectUid), '{$PAGE_LINK;/,:}', '{$PAGE_LINK;/,:login:logout}');
        }
    };
}(window.$cms));
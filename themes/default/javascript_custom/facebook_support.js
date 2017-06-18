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
        var facebookAppid = strVal(params.facebookAppid);
        if (facebookAppid !== '') {
            facebookInit(facebookAppid, $cms.baseUrl('facebook_connect.php'), (params.fbConnectFinishingProfile || params.fbConnectLoggedOut), (params.fbConnectUid === '' ? null : params.fbConnectUid), '{$PAGE_LINK;,:}', '{$PAGE_LINK;,:login:logout}');
        }
    };

    $cms.functions.hookSyndicationFacebook_syndicationJavascript = function () {
        var fbButton = document.getElementById('syndicate_start__facebook');
        if (fbButton) {
            var fbInput;
            if (typeof fbButton.form.elements['facebook_syndicate_to_page'] == 'undefined') {
                fbInput = document.createElement('input');
                fbInput.type = 'hidden';
                fbInput.name = 'facebook_syndicate_to_page';
                fbInput.value = '0';
                fbButton.form.appendChild(fbInput);
            } else {
                fbInput = fbButton.form.elements['facebook_syndicate_to_page'];
            }
            fbButton.addEventListener('click', function listener() {
                $cms.ui.generateQuestionUi(
                    '{!facebook:HOW_TO_SYNDICATE_DESCRIPTION;^}',
                    ['{!INPUTSYSTEM_CANCEL;^}', '{!FACEBOOK_PAGE;^}', '{!FACEBOOK_WALL;^}'],
                    '{!HOW_TO_SYNDICATE;^}',
                    $cms.format('{!SYNDICATE_TO_OWN_WALL;^}', $cms.$SITE_NAME()),
                    function (val) {
                        if (val != '{!INPUTSYSTEM_CANCEL;^}') {
                            fbInput.value = (val == '{!FACEBOOK_PAGE;^}') ? '1' : '0';
                            fbButton.removeEventListener('click', listener);
                            fbButton.click();
                        }
                    }
                );

                return false;
            });
        }
    };

    function facebookInit(appId, channelUrl, justLoggedOut, serversideFbuid, homePageUrl, logoutPageUrl) {
        window.fbAsyncInit = function fbAsyncInit() {
            window.FB.init({
                appId: appId,
                channelUrl: channelUrl,
                status: true,
                cookie: true,
                xfbml: true
            });

            // Ignore floods of "Unsafe JavaScript attempt to access frame with URL" errors in Chrome they are benign

            /*{+START,IF,{$CONFIG_OPTION,facebook_allow_signups}}*/

            // Calling this effectively waits until the login is active on the client side, which we must do before we can do anything (including calling a log out)
            window.FB.getLoginStatus(function (response) {
                if ((response.status == 'connected') && (response.authResponse)) {
                    // If Composr is currently logging out, tell FB connect to disentangle
                    // Must have JS FB login before can instruct to logout. Will not re-auth -- we know we have authed due to FB_CONNECT_LOGGED_OUT being set
                    if (justLoggedOut) {
                        window.FB.logout(function (response) {
                            $cms.log('Facebook: Logged out.');
                        });
                    }

                    // Facebook has automatically rebuilt its expired fbsr cookie, auth.login not triggered as already technically logged in
                    else {
                        if (serversideFbuid === null)  { // Definitive mismatch between server-side and client-side, so we must refresh
                            facebookTriggerRefresh(homePageUrl);
                        }
                    }

                    // Leech extra code to the Facebook logout action to logout links
                    var forms = document.getElementsByTagName('form');
                    for (var i = 0; i < forms.length; i++) {
                        if (forms[i].action.includes(logoutPageUrl)) {
                            forms[i].addEventListener('submit', (function (logoutLink) {
                                window.FB.logout(function (response) {
                                    $cms.log('Facebook: Logged out.');
                                    window.location = logoutLink;
                                });
                                // We cancel the form submit, as we need to wait for the AJAX request to happen
                                return false;
                            }).bind(undefined, forms[i].action));
                        }
                    }
                }
            });

            if (serversideFbuid === null) { // If not already in a Composr Facebook login session we may need to listen for explicit new logins
                window.FB.Event.subscribe('auth.login', function (response) { // New login status arrived - so a Composr Facebook login session should be established, or ignore as we are calling a logout within this request (above)
                    if (!justLoggedOut) { // Check it is not that logout
                        // ... and therefore refresh to let Composr server-side re-sync, as this was a new login initiated just now on the client side
                        if ((response.status == 'connected') && (response.authResponse)) { // Check we really are logged in, in case this event calls without us being
                            facebookTriggerRefresh(homePageUrl);
                        }
                    }
                });
            }
            /*{+END}*/
        };

        // Load the SDK Asynchronously
        (function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s);
            js.id = id;
            js.src = '//connect.facebook.net/en_US/all.js#xfbml=1&appId={$CONFIG_OPTION;,facebook_appid}';
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
    }

    function facebookTriggerRefresh(homePageUrl) {
        window.setTimeout(function () { // Firefox needs us to wait a bit
            if (document.querySelector('failover')) {
                return;
            }

            if ((window.location.href.indexOf('login') != -1) && (window == window.top)) {
                window.location = homePageUrl; // If currently on login screen, should go to home page not refresh
            } else {
                var currentUrl = window.top.location.href;
                if (currentUrl.indexOf('refreshed_once=1') == -1) {
                    currentUrl += ((currentUrl.indexOf('?') == -1) ? '?' : '&') + 'refreshed_once=1';
                    window.top.location = currentUrl;
                }
                else if (currentUrl.indexOf('keep_refreshed_once=1') == -1) {
                    //window.alert('Could not login, probably due to restrictive cookie settings.');
                    window.top.location = window.top.location.toString() + '&keep_refreshed_once=1';
                }
            }
        }, 500);
    }
}(window.$cms));

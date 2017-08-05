'use strict';

(function ($cms) {
    'use strict';

    $cms.views.ChatRoomScreen = ChatRoomScreen;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function ChatRoomScreen(params) {
        ChatRoomScreen.base(this, 'constructor', arguments);
        this.chatroomId = strVal(params.chatroomId);

        window.$cmsLoad.push(function () {
            chatLoad(params.chatroomId);
        });
    }

    $cms.inherits(ChatRoomScreen, $cms.View, /**@lends ChatRoomScreen#*/{
        events: function () {
            return {
                'click .js-btn-toggle-chat-comcode-panel': 'toggleChatPanel',
                'click select.js-select-click-font-change': 'fontChange',
                'change select.js-select-change-font-change': 'fontChange',
                'submit form.js-form-submit-check-chat-options': 'checkChatOptions',
                'click .js-click-post-chat-message': 'postChatMessage',
                'keypress .js-keypress-enter-post-chat': 'enterChatMessage',
                'change .js-change-input-text-color': 'changeInputTextColor',
                'click .js-click-open-emoticon-chooser-window': 'openEmoticonChooserWindow'
            };
        },

        toggleChatPanel: function () {
            $cms.ui.toggleableTray($cms.dom.$('#chat_comcode_panel'));
        },

        fontChange: function (e, selectEl) {
            this.$('#font').value = selectEl.value;
            this.$('#post').style.fontFamily = selectEl.value;
            $cms.manageScrollHeight(this.$('#post'));
        },

        checkChatOptions: function (e, form) {
            if (!form.elements['text_colour'].value.match(/^#[0-9A-F][0-9A-F][0-9A-F]([0-9A-F][0-9A-F][0-9A-F])?$/)) {
                $cms.ui.alert('{!chat:BAD_HTML_COLOUR;^}');
                e.preventDefault();
                return;
            }

            if ($cms.form.checkForm(form) === false) {
                e.preventDefault();
            }
        },

        postChatMessage: function (e) {
            chatPost(e, this.chatroomId, 'post', this.$('#font_name').value, this.$('#text_colour').value);
        },

        enterChatMessage: function (e) {
            if ($cms.dom.keyPressed(e, 'Enter')) {
                this.postChatMessage(e);
            }
        },

        changeInputTextColor: function (e, input) {
            if (input.value && /^#[0-9A-F]{3}([0-9A-F]{3})?$/i.test(input.value)) {
                input.style.color = input.value;
                this.$('#colour').value = input.value;
            }
        },

        openEmoticonChooserWindow: function () {
            $cms.ui.open($cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,emoticons}?field_name=post' + $cms.$KEEP()), 'emoticon_chooser', 'width=300,height=320,status=no,resizable=yes,scrollbars=no');
        }
    });

    $cms.templates.chatSound = function chatSound(params) { // Prepares chat sounds
        if (window.preparedChatSounds) {
            return;
        }
        window.preparedChatSounds = true;

        window.soundManager.setup({
            url: $cms.baseUrl('data'),
            debugMode: false,
            onready: function () {
                var soundEffects = params.soundEffects,
                    i;

                for (i in soundEffects) {
                    window.soundManager.createSound(soundEffects[i].key, soundEffects[i].value);
                }
            }
        });
    };

    $cms.templates.chatFriends = function chatFriends(params, container) {
        var friends = arrVal(params.friends), friend;

        for (var i = 0; i < friends.length; i++) {
            friend = friends[i];

            if (friend.onlineText !== '{!chat:ACTIVE;^}') {
                $cms.dom.$('#friend_img_' + friend.memberId).className = 'friend_inactive';
            }
        }

        $cms.dom.on(container, 'click', '.js-click-start-friend-im', function (e, link) {
            var memberId = strVal(link.dataset.tpMemberId);

            if (startIm(memberId, true) === false) {
                e.preventDefault();
            }
        });
    };

    $cms.templates.chatcodeEditorButton = function chatcodeEditorButton(params, btn) {
        var b = strVal(params.b);

        $cms.dom.on(btn, 'click', function () {
            window['doInput' + $cms.ucFirst(b)]('post');
        });
    };

    $cms.templates.chatcodeEditorMicroButton = function chatcodeEditorMicroButton(params, btn) {
        var b = strVal(params.b);

        $cms.dom.on(btn, 'click', function () {
            window['doInput' + $cms.ucFirst(b)]('post');
        });
    };

    $cms.templates.comcodeEditorMicroButton = function comcodeEditorMicroButton(params, btn) {
        var b = strVal(params.b),
            fieldName = strVal(params.fieldName);

        $cms.dom.on(btn, 'click', function () {
            window['doInput' + $cms.ucFirst(b)](fieldName);
        });
    };

    $cms.templates.chatLobbyImArea = function chatLobbyImArea(params, container) {
        var chatroomId = strVal(params.chatroomId);

        window.$cmsLoad.push(function () {
            try {
                $cms.dom.$('#post_' + chatroomId).focus();
            } catch (e) {}
            $cms.dom.$('#post_' + chatroomId).value = $cms.readCookie('last_chat_msg_' + chatroomId);
        });

        $cms.dom.on(container, 'click', '.js-click-chatroom-chat-post', function (e) {
            chatPost(e, chatroomId, 'post_' + chatroomId, '', '');
        });

        $cms.dom.on(container, 'click', '.js-click-open-chat-emoticons-popup', function () {
            var openFunc = (window.opener ? window.open : $cms.ui.open),
                popupUrl = strVal(params.emoticonsPopupUrl);

            openFunc($cms.maintainThemeInLink(popupUrl), 'emoticon_chooser', 'width=300,height=320,status=no,resizable=yes,scrollbars=no');
        });

        $cms.dom.on(container, 'click', '.js-click-close-chat-conversation', function () {
            closeChatConversation(chatroomId);
        });

        $cms.dom.on(container, 'keypress', '.js-keypress-eat-enter', function (e) {
            if ($cms.dom.keyPressed(e, 'Enter')) {
                e.preventDefault()
            }
        });

        $cms.dom.on(container, 'keyup', '.js-keyup-textarea-chat-post', function (e, textarea) {
            if (!$cms.$MOBILE()) {
                $cms.manageScrollHeight(textarea);
            }

            if ($cms.dom.keyPressed(e, 'Enter')) {
                $cms.setCookie('last_chat_msg_' + chatroomId, '');
                chatPost(e, chatroomId, 'post_' + chatroomId, '', '');
                e.preventDefault();
            } else {
                $cms.setCookie('last_chat_msg_' + chatroomId, textarea.value);
            }
        });
    };

    $cms.templates.chatLobbyScreen = function chatLobbyScreen(params, container) {
        if ($cms.$IS_GUEST()) {
            return;
        }

        window.imAreaTemplate = params.imAreaTemplate;
        window.imParticipantTemplate = params.imParticipantTemplate;
        window.topWindow = window;

        window.loadFromRoomId = -1;
        if ((window.chatCheck)) {
            chatCheck(true, 0);
        } else {
            setTimeout(beginImChatting, 500);
        }

        $cms.dom.on(container, 'click', '.js-click-btn-im-invite-ticked-people', function (e, btn) {
            var people = getTickedPeople(btn.form);
            if (people) {
                inviteIm(people);
            }
        });

        $cms.dom.on(container, 'click', '.js-click-btn-im-start-ticked-people', function (e, btn) {
            var people = getTickedPeople(btn.form);
            if (people) {
                startIm(people);
            }
        });

        $cms.dom.on(container, 'click', '.js-click-btn-dump-friends-confirm', function (e, btn) {
            var people = getTickedPeople(btn.form);
            if (people) {
                $cms.ui.confirm('{!Q_SURE=;}', function (result) {
                    if (result) {
                        $cms.ui.disableButton(btn);
                        btn.form.submit();
                    }
                });
            }
        });

        $cms.dom.on(container, 'keyup', '.js-keyup-input-update-ajax-member-list', function (e, btn) {
            $cms.form.updateAjaxMemberList(btn, null, false, e);
        });

        $cms.dom.on(container, 'submit', '.js-form-submit-add-friend', function (e, form) {
            $cms.loadSnippet('im_friends_rejig&member_id=' + params.memberId, 'add=' + encodeURIComponent(form.elements['friend_username'].value), true).then(function (ajaxResult) {
                $cms.dom.html($cms.dom.$('#friends_wrap'), ajaxResult.responseText);
                form.elements['friend_username'].value = '';
            });
        });

        function beginImChatting() {
            window.loadFromRoomId = -1;
            if ((window.chatCheck)) {
                chatCheck(true, 0);
            } else {
                setTimeout(beginImChatting, 100);
            }
        }
    };

    $cms.templates.chatModerateScreen = function chatModerateScreen(params, container) {
        $cms.dom.on(container, 'click', '.js-click-btn-delete-marked-posts', function (e, btn) {
            if ($cms.form.addFormMarkedPosts(btn.form, 'del_')) {
                $cms.ui.disableButton(btn);
            } else {
                $cms.ui.alert('{!NOTHING_SELECTED=;}');
                e.preventDefault();
            }
        });
    };

    $cms.templates.chatLobbyImParticipant = function chatLobbyImParticipant(params, container) {
        $cms.dom.on(container, 'click', '.js-click-hide-self', function (e, clicked) {
            $cms.dom.hide(clicked);
        });
    };

    $cms.templates.chatSiteWideImPopup = function (params) {
        window.detectIfChatWindowClosedChecker = setInterval(function () {
            if (detectIfChatWindowClosed !== undefined) {
                detectIfChatWindowClosed();
            }
        }, 5);

        function detectIfChatWindowClosed(dieOnLost, becomeAutonomousOnLost) {
            var lostConnection = false;
            try {
                /*if ($cms.browserMatches('non_concurrent'))    Pointless as document.write doesn't work on iOS without tabbing back and forth, so initial load is horribly slow in first place
                 {
                 throw 'No multi-process on iOS';
                 }*/

                if ((!window.opener) || (!window.opener.document)) {
                    lostConnection = true;
                } else {
                    var roomId = findCurrentImRoom();
                    if (window.opener.openedPopups['room_' + roomId] === undefined) {
                        var chatLobbyConvosTabs = window.opener.document.getElementById('chat_lobby_convos_tabs');
                        if (chatLobbyConvosTabs) {// Now in the chat lobby, consider this a confirmed loss, because we don't want duplicate IM spaces
                            dieOnLost = true;
                            becomeAutonomousOnLost = false;
                            lostConnection = true;
                        } else {
                            window.opener.openedPopups['room_' + roomId] = window; // Reattach, presumably a navigation has happened

                            if ((window.alreadyAutonomous !== undefined) && (window.alreadyAutonomous)) {// Losing autonomity again?
                                window.topWindow = window.opener;
                                chatCheck(false, window.lastMessageId, window.lastEventId);
                                window.alreadyAutonomous = false;
                            }

                            if (window.opener.console.log !== undefined) {
                                window.opener.console.log('Reattaching chat window to re-navigated master window.');
                            }
                        }
                    }
                }
            } catch (err) {
                lostConnection = true;
            }

            if (lostConnection) {
                if (dieOnLost === undefined) dieOnLost = false;
                if (becomeAutonomousOnLost === undefined) becomeAutonomousOnLost = false;

                if (becomeAutonomousOnLost) { // Becoming autonomous means allowing to work with a master window
                    chatWindowBecomeAutonomous();
                } else if (dieOnLost) {
                    window.isShutdown = true;
                    window.onbeforeunload = null;
                    window.close();
                } else {
                    if ((window.alreadyAutonomous === undefined) || (!window.alreadyAutonomous)) {
                        setTimeout(function () {
                            detectIfChatWindowClosed(false, true);
                        }, 3000); // If connection still lost after this time then kill the window
                    }
                }
            }

            function chatWindowBecomeAutonomous() {
                if ((window.alreadyAutonomous === undefined) || (!window.alreadyAutonomous)) {
                    window.topWindow = window;
                    chatCheck(false, window.lastMessageId, window.lastEventId);
                    window.alreadyAutonomous = true;
                }
            }
        }
    };

    $cms.templates.blockMainFriendsList = function (params, container) {
        if (params.wrapperId && params.blockCallUrl) {
            internaliseAjaxBlockWrapperLinks(params.blockCallUrl, document.getElementById(params.wrapperId), ['.*'], {}, false, true);
        }

        $cms.dom.on(container, 'keyup', '.js-input-friends-search', function (e, input) {
            $cms.form.updateAjaxSearchList(input, e);
        });
    };

    $cms.templates.blockSideShoutbox = function (params, container) {
        internaliseAjaxBlockWrapperLinks(params.blockCallUrl, document.getElementById(params.wrapperId), [], {}, false, true);

        $cms.dom.on(container, 'submit', 'form.js-form-submit-side-shoutbox', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['shoutbox_message'], e)) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });
    };

    $cms.templates.chatSiteWideIm = function (params) {
        if (!params.matched) {
            return;
        }

        window.imAreaTemplate = params.imAreaTemplate;
        window.imParticipantTemplate = params.imParticipantTemplate;
        window.topWindow = window;
        window.lobbyLink = params.lobbyLink;
        window.participants = '';

        window.$cmsReady.push(function () {
            if (!window.loadFromRoomId) { // Only if not in chat lobby or chatroom, so as to avoid conflicts
                beginImChatting();
            }
        });

        function beginImChatting() {
            window.loadFromRoomId = -1;
            if ((window.chatCheck)) {
                chatCheck(true, 0);
            } else {
                setTimeout(beginImChatting, 100);
            }
        }
    };

    $cms.templates.chatSetEffectsSettingBlock = function (params, container) {
        var key = strVal(params.key),
            memberId = strVal(params.memberId);

        if (!$cms.$IS_HTTPAUTH_LOGIN()) {
            var btnSubmitId = 'upload_' + params.key;

            if (memberId) {
                btnSubmitId += '_' + memberId;
            }

            preinitFileInput('chat_effect_settings', btnSubmitId, null, null, 'mp3', 'button_micro');
        }

        $cms.dom.on(container, 'click', '.js-click-require-sound-selection', function () {
            var select = $cms.dom.$('#select_' + key +  (memberId ? ('_' + memberId) : ''));
            if (select.value === '') {
                $cms.ui.alert('{!chat:PLEASE_SELECT_SOUND;}');
            } else {
                playSoundUrl(select.value);
            }
        });
    };

}(window.$cms));

// Constants
window.MESSAGE_CHECK_INTERVAL = +'{$ROUND%,{$MAX,3000,{$CONFIG_OPTION,chat_message_check_interval}}}';
window.TRANSITORY_ALERT_TIME = +'{$ROUND%,{$CONFIG_OPTION,chat_transitory_alert_time}}';
window.LOGS_DOWNLOAD_INTERVAL = 3000;

// Tracking variables
window.lastMessageId = -1;
window.lastTimestamp = 0;
window.lastEventId = -1;
window.messageChecking = false;
window.noImHtml = '';
window.textColour = null;
window.openedPopups = {};
window.loadFromRoomId = null;
window.alreadyReceivedRoomInvites = {};
window.alreadyReceivedContactAlert = {};
window.instantGo = false;
window.isShutdown = false;
window.allConversations = {};

// Code...

function playSoundUrl(url) { // Used for testing different sounds
    if (window.soundManager === undefined) {
        return;
    }

    var baseUrl = ((url.indexOf('data_custom') == -1) && (url.indexOf('uploads/') == -1)) ? '{$BASE_URL_NOHTTP;}' : '{$CUSTOM_BASE_URL_NOHTTP;}';
    var soundObject = window.soundManager.createSound({url: baseUrl + '/' + url});
    if (soundObject) {
        soundObject.play();
    }
}

function playChatSound(sId, forMember) {
    if (window.soundManager === undefined) {
        return;
    }

    var playSound = window.document.getElementById('play_sound');

    if ((playSound) && (!playSound.checked)) {
        return;
    }

    if (forMember) {
        var override = window.topWindow.soundManager.getSoundById(sId + '_' + forMember, true);
        if (override) {
            sId = sId + '_' + forMember;
        }
    }

    if (window.topWindow.console !== undefined) {
        window.topWindow.console.log('Playing ' + sId + ' sound'); // Useful when debugging sounds when testing using SU, otherwise you don't know which window they came from
    }

    window.topWindow.soundManager.play(sId);
}

function chatLoad(roomId) {
    window.topWindow = window;

    try {
        document.getElementById('post').focus();
    } catch (ignore) {}

    if (window.location.href.indexOf('keep_chattest') == -1) beginChatting(roomId);

    window.textColour = document.getElementById('text_colour');
    if (window.textColour) {
        window.textColour.style.color = window.textColour.value;
    }

    $cms.manageScrollHeight(document.getElementById('post'));
}

function beginChatting(roomId) {
    window.loadFromRoomId = roomId;

    chatCheck(true, 0);
    playChatSound('you_connect');
}

function decToHex(number) {
    var hexbase = '0123456789ABCDEF';
    return hexbase.charAt((number >> 4) & 0xf) + hexbase.charAt(number & 0xf);
}

function hexToDec(number) {
    return parseInt(number, 16);
}

function getTickedPeople(form) {
    var people = '';

    for (var i = 0; i < form.elements.length; i++) {
        if ((form.elements[i].type == 'checkbox') && (form.elements[i].checked))
            people += ((people != '') ? ',' : '') + form.elements[i].name.substr(7);
    }

    if (people === '') {
        $cms.ui.alert('{!chat:NOONE_SELECTED_YET;^}');
        return '';
    }

    return people;
}

function doInputPrivate_message(fieldName) {
    if (window.insertTextbox === undefined) {
        return;
    }
    $cms.ui.prompt(
        '{!chat:ENTER_RECIPIENT;^}',
        '',
        function (va) {
            if (va != null) {
                var vb = $cms.ui.prompt(
                    '{!MESSAGE;^}',
                    '',
                    function (vb) {
                        if (vb != null) {
                            insertTextbox(document.getElementById(fieldName), '[private="' + va + '"]' + vb + '[/private]');
                        }
                    },
                    '{!chat:INPUT_CHATCODE_private_message;^}'
                );
            }
        },
        '{!chat:INPUT_CHATCODE_private_message;^}'
    );
}

function doInputInvite(fieldName) {
    if (window.insertTextbox === undefined) {
        return;
    }
    $cms.ui.prompt(
        '{!chat:ENTER_RECIPIENT;^}',
        '',
        function (va) {
            if (va != null) {
                var vb = $cms.ui.prompt(
                    '{!chat:ENTER_CHATROOM;^}',
                    '',
                    function (vb) {
                        if (vb != null) insertTextbox(document.getElementById(fieldName), '[invite="' + va + '"]' + vb + '[/invite]');
                    },
                    '{!chat:INPUT_CHATCODE_invite;^}'
                );
            }
        },
        '{!chat:INPUT_CHATCODE_invite;^}'
    );
}

function doInputNew_room(fieldName) {
    if (window.insertTextbox === undefined) {
        return;
    }
    $cms.ui.prompt(
        '{!chat:ENTER_CHATROOM;^}',
        '',
        function (va) {
            if (va != null) {
                var vb = prompt(
                    '{!chat:ENTER_ALLOW;^}',
                    '',
                    function (vb) {
                        if (vb != null) {
                            insertTextbox(document.getElementById(fieldName), '[newroom="' + va + '"]' + vb + '[/newroom]');
                        }
                    },
                    '{!chat:INPUT_CHATCODE_new_room;^}'
                );
            }
        },
        '{!chat:INPUT_CHATCODE_new_room;^}'
    );
}

// Post a chat message
function chatPost(event, currentRoomId, fieldName, fontName, fontColour) {
    function errorFunc() {
        window.topWindow.currentlySendingMessage = false;
        element.disabled = false;

        // Reschedule the next check (ccTimer was reset already higher up in function)
        window.topWindow.ccTimer = window.topWindow.setTimeout(function () {
            window.topWindow.chatCheck(false, window.topWindow.lastMessageId, window.topWindow.lastEventId);
        }, window.MESSAGE_CHECK_INTERVAL);
    }

    // Catch the data being submitted by the form, and send it through XMLHttpRequest if possible. Stop the form submission if this is achieved.
    var element = document.getElementById(fieldName);
    event && event.stopPropagation();
    var messageText = strVal(element.value);

    if (messageText !== '') {
        if (window.topWindow.ccTimer) {
            window.topWindow.clearTimeout(window.topWindow.ccTimer);
            window.topWindow.ccTimer = null;
        }

        // Reinvite last left member if necessary
        if ((element.forceInvite !== undefined) && (element.forceInvite !== null)) {
            inviteIm(element.forceInvite);
            element.forceInvite = null;
        }

        // Send it through XMLHttpRequest, and append the results.
        var url = '{$FIND_SCRIPT;,messages}?action=post';
        element.disabled = true;
        window.topWindow.currentlySendingMessage = true;
        var func = function (responseXml) {
            window.topWindow.currentlySendingMessage = false;
            element.disabled = false;
            var responses = responseXml.getElementsByTagName('result');
            if (responses[0]) {
                processChatXmlMessages(responses[0], true);

                setTimeout(function () {
                    element.value = '';
                }, 20);
                element.style.height = 'auto';

                playChatSound('message_sent');
            } else {
                $cms.ui.alert('{!chat:MESSAGE_POSTING_ERROR;^}');
            }

            // Reschedule the next check (ccTimer was reset already higher up in function)
            window.topWindow.ccTimer = window.topWindow.setTimeout(function () {
                window.topWindow.chatCheck(false, window.topWindow.lastMessageId, window.topWindow.lastEventId);
            }, window.MESSAGE_CHECK_INTERVAL);

            try {
                element.focus();
            } catch (e) {}
        };
        var fullUrl = $cms.maintainThemeInLink(url + window.topWindow.$cms.keepStub(false));
        var postData = 'room_id=' + encodeURIComponent(currentRoomId) + '&message=' + encodeURIComponent(messageText) + '&font=' + encodeURIComponent(fontName) + '&colour=' + encodeURIComponent(fontColour) + '&message_id=' + encodeURIComponent((window.topWindow.lastMessageId === null) ? -1 : window.topWindow.lastMessageId) + '&event_id=' + encodeURIComponent(window.topWindow.lastEventId);
        $cms.doAjaxRequest(fullUrl, [func, errorFunc], postData);
    }

    return false;
}

// Check for new messages
function chatCheck(backlog, messageId, eventId) {
    function func(responseXml, xhr) {
        chatCheckResponse(responseXml, xhr, backlog/*backlog = skip_incoming_sound*/);
    }

    function errorFunc() {
        chatCheckResponse(null, null);
    }

    if (window.currentlySendingMessage)  { // We'll reschedule once our currently-in-progress message is sent
        return null;
    }

    eventId = intVal(eventId, -1);  // -1 Means, we don't want to look at events, but the server will give us a null event

    // Check for new messages on the server the new or old way
    setTimeout(function () {
        chatCheckTimeout(backlog, messageId, eventId);
    }, window.MESSAGE_CHECK_INTERVAL * 1.2);

    var theDate = new Date();
    if (!window.messageChecking || (window.messageChecking + window.MESSAGE_CHECK_INTERVAL <= theDate.getTime()))  { // If not currently in process, or process stalled
        window.messageChecking = theDate.getTime();
        var url;
        var _roomId = (window.loadFromRoomId == null) ? -1 : window.loadFromRoomId;
        if (backlog) {
            url = '{$FIND_SCRIPT;,messages}?action=all&room_id=' + encodeURIComponent(_roomId);
        } else {
            url = '{$FIND_SCRIPT;,messages}?action=new&room_id=' + encodeURIComponent(_roomId) + '&message_id=' + encodeURIComponent(messageId ? messageId : -1) + '&event_id=' + encodeURIComponent(eventId);
        }
        if (window.location.href.indexOf('no_reenter_message=1') !== -1) {
            url = url + '&no_reenter_message=1';
        }
        var fullUrl = $cms.maintainThemeInLink(url + $cms.keepStub(false));
        $cms.doAjaxRequest(fullUrl, [func, errorFunc]);
        return false;
    }

    return null;
}

// Check to see if there's been a packet loss
function chatCheckTimeout(backlog, messageId, eventId) {
    var theDate = new Date();
    if ((window.messageChecking) && (window.messageChecking <= theDate.getTime() - window.MESSAGE_CHECK_INTERVAL * 1.2) && (!window.currentlySendingMessage)) { // If we are awaiting a response (messageChecking is not false, and that response was made more than 12 seconds ago
        // Our response is tardy - presume we've lost our scheduler / AJAX request, so fire off a new AJAX request and reset the chatCheckTimeout timer
        chatCheck(backlog, messageId, eventId);
    }
}

// Deal with the new messages response. Wraps around processChatXmlMessages as it also adds timers to ensure the message check continues to function even if background errors might have happened.
function chatCheckResponse(responseXml, xhr, skipIncomingSound) {
    var ajaxResult = responseXml && responseXml.querySelector('result');
    
    if (ajaxResult != null) {
        if (skipIncomingSound === undefined) {
            skipIncomingSound = false;
        }

        var temp = processChatXmlMessages(ajaxResult, skipIncomingSound);
        if (temp == -2) {
            return false;
        }
    }

    // Schedule the next check
    if (window.ccTimer) {
        clearTimeout(window.ccTimer);
        window.ccTimer = null;
    }
    window.ccTimer = setTimeout(function () {
        chatCheck(false, window.lastMessageId, window.lastEventId);
    }, window.MESSAGE_CHECK_INTERVAL);

    window.messageChecking = false; // All must be ok so say we are happy we got a response and scheduled the next check

    return true;
}

function processChatXmlMessages(ajaxResult, skipIncomingSound) {
    if (!ajaxResult) { // Some kind of error happened
        return;
    }

    if (skipIncomingSound === undefined) {
        skipIncomingSound = false;
    }

    var messages = ajaxResult.childNodes,
        messageContainer = document.getElementById('messages_window'),
        messageContainerGlobal = (messageContainer != null),
        clonedMessage,
        currentRoomId = window.loadFromRoomId,
        tabElement,
        flashableAlert = false,
        username, roomName, roomId, eventType, memberId, tmpElement, rooms, avatarUrl, participants,
        id, timestamp,
        firstSet = false,
        newestIdHere = null, newestTimestampHere = null,
        cannotProcessAll = false;

    // Look through our messages
    for (var i = 0; i < messages.length; i++) {
        if (messages[i].localName === 'div')  { // MESSAGE
            // Find out about our message
            id = messages[i].getAttribute('id');
            timestamp = messages[i].getAttribute('timestamp');
            if (((window.topWindow.lastMessageId) && (parseInt(id) <= window.topWindow.lastMessageId)) && ((window.topWindow.lastTimestamp) && (parseInt(timestamp) <= window.topWindow.lastTimestamp))) {
                continue;
            }

            // Find container to place message
            if (!messageContainerGlobal) {
                roomId = messages[i].getAttribute('room_id');
                currentRoomId = roomId;
                messageContainer = null;
            } else {
                currentRoomId = messages[i].getAttribute('room_id');
            }

            if (document.getElementById('messages_window_' + currentRoomId)) {
                messageContainer = document.getElementById('messages_window_' + currentRoomId);
                tabElement = document.getElementById('tab_' + currentRoomId);
                if ((tabElement) && (!tabElement.classList.contains('chat_lobby_convos_current_tab'))) {
                    tabElement.className = ((tabElement.classList.contains('chat_lobby_convos_tab_first')) ? 'chat_lobby_convos_tab_first ' : '') + 'chat_lobby_convos_tab_new_messages';
                }
            } else if ((window.openedPopups['room_' + currentRoomId] !== undefined) && (!window.openedPopups['room_' + currentRoomId].isShutdown) && (window.openedPopups['room_' + currentRoomId].document)) { // Popup
                messageContainer = window.openedPopups['room_' + currentRoomId].document.getElementById('messages_window_' + currentRoomId);
            }

            if (!messageContainer) {
                cannotProcessAll = true;
                continue; // Still no luck
            }

            // If we got this far, recognise the message as received
            newestIdHere = parseInt(id);
            if ((newestTimestampHere = null) || (newestTimestampHere < parseInt(timestamp))) {
                newestTimestampHere = parseInt(timestamp);
            }

            var doc = document;
            if (window.openedPopups['room_' + currentRoomId] !== undefined) {
                var popupWin = window.openedPopups['room_' + currentRoomId];
                if (!popupWin.document) { // We have nowhere to put the message
                    cannotProcessAll = true;
                    continue;
                }
                doc = popupWin.document;

                // Feed in details, so if it becomes autonomous, it knows what to run with
                popupWin.lastTimestamp = window.lastTimestamp;
                popupWin.lastEventId = window.lastEventId;
                if ((newestIdHere) && ((popupWin.lastMessageId == null) || (popupWin.lastMessageId < newestIdHere))) {
                    popupWin.lastMessageId = newestIdHere;
                }
                if (popupWin.lastTimestamp < newestTimestampHere)
                    popupWin.lastTimestamp = newestTimestampHere;
            }

            if (doc.getElementById('chat_message__' + id)) { // Already there
                continue;
            }

            // Clone the node so that we may insert it
            clonedMessage = doc.createElement('div');
            $cms.dom.html(clonedMessage, (messages[i].xml !== undefined) ? messages[i].xml/*IE-only optimisation*/ : messages[i].firstElementChild.outerHTML);
            clonedMessage = clonedMessage.firstElementChild;
            clonedMessage.id = 'chat_message__' + id;

            // Non-first message
            if (messageContainer.children.length > 0) {
                if ($cms.$CONFIG_OPTION('chat_message_direction') === 'upwards') {
                    messageContainer.insertBefore(clonedMessage, messageContainer.firstElementChild);
                } else if ($cms.$CONFIG_OPTION('chat_message_direction') === 'downwards') {
                    messageContainer.appendChild(clonedMessage);
                    messageContainer.scrollTop = 1000000;
                }
                
                if (!firstSet) {// Only if no other message sound already for this event update
                    if (!skipIncomingSound) {
                        if (window.playChatSound !== undefined) {
                            playChatSound(document.hidden ?  'message_background' : 'message_received', messages[i].getAttribute('sender_id'));
                        }
                    }
                    flashableAlert = true;
                }
            } else { // First message
                $cms.dom.html(messageContainer, '');
                messageContainer.appendChild(clonedMessage);
                firstSet = true; // Let the code know the first set of messages has started, squashing any extra sounds for this event update
                if (!skipIncomingSound) {
                    playChatSound('message_initial');
                }
            }

            if (!messageContainerGlobal) {
                currentRoomId = -1; // We'll be gathering for all rooms we're in now, because this messaging is coming through the master control window
            }
        } else if (messages[i].nodeName.toLowerCase() === 'chat_members_update') { // UPDATE MEMBERS LIST IN ROOM
            var membersElement = document.getElementById('chat_members_update');
            if (membersElement) $cms.dom.html(membersElement, messages[i].textContent);
        } else if ((messages[i].nodeName.toLowerCase() === 'chat_event') && (window.imParticipantTemplate !== undefined)) { // Some kind of transitory event
            eventType = messages[i].getAttribute('event_type');
            roomId = messages[i].getAttribute('room_id');
            memberId = messages[i].getAttribute('member_id');
            username = messages[i].getAttribute('username');
            avatarUrl = messages[i].getAttribute('avatar_url');

            id = messages[i].textContent;

            switch (eventType) {
                case 'BECOME_ACTIVE':
                    if (window.TRANSITORY_ALERT_TIME != 0) {
                        flashableAlert = true;
                        tmpElement = document.getElementById('online_' + memberId);
                        if (tmpElement) {
                            if ($cms.dom.html(tmpElement).toLowerCase() == '{!chat:ACTIVE;^}'.toLowerCase()) break;
                            $cms.dom.html(tmpElement, '{!chat:ACTIVE;^}');
                            var friendImg = document.getElementById('friend_img_' + memberId);
                            if (friendImg) friendImg.className = 'friend_active';
                            var alertBoxWrap = document.getElementById('alert_box_wrap');
                            if (alertBoxWrap) alertBoxWrap.style.display = 'block';
                            var alertBox = document.getElementById('alert_box');
                            if (alertBox) $cms.dom.html(alertBox, '{!chat:NOW_ONLINE;^}'.replace('{' + '1}', username));
                            setTimeout(function () {
                                if (document.getElementById('alert_box')) // If the alert box is still there, remove it
                                    alertBoxWrap.style.display = 'none';
                            }, window.TRANSITORY_ALERT_TIME);

                            if (!skipIncomingSound) {
                                playChatSound('contact_on', memberId);
                            }
                        } else if (!document.getElementById('chat_lobby_convos_tabs')) {
                            createOverlayEvent(/*skip_incoming_sound*/true, memberId, '{!chat:NOW_ONLINE;^}'.replace('{' + '1}', username), function () {
                                startIm(memberId, true);
                                return false;
                            }, avatarUrl);
                        }
                    }

                    rooms = findImConvoRoomIds();
                    for (var r in rooms) {
                        roomId = rooms[r];
                        var doc = document;
                        if ((window.openedPopups['room_' + roomId] !== undefined) && (!window.openedPopups['room_' + roomId].isShutdown)) {
                            if (!window.openedPopups['room_' + roomId].document) continue;
                            doc = window.openedPopups['room_' + roomId].document;
                        }
                        tmpElement = doc.getElementById('participant_online__' + roomId + '__' + memberId);
                        if (tmpElement) {
                            $cms.dom.html(tmpElement, '{!chat:ACTIVE;^}');
                        }
                    }
                    break;

                case 'BECOME_INACTIVE':
                    var friendBeingTracked = false;
                    tmpElement = document.getElementById('online_' + memberId);
                    if (tmpElement) {
                        if ($cms.dom.html(tmpElement).toLowerCase() == '{!chat:INACTIVE;^}'.toLowerCase()) break;
                        $cms.dom.html(tmpElement, '{!chat:INACTIVE;^}');
                        document.getElementById('friend_img_' + memberId).className = 'friend_inactive';
                        friendBeingTracked = true;
                    }

                    rooms = findImConvoRoomIds();
                    for (var r in rooms) {
                        roomId = rooms[r];
                        var doc = document;
                        if (window.openedPopups['room_' + roomId] !== undefined) {
                            if (!window.openedPopups['room_' + roomId].document) continue;
                            doc = window.openedPopups['room_' + roomId].document;
                        }
                        tmpElement = doc.getElementById('participant_online__' + roomId + '__' + memberId);
                        if (tmpElement) $cms.dom.html(tmpElement, '{!chat:INACTIVE;^}');
                        friendBeingTracked = true;
                    }

                    if (!skipIncomingSound) {
                        if (friendBeingTracked)
                            playChatSound('contact_off', memberId);
                    }
                    break;

                case 'JOIN_IM':
                    addImMember(roomId, memberId, username, messages[i].getAttribute('away') == '1', avatarUrl);

                    var doc = document;
                    if ((window.openedPopups['room_' + roomId] !== undefined) && (!window.openedPopups['room_' + roomId].isShutdown)) {
                        if (!window.openedPopups['room_' + roomId].document) break;
                        doc = window.openedPopups['room_' + roomId].document;
                    }
                    tmpElement = doc.getElementById('participant_online__' + roomId + '__' + memberId);
                    if (tmpElement) {
                        if ($cms.dom.html(tmpElement).toLowerCase() == '{!chat:ACTIVE;^}'.toLowerCase()) {
                            break;
                        }
                        $cms.dom.html(tmpElement, '{!chat:ACTIVE;^}');
                        document.getElementById('friend_img_' + memberId).className = 'friend_active';
                    }

                    if (!skipIncomingSound) {
                        playChatSound('contact_on', memberId);
                    }
                    break;

                case 'PREINVITED_TO_IM':
                    addImMember(roomId, memberId, username, messages[i].getAttribute('away') == '1', avatarUrl);
                    break;

                case 'DEINVOLVE_IM':
                    var doc = document;
                    if (window.openedPopups['room_' + roomId] !== undefined) {
                        if (!window.openedPopups['room_' + roomId].document) break;
                        doc = window.openedPopups['room_' + roomId].document;
                    }

                    tmpElement = doc.getElementById('participant__' + roomId + '__' + memberId);
                    if ((tmpElement) && (tmpElement.parentNode)) {
                        var parent = tmpElement.parentNode;
                        /*Actually prefer to let them go away it's cleaner if (parent.childNodes.length == 1) // Don't really let them go, flag them merely as away - we'll reinvite them upon next post
                         {
                             tmp_element = doc.getElementById('post_' + roomId);
                             if (tmp_element) tmp_element.forceInvite = member_id;

                             tmp_element=doc.getElementById('participant_online__' + roomId + '__' + member_id);
                             if (tmp_element)
                             {
                                 if ($cms.dom.html(tmp_element).toLowerCase() == '{!chat:INACTIVE;^}'.toLowerCase()) break;
                                 $cms.dom.html(tmp_element, '{!chat:INACTIVE;^}');
                             }
                         } else*/
                        {
                            parent.removeChild(tmpElement);
                        }
                        /*if (parent.childNodes.length==0) { Don't set to none, as we want to allow the 'forceInvite' IM re-activation feature, to draw the other guy back -- above we pretended they're merely 'away', not just left
                             $cms.dom.html(parent, '<em class="none">{!NONE;^}</em>');
                         }*/

                        if (!skipIncomingSound) {
                            playChatSound('contact_off', memberId);
                        }
                    }
                    break;
            }
        } else if ((messages[i].nodeName.toLowerCase() == 'chat_invite') && (window.imParticipantTemplate !== undefined)) { // INVITES
            roomId = messages[i].textContent;

            if ((!document.getElementById('room_' + roomId)) && ((window.openedPopups['room_' + roomId] === undefined) || (window.openedPopups['room_' + roomId].isShutdown))) {
                roomName = messages[i].getAttribute('room_name');
                avatarUrl = messages[i].getAttribute('avatar_url');
                participants = messages[i].getAttribute('participants');
                var isNew = (messages[i].getAttribute('num_posts') == '0');
                var byYou = (messages[i].getAttribute('inviter') == messages[i].getAttribute('you'));

                if ((!byYou) && (!window.instantGo) && (!document.getElementById('chat_lobby_convos_tabs'))) {
                    createOverlayEvent(skipIncomingSound, messages[i].getAttribute('inviter'), '{!chat:IM_INFO_CHAT_WITH;^}'.replace('{' + '1}', roomName), function () {
                        window.lastMessageId = -1 /*Ensure messages re-processed*/;
                        detectedConversation(roomId, roomName, participants);
                        return false;
                    }, avatarUrl, roomId);
                } else {
                    detectedConversation(roomId, roomName, participants);
                }
                flashableAlert = true;
            }

        } else if (messages[i].nodeName.toLowerCase() == 'chat_tracking') { // TRACKING
            window.topWindow.lastMessageId = messages[i].getAttribute('last_msg');
            window.topWindow.lastEventId = messages[i].getAttribute('last_event');
        }
    }

    // Get attention, to indicate something has happened
    if (flashableAlert) {
        if ((roomId) && (window.openedPopups['room_' + roomId] !== undefined) && (!window.openedPopups['room_' + roomId].isShutdown)) {
            if (window.openedPopups['room_' + roomId].getAttention !== undefined) window.openedPopups['room_' + roomId].getAttention();
            if (window.openedPopups['room_' + roomId].focus !== undefined) {
                try {
                    window.openedPopups['room_' + roomId].focus();
                }
                catch (e) {
                }
            }
            if (window.openedPopups['room_' + roomId].document) {
                var post = window.openedPopups['room_' + roomId].document.getElementById('post');
                if (post) {
                    try {
                        post.focus();
                    }
                    catch (e) {
                    }
                }
            }
        } else {
            if (window.getAttention !== undefined) {
                window.getAttention();
            }
            if (window.focus !== undefined) {
                try {
                    focus();
                } catch (e) {}
            }
            var post = document.getElementById('post');
            if (post && post.name == 'message'/*The chat posting field is named message and IDd post*/) {
                try {
                    post.focus();
                } catch (e) {}
            }
        }
    }

    if (window.topWindow.lastTimestamp < newestTimestampHere) {
        window.topWindow.lastTimestamp = newestTimestampHere;
    }

    return currentRoomId;

    function addImMember(roomId, memberId, username, away, avatarUrl) {
        setTimeout(function () {
            var doc = document;
            if (window.openedPopups['room_' + roomId] !== undefined) {
                if (window.openedPopups['room_' + roomId].isShutdown) return;
                if (!window.openedPopups['room_' + roomId].document) return;
                doc = window.openedPopups['room_' + roomId].document;
            }
            if (away) {
                var tmpElement = doc.getElementById('online_' + memberId);
                if ((tmpElement) && ($cms.dom.html(tmpElement).toLowerCase() == '{!chat:ACTIVE;^}'.toLowerCase())) away = false;
            }
            if (doc.getElementById('participant__' + roomId + '__' + memberId)) return; // They're already put in it
            var newParticipant = doc.createElement('div');
            var newParticipantInner = window.imParticipantTemplate.replace(/\_\_username\_\_/g, username);
            newParticipantInner = newParticipantInner.replace(/\_\_id\_\_/g, memberId);
            newParticipantInner = newParticipantInner.replace(/\_\_room\_id\_\_/g, roomId);
            newParticipantInner = newParticipantInner.replace(/\_\_avatar\_url\_\_/g, avatarUrl);
            if (avatarUrl == '') {
                newParticipantInner = newParticipantInner.replace('style="display: block" id="avatar__', 'style="display: none" id="avatar__');
            }
            newParticipantInner = newParticipantInner.replace(/\_\_online\_\_/g, away ? '{!chat:INACTIVE;^}' : '{!chat:ACTIVE;^}');
            $cms.dom.html(newParticipant, newParticipantInner);
            newParticipant.setAttribute('id', 'participant__' + roomId + '__' + memberId);
            var element = doc.getElementById('participants__' + roomId);
            if (element) {// If we've actually got the HTML for the room setup
                var pList = $cms.dom.html(element).toLowerCase();

                if ((pList.indexOf('<em class="none">') != -1) || (pList.indexOf('<em class="loading">') != -1)) {
                    $cms.dom.html(element, '');
                }
                element.appendChild(newParticipant);
                if (doc.getElementById('friend_img_' + memberId)) {
                    doc.getElementById('friend__' + memberId).style.display = 'none';
                }
            }
        }, 0);
    }

    function detectedConversation(roomId, roomName, participants) { // Assumes conversation is new: something must check that before calling here
        window.topWindow.lastEventId = -1; // So that invite events re-run

        var areas = document.getElementById('chat_lobby_convos_areas');
        var tabs = document.getElementById('chat_lobby_convos_tabs');
        var lobby;
        if (tabs) {// Chat lobby
            tabs.style.display = 'block';
            if (document.getElementById('invite_ongoing_im_button')) document.getElementById('invite_ongoing_im_button').disabled = false;
            var count = countImConvos();
            // First one?
            if (count == 0) {
                window.noImHtml = $cms.dom.html(areas);
                $cms.dom.html(areas, '');
                $cms.dom.html(tabs, '');
            }

            lobby = true;
        } else {// Not chat lobby (sitewide IM)
            lobby = false;
        }

        window.topWindow.allConversations[participants] = roomId;

        var url = '{$FIND_SCRIPT_NOHTTP;,messages}?action=join_im&event_id=' + window.topWindow.lastEventId + window.topWindow.$cms.keepStub(false);
        var post = 'room_id=' + encodeURIComponent(roomId);

        // Add in
        var newOne = window.imAreaTemplate.replace(/\_\_room_id\_\_/g, roomId).replace(/\_\_room\_name\_\_/g, roomName);
        if (lobby) {
            var newDiv;
            newDiv = document.createElement('div');
            $cms.dom.html(newDiv, newOne);
            areas.appendChild(newDiv);

            // Add tab
            newDiv = document.createElement('div');
            newDiv.className = 'chat_lobby_convos_tab_uptodate' + ((count == 0) ? ' chat_lobby_convos_tab_first' : '');
            $cms.dom.html(newDiv, $cms.filter.html(roomName));
            newDiv.setAttribute('id', 'tab_' + roomId);
            newDiv.participants = participants;
            newDiv.onclick = function () {
                chatSelectTab(newDiv);
            };
            tabs.appendChild(newDiv);
            chatSelectTab(newDiv);

            // Tell server we've joined
            $cms.doAjaxRequest(url, function (responseXml) {
                var ajaxResult = responseXml && responseXml.querySelector('result');
                processChatXmlMessages(ajaxResult, true);
            }, post);
        } else {
            // Open popup
            var imPopupWindowOptions = 'width=370,height=460,menubar=no,toolbar=no,location=no,resizable=no,scrollbars=yes,top=' + ((screen.height - 520) / 2) + ',left=' + ((screen.width - 440) / 2);
            var newWindow = window.open($cms.baseUrl('data/empty.html?instant_messaging'), 'room_' + roomId, imPopupWindowOptions); // The "?instant_messaging" is just to make the location bar less surprising to the user ;-) [modern browsers always show the location bar for security, even if we try and disable it]
            if ((!newWindow) || (newWindow.window === undefined /*BetterPopupBlocker for Chrome returns a fake new window but won't have this defined in it*/)) {
                $cms.ui.alert('{!chat:_FAILED_TO_OPEN_POPUP;,{$PAGE_LINK*,_SEARCH:popup_blockers:failure=1,0,1}}', null, '{!chat:FAILED_TO_OPEN_POPUP;^}', true);
            }
            setTimeout(function () { // Needed for Safari to set the right domain, and also to give window an opportunity to attach itself on its own accord
                if ((window.openedPopups['room_' + roomId] !== undefined) && (window.openedPopups['room_' + roomId] != null) && (!window.openedPopups['room_' + roomId].isShutdown)) { // It's been reattached already
                    return;
                }

                window.openedPopups['room_' + roomId] = newWindow;

                if ((newWindow) && (newWindow.document !== undefined)) {
                    newWindow.document.open();
                    newWindow.document.write(newOne); // This causes a blocking on Firefox while files download/parse. It's annoying, you'll see the popup freezes. But it works after a few seconds.
                    newWindow.document.close();
                    newWindow.topWindow = window;
                    newWindow.roomId = roomId;
                    newWindow.loadFromRoomId = -1;

                    setTimeout(function () { // Allow XHTML to render; needed for .document to be available, which is needed to write in seeded chat messages
                        if (!newWindow.document) {
                            return;
                        }

                        newWindow.participants = participants;

                        newWindow.onbeforeunload = function () {
                            return '{!chat:CLOSE_VIA_END_CHAT_BUTTON;^}';
                            //new_window.closeChatConversation(roomId);
                        };

                        try {
                            newWindow.focus();
                        } catch (e) {}

                        // Tell server we have joined
                        $cms.doAjaxRequest(url, function (responseXml) {
                            var ajaxResult = responseXml && responseXml.querySelector('result');
                            processChatXmlMessages(ajaxResult, true);
                        }, post);

                        // Set title
                        var domTitle = newWindow.document.querySelector('title');
                        if (domTitle != null) {
                            newWindow.document.title = $cms.dom.html(domTitle).replace(/<.*?>/g, '');
                        } // For Safari

                    }, 500);
                    /* Could be 60 except for Firefox which is slow */
                }
            }, 60);
        }
    }
}

function createOverlayEvent(skipIncomingSound, memberId, message, clickEvent, avatarUrl, roomId) {
    var div;

    // Close link
    function closePopup() {
        if (div) {
            if (roomId) {
                $cms.ui.generateQuestionUi(
                    '{!chat:HOW_REMOVE_CHAT_NOTIFICATION;^}',
                    {/*buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}',*/buttons__proceed: '{!CLOSE;^}', buttons__ignore: '{!HIDE;^}'},
                    '{!chat:REMOVE_CHAT_NOTIFICATION;^}',
                    null,
                    function (answer) {
                        /*if (answer.toLowerCase()=='{!INPUTSYSTEM_CANCEL;^}'.toLowerCase()) return;*/
                        if (answer.toLowerCase() == '{!CLOSE;^}'.toLowerCase()) {
                            deinvolveIm(roomId, false, false);
                        }
                        document.body.removeChild(div);
                        div = null;
                    }
                );
            } else {
                document.body.removeChild(div);
                div = null;
            }
        }
    }

    if (roomId === undefined) {
        roomId = null;
    }

    if (window != window.topWindow) { // Can't display in an autonomous popup
        return;
    }

    // Make sure to not show multiple equiv ones, which could happen in various situations
    if (roomId !== null) {
        if ((window.alreadyReceivedRoomInvites[roomId] !== undefined) && (window.alreadyReceivedRoomInvites[roomId])) {
            return;
        }
        window.alreadyReceivedRoomInvites[roomId] = true;
    } else {
        if ((window.alreadyReceivedContactAlert[memberId] !== undefined) && (window.alreadyReceivedContactAlert[memberId])) {
            return;
        }
        window.alreadyReceivedContactAlert[memberId] = true;
    }

    // Ping!
    if (!skipIncomingSound) {
        playChatSound('invited', memberId);
    }

    // Start DOM stuff
    div = document.createElement('div');
    div.className = 'im_event';
    //div.style.left=($cms.dom.getWindowWidth()/2-140)+'px';
    div.style.right = '1em';
    div.style.bottom = ((document.body.querySelectorAll('.im_event').length) * 185 + 20) + 'px';
    var links = document.createElement('ul');
    links.className = 'actions_list';

    var imgclose = document.createElement('img');
    imgclose.src = $cms.img('{$IMG;,icons/14x14/delete}');
    imgclose.className = 'im_popup_close_button blend';
    imgclose.onclick = closePopup;
    div.appendChild(imgclose);

    // Avatar
    if (avatarUrl) {
        var img1 = document.createElement('img');
        img1.setAttribute('src', avatarUrl);
        img1.className = 'im_popup_avatar';
        div.appendChild(img1);
    }

    // Message
    var pMessage = document.createElement('p');
    $cms.dom.html(pMessage, message);
    div.appendChild(pMessage);

    // Open link
    if (!$cms.browserMatches('non_concurrent')) { // Can't do on iOS due to not being able to run windows/tabs concurrently - so for iOS we only show a lobby link
        var aPopupOpen = document.createElement('a');
        aPopupOpen.onclick = function () {
            clickEvent();
            document.body.removeChild(div);
            div = null;
            return false;
        };
        aPopupOpen.href = '#';
        $cms.dom.html(aPopupOpen, '{!chat:OPEN_IM_POPUP;^}');
        var liPopupOpen = document.createElement('li');
        liPopupOpen.appendChild(aPopupOpen);
        links.appendChild(liPopupOpen);
    }

    // Lobby link
    var aGotoLobby = document.createElement('a');
    aGotoLobby.href = window.lobbyLink.replace('%21%21', memberId);
    aGotoLobby.onclick = closePopup;
    aGotoLobby.target = '_blank';
    $cms.dom.html(aGotoLobby, '{!chat:GOTO_CHAT_LOBBY;^}');
    var liGotoLobby = document.createElement('li');
    liGotoLobby.appendChild(aGotoLobby);
    links.appendChild(liGotoLobby);

    // Add it all in
    div.appendChild(links);
    document.body.appendChild(div);

    // Contact ones disappear after a time
    if (roomId === null) {
        setTimeout(function () {
            closePopup();
        }, window.TRANSITORY_ALERT_TIME);
    }
}

function startIm(people, justRefocus) {
    if (($cms.browserMatches('non_concurrent')) && !document.getElementById('chat_lobby_convos_tabs')) {
        // Let it navigate to chat lobby
        return true;
    }

    people = strVal(people);
    justRefocus = !!justRefocus;

    var message = people.includes(',') ? '{!chat:ALREADY_HAVE_THIS;^}' : '{!chat:ALREADY_HAVE_THIS_SINGLE;^}';

    if (window.topWindow.allConversations[people] != null) {
        if (justRefocus) {
            try {
                var roomId = window.topWindow.allConversations[people];
                if (document.getElementById('tab_' + roomId)) {
                    chatSelectTab(document.getElementById('tab_' + roomId));
                } else {
                    window.topWindow.openedPopups['room_' + roomId].focus();
                }
                return false;
            } catch (ignore) {}
        }

        $cms.ui.confirm(
            message,
            function (answer) {
                if (answer) _startIm(people, false); // false, because can't recycle if its already open
            }
        );
    } else {
        _startIm(people, true); // true, because an IM may exist we don't have open, so let that be recycled
    }

    return false;

    function _startIm(people, mayRecycle) {
        var div = document.createElement('div');
        div.className = 'loading_overlay';
        $cms.dom.html(div, '{!LOADING;^}');
        document.body.appendChild(div);
        $cms.doAjaxRequest($cms.maintainThemeInLink('{$FIND_SCRIPT;,messages}?action=start_im&message_id=' + encodeURIComponent((window.topWindow.lastMessageId === null) ? -1 : window.topWindow.lastMessageId) + '&mayRecycle=' + (mayRecycle ? '1' : '0') + '&event_id=' + encodeURIComponent(window.topWindow.lastEventId) + $cms.keepStub(false)), function (responseXml) {
            var responses = responseXml.getElementsByTagName('result');
            if (responses[0]) {
                window.instantGo = true;
                processChatXmlMessages(responses[0], true);
                window.instantGo = false;
            }
            document.body.removeChild(div);
        }, 'people=' + people);
    }

}

function inviteIm(people) {
    var roomId = findCurrentImRoom();
    if (!roomId) {
        $cms.ui.alert('{!chat:NO_IM_ACTIVE;^}');
    } else {
        $cms.doAjaxRequest('{$FIND_SCRIPT;,messages}?action=invite_im' + $cms.keepStub(false), function () {
        }, 'room_id=' + encodeURIComponent(roomId) + '&people=' + people);
    }
}

function countImConvos() {
    var chatLobbyConvosTabs = document.getElementById('chat_lobby_convos_tabs');
    var count = 0, i;
    for (i = 0; i < chatLobbyConvosTabs.children.length; i++) {
        if (chatLobbyConvosTabs.children[i].id.substr(0, 4) === 'tab_') {
            count++;
        }
    }
    return count;
}

function findImConvoRoomIds() {
    var chatLobbyConvosTabs = document.getElementById('chat_lobby_convos_tabs');
    var rooms = [], i;
    if (!chatLobbyConvosTabs) {
        for (i in window.openedPopups) {
            if (i.substr(0, 5) === 'room_') {
                rooms.push(parseInt(i.substr(5)));
            }
        }
        return rooms;
    }
    for (i = 0; i < chatLobbyConvosTabs.children.length; i++) {
        if (chatLobbyConvosTabs.children[i].id.substr(0, 4) === 'tab_') {
            rooms.push(parseInt(chatLobbyConvosTabs.childNodes[i].id.substr(4)));
        }
    }
    return rooms;
}

function closeChatConversation(roomId) {
    var isPopup = (document.body.classList.contains('sitewide_im_popup_body'));
    /*{+START,IF,{$OR,{$NOT,{$ADDON_INSTALLED,cns_forum}},{$NOT,{$CNS}}}}*/
    $cms.ui.generateQuestionUi(
        '{!chat:WANT_TO_DOWNLOAD_LOGS*;^}',
        {buttons__cancel: '{!INPUTSYSTEM_CANCEL*;^}', buttons__yes: '{!YES*;^}', buttons__no: '{!NO*;^}'},
        '{!chat:CHAT_DOWNLOAD_LOGS*;^}',
        null,
        function (logs) {
            if (logs.toLowerCase() !== '{!INPUTSYSTEM_CANCEL*;^}'.toLowerCase()) {
                if (logs.toLowerCase() === '{!YES*;^}'.toLowerCase()) {
                    window.open('{$FIND_SCRIPT*;,download_chat_logs}?room=' + roomId + '{$KEEP*;^}');
                    deinvolveIm(roomId, true, isPopup);
                    return;
                }
                /*{+END}*/
                deinvolveIm(roomId, false, isPopup);
                /*{+START,IF,{$OR,{$NOT,{$ADDON_INSTALLED,cns_forum}},{$NOT,{$CNS}}}}*/
            }
        }
    );
    /*{+END}*/
}

function deinvolveIm(roomId, logs, isPopup) { // is_popup means that we show a progress indicator over it, then kill the window after deinvolvement
    if (isPopup) {
        var body = document.getElementsByTagName('body');
        if (body[0] !== undefined) {
            body[0].className += ' site_unloading';
            $cms.dom.html(body[0], '<div class="spaced"><div aria-busy="true" class="ajax_loading vertical_alignment"><img src="' + $cms.img('{$IMG*;,loading}') + '" alt="{!LOADING;^}" /> <span>{!LOADING;^}<\/span><\/div><\/div>');
        }
    }

    var element, participants = null;
    var tabs = document.getElementById('chat_lobby_convos_tabs');
    if (tabs) {
        element = document.getElementById('room_' + roomId);
        if (!element) { // Probably already been clicked once, lag
            return;
        }

        var tabElement = document.getElementById('tab_' + roomId);
        element.style.display = 'none';
        tabElement.style.display = 'none';

        participants = tabElement.participants;
    } else {
        if (isPopup) {
            participants = ((window.alreadyAutonomous !== undefined) && (window.alreadyAutonomous)) ? window.participants : window.topWindow.openedPopups['room_' + roomId].participants;
        }
    }

    window.topWindow.alreadyReceivedRoomInvites[roomId] = false;
    if (isPopup) {
        window.isShutdown = true;
    }

    setTimeout(function ()  { // Give time for any logs to download (download does not need to have finished - but must have loaded into a request response on the server side)
        window.topWindow.$cms.doAjaxRequest('{$FIND_SCRIPT;,messages}?action=deinvolve_im' + window.topWindow.$cms.keepStub(false), function () {
        }, 'room_id=' + encodeURIComponent(roomId)); // Has to be on topWindow or it will be lost if the window was explicitly closed (it is unloading mode and doesn't want to make a new request)

        if (participants) {
            window.topWindow.allConversations[participants] = null;
        }

        if (tabs) {
            if ((element) && (element.parentNode)) element.parentNode.removeChild(element);
            if (!tabElement.parentNode) return;

            tabElement.parentNode.removeChild(tabElement);

            // All gone?
            var count = countImConvos();
            if (count == 0) {
                $cms.dom.html(tabs, '&nbsp;');
                document.getElementById('chat_lobby_convos_tabs').style.display = 'none';
                $cms.dom.html(document.getElementById('chat_lobby_convos_areas'), window.noImHtml);
                if (document.getElementById('invite_ongoing_im_button')) {
                    document.getElementById('invite_ongoing_im_button').disabled = true;
                }
            } else {
                chatSelectTab(document.getElementById('tab_' + findImConvoRoomIds().pop()));
            }
        } else if (isPopup) {
            window.onbeforeunload = null;
            window.close();
        }
    }, logs ? window.LOGS_DOWNLOAD_INTERVAL : 10);
}

function findCurrentImRoom() {
    var chatLobbyConvosTabs = document.getElementById('chat_lobby_convos_tabs');
    if (!chatLobbyConvosTabs) {
        return window.roomId;
    }
    for (var i = 0; i < chatLobbyConvosTabs.children.length; i++) {
        if ((chatLobbyConvosTabs.children[i].nodeName.toLowerCase() === 'div') && (chatLobbyConvosTabs.children[i].classList.contains('chat_lobby_convos_current_tab'))) {
            return parseInt(chatLobbyConvosTabs.childNodes[i].id.substr(4));
        }
    }
    return null;
}

function chatSelectTab(element) {
    var i, chatLobbyConvosTabs = document.getElementById('chat_lobby_convos_tabs');

    for (i = 0; i < chatLobbyConvosTabs.children.length; i++) {
        if (chatLobbyConvosTabs.children[i].classList.contains('chat_lobby_convos_current_tab')) {
            chatLobbyConvosTabs.children[i].className = ((chatLobbyConvosTabs.children[i].classList.contains('chat_lobby_convos_tab_first')) ? 'chat_lobby_convos_tab_first ' : '') + 'chat_lobby_convos_tab_uptodate';
            document.getElementById('room_' + chatLobbyConvosTabs.children[i].id.substr(4)).style.display = 'none';
            break;
        }
    }

    document.getElementById('room_' + element.id.substr(4)).style.display = 'block';
    try {
        document.getElementById('post_' + element.id.substr(4)).focus();
    } catch (ignore) {}

    element.className = ((element.classList.contains('chat_lobby_convos_tab_first')) ? 'chat_lobby_convos_tab_first ' : '') + 'chat_lobby_convos_tab_uptodate chat_lobby_convos_current_tab';
}

(function ($cms) {
    'use strict';

    window.sbCcTimer = null;
    window.sbLastMessageId = null;
    window.MESSAGE_CHECK_INTERVAL = +'{$ROUND%,{$MAX,3000,{$CONFIG_OPTION,chat_message_check_interval}}}';
    
    $cms.templates.blockSideShoutbox = function blockSideShoutbox(params, container) {
        var chatRoomId = strVal(params.chatroomId),
            lastMessageId = strVal(params.lastMessageId);

        if (lastMessageId !== '') {
            sbChatCheck(chatRoomId, lastMessageId, -1);
        }

        $cms.dom.on(container, 'click', '.js-click-btn-send-message', function (e, el) {
            window.top.setTimeout(function () {
                window.top.sbChatCheck(chatRoomId, lastMessageId, -1);
            }, 2000);
            if (!$cms.form.checkFieldForBlankness(el.form.elements['shoutbox_message'])) {
                e.preventDefault();
            }
            $cms.ui.disableButton(el);
        });

        $cms.dom.on(container, 'click', '.js-click-btn-shake-screen', function (e, el) {
            el.form.elements['shoutbox_message'].value = '((SHAKE))';
            window.top.setTimeout(function () {
                window.top.sbChatCheck(chatRoomId, lastMessageId, -1);
            }, 2000);
            $cms.ui.disableButton(el);
        });
    };
}(window.$cms));

function sbChatCheck(roomId, lastMessageId, lastEventId) {
    window.sbRoomId = roomId;
    window.sbLastMessageId = lastMessageId;

    function sbChatCheckResponse(responseXml) {
        var ajaxResult = responseXml && responseXml.querySelector('result');
        
        if (!ajaxResult) return; // Some server side glitch. As this polls, lets ignore it

        sbHandleSignals(ajaxResult);

        // Schedule the next check
        if (window.sbCcTimer) {
            clearTimeout(window.sbCcTimer);
            window.sbCcTimer = null;
        }
        window.sbCcTimer = setTimeout(function () {
            var messageId = window.sbLastMessageId;
            return function () {
                sbChatCheck(window.sbRoomId, messageId, -1)
            }
        }(), window.MESSAGE_CHECK_INTERVAL);


        function sbHandleSignals(ajaxResult) {
            var messages = ajaxResult.childNodes;

            var _sbLastMessageId=window.sbLastMessageId;

            // Look through our messages
            for (var i = 0; i < messages.length; i++) {
                if (messages[i].localName === 'div') {
                    var id = messages[i].getAttribute("id");
                    if (id > window.sbLastMessageId) {
                        window.sbLastMessageId = window.parseInt(id);
                        if (window.sbLastMessageId != -1) {
                            if ($cms.dom.html(messages[i]).indexOf('((SHAKE))') !== -1) {
                                window.doShake();
                            } else {
                                window.showGhost($cms.dom.html(messages[i]));
                            }

                            var frames = window.parent.document.getElementsByTagName('iframe');
                            for (var i = 0; i < frames.length; i++) {
                                if ((frames[i].src == window.location.href) || (frames[i].contentWindow == window) || ((window.parent.frames[frames[i].id] != undefined) && (window.parent.frames[frames[i].id] == window))) {
                                    var sb = frames[i];
                                    if (sb.contentWindow.location.href.indexOf('posted') === -1) {
                                        sb.contentWindow.location.reload();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    var url = '{$FIND_SCRIPT_NOHTTP;,messages}?action=new&no_reenter_message=1&room_id=' + roomId + "&message_id=" + ((lastMessageId === null) ? -1 : lastMessageId) + "&event_id=" + lastEventId;
    $cms.doAjaxRequest(url + $cms.$KEEP(), sbChatCheckResponse);
}

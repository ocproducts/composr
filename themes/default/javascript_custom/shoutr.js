(function ($cms) {
    'use strict';

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

window.sb_cc_timer = null;
window.sb_last_message_id = null;

function sbChatCheck(roomId, lastMessageId, lastEventId) {
    window.sb_room_id = roomId;
    window.sb_last_message_id = lastMessageId;

    function sbChatCheckResponse(ajaxResultFrame, ajaxResult) {
        if (!ajaxResult) return; // Some server side glitch. As this polls, lets ignore it

        sbHandleSignals(ajaxResult);

        // Schedule the next check
        if (window.sb_cc_timer) {
            clearTimeout(window.sb_cc_timer);
            window.sb_cc_timer = null;
        }
        window.sb_cc_timer = setTimeout(function () {
            var messageId = window.sb_last_message_id;
            return function () {
                sbChatCheck(window.sb_room_id, messageId, -1)
            }
        }(), 10000);


        function sbHandleSignals(ajaxResult) {
            var messages = ajaxResult.childNodes;

            // Look through our messages
            for (var i = 0; i < messages.length; i++) {
                if (messages[i].localName === 'div') {
                    var id = messages[i].getAttribute("id");
                    if (id > window.sb_last_message_id && window.sb_last_message_id != -1) {
                        window.sb_last_message_id = id;
                        if ($cms.dom.html(messages[i]).indexOf('((SHAKE))') != -1) {
                            window.doShake();
                        } else {
                            window.showGhost($cms.dom.html(messages[i]));
                        }

                        var frames = window.parent.document.getElementsByTagName('iframe');
                        for (var i = 0; i < frames.length; i++) {
                            if ((frames[i].src == window.location.href) || (frames[i].contentWindow == window) || ((window.parent.frames[frames[i].id] != undefined) && (window.parent.frames[frames[i].id] == window))) {
                                var sb = frames[i];
                                if (sb.contentWindow.location.href.indexOf('posted') == -1)
                                    sb.contentWindow.location.reload();
                            }
                        }
                    }
                }
            }
        }
    }

    var url = '{$FIND_SCRIPT_NOHTTP;,messages}?action=new&no_reenter_message=1&room_id=' + roomId + "&message_id=" + lastMessageId + "&event_id=" + lastEventId;
    $cms.doAjaxRequest(url + $cms.keepStub(false), sbChatCheckResponse);
}
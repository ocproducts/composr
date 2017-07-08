/* TODO: Salman merge into shoutr.js */

'use strict';

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
                    if (!id) id = messages[i].id; // LEGACY Weird fix for Opera
                    if (id > window.sb_last_message_id && window.sb_last_message_id != -1) {
                        window.sb_last_message_id = id;
                        if ($cms.dom.html(messages[i]).indexOf('((SHAKE))') != -1) {
                            window.doShake();
                        } else {
                            window.showGhost($cms.dom.html(messages[i]));
                        }

                        var frames = window.parent.document.getElementsByTagName('iframe');
                        for (var i = 0; i < frames.length; i++) {
                            if (frames[i]) // If test needed for opera, as window.frames can get out-of-date
                            {
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
    }

    var url = '{$FIND_SCRIPT_NOHTTP;,messages}?action=new&no_reenter_message=1&room_id=' + roomId + "&message_id=" + lastMessageId + "&event_id=" + lastEventId;
    $cms.doAjaxRequest(url + $cms.keepStub(false), sbChatCheckResponse);
}

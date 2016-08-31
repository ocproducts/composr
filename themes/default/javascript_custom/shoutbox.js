var sb_cc_timer = null;
var sb_last_message_id = null;

function sb_chat_check(last_message_id, last_event_id) {
    sb_last_message_id = last_message_id;
    var url = "{$FIND_SCRIPT*,messages}?action=new&no_reenter_message=1&room_id=" + window.sb_room_id + "&message_id=" + last_message_id + "&event_id=" + last_event_id;
    do_ajax_request(url + keep_stub(false), sb_chat_check_response);
}

function sb_chat_check_response(ajax_result_frame, ajax_result) {
    if (!ajax_result) return; // Some server side glitch. As this polls, lets ignore it

    sb_handle_signals(ajax_result);

    // Schedule the next check
    if (window.sb_cc_timer) {
        window.clearTimeout(window.sb_cc_timer);
        window.sb_cc_timer = null;
    }
    window.sb_cc_timer = window.setTimeout(function () {
        var messageId = window.sb_last_message_id;
        return function () {
            sb_chat_check(messageId, -1)
        }
    }(), 10000);
}


function sb_handle_signals(ajax_result) {
    var messages = ajax_result.childNodes;

    // Look through our messages
    for (var i = 0; i < messages.length; i++) {
        if (messages[i].nodeName == 'div') {
            var id = messages[i].getAttribute("id");
            if (!id) id = messages[i].id; // Weird fix for Opera
            if (id > window.sb_last_message_id && window.sb_last_message_id != -1) {
                window.sb_last_message_id = id;
                if (Composr.dom.html(messages[i]).indexOf('((SHAKE))') != -1) {
                    do_shake();
                } else {
                    show_ghost(Composr.dom.html(messages[i]));
                }

                var frames = window.parent.document.getElementsByTagName('iframe');
                for (var i = 0; i < frames.length; i++) {
                    if (frames[i]) // If test needed for opera, as window.frames can get out-of-date
                    {
                        if ((frames[i].src == window.location.href) || (frames[i].contentWindow == window) || ((typeof window.parent.frames[frames[i].id] != "undefined") && (window.parent.frames[frames[i].id] == window))) {
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

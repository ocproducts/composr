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

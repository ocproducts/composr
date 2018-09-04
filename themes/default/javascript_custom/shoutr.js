(function ($cms, $util, $dom) {
    'use strict';

    var MESSAGE_CHECK_INTERVAL = window.MESSAGE_CHECK_INTERVAL = Math.max(3000, $cms.configOption('chat_message_check_interval'));

    var sbChatCheckTimerId = null,
        sbChatRoomId = null,
        sbLastMessageId = null;

    $cms.templates.blockSideShoutbox = function blockSideShoutbox(params, container) {
        var chatRoomId = strVal(params.chatroomId),
            lastMessageId = strVal(params.lastMessageId);

        if (lastMessageId !== '') {
            sbChatCheck(chatRoomId, lastMessageId, -1);
        }

        $dom.on(container, 'click', '.js-click-btn-send-message', function (e, el) {
            setTimeout(function () {
                sbChatCheck(chatRoomId, lastMessageId, -1);
            }, 2000);

            if (!$cms.form.checkFieldForBlankness(el.form.elements['shoutbox_message'])) {
                e.preventDefault();
            }

            $cms.ui.disableButton(el);
        });

        $dom.on(container, 'click', '.js-click-btn-shake-screen', function (e, el) {
            el.form.elements['shoutbox_message'].value = '((SHAKE))';
            setTimeout(function () {
                sbChatCheck(chatRoomId, lastMessageId, -1);
            }, 2000);
            $cms.ui.disableButton(el);
        });
    };

    function sbChatCheck(roomId, lastMessageId, lastEventId) {
        sbChatRoomId = Number(roomId);
        sbLastMessageId = Number(lastMessageId);

        var url = '{$FIND_SCRIPT_NOHTTP;,messages}?action=new&no_reenter_message=1&room_id=' + roomId + '&message_id=' + ((lastMessageId == null) ? -1 : lastMessageId) + '&event_id=' + lastEventId;
        $cms.doAjaxRequest(url + $cms.keep()).then(sbChatCheckResponse);
    }

    function sbChatCheckResponse(xhr) {
        var ajaxResult = xhr && xhr.responseXML && xhr.responseXML.querySelector('result');

        if (!ajaxResult) { // Some server side glitch. As this polls, lets ignore it
            return;
        }

        sbHandleSignals(ajaxResult);

        // Schedule the next check
        if (sbChatCheckTimerId) {
            clearTimeout(sbChatCheckTimerId);
        }
        sbChatCheckTimerId = setTimeout((function (messageId) {
            sbChatCheck(sbChatRoomId, messageId, -1);
        }).bind(undefined, sbLastMessageId), MESSAGE_CHECK_INTERVAL);

        function sbHandleSignals(ajaxResult) {
            var messageEls = arrVal(ajaxResult.children).filter(function (el) {
                return el.localName === 'div';
            });

            // Look through our messages
            for (var i = 0; i < messageEls.length; i++) {
                var id = messageEls[i].getAttribute('id');
                if ((id > sbLastMessageId) && (sbLastMessageId !== -1)) {
                    sbLastMessageId = parseInt(id);
                    if (sbLastMessageId !== -1) {
                        if ($dom.html(messageEls[i]).includes('((SHAKE))')) {
                            doShake();
                        } else {
                            showGhost($dom.html(messageEls[i]));
                        }

                        var frames = window.parent.document.getElementsByTagName('iframe');
                        for (var j = 0; j < frames.length; j++) {
                            if ((frames[j].src === window.location.href) || (frames[j].contentWindow === window) || ((window.parent.frames[frames[j].id] != null) && (window.parent.frames[frames[j].id] === window))) {
                                var sb = frames[j];
                                if ($util.url(sb.contentWindow.location.href).searchParams.get('posted') !== '1') {
                                    sb.contentWindow.location.reload();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    function doShake() {
        var seconds = 1, amount = 30;

        var overflowBefore = document.body.style.overflow;
        document.body.style.overflow = 'hidden';

        var divs = document.getElementsByTagName('div'), currentPositioning;
        for (var i = 0; i < divs.length; i++) {
            currentPositioning = $dom.css(divs[i], 'position');
            if ((currentPositioning === '') || (currentPositioning === 'static')) {
                divs[i].vectorSpeed = Math.round(Math.random() * 2);
                divs[i].style.position = 'relative';
            }
        }
        for (var times = 0; times < 10; times++) {
            window.setTimeout(shakeAnimateFunc(times, divs, amount), (100 * times * seconds));
        }

        for (var times2 = 8; times2 >= 0; times2--) {
            window.setTimeout(shakeAnimateFunc(times2, divs, amount), (1000 * seconds + 100 * (8 - times2) * seconds));
        }

        window.setTimeout(function () {
            for (var i = 0; i < divs.length; i++) {
                if (divs[i].vectorSpeed != null) {
                    divs[i].style.left = '0';
                    divs[i].style.top = '0';
                    divs[i].style.position = 'static';
                }
            }

            document.body.style.overflow = overflowBefore;
        }, 1000 * seconds * 2);

        function shakeAnimateFunc(times, divs, amount) {
            return function () {
                for (var i = 0; i < divs.length; i++) {
                    if (divs[i].vectorSpeed != null) {
                        divs[i].vectorTarget = [Math.round(amount - Math.random() * amount * 2), Math.round(amount - Math.random() * amount * 2)];

                        divs[i].style.left = Math.round(divs[i].vectorTarget[0] * times / 10.0) + 'px';
                        divs[i].style.top = Math.round(divs[i].vectorTarget[1] * times / 10.0) + 'px';
                    }
                }
            };
        }
    }

    function showGhost(htmlMessage) {
        var div = document.createElement('div');
        div.style.position = 'absolute';
        div.className = 'ghost';
        $dom.html(div, htmlMessage);
        var limit = 36, counter;
        for (counter = 0; counter < limit; counter++) {
            setTimeout(buildGhostFunc(div, counter, limit), counter * 100);
        }
        setTimeout(function () {
            document.body.removeChild(div);
        }, counter * 100);
        document.body.appendChild(div);

        function buildGhostFunc(div, counter, limit) {
            return function () {
                div.style.fontSize = (1 + 0.05 * counter) + 'em';
                div.style.opacity = 1.0 - counter / limit / 1.3;
                div.style.left = (($dom.getWindowWidth() - div.offsetWidth) / 2 + window.pageXOffset) + 'px';
                div.style.top = (($dom.getWindowHeight() - div.offsetHeight) / 2 - 20 + window.pageYOffset) + 'px';
            };
        }
    }
}(window.$cms, window.$util, window.$dom));

(function ($cms) {
    'use strict';

    $cms.templates.emoticonImgCodeThemedJestr = function emoticonImgCodeThemedJestr(params, container) {
        if (window.crazy_criters == null) {
            window.crazy_criters = [];
            setInterval(crazy_tick, 300);
        }

        var myId = parseInt(Math.random() * 10000),
            emoticoncrazy = document.getElementById('emoticoncrazy' + params.rndx);

        $cms.dom.html(emoticoncrazy, '<img id="' + myId + '" style="position: relative" alt="{!EMOTICON;}" src="' + params.imgSrc + '">');
        window.crazy_criters.push(myId);
    };
}(window.$cms));

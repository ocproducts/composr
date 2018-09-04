(function ($cms) {
    'use strict';

    $cms.templates.emoticonImgCodeThemedJestr = function emoticonImgCodeThemedJestr(params) {
        if (window.crazyCriters == null) {
            window.crazyCriters = [];
            setInterval(window.crazyTick, 300);
        }

        var myId = parseInt(Math.random() * 10000),
            emoticoncrazy = document.getElementById('emoticoncrazy' + params.rndx);

        $dom.html(emoticoncrazy, '<img id="' + myId + '" style="position: relative" alt="{!EMOTICON;}" src="' + params.imgSrc + '">');
        window.crazyCriters.push(myId);
    };
}(window.$cms));

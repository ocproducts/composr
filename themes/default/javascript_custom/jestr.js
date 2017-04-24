(function ($cms) {
    'use strict';

    $cms.templates.emoticonImgCodeThemedJestr = function emoticonImgCodeThemedJestr(params, container) {
        if (window.crazy_criters == null) {
            window.crazy_criters = [];
            window.setInterval(crazy_tick, 300);
        }

        var my_id = parseInt(Math.random() * 10000),
            emoticoncrazy = document.getElementById('emoticoncrazy' + params.rndx);

        $cms.dom.html(emoticoncrazy, '<img id="' + my_id + '" style="position: relative" alt="{!EMOTICON;}" src="' + params.imgSrc + '">');
        window.crazy_criters.push(my_id);
    };
}(window.$cms));
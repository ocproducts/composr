(function ($cms) {
    $cms.behaviors.initializeNewsScroller = {
        attach: function (context) {
            $cms.dom.$$$(context, '[data-cms-news-scroller]').forEach(function (scroller) {
                newsScroller(scroller);
            });
        }
    };

    function newsScroller(scroller) {
        var scroll_speed = 60;

        scroller.paused = false;

        if (scroller.scrollHeight < 300) scroll_speed = 300; // Slow, as not much to scroll

        window.setTimeout(function () {
            window.setInterval(function () {
                if (scroller.paused) return;
                if (scroller.scrollTop + scroller.offsetHeight >= scroller.scrollHeight - 1) {
                    scroller.scrollTop = 0;
                } else {
                    scroller.scrollTop++;
                }
            }, scroll_speed);
        }, 2000);
    }

}(window.$cms));

(function ($, Composr) {
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

    Composr.behaviors.syndicationBlocks = {
        initialize: {
            attach: function (context) {
                $('[data-cms-news-scroller]', context).each(function () {
                    newsScroller(this);
                });
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);

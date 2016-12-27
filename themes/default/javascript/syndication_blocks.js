(function ($cms) {
    'use strict';

    // Implementation for [data-cms-news-scroller]
    $cms.behaviors.initializeNewsScroller = {
        attach: function (context) {
            $cms.dom.$$$(context, '[data-cms-news-scroller]').forEach(function (scrollerEl) {
                var scrollInterval = 60;

                if (scrollerEl.scrollHeight < 300) {
                    scrollInterval = 300; // Slow, as not much to scroll
                }

                scrollerEl.paused = false;

                window.setTimeout(function () {
                    window.setInterval(function () {
                        if (scrollerEl.paused) {
                            return;
                        }

                        if ((scrollerEl.scrollTop + scrollerEl.offsetHeight) >= (scrollerEl.scrollHeight - 1)) {
                            scrollerEl.scrollTop = 0;
                        } else {
                            scrollerEl.scrollTop++;
                        }
                    }, scrollInterval);
                }, 2000);

                $cms.dom.on(scrollerEl, 'mouseover mouseout', function (e) {
                    if (scrollerEl.contains(e.relatedTarget)) {
                        return;
                    }
                    scrollerEl.paused = (e.type === 'mouseover');
                });
            });
        }
    };
}(window.$cms));

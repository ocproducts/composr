(function ($cms) {
    'use strict';

    // Implementation for [data-cms-news-scroller]
    $cms.defineBehaviors({
        initializeNewsScroller: {
            attach: function (context) {
                $util.once($cms.dom.$$$(context, '[data-cms-news-scroller]'), 'behavior.initializeNewsScroller').forEach(function (scrollerEl) {
                    var scrollInterval = 60;

                    if (scrollerEl.scrollHeight < 300) {
                        scrollInterval = 300; // Slow, as not much to scroll
                    }

                    scrollerEl.paused = false;

                    setTimeout(function () {
                        setInterval(function () {
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
        }
    });
    
    $cms.templates.blockMainImageFaderNews = function blockMainImageFaderNews(params, container) {
        var rand = strVal(params.randFaderNews),
            news = arrVal(params.news),
            milliseconds = Number(params.mill) || 0;

        // Variables we will need
        var fpAnimationImg = $cms.dom.$('#image_fader_news_' + rand),
            fpAnimationUrl = $cms.dom.$('#image_fader_news_url_' + rand),
            fpAnimationHtml = $cms.dom.$('#image_fader_news_html_' + rand);
        // Create fader
        var fpAnimationNewsImg = document.createElement('img');

        fpAnimationNewsImg.style.position = 'absolute';
        fpAnimationNewsImg.src = $cms.img('{$IMG;,blank}');
        
        fpAnimationImg.parentElement.insertBefore(fpAnimationNewsImg, fpAnimationImg);
        fpAnimationImg.parentElement.style.position = 'relative';
        fpAnimationImg.parentElement.style.display = 'block';

        var data = [], i;
        
        for (i = 0; i < news.length; i++) {
            data.push({
                html: $cms.dom.html('script#image-fader-' + rand + '-news-item-' + i + '-html'),
                url:  news[i].url,
                imageUrl: $cms.img(news[i].imageUrl)
            });

            new Image().src = news[i].imageUrl; // precache
        }

        // Cycling function
        var cycleTimerId = null,
            cycleIndex = 0;
        
        function doCycle(diff) {
            diff = Number(diff) || 0;
            
            //  Cycle
            cycleIndex = cycleIndex + diff;
            if (cycleIndex < 0) {
                cycleIndex = data.length - 1;
            }
            if (cycleIndex >= data.length) {
                cycleIndex = 0;
            }
            
            // Simple data copy
            $cms.dom.hide(fpAnimationHtml);
            $cms.dom.html(fpAnimationHtml, data[cycleIndex].html);
            $cms.dom.fadeIn(fpAnimationHtml);
            fpAnimationUrl.href = data[cycleIndex].url;

            // Set up fade
            fpAnimationNewsImg.src = fpAnimationImg.src;
            $cms.dom.fadeOut(fpAnimationNewsImg);
            $cms.dom.fadeIn(fpAnimationImg);
            fpAnimationImg.src = $cms.img(data[cycleIndex].imageUrl);
            setTimeout(function () { // Will know dimensions by the time the timeout happens
                fpAnimationNewsImg.style.left = ((fpAnimationNewsImg.parentNode.offsetHeight - fpAnimationNewsImg.offsetWidth) / 2) + 'px';
                fpAnimationNewsImg.style.top = ((fpAnimationNewsImg.parentNode.offsetHeight - fpAnimationNewsImg.offsetHeight) / 2) + 'px';
            }, 0);
            
            $cms.dom.$('#pause_button_' + rand).classList.remove('button_depressed');

            // Set up timer for next time
            if (cycleTimerId) {
                clearTimeout(cycleTimerId);
            }
            
            if (milliseconds && (news.length > 1)) {
                cycleTimerId = setTimeout(function () {
                    doCycle(1);
                }, milliseconds);
            }
        }

        // Pause cycle
        function pauseCycle() {
            if (cycleTimerId) {
                // Pause
                clearTimeout(cycleTimerId);
                cycleTimerId = null;
                $cms.dom.$('#pause_button_' + rand).classList.add('button_depressed');
            } else {
                // Unpause
                $cms.dom.$('#pause_button_' + rand).classList.remove('button_depressed');

                if (milliseconds && (news.length > 1)) {
                    cycleTimerId = setTimeout(function () {
                        doCycle(1);
                    }, milliseconds);
                }
            }
        }

        /// Start cycle
        doCycle();

        $cms.dom.on(container, 'click', '.js-click-btn-prev-cycle', function () {
            doCycle(-1);
        });

        $cms.dom.on(container, 'click', '.js-click-btn-pause-cycle', function () {
            pauseCycle();
        });

        $cms.dom.on(container, 'click', '.js-click-btn-next-cycle', function () {
            doCycle(1);
        });
    };

    $cms.templates.blockBottomNews = function blockBottomNews(params) {
        window.tickPos = window.tickPos || {};

        var newsTickerText = $cms.filter.nl(params.newsTickerText),
            ticktickticker = $cms.dom.$('#ticktickticker_news' + params.bottomNewsId),
            myId = 'ticker-' - $util.random();

        window.tickPos[myId] = 400;
        $cms.dom.html(ticktickticker, '<div class="ticker" style="text-indent: 400px; width: 400px;" id="' + myId + '"><span>' + newsTickerText + '</span></div>');

        setInterval(function () {
            tickerTick(myId, 400);
        }, 50);
    };
}(window.$cms));

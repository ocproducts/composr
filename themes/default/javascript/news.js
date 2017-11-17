(function ($cms, $util, $dom) {
    'use strict';

    // Implementation for [data-cms-news-scroller]
    $cms.behaviors.initializeNewsScroller = {
        attach: function (context) {
            $util.once($dom.$$$(context, '[data-cms-news-scroller]'), 'behavior.initializeNewsScroller').forEach(function (scrollerEl) {
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

                $dom.on(scrollerEl, 'mouseover mouseout', function (e) {
                    if (scrollerEl.contains(e.relatedTarget)) {
                        return;
                    }
                    scrollerEl.paused = (e.type === 'mouseover');
                });
            });
        }
    };
    
    $cms.templates.blockMainImageFaderNews = function blockMainImageFaderNews(params, container) {
        var rand = strVal(params.randFaderNews),
            news = arrVal(params.news),
            milliseconds = Number(params.mill) || 0;

        // Variables we will need
        var fpAnimationImg = $dom.$('#image_fader_news_' + rand),
            fpAnimationUrl = $dom.$('#image_fader_news_url_' + rand),
            fpAnimationHtml = $dom.$('#image_fader_news_html_' + rand);
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
                html: $dom.html('script#image-fader-' + rand + '-news-item-' + i + '-html'),
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
            $dom.hide(fpAnimationHtml);
            $dom.html(fpAnimationHtml, data[cycleIndex].html);
            $dom.fadeIn(fpAnimationHtml);
            fpAnimationUrl.href = data[cycleIndex].url;

            // Set up fade
            fpAnimationNewsImg.src = fpAnimationImg.src;
            $dom.fadeOut(fpAnimationNewsImg);
            $dom.fadeIn(fpAnimationImg);
            fpAnimationImg.src = $cms.img(data[cycleIndex].imageUrl);
            setTimeout(function () { // Will know dimensions by the time the timeout happens
                fpAnimationNewsImg.style.left = ((fpAnimationNewsImg.parentNode.offsetHeight - fpAnimationNewsImg.offsetWidth) / 2) + 'px';
                fpAnimationNewsImg.style.top = ((fpAnimationNewsImg.parentNode.offsetHeight - fpAnimationNewsImg.offsetHeight) / 2) + 'px';
            }, 0);
            
            $dom.$('#pause_button_' + rand).classList.remove('button_depressed');

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
                $dom.$('#pause_button_' + rand).classList.add('button_depressed');
            } else {
                // Unpause
                $dom.$('#pause_button_' + rand).classList.remove('button_depressed');

                if (milliseconds && (news.length > 1)) {
                    cycleTimerId = setTimeout(function () {
                        doCycle(1);
                    }, milliseconds);
                }
            }
        }

        /// Start cycle
        doCycle();

        $dom.on(container, 'click', '.js-click-btn-prev-cycle', function () {
            doCycle(-1);
        });

        $dom.on(container, 'click', '.js-click-btn-pause-cycle', function () {
            pauseCycle();
        });

        $dom.on(container, 'click', '.js-click-btn-next-cycle', function () {
            doCycle(1);
        });
    };

    $cms.templates.blockBottomNews = function blockBottomNews(params) {
        window.tickPos = window.tickPos || {};

        var newsTickerText = $cms.filter.nl(params.newsTickerText),
            ticktickticker = $dom.$('#ticktickticker_news' + params.bottomNewsId),
            myId = 'ticker-' - $util.random();

        window.tickPos[myId] = 400;
        $dom.html(ticktickticker, '<div class="ticker" style="text-indent: 400px; width: 400px;" id="' + myId + '"><span>' + newsTickerText + '</span></div>');

        setInterval(function () {
            tickerTick(myId, 400);
        }, 50);
    };
}(window.$cms, window.$util, window.$dom));
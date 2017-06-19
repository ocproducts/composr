(function ($cms) {
    'use strict';

    $cms.templates.blockMainImageFaderNews = function blockMainImageFaderNews(params, container) {
        var rand = strVal(params.randFaderNews),
            news = strVal(params.news),
            itemsHtml = JSON.parse(strVal(params.newsItemsHtmlJson));

        if (!Array.isArray(itemsHtml)) {
            itemsHtml = [];
        }

        // Variables we will need
        var fpAnimation = $cms.dom.$('#image_fader_news_' + rand),
            fpAnimationUrl = $cms.dom.$('#image_fader_news_url_' + rand),
            fpAnimationHtml = $cms.dom.$('#image_fader_news_html_' + rand);

        // For pause function
        var pause = 'main_image_fader_news_pause_' + rand;

        // For cycle Function
        var cycleCount = 'main_image_fader_news_cycle_count_' + rand,
            cycleTimer = 'main_image_fader_news_cycle_timer_' + rand,
            cycle = 'main_image_fader_news_cycle_' + rand;

        // Create fader
        var fpAnimationNews = document.createElement('img');

        fpAnimationNews.style.position = 'absolute';
        fpAnimationNews.src = $cms.img('{$IMG;,blank}');
        fpAnimation.parentElement.insertBefore(fpAnimationNews, fpAnimation);
        fpAnimation.parentElement.style.position = 'relative';
        fpAnimation.parentElement.style.display = 'block';

        var data = [], i;

        for (i = 0; i < news.length; i++) {
            data.push({
                html: itemsHtml[i],
                url:  news[i].url,
                image_url: news[i].imageUrl
            });

            new Image().src = news[i].imageUrl; // precache
        }

        // Pause function
        window[pause] = function () {
            if (window[cycleTimer]) {
                window.clearTimeout(cycleTimer);
                window[cycleTimer] = null;
                $cms.dom.$('#pause_button_' + rand).classList.add('button_depressed');
            } else {
                $cms.dom.$('#pause_button_' + rand).classList.remove('button_depressed');

                window[cycleTimer] = window.setTimeout(function () {
                    window[cycle](1);
                }, +params.mill);
            }
            return false;
        };

        // Cycling function
        window[cycleCount] = 0;
        window[cycleTimer] = null;
        window[cycle] = function (dif) {
            //  Cycle
            var j = window[cycleCount] + dif;
            if (j < 0) {
                j = data.length - 1;
            }
            if (j >= data.length) {
                j = 0;
            }
            window[cycleCount] = j;

            // Simple data copy
            $cms.dom.html(fpAnimationHtml, data[j].html);
            fpAnimationUrl.href = data[j].url;

            // Set up fade
            fpAnimationNews.src = fpAnimation.src;
            $cms.dom.clearTransitionAndSetOpacity(fpAnimationNews, 1.0);
            $cms.dom.fadeTransition(fpAnimationNews, 0, 30, -4);
            $cms.dom.clearTransitionAndSetOpacity(fpAnimation, 0.0);
            $cms.dom.fadeTransition(fpAnimation, 100, 30, 4);
            fpAnimation.src = data[j].image_url;
            window.setTimeout(function () { // Will know dimensions by the time the timeout happens
                fpAnimationNews.style.left = ((fpAnimationNews.parentNode.offsetHeight - fpAnimationNews.offsetWidth) / 2) + 'px';
                fpAnimationNews.style.top = ((fpAnimationNews.parentNode.offsetHeight - fpAnimationNews.offsetHeight) / 2) + 'px';
            }, 0);

            // Set up timer for next time
            if (window[cycleTimer]) {
                window.clearTimeout(window[cycleTimer]);
            }
            $cms.dom.$('#pause_button_' + rand).classList.remove('button_depressed');
            if (news.length > 1) {
                window[cycleTimer] = window.setTimeout(function () {
                    window[cycle](1);
                }, params.mill);
            }

            return false;
        };

        window[cycle](0);

        $cms.dom.on(container, 'click', '.js-click-btn-prev-cycle', function () {
            window[cycle](-1);
        });

        $cms.dom.on(container, 'click', '.js-click-btn-pause-cycle', function () {
            window[pause]();
        });

        $cms.dom.on(container, 'click', '.js-click-btn-next-cycle', function () {
            window[cycle](1);
        });
    };

    $cms.templates.blockBottomNews = function blockBottomNews(params) {
        window.tick_pos = window.tick_pos || [];

        var newsTickerText = $cms.filter.nl(params.newsTickerText),
            ticktickticker = $cms.dom.$('#ticktickticker_news' + params.bottomNewsId),
            myId = $cms.random();

        window.tick_pos[myId] = 400;
        $cms.dom.html(ticktickticker, '<div class="ticker" style="text-indent: 400px; width: 400px;" id="' + myId + '"><span>' + newsTickerText + '</span></div>');

        window.setInterval(function () {
            ticker_tick(myId, 400);
        }, 50);

    };
}(window.$cms));

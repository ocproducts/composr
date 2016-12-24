(function ($cms) {
    'use strict';

    $cms.templates.blockMainImageFaderNews = function (params, container) {
        var rand = strVal(params.randFaderNews),
            news = strVal(params.news),
            itemsHtml = JSON.parse(strVal(params.newsItemsHtmlJson));

        if (!Array.isArray(itemsHtml)) {
            itemsHtml = [];
        }

        // Variables we will need
        var fp_animation = $cms.dom.$('#image_fader_news_' + rand),
            fp_animation_url = $cms.dom.$('#image_fader_news_url_' + rand),
            fp_animation_html = $cms.dom.$('#image_fader_news_html_' + rand);

        // For pause function
        var pause = 'main_image_fader_news_pause_' + rand;

        // For cycle Function
        var cycleCount = 'main_image_fader_news_cycle_count_' + rand,
            cycleTimer = 'main_image_fader_news_cycle_timer_' + rand,
            cycle = 'main_image_fader_news_cycle_' + rand;

        // Create fader
        var fp_animation_news = document.createElement('img');

        fp_animation_news.style.position = 'absolute';
        fp_animation_news.src = '{$IMG;,blank}';
        fp_animation.parentElement.insertBefore(fp_animation_news, fp_animation);
        fp_animation.parentElement.style.position = 'relative';
        fp_animation.parentElement.style.display = 'block';

        var data = [], i;

        for (i = 0; i < news.length; i++) {
            data.push({
                html: itemsHtml[i],
                url:  news[i].url,
                image_url: news[i].imageUrl
            });

            new Image().src = news[i].imageUrl; // precache
        }

        // Pause function}
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

            // Simple data copy}
            $cms.dom.html(fp_animation_html, data[j].html);
            fp_animation_url.href = data[j].url;

            // Set up fade}
            fp_animation_news.src = fp_animation.src;
            clear_transition_and_set_opacity(fp_animation_news, 1.0);
            fade_transition(fp_animation_news, 0, 30, -4);
            clear_transition_and_set_opacity(fp_animation, 0.0);
            fade_transition(fp_animation, 100, 30, 4);
            fp_animation.src = data[j].image_url;
            window.setTimeout(function () { // Will know dimensions by the time the timeout happens}
                fp_animation_news.style.left = ((fp_animation_news.parentNode.offsetHeight - fp_animation_news.offsetWidth) / 2) + 'px';
                fp_animation_news.style.top = ((fp_animation_news.parentNode.offsetHeight - fp_animation_news.offsetHeight) / 2) + 'px';
            }, 0);

            // Set up timer for next time}
            if (window[cycleTimer]) {
                window.clearTimeout(window[cycleTimer]);
            }
            $cms.dom.$('#pause_button_' + rand).classList.remove('button_depressed');
            window[cycleTimer] = window.setTimeout(function () {
                window[cycle](1);
            }, params.mill);

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
        var newsTickerText = $cms.filter.nl(params.newsTickerText);

        window.tick_pos = window.tick_pos || [];
        var ticktickticker = $cms.dom.$('#ticktickticker_news' + params.bottomNewsId);
        if (document.createElement('marquee').scrolldelay === undefined) {// Slower, but chrome does not support marquee's
            var my_id = parseInt(Math.random() * 10000);
            window.tick_pos[my_id] = 400;
            $cms.dom.html(ticktickticker, '<div onmouseover="this.mouseisover=true;" onmouseout="this.mouseisover=false;" class="ticker" ' +
                'style="text-indent: 400px; width: 400px;" id="' + my_id + '"><span>' + newsTickerText + '</span></div>');
            window.focused = true;
            window.addEventListener("focus", function () {
                window.focused = true;
            });
            window.addEventListener("blur", function () {
                window.focused = false;
            });
            window.setInterval(function () {
                ticker_tick(my_id, 400);
            }, 50);
        } else {
            $cms.dom.html(ticktickticker, '<marquee style="display: block" class="ticker" onmouseover="this.setAttribute(\'scrolldelay\',\'10000\');" ' +
                'onmouseout="this.setAttribute(\'scrolldelay\',50);" scrollamount="2" scrolldelay="' + (50) + '" width="400">' + newsTickerText + '</marquee>');
        }
    };
}(window.$cms));
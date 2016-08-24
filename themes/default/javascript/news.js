(function ($, Composr) {
    Composr.templates.news = {
        blockBottomNews: function blockBottomNews(options) {
            var newsTickerText = Composr.filters.stripNewLines(options.newsTickerText);

            window.tick_pos = window.tick_pos || [];
            var ticktickticker = document.getElementById('ticktickticker_news' + options.bottomNewsId);
            if (typeof document.createElement('marquee').scrolldelay === 'undefined') {// Slower, but chrome does not support marquee's
                var my_id=parseInt(Math.random()*10000);
                window.tick_pos[my_id]=400;
                set_inner_html(ticktickticker,'<div onmouseover="this.mouseisover=true;" onmouseout="this.mouseisover=false;" class="ticker" ' +
                    'style="text-indent: 400px; width: 400px;" id="'+my_id+'"><span>' + newsTickerText + '</span></div>');
                window.focused=true;
                window.addEventListener("focus",function() { window.focused=true; });
                window.addEventListener("blur",function() { window.focused=false; });
                window.setInterval(function() { ticker_tick(my_id,400); }, 50);
            } else {
                set_inner_html(ticktickticker,'<marquee style="display: block" class="ticker" onmouseover="this.setAttribute(\'scrolldelay\',\'10000\');" ' +
                    'onmouseout="this.setAttribute(\'scrolldelay\',50);" scrollamount="2" scrolldelay="'+(50)+'" width="400">' + newsTickerText +'</marquee>');
            }
        }
    };

    Composr.behaviors.news = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'news');
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);
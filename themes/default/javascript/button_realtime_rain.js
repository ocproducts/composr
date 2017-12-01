(function ($cms, $util, $dom) {
    'use strict';

    $cms.behaviors.btnLoadRealtimeRain = {
        attach: function (context) {
            $util.once($dom.$$$(context, '[data-btn-load-realtime-rain]'), 'behavior.btnLoadRealtimeRain').forEach(function (btn) {
                $dom.on(btn, 'click', function (e) {
                    e.preventDefault();
                    loadRealtimeRain();
                });
            });
        }
    };
    
    function loadRealtimeRain() {
        if (window.$realtimeRain != null) {
            window.$realtimeRain.load();
            return;
        }
    
        if (document.getElementById('realtime_rain_img_loader')) {
            setTimeout(loadRealtimeRain, 200);
            return;
        }

        var img = document.getElementById('realtime_rain_img');
        img.className = 'footer_button_loading';
        var tmpEl = document.createElement('img');
        tmpEl.src = $util.srl('{$IMG;,loading}');
        tmpEl.style.position = 'absolute';
        tmpEl.style.left = ($dom.findPosX(img) + 2) + 'px';
        tmpEl.style.top = ($dom.findPosY(img) + 1) + 'px';
        tmpEl.id = 'realtime_rain_img_loader';
        img.parentNode.appendChild(tmpEl);

        $cms.requireCss('realtime_rain');
        $cms.requireJavascript('realtime_rain');
        setTimeout(loadRealtimeRain, 200);
    }

}(window.$cms, window.$util, window.$dom));



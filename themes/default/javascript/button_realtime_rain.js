function loadRealtimeRain() {
    if (window.$realtimeRain === undefined) {
        if (document.getElementById('realtime_rain_img_loader')) {
            setTimeout(loadRealtimeRain, 200);
            return;
        }

        var img = document.getElementById('realtime_rain_img');
        img.className = 'footer_button_loading';
        var tmpEl = document.createElement('img');
        tmpEl.src = $cms.img('{$IMG;,loading}');
        tmpEl.style.position = 'absolute';
        tmpEl.style.left = ($dom.findPosX(img) + 2) + 'px';
        tmpEl.style.top = ($dom.findPosY(img) + 1) + 'px';
        tmpEl.id = 'realtime_rain_img_loader';
        img.parentNode.appendChild(tmpEl);

        $cms.requireCss('realtime_rain');
        $cms.requireJavascript('realtime_rain');
        setTimeout(loadRealtimeRain, 200);
        return;
    }
    
    window.$realtimeRain.realtimeRainButtonLoadHandler();
}

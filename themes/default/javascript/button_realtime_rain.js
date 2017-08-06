function loadRealtimeRain() {
    if (window.realtimeRainButtonLoadHandler === undefined) {
        if (document.getElementById('realtime_rain_img_loader')) {
            setTimeout(loadRealtimeRain, 200);
            return;
        }

        var img = document.getElementById('realtime_rain_img');
        img.className = 'footer_button_loading';
        var tmpElement = document.createElement('img');
        tmpElement.src = $cms.img('{$IMG;,loading}');
        tmpElement.style.position = 'absolute';
        tmpElement.style.left = ($cms.dom.findPosX(img) + 2) + 'px';
        tmpElement.style.top = ($cms.dom.findPosY(img) + 1) + 'px';
        tmpElement.id = 'realtime_rain_img_loader';
        img.parentNode.appendChild(tmpElement);

        $cms.requireCss('realtime_rain');
        $cms.requireJavascript('realtime_rain');
        setTimeout(loadRealtimeRain, 200);
        return;
    }
    
    if (window.realtimeRainButtonLoadHandler !== undefined) {
        window.realtimeRainButtonLoadHandler();
        return;
    }
    
    window.location.href = document.getElementById('realtime_rain_button').href;
}

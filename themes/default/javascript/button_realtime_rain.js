"use strict";

function load_realtime_rain() {
    if ((window.realtime_rain_button_load_handler === undefined) || (window.do_ajax_request === undefined)) {
        if (document.getElementById('realtime_rain_img_loader')) {
            setTimeout(load_realtime_rain, 200);
            return false;
        }

        var img = document.getElementById('realtime_rain_img');
        img.className = 'footer_button_loading';
        var tmp_element = document.createElement('img');
        tmp_element.src = $cms.img('{$IMG;,loading}');
        tmp_element.style.position = 'absolute';
        tmp_element.style.left = ($cms.dom.findPosX(img) + 2) + 'px';
        tmp_element.style.top = ($cms.dom.findPosY(img) + 1) + 'px';
        tmp_element.id = 'realtime_rain_img_loader';
        img.parentNode.appendChild(tmp_element);

        $cms.requireJavascript('ajax');
        $cms.requireJavascript('realtime_rain');
        $cms.requireCss('realtime_rain');
        window.setTimeout(load_realtime_rain, 200);

        return false;
    }
    if ((window.realtime_rain_button_load_handler !== undefined)) {
        return realtime_rain_button_load_handler();
    }
    window.location.href = document.getElementById('realtime_rain_button').href;
    return false;
}

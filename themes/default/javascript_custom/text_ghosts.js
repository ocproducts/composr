function show_ghost(html_message) {
    var div = document.createElement('div');
    div.style.position = 'absolute';
    div.className = 'ghost';
    $cms.dom.html(div, html_message);
    var limit = 36;
    for (var counter = 0; counter < limit; counter++) {
        window.setTimeout(build_ghost_func(div, counter, limit), counter * 100);
    }
    window.setTimeout(function () {
        document.body.removeChild(div);
    }, counter * 100);
    document.body.appendChild(div);
}

function build_ghost_func(div, counter, limit) {
    return function () {
        div.style.fontSize = (1 + 0.05 * counter) + 'em';
        $cms.dom.clearTransitionAndSetOpacity(div, 1.0 - counter / limit / 1.3);
        div.style.left = (($cms.dom.getWindowWidth() - div.offsetWidth) / 2 + window.pageXOffset) + 'px';
        div.style.top = (($cms.dom.getWindowHeight() - div.offsetHeight) / 2 - 20 + window.pageYOffset) + 'px';
    }
}

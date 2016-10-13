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
        clear_transition_and_set_opacity(div, 1.0 - counter / limit / 1.3);
        div.style.left = ((get_window_width() - div.offsetWidth) / 2 + window.pageXOffset) + 'px';
        div.style.top = ((get_window_height() - div.offsetHeight) / 2 - 20 + window.pageYOffset) + 'px';
    }
}

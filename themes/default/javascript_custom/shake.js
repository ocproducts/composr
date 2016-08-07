function do_shake() {
    var seconds = 1, amount = 30;

    var overflow_before = abstract_get_computed_style(document.body, 'overflow');
    document.body.style.overflow = 'hidden';

    var divs = document.getElementsByTagName('div'), current_positioning;
    for (var i = 0; i < divs.length; i++) {
        current_positioning = abstract_get_computed_style(divs[i], 'position');
        if ((current_positioning == '') || (current_positioning == 'static')) {
            divs[i].vector_speed = Math.round(Math.random() * 2);
            divs[i].style.position = 'relative';
        }
    }
    for (var times = 0; times < 10; times++)
        window.setTimeout(shake_animate_func(times, divs, amount), 100 * times * seconds);
    for (var times = 8; times >= 0; times--)
        window.setTimeout(shake_animate_func(times, divs, amount), 1000 * seconds + 100 * (8 - times) * seconds);

    window.setTimeout(function () {
        for (var i = 0; i < divs.length; i++) {
            if (typeof divs[i].vector_speed != 'undefined') {
                divs[i].style.left = '0';
                divs[i].style.top = '0';
                divs[i].style.position = 'static';
            }
        }

        document.body.style.overflow = overflow_before;
    }, 1000 * seconds * 2);
}

function shake_animate_func(times, divs, amount) {
    return function () {
        for (var i = 0; i < divs.length; i++) {
            if (typeof divs[i].vector_speed != 'undefined') {
                divs[i].vector_target = [Math.round(amount - Math.random() * amount * 2), Math.round(amount - Math.random() * amount * 2)];

                divs[i].style.left = Math.round(divs[i].vector_target[0] * times / 10.0) + 'px';
                divs[i].style.top = Math.round(divs[i].vector_target[1] * times / 10.0) + 'px';
            }
        }
    };
}

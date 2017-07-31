function doShake() {
    var seconds = 1, amount = 30;

    var overflowBefore = window.getComputedStyle(document.body).getPropertyValue('overflow');
    document.body.style.overflow = 'hidden';

    var divs = document.getElementsByTagName('div'), currentPositioning;
    for (var i = 0; i < divs.length; i++) {
        currentPositioning = window.getComputedStyle(divs[i]).getPropertyValue('position');
        if ((currentPositioning == '') || (currentPositioning == 'static')) {
            divs[i].vectorSpeed = Math.round(Math.random() * 2);
            divs[i].style.position = 'relative';
        }
    }
    for (var times = 0; times < 10; times++) {
        window.setTimeout(shakeAnimateFunc(times, divs, amount), 100 * times * seconds);
    }

    for (var times = 8; times >= 0; times--) {
        window.setTimeout(shakeAnimateFunc(times, divs, amount), 1000 * seconds + 100 * (8 - times) * seconds);
    }

    window.setTimeout(function () {
        for (var i = 0; i < divs.length; i++) {
            if (typeof divs[i].vectorSpeed !== 'undefined') {
                divs[i].style.left = '0';
                divs[i].style.top = '0';
                divs[i].style.position = 'static';
            }
        }

        document.body.style.overflow = overflowBefore;
    }, 1000 * seconds * 2);

    function shakeAnimateFunc(times, divs, amount) {
        return function () {
            for (var i = 0; i < divs.length; i++) {
                if (typeof divs[i].vectorSpeed !== 'undefined') {
                    divs[i].vectorTarget = [Math.round(amount - Math.random() * amount * 2), Math.round(amount - Math.random() * amount * 2)];

                    divs[i].style.left = Math.round(divs[i].vectorTarget[0] * times / 10.0) + 'px';
                    divs[i].style.top = Math.round(divs[i].vectorTarget[1] * times / 10.0) + 'px';
                }
            }
        };
    }
}

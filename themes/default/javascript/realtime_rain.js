"use strict";

(function ($cms) {
    'use strict';

    $cms.templates.realtimeRainOverlay = function (params, container) {
        window.min_time = +params.minTime || 0;
        window.paused = false;
        window.bubble_groups = {};
        window.total_lines = 0;
        window.bubble_timer_1 = null;
        window.bubble_timer_2 = null;

        startRealtimeRain();

        $cms.dom.on(container, 'mouseover mouseover', '.js-hover-window-pause', function (e, target) {
            if (target.contains(e.relatedTarget)) {
                return;
            }

            if (e.type === 'mouseover') {
                if (!window.paused) {
                    target.pausing = true;
                    window.paused = true;
                }
            } else {
                if (target.pausing) {
                    target.pausing = false;
                    window.paused = false;
                }
            }
        });

        $cms.dom.on(container, 'mouseover', '.js-mouseover-set-time-line-position', function (){
            setTimeLinePosition(window.current_time);
        });

        $cms.dom.on(container, 'click', '.js-click-toggle-window-pausing', function (e, btn) {
            window.paused = !window.paused;
            btn.classList.toggle('paused', window.paused);
        });

        $cms.dom.on(container, 'mousemove', '.js-mousemove-timeline-click', function () {
            timelineClick(true);
        });

        $cms.dom.on(container, 'click', '.js-click-timeline-click', function () {
            timelineClick(false);
        });

        $cms.dom.on(container, 'mouseover mouseout', '.js-hover-toggle-real-time-indicator', function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                window.disable_real_time_indicator = (e.type === 'mouseover');
            }
        });

        $cms.dom.on(container, 'click', '.js-click-rain-slow-down', function () {
            window.time_window = window.time_window / 1.2;
        });

        $cms.dom.on(container, 'click', '.js-click-rain-slow-up', function () {
            window.time_window = window.time_window * 1.2;
        });
    };

    $cms.templates.realtimeRainBubble = function (params, container) {
        window.pending_eval_function = function (el) { // In webkit you can't get a node until it's been closed, so we need to set our code into a function and THEN run it
            if (params.tickerText !== undefined) {
                window.setTimeout(function () {
                    $cms.dom.html(document.getElementById('news_go_here'), params.tickerText);
                }, params.relativeTimestamp * 1000);
            }
            // Set up extra attributes
            el.time_offset = params.relativeTimestamp;
            el.lines_for = [];

            if (params.groupId !== undefined){
                el.lines_for.push(params.groupId);
            }

            if ((params.specialIcon !== undefined) && (params.specialIcon === 'email-icon')) {
                el.icon_multiplicity = params.multiplicity;
            }
        };
    };
}(window.$cms));

// Handle the realtime_rain button on the bottom bar
function realtimeRainButtonLoadHandler() {
    var img = $cms.dom.$('#realtime_rain_img');

    var e = $cms.dom.$('#real_time_surround');
    if (e) {// Clicked twice - so now we close it
        bubblesTidyUp();
        if (window.bubble_timer_1) {
            window.clearInterval(window.bubble_timer_1);
            window.bubble_timer_1 = null;
        }

        if (window.bubble_timer_2) {
            window.clearInterval(window.bubble_timer_2);
            window.bubble_timer_2 = null;
        }

        if (e.parentNode) {
            e.parentNode.parentNode.removeChild(e.parentNode);
        }

        img.src = $cms.img('{$IMG;,icons/24x24/tool_buttons/realtime_rain_on}');
        if (img.srcset !== undefined) {
            img.srcset = $cms.img('{$IMG;,icons/48x48/tool_buttons/realtime_rain_on}') + ' 2x';
        }

        return false;
    }

    img.src = $cms.img('{$IMG;,icons/24x24/tool_buttons/realtime_rain_off}');
    if (img.srcset !== undefined) {
        img.srcset = $cms.img('{$IMG;,icons/48x48/tool_buttons/realtime_rain_off}') + ' 2x';
    }

    var tmpElement = document.getElementById('realtime_rain_img_loader');
    if (tmpElement) {
        tmpElement.parentNode.removeChild(tmpElement);
    }

    img.className = '';

    var x = document.createElement('div');
    document.body.appendChild(x);
    $cms.dom.html(x, $cms.loadSnippet('realtime_rain_load'));
    e = document.getElementById('real_time_surround');
    e.style.position = 'absolute';
    e.style.zIndex = 100;
    e.style.left = 0;
    e.style.top = 0;
    e.style.width = '100%';
    e.style.height = ($cms.dom.getWindowScrollHeight() - 40) + 'px';
    $cms.dom.smoothScroll(0);

    startRealtimeRain();

    return false; // No need to load link now, because we've done an overlay
}

// Called to start the animation
function startRealtimeRain() {
    var newsTicker = document.getElementById('news_ticker');
    newsTicker.style.top = '20px';
    newsTicker.style.left = ($cms.dom.getWindowWidth() / 2 - newsTicker.offsetWidth / 2) + 'px';

    document.getElementById('loading_icon').style.display = 'block';

    window.current_time = timeNow() - 10;
    window.time_window = 10;
    getMoreEvents(window.current_time + 1, window.current_time + window.time_window); // note the +1 is because the time window is inclusive
    window.bubble_timer_1 = window.setInterval(function () {
        if (window.paused) return;
        getMoreEvents(window.current_time + 1, window.current_time + window.time_window);
    }, 10000);
    window.bubble_timer_2 = window.setInterval(function () {
        if (window.paused) return;
        if (window.time_window + window.current_time > timeNow()) {
            window.time_window = 10;
            window.current_time = timeNow() - 10;
        }
        if ((window.disable_real_time_indicator === undefined) || (!window.disable_real_time_indicator)) setTimeLinePosition(window.current_time);
        window.current_time += window.time_window / 10.0;
    }, 1000);
}

function getMoreEvents(from, to) {
    from = Math.round(from);
    to = Math.round(to);

    var url = $cms.baseUrl('data/realtime_rain.php?from=' + encodeURIComponent(from) + '&to=' + encodeURIComponent(to) + $cms.keepStub());
    $cms.doAjaxRequest(url, receivedEvents);
}

function receivedEvents(ajaxResultFrame, ajaxResult) {
    document.getElementById('loading_icon').style.display = 'none';

    var bubbles = document.getElementById('bubbles_go_here');

    var maxHeight = bubbles.parentNode.offsetHeight;
    var totalVerticalSlots = maxHeight / 183;
    var heightPerSecond = maxHeight / 10;
    var frameDelay = (1000 / heightPerSecond) / 1.1; // 1.1 is a fudge factor to reduce chance of overlap (creates slight inaccuracy in spacing though)

    var windowWidth = $cms.dom.getWindowWidth(),
        elements = ajaxResult.children,
        leftPos = 25;

    elements.some(function (element) {
        var _clonedMessage, clonedMessage;

        if (element.localName !== 'div') {
            return; // (continue)
        }

        // Set up HTML (difficult, as we are copying from XML)
        _clonedMessage = element;

        try {
            _clonedMessage = document.importNode(element, true);
        } catch (ignore) {}

        clonedMessage = $cms.dom.create('div', {
            id: _clonedMessage.getAttribute('id'),
            class: _clonedMessage.getAttribute('class'),
            html: $cms.dom.html(_clonedMessage)
        });

        leftPos += 200;
        if (leftPos >= windowWidth) {
            // Too much!
            return true; // (break)
        }
        window.setTimeout(function () {
            window.pending_eval_function(clonedMessage);

            // Set positioning (or break-out if we have too many bubbles to show)
            clonedMessage.style.position = 'absolute';
            clonedMessage.style.zIndex = 50;
            clonedMessage.style.left = leftPos + 'px';
            bubbles.appendChild(clonedMessage);
            var verticalSlot = Math.round(totalVerticalSlots * clonedMessage.time_offset / window.time_window);
            clonedMessage.style.top = (-(verticalSlot + 1) * clonedMessage.offsetHeight) + 'px';

            // JS events, for pausing and changing z-index
            clonedMessage.addEventListener('mouseover', function () {
                this.style.zIndex = 160;
                if (!window.paused) {
                    this.pausing = true;
                    window.paused = true;
                }
            });
            clonedMessage.addEventListener('mouseout', function () {
                this.style.zIndex = 50;
                if (this.pausing) {
                    this.pausing = false;
                    window.paused = false;
                }
            });

            // Draw lines and emails animation (after delay, so that we know it's rendered by then and hence knows full coordinates)
            window.setTimeout(function () {
                if ((clonedMessage.lines_for === undefined) || (clonedMessage.icon_multiplicity === undefined)) {
                    return;
                }

                var num = clonedMessage.icon_multiplicity,
                    mainIcon = clonedMessage.querySelector('.email-icon'),
                    iconSpot = $cms.dom.$('#real_time_surround');

                if ($cms.dom.findPosY(iconSpot, true) > 0) {
                    iconSpot = iconSpot.parentNode;
                }
                for (var x = 0; x < num; x++) {
                    window.setTimeout(function () {
                        var nextIcon = document.createElement('div');
                        nextIcon.className = mainIcon.className;
                        $cms.dom.html(nextIcon, $cms.dom.html(mainIcon));
                        nextIcon.style.position = 'absolute';
                        nextIcon.style.left = $cms.dom.findPosX(mainIcon, true) + 'px';
                        nextIcon.style.top = $cms.dom.findPosY(mainIcon, true) + 'px';
                        nextIcon.style.zIndex = 80;
                        nextIcon.x_vector = 5 - Math.random() * 10;
                        nextIcon.y_vector = -Math.random() * 6;
                        nextIcon.opacity = 1.0;
                        iconSpot.appendChild(nextIcon);
                        nextIcon.animation_timer = window.setInterval(function () {
                            if (window.paused) return;

                            var left = ((parseInt(nextIcon.style.left) || 0) + nextIcon.x_vector);
                            nextIcon.style.left = left + 'px';
                            var top = ((parseInt(nextIcon.style.top) || 0) + nextIcon.y_vector);
                            nextIcon.style.top = top + 'px';
                            $cms.dom.clearTransitionAndSetOpacity(nextIcon, nextIcon.opacity);
                            nextIcon.opacity *= 0.98;
                            nextIcon.y_vector += 0.2;
                            if ((top > maxHeight) || (nextIcon.opacity < 0.05) || (left + 50 > windowWidth) || (left < 0)) {
                                window.clearInterval(nextIcon.animation_timer);
                                nextIcon.animation_timer = null;
                                nextIcon.parentNode.removeChild(nextIcon);
                            }
                        }, 50);
                    }, 7000 + 500 * x);
                }
            }, 100);

            // Set up animation timer
            clonedMessage.timer = window.setInterval(function () {
                animateDown(clonedMessage);
            }, frameDelay);
        }, 0);
    });
}

function animateDown(el, avoidRemove) {
    if (window.paused) {
        return;
    }

    avoidRemove = !!avoidRemove;

    var bubbles = document.getElementById('bubbles_go_here');
    var maxHeight = bubbles.parentNode.offsetHeight;
    var jumpSpeed = 1;
    var newPos = (parseInt(el.style.top) || 0) + jumpSpeed;
    el.style.top = newPos + 'px';

    if ((newPos > maxHeight) || (!el.parentNode)) {
        if (!avoidRemove) {
            if (el.parentNode) {
                window.total_lines -= el.querySelectorAll('.line').length;
                el.parentNode.removeChild(el);
            }
            window.clearInterval(el.timer);
            el.timer = null;
        }
    }
}

function timeNow() {
    return Math.round(Date.now() / 1000);
}

function timelineClick(prospective) {
    prospective = !!prospective;

    var pos = window.mouse_x - $cms.dom.findPosX(document.getElementById('time_line_image'), true);
    var timelineLength = 808;
    var minTime = window.min_time;
    var maxTime = timeNow();
    var time = minTime + pos * (maxTime - minTime) / timelineLength;
    if (!prospective) {
        window.current_time = time;
        bubblesTidyUp();
        $cms.dom.html(document.getElementById('real_time_date'), '{!SET;^}');
        $cms.dom.html(document.getElementById('real_time_time'), '');
        document.getElementById('loading_icon').style.display = 'block';
    } else {
        setTimeLinePosition(time);
    }
}

function bubblesTidyUp() {
    var bubblesGoHere = document.getElementById('bubbles_go_here');
    if (!bubblesGoHere) return;
    var bubbles = document.getElementById('real_time_surround').parentNode.querySelectorAll('.bubble_wrap');
    for (var i = 0; i < bubbles.length; i++) {
        if (bubbles[i].timer) {
            window.clearInterval(bubbles[i].timer);
            bubbles[i].timer = null;
        }
    }
    $cms.dom.html(bubblesGoHere, '');
    window.bubble_groups = [];
    window.total_lines = 0;
    var icons = document.getElementById('real_time_surround').parentNode.querySelectorAll('.email_icon');
    for (var i = 0; i < icons.length; i++) {
        if (icons[i].animation_timer) {
            window.clearInterval(icons[i].animation_timer);
            icons[i].animation_timer = null;
        }
        icons[i].parentNode.removeChild(icons[i]);
    }
}

function setTimeLinePosition(time) {
    time = Math.round(time);

    var marker = document.getElementById('real_time_indicator');
    var timelineLength = 808;
    var minTime = window.min_time;
    var maxTime = timeNow();
    var timelineRange = maxTime - minTime;
    var timelineOffsetTime = time - minTime;
    var timelineOffsetPosition = timelineOffsetTime * timelineLength / timelineRange;
    marker.style.marginLeft = (50 + timelineOffsetPosition) + 'px';

    var dateObject = new Date();
    dateObject.setTime(time * 1000);
    var realtimedate = document.getElementById('real_time_date');
    var realtimetime = document.getElementById('real_time_time');
    if (!realtimedate) return;
    $cms.dom.html(realtimedate, dateObject.getFullYear() + '/' + ('' + dateObject.getMonth()) + '/' + ('' + dateObject.getDate()));
    $cms.dom.html(realtimetime, ('' + dateObject.getHours()) + ':' + ('' + dateObject.getMinutes()) + ':' + ('' + dateObject.getSeconds()));
}
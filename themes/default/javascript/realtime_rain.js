'use strict';

(function ($cms) {
    'use strict';

    $cms.templates.realtimeRainOverlay = function (params, container) {
        window.minTime = +params.minTime || 0;
        window.paused = false;
        window.bubbleGroups = {};
        window.totalLines = 0;
        window.bubbleTimer1 = null;
        window.bubbleTimer2 = null;

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

        $cms.dom.on(container, 'mouseover', '.js-mouseover-set-time-line-position', function () {
            setTimeLinePosition(window.currentTime);
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
                window.disableRealTimeIndicator = (e.type === 'mouseover');
            }
        });

        $cms.dom.on(container, 'click', '.js-click-rain-slow-down', function () {
            window.timeWindow = window.timeWindow / 1.2;
        });

        $cms.dom.on(container, 'click', '.js-click-rain-slow-up', function () {
            window.timeWindow = window.timeWindow * 1.2;
        });
    };

    $cms.templates.realtimeRainBubble = function (params, container) {
        window.pendingEvalFunction = function (el) { // In webkit you can't get a node until it's been closed, so we need to set our code into a function and THEN run it
            if (params.tickerText !== undefined) {
                setTimeout(function () {
                    $cms.dom.html(document.getElementById('news_go_here'), params.tickerText);
                }, params.relativeTimestamp * 1000);
            }
            // Set up extra attributes
            el.timeOffset = params.relativeTimestamp;
            el.linesFor = [];

            if (params.groupId !== undefined){
                el.linesFor.push(params.groupId);
            }

            if ((params.specialIcon !== undefined) && (params.specialIcon === 'email-icon')) {
                el.iconMultiplicity = params.multiplicity;
            }
        };
    };
}(window.$cms));

// Handle the realtime_rain button on the bottom bar
function realtimeRainButtonLoadHandler() {
    var img = $cms.dom.$('#realtime_rain_img');

    var e = $cms.dom.$('#real_time_surround');
    if (e) { // Clicked twice - so now we close it
        bubblesTidyUp();
        if (window.bubbleTimer1) {
            clearInterval(window.bubbleTimer1);
            window.bubbleTimer1 = null;
        }

        if (window.bubbleTimer2) {
            clearInterval(window.bubbleTimer2);
            window.bubbleTimer2 = null;
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
    /*TODO: Synchronous XHR*/
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

    window.currentTime = timeNow() - 10;
    window.timeWindow = 10;
    getMoreEvents(window.currentTime + 1, window.currentTime + window.timeWindow); // note the +1 is because the time window is inclusive
    window.bubbleTimer1 = setInterval(function () {
        if (window.paused) return;
        getMoreEvents(window.currentTime + 1, window.currentTime + window.timeWindow);
    }, 10000);
    window.bubbleTimer2 = setInterval(function () {
        if (window.paused) return;
        if (window.timeWindow + window.currentTime > timeNow()) {
            window.timeWindow = 10;
            window.currentTime = timeNow() - 10;
        }
        if ((window.disableRealTimeIndicator === undefined) || (!window.disableRealTimeIndicator)) setTimeLinePosition(window.currentTime);
        window.currentTime += window.timeWindow / 10.0;
    }, 1000);
}

function getMoreEvents(from, to) {
    from = Math.round(from);
    to = Math.round(to);

    var url = $cms.baseUrl('data/realtime_rain.php?from=' + encodeURIComponent(from) + '&to=' + encodeURIComponent(to) + $cms.keepStub());
    $cms.doAjaxRequest(url, receivedEvents);
}

function receivedEvents(responseXml) {
    var ajaxResult = responseXml && responseXml.querySelector('result');
    
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
            className: _clonedMessage.getAttribute('class'),
            html: $cms.dom.html(_clonedMessage)
        });

        leftPos += (windowWidth > 900) ? 200 : 20;
        if (leftPos >= windowWidth) {
            // Too much!
            return true; // (break)
        }
        setTimeout(function () {
            window.pendingEvalFunction(clonedMessage);

            // Set positioning (or break-out if we have too many bubbles to show)
            clonedMessage.style.position = 'absolute';
            clonedMessage.style.zIndex = 50;
            clonedMessage.style.left = leftPos + 'px';
            bubbles.appendChild(clonedMessage);
            var verticalSlot = Math.round(totalVerticalSlots * clonedMessage.timeOffset / window.timeWindow);
            clonedMessage.style.top = (-(verticalSlot + 1) * clonedMessage.offsetHeight) + 'px';

            // JS events, for pausing and changing z-index
            clonedMessage.addEventListener('mouseover', function () {
                clonedMessage.style.zIndex = 160;
                if (!window.paused) {
                    clonedMessage.pausing = true;
                    window.paused = true;
                }
            });
            clonedMessage.addEventListener('mouseout', function () {
                clonedMessage.style.zIndex = 50;
                if (clonedMessage.pausing) {
                    clonedMessage.pausing = false;
                    window.paused = false;
                }
            });

            // Draw lines and emails animation (after delay, so that we know it's rendered by then and hence knows full coordinates)
            setTimeout(function () {
                if ((clonedMessage.linesFor === undefined) || (clonedMessage.iconMultiplicity === undefined)) {
                    return;
                }

                var num = clonedMessage.iconMultiplicity,
                    mainIcon = clonedMessage.querySelector('.email-icon'),
                    iconSpot = $cms.dom.$('#real_time_surround');

                if ($cms.dom.findPosY(iconSpot, true) > 0) {
                    iconSpot = iconSpot.parentNode;
                }
                for (var x = 0; x < num; x++) {
                    setTimeout(function () {
                        var nextIcon = document.createElement('div');
                        nextIcon.className = mainIcon.className;
                        $cms.dom.html(nextIcon, $cms.dom.html(mainIcon));
                        nextIcon.style.position = 'absolute';
                        nextIcon.style.left = $cms.dom.findPosX(mainIcon, true) + 'px';
                        nextIcon.style.top = $cms.dom.findPosY(mainIcon, true) + 'px';
                        nextIcon.style.zIndex = 80;
                        nextIcon.xVector = 5 - Math.random() * 10;
                        nextIcon.yVector = -Math.random() * 6;
                        nextIcon.opacity = 1.0;
                        iconSpot.appendChild(nextIcon);
                        nextIcon.animationTimer = setInterval(function () {
                            if (window.paused) {
                                return;
                            }

                            var _left = ((parseInt(nextIcon.style.left) || 0) + nextIcon.xVector);
                            nextIcon.style.left = _left + 'px';
                            var _top = ((parseInt(nextIcon.style.top) || 0) + nextIcon.yVector);
                            nextIcon.style.top = _top + 'px';
                            nextIcon.style.opacity = nextIcon.opacity;
                            nextIcon.opacity *= 0.98;
                            nextIcon.yVector += 0.2;
                            if ((_top > maxHeight) || (nextIcon.opacity < 0.05) || (_left + 50 > windowWidth) || (_left < 0)) {
                                clearInterval(nextIcon.animationTimer);
                                nextIcon.animationTimer = null;
                                nextIcon.parentNode.removeChild(nextIcon);
                            }
                        }, 50);
                    }, 7000 + 500 * x);
                }
            }, 100);

            // Set up animation timer
            clonedMessage.timer = setInterval(function () {
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
                window.totalLines -= el.querySelectorAll('.line').length;
                el.parentNode.removeChild(el);
            }
            clearInterval(el.timer);
            el.timer = null;
        }
    }
}

function timeNow() {
    return Math.round(Date.now() / 1000);
}

function timelineClick(prospective) {
    prospective = !!prospective;

    var pos = window.currentMouseX - $cms.dom.findPosX(document.getElementById('time_line_image'), true);
    var timelineLength = 808;
    var minTime = window.minTime;
    var maxTime = timeNow();
    var time = minTime + pos * (maxTime - minTime) / timelineLength;
    if (!prospective) {
        window.currentTime = time;
        bubblesTidyUp();
        $cms.dom.html('#real_time_date', '{!SET;^}');
        $cms.dom.html('#real_time_time', '');
        document.getElementById('loading_icon').style.display = 'block';
    } else {
        setTimeLinePosition(time);
    }
}

function bubblesTidyUp() {
    var bubblesGoHere = document.getElementById('bubbles_go_here');
    if (!bubblesGoHere) {
        return;
    }
    var bubbles = document.getElementById('real_time_surround').parentNode.querySelectorAll('.bubble_wrap');
    for (var i = 0; i < bubbles.length; i++) {
        if (bubbles[i].timer) {
            clearInterval(bubbles[i].timer);
            bubbles[i].timer = null;
        }
    }
    $cms.dom.html(bubblesGoHere, '');
    window.bubbleGroups = [];
    window.totalLines = 0;
    var icons = document.getElementById('real_time_surround').parentNode.querySelectorAll('.email_icon');
    for (var i = 0; i < icons.length; i++) {
        if (icons[i].animationTimer) {
            clearInterval(icons[i].animationTimer);
            icons[i].animationTimer = null;
        }
        icons[i].parentNode.removeChild(icons[i]);
    }
}

function setTimeLinePosition(time) {
    time = Math.round(time);

    var marker = document.getElementById('real_time_indicator'),
        timelineLength = 808,
        minTime = window.minTime,
        maxTime = timeNow(),
        timelineRange = maxTime - minTime,
        timelineOffsetTime = time - minTime,
        timelineOffsetPosition = timelineOffsetTime * timelineLength / timelineRange;
    marker.style.marginLeft = (50 + timelineOffsetPosition) + 'px';

    var dateObject = new Date();
    dateObject.setTime(time * 1000);
    var realtimedate = document.getElementById('real_time_date');
    var realtimetime = document.getElementById('real_time_time');
    if (!realtimedate) {
        return;
    }
    $cms.dom.html(realtimedate, dateObject.getFullYear() + '/' + ('' + dateObject.getMonth()) + '/' + ('' + dateObject.getDate()));
    $cms.dom.html(realtimetime, ('' + dateObject.getHours()) + ':' + ('' + dateObject.getMinutes()) + ':' + ('' + dateObject.getSeconds()));
}

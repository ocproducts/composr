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

        start_realtime_rain();

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
            set_time_line_position(window.current_time);
        });

        $cms.dom.on(container, 'click', '.js-click-toggle-window-pausing', function (e, btn) {
            window.paused = !window.paused;
            btn.classList.toggle('paused', window.paused);
        });

        $cms.dom.on(container, 'mousemove', '.js-mousemove-timeline-click', function () {
            timeline_click(true);
        });

        $cms.dom.on(container, 'click', '.js-click-timeline-click', function () {
            timeline_click(false);
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
function realtime_rain_button_load_handler() {
    var img = $cms.dom.$('#realtime_rain_img');

    var e = $cms.dom.$('#real_time_surround');
    if (e) {// Clicked twice - so now we close it
        bubbles_tidy_up();
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
    var tmp_element = document.getElementById('realtime_rain_img_loader');
    if (tmp_element) tmp_element.parentNode.removeChild(tmp_element);
    img.className = '';

    var x = document.createElement('div');
    document.body.appendChild(x);
    $cms.dom.html(x, load_snippet('realtime_rain_load'));
    e = document.getElementById('real_time_surround');
    e.style.position = 'absolute';
    e.style.zIndex = 100;
    e.style.left = 0;
    e.style.top = 0;
    e.style.width = '100%';
    e.style.height = (get_window_scroll_height() - 40) + 'px';
    smooth_scroll(0);

    start_realtime_rain();

    return false; // No need to load link now, because we've done an overlay
}

// Called to start the animation
function start_realtime_rain() {
    register_mouse_listener();

    var news_ticker = document.getElementById('news_ticker');
    news_ticker.style.top = '20px';
    news_ticker.style.left = (get_window_width() / 2 - news_ticker.offsetWidth / 2) + 'px';

    document.getElementById('loading_icon').style.display = 'block';

    window.current_time = time_now() - 10;
    window.time_window = 10;
    get_more_events(window.current_time + 1, window.current_time + window.time_window); // note the +1 is because the time window is inclusive
    window.bubble_timer_1 = window.setInterval(function () {
        if (window.paused) return;
        get_more_events(window.current_time + 1, window.current_time + window.time_window);
    }, 10000);
    window.bubble_timer_2 = window.setInterval(function () {
        if (window.paused) return;
        if (window.time_window + window.current_time > time_now()) {
            window.time_window = 10;
            window.current_time = time_now() - 10;
        }
        if ((window.disable_real_time_indicator === undefined) || (!window.disable_real_time_indicator)) set_time_line_position(window.current_time);
        window.current_time += window.time_window / 10.0;
    }, 1000);
}

function get_more_events(from, to) {
    from = Math.round(from);
    to = Math.round(to);

    var url = $cms.baseUrl('data/realtime_rain.php?from=' + encodeURIComponent(from) + '&to=' + encodeURIComponent(to) + keep_stub());
    do_ajax_request(url, received_events);
}

function received_events(ajax_result_frame, ajax_result) {
    document.getElementById('loading_icon').style.display = 'none';

    var bubbles = document.getElementById('bubbles_go_here');

    var max_height = bubbles.parentNode.offsetHeight;
    var total_vertical_slots = max_height / 183;
    var height_per_second = max_height / 10;
    var frame_delay = (1000 / height_per_second) / 1.1; // 1.1 is a fudge factor to reduce chance of overlap (creates slight inaccuracy in spacing though)

    var window_width = get_window_width(),
        elements = ajax_result.children,
        left_pos = 25;

    elements.some(function (element) {
        var _cloned_message, cloned_message;

        if (element.localName !== 'div') {
            return; // (continue)
        }

        // Set up HTML (difficult, as we are copying from XML)
        _cloned_message = careful_import_node(element);
        cloned_message = $cms.dom.create('div', {
            id: _cloned_message.getAttribute('id'),
            class: _cloned_message.getAttribute('class'),
            html: $cms.dom.html(_cloned_message)
        });

        left_pos += 200;
        if (left_pos >= window_width) {
            // Too much!
            return true; // (break)
        }
        window.setTimeout(function () {
            window.pending_eval_function(cloned_message);

            // Set positioning (or break-out if we have too many bubbles to show)
            cloned_message.style.position = 'absolute';
            cloned_message.style.zIndex = 50;
            cloned_message.style.left = left_pos + 'px';
            bubbles.appendChild(cloned_message);
            var vertical_slot = Math.round(total_vertical_slots * cloned_message.time_offset / window.time_window);
            cloned_message.style.top = (-(vertical_slot + 1) * cloned_message.offsetHeight) + 'px';

            // JS events, for pausing and changing z-index
            cloned_message.addEventListener('mouseover', function () {
                this.style.zIndex = 160;
                if (!window.paused) {
                    this.pausing = true;
                    window.paused = true;
                }
            });
            cloned_message.addEventListener('mouseout', function () {
                this.style.zIndex = 50;
                if (this.pausing) {
                    this.pausing = false;
                    window.paused = false;
                }
            });

            // Draw lines and emails animation (after delay, so that we know it's rendered by then and hence knows full coordinates)
            window.setTimeout(function () {
                if ((cloned_message.lines_for === undefined) || (cloned_message.icon_multiplicity === undefined)) {
                    return;
                }

                var num = cloned_message.icon_multiplicity,
                    main_icon = cloned_message.querySelector('.email-icon'),
                    icon_spot = $cms.dom.$('#real_time_surround');

                if (find_pos_y(icon_spot, true) > 0) {
                    icon_spot = icon_spot.parentNode;
                }
                for (var x = 0; x < num; x++) {
                    window.setTimeout(function () {
                        var next_icon = document.createElement('div');
                        next_icon.className = main_icon.className;
                        $cms.dom.html(next_icon, $cms.dom.html(main_icon));
                        next_icon.style.position = 'absolute';
                        next_icon.style.left = find_pos_x(main_icon, true) + 'px';
                        next_icon.style.top = find_pos_y(main_icon, true) + 'px';
                        next_icon.style.zIndex = 80;
                        next_icon.x_vector = 5 - Math.random() * 10;
                        next_icon.y_vector = -Math.random() * 6;
                        next_icon.opacity = 1.0;
                        icon_spot.appendChild(next_icon);
                        next_icon.animation_timer = window.setInterval(function () {
                            if (window.paused) return;

                            var left = ((parseInt(next_icon.style.left) || 0) + next_icon.x_vector);
                            next_icon.style.left = left + 'px';
                            var top = ((parseInt(next_icon.style.top) || 0) + next_icon.y_vector);
                            next_icon.style.top = top + 'px';
                            clear_transition_and_set_opacity(next_icon, next_icon.opacity);
                            next_icon.opacity *= 0.98;
                            next_icon.y_vector += 0.2;
                            if ((top > max_height) || (next_icon.opacity < 0.05) || (left + 50 > window_width) || (left < 0)) {
                                window.clearInterval(next_icon.animation_timer);
                                next_icon.animation_timer = null;
                                next_icon.parentNode.removeChild(next_icon);
                            }
                        }, 50);
                    }, 7000 + 500 * x);
                }
            }, 100);

            // Set up animation timer
            cloned_message.timer = window.setInterval(function () {
                animate_down(cloned_message);
            }, frame_delay);
        }, 0);
    });
}

function animate_down(el, avoid_remove) {
    if (window.paused) {
        return;
    }

    avoid_remove = !!avoid_remove;

    var bubbles = document.getElementById('bubbles_go_here');
    var max_height = bubbles.parentNode.offsetHeight;
    var jump_speed = 1;
    var new_pos = (parseInt(el.style.top) || 0) + jump_speed;
    el.style.top = new_pos + 'px';

    if ((new_pos > max_height) || (!el.parentNode)) {
        if (!avoid_remove) {
            if (el.parentNode) {
                window.total_lines -= el.querySelectorAll('.line').length;
                el.parentNode.removeChild(el);
            }
            window.clearInterval(el.timer);
            el.timer = null;
        }
    }
}

function time_now() {
    return Math.round(Date.now() / 1000);
}

function timeline_click(prospective) {
    prospective = !!prospective;

    var pos = window.mouse_x - find_pos_x(document.getElementById('time_line_image'), true);
    var timeline_length = 808;
    var min_time = window.min_time;
    var max_time = time_now();
    var time = min_time + pos * (max_time - min_time) / timeline_length;
    if (!prospective) {
        window.current_time = time;
        bubbles_tidy_up();
        $cms.dom.html(document.getElementById('real_time_date'), '{!SET;^}');
        $cms.dom.html(document.getElementById('real_time_time'), '');
        document.getElementById('loading_icon').style.display = 'block';
    } else {
        set_time_line_position(time);
    }
}

function bubbles_tidy_up() {
    var bubbles_go_here = document.getElementById('bubbles_go_here');
    if (!bubbles_go_here) return;
    var bubbles = document.getElementById('real_time_surround').parentNode.querySelectorAll('.bubble_wrap');
    for (var i = 0; i < bubbles.length; i++) {
        if (bubbles[i].timer) {
            window.clearInterval(bubbles[i].timer);
            bubbles[i].timer = null;
        }
    }
    $cms.dom.html(bubbles_go_here, '');
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

function set_time_line_position(time) {
    time = Math.round(time);

    var marker = document.getElementById('real_time_indicator');
    var timeline_length = 808;
    var min_time = window.min_time;
    var max_time = time_now();
    var timeline_range = max_time - min_time;
    var timeline_offset_time = time - min_time;
    var timeline_offset_position = timeline_offset_time * timeline_length / timeline_range;
    marker.style.marginLeft = (50 + timeline_offset_position) + 'px';

    var date_object = new Date();
    date_object.setTime(time * 1000);
    var realtimedate = document.getElementById('real_time_date');
    var realtimetime = document.getElementById('real_time_time');
    if (!realtimedate) return;
    $cms.dom.html(realtimedate, date_object.getFullYear() + '/' + ('' + date_object.getMonth()) + '/' + ('' + date_object.getDate()));
    $cms.dom.html(realtimetime, ('' + date_object.getHours()) + ':' + ('' + date_object.getMinutes()) + ':' + ('' + date_object.getSeconds()));
}

function draw_line(group_id, bubble_id) {
    if (window.bubble_groups[group_id] === undefined) {
        window.bubble_groups[group_id] = [];
    } else {
        if (window.bubble_groups[group_id].indexOf(bubble_id) != -1) {
            return;
        }
        if (window.total_lines > 20) { // Performance
            return;
        }

        var others = window.bubble_groups[group_id];
        var el = document.getElementById(bubble_id + '_main'), el2;
        if (!el) return;
        if (!el.parentNode) return;
        var width = el.offsetWidth;
        var height = el.offsetHeight;
        var line;
        var x = find_pos_x(el, true);
        var y = find_pos_y(el, true);
        for (var i = 0; i < others.length; i++) {
            el2 = document.getElementById(others[i] + '_main');
            if ((el2) && (el2.parentNode)) {
                line = create_line(width / 2, height / 2, find_pos_x(el2, true) + width / 2 - x, find_pos_y(el2, true) + height / 2 - y, 88);
                el.appendChild(line);
                window.total_lines++;
            }
        }
    }

    window.bubble_groups[group_id].push(bubble_id);
}

// Based on http://www.gapjumper.com/research/lines.html
function create_line(x1, y1, x2, y2, margin) {
    if (x2 < x1) {
        var temp = x1;
        x1 = x2;
        x2 = temp;
        temp = y1;
        y1 = y2;
        y2 = temp;
    }
    var length = Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
    if (length - margin * 2 < 0) return;
    var line = document.createElement('div');
    line.className = 'line';
    line.style.position = 'absolute';
    line.style.zIndex = 20;
    line.style.width = (length - margin * 2) + 'px';
    line.style.marginLeft = margin + 'px';
    line.style.marginRight = margin + 'px';
    line.style.height = '1px';

    var angle = ((x2 - x1) == 0) ? 1.57 : Math.atan((y2 - y1) / (x2 - x1));
    line.style.top = Math.round(y1 + 0.5 * length * Math.sin(angle)) + 'px';
    line.style.left = Math.round(x1 - 0.5 * length * (1 - Math.cos(angle))) + 'px';
    if (!line.style.left) line.style.left = 0;
    line.style.transform = line.style.WebkitTransform = 'rotate(' + angle + 'rad)';

    return line;
}

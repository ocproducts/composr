"use strict";

function decToHex(number) {
    var hexbase = '0123456789ABCDEF';
    return hexbase.charAt((number >> 4) & 0xf) + hexbase.charAt(number & 0xf);
}

function hexToDec(number) {
    return parseInt(number, 16);
}

function processWave(e) {
    if (!e) {
        return;
    }

    var pos = window[e.id][0];
    var max_color = window[e.id][1];
    var min_color = window[e.id][2];
    var text_nodes = window[e.id][4];

    if (text_nodes.length === 0)  { // Setup
        var text_nodes_temp = findTextNodes(e);

        // Now split up the nodes so each is actually wrapped by a span
        for (var i = 0; i < text_nodes_temp.length; i++) {
            var parent = text_nodes_temp[i].parentNode;
            parent.removeChild(text_nodes_temp[i]);

            var text = text_nodes_temp[i].data;
            for (var j = 0; j < text.length; j++) {
                var span = document.createElement('span');
                var te = document.createTextNode(text.substr(j, 1));
                span.appendChild(te);
                text_nodes.push(span);
                parent.appendChild(span);
            }
        }

        window[e.id][4] = text_nodes;
    }

    var range = text_nodes.length;

    // Apply colour wave
    for (var i = 0; i < text_nodes.length; i++) {
        var dist_leftwards = i - pos;
        if (dist_leftwards < 0) dist_leftwards = i + range - pos;
        var dist_rightwards = pos - i;
        if (dist_rightwards < 0) dist_rightwards = pos + range - i;

        var diff = (dist_leftwards < dist_rightwards) ? dist_leftwards : dist_rightwards;
        var fraction = diff / (range / 2);
        text_nodes[i].style.color = '#' + colorInterpolation(max_color, min_color, fraction);
    }

    // Cycle around
    window[e.id][0]++;
    if (window[e.id][0] > text_nodes.length) {
        window[e.id][0] = 0;
    }

    function colorInterpolation(max_color, min_color, fraction) {
        var min_color_r = hexToDec(min_color.substr(0, 2));
        var min_color_g = hexToDec(min_color.substr(2, 2));
        var min_color_b = hexToDec(min_color.substr(4, 2));
        var max_color_r = hexToDec(max_color.substr(0, 2));
        var max_color_g = hexToDec(max_color.substr(2, 2));
        var max_color_b = hexToDec(max_color.substr(4, 2));

        var color_r = min_color_r + fraction * (max_color_r - min_color_r);
        var color_g = min_color_g + fraction * (max_color_g - min_color_g);
        var color_b = min_color_b + fraction * (max_color_b - min_color_b);

        return decToHex(window.parseInt(color_r)) + decToHex(window.parseInt(color_g)) + decToHex(window.parseInt(color_b));
    }

    function findTextNodes(e) {
        var found = [];
        for (var i = 0; i < e.childNodes.length; i++) {
            if (e.childNodes[i].nodeName === '#text') {
                found.push(e.childNodes[i]);
            }
            if (e.childNodes[i] !== undefined) {
                var found2 = findTextNodes(e.childNodes[i]);
                for (var i2 = 0; i2 < found2.length; i2++) {
                    found.push(found2[i2]);
                }
            }
        }
        return found;
    }
}

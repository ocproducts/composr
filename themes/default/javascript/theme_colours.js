"use strict";

// ==============
// COLOUR CHOOSER
// ==============


window.names_to_numbers || (window.names_to_numbers = {});
window.last_cc || (window.last_cc = {});
window.last_cc_i || (window.last_cc_i = {});

function decToHex(number) {
    var hexbase = '0123456789ABCDEF';
    return hexbase.charAt((number >> 4) & 0xf) + hexbase.charAt(number & 0xf);
}

function hexToDec(number) {
    return parseInt(number, 16);
}

function makeColourChooser(name, color, context, tabindex, label, className) {
    label || (label = '&lt;color-' + name + '&gt;');

    if (className === undefined) {
        className = '';
    } else {
        className = 'class="' + className + '" ';
    }

    window.names_to_numbers[name] = window.names_to_numbers.length;
    window.names_to_numbers.length++;

    var p = document.getElementById('colours_go_here_' + name);
    if (!p) {
        p = document.getElementById('colours_go_here');
    }

    if ((color != '') && (color.substr(0, 1) != '#') && (color.substr(0, 3) != 'rgb')) {
        if (color.match(/[A-Fa-f\d]\{6\}/)) {
            color = '#' + color;
        } else {
            color = '#000000';
        }
    }

    var _color = (color == '' || color == '#') ? '#000000' : ('#' + color.substr(1));

    var t = '';
    t = t + '<div class="css_colour_chooser">';
    t = t + '	<div class="css_colour_chooser_name">';
    t = t + '		<label class="field_name" for="' + name + '"> ' + label + '</label><br />';
    t = t + '<input ' + className + 'alt="{!COLOUR;^}" type="color" value="' + _color + '" size="7" id="' + name + '" name="' + name + '" size="6" class="js-change-update-chooser" />';
    t = t + '	</div>';
    t = t + '	<div class="css_colour_chooser_fixed">';
    t = t + '	<div class="css_colour_chooser_from" style="background-color: ' + ((color == '') ? '#000' : color) + '" id="cc_source_' + name + '">';
    t = t + "		{!themes:FROM_COLOUR^#}";
    t = t + '	</div>';
    t = t + '	<div class="css_colour_chooser_to" style="background-color: ' + ((color == '') ? '#000' : color) + '" id="cc_target_' + name + '">';
    t = t + "		{!themes:TO_COLOUR^#}";
    t = t + '	</div>';
    t = t + '	<div class="css_colour_chooser_colour">';
    t = t + '		<div id="cc_0_' + name + '"></div>';
    t = t + '		<div id="cc_1_' + name + '"></div>';
    t = t + '		<div id="cc_2_' + name + '"></div>';
    t = t + '	</div>';
    t = t + '	</div>';
    t = t + '</div>';

    if (context != '') {
        t = t + '<div class="css_colour_chooser_context">' + context + '</div>';
    }

    if (p.id === 'colours_go_here') {
        $cms.dom.append(p, t);
    } else {
        $cms.dom.html(p, t);
    }

    $cms.dom.on(p, 'change', '.js-change-update-chooser', function (e, target) {
        updateChooser(target.id);
    });

    /*
     Uncomment if you want to force spectrum widget even when there is native browser input support
     $("#"+name).spectrum({
     color: color
     });
     */
}

function doColorChooser() {
    var elements = document.getElementsByTagName('div');
    var ce, a = 0, myElements = [];
    for (ce = 0; ce < elements.length; ce++) {
        if (elements[ce].id.substring(0, 10) == 'cc_target_') {
            myElements[a] = elements[ce];
            a++;
        }
    }
    for (ce = 0; ce < a; ce++) {
        doColorChooserElement(myElements[ce]);
    }


    function doColorChooserElement(element) {
        var id = element.id.substring(10),
            source = document.getElementById('cc_source_' + id),
            bgColor = source.style.backgroundColor;

        if ((bgColor.substr(0, 1) !== '#') && (bgColor.substr(0, 3) != 'rgb')) {
            bgColor = '#000000';
        }
        if (bgColor.substr(0, 1) === '#') {
            bgColor = 'rgb(' + hexToDec(bgColor.substr(1, 2)) + ',' + hexToDec(bgColor.substr(3, 2)) + ',' + hexToDec(bgColor.substr(5, 2)) + ')';
        }

        var sRgb = bgColor.replace(new RegExp('(r|g|b|(\\()|(\\))|(\\s))*', 'gi'), '');
        var rgb = sRgb.split(',');

        rgb[0] = Math.round(rgb[0] / 4) * 4;
        rgb[1] = Math.round(rgb[1] / 4) * 4;
        rgb[2] = Math.round(rgb[2] / 4) * 4;

        if (rgb[0] >= 256) {
            rgb[0] = 252;
        }
        if (rgb[1] >= 256) {
            rgb[1] = 252;
        }
        if (rgb[2] >= 256) {
            rgb[2] = 252;
        }

        element.style.color = 'rgb(' + (255 - rgb[0]) + ',' + (255 - rgb[1]) + ',' + (255 - rgb[2]) + ')';
        source.style.color = element.style.color;

        var c = [];
        c[0] = document.getElementById('cc_0_' + id);
        c[1] = document.getElementById('cc_1_' + id);
        c[2] = document.getElementById('cc_2_' + id);

        var d, i, _rgb = [], bg, innert, tid, selected, style;
        for (d = 0; d <= 2; d++) {
            window.last_cc_i[d + window.names_to_numbers[id] * 3] = 0;
            innert = '';

            for (i = 0; i < 256; i += 4) {
                selected = (i == rgb[d]);
                if (!selected) {
                    _rgb[0] = 0;
                    _rgb[1] = 0;
                    _rgb[2] = 0;
                    _rgb[d] = i;
                } else {
                    _rgb[0] = 255;
                    _rgb[1] = 255;
                    _rgb[2] = 255;
                    window.last_cc_i[d + window.names_to_numbers[id] * 3] = i;
                }
                bg = 'rgb(' + _rgb[0] + ',' + _rgb[1] + ',' + _rgb[2] + ')';
                tid = 'cc_col_' + d + '_' + i + '#' + id;

                style = ((i == rgb[d]) ? '' : 'cursor: pointer; ') + 'background-color: ' + bg + ';';
                if (selected) {
                    style += 'outline: 3px solid gray; position: relative;';
                }
                innert = innert + '<div class="css_colour_strip js-click-do-color-change" style="' + style + '" id="' + tid + '"></div>';
            }
            $cms.dom.html(c[d], innert);
            $cms.dom.on(c[d].querySelector('.js-click-do-color-change'), 'click', function (e) {
                doColorChange(e);
            });
        }
    }
}

function doColorChange(e) {
    // Find our colour element we clicked on
    var targ;
    if (e.target !== undefined) {
        targ = e.target;
    }

    // Find the colour chooser's ID of this element
    var _id = targ.id.substring(targ.id.lastIndexOf('#') + 1);

    var finality = document.getElementById(_id);
    if (finality.disabled) return;

    // Get the ID of the element we clicked (format: cc_col_<0-2>_<0-255>#<chooser-id>)
    var id = targ.id;

    var b = id.substr(0, id.length - _id.length).lastIndexOf('_');

    var d = parseInt(id.substring(7, b), 10); // Get the colour row (0-2)
    var i = parseInt(id.substring(b + 1, id.lastIndexOf('#')), 10); // Get the colour (0-255)

    var rgb = [];
    rgb[0] = 0;
    rgb[1] = 0;
    rgb[2] = 0;
    rgb[d] = window.last_cc_i[d + window.names_to_numbers[_id] * 3];
    var tempLastCc = document.getElementById('cc_col_' + d + '_' + rgb[d] + '#' + _id);
    if (tempLastCc !== targ) {
        tempLastCc.style.backgroundColor = '#' + decToHex(rgb[0]) + decToHex(rgb[1]) + decToHex(rgb[2]);
        tempLastCc.style.cursor = 'pointer';
        tempLastCc.style.outline = 'none';
        tempLastCc.style.position = 'static';
        window.last_cc_i[d + window.names_to_numbers[_id] * 3] = i;

        // Show a white line over the colour we clicked
        targ.style.backgroundColor = '#FFFFFF';
        targ.style.cursor = '';
        targ.style.outline = '3px solid gray';
        targ.style.position = 'relative';

        var element = document.getElementById('cc_target_' + _id);
        var bgColor = element.style.backgroundColor;
        if (bgColor.substr(0, 1) === '#') bgColor = 'rgb(' + hexToDec(bgColor.substr(1, 2)) + ',' + hexToDec(bgColor.substr(3, 2)) + ',' + hexToDec(bgColor.substr(5, 2)) + ')';

        var sRgb = bgColor.replace(new RegExp('(r|g|b|(\\()|(\\))|(\\s))*', 'gi'), '');
        var _rgb = sRgb.split(',');
        _rgb[d] = i;
        element.style.backgroundColor = '#' + decToHex(_rgb[0]) + decToHex(_rgb[1]) + decToHex(_rgb[2]);
        element.style.color = '#' + decToHex(255 - _rgb[0]) + decToHex(255 - _rgb[1]) + decToHex(255 - _rgb[2]);

        finality.value = '#' + decToHex(_rgb[0]) + decToHex(_rgb[1]) + decToHex(_rgb[2]);
    }
}

function updateChooser(chooser) {
    var ob = document.getElementById(chooser);
    if (ob.disabled) {
        return false;
    }

    return updateChoose(chooser, 0, ob.value.substr(1, 2))
        && updateChoose(chooser, 1, ob.value.substr(3, 2))
        && updateChoose(chooser, 2, ob.value.substr(5, 2));

    function updateChoose(id, d, i) {
        i = hexToDec(i);
        i = i - i % 4;

        var tid = 'cc_col_' + d + '_' + i + '#' + id;
        var targ = document.getElementById(tid);
        if (!targ) return false;
        var rgb = [];
        rgb[0] = 0;
        rgb[1] = 0;
        rgb[2] = 0;
        rgb[d] = window.last_cc_i[d + window.names_to_numbers[id] * 3];
        var tempLastCc = document.getElementById('cc_col_' + d + '_' + rgb[d] + '#' + id);
        tempLastCc.style.backgroundColor = '#' + decToHex(rgb[0]) + decToHex(rgb[1]) + decToHex(rgb[2]); // Reset old
        tempLastCc.style.outline = 'none';
        tempLastCc.style.position = 'static';
        window.last_cc_i[d + window.names_to_numbers[id] * 3] = i;

        var element = document.getElementById('cc_target_' + id);
        var bgColor = element.style.backgroundColor;
        if (bgColor.substr(0, 1) == '#') bgColor = 'rgb(' + hexToDec(bgColor.substr(1, 2)) + ',' + hexToDec(bgColor.substr(3, 2)) + ',' + hexToDec(bgColor.substr(5, 2)) + ')';
        var sRgb = bgColor.replace(new RegExp('(r|g|b|(\\()|(\\))|(\\s))*', 'gi'), '');
        rgb = sRgb.split(',');
        rgb[d] = i;
        element.style.backgroundColor = '#' + decToHex(rgb[0]) + decToHex(rgb[1]) + decToHex(rgb[2]);
        element.style.color = '#' + decToHex(255 - rgb[0]) + decToHex(255 - rgb[1]) + decToHex(255 - rgb[2]);

        targ.style.backgroundColor = '#FFFFFF';
        targ.style.outline = '3px solid gray';
        targ.style.position = 'relative';

        return true;
    }
}



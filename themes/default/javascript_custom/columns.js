/*{$,parser hint: .innerHTML okay}*/

// Based on http://welcome.totheinter.net/columnizer-jquery-plugin/
//  But with fixes and better flexibility, and pure CSS-based activation

$dom.load.then(function () {
    jQuery('.column-wrapper').columnize({columns: 3});
    jQuery('.column-wrapper-2').columnize({columns: 2});
});

// version 1.5.0
// http://welcome.totheinter.net/columnizer-jquery-plugin/
// created by: Adam Wulf @adamwulf, adam.wulf@gmail.com

(function ($) {

    $.fn.columnize = function (options) {

        var $inBox = options.target ? jQuery(options.target) : jQuery(this);

        var defaults = {
            // optional # of columns instead of width
            columns: false,
            // true to build columns once regardless of window resize
            // false to rebuild when content box changes bounds
            buildOnce: false,
            // an object with options if the text should overflow
            // it's container if it can't fit within a specified height
            overflow: false,
            // this function is called after content is columnized
            doneFunc: function () {
            },
            // if the content should be columnized into a
            // container node other than it's own node
            target: false,
            // re-columnizing when images reload might make things
            // run slow. so flip this to true if it's causing delays
            ignoreImageLoading: true,
            // should columns float left or right
            columnFloat: "left",
            // ensure the last column is never the tallest column
            lastNeverTallest: false,
            // (int) the minimum number of characters to jump when splitting
            // text nodes. smaller numbers will result in higher accuracy
            // column widths, but will take slightly longer
            accuracy: false,
            // if we need a 'force-break' class set
            explicitBreaks: $inBox.find('.force-break').length != 0
        };
        var options = $.extend(defaults, options);

        if (!options.explicitBreaks) {
            $inBox.find('h1, h2, h3, h4, h5, h6').addClass('dontend');
        }
        $inBox.find('table, thead, tbody, tfoot, colgroup, caption, label, legend, script, style, textarea, button, object, embed, tr, th, td, li, h1, h2, h3, h4, h5, h6, form').addClass('dontsplit');
        $inBox.find('br').addClass('removeiflast').addClass('removeiffirst');

        // Take out DOM nodes that can't be copied/medled-with. We'll put them back at the end of the process.
        var protectMe = [];
        $inBox.find(".protectme").each(function (index, node) {
            protectMe.push(node);
            var temp = document.createElement('div');
            temp.className = 'protectme protectMe_' + (protectMe.length - 1);
            node.parentNode.replaceChild(temp, node);
        });

        return this.each(function () {
            var maxHeight = $inBox.height();
            var $cache = jQuery('<div></div>'); // this is where we'll put the real content
            var lastWidth = 0;
            var columnizing = false;

            var adjustment = 0;

            $cache.append($inBox.contents().clone(true));

            // images loading after dom load
            // can screw up the column heights,
            // so recolumnize after images load
            if (!options.ignoreImageLoading && !options.target) {
                if (!$inBox.data("imageLoaded")) {
                    $inBox.data("imageLoaded", true);
                    if ($inBox.find("img").length > 0) {
                        // only bother if there are
                        // actually images...
                        var func = (function ($inBox, $cache) {
                            return function () {
                                if (!$inBox.data("firstImageLoaded")) {
                                    $inBox.data("firstImageLoaded", "true");
                                    $inBox.empty().append($cache.children().clone(true));
                                    $inBox.columnize(options);
                                }
                            }
                        }($inBox, $cache));
                        $inBox.find("img").one("load", func);
                        $inBox.find("img").one("abort", func);
                        return;
                    }
                }
            }

            $inBox.empty();

            columnizeIt();

            if (!options.buildOnce) {
                jQuery(window).resize(function () {
                    if (!options.buildOnce && $.browser.msie) {
                        if ($inBox.data("timeout")) {
                            clearTimeout($inBox.data("timeout"));
                        }
                        $inBox.data("timeout", setTimeout(columnizeIt, 200));
                    } else if (!options.buildOnce) {
                        columnizeIt();
                    } else {
                        // don't rebuild
                    }
                });
            }

            /**
             * Create a node that has a height
             * less than or equal to height.
             * Returns a boolean on whether we did some splitting successfully at an optimal point (so we know we don't need to continue to split elements recursively).
             *
             * @param putInHere, a jQuery element
             * @$pullOutHere, a dom element
             */
            function columnize($putInHere, $pullOutHere, $parentColumn, height) {
                if (options.explicitBreaks) { // We're doing explicit breaks, meaning we only ever break on a force-break node
                    var splitHere = false;
                    var splitUnder = false;
                    while ($pullOutHere[0].childNodes.length != 0) {
                        var next = jQuery($pullOutHere[0].childNodes[0]);
                        splitHere = next.hasClass('force-break');
                        if (splitHere) break;
                        splitUnder = next.find('.force-break').length != 0;
                        if (splitUnder) break;
                        $putInHere.append(next); // Because we're not cloning, jquery will actually move the element
                    }
                    if (splitHere) {
                        jQuery($pullOutHere[0].childNodes[0]).remove();
                        return true; // No further splits needs
                    }
                    return false; // Will need to go down to split recursively
                } else {
                    while ($parentColumn.height() < height && $pullOutHere[0].childNodes.length != 0) {
                        var next = $pullOutHere[0].childNodes[0];
                        $putInHere.append(next); // Because we're not cloning, jquery will actually move the element
                    }
                }
                if ($putInHere[0].childNodes.length == 0) return false;

                // now we're too tall, undo the last one
                var kids = $putInHere[0].childNodes;
                var lastKid = kids[kids.length - 1];
                $putInHere[0].removeChild(lastKid);
                var $item = jQuery(lastKid);

                // and now try and put a split version of it
                if ($item[0].nodeType == 3) {
                    // it's a text node, split it up
                    var oText = $item[0].nodeValue;

                    var counter2 = $putInHere.width() / 18;
                    if (options.accuracy)
                        counter2 = options.accuracy;
                    var columnText;
                    var latestTextNode = null;
                    var partsUsed = 0;
                    while ($parentColumn.height() < height && oText.length != 0) {
                        var pos = oText.indexOf(' '/*, counter2*/);
                        if (pos == 0) {
                            pos = oText.substring(1).indexOf(' '/*, counter2*/);
                            if (pos != -1) pos++;
                        }
                        if (pos != -1) {
                            columnText = oText.substring(0, pos);
                        } else {
                            columnText = oText;
                        }
                        latestTextNode = document.createTextNode(columnText);
                        $putInHere.append(latestTextNode);
                        partsUsed++;

                        if ((oText.length > counter2) && (pos != -1)) {
                            oText = oText.substring(pos);
                        } else {
                            oText = "";
                        }
                    }

                    if ($parentColumn.height() >= height && latestTextNode != null) {
                        // too tall - step back :(
                        $putInHere[0].removeChild(latestTextNode);
                        oText = latestTextNode.nodeValue + oText;
                        partsUsed--;
                    }
                    if (oText.length != 0) {
                        if (partsUsed != 0) {
                            if (latestTextNode != null) {
                                // Step back a bit further, to make a very small bit of space
                                latestTextNode = $putInHere[0].lastChild;
                                $putInHere[0].removeChild(latestTextNode);
                                oText = latestTextNode.nodeValue + oText;
                            }

                            // Add a dash
                            latestTextNode = document.createTextNode(' \u2014');
                            $putInHere.append(latestTextNode);
                        }
                        $item[0].nodeValue = oText;
                    } else {
                        return false; // we ate the whole text node, move on to the next node
                    }
                }

                // Put what is left back
                if ($pullOutHere.contents().length != 0) {
                    $pullOutHere.prepend($item);
                } else {
                    $pullOutHere.append($item);
                }

                return $item[0].nodeType == 3;
            }

            // Split up an element, which is more complex than splitting text. We need to create two copies of the element with it's contents divided between each
            function split($putInHere, $pullOutHere, $parentColumn, height) {
                if ($pullOutHere.children().length != 0) {
                    var $cloneMe = $pullOutHere.children(":first"); // From
                    var $clone = $cloneMe.clone(true); // To
                    if ($clone.prop("nodeType") == 1 && (options.explicitBreaks || !$clone.hasClass("dontend"))) {
                        $putInHere.append($clone);
                        var dontsplit = $cloneMe.hasClass("dontsplit");
                        if ((options.explicitBreaks) && ($clone.hasClass('force-break'))) { // Explicit break
                            $cloneMe.remove();
                            $clone.remove();
                        } else if ((!options.explicitBreaks) && ($clone.is("img") && $parentColumn.height() < height + 20)) { // Images are easy to handle, just shift them
                            $cloneMe.remove();
                        } else if ((!options.explicitBreaks) && (!dontsplit && $parentColumn.height() < height + 20)) { // If this is a viable split point, do it
                            $cloneMe.remove(); // Remove from from
                        } else if ((!options.explicitBreaks) && ($clone.is("img") || dontsplit)) { // Can't split, we'll just have to let it all stay where it is
                            $clone.remove(); // Remove from to (i.e. undo copy). Stays at from.
                        } else { // Look deeper for split point
                            $clone.empty();
                            if (!columnize($clone, $cloneMe, $parentColumn, height)) {
                                if ($cloneMe.children().length != 0) {
                                    split($clone, $cloneMe, $parentColumn, height);
                                }
                            } else {
                                // Case where explicit break might be at end of list item, we need to not copy over shell of this list item
                                if ((options.explicitBreaks) && ($cloneMe[0].localName === 'li') && ($cloneMe[0].childNodes.length == 1) && ($cloneMe[0].childNodes[0].nodeType == 3) && ($cloneMe[0].childNodes[0].nodeValue.replace(/\s*/g, '') == ''))
                                    $cloneMe.first().remove();
                            }
                            if ($clone.get(0).childNodes.length == 0) {
                                // it was split, but nothing is in it :(. No deeper to go.
                                $clone.remove();
                            }
                        }
                    }
                }
            }

            function cantEndOn(dom, lookingDeep) {
                if (!lookingDeep) {
                    if (dom.nodeType !== 1) {
                        var isBlankTextNode = (dom.nodeType === 3) && (dom.nodeValue.replace(/\s/g, '') === '');
                        return isBlankTextNode;
                    }
                }

                if (jQuery(dom).hasClass("dontend")) {
                    return true;
                }

                // Need to look deeper?
                if (dom.childNodes.length === 0) {
                    return false;
                }
                return cantEndOn(dom.childNodes[dom.childNodes.length - 1], true);
            }

            function columnizeIt() {
                if (lastWidth == $inBox.width()) {
                    return;
                }
                lastWidth = $inBox.width();

                var numCols = options.columns;

                if ($inBox.data("columnizing")) {
                    return;
                }
                $inBox.data("columnized", true);
                $inBox.data("columnizing", true);

                $inBox.empty();
                $inBox.append(jQuery("<div style='float: " + options.columnFloat + ";'></div>")); //"
                $col = $inBox.children(":last");
                $col.append($cache.clone());
                maxHeight = $col.height();
                $inBox.empty();

                var targetHeight = maxHeight / numCols;
                var firstTime = true;
                var maxLoops = 3;
                var scrollHorizontally = false;
                if (options.overflow) {
                    maxLoops = 1;
                    targetHeight = options.overflow.height;
                } else if (options.height) {
                    maxLoops = 1;
                    targetHeight = options.height;
                    scrollHorizontally = true;
                }

                for (var loopCount = 0; loopCount < maxLoops; loopCount++) {
                    if (typeof window.console !== 'undefined') console.log('STARTING COLUMNISATION ITERATION');

                    $inBox.empty();
                    var $destroyable; // This is where we'll pull all our data from, as we progressively fill our columns
                    try {
                        $destroyable = $cache.clone(true);
                    } catch (e) {
                        // jquery in ie6 can't clone with true
                        $destroyable = $cache.clone();
                    }
                    $destroyable.css("visibility", "hidden");
                    // create the columns
                    for (var i = 0; i < numCols; i++) {
                        /* create column */
                        var className = (i == 0) ? "first column" : "column";
                        var className = (i == numCols - 1) ? ("last " + className) : className;
                        $inBox.append(jQuery("<div class='" + className + "' style='float: " + options.columnFloat + ";'></div>")); //"
                    }

                    // fill all but the last column (unless overflowing)
                    var i = 0;
                    while (i < numCols - (options.overflow ? 0 : 1) || scrollHorizontally && $destroyable.contents().length != 0) {
                        if ($inBox.children().length <= i) {
                            // we ran out of columns, make another
                            $inBox.append(jQuery("<div class='" + className + "' style='float: " + options.columnFloat + ";'></div>")); //"
                        }
                        var $col = $inBox.children().eq(i);
                        var needsDeepSplit = !columnize($col, $destroyable, $col, targetHeight);
                        if (needsDeepSplit) {
                            // do a split, but only if the last item in the column isn't a "dontend"
                            if (options.explicitBreaks || !$destroyable.contents().find(":first-child").hasClass("dontend")) {
                                split($col/*put in here*/, $destroyable/*pull out here*/, $col, targetHeight);
                            } else {
                                //						alert("not splitting a dontend");
                            }
                        }

                        if (!options.explicitBreaks) {
                            // Any "dontend" stuff needs to be yonked off our current column and put back onto the start of $destroyable. Loop whilst we need to keep doing this.
                            while ($col.contents(":last").length != 0 && cantEndOn($col.contents(":last").get(0))) {
                                var $lastKid = $col.contents(":last");
                                $lastKid.remove();
                                $destroyable.prepend($lastKid);
                            }
                        }
                        i++;
                    }

                    if (options.overflow && !scrollHorizontally) {
                        var IE6 = false /*@cc_on || @_jscript_version < 5.7 @*/;
                        var IE7 = (document.all) && (navigator.appVersion.indexOf("MSIE 7.") != -1);
                        if (IE6 || IE7) {
                            var html = "";
                            var div = document.createElement('DIV');
                            while ($destroyable[0].childNodes.length > 0) {
                                var kid = $destroyable[0].childNodes[0];
                                for (var i = 0; i < kid.attributes.length; i++) {
                                    if (kid.attributes[i].nodeName.indexOf("jQuery") == 0) {
                                        kid.removeAttribute(kid.attributes[i].nodeName);
                                    }
                                }
                                div.innerHTML = "";
                                div.appendChild($destroyable[0].childNodes[0]);
                                html += div.innerHTML;
                            }
                            var overflow = jQuery(options.overflow.id)[0];
                            overflow.innerHTML = html;
                        } else {
                            jQuery(options.overflow.id).empty().append($destroyable.contents().clone(true));
                        }
                    } else if (!scrollHorizontally) {
                        // it's scrolling horizontally, try and workout our average height. We know it initially but if the last column is too high we need to raise 'adjustment'. We try this over a few iterations until we're 'solid'.

                        // the last column in the series
                        $col = $inBox.children().eq($inBox.children().length - 1);
                        while ($destroyable.contents().length != 0) $col.append($destroyable.contents(":first"));
                        var afterH = $col.height();
                        var diff = afterH - targetHeight;
                        var totalH = 0;
                        var min = 10000000;
                        var max = 0;
                        var lastIsMax = false;
                        $inBox.children().each((function ($inBox) {
                            return function ($item) {
                                var h = $inBox.children().eq($item).height();
                                lastIsMax = false;
                                totalH += h;
                                if (h > max) {
                                    max = h;
                                    lastIsMax = true;
                                }
                                if (h < min) {
                                    min = h;
                                }
                            };
                        }($inBox)));

                        var avgH = totalH / numCols;
                        if (options.lastNeverTallest && lastIsMax) {
                            // the last column is the tallest
                            // so allow columns to be taller
                            // and retry
                            adjustment += 30;
                            if (adjustment < 100) {
                                targetHeight = targetHeight + 30;
                                if (loopCount == maxLoops - 1) {
                                    maxLoops++;
                                }
                            } else {
                                loopCount = maxLoops;
                            }
                        } else if (max - min > 30) {
                            // too much variation, try again
                            targetHeight = avgH + 30;
                        } else if (Math.abs(avgH - targetHeight) > 20) {
                            // too much variation, try again
                            targetHeight = avgH;
                        } else {
                            // solid, we're done
                            loopCount = maxLoops;
                        }
                    } else {
                        // it's scrolling horizontally, fix the classes of the columns
                        $inBox.children().each(function (i) {
                            $col = $inBox.children().eq(i);
                            if (i == 0) {
                                $col.addClass("first");
                            } else if (i == $inBox.children().length - 1) {
                                $col.addClass("last");
                            } else {
                                $col.removeClass("first");
                                $col.removeClass("last");
                            }
                        });
                    }
                }
                for (var i = 0; i < numCols; i++) {
                    var $col = $inBox.children().eq(i);
                    var runOn;

                    do {
                        runOn = $col.children(":first-child.removeiffirst");
                        if (runOn.length !== 0) {
                            // Protect if a relevant text node preceding
                            if (runOn[0].previousSibling && runOn[0].previousSibling.nodeType === 3) {
                                if (runOn[0].previousSibling.nodeValue.replace(/\s/g, '') !== '') {
                                    break;
                                }
                            }
                            // Okay, strip then
                            jQuery(runOn[0]).remove();
                        }
                    } while (runOn.length !== 0);

                    do {
                        runOn = $col.children(":last-child.removeiflast");
                        if (runOn.length !== 0) {
                            // Protect if a relevant text node suceeding
                            if (runOn[0].nextSibling && runOn[0].nextSibling.nodeType == 3) {
                                if (runOn[0].nextSibling.nodeValue.replace(/\s/g, '') != '') {
                                    break;
                                }
                            }
                            // Okay, strip then
                            jQuery(runOn[0]).remove();
                        }
                    } while (runOn.length !== 0);
                }

                $inBox.find('.protectme').each(function (index, node) {
                    var reference = protectMe[node.className.substr(node.className.lastIndexOf('_') + 1)];
                    node.parentNode.replaceChild(reference, node);
                });

                $inBox.data("columnizing", false);

                if (options.overflow) {
                    options.overflow.doneFunc();
                }
                options.doneFunc();
            }
        });
    };
}(jQuery));

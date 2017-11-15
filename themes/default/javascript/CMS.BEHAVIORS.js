(function ($cms, $util, $dom) {
    'use strict';

    var IN_MINIKERNEL_VERSION = document.documentElement.classList.contains('in-minikernel-version');

    /**
     * Addons will add "behaviors" under this namespace
     * @namespace $cms.behaviors
     */
    $cms.behaviors = {};

    // Implementation for [data-require-javascript="[<scripts>...]"]
    //$cms.behaviors.initializeRequireJavascript = {
    //    priority: 10000,
    //    attach: function (context) {
    //        var promises = [];
    //
    //        $dom.$$$(context, '[data-require-javascript]').forEach(function (el) {
    //            var scripts = arrVal($dom.data(el, 'requireJavascript'));
    //
    //            if (scripts.length) {
    //                promises.push($cms.requireJavascript(scripts));
    //            }
    //        });
    //
    //        if (promises.length > 0) {
    //            return Promise.all(promises);
    //        }
    //    }
    //};
    // TODO: Is this dead code? Is data-require-javascript in use or should be stripped? What's the purpose verses Tempcode method?

    // Implementation for [data-view]
    $cms.behaviors.initializeViews = {
        attach: function (context) {
            $util.once($dom.$$$(context, '[data-view]'), 'behavior.initializeViews').forEach(function (el) {
                var params = objVal($dom.data(el, 'viewParams')),
                    viewName = el.dataset.view,
                    viewOptions = {el: el};

                if (typeof $cms.views[viewName] !== 'function') {
                    $util.fatal('$cms.behaviors.initializeViews.attach(): Missing view constructor "' + viewName + '" for', el);
                    return;
                }

                try {
                    $dom.data(el).viewObject = new $cms.views[viewName](params, viewOptions);
                    //$util.inform('$cms.behaviors.initializeViews.attach(): Initialized view "' + el.dataset.view + '" for', el, view);
                } catch (ex) {
                    $util.fatal('$cms.behaviors.initializeViews.attach(): Exception thrown while initializing view "' + el.dataset.view + '" for', el, ex);
                }
            });
        }
    };

    // Implementation for [data-tpl]
    $cms.behaviors.initializeTemplates = {
        attach: function (context) {
            $util.once($dom.$$$(context, '[data-tpl]'), 'behavior.initializeTemplates').forEach(function (el) {
                var template = el.dataset.tpl,
                    params = objVal($dom.data(el, 'tplParams'));

                if (typeof $cms.templates[template] !== 'function') {
                    $util.fatal('$cms.behaviors.initializeTemplates.attach(): Missing template function "' + template + '" for', el);
                    return;
                }

                try {
                    $cms.templates[template].call(el, params, el);
                    //$util.inform('$cms.behaviors.initializeTemplates.attach(): Initialized template "' + template + '" for', el);
                } catch (ex) {
                    $util.fatal('$cms.behaviors.initializeTemplates.attach(): Exception thrown while calling the template function "' + template + '" for', el, ex);
                }
            });
        }
    };

    $cms.behaviors.initializeAnchors = {
        attach: function (context) {
            var anchors = $util.once($dom.$$$(context, 'a'), 'behavior.initializeAnchors'),
                hasBaseEl = !!document.querySelector('base');

            anchors.forEach(function (anchor) {
                var href = strVal(anchor.getAttribute('href'));
                // So we can change base tag especially when on debug mode
                if (hasBaseEl && href.startsWith('#') && (href !== '#!')) {
                    anchor.setAttribute('href', window.location.href.replace(/#.*$/, '') + href);
                }

                if ($cms.configOption('js_overlays')) {
                    // Lightboxes
                    if (anchor.rel && anchor.rel.includes('lightbox')) {
                        anchor.title = anchor.title.replace('{!LINK_NEW_WINDOW;^}', '').trim();
                    }

                    // Convert <a> title attributes into composr tooltips
                    if (!anchor.classList.contains('no_tooltip')) {
                        convertTooltip(anchor);
                    }
                }

                if (boolVal('{$VALUE_OPTION;,js_keep_params}')) {
                    // Keep parameters need propagating
                    if (anchor.href && anchor.href.startsWith($cms.baseUrl() + '/')) {
                        anchor.href += $cms.addKeepStub(anchor.href);
                    }
                }
            });
        }
    };

    $cms.behaviors.initializeForms = {
        attach: function (context) {
            var forms = $util.once($dom.$$$(context, 'form'), 'behavior.initializeForms');

            forms.forEach(function (form) {
                // HTML editor
                if (window.loadHtmlEdit !== undefined) {
                    window.loadHtmlEdit(form);
                }

                // Remove tooltips from forms as they are for screen-reader accessibility only
                form.title = '';

                // Convert form element title attributes into composr tooltips
                if ($cms.configOption('js_overlays')) {
                    // Convert title attributes into composr tooltips
                    var elements = form.elements, j;

                    for (j = 0; j < elements.length; j++) {
                        if ((elements[j].title !== undefined) && (elements[j]['original-title'] === undefined/*check tipsy not used*/) && !elements[j].classList.contains('no_tooltip')) {
                            convertTooltip(elements[j]);
                        }
                    }

                    elements = form.querySelectorAll('input[type="image"][title]'); // JS DOM does not include input[type="image"] ones in form.elements
                    for (j = 0; j < elements.length; j++) {
                        if ((elements[j]['original-title'] === undefined/*check tipsy not used*/) && !elements[j].classList.contains('no_tooltip')) {
                            convertTooltip(elements[j]);
                        }
                    }
                }

                if (boolVal('{$VALUE_OPTION;,js_keep_params}')) {
                    /* Keep parameters need propagating */
                    if (form.action && form.action.startsWith($cms.baseUrl() + '/')) {
                        form.action = $cms.addKeepStub(form.action);
                    }
                }

                // This "proves" that JS is running, which is an anti-spam heuristic (bots rarely have working JS)
                if ((form.elements['csrf_token'] != null) && (form.elements['js_token'] == null)) {
                    var jsToken = document.createElement('input');
                    jsToken.type = 'hidden';
                    jsToken.name = 'js_token';
                    jsToken.value = form.elements['csrf_token'].value.split('').reverse().join(''); // Reverse the CSRF token for our JS token
                    form.appendChild(jsToken);
                }
            });
        }
    };

    $cms.behaviors.initializeInputs = {
        attach: function (context) {
            var inputs = $util.once($dom.$$$(context, 'input'), 'behavior.initializeInputs');

            inputs.forEach(function (input) {
                if (input.type === 'checkbox') {
                    // Implementatioin for input[data-cms-unchecked-is-indeterminate]
                    if (input.dataset.cmsUncheckedIsIndeterminate != null) {
                        input.indeterminate = !input.checked;
                    }
                }
            });
        }
    };

    $cms.behaviors.initializeTables = {
        attach: function attach(context) {
            var tables = $util.once($dom.$$$(context, 'table'), 'behavior.initializeTables');

            tables.forEach(function (table) {
                // Responsive table prep work
                if (table.classList.contains('responsive_table')) {
                    var trs = table.getElementsByTagName('tr'),
                        thsFirstRow = trs[0].cells,
                        i, tds, j, data;

                    for (i = 0; i < trs.length; i++) {
                        tds = trs[i].cells;
                        for (j = 0; j < tds.length; j++) {
                            if (!tds[j].classList.contains('responsive_table_no_prefix')) {
                                data = (thsFirstRow[j] === undefined) ? '' : thsFirstRow[j].textContent.replace(/^\s+/, '').replace(/\s+$/, '');
                                if (data !== '') {
                                    tds[j].setAttribute('data-th', data);
                                }
                            }
                        }
                    }
                }
            });
        }
    };

    // Implementation for [data-textarea-auto-height]
    $cms.behaviors.textareaAutoHeight = {
        attach: function attach(context) {
            if ($cms.isMobile()) {
                return;
            }

            var textareas = $dom.$$$(context, '[data-textarea-auto-height]');

            for (var i = 0; i < textareas.length; i++) {
                $cms.manageScrollHeight(textareas[i]);
            }
        }
    };

    $cms.behaviors.columnHeightBalancing = {
        attach: function attach(context) {
            var cols = $util.once($dom.$$$(context, '.col_balance_height'), 'behavior.columnHeightBalancing'),
                i, max, j, height;

            for (i = 0; i < cols.length; i++) {
                max = null;
                for (j = 0; j < cols.length; j++) {
                    if (cols[i].className === cols[j].className) {
                        height = cols[j].offsetHeight;
                        if ((max === null) || (height > max)) {
                            max = height;
                        }
                    }
                    cols[i].style.height = max + 'px';
                }
            }
        }
    };

    // Convert img title attributes into composr tooltips
    $cms.behaviors.imageTooltips = {
        attach: function (context) {
            if (!$cms.configOption('js_overlays')) {
                return;
            }

            $util.once($dom.$$$(context, 'img:not([data-cms-rich-tooltip])'), 'behavior.imageTooltips').forEach(function (img) {
                convertTooltip(img);
            });
        }
    };

    // Implementation for [data-remove-if-js-enabled]
    $cms.behaviors.removeIfJsEnabled = {
        attach: function (context) {
            var els = $dom.$$$(context, '[data-remove-if-js-enabled]');

            els.forEach(function (el) {
                $dom.remove(el);
            });
        }
    };

    // Implementation for [data-js-function-calls]
    $cms.behaviors.jsFunctionCalls = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-js-function-calls]'), 'behavior.jsFunctionCalls');

            els.forEach(function (el) {
                var jsFunctionCalls = $dom.data(el, 'jsFunctionCalls');

                if (typeof jsFunctionCalls === 'string') {
                    jsFunctionCalls = [jsFunctionCalls];
                }

                if (jsFunctionCalls != null) {
                    $cms.executeJsFunctionCalls(jsFunctionCalls);
                }
            });
        }
    };


    // Implementation for [data-cms-select2]
    $cms.behaviors.select2Plugin = {
        attach: function (context) {
            if (IN_MINIKERNEL_VERSION) {
                return;
            }

            $cms.requireJavascript(['jquery', 'select2']).then(function () {
                var els = $util.once($dom.$$$(context, '[data-cms-select2]'), 'behavior.select2Plugin');

                // Select2 plugin hook
                els.forEach(function (el) {
                    var options = objVal($dom.data(el, 'cmsSelect2'));
                    if (window.jQuery && window.jQuery.fn.select2) {
                        window.jQuery(el).select2(options);
                    }
                });
            });
        }
    };

    // Implementation for img[data-gd-text]
    $cms.behaviors.gdTextImages = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, 'img[data-gd-text]'), 'behavior.gdTextImages');

            els.forEach(function (img) {
                gdImageTransform(img);
            });

            function gdImageTransform(el) {
                /* GD text maybe can do with transforms */
                var span = document.createElement('span');
                if (typeof span.style.transform === 'string') {
                    el.style.display = 'none';
                    $dom.css(span, {
                        transform: 'rotate(90deg)',
                        transformOrigin: 'bottom left',
                        top: '-1em',
                        left: '0.5em',
                        position: 'relative',
                        display: 'inline-block',
                        whiteSpace: 'nowrap',
                        paddingRight: '0.5em'
                    });

                    el.parentNode.style.textAlign = 'left';
                    el.parentNode.style.width = '1em';
                    el.parentNode.style.overflow = 'hidden'; // LEGACY Needed due to https://bugzilla.mozilla.org/show_bug.cgi?id=456497
                    el.parentNode.style.verticalAlign = 'top';
                    span.textContent = el.alt;

                    el.parentNode.insertBefore(span, el);
                    var spanProxy = span.cloneNode(true); // So we can measure width even with hidden tabs
                    spanProxy.style.position = 'absolute';
                    spanProxy.style.visibility = 'hidden';
                    document.body.appendChild(spanProxy);

                    setTimeout(function () {
                        var width = spanProxy.offsetWidth + 15;
                        spanProxy.parentNode.removeChild(spanProxy);
                        if (el.parentNode.nodeName === 'TH' || el.parentNode.nodeName === 'TD') {
                            el.parentNode.style.height = width + 'px';
                        } else {
                            el.parentNode.style.minHeight = width + 'px';
                        }
                    }, 0);
                }
            }
        }
    };

    // Implementation for [data-toggleable-tray]
    $cms.behaviors.toggleableTray = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-toggleable-tray]'), 'behavior.toggleableTray');

            els.forEach(function (el) {
                var options = $dom.data(el, 'toggleableTray') || {};

                $dom.data(el).toggleableTrayObject = new $cms.views.ToggleableTray(options, {el: el});
            });
        }
    };

    function convertTooltip(el) {
        var title = el.title;

        if (!title || $cms.browserMatches('touch_enabled') || el.classList.contains('leave_native_tooltip')) {
            return;
        }

        // Remove old tooltip
        if ((el.localName === 'img') && !el.alt) {
            el.alt = el.title;
        }

        el.title = '';

        if (el.onmouseover || (el.firstElementChild && (el.firstElementChild.onmouseover || el.firstElementChild.title))) {
            // Only put on new tooltip if there's nothing with a tooltip inside the element
            return;
        }

        if (el.textContent) {
            var prefix = el.textContent + ': ';
            if (title.substr(0, prefix.length) === prefix) {
                title = title.substring(prefix.length, title.length);
            } else if (title === el.textContent) {
                return;
            }
        }

        // And now define nice listeners for it all...
        var global = $cms.getMainCmsWindow(true);

        el.cmsTooltipTitle = $cms.filter.html(title);

        $dom.on(el, 'mouseover.convertTooltip', function (event) {
            global.$cms.ui.activateTooltip(el, event, el.cmsTooltipTitle, 'auto', '', null, false, false, false, false, global);
        });

        $dom.on(el, 'mousemove.convertTooltip', function (event) {
            global.$cms.ui.repositionTooltip(el, event, false, false, null, false, global);
        });

        $dom.on(el, 'mouseout.convertTooltip', function () {
            global.$cms.ui.deactivateTooltip(el);
        });
    }

}(window.$cms, window.$util, window.$dom));
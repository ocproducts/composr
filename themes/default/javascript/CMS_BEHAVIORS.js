(function ($cms, $util, $dom) {
    'use strict';

    var IN_MINIKERNEL_VERSION = document.documentElement.classList.contains('in-minikernel-version');

    /**
     * Addons will add "behaviors" under this namespace
     * @namespace $cms.behaviors
     */
    $cms.behaviors = {};

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
                hasBaseEl = Boolean(document.querySelector('base'));

            anchors.forEach(function (anchor) {
                var href = strVal(anchor.href);
                // So we can change base tag especially when on debug mode
                if (hasBaseEl && href.startsWith('#') && (href !== '#!')) {
                    anchor.href = window.location.href.replace(/#.*$/, '') + href;
                }

                if ($cms.configOption('js_overlays')) {
                    // Lightboxes
                    if (anchor.rel && anchor.rel.includes('lightbox')) {
                        anchor.title = anchor.title.replace('{!LINK_NEW_WINDOW;^}', '').trim();
                    }

                    // Convert <a> title attributes into composr tooltips
                    if (!anchor.classList.contains('no-tooltip')) {
                        convertTooltip(anchor);
                    }
                }

                if (boolVal('{$VALUE_OPTION;,js_keep_params}')) {
                    // Keep parameters need propagating
                    if (anchor.href && anchor.href.startsWith($cms.getBaseUrl() + '/')) {
                        anchor.href = $cms.addKeepStub(anchor.href);
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
                if (window.$editing !== undefined) {
                    window.$editing.loadHtmlEdit(form);
                }

                // Remove tooltips from forms as they are for screen-reader accessibility only
                form.title = '';

                // Convert form element title attributes into composr tooltips
                if ($cms.configOption('js_overlays')) {
                    // Convert title attributes into composr tooltips
                    var elements = arrVal(form.elements), j;

                    elements = elements.concat(form.querySelectorAll('input[type="image"]')); // JS DOM does not include input[type="image"] ones in form.elements

                    for (j = 0; j < elements.length; j++) {
                        if ((elements[j].title !== undefined) && (elements[j]['original-title'] === undefined/*check tipsy not used*/) && !elements[j].classList.contains('no-tooltip')) {
                            convertTooltip(elements[j]);
                        }
                    }
                }

                if (boolVal('{$VALUE_OPTION;,js_keep_params}')) {
                    /* Keep parameters need propagating */
                    if (form.action && form.action.startsWith($cms.getBaseUrl() + '/')) {
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

    $cms.behaviors.initializeTables = {
        attach: function attach(context) {
            var tables = $util.once($dom.$$$(context, 'table'), 'behavior.initializeTables');

            tables.forEach(function (table) {
                // Responsive table prep work
                if (table.classList.contains('responsive-table')) {
                    var trs = table.getElementsByTagName('tr'),
                        thsFirstRow = trs[0].cells,
                        i, tds, j, data;

                    for (i = 0; i < trs.length; i++) {
                        tds = trs[i].cells;
                        for (j = 0; j < tds.length; j++) {
                            if (!tds[j].classList.contains('responsive-table-no-prefix')) {
                                data = (thsFirstRow[j] == null) ? '' : thsFirstRow[j].textContent.replace(/^\s+/, '').replace(/\s+$/, '');
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

    // Implementation for [data-click-pd]
    // Prevent-default for JS-activated elements (which may have noscript fallbacks as default actions)
    $cms.behaviors.onclickPreventDefault = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-click-pd]'), 'behavior.onclickPreventDefault');
            els.forEach(function (el) {
                $dom.on(el, 'click', function (e) {
                    e.preventDefault();
                });
            });
        }
    };

    // Implementation for [data-submit-pd]
    // Prevent-default for JS-activated elements (which may have noscript fallbacks as default actions)
    $cms.behaviors.onsubmitPreventDefault = {
        attach: function (context) {
            var forms = $util.once($dom.$$$(context, '[data-submit-pd]'), 'behavior.onsubmitPreventDefault');
            forms.forEach(function (form) {
                $dom.on(form, 'submit', function (e) {
                    e.preventDefault();
                });
            });
        }
    };

    // Implementation for input[data-cms-unchecked-is-indeterminate]
    $cms.behaviors.uncheckedIsIndeterminate = {
        attach: function (context) {
            var inputs = $util.once($dom.$$$(context, 'input[data-cms-unchecked-is-indeterminate]'), 'behavior.uncheckedIsIndeterminate');

            inputs.forEach(function (input) {
                if (input.type === 'checkbox') {
                    if (!input.checked) {
                        input.indeterminate = true;
                    }

                    $dom.on(input, 'change', function uncheckedIsIndeterminate() {
                        if (!input.checked) {
                            input.indeterminate = true;
                        }
                    });
                }
            });
        }
    };

    // Implementation for [data-click-eval="<code to eval>"]
    $cms.behaviors.clickEval = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-click-eval]'), 'behavior.clickEval');

            els.forEach(function (el) {
                $dom.on(el, 'click', function clickEval() {
                    var code = strVal(el.dataset.clickEval);

                    if (code !== '') {
                        (function () {
                            eval(code); // eval() call
                        }).call(el); // Set `this` context for eval
                    }
                });
            });
        }
    };

    // Implementation for [data-click-alert]
    $cms.behaviors.onclickShowModalAlert = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-click-alert]'), 'behavior.onclickShowModalAlert');

            els.forEach(function (el) {
                $dom.on(el, 'click', function onclickShowModalAlert() {
                    var options = objVal($dom.data(el, 'clickAlert'), {}, 'notice');
                    $cms.ui.alert(options.notice);
                });
            });
        }
    };

    // Implementation for [data-keypress-alert]
    $cms.behaviors.onkeypressShowModalAlert = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-keypress-alert]'), 'behavior.onkeypressShowModalAlert');

            els.forEach(function (el) {
                $dom.on(el, 'keypress', function onkeypressShowModalAlert() {
                    var options = objVal($dom.data(el, 'keypressAlert'), {}, 'notice');
                    $cms.ui.alert(options.notice);
                });
            });
        }
    };

    // Implementation for [data-submit-on-enter]
    $cms.behaviors.submitOnEnter = {
        attach: function (context) {
            var inputs = $util.once($dom.$$$(context, '[data-submit-on-enter]'), 'behavior.submitOnEnter');

            inputs.forEach(function (input) {
                $dom.on(input, (input.nodeName.toLowerCase() == 'select') ? 'keyup' : 'keypress', function submitOnEnter(e) {
                    if ($dom.keyPressed(e, 'Enter')) {
                        $dom.submit(input.form);
                        e.preventDefault();
                    }
                });
            });
        }
    };

    // Implementation for [data-mouseover-class="{ 'some-class' : 1|0 }"]
    // Toggle classes based on mouse location
    $cms.behaviors.mouseoverClass = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-mouseover-class]'), 'behavior.mouseoverClass');

            els.forEach(function (el) {
                $dom.on(el, 'mouseover', function mouseoverClass(e) {
                    var classes = objVal($dom.data(el, 'mouseoverClass')), key, bool;

                    if (!e.relatedTarget || !el.contains(e.relatedTarget)) {
                        for (key in classes) {
                            bool = Boolean(classes[key]) && (classes[key] !== '0');
                            el.classList.toggle(key, bool);
                        }
                    }
                });
            });
        }
    };

    // Implementation for [data-mouseout-class="{ 'some-class' : 1|0 }"]
    // Toggle classes based on mouse location
    $cms.behaviors.mouseoutClass = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-mouseout-class]'), 'behavior.mouseoutClass');

            els.forEach(function (el) {
                $dom.on(el, 'mouseout', function mouseoutClass(e) {
                    var classes = objVal($dom.data(el, 'mouseoutClass')), key, bool;

                    if (!e.relatedTarget || !el.contains(e.relatedTarget)) {
                        for (key in classes) {
                            bool = Boolean(classes[key]) && (classes[key] !== '0');
                            el.classList.toggle(key, bool);
                        }
                    }
                });
            });
        }
    };

    // Implementation for [data-cms-confirm-click="<Message>"]
    // Show a confirmation dialog for clicks on a link (is higher up for priority)
    var _confirmedClick;
    $cms.behaviors.confirmClick = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-cms-confirm-click]'), 'behavior.confirmClick');

            els.forEach(function (el) {
                var uid = $util.uid(el),
                    message = strVal(el.dataset.cmsConfirmClick);

                $dom.on(el, 'click', function (e) {
                    if (_confirmedClick === uid) {
                        // Confirmed, let it through
                        return;
                    }
                    e.preventDefault();
                    $cms.ui.confirm(message, function (result) {
                        if (result) {
                            _confirmedClick = uid;
                            $dom.trigger(el, 'click');
                        }
                    });
                });
            });
        }
    };

    // Implementation for form[data-submit-modsecurity-workaround]
    // mod_security workaround
    $cms.behaviors.submitModSecurityWorkaround = {
        attach: function (context) {
            var forms = $util.once($dom.$$$(context, 'form[data-submit-modsecurity-workaround]'), 'behavior.submitModSecurityWorkaround');

            forms.forEach(function (form) {
                $dom.on(form, 'submit', function (e) {
                    if ($cms.form.isModSecurityWorkaroundEnabled()) {
                        e.preventDefault();
                        $cms.form.modSecurityWorkaround(form);
                    }
                });
            });
        }
    };

    // Implementation for form[data-disable-buttons-on-submit]
    // Disable form buttons on submit
    $cms.behaviors.disableButtonsOnFormSubmit = {
        attach: function (context) {
            var forms = $util.once($dom.$$$(context, 'form[data-disable-buttons-on-submit]'), 'behavior.disableButtonsOnFormSubmit');

            forms.forEach(function (form) {
                $dom.on(form, 'submit', function () {
                    $cms.ui.disableFormButtons(form);
                });
            });
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

    // Convert img title attributes into Composr tooltips
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

                /**
                 * @type { $cms.views.ToggleableTray }
                 */
                $dom.data(el).toggleableTrayObject = new $cms.views.ToggleableTray(options, {el: el});
            });
        }
    };

    // Implementation for [data-click-tray-toggle="<SELECTOR FOR TRAY ELEMENT>"]
    // Toggle a tray on click on an element
    $cms.behaviors.clickToggleTray = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-click-tray-toggle]'), 'behavior.clickToggleTray');

            els.forEach(function (el) {
                $dom.on(el, 'click', function () {
                    var trayId = strVal(el.dataset.clickTrayToggle),
                        trayEl = $dom.$(trayId);

                    if (!trayEl) {
                        return;
                    }

                    var ttObj = $dom.data(trayEl).toggleableTrayObject;
                    if (ttObj) {
                        ttObj.toggleTray();
                    }
                });
            });
        }
    };

    // Implementation for [data-textarea-auto-height]
    $cms.behaviors.textareaAutoHeight = {
        attach: function (context) {
            if ($cms.isMobile()) {
                return;
            }

            var textareas = $util.once($dom.$$$(context, '[data-textarea-auto-height]'), 'behavior.textareaAutoHeight');
            textareas.forEach(function (textarea) {
                $cms.manageScrollHeight(textarea);

                $dom.on(textarea, 'click input change keyup keydown', function manageScrollHeight() {
                    $cms.manageScrollHeight(textarea);
                });
            });
        }
    };

    var _invalidPatternCache = {};
    // Implementation for [data-prevent-input="<REGEX FOR DISALLOWED CHARACTERS>"]
    // Prevents input of matching characters
    $cms.behaviors.preventInput = {
        attach: function (context) {
            var inputs = $util.once($dom.$$$(context, 'data-prevent-input'), 'behavior.preventInput');

            inputs.forEach(function (input) {
                var pattern = input.dataset.preventInput, regex;

                regex = _invalidPatternCache[pattern] || (_invalidPatternCache[pattern] = new RegExp(pattern, 'g'));

                $dom.on(input, 'input keydown keypress', function (e) {
                    if (e.type === 'input') {
                        if (input.value.length === 0) {
                            input.value = ''; // value.length is also 0 if invalid value is entered for input[type=number] et al., clear that
                        } else if (input.value.search(regex) !== -1) {
                            input.value = input.value.replace(regex, '');
                        }
                    } else if ($dom.keyOutput(e, regex)) { // keydown/keypress event
                        // pattern matched, prevent input
                        e.preventDefault();
                    }
                });
            });
        }
    };

    // Implementation for [data-change-submit-form]
    // Submit form when the change event is fired on an input element
    $cms.behaviors.changeSubmitForm = {
        attach: function (context) {
            var inputs = $util.once($dom.$$$(context, '[data-change-submit-form]'), 'behavior.changeSubmitForm');

            inputs.forEach(function (input) {
                $dom.on(input, 'change', function () {
                    $dom.trigger(input.form, 'submit');
                });
            });
        }
    };

    // Implementation for [data-cms-btn-go-back]
    // Go back in browser history
    $cms.behaviors.btnGoBack = {
        attach: function (context) {
            var btns = $util.once($dom.$$$(context, '[data-cms-btn-go-back]'), 'behavior.btnGoBack');

            btns.forEach(function (btn) {
                $dom.on(btn, 'click', function () {
                    window.history.back();
                });
            });
        }
    };

    // Implementation for [data-click-ga-track]
    $cms.behaviors.clickGaTrack = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-click-ga-track]'), 'behavior.clickGaTrack');

            els.forEach(function (el) {
                $dom.on(el, 'click', function (e) {
                    var options = objVal($dom.data(el, 'clickGaTrack'));

                    e.preventDefault();
                    $cms.gaTrack(el, options.category, options.action);
                });
            });
        }
    };

    // Implementation for [data-click-ui-open]
    $cms.behaviors.onclickUiOpen = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-click-ui-open]'), 'behavior.onclickUiOpen');
            els.forEach(function (el) {
                $dom.on(el, 'click', function () {
                    var args = arrVal($dom.data(el, 'clickUiOpen'));
                    $cms.ui.open($util.rel($cms.maintainThemeInLink(args[0])), args[1], args[2], args[3], args[4]);
                });
            });
        }
    };

    // Implementation for [data-click-do-input]
    $cms.behaviors.onclickDoInput = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-click-do-input]'), 'behavior.onclickDoInput');

            els.forEach(function (el) {
                $dom.on(el, 'click', function () {
                    var args = arrVal($dom.data(el, 'clickDoInput')),
                        type = strVal(args[0]),
                        fieldName = strVal(args[1]),
                        tag = strVal(args[2]),
                        fnName = 'doInput' + $util.ucFirst($util.camelCase(type));

                    if (typeof window[fnName] === 'function') {
                        window[fnName](fieldName, tag);
                    } else {
                        $util.fatal('$cms.behaviors.onclickDoInput.attach(): Function not found "window.' + fnName + '()"');
                    }
                });
            });
        }
    };

    // Implementation for [data-click-toggle-checked="<SELECTOR FOR TARGET CHECKBOX(ES)>"]
    $cms.behaviors.onclickToggleCheckboxes = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-click-toggle-checked]'), 'behavior.onclickToggleCheckboxes');

            els.forEach(function (el) {
                $dom.on(el, 'click', function () {
                    var selector = strVal(el.dataset.clickToggleChecked),
                        checkboxes = $dom.$$(selector);

                    checkboxes.forEach(function (checkbox) {
                        $dom.toggleChecked(checkbox);
                    });
                });
            });
        }
    };

    // Implementation for [data-cms-rich-tooltip]
    // "Rich semantic tooltips"
    $cms.behaviors.cmsRichTooltip = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-cms-rich-tooltip]'), 'behavior.cmsRichTooltip');

            els.forEach(function (el) {
                var options = objVal($dom.data(el, 'cmsRichTooltip'));

                $dom.on(el, 'click mouseover keypress', function (e) {
                    if (el.ttitle === undefined) {
                        el.ttitle = (el.attributes['data-title'] ? el.getAttribute('data-title') : el.title);
                        el.title = '';
                    }

                    if ((e.type === 'mouseover') && options.haveLinks) {
                        return;
                    }

                    if (options.haveLinks && el.tooltipId && $dom.$id(el.tooltipId) && $dom.isDisplayed($dom.$id(el.tooltipId))) {
                        $cms.ui.deactivateTooltip(el);
                        return;
                    }

                    //arguments: el, event, tooltip, width, pic, height, bottom, noDelay, lightsOff, forceWidth, win, haveLinks
                    var args = [el, e, el.ttitle, 'auto', null, null, false, true, false, false, window, true];

                    try {
                        $cms.ui.activateTooltip.apply(undefined, args);
                    } catch (ex) {
                        $util.fatal('$cms.behaviors.cmsRichTooltip.attach(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
                    }
                });
            });
        }
    };

    // Implementation for [data-disable-on-click]
    // Disable button after click
    $cms.behaviors.disableOnClick = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-disable-on-click]'), 'behavior.disableOnClick');

            els.forEach(function (el) {
                $dom.on(el, 'click', function () {
                    $cms.ui.disableButton(el);
                });
            });
        }
    };

    // Implementation for [data-mouseover-activate-tooltip]
    $cms.behaviors.onmouseoverActivateTooltip = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-mouseover-activate-tooltip]'), 'behavior.onmouseoverActivateTooltip');

            els.forEach(function (el) {
                $dom.on(el, 'mouseover', function (e) {
                    if (!Array.isArray($dom.data(el, 'mouseoverActivateTooltip'))) {
                        return;
                    }

                    var args = arrVal($dom.data(el, 'mouseoverActivateTooltip'));

                    args.unshift(el, e);

                    try {
                        //arguments: el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, haveLinks
                        $cms.ui.activateTooltip.apply(undefined, args);
                    } catch (ex) {
                        $util.fatal('$cms.behaviors.onmouseoverActivateTooltip.attach(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
                    }
                });
            });
        }
    };

    // Implementation for [data-focus-activate-tooltip]
    $cms.behaviors.onfocusActivateTooltip = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-focus-activate-tooltip]'), 'behavior.onfocusActivateTooltip');

            els.forEach(function (el) {
                $dom.on(el, 'focus', function (e) {
                    if (!Array.isArray($dom.data(el, 'focusActivateTooltip'))) {
                        return;
                    }

                    var args = arrVal($dom.data(el, 'focusActivateTooltip'));

                    args.unshift(el, e);

                    try {
                        //arguments: el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, haveLinks
                        $cms.ui.activateTooltip.apply(undefined, args);
                    } catch (ex) {
                        $util.fatal('$cms.behaviors.onfocusActivateTooltip.attach(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
                    }
                });
            });
        }
    };

    // Implementation for [data-blur-deactivate-tooltip]
    $cms.behaviors.onblurDeactivateTooltip = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-blur-deactivate-tooltip]'), 'behavior.onblurDeactivateTooltip');

            els.forEach(function (el) {
                $dom.on(el, 'blur', function () {
                    $cms.ui.deactivateTooltip(el);
                });
            });
        }
    };

    // Implementation for [data-click-forward="{ child: '.some-selector' }"]
    $cms.behaviors.onclickForwardTo = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-click-forward]'), 'behavior.onclickForwardTo');

            els.forEach(function (el) {
                $dom.on(el, 'click', function (e) {
                    var options = objVal($dom.data(el, 'clickForward'), {}, 'child'),
                        child = strVal(options.child), // Selector for target child element
                        except = strVal(options.except), // Optional selector for excluded elements to let pass-through
                        childEl = $dom.$(el, child);

                    if (!childEl) {
                        // Nothing to do
                        return;
                    }

                    if (!childEl.contains(e.target) && (!except || !$dom.closest(e.target, except, el.parentElement))) {
                        // ^ Make sure the child isn't the current event's target already, and check for excluded elements to let pass-through
                        e.preventDefault();
                        $dom.trigger(childEl, 'click');
                    }
                });
            });
        }
    };

    // Implementation for [data-open-as-overlay]
    // Open page in overlay
    $cms.behaviors.onclickOpenOverlay = {
        attach: function (context) {
            if (!$cms.configOption('js_overlays')) {
                return;
            }

            var els = $util.once($dom.$$$(context, '[data-open-as-overlay]'), 'behavior.onclickOpenOverlay');

            els.forEach(function (el) {
                $dom.on(el, 'click', function (e) {
                    var options, url = (el.href === undefined) ? el.action : el.href;

                    if ($util.url(url).hostname !== window.location.hostname) {
                        return; // Cannot overlay, different domain
                    }

                    e.preventDefault();

                    options = objVal($dom.data(el, 'openAsOverlay'));
                    options.el = el;

                    openLinkAsOverlay(options);
                });
            });
        }
    };

    // Implementation for `click a[rel*="lightbox"]`
    // Open link in a lightbox
    $cms.behaviors.onclickOpenLightbox = {
        attach: function (context) {
            if (!($cms.configOption('js_overlays'))) {
                return;
            }

            var els = $util.once($dom.$$$(context, 'a[rel*="lightbox"]'), 'behavior.onclickOpenLightbox');

            els.forEach(function (el) {
                $dom.on(el, 'click', function (e) {
                    e.preventDefault();

                    if (el.querySelector('img, video')) {
                        openImageIntoLightbox(el);
                    } else {
                        openLinkAsOverlay({ el: el });
                    }

                    function openImageIntoLightbox(el) {
                        var hasFullButton = (el.firstElementChild == null) || (el.href !== el.firstElementChild.src);
                        $cms.ui.openImageIntoLightbox(el.href, ((el.cmsTooltipTitle !== undefined) ? el.cmsTooltipTitle : el.title), null, null, hasFullButton);
                    }
                });
            });
        }
    };

    // Implementation for [data-cms-href="<URL>"]
    // Simulated [href] for non <a> elements
    $cms.behaviors.cmsHref = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-cms-href]'), 'behavior.cmsHref');

            els.forEach(function (el) {
                $dom.on(el, 'click', function (e) {
                    var anchorClicked = Boolean($dom.closest(e.target, 'a', el));

                    // Make sure a child <a> element wasn't clicked and default wasn't prevented
                    if (!anchorClicked && !e.defaultPrevented) {
                        $util.navigate(el);
                    }
                });
            });
        }
    };
    
    // Implementation for [data-ajaxify="{...}"] and [data-ajaxify-target="1"]
    // Mark ajaxified containers with [data-ajaxify="{...}"]
    // Mark links and forms to ajaxify with [data-ajaxify-target="1"]
    $cms.behaviors.ajaxify = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-ajaxify]'), 'behavior.ajaxify');

            els.forEach(function (ajaxifyContainer) {
                var options = objVal($dom.data(ajaxifyContainer, 'ajaxify')),
                    callUrl = $util.url(options.callUrl),
                    callParams = objVal(options.callParams),
                    callParamsFromTarget = arrVal(options.callParamsFromTarget); 
                    // ^ An array of regexes that we will match with query string params in the target's [href] or [action] URL and if matched, pass them along with the block call

                for (var key in callParams) {
                    callUrl.searchParams.set(key, callParams[key]);
                }
                
                $dom.on(ajaxifyContainer, 'click', 'a[data-ajaxify-target]', doAjaxify);
                $dom.on(ajaxifyContainer, 'submit', 'form[data-ajaxify-target]', doAjaxify);

                function doAjaxify(e, target) {
                    if ($dom.parent(target, '[data-ajaxify]') !== ajaxifyContainer) {
                        return; // Child of a different ajaxify container.
                    }
                    
                    e.preventDefault();
                    
                    var thisCallUrl = $util.url(callUrl),
                        postParams = null,
                        targetUrl = $util.url((target.localName === 'a') ? target.href : target.action);
                    
                    if (callParamsFromTarget.length > 0) {
                        // Any parameters matching a pattern must be sent in the URL to the AJAX block call
                        $util.eachIter(targetUrl.searchParams.entries(), function (param) {
                            var paramName = param[0],
                                paramValue = param[1];

                            callParamsFromTarget.forEach(function (pattern) {
                                pattern = new RegExp(pattern);

                                if (pattern.test(paramName)) {
                                    thisCallUrl.searchParams.set(paramName, paramValue);
                                }
                            });
                        });
                    }

                    if (target.localName === 'form') {
                        if (target.method.toLowerCase() === 'post') {
                            postParams = '';
                        }

                        var paramName, paramValue;
                        for (var j = 0; j < target.elements.length; j++) {
                            if (target.elements[j].name) {
                                paramName = target.elements[j].name;
                                paramValue = $cms.form.cleverFindValue(target, target.elements[j]);

                                if (target.method.toLowerCase() === 'post') {
                                    if (postParams !== '') {
                                        postParams += '&';
                                    }
                                    postParams += paramName + '=' + encodeURIComponent(paramValue);
                                } else {
                                    thisCallUrl.searchParams.set(paramName, paramValue);
                                    targetUrl.searchParams.set(paramName, paramValue); // Used for setting new window URL
                                }
                            }
                        }
                    }

                    $cms.ui.clearOutTooltips();

                    // Make AJAX block call
                    $cms.callBlock($util.rel(thisCallUrl), '', ajaxifyContainer, false, false, postParams).then(function () {
                        window.scrollTo(0, $dom.findPosY(ajaxifyContainer, true));
                        
                        /* Update current URL */
                        var newPageUrl = $cms.pageUrl();
                        $util.eachIter(targetUrl.searchParams.entries(), function (param) {
                            var paramName = param[0],
                                paramValue = param[1],
                                skip = /^(zone|page|type|id|raw|cache|auth_key|block_map|snippet|utheme|ajax)$/;
                            
                            if (!skip.test(paramName)) {
                                newPageUrl.searchParams.set(paramName, paramValue);
                            }
                        });

                        window.hasJsState = true;
                        window.history.pushState({}, document.title, newPageUrl.toString());
                    });
                }
            });
        }
    };

    // Only for debugging purposes, finds and logs orphan [data-ajaxify-target] instances
    $cms.behaviors.ajaxifyTarget = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-ajaxify-target]'), 'behavior.ajaxifyTarget');

            els.forEach(function (ajaxifyTarget) {
                if (!$dom.parent(ajaxifyTarget, '[data-ajaxify]')) {
                    $util.error('[data-ajaxify-target] instance found without a corresponding [data-ajaxify] container.');
                }
            });
        }
    };

    // Implementation for [data-stuck-nav]
    // Pinning to top if scroll out (LEGACY: CSS is going to have a better solution to this soon)
    $cms.behaviors.stuckNav = {
        attach: function (context) {
            var els = $util.once($dom.$$$(context, '[data-stuck-nav]'), 'behavior.stuckNav');

            els.forEach(function (stuckNav) {
                window.addEventListener('scroll', $util.throttle(function () {
                    scrollListener(stuckNav);
                }, 400));
            });

            /**
             * @param { Element } stuckNav
             */
            function scrollListener(stuckNav) {
                var stuckNavHeight = (stuckNav.realHeight == null) ? $dom.contentHeight(stuckNav) : stuckNav.realHeight;

                stuckNav.realHeight = stuckNavHeight;
                var posY = $dom.findPosY(stuckNav.parentNode, true),
                    footerHeight = document.querySelector('footer') ? document.querySelector('footer').offsetHeight : 0,
                    panelBottom = $dom.$('#panel-bottom');

                if (panelBottom) {
                    footerHeight += panelBottom.offsetHeight;
                }
                panelBottom = $dom.$('#global-messages-2');
                if (panelBottom) {
                    footerHeight += panelBottom.offsetHeight;
                }
                if (stuckNavHeight < ($dom.getWindowHeight() - footerHeight)) { // If there's space in the window to make it "float" between header/footer
                    var extraHeight = (window.pageYOffset - posY);
                    if (extraHeight > 0) {
                        var width = $dom.contentWidth(stuckNav),
                            height = $dom.contentHeight(stuckNav),
                            stuckNavWidth = $dom.contentWidth(stuckNav);

                        if (!window.getComputedStyle(stuckNav).getPropertyValue('width')) { // May be centered or something, we should be careful
                            stuckNav.parentNode.style.width = width + 'px';
                        }
                        stuckNav.parentNode.style.height = height + 'px';
                        stuckNav.style.position = 'fixed';
                        stuckNav.style.top = '0px';
                        stuckNav.style.zIndex = '1000';
                        stuckNav.style.width = stuckNavWidth + 'px';
                    } else {
                        stuckNav.parentNode.style.width = '';
                        stuckNav.parentNode.style.height = '';
                        stuckNav.style.position = '';
                        stuckNav.style.top = '';
                        stuckNav.style.width = '';
                    }
                } else {
                    stuckNav.parentNode.style.width = '';
                    stuckNav.parentNode.style.height = '';
                    stuckNav.style.position = '';
                    stuckNav.style.top = '';
                    stuckNav.style.width = '';
                }
            }
        }
    };

    function openLinkAsOverlay(options) {
        options = $util.defaults({
            width: '800',
            height: 'auto',
            target: '_top',
            el: null
        }, options);

        var width = strVal(options.width);

        if (width.match(/^\d+$/)) { // Restrain width to viewport width
            width = Math.min(parseInt(width), $dom.getWindowWidth() - 60) + '';
        }

        var el = options.el,
            url = (el.href === undefined) ? el.action : el.href,
            urlStripped = url.replace(/#.*/, ''),
            newUrl = urlStripped + (!urlStripped.includes('?') ? '?' : '&') + 'wide_high=1' + url.replace(/^[^\#]+/, '');

        $cms.ui.open(newUrl, null, 'width=' + width + ';height=' + options.height, options.target);
    }

    function convertTooltip(el) {
        var title = el.title;

        if (!title || $cms.browserMatches('touch_enabled') || el.classList.contains('leave-native-tooltip') || el.dataset['mouseoverActivateTooltip']) {
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
    }
}(window.$cms, window.$util, window.$dom));

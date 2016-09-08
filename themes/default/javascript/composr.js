(function (Composr, _, Backbone, data) {
    'use strict';

    Object.assign(Composr, {
        $PAGE_TITLE: data.PAGE_TITLE,
        $MEMBER: data.MEMBER,
        $IS_GUEST: data.IS_GUEST,
        $USERNAME: data.USERNAME,
        $AVATAR: data.AVATAR,
        $MEMBER_EMAIL: data.MEMBER_EMAIL,
        $PHOTO: data.PHOTO,
        $MEMBER_PROFILE_URL: data.MEMBER_PROFILE_URL,
        $FROM_TIMESTAMP: data.FROM_TIMESTAMP,
        $MOBILE: data.MOBILE,
        $THEME: data.THEME,
        $JS_ON: data.JS_ON,
        $LANG: data.LANG,
        $BROWSER_UA: data.BROWSER_UA,
        $OS: data.OS,
        $DEV_MODE: data.DEV_MODE,
        $USER_AGENT: data.USER_AGENT,
        $IP_ADDRESS: data.IP_ADDRESS,
        $TIMEZONE: data.TIMEZONE,
        $HTTP_STATUS_CODE: data.HTTP_STATUS_CODE,
        $CHARSET: data.CHARSET,
        $KEEP: data.KEEP,
        $SITE_NAME: data.SITE_NAME,
        $COPYRIGHT: data.COPYRIGHT,
        $DOMAIN: data.DOMAIN,
        $FORUM_BASE_URL: data.FORUM_BASE_URL,
        $BASE_URL: data.BASE_URL,
        $BRAND_NAME: data.BRAND_NAME,
        $IS_STAFF: data.IS_STAFF,
        $IS_ADMIN: data.IS_ADMIN,
        $VERSION: data.VERSION,
        $COOKIE_PATH: data.COOKIE_PATH,
        $COOKIE_DOMAIN: data.COOKIE_DOMAIN,
        $IS_HTTPAUTH_LOGIN: data.IS_HTTPAUTH_LOGIN,
        $IS_A_COOKIE_LOGIN: data.IS_A_COOKIE_LOGIN,
        $SESSION_COOKIE_NAME: data.SESSION_COOKIE_NAME,
        $GROUP_ID: data.GROUP_ID,
        $CONFIG_OPTION: data.CONFIG_OPTION,
        $VALUE_OPTION: data.VALUE_OPTION,
        $HAS_PRIVILEGE: data.HAS_PRIVILEGE,
        // Just some additonal stuff, not a tempcode symbol
        $EXTRA: data.EXTRA
    });

    var objProto  = Object.prototype,
        toString  = Function.bind.call(Function.call, objProto.toString),
        elProto   = HTMLElement.prototype,
        elMatches = Function.bind.call(Function.call, elProto.matches || elProto.webkitMatchesSelector || elProto.msMatchesSelector),
        arrProto  = Array.prototype,
        toArray   = Function.bind.call(Function.call, arrProto.slice),
        noop = function () {},

        loadPolyfillsPromise = new Promise(function (resolve) {
            loadPolyfills(resolve);
        }),

        domReadyPromise = new Promise(function (resolve) {
            if (document.readyState === 'interactive') {
                resolve();
            } else {
                document.addEventListener('DOMContentLoaded', function listener() {
                    document.removeEventListener('DOMContentLoaded', listener);
                    resolve();
                });
            }
        }),

        windowLoadPromise = new Promise(function (resolve) {
            if (document.readyState === 'complete') {
                resolve();
            } else {
                window.addEventListener('load', function listener() {
                    window.removeEventListener('load', listener);
                    resolve();
                });
            }
        });

    Promise.all([loadPolyfillsPromise, domReadyPromise]).then(function () {
        Composr.queryString = new window.URLSearchParams(window.location.search);

        Composr._resolveReady();
        delete Composr._resolveReady;
    });

    Promise.all([Composr.ready, windowLoadPromise]).then(function () {
        Composr._resolveLoad();
        delete Composr._resolveLoad;
    });

    function isA(obj, clazz) {
        return toString(obj) === '[object ' + clazz + ']';
    }

    function defined() {
        var i;
        for (i = 0; i < arguments.length; i++) {
            if (arguments[i] === undefined) {
                return false;
            }
        }
        return true;
    }

    function nodeType(obj) {
        return (!!obj) && (typeof obj === 'object') && ('nodeType' in obj) && obj.nodeType;
    }

    function isDocOrEl(obj) {
        var nt = nodeType(obj);
        return (nt === window.Node.DOCUMENT_NODE) || (nt === window.Node.ELEMENT_NODE);
    }

    function isEl(el) {
        return nodeType(el) === window.Node.ELEMENT_NODE;
    }

    Composr.isA = isA;
    Composr.defined = defined;
    Composr.nodeType = nodeType;
    Composr.isDocOrEl = isDocOrEl;
    Composr.isEl = isEl;


    /* String interpolation */
    Composr.str = function (format) {
        var args = toArray(arguments); // Make a copy
        args[0] = ''; // Replace 'format' with empty string
        return format.replace(/\{(\d+)\}/g, function (match, number) {
            return (args[number] !== undefined) ? args[number] : match;
        });
    };

    /* Generate url */
    Composr.url = function (path) {
        return Composr.$BASE_URL + '/' + path;
    };

    /* Mainly used to check tempcode values, since in JavaScript '0' (string) is true */
    Composr.isFalsy = function (val) {
        return !val || (val.length === 0) || ((typeof val === 'string') && ((val.trim() === '') || (val.trim() === '0')));
    };

    Composr.not = function () {
        var i = 0, len = arguments.length;

        while (i < len) {
            if (!Composr.isFalsy(arguments[i])) {
                return false;
            }
            i++;
        }

        return true;
    };

    Composr.is = function () {
        var i = 0, len = arguments.length;

        while (i < len) {
            if (Composr.isFalsy(arguments[i])) {
                return false;
            }
            i++;
        }

        return true;
    };

    /* Used for specifying required arguments */
    Composr.required = function (obj, keys) {
        var i, len;

        if (!Array.isArray(keys)) {
            throw new Error('Parameter \'keys\' must be an array.');
        }

        for (i = 0, len = keys.length; i < len; i++) {
            if (!obj.hasOwnProperty(keys[i])) {
                throw new Error('Object is missing a required key: \'' + keys[i] + '\'.');
            }
        }
    };

    Composr.log    = Composr.$DEV_MODE ? console.log : noop;
    Composr.dir    = Composr.$DEV_MODE ? console.dir : noop;
    Composr.assert = Composr.$DEV_MODE ? console.assert : noop;
    Composr.error  = Composr.$DEV_MODE ? console.error : noop;
    Composr.exception = function (ex) {
        if (Composr.$DEV_MODE) {
            throw ex;
        }
    };

    Composr.settings = {};

    /* Addons will add "behaviors" under this object */
    Composr.behaviors = {};

    Composr.attachBehaviors = function (context, settings) {
        var i, behaviors, j;

        if (!isDocOrEl(context)) {
            throw new Error(Composr.str("Invalid argument type: 'context' must be of type HTMLDocument or HTMLElement, '{1}' supplied.", toString(context)));
        }

        settings = settings || Composr.settings;

        // Execute all of them.
        for (i in Composr.behaviors) {
            if (Composr.behaviors.hasOwnProperty(i) && (typeof Composr.behaviors[i] === 'object')) {
                behaviors = Composr.behaviors[i];

                for (j in behaviors) {
                    if (behaviors.hasOwnProperty(j) && (typeof behaviors[j] === 'object') && (typeof behaviors[j].attach === 'function')) {
                        //try {
                            behaviors[j].attach(context, settings);
                        //} catch (e) {
                        //    Composr.error('Error while attaching behavior \'' + j + '\' of addon \'' + i + '\'', e);
                        //}
                    }
                }
            }
        }
    };

    Composr.detachBehaviors = function (context, settings, trigger) {
        var i, behaviors, j;

        if (!isDocOrEl(context)) {
            throw new Error(Composr.str("Invalid argument type: 'context' must be of type HTMLDocument or HTMLElement, '{1}' supplied.", toString(context)));
        }

        settings = settings || Composr.settings;
        trigger = trigger || 'unload';

        // Execute all of them.
        for (i in Composr.behaviors) {
            if (Composr.behaviors.hasOwnProperty(i) && (typeof Composr.behaviors[i] === 'object')) {
                behaviors = Composr.behaviors[i];

                for (j in behaviors) {
                    if (behaviors.hasOwnProperty(j) && (typeof behaviors[j] === 'object') && (typeof behaviors[j].detach === 'function')) {
                        try {
                            behaviors[j].detach(context, settings, trigger);
                        } catch (e) {
                            Composr.error('Error while detaching behavior \'' + j + '\' of addon \'' + i + '\'', e);
                        }
                    }
                }
            }
        }
    };

    /* Addons will add template related methods under this object */
    Composr.templates = {};

    Composr.initializeTemplates = function initializeTemplates(context, addonName) {
        addonName = addonName.replace(/_/g, '-');

        Composr.dom.$$$(context, '[data-tpl-' + addonName + ']').forEach(function (el) {
            var tplName = el.dataset[Composr.util.camelCase('tpl-' + addonName)].trim(),
                addonArgs = '',
                args = [];

            if ((el.localName === 'script') && (el.type === 'application/json')) {
                // Arguments provided inside the <script> tag.
                addonArgs = el.textContent.trim();
            } else {
                // Arguments provided in the data-tpl-args attribute.
                addonArgs = el.dataset.tplArgs ? el.dataset.tplArgs.trim() : '';
            }

            if (addonArgs !== '') {
                args = JSON.parse(addonArgs);

                if (!Array.isArray(args)) {
                    args = [args];
                }
            }

            var addonNameCamelCased = Composr.util.camelCase(addonName),
                tplFunc = Composr.templates[addonNameCamelCased] ? Composr.templates[addonNameCamelCased][tplName] : null;

            if (typeof tplFunc === 'function') {
                tplFunc.apply(el, args);
            }
        });
    };

    Composr.View = Backbone.View.extend({
        options: null,
        initialize: function (viewOptions, options) {
            this.options = options || {};
        },
        $: function (selector) {
            return Composr.dom.$(this.el, selector);
        },
        $$: function (selector) {
            return Composr.dom.$$(this.el, selector);
        },
        $$$: function (selector) {
            return Composr.dom.$$$(this.el, selector);
        }
    });

    /* Addons will add Composr.View subclasses under this object */
    Composr.views = {};

    Composr.initializeViews = function (context, addonName) {
        var addonNameKibab = addonName.replace(/_/g, '-'),
            addonNameCamelCase = Composr.util.camelCase(addonName);

        Composr.dom.$$$(context, '[data-view-' + addonNameKibab + ']').forEach(function (el) {
            var viewClasses = Composr.views[addonNameCamelCase],
                viewClassName = el.dataset[Composr.util.camelCase('view-' + addonNameKibab)].trim(),
                options = Composr.parseDataObject(el.dataset.viewArgs),
                View;

            if (viewClasses && viewClasses[viewClassName]) {
                View = viewClasses[viewClassName];

                new View({el: el}, options);
            }
        });
    };

    /* Tempcode filters ported to JS */
    Composr.filters = {};

    // JS port of the cms_url_encode function used by the tempcode filter '&'
    Composr.filters.urlEncode = function (urlPart, canTryUrlSchemes) {
        var urlPartEncoded = urlencode(urlPart);

        if (urlPartEncoded === urlPart) {
            return urlPartEncoded;
        }

        if ((typeof canTryUrlSchemes === 'undefined') || (canTryUrlSchemes === null)) {
            canTryUrlSchemes = Composr.$EXTRA.canTryUrlSchemes;
        }

        if (canTryUrlSchemes) {
            // These interfere with URL Scheme processing because they get pre-decoded and make things ambiguous
            urlPart = urlPart.replace(/\//g, ':slash:').replace(/&/g, ':amp:').replace(/#/g, ':uhash:');
        }

        return urlencode(urlPart);
    };

    // JavaScript port of php's urlencode function
    // Credit: http://locutus.io/php/url/urlencode/
    function urlencode(str) {
        str = (str + '');
        return encodeURIComponent(str)
            .replace(/!/g, '%21')
            .replace(/'/g, '%27')
            .replace(/\(/g, '%28')
            .replace(/\)/g, '%29')
            .replace(/\*/g, '%2A')
            .replace(/%20/g, '+')
            .replace(/~/g, '%7E');
    }

    Composr.filters.stripNewLines = function (str) {
        if (typeof str !== 'string') {
            throw new Error('Invalid argument type: \'str\' must be a string.');
        }

        return str.replace(/[\r\n]/g, '');
    };

    Composr.filters.id = function (str) {
        var out, i, char, ascii, remap = {
            '[': '_opensquare_',
            ']': '_closesquare_',
            '\'': '_apostophe_',
            '-': '_minus_',
            ' ': '_space_',
            '+': '_plus_',
            '*': '_star_',
            '/': '__'
        };

        if (typeof str !== 'string') {
            throw new Error('Invalid argument type: \'str\' must be a string.');
        }

        out = '';

        for (i = 0; i < str.length; i++) {
            char = str[i];

            if (remap[char] !== undefined) {
                out += remap[char];
            } else {
                ascii = char.charCodeAt(0);

                if (((i !== 0) && (char === '_')) || ((ascii >= 48) && (ascii <= 57)) || ((ascii >= 65) && (ascii <= 90)) || ((ascii >= 97) && (ascii <= 122))) {
                    out += char;
                } else {
                    out += '_' + ascii + '_';
                }
            }
        }

        if (out === '') {
            out = 'zero_length';
        }

        if (out[0] === '_') {
            out = 'und_' + out;
        }

        return out;
    };

    /* General utility methods */
    Composr.util = {};

    // Returns a random integer between min (inclusive) and max (inclusive)
    // Using Math.round() will give you a non-uniform distribution!
    Composr.util.random = function random(min, max) {
        if (min === undefined) {
            min = 0;
        }

        if (max === undefined) {
            max = 4294967295;
        }

        return Math.floor(Math.random() * (max - min + 1)) + min;
    };

    // Credit: http://stackoverflow.com/a/32604073/362006
    Composr.util.camelCase = function camelCase(str) {
        // Lower cases the string
        return str.toLowerCase()
            // Replaces any - or _ characters with a space
            .replace( /[-_]+/g, ' ')
            // Removes any non alphanumeric characters
            .replace( /[^\w\s]/g, '')
            // Uppercases the first character in each group immediately following a space
            // (delimited by spaces)
            .replace( / (.)/g, function ($1) { return $1.toUpperCase(); })
            // Removes spaces
            .replace( / /g, '' );
    };

    Composr.util.dasherize = function (str) {
        return str.replace(/::/g, '/')
            .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
            .replace(/([a-z\d])([A-Z])/g, '$1_$2')
            .replace(/_/g, '-')
            .toLowerCase();

    };

    Composr.window = function (node) {
        var type = nodeType(node);

        if (!type) {
            return null;
        }

        if (type === window.Node.DOCUMENT_NODE) {
            return node.defaultView;
        }

        return node.ownerDocument.defaultView;
    };

    /* DOM helper methods */
    Composr.dom = {};

    // Returns a single matching child element, defaults to 'document' as parent
    Composr.dom.id = function (context, id) {
        return (arguments.length === 1) ? document.getElementById(context) : context.querySelector('#' + id);
    };

    // Returns a single matching child element, defaults to 'document' as parent
    Composr.dom.$ = function (context, selector) {
        if (arguments.length === 1) {
            selector = context;
            context = document;
        }

        return context.querySelector(selector);
    };

    // Returns an array with matching child elements
    Composr.dom.$$ = function (context, selector) {
        if (arguments.length === 1) {
            selector = context;
            context = document;
        }

        return toArray(context.querySelectorAll(selector));
    };

    // This one (3 dollarydoos) also includes the parent element (at offset 0) if it matches the selector
    Composr.dom.$$$ = function (el, selector) {
        var els = toArray(el.querySelectorAll(selector));

        if (Composr.dom.matches(el, selector)) {
            els.unshift(el);
        }

        return els;
    };

    // Simple abstraction layer for addEventListener, supports event delegation.
    Composr.dom.on = function (el, eventNames, listenerOrSelectorsMap) {
        var listener = listenerOrSelectorsMap;

        if (typeof listenerOrSelectorsMap === 'object') {
            // Event delegation, it's a map of selectors and their listener functions
            listener = function (e) {
                var selectors = listenerOrSelectorsMap,
                    selector, callback, match;

                for (selector in selectors) {
                    if (selectors.hasOwnProperty(selector)) {
                        callback = selectors[selector];
                        match = Composr.dom.closest(e.target, selector, el);

                        if (match) {
                            callback.call(match, e);
                        }
                    }
                }
            };
        }

        if (typeof eventNames === 'string') {
            eventNames = eventNames.trim().split(/\s+/);
        }

        eventNames.forEach(function (eventName) {
            el.addEventListener(eventName, listener);
        });

        return listener;
    };

    Composr.dom.off = function (el, eventNames, callback) {
        if (typeof eventNames === 'string') {
            eventNames = eventNames.trim().split(/\s+/);
        }

        eventNames.forEach(function (eventName) {
            el.removeEventListener(eventName, callback);
        });
    };

    // Creates an array from a NodeList or HTMLCollection or a single element
    Composr.dom.array = function (elOrList) {
        if (!elOrList || (typeof elOrList !== 'object')) {
            return [];
        }

        if (Array.isArray(elOrList)) {
            return elOrList;
        }

        if (isEl(elOrList)) {
            return [elOrList];
        }

        if (isA(elOrList, 'HTMLCollection') || isA(elOrList, 'NodeList')) {
            return toArray(elOrList);
        }

        return [];
    };

    Composr.dom.css = (function () {
        function camelize(str) {
            return str.replace(/-+(.)?/g, function (match, chr) {
                return chr ? chr.toUpperCase() : '';
            });
        }

        function getStyles(el, propsArr) {
            var props = {}, computedStyle = window.getComputedStyle(el, ''), i;

            for (i = 0; i < propsArr.length; i++) {
                props[propsArr[i]] = el.style[camelize(propsArr[i])] || computedStyle.getPropertyValue(Composr.util.dasherize(propsArr[i]));
            }

            return props;
        }

        function maybeAddPx(name, value) {
            var cssNumber = {
                'column-count': 1,
                'columns': 1,
                'font-weight': 1,
                'line-height': 1,
                'opacity': 1,
                'z-index': 1,
                'zoom': 1
            };

            return (typeof value === 'number' && !cssNumber[name]) ? (value + 'px') : value;
        }

        function setStyles(el, stylesMap) {
            var key, dashedKey, css = '';

            for (key in stylesMap) {
                if (stylesMap.hasOwnProperty(key)) {
                    dashedKey = Composr.util.dasherize(key);

                    if (!stylesMap[key] && (stylesMap[key] !== 0)) {
                        el.style.removeProperty(dashedKey);
                    } else {
                        css += dashedKey + ':' + maybeAddPx(dashedKey, stylesMap[key]) + ';';
                    }
                }
            }

            if (css.length) {
                el.style.cssText += ';' + css;
            }
        }

        return function (el, tbd) {
            if (typeof tbd === 'string') {
                // It's a CSS property name to retrieve
                return getStyles(el, [tbd])[tbd];
            }

            if (Array.isArray(tbd)) {
                // It's an array of CSS property names to retrieve
                return getStyles(el, tbd);
            }

            if (typeof tbd === 'object') {
                // It's a map of CSS property values to set
                setStyles(el, tbd);
            }
        };
    }());

    Composr.dom.keyPressed = function (keyboardEvent, checkKey) {
        var key = keyboardEvent.key;

        if (arguments.length === 2) {
            return Array.isArray(checkKey) ? (checkKey.indexOf(key) !== -1) : key === checkKey;
        }

        return key;
    };

    /**
     * Returns the output produced by a KeyboardEvent, or empty string if none
     * @param keyboardEvent { KeyboardEvent }
     * @return string
     */
    Composr.dom.keyOutput = function (keyboardEvent) {
        var key = keyboardEvent.key;

        if ((typeof key === 'string') && (key.length === 1)) {
            return key;
        }

        return '';
    };

    Composr.dom.html = function (el, html) {
        // Parser hint: .innerHTML okay
        var i, len;

        if (arguments.length === 1) {
            return el.innerHTML;
        }

        if (el.children.length !== 0) {
            for (i = 0, len = el.children.length; i < len; i++) {
                // Detach behaviors from the elements to be deleted
                Composr.detachBehaviors(el.children[i]);
            }
        }

        el.innerHTML = html;

        if ((html === '') || (el.children.length === 0)) {
            // No new child elements added.
            return;
        }

        for (i = 0, len = el.children.length; i < len; i++) {
            Composr.attachBehaviors(el.children[i]);
        }
    };

    Composr.dom.prependHtml = function (el, html) {
        var prevChildrenLength = el.children.length, newChildrenLength, i, stop;

        el.insertAdjacentHTML('afterbegin', html);

        newChildrenLength = el.children.length;

        if (prevChildrenLength === newChildrenLength) {
            // No new child elements added.
            return;
        }

        for (i = 0, stop = (prevChildrenLength - newChildrenLength); i < stop; i++) {
            Composr.attachBehaviors(el.children[i]);
        }
    };

    Composr.dom.appendHtml = function (el, html) {
        var startIndex = el.children.length, newChildrenLength, i;

        el.insertAdjacentHTML('beforeend', html);

        newChildrenLength = el.children.length;

        if (startIndex === newChildrenLength) {
            // No new child elements added.
            return;
        }

        for (i = startIndex; i < newChildrenLength; i++) {
            Composr.attachBehaviors(el.children[i]);
        }
    };

    /* Put some new HTML around the given element */
    Composr.dom.outerHtml = function (el, html) {
        var p   = el.parentNode,
            ref = el.nextSibling,
            c, ci;

        if (arguments.length === 1) {
            return el.outerHTML;
        }

        p.removeChild(el);

        Composr.dom.html(el, html);

        c = el.childNodes;

        while (c.length > 0) {
            ci = c[0];
            el.removeChild(ci);
            p.insertBefore(ci, ref);
        }
    };

    /* Returns the provided element's width excluding padding and borders */
    Composr.dom.contentWidth = function contentWidth(element) {
        var cs = window.getComputedStyle(element),
            padding = parseFloat(cs.paddingLeft) + parseFloat(cs.paddingRight),
            border = parseFloat(cs.borderLeftWidth) + parseFloat(cs.borderRightWidth);

        return element.offsetWidth - padding - border;
    };

    /* Returns the provided element's height excluding padding and border */
    Composr.dom.contentHeight = function contentHeigt(element) {
        var cs = window.getComputedStyle(element),
            padding = parseFloat(cs.paddingTop) + parseFloat(cs.paddingBottom),
            border = parseFloat(cs.borderTopWidth) + parseFloat(cs.borderBottomWidth);

        return element.offsetHeight - padding - border;
    };

    // Check if the given element matches selector
    Composr.dom.matches = function (el, selector) {
        return isEl(el) && elMatches(el, selector);
    };

    // Get nearest parent (or itself) element matching selector
    Composr.dom.closest = function (el, selector, untilParent) {
        if (!isEl(el) || (el === untilParent)) {
            return null;
        }

        if (Composr.dom.matches(el, selector)) {
            return el;
        }

        return Composr.dom.closest(el.parentElement, selector, untilParent);
    };

    Composr.parseDataObject = function (data, defaults) {
        data = typeof data === 'string' ? data.trim() : '';
        defaults = defaults || {};

        if ((data !== '') && (data !== '{}') && (data !== '1')) {
            try {
                data = JSON.parse(data);

                if (data && (typeof data === 'object')) {
                    return Object.assign({}, defaults, data);
                }
            } catch (ex) {
                Composr.error('Composr.parseDataArgs(), error parsing JSON: ' + data, ex);
            }
        }

        return defaults;
    };

    Composr.widgets = {};

    Composr.ui = {};

    Composr.ui.disableButton = function (btn, permanent) {
        if (permanent === undefined) {
            permanent = false;
        }

        if (btn.form && (btn.form.target === '_blank')) {
            return;
        }

        window.setTimeout(function () {
            btn.style.cursor = 'wait';
            btn.disabled = true;
            btn.under_timer = true;
        }, 20);

        if (!permanent) {
            window.setTimeout(enable, 5000);
            window.addEventListener('pagehide', enable);
        }

        function enable() {
            if (btn.under_timer) {
                btn.disabled = false;
                btn.under_timer = false;
                btn.style.cursor = 'default';
            }
        }
    };

    Composr.ui.disableFormButtons = function (form, permanent) {
        var buttons = Composr.dom.$$(form, 'input[type="submit"], input[type="button"], input[type="image"], button');

        buttons.forEach(function (btn) {
            Composr.ui.disableButton(btn, permanent);
        });
    };

    // This is kinda dumb, ported from checking.js, originally named as disable_buttons_just_clicked()
    Composr.ui.disableSubmitAndPreviewButtons = function (permanent) {
        // [accesskey="u"] identifies submit button, [accesskey="p"] identifies preview button
        var buttons = Composr.dom.$$('input[accesskey="u"], button[accesskey="u"], input[accesskey="p"], button[accesskey="p"]');

        if (permanent === undefined) {
            permanent = false;
        }

        buttons.forEach(function (btn) {
            if (!btn.disabled && !btn.under_timer) {// We do not want to interfere with other code potentially operating
                Composr.ui.disableButton(btn, permanent);
            }
        });
    };

    Composr.audio = {};

    function loadPolyfills(callback) {
        var scriptsToLoad = 0,
            scriptsLoaded = 0;

        // Credit: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/String/includes
        if (String.prototype.includes === undefined) {
            String.prototype.includes = function (search, start) {
                if (typeof start !== 'number') {
                    start = 0;
                }

                if (start + search.length > this.length) {
                    return false;
                }

                return this.indexOf(search, start) !== -1;
            };
        }

        if (window.onfocusin === undefined) { // Polyfill Firefox not supporting foucsin and focusout
            // Credit: https://github.com/Financial-Times/polyfill-service/blob/master/polyfills/Event/focusin/polyfill.js
            window.addEventListener('focus', function (event) {
                event.target.dispatchEvent(new Event('focusin', {
                    bubbles: true,
                    cancelable: true
                }));
            }, true);

            window.addEventListener('blur', function (event) {
                event.target.dispatchEvent(new Event('focusout', {
                    bubbles: true,
                    cancelable: true
                }));
            }, true);
        }

        // Add CustomEvent to Internet Explorer
        if (typeof window.CustomEvent !== 'function') {
            // Code from: https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent
            function CustomEvent(event, options) {
                options = options || { bubbles: false, cancelable: false, detail: undefined };
                var e = document.createEvent('CustomEvent');
                e.initCustomEvent(event, !!options.bubbles, !!options.cancelable, options.detail);
                return e;
            }

            CustomEvent.prototype = window.Event.prototype;
            window.CustomEvent = CustomEvent;
        }

        function onload() {
            scriptsLoaded++;

            if (scriptsToLoad === scriptsLoaded) {
                callback();
            }
        }

        function loadScript(src) {
            scriptsToLoad++;
            var s = document.createElement('script');
            s.onload = onload;
            s.async = true;
            s.src = src;
            document.head.appendChild(s);
        }

        if (window.URLSearchParams === undefined) {
            loadScript(Composr.$BASE_URL + '/data/polyfills/url-search-params.max.js');
        }

        if (!('key' in window.KeyboardEvent.prototype)) {
            loadScript(Composr.$BASE_URL + '/data/polyfills/keyboardevent-key-polyfill.js');
        }

        if (scriptsToLoad === 0) {
            callback();
        }
    }
}(window.Composr, window._, window.Backbone, JSON.parse(document.getElementsByName('composr-symbol-data')[0].content)));
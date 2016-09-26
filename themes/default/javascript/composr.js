(function (Composr, Backbone, symbol) {
    'use strict';

    // Cached references
    var objProto = Object.prototype,
        arrProto = Array.prototype,
        elProto  = window.HTMLElement.prototype,
        polyfillsPromise = new Promise(loadPolyfills), // Load polyfills
        domReadyPromise = new Promise(domReady),
        loadWindowPromise = new Promise(loadWindow);

    var ELEMENT_NODE = 1,
        DOCUMENT_NODE = 9,
        DOCUMENT_FRAGMENT_NODE = 11;

    Object.assign(Composr, {
        // Unique for each copy of Composr on the page
        id: 'Composr' + Math.random().toString().substr(2),

        // Load up symbols data
        $PAGE_TITLE: symbol.PAGE_TITLE,
        $MEMBER: symbol.MEMBER,
        $IS_GUEST: symbol.IS_GUEST,
        $USERNAME: symbol.USERNAME,
        $AVATAR: symbol.AVATAR,
        $MEMBER_EMAIL: symbol.MEMBER_EMAIL,
        $PHOTO: symbol.PHOTO,
        $MEMBER_PROFILE_URL: symbol.MEMBER_PROFILE_URL,
        $FROM_TIMESTAMP: symbol.FROM_TIMESTAMP,
        $MOBILE: symbol.MOBILE,
        $THEME: symbol.THEME,
        $JS_ON: symbol.JS_ON,
        $LANG: symbol.LANG,
        $BROWSER_UA: symbol.BROWSER_UA,
        $OS: symbol.OS,
        $DEV_MODE: symbol.DEV_MODE,
        $USER_AGENT: symbol.USER_AGENT,
        $IP_ADDRESS: symbol.IP_ADDRESS,
        $TIMEZONE: symbol.TIMEZONE,
        $HTTP_STATUS_CODE: symbol.HTTP_STATUS_CODE,
        $CHARSET: symbol.CHARSET,
        $KEEP: symbol.KEEP,
        $FORCE_PREVIEWS: symbol.FORCE_PREVIEWS,
        $PREVIEW_URL: symbol.PREVIEW_URL,
        $SITE_NAME: symbol.SITE_NAME,
        $COPYRIGHT: symbol.COPYRIGHT,
        $DOMAIN: symbol.DOMAIN,
        $FORUM_BASE_URL: symbol.FORUM_BASE_URL,
        $BASE_URL: symbol.BASE_URL,
        $CUSTOM_BASE_URL: symbol.CUSTOM_BASE_URL,
        $BASE_URL_NOHTTP: symbol.BASE_URL_NOHTTP,
        $CUSTOM_BASE_URL_NOHTTP: symbol.CUSTOM_BASE_URL_NOHTTP,
        $BRAND_NAME: symbol.BRAND_NAME,
        $IS_STAFF: symbol.IS_STAFF,
        $IS_ADMIN: symbol.IS_ADMIN,
        $VERSION: symbol.VERSION,
        $COOKIE_PATH: symbol.COOKIE_PATH,
        $COOKIE_DOMAIN: symbol.COOKIE_DOMAIN,
        $IS_HTTPAUTH_LOGIN: symbol.IS_HTTPAUTH_LOGIN,
        $IS_A_COOKIE_LOGIN: symbol.IS_A_COOKIE_LOGIN,
        $SESSION_COOKIE_NAME: symbol.SESSION_COOKIE_NAME,
        $GROUP_ID: symbol.GROUP_ID,
        $CONFIG_OPTION: symbol.CONFIG_OPTION,
        $VALUE_OPTION: symbol.VALUE_OPTION,
        $HAS_PRIVILEGE: symbol.HAS_PRIVILEGE,

        // Just some additonal stuff, not a tempcode symbol
        $EXTRA: symbol.EXTRA
    });

    polyfillsPromise.then(function () {
        // Polyfills loaded!
        Composr.usp = Composr.uspFromUrl(window.location.href);
    });

    function domReady(resolve) {
        if (document.readyState === 'interactive') {
            resolve();
        } else {
            document.addEventListener('DOMContentLoaded', function listener() {
                document.removeEventListener('DOMContentLoaded', listener);
                resolve();
            });
        }
    }

    function loadWindow(resolve) {
        if (document.readyState === 'complete') {
            resolve();
        } else {
            window.addEventListener('load', function listener() {
                window.removeEventListener('load', listener);
                resolve();
            });
        }
    }

    /* Fulfill and resolve promises! */
    Promise.all([polyfillsPromise, domReadyPromise]).then(function () {
        Composr._resolveReady();
        delete Composr._resolveReady;
    });

    Promise.all([Composr.ready, loadWindowPromise]).then(function () {
        Composr._resolveLoad();
        delete Composr._resolveLoad;
    });

    var toArray = Function.bind.call(Function.call, arrProto.slice),
        forEach = Function.bind.call(Function.call, arrProto.forEach),
        includes = Function.bind.call(Function.call, arrProto.includes),
        merge = Function.bind.call(Function.apply, arrProto.push),
        hasOwn = Function.bind.call(Function.call, objProto.hasOwnProperty),

        isArray = Array.isArray,

        // Browser detection. Credit: http://stackoverflow.com/a/9851769/362006
        // Opera 8.0+
        isOpera = (!!window.opr && !!window.opr.addons) || !!window.opera || (navigator.userAgent.includes(' OPR/')),
        // Firefox 1.0+
        isFirefox = (window.InstallTrigger !== undefined),
        // At least Safari 3+: HTMLElement's constructor's name is HTMLElementConstructor
        isSafari = clazz(window.HTMLElement) === 'HTMLElementConstructor',
        // Internet Explorer 6-11
        isIE = /*@cc_on!@*/false || (typeof document.documentMode === 'number'),
        // Edge 20+
        isEdge = !isIE && !!window.StyleMedia,
        // Chrome 1+
        isChrome = !!window.chrome && !!window.chrome.webstore,
        // Blink engine detection
        isBlink = (isChrome || isOpera) && !!window.CSS;

    function noop() {}

    function isset(val) {
        return (val !== undefined) && (val !== null);
    }

    function notset(val) {
        return (val === undefined) || (val === null);
    }

    var _cid = 1;
    function cid(obj) {
        return obj[Composr.id] || (obj[Composr.id] = _cid++);
    }

    function returnTrue(){
        return true;
    }

    function returnFalse() {
        return false;
    }

    // Gets the class/constructor function name from an object
    function clazz(obj) {
        return objProto.toString.call(obj).slice(8, -1); // slice off the surrounding '[object ' and ']'
    }

    function isObj(val) {
        return (val !== null) && (typeof val === 'object');
    }

    var rgxPrimitiveTypes = /^Boolean|Number|String|Function|Array|Date|RegExp|Object|Error$/;

    // Makes sure that val is not an object of another primitive type
    function isTrueObj(val) {
        var ctor;
        return isObj(val) && (((ctor = clazz(val)) === 'Object') || !rgxPrimitiveTypes.test(ctor));
    }

    function isFunc(val) {
        return typeof val === 'function';
    }

    // Makes sure that val is not a function of another primitive type
    function isTrueFunc(val) {
        var ctor;
        return isFunc(val) && (((ctor = clazz(val)) === 'Function') || !rgxPrimitiveTypes.test(ctor));
    }

    function isStr(val) {
        return typeof val === 'string';
    }

    function isEmptyObj(obj) {
        var k;
        if (!isObj(obj)) {
            return true;
        }
        for (k in obj) {
            return false;
        }
        return true;
    }

    function boolMap(arr) {
        var i, len, map = {};

        for (i = 0, len = arr.length; i < len; i++) {
            map[arr[i]] = true;
        }

        return map;
    }

    function isPlainObject (obj) {
        return isTrueObj(obj) && !isWindow(obj) && (Object.getPrototypeOf(obj) === Object.prototype);
    }

    // Checks if an object is of given class, expensive since it goes through the entire prototype chain
    function isA(obj, constructorName) {
        var proto;

        if (isObj(obj)) {
            proto = Object.getPrototypeOf(obj);
            while (proto !== null) {
                if (clazz(proto) === constructorName) {
                    return true;
                }

                proto = Object.getPrototypeOf(obj);
            }
        }
        return false;
    }

    function isWindow(obj) {
        return isObj(obj) && (obj === obj.window) && (obj === obj.self) && (clazz(obj) === 'Window');
    }

    function nodeType(obj) {
        return isObj(obj) && (typeof obj.nodeName === 'string') && (typeof obj.nodeType === 'number') && obj.nodeType;
    }

    function isNode(obj) {
        return nodeType(obj) !== false;
    }

    function isEl(obj) {
        return nodeType(obj) === ELEMENT_NODE;
    }

    function isDoc(obj) {
        return nodeType(obj) === DOCUMENT_NODE;
    }

    function isDocFrag(obj) {
        return nodeType(obj) === DOCUMENT_FRAGMENT_NODE;
    }

    function isDocOrEl(obj) {
        var t = nodeType(obj);
        return (t === ELEMENT_NODE) || (t === DOCUMENT_NODE);
    }

    function isDocOrFragOrEl(obj) {
        var t = nodeType(obj);
        return (t === ELEMENT_NODE) || (t === DOCUMENT_NODE) || (t === DOCUMENT_FRAGMENT_NODE);
    }

    function isEvent(obj) {
        return isObj(obj) && (typeof obj.type === 'string') && (typeof obj.preventDefault === 'function');
    }

    function instanceOf(obj, constructorName, global) {
        var Class;

        if (arguments.length === 2) {
            // Try to figure out the global
            if (isNode(obj) && obj.ownerDocument) {
                global = obj.ownerDocument.defaultView;
            } else {
                global = window;
            }
        }

        Class = global[constructorName];

        return obj instanceof Class;
    }

    function isNumeric(val) { // Inspired by jQuery.isNumeric
        return ((typeof val === 'number') || (typeof val === 'string')) && !Number.isNaN(val - parseFloat(val));
    }

    function defined() {
        var i, len;
        for (i = 0, len = arguments.length; i < len; i++) {
            if (arguments[i] === undefined) {
                return false;
            }
        }
        return true;
    }

    function isIterator(obj) {
        return isObj(obj) && (typeof obj.next === 'function');
    }

    function isArrayLike(obj, withElements) {
        var len;

        if (!isObj(obj) || isWindow(obj) || (typeof (len = obj.length) !== 'number') || (len < 0) || (withElements && (len < 1))) {
            return false;
        }

        return (len === 0) || ((0 in obj) && ((len - 1) in obj));
    }

    function isArrayLikeWithEls(obj) {
        return isArrayLike(obj, true);
    }

    /* Mainly used to check tempcode values, since in JavaScript '0' (string) is true */
    function isFalsy(val) {
        return !val || (val.length === 0) || ((typeof val === 'string') && ((val = val.trim()) === '') || (val === '0'));
    }

    function isTruthy(val) {
        return (val === true) || (val === '1') || !isFalsy(val);
    }

    // Returns a random integer between min (inclusive) and max (inclusive)
    // Using Math.round() will give you a non-uniform distribution!
    function random(min, max) {
        min = min || 0;
        max = max || 9007199254740990; // Number.MAX_SAFE_INTEGER - 1

        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    // Credit: http://stackoverflow.com/a/32604073/362006
    function camelCase(str) {
        // Lower cases the string
        return str.toLowerCase()
            // Replaces any - or _ characters with a space
            .replace(/[\-_]+/g, ' ')
            // Removes any non alphanumeric characters
            .replace(/[^\w\s]/g, '')
            // Uppercases the first character in each group immediately following a space
            // (delimited by spaces)
            .replace(/ (.)/g, function ($1) { return $1.toUpperCase(); })
            // Removes spaces
            .replace(/ /g, '');
    }

    function camelize(str) {
        return str.replace(/-+(.)?/g, function (match, chr) {
            return chr ? chr.toUpperCase() : '';
        });
    }

    function dasherize(str) {
        return str.replace(/::/g, '/')
            .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
            .replace(/([a-z\d])([A-Z])/g, '$1_$2')
            .replace(/_/g, '-')
            .toLowerCase();
    }

    function each(map, callback) {
        var key;

        for (key in map) {
            if (callback.call(map[key], key, map[key]) === false) {
                return;
            }
        }
    }

    function _extend(target, source, deep) {
        var key;
        for (key in source) {
            if (deep && (isPlainObject(source[key]) || isArray(source[key]))) {
                if (isPlainObject(source[key]) && !isPlainObject(target[key])) {
                    target[key] = {};
                }

                if (isArray(source[key]) && !isArray(target[key])) {
                    target[key] = [];
                }

                extend(target[key], source[key], deep);
            } else if (source[key] !== undefined) {
                target[key] = source[key]
            }
        }
    }

    // Copy all but undefined properties from one or more
    // objects to the `target` object.
    function extend(target) {
        var deep, args = toArray(arguments, 1);

        var type = clazz(target);

        if (type === 'Boolean') {
            deep = target;
            target = args.shift();
        } else if (type === 'RegExp') {

        }

        args.forEach(function (arg) {
            _extend(target, arg, deep);
        });

        return target
    }

    var isMobile = symbol.MOBILE === '1',
        isDevMode = symbol.DEV_MODE === '1',
        isGuest = symbol.IS_GUEST === '1',
        isStaff = symbol.IS_STAFF === '1',
        isAdmin = symbol.IS_ADMIN === '1';

    // Export useful stuff
    Object.assign(Composr, {
        isMobile: isMobile,
        isDevMode: isDevMode,
        isGuest: isGuest,
        isStaff: isStaff,
        isAdmin: isAdmin,

        toArray: toArray,
        forEach: forEach,
        some: Function.bind.call(Function.call, arrProto.some),
        every: Function.bind.call(Function.call, arrProto.every),
        includes: includes,
        hasOwn: hasOwn,

        isOpera: isOpera,
        isFirefox: isFirefox,
        isSafari: isSafari,
        isIE: isIE,
        isEdge: isEdge,
        isChrome: isChrome,
        isBlink: isBlink,

        clazz: clazz,
        isObj: isObj,
        isEmptyObj: isEmptyObj,
        nodeType: nodeType,
        isEl: isEl,
        isNumeric: isNumeric,
        isDocOrEl: isDocOrEl,
        defined: defined,
        isA: isA,
        isArrayLike: isArrayLike,
        noop: noop,
        random: random,
        camelCase: camelCase,

        each: each
    });

    Composr.not = function () {
        var i, len;
        for (i = 0, len = arguments.length; i < len; i++) {
            if (!isFalsy(arguments[i])) {
                return false;
            }
        }
        return true;
    };

    Composr.is = function () {
        var i, len;
        for (i = 0, len = arguments.length; i < len; i++) {
            if (!isTruthy(arguments[i])) {
                return false;
            }
        }
        return true;
    };

    // Sensible string coercion, and (optionally) interpolation
    Composr.str = function (str, values) {
        if (notset(str)) {
            return '';
        }

        if (typeof str === 'boolean') {
            return (str === true) ? '1' : '0';
        }

        if (typeof str !== 'string') {
            str = str.toString();
        }

        if (arguments.length < 2) {
            return str;
        }

        if (!isObj(values)) {
            // values provided as multiple parameters?
            values = toArray(arguments, 1);
            values.unshift(''); // Add empty string at index 0 so that interpolation starts from '{1}'
        } else if (isArrayLikeWithEls(values)) {
            // Array(-ish?) object provided with values
            values = toArray(values);
            values.unshift(''); // Add empty string at index 0 so that interpolation starts from '{1}'
        }

        return str.replace(/\{(\w+)\}/g, function (match, key) {
            return (key in values) ? Composr.str(values[key]) : match;
        });
    };

    /* Generate url */
    var rgxProtocol = /^https?:/;
    Composr.url = function (url) {
        if (rgxProtocol.test(url)) {
            // It's an absolute URL, just set the correct protocol
            return url.replace(rgxProtocol, window.location.protocol);
        }

        return Composr.$BASE_URL + '/' + url;
    };

    Composr.navigate = function (url, target) {
        if (isEl(url)) {
            url = ('cmsHref' in url.dataset) ? url.dataset.cmsHref : url.href;
            target = ('cmsTarget' in url.dataset) ? url.dataset.cmsTarget : url.target;
        }

        target || (target = '_self');

        if (target === '_self') {
            window.location = url;
        } else {
            window.open(url, target);
        }
    };

    // Extract query string from url
    Composr.extractQs = function (url) {
        var query = (url || '').split('?', 2)[1]; // Grab query string
        return (query || '').split('#')[0]; // Remove hash fragment (if any)
    };

    Composr.uspFromUrl = function (url) {
        var query = Composr.extractQs(url);
        return query ? new window.URLSearchParams(query) : null;
    };

    Composr.log = function () {
        if (isDevMode) {
            console.log.apply(undefined, arguments);
        }
    };

    Composr.dir = function () {
        if (isDevMode) {
            console.dir.apply(undefined, arguments);
        }
    };

    Composr.assert = function () {
        if (isDevMode) {
            console.assert.apply(undefined, arguments);
        }
    };

    Composr.error = function () {
        if (isDevMode) {
            console.error.apply(undefined, arguments);
        }
    };

    Composr.exception = function (ex) {
        if (isDevMode) {
            throw ex;
        }
    };

    /* DOM helper methods */
    Composr.dom = {};

    // `Composr.dom.qsa` is Composr's CSS selector implementation which
    // uses `document.querySelectorAll` and optimizes for some special cases, like `#id`, `.someclass` and `div`.
    var rgxSimpleSelector = /^[\#\.]?[\w-]+$/;
    Composr.dom.qsa = function (el, selector) {
        var name = selector.substr(1), found;

        // Safari DocumentFragment doesn't have getElementById
        // DocumentFragment doesn't have getElementsBy(Tag|Class)Name
        if (rgxSimpleSelector.test(selector) && !isDocFrag(el)) {
            switch (selector[0]) {
                case '#': // selector is an ID
                    return (found = el.getElementById(name)) ? [found] : [];
                    break;

                case '.': // selector is a class name
                    return toArray(el.getElementsByClassName(name));
                    break;

                default: // selector is a tag name
                    return toArray(el.getElementsByTagName(name));
                    break;
            }
        }

        return toArray(el.querySelectorAll(selector));
    };

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

        return Composr.dom.qsa(context, selector);
    };

    // This one (3 dollarydoos) also includes the parent element (at offset 0) if it matches the selector
    Composr.dom.$$$ = function (el, selector) {
        var els = toArray(el.querySelectorAll(selector));

        if (Composr.dom.matches(el, selector)) {
            els.unshift(el);
        }

        return els;
    };

    Composr.dom.hasIframeAccess = function (iframe) {
        try {
            return (iframe.contentWindow['access' + random()] = true) === true;
        } catch (ignore) {}

        return false;
    };

    var _matchesFnName = ('matches' in elProto) ? 'matches'
        : ('webkitMatchesSelector' in elProto) ? 'webkitMatchesSelector'
        : ('msMatchesSelector' in elProto) ? 'msMatchesSelector'
        : 'matches';

    // Check if the given element matches selector
    Composr.dom.matches = function (el, selector) {
        return isEl(el) && ((selector === '*') || el[_matchesFnName](selector));
    };

    // Gets closest parent (or itself) element matching selector
    Composr.dom.closest = function (el, selector, context) {
        while (el && (el !== context)) {
            if (Composr.dom.matches(el, selector)) {
                return el;
            }
            el = el.parentElement;
        }

        return null;
    };

    Composr.dom.parents = function (el, selector) {
        var parents = [], parent = isEl(el) && el.parentElement;

        while (parent) {
            if (!selector || Composr.dom.matches(parent, selector)) {
                parents.push(parent);
            }
            parent = parent.parentElement;
        }

        return parents;
    };

    Composr.dom.append = function (el, newChild) {
        el.appendChild(newChild);
    };

    Composr.dom.prepend = function (el, newChild) {
        el.insertBefore(newChild, el.firstChild);
    };

    (function () {
        var handlers = {},
            focus = { focus: 'focusin', blur: 'focusout' },
            hover = { mouseenter: 'mouseover', mouseleave: 'mouseout'};

        function parseEventName(event) {
            var parts = ('' + event).split('.');
            return {e: parts[0], ns: parts.slice(1).sort().join(' ')};
        }

        function matcherFor(ns) {
            return new RegExp('(?:^| )' + ns.replace(' ', ' .* ?') + '(?: |$)');
        }

        var focusinSupported = 'onfocusin' in window;
        function eventCapture(handler, captureSetting) {
            return handler.del && (!focusinSupported && (handler.e in focus)) || !!captureSetting;
        }

        function realEvent(type) {
            return hover[type] || (focusinSupported && focus[type]) || type;
        }

        function addEvent(el, events, fn, data, selector, delegator, capture) {
            var id = cid(el),
                set = handlers[id] || (handlers[id] = []);

            events.split(/\s/).forEach(function (event) {
                var handler = parseEventName(event);
                handler.fn = fn;
                handler.sel = selector;
                // emulate mouseenter, mouseleave
                if (handler.e in hover) {
                    fn = function (e) {
                        var related = e.relatedTarget;
                        if (!related || ((related !== this) && !this.contains(related))) {
                            return handler.fn.apply(this, arguments);
                        }
                    };
                }
                handler.del = delegator;
                var callback = delegator || fn;
                handler.proxy = function (e) {
                    var args = [e, el];
                    e.data = data;
                    if (isArray(e._args)) {
                        merge(args, e._args);
                    }
                    var result = callback.apply(el, args);
                    if (result === false) {
                        e.preventDefault();
                        e.stopPropagation();
                    }
                    return result;
                };
                handler.i = set.length;
                set.push(handler);

                el.addEventListener(realEvent(handler.e), handler.proxy, eventCapture(handler, capture))
            });
        }

        function findHandlers(element, event, fn, selector) {
            var matcher;
            event = parseEventName(event);
            if (event.ns) {
                matcher = matcherFor(event.ns)
            }
            return (handlers[cid(element)] || []).filter(function (handler) {
                return handler
                    && (!event.e || handler.e === event.e)
                    && (!event.ns || matcher.test(handler.ns))
                    && (!fn || cid(handler.fn) === cid(fn))
                    && (!selector || handler.sel === selector);
            })
        }

        function removeEvent(element, events, fn, selector, capture) {
            var id = cid(element);

            (events || '').split(/\s/).forEach(function (event) {
                findHandlers(element, event, fn, selector).forEach(function (handler) {
                    delete handlers[id][handler.i];
                    element.removeEventListener(realEvent(handler.e), handler.proxy, eventCapture(handler, capture))
                })
            })
        }

        Composr.dom.one = function (el, event, selector, data, callback) {
            return Composr.dom.on(el, event, selector, data, callback, 1);
        };

        Composr.dom.on = function (el, event, selector, data, callback, one) {
            var autoRemove, delegator;

            if (event && !isStr(event)) {
                each(event, function (type, fn) {
                    Composr.dom.on(el, type, selector, data, fn, one)
                });
                return;
            }

            if (!isStr(selector) && !isFunc(callback) && (callback !== false)) {
                callback = data;
                data = selector;
                selector = undefined;
            }

            if ((callback === undefined) || (data === false)) {
                callback = data;
                data = undefined;
            }

            if (callback === false) {
                callback = returnFalse;
            }

            if (one) {
                autoRemove = function (e) {
                    removeEvent(el, e.type, callback);
                    return callback.apply(this, arguments);
                };
            }

            if (selector) {
                delegator = function (e) {
                    var match = Composr.dom.closest(e.target, selector, el);

                    if (match && (match !== el)) {
                        var args = toArray(arguments);
                        args[1] = match; // Set the element arg to the matched element
                        return (autoRemove || callback).apply(match, args);
                    }
                };
            }

            addEvent(el, event, callback, data, selector, delegator || autoRemove);
        };

        Composr.dom.off = function (el, event, selector, callback) {
            if (event && !isStr(event)) {
                each(event, function (type, fn) {
                    Composr.dom.off(el, type, selector, fn);
                });
                return;
            }

            if (!isStr(selector) && !isFunc(callback) && (callback !== false)) {
                callback = selector;
                selector = undefined;
            }

            if (callback === false) {
                callback = returnFalse;
            }

            removeEvent(el, event, callback, selector)
        };

        var rgxMouseEvents = /^click|mousedown|mouseup|mousemove$/;
        Composr.dom.createEvent = function (type, props) {
            if (!isStr(type)) {
                props = type;
                type = props.type;
            }
            var event = document.createEvent(rgxMouseEvents.test(type) ? 'MouseEvents' : 'Events'),
                bubbles = true,
                cancelable = true;

            if (props) {
                for (var key in props) {
                    if (key === 'bubbles') {
                        bubbles = !!props.bubbles;
                    } else if (key === 'cancelable') {
                        cancelable = !!props.cancelable;
                    } else if (key !== 'type') {
                        event[key] = props[key];
                    }
                }
            }
            event.initEvent(type, bubbles, cancelable);
            return event;
        };

        Composr.dom.trigger = function (el, event, args) {
            event = (isStr(event) || isPlainObject(event)) ? Composr.dom.createEvent(event) : event;
            event._args = args;

            // handle focus(), blur() by calling them directly
            if ((event.type in focus) && (typeof el[event.type] === 'function')) {
                return el[event.type]();
            } else {
                return el.dispatchEvent(event)
            }
        };
    }());
    // Gets the 'initial' value for an element type's CSS property (only 'display' supported as of now)
    var _initial = {};
    Composr.dom.initial = function (el, property) {
        var doc = el.ownerDocument,
            tag = el.localName;

        _initial[tag] || (_initial[tag] = {});

        if (_initial[tag][property] === undefined) {
            if (property === 'display') {
                var tmp, display;

                tmp = doc.body.appendChild(doc.createElement(tag));
                display = Composr.dom.css(tmp, 'display');
                tmp.parentNode.removeChild(tmp);
                if (display === 'none') {
                    display = 'block';
                }

                _initial[tag][property] = display;
            }
        }

        return _initial[tag][property];
    };

    var rgxCssNumericProps = /^column-count|columns|font-weight|line-height|opacity|z-index|zoom$/;
    function maybeAddPx(name, value) {
        return ((typeof value === 'number') && !rgxCssNumericProps.test(name)) ? (value + 'px') : value;
    }
    Composr.dom.css = function (element, property, value) {
        var key;
        if (arguments.length < 3) {
            if (typeof property === 'string') {
                return element.style[camelize(property)] || getComputedStyle(element, '').getPropertyValue(property);
            } else if (isArray(property)) {
                var props = {};
                var computedStyle = getComputedStyle(element, '');
                property.forEach(function (prop) {
                    props[prop] = (element.style[camelize(prop)] || computedStyle.getPropertyValue(prop));
                });
                return props;
            }
        }

        var css = '';
        if (typeof property === 'string') {
            if (!value && (value !== 0)) {
                element.style.removeProperty(dasherize(property));
            } else {
                css = dasherize(property) + ':' + maybeAddPx(property, value);
            }
        } else {
            for (key in property) {
                if (!property[key] && (property[key] !== 0)) {
                    element.style.removeProperty(dasherize(key));
                } else {
                    css += dasherize(key) + ':' + maybeAddPx(key, property[key]) + ';';
                }
            }
        }

        element.style.cssText += ';' + css;
    };

    Composr.dom.keyPressed = function (keyboardEvent, checkKey) {
        var key = keyboardEvent.key, type;

        if (arguments.length === 2) {
            // Key(s) to check against passed
            type = clazz(checkKey);

            if (type === 'String') {
                return key === checkKey;
            }

            if (type === 'RegExp') {
                return checkKey.test(key);
            }

            if (isArrayLikeWithEls(checkKey)) {
                return includes(checkKey, key);
            }

            return false;
        }

        return key;
    };

    /* Returns the output character produced by a KeyboardEvent, or empty string if none */
    Composr.dom.keyOutput = function (keyboardEvent, checkOutput) {
        var key = keyboardEvent.key, type;

        if ((typeof key !== 'string') || (key.length !== 1)) {
            key = '';
        }

        if (arguments.length === 2) {
            // Key output(s) to check against passed
            type = clazz(checkOutput);

            if (type === 'String') {
                return key === checkOutput;
            }

            if (type === 'RegExp') {
                return checkOutput.test(key);
            }

            if (isArrayLike(checkOutput, true)) {
                return includes(checkOutput, key);
            }

            return false;
        }

        return key;
    };

    Composr.dom.isActionEvent = function (e) {
        if ((e.type === 'click') && ((e.button === 0) || (e.button === 1))) {  // 0 = Left Click, 1 = Middle Click
            return true;
        }

        if ((e.type === 'keydown') || (e.type === 'keypress')) {
            return Composr.dom.keyPressed(e, ['Enter', 'Space']);
        }

        return false;
    };

    function setAttribute(el, name, value) {
        isset(value) ? el.setAttribute(name) : el.removeAttribute(name, value)
    }

    Composr.dom.attr = function (el, name, value) {
        var key;

        if ((typeof name === 'string') && (arguments.length === 2)) {
            return el.getAttribute(name);
        }

        if (isObj(name)) {
            for (key in name) {
                setAttribute(el, key, name[key]);
            }
        } else {
            setAttribute(el, name, value);
        }
    };

    Composr.dom.removeAttr = function (el, name) {
        name.split(' ').forEach(function (attribute) {
            setAttribute(el, attribute)
        });
    };

    Composr.dom.html = function (el, html) {
        // Parser hint: .innerHTML okay
        var i, len;

        if (arguments.length === 1) {
            return el.innerHTML;
        }
        len = el.children.length;
        if (len !== 0) {
            for (i = 0; i < len; i++) {
                // Detach behaviors from the elements to be deleted
                Composr.detachBehaviors(el.children[i]);
            }
        }

        el.innerHTML = html;

        len = el.children.length;
        if (len === 0) {
            // No new child elements added.
            return;
        }

        for (i = 0; i < len; i++) {
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
    Composr.dom.contentWidth = function (el) {
        var cs = el.ownerDocument.defaultView.getComputedStyle(el),
            padding = parseFloat(cs.paddingLeft) + parseFloat(cs.paddingRight),
            border = parseFloat(cs.borderLeftWidth) + parseFloat(cs.borderRightWidth);

        return el.offsetWidth - padding - border;
    };

    /* Returns the provided element's height excluding padding and border */
    Composr.dom.contentHeight = function (el) {
        var cs = el.ownerDocument.defaultView.getComputedStyle(el),
            padding = parseFloat(cs.paddingTop) + parseFloat(cs.paddingBottom),
            border = parseFloat(cs.borderTopWidth) + parseFloat(cs.borderBottomWidth);

        return el.offsetHeight - padding - border;
    };

    Composr.settings = {};

    /* Addons will add "behaviors" under this object */
    Composr.behaviors = {};

    Composr.attachBehaviors = function (context, settings) {
        var addon, behaviors, name;

        if (!isDocOrEl(context)) {
            throw new Error('Invalid argument type: \'context\' must be of type HTMLDocument or HTMLElement');
        }

        settings = settings || Composr.settings;

        // Execute all of them.
        for (addon in Composr.behaviors) {
            if (Composr.behaviors.hasOwnProperty(addon) && (typeof Composr.behaviors[addon] === 'object')) {
                behaviors = Composr.behaviors[addon];

                for (name in behaviors) {
                    if (behaviors.hasOwnProperty(name) && (typeof behaviors[name] === 'object') && (typeof behaviors[name].attach === 'function')) {
                        //try {
                            behaviors[name].attach(context, settings);
                        //} catch (e) {
                        //    Composr.error('Error while attaching behavior \'' + name + '\' of addon \'' + addon + '\'', e);
                        //}
                    }
                }
            }
        }
    };

    Composr.detachBehaviors = function (context, settings, trigger) {
        var addon, behaviors, name;

        if (!isDocOrEl(context)) {
            throw new Error('Invalid argument type: \'context\' must be of type HTMLDocument or HTMLElement');
        }

        settings = settings || Composr.settings;
        trigger = trigger || 'unload';

        // Execute all of them.
        for (addon in Composr.behaviors) {
            if (Composr.behaviors.hasOwnProperty(addon) && (typeof Composr.behaviors[addon] === 'object')) {
                behaviors = Composr.behaviors[addon];

                for (name in behaviors) {
                    if (behaviors.hasOwnProperty(name) && (typeof behaviors[name] === 'object') && (typeof behaviors[name].detach === 'function')) {
                        try {
                            behaviors[name].detach(context, settings, trigger);
                        } catch (e) {
                            Composr.error('Error while detaching behavior \'' + name + '\' of addon \'' + addon + '\'', e);
                        }
                    }
                }
            }
        }
    };

    /* Addons will add template related methods under this object */
    Composr.templates = {};

    Composr.initializeTemplates = function (context, addonName) {
        addonName = addonName.replace(/_/g, '-');

        Composr.dom.$$$(context, '[data-tpl-' + addonName + ']').forEach(function (el) {
            var tplName = el.dataset[camelCase('tpl-' + addonName)].trim(),
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

                if (!isArray(args)) {
                    args = [args];
                }
            }

            var addonNameCamelCased = camelCase(addonName),
                tplFunc = Composr.templates[addonNameCamelCased] ? Composr.templates[addonNameCamelCased][tplName] : null;

            if (typeof tplFunc === 'function') {
                tplFunc.apply(el, args);
            }
        });
    };

    // Trying an alternate implementation
    Composr.initializeTemplatesAlternate = function (context) {
        Composr.dom.$$$(context, '[data-tpl]').forEach(function (el) {
            var template = el.dataset.tpl,
                args, templateFunction;

            if ((el.localName === 'script') && (el.type === 'application/json')) {
                // Arguments provided inside the <script> tag.
                args = el.textContent.trim();
            } else {
                // Arguments provided in the data-tpl-args attribute.
                args = el.dataset.tplArgs;
            }

            args = Composr.parseDataObject(args);

            templateFunction = Composr.templates[template];
            if (typeof templateFunction === 'function') {
                templateFunction.apply(el, args);
            }
        });
    };

    // If the value of the named `property` is a function then invoke it with the
    // `object` as context; otherwise, return it.
    function result(object, property, fallback) {
        var value = isset(object) ? object[property] : undefined;
        if (value === undefined) {
            value = fallback;
        }
        return isFunc(value) ? value.call(object) : value;
    }

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
        },
        $closest: function (el, selector) {
            return Composr.dom.closest(el, selector, this.el);
        },

        // Remove this view's element from the document and all event listeners
        // attached to it. Exposed for subclasses using an alternative DOM
        // manipulation API.
        _removeElement: function() {
            this.el.parentNode && this.el.parentNode.removeChild(this.el);
        },

        // Change the view's element (`this.el` property) and re-delegate the
        // view's events on the new element.
        setElement: function(element) {
            this.undelegateEvents();
            this._setElement(element);
            this.delegateEvents();
            return this;
        },

        // Creates the `this.el` reference for this view using the
        // given `el`. `el` can be a CSS selector or an HTML element.
        // Subclasses can override this to utilize an
        // alternative DOM manipulation API and are only required to set the `this.el` property.
        _setElement: function(el) {
            this.el = (typeof el === 'string') ? Composr.dom.$(el) : el;
        },

        // Set callbacks, where `this.events` is a hash of
        // *{"event selector": "callback"}*
        // pairs. Callbacks will be bound to the view, with `this` set properly.
        // Uses event delegation for efficiency.
        // Omitting the selector binds the event to `this.el`.

        // Cached regex to split keys for `delegate`.
        _rgxDelegateEventSplitter: /^(\S+)\s*(.*)$/,

        delegateEvents: function(events) {
            var key, method, match;
            events || (events = result(this, 'events'));
            if (!events) {
                return this;
            }
            this.undelegateEvents();
            for (key in events) {
                method = events[key];
                if (!isFunc(method)) {
                    method = this[method];
                }
                if (!method) {
                    continue;
                }
                match = key.match(this._rgxDelegateEventSplitter);
                this.delegate(match[1], match[2], method.bind(this));
            }
            return this;
        },

        // Add a single event listener to the view's element (or a child element using `selector`).
        delegate: function(eventName, selector, listener) {
            Composr.dom.on(this.el, (eventName + '.delegateEvents' + this.cid), selector, listener);
            return this;
        },

        // Clears all callbacks previously bound to the view by `delegateEvents`.
        // You usually don't need to use this, but may wish to if you have multiple
        // views attached to the same DOM element.
        undelegateEvents: function() {
            if (this.el) {
                Composr.dom.off(this.el, '.delegateEvents' + this.cid);
            }
            return this;
        },

        // A finer-grained `undelegateEvents` for removing a single delegated event. `selector` and `listener` are both optional.
        undelegate: function(eventName, selector, listener) {
            Composr.dom.off(this.el, (eventName + '.delegateEvents' + this.cid), selector, listener);
            return this;
        },

        // Produces a DOM element to be assigned to your view. Exposed for
        // subclasses using an alternative DOM manipulation API.
        _createElement: function(tagName) {
            return document.createElement(tagName);
        },

        _ensureElement: function() {
            var attrs;
            if (!this.el) {
                attrs = extend({}, result(this, 'attributes'));
                if (this.id) {
                    attrs.id = result(this, 'id');
                }
                if (this.className) {
                    attrs.class = result(this, 'className');
                }
                this.setElement(this._createElement(result(this, 'tagName')));
                this._setAttributes(attrs);
            } else {
                this.setElement(result(this, 'el'));
            }
        },

        // Set attributes from a hash on this view's element.  Exposed for
        // subclasses using an alternative DOM manipulation API.
        _setAttributes: function(attributes) {
            Composr.dom.attr(this.el, attributes);
        }
    });

    /* Addons will add Composr.View subclasses under this object */
    Composr.views = {};

    Composr.initializeViews = function (context, addonName) {
        var addonNameKibab = addonName.replace(/_/g, '-'),
            addonNameCamelCase = camelCase(addonName);

        Composr.dom.$$$(context, '[data-view-' + addonNameKibab + ']').forEach(function (el) {
            var viewClasses = Composr.views[addonNameCamelCase],
                viewClassName = el.dataset[camelCase('view-' + addonNameKibab)].trim(),
                options = Composr.parseDataObject(el.dataset.viewArgs),
                ViewClass, view;

            if (viewClasses && viewClasses[viewClassName]) {
                ViewClass = viewClasses[viewClassName];

                view = new ViewClass({el: el}, options);
            }
        });
    };

    // Trying an alternate implementation
    Composr.initializeViewsAlternate = function (context) {
        Composr.dom.$$$(context, '[data-view]').forEach(function (el) {
            var ViewClass = Composr.views[el.dataset.view], view,
                options = Composr.parseDataObject(el.dataset.viewArgs),
                id = camelCase(el.id);

            if (typeof ViewClass === 'function') {
                view = new ViewClass({ el: el }, options);

                Composr.views[id || view.cid] = view;
            }
        });
    };

    /* Tempcode filters ported to JS */
    Composr.filter = {};

    // JS port of the cms_url_encode function used by the tempcode filter '&' (UL_ESCAPED)
    Composr.filter.url = (function () {
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

        return function (urlPart, canTryUrlSchemes) {
            var urlPartEncoded = urlencode(urlPart);
            canTryUrlSchemes = (arguments.length > 1) ? !!canTryUrlSchemes : Composr.$EXTRA.canTryUrlSchemes;

            if ((urlPartEncoded !== urlPart) && canTryUrlSchemes) {
                // These interfere with URL Scheme processing because they get pre-decoded and make things ambiguous
                urlPart = urlPart.replace(/\//g, ':slash:').replace(/&/g, ':amp:').replace(/#/g, ':uhash:');
                return urlencode(urlPart);
            }

            return urlPartEncoded;
        };
    }());

    // JS port of the tempcode filter '~' (NL_ESCAPED)
    Composr.filter.crLf = function (str) {
        return str.replace(/[\r\n]/g, '');
    };

    // JS port of the tempcode filter '|' (ID_ESCAPED)
    Composr.filter.id = function (str) {
        var i, char, ascii, remap = {
            '[': '_opensquare_',
            ']': '_closesquare_',
            '\'': '_apostophe_',
            '-': '_minus_',
            ' ': '_space_',
            '+': '_plus_',
            '*': '_star_',
            '/': '__'
        }, out = '';

        str || (str = '');

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

    function loadPolyfills(resolve) {
        var scriptsToLoad = 0,
            scriptsLoaded = 0;

        // Credit for isSymbol, define: https://github.com/inexorabletash/polyfill/blob/master/es6.js
        function isSymbol(s) {
            return (typeof s === 'symbol') || (('Symbol' in window) && (Object.prototype.toString.call(s) === '[object Symbol]'));
        }

        function define(o, p, v, override) {
            var isFunc = typeof v === 'function';

            if ((p in o) && !override && !window.OVERRIDE_NATIVE_FOR_TESTING) {
                return;
            }

            if (isFunc) {
                // Sanity check that functions are appropriately named (where possible)
                console.assert(isSymbol(p) || !('name' in v) || (v.name === p) || (v.name === p + '_'), 'Expected function name "' + p.toString() + '", was "' + v.name + '"');
            }

            Object.defineProperty(o, p, {
                value: v,
                configurable: isFunc,
                enumerable: false,
                writable: isFunc
            });
        }

        // 20.1.2.6 Number.MAX_SAFE_INTEGER
        define(Number, 'MAX_SAFE_INTEGER', 9007199254740991); // 2^53-1

        // 20.1.2.8 Number.MIN_SAFE_INTEGER
        define(Number, 'MIN_SAFE_INTEGER', -9007199254740991); // -2^53+1

        // Credit: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isNaN
        define(Number, 'isNaN', function (value) {
            return value !== value;
        });

        // Credit: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isFinite
        define(Number, 'isFinite', function (value) {
            return (typeof value === 'number') && isFinite(value);
        });

        // Credit: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isInteger
        define(Number, 'isInteger', function (value) {
            return Number.isFinite(value) && (Math.floor(value) === value);
        });

        // Credit: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/String/includes
        define(String.prototype, 'includes', function (search, start) {
            if (typeof start !== 'number') {
                start = 0;
            }

            if (start + search.length > this.length) {
                return false;
            }

            return this.indexOf(search, start) !== -1;
        });

        // Credit: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/String/startsWith
        define(String.prototype, 'startsWith', function (searchString, position) {
            position = position || 0;
            return this.substr(position, searchString.length) === searchString;
        });


        // https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/String/endsWith
        define(String.prototype, 'endsWith', function (searchString, position) {
            var subjectString = this.toString();
            if (typeof position !== 'number' || !isFinite(position) || Math.floor(position) !== position || position > subjectString.length) {
                position = subjectString.length;
            }
            position -= searchString.length;
            var lastIndex = subjectString.lastIndexOf(searchString, position);
            return lastIndex !== -1 && lastIndex === position;
        });

        // Credit: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes
        define(Array.prototype, 'includes', function (searchElement /*, fromIndex*/) {
            var isSearchNaN = Number.isNaN(searchElement); // Needs a special check since NaN !== NaN

            if ((this === null) || (this === undefined)) {
                throw new TypeError('Array.prototype.includes called with invalid context');
            }

            var O = Object(this);
            var len = parseInt(O.length, 10) || 0;
            if (len === 0) {
                return false;
            }
            var n = parseInt(arguments[1], 10) || 0;
            var k;
            if (n >= 0) {
                k = n;
            } else {
                k = len + n;
                if (k < 0) { k = 0; }
            }
            var currentElement;
            while (k < len) {
                currentElement = O[k];
                if ((searchElement === currentElement) || (isSearchNaN && Number.isNaN(currentElement))) {
                    return true;
                }
                k++;
            }
            return false;
        });

        // Add CustomEvent to Internet Explorer
        if (!('CustomEvent' in window)) {
            // Credit: https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent
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
                resolve();
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
            resolve();
        }
    }

}(window.Composr, window.Backbone, JSON.parse(document.getElementById('composr-symbol-data').content)));


/* Ideally this template should not be edited. See the note at the bottom of how JAVASCRIPT_CUSTOM_GLOBALS.tpl is appended to this template */
'use strict';


if (window.fade_transition_timers === undefined) {
    window.fade_transition_timers = {};
}

if (window.unloaded === undefined) {
    window.unloaded = false; // Serves as a flag to indicate any new errors are probably due to us transitioning
}
window.addEventListener('beforeunload', function () {
    window.unloaded = true;
});

/* Screen transition, for staff */
function staff_unload_action() {
    undo_staff_unload_action();

    // If clicking a download link then don't show the animation
    if (document.activeElement && typeof document.activeElement.href !== 'undefined' && document.activeElement.href != null) {
        var url = document.activeElement.href.replace(/.*:\/\/[^\/:]+/, '');
        if (url.includes('download') || url.includes('export')) {
            return;
        }
    }

    // If doing a meta refresh then don't show the animation
    if (document.querySelector('meta[http-equiv="Refresh"]')) {
        return;
    }

    // Show the animation
    var bi = document.getElementById('main_website_inner');
    if (bi) {
        bi.classList.add('site_unloading');
        fade_transition(bi, 20, 30, -4);
    }
    var div = document.createElement('div');
    div.className = 'unload_action';
    div.style.width = '100%';
    div.style.top = (get_window_height() / 2 - 160) + 'px';
    div.style.position = 'fixed';
    div.style.zIndex = 10000;
    div.style.textAlign = 'center';
    Composr.dom.html(div, '<div aria-busy="true" class="loading_box box"><h2>{!LOADING;^}</h2><img id="loading_image" alt="" src="{$IMG_INLINE*;,loading}" /></div>');
    window.setTimeout(function () {
        // Stupid workaround for Google Chrome not loading an image on unload even if in cache
        if (document.getElementById('loading_image')) {
            document.getElementById('loading_image').src += '';
        }
    }, 100);
    document.body.appendChild(div);

    // Allow unloading of the animation
    window.addEventListener('pageshow', undo_staff_unload_action);
    window.addEventListener('keydown', undo_staff_unload_action);
    window.addEventListener('click', undo_staff_unload_action);
}

function undo_staff_unload_action() {
    var pre = document.body.querySelectorAll('.unload_action');
    for (var i = 0; i < pre.length; i++) {
        pre[i].parentNode.removeChild(pre[i]);
    }
    var bi = document.getElementById('main_website_inner');
    if (bi) {
        if (window.fade_transition_timers[bi.fader_key]) {
            window.clearTimeout(window.fade_transition_timers[bi.fader_key]);
            delete window.fade_transition_timers[bi.fader_key];
        }
        bi.classList.remove('site_unloading');
    }
}

function placeholder_focus(el, def) {
    if (def === undefined) {
        def = el.defaultValue;
    }

    if (el.value === def) {
        el.value = '';
    }

    el.classList.remove('field_input_non_filled');
    el.classList.add('field_input_filled');
}

function placeholder_blur(el, def) {
    if (def === undefined) {
        def = el.defaultValue;
    }

    if (el.value === '') {
        el.value = def;
    }

    if (el.value === def) {
        el.classList.remove('field_input_filled');
        el.classList.add('field_input_non_filled');
    }
}

/* Very simple form control flow */
function check_field_for_blankness(field, event) {
    if (!field) return true; // Shame we need this, seems on Google Chrome things can get confused on JS assigned to page-changing events
    if (typeof field.nodeName == 'undefined') return true; // Also bizarre

    var value;
    if (field.localName === 'select') {
        value = field.options[field.selectedIndex].value;
    } else {
        value = field.value;
    }

    var ee = document.getElementById('error_' + field.id);

    if ((value.replace(/\s/g, '') === '') || (value === '****') || (value === '{!POST_WARNING;^}') || (value === '{!THREADED_REPLY_NOTICE;^,{!POST_WARNING}}')) {
        if (event) {
            cancel_bubbling(event);
        }

        if (ee !== null) {
            ee.style.display = 'block';
            Composr.dom.html(ee, '{!REQUIRED_NOT_FILLED_IN;^}');
        }

        window.fauxmodal_alert('{!IMPROPERLY_FILLED_IN;^}');
        return false;
    }

    if (ee !== null) {
        ee.style.display = 'none';
    }

    return true;
}
function disable_button_just_clicked(input, permanent) {
    if (permanent === undefined) {
        permanent = false;
    }

    if (input.localName === 'form') {
        for (var i = 0; i < input.elements.length; i++) {
            if ((input.elements[i].type === 'submit') || (input.elements[i].type === 'button') || (input.elements[i].type === 'image') || (input.elements[i].localName === 'button')) {
                disable_button_just_clicked(input.elements[i]);
            }
        }
        return;
    }

    if (input.form.target == '_blank') return;

    window.setTimeout(function () {
        input.disabled = true;
        input.under_timer = true;
    }, 20);
    input.style.cursor = 'wait';
    if (!permanent) {
        var goback = function () {
            if (input.under_timer) {
                input.disabled = false;
                input.under_timer = false;
                input.style.cursor = 'default';
            }
        };
        window.setTimeout(goback, 5000);
    } else input.under_timer = false;

    window.addEventListener('pagehide', goback);
}

/* Making the height of a textarea match its contents */
function manage_scroll_height(ob) {
    var height = ob.scrollHeight;
    if ((height > 5) && (sts(ob.style.height) < height) && (ob.offsetHeight < height)) {
        ob.style.height = height + 'px';
        ob.style.boxSizing = 'border-box';
        ob.style.overflowY = 'hidden';
        trigger_resize();
    }
}

/* Ask a user a question: they must click a button */
// 'Cancel' should come as index 0 and Ok/default-option should come as index 1. This is so that the fallback works right.
function generate_question_ui(message, button_set, window_title, fallback_message, callback, dialog_width, dialog_height) {
    var image_set = [];
    var new_button_set = [];
    for (var s in button_set) {
        new_button_set.push(button_set[s]);
        image_set.push(s);
    }
    button_set = new_button_set;

    if ((typeof window.showModalDialog != 'undefined')/*{+START,IF,{$CONFIG_OPTION,js_overlays}}*/ || true/*{+END}*/) {
        if (button_set.length > 4) dialog_height += 5 * (button_set.length - 4);

        // Intentionally FIND_SCRIPT and not FIND_SCRIPT_NOHTTP, because no needs-HTTPS security restriction applies to popups, yet popups do not know if they run on HTTPS if behind a transparent reverse proxy
        var url = maintain_theme_in_link('{$FIND_SCRIPT;,question_ui}?message=' + encodeURIComponent(message) + '&image_set=' + encodeURIComponent(image_set.join(',')) + '&button_set=' + encodeURIComponent(button_set.join(',')) + '&window_title=' + encodeURIComponent(window_title) + keep_stub());
        if (typeof dialog_width == 'undefined') dialog_width = 440;
        if (typeof dialog_height == 'undefined') dialog_height = 180;
        window.faux_showModalDialog(
            url,
            null,
            'dialogWidth=' + dialog_width + ';dialogHeight=' + dialog_height + ';status=no;unadorned=yes',
            function (result) {
                if ((typeof result == 'undefined') || (result === null)) {
                    callback(button_set[0]); // just pressed 'cancel', so assume option 0
                } else {
                    callback(result);
                }
            }
        );

        return;
    }

    if (button_set.length == 1) {
        window.fauxmodal_alert(
            fallback_message ? fallback_message : message,
            function () {
                callback(button_set[0]);
            },
            window_title
        );
    } else if (button_set.length == 2) {
        window.fauxmodal_confirm(
            fallback_message ? fallback_message : message,
            function (result) {
                callback(result ? button_set[1] : button_set[0]);
            },
            window_title
        );
    } else {
        if (!fallback_message) {
            message += '\n\n{!INPUTSYSTEM_TYPE_EITHER;^}';
            for (var i = 0; i < button_set.length; i++) {
                message += button_set[i] + ',';
            }
            message = message.substr(0, message.length - 1);
        } else message = fallback_message;

        window.fauxmodal_prompt(
            message,
            '',
            function (result) {
                if ((typeof result == 'undefined') || (result === null)) {
                    callback(button_set[0]); // just pressed 'cancel', so assume option 0
                    return;
                } else {
                    if (result == '') {
                        callback(button_set[1]); // just pressed 'ok', so assume option 1
                        return;
                    }
                    for (var i = 0; i < button_set.length; i++) {
                        if (result.toLowerCase() == button_set[i].toLowerCase()) // match
                        {
                            callback(result);
                            return;
                        }
                    }
                }

                // unknown
                callback(button_set[0]);
            },
            window_title
        );
    }
}

/* Find the main Composr window */
function get_main_cms_window(any_large_ok) {
    if (any_large_ok === undefined) {
        any_large_ok = false;
    }

    if (Composr.dom.id('main_website')) {
        return window;
    }

    if (any_large_ok && (get_window_width() > 300)) {
        return window;
    }

    try {
        if (window.parent && (window.parent !== window) && (window.parent.get_main_cms_window !== undefined)) {
            return window.parent.get_main_cms_window();
        }
    } catch (ignore) {}

    try {
        if (window.opener && (window.opener.get_main_cms_window !== undefined)) {
            return window.opener.get_main_cms_window();
        }
    } catch (ignore) {}

    return window;
}


/* Find the size of a dimensions in pixels without the px (not general purpose, just to simplify code) */
function sts(src) {
    if (!src) return 0;
    if (src.indexOf('px') == -1) return 0;
    return window.parseInt(src.replace('px', ''));
}

/* Find if the user performed the Composr "magic keypress" to initiate some action */
function capture_click_key_states(event) {
    window.capture_event = event;
}
function magic_keypress(event) {
    // Cmd+Shift works on Mac - cannot hold down control or alt in Mac firefox at least
    if (window.capture_event !== undefined) event = window.capture_event;
    var count = 0;
    if (event.shiftKey) count++;
    if (event.ctrlKey) count++;
    if (event.metaKey) count++;
    if (event.altKey) count++;

    return (count >= 2);
}

/* Data escaping */
function escape_html(value) {
    if (!value) return '';
    return value.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(new RegExp('<', 'g')/* For CDATA embedding else causes weird error */, '&lt;').replace(/>/g, '&gt;');
}
function escape_comcode(value) {
    return value.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
}

/* Image rollover effects */
function create_rollover(rand, rollover) {
    var img = document.getElementById(rand);
    if (!img) return;
    new Image().src = rollover; // precache
    var activate = function () {
        img.old_src = img.getAttribute('src');
        if (typeof img.origsrc != 'undefined') img.old_src = img.origsrc;
        img.setAttribute('src', rollover);
    };
    var deactivate = function () {
        img.setAttribute('src', img.old_src);
    };
    img.addEventListener('mouseover', activate);
    img.addEventListener('click', deactivate);
    img.addEventListener('mouseout', deactivate);
}

var _doneCookieAlert = false;
/* Cookies */
function set_cookie(cookie_name, cookie_value, num_days) {
    var today = new Date(),
        expire = new Date(),
        extra = '', to_set;

    if (num_days || num_days == 0) {
        num_days = 1;
    }

    expire.setTime(today.getTime() + 3600000 * 24 * num_days);

    if (Composr.$COOKIE_PATH !== '') {
        extra += ';path=' + Composr.$COOKIE_PATH;
    }

    if (Composr.$COOKIE_DOMAIN !== '') {
        extra += ';domain=' + Composr.$COOKIE_DOMAIN;
    }

    to_set = cookie_name + '=' + encodeURIComponent(cookie_value) + ';expires=' + expire.toUTCString() + extra;

    document.cookie = to_set;

    var read = read_cookie(cookie_name);
    if (read && (read !== cookie_value)) {
        if (Composr.isDevMode && !_doneCookieAlert) {
            window.fauxmodal_alert('{!COOKIE_CONFLICT_DELETE_COOKIES;^}' + '... ' + document.cookie + ' (' + to_set + ')', null, '{!ERROR_OCCURRED;^}');
        }

        _doneCookieAlert = true;
    }
}

function read_cookie(cookie_name, defaultValue) {
    var theCookie = '' + document.cookie;
    var ind = theCookie.indexOf(' ' + cookie_name + '=');

    if ((ind === -1) && (theCookie.substr(0, cookie_name.length + 1) === cookie_name + '=')) {
        ind = 0;
    } else if (ind !== -1) {
        ind++;
    }

    if (ind === -1 || cookie_name == '') {
        return defaultValue;
    }

    var ind1 = theCookie.indexOf(';', ind);
    if (ind1 === -1) {
        ind1 = theCookie.length;
    }

    return window.decodeURIComponent(theCookie.substring(ind + cookie_name.length + 1, ind1));
}



/* Browser sniffing */
function browser_matches(code) {
    var browser = navigator.userAgent.toLowerCase();
    var os = navigator.platform.toLowerCase() + ' ' + browser;

    var is_safari = browser.includes('applewebkit');
    var is_chrome = browser.includes('chrome/');
    var is_gecko = browser.includes('gecko') && !is_safari;
    var _is_ie = browser.includes('msie') || browser.includes('trident');
    var is_ie_8 = browser.includes('msie 8') && (_is_ie);
    var is_ie_8_plus = is_ie_8;
    var is_ie_9 = browser.includes('msie 9') && (_is_ie);
    var is_ie_9_plus = is_ie_9 && !is_ie_8;

    switch (code) {
        case 'non_concurrent':
            return browser.includes('iphone') || browser.includes('ipad') || browser.includes('android') || browser.includes('phone') || browser.includes('tablet');
        case 'ios':
            return browser.includes('iphone') || browser.includes('ipad');
        case 'android':
            return browser.includes('android');
        case 'wysiwyg':
            return Composr.is(Composr.$CONFIG_OPTION.wysiwyg);
        case 'windows':
            return os.includes('windows') || os.includes('win32');
        case 'mac':
            return os.includes('mac');
        case 'linux':
            return os.includes('linux');
        case 'ie':
            return _is_ie;
        case 'ie8':
            return is_ie_8;
        case 'ie8+':
            return is_ie_8_plus;
        case 'ie9':
            return is_ie_9;
        case 'ie9+':
            return is_ie_9_plus;
        case 'chrome':
            return is_chrome;
        case 'gecko':
            return is_gecko;
        case 'safari':
            return is_safari;
    }

    // Should never get here
    return false;
}

/* Safe way to get the base URL */
function get_base_url() {
    return (window.location + '').replace(/(^.*:\/\/[^\/]*)\/.*/, '$1') + '{$BASE_URL_NOHTTP;}'.replace(/^.*:\/\/[^\/]*/, '');
}

/* Enforcing a session using AJAX */
function confirm_session(callback) {
    if (typeof window.do_ajax_request == 'undefined') return;

    var url = '{$FIND_SCRIPT_NOHTTP;,confirm_session}' + keep_stub(true);

    // First see if session already established
    require_javascript('ajax', window.do_ajax_request);
    if (typeof window.do_ajax_request == 'undefined') return;
    var ret = do_ajax_request(url + keep_stub(true), function (ret) {
        if (!ret) return;

        if (ret.responseText === '') // Blank means success, no error - so we can call callback
        {
            callback(true);
            return;
        }

        // But non blank tells us the username, and there is an implication that no session is confirmed for this login

        if (ret.responseText == '{!GUEST;}') // Hmm, actually whole login was lost, so we need to ask for username too
        {
            window.fauxmodal_prompt(
                '{!USERNAME;^}',
                '',
                function (promptt) {
                    _confirm_session(callback, promptt, url);
                },
                '{!_LOGIN;}'
            );
            return;
        }

        _confirm_session(callback, ret.responseText, url);
    });
}
function _confirm_session(callback, username, url) {
    window.fauxmodal_prompt(
        '{$?,{$NOT,{$CONFIG_OPTION,js_overlays}},{!ENTER_PASSWORD_JS;^},{!ENTER_PASSWORD_JS_2;^}}',
        '',
        function (promptt) {
            if (promptt !== null) {
                do_ajax_request(url, function (ret) {
                    if (ret && ret.responseText === '') // Blank means success, no error - so we can call callback
                        callback(true);
                    else
                        _confirm_session(callback, username, url); // Recurse
                }, 'login_username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(promptt));
            } else callback(false);
        },
        '{!_LOGIN;}',
        'password'
    );
}

/* Dynamic inclusion */
function load_snippet(snippet_hook, post, callback) {
    var title = Composr.dom.html(document.getElementsByTagName('title')[0]);
    title = title.replace(/ \u2013 .*/, '');
    var metas = document.getElementsByTagName('link');
    var i;
    if (!window.location) return null; // In middle of page navigation away
    var url = window.location.href;
    for (i = 0; i < metas.length; i++) {
        if (metas[i].getAttribute('rel') == 'canonical') url = metas[i].getAttribute('href');
    }
    if (!url) url = window.location.href;
    var html;
    if (typeof window.do_ajax_request != 'undefined') {
        var url2 = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=' + snippet_hook + '&url=' + encodeURIComponent(url) + '&title=' + encodeURIComponent(title) + keep_stub();
        html = do_ajax_request(maintain_theme_in_link(url2), callback, post);
    }
    if (callback) return null;
    return html.responseText;
}
function require_css(sheet) {
    if (document.getElementById('loading_css_' + sheet)) {
        return;
    }
    var link = document.createElement('link');
    link.setAttribute('id', 'loading_css_' + sheet);
    link.setAttribute('rel', 'stylesheet');
    link.setAttribute('href', '{$FIND_SCRIPT_NOHTTP;,sheet}?sheet=' + sheet + keep_stub());
    document.head.appendChild(link);
}
function require_javascript(script, detector) {
    // Check it is not already loading
    if (document.getElementById('loading_js_' + script)) {
        return;
    }

    // Check it is already loaded
    if (detector !== undefined) {
        // Some object reference into the file passed in was defined, so the file must have been loaded already
        return;
    }

    // Load it
    var s = document.createElement('script');
    s.id = 'loading_js_' + script;
    s.src = '{$FIND_SCRIPT_NOHTTP;,javascript}?script=' + script + keep_stub();
    document.head.appendChild(s);
}

/* Tabs */
function find_url_tab(hash) {
    if (typeof hash == 'undefined') hash = window.location.hash;

    if (hash.replace(/^#/, '') != '') {
        var tab = hash.replace(/^#/, '').replace(/^tab\_\_/, '');

        if (document.getElementById('g_' + tab)) {
            select_tab('g', tab);
        }
        else if ((tab.indexOf('__') != -1) && (document.getElementById('g_' + tab.substr(0, tab.indexOf('__'))))) {
            var old = hash;
            select_tab('g', tab.substr(0, tab.indexOf('__')));
            window.location.hash = old;
        }
    }
}
function select_tab(id, tab, from_url, automated) {
    if (from_url === undefined) {
        from_url = false;
    }

    if (automated === undefined) {
        automated = false;
    }

    if (!from_url) {
        var tab_marker = document.getElementById('tab__' + tab.toLowerCase());
        if (tab_marker) {
            // For URL purposes, we will change URL to point to tab
            // HOWEVER, we do not want to cause a scroll so we will be careful
            tab_marker.id = '';
            window.location.hash = '#tab__' + tab.toLowerCase();
            tab_marker.id = 'tab__' + tab.toLowerCase();
        }
    }

    var tabs = [];
    var i, element;
    element = document.getElementById('t_' + tab);
    for (i = 0; i < element.parentNode.children.length; i++) {
        if (element.parentNode.children[i].id && (element.parentNode.children[i].id.substr(0, 2) === 't_')) {
            tabs.push(element.parentNode.children[i].id.substr(2));
        }
    }

    for (i = 0; i < tabs.length; i++) {
        element = document.getElementById(id + '_' + tabs[i]);
        if (element) {
            element.style.display = (tabs[i] === tab) ? 'block' : 'none';

            if (tabs[i] === tab) {
                if (window['load_tab__' + tab] === undefined) {
                    clear_transition_and_set_opacity(element, 0.0);
                    fade_transition(element, 100, 30, 8);
                }
            }
        }

        element = document.getElementById('t_' + tabs[i]);
        if (element) {
            element.classList.toggle('tab_active', tabs[i] === tab);
        }
    }

    if (window['load_tab__' + tab] !== undefined) {
        // Usually an AJAX loader
        window['load_tab__' + tab](automated, document.getElementById(id + '_' + tab));
    }

    return false;
}

/* Hiding/Showing of collapsed sections */
function set_display_with_aria(el, display) {
    el.style.display = display;
    el.setAttribute('aria-hidden', (display === 'none') ? 'true' : 'false');
}

function matches_theme_image(src, url) {
    return Composr.url(src) === Composr.url(url);
}

function set_tray_theme_image(pic, before_theme_img, after_theme_img, before1_url, after1_url, after1_url_2x, after2_url, after2_url_2x) {
    var is_1 = matches_theme_image(pic.src, before1_url);

    if (is_1) {
        if (pic.src.indexOf('themewizard.php') != -1) {
            pic.src = pic.src.replace(before_theme_img, after_theme_img);
        } else {
            pic.src = Composr.url(after1_url);
        }
    } else {
        if (pic.src.indexOf('themewizard.php') != -1) {
            pic.src = pic.src.replace(before_theme_img + '2', after_theme_img + '2');
        } else {
            pic.src = Composr.url(after2_url);
        }
    }

    if (typeof pic.srcset != 'undefined') {
        if (is_1) {
            if (pic.srcset.indexOf('themewizard.php') != -1) {
                pic.srcset = pic.srcset.replace(before_theme_img, after_theme_img);
            } else {
                pic.srcset = Composr.url(after1_url_2x);
            }
        } else {
            if (pic.srcset.indexOf('themewizard.php') != -1) {
                pic.srcset = pic.srcset.replace(before_theme_img + '2', after_theme_img + '2');
            } else {
                pic.srcset = Composr.url(after2_url_2x);
            }
        }
    }
}
function toggleable_tray(element, no_animate, cookie_id_name) {
    if (typeof element === 'string') {
        element = document.getElementById(element);
    }

    if (!element) {
        return;
    }

    if (Composr.not(Composr.$CONFIG_OPTION.enableAnimations)) {
        no_animate = true;
    }

    if (!element.classList.contains('toggleable_tray')) {// Suspicious, maybe we need to probe deeper
        element = Composr.dom.$(element, '.toggleable_tray') || element;
    }

    if (element.dataset.trayCookie !== undefined) {
        cookie_id_name = element.dataset.trayCookie;
    }

    if (cookie_id_name !== undefined) {
        set_cookie('tray_' + cookie_id_name, (element.style.display == 'none') ? 'open' : 'closed');
    }

    var type = 'block';
    if (element.localName === 'table') {
        type = 'table';
    } else if (element.localName === 'tr') {
        type = 'table-row';
    }

    var pic = Composr.dom.$(element.parentNode, '.toggleable_tray_button img') || Composr.dom.$('#e_' + element.id);
    if (pic && (matches_theme_image(pic.src, '{$IMG;,1x/trays/expcon}') || matches_theme_image(pic.src, '{$IMG;,1x/trays/expcon2}'))) {// Currently in action?
        return;
    }

    element.setAttribute('aria-expanded', (type === 'none') ? 'false' : 'true');

    if (element.style.display === 'none') {
        element.style.display = type;
        if ((type === 'block') && (element.localName === 'div') && (!no_animate) && ((!pic) || (pic.src.indexOf('themewizard.php') == -1))) {
            element.style.visibility = 'hidden';
            element.style.width = element.offsetWidth + 'px';
            element.style.position = 'absolute'; // So things do not just around now it is visible
            if (pic) {
                set_tray_theme_image(pic, 'expand', 'expcon', '{$IMG;,1x/trays/expand}', '{$IMG;,1x/trays/expcon}', '{$IMG;,2x/trays/expcon}', '{$IMG;,1x/trays/expcon2}', '{$IMG;,2x/trays/expcon2}');
            }
            window.setTimeout(function () {
                begin_toggleable_tray_animation(element, 20, 70, -1, pic);
            }, 20);
        } else {
            clear_transition_and_set_opacity(element, 0.0);
            fade_transition(element, 100, 30, 4);

            if (pic) {
                set_tray_theme_image(pic, 'expand', 'contract', '{$IMG;,1x/trays/expand}', '{$IMG;,1x/trays/contract}', '{$IMG;,2x/trays/contract}', '{$IMG;,1x/trays/contract2}', '{$IMG;,2x/trays/contract2}');
            }
        }
    } else {
        if ((type === 'block') && (element.localName === 'div') && (!no_animate) && ((!pic) || (pic.src.indexOf('themewizard.php') == -1))) {
            if (pic) {
                set_tray_theme_image(pic, 'contract', 'expcon', '{$IMG;,1x/trays/contract}', '{$IMG;,1x/trays/expcon}', '{$IMG;,2x/trays/expcon}', '{$IMG;,1x/trays/expcon2}', '{$IMG;,2x/trays/expcon2}');
            }
            window.setTimeout(function () {
                begin_toggleable_tray_animation(element, -20, 70, 0, pic);
            }, 20);
        } else {
            if (pic) {
                set_tray_theme_image(pic, 'contract', 'expand', '{$IMG;,1x/trays/contract}', '{$IMG;,1x/trays/expand}', '{$IMG;,2x/trays/expand}', '{$IMG;,1x/trays/expand2}', '{$IMG;,2x/trays/expand2}');
                pic.setAttribute('alt', pic.getAttribute('alt').replace('{!CONTRACT;}', '{!EXPAND;}'));
                pic.title = '{!EXPAND;}'; // Needs doing because convert_tooltip may not have run yet
                pic.cms_tooltip_title = '{!EXPAND;}';
            }
            element.style.display = 'none';
        }
    }

    trigger_resize(true);

    return false;
}
function begin_toggleable_tray_animation(element, animate_dif, animate_ticks, final_height, pic) {
    var full_height = Composr.dom.contentHeight(element);
    if (final_height == -1) // We are animating to full height - not a fixed height
    {
        final_height = full_height;
        element.style.height = '0px';
        element.style.visibility = 'visible';
        element.style.position = 'static';
    }
    if (full_height > 300) // Quick finish in the case of huge expand areas
    {
        toggleable_tray_done(element, final_height, animate_dif, 'hidden', animate_ticks, pic);
        return;
    }
    element.style.outline = '1px dashed gray';

    if (final_height == 0) {
        clear_transition_and_set_opacity(element, 1.0);
        fade_transition(element, 0, 30, 4);
    } else {
        clear_transition_and_set_opacity(element, 0.0);
        fade_transition(element, 100, 30, 4);
    }

    var orig_overflow = element.style.overflow;
    element.style.overflow = 'hidden';
    window.setTimeout(function () {
        toggleable_tray_animate(element, final_height, animate_dif, orig_overflow, animate_ticks, pic);
    }, animate_ticks);
}
function toggleable_tray_animate(element, final_height, animate_dif, orig_overflow, animate_ticks, pic) {
    var current_height = ((element.style.height == 'auto') || (element.style.height == '')) ? element.offsetHeight : sts(element.style.height);
    if (((current_height > final_height) && (animate_dif < 0)) || ((current_height < final_height) && (animate_dif > 0))) {
        var num = Math.max(current_height + animate_dif, 0);
        if (animate_dif > 0) num = Math.min(num, final_height);
        element.style.height = num + 'px';
        window.setTimeout(function () {
            toggleable_tray_animate(element, final_height, animate_dif, orig_overflow, animate_ticks, pic);
        }, animate_ticks);
    } else {
        toggleable_tray_done(element, final_height, animate_dif, orig_overflow, animate_ticks, pic);
    }
}
function toggleable_tray_done(element, final_height, animate_dif, orig_overflow, animate_ticks, pic) {
    element.style.height = 'auto';
    if (animate_dif < 0) {
        element.style.display = 'none';
    }
    element.style.overflow = orig_overflow;
    element.style.outline = '0';
    if (pic) {
        if (animate_dif < 0) {
            set_tray_theme_image(pic, 'expcon', 'expand', '{$IMG;,1x/trays/expcon}', '{$IMG;,1x/trays/expand}', '{$IMG;,2x/trays/expand}', '{$IMG;,1x/trays/expand2}', '{$IMG;,2x/trays/expand2}');
        } else {
            set_tray_theme_image(pic, 'expcon', 'contract', '{$IMG;,1x/trays/expcon}', '{$IMG;,1x/trays/contract}', '{$IMG;,2x/trays/contract}', '{$IMG;,1x/trays/contract2}', '{$IMG;,2x/trays/contract2}');
        }
        pic.setAttribute('alt', pic.getAttribute('alt').replace((animate_dif < 0) ? '{!CONTRACT;}' : '{!EXPAND;}', (animate_dif < 0) ? '{!EXPAND;}' : '{!CONTRACT;}'));
        pic.cms_tooltip_title = (animate_dif < 0) ? '{!EXPAND;}' : '{!CONTRACT;}';
    }
    trigger_resize(true);
}


/* Animate the loading of a frame */
function animate_frame_load(pf, frame, leave_gap_top, leave_height) {
    if (!pf) return;
    if (leave_gap_top === undefined) leave_gap_top = 0;
    if (leave_height === undefined) leave_height = false;

    if (!leave_height){
        // Enough to stop jumping around
        pf.style.height = window.top.get_window_height() + 'px';
    }

    illustrate_frame_load(frame);

    var ifuob = window.top.document.getElementById('iframe_under');
    var extra = ifuob ? ((window != window.top) ? find_pos_y(ifuob) : 0) : 0;
    if (ifuob) {
        ifuob.scrolling = 'no';
    }

    if (window === window.top) {
        window.top.smooth_scroll(find_pos_y(pf) + extra - leave_gap_top);
    }
}

function illustrate_frame_load(iframeId) {
    var head, cssText = '', i, iframe = document.getElementById(iframeId), doc, de;

    if (Composr.not(Composr.$CONFIG_OPTION.enableAnimations) || !iframe || !iframe.contentDocument || !iframe.contentDocument.documentElement) {
        return;
    }

    doc = iframe.contentDocument;
    de = doc.documentElement;

    head = '<style>';

    for (i = 0; i < document.styleSheets.length; i++) {
        try {
            var stylesheet = document.styleSheets[i];
            if (stylesheet.href && !stylesheet.href.includes('/global') && !stylesheet.href.includes('/merged')) {
                continue;
            }

            if (stylesheet.cssText !== undefined) {
                cssText += stylesheet.cssText;
            } else {
                var rules = [];
                try {
                    rules = stylesheet.cssRules ? stylesheet.cssRules : stylesheet.rules;
                } catch (ignore) {
                }

                if (rules) {
                    for (var j = 0; j < rules.length; j++) {
                        if (rules[j].cssText){
                            cssText += rules[j].cssText + '\n\n';
                        } else {
                            cssText += rules[j].selectorText + '{ ' + rules[j].style.cssText + '}\n\n';
                        }
                    }
                }
            }
        } catch (ignore) {
        }
    }

    head += cssText + '<\/style>';

    doc.body.classList.add('website_body');
    doc.body.classList.add('main_website_faux');

    if (de.getElementsByTagName('style').length == 0) {// The conditional is needed for Firefox - for some odd reason it is unable to parse any head tags twice
        Composr.dom.html(doc.head, head);
    }

    Composr.dom.html(doc.body, '<div aria-busy="true" class="spaced"><div class="ajax_loading"><img id="loading_image" class="vertical_alignment" src="' + Composr.url('{$IMG_INLINE*;,loading}') + '" alt="{!LOADING;^}" /> <span class="vertical_alignment">{!LOADING;^}<\/span><\/div><\/div>');

    // Stupid workaround for Google Chrome not loading an image on unload even if in cache
    window.setTimeout(function () {
        if (!doc.getElementById('loading_image')) {
            return;
        }

        var i_new = doc.createElement('img');
        i_new.src = doc.getElementById('loading_image').src;

        var i_default = doc.getElementById('loading_image');
        if (i_default) {
            i_new.className = i_default.className;
            i_new.alt = i_default.alt;
            i_new.id = i_default.id;
            i_default.parentNode.replaceChild(i_new, i_default);
        }
    }, 0);
}

/* Smoothly scroll to another position on the page */
function smooth_scroll(dest_y, expected_scroll_y, dir, event_after) {
    if (Composr.not(Composr.$CONFIG_OPTION.enableAnimations)) {
        try {
            window.scrollTo(0, dest_y);
        } catch (e) {
        }
        return;
    }

    var scroll_y = window.pageYOffset;
    if (typeof dest_y == 'string') dest_y = find_pos_y(document.getElementById(dest_y), true);
    if (dest_y < 0) dest_y = 0;
    if ((typeof expected_scroll_y != 'undefined') && (expected_scroll_y != null) && (expected_scroll_y != scroll_y)) return; // We must terminate, as the user has scrolled during our animation and we do not want to interfere with their action -- or because our last scroll failed, due to us being on the last scroll screen already
    if (typeof dir == 'undefined' || !null) var dir = (dest_y > scroll_y) ? 1 : -1;

    var distance_to_go = (dest_y - scroll_y) * dir;
    var dist = Math.round(dir * (distance_to_go / 25));
    if (dir == -1 && dist > -25) dist = -25;
    if (dir == 1 && dist < 25) dist = 25;

    if (((dir == 1) && (scroll_y + dist >= dest_y)) || ((dir == -1) && (scroll_y + dist <= dest_y)) || (distance_to_go > 2000)) {
        try {
            window.scrollTo(0, dest_y);
        }
        catch (e) {
        }
        if (event_after) event_after();
        return;
    }

    try {
        window.scrollBy(0, dist);
    } catch (e) {
        return; // May be stopped by popup blocker
    }

    window.setTimeout(function () {
        smooth_scroll(dest_y, scroll_y + dist, dir, event_after);
    }, 30);
}

/* Helper to change class on checkbox check */
function change_class(box, theId, to, from) {
    var cell = document.getElementById(theId);
    if (!cell) cell = theId;
    cell.className = (box.checked) ? to : from;
}

/* Dimension functions */
function register_mouse_listener(e) {
    if (!window.mouse_listener_enabled) {
        window.mouse_listener_enabled = true;
        document.body.addEventListener('mousemove', get_mouse_xy);
        if (typeof e != 'undefined') get_mouse_xy(e);
    }
}
function get_mouse_xy(e, win) {
    if (typeof win == 'undefined') win = window;
    win.mouse_x = get_mouse_x(e, win);
    win.mouse_y = get_mouse_y(e, win);
    win.ctrl_pressed = e.ctrlKey;
    win.alt_pressed = e.altKey;
    win.meta_pressed = e.metaKey;
    win.shift_pressed = e.shiftKey;
    return true
}
function get_mouse_x(event, win) // Usually use window.mouse_x after calling register_mouse_listener(), it's more accurate on Firefox
{
    if (typeof win == 'undefined') win = window;
    try {
        if ((typeof event.pageX != 'undefined') && (event.pageX)) {
            return event.pageX;
        } else if ((typeof event.clientX != 'undefined') && (event.clientX)) {
            return event.clientX + win.pageXOffset
        }
    }
    catch (err) {
    }
    return 0;
}
function get_mouse_y(event, win) // Usually use window.mouse_y after calling register_mouse_listener(), it's more accurate on Firefox
{
    if (typeof win == 'undefined') win = window;
    try {
        if ((typeof event.pageY != 'undefined') && (event.pageY)) {
            return event.pageY;
        } else if ((typeof event.clientY != 'undefined') && (event.clientY)) {
            return event.clientY + win.pageYOffset
        }
    }
    catch (err) {
    }
    return 0;
}
function get_window_width(win) {
    if ( win === undefined) {
        win = window;
    }
    if (win.innerWidth !== undefined) {
        return win.innerWidth - 18;
    }

    if ((win.document.documentElement) && (win.document.documentElement.clientWidth)) {
        return win.document.documentElement.clientWidth;
    }

    if ((win.document.body) && (win.document.body.clientWidth)) {
        return win.document.body.clientWidth;
    }

    return 0;
}
function get_window_height(win) {
    if ( win === undefined) {
        win = window;
    }

    if (win.innerHeight !== undefined) {
        return win.innerHeight - 18;
    }
    if ((win.document.documentElement) && (win.document.documentElement.clientHeight)) {
        return win.document.documentElement.clientHeight;
    }
    if ((win.document.body) && (win.document.body.clientHeight)) {
        return win.document.body.clientHeight;
    }

    return 0;
}

function get_window_scroll_width(win) {
    if ( win === undefined) {
        win = window;
    }
    return win.document.body.scrollWidth;
}

function get_window_scroll_height(win) {
    if ( win === undefined) {
        win = window;
    }
    var rect_a = win.document.body.parentNode.getBoundingClientRect();
    var a = rect_a.bottom - rect_a.top;
    var rect_b = win.document.body.getBoundingClientRect();
    var b = rect_b.bottom - rect_b.top;
    if (a > b) return a;

    return b;
}

function find_pos_x(obj, not_relative) {/* if not_relative is true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree */
    if (typeof not_relative == 'undefined') not_relative = false;
    var ret = obj.getBoundingClientRect().left + window.pageXOffset;
    if (!not_relative) {
        var position;
        while (obj != null) {
            position = window.getComputedStyle(obj).getPropertyValue('position');
            if (position == 'absolute' || position == 'relative') {
                ret -= find_pos_x(obj, true);
                break;
            }
            obj = obj.parentNode;
        }
    }
    return ret;
}
function find_pos_y(obj, not_relative) {/* if not_relative is true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree */
    if (typeof not_relative == 'undefined') not_relative = false;
    var ret = obj.getBoundingClientRect().top + window.pageYOffset;
    if (!not_relative) {
        var position;
        while (obj != null) {
            position = window.getComputedStyle(obj).getPropertyValue('position');
            if (position == 'absolute' || position == 'relative') {
                ret -= find_pos_y(obj, true);
                break;
            }
            obj = obj.parentNode;
        }
    }
    return ret;
}

/* See if a key event was an enter key being pressed */
function enter_pressed(event, alt_char) {
    if ((alt_char !== undefined) && (event.which && (event.which === alt_char.charCodeAt(0))))  {
        return true;
    }

    return event.which && (event.which === 13);
}

function modsecurity_workaround(form) {
    var temp_form = document.createElement('form');
    temp_form.method = 'post';
    if (form.target != null && form.target != '') {
        temp_form.target = form.target;
    }
    temp_form.action = form.action;

    var data = $(form).serialize();
    data = _modsecurity_workaround(data);

    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = '_data';
    input.value = data;
    temp_form.appendChild(input);

    if (typeof form.elements['csrf_token'] != 'undefined') {
        var csrf_input = document.createElement('input');
        csrf_input.type = 'hidden';
        csrf_input.name = 'csrf_token';
        csrf_input.value = form.elements['csrf_token'].value;
        temp_form.appendChild(csrf_input);
    }

    temp_form.style.display = 'none';
    document.body.appendChild(temp_form);

    window.setTimeout(function () {
        temp_form.submit();

        temp_form.parentNode.removeChild(temp_form);
    }, 0);

    return false;
}

function modsecurity_workaround_ajax(data) {
    return '_data=' + encodeURIComponent(_modsecurity_workaround(data));
}

function _modsecurity_workaround(data) {
    var remapper = {
        '\\': '<',
        '/': '>',
        '<': '\'',
        '>': '"',
        '\'': '/',
        '"': '\\',
        '%': '&',
        '&': '%'
    };
    var out = '';
    var len = data.length, char;
    for (var i = 0; i < len; i++) {
        char = data[i];
        if (remapper[char] !== undefined) {
            out += remapper[char];
        } else {
            out += char;
        }
    }
    return out;
}

function clear_out_tooltips(tooltip_being_opened) {
    // Delete other tooltips, which due to browser bugs can get stuck
    var selector = tooltip_being_opened ? '.tooltip:not(#' + tooltip_being_opened + ')' : '.tooltip';
    Composr.dom.$$(selector).forEach(function(el) {
        deactivate_tooltip(el.ac, el);
    });
}

function preactivate_rich_semantic_tooltip(ob, event, have_links) {
    if (typeof ob.ttitle == 'undefined') ob.ttitle = ob.title;
    ob.title = '';
    ob.onmouseover = null;
    ob.onclick = function () {
        activate_rich_semantic_tooltip(ob, event, have_links);
    };
}
function activate_rich_semantic_tooltip(ob, event, have_links) {
    if (typeof ob.ttitle == 'undefined') ob.ttitle = ob.title;
    activate_tooltip(ob, event, ob.ttitle, 'auto', null, null, false, true, false, false, window, have_links);
}
/* Tooltips that can work on any element with rich HTML support */
//  ac is the object to have the tooltip
//  event is the event handler
//  tooltip is the text for the tooltip
//  width is in pixels (but you need 'px' on the end), can be null or auto
//  pic is the picture to show in the top-left corner of the tooltip; should be around 30px x 30px
//  height is the maximum height of the tooltip for situations where an internal but unusable scrollbar is wanted
//  bottom is set to true if the tooltip should definitely appear upwards; rarely use this parameter
//  no_delay is set to true if the tooltip should appear instantly
//  lights_off is set to true if the image is to be dimmed
//  force_width is set to true if you want width to not be a max width
//  win is the window to open in
//  have_links is set to true if we activate/deactivate by clicking due to possible links in the tooltip or the need for it to work on mobile
function activate_tooltip(ac, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, have_links) {
    if (window.is_doing_a_drag) return; // Don't want tooltips appearing when doing a drag and drop operation

    if (!have_links) {
        if (document.body.className.indexOf(' touch_enabled') != -1) return; // Too erratic
    }

    if (typeof width == 'undefined' || !width) var width = 'auto';
    if (typeof pic == 'undefined') pic = '';
    if (typeof height == 'undefined' || !height) var height = 'auto';
    if (typeof bottom == 'undefined') bottom = false;
    if (typeof no_delay == 'undefined') no_delay = false;
    if (typeof lights_off == 'undefined') lights_off = false;
    if (typeof force_width == 'undefined') force_width = false;
    if (typeof win == 'undefined') win = window;
    if (typeof have_links == 'undefined') have_links = false;

    if (!window.page_loaded) return;
    if ((typeof tooltip != 'function') && (tooltip == '')) return;

    register_mouse_listener(event);

    clear_out_tooltips(ac.tooltip_id);

    // Add in move/leave events if needed
    if (!have_links) {
        if (!ac.onmouseout) ac.onmouseout = function (event) {
            win.deactivate_tooltip(ac);
        };
        if (!ac.onmousemove) ac.onmousemove = function (event) {
            win.reposition_tooltip(ac, event, false, false, null, false, win);
        };
    } else {
        ac.old_onclick = ac.onclick;
        ac.onclick = function (event) {
            win.deactivate_tooltip(ac);
        };
    }

    if (typeof tooltip == 'function') tooltip = tooltip();
    if (tooltip == '') return;

    ac.is_over = true;
    ac.tooltip_on = false;
    ac.initial_width = width;
    ac.have_links = have_links;

    var children = ac.getElementsByTagName('img');
    for (var i = 0; i < children.length; i++) children[i].setAttribute('title', '');

    var tooltip_element;
    if ((typeof ac.tooltip_id != 'undefined') && (document.getElementById(ac.tooltip_id))) {
        tooltip_element = win.document.getElementById(ac.tooltip_id);
        tooltip_element.style.display = 'none';
        Composr.dom.html(tooltip_element, '');
        window.setTimeout(function () {
            reposition_tooltip(ac, event, bottom, true, tooltip_element, force_width);
        }, 0);
    } else {
        tooltip_element = win.document.createElement('div');
        tooltip_element.role = 'tooltip';
        tooltip_element.style.display = 'none';
        var rt_pos = tooltip.indexOf('results_table');
        tooltip_element.className = 'tooltip ' + ((rt_pos == -1 || rt_pos > 100) ? 'tooltip_ownlayout' : 'tooltip_nolayout') + ' boxless_space' + (have_links ? ' have_links' : '');
        if (ac.className.substr(0, 3) == 'tt_') {
            tooltip_element.className += ' ' + ac.className;
        }
        if (tooltip.length < 50) tooltip_element.style.wordWrap = 'normal'; // Only break words on long tooltips. Otherwise it messes with alignment.
        if (force_width) {
            tooltip_element.style.width = width;
        } else {
            if (width == 'auto') {
                var new_auto_width = get_window_width(win) - 30 - window.mouse_x;
                if (new_auto_width < 150) new_auto_width = 150; // For tiny widths, better let it slide to left instead, which it will as this will force it to not fit
                tooltip_element.style.maxWidth = new_auto_width + 'px';
            } else {
                tooltip_element.style.maxWidth = width;
            }
            tooltip_element.style.width = 'auto'; // Needed for Opera, else it uses maxWidth for width too
        }
        if ((height) && (height != 'auto')) {
            tooltip_element.style.maxHeight = height;
            tooltip_element.style.overflow = 'auto';
        }
        tooltip_element.style.position = 'absolute';
        tooltip_element.id = 't_' + Math.floor(Math.random() * 1000);
        ac.tooltip_id = tooltip_element.id;
        reposition_tooltip(ac, event, bottom, true, tooltip_element, force_width);
        document.body.appendChild(tooltip_element);
    }
    tooltip_element.ac = ac;

    if (pic) {
        var img = win.document.createElement('img');
        img.src = pic;
        img.className = 'tooltip_img';
        if (lights_off) img.className += ' faded_tooltip_img';
        tooltip_element.appendChild(img);
        tooltip_element.className += ' tooltip_with_img';
    }

    var event_copy;
    try {
        event_copy = { // Needs to be copied as it will get erased on IE after this function ends
            'pageX': event.pageX,
            'pageY': event.pageY,
            'clientX': event.clientX,
            'clientY': event.clientY,
            'type': event.type
        };
    }
    catch (e) { // Can happen if IE has lost the event
        event_copy = {
            'pageX': 0,
            'pageY': 0,
            'clientX': 0,
            'clientY': 0,
            'type': ''
        };
    }

    // This allows turning off tooltips by pressing anywhere, on iPhone (and probably Android etc). The clickability of body forces the simulated onmouseout events to fire.
    var bi = document.getElementById('main_website_inner');
    if (!bi) bi = document.body;
    if ((typeof window.TouchEvent != 'undefined') && (!bi.onmouseover)) {
        bi.onmouseover = function () {
            return true;
        };
    }

    window.setTimeout(function () {
        if (!ac.is_over) return;

        if ((!ac.tooltip_on) || (tooltip_element.childNodes.length == 0)) // Some other tooltip jumped in and wiped out tooltip on a delayed-show yet never triggers due to losing focus during that delay
            Composr.dom.appendHtml(tooltip_element, tooltip);

        ac.tooltip_on = true;
        tooltip_element.style.display = 'block';
        if (tooltip_element.style.width == 'auto')
            tooltip_element.style.width = (Composr.dom.contentWidth(tooltip_element) + 1/*for rounding issues from em*/) + 'px'; // Fix it, to stop the browser retroactively reflowing ambiguous layer widths on mouse movement

        if (!no_delay) {
            // If delayed we will sub in what the currently known global mouse coordinate is
            event_copy.pageX = win.mouse_x;
            event_copy.pageY = win.mouse_y;
        }

        reposition_tooltip(ac, event_copy, bottom, true, tooltip_element, force_width, win);
    }, no_delay ? 0 : 666);
}
function reposition_tooltip(ac, event, bottom, starting, tooltip_element, force_width, win) {
    if (typeof win === 'undefined') { win = window; }

    if (!starting) // Real JS mousemove event, so we assume not a screen reader and have to remove natural tooltip
    {
        if (ac.getAttribute('title')) ac.setAttribute('title', '');
        if ((ac.parentNode.localName === 'a') && (ac.parentNode.getAttribute('title')) && ((ac.localName === 'abbr') || (ac.parentNode.getAttribute('title').indexOf('{!LINK_NEW_WINDOW;^}') != -1)))
            ac.parentNode.setAttribute('title', ''); // Do not want second tooltips that are not useful
    }

    if (!window.page_loaded) return;
    if (!ac.tooltip_id) {
        if ((typeof ac.onmouseover != 'undefined') && (ac.onmouseover)) ac.onmouseover(event);
        return;
    }  // Should not happen but written as a fail-safe

    if ((typeof tooltip_element == 'undefined') || (!tooltip_element)) var tooltip_element = document.getElementById(ac.tooltip_id);
    if (tooltip_element) {
        var style__offset_x = 9;
        var style__offset_y = (ac.have_links) ? 18 : 9;

        // Find mouse position
        var x, y;
        x = window.mouse_x;
        y = window.mouse_y;
        x += style__offset_x;
        y += style__offset_y;
        try {
            if (typeof event.type != 'undefined') {
                if (event.type != 'focus') ac.done_none_focus = true;
                if ((event.type == 'focus') && (ac.done_none_focus)) return;
                x = (event.type == 'focus') ? (win.pageXOffset + get_window_width(win) / 2) : (window.mouse_x + style__offset_x);
                y = (event.type == 'focus') ? (win.pageYOffset + get_window_height(win) / 2 - 40) : (window.mouse_y + style__offset_y);
            }
        }
        catch (ignore) {
        }
        // Maybe mouse position actually needs to be in parent document?
        try {
            if (event.target !== undefined) {
                if (event.target.ownerDocument !== win.document) {
                    x = win.mouse_x + style__offset_x;
                    y = win.mouse_y + style__offset_y;
                }
            }
        }
        catch (ignore) {
        }

        // Work out which direction to render in
        var width = Composr.dom.contentWidth(tooltip_element);
        if (tooltip_element.style.width == 'auto') {
            if (width < 200) width = 200; // Give some breathing room, as might already have painfully-wrapped when it found there was not much space
        }
        var height = tooltip_element.offsetHeight;
        var x_excess = x - get_window_width(win) - win.pageXOffset + width + 10/*magic tolerance factor*/;
        if (x_excess > 0) // Either we explicitly gave too much width, or the width auto-calculated exceeds what we THINK is the maximum width in which case we have to re-compensate with an extra contingency to stop CSS/JS vicious disagreement cycles
        {
            var x_before = x;
            x -= x_excess + 20 + style__offset_x;
            if (x < 100) x = (x_before < 100) ? x_before : 100; // Do not make it impossible to de-focus the tooltip
        }
        if (x < 0) x = 0;
        if (bottom) {
            tooltip_element.style.top = (y - height) + 'px';
        } else {
            var y_excess = y - get_window_height(win) - win.pageYOffset + height + style__offset_y;
            if (y_excess > 0) y -= y_excess;
            var scroll_y = win.pageYOffset;
            if (y < scroll_y) y = scroll_y;
            tooltip_element.style.top = y + 'px';
        }
        tooltip_element.style.left = x + 'px';
    }
}
function deactivate_tooltip(ac, tooltip_element) {
    ac.is_over = false;

    if (typeof ac.tooltip_id == 'undefined') return;

    if (typeof tooltip_element == 'undefined')
        tooltip_element = document.getElementById(ac.tooltip_id);
    if (tooltip_element) tooltip_element.style.display = 'none';

    if (typeof ac.old_onclick != 'undefined') {
        ac.onclick = ac.old_onclick;
    }
}

/* Automatic resizing to make frames seamless. Composr calls this automatically. Make sure id&name attributes are defined on your iframes! */
function resize_frame(name, min_height) {
    if (typeof min_height == 'undefined') min_height = 0;
    var frame_element = document.getElementById(name);
    var frame_window;
    if (typeof window.frames[name] != 'undefined') frame_window = window.frames[name]; else if (parent && parent.frames[name]) frame_window = parent.frames[name]; else return;
    if ((frame_element) && (frame_window) && (frame_window.document) && (frame_window.document.body)) {
        var h = get_window_scroll_height(frame_window);
        if ((h == 0) && (frame_element.parentNode.style.display == 'none')) {
            h = ((typeof min_height == 'undefined') || (min_height == 0)) ? 100 : min_height;
            if (frame_window.parent) window.setTimeout(function () {
                if (frame_window.parent) frame_window.parent.trigger_resize();
            }, 0);
        }
        if (h + 'px' != frame_element.style.height) {
            if (frame_element.scrolling != 'auto') {
                frame_element.style.height = ((h >= min_height) ? h : min_height) + 'px';
                if (frame_window.parent) window.setTimeout(function () {
                    if (frame_window.parent) frame_window.parent.trigger_resize();
                }, 0);
                frame_element.scrolling = 'no';
                frame_window.onscroll = function (event) {
                    if (event == null) return false;
                    try {
                        frame_window.scrollTo(0, 0);
                    } catch (e) {
                    }
                    return cancel_bubbling(event);
                }; // Needed for Opera
            }
        }
    }

    frame_element.style.transform = 'scale(1)'; // Workaround Chrome painting bug
}
function trigger_resize(and_subframes) {
    if (typeof window.parent == 'undefined') return;
    if (typeof window.parent.document == 'undefined') return;
    var frames = window.parent.document.getElementsByTagName('iframe');
    var done = false, i;

    for (i = 0; i < frames.length; i++) {
        if ((frames[i].src == window.location.href) || (frames[i].contentWindow == window) || ((frames[i].id != '') && (typeof window.parent.frames[frames[i].id] != 'undefined') && (window.parent.frames[frames[i].id] == window))) {
            if (frames[i].style.height == '900px') frames[i].style.height = 'auto';
            window.parent.resize_frame(frames[i].name);
        }
    }

    if (and_subframes) {
        frames = document.getElementsByTagName('iframe');
        for (i = 0; i < frames.length; i++) {
            if ((frames[i].name != '') && ((frames[i].className.indexOf('expandable_iframe') != -1) || (frames[i].className.indexOf('dynamic_iframe') != -1))) resize_frame(frames[i].name);
        }
    }
}

/* Marking things (to avoid illegally nested forms) */
function add_form_marked_posts(work_on, prefix) {
    var get = work_on.method.toLowerCase() === 'get';
    var elements = document.getElementsByTagName('input');
    var i;
    var append = '';
    if (get) {
        for (i = 0; i < work_on.elements.length; i++) {
            if (work_on.elements[i].name.match(new RegExp('&' + prefix.replace('_', '\_') + '\d+=1$', 'g'))) {
                work_on.elements[i].parentNode.removeChild(work_on.elements[i]);
            }
        }
    } else {
        // Strip old marks out of the URL
        work_on.action = work_on.action.replace('?', '&');
        work_on.action = work_on.action.replace(new RegExp('&' + prefix.replace('_', '\_') + '\d+=1$', 'g'), '');
        work_on.action = work_on.action.replace('&', '?'); // will just do first due to how JS works
    }
    for (i = 0; i < elements.length; i++) {
        if ((elements[i].type == 'checkbox') && (elements[i].name.substring(0, prefix.length) == prefix) && (elements[i].checked))
            append += (((append == '') && (work_on.action.indexOf('?') == -1) && (work_on.action.indexOf('/pg/') == -1) && (!get)) ? '?' : '&') + elements[i].name + '=1';
    }
    if (get) {
        var bits = append.split('&');
        for (i = 0; i < bits.length; i++) {
            if (bits[i] != '') {
                var hidden = document.createElement('input');
                hidden.name = bits[i].substr(0, bits[i].indexOf('=1'));
                hidden.value = '1';
                hidden.type = 'hidden';
                work_on.appendChild(hidden);
            }
        }
    } else {
        work_on.action += append;
    }
    return append != '';
}


/* Set opacity, without interfering with the thumbnail timer */
function clear_transition_and_set_opacity(el, fraction) {
    clear_transition(el);
    el.style.opacity = fraction;
}

function clear_transition(el) {
    var key = el.fader_key;
    if (key && window.fade_transition_timers[key]) {
        try { // Cross-frame issues may cause error
            window.clearTimeout(window.fade_transition_timers[key]);
        } catch (ignore) {}
        delete window.fade_transition_timers[key];
    }
}

/* Event listeners */

function cancel_bubbling(event) {
    if (!event || !event.target || (event.stopPropagation === undefined)) {
        return false;
    }

    event.stopPropagation();
    return true;
}

/* Update a URL to maintain the current theme into it */
function maintain_theme_in_link(url) {
    var qs = Composr.uspFromUrl(url),
        theme = encodeURIComponent(Composr.$THEME);

    if (!qs) {
        return url + '?utheme=' + theme;
    }

    if (!qs.has('utheme') && !qs.has('keep_theme')) {
        return url + '&utheme=' + theme;
    }

    return url;
}

/* Get URL stub to propagate keep_* parameters */
function keep_stub(starting_query_string, skip_session, context) {// starting_query_string means "Put a '?' for the first parameter"
    if (!window || (window.location === undefined)) {
        // Can happen, in a document.write'd popup
        return '';
    }

    if (skip_session === undefined) {
        skip_session = false;
    }

    if (((context === undefined) || !context.includes('keep_')) && (skip_session)) {
        if (starting_query_string) {
            if (window.cache_keep_stub_starting_query_string !== undefined)
                return window.cache_keep_stub_starting_query_string;
        } else {
            if (window.cache_keep_stub !== undefined) {
                return window.cache_keep_stub;
            }
        }
    }

    var to_add = '', i,
        search = (window.location.search || '?').substr(1),
        bits = search.split('&'),
        done_session = skip_session,
        gap_symbol;

    for (i = 0; i < bits.length; i++) {
        if (bits[i].substr(0, 5) === 'keep_') {
            if ((context === undefined) || (!context.includes('?' + bits[i]) && !context.includes('&' + bits[i]))) {
                gap_symbol = (((to_add == '') && (starting_query_string)) ? '?' : '&');
                to_add += gap_symbol + bits[i];
                if (bits[i].substr(0, 13) == 'keep_session=') done_session = true;
            }
        }
    }
    if (!done_session) {
        var session = get_session_id();
        gap_symbol = (((to_add == '') && (starting_query_string)) ? '?' : '&');
        if (session) to_add = to_add + gap_symbol + 'keep_session=' + encodeURIComponent(session);
    }

    if (((context === undefined) || !context.includes('keep_')) && (skip_session)) {
        if (starting_query_string) {
            window.cache_keep_stub_starting_query_string = to_add;
        } else {
            window.cache_keep_stub = to_add;
        }
    }

    return to_add;
}

function get_csrf_token() {
    return read_cookie(Composr.$SESSION_COOKIE_NAME); // Session also works as a CSRF-token, as client-side knows it (AJAX)
}

function get_session_id() {
    return read_cookie(Composr.$SESSION_COOKIE_NAME);
}

/* Import an XML node into the current document */
function careful_import_node(node) {
    try {
        return document.importNode(node, true);
    } catch (e) {
        return node;
    }
}

/* Google Analytics tracking for links; particularly useful if you have no server-side stat collection */
function ga_track(ob, category, action) {
    if (Composr.not(Composr.$CONFIG_OPTION.googleAnalytics) || Composr.isStaff || Composr.isAdmin) {
        return;
    }

    if (category === undefined) {
        category = '{!URL;}';
    }

    if (action === undefined) {
        action = ob ? ob.href : '{!UNKNOWN;}';
    }

    try {
        ga('send', 'event', category, action);
    } catch (ignore) {
    }

    if (ob) {
        setTimeout(function () {
            click_link(ob);
        }, 100);

        return false;
    }
}

/* Force a link to be clicked without user clicking it directly (useful if there's a confirmation dialog inbetween their click) */
function click_link(link) {
    var tmp, cancelled;

    if ((link.localName !== 'a') && (link.localName !== 'input')) {
        link = link.querySelector('a, input');
    }

    if (!link) {
        return;
    }

    tmp = link.onclick;
    link.onclick = null;
    cancelled = !Composr.dom.trigger(link, { type: 'click', bubbles: false });
    link.onclick = tmp;

    if (!cancelled && link.href) {
        if (!link.target || (link.target === '_self')) {
            window.location = link.href;
        } else {
            window.open(link.href, link.target);
        }
    }
}

/* Reply to a topic using AJAX */
function topic_reply(is_threaded, ob, id, replying_to_username, replying_to_post, replying_to_post_plain, explicit_quote) {
    if (typeof explicit_quote == 'undefined') explicit_quote = false;

    var form = document.getElementById('comments_form');

    var parent_id_field;
    if (typeof form.elements['parent_id'] == 'undefined') {
        parent_id_field = document.createElement('input');
        parent_id_field.type = 'hidden';
        parent_id_field.name = 'parent_id';
        form.appendChild(parent_id_field);
    } else {
        parent_id_field = form.elements['parent_id'];
        if (typeof window.last_reply_to != 'undefined') clear_transition_and_set_opacity(window.last_reply_to, 1.0);
    }
    window.last_reply_to = ob;
    parent_id_field.value = is_threaded ? id : '';

    ob.className += ' activated_quote_button';

    var post = form.elements['post'];

    smooth_scroll(find_pos_y(form, true));

    var outer = document.getElementById('comments_posting_form_outer');
    if (outer && outer.style.display == 'none')
        toggleable_tray('comments_posting_form_outer');

    if (is_threaded) {
        post.value = '{!QUOTED_REPLY_MESSAGE;^}'.replace(/\\{1\\}/g, replying_to_username).replace(/\\{2\\}/g, replying_to_post_plain);
        post.strip_on_focus = post.value;
        post.className += ' field_input_non_filled';
    } else {
        if (typeof post.strip_on_focus != 'undefined' && post.value == post.strip_on_focus)
            post.value = '';
        else if (post.value != '') post.value += '\n\n';

        post.focus();
        post.value += '[quote="' + replying_to_username + '"]\n' + replying_to_post + '\n[snapback]' + id + '[/snapback][/quote]\n\n';
        if (!explicit_quote) post.default_substring_to_strip = post.value;
    }

    manage_scroll_height(post);
    post.scrollTop = post.scrollHeight;

    return false;
}

/* Set it up so a form field is known and can be monitored for changes */
function set_up_change_monitor(container) {
    var firstInp = Composr.dom.$(container, 'input, select, textarea');

    if (!firstInp || firstInp.id.includes('choose_')) {
        return;
    }

    Composr.dom.on(container, 'focusout change', function () {
        container.classList.toggle('filledin', find_if_children_set(container));
    });
}


function find_if_children_set(container) {
    var value, blank = true, el;
    var elements = Composr.dom.$$(container, 'input, select, textarea');
    for (var i = 0; i < elements.length; i++) {
        el = elements[i];
        if (((el.type === 'hidden') || ((el.style.display === 'none') && !is_wysiwyg_field(el))) && !el.classList.contains('hidden_but_needed')) {
            continue;
        }
        value = clever_find_value(el.form, el);
        blank = blank && (value == '');
    }
    return !blank;
}


/* Used by audio CAPTCHA. */
function play_self_audio_link(ob) {
    require_javascript('sound', window.SoundManager);

    var timer = window.setInterval(function () {
        window.clearInterval(timer);
        window.soundManager.setup({
            url: get_base_url() + '/data',
            debugMode: false,
            onready: function () {
                var sound_object = window.soundManager.createSound({url: ob.href});
                if (sound_object) {
                    sound_object.play();
                }
            }
        });
    }, 50);

    return false;
}

function fade_transition(el, dest_percent_opacity, period_in_msecs, increment, destroy_after) {
    if (!Composr.isEl(el)) {
        return;
    }

    if (Composr.not(Composr.$CONFIG_OPTION.enableAnimations)) {
        el.style.opacity =  dest_percent_opacity / 100.0;
        return;
    }

    if (el.fader_key === undefined) {
        el.fader_key = el.id + '_' + Math.round(Math.random() * 1000000);
    }

    if (window.fade_transition_timers[el.fader_key]) {
        window.clearTimeout(window.fade_transition_timers[el.fader_key]);
        delete window.fade_transition_timers[el.fader_key];
    }

    var again, new_increment;

    if (el.style.opacity) {
        var diff = (dest_percent_opacity / 100.0) - el.style.opacity;
        var direction = 1;
        if (increment > 0) {
            if (el.style.opacity > (dest_percent_opacity / 100.0)) {
                direction = -1;
            }
            new_increment = Math.min(direction * diff, increment / 100.0);
        } else {
            if (el.style.opacity < (dest_percent_opacity / 100.0)) {
                direction = -1;
            }
            new_increment = Math.max(direction * diff, increment / 100.0);
        }
        var temp = parseFloat(el.style.opacity) + direction * new_increment;

        if (temp < 0.0) {
            temp = 0.0;
        }

        if (temp > 1.0) {
            temp = 1.0;
        }

        el.style.opacity = temp;
        again = Math.round(temp * 100) !== Math.round(dest_percent_opacity);
    } else {
        // Opacity not set yet, need to call back in an event timer
        again = true;
    }

    if (again) {
        window.fade_transition_timers[el.fader_key] = window.setTimeout(function () {
            fade_transition(el, dest_percent_opacity, period_in_msecs, increment, destroy_after);
        }, period_in_msecs);
    } else {
        if (destroy_after && el.parentNode) {
            el.parentNode.removeChild(el);
        }
    }
}


/*

 This file does a lot of stuff relating to overlays...

 It provides callback-based *overlay*-driven substitutions for the standard browser windowing API...
 - alert
 - prompt
 - confirm
 - open (known as popups)
 - showModalDialog
 A term we are using for these kinds of 'overlay' is '(faux) modal window'.

 It provides a generic function to open a link as an overlay.

 It provides a function to open an image link as a 'lightbox' (we use the term lightbox exclusively to refer to images in an overlay).

 */
'use strict';

if (window.overlay_zIndex === undefined) {
    window.overlay_zIndex = 999999; // Has to be higher than plupload, which is 99999
}

function noop() {}

function open_images_into_lightbox(imgs, start) {
    if (start === undefined) {
        start = 0;
    }

    var modal = _open_image_into_lightbox(imgs[start][0], imgs[start][1], start + 1, imgs.length, true, imgs[start][2]);
    modal.positionInSet = start;

    var previous_button = document.createElement('img');
    previous_button.className = 'previous_button';
    previous_button.src = '{$IMG;,mediaset_previous}'.replace(/^https?:/, window.location.protocol);
    var previous = function (e) {
        cancel_bubbling(e);

        var new_position = modal.positionInSet - 1;
        if (new_position < 0) new_position = imgs.length - 1;
        modal.positionInSet = new_position;
        _open_different_image_into_lightbox(modal, new_position, imgs);
        return false;
    };
    previous_button.onclick = previous;
    modal.left = previous;
    modal.box_wrapper.firstElementChild.appendChild(previous_button);

    var next_button = document.createElement('img');
    next_button.className = 'next_button';
    next_button.src = '{$IMG;,mediaset_next}'.replace(/^https?:/, window.location.protocol);
    var next = function (e) {
        cancel_bubbling(e);

        var new_position = modal.positionInSet + 1;
        if (new_position >= imgs.length) new_position = 0;
        modal.positionInSet = new_position;
        _open_different_image_into_lightbox(modal, new_position, imgs);
        return false;
    };
    next_button.onclick = next;
    modal.right = next;
    modal.box_wrapper.firstElementChild.appendChild(next_button);
}

function open_image_into_lightbox(a, is_video) {
    if (typeof is_video == 'undefined') is_video = false;
    var has_full_button = (a.firstElementChild === null) || (a.href !== a.firstElementChild.src);
    _open_image_into_lightbox(a.href, (typeof a.cms_tooltip_title != 'undefined') ? a.cms_tooltip_title : a.title, null, null, has_full_button, is_video);
}

function _open_image_into_lightbox(initial_img_url, description, x, n, has_full_button, is_video) {
    if (typeof has_full_button == 'undefined') has_full_button = false;

    // Set up overlay for Lightbox
    var lightbox_code = ' \
			<div style="text-align: center"> \
				<p class="ajax_loading" id="lightbox_image"><img src="' + '{$IMG*;,loading}'.replace(/^https?:/, window.location.protocol) + '" /></p> \
				<p id="lightbox_meta" style="display: none" class="associated_link associated_links_block_group"> \
					<span id="lightbox_description">' + description + '</span> \
					' + ((n === null) ? '' : ('<span id="lightbox_position_in_set"><span id="lightbox_position_in_set_x">' + x + '</span> / <span id="lightbox_position_in_set_n">' + n + '</span></span>')) + ' \
					' + (is_video ? '' : ('<span id="lightbox_full_link"><a href="' + escape_html(initial_img_url) + '" target="_blank" title="{$STRIP_TAGS;,{!SEE_FULL_IMAGE}} {!LINK_NEW_WINDOW;}">{!SEE_FULL_IMAGE;}</a></span>')) + ' \
				</p> \
			</div> \
		';

    // Show overlay
    var my_lightbox = {
        type: 'lightbox',
        text: lightbox_code,
        cancel_button: '{!INPUTSYSTEM_CLOSE;^}',
        width: '450', // This will be updated with the real image width, when it has loaded
        height: '300' // "
    };
    var modal = new ModalWindow();
    modal.open(my_lightbox);

    // Load proper image
    window.setTimeout(function () { // Defer execution until the HTML was parsed
        if (is_video) {
            var video = document.createElement('video');
            video.controls = 'controls';
            video.autoplay = 'autoplay';
            Composr.dom.html(video, initial_img_url);
            video.className = 'lightbox_image';
            video.id = 'lightbox_image';
            video.addEventListener('loadedmetadata', function () {
                _resize_lightbox_dimensions_img(modal, video, has_full_button, true);
            });
        } else {
            var img = modal.top_window.document.createElement('img');
            img.className = 'lightbox_image';
            img.id = 'lightbox_image';
            img.onload = function () {
                _resize_lightbox_dimensions_img(modal, img, has_full_button, false);
            };
            img.src = initial_img_url;
        }
    }, 0);

    return modal;
}

function _open_different_image_into_lightbox(modal, position, imgs) {
    var is_video = imgs[position][2];

    // Load proper image
    window.setTimeout(function () { // Defer execution until the HTML was parsed
        if (is_video) {
            var video = document.createElement('video');
            video.controls = 'controls';
            video.autoplay = 'autoplay';
            Composr.dom.html(video, imgs[position][0]);
            video.className = 'lightbox_image';
            video.id = 'lightbox_image';
            video.addEventListener('loadedmetadata', function () {
                _resize_lightbox_dimensions_img(modal, video, true, true);
            });
        } else {
            var img = modal.top_window.document.createElement('img');
            img.className = 'lightbox_image';
            img.id = 'lightbox_image';
            img.src = '{$IMG_INLINE;,loading}';
            window.setTimeout(function () { // Defer execution until after loading is set
                img.onload = function () {
                    _resize_lightbox_dimensions_img(modal, img, true, is_video);
                };
                img.src = imgs[position][0];
            }, 0);
        }

        var lightbox_description = modal.top_window.document.getElementById('lightbox_description');
        var lightbox_position_in_set_x = modal.top_window.document.getElementById('lightbox_position_in_set_x');
        if (lightbox_description) Composr.dom.html(lightbox_description, imgs[position][1]);
        if (lightbox_position_in_set_x) Composr.dom.html(lightbox_position_in_set_x, position + 1);
    }, 0);
}

function _resize_lightbox_dimensions_img(modal, img, has_full_button, is_video) {
    if (!modal.box_wrapper) {
        /* Overlay closed already */
        return;
    }

    var real_width = is_video ? img.videoWidth : img.width;
    var width = real_width;
    var real_height = is_video ? img.videoHeight : img.height;
    var height = real_height;
    var lightbox_image = modal.top_window.document.getElementById('lightbox_image');

    var lightbox_meta = modal.top_window.document.getElementById('lightbox_meta');
    var lightbox_description = modal.top_window.document.getElementById('lightbox_description');
    var lightbox_position_in_set = modal.top_window.document.getElementById('lightbox_position_in_set');
    var lightbox_full_link = modal.top_window.document.getElementById('lightbox_full_link');

    var dims_func = function () {
        lightbox_description.style.display = (lightbox_description.childNodes.length > 0) ? 'inline' : 'none';
        if (lightbox_full_link) lightbox_full_link.style.display = (!is_video && has_full_button && (real_width > max_width || real_height > max_height)) ? 'inline' : 'none';
        lightbox_meta.style.display = (lightbox_description.style.display == 'inline' || lightbox_position_in_set !== null || lightbox_full_link && lightbox_full_link.style.display == 'inline') ? 'block' : 'none';

        // Might need to rescale using some maths, if natural size is too big
        var max_dims = _get_max_lightbox_img_dims(modal, has_full_button);
        var max_width = max_dims[0];
        var max_height = max_dims[1];
        if (width > max_width) {
            width = max_width;
            height = window.parseInt(max_width * real_height / real_width - 1);
        }
        if (height > max_height) {
            width = window.parseInt(max_height * real_width / real_height - 1);
            height = max_height;
        }

        img.width = width;
        img.height = height;
        modal.reset_dimensions('' + width, '' + height, false, true); // Temporarily forced, until real height is known (includes extra text space etc)

        window.setTimeout(function () {
            modal.reset_dimensions('' + width, '' + height, false);
        }, 0);

        if (img.parentElement) {
            img.parentElement.parentElement.parentElement.style.width = 'auto';
            img.parentElement.parentElement.parentElement.style.height = 'auto';
        }
    };

    var sup = lightbox_image.parentNode;
    sup.removeChild(lightbox_image);
    if (sup.childNodes.length != 0) {
        sup.insertBefore(img, sup.firstElementChild);
    } else {
        sup.appendChild(img);
    }
    sup.className = '';
    sup.style.textAlign = 'center';
    sup.style.overflow = 'hidden';

    dims_func();
    modal.add_event(window, 'resize', function () {
        dims_func();
    });
}

function _get_max_lightbox_img_dims(modal, has_full_button) {
    var max_width = modal.top_window.get_window_width() - 20;
    var max_height = modal.top_window.get_window_height() - 60;
    if (has_full_button) max_height -= 120;
    return [max_width, max_height];
}

function fauxmodal_confirm(question, callback, title, unescaped) {
    if (title === undefined) {
        title = '{!Q_SURE;}';
    }

    if (unescaped === undefined) {
        unescaped = false;
    }

    if (Composr.not(Composr.$CONFIG_OPTION.jsOverlays)) {
        callback(window.confirm(question));
        return;
    }


    var my_confirm = {
        type: 'confirm',
        text: unescaped ? question : escape_html(question).replace(/\n/g, '<br />'),
        yes_button: '{!YES;^}',
        no_button: '{!NO;^}',
        cancel_button: null,
        title: title,
        yes: function () {
            callback(true);
        },
        no: function () {
            callback(false);
        },
        width: '450'
    };
    new ModalWindow().open(my_confirm);
}

function fauxmodal_alert(notice, callback, title, unescaped) {
    callback = callback || noop;

    if (title === undefined) {
        title = '{!MESSAGE^;}';
    }

    if (unescaped === undefined) {
        unescaped = false;
    }

    if (Composr.not(Composr.$CONFIG_OPTION.jsOverlays)) {
        window.alert(notice);
        callback();
        return;
    }

    var my_alert = {
        type: 'alert',
        text: unescaped ? notice : escape_html(notice).replace(/\n/g, '<br />'),
        yes_button: '{!INPUTSYSTEM_OK;^}',
        width: '600',
        yes: callback,
        title: title,
        cancel_button: null
    };
    new ModalWindow().open(my_alert);
}

function fauxmodal_prompt(question, defaultValue, callback, title, input_type) {
    if (Composr.not(Composr.$CONFIG_OPTION.jsOverlays)) {
        callback(window.prompt(question, defaultValue));
        return;
    }

    var my_prompt = {
        type: 'prompt',
        text: escape_html(question).replace(/\n/g, '<br />'),
        yes_button: '{!INPUTSYSTEM_OK;^}',
        cancel_button: '{!INPUTSYSTEM_CANCEL;^}',
        defaultValue: (defaultValue === null) ? '' : defaultValue,
        title: title,
        yes: function (value) {
            callback(value);
        },
        cancel: function () {
            callback(null);
        },
        width: '450'
    };
    if (input_type) {
        my_prompt.input_type = input_type;
    }
    new ModalWindow().open(my_prompt);
}

function faux_showModalDialog(url, name, options, callback, target, cancel_text) {
    callback = callback || noop;

    if (Composr.not(Composr.$CONFIG_OPTION.jsOverlays)) {
        options = options.replace('height=auto', 'height=520');

        var timer = new Date().getTime();
        try {
            var result = window.showModalDialog(url, name, options);
        } catch (ignore) {
            // IE gives "Access is denied" if popup was blocked, due to var result assignment to non-real window
        }
        var timer_now = new Date().getTime();
        if (timer_now - 100 > timer) {// Not popup blocked
            if ((result === undefined) || (result === null)) {
                callback(null);
            } else {
                callback(result);
            }
        }
        return;
    }

    var width = null, height = null, scrollbars = null, unadorned = null;

    if (cancel_text === undefined) {
        cancel_text = '{!INPUTSYSTEM_CANCEL;^}';
    }

    if (options) {
        var parts = options.split(/[;,]/g), i;
        for (i = 0; i < parts.length; i++) {
            var bits = parts[i].split('=');
            if (bits[1] !== undefined) {
                if ((bits[0] == 'dialogWidth') || (bits[0] == 'width'))
                    width = bits[1].replace(/px$/, '');
                if ((bits[0] == 'dialogHeight') || (bits[0] == 'height')) {
                    if (bits[1] == '100%') {
                        height = '' + (get_window_height() - 200);
                    } else {
                        height = bits[1].replace(/px$/, '');
                    }
                }
                if (((bits[0] == 'resizable') || (bits[0] == 'scrollbars')) && scrollbars !== true)
                    scrollbars = ((bits[1] == 'yes') || (bits[1] == '1'))/*if either resizable or scrollbars set we go for scrollbars*/;
                if (bits[0] == 'unadorned') unadorned = ((bits[1] == 'yes') || (bits[1] == '1'));
            }
        }
    }

    if (url.indexOf(window.location.host) !== -1) {
        url += ((url.indexOf('?') == -1) ? '?' : '&') + 'overlay=1';
    }

    var my_frame = {
        type: 'iframe',
        finished: function (value) {
            callback(value);
        },
        name: name,
        width: width,
        height: height,
        scrollbars: scrollbars,
        href: url.replace(/^https?:/, window.location.protocol)
    };
    my_frame.cancel_button = (unadorned !== true) ? cancel_text : null;
    if (target) {
        my_frame.target = target;
    }
    new ModalWindow().open(my_frame);
}

function faux_open(url, name, options, target, cancel_text) {
    if (cancel_text === undefined) {
        cancel_text = '{!INPUTSYSTEM_CANCEL;^}';
    }

    if (Composr.not(Composr.$CONFIG_OPTION.jsOverlays)) {
        options = options.replace('height=auto', 'height=520');
        window.open(url, name, options);
        return;
    }

    faux_showModalDialog(url, name, options, null, target, cancel_text);
}

/*
 Originally...

 Script: modalwindow.js
 ModalWindow - Simple javascript popup overlay to replace builtin alert, prompt and confirm, and more.

 License:
 PHP-style license.

 Copyright:
 Copyright (c) 2009 [Kieron Wilson](http://kd3sign.co.uk/).

 Code & Documentation:
 http://kd3sign.co.uk/examples/modalwindow/

 HEAVILY Modified by ocProducts for Composr.

 */
// NB: only used in modalwindow.js
function ModalWindow() {
    function has_iframe_ownership(iframe) {
        try {
            return !!(iframe && (iframe.contentWindow.location.host === window.location.host) && (iframe.contentWindow.document));
        } catch (ignore) {}

        return false;
    }

    return {
        // Constants
        WINDOW_SIDE_GAP: Composr.is(Composr.$MOBILE) ? 5 : 25,
        WINDOW_TOP_GAP: 25, // Will also be used for bottom gap for percentage heights
        BOX_EAST_PERIPHERARY: 4,
        BOX_WEST_PERIPHERARY: 4,
        BOX_NORTH_PERIPHERARY: 4,
        BOX_SOUTH_PERIPHERARY: 4,
        VCENTRE_FRACTION_SHIFT: 0.5, // Fraction of remaining top gap also removed (as overlays look better slightly higher than vertical centre)
        LOADING_SCREEN_HEIGHT: 100,

        // Properties
        box_wrapper: null,
        button_container: null,
        returnValue: null,
        top_window: null,
        iframe_restyle_timer: null,

        // Methods...

        open: function () {
            var options = arguments[0] || {};
            var defaults = {
                'type': 'alert',
                'opacity': '0.5',
                'width': 'auto',
                'height': 'auto',
                'title': '',
                'text': '',
                'yes_button': '{!YES;^}',
                'no_button': '{!NO;^}',
                'cancel_button': '{!INPUTSYSTEM_CANCEL;^}',
                'yes': null,
                'no': null,
                'finished': null,
                'cancel': null,
                'href': null,
                'scrollbars': null,
                'defaultValue': null,
                'target': '_self',
                'input_type': 'text'
            };

            this.top_window = window.top;
            this.top_window = this.top_window.top;

            for (var key in defaults) {
                this[key] = (typeof options[key] != 'undefined') ? options[key] : defaults[key];
            }

            this.close(this.top_window);
            this.init_box();
        },

        close: function (win) {
            if (this.box_wrapper) {
                this.top_window.document.body.style.overflow = '';

                this.remove(this.box_wrapper, win);
                this.box_wrapper = null;

                this.remove_event(document, 'keyup', this.keyup);
                this.remove_event(document, 'mousemove', this.keyup);
            }
            this.opened = false;
        },

        option: function (method) {
            var win = this.top_window; // The below call may end up killing our window reference (for nested alerts), so we need to grab it first
            if (this[method]) {
                if (this.type == 'prompt') {
                    this[method](this.input.value);
                }
                else if (this.type == 'iframe') {
                    this[method](this.returnValue);
                }
                else this[method]();
            }
            if (method != 'left' && method != 'right')
                this.close(win);
        },

        reset_dimensions: function (width, height, init, force_height) {
            if (typeof force_height == 'undefined') force_height = false;

            if (!this.box_wrapper) return;

            var dim = this.get_page_size();

            var bottom_gap = this.WINDOW_TOP_GAP;
            if (this.button_container.childNodes.length > 0) bottom_gap += this.button_container.offsetHeight;

            if (!force_height)
                height = 'auto'; // Actually we always want auto heights, no reason to not for overlays

            // Store for later (when browser resizes for example)
            this.width = width;
            this.height = height;

            // Normalise parameters (we don't have px on the end of pixel units, and these units refer to internal space size [% ones are relative to window though])
            width = width.replace(/px$/, '');
            height = height.replace(/px$/, '');

            // Constrain to window width
            if (width.match(/^\d+$/) !== null) {
                if ((window.parseInt(width) > dim.window_width - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY) || (width == 'auto'))
                    width = '' + (dim.window_width - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY);
            }

            // Auto width means full width
            if (width == 'auto') {
                width = '' + (dim.window_width - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY);
            }
            // NB: auto height feeds through without a constraint (due to infinite growth space), with dynamic adjustment for iframes

            // Calculate percentage sizes
            var match;
            match = width.match(/^([\d\.]+)%$/);
            if (match !== null) {
                width = '' + (window.parseFloat(match[1]) * (dim.window_width - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY));
            }
            match = height.match(/^([\d\.]+)%$/);
            if (match !== null) {
                height = '' + (window.parseFloat(match[1]) * (dim.page_height - this.WINDOW_TOP_GAP - bottom_gap - this.BOX_NORTH_PERIPHERARY - this.BOX_SOUTH_PERIPHERARY));
            }

            // Work out box dimensions
            var box_width, box_height;
            if (width.match(/^\d+$/) !== null) {
                box_width = width + 'px';
            } else {
                box_width = width;
            }
            if (height.match(/^\d+$/) !== null) {
                box_height = height + 'px';
            } else {
                box_height = height;
            }

            // Save into HTML
            var detected_box_height;
            this.box_wrapper.firstElementChild.style.width = box_width;
            this.box_wrapper.firstElementChild.style.height = box_height;
            var iframe = this.box_wrapper.getElementsByTagName('iframe');
            if ((has_iframe_ownership(iframe[0])) && (iframe[0].contentWindow.document.body)) // Balance iframe height
            {
                iframe[0].style.width = '100%';
                if (height == 'auto') {
                    if (!init) {
                        detected_box_height = get_window_scroll_height(iframe[0].contentWindow);
                        iframe[0].style.height = detected_box_height + 'px';
                    }
                } else {
                    iframe[0].style.height = '100%';
                }
            }

            // Work out box position
            if (!detected_box_height) detected_box_height = this.box_wrapper.firstElementChild.offsetHeight;
            var _box_pos_top, _box_pos_left, box_pos_top, box_pos_left;
            if (box_height == 'auto') {
                if (init) {
                    _box_pos_top = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (this.LOADING_SCREEN_HEIGHT / 2) + this.WINDOW_TOP_GAP; // This is just temporary
                } else {
                    _box_pos_top = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (detected_box_height / 2) + this.WINDOW_TOP_GAP;
                }

                if (typeof iframe[0] != 'undefined') _box_pos_top = this.WINDOW_TOP_GAP; // Actually, for frames we'll put at top so things don't bounce about during loading and if the frame size changes
            } else {
                _box_pos_top = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (parseInt(box_height) / 2) + this.WINDOW_TOP_GAP;
            }
            if (_box_pos_top < this.WINDOW_TOP_GAP) _box_pos_top = this.WINDOW_TOP_GAP;
            _box_pos_left = ((dim.window_width / 2) - (parseInt(box_width) / 2));
            box_pos_top = _box_pos_top + 'px';
            box_pos_left = _box_pos_left + 'px';

            // Save into HTML
            this.box_wrapper.firstElementChild.style.top = box_pos_top;
            this.box_wrapper.firstElementChild.style.left = box_pos_left;

            var do_scroll = false;

            // Absolute positioning instead of fixed positioning
            if (Composr.is(Composr.$MOBILE) || (detected_box_height > dim.window_height) || (this.box_wrapper.style.position == 'absolute'/*don't switch back to fixed*/)) {
                var was_fixed = (this.box_wrapper.style.position == 'fixed');

                this.box_wrapper.style.position = 'absolute';
                this.box_wrapper.style.height = ((dim.page_height > (detected_box_height + bottom_gap + _box_pos_left)) ? dim.page_height : (detected_box_height + bottom_gap + _box_pos_left)) + 'px';
                this.top_window.document.body.style.overflow = '';

                if (Composr.not(Composr.$MOBILE)) {
                    this.box_wrapper.firstElementChild.style.position = 'absolute';
                    box_pos_top = this.WINDOW_TOP_GAP + 'px';
                    this.box_wrapper.firstElementChild.style.top = box_pos_top;
                }

                if ((init) || (was_fixed)) do_scroll = true;
                if (/*maybe a navigation has happened and we need to scroll back up*/(typeof iframe[0] != 'undefined') && (has_iframe_ownership(iframe[0])) && (typeof iframe[0].contentWindow.scrolled_up_for == 'undefined')) {
                    do_scroll = true;
                }
            } else // Fixed positioning, with scrolling turned off until the overlay is closed
            {
                this.box_wrapper.style.position = 'fixed';
                this.box_wrapper.firstElementChild.style.position = 'fixed';
                this.top_window.document.body.style.overflow = 'hidden';
            }

            if (do_scroll) {
                try // Scroll to top to see
                {
                    this.top_window.scrollTo(0, 0);
                    if ((typeof iframe[0] != 'undefined') && (has_iframe_ownership(iframe[0])))
                        iframe[0].contentWindow.scrolled_up_for = true;
                }
                catch (e) {
                }
            }
        },

        init_box: function () {
            var dim = this.get_page_size();

            this.box_wrapper = this.element('div', { // Black out the background
                'styles': {
                    'background': 'rgba(0,0,0,0.7)',
                    'zIndex': this.top_window.overlay_zIndex++,
                    'overflow': 'hidden',
                    'position': Composr.is(Composr.$MOBILE) ? 'absolute' : 'fixed',
                    'left': '0',
                    'top': '0',
                    'width': '100%',
                    'height': '100%'
                }
            });

            this.box_wrapper.appendChild(this.element('div', { // The main overlay
                'class': 'box overlay ' + this.type,
                'role': 'dialog',
                'styles': {
                    // This will be updated immediately in reset_dimensions
                    'position': Composr.is(Composr.$MOBILE) ? 'static' : 'fixed',
                    'margin': '0 auto' // Centering for iOS/Android which is statically positioned (so the container height as auto can work)
                }
            }));

            var _this = this;
            var width = this.width;
            var height = this.height;

            this.inject(this.box_wrapper);

            var container = this.element('div', {
                'class': 'box_inner',
                'styles': {
                    'width': 'auto',
                    'height': 'auto'
                }
            });

            var overlay_header = null;
            if (this.title != '' || this.type == 'iframe') {
                overlay_header = this.element('h3', {
                    'html': this.title,
                    'styles': {
                        'display': (this.title == '') ? 'none' : 'block'
                    }
                });
                container.appendChild(overlay_header);
            }

            if (this.text != '') {
                if (this.type == 'prompt') {
                    var div = this.element('p');
                    div.appendChild(this.element('label', {
                        'for': 'overlay_prompt',
                        'html': this.text
                    }));
                    container.appendChild(div);
                } else {
                    container.appendChild(this.element('div', {
                        'html': this.text
                    }));
                }
            }

            this.button_container = this.element('p', {
                'class': 'proceed_button'
            });

            this.clickout_cancel = function () {
                _this.option('cancel');
            };

            this.clickout_finished = function () {
                _this.option('finished');
            };

            this.clickout_yes = function () {
                _this.option('yes');
            };

            this.keyup = function (e) {
                var key_code = (e) ? (e.which || e.keyCode) : null;

                if (key_code == 37) // Left arrow
                {
                    _this.option('left');
                } else if (key_code == 39) // Right arrow
                {
                    _this.option('right');
                } else if ((key_code == 13/*enter*/) && (_this.yes)) {
                    _this.option('yes');
                }
                if ((key_code == 13/*enter*/) && (_this.finished)) {
                    _this.option('finished');
                } else if ((key_code == 27/*esc*/) && (_this.cancel_button) && ((_this.type == 'prompt') || (_this.type == 'confirm') || (_this.type == 'lightbox') || (_this.type == 'alert'))) {
                    _this.option('cancel');
                }
            };

            this.mousemove = function (e) {
                if (_this.box_wrapper && _this.box_wrapper.firstElementChild.className.indexOf(' mousemove') == -1) {
                    _this.box_wrapper.firstElementChild.className += ' mousemove';
                    window.setTimeout(function () {
                        if (_this.box_wrapper) {
                            _this.box_wrapper.firstElementChild.className = _this.box_wrapper.firstElementChild.className.replace(/ mousemove/g, '');
                        }
                    }, 2000);
                }
            };

            this.add_event(this.box_wrapper.firstElementChild, 'click', function (e) {
                try {
                    _this.top_window.cancel_bubbling(e);
                } catch (e) {
                }

                if (Composr.is(Composr.$MOBILE) && (_this.type === 'lightbox')) {// IDEA: Swipe detect would be better, but JS does not have this natively yet
                    _this.option('right');
                }
            });

            switch (this.type) {
                case 'iframe':
                    var iframe_width = (this.width.match(/^[\d\.]+$/) !== null) ? ((this.width - 14) + 'px') : this.width;
                    var iframe_height = (this.height.match(/^[\d\.]+$/) !== null) ? (this.height + 'px') : ((this.height == 'auto') ? (this.LOADING_SCREEN_HEIGHT + 'px') : this.height);

                    var iframe = this.element('iframe', {
                        'frameBorder': '0',
                        'scrolling': 'no',
                        'title': '',
                        'name': 'overlay_iframe',
                        'id': 'overlay_iframe',
                        'allowTransparency': 'true',
                        //'seamless': 'seamless',	Not supported, and therefore testable yet. Would be great for mobile browsing.
                        'styles': {
                            'width': iframe_width,
                            'height': iframe_height,
                            'background': 'transparent'
                        }
                    });

                    container.appendChild(iframe);

                    animate_frame_load(iframe, 'overlay_iframe', 50, true);

                    window.setTimeout(function () {
                        _this.add_event(_this.box_wrapper, 'click', _this.clickout_finished);
                    }, 1000);

                    this.add_event(iframe, 'load', function () {
                        if ((has_iframe_ownership(iframe)) && (typeof iframe.contentWindow.document.getElementsByTagName('h1')[0] == 'undefined') && (typeof iframe.contentWindow.document.getElementsByTagName('h2')[0] == 'undefined')) {
                            if (iframe.contentWindow.document.title != '') {
                                Composr.dom.html(overlay_header, escape_html(iframe.contentWindow.document.title));
                                overlay_header.style.display = 'block';
                            }
                        }
                    });

                    // Fiddle it, to behave like a popup would
                    var name = this.name;
                    var make_frame_like_popup = function () {
                        if (iframe.parentNode.parentNode.parentNode.parentNode == null && _this.iframe_restyle_timer != null) {
                            clearInterval(_this.iframe_restyle_timer);
                            _this.iframe_restyle_timer = null;
                            return;
                        }

                        if ((has_iframe_ownership(iframe)) && (iframe.contentWindow.document.body) && (typeof iframe.contentWindow.document.body.done_popup_trans == 'undefined')) {
                            iframe.contentWindow.document.body.style.background = 'transparent';

                            if (iframe.contentWindow.document.body.className.indexOf('overlay') == -1) {
                                iframe.contentWindow.document.body.className += ' overlay lightbox';
                            }

                            // Allow scrolling, if we want it
                            //iframe.scrolling=(_this.scrollbars===false)?'no':'auto';	Actually, not wanting this now

                            // Remove fixed width
                            var main_website_inner = iframe.contentWindow.document.getElementById('main_website_inner');
                            if (main_website_inner) main_website_inner.id = '';

                            // Remove main_website marker
                            var main_website = iframe.contentWindow.document.getElementById('main_website');
                            if (main_website) main_website.id = '';

                            // Remove popup spacing
                            var popup_spacer = iframe.contentWindow.document.getElementById('popup_spacer');
                            if (popup_spacer) popup_spacer.id = '';

                            // Set linking scheme
                            var bases = iframe.contentWindow.document.getElementsByTagName('base');
                            var base_element;
                            if (!bases[0]) {
                                base_element = iframe.contentWindow.document.createElement('base');
                                if (iframe.contentWindow.document) {
                                    var heads = iframe.contentWindow.document.getElementsByTagName('head');
                                    if (heads[0]) {
                                        heads[0].appendChild(base_element);
                                    }
                                }
                            } else {
                                base_element = bases[0];
                            }
                            base_element.target = _this.target;
                            // Firefox 3.6 does not respect <base> element put in via DOM manipulation :(
                            var forms = iframe.contentWindow.document.getElementsByTagName('form');
                            for (var i = 0; i < forms.length; i++) {
                                if (!forms[i].target) forms[i].target = _this.target;
                            }
                            var as = iframe.contentWindow.document.getElementsByTagName('a');
                            for (var i = 0; i < as.length; i++) {
                                if (!as[i].target) as[i].target = _this.target;
                            }

                            // Set frame name
                            if (name && iframe.contentWindow.name != name) iframe.contentWindow.name = name;

                            // Create close function
                            if (typeof iframe.contentWindow.faux_close == 'undefined') {
                                iframe.contentWindow.faux_close = function () {
                                    if (iframe && iframe.contentWindow && typeof iframe.contentWindow.returnValue != 'undefined')
                                        _this.returnValue = iframe.contentWindow.returnValue;
                                    _this.option('finished');
                                };
                            }

                            if (Composr.dom.html(iframe.contentWindow.document.body).length > 300) // Loaded now
                            {
                                iframe.contentWindow.document.body.done_popup_trans = true;
                            }
                        }

                        // Handle iframe sizing
                        if (_this.height == 'auto') {
                            _this.reset_dimensions(_this.width, _this.height, false);
                        }
                    };
                    window.setTimeout(function () {
                        illustrate_frame_load('overlay_iframe');
                        iframe.src = _this.href;
                        make_frame_like_popup();

                        if (_this.iframe_restyle_timer == null)
                            _this.iframe_restyle_timer = window.setInterval(make_frame_like_popup, 300); // In case internal nav changes
                    }, 0);
                    break;

                case 'lightbox':
                case 'alert':
                    if (this.yes) {
                        var button = this.element('button', {
                            'html': this.yes_button,
                            'class': 'buttons__proceed button_screen_item'
                        });
                        this.add_event(button, 'click', function () {
                            _this.option('yes');
                        });
                        window.setTimeout(function () {
                            _this.add_event(_this.box_wrapper, 'click', _this.clickout_yes);
                        }, 1000);
                        this.button_container.appendChild(button);
                    } else {
                        window.setTimeout(function () {
                            _this.add_event(_this.box_wrapper, 'click', _this.clickout_cancel);
                        }, 1000);
                    }
                    break;

                case 'confirm':
                    var button = this.element('button', {
                        'html': this.yes_button,
                        'class': 'buttons__yes button_screen_item',
                        'style': 'font-weight: bold;'
                    });
                    this.add_event(button, 'click', function () {
                        _this.option('yes');
                    });
                    this.button_container.appendChild(button);
                    var button = this.element('button', {
                        'html': this.no_button,
                        'class': 'buttons__no button_screen_item'
                    });
                    this.add_event(button, 'click', function () {
                        _this.option('no');
                    });
                    this.button_container.appendChild(button);
                    break;

                case 'prompt':
                    this.input = this.element('input', {
                        'name': 'prompt',
                        'id': 'overlay_prompt',
                        'type': this.input_type,
                        'size': '40',
                        'class': 'wide_field',
                        'value': (this.defaultValue === null) ? '' : this.defaultValue
                    });
                    var input_wrap = this.element('div', {
                        'class': 'constrain_field'
                    });
                    input_wrap.appendChild(this.input);
                    container.appendChild(input_wrap);

                    if (this.yes) {
                        var button = this.element('button', {
                            'html': this.yes_button,
                            'class': 'buttons__yes button_screen_item',
                            'style': 'font-weight: bold;'
                        });
                        this.add_event(button, 'click', function () {
                            _this.option('yes');
                        });
                        this.button_container.appendChild(button);
                    }
                    window.setTimeout(function () {
                        _this.add_event(_this.box_wrapper, 'click', _this.clickout_cancel);
                    }, 1000);
                    break;
            }

            // Cancel button handled either via button in corner (if there's no other buttons) or another button in the panel (if there's other buttons)
            if (this.cancel_button) {
                var button;
                if (this.button_container.childNodes.length > 0) {
                    button = this.element('button', {
                        'html': this.cancel_button,
                        'class': 'button_screen_item buttons__cancel'
                    });
                    this.button_container.appendChild(button);
                } else {
                    button = this.element('img', {
                        'src': '{$IMG;,button_lightbox_close}'.replace(/^https?:/, window.location.protocol),
                        'alt': this.cancel_button,
                        'class': 'overlay_close_button'
                    });
                    container.appendChild(button);
                }
                this.add_event(button, 'click', function () {
                    _this.option(this.cancel ? 'cancel' : 'finished');
                });
            }

            // Put together
            if (this.button_container.childNodes.length > 0) {
                if (this.type == 'iframe')
                    container.appendChild(this.element('hr', {'class': 'spaced_rule'}));
                container.appendChild(this.button_container);
            }
            this.box_wrapper.firstElementChild.appendChild(container);

            // Handle dimensions
            this.reset_dimensions(this.width, this.height, true);
            this.add_event(window, 'resize', function () {
                _this.reset_dimensions(width, height, false);
            });

            // Focus first button by default
            if (this.input) {
                window.setTimeout(function () {
                    _this.input.focus();
                }, 0);
            }
            else if (typeof this.box_wrapper.getElementsByTagName('button')[0] != 'undefined') {
                this.box_wrapper.getElementsByTagName('button')[0].focus();
            }

            window.setTimeout(function () { // Timeout needed else keyboard activation of overlay opener may cause instant shutdown also
                _this.add_event(document, 'keyup', _this.keyup);
                _this.add_event(document, 'mousemove', _this.mousemove);
            }, 100);
        },

        inject: function (el) {
            this.top_window.document.body.appendChild(el);
        },

        remove: function (el, win) {
            if (!win) win = this.top_window;
            win.document.body.removeChild(el);
        },

        element: function () {
            var tag = arguments[0], options = arguments[1];
            var el = this.top_window.document.createElement(tag);
            var attributes = {
                'html': 'innerHTML',
                'class': 'className',
                'for': 'htmlFor',
                'text': 'innerText'
            };
            if (options) {
                if (typeof options == 'object') {
                    for (var name in options) {
                        var value = options[name];
                        if (name == 'styles') {
                            this.set_styles(el, value);
                        } else if (name == 'html') {
                            Composr.dom.html(el, value);
                        } else if (attributes[name]) {
                            el[attributes[name]] = value;
                        } else {
                            el.setAttribute(name, value);
                        }
                    }
                }
            }
            return el;
        },

        add_event: function (o, e, f) {
            if (o) {
                o.addEventListener(e, f, false);
            }
        },

        remove_event: function (o, e, f) {
            if (o) {
                o.removeEventListener(e, f, false);
            }
        },

        set_styles: function (e, o) {
            for (var k in o) {
                this.set_style(e, k, o[k]);
            }
        },

        set_style: function (e, p, v) {
            if (p == 'opacity') {
                this.top_window.set_opacity(e, v);
            } else {
                try {
                    e.style[p] = v;
                }
                catch (e) {
                }
            }
        },

        get_page_size: function () {
            return {
                'page_width': this.top_window.get_window_scroll_width(this.top_window),
                'page_height': this.top_window.get_window_scroll_height(this.top_window),
                'window_width': this.top_window.get_window_width(this.top_window),
                'window_height': this.top_window.get_window_height()
            };
        }
    };
}


"use strict";

window.tree_list = function (name, ajax_url, root_id, options, multi_selection, tabindex, all_nodes_selectable, use_server_id) {
    if (typeof window.do_ajax_request == 'undefined') return;
    if (typeof use_server_id == 'undefined') use_server_id = false;

    if ((typeof multi_selection == 'undefined') || (!multi_selection)) var multi_selection = false;

    this.name = name;
    this.ajax_url = ajax_url;
    this.options = options;
    this.multi_selection = multi_selection;
    this.tabindex = tabindex ? tabindex : null;
    this.all_nodes_selectable = all_nodes_selectable;
    this.use_server_id = use_server_id;

    var element = document.getElementById('tree_list__root_' + name);
    Composr.dom.html(element, '<div class="ajax_loading vertical_alignment"><img src="' + Composr.url('{$IMG*;,loading}') + '" alt="" /> <span>{!LOADING;^}</span></div>');

    // Initial rendering
    var url = '{$BASE_URL_NOHTTP;}/' + ajax_url;
    if (root_id !== null) url += '&id=' + window.encodeURIComponent(root_id);
    url += '&options=' + options;
    url += '&default=' + window.encodeURIComponent(document.getElementById(name).value);
    do_ajax_request(url, this);

    register_mouse_listener();
};

tree_list.prototype.tree_list_data = '';
tree_list.prototype.busy = false;
tree_list.prototype.last_clicked = null; // The hyperlink object that was last clicked (usage during multi selection when holding down shift)

/* Go through our tree list looking for a particular XML node */
tree_list.prototype.getElementByIdHack = function (id, type, ob, serverid) {
    if ((typeof type == 'undefined') || (!type)) var type = 'c';
    if ((typeof ob == 'undefined') || (!ob)) var ob = this.tree_list_data;
    var i, test, done = false;
    // Normally we could only ever use getElementsByTagName, but Konqueror and Safari don't like it
    try // IE9 beta has serious problems
    {
        if ((typeof ob.getElementsByTagName != 'undefined') && (typeof ob.getElementsByTagName != 'unknown')) {
            var results = ob.getElementsByTagName((type == 'c') ? 'category' : 'entry');
            for (i = 0; i < results.length; i++) {
                if ((typeof results[i].getAttribute != 'undefined') && (typeof results[i].getAttribute != 'unknown') && (results[i].getAttribute(serverid ? 'serverid' : 'id') == id)) {
                    return results[i];
                }
            }
            done = true;
        }
    }
    catch (e) {
    }
    if (!done) {
        for (i = 0; i < ob.childNodes.length; i++) {
            if (ob.childNodes[i].localName === 'category') {
                test = this.getElementByIdHack(id, type, ob.childNodes[i], serverid);
                if (test) {
                    return test;
                }
            }
            if ((ob.childNodes[i].localName === ((type == 'c') ? 'category' : 'entry')) && (ob.childNodes[i].getAttribute(serverid ? 'serverid' : 'id') == id))
                return ob.childNodes[i];
        }
    }
    return null;
};

tree_list.prototype.response = function (ajax_result_frame, ajax_result, expanding_id) {
    if (!ajax_result) return;
    if (!window.fixup_node_positions) return;

    ajax_result = careful_import_node(ajax_result);

    var i, xml, temp_node, html;
    if (!expanding_id) // Root
    {
        html = document.getElementById('tree_list__root_' + this.name);
        Composr.dom.html(html, '');

        this.tree_list_data = ajax_result.cloneNode(true);
        xml = this.tree_list_data;

        if (!has_child_nodes(xml)) {
            var error = document.createTextNode((this.name.indexOf('category') == -1 && window.location.href.indexOf('category') == -1) ? '{!NO_ENTRIES;^}' : '{!NO_CATEGORIES;^}');
            html.className = 'red_alert';
            html.appendChild(error);
            return;
        }
    } else // Appending
    {
        xml = this.getElementByIdHack(expanding_id, 'c');
        for (i = 0; i < ajax_result.childNodes.length; i++) {
            temp_node = ajax_result.childNodes[i];
            xml.appendChild(temp_node.cloneNode(true));
        }
        html = document.getElementById(this.name + 'tree_list_c_' + expanding_id);
    }

    attributes_full_fixup(xml);

    this.root_element = this.render_tree(xml, html);

    var name = this.name;
    fixup_node_positions(name);
    //window.setTimeout(function() { fixup_node_positions(name); },500);
};

function attributes_full_fixup(xml) {
    var node, i;
    if (typeof window.attributes_full == 'undefined') window.attributes_full = {};
    var id = xml.getAttribute('id');
    if (typeof window.attributes_full[id] == 'undefined') window.attributes_full[id] = {};
    for (i = 0; i < xml.attributes.length; i++) {
        window.attributes_full[id][xml.attributes[i].name] = xml.attributes[i].value;
    }
    for (i = 0; i < xml.childNodes.length; i++) {
        node = xml.childNodes[i];

        if (node.nodeName == '#text') continue; // A text-node

        if ((node.localName === 'category') || (node.localName === 'entry')) {
            attributes_full_fixup(node);
        }
    }
}

function has_child_nodes(node) {
    for (var i = 0; i < node.childNodes.length; i++) {
        if (node.childNodes[i].nodeName != '#text') return true;
    }
    return false;
}

tree_list.prototype.render_tree = function (xml, html, element) {
    if (!window.fixup_node_positions) {
        return null;
    }

    var i, colour, new_html, url, escaped_title;
    var initially_expanded, selectable, extra, url, title, func, temp, master_html, node, node_self_wrap, node_self;
    if ((typeof element == 'undefined') || (!element)) var element = document.getElementById(this.name);

    clear_transition_and_set_opacity(html, 0.0);
    fade_transition(html, 100, 30, 4);


    html.style.display = 'block';
    if (!has_child_nodes(xml)) {
        html.style.display = 'none';
    }

    for (i = 0; i < xml.childNodes.length; i++) {
        node = xml.childNodes[i];
        if (node.nodeName == '#text') continue; // A text-node

        // Special handling of 'options' nodes, inject new options
        if (node.nodeName == 'options') {
            this.options = window.encodeURIComponent(Composr.dom.html(node));
            continue;
        }

        // Special handling of 'expand' nodes, which say to pre-expand some categories as soon as the page loads
        if (node.nodeName == 'expand') {
            var e = document.getElementById(this.name + 'texp_c_' + Composr.dom.html(node));
            if (e) {
                var html_node = document.getElementById(this.name + 'tree_list_c_' + Composr.dom.html(node));
                var expanding = (html_node.style.display != 'block');
                if (expanding)
                    e.onclick(null, true);
            } else {
                // Now try against serverid
                var xml_node = this.getElementByIdHack(Composr.dom.html(node), 'c', null, true);
                if (xml_node) {
                    var e = document.getElementById(this.name + 'texp_c_' + xml_node.getAttribute('id'));
                    if (e) {
                        var html_node = document.getElementById(this.name + 'tree_list_c_' + xml_node.getAttribute('id'));
                        var expanding = (html_node.style.display != 'block');
                        if (expanding)
                            e.onclick(null, true);
                    }
                }
            }
            continue;
        }

        // Category or entry nodes
        extra = ' ';
        func = node.getAttribute('img_func_1');
        if (func) {
            extra = extra + eval(func + '(node)');
        }
        func = node.getAttribute('img_func_2');
        if (func) {
            extra = extra + eval(func + '(node)');
        }
        node_self_wrap = document.createElement('div');
        node_self = document.createElement('div');
        node_self.style.display = 'inline-block';
        node_self_wrap.appendChild(node_self);
        node_self.object = this;
        colour = (node.getAttribute('selectable') == 'true' || this.all_nodes_selectable) ? 'native_ui_foreground' : 'locked_input_field';
        selectable = (node.getAttribute('selectable') == 'true' || this.all_nodes_selectable);
        if (node.localName === 'category') {
            // Render self
            node_self.className = (node.getAttribute('highlighted') == 'true') ? 'tree_list_highlighted' : 'tree_list_nonhighlighted';
            initially_expanded = (node.getAttribute('has_children') != 'true') || (node.getAttribute('expanded') == 'true');
            escaped_title = escape_html((typeof node.getAttribute('title') != 'undefined') ? node.getAttribute('title') : '');
            if (escaped_title == '') escaped_title = '{!NA_EM;^}';
            var description = '';
            var description_in_use = '';
            if (node.getAttribute('description_html')) {
                description = node.getAttribute('description_html');
                description_in_use = escape_html(description);
            } else {
                if (node.getAttribute('description')) description = escape_html('. ' + node.getAttribute('description'));
                description_in_use = escaped_title + ': {!TREE_LIST_SELECT*;^}' + description + ((node.getAttribute('serverid') == '') ? (' (' + escape_html(node.getAttribute('serverid')) + ')') : '');
            }
            var img_url = Composr.url('{$IMG;,1x/treefield/category}');
            var img_url_2 = Composr.url('{$IMG;,2x/treefield/category}');
            if (node.getAttribute('img_url')) {
                img_url = node.getAttribute('img_url');
                img_url_2 = node.getAttribute('img_url_2');
            }
            Composr.dom.html(node_self, ' \
				<div> \
					<input class="ajax_tree_expand_icon"' + (this.tabindex ? (' tabindex="' + this.tabindex + '"') : '') + ' type="image" alt="' + ((!initially_expanded) ? '{!EXPAND;^}' : '{!CONTRACT;^}') + ': ' + escaped_title + '" title="' + ((!initially_expanded) ? '{!EXPAND;^}' : '{!CONTRACT;^}') + '" id="' + this.name + 'texp_c_' + node.getAttribute('id') + '" src="' + Composr.url(!initially_expanded ? '{$IMG*;,1x/treefield/expand}' : '{$IMG*;,1x/treefield/collapse}') + '" /> \
					<img class="ajax_tree_cat_icon" alt="{!CATEGORY;^}" src="' + escape_html(img_url) + '" srcset="' + escape_html(img_url_2) + ' 2x" /> \
					<label id="' + this.name + 'tsel_c_' + node.getAttribute('id') + '" for="' + this.name + 'tsel_r_' + node.getAttribute('id') + '" onmouseover="activate_tooltip(this,event,' + (node.getAttribute('description_html') ? '' : 'escape_html') + '(this.firstElementChild.title),\'auto\');" class="ajax_tree_magic_button ' + colour + '"><input ' + (this.tabindex ? ('tabindex="' + this.tabindex + '" ') : '') + 'id="' + this.name + 'tsel_r_' + node.getAttribute('id') + '" style="position: absolute; left: -10000px" type="radio" name="_' + this.name + '" value="1" title="' + description_in_use + '" />' + escaped_title + '</label> \
					<span id="' + this.name + 'extra_' + node.getAttribute('id') + '">' + extra + '</span> \
				</div> \
			');
            var expand_button = node_self.getElementsByTagName('input')[0];
            var _this = this;
            expand_button.oncontextmenu = function () {
                return false;
            };
            expand_button.object = this;
            expand_button.onclick = function (expand_button) {
                return function (event, automated) {
                    if (document.getElementById('choose_' + _this.name)) click_link(document.getElementById('choose_' + _this.name));
                    if (event) {
                        if (event.cancelable) event.preventDefault();
                    }
                    _this.handle_tree_click.call(expand_button, event, automated);
                    return false;
                }
            }(expand_button);
            var a = node_self.getElementsByTagName('label')[0];
            expand_button.onkeypress = a.onkeypress = a.firstElementChild.onkeypress = function (expand_button) {
                return function (event) {
                    if (((event.keyCode ? event.keyCode : event.charCode) == 13) || ['+', '-', '='].indexOf(String.fromCharCode(event.keyCode ? event.keyCode : event.charCode)) != -1)
                        expand_button.onclick(event);
                }
            }(expand_button);
            a.oncontextmenu = function () {
                return false;
            };
            a.handle_selection = this.handle_selection;
            a.firstElementChild.onfocus = function () {
                this.parentNode.style.outline = '1px dotted';
            };
            a.firstElementChild.onblur = function () {
                this.parentNode.style.outline = '';
            };
            a.firstElementChild.onclick = a.handle_selection;
            a.onclick = a.handle_selection; // Needed by Firefox, the radio button's onclick will not be called if shift/ctrl held
            a.firstElementChild.object = this;
            a.object = this;
            a.onmousedown = function (event) { // To disable selection of text when holding shift or control
                if (event.ctrlKey || event.metaKey || event.shiftKey) {
                    if (event.cancelable) event.preventDefault();
                }
            };
            html.appendChild(node_self_wrap);

            // Do any children
            new_html = document.createElement('div');
            new_html.role = 'treeitem';
            new_html.id = this.name + 'tree_list_c_' + node.getAttribute('id');
            new_html.style.display = ((!initially_expanded) || (node.getAttribute('has_children') != 'true')) ? 'none' : 'block';
            new_html.style.padding/*{$?,{$EQ,{!en_left},left},Left,Right}*/ = '15px';
            var selected = ((this.use_server_id ? node.getAttribute('serverid') : node.getAttribute('id')) == element.value && element.value != '') || node.getAttribute('selected') == 'yes';
            if (selectable) {
                this.make_element_look_selected(document.getElementById(this.name + 'tsel_c_' + node.getAttribute('id')), selected);
                if (selected) {
                    element.value = (this.use_server_id ? node.getAttribute('serverid') : node.getAttribute('id')); // Copy in proper ID for what is selected, not relying on what we currently have as accurate
                    if (element.value != '') {
                        if (typeof element.selected_title == 'undefined') element.selected_title = '';
                        if (element.selected_title != '') element.selected_title += ',';
                        element.selected_title += node.getAttribute('title');
                    }
                    if (element.onchange) element.onchange();
                    if (typeof element.fakeonchange != 'undefined' && element.fakeonchange) element.fakeonchange();
                }
            }
            node_self.appendChild(new_html);

            // Auto-expand
            if (window.ctrl_pressed || window.alt_pressed || window.meta_pressed || window.shift_pressed) {
                if (!initially_expanded)
                    expand_button.onclick();
            }
        } else // Assume entry
        {
            new_html = null;

            escaped_title = escape_html((typeof node.getAttribute('title') != 'undefined') ? node.getAttribute('title') : '');
            if (escaped_title == '') escaped_title = '{!NA_EM;^}';

            var description = '';
            var description_in_use = '';
            if (node.getAttribute('description_html')) {
                description = node.getAttribute('description_html');
                description_in_use = escape_html(description);
            } else {
                if (node.getAttribute('description')) description = escape_html('. ' + node.getAttribute('description'));
                description_in_use = escaped_title + ': {!TREE_LIST_SELECT*;^}' + description + ((node.getAttribute('serverid') == '') ? (' (' + escape_html(node.getAttribute('serverid')) + ')') : '');
            }

            // Render self
            initially_expanded = false;
            var img_url = Composr.url('{$IMG;,1x/treefield/entry}');
            var img_url_2 = Composr.url('{$IMG;,2x/treefield/entry}');
            if (node.getAttribute('img_url')) {
                img_url = node.getAttribute('img_url');
                img_url_2 = node.getAttribute('img_url_2');
            }
            Composr.dom.html(node_self, '<div><img alt="{!ENTRY;^}" src="' + escape_html(img_url) + '" srcset="' + escape_html(img_url_2) + ' 2x" style="width: 14px; height: 14px" /> <label id="' + this.name + 'tsel_e_' + node.getAttribute('id') + '" class="ajax_tree_magic_button ' + colour + '" for="' + this.name + 'tsel_s_' + node.getAttribute('id') + '" onmouseover="activate_tooltip(this,event,' + (node.getAttribute('description_html') ? '' : 'escape_html') + '(\'' + (description_in_use.replace(/\n/g, '').replace(/'/g, '\\' + '\'')) + '\'),\'800px\');"><input' + (this.tabindex ? (' tabindex="' + this.tabindex + '"') : '') + ' id="' + this.name + 'tsel_s_' + node.getAttribute('id') + '" style="position: absolute; left: -10000px" type="radio" name="_' + this.name + '" value="1" />' + escaped_title + '</label>' + extra + '</div>');
            var a = node_self.getElementsByTagName('label')[0];
            a.handle_selection = this.handle_selection;
            a.firstElementChild.onfocus = function () {
                this.parentNode.style.outline = '1px dotted';
            };
            a.firstElementChild.onblur = function () {
                this.parentNode.style.outline = '';
            };
            a.firstElementChild.onclick = a.handle_selection;
            a.onclick = a.handle_selection; // Needed by Firefox, the radio button's onclick will not be called if shift/ctrl held
            a.firstElementChild.object = this;
            a.object = this;
            a.onmousedown = function (event) { // To disable selection of text when holding shift or control
                if (event.ctrlKey || event.metaKey || event.shiftKey) {
                    if (event.cancelable) event.preventDefault();
                }
            };
            html.appendChild(node_self_wrap);
            var selected = ((this.use_server_id ? node.getAttribute('serverid') : node.getAttribute('id')) == element.value) || node.getAttribute('selected') == 'yes';
            if ((this.multi_selection) && (!selected)) {
                selected = ((',' + element.value + ',').indexOf(',' + node.getAttribute('id') + ',') != -1);
            }
            this.make_element_look_selected(document.getElementById(this.name + 'tsel_e_' + node.getAttribute('id')), selected);
        }

        if ((node.getAttribute('draggable')) && (node.getAttribute('draggable') != 'false')) {
            master_html = document.getElementById('tree_list__root_' + this.name);
            fix_up_node_position(node_self);
            node_self.cms_draggable = node.getAttribute('draggable');
            node_self.draggable = true;
            node_self.ondragstart = function (event) {
                clear_out_tooltips();

                this.className += ' being_dragged';

                window.is_doing_a_drag = true;
            };
            node_self.ondrag = function (event) {
                if (!event.clientY) return;
                var hit = find_overlapping_selectable(event.clientY + window.pageYOffset, this, this.object.tree_list_data, this.object.name);
                if (this.last_hit != null) {
                    this.last_hit.parentNode.parentNode.style.border = '0px';
                }
                if (hit != null) {
                    hit.parentNode.parentNode.style.border = '1px dotted green';
                    this.last_hit = hit;
                }
            };
            node_self.ondragend = function (event) {
                window.is_doing_a_drag = false;

                this.className = this.className.replace(/ being_dragged/g, '');

                if (this.last_hit != null) {
                    this.last_hit.parentNode.parentNode.style.border = '0px';

                    if (this.parentNode.parentNode != this.last_hit) {
                        var xml_node = this.object.getElementByIdHack(this.getElementsByTagName('input')[0].id.substr(7 + this.object.name.length));
                        var target_xml_node = this.object.getElementByIdHack(this.last_hit.id.substr(12 + this.object.name.length));

                        if ((this.last_hit.childNodes.length === 1) && (this.last_hit.childNodes[0].nodeName === '#text')) {
                            Composr.dom.html(this.last_hit, '');
                            this.object.render_tree(target_xml_node, this.last_hit);
                        }

                        // Change HTML
                        this.parentNode.parentNode.removeChild(this.parentNode);
                        this.last_hit.appendChild(this.parentNode);

                        // Change node structure
                        xml_node.parentNode.removeChild(xml_node);
                        target_xml_node.appendChild(xml_node);

                        // Ajax request
                        eval('drag_' + xml_node.getAttribute('draggable') + '("' + xml_node.getAttribute('serverid') + '","' + target_xml_node.getAttribute('serverid') + '")');

                        fixup_node_positions(this.object.name);
                    }
                }
            };
        }

        if ((node.getAttribute('droppable')) && (node.getAttribute('droppable') != 'false')) {
            node_self.ondragover = function (event) {
                if (event.cancelable) event.preventDefault();
            };
            node_self.ondrop = function (event) {
                if (event.cancelable) event.preventDefault();
                // ondragend will call with last_hit set, we don't track the drop spots using this event handler, we track it in real time using mouse coordinate analysis
            };
        }

        if (initially_expanded) {
            this.render_tree(node, new_html, element);
        } else {
            if (new_html) Composr.dom.appendHtml(new_html, '{!PLEASE_WAIT;^}');
        }
    }

    trigger_resize();

    return a;
};

function fixup_node_positions(name) {
    var html = document.getElementById('tree_list__root_' + name);
    var to_fix = html.getElementsByTagName('div');
    var i;
    for (i = 0; i < to_fix.length; i++) {
        if (to_fix[i].style.position == 'absolute') fix_up_node_position(to_fix[i]);
    }
}

function fix_up_node_position(node_self) {
    node_self.style.left = find_pos_x(node_self.parentNode, true) + 'px';
    node_self.style.top = find_pos_y(node_self.parentNode, true) + 'px';
}

function find_overlapping_selectable(mouse_y, element, node, name) // Find drop targets
{
    var i, childNode, temp, child_node_element, y, height;

    // Recursion
    if (node.getAttribute('expanded') !== 'false') {
        for (i = 0; i < node.childNodes.length; i++) {
            childNode = node.childNodes[i];
            if (childNode.nodeName == '#text') continue; // A text-node

            temp = find_overlapping_selectable(mouse_y, element, childNode, name);
            if (temp) return temp;
        }
    }

    if (node.getAttribute('droppable') == element.cms_draggable) {
        child_node_element = document.getElementById(name + 'tree_list_' + ((node.localName === 'category') ? 'c' : 'e') + '_' + node.getAttribute('id'));
        y = find_pos_y(child_node_element.parentNode.parentNode, true);
        height = child_node_element.parentNode.parentNode.offsetHeight;
        if ((y < mouse_y) && (y + height > mouse_y)) {
            return child_node_element;
        }
    }

    return null;
}

tree_list.prototype.handle_tree_click = function (event, automated) // Not called as a method
{
    if (typeof window.do_ajax_request == 'undefined') return false;

    var element = document.getElementById(this.object.name);
    if (element.disabled) return false;

    if (this.object.busy) return false;
    this.object.busy = true;

    var clicked_id = this.getAttribute('id').substr(7 + this.object.name.length);

    var html_node = document.getElementById(this.object.name + 'tree_list_c_' + clicked_id);
    var expand_button = document.getElementById(this.object.name + 'texp_c_' + clicked_id);

    var expanding = (html_node.style.display != 'block');

    if (expanding) {
        var xml_node = this.object.getElementByIdHack(clicked_id, 'c');
        xml_node.setAttribute('expanded', 'true');
        var real_clicked_id = xml_node.getAttribute('serverid');
        if ((typeof real_clicked_id).toLowerCase() != 'string') real_clicked_id = clicked_id;

        /*if ((xml_node.getAttribute('draggable')) && (xml_node.getAttribute('draggable')!='false'))
         {
         html_node.parentNode.style.position='static';
         }*/

        if ((xml_node.getAttribute('has_children') == 'true') && (!has_child_nodes(xml_node))) {
            var url = '{$BASE_URL_NOHTTP;}/' + this.object.ajax_url + '&id=' + window.encodeURIComponent(real_clicked_id) + '&options=' + this.object.options + '&default=' + window.encodeURIComponent(element.value);
            var ob = this.object;
            do_ajax_request(url, function (ajax_result_frame, ajax_result) {
                Composr.dom.html(html_node, '');
                ob.response(ajax_result_frame, ajax_result, clicked_id);
            });
            Composr.dom.html(html_node, '<div aria-busy="true" class="vertical_alignment"><img src="' + Composr.url('{$IMG*;,loading}') + '" alt="" /> <span>{!LOADING;^}</span></div>');
            var container = document.getElementById('tree_list__root_' + ob.name);
            if ((automated) && (container) && (container.style.overflowY == 'auto')) {
                window.setTimeout(function () {
                    container.scrollTop = find_pos_y(html_node) - 20;
                }, 0);
            }
        }

        html_node.style.display = 'block';
        clear_transition_and_set_opacity(html_node, 0.0);
        fade_transition(html_node, 100, 30, 4);


        expand_button.src = Composr.url('{$IMG;,1x/treefield/collapse}');
        expand_button.title = expand_button.title.replace('{!EXPAND;^}', '{!CONTRACT;^}');
        expand_button.alt = expand_button.alt.replace('{!EXPAND;^}', '{!CONTRACT;^}');
    } else {
        var xml_node = this.object.getElementByIdHack(clicked_id, 'c');
        xml_node.setAttribute('expanded', 'false');

        /*if ((xml_node.getAttribute('draggable')) && (xml_node.getAttribute('draggable')!='false'))
         {
         html_node.parentNode.style.position='absolute';
         }*/

        html_node.style.display = 'none';

        expand_button.src = Composr.url('{$IMG;,1x/treefield/expand}');
        expand_button.title = expand_button.title.replace('{!CONTRACT;^}', '{!EXPAND;^}');
        expand_button.alt = expand_button.alt.replace('{!CONTRACT;^}', '{!EXPAND;^}');
    }

    fixup_node_positions(this.object.name);

    trigger_resize();

    this.object.busy = false;

    return true;
};

tree_list.prototype.handle_selection = function (event, assume_ctrl) // Not called as a method
{
    if (typeof assume_ctrl == 'undefined') assume_ctrl = false;

    var element = document.getElementById(this.object.name);
    if (element.disabled) return;
    var i;
    var selected_before = (element.value == '') ? [] : (this.object.multi_selection ? element.value.split(',') : [element.value]);

    cancel_bubbling(event);
    if (event.cancelable) event.preventDefault();

    if ((!assume_ctrl) && (event.shiftKey) && (this.object.multi_selection)) {
        // We're holding down shift so we need to force selection of everything bounded between our last click spot and here
        var all_a = document.getElementById('tree_list__root_' + this.object.name).getElementsByTagName('label');
        var pos_last = -1;
        var pos_us = -1;
        if (this.object.last_clicked == null) this.object.last_clicked = all_a[0];
        for (i = 0; i < all_a.length; i++) {
            if (all_a[i] == this || all_a[i] == this.parentNode) pos_us = i;
            if (all_a[i] == this.object.last_clicked || all_a[i] == this.object.last_clicked.parentNode) pos_last = i;
        }
        if (pos_us < pos_last) // ReOrder them
        {
            var temp = pos_us;
            pos_us = pos_last;
            pos_last = temp;
        }
        var that_selected_id, that_xml_node, that_type;
        for (i = 0; i < all_a.length; i++) {
            that_type = this.getAttribute('id').charAt(5 + this.object.name.length);
            if (that_type == 'r') that_type = 'c';
            if (that_type == 's') that_type = 'e';

            if (all_a[i].getAttribute('id').substr(5 + this.object.name.length, that_type.length) == that_type) {
                that_selected_id = (this.object.use_server_id) ? all_a[i].getAttribute('serverid') : all_a[i].getAttribute('id').substr(7 + this.object.name.length);
                that_xml_node = this.object.getElementByIdHack(that_selected_id, that_type);
                if ((that_xml_node.getAttribute('selectable') == 'true') || (this.object.all_nodes_selectable)) {
                    if ((i >= pos_last) && (i <= pos_us)) {
                        if (selected_before.indexOf(that_selected_id) == -1)
                            all_a[i].handle_selection(event, true);
                    } else {
                        if (selected_before.indexOf(that_selected_id) != -1)
                            all_a[i].handle_selection(event, true);
                    }
                }
            }
        }

        return;
    }
    var type = this.getAttribute('id').charAt(5 + this.object.name.length);
    if (type == 'r') type = 'c';
    if (type == 's') type = 'e';
    var real_selected_id = this.getAttribute('id').substr(7 + this.object.name.length);
    var xml_node = this.object.getElementByIdHack(real_selected_id, type);
    var selected_id = (this.object.use_server_id) ? xml_node.getAttribute('serverid') : real_selected_id;

    if (xml_node.getAttribute('selectable') == 'true' || this.object.all_nodes_selectable) {
        var selected_after = selected_before;
        for (i = 0; i < selected_before.length; i++) {
            this.object.make_element_look_selected(document.getElementById(this.object.name + 'tsel_' + type + '_' + selected_before[i]), false);
        }
        if ((!this.object.multi_selection) || (((!event.ctrlKey) && (!event.metaKey) && (!event.altKey)) && (!assume_ctrl))) {
            selected_after = [];
        }
        if ((selected_before.indexOf(selected_id) != -1) && (((selected_before.length == 1) && (selected_before[0] != selected_id)) || ((event.ctrlKey) || (event.metaKey) || (event.altKey)) || (assume_ctrl))) {
            for (var key in selected_after) {
                if (selected_after[key] == selected_id)
                    selected_after.splice(key, 1);
            }
        } else if (selected_after.indexOf(selected_id) == -1) {
            selected_after.push(selected_id);
            if (!this.object.multi_selection) // This is a bit of a hack to make selection look nice, even though we aren't storing natural IDs of what is selected
            {
                var anchors = document.getElementById('tree_list__root_' + this.object.name).getElementsByTagName('label');
                for (i = 0; i < anchors.length; i++) {
                    this.object.make_element_look_selected(anchors[i], false);
                }
                this.object.make_element_look_selected(document.getElementById(this.object.name + 'tsel_' + type + '_' + real_selected_id), true);
            }
        }
        for (i = 0; i < selected_after.length; i++) {
            this.object.make_element_look_selected(document.getElementById(this.object.name + 'tsel_' + type + '_' + selected_after[i]), true);
        }

        element.value = selected_after.join(',');
        element.selected_title = (selected_after.length == 1) ? xml_node.getAttribute('title') : element.value;
        element.selected_editlink = xml_node.getAttribute('edit');
        if (element.value == '') element.selected_title = '';
        if (element.onchange) element.onchange();
        if (typeof element.fakeonchange != 'undefined' && element.fakeonchange) element.fakeonchange();
    }

    if (/*(!event.ctrlKey) && */(!assume_ctrl)) this.object.last_clicked = this;
};

tree_list.prototype.make_element_look_selected = function (target, selected) {
    if (!target) return;
    if (!selected) {
        target.className = target.className.replace(/ native_ui_selected/g, '');
    } else {
        target.className += ' native_ui_selected';
    }
    target.style.cursor = 'pointer';
};



/*{$,Parser hint: .innerHTML okay}*/
/*{$,Parser hint: pure}*/

/** @license
 *
 * SoundManager 2: JavaScript Sound for the Web
 * ----------------------------------------------
 * http://schillmania.com/projects/soundmanager2/
 *
 * Copyright (c) 2007, Scott Schiller. All rights reserved.
 * Code provided under the BSD License:
 * http://schillmania.com/projects/soundmanager2/license.txt
 *
 * V2.97a.20150601
 */

/*global window, SM2_DEFER, sm2Debugger, console, document, navigator, setTimeout, setInterval, clearInterval, Audio, opera, module, define */
/*jslint regexp: true, sloppy: true, white: true, nomen: true, plusplus: true, todo: true */

(function(window, _undefined) {
    "use strict";
    if (!window || !window.document) {
        throw new Error('SoundManager requires a browser with window and document objects.');
    }
    var soundManager = null;
    function SoundManager(smURL, smID) {
        this.setupOptions = {
            'url': (smURL || null),
            'flashVersion': 8,
            'debugMode': true,
            'debugFlash': false,
            'useConsole': true,
            'consoleOnly': true,
            'waitForWindowLoad': false,
            'bgColor': '#ffffff',
            'useHighPerformance': false,
            'flashPollingInterval': null,
            'html5PollingInterval': null,
            'flashLoadTimeout': 1000,
            'wmode': null,
            'allowScriptAccess': 'always',
            'useFlashBlock': false,
            'useHTML5Audio': true,
            'forceUseGlobalHTML5Audio': false,
            'ignoreMobileRestrictions': false,
            'html5Test': /^(probably|maybe)$/i,
            'preferFlash': false,
            'noSWFCache': false,
            'idPrefix': 'sound'
        };
        this.defaultOptions = {
            'autoLoad': false,
            'autoPlay': false,
            'from': null,
            'loops': 1,
            'onid3': null,
            'onload': null,
            'whileloading': null,
            'onplay': null,
            'onpause': null,
            'onresume': null,
            'whileplaying': null,
            'onposition': null,
            'onstop': null,
            'onfailure': null,
            'onfinish': null,
            'multiShot': true,
            'multiShotEvents': false,
            'position': null,
            'pan': 0,
            'stream': true,
            'to': null,
            'type': null,
            'usePolicyFile': false,
            'volume': 100
        };
        this.flash9Options = {
            'isMovieStar': null,
            'usePeakData': false,
            'useWaveformData': false,
            'useEQData': false,
            'onbufferchange': null,
            'ondataerror': null
        };
        this.movieStarOptions = {
            'bufferTime': 3,
            'serverURL': null,
            'onconnect': null,
            'duration': null
        };
        this.audioFormats = {
            'mp3': {
                'type': ['audio/mpeg; codecs="mp3"', 'audio/mpeg', 'audio/mp3', 'audio/MPA', 'audio/mpa-robust'],
                'required': true
            },
            'mp4': {
                'related': ['aac','m4a','m4b'],
                'type': ['audio/mp4; codecs="mp4a.40.2"', 'audio/aac', 'audio/x-m4a', 'audio/MP4A-LATM', 'audio/mpeg4-generic'],
                'required': false
            },
            'ogg': {
                'type': ['audio/ogg; codecs=vorbis'],
                'required': false
            },
            'opus': {
                'type': ['audio/ogg; codecs=opus', 'audio/opus'],
                'required': false
            },
            'wav': {
                'type': ['audio/wav; codecs="1"', 'audio/wav', 'audio/wave', 'audio/x-wav'],
                'required': false
            }
        };
        this.movieID = 'sm2-container';
        this.id = (smID || 'sm2movie');
        this.debugID = 'soundmanager-debug';
        this.debugURLParam = /([#?&])debug=1/i;
        this.versionNumber = 'V2.97a.20150601';
        this.version = null;
        this.movieURL = null;
        this.altURL = null;
        this.swfLoaded = false;
        this.enabled = false;
        this.oMC = null;
        this.sounds = {};
        this.soundIDs = [];
        this.muted = false;
        this.didFlashBlock = false;
        this.filePattern = null;
        this.filePatterns = {
            'flash8': /\.mp3(\?.*)?$/i,
            'flash9': /\.mp3(\?.*)?$/i
        };
        this.features = {
            'buffering': false,
            'peakData': false,
            'waveformData': false,
            'eqData': false,
            'movieStar': false
        };
        this.sandbox = {
        };
        this.html5 = {
            'usingFlash': null
        };
        this.flash = {};
        this.html5Only = false;
        this.ignoreFlash = false;
        var SMSound,
            sm2 = this, globalHTML5Audio = null, flash = null, sm = 'soundManager', smc = sm + ': ', h5 = 'HTML5::', id, ua = navigator.userAgent, wl = window.location.href.toString(), doc = document, doNothing, setProperties, init, fV, on_queue = [], debugOpen = true, debugTS, didAppend = false, appendSuccess = false, didInit = false, disabled = false, windowLoaded = false, _wDS, wdCount = 0, initComplete, mixin, assign, extraOptions, addOnEvent, processOnEvents, initUserOnload, delayWaitForEI, waitForEI, rebootIntoHTML5, setVersionInfo, handleFocus, strings, initMovie, domContentLoaded, winOnLoad, didDCLoaded, getDocument, createMovie, catchError, setPolling, initDebug, debugLevels = ['log', 'info', 'warn', 'error'], defaultFlashVersion = 8, disableObject, failSafely, normalizeMovieURL, oRemoved = null, oRemovedHTML = null, str, flashBlockHandler, getSWFCSS, swfCSS, toggleDebug, loopFix, policyFix, complain, idCheck, waitingForEI = false, initPending = false, startTimer, stopTimer, timerExecute, h5TimerCount = 0, h5IntervalTimer = null, parseURL, messages = [],
            canIgnoreFlash, needsFlash = null, featureCheck, html5OK, html5CanPlay, html5Ext, html5Unload, domContentLoadedIE, testHTML5, event, slice = Array.prototype.slice, useGlobalHTML5Audio = false, lastGlobalHTML5URL, hasFlash, detectFlash, badSafariFix, html5_events, showSupport, flushMessages, wrapCallback, idCounter = 0, didSetup, msecScale = 1000,
            is_iDevice = ua.match(/(ipad|iphone|ipod)/i), isAndroid = ua.match(/android/i), isIE = ua.match(/msie/i),
            isWebkit = ua.match(/webkit/i),
            isSafari = (ua.match(/safari/i) && !ua.match(/chrome/i)),
            isOpera = (ua.match(/opera/i)),
            mobileHTML5 = (ua.match(/(mobile|pre\/|xoom)/i) || is_iDevice || isAndroid),
            isBadSafari = (!wl.match(/usehtml5audio/i) && !wl.match(/sm2\-ignorebadua/i) && isSafari && !ua.match(/silk/i) && ua.match(/OS X 10_6_([3-7])/i)),
            hasConsole = (window.console !== _undefined && console.log !== _undefined),
            isFocused = (doc.hasFocus !== _undefined ? doc.hasFocus() : null),
            tryInitOnFocus = (isSafari && (doc.hasFocus === _undefined || !doc.hasFocus())),
            okToDisable = !tryInitOnFocus,
            flashMIME = /(mp3|mp4|mpa|m4a|m4b)/i,
            emptyURL = 'about:blank',
            emptyWAV = 'data:audio/wave;base64,/UklGRiYAAABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YQIAAAD//w==',
            overHTTP = (doc.location ? doc.location.protocol.match(/http/i) : null),
            http = (!overHTTP ? 'http:/'+'/' : ''),
            netStreamMimeTypes = /^\s*audio\/(?:x-)?(?:mpeg4|aac|flv|mov|mp4||m4v|m4a|m4b|mp4v|3gp|3g2)\s*(?:$|;)/i,
            netStreamTypes = ['mpeg4', 'aac', 'flv', 'mov', 'mp4', 'm4v', 'f4v', 'm4a', 'm4b', 'mp4v', '3gp', '3g2'],
            netStreamPattern = new RegExp('\\.(' + netStreamTypes.join('|') + ')(\\?.*)?$', 'i');
        this.mimePattern = /^\s*audio\/(?:x-)?(?:mp(?:eg|3))\s*(?:$|;)/i;
        this.useAltURL = !overHTTP;
        swfCSS = {
            'swfBox': 'sm2-object-box',
            'swfDefault': 'movieContainer',
            'swfError': 'swf_error',
            'swfTimedout': 'swf_timedout',
            'swfLoaded': 'swf_loaded',
            'swfUnblocked': 'swf_unblocked',
            'sm2Debug': 'sm2_debug',
            'highPerf': 'high_performance',
            'flashDebug': 'flash_debug'
        };
        this.hasHTML5 = (function() {
            try {
                return (Audio !== _undefined && (isOpera && opera !== _undefined && opera.version() < 10 ? new Audio(null) : new Audio()).canPlayType !== _undefined);
            } catch(e) {
                return false;
            }
        }());
        this.setup = function(options) {
            var noURL = (!sm2.url);
            if (options !== _undefined && didInit && needsFlash && sm2.ok() && (options.flashVersion !== _undefined || options.url !== _undefined || options.html5Test !== _undefined)) {
            }
            assign(options);
            if (!useGlobalHTML5Audio) {
                if (mobileHTML5) {
                    if (!sm2.setupOptions.ignoreMobileRestrictions || sm2.setupOptions.forceUseGlobalHTML5Audio) {
                        messages.push(strings.globalHTML5);
                        useGlobalHTML5Audio = true;
                    }
                } else {
                    if (sm2.setupOptions.forceUseGlobalHTML5Audio) {
                        messages.push(strings.globalHTML5);
                        useGlobalHTML5Audio = true;
                    }
                }
            }
            if (!didSetup && mobileHTML5) {
                if (sm2.setupOptions.ignoreMobileRestrictions) {
                    messages.push(strings.ignoreMobile);
                } else {
                    sm2.setupOptions.useHTML5Audio = true;
                    sm2.setupOptions.preferFlash = false;
                    if (is_iDevice) {
                        sm2.ignoreFlash = true;
                    } else if ((isAndroid && !ua.match(/android\s2\.3/i)) || !isAndroid) {
                        useGlobalHTML5Audio = true;
                    }
                }
            }
            if (options) {
                if (noURL && didDCLoaded && options.url !== _undefined) {
                    sm2.beginDelayedInit();
                }
                if (!didDCLoaded && options.url !== _undefined && doc.readyState === 'complete') {
                    setTimeout(domContentLoaded, 1);
                }
            }
            didSetup = true;
            return sm2;
        };
        this.ok = function() {
            return (needsFlash ? (didInit && !disabled) : (sm2.useHTML5Audio && sm2.hasHTML5));
        };
        this.supported = this.ok;
        this.getMovie = function(smID) {
            return id(smID) || doc[smID] || window[smID];
        };
        this.createSound = function(oOptions, _url) {
            var cs, cs_string, options, oSound = null;
            if (!didInit || !sm2.ok()) {
                return false;
            }
            if (_url !== _undefined) {
                oOptions = {
                    'id': oOptions,
                    'url': _url
                };
            }
            options = mixin(oOptions);
            options.url = parseURL(options.url);
            if (options.id === _undefined) {
                options.id = sm2.setupOptions.idPrefix + (idCounter++);
            }
            if (idCheck(options.id, true)) {
                return sm2.sounds[options.id];
            }
            function make() {
                options = loopFix(options);
                sm2.sounds[options.id] = new SMSound(options);
                sm2.soundIDs.push(options.id);
                return sm2.sounds[options.id];
            }
            if (html5OK(options)) {
                oSound = make();
                oSound._setup_html5(options);
            } else {
                if (sm2.html5Only) {
                    return make();
                }
                if (sm2.html5.usingFlash && options.url && options.url.match(/data\:/i)) {
                    return make();
                }
                if (fV > 8) {
                    if (options.isMovieStar === null) {
                        options.isMovieStar = !!(options.serverURL || (options.type ? options.type.match(netStreamMimeTypes) : false) || (options.url && options.url.match(netStreamPattern)));
                    }
                }
                options = policyFix(options, cs);
                oSound = make();
                if (fV === 8) {
                    flash._createSound(options.id, options.loops || 1, options.usePolicyFile);
                } else {
                    flash._createSound(options.id, options.url, options.usePeakData, options.useWaveformData, options.useEQData, options.isMovieStar, (options.isMovieStar ? options.bufferTime : false), options.loops || 1, options.serverURL, options.duration || null, options.autoPlay, true, options.autoLoad, options.usePolicyFile);
                    if (!options.serverURL) {
                        oSound.connected = true;
                        if (options.onconnect) {
                            options.onconnect.apply(oSound);
                        }
                    }
                }
                if (!options.serverURL && (options.autoLoad || options.autoPlay)) {
                    oSound.load(options);
                }
            }
            if (!options.serverURL && options.autoPlay) {
                oSound.play();
            }
            return oSound;
        };
        this.destroySound = function(sID, _bFromSound) {
            if (!idCheck(sID)) {
                return false;
            }
            var oS = sm2.sounds[sID], i;
            oS.stop();
            oS._iO = {};
            oS.unload();
            for (i = 0; i < sm2.soundIDs.length; i++) {
                if (sm2.soundIDs[i] === sID) {
                    sm2.soundIDs.splice(i, 1);
                    break;
                }
            }
            if (!_bFromSound) {
                oS.destruct(true);
            }
            oS = null;
            delete sm2.sounds[sID];
            return true;
        };
        this.load = function(sID, oOptions) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].load(oOptions);
        };
        this.unload = function(sID) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].unload();
        };
        this.onPosition = function(sID, nPosition, oMethod, oScope) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].onposition(nPosition, oMethod, oScope);
        };
        this.onposition = this.onPosition;
        this.clearOnPosition = function(sID, nPosition, oMethod) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].clearOnPosition(nPosition, oMethod);
        };
        this.play = function(sID, oOptions) {
            var result = null,
                overloaded = (oOptions && !(oOptions instanceof Object));
            if (!didInit || !sm2.ok()) {
                return false;
            }
            if (!idCheck(sID, overloaded)) {
                if (!overloaded) {
                    return false;
                }
                if (overloaded) {
                    oOptions = {
                        url: oOptions
                    };
                }
                if (oOptions && oOptions.url) {
                    oOptions.id = sID;
                    result = sm2.createSound(oOptions).play();
                }
            } else if (overloaded) {
                oOptions = {
                    url: oOptions
                };
            }
            if (result === null) {
                result = sm2.sounds[sID].play(oOptions);
            }
            return result;
        };
        this.start = this.play;
        this.setPosition = function(sID, nMsecOffset) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].setPosition(nMsecOffset);
        };
        this.stop = function(sID) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].stop();
        };
        this.stopAll = function() {
            var oSound;
            for (oSound in sm2.sounds) {
                if (sm2.sounds.hasOwnProperty(oSound)) {
                    sm2.sounds[oSound].stop();
                }
            }
        };
        this.pause = function(sID) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].pause();
        };
        this.pauseAll = function() {
            var i;
            for (i = sm2.soundIDs.length - 1; i >= 0; i--) {
                sm2.sounds[sm2.soundIDs[i]].pause();
            }
        };
        this.resume = function(sID) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].resume();
        };
        this.resumeAll = function() {
            var i;
            for (i = sm2.soundIDs.length- 1 ; i >= 0; i--) {
                sm2.sounds[sm2.soundIDs[i]].resume();
            }
        };
        this.togglePause = function(sID) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].togglePause();
        };
        this.setPan = function(sID, nPan) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].setPan(nPan);
        };
        this.setVolume = function(sID, nVol) {
            var i, j;
            if (sID !== _undefined && !isNaN(sID) && nVol === _undefined) {
                for (i = 0, j = sm2.soundIDs.length; i < j; i++) {
                    sm2.sounds[sm2.soundIDs[i]].setVolume(sID);
                }
                return;
            }
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].setVolume(nVol);
        };
        this.mute = function(sID) {
            var i = 0;
            if (sID instanceof String) {
                sID = null;
            }
            if (!sID) {
                for (i = sm2.soundIDs.length - 1; i >= 0; i--) {
                    sm2.sounds[sm2.soundIDs[i]].mute();
                }
                sm2.muted = true;
            } else {
                if (!idCheck(sID)) {
                    return false;
                }
                return sm2.sounds[sID].mute();
            }
            return true;
        };
        this.muteAll = function() {
            sm2.mute();
        };
        this.unmute = function(sID) {
            var i;
            if (sID instanceof String) {
                sID = null;
            }
            if (!sID) {
                for (i = sm2.soundIDs.length - 1; i >= 0; i--) {
                    sm2.sounds[sm2.soundIDs[i]].unmute();
                }
                sm2.muted = false;
            } else {
                if (!idCheck(sID)) {
                    return false;
                }
                return sm2.sounds[sID].unmute();
            }
            return true;
        };
        this.unmuteAll = function() {
            sm2.unmute();
        };
        this.toggleMute = function(sID) {
            if (!idCheck(sID)) {
                return false;
            }
            return sm2.sounds[sID].toggleMute();
        };
        this.getMemoryUse = function() {
            var ram = 0;
            if (flash && fV !== 8) {
                ram = parseInt(flash._getMemoryUse(), 10);
            }
            return ram;
        };
        this.disable = function(bNoDisable) {
            var i;
            if (bNoDisable === _undefined) {
                bNoDisable = false;
            }
            if (disabled) {
                return false;
            }
            disabled = true;
            for (i = sm2.soundIDs.length - 1; i >= 0; i--) {
                disableObject(sm2.sounds[sm2.soundIDs[i]]);
            }
            initComplete(bNoDisable);
            event.remove(window, 'load', initUserOnload);
            return true;
        };
        this.canPlayMIME = function(sMIME) {
            var result;
            if (sm2.hasHTML5) {
                result = html5CanPlay({
                    type: sMIME
                });
            }
            if (!result && needsFlash) {
                result = (sMIME && sm2.ok() ? !!((fV > 8 ? sMIME.match(netStreamMimeTypes) : null) || sMIME.match(sm2.mimePattern)) : null);
            }
            return result;
        };
        this.canPlayURL = function(sURL) {
            var result;
            if (sm2.hasHTML5) {
                result = html5CanPlay({
                    url: sURL
                });
            }
            if (!result && needsFlash) {
                result = (sURL && sm2.ok() ? !!(sURL.match(sm2.filePattern)) : null);
            }
            return result;
        };
        this.canPlayLink = function(oLink) {
            if (oLink.type !== _undefined && oLink.type) {
                if (sm2.canPlayMIME(oLink.type)) {
                    return true;
                }
            }
            return sm2.canPlayURL(oLink.href);
        };
        this.getSoundById = function(sID, _suppressDebug) {
            if (!sID) {
                return null;
            }
            var result = sm2.sounds[sID];
            return result;
        };
        this.onready = function(oMethod, oScope) {
            var sType = 'onready',
                result = false;
            if (typeof oMethod === 'function') {
                if (!oScope) {
                    oScope = window;
                }
                addOnEvent(sType, oMethod, oScope);
                processOnEvents();
                result = true;
            } else {
                throw str('needFunction', sType);
            }
            return result;
        };
        this.ontimeout = function(oMethod, oScope) {
            var sType = 'ontimeout',
                result = false;
            if (typeof oMethod === 'function') {
                if (!oScope) {
                    oScope = window;
                }
                addOnEvent(sType, oMethod, oScope);
                processOnEvents({type:sType});
                result = true;
            } else {
                throw str('needFunction', sType);
            }
            return result;
        };
        this._writeDebug = function(sText, sTypeOrObject) {
            return true;
        };
        this._wD = this._writeDebug;
        this._debug = function() {
        };
        this.reboot = function(resetEvents, excludeInit) {
            var i, j, k;
            for (i = sm2.soundIDs.length- 1 ; i >= 0; i--) {
                sm2.sounds[sm2.soundIDs[i]].destruct();
            }
            if (flash) {
                try {
                    if (isIE) {
                        oRemovedHTML = flash.innerHTML;
                    }
                    oRemoved = flash.parentNode.removeChild(flash);
                } catch(e) {
                }
            }
            oRemovedHTML = oRemoved = needsFlash = flash = null;
            sm2.enabled = didDCLoaded = didInit = waitingForEI = initPending = didAppend = appendSuccess = disabled = useGlobalHTML5Audio = sm2.swfLoaded = false;
            sm2.soundIDs = [];
            sm2.sounds = {};
            idCounter = 0;
            didSetup = false;
            if (!resetEvents) {
                for (i in on_queue) {
                    if (on_queue.hasOwnProperty(i)) {
                        for (j = 0, k = on_queue[i].length; j < k; j++) {
                            on_queue[i][j].fired = false;
                        }
                    }
                }
            } else {
                on_queue = [];
            }
            sm2.html5 = {
                'usingFlash': null
            };
            sm2.flash = {};
            sm2.html5Only = false;
            sm2.ignoreFlash = false;
            window.setTimeout(function() {
                if (!excludeInit) {
                    sm2.beginDelayedInit();
                }
            }, 20);
            return sm2;
        };
        this.reset = function() {
            return sm2.reboot(true, true);
        };
        this.getMoviePercent = function() {
            return (flash && 'PercentLoaded' in flash ? flash.PercentLoaded() : null);
        };
        this.beginDelayedInit = function() {
            windowLoaded = true;
            domContentLoaded();
            setTimeout(function() {
                if (initPending) {
                    return false;
                }
                createMovie();
                initMovie();
                initPending = true;
                return true;
            }, 20);
            delayWaitForEI();
        };
        this.destruct = function() {
            sm2.disable(true);
        };
        SMSound = function(oOptions) {
            var s = this, resetProperties, add_html5_events, remove_html5_events, stop_html5_timer, start_html5_timer, attachOnPosition, onplay_called = false, onPositionItems = [], onPositionFired = 0, detachOnPosition, applyFromTo, lastURL = null, lastHTML5State, urlOmitted;
            lastHTML5State = {
                duration: null,
                time: null
            };
            this.id = oOptions.id;
            this.sID = this.id;
            this.url = oOptions.url;
            this.options = mixin(oOptions);
            this.instanceOptions = this.options;
            this._iO = this.instanceOptions;
            this.pan = this.options.pan;
            this.volume = this.options.volume;
            this.isHTML5 = false;
            this._a = null;
            urlOmitted = (this.url ? false : true);
            this.id3 = {};
            this._debug = function() {
            };
            this.load = function(oOptions) {
                var oSound = null, instanceOptions;
                if (oOptions !== _undefined) {
                    s._iO = mixin(oOptions, s.options);
                } else {
                    oOptions = s.options;
                    s._iO = oOptions;
                    if (lastURL && lastURL !== s.url) {
                        s._iO.url = s.url;
                        s.url = null;
                    }
                }
                if (!s._iO.url) {
                    s._iO.url = s.url;
                }
                s._iO.url = parseURL(s._iO.url);
                s.instanceOptions = s._iO;
                instanceOptions = s._iO;
                if (!instanceOptions.url && !s.url) {
                    return s;
                }
                if (instanceOptions.url === s.url && s.readyState !== 0 && s.readyState !== 2) {
                    if (s.readyState === 3 && instanceOptions.onload) {
                        wrapCallback(s, function() {
                            instanceOptions.onload.apply(s, [(!!s.duration)]);
                        });
                    }
                    return s;
                }
                s.loaded = false;
                s.readyState = 1;
                s.playState = 0;
                s.id3 = {};
                if (html5OK(instanceOptions)) {
                    oSound = s._setup_html5(instanceOptions);
                    if (!oSound._called_load) {
                        s._html5_canplay = false;
                        if (s.url !== instanceOptions.url) {
                            s._a.src = instanceOptions.url;
                            s.setPosition(0);
                        }
                        s._a.autobuffer = 'auto';
                        s._a.preload = 'auto';
                        s._a._called_load = true;
                    } else {
                    }
                } else {
                    if (sm2.html5Only) {
                        return s;
                    }
                    if (s._iO.url && s._iO.url.match(/data\:/i)) {
                        return s;
                    }
                    try {
                        s.isHTML5 = false;
                        s._iO = policyFix(loopFix(instanceOptions));
                        if (s._iO.autoPlay && (s._iO.position || s._iO.from)) {
                            s._iO.autoPlay = false;
                        }
                        instanceOptions = s._iO;
                        if (fV === 8) {
                            flash._load(s.id, instanceOptions.url, instanceOptions.stream, instanceOptions.autoPlay, instanceOptions.usePolicyFile);
                        } else {
                            flash._load(s.id, instanceOptions.url, !!(instanceOptions.stream), !!(instanceOptions.autoPlay), instanceOptions.loops || 1, !!(instanceOptions.autoLoad), instanceOptions.usePolicyFile);
                        }
                    } catch(e) {
                        catchError({
                            type: 'SMSOUND_LOAD_JS_EXCEPTION',
                            fatal: true
                        });
                    }
                }
                s.url = instanceOptions.url;
                return s;
            };
            this.unload = function() {
                if (s.readyState !== 0) {
                    if (!s.isHTML5) {
                        if (fV === 8) {
                            flash._unload(s.id, emptyURL);
                        } else {
                            flash._unload(s.id);
                        }
                    } else {
                        stop_html5_timer();
                        if (s._a) {
                            s._a.pause();
                            lastURL = html5Unload(s._a);
                        }
                    }
                    resetProperties();
                }
                return s;
            };
            this.destruct = function(_bFromSM) {
                if (!s.isHTML5) {
                    s._iO.onfailure = null;
                    flash._destroySound(s.id);
                } else {
                    stop_html5_timer();
                    if (s._a) {
                        s._a.pause();
                        html5Unload(s._a);
                        if (!useGlobalHTML5Audio) {
                            remove_html5_events();
                        }
                        s._a._s = null;
                        s._a = null;
                    }
                }
                if (!_bFromSM) {
                    sm2.destroySound(s.id, true);
                }
            };
            this.play = function(oOptions, _updatePlayState) {
                var fN, allowMulti, a, onready,
                    audioClone, onended, oncanplay,
                    startOK = true,
                    exit = null;
                _updatePlayState = (_updatePlayState === _undefined ? true : _updatePlayState);
                if (!oOptions) {
                    oOptions = {};
                }
                if (s.url) {
                    s._iO.url = s.url;
                }
                s._iO = mixin(s._iO, s.options);
                s._iO = mixin(oOptions, s._iO);
                s._iO.url = parseURL(s._iO.url);
                s.instanceOptions = s._iO;
                if (!s.isHTML5 && s._iO.serverURL && !s.connected) {
                    if (!s.getAutoPlay()) {
                        s.setAutoPlay(true);
                    }
                    return s;
                }
                if (html5OK(s._iO)) {
                    s._setup_html5(s._iO);
                    start_html5_timer();
                }
                if (s.playState === 1 && !s.paused) {
                    allowMulti = s._iO.multiShot;
                    if (!allowMulti) {
                        if (s.isHTML5) {
                            s.setPosition(s._iO.position);
                        }
                        exit = s;
                    } else {
                    }
                }
                if (exit !== null) {
                    return exit;
                }
                if (oOptions.url && oOptions.url !== s.url) {
                    if (!s.readyState && !s.isHTML5 && fV === 8 && urlOmitted) {
                        urlOmitted = false;
                    } else {
                        s.load(s._iO);
                    }
                }
                if (!s.loaded) {
                    if (s.readyState === 0) {
                        if (!s.isHTML5 && !sm2.html5Only) {
                            s._iO.autoPlay = true;
                            s.load(s._iO);
                        } else if (s.isHTML5) {
                            s.load(s._iO);
                        } else {
                            exit = s;
                        }
                        s.instanceOptions = s._iO;
                    } else if (s.readyState === 2) {
                        exit = s;
                    } else {
                    }
                } else {
                }
                if (exit !== null) {
                    return exit;
                }
                if (!s.isHTML5 && fV === 9 && s.position > 0 && s.position === s.duration) {
                    oOptions.position = 0;
                }
                if (s.paused && s.position >= 0 && (!s._iO.serverURL || s.position > 0)) {
                    s.resume();
                } else {
                    s._iO = mixin(oOptions, s._iO);
                    if (((!s.isHTML5 && s._iO.position !== null && s._iO.position > 0) || (s._iO.from !== null && s._iO.from > 0) || s._iO.to !== null) && s.instanceCount === 0 && s.playState === 0 && !s._iO.serverURL) {
                        onready = function() {
                            s._iO = mixin(oOptions, s._iO);
                            s.play(s._iO);
                        };
                        if (s.isHTML5 && !s._html5_canplay) {
                            s.load({
                                _oncanplay: onready
                            });
                            exit = false;
                        } else if (!s.isHTML5 && !s.loaded && (!s.readyState || s.readyState !== 2)) {
                            s.load({
                                onload: onready
                            });
                            exit = false;
                        }
                        if (exit !== null) {
                            return exit;
                        }
                        s._iO = applyFromTo();
                    }
                    if (!s.instanceCount || s._iO.multiShotEvents || (s.isHTML5 && s._iO.multiShot && !useGlobalHTML5Audio) || (!s.isHTML5 && fV > 8 && !s.getAutoPlay())) {
                        s.instanceCount++;
                    }
                    if (s._iO.onposition && s.playState === 0) {
                        attachOnPosition(s);
                    }
                    s.playState = 1;
                    s.paused = false;
                    s.position = (s._iO.position !== _undefined && !isNaN(s._iO.position) ? s._iO.position : 0);
                    if (!s.isHTML5) {
                        s._iO = policyFix(loopFix(s._iO));
                    }
                    if (s._iO.onplay && _updatePlayState) {
                        s._iO.onplay.apply(s);
                        onplay_called = true;
                    }
                    s.setVolume(s._iO.volume, true);
                    s.setPan(s._iO.pan, true);
                    if (!s.isHTML5) {
                        startOK = flash._start(s.id, s._iO.loops || 1, (fV === 9 ? s.position : s.position / msecScale), s._iO.multiShot || false);
                        if (fV === 9 && !startOK) {
                            if (s._iO.onplayerror) {
                                s._iO.onplayerror.apply(s);
                            }
                        }
                    } else {
                        if (s.instanceCount < 2) {
                            start_html5_timer();
                            a = s._setup_html5();
                            s.setPosition(s._iO.position);
                            a.play();
                        } else {
                            audioClone = new Audio(s._iO.url);
                            onended = function() {
                                event.remove(audioClone, 'ended', onended);
                                s._onfinish(s);
                                html5Unload(audioClone);
                                audioClone = null;
                            };
                            oncanplay = function() {
                                event.remove(audioClone, 'canplay', oncanplay);
                                try {
                                    audioClone.currentTime = s._iO.position/msecScale;
                                } catch(err) {
                                }
                                audioClone.play();
                            };
                            event.add(audioClone, 'ended', onended);
                            if (s._iO.volume !== _undefined) {
                                audioClone.volume = Math.max(0, Math.min(1, s._iO.volume/100));
                            }
                            if (s.muted) {
                                audioClone.muted = true;
                            }
                            if (s._iO.position) {
                                event.add(audioClone, 'canplay', oncanplay);
                            } else {
                                audioClone.play();
                            }
                        }
                    }
                }
                return s;
            };
            this.start = this.play;
            this.stop = function(bAll) {
                var instanceOptions = s._iO,
                    originalPosition;
                if (s.playState === 1) {
                    s._onbufferchange(0);
                    s._resetOnPosition(0);
                    s.paused = false;
                    if (!s.isHTML5) {
                        s.playState = 0;
                    }
                    detachOnPosition();
                    if (instanceOptions.to) {
                        s.clearOnPosition(instanceOptions.to);
                    }
                    if (!s.isHTML5) {
                        flash._stop(s.id, bAll);
                        if (instanceOptions.serverURL) {
                            s.unload();
                        }
                    } else {
                        if (s._a) {
                            originalPosition = s.position;
                            s.setPosition(0);
                            s.position = originalPosition;
                            s._a.pause();
                            s.playState = 0;
                            s._onTimer();
                            stop_html5_timer();
                        }
                    }
                    s.instanceCount = 0;
                    s._iO = {};
                    if (instanceOptions.onstop) {
                        instanceOptions.onstop.apply(s);
                    }
                }
                return s;
            };
            this.setAutoPlay = function(autoPlay) {
                s._iO.autoPlay = autoPlay;
                if (!s.isHTML5) {
                    flash._setAutoPlay(s.id, autoPlay);
                    if (autoPlay) {
                        if (!s.instanceCount && s.readyState === 1) {
                            s.instanceCount++;
                        }
                    }
                }
            };
            this.getAutoPlay = function() {
                return s._iO.autoPlay;
            };
            this.setPosition = function(nMsecOffset) {
                if (nMsecOffset === _undefined) {
                    nMsecOffset = 0;
                }
                var position, position1K,
                    offset = (s.isHTML5 ? Math.max(nMsecOffset, 0) : Math.min(s.duration || s._iO.duration, Math.max(nMsecOffset, 0)));
                s.position = offset;
                position1K = s.position/msecScale;
                s._resetOnPosition(s.position);
                s._iO.position = offset;
                if (!s.isHTML5) {
                    position = (fV === 9 ? s.position : position1K);
                    if (s.readyState && s.readyState !== 2) {
                        flash._setPosition(s.id, position, (s.paused || !s.playState), s._iO.multiShot);
                    }
                } else if (s._a) {
                    if (s._html5_canplay) {
                        if (s._a.currentTime !== position1K) {
                            try {
                                s._a.currentTime = position1K;
                                if (s.playState === 0 || s.paused) {
                                    s._a.pause();
                                }
                            } catch(e) {
                            }
                        }
                    } else if (position1K) {
                        return s;
                    }
                    if (s.paused) {
                        s._onTimer(true);
                    }
                }
                return s;
            };
            this.pause = function(_bCallFlash) {
                if (s.paused || (s.playState === 0 && s.readyState !== 1)) {
                    return s;
                }
                s.paused = true;
                if (!s.isHTML5) {
                    if (_bCallFlash || _bCallFlash === _undefined) {
                        flash._pause(s.id, s._iO.multiShot);
                    }
                } else {
                    s._setup_html5().pause();
                    stop_html5_timer();
                }
                if (s._iO.onpause) {
                    s._iO.onpause.apply(s);
                }
                return s;
            };
            this.resume = function() {
                var instanceOptions = s._iO;
                if (!s.paused) {
                    return s;
                }
                s.paused = false;
                s.playState = 1;
                if (!s.isHTML5) {
                    if (instanceOptions.isMovieStar && !instanceOptions.serverURL) {
                        s.setPosition(s.position);
                    }
                    flash._pause(s.id, instanceOptions.multiShot);
                } else {
                    s._setup_html5().play();
                    start_html5_timer();
                }
                if (!onplay_called && instanceOptions.onplay) {
                    instanceOptions.onplay.apply(s);
                    onplay_called = true;
                } else if (instanceOptions.onresume) {
                    instanceOptions.onresume.apply(s);
                }
                return s;
            };
            this.togglePause = function() {
                if (s.playState === 0) {
                    s.play({
                        position: (fV === 9 && !s.isHTML5 ? s.position : s.position / msecScale)
                    });
                    return s;
                }
                if (s.paused) {
                    s.resume();
                } else {
                    s.pause();
                }
                return s;
            };
            this.setPan = function(nPan, bInstanceOnly) {
                if (nPan === _undefined) {
                    nPan = 0;
                }
                if (bInstanceOnly === _undefined) {
                    bInstanceOnly = false;
                }
                if (!s.isHTML5) {
                    flash._setPan(s.id, nPan);
                }
                s._iO.pan = nPan;
                if (!bInstanceOnly) {
                    s.pan = nPan;
                    s.options.pan = nPan;
                }
                return s;
            };
            this.setVolume = function(nVol, _bInstanceOnly) {
                if (nVol === _undefined) {
                    nVol = 100;
                }
                if (_bInstanceOnly === _undefined) {
                    _bInstanceOnly = false;
                }
                if (!s.isHTML5) {
                    flash._setVolume(s.id, (sm2.muted && !s.muted) || s.muted ? 0 : nVol);
                } else if (s._a) {
                    if (sm2.muted && !s.muted) {
                        s.muted = true;
                        s._a.muted = true;
                    }
                    s._a.volume = Math.max(0, Math.min(1, nVol/100));
                }
                s._iO.volume = nVol;
                if (!_bInstanceOnly) {
                    s.volume = nVol;
                    s.options.volume = nVol;
                }
                return s;
            };
            this.mute = function() {
                s.muted = true;
                if (!s.isHTML5) {
                    flash._setVolume(s.id, 0);
                } else if (s._a) {
                    s._a.muted = true;
                }
                return s;
            };
            this.unmute = function() {
                s.muted = false;
                var hasIO = (s._iO.volume !== _undefined);
                if (!s.isHTML5) {
                    flash._setVolume(s.id, hasIO ? s._iO.volume : s.options.volume);
                } else if (s._a) {
                    s._a.muted = false;
                }
                return s;
            };
            this.toggleMute = function() {
                return (s.muted ? s.unmute() : s.mute());
            };
            this.onPosition = function(nPosition, oMethod, oScope) {
                onPositionItems.push({
                    position: parseInt(nPosition, 10),
                    method: oMethod,
                    scope: (oScope !== _undefined ? oScope : s),
                    fired: false
                });
                return s;
            };
            this.onposition = this.onPosition;
            this.clearOnPosition = function(nPosition, oMethod) {
                var i;
                nPosition = parseInt(nPosition, 10);
                if (isNaN(nPosition)) {
                    return false;
                }
                for (i=0; i < onPositionItems.length; i++) {
                    if (nPosition === onPositionItems[i].position) {
                        if (!oMethod || (oMethod === onPositionItems[i].method)) {
                            if (onPositionItems[i].fired) {
                                onPositionFired--;
                            }
                            onPositionItems.splice(i, 1);
                        }
                    }
                }
            };
            this._processOnPosition = function() {
                var i, item, j = onPositionItems.length;
                if (!j || !s.playState || onPositionFired >= j) {
                    return false;
                }
                for (i = j - 1; i >= 0; i--) {
                    item = onPositionItems[i];
                    if (!item.fired && s.position >= item.position) {
                        item.fired = true;
                        onPositionFired++;
                        item.method.apply(item.scope, [item.position]);
                        j = onPositionItems.length;
                    }
                }
                return true;
            };
            this._resetOnPosition = function(nPosition) {
                var i, item, j = onPositionItems.length;
                if (!j) {
                    return false;
                }
                for (i = j - 1; i >= 0; i--) {
                    item = onPositionItems[i];
                    if (item.fired && nPosition <= item.position) {
                        item.fired = false;
                        onPositionFired--;
                    }
                }
                return true;
            };
            applyFromTo = function() {
                var instanceOptions = s._iO,
                    f = instanceOptions.from,
                    t = instanceOptions.to,
                    start, end;
                end = function() {
                    s.clearOnPosition(t, end);
                    s.stop();
                };
                start = function() {
                    if (t !== null && !isNaN(t)) {
                        s.onPosition(t, end);
                    }
                };
                if (f !== null && !isNaN(f)) {
                    instanceOptions.position = f;
                    instanceOptions.multiShot = false;
                    start();
                }
                return instanceOptions;
            };
            attachOnPosition = function() {
                var item,
                    op = s._iO.onposition;
                if (op) {
                    for (item in op) {
                        if (op.hasOwnProperty(item)) {
                            s.onPosition(parseInt(item, 10), op[item]);
                        }
                    }
                }
            };
            detachOnPosition = function() {
                var item,
                    op = s._iO.onposition;
                if (op) {
                    for (item in op) {
                        if (op.hasOwnProperty(item)) {
                            s.clearOnPosition(parseInt(item, 10));
                        }
                    }
                }
            };
            start_html5_timer = function() {
                if (s.isHTML5) {
                    startTimer(s);
                }
            };
            stop_html5_timer = function() {
                if (s.isHTML5) {
                    stopTimer(s);
                }
            };
            resetProperties = function(retainPosition) {
                if (!retainPosition) {
                    onPositionItems = [];
                    onPositionFired = 0;
                }
                onplay_called = false;
                s._hasTimer = null;
                s._a = null;
                s._html5_canplay = false;
                s.bytesLoaded = null;
                s.bytesTotal = null;
                s.duration = (s._iO && s._iO.duration ? s._iO.duration : null);
                s.durationEstimate = null;
                s.buffered = [];
                s.eqData = [];
                s.eqData.left = [];
                s.eqData.right = [];
                s.failures = 0;
                s.isBuffering = false;
                s.instanceOptions = {};
                s.instanceCount = 0;
                s.loaded = false;
                s.metadata = {};
                s.readyState = 0;
                s.muted = false;
                s.paused = false;
                s.peakData = {
                    left: 0,
                    right: 0
                };
                s.waveformData = {
                    left: [],
                    right: []
                };
                s.playState = 0;
                s.position = null;
                s.id3 = {};
            };
            resetProperties();
            this._onTimer = function(bForce) {
                var duration, isNew = false, time, x = {};
                if (s._hasTimer || bForce) {
                    if (s._a && (bForce || ((s.playState > 0 || s.readyState === 1) && !s.paused))) {
                        duration = s._get_html5_duration();
                        if (duration !== lastHTML5State.duration) {
                            lastHTML5State.duration = duration;
                            s.duration = duration;
                            isNew = true;
                        }
                        s.durationEstimate = s.duration;
                        time = (s._a.currentTime * msecScale || 0);
                        if (time !== lastHTML5State.time) {
                            lastHTML5State.time = time;
                            isNew = true;
                        }
                        if (isNew || bForce) {
                            s._whileplaying(time, x, x, x, x);
                        }
                    }
                    return isNew;
                }
            };
            this._get_html5_duration = function() {
                var instanceOptions = s._iO,
                    d = (s._a && s._a.duration ? s._a.duration * msecScale : (instanceOptions && instanceOptions.duration ? instanceOptions.duration : null)),
                    result = (d && !isNaN(d) && d !== Infinity ? d : null);
                return result;
            };
            this._apply_loop = function(a, nLoops) {
                a.loop = (nLoops > 1 ? 'loop' : '');
            };
            this._setup_html5 = function(oOptions) {
                var instanceOptions = mixin(s._iO, oOptions),
                    a = useGlobalHTML5Audio ? globalHTML5Audio : s._a,
                    dURL = decodeURI(instanceOptions.url),
                    sameURL;
                if (useGlobalHTML5Audio) {
                    if (dURL === decodeURI(lastGlobalHTML5URL)) {
                        sameURL = true;
                    }
                } else if (dURL === decodeURI(lastURL)) {
                    sameURL = true;
                }
                if (a) {
                    if (a._s) {
                        if (useGlobalHTML5Audio) {
                            if (a._s && a._s.playState && !sameURL) {
                                a._s.stop();
                            }
                        } else if (!useGlobalHTML5Audio && dURL === decodeURI(lastURL)) {
                            s._apply_loop(a, instanceOptions.loops);
                            return a;
                        }
                    }
                    if (!sameURL) {
                        if (lastURL) {
                            resetProperties(false);
                        }
                        a.src = instanceOptions.url;
                        s.url = instanceOptions.url;
                        lastURL = instanceOptions.url;
                        lastGlobalHTML5URL = instanceOptions.url;
                        a._called_load = false;
                    }
                } else {
                    if (instanceOptions.autoLoad || instanceOptions.autoPlay) {
                        s._a = new Audio(instanceOptions.url);
                        s._a.load();
                    } else {
                        s._a = (isOpera && opera.version() < 10 ? new Audio(null) : new Audio());
                    }
                    a = s._a;
                    a._called_load = false;
                    if (useGlobalHTML5Audio) {
                        globalHTML5Audio = a;
                    }
                }
                s.isHTML5 = true;
                s._a = a;
                a._s = s;
                add_html5_events();
                s._apply_loop(a, instanceOptions.loops);
                if (instanceOptions.autoLoad || instanceOptions.autoPlay) {
                    s.load();
                } else {
                    a.autobuffer = false;
                    a.preload = 'auto';
                }
                return a;
            };
            add_html5_events = function() {
                if (s._a._added_events) {
                    return false;
                }
                var f;
                function add(oEvt, oFn, bCapture) {
                    return s._a ? s._a.addEventListener(oEvt, oFn, bCapture || false) : null;
                }
                s._a._added_events = true;
                for (f in html5_events) {
                    if (html5_events.hasOwnProperty(f)) {
                        add(f, html5_events[f]);
                    }
                }
                return true;
            };
            remove_html5_events = function() {
                var f;
                function remove(oEvt, oFn, bCapture) {
                    return (s._a ? s._a.removeEventListener(oEvt, oFn, bCapture || false) : null);
                }
                s._a._added_events = false;
                for (f in html5_events) {
                    if (html5_events.hasOwnProperty(f)) {
                        remove(f, html5_events[f]);
                    }
                }
            };
            this._onload = function(nSuccess) {
                var fN,
                    loadOK = !!nSuccess || (!s.isHTML5 && fV === 8 && s.duration);
                s.loaded = loadOK;
                s.readyState = (loadOK ? 3 : 2);
                s._onbufferchange(0);
                if (s._iO.onload) {
                    wrapCallback(s, function() {
                        s._iO.onload.apply(s, [loadOK]);
                    });
                }
                return true;
            };
            this._onbufferchange = function(nIsBuffering) {
                if (s.playState === 0) {
                    return false;
                }
                if ((nIsBuffering && s.isBuffering) || (!nIsBuffering && !s.isBuffering)) {
                    return false;
                }
                s.isBuffering = (nIsBuffering === 1);
                if (s._iO.onbufferchange) {
                    s._iO.onbufferchange.apply(s, [nIsBuffering]);
                }
                return true;
            };
            this._onsuspend = function() {
                if (s._iO.onsuspend) {
                    s._iO.onsuspend.apply(s);
                }
                return true;
            };
            this._onfailure = function(msg, level, code) {
                s.failures++;
                if (s._iO.onfailure && s.failures === 1) {
                    s._iO.onfailure(msg, level, code);
                } else {
                }
            };
            this._onwarning = function(msg, level, code) {
                if (s._iO.onwarning) {
                    s._iO.onwarning(msg, level, code);
                }
            };
            this._onfinish = function() {
                var io_onfinish = s._iO.onfinish;
                s._onbufferchange(0);
                s._resetOnPosition(0);
                if (s.instanceCount) {
                    s.instanceCount--;
                    if (!s.instanceCount) {
                        detachOnPosition();
                        s.playState = 0;
                        s.paused = false;
                        s.instanceCount = 0;
                        s.instanceOptions = {};
                        s._iO = {};
                        stop_html5_timer();
                        if (s.isHTML5) {
                            s.position = 0;
                        }
                    }
                    if (!s.instanceCount || s._iO.multiShotEvents) {
                        if (io_onfinish) {
                            wrapCallback(s, function() {
                                io_onfinish.apply(s);
                            });
                        }
                    }
                }
            };
            this._whileloading = function(nBytesLoaded, nBytesTotal, nDuration, nBufferLength) {
                var instanceOptions = s._iO;
                s.bytesLoaded = nBytesLoaded;
                s.bytesTotal = nBytesTotal;
                s.duration = Math.floor(nDuration);
                s.bufferLength = nBufferLength;
                if (!s.isHTML5 && !instanceOptions.isMovieStar) {
                    if (instanceOptions.duration) {
                        s.durationEstimate = (s.duration > instanceOptions.duration) ? s.duration : instanceOptions.duration;
                    } else {
                        s.durationEstimate = parseInt((s.bytesTotal / s.bytesLoaded) * s.duration, 10);
                    }
                } else {
                    s.durationEstimate = s.duration;
                }
                if (!s.isHTML5) {
                    s.buffered = [{
                        'start': 0,
                        'end': s.duration
                    }];
                }
                if ((s.readyState !== 3 || s.isHTML5) && instanceOptions.whileloading) {
                    instanceOptions.whileloading.apply(s);
                }
            };
            this._whileplaying = function(nPosition, oPeakData, oWaveformDataLeft, oWaveformDataRight, oEQData) {
                var instanceOptions = s._iO,
                    eqLeft;
                if (isNaN(nPosition) || nPosition === null) {
                    return false;
                }
                s.position = Math.max(0, nPosition);
                s._processOnPosition();
                if (!s.isHTML5 && fV > 8) {
                    if (instanceOptions.usePeakData && oPeakData !== _undefined && oPeakData) {
                        s.peakData = {
                            left: oPeakData.leftPeak,
                            right: oPeakData.rightPeak
                        };
                    }
                    if (instanceOptions.useWaveformData && oWaveformDataLeft !== _undefined && oWaveformDataLeft) {
                        s.waveformData = {
                            left: oWaveformDataLeft.split(','),
                            right: oWaveformDataRight.split(',')
                        };
                    }
                    if (instanceOptions.useEQData) {
                        if (oEQData !== _undefined && oEQData && oEQData.leftEQ) {
                            eqLeft = oEQData.leftEQ.split(',');
                            s.eqData = eqLeft;
                            s.eqData.left = eqLeft;
                            if (oEQData.rightEQ !== _undefined && oEQData.rightEQ) {
                                s.eqData.right = oEQData.rightEQ.split(',');
                            }
                        }
                    }
                }
                if (s.playState === 1) {
                    if (!s.isHTML5 && fV === 8 && !s.position && s.isBuffering) {
                        s._onbufferchange(0);
                    }
                    if (instanceOptions.whileplaying) {
                        instanceOptions.whileplaying.apply(s);
                    }
                }
                return true;
            };
            this._oncaptiondata = function(oData) {
                s.captiondata = oData;
                if (s._iO.oncaptiondata) {
                    s._iO.oncaptiondata.apply(s, [oData]);
                }
            };
            this._onmetadata = function(oMDProps, oMDData) {
                var oData = {}, i, j;
                for (i = 0, j = oMDProps.length; i < j; i++) {
                    oData[oMDProps[i]] = oMDData[i];
                }
                s.metadata = oData;
                if (s._iO.onmetadata) {
                    s._iO.onmetadata.call(s, s.metadata);
                }
            };
            this._onid3 = function(oID3Props, oID3Data) {
                var oData = [], i, j;
                for (i = 0, j = oID3Props.length; i < j; i++) {
                    oData[oID3Props[i]] = oID3Data[i];
                }
                s.id3 = mixin(s.id3, oData);
                if (s._iO.onid3) {
                    s._iO.onid3.apply(s);
                }
            };
            this._onconnect = function(bSuccess) {
                bSuccess = (bSuccess === 1);
                s.connected = bSuccess;
                if (bSuccess) {
                    s.failures = 0;
                    if (idCheck(s.id)) {
                        if (s.getAutoPlay()) {
                            s.play(_undefined, s.getAutoPlay());
                        } else if (s._iO.autoLoad) {
                            s.load();
                        }
                    }
                    if (s._iO.onconnect) {
                        s._iO.onconnect.apply(s, [bSuccess]);
                    }
                }
            };
            this._ondataerror = function(sError) {
                if (s.playState > 0) {
                    if (s._iO.ondataerror) {
                        s._iO.ondataerror.apply(s);
                    }
                }
            };
        };
        getDocument = function() {
            return (doc.body || doc.getElementsByTagName('div')[0]);
        };
        id = function(sID) {
            return doc.getElementById(sID);
        };
        mixin = function(oMain, oAdd) {
            var o1 = (oMain || {}), o2, o;
            o2 = (oAdd === _undefined ? sm2.defaultOptions : oAdd);
            for (o in o2) {
                if (o2.hasOwnProperty(o) && o1[o] === _undefined) {
                    if (typeof o2[o] !== 'object' || o2[o] === null) {
                        o1[o] = o2[o];
                    } else {
                        o1[o] = mixin(o1[o], o2[o]);
                    }
                }
            }
            return o1;
        };
        wrapCallback = function(oSound, callback) {
            if (!oSound.isHTML5 && fV === 8) {
                window.setTimeout(callback, 0);
            } else {
                callback();
            }
        };
        extraOptions = {
            'onready': 1,
            'ontimeout': 1,
            'defaultOptions': 1,
            'flash9Options': 1,
            'movieStarOptions': 1
        };
        assign = function(o, oParent) {
            var i,
                result = true,
                hasParent = (oParent !== _undefined),
                setupOptions = sm2.setupOptions,
                bonusOptions = extraOptions;
            for (i in o) {
                if (o.hasOwnProperty(i)) {
                    if (typeof o[i] !== 'object' || o[i] === null || o[i] instanceof Array || o[i] instanceof RegExp) {
                        if (hasParent && bonusOptions[oParent] !== _undefined) {
                            sm2[oParent][i] = o[i];
                        } else if (setupOptions[i] !== _undefined) {
                            sm2.setupOptions[i] = o[i];
                            sm2[i] = o[i];
                        } else if (bonusOptions[i] === _undefined) {
                            result = false;
                        } else {
                            if (sm2[i] instanceof Function) {
                                sm2[i].apply(sm2, (o[i] instanceof Array ? o[i] : [o[i]]));
                            } else {
                                sm2[i] = o[i];
                            }
                        }
                    } else {
                        if (bonusOptions[i] === _undefined) {
                            result = false;
                        } else {
                            return assign(o[i], i);
                        }
                    }
                }
            }
            return result;
        };
        function preferFlashCheck(kind) {
            return (sm2.preferFlash && hasFlash && !sm2.ignoreFlash && (sm2.flash[kind] !== _undefined && sm2.flash[kind]));
        }
        event = (function() {
            var old = (window.attachEvent),
                evt = {
                    add: (old ? 'attachEvent' : 'addEventListener'),
                    remove: (old ? 'detachEvent' : 'removeEventListener')
                };
            function getArgs(oArgs) {
                var args = slice.call(oArgs),
                    len = args.length;
                if (old) {
                    args[1] = 'on' + args[1];
                    if (len > 3) {
                        args.pop();
                    }
                } else if (len === 3) {
                    args.push(false);
                }
                return args;
            }
            function apply(args, sType) {
                var element = args.shift(),
                    method = [evt[sType]];
                if (old) {
                    element[method](args[0], args[1]);
                } else {
                    element[method].apply(element, args);
                }
            }
            function add() {
                apply(getArgs(arguments), 'add');
            }
            function remove() {
                apply(getArgs(arguments), 'remove');
            }
            return {
                'add': add,
                'remove': remove
            };
        }());
        function html5_event(oFn) {
            return function(e) {
                var s = this._s,
                    result;
                if (!s || !s._a) {
                    result = null;
                } else {
                    result = oFn.call(this, e);
                }
                return result;
            };
        }
        html5_events = {
            abort: html5_event(function() {
            }),
            canplay: html5_event(function() {
                var s = this._s,
                    position1K;
                if (s._html5_canplay) {
                    return true;
                }
                s._html5_canplay = true;
                s._onbufferchange(0);
                position1K = (s._iO.position !== _undefined && !isNaN(s._iO.position) ? s._iO.position/msecScale : null);
                if (this.currentTime !== position1K) {
                    try {
                        this.currentTime = position1K;
                    } catch(ee) {
                    }
                }
                if (s._iO._oncanplay) {
                    s._iO._oncanplay();
                }
            }),
            canplaythrough: html5_event(function() {
                var s = this._s;
                if (!s.loaded) {
                    s._onbufferchange(0);
                    s._whileloading(s.bytesLoaded, s.bytesTotal, s._get_html5_duration());
                    s._onload(true);
                }
            }),
            durationchange: html5_event(function() {
                var s = this._s,
                    duration;
                duration = s._get_html5_duration();
                if (!isNaN(duration) && duration !== s.duration) {
                    s.durationEstimate = s.duration = duration;
                }
            }),
            ended: html5_event(function() {
                var s = this._s;
                s._onfinish();
            }),
            error: html5_event(function() {
                this._s._onload(false);
            }),
            loadeddata: html5_event(function() {
                var s = this._s;
                if (!s._loaded && !isSafari) {
                    s.duration = s._get_html5_duration();
                }
            }),
            loadedmetadata: html5_event(function() {
            }),
            loadstart: html5_event(function() {
                this._s._onbufferchange(1);
            }),
            play: html5_event(function() {
                this._s._onbufferchange(0);
            }),
            playing: html5_event(function() {
                this._s._onbufferchange(0);
            }),
            progress: html5_event(function(e) {
                var s = this._s,
                    i, j, progStr, buffered = 0,
                    isProgress = (e.type === 'progress'),
                    ranges = e.target.buffered,
                    loaded = (e.loaded || 0),
                    total = (e.total || 1);
                s.buffered = [];
                if (ranges && ranges.length) {
                    for (i = 0, j = ranges.length; i < j; i++) {
                        s.buffered.push({
                            'start': ranges.start(i) * msecScale,
                            'end': ranges.end(i) * msecScale
                        });
                    }
                    buffered = (ranges.end(0) - ranges.start(0)) * msecScale;
                    loaded = Math.min(1, buffered / (e.target.duration * msecScale));
                }
                if (!isNaN(loaded)) {
                    s._whileloading(loaded, total, s._get_html5_duration());
                    if (loaded && total && loaded === total) {
                        html5_events.canplaythrough.call(this, e);
                    }
                }
            }),
            ratechange: html5_event(function() {
            }),
            suspend: html5_event(function(e) {
                var s = this._s;
                html5_events.progress.call(this, e);
                s._onsuspend();
            }),
            stalled: html5_event(function() {
            }),
            timeupdate: html5_event(function() {
                this._s._onTimer();
            }),
            waiting: html5_event(function() {
                var s = this._s;
                s._onbufferchange(1);
            })
        };
        html5OK = function(iO) {
            var result;
            if (!iO || (!iO.type && !iO.url && !iO.serverURL)) {
                result = false;
            } else if (iO.serverURL || (iO.type && preferFlashCheck(iO.type))) {
                result = false;
            } else {
                result = ((iO.type ? html5CanPlay({type:iO.type}) : html5CanPlay({url:iO.url}) || sm2.html5Only || iO.url.match(/data\:/i)));
            }
            return result;
        };
        html5Unload = function(oAudio) {
            var url;
            if (oAudio) {
                url = (isSafari ? emptyURL : (sm2.html5.canPlayType('audio/wav') ? emptyWAV : emptyURL));
                oAudio.src = url;
                if (oAudio._called_unload !== _undefined) {
                    oAudio._called_load = false;
                }
            }
            if (useGlobalHTML5Audio) {
                lastGlobalHTML5URL = null;
            }
            return url;
        };
        html5CanPlay = function(o) {
            if (!sm2.useHTML5Audio || !sm2.hasHTML5) {
                return false;
            }
            var url = (o.url || null),
                mime = (o.type || null),
                aF = sm2.audioFormats,
                result,
                offset,
                fileExt,
                item;
            if (mime && sm2.html5[mime] !== _undefined) {
                return (sm2.html5[mime] && !preferFlashCheck(mime));
            }
            if (!html5Ext) {
                html5Ext = [];
                for (item in aF) {
                    if (aF.hasOwnProperty(item)) {
                        html5Ext.push(item);
                        if (aF[item].related) {
                            html5Ext = html5Ext.concat(aF[item].related);
                        }
                    }
                }
                html5Ext = new RegExp('\\.('+html5Ext.join('|')+')(\\?.*)?$','i');
            }
            fileExt = (url ? url.toLowerCase().match(html5Ext) : null);
            if (!fileExt || !fileExt.length) {
                if (!mime) {
                    result = false;
                } else {
                    offset = mime.indexOf(';');
                    fileExt = (offset !== -1 ? mime.substr(0,offset) : mime).substr(6);
                }
            } else {
                fileExt = fileExt[1];
            }
            if (fileExt && sm2.html5[fileExt] !== _undefined) {
                result = (sm2.html5[fileExt] && !preferFlashCheck(fileExt));
            } else {
                mime = 'audio/' + fileExt;
                result = sm2.html5.canPlayType({type:mime});
                sm2.html5[fileExt] = result;
                result = (result && sm2.html5[mime] && !preferFlashCheck(mime));
            }
            return result;
        };
        testHTML5 = function() {
            if (!sm2.useHTML5Audio || !sm2.hasHTML5) {
                sm2.html5.usingFlash = true;
                needsFlash = true;
                return false;
            }
            var a = (Audio !== _undefined ? (isOpera && opera.version() < 10 ? new Audio(null) : new Audio()) : null),
                item, lookup, support = {}, aF, i;
            function cp(m) {
                var canPlay, j,
                    result = false,
                    isOK = false;
                if (!a || typeof a.canPlayType !== 'function') {
                    return result;
                }
                if (m instanceof Array) {
                    for (i = 0, j = m.length; i < j; i++) {
                        if (sm2.html5[m[i]] || a.canPlayType(m[i]).match(sm2.html5Test)) {
                            isOK = true;
                            sm2.html5[m[i]] = true;
                            sm2.flash[m[i]] = !!(m[i].match(flashMIME));
                        }
                    }
                    result = isOK;
                } else {
                    canPlay = (a && typeof a.canPlayType === 'function' ? a.canPlayType(m) : false);
                    result = !!(canPlay && (canPlay.match(sm2.html5Test)));
                }
                return result;
            }
            aF = sm2.audioFormats;
            for (item in aF) {
                if (aF.hasOwnProperty(item)) {
                    lookup = 'audio/' + item;
                    support[item] = cp(aF[item].type);
                    support[lookup] = support[item];
                    if (item.match(flashMIME)) {
                        sm2.flash[item] = true;
                        sm2.flash[lookup] = true;
                    } else {
                        sm2.flash[item] = false;
                        sm2.flash[lookup] = false;
                    }
                    if (aF[item] && aF[item].related) {
                        for (i = aF[item].related.length - 1; i >= 0; i--) {
                            support['audio/' + aF[item].related[i]] = support[item];
                            sm2.html5[aF[item].related[i]] = support[item];
                            sm2.flash[aF[item].related[i]] = support[item];
                        }
                    }
                }
            }
            support.canPlayType = (a ? cp : null);
            sm2.html5 = mixin(sm2.html5, support);
            sm2.html5.usingFlash = featureCheck();
            needsFlash = sm2.html5.usingFlash;
            return true;
        };
        strings = {
        };
        str = function() {
        };
        loopFix = function(sOpt) {
            if (fV === 8 && sOpt.loops > 1 && sOpt.stream) {
                sOpt.stream = false;
            }
            return sOpt;
        };
        policyFix = function(sOpt, sPre) {
            if (sOpt && !sOpt.usePolicyFile && (sOpt.onid3 || sOpt.usePeakData || sOpt.useWaveformData || sOpt.useEQData)) {
                sOpt.usePolicyFile = true;
            }
            return sOpt;
        };
        complain = function(sMsg) {
        };
        doNothing = function() {
            return false;
        };
        disableObject = function(o) {
            var oProp;
            for (oProp in o) {
                if (o.hasOwnProperty(oProp) && typeof o[oProp] === 'function') {
                    o[oProp] = doNothing;
                }
            }
            oProp = null;
        };
        failSafely = function(bNoDisable) {
            if (bNoDisable === _undefined) {
                bNoDisable = false;
            }
            if (disabled || bNoDisable) {
                sm2.disable(bNoDisable);
            }
        };
        normalizeMovieURL = function(smURL) {
            var urlParams = null, url;
            if (smURL) {
                if (smURL.match(/\.swf(\?.*)?$/i)) {
                    urlParams = smURL.substr(smURL.toLowerCase().lastIndexOf('.swf?') + 4);
                    if (urlParams) {
                        return smURL;
                    }
                } else if (smURL.lastIndexOf('/') !== smURL.length - 1) {
                    smURL += '/';
                }
            }
            url = (smURL && smURL.lastIndexOf('/') !== - 1 ? smURL.substr(0, smURL.lastIndexOf('/') + 1) : './') + sm2.movieURL;
            if (sm2.noSWFCache) {
                url += ('?ts=' + new Date().getTime());
            }
            return url;
        };
        setVersionInfo = function() {
            fV = parseInt(sm2.flashVersion, 10);
            if (fV !== 8 && fV !== 9) {
                sm2.flashVersion = fV = defaultFlashVersion;
            }
            var isDebug = (sm2.debugMode || sm2.debugFlash ? '_debug.swf' : '.swf');
            if (sm2.useHTML5Audio && !sm2.html5Only && sm2.audioFormats.mp4.required && fV < 9) {
                sm2.flashVersion = fV = 9;
            }
            sm2.version = sm2.versionNumber + (sm2.html5Only ? ' (HTML5-only mode)' : (fV === 9 ? ' (AS3/Flash 9)' : ' (AS2/Flash 8)'));
            if (fV > 8) {
                sm2.defaultOptions = mixin(sm2.defaultOptions, sm2.flash9Options);
                sm2.features.buffering = true;
                sm2.defaultOptions = mixin(sm2.defaultOptions, sm2.movieStarOptions);
                sm2.filePatterns.flash9 = new RegExp('\\.(mp3|' + netStreamTypes.join('|') + ')(\\?.*)?$', 'i');
                sm2.features.movieStar = true;
            } else {
                sm2.features.movieStar = false;
            }
            sm2.filePattern = sm2.filePatterns[(fV !== 8 ? 'flash9' : 'flash8')];
            sm2.movieURL = (fV === 8 ? 'soundmanager2.swf' : 'soundmanager2_flash9.swf').replace('.swf', isDebug);
            sm2.features.peakData = sm2.features.waveformData = sm2.features.eqData = (fV > 8);
        };
        setPolling = function(bPolling, bHighPerformance) {
            if (!flash) {
                return false;
            }
            flash._setPolling(bPolling, bHighPerformance);
        };
        initDebug = function() {
        };
        idCheck = this.getSoundById;
        getSWFCSS = function() {
            var css = [];
            if (sm2.debugMode) {
                css.push(swfCSS.sm2Debug);
            }
            if (sm2.debugFlash) {
                css.push(swfCSS.flashDebug);
            }
            if (sm2.useHighPerformance) {
                css.push(swfCSS.highPerf);
            }
            return css.join(' ');
        };
        flashBlockHandler = function() {
            var name = str('fbHandler'),
                p = sm2.getMoviePercent(),
                css = swfCSS,
                error = {
                    type:'FLASHBLOCK'
                };
            if (sm2.html5Only) {
                return false;
            }
            if (!sm2.ok()) {
                if (needsFlash) {
                    sm2.oMC.className = getSWFCSS() + ' ' + css.swfDefault + ' ' + (p === null ? css.swfTimedout : css.swfError);
                }
                sm2.didFlashBlock = true;
                processOnEvents({
                    type: 'ontimeout',
                    ignoreInit: true,
                    error: error
                });
                catchError(error);
            } else {
                if (sm2.oMC) {
                    sm2.oMC.className = [getSWFCSS(), css.swfDefault, css.swfLoaded + (sm2.didFlashBlock ? ' ' + css.swfUnblocked : '')].join(' ');
                }
            }
        };
        addOnEvent = function(sType, oMethod, oScope) {
            if (on_queue[sType] === _undefined) {
                on_queue[sType] = [];
            }
            on_queue[sType].push({
                'method': oMethod,
                'scope': (oScope || null),
                'fired': false
            });
        };
        processOnEvents = function(oOptions) {
            if (!oOptions) {
                oOptions = {
                    type: (sm2.ok() ? 'onready' : 'ontimeout')
                };
            }
            if (!didInit && oOptions && !oOptions.ignoreInit) {
                return false;
            }
            if (oOptions.type === 'ontimeout' && (sm2.ok() || (disabled && !oOptions.ignoreInit))) {
                return false;
            }
            var status = {
                    success: (oOptions && oOptions.ignoreInit ? sm2.ok() : !disabled)
                },
                srcQueue = (oOptions && oOptions.type ? on_queue[oOptions.type] || [] : []),
                queue = [], i, j,
                args = [status],
                canRetry = (needsFlash && !sm2.ok());
            if (oOptions.error) {
                args[0].error = oOptions.error;
            }
            for (i = 0, j = srcQueue.length; i < j; i++) {
                if (srcQueue[i].fired !== true) {
                    queue.push(srcQueue[i]);
                }
            }
            if (queue.length) {
                for (i = 0, j = queue.length; i < j; i++) {
                    if (queue[i].scope) {
                        queue[i].method.apply(queue[i].scope, args);
                    } else {
                        queue[i].method.apply(this, args);
                    }
                    if (!canRetry) {
                        queue[i].fired = true;
                    }
                }
            }
            return true;
        };
        initUserOnload = function() {
            window.setTimeout(function() {
                if (sm2.useFlashBlock) {
                    flashBlockHandler();
                }
                processOnEvents();
                if (typeof sm2.onload === 'function') {
                    sm2.onload.apply(window);
                }
                if (sm2.waitForWindowLoad) {
                    event.add(window, 'load', initUserOnload);
                }
            }, 1);
        };
        detectFlash = function() {
            if (hasFlash !== _undefined) {
                return hasFlash;
            }
            var hasPlugin = false, n = navigator, nP = n.plugins, obj, type, types, AX = window.ActiveXObject;
            if (nP && nP.length) {
                type = 'application/x-shockwave-flash';
                types = n.mimeTypes;
                if (types && types[type] && types[type].enabledPlugin && types[type].enabledPlugin.description) {
                    hasPlugin = true;
                }
            } else if (AX !== _undefined && !ua.match(/MSAppHost/i)) {
                try {
                    obj = new AX('ShockwaveFlash.ShockwaveFlash');
                } catch(e) {
                    obj = null;
                }
                hasPlugin = (!!obj);
                obj = null;
            }
            hasFlash = hasPlugin;
            return hasPlugin;
        };
        featureCheck = function() {
            var flashNeeded,
                item,
                formats = sm2.audioFormats,
                isSpecial = (is_iDevice && !!(ua.match(/os (1|2|3_0|3_1)\s/i)));
            if (isSpecial) {
                sm2.hasHTML5 = false;
                sm2.html5Only = true;
                if (sm2.oMC) {
                    sm2.oMC.style.display = 'none';
                }
            } else {
                if (sm2.useHTML5Audio) {
                    if (!sm2.html5 || !sm2.html5.canPlayType) {
                        sm2.hasHTML5 = false;
                    }
                }
            }
            if (sm2.useHTML5Audio && sm2.hasHTML5) {
                canIgnoreFlash = true;
                for (item in formats) {
                    if (formats.hasOwnProperty(item)) {
                        if (formats[item].required) {
                            if (!sm2.html5.canPlayType(formats[item].type)) {
                                canIgnoreFlash = false;
                                flashNeeded = true;
                            } else if (sm2.preferFlash && (sm2.flash[item] || sm2.flash[formats[item].type])) {
                                flashNeeded = true;
                            }
                        }
                    }
                }
            }
            if (sm2.ignoreFlash) {
                flashNeeded = false;
                canIgnoreFlash = true;
            }
            sm2.html5Only = (sm2.hasHTML5 && sm2.useHTML5Audio && !flashNeeded);
            return (!sm2.html5Only);
        };
        parseURL = function(url) {
            var i, j, urlResult = 0, result;
            if (url instanceof Array) {
                for (i = 0, j = url.length; i < j; i++) {
                    if (url[i] instanceof Object) {
                        if (sm2.canPlayMIME(url[i].type)) {
                            urlResult = i;
                            break;
                        }
                    } else if (sm2.canPlayURL(url[i])) {
                        urlResult = i;
                        break;
                    }
                }
                if (url[urlResult].url) {
                    url[urlResult] = url[urlResult].url;
                }
                result = url[urlResult];
            } else {
                result = url;
            }
            return result;
        };
        startTimer = function(oSound) {
            if (!oSound._hasTimer) {
                oSound._hasTimer = true;
                if (!mobileHTML5 && sm2.html5PollingInterval) {
                    if (h5IntervalTimer === null && h5TimerCount === 0) {
                        h5IntervalTimer = setInterval(timerExecute, sm2.html5PollingInterval);
                    }
                    h5TimerCount++;
                }
            }
        };
        stopTimer = function(oSound) {
            if (oSound._hasTimer) {
                oSound._hasTimer = false;
                if (!mobileHTML5 && sm2.html5PollingInterval) {
                    h5TimerCount--;
                }
            }
        };
        timerExecute = function() {
            var i;
            if (h5IntervalTimer !== null && !h5TimerCount) {
                clearInterval(h5IntervalTimer);
                h5IntervalTimer = null;
                return false;
            }
            for (i = sm2.soundIDs.length - 1; i >= 0; i--) {
                if (sm2.sounds[sm2.soundIDs[i]].isHTML5 && sm2.sounds[sm2.soundIDs[i]]._hasTimer) {
                    sm2.sounds[sm2.soundIDs[i]]._onTimer();
                }
            }
        };
        catchError = function(options) {
            options = (options !== _undefined ? options : {});
            if (typeof sm2.onerror === 'function') {
                sm2.onerror.apply(window, [{
                    type: (options.type !== _undefined ? options.type : null)
                }]);
            }
            if (options.fatal !== _undefined && options.fatal) {
                sm2.disable();
            }
        };
        badSafariFix = function() {
            if (!isBadSafari || !detectFlash()) {
                return false;
            }
            var aF = sm2.audioFormats, i, item;
            for (item in aF) {
                if (aF.hasOwnProperty(item)) {
                    if (item === 'mp3' || item === 'mp4') {
                        sm2.html5[item] = false;
                        if (aF[item] && aF[item].related) {
                            for (i = aF[item].related.length - 1; i >= 0; i--) {
                                sm2.html5[aF[item].related[i]] = false;
                            }
                        }
                    }
                }
            }
        };
        this._setSandboxType = function(sandboxType) {
        };
        this._externalInterfaceOK = function(swfVersion) {
            if (sm2.swfLoaded) {
                return false;
            }
            var e;
            sm2.swfLoaded = true;
            tryInitOnFocus = false;
            if (isBadSafari) {
                badSafariFix();
            }
            setTimeout(init, isIE ? 100 : 1);
        };
        createMovie = function(smID, smURL) {
            if (didAppend && appendSuccess) {
                return false;
            }
            function initMsg() {
            }
            if (sm2.html5Only) {
                setVersionInfo();
                initMsg();
                sm2.oMC = id(sm2.movieID);
                init();
                didAppend = true;
                appendSuccess = true;
                return false;
            }
            var remoteURL = (smURL || sm2.url),
                localURL = (sm2.altURL || remoteURL),
                swfTitle = 'JS/Flash audio component (SoundManager 2)',
                oTarget = getDocument(),
                extraClass = getSWFCSS(),
                isRTL = null,
                html = doc.getElementsByTagName('html')[0],
                oEmbed, oMovie, tmp, movieHTML, oEl, s, x, sClass;
            isRTL = (html && html.dir && html.dir.match(/rtl/i));
            smID = (smID === _undefined ? sm2.id : smID);
            function param(name, value) {
                return '<param name="' + name + '" value="' + value + '" />';
            }
            setVersionInfo();
            sm2.url = normalizeMovieURL(overHTTP ? remoteURL : localURL);
            smURL = sm2.url;
            sm2.wmode = (!sm2.wmode && sm2.useHighPerformance ? 'transparent' : sm2.wmode);
            if (sm2.wmode !== null && (ua.match(/msie 8/i) || (!isIE && !sm2.useHighPerformance)) && navigator.platform.match(/win32|win64/i)) {
                messages.push(strings.spcWmode);
                sm2.wmode = null;
            }
            oEmbed = {
                'name': smID,
                'id': smID,
                'src': smURL,
                'quality': 'high',
                'allowScriptAccess': sm2.allowScriptAccess,
                'bgcolor': sm2.bgColor,
                'pluginspage': http + 'www.macromedia.com/go/getflashplayer',
                'title': swfTitle,
                'type': 'application/x-shockwave-flash',
                'wmode': sm2.wmode,
                'hasPriority': 'true'
            };
            if (sm2.debugFlash) {
                oEmbed.FlashVars = 'debug=1';
            }
            if (!sm2.wmode) {
                delete oEmbed.wmode;
            }
            if (isIE) {
                oMovie = doc.createElement('div');
                movieHTML = [
                    '<object id="' + smID + '" data="' + smURL + '" type="' + oEmbed.type + '" title="' + oEmbed.title +'" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0">',
                    param('movie', smURL),
                    param('AllowScriptAccess', sm2.allowScriptAccess),
                    param('quality', oEmbed.quality),
                    (sm2.wmode? param('wmode', sm2.wmode): ''),
                    param('bgcolor', sm2.bgColor),
                    param('hasPriority', 'true'),
                    (sm2.debugFlash ? param('FlashVars', oEmbed.FlashVars) : ''),
                    '</object>'
                ].join('');
            } else {
                oMovie = doc.createElement('embed');
                for (tmp in oEmbed) {
                    if (oEmbed.hasOwnProperty(tmp)) {
                        oMovie.setAttribute(tmp, oEmbed[tmp]);
                    }
                }
            }
            initDebug();
            extraClass = getSWFCSS();
            oTarget = getDocument();
            if (oTarget) {
                sm2.oMC = (id(sm2.movieID) || doc.createElement('div'));
                if (!sm2.oMC.id) {
                    sm2.oMC.id = sm2.movieID;
                    sm2.oMC.className = swfCSS.swfDefault + ' ' + extraClass;
                    s = null;
                    oEl = null;
                    if (!sm2.useFlashBlock) {
                        if (sm2.useHighPerformance) {
                            s = {
                                'position': 'fixed',
                                'width': '8px',
                                'height': '8px',
                                'bottom': '0px',
                                'left': '0px',
                                'overflow': 'hidden'
                            };
                        } else {
                            s = {
                                'position': 'absolute',
                                'width': '6px',
                                'height': '6px',
                                'top': '-9999px',
                                'left': '-9999px'
                            };
                            if (isRTL) {
                                s.left = Math.abs(parseInt(s.left, 10)) + 'px';
                            }
                        }
                    }
                    if (isWebkit) {
                        sm2.oMC.style.zIndex = 10000;
                    }
                    if (!sm2.debugFlash) {
                        for (x in s) {
                            if (s.hasOwnProperty(x)) {
                                sm2.oMC.style[x] = s[x];
                            }
                        }
                    }
                    try {
                        if (!isIE) {
                            sm2.oMC.appendChild(oMovie);
                        }
                        oTarget.appendChild(sm2.oMC);
                        if (isIE) {
                            oEl = sm2.oMC.appendChild(doc.createElement('div'));
                            oEl.className = swfCSS.swfBox;
                            oEl.innerHTML = movieHTML;
                        }
                        appendSuccess = true;
                    } catch(e) {
                        throw new Error(str('domError') + ' \n' + e.toString());
                    }
                } else {
                    sClass = sm2.oMC.className;
                    sm2.oMC.className = (sClass ? sClass + ' ' : swfCSS.swfDefault) + (extraClass ? ' ' + extraClass : '');
                    sm2.oMC.appendChild(oMovie);
                    if (isIE) {
                        oEl = sm2.oMC.appendChild(doc.createElement('div'));
                        oEl.className = swfCSS.swfBox;
                        oEl.innerHTML = movieHTML;
                    }
                    appendSuccess = true;
                }
            }
            didAppend = true;
            initMsg();
            return true;
        };
        initMovie = function() {
            if (sm2.html5Only) {
                createMovie();
                return false;
            }
            if (flash) {
                return false;
            }
            if (!sm2.url) {
                return false;
            }
            flash = sm2.getMovie(sm2.id);
            if (!flash) {
                if (!oRemoved) {
                    createMovie(sm2.id, sm2.url);
                } else {
                    if (!isIE) {
                        sm2.oMC.appendChild(oRemoved);
                    } else {
                        sm2.oMC.innerHTML = oRemovedHTML;
                    }
                    oRemoved = null;
                    didAppend = true;
                }
                flash = sm2.getMovie(sm2.id);
            }
            if (typeof sm2.oninitmovie === 'function') {
                setTimeout(sm2.oninitmovie, 1);
            }
            return true;
        };
        delayWaitForEI = function() {
            setTimeout(waitForEI, 1000);
        };
        rebootIntoHTML5 = function() {
            window.setTimeout(function() {
                sm2.setup({
                    preferFlash: false
                }).reboot();
                sm2.didFlashBlock = true;
                sm2.beginDelayedInit();
            }, 1);
        };
        waitForEI = function() {
            var p,
                loadIncomplete = false;
            if (!sm2.url) {
                return false;
            }
            if (waitingForEI) {
                return false;
            }
            waitingForEI = true;
            event.remove(window, 'load', delayWaitForEI);
            if (hasFlash && tryInitOnFocus && !isFocused) {
                return false;
            }
            if (!didInit) {
                p = sm2.getMoviePercent();
                if (p > 0 && p < 100) {
                    loadIncomplete = true;
                }
            }
            setTimeout(function() {
                p = sm2.getMoviePercent();
                if (loadIncomplete) {
                    waitingForEI = false;
                    window.setTimeout(delayWaitForEI, 1);
                    return false;
                }
                if (!didInit && okToDisable) {
                    if (p === null) {
                        if (sm2.useFlashBlock || sm2.flashLoadTimeout === 0) {
                            if (sm2.useFlashBlock) {
                                flashBlockHandler();
                            }
                        } else {
                            if (!sm2.useFlashBlock && canIgnoreFlash) {
                                rebootIntoHTML5();
                            } else {
                                processOnEvents({
                                    type: 'ontimeout',
                                    ignoreInit: true,
                                    error: {
                                        type: 'INIT_FLASHBLOCK'
                                    }
                                });
                            }
                        }
                    } else {
                        if (sm2.flashLoadTimeout === 0) {
                        } else {
                            if (!sm2.useFlashBlock && canIgnoreFlash) {
                                rebootIntoHTML5();
                            } else {
                                failSafely(true);
                            }
                        }
                    }
                }
            }, sm2.flashLoadTimeout);
        };
        handleFocus = function() {
            function cleanup() {
                event.remove(window, 'focus', handleFocus);
            }
            if (isFocused || !tryInitOnFocus) {
                cleanup();
                return true;
            }
            okToDisable = true;
            isFocused = true;
            waitingForEI = false;
            delayWaitForEI();
            cleanup();
            return true;
        };
        flushMessages = function() {
        };
        showSupport = function() {
        };
        initComplete = function(bNoDisable) {
            if (didInit) {
                return false;
            }
            if (sm2.html5Only) {
                didInit = true;
                initUserOnload();
                return true;
            }
            var wasTimeout = (sm2.useFlashBlock && sm2.flashLoadTimeout && !sm2.getMoviePercent()),
                result = true,
                error;
            if (!wasTimeout) {
                didInit = true;
            }
            error = {
                type: (!hasFlash && needsFlash ? 'NO_FLASH' : 'INIT_TIMEOUT')
            };
            if (disabled || bNoDisable) {
                if (sm2.useFlashBlock && sm2.oMC) {
                    sm2.oMC.className = getSWFCSS() + ' ' + (sm2.getMoviePercent() === null ? swfCSS.swfTimedout : swfCSS.swfError);
                }
                processOnEvents({
                    type: 'ontimeout',
                    error: error,
                    ignoreInit: true
                });
                catchError(error);
                result = false;
            } else {
            }
            if (!disabled) {
                if (sm2.waitForWindowLoad && !windowLoaded) {
                    event.add(window, 'load', initUserOnload);
                } else {
                    initUserOnload();
                }
            }
            return result;
        };
        setProperties = function() {
            var i,
                o = sm2.setupOptions;
            for (i in o) {
                if (o.hasOwnProperty(i)) {
                    if (sm2[i] === _undefined) {
                        sm2[i] = o[i];
                    } else if (sm2[i] !== o[i]) {
                        sm2.setupOptions[i] = sm2[i];
                    }
                }
            }
        };
        init = function() {
            if (didInit) {
                return false;
            }
            function cleanup() {
                event.remove(window, 'load', sm2.beginDelayedInit);
            }
            if (sm2.html5Only) {
                if (!didInit) {
                    cleanup();
                    sm2.enabled = true;
                    initComplete();
                }
                return true;
            }
            initMovie();
            try {
                flash._externalInterfaceTest(false);
                setPolling(true, (sm2.flashPollingInterval || (sm2.useHighPerformance ? 10 : 50)));
                if (!sm2.debugMode) {
                    flash._disableDebug();
                }
                sm2.enabled = true;
                if (!sm2.html5Only) {
                    event.add(window, 'unload', doNothing);
                }
            } catch(e) {
                catchError({
                    type: 'JS_TO_FLASH_EXCEPTION',
                    fatal: true
                });
                failSafely(true);
                initComplete();
                return false;
            }
            initComplete();
            cleanup();
            return true;
        };
        domContentLoaded = function() {
            if (didDCLoaded) {
                return false;
            }
            didDCLoaded = true;
            setProperties();
            initDebug();
            if (!hasFlash && sm2.hasHTML5) {
                sm2.setup({
                    'useHTML5Audio': true,
                    'preferFlash': false
                });
            }
            testHTML5();
            if (!hasFlash && needsFlash) {
                messages.push(strings.needFlash);
                sm2.setup({
                    'flashLoadTimeout': 1
                });
            }
            if (doc.removeEventListener) {
                doc.removeEventListener('DOMContentLoaded', domContentLoaded, false);
            }
            initMovie();
            return true;
        };
        domContentLoadedIE = function() {
            if (doc.readyState === 'complete') {
                domContentLoaded();
                doc.detachEvent('onreadystatechange', domContentLoadedIE);
            }
            return true;
        };
        winOnLoad = function() {
            windowLoaded = true;
            domContentLoaded();
            event.remove(window, 'load', winOnLoad);
        };
        detectFlash();
        event.add(window, 'focus', handleFocus);
        event.add(window, 'load', delayWaitForEI);
        event.add(window, 'load', winOnLoad);
        if (doc.addEventListener) {
            doc.addEventListener('DOMContentLoaded', domContentLoaded, false);
        } else if (doc.attachEvent) {
            doc.attachEvent('onreadystatechange', domContentLoadedIE);
        } else {
            catchError({
                type: 'NO_DOM2_EVENTS',
                fatal: true
            });
        }
    }
// SM2_DEFER details: http://www.schillmania.com/projects/soundmanager2/doc/getstarted/#lazy-loading
    if (window.SM2_DEFER === _undefined || !SM2_DEFER) {
        soundManager = new SoundManager();
    }
    if (typeof module === 'object' && module && typeof module.exports === 'object') {
        module.exports.SoundManager = SoundManager;
        module.exports.soundManager = soundManager;
    } else if (typeof define === 'function' && define.amd) {
        define(function() {
            function getInstance(smBuilder) {
                if (!window.soundManager && smBuilder instanceof Function) {
                    var instance = smBuilder(SoundManager);
                    if (instance instanceof SoundManager) {
                        window.soundManager = instance;
                    }
                }
                return window.soundManager;
            }
            return {
                constructor: SoundManager,
                getInstance: getInstance
            }
        });
    }
// standard browser case
// constructor
    window.SoundManager = SoundManager;
// public API, flash callbacks etc.
    window.soundManager = soundManager;
}(window));

if (typeof window.AJAX_REQUESTS == 'undefined') {
    window.AJAX_REQUESTS = [];
    window.AJAX_METHODS = [];
}

/*
 Faux frames and faux scrolling
 */

if (typeof window.block_data_cache == 'undefined') {
    window.block_data_cache = {};
}

if (typeof window.infinite_scroll_pending == 'undefined') {
    window.infinite_scroll_pending = false; // Blocked due to queued HTTP request
    window.infinite_scroll_blocked = false; // Blocked due to event tracking active
}
function infinite_scrolling_block(event) {
    if (event.keyCode == 35) // 'End' key pressed, so stop the expand happening for a few seconds while the browser scrolls down
    {
        window.infinite_scroll_blocked = true;
        window.setTimeout(function () {
            window.infinite_scroll_blocked = false;
        }, 3000);
    }
}
if (typeof window.infinite_scroll_mouse_held == 'undefined') {
    window.infinite_scroll_mouse_held = false;
}
function infinite_scrolling_block_hold() {
    if (!window.infinite_scroll_blocked) {
        window.infinite_scroll_blocked = true;
        window.infinite_scroll_mouse_held = true;
    }
}
function infinite_scrolling_block_unhold(infinite_scrolling) {
    if (window.infinite_scroll_mouse_held) {
        window.infinite_scroll_blocked = false;
        window.infinite_scroll_mouse_held = false;
        infinite_scrolling();
    }
}
function internalise_infinite_scrolling(url_stem, wrapper) {
    if (window.infinite_scroll_blocked || window.infinite_scroll_pending) return false; // Already waiting for a result

    var _pagination = wrapper.querySelectorAll('.pagination');

    if (_pagination.length == 0) return false;

    var more_links = [], found_new_links = null;

    for (var _i = 0; _i < _pagination.length; _i++) {
        var pagination = _pagination[_i];

        if (pagination.style.display != 'none') {
            // Remove visibility of pagination, now we've replaced with AJAX load more link
            var pagination_parent = pagination.parentNode;
            pagination.style.display = 'none';
            var num_node_children = 0;
            for (var i = 0; i < pagination_parent.childNodes.length; i++) {
                if (pagination_parent.childNodes[i].nodeName != '#text') num_node_children++;
            }
            if (num_node_children == 0) // Remove empty pagination wrapper
            {
                pagination_parent.style.display = 'none';
            }

            // Add AJAX load more link before where the last pagination control was
            // Remove old pagination_load_more's
            var pagination_load_more = wrapper.querySelectorAll('.pagination_load_more');
            if (pagination_load_more.length > 0) pagination_load_more[0].parentNode.removeChild(pagination_load_more[0]);

            // Add in new one
            var load_more_link = document.createElement('div');
            load_more_link.className = 'pagination_load_more';
            var load_more_link_a = document.createElement('a');
            Composr.dom.html(load_more_link_a, '{!LOAD_MORE;}');
            load_more_link_a.href = '#';
            load_more_link_a.onclick = function () {
                internalise_infinite_scrolling_go(url_stem, wrapper, more_links);
                return false;
            }; // Click link -- load
            load_more_link.appendChild(load_more_link_a);
            _pagination[_pagination.length - 1].parentNode.insertBefore(load_more_link, _pagination[_pagination.length - 1].nextSibling);

            more_links = pagination.getElementsByTagName('a');
            found_new_links = _i;
        }
    }
    for (var _i = 0; _i < _pagination.length; _i++) {
        var pagination = _pagination[_i];
        if (found_new_links != null) // Cleanup old pagination
        {
            if (_i != found_new_links) {
                var _more_links = pagination.getElementsByTagName('a');
                var num_links = _more_links.length;
                for (var i = num_links - 1; i >= 0; i--) {
                    _more_links[i].parentNode.removeChild(_more_links[i]);
                }
            }
        } else // Find links from an already-hidden pagination
        {
            more_links = pagination.getElementsByTagName('a');
            if (more_links.length != 0) break;
        }
    }

    // Is more scrolling possible?
    var rel, found_rel = false;
    for (var i = 0; i < more_links.length; i++) {
        rel = more_links[i].getAttribute('rel');
        if (rel && rel.indexOf('next') != -1) {
            found_rel = true;
        }
    }
    if (!found_rel) // Ah, no more scrolling possible
    {
        // Remove old pagination_load_more's
        var pagination_load_more = wrapper.querySelectorAll('.pagination_load_more');
        if (pagination_load_more.length > 0) pagination_load_more[0].parentNode.removeChild(pagination_load_more[0]);

        return;
    }

    // Used for calculating if we need to scroll down
    var wrapper_pos_y = find_pos_y(wrapper);
    var wrapper_height = wrapper.offsetHeight;
    var wrapper_bottom = wrapper_pos_y + wrapper_height;
    var window_height = get_window_height();
    var page_height = get_window_scroll_height();
    var scroll_y = window.pageYOffset;

    // Scroll down -- load
    if ((scroll_y + window_height > wrapper_bottom - window_height * 2) && (scroll_y + window_height < page_height - 30)) // If within window_height*2 pixels of load area and not within 30 pixels of window bottom (so you can press End key)
    {
        return internalise_infinite_scrolling_go(url_stem, wrapper, more_links);
    }

    return false;
}
function internalise_infinite_scrolling_go(url_stem, wrapper, more_links) {
    if (window.infinite_scroll_pending) return false;

    var wrapper_inner = document.getElementById(wrapper.id + '_inner');
    if (!wrapper_inner) wrapper_inner = wrapper;

    var rel;
    for (var i = 0; i < more_links.length; i++) {
        rel = more_links[i].getAttribute('rel');
        if (rel && rel.indexOf('next') != -1) {
            var next_link = more_links[i];
            var url_stub = '';

            var matches = next_link.href.match(new RegExp('[&?](start|[^_]*_start|start_[^_]*)=([^&]*)'));
            if (matches) {
                url_stub += (url_stem.indexOf('?') == -1) ? '?' : '&';
                url_stub += matches[1] + '=' + matches[2];
                url_stub += '&raw=1';
                window.infinite_scroll_pending = true;

                return call_block(url_stem + url_stub, '', wrapper_inner, true, function () {
                    window.infinite_scroll_pending = false;
                    internalise_infinite_scrolling(url_stem, wrapper);
                });
            }
        }
    }

    return false;
}

function internalise_ajax_block_wrapper_links(url_stem, block_element, look_for, extra_params, append, forms_too, scroll_to_top) {
    if (typeof look_for == 'undefined') look_for = [];
    if (typeof extra_params == 'undefined') extra_params = [];
    if (typeof append == 'undefined') append = false;
    if (typeof forms_too == 'undefined') forms_too = false;
    if (typeof scroll_to_top == 'undefined') scroll_to_top = true;

    var block_pos_y = find_pos_y(block_element, true);
    if (block_pos_y > window.pageYOffset) {
        scroll_to_top = false;
    }

    var _link_wrappers = block_element.querySelectorAll('.ajax_block_wrapper_links');
    if (_link_wrappers.length == 0) _link_wrappers = [block_element];
    var links = [];
    for (var i = 0; i < _link_wrappers.length; i++) {
        var _links = _link_wrappers[i].getElementsByTagName('a');
        for (var j = 0; j < _links.length; j++)
            links.push(_links[j]);
        if (forms_too) {
            _links = _link_wrappers[i].getElementsByTagName('form');
            for (var j = 0; j < _links.length; j++)
                links.push(_links[j]);
            if (_link_wrappers[i].nodeName.toLowerCase() == 'form')
                links.push(_link_wrappers[i]);
        }
    }
    for (var i = 0; i < links.length; i++) {
        if ((links[i].target) && (links[i].target == '_self') && ((!links[i].href) || (links[i].href.substr(0, 1) != '#'))) {
            var submit_func = function () {
                var url_stub = '';

                var href = (this.nodeName.toLowerCase() == 'a') ? this.href : this.action;

                // Any parameters matching a pattern must be sent in the URL to the AJAX block call
                for (var j = 0; j < look_for.length; j++) {
                    var matches = href.match(new RegExp('[&\?](' + look_for[j] + ')=([^&]*)'));
                    if (matches) {
                        url_stub += (url_stem.indexOf('?') == -1) ? '?' : '&';
                        url_stub += matches[1] + '=' + matches[2];
                    }
                }
                for (var j in extra_params) {
                    url_stub += (url_stem.indexOf('?') == -1) ? '?' : '&';
                    url_stub += j + '=' + window.encodeURIComponent(extra_params[j]);
                }

                // Any POST parameters?
                var post_params = null, param;
                if (this.nodeName.toLowerCase() == 'form') {
                    post_params = '';
                    for (var j = 0; j < this.elements.length; j++) {
                        if (this.elements[j].name) {
                            param = this.elements[j].name + '=' + window.encodeURIComponent(clever_find_value(this, this.elements[j]));

                            if ((!this.method) || (this.method.toLowerCase() != 'get')) {
                                if (post_params != '') post_params += '&';
                                post_params += param;
                            } else {
                                url_stub += (url_stem.indexOf('?') == -1) ? '?' : '&';
                                url_stub += param;
                            }
                        }
                    }
                }

                if (typeof window.history.pushState != 'undefined') {
                    try {
                        window.has_js_state = true;
                        history.pushState({js: true}, document.title, href.replace('&ajax=1', '').replace(/&zone=\w+/, ''));
                    }
                    catch (e) {
                    }
                    ; // Exception could have occurred due to cross-origin error (e.g. "Failed to execute 'pushState' on 'History': A history state object with URL 'https://xxx' cannot be created in a document with origin 'http://xxx'")
                }

                clear_out_tooltips(null);

                // Make AJAX block call
                return call_block(url_stem + url_stub, '', block_element, append, function () {
                    if (scroll_to_top) window.scrollTo(0, block_pos_y);
                }, false, post_params);
            };
            if (links[i].nodeName.toLowerCase() == 'a') {
                if (links[i].onclick) {
                    links[i].onclick = function (old_onclick) {
                        return function (event) {
                            return old_onclick.call(this, event) !== false && submit_func.call(this, event);
                        }
                    }(links[i].onclick);
                } else {
                    links[i].onclick = submit_func;
                }
            } else {
                if (links[i].onsubmit) {
                    links[i].onsubmit = function (old_onsubmit) {
                        return function (event) {
                            return old_onsubmit.call(this, event) !== false && submit_func.call(this, event);
                        }
                    }(links[i].onsubmit);
                } else {
                    links[i].onsubmit = submit_func;
                }
            }
        }
    }
}

// This function will load a block, with options for parameter changes, and render the results in specified way - with optional callback support
function call_block(url, new_block_params, target_div, append, callback, scroll_to_top_of_wrapper, post_params, inner, show_loading_animation) {
    if (typeof scroll_to_top_of_wrapper == 'undefined') scroll_to_top_of_wrapper = false;
    if (typeof post_params == 'undefined') post_params = null;
    if (typeof inner == 'undefined') inner = false;
    if (typeof show_loading_animation == 'undefined') show_loading_animation = true;
    if ((typeof block_data_cache[url] == 'undefined') && (new_block_params != ''))
        block_data_cache[url] = Composr.dom.html(target_div); // Cache start position. For this to be useful we must be smart enough to pass blank new_block_params if returning to fresh state

    var ajax_url = url;
    if (new_block_params != '') ajax_url += '&block_map_sup=' + window.encodeURIComponent(new_block_params);
    ajax_url += '&utheme=' + Composr.$THEME;
    if (typeof block_data_cache[ajax_url] != 'undefined' && post_params == null) {
        // Show results from cache
        show_block_html(block_data_cache[ajax_url], target_div, append, inner);
        if (callback) callback();
        return false;
    }

    // Show loading animation
    var loading_wrapper = target_div;
    if ((loading_wrapper.id.indexOf('carousel_') == -1) && (Composr.dom.html(loading_wrapper).indexOf('ajax_loading_block') == -1) && (show_loading_animation)) {
        var raw_ajax_grow_spot = target_div.querySelectorAll('.raw_ajax_grow_spot');
        if (typeof raw_ajax_grow_spot[0] != 'undefined' && append) loading_wrapper = raw_ajax_grow_spot[0]; // If we actually are embedding new results a bit deeper
        var loading_wrapper_inner = document.createElement('div');
        var position_type = window.getComputedStyle(loading_wrapper).getPropertyValue('position');
        if ((position_type != 'relative') && (position_type != 'absolute')) {
            if (append) {
                loading_wrapper_inner.style.position = 'relative';
            } else {
                loading_wrapper.style.position = 'relative';
                loading_wrapper.style.overflow = 'hidden'; // Stops margin collapsing weirdness
            }
        }
        var loading_image = document.createElement('img');
        loading_image.className = 'ajax_loading_block';
        loading_image.src = Composr.url('{$IMG;,loading}');
        loading_image.style.position = 'absolute';
        loading_image.style.zIndex = '1000';
        loading_image.style.left = (target_div.offsetWidth / 2 - 10) + 'px';
        if (!append) {
            loading_image.style.top = (target_div.offsetHeight / 2 - 20) + 'px';
        } else {
            loading_image.style.top = 0;
            loading_wrapper_inner.style.height = '30px';
        }
        loading_wrapper_inner.appendChild(loading_image);
        loading_wrapper.appendChild(loading_wrapper_inner);
        window.document.body.style.cursor = 'wait';
    }

    // Make AJAX call
    do_ajax_request(
        ajax_url + keep_stub(),
        function (raw_ajax_result) { // Show results when available
            _call_block_render(raw_ajax_result, ajax_url, target_div, append, callback, scroll_to_top_of_wrapper, inner);
        },
        post_params
    );

    return false;
}

function _call_block_render(raw_ajax_result, ajax_url, target_div, append, callback, scroll_to_top_of_wrapper, inner) {
    var new_html = raw_ajax_result.responseText;
    block_data_cache[ajax_url] = new_html;

    // Remove loading animation if there is one
    var ajax_loading = target_div.querySelector('.ajax_loading_block');
    if (ajax_loading) {
        ajax_loading.parentNode.parentNode.removeChild(ajax_loading.parentNode);
    }
    window.document.body.style.cursor = '';

    // Put in HTML
    show_block_html(new_html, target_div, append, inner);

    // Scroll up if required
    if (scroll_to_top_of_wrapper) {
        try {
            window.scrollTo(0, find_pos_y(target_div));
        }
        catch (e) {
        }
    }

    // Defined callback
    if (callback) callback();
}

function show_block_html(new_html, target_div, append, inner) {
    var raw_ajax_grow_spot = target_div.querySelectorAll('.raw_ajax_grow_spot');
    if (typeof raw_ajax_grow_spot[0] != 'undefined' && append) target_div = raw_ajax_grow_spot[0]; // If we actually are embedding new results a bit deeper
    if (append) {
        Composr.dom.appendHtml(target_div, new_html);
    } else {
        if (inner) {
            Composr.dom.html(target_div, new_html);
        } else {
            Composr.dom.outerHtml(target_div, new_html);
        }
    }
}

function ajax_form_submit__admin__headless(event, form, block_name, map) {
    if (typeof window.clever_find_value == 'undefined') return true;

    var post = '';
    if (typeof block_name != 'undefined') {
        if (typeof map == 'undefined') map = '';
        var comcode = '[block' + map + ']' + block_name + '[/block]';
        post += 'data=' + window.encodeURIComponent(comcode);
    }
    for (var i = 0; i < form.elements.length; i++) {
        if (!form.elements[i].disabled && typeof form.elements[i].name != 'undefined' && form.elements[i].name != null && form.elements[i].name != '')
            post += '&' + form.elements[i].name + '=' + window.encodeURIComponent(clever_find_value(form, form.elements[i]));
    }
    var request = do_ajax_request(maintain_theme_in_link('{$FIND_SCRIPT_NOHTTP;,comcode_convert}' + keep_stub(true)), null, post);

    if ((request.responseText != '') && (request.responseText != '')) {
        if (request.responseText != 'false') {
            var result_tags = request.responseXML.documentElement.getElementsByTagName('result');
            if ((result_tags) && (result_tags.length != 0)) {
                var result = result_tags[0];
                var xhtml = merge_text_nodes(result.childNodes);

                var element_replace = form;
                while (element_replace.className != 'form_ajax_target') {
                    element_replace = element_replace.parentNode;
                    if (!element_replace) return true; // Oh dear, target not found
                }

                Composr.dom.html(element_replace, xhtml);

                window.fauxmodal_alert('{!SUCCESS;}');

                return false; // We've handled it internally
            }
        }
    }

    return true;
}

/*
 Validation
 */

/* Calls up a URL to check something, giving any 'feedback' as an error (or if just 'false' then returning false with no message) */
function do_ajax_field_test(url, post) {
    var xmlhttp = do_ajax_request(url, null, post);
    if ((xmlhttp.responseText != '') && (xmlhttp.responseText.replace(/[ \t\n\r]/g, '') != '0'/*some cache layers may change blank to zero*/)) {
        if (xmlhttp.responseText != 'false') {
            if (xmlhttp.responseText.length > 1000) {
                if (typeof window.console != 'undefined') console.log(xmlhttp.responseText);

                fauxmodal_alert(xmlhttp.responseText, null, '{!ERROR_OCCURRED;}', true);
            } else {
                window.fauxmodal_alert(xmlhttp.responseText);
            }
        }
        return false;
    }
    return true;
}

/*
 Request backend
 */

function do_ajax_request(url, callback__method, post) // Note: 'post' is not an array, it's a string (a=b)
{
    var synchronous = !callback__method;

    if ((url.indexOf('://') == -1) && (url.substr(0, 1) == '/')) {
        url = window.location.protocol + '//' + window.location.host + url;
    }

    if ((typeof window.AJAX_REQUESTS == 'undefined') || (!window.AJAX_REQUESTS)) return null; // Probably the page is in process of being navigated away so window object is gone

    var index = window.AJAX_REQUESTS.length;
    window.AJAX_METHODS[index] = callback__method;

    window.AJAX_REQUESTS[index] = new XMLHttpRequest();

    if (!synchronous) window.AJAX_REQUESTS[index].onreadystatechange = process_request_changes;
    if (typeof post != 'undefined' && post !== null) {
        if (post.indexOf('&csrf_token') == -1)
            post += '&csrf_token=' + window.encodeURIComponent(get_csrf_token()); // For CSRF prevention

        window.AJAX_REQUESTS[index].open('POST', url, !synchronous);
        window.AJAX_REQUESTS[index].setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        window.AJAX_REQUESTS[index].send(post);
    } else {
        window.AJAX_REQUESTS[index].open('GET', url, !synchronous);
        window.AJAX_REQUESTS[index].send(null);
    }

    if ((typeof window.AJAX_REQUESTS == 'undefined') || (!window.AJAX_REQUESTS)) return null; // Probably the page is in process of being navigated away so window object is gone
    var result = window.AJAX_REQUESTS[index];
    if (synchronous) {
        window.AJAX_REQUESTS[index] = null;
    }
    return result;
}

function process_request_changes() {
    if ((typeof window.AJAX_REQUESTS == 'undefined') || (!window.AJAX_REQUESTS)) return null; // Probably the page is in process of being navigated away so window object is gone

    // If any AJAX_REQUESTS are 'complete'
    var i, result;
    for (i = 0; i < window.AJAX_REQUESTS.length; i++) {
        result = window.AJAX_REQUESTS[i];
        if ((result != null) && (result.readyState) && (result.readyState == 4)) {
            window.AJAX_REQUESTS[i] = null;

            // If status is 'OK'
            if ((result.status) && ((result.status == 200) || (result.status == 500) || (result.status == 400) || (result.status == 401))) {
                // Process the result
                if ((window.AJAX_METHODS[i]) && (typeof window.AJAX_METHODS[i] === 'function') && (!result.responseXML/*Not payload handler and not stack trace*/ || result.responseXML.childNodes.length == 0)) {
                    return window.AJAX_METHODS[i](result);
                }
                var xml = handle_errors_in_result(result);
                if (xml) {
                    xml.validateOnParse = false;
                    var ajax_result_frame = xml.documentElement;
                    if (!ajax_result_frame) ajax_result_frame = xml;
                    process_request_change(ajax_result_frame, i);
                }
            }
            else {
                try {
                    if ((result.status == 0) || (result.status == 12029)) // 0 implies site down, or network down
                    {
                        if ((!window.network_down) && (!window.unloaded)) {
                            if (result.status == 12029) window.fauxmodal_alert('{!NETWORK_DOWN;^}');
                            window.network_down = true;
                        }
                    } else {
                        if (typeof console.log != 'undefined') console.log('{!PROBLEM_RETRIEVING_XML;^}\n' + result.status + ': ' + result.statusText + '.');
                    }
                }
                catch (e) {
                    if (typeof console.log != 'undefined') console.log('{!PROBLEM_RETRIEVING_XML;^}');		// This is probably clicking back
                }
            }
        }
    }
}

function handle_errors_in_result(result) {
    if ((result.responseXML == null) || (result.responseXML.childNodes.length == 0)) {
        // Try and parse again. Firefox can be weird.
        var xml;
        try {
            xml = (new DOMParser()).parseFromString(result.responseText, 'application/xml');
        } catch (e) {
        }

        if (xml) return xml;

        if ((result.responseText) && (result.responseText != '') && (result.responseText.indexOf('<html') != -1)) {
            console.log(result);

            fauxmodal_alert(result.responseText, null, '{!ERROR_OCCURRED;}', true);
        }
        return false;
    }
    return result.responseXML;
}

function process_request_change(ajax_result_frame, i) {
    if (!ajax_result_frame) return null; // Needed for Opera
    if ((typeof window.AJAX_REQUESTS == 'undefined') || (!window.AJAX_REQUESTS)) return null; // Probably the page is in process of being navigated away so window object is gone

    if (ajax_result_frame.getElementsByTagName('message')[0]) {
        // Either an error or a message was returned. :(
        var message = ajax_result_frame.getElementsByTagName('message')[0].firstChild.data;

        if (ajax_result_frame.getElementsByTagName('error')[0]) {
            // It's an error :|
            window.fauxmodal_alert('An error (' + ajax_result_frame.getElementsByTagName('error')[0].firstChild.data + ') message was returned by the server: ' + message);
            return null;
        }

        window.fauxmodal_alert('An informational message was returned by the server: ' + message);
        return null;
    }

    var ajax_result = ajax_result_frame.getElementsByTagName('result')[0];
    if (!ajax_result) return null;

    if ((ajax_result_frame.getElementsByTagName('method')[0]) || (window.AJAX_METHODS[i])) {
        var method = (ajax_result_frame.getElementsByTagName('method')[0]) ? eval('return ' + merge_text_nodes(ajax_result_frame.getElementsByTagName('method')[0])) : window.AJAX_METHODS[i];
        if (typeof method.response != 'undefined') method.response(ajax_result_frame, ajax_result);
        else method(ajax_result_frame, ajax_result);

    }// else window.fauxmodal_alert('Method required: as it is non-blocking');

    return null;
}

function merge_text_nodes(childNodes) {
    var i, text = '';
    for (i = 0; i < childNodes.length; i++) {
        if (childNodes[i].nodeName == '#text') {
            text += childNodes[i].data;
        }
    }
    return text;
}

"use strict";

if (typeof window.current_list_for == 'undefined') {
    window.current_list_for = null;
    window.currently_doing_list = null;
}

function update_ajax_admin_search_list(target, e) {
    update_ajax_member_list(target, 'admin_search', false, e);
}

function update_ajax_search_list(target, e, search_type) {
    var special = 'search';
    if (typeof search_type != 'undefined') special += '&search_type=' + window.encodeURIComponent(search_type);
    update_ajax_member_list(target, special, false, e);
}

function update_ajax_author_list(target, e) {
    update_ajax_member_list(target, 'author', false, e);
}

function close_down() {
    var current = document.getElementById('ajax_list');
    if (current) current.parentNode.removeChild(current);
}

function update_ajax_member_list(target, special, delayed, e) {
    // Uncomment the below to disable backspace
    //if (!e) target.onkeyup=function (e2) { update_ajax_member_list(target,special,delayed,e2); } ; // Make sure we get the event next time
    //if ((e) && (e.keyCode==8)) return; // No back key allowed

    if (e && enter_pressed(e)) {
        return null;
    }

    if (target.disabled) return;

    if (!browser_matches('ios')) {
        if (!target.onblur) target.onblur = function () {
            setTimeout(function () {
                close_down();
            }, 300);
        }
    }

    if (!delayed) // A delay, so as not to throw out too many requests
    {
        if (window.currently_doing_list) {
            window.clearTimeout(window.currently_doing_list);
            window.currently_doing_list = null;
        }
        var e_copy = {'keyCode': e.keyCode, 'which': e.which};
        window.currently_doing_list = window.setTimeout(function () {
            update_ajax_member_list(target, special, true, e_copy);
        }, 400);
        return;
    } else {
        window.currently_doing_list = null;
    }

    target.special = special;

    var v = target.value;

    window.current_list_for = target;
    var url = '{$FIND_SCRIPT;,namelike}?id=' + encodeURIComponent(v);
    if (special) url = url + '&special=' + special;

    if (typeof window.do_ajax_request != 'undefined') do_ajax_request(url + keep_stub(), update_ajax_member_list_response);
}

function update_ajax_member_list_response(result, list_contents) {
    if (!list_contents) return;
    if (window.current_list_for == null) return;

    close_down();

    var data_list = false;//(typeof document.createElement('datalist').options!='undefined');	Still to buggy in browsers

    //if (list_contents.childNodes.length==0) return;
    var list = document.createElement(data_list ? 'datalist' : 'select');
    list.className = 'people_list';
    list.setAttribute('id', 'ajax_list');
    if (data_list) {
        window.current_list_for.setAttribute('list', 'ajax_list');
    } else {
        if (list_contents.childNodes.length == 1) {// We need to make sure it is not a dropdown. Normally we'd use size (multiple isn't correct, but we'll try this for 1 as it may be more stable on some browsers with no side effects)
            list.setAttribute('multiple', 'multiple');
        } else {
            list.setAttribute('size', list_contents.childNodes.length + 1);
        }
        list.style.position = 'absolute';
        list.style.left = (find_pos_x(window.current_list_for)) + 'px';
        list.style.top = (find_pos_y(window.current_list_for) + window.current_list_for.offsetHeight) + 'px';
    }
    setTimeout(function () {
        list.style.zIndex++;
    }, 100); // Fixes Opera by causing a refresh

    if (list_contents.children.length == 0) return;

    var i, item, displaytext;
    for (i = 0; i < list_contents.children.length; i++) {
        item = document.createElement('option');
        item.value = list_contents.children[i].getAttribute('value');
        displaytext = item.value;
        if (list_contents.children[i].getAttribute('displayname') != '')
            displaytext = list_contents.children[i].getAttribute('displayname');
        item.text = displaytext;
        item.innerText = displaytext;
        list.appendChild(item);
    }
    item = document.createElement('option');
    item.disabled = true;
    item.text = '{!javascript:SUGGESTIONS_ONLY;}'.toUpperCase();
    item.innerText = '{!javascript:SUGGESTIONS_ONLY;}'.toUpperCase();
    list.appendChild(item);
    window.current_list_for.parentNode.appendChild(list);

    if (data_list) return;

    clear_transition_and_set_opacity(list, 0.0);
    fade_transition(list, 100, 30, 8);

    var current_list_for_copy = window.current_list_for;

    if (typeof window.current_list_for.old_onkeyup == 'undefined')
        window.current_list_for.old_onkeyup = window.current_list_for.onkeyup;
    if (typeof window.current_list_for.old_onchange == 'undefined')
        window.current_list_for.old_onchange = window.current_list_for.onchange;

    var make_selection = function (e) {
        var el = e.target;

        current_list_for_copy.value = el.value;
        current_list_for_copy.onkeyup = current_list_for_copy.old_onkeyup;
        current_list_for_copy.onchange = current_list_for_copy.old_onchange;
        current_list_for_copy.onkeypress = function () {
        };
        if (typeof current_list_for_copy.onrealchange != 'undefined' && current_list_for_copy.onrealchange) current_list_for_copy.onrealchange(e);
        if (typeof current_list_for_copy.onchange != 'undefined' && current_list_for_copy.onchange) current_list_for_copy.onchange(e);
        var al = document.getElementById('ajax_list');
        al.parentNode.removeChild(al);
        window.setTimeout(function () {
            current_list_for_copy.focus();
        }, 300);
    };

    window.current_list_for.down_once = false;
    var handle_arrow_usage = function (event) {
        if (!event.shiftKey && Composr.dom.keyPressed(event, 'ArrowDown')) {// DOWN
            current_list_for_copy.disabled = true;
            window.setTimeout(function () {
                current_list_for_copy.disabled = false;
            }, 1000);

            var temp = current_list_for_copy.onblur;
            current_list_for_copy.onblur = function () {
            };
            list.focus();
            current_list_for_copy.onblur = temp;
            if (!current_list_for_copy.down_once) {
                current_list_for_copy.down_once = true;
                list.selectedIndex = 0;
            } else {
                if (list.selectedIndex < list.options.length - 1) list.selectedIndex++;
            }
            list.options[list.selectedIndex].selected = true;
            return cancel_bubbling(event);
        }
        if (!event.shiftKey && Composr.dom.keyPressed(event, 'ArrowUp')) {// UP
            current_list_for_copy.disabled = true;
            window.setTimeout(function () {
                current_list_for_copy.disabled = false;
            }, 1000);

            var temp = current_list_for_copy.onblur;
            current_list_for_copy.onblur = function () {
            };
            list.focus();
            current_list_for_copy.onblur = temp;
            if (!current_list_for_copy.down_once) {
                current_list_for_copy.down_once = true;
                list.selectedIndex = 0;
            } else {
                if (list.selectedIndex > 0) list.selectedIndex--;
            }
            list.options[list.selectedIndex].selected = true;
            return cancel_bubbling(event);
        }
        return null;
    };
    window.current_list_for.onkeyup = function (event) {
        var ret = handle_arrow_usage(event);
        if (ret != null) return ret;
        return update_ajax_member_list(current_list_for_copy, current_list_for_copy.special, false, event);
    };
    window.current_list_for.onchange = function (event) {
        current_list_for_copy.onkeyup = current_list_for_copy.old_onkeyup;
        current_list_for_copy.onchange = current_list_for_copy.old_onchange;
        if (current_list_for_copy.onchange) current_list_for_copy.onchange(event);
    };
    list.onkeyup = function (event) {
        var ret = handle_arrow_usage(event);
        if (ret != null) return ret;
        if (enter_pressed(event)) {// ENTER
            make_selection(event);
            current_list_for_copy.disabled = true;
            window.setTimeout(function () {
                current_list_for_copy.disabled = false;
            }, 200);

            return cancel_bubbling(event);
        }
        if (!event.shiftKey && Composr.dom.keyPressed(event, ['ArrowUp', 'ArrowDown'])) {
            if (event.cancelable) event.preventDefault();
            return cancel_bubbling(event);
        }
        return null;
    };

    window.current_list_for.onkeypress = function (event) {
        if (!event.shiftKey && Composr.dom.keyPressed(event, ['ArrowUp', 'ArrowDown'])) {
            if (event.cancelable) event.preventDefault();
            return cancel_bubbling(event);
        }
        return null;
    };
    list.onkeypress = function (event) {
        if (!event.shiftKey && Composr.dom.keyPressed(event, ['Enter', 'ArrowUp', 'ArrowDown'])) {
            if (event.cancelable) event.preventDefault();
            return cancel_bubbling(event);
        }
        return null;
    };

    list.addEventListener(browser_matches('ios') ? 'change' : 'click', make_selection, false);

    window.current_list_for = null;
}


/* Validation code and other general code relating to forms */

"use strict";

new Image().src = Composr.url('{$IMG;,loading}');

function password_strength(ob) {
    if (ob.name.indexOf('2') != -1) return;
    if (ob.name.indexOf('confirm') != -1) return;

    var _ind = document.getElementById('password_strength_' + ob.id);
    if (!_ind) return;
    var ind = _ind.getElementsByTagName('div')[0];
    var post = 'password=' + window.encodeURIComponent(ob.value);
    if (ob.form && typeof ob.form.elements['username'] != 'undefined') {
        post += '&username=' + ob.form.elements['username'].value;
    } else {
        if (ob.form && typeof ob.form.elements['edit_username'] != 'undefined') {
            post += '&username=' + ob.form.elements['edit_username'].value;
        }
    }
    var strength = load_snippet('password_strength', post);
    strength *= 2;
    if (strength > 10) strength = 10; // Normally too harsh!
    ind.style.width = (strength * 10) + 'px';
    if (strength >= 6)
        ind.style.backgroundColor = 'green';
    else if (strength < 4)
        ind.style.backgroundColor = 'red';
    else
        ind.style.backgroundColor = 'orange';
    ind.parentNode.style.display = (ob.value.length == 0) ? 'none' : 'block';
}

function fix_form_enter_key(form) {
    var submit = document.getElementById('submit_button');
    var inputs = form.getElementsByTagName('input');
    var type;
    for (var i = 0; i < inputs.length; i++) {
        type = inputs[i].type;
        if (((type == 'text') || (type == 'password') || (type == 'color') || (type == 'email') || (type == 'number') || (type == 'range') || (type == 'search') || (type == 'tel') || (type == 'url'))
            && (typeof submit.onclick != 'undefined') && (submit.onclick)
            && ((typeof inputs[i].onkeypress == 'undefined') || (!inputs[i].onkeypress)))
            inputs[i].onkeypress = function (event) {
                if (enter_pressed(event)) submit.onclick(event);
            };
    }
}

function radio_value(radios) {
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked) return radios[i].value;
    }
    return '';
}

function get_errormsg_element(id) {
    var errormsg_element = document.getElementById('error_' + id);
    if (!errormsg_element) {
        errormsg_element = document.getElementById('error_' + id.replace(/\_day$/, '').replace(/\_month$/, '').replace(/\_year$/, '').replace(/\_hour$/, '').replace(/\_minute$/, ''));
    }
    return errormsg_element;
}

function set_field_error(the_element, error_msg) {
    if (typeof the_element.name != 'undefined') {
        var id = the_element.name;
        var errormsg_element = get_errormsg_element(id);
        if ((error_msg == '') && (id.indexOf('_hour') != -1) || (id.indexOf('_minute') != -1)) return; // Do not blank out as day/month/year (which comes first) would have already done it
        if (errormsg_element) {
            // Make error message visible, if there's an error
            errormsg_element.style.display = (error_msg == '') ? 'none' : 'block';

            // Changed error message
            if (Composr.dom.html(errormsg_element) != escape_html(error_msg)) {
                Composr.dom.html(errormsg_element, '');
                if (error_msg != '') // If there actually an error
                {
                    the_element.setAttribute('aria-invalid', 'true');

                    // Need to switch tab?
                    var p = errormsg_element;
                    while (p !== null) {
                        p = p.parentNode;
                        if ((error_msg.substr(0, 5) != '{!DISABLED_FORM_FIELD;}'.substr(0, 5)) && (p) && (typeof p.getAttribute != 'undefined') && (p.getAttribute('id')) && (p.getAttribute('id').substr(0, 2) == 'g_') && (p.style.display == 'none')) {
                            select_tab('g', p.getAttribute('id').substr(2, p.id.length - 2), false, true);
                            break;
                        }
                    }

                    // Set error message
                    var msg_node = document.createTextNode(error_msg);
                    errormsg_element.appendChild(msg_node);
                    errormsg_element.setAttribute('role', 'alert');

                    // Fade in
                    clear_transition_and_set_opacity(errormsg_element, 0.0);
                    fade_transition(errormsg_element, 100, 30, 4);

                } else {
                    the_element.setAttribute('aria-invalid', 'false');
                    errormsg_element.setAttribute('role', '');
                }
            }
        }
    }
    if ((typeof window.is_wysiwyg_field != 'undefined') && (is_wysiwyg_field(the_element))) the_element = the_element.parentNode;
    the_element.className = the_element.className.replace(/( input_erroneous($| ))+/g, ' ');
    if (error_msg != '') {
        the_element.className = the_element.className + ' input_erroneous';
    }
}

function do_form_submit(form, event) {
    if (!check_form(form, false)) {
        return false;
    }

    if (form.old_action) {
        form.setAttribute('action', form.old_action);
    }
    if (form.old_target) {
        form.setAttribute('target', form.old_target);
    }
    if (!form.getAttribute('target')) {
        form.setAttribute('target', '_top');
    }

    /* Remove any stuff that is only in the form for previews if doing a GET request */
    if (form.method.toLowerCase() === 'get') {
        var i = 0, name, elements = [];
        for (i = 0; i < form.elements.length; i++) {
            elements.push(form.elements[i]);
        }
        for (i = 0; i < elements.length; i++) {
            name = elements[i].name;
            if (name && ((name.substr(0, 11) == 'label_for__') || (name.substr(0, 14) == 'tick_on_form__') || (name.substr(0, 9) == 'comcode__') || (name.substr(0, 9) == 'require__'))) {
                elements[i].parentNode.removeChild(elements[i]);
            }
        }
    }
    if (form.onsubmit) {
        var ret = form.onsubmit.call(form, event);
        if (!ret) {
            return false;
        }
    }
    if (!window.just_checking_requirements) {
        form.submit();
    }

    Composr.ui.disableSubmitAndPreviewButtons();

    if (window.detect_interval !== undefined) {
        window.clearInterval(window.detect_interval);
        delete window.detect_interval;
    }

    return true;
}

function do_form_preview(event, form, preview_url, has_separate_preview) {
    if (has_separate_preview === undefined) has_separate_preview = false;

    if (!document.getElementById('preview_iframe')) {
        fauxmodal_alert('{!ADBLOCKER;}');
        return false;
    }

    preview_url += ((typeof window.mobile_version_for_preview == 'undefined') ? '' : ('&keep_mobile=' + (window.mobile_version_for_preview ? '1' : '0')));

    var old_action = form.getAttribute('action');

    if (!form.old_action) form.old_action = old_action;
    form.setAttribute('action', /*maintain_theme_in_link - no, we want correct theme images to work*/(preview_url) + ((form.old_action.indexOf('&uploading=1') != -1) ? '&uploading=1' : ''));
    var old_target = form.getAttribute('target');
    if (!old_target) old_target = '_top';
    /* not _self due to edit screen being a frame itself */
    if (!form.old_target) form.old_target = old_target;
    form.setAttribute('target', 'preview_iframe');

    if ((window.check_form) && (!check_form(form, true))) return false;

    if (form.onsubmit) {
        var test = form.onsubmit.call(form, event, true);
        if (!test) return false;
    }

    if ((has_separate_preview) || (window.has_separate_preview)) {
        form.setAttribute('action', form.old_action + ((form.old_action.indexOf('?') == -1) ? '?' : '&') + 'preview=1');
        return true;
    }

    document.getElementById('submit_button').style.display = 'inline';
    //window.setInterval(function() { resize_frame('preview_iframe',window.top.scrollY+window.top.get_window_height()); },1500);
    var pf = document.getElementById('preview_iframe');

    /* Do our loading-animation */
    if (!window.just_checking_requirements) {
        window.setInterval(window.trigger_resize, 500);
        /* In case its running in an iframe itself */
        illustrate_frame_load('preview_iframe');
    }

    Composr.ui.disableSubmitAndPreviewButtons();

    // Turn main post editing back off
    if (wysiwyg_set_readonly !== undefined) wysiwyg_set_readonly('post', true);

    return true;
}

function clever_find_value(form, element) {
    if ((typeof element.length != 'undefined') && (typeof element.nodeName == 'undefined')) {
        // Radio button
        element = element[0];
    }

    var value;
    switch (element.localName) {
        case 'textarea':
            value = (typeof window.get_textbox == 'undefined') ? element.value : get_textbox(element);
            break;
        case 'select':
            value = '';
            if (element.selectedIndex >= 0) {
                if (element.multiple) {
                    for (var i = 0; i < element.options.length; i++) {
                        if (element.options[i].selected) {
                            if (value != '') value += ',';
                            value += element.options[i].value;
                        }
                    }
                } else if (element.selectedIndex >= 0) {
                    value = element.options[element.selectedIndex].value;
                    if ((value == '') && (element.getAttribute('size') > 1)) value = '-1'; // Fudge, as we have selected something explicitly that is blank
                }
            }
            break;
        case 'input':
            switch (element.type) {
                case 'checkbox':
                    value = (element.checked) ? element.value : '';
                    break;

                case 'radio':
                    value = '';
                    for (var i = 0; i < form.elements.length; i++) {
                        if ((form.elements[i].name == element.name) && (form.elements[i].checked))
                            value = form.elements[i].value;
                    }
                    break;

                case 'hidden':
                case 'text':
                case 'color':
                case 'date':
                case 'datetime':
                case 'datetime-local':
                case 'email':
                case 'month':
                case 'number':
                case 'range':
                case 'search':
                case 'tel':
                case 'time':
                case 'url':
                case 'week':
                case 'password':
                default:
                    value = element.value;
                    break;
            }
    }
    return value;
}

function check_field(the_element, the_form) {
    var i, the_class, required, my_value, erroneous = false, error_msg = '', regexp, total_file_size = 0, alerted = false;

    // No checking for hidden elements
    if (((the_element.type == 'hidden') || (((the_element.style.display == 'none') || (the_element.parentNode.style.display == 'none') || (the_element.parentNode.parentNode.style.display == 'none') || (the_element.parentNode.parentNode.parentNode.style.display == 'none')) && ((typeof window.is_wysiwyg_field == 'undefined') || (!is_wysiwyg_field(the_element))))) && ((!the_element.className) || (the_element.classList.contains('hidden_but_needed')) == null)) {
        return null;
    }
    if (the_element.disabled) return null;

    // Test file sizes
    if ((the_element.type == 'file') && (the_element.files) && (the_element.files.item) && (the_element.files.item(0)) && (the_element.files.item(0).fileSize))
        total_file_size += the_element.files.item(0).fileSize;

    // Test file types
    if ((the_element.type == 'file') && (the_element.value) && (the_element.name != 'file_anytype')) {
        var allowed_types = '{$VALID_FILE_TYPES;}'.split(/,/);
        var type_ok = false;
        var theFileType = the_element.value.indexOf('.') ? the_element.value.substr(the_element.value.lastIndexOf('.') + 1) : '{!NONE;^}';
        for (var k = 0; k < allowed_types.length; k++) {
            if (allowed_types[k].toLowerCase() == theFileType.toLowerCase()) type_ok = true;
        }
        if (!type_ok) {
            error_msg = '{!INVALID_FILE_TYPE;^,xx1xx,{$VALID_FILE_TYPES}}'.replace(/xx1xx/g, theFileType).replace(/<[^>]*>/g, '').replace(/&[lr][sd]quo;/g, '\'').replace(/,/g, ', ');
            if (!alerted) window.fauxmodal_alert(error_msg);
            alerted = true;
        }
    }

    // Fix up bad characters
    if ((browser_matches('ie')) && (the_element.value) && (the_element.localName != 'select')) {
        var bad_word_chars = [8216, 8217, 8220, 8221];
        var fixed_word_chars = ['\'', '\'', '"', '"'];
        for (i = 0; i < bad_word_chars.length; i++) {
            regexp = new RegExp(String.fromCharCode(bad_word_chars[i]), 'gm');
            the_element.value = the_element.value.replace(regexp, fixed_word_chars[i]);
        }
    }

    // Class name
    the_class = the_element.classList[0];

    // Find whether field is required and value of it
    if (the_element.type == 'radio') {
        required = (typeof the_form.elements['require__' + the_element.name] != 'undefined') && (the_form.elements['require__' + the_element.name].value == '1');
    } else {
        required = the_element.className.indexOf('_required') != -1;
    }
    my_value = clever_find_value(the_form, the_element);

    // Prepare for custom error messages, stored as HTML5 data on the error message display element
    var errormsg_element = (typeof the_element.name == 'undefined') ? null : get_errormsg_element(the_element.name);

    // Blank?
    if ((required) && (my_value.replace(/&nbsp;/g, ' ').replace(/<br\s*\/?>/g, ' ').replace(/\s/g, '') == '')) {
        error_msg = '{!REQUIRED_NOT_FILLED_IN;^}';
        if ((errormsg_element) && (errormsg_element.getAttribute('data-errorUnfilled') != null) && (errormsg_element.getAttribute('data-errorUnfilled') != ''))
            error_msg = errormsg_element.getAttribute('data-errorUnfilled');
    } else {
        // Standard field-type checks
        if ((the_element.className.indexOf('date') != -1) && (the_element.name.match(/\_(day|month|year)$/)) && (my_value != '')) {
            var day = the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_day')].options[the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_day')].selectedIndex].value;
            var month = the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_month')].options[the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_month')].selectedIndex].value;
            var year = the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_year')].options[the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_year')].selectedIndex].value;
            var source_date = new Date(year, month - 1, day);
            if (year != source_date.getFullYear()) error_msg = '{!javascript:NOT_A_DATE;^}';
            if (month != source_date.getMonth() + 1) error_msg = '{!javascript:NOT_A_DATE;^}';
            if (day != source_date.getDate()) error_msg = '{!javascript:NOT_A_DATE;^}';
        }
        if (((the_class == 'input_email') || (the_class == 'input_email_required')) && (my_value != '') && (!my_value.match(/^[a-zA-Z0-9\._\-\+]+@[a-zA-Z0-9\._\-]+$/))) {
            error_msg = '{!javascript:NOT_A_EMAIL;^}'.replace('\{1}', my_value);
        }
        if (((the_class == 'input_username') || (the_class == 'input_username_required')) && (my_value != '') && (window.do_ajax_field_test) && (!do_ajax_field_test('{$FIND_SCRIPT_NOHTTP;,username_exists}?username=' + encodeURIComponent(my_value)))) {
            error_msg = '{!javascript:NOT_USERNAME;^}'.replace('\{1}', my_value);
        }
        if (((the_class == 'input_codename') || (the_class == 'input_codename_required')) && (my_value != '') && (!my_value.match(/^[a-zA-Z0-9\-\.\_]*$/))) {
            error_msg = '{!javascript:NOT_CODENAME;^}'.replace('\{1}', my_value);
        }
        if (((the_class == 'input_integer') || (the_class == 'input_integer_required')) && (my_value != '') && (parseInt(my_value, 10) != my_value - 0)) {
            error_msg = '{!javascript:NOT_INTEGER;^}'.replace('\{1}', my_value);
        }
        if (((the_class == 'input_float') || (the_class == 'input_float_required')) && (my_value != '') && (parseFloat(my_value) != my_value - 0)) {
            error_msg = '{!javascript:NOT_FLOAT;^}'.replace('\{1}', my_value);
        }

        // Shim for HTML5 regexp patterns
        if (the_element.getAttribute('pattern')) {
            if ((my_value != '') && (!my_value.match(new RegExp(the_element.getAttribute('pattern'))))) {
                error_msg = '{!javascript:PATTERN_NOT_MATCHED;^}'.replace('\{1}', my_value);
            }
        }

        // Custom error messages
        if (error_msg != '' && errormsg_element != null) {
            var custom_msg = errormsg_element.getAttribute('data-errorRegexp');
            if ((custom_msg != null) && (custom_msg != ''))
                error_msg = custom_msg;
        }
    }

    // Show error?
    set_field_error(the_element, error_msg);

    if ((error_msg != '') && (!erroneous)) {
        erroneous = true;
    }

    return [erroneous, total_file_size, alerted];
}

function check_form(the_form, for_preview) {
    var delete_element = document.getElementById('delete');
    if ((!for_preview) && (delete_element != null) && (((delete_element.classList[0] == 'input_radio') && (the_element.value != '0')) || (delete_element.classList[0] == 'input_tick')) && (delete_element.checked)) {
        return true;
    }

    var j, the_element, erroneous = false, total_file_size = 0, alerted = false, error_element = null, check_result;
    for (j = 0; j < the_form.elements.length; j++) {
        if (!the_form.elements[j]) continue;

        if (the_form.elements[j].localName == 'object') continue; // IE9 being weird!

        the_element = the_form.elements[j];

        check_result = check_field(the_element, the_form, for_preview);
        if (check_result != null) {
            erroneous = check_result[0] || erroneous;
            if (!error_element && erroneous) error_element = the_element;
            total_file_size += check_result[1];
            alerted = check_result[2] || alerted;

            if (check_result[0]) {
                var auto_reset_error = function (the_element) {
                    return function (event, no_recurse) {
                        var check_result = check_field(the_element, the_form, for_preview);
                        if ((check_result != null) && (!check_result[0])) {
                            set_field_error(the_element, '');
                        }

                        if ((!no_recurse) && (the_element.className.indexOf('date') != -1) && (the_element.name.match(/\_(day|month|year)$/))) {
                            var e = document.getElementById(the_element.id.replace(/\_(day|month|year)$/, '_day'));
                            if (e != the_element) e.onblur(event, true);
                            var e = document.getElementById(the_element.id.replace(/\_(day|month|year)$/, '_month'));
                            if (e != the_element) e.onblur(event, true);
                            var e = document.getElementById(the_element.id.replace(/\_(day|month|year)$/, '_year'));
                            if (e != the_element) e.onblur(event, true);
                        }
                    };
                };

                if (the_element.getAttribute('type') == 'radio') {
                    for (var i = 0; i < the_form.elements.length; i++) {
                        the_form.elements[i].onchange = auto_reset_error(the_form.elements[i]);
                    }
                } else {
                    the_element.onblur = auto_reset_error(the_element);
                }
            }
        }
    }

    if ((total_file_size > 0) && (the_form.elements['MAX_FILE_SIZE'])) {
        if (total_file_size > the_form.elements['MAX_FILE_SIZE'].value) {
            if (!erroneous) {
                error_element = the_element;
                erroneous = true;
            }
            if (!alerted) {
                window.fauxmodal_alert('{!javascript:TOO_MUCH_FILE_DATA;^}'.replace(new RegExp('\\\\{' + '1' + '\\\\}', 'g'), Math.round(total_file_size / 1024)).replace(new RegExp('\\\\{' + '2' + '\\\\}', 'g'), Math.round(the_form.elements['MAX_FILE_SIZE'].value / 1024)));
            }
            alerted = true;
        }
    }

    if (erroneous) {
        if (!alerted) window.fauxmodal_alert('{!IMPROPERLY_FILLED_IN;^}');
        var posy = find_pos_y(error_element, true);
        if (posy == 0) {
            posy = find_pos_y(error_element.parentNode, true);
        }
        if (posy != 0)
            smooth_scroll(posy - 50, null, null, function () {
                try {
                    error_element.focus();
                } catch (e) {
                }
                /* Can have exception giving focus on IE for invisible fields */
            });
    }

    // Try and workaround max_input_vars problem if lots of usergroups
    if (!erroneous) {
        var delete_e = document.getElementById('delete');
        var is_delete = delete_e && delete_e.type == 'checkbox' && delete_e.checked;
        var es = document.getElementsByTagName('select'), e;
        for (var i = 0; i < es.length; i++) {
            e = es[i];
            if ((e.name.match(/^access_\d+_privilege_/)) && ((is_delete) || (e.options[e.selectedIndex].value == '-1'))) {
                e.disabled = true;
            }
        }
    }

    return !erroneous;
}

function standard_alternate_fields_within(set_name, something_required) {
    var form = document.getElementById('set_wrapper_' + set_name);

    while (form.localName != 'form') {
        form = form.parentNode;
    }
    var fields = form.elements[set_name];
    var field_names = [];
    for (var i = 0; i < fields.length; i++) {
        if (typeof fields[i][0] == 'undefined') {
            if (fields[i].id.match(/^choose\_/))
                field_names.push(fields[i].id.replace(/^choose\_/, ''));
        } else {
            if (fields[i][0].id.match(/^choose\_/))
                field_names.push(fields[i][0].id.replace(/^choose\_/, ''));
        }
    }
    standard_alternate_fields(field_names, something_required);
}

// Do dynamic set_locked/set_required such that one of these must be set, but only one may be
function standard_alternate_fields(field_names, something_required, second_run) {
    if (typeof second_run == 'undefined') second_run = false;

    // Look up field objects
    var fields = [];

    for (var i = 0; i < field_names.length; i++) {
        var field = _standard_alternate_fields_get_object(field_names[i]);
        fields.push(field);
    }

    // Set up listeners...
    for (var i = 0; i < field_names.length; i++) {
        var field = fields[i];
        if ((!field) || (typeof field.alternating == 'undefined')) // ... but only if not already set
        {
            var self_function = function (e) {
                standard_alternate_fields(field_names, something_required, true);
            }; // We'll re-call ourself on change
            _standard_alternate_field_create_listeners(field, self_function);
        }
    }

    // Update things
    for (var i = 0; i < field_names.length; i++) {
        var field = fields[i];
        if (_standard_alternate_field_is_filled_in(field, second_run, false))
            return _standard_alternate_field_update_editability(field, fields, something_required);
    }

    // Hmm, force first one chosen then
    for (var i = 0; i < field_names.length; i++) {
        if (field_names[i] == '') {
            var radio_button = document.getElementById('choose_'); // Radio button handles field alternation
            radio_button.checked = true;
            return _standard_alternate_field_update_editability(null, fields, something_required);
        }

        var field = fields[i];
        if ((field) && (_standard_alternate_field_is_filled_in(field, second_run, true)))
            return _standard_alternate_field_update_editability(field, fields, something_required);
    }
}

function _standard_alternate_field_is_filled_in(field, second_run, force) {
    if (!field) return false; // N/A input is considered unset

    var is_set = force || ((field.value != '') && (field.value != '-1')) || ((typeof field.virtual_value != 'undefined') && (field.virtual_value != '') && (field.virtual_value != '-1'));

    var radio_button = document.getElementById('choose_' + (field ? field.name : '').replace(/\[\]$/, '')); // Radio button handles field alternation
    if (!radio_button) radio_button = document.getElementById('choose_' + field.name.replace(/\_\d+$/, '_'));
    if (second_run) {
        if (radio_button) return radio_button.checked;
    } else {
        if (radio_button) radio_button.checked = is_set;
    }
    return is_set;
}

function _standard_alternate_field_create_listeners(field, refreshFunction) {
    if ((!field) || (typeof field.nodeName != 'undefined')) {
        __standard_alternate_field_create_listeners(field, refreshFunction);
    } else {
        var i;
        for (i = 0; i < field.length; i++) {
            if (typeof field[i].name != 'undefined')
                __standard_alternate_field_create_listeners(field[i], refreshFunction);
        }
        field.alternating = true;
    }
    return null;
}

function __standard_alternate_field_create_listeners(field, refreshFunction) {
    var radio_button = document.getElementById('choose_' + (field ? field.name : '').replace(/\[\]$/, ''));
    if (!radio_button) radio_button = document.getElementById('choose_' + field.name.replace(/\_\d+$/, '_'));
    if (radio_button) // Radio button handles field alternation
    {
        radio_button.addEventListener('change', refreshFunction);
    } else { // Filling/blanking out handles field alternation
        if (field) {
            field.addEventListener('keyup', refreshFunction);
            field.addEventListener('change', refreshFunction);
            field.fakeonchange = refreshFunction;
        }
    }
    if (field) field.alternating = true;
}

function _standard_alternate_fields_get_object(field_name) {
    // Maybe it's an N/A so no actual field
    if (field_name == '') return null;

    // Try and get direct field
    var field = document.getElementById(field_name);
    if (field) return field;

    // A radio field, so we need to create a virtual field object to return that will hold our value
    var radio_buttons = [], i, j, e;
    /*JSLINT: Ignore errors*/
    radio_buttons['name'] = field_name;
    radio_buttons['value'] = '';
    for (i = 0; i < document.forms.length; i++) {
        for (j = 0; j < document.forms[i].elements.length; j++) {
            e = document.forms[i].elements[j];
            if (!e.name) continue;

            if ((e.name.replace(/\[\]$/, '') == field_name) || (e.name.replace(/\_\d+$/, '_') == field_name)) {
                radio_buttons.push(e);
                if (e.checked) // This is the checked radio equivalent to our text field, copy the value through to the text field
                {
                    radio_buttons['value'] = e.value;
                }
                if (e.alternating) radio_buttons.alternating = true;
            }
        }
    }

    if (radio_buttons.length == 0) return null;

    return radio_buttons;
}

function _standard_alternate_field_update_editability(chosen, choices, something_required) {
    for (var i = 0; i < choices.length; i++) {
        __standard_alternate_field_update_editability(choices[i], chosen, choices[i] != chosen, choices[i] == chosen, something_required);
    }
}
// NB: is_chosen may only be null if is_locked is false
function __standard_alternate_field_update_editability(field, chosen_field, is_locked, is_chosen, something_required) {
    if ((!field) || (typeof field.nodeName != 'undefined')) {
        ___standard_alternate_field_update_editability(field, chosen_field, is_locked, is_chosen, something_required);
    } else // List of fields (e.g. radio list, or just because standard_alternate_fields_within was used)
    {
        for (var i = 0; i < field.length; i++) {
            if (typeof field[i].name != 'undefined') // If it is an object, as opposed to some string in the collection
            {
                ___standard_alternate_field_update_editability(field[i], chosen_field, is_locked, is_chosen, something_required);
                something_required = false; // Only the first will be required
            }
        }
    }
}
function ___standard_alternate_field_update_editability(field, chosen_field, is_locked, is_chosen, something_required) {
    if (!field) return;

    var radio_button = document.getElementById('choose_' + field.name.replace(/\[\]$/, ''));
    if (!radio_button) radio_button = document.getElementById('choose_' + field.name.replace(/\_\d+$/, '_'));

    set_locked(field, is_locked, chosen_field);
    if (something_required) {
        set_required(field.name.replace(/\[\]$/, ''), is_chosen);
    }
}

function set_locked(field, is_locked, chosen_ob) {
    var radio_button = document.getElementById('choose_' + field.name.replace(/\[\]$/, ''));
    if (!radio_button) radio_button = document.getElementById('choose_' + field.name.replace(/\_\d+$/, '_'));

    // For All-and-not,Line-multi,Compound-Tick,Radio-List,Date/Time: set_locked assumes that the calling code is clever
    // special input types are coded to observe their master input field readonly status)
    var button = document.getElementById('uploadButton_' + field.name.replace(/\[\]$/, ''));

    if (is_locked) {
        var labels = document.getElementsByTagName('label'), label = null;
        for (var i = 0; i < labels.length; i++) {
            if ((chosen_ob) && (labels[i].getAttribute('for') == chosen_ob.id)) {
                label = labels[i];
                break;
            }
        }
        if (!radio_button) {
            if (label) {
                var label_nice = Composr.dom.html(label).replace('&raquo;', '').replace(/^\s*/, '').replace(/\s*$/, '');
                if (field.type == 'file') {
                    set_field_error(field, '{!DISABLED_FORM_FIELD_ENCHANCEDMSG_UPLOAD;^}'.replace(/\\{1\\}/, label_nice));
                } else {
                    set_field_error(field, '{!DISABLED_FORM_FIELD_ENCHANCEDMSG;^}'.replace(/\\{1\\}/, label_nice));
                }
            } else {
                set_field_error(field, '{!DISABLED_FORM_FIELD;^}');
            }
        }
        field.className = field.className.replace(/( input_erroneous($| ))+/g, ' ');
    } else {
        if (!radio_button) {
            set_field_error(field, '');
        }
    }
    field.disabled = is_locked;
    if (button) button.disabled = is_locked;
}

function set_required(field_name, is_required) {
    var radio_button = document.getElementById('choose_' + field_name);

    if (radio_button) {
        if (is_required) radio_button.checked = true;
    } else {
        var required_a = document.getElementById('form_table_field_name__' + field_name);
        var required_b = document.getElementById('required_readable_marker__' + field_name);
        var required_c = document.getElementById('required_posted__' + field_name);
        var required_d = document.getElementById('form_table_field_input__' + field_name);
        if (is_required) {
            if (required_a) required_a.className = 'form_table_field_name required';
            if (required_d) required_d.className = 'form_table_field_input';
            if (required_b) required_b.style.display = 'inline';
            if (required_c) required_c.value = 1;
        } else {
            if (required_a) required_a.className = 'form_table_field_name';
            if (required_d) required_d.className = 'form_table_field_input';
            if (required_b) required_b.style.display = 'none';
            if (required_c) required_c.value = 0;
        }
    }

    var element = document.getElementById(field_name);

    if (element) {
        element.className = element.className.replace(/(input\_[a-z\_]+)_required/g, '$1');

        if (typeof element.plupload_object != 'undefined') {
            element.plupload_object.settings.required = is_required;
        }

        if (is_required) element.className = element.className.replace(/(input\_[a-z\_]+)/g, '$1_required');
    }

    if (!is_required) {
        var error = document.getElementById('error__' + field_name);
        if (error) error.style.display = 'none';
    }
}


function choose_picture(j_id, img_ob, name, event) {
    var j = document.getElementById(j_id);
    if (!j) {
        return;
    }

    if (!img_ob) {
        img_ob = document.getElementById('w_' + j_id.substring(2, j_id.length)).getElementsByTagName('img')[0];
        if (img_ob === undefined) {
            return;
        }
    }

    var e = j.form.elements[name];
    for (var i = 0; i < e.length; i++) {
        if (e[i].disabled) continue;
        var img = e[i].parentNode.parentNode.querySelector('img');
        if (img && (img !== img_ob)) {
            if (img.parentNode.classList.has('selected')) {
                img.parentNode.classList.remove('selected');
                img.style.outline = '0';
                if (!browser_matches('ie8+')) {
                    img.style.background = 'none';
                }
            }
        }
    }

    if (j.disabled) {
        return;
    }
    j.checked = true;
    //if (j.onclick) j.onclick(); causes loop
    if (j.fakeonchange) {
        j.fakeonchange(event);
    }
    img_ob.parentNode.classList.add(' selected');
    img_ob.style.outline = '1px dotted';
}

function disable_preview_scripts(under) {
    if (under === undefined) {
        under = document;
    }

    var elements, i;
    var no_go = function () {
        window.fauxmodal_alert('{!NOT_IN_PREVIEW_MODE;^}');
        return false;
    };
    elements = under.getElementsByTagName('button');
    for (i = 0; i < elements.length; i++)
        elements[i].onclick = no_go;
    elements = under.getElementsByTagName('input');
    for (i = 0; i < elements.length; i++)
        if ((elements[i].getAttribute('type') == 'button') || (elements[i].getAttribute('type') == 'image')) elements[i].onclick = no_go;
    // Make sure links in the preview don't break it - put in a new window
    elements = under.getElementsByTagName('a');
    for (i = 0; i < elements.length; i++) {
        if (elements[i].href.indexOf('://') != -1) {
            try {
                if (((!elements[i].href) || (elements[i].href.toLowerCase().indexOf('javascript:') != 0)) && (elements[i].target !== '_self') && (elements[i].target !== '_blank')) // guard due to weird Firefox bug, JS actions still opening new window
                {
                    elements[i].target = 'false_blank'; // Real _blank would trigger annoying CSS. This is better anyway.
                }
            }
            catch (e) { // IE can have security exceptions
            }
        }
    }
}


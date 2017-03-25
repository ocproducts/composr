var encodeUC = encodeURIComponent;

(function ($cms, symbols) {
    'use strict';

    // Cached references
    var smile = ':)',
        encodeUC = encodeURIComponent,
        decodeUC = decodeURIComponent,
        emptyObj = {},
        emptyArr = [],
        docEl = document.documentElement,
        emptyEl = document.createElement('div'),
        emptyElStyle = emptyEl.style,

    // hasOwnProperty shorcut
        hasOwn = Function.bind.call(Function.call, emptyObj.hasOwnProperty),

        toArray = Function.bind.call(Function.call, emptyArr.slice),
        forEach = Function.bind.call(Function.call, emptyArr.forEach),
        includes = Function.bind.call(Function.call, emptyArr.includes),
        // Clever helper for merging arrays using `[].push`
        pushArray = Function.bind.call(Function.apply, emptyArr.push),

    // Browser detection. Credit: http://stackoverflow.com/a/9851769/362006
    // Opera 8.0+
        isOpera = (!!window.opr && !!window.opr.addons) || !!window.opera || (navigator.userAgent.includes(' OPR/')),
    // Firefox 1.0+
        isFirefox = (window.InstallTrigger !== undefined),
    // At least Safari 3+: HTMLElement's constructor's name is HTMLElementConstructor
        isSafari = internalName(window.HTMLElement) === 'HTMLElementConstructor',
    // Internet Explorer 6-11
        isIE = (/*@cc_on!@*/0 || (typeof document.documentMode === 'number')),
    // Edge 20+
        isEdge = !isIE && !!window.StyleMedia,
    // Chrome 1+
        isChrome = !!window.chrome && !!window.chrome.webstore;

    // Too useful to not have globally!
    window.intVal = intVal;
    window.strVal = strVal;
    window.arrVal = arrVal;
    window.objVal = objVal;

    /** @namespace $cms */
    $cms = extendDeep($cms, /** @lends $cms */ {
        // Unique for each copy of Composr on the page
        /**@var {string}*/
        id: 'composr' + ('' + Math.random()).substr(2),

        // Load up symbols data
        /**@var {boolean}*/
        $IS_GUEST: boolVal(symbols.IS_GUEST),
        /**@var {boolean}*/
        $IS_STAFF: boolVal(symbols.IS_STAFF),
        /**@var {boolean}*/
        $IS_ADMIN: boolVal(symbols.IS_ADMIN),
        /**@var {boolean}*/
        $IS_HTTPAUTH_LOGIN: boolVal(symbols.IS_HTTPAUTH_LOGIN),
        /**@var {boolean}*/
        $IS_A_COOKIE_LOGIN: boolVal(symbols.IS_A_COOKIE_LOGIN),
        /**@var {boolean}*/
        $DEV_MODE: boolVal(symbols.DEV_MODE),
        /**@var {boolean}*/
        $JS_ON: boolVal(symbols.JS_ON),
        /**@var {boolean}*/
        $MOBILE: boolVal(symbols.MOBILE),
        /**@var {boolean}*/
        $DESKTOP: !boolVal(symbols.MOBILE),
        /**@var {boolean}*/
        $FORCE_PREVIEWS: boolVal(symbols.FORCE_PREVIEWS),
        /**@var {boolean}*/
        $VERBOSE: true,

        /**@var {number}*/
        $HTTP_STATUS_CODE: (+symbols.HTTP_STATUS_CODE || 0),
        /**@var {number}*/
        $GROUP_ID: (+symbols.GROUP_ID || 0),

        /**@var {string}*/
        $VERSION: strVal(symbols.VERSION),
        /**@var {string}*/
        $PAGE: strVal(symbols.PAGE),
        /**@var {string}*/
        $PAGE_TITLE: strVal(symbols.PAGE_TITLE),
        /**@var {string}*/
        $ZONE: strVal(symbols.ZONE),
        /**@var {string}*/
        $MEMBER: strVal(symbols.MEMBER),
        /**@var {string}*/
        $USERNAME: strVal(symbols.USERNAME),
        /**@var {string}*/
        $AVATAR: strVal(symbols.AVATAR),
        /**@var {string}*/
        $MEMBER_EMAIL: strVal(symbols.MEMBER_EMAIL),
        /**@var {string}*/
        $PHOTO: strVal(symbols.PHOTO),
        /**@var {string}*/
        $MEMBER_PROFILE_URL: strVal(symbols.MEMBER_PROFILE_URL),
        /**@var {string}*/
        $FROM_TIMESTAMP: symbols.FROM_TIMESTAMP,
        /**@var {string}*/
        $THEME: strVal(symbols.THEME),
        /**@var {string}*/
        $LANG: strVal(symbols.LANG),
        /**@var {string}*/
        $BROWSER_UA: strVal(symbols.BROWSER_UA),
        /**@var {string}*/
        $OS: strVal(symbols.OS),
        /**@var {string}*/
        $USER_AGENT: strVal(symbols.USER_AGENT),
        /**@var {string}*/
        $IP_ADDRESS: strVal(symbols.IP_ADDRESS),
        /**@var {string}*/
        $TIMEZONE: strVal(symbols.TIMEZONE),
        /**@var {string}*/
        $CHARSET: strVal(symbols.CHARSET),
        /**@var {string}*/
        $KEEP: strVal(symbols.KEEP),
        /**@var {string}*/
        $PREVIEW_URL: strVal(symbols.PREVIEW_URL),
        /**@var {string}*/
        $SITE_NAME: strVal(symbols.SITE_NAME),
        /**@var {string}*/
        $COPYRIGHT: strVal(symbols.COPYRIGHT),
        /**@var {string}*/
        $DOMAIN: strVal(symbols.DOMAIN),
        /**@var {string}*/
        $FORUM_BASE_URL: strVal(symbols.FORUM_BASE_URL),
        /**@var {string}*/
        $BASE_URL: strVal(symbols.BASE_URL),
        /**@var {string}*/
        $BASE_URL_S: strVal(symbols.BASE_URL) + '/', // With trailing slash
        /**@var {string}*/
        $BASE_URL_PRL: toProtocolRelative(symbols.BASE_URL), // Protocol relative
        /**@var {string}*/
        $CUSTOM_BASE_URL: strVal(symbols.CUSTOM_BASE_URL),
        /**@var {string}*/
        $BASE_URL_NOHTTP: strVal(symbols.BASE_URL_NOHTTP),
        /**@var {string}*/
        $BASE_URL_NOHTTP_S: strVal(symbols.BASE_URL_NOHTTP) + '/', // With trailing slash
        /**@var {string}*/
        $CUSTOM_BASE_URL_NOHTTP: strVal(symbols.CUSTOM_BASE_URL_NOHTTP),
        /**@var {string}*/
        $BRAND_NAME: strVal(symbols.BRAND_NAME),
        /**@var {string}*/
        $SESSION_COOKIE_NAME: strVal(symbols.SESSION_COOKIE_NAME),
        /**@var {string}*/
        $COOKIE_PATH: strVal(symbols.COOKIE_PATH),
        /**@var {string}*/
        $COOKIE_DOMAIN: strVal(symbols.COOKIE_DOMAIN),

        /**@var {object}*/
        $CONFIG_OPTION: {
            /**@var {boolean}*/
            js_overlays: boolVal(symbols.CONFIG_OPTION.js_overlays),
            /**@var {boolean}*/
            enable_animations: boolVal(symbols.CONFIG_OPTION.enable_animations),
            /**@var {boolean}*/
            detect_javascript: boolVal(symbols.CONFIG_OPTION.detect_javascript),
            /**@var {boolean}*/
            is_on_timezone_detection: boolVal(symbols.CONFIG_OPTION.is_on_timezone_detection),
            /**@var {boolean}*/
            wysiwyg: boolVal(symbols.CONFIG_OPTION.wysiwyg),
            /**@var {boolean}*/
            complex_uploader: boolVal(symbols.CONFIG_OPTION.complex_uploader),
            /**@var {boolean}*/
            collapse_user_zones: boolVal(symbols.CONFIG_OPTION.collapse_user_zones),
            /**@var {boolean}*/
            sitewide_im: boolVal(symbols.CONFIG_OPTION.sitewide_im),
            /**@var {boolean}*/
            simplified_attachments_ui: boolVal(symbols.CONFIG_OPTION.simplified_attachments_ui),
            /**@var {boolean}*/
            spam_heuristic_pasting: boolVal(symbols.CONFIG_OPTION.spam_heuristic_pasting),

            /**@var {string}*/
            thumb_width: strVal(symbols.CONFIG_OPTION.thumb_width),
            /**@var {string}*/
            js_captcha: symbols.CONFIG_OPTION.js_captcha,
            /**@var {string}*/
            google_analytics: strVal(symbols.CONFIG_OPTION.google_analytics),
            /**@var {string}*/
            long_google_cookies: symbols.CONFIG_OPTION.long_google_cookies,
            /**@var {string}*/
            editarea: symbols.CONFIG_OPTION.editarea,
            /**@var {string}*/
            fixed_width: symbols.CONFIG_OPTION.fixed_width,
            /**@var {string}*/
            infinite_scrolling: symbols.CONFIG_OPTION.infinite_scrolling,
            /**@var {string}*/
            eager_wysiwyg: symbols.CONFIG_OPTION.eager_wysiwyg,
            /**@var {string}*/
            show_inline_stats: symbols.CONFIG_OPTION.show_inline_stats,
            /**@var {string}*/
            notification_desktop_alerts: symbols.CONFIG_OPTION.notification_desktop_alerts,
            /**@var {string}*/
            enable_theme_img_buttons: symbols.CONFIG_OPTION.enable_theme_img_buttons,
            /**@var {string}*/
            enable_previews: symbols.CONFIG_OPTION.enable_previews,
            /**@var {string}*/
            background_template_compilation: symbols.CONFIG_OPTION.background_template_compilation,
            /**@var {string}*/
            topic_pin_max_days: symbols.CONFIG_OPTION.topic_pin_max_days
        },
        /**@var {object}*/
        $VALUE_OPTION: {
            /**@var {string}*/
            js_keep_params: symbols.VALUE_OPTION.js_keep_params,
            /**@var {string}*/
            commercial_spellchecker: symbols.VALUE_OPTION.commercial_spellchecker
        },
        /**@var {object}*/
        $HAS_PRIVILEGE: {
            /**@var {string}*/
            sees_javascript_error_alerts: symbols.HAS_PRIVILEGE.sees_javascript_error_alerts
        },

        // Just some more useful stuff, (not tempcode symbols)
        /**@var {boolean}*/
        canTryUrlSchemes: boolVal(symbols.EXTRA.can_try_url_schemes),
        /**@var {object}*/
        staffTooltipsUrlPatterns: objVal(symbols.EXTRA.staff_tooltips_url_patterns),


        /**@var {boolean}*/
        isOpera: isOpera,
        /**@var {boolean}*/
        isFirefox: isFirefox,
        /**@var {boolean}*/
        isSafari: isSafari,
        /**@var {boolean}*/
        isIE: isIE,
        /**@var {boolean}*/
        isEdge: isEdge,
        /**@var {boolean}*/
        isChrome: isChrome,
        /**@var {boolean}*/
        isTouchEnabled: ('ontouchstart' in docEl),

        // Export useful stuff
        /**@method*/
        toArray: toArray,
        /**@method*/
        forEach: forEach,
        /**@method*/
        some: Function.bind.call(Function.call, emptyArr.some),
        /**@method*/
        every: Function.bind.call(Function.call, emptyArr.every),
        /**@method*/
        includes: includes,
        /**@method*/
        hasOwn: hasOwn,

        /**@method*/
        uid: uid,
        /**@method*/
        nodeType: nodeType,
        /**@method*/
        isEl: isEl,
        /**@method*/
        isNumeric: isNumeric,
        /**@method*/
        isDocOrEl: isDocOrEl,
        /**@method*/
        isArrayLike: isArrayLike,
        /**@method*/
        noop: noop,
        /**@method*/
        random: random,
        /**@method*/
        camelCase: camelCase,
        /**@method*/
        uspFromUrl: uspFromUrl,
        /**@method*/
        each: each,
        /**@method*/
        extend: extend,
        /**@method*/
        extendOwn: extendOwn,
        /**@method*/
        extendDeep: extendDeep,
        /**@method*/
        cloner: cloner,
        /**@method*/
        defaults: defaults,
        /**@method*/
        properties: properties,
        /**@method*/
        intVal: intVal,
        /**@method*/
        strVal: strVal,
        /**@method*/
        format: format,
        /**@method*/
        numberFormat: numberFormat,
        /**@method*/
        inherits: inherits,
        /**@method*/
        baseUrl: baseUrl,
        /**@method*/
        img: img,
        /**@method*/
        navigate: navigate,
        /**@method*/
        log: log,
        /**@method*/
        info: info,
        /**@method*/
        warn: warn,
        /**@method*/
        dir: dir,
        /**@method*/
        assert: assert,
        /**@method*/
        error: error,
        /**@method*/
        exception: exception,
        /**@method*/
        requireCss: requireCss,
        /**@method*/
        requireJavascript: requireJavascript,
        /**@method*/
        setPostDataFlag: setPostDataFlag,
        /**@method*/
        parseJson: parseJson,

        /**@method*/
        defineBehaviors: defineBehaviors,
        /**@method*/
        attachBehaviors: attachBehaviors,
        /**@method*/
        detachBehaviors: detachBehaviors
    });

    /**
     * Addons will add template related methods under this object
     * @namespace $cms.templates
     */
    $cms.templates || ($cms.templates = {});

    /**
     * Addons can add functions under this object
     * @namespace $cms.functions
     */
    $cms.functions || ($cms.functions = {});

    /**
     * Addons will add $cms.View subclasses under this object
     * @namespace $cms.views
     */
    $cms.views || ($cms.views = {});

    /**
     * @namespace $cms.viewInstances
     */
    $cms.viewInstances || ($cms.viewInstances = {});

    /**
     * @namespace $cms.ui
     */
    $cms.ui || ($cms.ui = {});

    /** @namespace $cms.settings */
    $cms.settings || ($cms.settings = {});

    /**
     * Addons will add "behaviors" under this object
     * @namespace $cms.behaviors
     */
    $cms.behaviors || ($cms.behaviors = {});

    /**
     * Browser feature detection
     * @namespace $cms.support
     */
    $cms.support || ($cms.support = {});

    /**
     * DOM helper methods
     * @namespace $cms.dom
     * */
    $cms.dom || ($cms.dom = {});

    var domReadyPromise = new Promise(function (resolve) {
        if (document.readyState === 'interactive') {
            window.setTimeout(resolve);
        } else {
            document.addEventListener('DOMContentLoaded', function listener() {
                document.removeEventListener('DOMContentLoaded', listener);
                resolve();
            });
        }
    });

    var loadWindowPromise = new Promise(function (resolve) {
        if (document.readyState === 'complete') {
            window.setTimeout(resolve);
        } else {
            window.addEventListener('load', function listener() {
                window.removeEventListener('load', listener);
                resolve();
            });
        }
    });

    /* Fulfill and resolve promises! */
    domReadyPromise.then(function () {
        $cms._resolveReady();
        delete $cms._resolveReady;
    });

    Promise.all([$cms.ready, loadWindowPromise]).then(function () {
        $cms._resolveLoad();
        delete $cms._resolveLoad;
    });

    $cms.usp = uspFromUrl(window.location.href);

    // usp with only the `keep_*` parameters
    $cms.uspKeep = new URLSearchParams();
    // this always has `keep_session` where possible
    $cms.uspKeepSession = new URLSearchParams();

    eachIter($cms.usp.entries(), function (entry) {
        var name = entry[0],
            value = entry[1];

        if (name.startsWith('keep_')) {
            $cms.uspKeep.set(name, value);
            $cms.uspKeepSession.set(name, value);
        }
    });

    var sessionId = get_session_id();

    if (sessionId && !$cms.uspKeepSession.has('keep_session')) {
        $cms.uspKeepSession.set('keep_session', sessionId);
    }

    function noop() {}

    // Generate a unique integer id (unique within the entire client session).
    var _uniqueId = 0;
    function uniqueId() {
        return ++_uniqueId;
    }

    /**
     * Used to uniquely identify objects/functions
     * @param {object|function} obj
     * @returns {number}
     */
    function uid(obj) {
        if ((obj == null) || ((typeof obj !== 'object') && (typeof obj !== 'function'))) {
            throw new TypeError('$cms.uid(): Parameter `obj` must be an object or a function.');
        }

        if (hasOwn(obj, $cms.id)) {
            return obj[$cms.id];
        }

        var id = uniqueId();
        properties(obj, keyValue($cms.id, id));
        return id;
    }

    function returnTrue() {
        return true;
    }

    function returnFalse() {
        return false;
    }

    function returnFirst(first) {
        return first;
    }

    function isObj(val) {
        return (val != null) && (typeof val === 'object');
    }

    function hasEnumerable(val) {
        if (val != null) {
            for (var key in val) {
                return true;
            }
        }
        return false;
    }

    function hasOwnEnumerable(val) {
        if (val != null) {
            for (var key in val) {
                if (hasOwn(val, key)) {
                    return true;
                }
            }
        }
        return false;
    }

    function isPlainObj(obj) {
        var proto;
        return isObj(obj) && (internalName(obj) === 'Object') && (((proto = Object.getPrototypeOf(obj)) === Object.prototype) || (proto === null));
    }

    function isArrayOrPlainObj(val) {
        return (val != null) && (Array.isArray(val) || isPlainObj(val));
    }

    function isScalar(val) {
        return (val != null) && ((typeof val === 'boolean') || (typeof val === 'number') || (typeof val === 'string'));
    }

    function hasMatchingKey(obj, keys) {
        keys = arrVal(keys);

        for (var i = 0, len = keys.length; i < len; i++) {
            if (keys[i] in obj) {
                return true;
            }
        }

        return false;
    }

    function withProto(prototype, data) {
        var obj = Object.create(prototype);
        if (data != null) {
            Object.assign(obj, data);
        }
        return obj;
    }

    function pureObj(data) {
        return withProto(null, data);
    }

    function keyValue(key, value) {
        var obj = {};
        obj[key] = value;
        return obj;
    }

    function isPromise(obj) {
        return (obj != null) && (typeof obj === 'object') && (typeof obj.then === 'function');
    }

    function isWindow(obj) {
        return isObj(obj) && (obj === obj.window) && (obj === obj.self) && (internalName(obj) === 'Window');
    }

    function nodeType(obj) {
        return isObj(obj) && (typeof obj.nodeName === 'string') && (typeof obj.nodeType === 'number') && obj.nodeType;
    }

    var ELEMENT_NODE = 1,
        DOCUMENT_NODE = 9,
        DOCUMENT_FRAGMENT_NODE = 11;

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

    function isRegExp(obj) {
        return (obj != null) && (internalName(obj) === 'RegExp');
    }

    function isDate(obj) {
        return (obj != null) && (internalName(obj) === 'Date');
    }

    // Inspired by jQuery.isNumeric
    function isNumeric(val) {
        // parseFloat NaNs numeric-cast false positives ("")
        // ...but misinterprets leading-number strings, particularly hex literals ("0x...")
        val = (typeof val === 'string') ? parseFloat(val) : val;
        return Number.isFinite(val);
    }

    function isArrayLike(obj, minLength) {
        var len;
        minLength = Number.isFinite(+minLength) ? +minLength : 0;

        return (obj != null)
            && (typeof obj === 'object')
            && (internalName(obj) !== 'Window')
            && (typeof (len = obj.length) === 'number')
            && (len >= minLength)
            && ((len === 0) || ((0 in obj) && ((len - 1) in obj)));
    }

    // Returns a random integer between min (inclusive) and max (inclusive)
    // Using Math.round() will give you a non-uniform distribution!
    function random(min, max) {
        min = Number.isFinite(+min) ? +min : 0;
        max = Number.isFinite(+max) ? +max : 1000000000000; // 1 Trillion

        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    // Bind a number of an object's methods to that object. Remaining arguments
    // are the method names to be bound. Useful for ensuring that all callbacks
    // defined on an object belong to it.
    function bindAll(obj/*, ...methodNames*/) {
        var i, len = arguments.length, methodName;
        for (i = 1; i < len; i++) {
            methodName = arguments[i];
            obj[methodName] = obj[methodName].bind(obj);
        }
        return obj;
    }

    function each(obj, callback) {
        if (obj == null) {
            return obj;
        }

        for (var name in obj) {
            if (callback.call(obj, name, obj[name]) === false) {
                break;
            }
        }

        return obj;
    }

    function eachIter(iterable, callback) {
        var item, i = 0;

        if (iterable == null) {
            return iterable;
        }

        while (!(item = iterable.next()).done) {
            if (callback.call(undefined, item.value, i++) === false) {
                break;
            }
        }

        return iterable;
    }

    var EXTEND_DEEP = 1,
        EXTEND_TGT_OWN_ONLY = 2,
        EXTEND_SRC_OWN_ONLY = 4;

    function _extend(target, source, mask) {
        var key, tgt, src, isSrcArr;

        mask = +mask || 0;

        for (key in source) {
            tgt = target[key];
            src = source[key];

            if (
                (src === undefined)
                || ((mask & EXTEND_TGT_OWN_ONLY) && !hasOwn(target, key))
                || ((mask & EXTEND_SRC_OWN_ONLY) && !hasOwn(source, key))
            ) {
                continue;
            }

            if ((mask & EXTEND_DEEP) && src && (typeof src === 'object') && ((isSrcArr = Array.isArray(src)) || isPlainObj(src))) {
                if (isSrcArr && !Array.isArray(tgt)) {
                    tgt = {};
                } else if (!isSrcArr && !isPlainObj(tgt)) {
                    tgt = [];
                }

                target[key] = _extend(tgt, src, mask);
            } else {
                target[key] = src;
            }
        }
    }

    // Copy all but undefined properties from one or more objects to the `target` object.
    function extend(target/*, ...sources*/) {
        for (var i = 1, len = arguments.length; i < len; i++) {
            _extend(target, arguments[i]);
        }
        return target
    }

    // Extends `target` with source own-properties only.
    function extendOwn(target/*, ...sources*/) {
        for (var i = 1, len = arguments.length; i < len; i++) {
            _extend(target, arguments[i], EXTEND_SRC_OWN_ONLY);
        }
        return target
    }

    // Deep extend, clones any arrays and plain objects found in sources.
    function extendDeep(target/*, ...sources*/) {
        for (var i = 1, len = arguments.length; i < len; i++) {
            _extend(target, arguments[i], EXTEND_DEEP);
        }
        return target
    }

    // Returns a function that always returns a deep-clone of `obj`
    function cloner(obj) {
        obj = objVal(obj);
        return function cloned() {
            return extendDeep({}, obj);
        };
    }

    // Apply `options` to the `defaults` object. Only copies over properties with keys already defined in the `defaults` object.
    function defaults(defaults/*, ...options*/) {
        for (var i = 1, len = arguments.length; i < len; i++) {
            _extend(defaults, arguments[i], EXTEND_TGT_OWN_ONLY);
        }
        return defaults
    }

    // If the value of the named `property` is a function then invoke it with the
    // `object` as context; otherwise, return it.
    function result(object, property, fallback) {
        var value = ((object != null) && (object[property] !== undefined)) ? object[property] : fallback;
        return (typeof value === 'function') ? value.call(object) : value;
    }

    /**
     * @param {string} [mask] - optional, assumed to be `obj` if not of type number.
     * @param {object} obj - the target object to define properties on.
     * @param {object|string} props - is a single property's name if `value` is passed.
     * @returns {Object}
     */
    function properties(mask, obj, props) {
        var key, descriptors, descriptor;

        if (typeof mask !== 'string') {
            props = obj;
            obj = mask;
            mask = 'cw';
        }

        var configurable = mask.includes('c'),
            enumerable = mask.includes('e'),
            writeable = mask.includes('w');

        descriptors = {};
        for (key in props) {
            if (!hasOwn(props, key)) {
                continue;
            }

            descriptor = Object.getOwnPropertyDescriptor(props, key);
            descriptor.configurable = configurable;
            descriptor.enumerable = enumerable;
            if (descriptor.writeable !== undefined) {
                // ^ It's not an accessor property, otherwise we just let descriptor.get/set pass-through
                descriptor.writeable = writeable;
            }
            descriptors[key] = descriptor;
        }

        return Object.defineProperties(obj, descriptors);
    }

    // Gets the internal type/constructor name of the provided `val`
    function internalName(val) {
        return emptyObj.toString.call(val).slice(8, -1); // slice off the surrounding '[object ' and ']'
    }

    function constructorName(obj) {
        if ((obj != null) && (typeof obj.constructor === 'function') && (typeof obj.constructor.name === 'string')) {
            return obj.constructor.name;
        }
    }

    function typeName(obj) {
        var name = constructorName(obj);
        return (name !== undefined) ? name : internalName(obj);
    }

    /**
     * @param val
     * @returns { Boolean }
     */
    function boolVal(val) {
        var p;
        return !!val && (val !== '0') && ((typeof val !== 'object') || !((p = isPlainObj(val)) || isArrayLike(val)) || (p ? hasEnumerable(val) : (val.length !== 0)));
    }

    /**
     * Port of PHP's empty() function
     * @returns { Boolean }
     */
    //function falsy(val) {
    //    var p;
    //    return !val || (val === '0') || ((typeof val === 'object') && ((p = isPlainObj(val)) || isArrayLike(val)) && (p ? !hasEnumerable(val) : (val.length === 0)));
    //}

    /**
     * @returns { Number }
     */
    function intVal(val) {
        return ((val != null) && (val = Math.floor(val)) && (val !== Infinity) && (val !== -Infinity)) ? val : 0;
    }

    function numberFormat(num) {
        num = +num || 0;
        return num.toLocaleString();
    }

    /**
     * @returns { Array|* } array or array-like object
     */
    function arrVal(val, clone) {
        var isArr;

        clone = !!clone;

        if (val == null) {
            return [];
        }

        if ((typeof val === 'object') && ((isArr = Array.isArray(val))/* || isArrayLike(val)*/)) {
            return clone ? toArray(val) : val;
        }

        return [val];
    }

    /**
     * @returns { Object }
     */
    function objVal(val, defaultPropertyName) {
        if (!isObj(val) || Array.isArray(val)) {
            val = (defaultPropertyName !== undefined) ? keyValue(defaultPropertyName, val) : {};
        }

        return val;
    }

    /**
     * Sensible PHP-like string coercion
     * @returns { string }
     */
    function strVal(val) {
        if (!val) {
            return (val === 0) ? '0' : '';
        } else if (val === true) {
            return '1';
        } else if (typeof val === 'string') {
            return val;
        } else if (typeof val === 'number') {
            return ((val !== Infinity) && (val !== -Infinity)) ? ('' + val) : '';
        } else if ((typeof val === 'object') && (val.toString !== emptyObj.toString) && (typeof val.toString === 'function')) {
            // `val` has a .toString() implementation other than the useless generic one
            return '' + val;
        }

        throw new TypeError('strVal(): Cannot coerce `val` of type "' + typeName(val) + '" to a string.');
    }

    /**
     * String interpolation
     * @returns {string}
     */
    function format(str, values) {
        str = strVal(str);

        if ((str === '') || (arguments.length < 2)) {
            return str; // Nothing to do
        }

        if ((values == null) || (typeof values !== 'object')) {
            // values provided as multiple arguments?
            values = toArray(arguments, 1);
            values.unshift(''); // Add empty string at index 0 so that interpolation starts from '{1}'
        } else if (isArrayLike(values)) {
            // Array(-ish?) object provided with values
            values = toArray(values);
            values.unshift(''); // Add empty string at index 0 so that interpolation starts from '{1}'
        }

        return str.replace(/\{(\w+)\}/g, function (match, key) {
            return (key in values) ? strVal(values[key]) : match;
        });
    }

    function ucFirst(str) {
        return ((str != null) && (str = strVal(str))) ? str.charAt(0).toUpperCase() + str.substr(1) : '';
    }

    function lcFirst(str) {
        return ((str != null) && (str = strVal(str))) ? str.charAt(0).toLowerCase() + str.substr(1) : '';
    }

    // Credit: http://stackoverflow.com/a/32604073/362006
    function camelCase(str) {
        // Lower cases the string
        return ((str != null) && (str = strVal(str))) ?
            str.toLowerCase()
                // Replaces any - or _ characters with a space
                .replace(/[\-_]+/g, ' ')
                // Removes any non alphanumeric characters
                .replace(/[^\w\s]/g, '')
                // Uppercases the first character in each group immediately following a space
                // (delimited by spaces)
                .replace(/ (.)/g, function ($1) {
                    return $1.toUpperCase();
                })
                // Removes spaces
                .replace(/ /g, '')
            : '';
    }

    /**
     * Extracts query string from a url
     * @param {string} url
     * @returns {string}
     */
    function queryStringFromUrl(url) {
        var query = strVal(url).split('?', 2)[1]; // Grab query string
        return (query || '').split('#')[0]; // Remove hash fragment (if any)
    }

    /**
     * Returns a `URLSearchParams` instance
     * @param {string} url
     * @returns { URLSearchParams }
     */
    function uspFromUrl(url) {
        var query = queryStringFromUrl(url);
        return new URLSearchParams(query);
    }

    /**
     * @param usp
     * @returns {object}
     */
    function entriesFromUsp(usp) {
        var entries = arrayFromIterable(usp.entries()),
            i, entryName, entryValue, params = {};

        for (i = 0; i < entries.length; i++) {
            entryName = entries[i][0];
            entryValue = entries[i][1];

            if (!(entryName in params)) {
                params[entryName] = entryValue;
            } else { // Multiple values
                if (!Array.isArray(params[entryName])) {
                    params[entryName] = [params[entryName]];
                }

                params[entryName].push(entryValue);
            }
        }

        return params;
    }

    function arrayFromIterable(iterable) {
        var item, array = [];

        if (iterable != null) {
            while (!(item = iterable.next()).done) {
                array.push(item.value);
            }
        }

        return array;
    }

    /* Generate url */

    $cms.url = function () {};

    var rgxProtocol = /^[a-z0-9\-\.]+:(?=\/\/)/i,
        rgxHttp = /^https?:(?=\/\/)/i;

    function toProtocolRelative(absoluteUrl) {
        return strVal(absoluteUrl).replace(rgxProtocol, '');
    }

    function baseUrl(relativeUrl) {
        if (!relativeUrl && (relativeUrl !== 0)) {
            return $cms.$BASE_URL_S;
        }

        relativeUrl = strVal(relativeUrl);

        if (rgxHttp.test(relativeUrl)) {
            // Already an absolute url, just ensure matching protocol as the current page.
            return relativeUrl.replace(rgxHttp, window.location.protocol);
        }

        return ((relativeUrl.startsWith('/')) ? $cms.$BASE_URL : $cms.$BASE_URL_S) + relativeUrl;
    }

    // Dynamically fixes the protocol for image URLs
    function img(url) {
        return strVal(url).replace(rgxHttp, window.location.protocol);
    }

    /* Force a link to be clicked without user clicking it directly (useful if there's a confirmation dialog inbetween their click) */
    function navigate(url, target) {
        var el;

        if (isEl(url)) {
            el = url;
            url = '';

            if (el.localName === 'a') {
                url = el.href;
                if ('target' in el) {
                    target = el.target;
                }
            } else if (el.dataset && ('cmsHref' in el.dataset)) {
                url = el.dataset.cmsHref;
                if ('cmsTarget' in el.dataset) {
                    target = el.dataset.cmsTarget;
                }
            }
        }

        if (!url) {
            return;
        }
        target || (target = '_self');
        if (target === '_self') {
            window.location = url;
        } else {
            window.open(url, target);
        }
    }

    function parseJson(source) {
        return window.JSON5.parse(strVal(source));
    }

    function log() {
        if ($cms.$DEV_MODE && $cms.$VERBOSE) {
            return console.log.apply(undefined, arguments);
        }
    }

    function info() {
        if ($cms.$DEV_MODE) {
            return console.info.apply(undefined, arguments);
        }
    }

    function warn() {
        if ($cms.$DEV_MODE) {
            return console.warn.apply(undefined, arguments);
        }
    }

    function dir() {
        if ($cms.$DEV_MODE) {
            return console.dir.apply(undefined, arguments);
        }
    }

    function assert() {
        if ($cms.$DEV_MODE) {
            return console.assert.apply(undefined, arguments);
        }
    }

    function error() {
        if ($cms.$DEV_MODE) {
            return console.error.apply(undefined, arguments);
        }
    }

    function exception(ex) {
        if ($cms.$DEV_MODE) {
            if (typeof ex === 'string') {
                throw new Error(ex);
            }
            throw ex;
        }
    }

    function requireCss(sheet) {
        if ($cms.dom.$('link#css-' + sheet)) {
            return;
        }
        var link = document.createElement('link');
        link.id = 'css-' + sheet;
        link.rel = 'stylesheet';
        link.href = '{$FIND_SCRIPT_NOHTTP;,sheet}?sheet=' + sheet + keep_stub();
        document.head.appendChild(link);
    }

    var _requireJsPromises = Object.create(null);
    function _requireJavascript(script) {
        script = strVal(script);

        if (_requireJsPromises[script] == null) {
            if ($cms.dom.$('script#javascript-' + script)) {
                _requireJsPromises[script] = Promise.resolve();
            } else {
                _requireJsPromises[script] = new Promise(function (resolve, reject) {
                    var sEl = document.createElement('script');
                    sEl.id = 'javascript-' + script;
                    sEl.addEventListener('load', function (e) {
                        resolve(e)
                    });
                    sEl.addEventListener('error', function (e) {
                        $cms.error('$cms.requireJavascript(): Error loading script "' + script + '"', e);
                        reject(e);
                    });
                    sEl.src = '{$FIND_SCRIPT_NOHTTP;,javascript}?script=' + script + keep_stub();
                    document.body.appendChild(sEl);
                });
            }
        }

        return _requireJsPromises[script];
    }

    function requireJavascript(scripts) {
        scripts = arrVal(scripts);

        return Promise.all(scripts.map(_requireJavascript));
    }

    function setPostDataFlag(flag) {
        flag = strVal(flag);

        var forms = $cms.dom.$$('form'), form, post_data;

        for (var i = 0; i < forms.length; i++) {
            form = forms[i];

            if (form.elements['post_data'] == null) {
                post_data = document.createElement('input');
                post_data.value = '';
            } else {
                post_data = form.elements['post_data'];
                post_data.value += ',';
            }
            post_data.type = 'hidden';
            post_data.name = 'post_data';
            post_data.value += flag;
            form.appendChild(post_data);
        }
    }

    // Inspired by goog.inherits and Babel's generated output for ES6 classes
    function inherits(SubClass, SuperClass, protoProps) {
        Object.setPrototypeOf(SubClass, SuperClass);

        properties(SubClass, { base: base.bind(undefined, SuperClass) });

        // Set the prototype chain to inherit from `SuperClass`
        SubClass.prototype = Object.create(SuperClass.prototype);

        protoProps || (protoProps = {});
        protoProps.constructor = SubClass;

        properties(SubClass.prototype, protoProps);
    }

    /**
     *  Emulates super.method() call
     * @param SuperClass
     * @param that
     * @param method
     * @param args
     * @returns {*}
     */
    function base(SuperClass, that, method, args) {
        return (args && args.length) ? SuperClass.prototype[method].apply(that, args) : SuperClass.prototype[method].call(that);
    }

    /* Cookies */

    // Inspired by cookie.js: https://github.com/js-cookie/js-cookie
    function CookieMonster() {}

    properties(CookieMonster.prototype, /** @lends CookieMonster# */ {
        get: function get(cookieName) {
            cookieName = strVal(cookieName);
            if (cookieName) {
                return this.getAll(cookieName);
            }
        },

        getAll: function getAll() {
            // To prevent the for loop in the first place assign an empty array
            // in case there are no cookies at all. Also prevents odd result when
            // calling "get()"
            var cookies = document.cookie ? document.cookie.split('; ') : [],
                rdecode = /(%[0-9A-Z]{2})+/g,
                cookieName = arguments[0], // (internal use only)
                result, i;

            if (cookieName == null) {
                result = {};
            }

            for (i = 0; i < cookies.length; i++) {
                var parts = cookies[i].split('='),
                    cookie = parts.slice(1).join('=');

                if (cookie.startsWith('"') && cookie.endsWith('"')) {
                    cookie = cookie.slice(1, -1);
                }

                var name = parts[0].replace(rdecode, decodeUC);
                cookie = cookie.replace(rdecode, decodeUC);

                if (cookieName == null) {
                    result[name] = cookie;
                } else if (cookieName === name) {
                    result = cookie;
                    break;
                }
            }

            return result;
        },

        set: function set(details, value) {
            var defaults = {
                value: '',
                expires: 1, // 1 day
                path: $cms.$COOKIE_PATH,
                domain: $cms.$COOKIE_DOMAIN,
                secure: false
            };

            if (!isObj(details)) {
                // `details` is a cookie name
                details = {
                    name: details,
                    value: value
                };
            }
            details = Object.assign(defaults, details);

            if (!isDate(details.expires)) {
                // Expiry specified in days
                var expires = new Date();
                expires.setDate(expires.getDate() + (Number.isFinite(+details.expires) ? +details.expires : 0)); // Add days to date
                details.expires = expires;
            }

            value = encodeUC(strVal(details.value)).replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeUC);

            var cookieName = strVal(details.name);
            cookieName = encodeUC(cookieName);
            cookieName = cookieName.replace(/%(23|24|26|2B|5E|60|7C)/g, decodeUC);
            cookieName = cookieName.replace(/[\(\)]/g, escape);

            document.cookie = [
                cookieName + '=' + value,
                details.expires ? '; expires=' + details.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                details.path ? '; path=' + details.path : '',
                details.domain ? '; domain=' + details.domain : '',
                details.secure ? '; secure' : ''
            ].join('');
        },

        remove: function remove(cookieName) {
            var details = {
                name: cookieName,
                expiry: -1
            };

            this.set(details);
        }
    });

    $cms.cookies || ($cms.cookies = new CookieMonster());

    var alertedCookieConflict;
    function set_cookie(cookieName, cookieValue, numDays) {
        var expires = new Date(),
            output;

        numDays = +numDays || 1;

        expires.setDate(expires.getDate() + numDays); // Add days to date

        output = cookieName + '=' + encodeUC(cookieValue) + ';expires=' + expires.toUTCString();

        if ($cms.$COOKIE_PATH) {
            output += ';path=' + $cms.$COOKIE_PATH;
        }

        if ($cms.$COOKIE_DOMAIN) {
            output += ';domain=' + $cms.$COOKIE_DOMAIN;
        }

        document.cookie = output;

        var read = read_cookie(cookieName);

        if (read && (read !== cookieValue) && $cms.$DEV_MODE && !alertedCookieConflict) {
            window.fauxmodal_alert('{!COOKIE_CONFLICT_DELETE_COOKIES;^}' + '... ' + document.cookie + ' (' + output + ')', null, '{!ERROR_OCCURRED;^}');
            alertedCookieConflict = true;
        }
    }

    function read_cookie(cookieName, defaultValue) {
        cookieName = strVal(cookieName);
        defaultValue = strVal(defaultValue);

        var cookies = '' + document.cookie,
            startIdx = cookies.startsWith(cookieName + '=') ? 0 : cookies.indexOf(' ' + cookieName + '=');

        if ((startIdx === -1) || !cookieName) {
            return defaultValue;
        }

        if (startIdx > 0) {
            startIdx++;
        }

        var endIdx = cookies.indexOf(';', startIdx);
        if (endIdx === -1) {
            endIdx = cookies.length;
        }

        return decodeUC(cookies.substring(startIdx + cookieName.length + 1, endIdx));
    }

    // If the browser has support for CSS transitions
    $cms.support.cssTransitions = ('transition' in emptyElStyle) || ('WebkitTransition' in emptyElStyle) || ('msTransition' in emptyElStyle);

    // If the browser has support for an <input [type=???]>
    $cms.support.inputTypes = {
        search: 0, tel: 0, url: 0, email: 0, datetime: 0, date: 0, month: 0,
        week: 0, time: 0, 'datetime-local': 0, number: 0, range: 0, color: 0
    };

    (function () {
        var type, bool, inputEl = document.createElement('input');

        for (type in $cms.support.inputTypes) {
            inputEl.setAttribute('type', type);
            bool = inputEl.type !== 'text';

            if (bool && (type !== 'search') && (type !== 'tel')) {
                inputEl.value = smile;
                inputEl.style.cssText = 'position:absolute;visibility:hidden;';

                if ((type === 'range') && (inputEl.style.WebkitAppearance !== undefined)) {
                    docEl.appendChild(inputEl);

                    bool = (getComputedStyle(inputEl).WebkitAppearance !== 'textfield') && (inputEl.offsetHeight !== 0);
                    docEl.removeChild(inputEl);
                } else if ((type === 'url') || (type === 'email')) {
                    bool = inputEl.checkValidity && (inputEl.checkValidity() === false);
                } else {
                    bool = inputEl.value !== smile;
                }
            }

            $cms.support.inputTypes[type] = !!bool;
        }
    }());

    function domArg(windowOrNodeOrSelector) {
        var el;

        if (windowOrNodeOrSelector != null) {
            if (isWindow(windowOrNodeOrSelector) || isNode(windowOrNodeOrSelector)) {
                return windowOrNodeOrSelector
            }

            if (typeof windowOrNodeOrSelector === 'string') {
                el = $cms.dom.$(windowOrNodeOrSelector);

                if (el == null) {
                    throw new Error('domArg(): No element found for selector "' + strVal(windowOrNodeOrSelector) + '".');
                }

                return el;
            }
        }

        throw new TypeError('domArg(): Argument 1 must be a {' + 'Window|Node|string}, "' + typeName(windowOrNodeOrSelector) + '" provided.');
    }

    function nodeArg(nodeOrSelector) {
        var el;

        if (nodeOrSelector != null) {
            if (isNode(nodeOrSelector)) {
                return nodeOrSelector;
            }

            if (typeof nodeOrSelector === 'string') {
                el = $cms.dom.$(nodeOrSelector);

                if (el == null) {
                    throw new Error('nodeArg(): No element found for selector "' + strVal(nodeOrSelector) + '".');
                }

                return el;
            }
        }

        throw new TypeError('nodeArg(): Argument 1 must be a {' + 'Node|string}, "' + typeName(nodeOrSelector) + '" provided.');
    }

    function elArg(elementOrSelector) {
        var el;

        if (elementOrSelector != null) {
            if (isEl(elementOrSelector)) {
                return elementOrSelector;
            }

            if (typeof elementOrSelector === 'string') {
                el = $cms.dom.$(elementOrSelector);

                if (el == null) {
                    throw new Error('elArg(): No element found for selector "' + strVal(elementOrSelector) + '".');
                }

                return el;
            }
        }

        throw new TypeError('elArg(): Argument 1 must be a {' + 'Element|string}, "' + typeName(elementOrSelector) + '" provided.');
    }

    function computedStyle(el, property) {
        var cs = el.ownerDocument.defaultView.getComputedStyle(el);
        return (property !== undefined) ? cs.getPropertyValue(property) : cs;
    }

    // Returns a single matching child element, defaults to 'document' as parent
    /**
     * @memberof $cms.dom
     * @param context
     * @param id
     * @returns {*}
     */
    $cms.dom.$id = function $id(context, id) {
        if (id === undefined) {
            id = context;
            context = document;
        } else {
            context = nodeArg(context);
        }
        id = strVal(id);

        return ('getElementById' in context) ? context.getElementById(id) : context.querySelector('#' + id);
    };

    // Returns a single matching child element, `context` defaults to 'document'
    var rgxIdSelector = /^\#[\w\-]+$/;
    /**
     * @memberof $cms.dom
     * @param context
     * @param selector
     * @returns {*}
     */
    $cms.dom.$ = function $(context, selector) {
        if (selector === undefined) {
            selector = context;
            context = document;
        } else {
            context = nodeArg(context);
        }
        selector = strVal(selector);

        return (rgxIdSelector.test(selector) && ('getElementById' in context)) ? context.getElementById(selector.substr(1)) : context.querySelector(selector);
    };

    /* `$cms.dom.$$` is a CSS selector implementation which uses `document.querySelectorAll` and optimizes for some special cases, like `#id`, `.someclass` and `div`.*/
    var rgxSimpleSelector = /^[\#\.]?[\w\-]+$/;
    /**
     * @memberof $cms.dom
     * @param context
     * @param selector
     * @returns {*}
     */
    $cms.dom.$$ = function $$(context, selector) {
        var found;

        if (selector === undefined) {
            selector = context;
            context = document;
        } else {
            context = nodeArg(context);
        }
        selector = strVal(selector);

        // DocumentFragment is missing getElementById and getElementsBy(Tag|Class)Name in some implementations
        if (rgxSimpleSelector.test(selector) && isDocOrEl(context)) {
            switch (selector[0]) {
                case '#': // selector is an ID
                    return (found = (('getElementById' in context) ? context.getElementById(selector.substr(1)) : context.querySelector(selector))) ? [found] : [];
                    break;

                case '.': // selector is a class name
                    return toArray(context.getElementsByClassName(selector.substr(1)));
                    break;

                default: // selector is a tag name
                    return toArray(context.getElementsByTagName(selector));
                    break;
            }
        }

        return toArray(context.querySelectorAll(selector));
    };

    /**
     * @memberof $cms.dom
     * @param context
     * @param selector
     * @returns { Element }
     */
    $cms.dom.last = function last(context, selector) {
        return $cms.dom.$$(context, selector).pop();
    };

    /**
     * This one (3 dollars) also includes the context element (at offset 0) if it matches the selector
     * @memberof $cms.dom
     * @param context
     * @param selector
     * @returns {*}
     */
    $cms.dom.$$$ = function $$$(context, selector) {
        if (selector === undefined) {
            selector = context;
            context = document;
        } else {
            context = nodeArg(context);
        }
        selector = strVal(selector);

        var els = $cms.dom.$$(context, selector);

        if (isEl(context) && $cms.dom.matches(context, selector)) {
            els.unshift(context);
        }

        return els;
    };

    // Special attributes that should be set via method calls
    var methodAttributes = { val: 1, css: 1, html: 1, text: 1, data: 1, width: 1, height: 1, offset: 1 };

    /**
     * @memberof $cms.dom
     * @param tag
     * @param attributes
     * @param properties
     * @returns { Element }
     */
    $cms.dom.create = function create(tag, attributes, properties) {
        var el = document.createElement(strVal(tag));

        if (isObj(attributes)) {
            each(attributes, function (key, value) {
                if (key in methodAttributes) {
                    $cms.dom[key](el, value);
                } else {
                    $cms.dom.attr(el, key, value)
                }
            });
        }

        if (isObj(properties)) {
            extendDeep(el, properties);
        }

        return el;
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param value
     * @returns {*}
     */
    $cms.dom.val = function val(el, value) {
        el = elArg(el);

        if (value === undefined) {
            if ((el.localName !== 'select') || !el.multiple) {
                return el.value;
            }

            // Special case: <select [multiple]>
            var values = [], i;
            for (i = 0; i < el.options.length; i++) {
                if (el.options[i].selected) {
                    values.push(el.options[i].value);
                }
            }

            return values;
        }

        el.value = strVal((typeof value === 'function') ? value.call(el, $cms.dom.val(el), el) : value);
    };

    /**
     * @memberof $cms.dom
     * @param node
     * @param newText
     * @returns {string|*}
     */
    $cms.dom.text = function text(node, newText) {
        node = nodeArg(node);

        if (newText === undefined) {
            return node.textContent;
        }

        node.textContent = strVal((typeof newText === 'function') ? newText.call(node, node.textContent, node) : newText);
    };

    var rgxNotWhite = /\S+/g;
    /** @class */
    function Data() {
        this.expando = $cms.id + '-data-' + Data.uid++;
    }
    Data.uid = 1;
    properties(Data.prototype, /**@lends Data#*/ {
        cache: function (owner) {
            // Check if the owner object already has a cache
            var value = owner[this.expando];
            // If not, create one
            if (!value) {
                value = {};

                // We can accept data for non-element nodes in modern browsers,
                // but we should not, see #8335.
                // Always return an empty object.
                if (!isNode(owner) || isDocOrEl(owner)) {
                    properties(owner, keyValue(this.expando, value));
                }
            }

            return value;
        },
        set: function (owner, data, value) {
            var prop, cache = this.cache(owner);

            // Handle: [ owner, key, value ] args
            // Always use camelCase key (gh-2257)
            if (typeof data === 'string') {
                cache[camelCase(data)] = value;
                // Handle: [ owner, { properties } ] args
            } else {
                // Copy the properties one-by-one to the cache object
                for (prop in data) {
                    cache[camelCase(prop)] = data[prop];
                }
            }
            return cache;
        },
        get: function (owner, key) {
            return key === undefined ?
                this.cache(owner) :
                // Always use camelCase key (gh-2257)
                (owner[this.expando] && owner[this.expando][camelCase(key)]);
        },
        access: function (owner, key, value) {
            // In cases where either:
            //
            //   1. No key was specified
            //   2. A string key was specified, but no value provided
            //
            // Take the "read" path and allow the get method to determine
            // which value to return, respectively either:
            //
            //   1. The entire cache object
            //   2. The data stored at the key
            //
            if ((key === undefined) || ((key && (typeof key === 'string')) && (value === undefined))) {
                return this.get(owner, key);
            }

            // When the key is not a string, or both a key and value
            // are specified, set or extend (existing objects) with either:
            //
            //   1. An object of properties
            //   2. A key and value
            //
            this.set(owner, key, value);

            // Since the "set" path can have two possible entry points
            // return the expected data based on which path was taken[*]
            return (value !== undefined) ? value : key;
        },
        remove: function (owner, key) {
            var i, cache = owner[this.expando];

            if (cache === undefined) {
                return;
            }

            if (key !== undefined) {
                // Support array or space separated string of keys
                if (Array.isArray(key)) {
                    // If key is an array of keys...
                    // We always set camelCase keys, so remove that.
                    key = key.map(camelCase);
                } else {
                    key = camelCase(key);
                    // If a key with the spaces exists, use it.
                    // Otherwise, create an array by matching non-whitespace
                    key = (key in cache) ? [key] : (key.match(rgxNotWhite) || []);
                }

                i = key.length;

                while (i--) {
                    delete cache[key[i]];
                }
            }

            // Remove the expando if there's no more data
            if ((key === undefined) || !hasEnumerable(cache)) {
                // Support: Chrome <=35 - 45
                // Webkit & Blink performance suffers when deleting properties
                // from DOM nodes, so set to undefined instead
                // https://bugs.chromium.org/p/chromium/issues/detail?id=378607 (bug restricted)
                if (isNode(owner)) {
                    owner[this.expando] = undefined;
                } else {
                    delete owner[this.expando];
                }
            }
        },
        hasData: function (owner) {
            var cache = owner[this.expando];
            return (cache !== undefined) && hasEnumerable(cache);
        }
    });

    function dataAttr(elem, key, data) {
        var trimmed;
        // If nothing was found internally, try to fetch any
        // data from the HTML5 data-* attribute
        if ((data === undefined) && (typeof (data = elem.dataset[key]) === 'string')) {
            trimmed = data.trim();

            if ((trimmed.startsWith('{') && trimmed.endsWith('}')) || (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
                data = parseJson(data);
            }

            // Make sure we set the data so it isn't changed later
            domData.set(elem, key, data);
        }
        return data;
    }

    var domData = new Data();

    /**
     * Data retrieval and storage
     * @memberof $cms.dom
     * @param el
     * @param key
     * @param value
     * @returns {*}
     */
    $cms.dom.data = function data(el, key, value) {
        var name, data;

        el = elArg(el);

        // Gets all values
        if (key === undefined) {
            data = domData.get(el);

            if (!domData.hasData(el)) {
                for (name in el.dataset) {
                    dataAttr(el, name, data[name]);
                }
            }

            return data;
        }

        // Sets multiple values
        if (typeof key === 'object') {
            return domData.set(el, key);
        }

        if (value === undefined) {
            // Attempt to get data from the cache
            // The key will always be camelCased in Data
            data = domData.get(el, key);
            if (data !== undefined) {
                return data;
            }
            // Attempt to "discover" the data in
            // HTML5 custom data-* attrs

            try {
                data = dataAttr(el, key);
            } catch (e) {
                $cms.warn('$cms.dom.data(): Exception thrown while parsing JSON in data attribute "' + key + '" of', el, e);
            }

            if (data !== undefined) {
                return data;
            }

            // We tried really hard, but the data doesn't exist.
            return;
        }

        // Set the data...
        // We always store the camelCased key
        domData.set(el, key, strVal(value));
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param key
     */
    $cms.dom.removeData = function removeData(el, key) {
        el = elArg(el);

        domData.remove(el, key);
    };

    /**
     * @memberof $cms.dom
     * @param obj
     * @param value
     * @returns {*}
     */
    $cms.dom.width = function width(obj, value) {
        var offset;

        obj = domArg(obj);

        if (value === undefined) {
            return isWindow(obj) ? obj.innerWidth :
                isDoc(obj) ? obj.documentElement.scrollWidth :
                (offset = $cms.dom.offset(obj)) && offset.width;
        }

        $cms.dom.css(obj, 'width', (typeof value === 'function') ? value.call(obj, $cms.dom.width(obj)) : value);
    };

    /**
     * @memberof $cms.dom
     * @param obj
     * @param value
     * @returns {*}
     */
    $cms.dom.height = function height(obj, value) {
        var offset;

        obj = domArg(obj);

        if (value === undefined) {
            return isWindow(obj) ? obj.innerHeight :
                isDoc(obj) ? obj.documentElement.scrollHeight :
                (offset = $cms.dom.offset(obj)) && offset.height;
        }

        $cms.dom.css(obj, 'height', (typeof value === 'function') ? value.call(obj, $cms.dom.height(obj)) : value);
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param coordinates
     * @returns {*}
     */
    $cms.dom.offset = function offset(el, coordinates) {
        el = elArg(el);

        if (coordinates === undefined) {
            if (!document.documentElement.contains(el)) {
                return { top: 0, left: 0 };
            }

            var rect = el.getBoundingClientRect();
            return {
                left: rect.left + window.scrollX,
                top: rect.top + window.scrollY,
                width: Math.round(rect.width),
                height: Math.round(rect.height)
            };
        }

        var coords = (typeof coordinates === 'function') ? coordinates.call(el, $cms.dom.offset(el)) : coordinates,
            parentOffset = $cms.dom.offset($cms.dom.offsetParent(el)),
            props = {
                top: coords.top - parentOffset.top,
                left: coords.left - parentOffset.left
            };

        if ($cms.dom.css(el, 'position') === 'static') {
            props.position = 'relative'
        }

        $cms.dom.css(el, props);
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @returns { Element }
     */
    $cms.dom.offsetParent = function offsetParent(el) {
        el = elArg(el);

        var parent = el.offsetParent || el.ownerDocument.body;
        while (parent && (parent.localName !== 'html') && (parent.localName !== 'body') && ($cms.dom.css(parent, 'position') === 'static')) {
            parent = parent.offsetParent;
        }
        return parent;
    };

    /**
     * @memberof $cms.dom
     * @param iframe
     * @returns {boolean}
     */
    $cms.dom.hasIframeAccess = function hasIframeAccess(iframe) {
        try {
            return (iframe.contentWindow['access' + random()] = true) === true;
        } catch (ignore) {}

        return false;
    };

    var _matchesFnName = ('matches' in emptyEl) ? 'matches'
        : ('webkitMatchesSelector' in emptyEl) ? 'webkitMatchesSelector'
        : ('msMatchesSelector' in emptyEl) ? 'msMatchesSelector'
        : 'matches';

    // Check if the given element matches selector
    /**
     * @memberof $cms.dom
     * @param el
     * @param selector
     * @returns {boolean}
     */
    $cms.dom.matches = function matches(el, selector) {
        el = elArg(el);

        return ((selector === '*') || el[_matchesFnName](selector));
    };

    /**
     * Gets closest parent (or itself) element matching selector
     * @memberof $cms.dom
     * @param el
     * @param selector
     * @param context
     * @returns {*}
     */
    $cms.dom.closest = function closest(el, selector, context) {
        el = elArg(el);

        while (el && (el !== context)) {
            if ($cms.dom.matches(el, selector)) {
                return el;
            }
            el = el.parentElement;
        }

        return null;
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param selector
     * @returns { Array }
     */
    $cms.dom.parents = function parents(el, selector) {
        el = elArg(el);

        var parents = [],
            parent;

        while (parent = el.parentElement) {
            if ((selector === undefined) || $cms.dom.matches(parent, selector)) {
                parents.push(parent);
            }
        }

        return parents;
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param selector
     * @returns { HTMLElement }
     */
    $cms.dom.parent = function parent(el, selector) {
        el = elArg(el);

        var parent;

        while (parent = el.parentElement) {
            if ((selector === undefined) || $cms.dom.matches(parent, selector)) {
                return parent;
            }
        }

        return null;
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param selector
     * @returns {*}
     */
    $cms.dom.next = function next(el, selector) {
        el = elArg(el);

        var sibling = el.nextElementSibling;

        if (selector === undefined) {
            return sibling;
        }

        while (sibling) {
            if ($cms.dom.matches(sibling, selector)) {
                return sibling;
            }

            sibling = el.nextElementSibling;
        }

        return null;
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param selector
     * @returns {*}
     */
    $cms.dom.prev = function prev(el, selector) {
        el = elArg(el);

        var sibling = el.previousElementSibling;

        if (selector === undefined) {
            return sibling;
        }

        while (sibling) {
            if ($cms.dom.matches(sibling, selector)) {
                return sibling;
            }

            sibling = el.previousElementSibling;
        }

        return null;
    };

    /**
     * @memberof $cms.dom
     * @param parentNode
     * @param childNode
     * @returns {boolean|*}
     */
    $cms.dom.contains = function contains(parentNode, childNode) {
        parentNode = nodeArg(parentNode);

        return (parentNode !== childNode) && parentNode.contains(childNode);
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param newChild
     */
    $cms.dom.append = function append(el, newChild) {
        el = nodeArg(el);

        el.appendChild(newChild);
        if (isDocOrEl(newChild)) {
            $cms.attachBehaviors(newChild);
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param newChild
     */
    $cms.dom.prepend = function prepend(el, newChild) {
        el = nodeArg(el);

        el.insertBefore(newChild, el.firstChild);
        if (isDocOrEl(newChild)) {
            $cms.attachBehaviors(newChild);
        }
    };

    var eventHandlers = {},
        focusEvents = { focus: 'focusin', blur: 'focusout' },
        focusinSupported = 'onfocusin' in window;

    function parseEventName(event) {
        var parts = ('' + event).split('.');
        return {e: parts[0], ns: parts.slice(1).sort().join(' ')};
    }

    function matcherFor(ns) {
        return new RegExp('(?:^| )' + ns.replace(' ', ' .* ?') + '(?: |$)');
    }

    function eventCapture(handler, captureSetting) {
        return !!handler.del && (!focusinSupported && (handler.e in focusEvents)) || !!captureSetting;
    }

    function realEvent(type) {
        return (focusinSupported && focusEvents[type]) || type;
    }

    function addEvent(el, events, fn, data, selector, delegator, capture) {
        var id = uid(el),
            set = eventHandlers[id] || (eventHandlers[id] = []);

        events.split(/\s/).forEach(function (event) {
            var handler = parseEventName(event);
            handler.fn = fn;
            handler.sel = selector;
            handler.del = delegator;
            var callback = delegator || fn;
            handler.proxy = function (e) {
                var args = [e, el];
                e.data = data;
                if (Array.isArray(e._args)) {
                    args = args.concat(e._args);
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
        return (eventHandlers[uid(element)] || []).filter(function (handler) {
            return handler
                && (!event.e || (handler.e === event.e))
                && (!event.ns || matcher.test(handler.ns))
                && (!fn || (uid(handler.fn) === uid(fn)))
                && (!selector || (handler.sel === selector));
        });
    }

    function removeEvent(element, events, fn, selector, capture) {
        var id = uid(element);

        (events || '').split(/\s/).forEach(function (event) {
            findHandlers(element, event, fn, selector).forEach(function (handler) {
                delete eventHandlers[id][handler.i];
                element.removeEventListener(realEvent(handler.e), handler.proxy, eventCapture(handler, capture))
            })
        });
    }

    /**
     * @memberof $cms.dom
     * @param el { Window|Document|Element }
     * @param event {string|object}
     * @param selector {string|function}
     * @param [data] {object|function}
     * @param [callback] {function}
     * @param [one] {number}
     */
    $cms.dom.on = function on(el, event, selector, data, callback, one) {
        var autoRemove, delegator;

        el = domArg(el);

        if (event && (typeof event !== 'string')) {
            each(event, function (type, fn) {
                $cms.dom.on(el, type, selector, data, fn, one)
            });
            return;
        }

        if ((typeof selector !== 'string') && (typeof callback !== 'function') && (callback !== false)) {
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
                var match = $cms.dom.closest(e.target, selector, el);

                if (match) {
                    var args = toArray(arguments);
                    args[1] = match; // Set the `element` arg to the matched element
                    return (autoRemove || callback).apply(match, args);
                }
            };
        }

        addEvent(el, event, callback, data, selector, delegator || autoRemove);
    };

    /**
     * @memberof $cms.dom
     * @param el { Window|Document|Element }
     * @param event {string|object}
     * @param selector {string|function}
     * @param [data] {object|function}
     * @param [callback] {function}
     */
    $cms.dom.one = function one(el, event, selector, data, callback) {
        el = domArg(el);

        return $cms.dom.on(el, event, selector, data, callback, 1);
    };

    /**
     * @param el { Window|Document|Element }
     * @param event {string|object}
     * @param selector {string|function}
     * @param [callback] {function}
     */
    $cms.dom.off = function off(el, event, selector, callback) {
        el = domArg(el);

        if (event && (typeof event !== 'string')) {
            each(event, function (type, fn) {
                $cms.dom.off(el, type, selector, fn);
            });
            return;
        }

        if ((typeof selector !== 'string') && (typeof callback !== 'function') && (callback !== false)) {
            callback = selector;
            selector = undefined;
        }

        if (callback === false) {
            callback = returnFalse;
        }

        removeEvent(el, event, callback, selector)
    };

    var mouseEvents = { click: 1, mousedown: 1, mouseup: 1, mousemove: 1 };

    /**
     * @memberof $cms.dom
     * @param type
     * @param props
     * @returns { Event }
     */
    $cms.dom.createEvent = function createEvent(type, props) {
        if (isObj(type)) {
            props = type;
            type = props.type;
        }
        var event = document.createEvent((type in mouseEvents) ? 'MouseEvents' : 'Events'),
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

    /**
     * @memberof $cms.dom
     * @param el
     * @param event
     * @param args
     * @returns {*}
     */
    $cms.dom.trigger = function trigger(el, event, args) {
        el = domArg(el);
        event = ((typeof event === 'string') || isPlainObj(event)) ? $cms.dom.createEvent(event) : event;
        if (args) {
            event._args = args;
        }

        // handle focus(), blur() by calling them directly
        if ((event.type in focusEvents) && (typeof el[event.type] === 'function')) {
            return el[event.type]();
        } else if ((event.type === 'click') && (el.localName === 'input') && (el.type === 'checkbox') && el.click) {
            // For checkbox, fire native event so checked state will be right
            return el.click();
        } else {
            return el.dispatchEvent(event)
        }
    };

    function camelize(str) {
        return strVal(str).replace(/-+(.)?/g, function (match, chr) {
            return chr ? chr.toUpperCase() : '';
        });
    }

    function dasherize(str) {
        return strVal(str).replace(/::/g, '/')
            .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
            .replace(/([a-z\d])([A-Z])/g, '$1_$2')
            .replace(/_/g, '-')
            .toLowerCase();
    }

    var cssNumericProps = {'column-count': 1, 'columns': 1, 'font-weight': 1, 'line-height': 1, 'opacity': 1, 'z-index': 1, 'zoom': 1};
    function maybeAddPx(name, value) {
        return ((typeof value === 'number') && !(name in cssNumericProps)) ? (value + 'px') : value;
    }

    /**
     * @memberof $cms.dom
     * @param el
     * @param property
     * @param value
     * @returns {*}
     */
    $cms.dom.css = function css(el, property, value) {
        var key;

        el = elArg(el);

        if (value === undefined) {
            if (typeof property === 'string') {
                return el.style[camelize(property)] || computedStyle(el, property);
            } else if (Array.isArray(property)) {
                var cs = computedStyle(el),
                    props = {};
                property.forEach(function (prop) {
                    props[prop] = (el.style[camelize(prop)] || cs.getPropertyValue(prop));
                });
                return props;
            }
        }

        var css = '';
        if (typeof property === 'string') {
            if (!value && (value !== 0)) {
                el.style.removeProperty(dasherize(property));
            } else {
                css = dasherize(property) + ':' + maybeAddPx(property, value);
            }
        } else {
            for (key in property) {
                if (!property[key] && (property[key] !== 0)) {
                    el.style.removeProperty(dasherize(key));
                } else {
                    css += dasherize(key) + ':' + maybeAddPx(key, property[key]) + ';';
                }
            }
        }

        el.style.cssText += ';' + css;
    };

    /**
     * @memberof $cms.dom
     * @param {Element} el
     * @param {string} property
     * @param {string|Array} values
     * @returns {boolean}
     */
    $cms.dom.isCss = function isCss(el, property, values) {
        el = elArg(el);
        values = arrVal(values);

        return values.includes($cms.dom.css(el, property));
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @returns {boolean}
     */
    $cms.dom.isDisplayed = function isDisplayed(el) {
        el = elArg(el);
        return $cms.dom.css(el, 'display') !== 'none';
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @returns {boolean}
     */
    $cms.dom.notDisplayed = function notDisplayed(el) {
        el = elArg(el);
        return $cms.dom.css(el, 'display') === 'none';
    };

    var _initial = {};
    /**
     * Gets the 'initial' value for an element type's CSS property (only 'display' supported as of now)
     * @memberof $cms.dom
     * @param el
     * @param property
     * @returns {*}
     */
    $cms.dom.initial = function initial(el, property) {
        el = elArg(el);

        var tag = el.localName, doc;

        _initial[tag] || (_initial[tag] = {});

        if (_initial[tag][property] === undefined) {
            doc = el.ownerDocument;

            if (property === 'display') {
                var tmp, display;

                tmp = doc.body.appendChild(doc.createElement(tag));
                display = $cms.dom.css(tmp, 'display');
                tmp.parentNode.removeChild(tmp);
                if (display === 'none') {
                    display = 'block';
                }

                _initial[tag][property] = display;
            }
        }

        return _initial[tag][property];
    };

    /**
     * @memberof $cms.dom
     * @param el
     */
    $cms.dom.show = function show(el) {
        el = elArg(el);

        if (el.style.display === 'none') {
            el.style.removeProperty('display');
        }

        if (computedStyle(el, 'display') === 'none') { // Still hidden (with CSS?)
            el.style.display = $cms.dom.initial(el, 'display');
        }
    };

    /**
     *
     * @param el
     */
    $cms.dom.hide = function hide(el) {
        el = elArg(el);
        $cms.dom.css(el, 'display', 'none');
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param show
     */
    $cms.dom.toggle = function toggle(el, show) {
        el = elArg(el);
        show = (show !== undefined) ? !!show : ($cms.dom.css(el, 'display') === 'none');

        if (show) {
            $cms.dom.show(el);
        } else {
            $cms.dom.hide(el);
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param show
     */
    $cms.dom.toggleWithAria = function toggleWithAria(el, show) {
        el = elArg(el);
        show = (show !== undefined) ? !!show : ($cms.dom.css(el, 'display') === 'none');

        if (show) {
            $cms.dom.show(el);
            el.setAttribute('aria-hidden', 'false');
        } else {
            $cms.dom.hide(el);
            el.setAttribute('aria-hidden', 'true')
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param disabled
     */
    $cms.dom.toggleDisabled = function toggleDisabled(el, disabled) {
        el = elArg(el);
        disabled = (disabled !== undefined) ? !!disabled : !el.disabled;

        el.disabled = disabled;
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param checked
     */
    $cms.dom.toggleChecked = function toggleChecked(el, checked) {
        el = elArg(el);
        checked = (checked !== undefined) ? !!checked : !el.checked;

        el.checked = checked;
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param callback
     */
    $cms.dom.fadeIn = function fadeIn(el, duration, callback) {
        el = elArg(el);

        if ((typeof duration === 'function') && (callback === undefined)) {
            callback = duration;
            duration = undefined;
        }

        duration = Number.isFinite(+duration) ? +duration : 400;

        var target = $cms.dom.css(el, 'opacity');

        if (target > 0) {
            $cms.dom.css(el, 'opacity', 0);
        } else {
            target = 1;
        }

        $cms.dom.show(el);

        if (('animate' in emptyEl) && (duration > 0)) { // Progressive enhancement using the web animations API
            var keyFrames = [{ opacity: 0 }, { opacity: target }],
                options = { duration : duration },
                animation = el.animate(keyFrames, options);

            animation.onfinish = function (e) {
                el.style.opacity = target;

                if (callback) {
                    callback.call(el, e, el);
                }
            };
        } else {
            el.style.opacity = target;
            if (callback) {
                callback.call(el, {}, el);
            }
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param callback
     */
    $cms.dom.fadeOut = function fadeOut(el, duration, callback) {
        el = elArg(el);

        if ((typeof duration === 'function') && (callback === undefined)) {
            callback = duration;
            duration = undefined;
        }

        duration = Number.isFinite(+duration) ? +duration : 400;

        if ('animate' in emptyEl) { // Progressive enhancement using the web animations API
            var keyFrames = [{ opacity: $cms.dom.css(el, 'opacity')}, { opacity: 0 }],
                options = { duration: duration },
                animation = el.animate(keyFrames, options);

            animation.onfinish = function (e) {
                $cms.dom.hide(el);
                if (callback) {
                    callback.call(el, e, el);
                }
            };
        } else {
            $cms.dom.hide(el);
            if (callback) {
                callback.call(el, {}, el);
            }
        }
    };

    /**
     * @memberof $cms.dom
     * @param keyboardEvent
     * @param checkKey
     * @returns {*}
     */
    $cms.dom.keyPressed = function keyPressed(keyboardEvent, checkKey) {
        var key = keyboardEvent.key;

        if (checkKey !== undefined) {
            // Key(s) to check against passed

            if (typeof checkKey === 'number') {
                checkKey = strVal(checkKey);
            }

            if (typeof checkKey === 'string') {
                return key === checkKey;
            }

            if (isRegExp(checkKey)) {
                return checkKey.test(key);
            }

            if (isArrayLike(checkKey, 1)) {
                return includes(checkKey, key);
            }

            return false;
        }

        return key;
    };

    /**
     * Returns the output character produced by a KeyboardEvent, or empty string if none
     * @memberof $cms.dom
     * @param keyboardEvent
     * @param checkOutput
     * @returns {*}
     */
    $cms.dom.keyOutput = function keyOutput(keyboardEvent, checkOutput) {
        var key = keyboardEvent.key;

        if ((typeof key !== 'string') || (key.length !== 1)) {
            key = '';
        }

        if (checkOutput !== undefined) {
            // Key output(s) to check against passed
            if (typeof checkOutput === 'string') {
                return key === checkOutput;
            }

            if (isRegExp(checkOutput)) {
                return checkOutput.test(key);
            }

            if (isArrayLike(checkOutput, 1)) {
                return includes(checkOutput, key);
            }

            return false;
        }

        return key;
    };

    /*$cms.dom.isActionEvent = */function isActionEvent(e) {
        if ((e.type === 'click') && ((e.button === 0) || (e.button === 1))) {  // 0 = Left Click, 1 = Middle Click
            return true;
        }

        if ((e.type === 'keydown') || (e.type === 'keypress')) {
            return $cms.dom.keyPressed(e, ['Enter', 'Space']);
        }

        return false;
    }

    function setAttr(el, name, value) {
        (value != null) ? el.setAttribute(name, value) : el.removeAttribute(name);
    }

    /**
     * @memberof $cms.dom
     * @param el
     * @param name
     * @param value
     * @returns {*|string}
     */
    $cms.dom.attr = function attr(el, name, value) {
        var key;

        el = elArg(el);

        if ((typeof name === 'string') && (value === undefined)) {
            return el.getAttribute(name);
        }

        if (isObj(name)) {
            for (key in name) {
                setAttr(el, key, name[key]);
            }
        } else {
            setAttr(el, name, value);
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param name
     */
    $cms.dom.removeAttr = function removeAttr(el, name) {
        el = elArg(el);

        name.split(' ').forEach(function (attribute) {
            setAttr(el, attribute, null)
        });
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param html
     * @returns {string|*}
     */
    $cms.dom.html = function html(el, html) {
        // Parser hint: .innerHTML okay
        var i, len;

        el = elArg(el);

        if (html === undefined) {
            return el.innerHTML;
        }

        for (i = 0, len = el.children.length; i < len; i++) {
            // Detach behaviors from the (if any) elements to be deleted
            $cms.detachBehaviors(el.children[i]);
        }

        el.innerHTML = strVal(html);

        // Attach behaviors to new child elements (if any)
        for (i = 0, len = el.children.length; i < len; i++) {
            $cms.attachBehaviors(el.children[i]);
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     */
    $cms.dom.empty = function empty(el) {
        el = elArg(el);

        $cms.dom.html(el, '');
    };

    /**
     * @memberof $cms.dom
     * @param el
     */
    $cms.dom.remove = function remove(el) {
        el = elArg(el);

        if (el) {
            $cms.detachBehaviors(el);
            el.parentNode.removeChild(el);
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param html
     */
    $cms.dom.prependHtml = function prependHtml(el, html) {
        el = elArg(el);

        var prevChildrenLength = el.children.length, newChildrenLength, i, stop;

        el.insertAdjacentHTML('afterbegin', html);

        newChildrenLength = el.children.length;

        if (prevChildrenLength === newChildrenLength) {
            // No new child elements added.
            return;
        }

        for (i = 0, stop = (prevChildrenLength - newChildrenLength); i < stop; i++) {
            $cms.attachBehaviors(el.children[i]);
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param html
     */
    $cms.dom.appendHtml = function appendHtml(el, html) {
        el = elArg(el);

        var startIndex = el.children.length, newChildrenLength, i;

        el.insertAdjacentHTML('beforeend', html);

        newChildrenLength = el.children.length;

        if (startIndex === newChildrenLength) {
            // No new child elements added.
            return;
        }

        for (i = startIndex; i < newChildrenLength; i++) {
            $cms.attachBehaviors(el.children[i]);
        }
    };

    /**
     * Put some new HTML around the given element
     * @memberof $cms.dom
     * @param el
     * @param html
     * @returns {*}
     */
    $cms.dom.outerHtml = function outerHtml(el, html) {
        el = elArg(el);

        var parent = el.parentNode,
            next = el.nextSibling,
            node;

        if (html === undefined) {
            return el.outerHTML;
        }

        parent.removeChild(el);

        $cms.dom.html(el, html);

        while (node = el.firstChild) {
            el.removeChild(node);
            parent.insertBefore(node, next);
        }
    };

    /**
     * Returns the provided element's width excluding padding and borders
     * @memberof $cms.dom
     * @param el
     * @returns {number}
     */
    $cms.dom.contentWidth = function contentWidth(el) {
        el = elArg(el);

        var cs = computedStyle(el),
            padding = parseFloat(cs.paddingLeft) + parseFloat(cs.paddingRight),
            border = parseFloat(cs.borderLeftWidth) + parseFloat(cs.borderRightWidth);

        return el.offsetWidth - padding - border;
    };

    /**
     * Returns the provided element's height excluding padding and border
     * @memberof $cms.dom
     * @param el
     * @returns {number}
     */
    $cms.dom.contentHeight = function contentHeight(el) {
        el = elArg(el);

        var cs = computedStyle(el),
            padding = parseFloat(cs.paddingTop) + parseFloat(cs.paddingBottom),
            border = parseFloat(cs.borderTopWidth) + parseFloat(cs.borderBottomWidth);

        return el.offsetHeight - padding - border;
    };

    var serializeExcludedTypes = { submit: 1, reset: 1, button: 1, file: 1 };
    /**
     * @memberof $cms.dom
     * @param form
     * @returns {Array}
     */
    $cms.dom.serializeArray = function serializeArray(form) {
        var name, result = [];

        form = elArg(form);

        forEach(form.elements, function (field) {
            name = field.name;
            if (name && (field.localName !== 'fieldset') && !field.disabled && !(field.type in serializeExcludedTypes) && (!['radio', 'checkbox'].includes(field.type) || field.checked)) {
                add($cms.dom.val(field));
            }
        });

        function add(value) {
            if (Array.isArray(value)) {
                return value.forEach(add);
            }
            result.push({name: name, value: value});
        }

        return result;
    };

    /**
     * @memberof $cms.dom
     * @param form
     * @returns {string}
     */
    $cms.dom.serialize = function serialize(form) {
        var result = [];

        form = elArg(form);

        $cms.dom.serializeArray(form).forEach(function (el) {
            result.push(encodeUC(el.name) + '=' + encodeUC(el.value))
        });
        return result.join('&');
    };

    function defineBehaviors(behaviors) {
        behaviors = objVal(behaviors);

        for (var key in behaviors) {
            $cms.behaviors[key] = behaviors[key];
        }
    }

    /**
     * @return {string[]}
     */
    function behaviorNamesByPriority() {
        var name, behavior, priority, priorities, i,
            byPriority = {},
            names = [];

        for (name in $cms.behaviors) {
            behavior = $cms.behaviors[name];
            priority = +behavior.priority || 0;

            byPriority[priority] || (byPriority[priority] = []);
            byPriority[priority].push(name);
        }

        priorities = Object.keys(byPriority);
        priorities.sort(function (a, b) {
            // Numerical descending sort
            return b - a;
        });

        for (i = 0; i < priorities.length; i++) {
            priority = priorities[i];
            pushArray(names, byPriority[priority]);
        }

        return names;
    }

    /**
     *
     * @param context
     * @param settings
     */
    function attachBehaviors(context, settings) {
        var names;

        if (!isDocOrEl(context)) {
            throw new TypeError('Invalid argument type: `context` must be of type HTMLDocument or HTMLElement');
        }

        settings || (settings = $cms.settings);

        // Execute all of them.
        names = behaviorNamesByPriority();

        _attach(0);
        function _attach(i) {
            var name = names[i], ret;

            if (isObj($cms.behaviors[name]) && (typeof $cms.behaviors[name].attach === 'function')) {
                try {
                    ret = $cms.behaviors[name].attach(context, settings);
                } catch (e) {
                    $cms.error('$cms.attachBehaviors(): Error while attaching behavior \'' + name + '\' to', context, '\n', e);
                }
            }

            ++i;

            if (names.length <= i) {
                return;
            }

            if (isPromise(ret)) { // If the behavior returns a promise, we wait for it before moving on
                ret.then(_attach.bind(undefined, i), _attach.bind(undefined, i));
            } else { // no promise!
                _attach(i);
            }
        }
    }

    /**
     *
     * @param context
     * @param settings
     * @param trigger
     */
    function detachBehaviors(context, settings, trigger) {
        var name;

        if (!isDocOrEl(context)) {
            throw new TypeError('Invalid argument type: `context` must be of type HTMLDocument or HTMLElement');
        }

        settings || (settings = $cms.settings);
        trigger || (trigger = 'unload');

        // Detach all of them.
        for (name in $cms.behaviors) {
            if (isObj($cms.behaviors[name]) && (typeof $cms.behaviors[name].detach === 'function')) {
                try {
                    $cms.behaviors[name].detach(context, settings, trigger);
                } catch (e) {
                    $cms.error('$cms.detachBehaviors(): Error while detaching behavior \'' + name + '\' from', context, '\n', e);
                }
            }
        }
    }

    // List of view options that can be set as properties.
    var viewOptionsList = { el: 1, id: 1, attributes: 1, className: 1, tagName: 1, events: 1 };

    $cms.View = View;
    /**
     * @memberof $cms
     * @class
     */
    function View(params, viewOptions) {
        /** @var {string} */
        this.tagName = 'div';
        /** @var { HTMLElement } */
        this.el = null;

        this.initialize.apply(this, arguments);
    }

    // Cached regex to split keys for `delegate`.
    var rgxDelegateEventSplitter = /^(\S+)\s*(.*)$/;
    properties(View.prototype, /**@lends $cms.View#*/{
        /**
         * @method
         */
        initialize: function (params, viewOptions) {
            this.params = objVal(params);

            if (isObj(viewOptions)) {
                for (var key in viewOptionsList) {
                    if (key in viewOptions) {
                        this[key] = viewOptions[key];
                    }
                }
            }

            this._ensureElement();
        },
        /**
         * @method
         */
        $: function (selector) {
            return $cms.dom.$(this.el, selector);
        },
        /**
         * @method
         */
        $$: function (selector) {
            return $cms.dom.$$(this.el, selector);
        },
        /**
         * @method
         */
        $$$: function (selector) {
            return $cms.dom.$$$(this.el, selector);
        },
        /**
         * @method
         */
        $closest: function (el, selector) {
            return $cms.dom.closest(el, selector, this.el);
        },

        // Remove this view by taking the element out of the DOM.
        /**
         * @method
         */
        remove: function () {
            this._removeElement();
            return this;
        },

        // Remove this view's element from the document and all event listeners
        // attached to it. Exposed for subclasses using an alternative DOM
        // manipulation API.
        /**
         * @method
         */
        _removeElement: function () {
            this.el && this.el.parentNode && this.el.parentNode.removeChild(this.el);
        },

        // Change the view's element (`this.el` property) and re-delegate the
        // view's events on the new element.
        /**
         * @method
         */
        setElement: function (element) {
            this.undelegateEvents();
            this._setElement(element);
            this.delegateEvents();
            return this;
        },

        // Creates the `this.el` reference for this view using the
        // given `el`. `el` can be a CSS selector or an HTML element.
        // Subclasses can override this to utilize an
        // alternative DOM manipulation API and are only required to set the `this.el` property.
        /**
         * @method
         */
        _setElement: function (el) {
            this.el = (typeof el === 'string') ? $cms.dom.$(el) : el;
        },

        /**
         * @method
         */
        events: function () {
            return {};
        },

        // Set callbacks, where `this.events` is a hash of
        // *{"event selector": "callback"}*
        // pairs. Callbacks will be bound to the view, with `this` set properly.
        // Uses event delegation for efficiency.
        // Omitting the selector binds the event to `this.el`.

        /**
         * @method
         */
        delegateEvents: function (events) {
            var key, method, match;
            events || (events = result(this, 'events'));
            if (!events) {
                return this;
            }
            this.undelegateEvents();
            for (key in events) {
                method = events[key];
                if (typeof method !== 'function') {
                    method = this[method];
                }
                if (!method) {
                    continue;
                }
                match = key.match(rgxDelegateEventSplitter);
                this.delegate(match[1], match[2], method.bind(this));
            }
            return this;
        },

        // Add a single event listener to the view's element (or a child element using `selector`).
        /**
         * @method
         */
        delegate: function (eventName, selector, listener) {
            $cms.dom.on(this.el, (eventName + '.delegateEvents' + uid(this)), selector, listener);
            return this;
        },

        // Clears all callbacks previously bound to the view by `delegateEvents`.
        // You usually don't need to use this, but may wish to if you have multiple
        // views attached to the same DOM element.
        /**
         * @method
         */
        undelegateEvents: function () {
            if (this.el) {
                $cms.dom.off(this.el, '.delegateEvents' + uid(this));
            }
            return this;
        },

        // A finer-grained `undelegateEvents` for removing a single delegated event. `selector` and `listener` are both optional.
        /**
         * @method
         */
        undelegate: function (eventName, selector, listener) {
            $cms.dom.off(this.el, (eventName + '.delegateEvents' + uid(this)), selector, listener);
            return this;
        },

        /**
         * @method
         */
        _ensureElement: function () {
            var attrs;
            if (!this.el) {
                attrs = Object.assign({}, result(this, 'attributes'));
                if (this.id) {
                    attrs.id = result(this, 'id');
                }
                if (this.className) {
                    attrs.class = result(this, 'className');
                }
                this.setElement($cms.dom.create(result(this, 'tagName') || 'div', attrs));
            } else {
                this.setElement(result(this, 'el'));
            }
        }
    });

    /**
     * Tempcode filters ported to JS
     * @namespace $cms.filter
     * @param str
     * @param {string} filters
     * @returns {string}
     */
    $cms.filter = function filter(str, filters) {
        str = strVal(str);
        filters = strVal(filters);

        for (var i = 0; i < filters.length; i++) {
            switch (filters[i]) {
                case '&':
                    str = $cms.filter.url(str);
                    break;

                case '~':
                    str = $cms.filter.nl(str);
                    break;

                case '|':
                    str = $cms.filter.id(str);
                    break;

                case '=':
                    str = $cms.filter.html(str);
                    break;
            }
        }

        return str;
    };

    /**
     * JavaScript port of php's urlencode function
     * Credit: http://locutus.io/php/url/urlencode/
     * @param str
     * @returns {string}
     */
    function urlencode(str) {
        return ((str != null) && (str = strVal(str))) ?
            encodeUC(str)
                .replace(/!/g, '%21')
                .replace(/'/g, '%27')
                .replace(/\(/g, '%28')
                .replace(/\)/g, '%29')
                .replace(/\*/g, '%2A')
                .replace(/%20/g, '+')
                .replace(/~/g, '%7E')
            : '';
    }

    /**
     * JS port of the cms_url_encode function used by the tempcode filter '&' (UL_ESCAPED)
     * @memberof $cms.filter
     * @param {string} urlPart
     * @param {boolean} [canTryUrlSchemes]
     * @returns {string}
     */
    $cms.filter.url = function url(urlPart, canTryUrlSchemes) {
        urlPart = strVal(urlPart);
        var urlPartEncoded = urlencode(urlPart);
        canTryUrlSchemes = (canTryUrlSchemes !== undefined) ? !!canTryUrlSchemes : $cms.canTryUrlSchemes;

        if ((urlPartEncoded !== urlPart) && canTryUrlSchemes) {
            // These interfere with URL Scheme processing because they get pre-decoded and make things ambiguous
            urlPart = urlPart.replace(/\//g, ':slash:').replace(/&/g, ':amp:').replace(/#/g, ':uhash:');
            return urlencode(urlPart);
        }

        return urlPartEncoded;
    };

    /**
     * JS port of the tempcode filter '~' (NL_ESCAPED)
     * @memberof $cms.filter
     * @param {string} str
     * @returns {string}
     */
    $cms.filter.nl = function nl(str) {
        return strVal(str).replace(/[\r\n]/g, '');
    };

    var filterIdReplace = {
        '[': '_opensquare_',
        ']': '_closesquare_',
        '\'': '_apostophe_',
        '-': '_minus_',
        ' ': '_space_',
        '+': '_plus_',
        '*': '_star_',
        '/': '__'
    };

    /**
     * JS port of the tempcode filter '|' (ID_ESCAPED)
     * @memberof $cms.filter
     * @param {string} str
     * @returns {string}
     */
    $cms.filter.id = function id(str) {
        var i, char, ascii, out = '';

        str = strVal(str);

        for (i = 0; i < str.length; i++) {
            char = str[i];

            if (char in filterIdReplace) {
                out += filterIdReplace[char];
            } else {
                // @TODO (Salman): Need to make sure I ported this block accurately from PHP.
                ascii = char.charCodeAt(0);

                if (
                    ((i !== 0) && (char === '_'))
                    || ((ascii >= 48) && (ascii <= 57))
                    || ((ascii >= 65) && (ascii <= 90))
                    || ((ascii >= 97) && (ascii <= 122))
                ) {
                    out += char;
                } else {
                    out += '_' + ascii + '_';
                }
            }
        }

        if (out === '') {
            out = 'zero_length';
        } else if (out.startsWith('_')) {
            out = 'und_' + out;
        }

        return out;
    };

    /**
     * JS port of the tempcode filter '=' (FORCIBLY_ENTITY_ESCAPED)
     * @memberof $cms.filter
     * @param {string} str
     * @returns {string}
     */
    $cms.filter.html = function html(str) {
        return ((str != null) && (str = strVal(str))) ?
            str.replace(/&/g, '&amp;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&apos;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
            : '';
    };


    var tempDisabledButtons = {};

    /**
     * @param btn
     * @param permanent
     */
    $cms.ui.disableButton = function disableButton(btn, permanent) {
        permanent = !!permanent;

        if (btn.form && (btn.form.target === '_blank')) {
            return;
        }

        var uid = $cms.uid(btn);

        window.setTimeout(function () {
            btn.style.cursor = 'wait';
            btn.disabled = true;
            if (!permanent) {
                tempDisabledButtons[uid] = true;
            }
        }, 20);

        if (!permanent) {
            window.setTimeout(enableDisabledButton, 5000);
            $cms.dom.on(window, 'pagehide', enableDisabledButton);
        }

        function enableDisabledButton() {
            if (tempDisabledButtons[uid]) {
                btn.disabled = false;
                btn.style.removeProperty('cursor');
                delete tempDisabledButtons[uid];
            }
        }
    };

    /**
     *
     * @param form
     * @param permanent
     */
    $cms.ui.disableFormButtons = function disableFormButtons(form, permanent) {
        var buttons = $cms.dom.$$(form, 'input[type="submit"], input[type="button"], input[type="image"], button');

        buttons.forEach(function (btn) {
            $cms.ui.disableButton(btn, permanent);
        });
    };

    /**
     * This is kinda dumb, ported from checking.js, originally named as disable_buttons_just_clicked()
     * @param permanent
     */
    $cms.ui.disableSubmitAndPreviewButtons = function disableSubmitAndPreviewButtons(permanent) {
        // [accesskey="u"] identifies submit button, [accesskey="p"] identifies preview button
        var buttons = $cms.dom.$$('input[accesskey="u"], button[accesskey="u"], input[accesskey="p"], button[accesskey="p"]');

        permanent = !!permanent;

        buttons.forEach(function (btn) {
            if (!btn.disabled && !tempDisabledButtons[$cms.uid(btn)]) {// We do not want to interfere with other code potentially operating
                $cms.ui.disableButton(btn, permanent);
            }
        });
    };

    /**
     *
     * @param options
     * @returns { $cms.views.ModalWindow }
     */
    $cms.openModalWindow = function openModalWindow(options) {
        return new $cms.views.ModalWindow(options);
    };

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

     HEAVILY Modified by ocProducts for composr.

     */

    $cms.views.ModalWindow = ModalWindow;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function ModalWindow(params) {
        ModalWindow.base(this, 'constructor', arguments);

        // Constants
        this.WINDOW_SIDE_GAP = $cms.$MOBILE ? 5 : 25;
        this.WINDOW_TOP_GAP = 25; // Will also be used for bottom gap for percentage heights
        this.BOX_EAST_PERIPHERARY = 4;
        this.BOX_WEST_PERIPHERARY = 4;
        this.BOX_NORTH_PERIPHERARY = 4;
        this.BOX_SOUTH_PERIPHERARY = 4;
        this.VCENTRE_FRACTION_SHIFT = 0.5; // Fraction of remaining top gap also removed (as overlays look better slightly higher than vertical centre)
        this.LOADING_SCREEN_HEIGHT = 100;

        // Properties
        this.boxWrapperEl =  null;
        this.button_container = null;
        this.returnValue = null;
        this.top_window = null;
        this.iframe_restyle_timer = null;

        // Set params
        params = defaults({ // apply defaults
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
        }, (params || {}));

        for (var key in params) {
            this[key] = params[key];
        }

        this.top_window = window.top;
        this.top_window = this.top_window.top;

        this.close(this.top_window);
        this.init_box();
    }

    $cms.inherits(ModalWindow, $cms.View, /** @lends $cms.views.ModalWindow# */ {
        // Methods...
        close: function (win) {
            if (this.boxWrapperEl) {
                this.top_window.document.body.style.overflow = '';

                this.remove(this.boxWrapperEl, win);
                this.boxWrapperEl = null;

                $cms.dom.off(document, 'keyup mousemove', this.keyup);
            }
            this.opened = false;
        },

        option: function (method) {
            var win = this.top_window; // The below call may end up killing our window reference (for nested alerts), so we need to grab it first
            if (this[method]) {
                if (this.type === 'prompt') {
                    this[method](this.input.value);
                } else if (this.type === 'iframe') {
                    this[method](this.returnValue);
                } else {
                    this[method]();
                }
            }
            if ((method !== 'left') && (method !== 'right')) {
                this.close(win);
            }
        },

        reset_dimensions: function (width, height, init, force_height) {
            force_height = !!force_height;

            if (!this.boxWrapperEl) {
                return;
            }

            var dim = this.getPageSize();

            var bottom_gap = this.WINDOW_TOP_GAP;
            if (this.button_container.firstChild) {
                bottom_gap += this.button_container.offsetHeight;
            }

            if (!force_height) {
                height = 'auto'; // Actually we always want auto heights, no reason to not for overlays
            }

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
            this.boxWrapperEl.firstElementChild.style.width = box_width;
            this.boxWrapperEl.firstElementChild.style.height = box_height;
            var iframe = this.boxWrapperEl.querySelector('iframe');

            if (($cms.dom.hasIframeAccess(iframe)) && (iframe.contentWindow.document.body)) {// Balance iframe height
                iframe.style.width = '100%';
                if (height == 'auto') {
                    if (!init) {
                        detected_box_height = get_window_scroll_height(iframe.contentWindow);
                        iframe.style.height = detected_box_height + 'px';
                    }
                } else {
                    iframe.style.height = '100%';
                }
            }

            // Work out box position
            if (!detected_box_height) detected_box_height = this.boxWrapperEl.firstElementChild.offsetHeight;
            var _box_pos_top, _box_pos_left, box_pos_top, box_pos_left;
            if (box_height == 'auto') {
                if (init) {
                    _box_pos_top = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (this.LOADING_SCREEN_HEIGHT / 2) + this.WINDOW_TOP_GAP; // This is just temporary
                } else {
                    _box_pos_top = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (detected_box_height / 2) + this.WINDOW_TOP_GAP;
                }

                if (iframe) _box_pos_top = this.WINDOW_TOP_GAP; // Actually, for frames we'll put at top so things don't bounce about during loading and if the frame size changes
            } else {
                _box_pos_top = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (parseInt(box_height) / 2) + this.WINDOW_TOP_GAP;
            }
            if (_box_pos_top < this.WINDOW_TOP_GAP) _box_pos_top = this.WINDOW_TOP_GAP;
            _box_pos_left = ((dim.window_width / 2) - (parseInt(box_width) / 2));
            box_pos_top = _box_pos_top + 'px';
            box_pos_left = _box_pos_left + 'px';

            // Save into HTML
            this.boxWrapperEl.firstElementChild.style.top = box_pos_top;
            this.boxWrapperEl.firstElementChild.style.left = box_pos_left;

            var do_scroll = false;

            // Absolute positioning instead of fixed positioning
            if ($cms.$MOBILE || (detected_box_height > dim.window_height) || (this.boxWrapperEl.style.position === 'absolute'/*don't switch back to fixed*/)) {
                var was_fixed = (this.boxWrapperEl.style.position == 'fixed');

                this.boxWrapperEl.style.position = 'absolute';
                this.boxWrapperEl.style.height = ((dim.page_height > (detected_box_height + bottom_gap + _box_pos_left)) ? dim.page_height : (detected_box_height + bottom_gap + _box_pos_left)) + 'px';
                this.top_window.document.body.style.overflow = '';

                if (!$cms.$MOBILE) {
                    this.boxWrapperEl.firstElementChild.style.position = 'absolute';
                    box_pos_top = this.WINDOW_TOP_GAP + 'px';
                    this.boxWrapperEl.firstElementChild.style.top = box_pos_top;
                }

                if ((init) || (was_fixed)) do_scroll = true;
                if (/*maybe a navigation has happened and we need to scroll back up*/iframe && ($cms.dom.hasIframeAccess(iframe)) && (iframe.contentWindow.scrolled_up_for === undefined)) {
                    do_scroll = true;
                }
            } else {// Fixed positioning, with scrolling turned off until the overlay is closed
                this.boxWrapperEl.style.position = 'fixed';
                this.boxWrapperEl.firstElementChild.style.position = 'fixed';
                this.top_window.document.body.style.overflow = 'hidden';
            }

            if (do_scroll) {
                try {// Scroll to top to see
                    this.top_window.scrollTo(0, 0);
                    if (iframe && ($cms.dom.hasIframeAccess(iframe))) {
                        iframe.contentWindow.scrolled_up_for = true;
                    }
                } catch (ignore) {}
            }
        },

        init_box: function () {
            var button;

            this.top_window.overlay_zIndex || (this.top_window.overlay_zIndex = 999999); // Has to be higher than plupload, which is 99999

            this.boxWrapperEl = this.element('div', { // Black out the background
                'styles': {
                    'background': 'rgba(0,0,0,0.7)',
                    'zIndex': this.top_window.overlay_zIndex++,
                    'overflow': 'hidden',
                    'position': $cms.$MOBILE ? 'absolute' : 'fixed',
                    'left': '0',
                    'top': '0',
                    'width': '100%',
                    'height': '100%'
                }
            });

            this.boxWrapperEl.appendChild(this.element('div', { // The main overlay
                'class': 'box overlay ' + this.type,
                'role': 'dialog',
                'styles': {
                    // This will be updated immediately in reset_dimensions
                    'position': $cms.$MOBILE ? 'static' : 'fixed',
                    'margin': '0 auto' // Centering for iOS/Android which is statically positioned (so the container height as auto can work)
                }
            }));

            var that = this;
            var width = this.width;
            var height = this.height;

            this.inject(this.boxWrapperEl);

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
                if (this.type === 'prompt') {
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
                that.option('cancel');
            };

            this.clickout_finished = function () {
                that.option('finished');
            };

            this.clickout_yes = function () {
                that.option('yes');
            };

            this.keyup = function (e) {
                var key_code = (e) ? (e.which || e.keyCode) : null;

                if (key_code == 37) // Left arrow
                {
                    that.option('left');
                } else if (key_code == 39) // Right arrow
                {
                    that.option('right');
                } else if ((key_code == 13/*enter*/) && (that.yes)) {
                    that.option('yes');
                }
                if ((key_code == 13/*enter*/) && (that.finished)) {
                    that.option('finished');
                } else if ((key_code == 27/*esc*/) && (that.cancel_button) && ((that.type == 'prompt') || (that.type == 'confirm') || (that.type == 'lightbox') || (that.type == 'alert'))) {
                    that.option('cancel');
                }
            };

            this.mousemove = function (e) {
                if (that.boxWrapperEl && that.boxWrapperEl.firstElementChild.className.indexOf(' mousemove') == -1) {
                    that.boxWrapperEl.firstElementChild.className += ' mousemove';
                    window.setTimeout(function () {
                        if (that.boxWrapperEl) {
                            that.boxWrapperEl.firstElementChild.classList.remove('mousemove');
                        }
                    }, 2000);
                }
            };

            $cms.dom.on(this.boxWrapperEl.firstElementChild, 'click', function (e) {
                try {
                    that.top_window.cancel_bubbling(e);
                } catch (e) {}

                if ($cms.$MOBILE && (that.type === 'lightbox')) {// IDEA: Swipe detect would be better, but JS does not have this natively yet
                    that.option('right');
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
                        $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_finished);
                    }, 1000);

                    $cms.dom.on(iframe, 'load', function () {
                        if (($cms.dom.hasIframeAccess(iframe)) && (!iframe.contentWindow.document.querySelector('h1')) && (!iframe.contentWindow.document.querySelector('h2'))) {
                            if (iframe.contentWindow.document.title) {
                                $cms.dom.html(overlay_header, $cms.filter.html(iframe.contentWindow.document.title));
                                overlay_header.style.display = 'block';
                            }
                        }
                    });

                    // Fiddle it, to behave like a popup would
                    var name = this.name;
                    var make_frame_like_popup = function make_frame_like_popup() {
                        if (iframe.parentNode.parentNode.parentNode.parentNode == null && that.iframe_restyle_timer != null) {
                            clearInterval(that.iframe_restyle_timer);
                            that.iframe_restyle_timer = null;
                            return;
                        }

                        if (($cms.dom.hasIframeAccess(iframe)) && (iframe.contentWindow.document.body) && (iframe.contentWindow.document.body.done_popup_trans === undefined)) {
                            iframe.contentWindow.document.body.style.background = 'transparent';

                            if (iframe.contentWindow.document.body.className.indexOf('overlay') == -1) {
                                iframe.contentWindow.document.body.className += ' overlay lightbox';
                            }

                            // Allow scrolling, if we want it
                            //iframe.scrolling=(_this.scrollbars===false)?'no':'auto';	Actually, not wanting this now

                            // Remove fixed width
                            var main_website_inner = iframe.contentWindow.$cms.dom.$id('main_website_inner');
                            if (main_website_inner) main_website_inner.id = '';

                            // Remove main_website marker
                            var main_website = iframe.contentWindow.$cms.dom.$id('main_website');
                            if (main_website) main_website.id = '';

                            // Remove popup spacing
                            var popup_spacer = iframe.contentWindow.$cms.dom.$id('popup_spacer');
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
                            base_element.target = that.target;
                            // Firefox 3.6 does not respect <base> element put in via DOM manipulation :(
                            var forms = iframe.contentWindow.document.getElementsByTagName('form');
                            for (var i = 0; i < forms.length; i++) {
                                if (!forms[i].target) forms[i].target = that.target;
                            }
                            var as = iframe.contentWindow.document.getElementsByTagName('a');
                            for (var i = 0; i < as.length; i++) {
                                if (!as[i].target) as[i].target = that.target;
                            }

                            // Set frame name
                            if (name && iframe.contentWindow.name != name) iframe.contentWindow.name = name;

                            // Create close function
                            if (iframe.contentWindow.faux_close === undefined) {
                                iframe.contentWindow.faux_close = function () {
                                    if (iframe && iframe.contentWindow && iframe.contentWindow.returnValue !== undefined) {
                                        that.returnValue = iframe.contentWindow.returnValue;
                                    }
                                    that.option('finished');
                                };
                            }

                            if ($cms.dom.html(iframe.contentWindow.document.body).length > 300) {// Loaded now
                                iframe.contentWindow.document.body.done_popup_trans = true;
                            }
                        } else
                        {
                            if (has_iframe_loaded(iframe) && !has_iframe_ownership(iframe)) {
                                iframe.scrolling='yes';
                                iframe.style.height='500px';
                            }
                        }

                        // Handle iframe sizing
                        if (that.height == 'auto') {
                            that.reset_dimensions(that.width, that.height, false);
                        }
                    };
                    window.setTimeout(function () {
                        illustrate_frame_load('overlay_iframe');
                        iframe.src = that.href;
                        make_frame_like_popup();

                        if (that.iframe_restyle_timer == null)
                            that.iframe_restyle_timer = window.setInterval(make_frame_like_popup, 300); // In case internal nav changes
                    }, 0);
                    break;

                case 'lightbox':
                case 'alert':
                    if (this.yes) {
                        button = this.element('button', {
                            'html': this.yes_button,
                            'class': 'buttons__proceed button_screen_item'
                        });
                        $cms.dom.on(button, 'click', function () {
                            that.option('yes');
                        });
                        window.setTimeout(function () {
                            $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_yes);
                        }, 1000);
                        this.button_container.appendChild(button);
                    } else {
                        window.setTimeout(function () {
                            $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_cancel);
                        }, 1000);
                    }
                    break;

                case 'confirm':
                    button = this.element('button', {
                        'html': this.yes_button,
                        'class': 'buttons__yes button_screen_item',
                        'style': 'font-weight: bold;'
                    });
                    $cms.dom.on(button, 'click', function () {
                        that.option('yes');
                    });
                    this.button_container.appendChild(button);
                    button = this.element('button', {
                        'html': this.no_button,
                        'class': 'buttons__no button_screen_item'
                    });
                    $cms.dom.on(button, 'click', function () {
                        that.option('no');
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
                        button = this.element('button', {
                            'html': this.yes_button,
                            'class': 'buttons__yes button_screen_item',
                            'style': 'font-weight: bold;'
                        });
                        $cms.dom.on(button, 'click', function () {
                            that.option('yes');
                        });
                        this.button_container.appendChild(button);
                    }
                    window.setTimeout(function () {
                        $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_cancel);
                    }, 1000);
                    break;
            }

            // Cancel button handled either via button in corner (if there's no other buttons) or another button in the panel (if there's other buttons)
            if (this.cancel_button) {
                if (this.button_container.firstChild) {
                    button = this.element('button', {
                        'html': this.cancel_button,
                        'class': 'button_screen_item buttons__cancel'
                    });
                    this.button_container.appendChild(button);
                } else {
                    button = this.element('img', {
                        'src': $cms.img('{$IMG;,button_lightbox_close}'),
                        'alt': this.cancel_button,
                        'class': 'overlay_close_button'
                    });
                    container.appendChild(button);
                }
                $cms.dom.on(button, 'click', function () {
                    that.option(this.cancel ? 'cancel' : 'finished');
                });
            }

            // Put together
            if (this.button_container.firstChild) {
                if (this.type == 'iframe') {
                    container.appendChild(this.element('hr', {'class': 'spaced_rule'}));
                }
                container.appendChild(this.button_container);
            }
            this.boxWrapperEl.firstElementChild.appendChild(container);

            // Handle dimensions
            this.reset_dimensions(this.width, this.height, true);
            $cms.dom.on(window, 'resize', function () {
                that.reset_dimensions(width, height, false);
            });

            // Focus first button by default
            if (this.input) {
                setTimeout(function () {
                    that.input.focus();
                });
            } else if (this.boxWrapperEl.querySelector('button')) {
                this.boxWrapperEl.querySelector('button').focus();
            }

            setTimeout(function () { // Timeout needed else keyboard activation of overlay opener may cause instant shutdown also
                $cms.dom.on(document, 'keyup', that.keyup);
                $cms.dom.on(document, 'mousemove', that.mousemove);
            }, 100);


            function has_iframe_loaded(iframe) {
                var has_loaded = false;
                try {
                    has_loaded = (typeof iframe != 'undefined') && (iframe != null) && (iframe.contentWindow.location.host != '');
                }
                catch (e) {
                }
                return has_loaded;
            }

            function has_iframe_ownership(iframe) {
                var has_ownership = false;
                try {
                    has_ownership = (typeof iframe != 'undefined') && (iframe != null) && (iframe.contentWindow.location.host == window.location.host) && (iframe.contentWindow.document != null);
                }
                catch (e) {
                }
                return has_ownership;
            }
        },

        inject: function (el) {
            this.top_window.document.body.appendChild(el);
        },

        remove: function (el, win) {
            if (!win) {
                win = this.top_window;
            }
            win.document.body.removeChild(el);
        },

        element: function (tag, options) {
            var el = this.top_window.document.createElement(tag),
                attributes = {
                    'html': 'innerHTML',
                    'class': 'className',
                    'for': 'htmlFor',
                    'text': 'textContent'
                };

            if (isObj(options)) {
                for (var name in options) {
                    var value = options[name];
                    if (name === 'styles') {
                        this.setStyles(el, value);
                    } else if (name === 'html') {
                        $cms.dom.html(el, value);
                    } else if (attributes[name]) {
                        el[attributes[name]] = value;
                    } else {
                        el.setAttribute(name, value);
                    }
                }
            }
            return el;
        },

        setStyles: function (el, obj) {
            for (var k in obj) {
                this.setStyle(el, k, obj[k]);
            }
        },

        setStyle: function (el, prop, val) {
            try {
                el.style[prop] = val;
            } catch (e) {}
        },

        getPageSize: function () {
            return {
                'page_width': this.top_window.get_window_scroll_width(this.top_window),
                'page_height': this.top_window.get_window_scroll_height(this.top_window),
                'window_width': this.top_window.get_window_width(this.top_window),
                'window_height': this.top_window.get_window_height()
            };
        }
    });

    $cms.createTreeList = function (name, ajax_url, root_id, opts, multi_selection, tabindex, all_nodes_selectable, use_server_id) {
        var options = {
                name: name,
                ajax_url: ajax_url,
                root_id: root_id,
                options: opts,
                multi_selection: multi_selection,
                tabindex: tabindex,
                all_nodes_selectable: all_nodes_selectable,
                use_server_id: use_server_id
            },
            el = $cms.dom.$('#tree_list__root_' + name);

        return new $cms.views.TreeList(options, {el: el});
    };

    $cms.views.TreeList = TreeList;

    /** @class */
    function TreeList(params) {
        TreeList.base(this, 'constructor', arguments);

        this.name = params.name;
        this.ajax_url = params.ajax_url;
        this.options = params.options;
        this.multi_selection = !!params.multi_selection;
        this.tabindex = params.tabindex || null;
        this.all_nodes_selectable = !!params.all_nodes_selectable;
        this.use_server_id = !!params.use_server_id;

        $cms.dom.html(this.el, '<div class="ajax_loading vertical_alignment"><img src="' + $cms.img('{$IMG*;^,loading}') + '" alt="" /> <span>{!LOADING;^}</span></div>');

        // Initial rendering
        var url = $cms.baseUrl(this.ajax_url);
        if (params.root_id) {
            url += '&id=' + encodeUC(params.root_id);
        }
        url += '&options=' + this.options;
        url += '&default=' + encodeUC($cms.dom.$id(this.name).value);

        do_ajax_request(url, this);

        var that = this;
        $cms.dom.on(document.documentElement, 'mousemove', function (event) {
            that.specialKeyPressed = !!(event.ctrlKey || event.altKey || event.metaKey || event.shiftKey)
        });
    }

    $cms.inherits(TreeList, $cms.View, /** @lends TreeList.prototype */ {
        specialKeyPressed: false,

        tree_list_data: '',
        busy: false,
        last_clicked: null, // The hyperlink object that was last clicked (usage during multi selection when holding down shift)

        /* Go through our tree list looking for a particular XML node */
        getElementByIdHack: function (id, type, ob, serverid) {
            var i, test, done = false;

            type || (type = 'c');
            ob || (ob = this.tree_list_data);
            serverid = !!serverid;

            // Normally we could only ever use getElementsByTagName, but Konqueror and Safari don't like it
            try {// IE9 beta has serious problems
                if (ob.getElementsByTagName) {
                    var results = ob.getElementsByTagName((type === 'c') ? 'category' : 'entry');
                    for (i = 0; i < results.length; i++) {
                        if ((results[i].getAttribute !== undefined) && (results[i].getAttribute(serverid ? 'serverid' : 'id') == id)) {
                            return results[i];
                        }
                    }
                    done = true;
                }
            } catch (e) {}

            if (!done) {
                for (i = 0; i < ob.children.length; i++) {
                    if (ob.children[i].localName === 'category') {
                        test = this.getElementByIdHack(id, type, ob.children[i], serverid);
                        if (test) {
                            return test;
                        }
                    }
                    if ((ob.children[i].localName === ((type === 'c') ? 'category' : 'entry')) && (ob.children[i].getAttribute(serverid ? 'serverid' : 'id') == id)) {
                        return ob.children[i];
                    }
                }
            }
            return null;
        },

        response: function (ajax_result_frame, ajax_result, expanding_id) {
            if (!ajax_result) {
                return;
            }

            ajax_result = careful_import_node(ajax_result);

            var i, xml, temp_node, html;
            if (!expanding_id) {// Root
                html = $cms.dom.$id('tree_list__root_' + this.name);
                $cms.dom.html(html, '');

                this.tree_list_data = ajax_result.cloneNode(true);
                xml = this.tree_list_data;

                if (!xml.firstElementChild) {
                    var error = document.createTextNode((this.name.indexOf('category') == -1 && window.location.href.indexOf('category') == -1) ? '{!NO_ENTRIES;^}' : '{!NO_CATEGORIES;^}');
                    html.className = 'red_alert';
                    html.appendChild(error);
                    return;
                }
            } else { // Appending
                xml = this.getElementByIdHack(expanding_id, 'c');
                for (i = 0; i < ajax_result.childNodes.length; i++) {
                    temp_node = ajax_result.childNodes[i];
                    xml.appendChild(temp_node.cloneNode(true));
                }
                html = $cms.dom.$id(this.name + 'tree_list_c_' + expanding_id);
            }

            attributes_full_fixup(xml);

            this.root_element = this.renderTree(xml, html);

            var name = this.name;
            fixup_node_positions(name);
        },

        renderTree: function (xml, html, element) {
            var that = this, i, colour, new_html, url, escaped_title,
                initially_expanded, selectable, extra, title, func,
                temp, master_html, node, node_self_wrap, node_self;

            element || (element = $cms.dom.$id(this.name));

            clear_transition_and_set_opacity(html, 0.0);
            fade_transition(html, 100, 30, 4);

            html.style.display = xml.firstElementChild ? 'block' : 'none';

            forEach(xml.children, function (node) {
                var el, html_node, expanding;

                // Special handling of 'options' nodes, inject new options
                if (node.localName === 'options') {
                    that.options = encodeUC($cms.dom.html(node));
                    return;
                }

                // Special handling of 'expand' nodes, which say to pre-expand some categories as soon as the page loads
                if (node.localName === 'expand') {
                    el = $cms.dom.$('#' + that.name + 'texp_c_' + $cms.dom.html(node));
                    if (el) {
                        html_node = $cms.dom.$('#' + that.name + 'tree_list_c_' + $cms.dom.html(node));
                        expanding = (html_node.style.display != 'block');
                        if (expanding)
                            el.onclick(null, true);
                    } else {
                        // Now try against serverid
                        var xml_node = that.getElementByIdHack($cms.dom.html(node), 'c', null, true);
                        if (xml_node) {
                            el = $cms.dom.$('#' + that.name + 'texp_c_' + xml_node.getAttribute('id'));
                            if (el) {
                                html_node = $cms.dom.$id(that.name + 'tree_list_c_' + xml_node.getAttribute('id'));
                                expanding = (html_node.style.display != 'block');
                                if (expanding) {
                                    el.onclick(null, true);
                                }
                            }
                        }
                    }
                    return;
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
                node_self.object = that;
                colour = (node.getAttribute('selectable') == 'true' || that.all_nodes_selectable) ? 'native_ui_foreground' : 'locked_input_field';
                selectable = (node.getAttribute('selectable') == 'true' || that.all_nodes_selectable);
                if (node.localName === 'category') {
                    // Render self
                    node_self.className = (node.getAttribute('highlighted') == 'true') ? 'tree_list_highlighted' : 'tree_list_nonhighlighted';
                    initially_expanded = (node.getAttribute('has_children') != 'true') || (node.getAttribute('expanded') == 'true');
                    escaped_title = $cms.filter.html((node.getAttribute('title') !== undefined) ? node.getAttribute('title') : '');
                    if (escaped_title == '') escaped_title = '{!NA_EM;^}';
                    var description = '';
                    var description_in_use = '';
                    if (node.getAttribute('description_html')) {
                        description = node.getAttribute('description_html');
                        description_in_use = $cms.filter.html(description);
                    } else {
                        if (node.getAttribute('description')) description = $cms.filter.html('. ' + node.getAttribute('description'));
                        description_in_use = escaped_title + ': {!TREE_LIST_SELECT*;^}' + description + ((node.getAttribute('serverid') == '') ? (' (' + $cms.filter.html(node.getAttribute('serverid')) + ')') : '');
                    }
                    var img_url = $cms.img('{$IMG;,1x/treefield/category}');
                    var img_url_2 = $cms.img('{$IMG;,2x/treefield/category}');
                    if (node.getAttribute('img_url')) {
                        img_url = node.getAttribute('img_url');
                        img_url_2 = node.getAttribute('img_url_2');
                    }
                    $cms.dom.html(node_self, ' \
				<div> \
					<input class="ajax_tree_expand_icon"' + (that.tabindex ? (' tabindex="' + that.tabindex + '"') : '') + ' type="image" alt="' + ((!initially_expanded) ? '{!EXPAND;^}' : '{!CONTRACT;^}') + ': ' + escaped_title + '" title="' + ((!initially_expanded) ? '{!EXPAND;^}' : '{!CONTRACT;^}') + '" id="' + that.name + 'texp_c_' + node.getAttribute('id') + '" src="' + $cms.url(!initially_expanded ? '{$IMG*;,1x/treefield/expand}' : '{$IMG*;,1x/treefield/collapse}') + '" srcset="' + $cms.url(!initially_expanded ? '{$IMG*;,2x/treefield/expand}' : '{$IMG*;,2x/treefield/collapse}') + ' 2x" /> \
					<img class="ajax_tree_cat_icon" alt="{!CATEGORY;^}" src="' + $cms.filter.html(img_url) + '" srcset="' + $cms.filter.html(img_url_2) + ' 2x" /> \
					<label id="' + that.name + 'tsel_c_' + node.getAttribute('id') + '" for="' + that.name + 'tsel_r_' + node.getAttribute('id') + '" data-mouseover-activate-tooltip="[\'' + (node.getAttribute('description_html') ? '' : $cms.filter.html(description_in_use)) + '\', \'auto\']" class="ajax_tree_magic_button ' + colour + '"><input ' + (that.tabindex ? ('tabindex="' + that.tabindex + '" ') : '') + 'id="' + that.name + 'tsel_r_' + node.getAttribute('id') + '" style="position: absolute; left: -10000px" type="radio" name="_' + that.name + '" value="1" title="' + description_in_use + '" />' + escaped_title + '</label> \
					<span id="' + that.name + 'extra_' + node.getAttribute('id') + '">' + extra + '</span> \
				</div> \
			');
                    var expand_button = node_self.querySelector('input');
                    expand_button.oncontextmenu = returnFalse;
                    expand_button.object = that;
                    expand_button.onclick = function (event, automated) {
                        if ($cms.dom.$('#choose_' + that.name)) {
                            $cms.dom.$('#choose_' + that.name).click();
                        }

                        if (event) {
                            event.preventDefault();
                        }
                        that.handleTreeClick.call(expand_button, event, automated);
                        return false;

                    };
                    var a = node_self.querySelector('label');
                    expand_button.onkeypress = a.onkeypress = a.firstElementChild.onkeypress = function (expand_button) {
                        return function (event) {
                            if (((event.keyCode ? event.keyCode : event.charCode) == 13) || ['+', '-', '='].includes(String.fromCharCode(event.keyCode ? event.keyCode : event.charCode))) {
                                expand_button.onclick(event);
                            }
                        }
                    }(expand_button);
                    a.oncontextmenu = returnFalse;
                    a.handleSelection = that.handleSelection;
                    a.firstElementChild.addEventListener('focus', function () {
                        this.parentNode.style.outline = '1px dotted';
                    });
                    a.firstElementChild.addEventListener('blur', function () {
                        this.parentNode.style.outline = '';
                    });
                    a.firstElementChild.addEventListener('click', a.handleSelection);
                    a.addEventListener('click', a.handleSelection); // Needed by Firefox, the radio button's onclick will not be called if shift/ctrl held
                    a.firstElementChild.object = this;
                    a.object = this;
                    a.addEventListener('mousedown', function (event) { // To disable selection of text when holding shift or control
                        if (event.ctrlKey || event.metaKey || event.shiftKey) {
                            if (event.cancelable) {
                                event.preventDefault();
                            }
                        }
                    });
                    html.appendChild(node_self_wrap);

                    // Do any children
                    new_html = document.createElement('div');
                    new_html.role = 'treeitem';
                    new_html.id = that.name + 'tree_list_c_' + node.getAttribute('id');
                    new_html.style.display = ((!initially_expanded) || (node.getAttribute('has_children') != 'true')) ? 'none' : 'block';
                    new_html.style.padding/*{$?,{$EQ,{!en_left},left},Left,Right}*/ = '15px';
                    var selected = ((that.use_server_id ? node.getAttribute('serverid') : node.getAttribute('id')) == element.value && element.value != '') || node.getAttribute('selected') == 'yes';
                    if (selectable) {
                        that.makeElementLookSelected($cms.dom.$id(that.name + 'tsel_c_' + node.getAttribute('id')), selected);
                        if (selected) {
                            element.value = (that.use_server_id ? node.getAttribute('serverid') : node.getAttribute('id')); // Copy in proper ID for what is selected, not relying on what we currently have as accurate
                            if (element.value != '') {
                                if (element.selected_title === undefined) element.selected_title = '';
                                if (element.selected_title != '') element.selected_title += ',';
                                element.selected_title += node.getAttribute('title');
                            }
                            if (element.onchange) element.onchange();
                            if (element.fakeonchange !== undefined && element.fakeonchange) element.fakeonchange();
                        }
                    }
                    node_self.appendChild(new_html);

                    // Auto-expand
                    if (that.specialKeyPressed && !initially_expanded) {
                        expand_button.onclick();
                    }
                } else { // Assume entry
                    new_html = null;

                    escaped_title = $cms.filter.html((node.getAttribute('title') !== undefined) ? node.getAttribute('title') : '');
                    if (escaped_title == '') escaped_title = '{!NA_EM;^}';

                    var description = '';
                    var description_in_use = '';
                    if (node.getAttribute('description_html')) {
                        description = node.getAttribute('description_html');
                        description_in_use = $cms.filter.html(description);
                    } else {
                        if (node.getAttribute('description')) description = $cms.filter.html('. ' + node.getAttribute('description'));
                        description_in_use = escaped_title + ': {!TREE_LIST_SELECT*;^}' + description + ((node.getAttribute('serverid') == '') ? (' (' + $cms.filter.html(node.getAttribute('serverid')) + ')') : '');
                    }

                    // Render self
                    initially_expanded = false;
                    var img_url = $cms.img('{$IMG;,1x/treefield/entry}');
                    var img_url_2 = $cms.img('{$IMG;,2x/treefield/entry}');
                    if (node.getAttribute('img_url')) {
                        img_url = node.getAttribute('img_url');
                        img_url_2 = node.getAttribute('img_url_2');
                    }
                    $cms.dom.html(node_self, '<div><img alt="{!ENTRY;^}" src="' + $cms.filter.html(img_url) + '" srcset="' + $cms.filter.html(img_url_2) + ' 2x" style="width: 14px; height: 14px" /> ' +
                        '<label id="' + this.name + 'tsel_e_' + node.getAttribute('id') + '" class="ajax_tree_magic_button ' + colour + '" for="' + this.name + 'tsel_s_' + node.getAttribute('id') + '" data-mouseover-activate-tooltip="[\'' + (node.getAttribute('description_html') ? '' : (description_in_use.replace(/\n/g, '').replace(/'/g, '\\\''))) + '\', \'800px\']">' +
                        '<input' + (this.tabindex ? (' tabindex="' + this.tabindex + '"') : '') + ' id="' + this.name + 'tsel_s_' + node.getAttribute('id') + '" style="position: absolute; left: -10000px" type="radio" name="_' + this.name + '" value="1" />' + escaped_title + '</label>' + extra + '</div>');
                    var a = node_self.querySelector('label');
                    a.handleSelection = that.handleSelection;
                    a.firstElementChild.addEventListener('focus', function () {
                        this.parentNode.style.outline = '1px dotted';
                    });
                    a.firstElementChild.addEventListener('blur', function () {
                        this.parentNode.style.outline = '';
                    });
                    a.firstElementChild.addEventListener('click', a.handleSelection);
                    a.addEventListener('click', a.handleSelection); // Needed by Firefox, the radio button's onclick will not be called if shift/ctrl held
                    a.firstElementChild.object = that;
                    a.object = that;
                    a.addEventListener('mousedown', function (event) { // To disable selection of text when holding shift or control
                        if (event.ctrlKey || event.metaKey || event.shiftKey) {
                            if (event.cancelable) {
                                event.preventDefault();
                            }
                        }
                    });
                    html.appendChild(node_self_wrap);
                    var selected = ((that.use_server_id ? node.getAttribute('serverid') : node.getAttribute('id')) == element.value) || node.getAttribute('selected') == 'yes';
                    if ((that.multi_selection) && (!selected)) {
                        selected = ((',' + element.value + ',').indexOf(',' + node.getAttribute('id') + ',') != -1);
                    }
                    that.makeElementLookSelected($cms.dom.$id(that.name + 'tsel_e_' + node.getAttribute('id')), selected);
                }

                if ((node.getAttribute('draggable')) && (node.getAttribute('draggable') !== 'false')) {
                    master_html = $cms.dom.$id('tree_list__root_' + that.name);
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

                        this.classList.remove('being_dragged');

                        if (this.last_hit != null) {
                            this.last_hit.parentNode.parentNode.style.border = '0px';

                            if (this.parentNode.parentNode != this.last_hit) {
                                var xml_node = this.object.getElementByIdHack(this.querySelector('input').id.substr(7 + this.object.name.length));
                                var target_xml_node = this.object.getElementByIdHack(this.last_hit.id.substr(12 + this.object.name.length));

                                if ((this.last_hit.childNodes.length === 1) && (this.last_hit.childNodes[0].nodeName === '#text')) {
                                    $cms.dom.html(this.last_hit, '');
                                    this.object.renderTree(target_xml_node, this.last_hit);
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

                if ((node.getAttribute('droppable')) && (node.getAttribute('droppable') !== 'false')) {
                    node_self.ondragover = function (event) {
                        if (event.cancelable) {
                            event.preventDefault();
                        }
                    };
                    node_self.ondrop = function (event) {
                        if (event.cancelable) {
                            event.preventDefault();
                        }
                        // ondragend will call with last_hit set, we don't track the drop spots using this event handler, we track it in real time using mouse coordinate analysis
                    };
                }

                if (initially_expanded) {
                    that.renderTree(node, new_html, element);
                } else if (new_html) {
                    $cms.dom.appendHtml(new_html, '{!PLEASE_WAIT;^}');
                }
            });

            trigger_resize();

            return a;
        },

        handleTreeClick: function (event, automated) {// Not called as a method
            var element = $cms.dom.$id(this.object.name);
            if (element.disabled || this.object.busy) {
                return false;
            }

            this.object.busy = true;

            var clicked_id = this.getAttribute('id').substr(7 + this.object.name.length);

            var html_node = $cms.dom.$id(this.object.name + 'tree_list_c_' + clicked_id);
            var expand_button = $cms.dom.$id(this.object.name + 'texp_c_' + clicked_id);

            var expanding = (html_node.style.display != 'block');

            if (expanding) {
                var xml_node = this.object.getElementByIdHack(clicked_id, 'c');
                xml_node.setAttribute('expanded', 'true');
                var real_clicked_id = xml_node.getAttribute('serverid');
                if (typeof real_clicked_id !== 'string') {
                    real_clicked_id = clicked_id;
                }

                if ((xml_node.getAttribute('has_children') === 'true') && !xml_node.firstElementChild) {
                    var url = $cms.baseUrl(this.object.ajax_url + '&id=' + encodeUC(real_clicked_id) + '&options=' + this.object.options + '&default=' + encodeUC(element.value));
                    var ob = this.object;
                    do_ajax_request(url, function (ajax_result_frame, ajax_result) {
                        $cms.dom.html(html_node, '');
                        ob.response(ajax_result_frame, ajax_result, clicked_id);
                    });
                    $cms.dom.html(html_node, '<div aria-busy="true" class="vertical_alignment"><img src="' + $cms.img('{$IMG*;,loading}') + '" alt="" /> <span>{!LOADING;^}</span></div>');
                    var container = $cms.dom.$id('tree_list__root_' + ob.name);
                    if ((automated) && (container) && (container.style.overflowY == 'auto')) {
                        window.setTimeout(function () {
                            container.scrollTop = find_pos_y(html_node) - 20;
                        }, 0);
                    }
                }

                html_node.style.display = 'block';
                clear_transition_and_set_opacity(html_node, 0.0);
                fade_transition(html_node, 100, 30, 4);

                expand_button.src = $cms.img('{$IMG;,1x/treefield/collapse}');
                expand_button.srcset = $cms.img('{$IMG;,2x/treefield/collapse}') + ' 2x';
                expand_button.title = expand_button.title.replace('{!EXPAND;^}', '{!CONTRACT;^}');
                expand_button.alt = expand_button.alt.replace('{!EXPAND;^}', '{!CONTRACT;^}');
            } else {
                var xml_node = this.object.getElementByIdHack(clicked_id, 'c');
                xml_node.setAttribute('expanded', 'false');
                html_node.style.display = 'none';

                expand_button.src = $cms.img('{$IMG;,1x/treefield/expand}');
                expand_button.srcset = $cms.img('{$IMG;,2x/treefield/expand}') + ' 2x';
                expand_button.title = expand_button.title.replace('{!CONTRACT;^}', '{!EXPAND;^}');
                expand_button.alt = expand_button.alt.replace('{!CONTRACT;^}', '{!EXPAND;^}');
            }

            fixup_node_positions(this.object.name);

            trigger_resize();

            this.object.busy = false;

            return true;
        },

        handleSelection: function (event, assume_ctrl) {// Not called as a method
            assume_ctrl = !!assume_ctrl;

            var element = $cms.dom.$id(this.object.name);
            if (element.disabled) {
                return;
            }
            var i,
                selected_before = (element.value == '') ? [] : (this.object.multi_selection ? element.value.split(',') : [element.value]);

            cancel_bubbling(event);
            event.preventDefault();

            if (!assume_ctrl && event.shiftKey && this.object.multi_selection) {
                // We're holding down shift so we need to force selection of everything bounded between our last click spot and here
                var all_a = $cms.dom.$id('tree_list__root_' + this.object.name).getElementsByTagName('label');
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
                                    all_a[i].handleSelection(event, true);
                            } else {
                                if (selected_before.indexOf(that_selected_id) != -1)
                                    all_a[i].handleSelection(event, true);
                            }
                        }
                    }
                }

                return;
            }
            var type = this.getAttribute('id').charAt(5 + this.object.name.length);
            if (type === 'r') {
                type = 'c';
            } else if (type === 's') {
                type = 'e';
            }
            var real_selected_id = this.getAttribute('id').substr(7 + this.object.name.length),
                xml_node = this.object.getElementByIdHack(real_selected_id, type),
                selected_id = (this.object.use_server_id) ? xml_node.getAttribute('serverid') : real_selected_id;

            if (xml_node.getAttribute('selectable') == 'true' || this.object.all_nodes_selectable) {
                var selected_after = selected_before;
                for (i = 0; i < selected_before.length; i++) {
                    this.object.makeElementLookSelected($cms.dom.$id(this.object.name + 'tsel_' + type + '_' + selected_before[i]), false);
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
                    if (!this.object.multi_selection) {// This is a bit of a hack to make selection look nice, even though we aren't storing natural IDs of what is selected
                        var anchors = $cms.dom.$id('tree_list__root_' + this.object.name).getElementsByTagName('label');
                        for (i = 0; i < anchors.length; i++) {
                            this.object.makeElementLookSelected(anchors[i], false);
                        }
                        this.object.makeElementLookSelected($cms.dom.$id(this.object.name + 'tsel_' + type + '_' + real_selected_id), true);
                    }
                }
                for (i = 0; i < selected_after.length; i++) {
                    this.object.makeElementLookSelected($cms.dom.$id(this.object.name + 'tsel_' + type + '_' + selected_after[i]), true);
                }

                element.value = selected_after.join(',');
                element.selected_title = (selected_after.length == 1) ? xml_node.getAttribute('title') : element.value;
                element.selected_editlink = xml_node.getAttribute('edit');
                if (element.value == '') {
                    element.selected_title = '';
                }
                if (element.onchange) {
                    element.onchange();
                }
                if (element.fakeonchange !== undefined && element.fakeonchange) {
                    element.fakeonchange();
                }
            }

            if (!assume_ctrl) {
                this.object.last_clicked = this;
            }
        },

        makeElementLookSelected: function (target, selected) {
            if (!target) {
                return;
            }
            target.classList.toggle('native_ui_selected', !!selected);
            target.style.cursor = 'pointer';
        }
    });

    function attributes_full_fixup(xml) {
        var node, i,
            id = xml.getAttribute('id');

        window.attributes_full || (window.attributes_full = {});
        window.attributes_full[id] || (window.attributes_full[id] = {});

        for (i = 0; i < xml.attributes.length; i++) {
            window.attributes_full[id][xml.attributes[i].name] = xml.attributes[i].value;
        }
        for (i = 0; i < xml.children.length; i++) {
            node = xml.children[i];

            if ((node.localName === 'category') || (node.localName === 'entry')) {
                attributes_full_fixup(node);
            }
        }
    }

    function fixup_node_positions(name) {
        var html = $cms.dom.$('#tree_list__root_' + name);
        var to_fix = html.getElementsByTagName('div');
        var i;
        for (i = 0; i < to_fix.length; i++) {
            if (to_fix[i].style.position === 'absolute') {
                fix_up_node_position(to_fix[i]);
            }
        }
    }

    function fix_up_node_position(node_self) {
        node_self.style.left = find_pos_x(node_self.parentNode, true) + 'px';
        node_self.style.top = find_pos_y(node_self.parentNode, true) + 'px';
    }

    function find_overlapping_selectable(mouse_y, element, node, name) { // Find drop targets
        var i, childNode, temp, child_node_element, y, height;

        // Recursion
        if (node.getAttribute('expanded') !== 'false') {
            for (i = 0; i < node.children.length; i++) {
                childNode = node.children[i];
                temp = find_overlapping_selectable(mouse_y, element, childNode, name);
                if (temp) {
                    return temp;
                }
            }
        }

        if (node.getAttribute('droppable') == element.cms_draggable) {
            child_node_element = $cms.dom.$id(name + 'tree_list_' + ((node.localName === 'category') ? 'c' : 'e') + '_' + node.getAttribute('id'));
            y = find_pos_y(child_node_element.parentNode.parentNode, true);
            height = child_node_element.parentNode.parentNode.offsetHeight;
            if ((y < mouse_y) && (y + height > mouse_y)) {
                return child_node_element;
            }
        }

        return null;
    }

    window.generate_question_ui = generate_question_ui;
    window.do_ajax_request = do_ajax_request;
    window.set_cookie = set_cookie;
    window.read_cookie = read_cookie;
    window.get_csrf_token = get_csrf_token;
    window.get_session_id = get_session_id;

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

        if ((window.showModalDialog !== undefined) || $cms.$CONFIG_OPTION.js_overlays) {
            if (button_set.length > 4) {
                dialog_height += 5 * (button_set.length - 4);
            }

            // Intentionally FIND_SCRIPT and not FIND_SCRIPT_NOHTTP, because no needs-HTTPS security restriction applies to popups, yet popups do not know if they run on HTTPS if behind a transparent reverse proxy
            var url = maintain_theme_in_link('{$FIND_SCRIPT;,question_ui}?message=' + encodeUC(message) + '&image_set=' + encodeUC(image_set.join(',')) + '&button_set=' + encodeUC(button_set.join(',')) + '&window_title=' + encodeUC(window_title) + keep_stub());
            if (dialog_width === undefined) {
                dialog_width = 440;
            }
            if (dialog_height === undefined) {
                dialog_height = 180;
            }
            window.faux_showModalDialog(
                url,
                null,
                'dialogWidth=' + dialog_width + ';dialogHeight=' + dialog_height + ';status=no;unadorned=yes',
                function (result) {
                    if (result == null) {
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
            } else {
                message = fallback_message;
            }

            window.fauxmodal_prompt(
                message,
                '',
                function (result) {
                    if ((result === undefined) || (result === null)) {
                        callback(button_set[0]); // just pressed 'cancel', so assume option 0
                        return;
                    } else {
                        if (result == '') {
                            callback(button_set[1]); // just pressed 'ok', so assume option 1
                            return;
                        }
                        for (var i = 0; i < button_set.length; i++) {
                            if (result.toLowerCase() === button_set[i].toLowerCase()) {// match
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

    var ajaxInstances,
        ajaxCallbacks,
        networkDownAlerted = false;

    function do_ajax_request(url, callbackMethod, post) { // Note: 'post' is not an array, it's a string (a=b)
        var async = !!callbackMethod, index, result;

        if (!url.includes('://') && url.startsWith('/')) {
            url = window.location.protocol + '//' + window.location.host + url;
        }

        ajaxInstances || (ajaxInstances = []);
        ajaxCallbacks || (ajaxCallbacks = []);

        index = ajaxInstances.length;

        ajaxInstances[index] = new XMLHttpRequest();
        ajaxCallbacks[index] = callbackMethod;

        if (async) {
            ajaxInstances[index].onreadystatechange = readyStateChangeListener;
        }

        if (typeof post === 'string') {
            if (!post.includes('&csrf_token')) { // For CSRF prevention
                post += '&csrf_token=' + encodeUC(get_csrf_token());
            }

            ajaxInstances[index].open('POST', url, async);
            ajaxInstances[index].setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            ajaxInstances[index].send(post);
        } else {
            ajaxInstances[index].open('GET', url, async);
            ajaxInstances[index].send(null);
        }

        result = ajaxInstances[index];

        if (!async) {
            delete ajaxInstances[index];
        }

        return result;

        function readyStateChangeListener() {
            ajaxInstances || (ajaxInstances = []);
            ajaxCallbacks || (ajaxCallbacks = []);

            // Check if any ajax requests are complete
            ajaxInstances.forEach(function (xhr, i) {
                if (!xhr || (xhr.readyState !== 4)) { // 4 = DONE
                    return; // (continue)
                }

                delete ajaxInstances[i];

                var okStatusCodes = [200, 500, 400, 401];
                // If status is 'OK'
                if (xhr.status && okStatusCodes.includes(xhr.status)) {
                    // Process the result
                    if ((!xhr.responseXML/*Not payload handler and not stack trace*/ || !xhr.responseXML.firstChild)) {
                        return callAjaxMethod(ajaxCallbacks[i], xhr);
                    }

                    // XML result. Handle with a potentially complex call
                    var xml = (xhr.responseXML && xhr.responseXML.firstChild) ? xhr.responseXML : handleErrorsInResult(xhr);

                    if (xml) {
                        xml.validateOnParse = false;
                        processRequestChange(xml.documentElement || xml, i);
                    } else {
                        // Error parsing
                        return callAjaxMethod(ajaxCallbacks[i]);
                    }
                } else {
                    // HTTP error...
                    callAjaxMethod(ajaxCallbacks[i]);

                    try {
                        if ((xhr.status === 0) || (xhr.status > 10000)) { // implies site down, or network down
                            if (!networkDownAlerted && !window.unloaded) {
                                window.fauxmodal_alert('{!NETWORK_DOWN;^}');
                                networkDownAlerted = true;
                            }
                        } else {
                            $cms.error('do_ajax_request(): {!PROBLEM_RETRIEVING_XML;^}\n' + xhr.status + ': ' + xhr.statusText + '.', xhr);
                        }
                    } catch (e) {
                        $cms.error('do_ajax_request(): {!PROBLEM_RETRIEVING_XML;^}', e); // This is probably clicking back
                    }
                }
            });
        }

        function processRequestChange(ajaxResultFrame, i) {
            ajaxInstances || (ajaxInstances = []);
            ajaxCallbacks || (ajaxCallbacks = []);

            var method = null,
                methodEl = ajaxResultFrame.querySelector('method');

            if (methodEl || ajaxCallbacks[i]) {
                method = methodEl ? eval('return ' + merge_text_nodes(methodEl)) : ajaxCallbacks[i];
            }

            var messageEl = ajaxResultFrame.querySelector('message');
            if (messageEl) {
                // Either an error or a message was returned. :(
                var message = messageEl.firstChild.data;

                callAjaxMethod(method);

                if (ajaxResultFrame.querySelector('error')) {
                    // It's an error :|
                    window.fauxmodal_alert('An error (' + ajaxResultFrame.querySelector('error').firstChild.data + ') message was returned by the server: ' + message);
                    return;
                }

                window.fauxmodal_alert('An informational message was returned by the server: ' + message);
                return;
            }

            var ajaxResultEl = ajaxResultFrame.querySelector('result');
            if (!ajaxResultEl) {
                callAjaxMethod(method);
                return;
            }

            callAjaxMethod(ajaxResultFrame, ajaxResultEl);
        }

        function handleErrorsInResult(xhr) {
            // Try and parse again. Firefox can be weird.
            var xml;
            try {
                xml = (new DOMParser()).parseFromString(xhr.responseText, 'application/xml');
            } catch (ignore) {}

            if (xml) {
                return xml;
            }

            if (xhr.responseText && xhr.responseText.includes('<html')) {
                $cms.error('do_ajax_request(): ', xhr);
                fauxmodal_alert(xhr.responseText, null, '{!ERROR_OCCURRED;^}', true);
            }
        }

        function callAjaxMethod(method, ajaxResultFrame, ajaxResult) {
            if (Array.isArray(method)) {
                if (ajaxResultFrame != null) {
                    method = (method[0] !== undefined) ? method[0] : null;
                } else {
                    method = (method[1] !== undefined) ? method[1] : null;
                }
            } else if (ajaxResultFrame == null)  {
                // No failure method given, so don't call
                method = null;
            }

            if (method != null) {
                if (method.response !== undefined) {
                    method.response(ajaxResultFrame, ajaxResult);
                } else if (typeof method === 'function') {
                    method(ajaxResultFrame, ajaxResult);
                }
            }
        }
    }

    function get_csrf_token() {
        return read_cookie($cms.$SESSION_COOKIE_NAME); // Session also works as a CSRF-token, as client-side knows it (AJAX)
    }

    function get_session_id() {
        return read_cookie($cms.$SESSION_COOKIE_NAME);
    }

    $cms.topicReply = topicReply;
    /* Reply to a topic using AJAX */
    function topicReply(el, isThreaded, id, replyingToUsername, replyingToPost, replyingToPostPlain, isExplicitQuote) {
        isThreaded = !!isThreaded;
        isExplicitQuote = !!isExplicitQuote;

        var form = $cms.dom.$('form#comments_form');

        var parent_id_field;
        if (form.elements.parent_id === undefined) {
            parent_id_field = document.createElement('input');
            parent_id_field.type = 'hidden';
            parent_id_field.name = 'parent_id';
            form.appendChild(parent_id_field);
        } else {
            parent_id_field = form.elements['parent_id'];
            if (window.last_reply_to !== undefined) {
                clear_transition_and_set_opacity(window.last_reply_to, 1.0);
            }
        }
        window.last_reply_to = el;
        parent_id_field.value = isThreaded ? id : '';

        el.classList.add('activated_quote_button');

        var post = form.elements.post;

        smooth_scroll(find_pos_y(form, true));

        var outer = $cms.dom.$('#comments_posting_form_outer');
        if (outer && $cms.dom.notDisplayed(outer)) {
            $cms.toggleableTray(outer);
        }

        if (isThreaded) {
            post.value = $cms.format('{!QUOTED_REPLY_MESSAGE;^}', replyingToUsername, replyingToPostPlain);
            post.strip_on_focus = post.value;
            post.classList.add('field_input_non_filled');
        } else {
            if ((post.strip_on_focus !== undefined) && (post.value == post.strip_on_focus)) {
                post.value = '';
            } else if (post.value != '') {
                post.value += '\n\n';
            }

            post.focus();
            post.value += '[quote="' + replyingToUsername + '"]\n' + replyingToPost + '\n[snapback]' + id + '[/snapback][/quote]\n\n';

            if (!isExplicitQuote) {
                post.default_substring_to_strip = post.value;
            }
        }

        manage_scroll_height(post);
        post.scrollTop = post.scrollHeight;
    }



}(window.$cms, JSON.parse(document.getElementById('composr-symbol-data').content)));

function noop() {}

(function () {
    window.undo_staff_unload_action = undo_staff_unload_action;
    window.check_field_for_blankness = check_field_for_blankness;
    window.manage_scroll_height = manage_scroll_height;
    window.get_main_cms_window = get_main_cms_window;
    window.magic_keypress = magic_keypress;
    window.escape_comcode = escape_comcode;
    window.create_rollover = create_rollover;
    window.browser_matches = browser_matches;
    window.confirm_session = confirm_session;

    // Serves as a flag to indicate any new errors are probably due to us transitioning
    window.unloaded = !!window.unloaded;
    window.addEventListener('beforeunload', function () {
        window.unloaded = true;
    });

    function undo_staff_unload_action() {
        var pre = document.body.querySelectorAll('.unload_action');
        for (var i = 0; i < pre.length; i++) {
            pre[i].parentNode.removeChild(pre[i]);
        }
        var bi = $cms.dom.$id('main_website_inner');
        if (bi) {
            clear_transition(bi);
            bi.classList.remove('site_unloading');
        }
    }

    /* Very simple form control flow */
    function check_field_for_blankness(field, event) {
        if (!field) {
            // Shame we need this, seems on Google Chrome things can get confused on JS assigned to page-changing events
            return true;
        }

        var value = field.value,
            errorEl = $cms.dom.$('#error_' + field.id);

        if ((value.trim() === '') || (value === '****') || (value === '{!POST_WARNING;^}') || (value === '{!THREADED_REPLY_NOTICE;^,{!POST_WARNING}}')) {
            if (errorEl !== null) {
                errorEl.style.display = 'block';
                $cms.dom.html(errorEl, '{!REQUIRED_NOT_FILLED_IN;^}');
            }

            window.fauxmodal_alert('{!IMPROPERLY_FILLED_IN;^}');
            return false;
        }

        if (errorEl != null) {
            errorEl.style.display = 'none';
        }

        return true;
    }

    /* Making the height of a textarea match its contents */
    function manage_scroll_height(textAreaEl) {
        var scrollHeight = textAreaEl.scrollHeight,
            offsetHeight = textAreaEl.offsetHeight,
            currentHeight = parseInt($cms.dom.css(textAreaEl, 'height')) || 0;

        if ((scrollHeight > 5) && (currentHeight < scrollHeight) && (offsetHeight < scrollHeight)) {
            $cms.dom.css(textAreaEl, {
                height: scrollHeight + 'px',
                boxSizing: 'border-box',
                overflowY: 'hidden'
            });
            trigger_resize();
        }
    }

    /* Find the main Composr window */
    function get_main_cms_window(any_large_ok) {
        any_large_ok = !!any_large_ok;

        if ($cms.dom.$('#main_website')) {
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

    /* Find if the user performed the Composr "magic keypress" to initiate some action */
    function magic_keypress(event) {
        // Cmd+Shift works on Mac - cannot hold down control or alt in Mac firefox at least
        var count = 0;
        if (event.shiftKey) {
            count++;
        }
        if (event.ctrlKey) {
            count++;
        }
        if (event.metaKey) {
            count++;
        }
        if (event.altKey) {
            count++;
        }

        return count >= 2;
    }

    /* Data escaping */
    function escape_comcode(value) {
        value = strVal(value);
        if (!value) {
            return '';
        }
        return value.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
    }

    /* Image rollover effects */
    function create_rollover(rand, rollover) {
        var img = rand && $cms.dom.$id(rand);
        if (!img) {
            return;
        }
        new Image().src = rollover; // precache

        $cms.dom.on(img, 'mouseover', activate);
        $cms.dom.on(img, 'click mouseout', deactivate);

        function activate() {
            img.old_src = img.getAttribute('src');
            if (img.origsrc !== undefined) {
                img.old_src = img.origsrc;
            }
            img.setAttribute('src', rollover);
        }

        function deactivate() {
            img.setAttribute('src', img.old_src);
        }
    }

    /* Browser sniffing */
    /**
     * @param {string} code
     * @returns {boolean}
     */
    function browser_matches(code) {
        var browser = navigator.userAgent.toLowerCase(),
            os = navigator.platform.toLowerCase() + ' ' + browser;

        var is_safari = browser.includes('applewebkit'),
            is_chrome = browser.includes('chrome/'),
            is_gecko = browser.includes('gecko') && !is_safari,
            _is_ie = browser.includes('msie') || browser.includes('trident') || browser.includes('edge/'),
            is_ie_8 = browser.includes('msie 8') && (_is_ie),
            is_ie_8_plus = is_ie_8,
            is_ie_9 = browser.includes('msie 9') && (_is_ie),
            is_ie_9_plus = is_ie_9 && !is_ie_8;

        switch (code) {
            case 'simplified_attachments_ui':
                return !is_ie_8 && !is_ie_9 && $cms.$CONFIG_OPTION.simplified_attachments_ui && $cms.$CONFIG_OPTION.complex_uploader;
            case 'non_concurrent':
                return browser.includes('iphone') || browser.includes('ipad') || browser.includes('android') || browser.includes('phone') || browser.includes('tablet');
            case 'ios':
                return browser.includes('iphone') || browser.includes('ipad');
            case 'android':
                return browser.includes('android');
            case 'wysiwyg':
                return $cms.$CONFIG_OPTION.wysiwyg;
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

    /* Enforcing a session using AJAX */
    function confirm_session(callback) {
        var url = '{$FIND_SCRIPT_NOHTTP;,confirm_session}' + keep_stub(true);

        do_ajax_request(url, function (ret) {
            if (!ret) {
                return;
            }

            if (ret.responseText === '') {// Blank means success, no error - so we can call callback
                callback(true);
                return;
            }

            // But non blank tells us the username, and there is an implication that no session is confirmed for this login
            if (ret.responseText === '{!GUEST;^}') {// Hmm, actually whole login was lost, so we need to ask for username too
                window.fauxmodal_prompt(
                    '{!USERNAME;^}',
                    '',
                    function (promptt) {
                        _confirm_session(callback, promptt, url);
                    },
                    '{!_LOGIN;^}'
                );
                return;
            }

            _confirm_session(callback, ret.responseText, url);
        });

        function _confirm_session(callback, username, url) {
            window.fauxmodal_prompt(
                $cms.$CONFIG_OPTION.js_overlays ? '{!ENTER_PASSWORD_JS_2;^}' : '{!ENTER_PASSWORD_JS;^}',
                '',
                function (promptt) {
                    if (promptt !== null) {
                        do_ajax_request(url, function (ret) {
                            if (ret && ret.responseText === '') {// Blank means success, no error - so we can call callback
                                callback(true);
                            } else {
                                _confirm_session(callback, username, url); // Recurse
                            }
                        }, 'login_username=' + encodeUC(username) + '&password=' + encodeUC(promptt));
                    } else {
                        callback(false);
                    }
                },
                '{!_LOGIN;^}',
                'password'
            );
        }
    }
}());


/* Dynamic inclusion */
function load_snippet(snippet_hook, post, callback) {
    if (!window.location) { // In middle of page navigation away
        return null;
    }

    var title = $cms.dom.html(document.querySelector('title')).replace(/ \u2013 .*/, ''),
        metas = document.getElementsByTagName('link'), i,
        url = window.location.href;

    for (i = 0; i < metas.length; i++) {
        if (metas[i].getAttribute('rel') === 'canonical') {
            url = metas[i].getAttribute('href');
        }
    }
    if (!url) {
        url = window.location.href;
    }
    var url2 = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=' + snippet_hook + '&url=' + encodeURIComponent(url) + '&title=' + encodeURIComponent(title) + keep_stub(),
        html = do_ajax_request(maintain_theme_in_link(url2), callback, post);
    if (callback) {
        return null;
    }
    return html.responseText;
}

/* Tabs */
function find_url_tab(hash) {
    if (hash === undefined) {
        hash = window.location.hash;
    }

    if (hash.replace(/^#/, '') !== '') {
        var tab = hash.replace(/^#/, '').replace(/^tab\_\_/, '');

        if ($cms.dom.$('#g_' + tab)) {
            select_tab('g', tab);
        }
        else if ((tab.indexOf('__') != -1) && ($cms.dom.$id('g_' + tab.substr(0, tab.indexOf('__'))))) {
            var old = hash;
            select_tab('g', tab.substr(0, tab.indexOf('__')));
            window.location.hash = old;
        }
    }
}
function select_tab(id, tab, from_url, automated) {
    from_url = !!from_url;
    automated = !!automated;

    if (!from_url) {
        var tab_marker = $cms.dom.$('#tab__' + tab.toLowerCase());
        if (tab_marker) {
            // For URL purposes, we will change URL to point to tab
            // HOWEVER, we do not want to cause a scroll so we will be careful
            tab_marker.id = '';
            window.location.hash = '#tab__' + tab.toLowerCase();
            tab_marker.id = 'tab__' + tab.toLowerCase();
        }
    }

    var tabs = [], i, element;

    element = $cms.dom.$('#t_' + tab);
    for (i = 0; i < element.parentNode.children.length; i++) {
        if (element.parentNode.children[i].id && (element.parentNode.children[i].id.substr(0, 2) === 't_')) {
            tabs.push(element.parentNode.children[i].id.substr(2));
        }
    }

    for (i = 0; i < tabs.length; i++) {
        element = $cms.dom.$('#' + id + '_' + tabs[i]);
        if (element) {
            element.style.display = (tabs[i] === tab) ? 'block' : 'none';

            if (tabs[i] === tab) {
                if (window['load_tab__' + tab] === undefined) {
                    clear_transition_and_set_opacity(element, 0.0);
                    fade_transition(element, 100, 30, 8);
                }
            }
        }

        element = $cms.dom.$('#t_' + tabs[i]);
        if (element) {
            element.classList.toggle('tab_active', tabs[i] === tab);
        }
    }

    if (window['load_tab__' + tab] !== undefined) {
        // Usually an AJAX loader
        window['load_tab__' + tab](automated, $cms.dom.$('#' + id + '_' + tab));
    }

    return false;
}

function matches_theme_image(src, url) {
    return $cms.img(src) === $cms.img(url);
}

/* Animate the loading of a frame */
function animate_frame_load(pf, frame, leave_gap_top, leave_height) {
    if (!pf) {
        return;
    }

    leave_gap_top = +leave_gap_top || 0;
    leave_height = !!leave_height;

    if (!leave_height) {
        // Enough to stop jumping around
        pf.style.height = window.top.get_window_height() + 'px';
    }

    illustrate_frame_load(frame);

    var ifuob = window.top.$cms.dom.$('#iframe_under');
    var extra = ifuob ? ((window != window.top) ? find_pos_y(ifuob) : 0) : 0;
    if (ifuob) {
        ifuob.scrolling = 'no';
    }

    if (window === window.top) {
        window.top.smooth_scroll(find_pos_y(pf) + extra - leave_gap_top);
    }
}

function illustrate_frame_load(iframeId) {
    var head, cssText = '', i, iframe = $cms.dom.$id(iframeId), doc, de;

    if (!$cms.$CONFIG_OPTION.enable_animations || !iframe || !iframe.contentDocument || !iframe.contentDocument.documentElement) {
        return;
    }

    iframe.style.height = '80px';

    try {
        doc = iframe.contentDocument;
        de = doc.documentElement;
    }
    catch (e) {
        // May be connection interference somehow
        iframe.scrolling = 'auto';
        return;
    }

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
                        if (rules[j].cssText) {
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

    doc.body.classList.add('website_body', 'main_website_faux');

    if (!de.querySelector('style')) {// The conditional is needed for Firefox - for some odd reason it is unable to parse any head tags twice
        $cms.dom.html(doc.head, head);
    }

    $cms.dom.html(doc.body, '<div aria-busy="true" class="spaced"><div class="ajax_loading"><img id="loading_image" class="vertical_alignment" src="' + $cms.img('{$IMG_INLINE*;,loading}') + '" alt="{!LOADING;^}" /> <span class="vertical_alignment">{!LOADING;^}<\/span><\/div><\/div>');

    // Stupid workaround for Google Chrome not loading an image on unload even if in cache
    setTimeout(function () {
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
    if (!$cms.$CONFIG_OPTION.enable_animations) {
        try {
            window.scrollTo(0, dest_y);
        } catch (ignore) {}
        return;
    }

    var scroll_y = window.pageYOffset;
    if (typeof dest_y === 'string') {
        dest_y = find_pos_y($cms.dom.$id(dest_y), true);
    }
    if (dest_y < 0) {
        dest_y = 0;
    }
    if ((expected_scroll_y != null) && (expected_scroll_y != scroll_y)) {
        // We must terminate, as the user has scrolled during our animation and we do not want to interfere with their action -- or because our last scroll failed, due to us being on the last scroll screen already
        return;
    }

    dir = (dest_y > scroll_y) ? 1 : -1;

    var distance_to_go = (dest_y - scroll_y) * dir;
    var dist = Math.round(dir * (distance_to_go / 25));

    if (dir == -1 && dist > -25) {
        dist = -25;
    }
    if (dir == 1 && dist < 25) {
        dist = 25;
    }

    if (((dir == 1) && (scroll_y + dist >= dest_y)) || ((dir == -1) && (scroll_y + dist <= dest_y)) || (distance_to_go > 2000)) {
        try {
            window.scrollTo(0, dest_y);
        } catch (e) {
        }
        if (event_after) {
            event_after();
        }
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

/* Dimension functions */
function register_mouse_listener(e) {
    register_mouse_listener = noop; // ensure this function is only executed once

    if (e) {
        window.mouse_x = get_mouse_x(e);
        window.mouse_y = get_mouse_y(e);
    }

    document.documentElement.addEventListener('mousemove', function (event) {
        window.mouse_x = get_mouse_x(event);
        window.mouse_y = get_mouse_y(event);
    });

    function get_mouse_x(event) {
        try {
            if (event.pageX) {
                return event.pageX;
            } else if (event.clientX) {
                return event.clientX + window.pageXOffset;
            }
        } catch (ignore) {}

        return 0;
    }

    function get_mouse_y(event) {
        try {
            if (event.pageY) {
                return event.pageY;
            } else if (event.clientY) {
                return event.clientY + window.pageYOffset
            }
        } catch (ignore) {
        }

        return 0;
    }
}

function get_window_width(win) {
    return (win || window).innerWidth - 18;
}

function get_window_height(win) {
    return (win || window).innerHeight - 18;
}

function get_window_scroll_width(win) {
    return (win || window).document.body.scrollWidth;
}

function get_window_scroll_height(win) {
    win || (win = window);

    var rect_a = win.document.body.parentElement.getBoundingClientRect(),
        rect_b = win.document.body.getBoundingClientRect(),
        a = (rect_a.bottom - rect_a.top),
        b = (rect_b.bottom - rect_b.top);

    return (a > b) ? a : b;
}

function find_pos_x(el, not_relative) {/* if not_relative is true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree */
    not_relative = !!not_relative;

    var left = el.getBoundingClientRect().left + window.pageXOffset;

    if (!not_relative) {
        var position;
        while (el) {
            if ($cms.dom.isCss(el, 'position', ['absolute', 'relative', 'fixed'])) {
                left -= find_pos_x(el, true);
                break;
            }
            el = el.parentElement;
        }
    }

    return left;
}

function find_pos_y(el, not_relative) {/* if not_relative is true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree */
    not_relative = !!not_relative;

    var top = el.getBoundingClientRect().top + window.pageYOffset;

    if (!not_relative) {
        var position;
        while (el) {
            if ($cms.dom.isCss(el, 'position', ['absolute', 'relative', 'fixed'])) {
                top -= find_pos_y(el, true);
                break;
            }
            el = el.parentElement;
        }
    }
    return top;
}

(function (){
    'use strict';

    window.modsecurity_workaround = modsecurity_workaround;
    window.modsecurity_workaround_ajax = modsecurity_workaround_ajax;

    function modsecurity_workaround(form) {
        var temp_form = document.createElement('form');
        temp_form.method = 'post';

        if (form.target) {
            temp_form.target = form.target;
        }
        temp_form.action = form.action;

        var data = $cms.dom.serialize(form);
        data = _modsecurity_workaround(data);

        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = '_data';
        input.value = data;
        temp_form.appendChild(input);

        if (form.elements.csrf_token) {
            var csrf_input = document.createElement('input');
            csrf_input.type = 'hidden';
            csrf_input.name = 'csrf_token';
            csrf_input.value = form.elements.csrf_token.value;
            temp_form.appendChild(csrf_input);
        }

        temp_form.style.display = 'none';
        document.body.appendChild(temp_form);

        window.setTimeout(function () {
            temp_form.submit();
            temp_form.parentNode.removeChild(temp_form);
        });

        return false;
    }

    function modsecurity_workaround_ajax(data) {
        return '_data=' + encodeUC(_modsecurity_workaround(data));
    }

    function _modsecurity_workaround(data) {
        data = strVal(data);

        var remapper = {
                '\\': '<',
                '/': '>',
                '<': '\'',
                '>': '"',
                '\'': '/',
                '"': '\\',
                '%': '&',
                '&': '%',
                '@': ':',
                ':': '@'
            },
            out = '',
            char;
        for (var i = 0; i < data.length; i++) {
            char = data[i];
            if (remapper[char] !== undefined) {
                out += remapper[char];
            } else {
                out += char;
            }
        }
        return out;
    }
}());


function clear_out_tooltips(tooltip_being_opened) {
    // Delete other tooltips, which due to browser bugs can get stuck
    var selector = '.tooltip';
    if (tooltip_being_opened) {
        selector += ':not(#' + tooltip_being_opened + ')';
    }
    $cms.dom.$$(selector).forEach(function (el) {
        deactivate_tooltip(el.ac, el);
    });
}

$cms.ready.then(function () {
    // Tooltips close on browser resize
    $cms.dom.on(window, 'resize', function () {
        clear_out_tooltips();
    });
});

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
function activate_tooltip(el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, have_links) {
    event || (event = {});
    width || (width = 'auto');
    pic || (pic = '');
    height || (height = 'auto');
    bottom = !!bottom;
    no_delay = !!no_delay;
    lights_off = !!lights_off;
    force_width = !!force_width;
    win || (win = window);
    have_links = !!have_links;

    if (!window.page_loaded || !tooltip) {
        return;
    }

    if (window.is_doing_a_drag) {
        // Don't want tooltips appearing when doing a drag and drop operation
        return;
    }

    if (!have_links && $cms.isTouchEnabled) {
        return; // Too erratic
    }

    register_mouse_listener(event);

    clear_out_tooltips(el.tooltip_id);

    // Add in move/leave events if needed
    if (!have_links) {
        el.addEventListener('mouseout', function () {
            win.deactivate_tooltip(el);
        });

        el.addEventListener('mousemove', function () {
            win.reposition_tooltip(el, event, false, false, null, false, win);
        });
    } else {
        el.addEventListener('click', function () {
            win.deactivate_tooltip(el);
        });
    }

    if (typeof tooltip === 'function') {
        tooltip = tooltip();
    }

    tooltip = strVal(tooltip);

    if (!tooltip) {
        return;
    }

    el.is_over = true;
    el.tooltip_on = false;
    el.initial_width = width;
    el.have_links = have_links;

    var children = el.querySelectorAll('img');
    for (var i = 0; i < children.length; i++) {
        children[i].setAttribute('title', '');
    }

    var tooltipEl;
    if ((el.tooltip_id !== undefined) && ($cms.dom.$id(el.tooltip_id))) {
        tooltipEl = win.$cms.dom.$('#' + el.tooltip_id);
        tooltipEl.style.display = 'none';
        $cms.dom.html(tooltipEl, '');
        window.setTimeout(function () {
            reposition_tooltip(el, event, bottom, true, tooltipEl, force_width);
        }, 0);
    } else {
        tooltipEl = win.document.createElement('div');
        tooltipEl.role = 'tooltip';
        tooltipEl.style.display = 'none';
        var rt_pos = tooltip.indexOf('results_table');
        tooltipEl.className = 'tooltip ' + ((rt_pos == -1 || rt_pos > 100) ? 'tooltip_ownlayout' : 'tooltip_nolayout') + ' boxless_space' + (have_links ? ' have_links' : '');
        if (el.className.substr(0, 3) === 'tt_') {
            tooltipEl.className += ' ' + el.className;
        }
        if (tooltip.length < 50) {  // Only break words on long tooltips. Otherwise it messes with alignment.
            tooltipEl.style.wordWrap = 'normal';
        }

        if (force_width) {
            tooltipEl.style.width = width;
        } else {
            if (width === 'auto') {
                var new_auto_width = get_window_width(win) - 30 - window.mouse_x;
                if (new_auto_width < 150) new_auto_width = 150; // For tiny widths, better let it slide to left instead, which it will as this will force it to not fit
                tooltipEl.style.maxWidth = new_auto_width + 'px';
            } else {
                tooltipEl.style.maxWidth = width;
            }
            tooltipEl.style.width = 'auto'; // Needed for Opera, else it uses maxWidth for width too
        }
        if (height && (height !== 'auto')) {
            tooltipEl.style.maxHeight = height;
            tooltipEl.style.overflow = 'auto';
        }
        tooltipEl.style.position = 'absolute';
        tooltipEl.id = 't_' + $cms.random();
        el.tooltip_id = tooltipEl.id;
        reposition_tooltip(el, event, bottom, true, tooltipEl, force_width);
        document.body.appendChild(tooltipEl);
    }
    tooltipEl.ac = el;

    if (pic) {
        var img = win.document.createElement('img');
        img.src = pic;
        img.className = 'tooltip_img';
        if (lights_off) {
            img.classList.add('faded_tooltip_img');
        }
        tooltipEl.appendChild(img);
        tooltipEl.classList.add('tooltip_with_img');
    }

    var event_copy = { // Needs to be copied as it will get erased on IE after this function ends
        'pageX': +event.pageX || 0,
        'pageY': +event.pageY || 0,
        'clientX': +event.clientX || 0,
        'clientY': +event.clientY || 0,
        'type': event.type || ''
    };

    // This allows turning off tooltips by pressing anywhere, on iPhone (and probably Android etc). The clickability of body forces the simulated onmouseout events to fire.
    var bi = $cms.dom.$('#main_website_inner') || document.body;
    if ((window.TouchEvent !== undefined) && !bi.onmouseover) {
        bi.onmouseover = function () {
            return true;
        };
    }

    window.setTimeout(function () {
        if (!el.is_over) {
            return;
        }

        if ((!el.tooltip_on) || (tooltipEl.childNodes.length === 0)) // Some other tooltip jumped in and wiped out tooltip on a delayed-show yet never triggers due to losing focus during that delay
            $cms.dom.appendHtml(tooltipEl, tooltip);

        el.tooltip_on = true;
        tooltipEl.style.display = 'block';
        if (tooltipEl.style.width == 'auto')
            tooltipEl.style.width = ($cms.dom.contentWidth(tooltipEl) + 1/*for rounding issues from em*/) + 'px'; // Fix it, to stop the browser retroactively reflowing ambiguous layer widths on mouse movement

        if (!no_delay) {
            // If delayed we will sub in what the currently known global mouse coordinate is
            event_copy.pageX = win.mouse_x;
            event_copy.pageY = win.mouse_y;
        }

        reposition_tooltip(el, event_copy, bottom, true, tooltipEl, force_width, win);
    }, no_delay ? 0 : 666);
}
function reposition_tooltip(el, event, bottom, starting, tooltip_element, force_width, win) {
    bottom = !!bottom;
    win || (win = window);

    if (!starting) {// Real JS mousemove event, so we assume not a screen reader and have to remove natural tooltip

        if (el.getAttribute('title')) {
            el.setAttribute('title', '');
        }

        if ((el.parentElement.localName === 'a') && (el.parentElement.getAttribute('title')) && ((el.localName === 'abbr') || (el.parentElement.getAttribute('title').includes('{!LINK_NEW_WINDOW;^}')))) {
            el.parentElement.setAttribute('title', '');  // Do not want second tooltips that are not useful
        }
    }

    if (!window.page_loaded) {
        return;
    }

    if (!el.tooltip_id) {
        if (el.onmouseover) {
            el.onmouseover(event);
        }
        return;
    }  // Should not happen but written as a fail-safe

    tooltip_element || (tooltip_element = $cms.dom.$id(el.tooltip_id));

    if (!tooltip_element) {
        return;
    }

    var style__offset_x = 9,
        style__offset_y = (el.have_links) ? 18 : 9,
        x, y;

    // Find mouse position
    x = window.mouse_x;
    y = window.mouse_y;
    x += style__offset_x;
    y += style__offset_y;
    try {
        if (event.type) {
            if (event.type != 'focus') {
                el.done_none_focus = true;
            }

            if ((event.type === 'focus') && (el.done_none_focus)) {
                return;
            }

            x = (event.type === 'focus') ? (win.pageXOffset + get_window_width(win) / 2) : (window.mouse_x + style__offset_x);
            y = (event.type === 'focus') ? (win.pageYOffset + get_window_height(win) / 2 - 40) : (window.mouse_y + style__offset_y);
        }
    } catch (ignore) {
    }
    // Maybe mouse position actually needs to be in parent document?
    try {
        if (event.target && (event.target.ownerDocument !== win.document)) {
            x = win.mouse_x + style__offset_x;
            y = win.mouse_y + style__offset_y;
        }
    } catch (ignore) {
    }

    // Work out which direction to render in
    var width = $cms.dom.contentWidth(tooltip_element);
    if (tooltip_element.style.width === 'auto') {
        if (width < 200) {
            // Give some breathing room, as might already have painfully-wrapped when it found there was not much space
            width = 200;
        }
    }
    var height = tooltip_element.offsetHeight;
    var x_excess = x - get_window_width(win) - win.pageXOffset + width + 10/*magic tolerance factor*/;
    if (x_excess > 0) {// Either we explicitly gave too much width, or the width auto-calculated exceeds what we THINK is the maximum width in which case we have to re-compensate with an extra contingency to stop CSS/JS vicious disagreement cycles
        var x_before = x;
        x -= x_excess + 20 + style__offset_x;
        if (x < 100) { // Do not make it impossible to de-focus the tooltip
            x = (x_before < 100) ? x_before : 100;
        }
    }
    if (x < 0) {
        x = 0;
    }
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

function deactivate_tooltip(el, tooltip_element) {
    el.is_over = false;

    if (el.tooltip_id == null) {
        return;
    }

    tooltip_element || (tooltip_element = $cms.dom.$('#' + el.tooltip_id));

    if (tooltip_element) {
        $cms.dom.hide(tooltip_element);
    }
}

/* Automatic resizing to make frames seamless. Composr calls this automatically. Make sure id&name attributes are defined on your iframes! */
function resize_frame(name, min_height) {
    min_height = +min_height || 0;

    var frame_element = $cms.dom.$id(name),
        frame_window;

    if (window.frames[name] !== undefined) {
        frame_window = window.frames[name];
    } else if (window.parent && window.parent.frames[name]) {
        frame_window = window.parent.frames[name];
    } else {
        return;
    }

    if ((frame_element) && (frame_window) && (frame_window.document) && (frame_window.document.body)) {
        var h = get_window_scroll_height(frame_window);

        if ((h === 0) && (frame_element.parentElement.style.display === 'none')) {
            h = min_height ? min_height : 100;

            if (frame_window.parent) {
                window.setTimeout(function () {
                    if (frame_window.parent) {
                        frame_window.parent.trigger_resize();
                    }
                });
            }
        }

        if (h + 'px' != frame_element.style.height) {
            if ((frame_element.scrolling !== 'auto' && frame_element.scrolling !== 'yes') || (frame_element.style.height == '0px')) {
                frame_element.style.height = ((h >= min_height) ? h : min_height) + 'px';
                if (frame_window.parent) {
                    window.setTimeout(function () {
                        if (frame_window.parent) frame_window.parent.trigger_resize();
                    });
                }
                frame_element.scrolling = 'no';
                frame_window.onscroll = function (event) {
                    if (event == null) {
                        return false;
                    }
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
    if (!window.parent || !window.parent.document) {
        return;
    }
    var i, iframes = window.parent.document.querySelectorAll('iframe');

    and_subframes = !!and_subframes;

    for (i = 0; i < iframes.length; i++) {
        if ((iframes[i].src === window.location.href) || (iframes[i].contentWindow === window) || ((iframes[i].id != '') && (window.parent.frames[iframes[i].id] !== undefined) && (window.parent.frames[iframes[i].id] == window))) {
            if (iframes[i].style.height === '900px') {
                iframes[i].style.height = 'auto';
            }
            window.parent.resize_frame(iframes[i].name);
        }
    }

    if (and_subframes) {
        iframes = document.querySelectorAll('iframe');
        for (i = 0; i < iframes.length; i++) {
            if ((iframes[i].name != '') && ((iframes[i].classList.contains('expandable_iframe')) || (iframes[i].classList.contains('dynamic_iframe')))) {
                resize_frame(iframes[i].name);
            }
        }
    }
}

/* Marking things (to avoid illegally nested forms) */
function add_form_marked_posts(form, prefix) {
    prefix = strVal(prefix);

    var get = form.method.toLowerCase() === 'get',
        i;

    if (get) {
        for (i = 0; i < form.elements.length; i++) {
            if ((new RegExp('&' + prefix + '\d+=1$', 'g')).test(form.elements[i].name)) {
                form.elements[i].parentNode.removeChild(form.elements[i]);
            }
        }
    } else {
        // Strip old marks out of the URL
        form.action = form.action.replace('?', '&')
            .replace(new RegExp('&' + prefix + '\d+=1$', 'g'), '')
            .replace('&', '?'); // will just do first due to how JS works
    }

    var checkboxes = $cms.dom.$$('input[type="checkbox"][name^="' + prefix + '"]:checked'),
        append = '';

    for (i = 0; i < checkboxes.length; i++) {
        append += (((append === '') && !form.action.includes('?') && !form.action.includes('/pg/') && !get) ? '?' : '&') + checkboxes[i].name + '=1';
    }

    if (get) {
        var bits = append.split('&');
        for (i = 0; i < bits.length; i++) {
            if (bits[i] !== '') {
                $cms.dom.append(form, $cms.dom.create('input', {
                    name: bits[i].substr(0, bits[i].indexOf('=1')),
                    type: 'hidden',
                    value: '1'
                }));
            }
        }
    } else {
        form.action += append;
    }

    return append !== '';
}

/* Event listeners */

function cancel_bubbling(event) {
    return !!(event && event.target && event.stopPropagation && (event.stopPropagation() === undefined));
}

/* Update a URL to maintain the current theme into it */
function maintain_theme_in_link(url) {
    var usp = $cms.uspFromUrl(url),
        theme = encodeUC($cms.$THEME);

    if (usp.keys().next().done) {
        // `url` doesn't have a query string
        return url + '?utheme=' + theme;
    } else if (!usp.has('utheme') && !usp.has('keep_theme')) {
        return url + '&utheme=' + theme;
    }

    return url;
}

/* Get URL stub to propagate keep_* parameters */
function keep_stub(starting) {// `starting` set to true means "Put a '?' for the first parameter"
    var keep = $cms.uspKeepSession.toString();

    if (!keep) {
        return '';
    }

    return (starting ? '?' : '&') + keep;
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
function ga_track(el, category, action) {
    if (!$cms.$CONFIG_OPTION.google_analytics || $cms.$IS_STAFF || $cms.$IS_ADMIN) {
        return;
    }

    if (category === undefined) {
        category = '{!URL;^}';
    }

    if (action === undefined) {
        action = el ? el.href : '{!UNKNOWN;^}';
    }

    try {
        window.ga('send', 'event', category, action);
    } catch (ignore) {}

    if (el) {
        setTimeout(function () {
            $cms.navigate(el);
        }, 100);

        return false;
    }
}

/* Set it up so a form field is known and can be monitored for changes */
function set_up_change_monitor(container) {
    var firstInp = $cms.dom.$(container, 'input, select, textarea');

    if (!firstInp || firstInp.id.includes('choose_')) {
        return;
    }

    $cms.dom.on(container, 'blur change', function () {
        container.classList.toggle('filledin', find_if_children_set(container));
    });
}


function find_if_children_set(container) {
    var value, blank = true, el,
        elements = $cms.dom.$$(container, 'input, select, textarea');

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
    $cms.requireJavascript('sound').then(function () {
        window.soundManager.setup({
            url: $cms.baseUrl('data'),
            debugMode: false,
            onready: function () {
                var sound_object = window.soundManager.createSound({url: ob.href});
                if (sound_object) {
                    sound_object.play();
                }
            }
        });
    });
}

((function () {
    window.fade_transition = fade_transition;
    window.has_fade_transition = has_fade_transition;
    window.clear_transition = clear_transition;
    window.clear_transition_and_set_opacity = clear_transition_and_set_opacity;

    // <{element's uid}, {setTimeout id}>
    var timeouts = {};

    function fade_transition(el, destPercentOpacity, periodInMsecs, increment, destroyAfter) {
        if (!$cms.isEl(el)) {
            return;
        }

        destPercentOpacity = +destPercentOpacity || 0;
        periodInMsecs = +periodInMsecs || 0;
        increment = +increment || 0;
        destroyAfter = !!destroyAfter;

        if (!$cms.$CONFIG_OPTION.enable_animations) {
            el.style.opacity = destPercentOpacity / 100.0;
            return;
        }

        clear_transition(el);

        var again, newIncrement;

        if (el.style.opacity) {
            var diff = (destPercentOpacity / 100.0) - el.style.opacity,
                direction = 1;

            if (increment > 0) {
                if (el.style.opacity > (destPercentOpacity / 100.0)) {
                    direction = -1;
                }
                newIncrement = Math.min(direction * diff, increment / 100.0);
            } else {
                if (el.style.opacity < (destPercentOpacity / 100.0)) {
                    direction = -1;
                }
                newIncrement = Math.max(direction * diff, increment / 100.0);
            }

            var temp = parseFloat(el.style.opacity) + (direction * newIncrement);

            if (temp < 0.0) {
                temp = 0.0;
            } else if (temp > 1.0) {
                temp = 1.0;
            }

            el.style.opacity = temp;
            again = (Math.round(temp * 100) !== Math.round(destPercentOpacity));
        } else {
            // Opacity not set yet, need to call back in an event timer
            again = true;
        }

        if (again) {
            timeouts[$cms.uid(el)] = window.setTimeout(function () {
                fade_transition(el, destPercentOpacity, periodInMsecs, increment, destroyAfter);
            }, periodInMsecs);
        } else if (destroyAfter && el.parentNode) {
            clear_transition(el);
            el.parentNode.removeChild(el);
        }
    }

    function has_fade_transition(el) {
        return $cms.isEl(el) && ($cms.uid(el) in timeouts);
    }

    function clear_transition(el) {
        var uid = $cms.isEl(el) && $cms.uid(el);

        if (uid && timeouts[uid]) {
            try { // Cross-frame issues may cause error
                window.clearTimeout(timeouts[uid]);
            } catch (ignore) {}
            delete timeouts[uid];
        }
    }

    /* Set opacity, without interfering with the thumbnail timer */
    function clear_transition_and_set_opacity(el, fraction) {
        clear_transition(el);
        el.style.opacity = fraction;
    }
})());

/*

 This code does a lot of stuff relating to overlays...

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


function _open_image_into_lightbox(initial_img_url, description, x, n, has_full_button, is_video) {
    has_full_button = !!has_full_button;
    is_video = !!is_video;

    // Set up overlay for Lightbox
    var lightbox_code = /** @lang HTML */' \
			<div style="text-align: center"> \
				<p class="ajax_loading" id="lightbox_image"><img src="' + $cms.img('{$IMG*;,loading}') + '" /></p> \
				<p id="lightbox_meta" style="display: none" class="associated_link associated_links_block_group"> \
					<span id="lightbox_description">' + description + '</span> \
					' + ((n === null) ? '' : ('<span id="lightbox_position_in_set"><span id="lightbox_position_in_set_x">' + x + '</span> / <span id="lightbox_position_in_set_n">' + n + '</span></span>')) + ' \
					' + (is_video ? '' : ('<span id="lightbox_full_link"><a href="' + $cms.filter.html(initial_img_url) + '" target="_blank" title="{$STRIP_TAGS;^,{!SEE_FULL_IMAGE}} {!LINK_NEW_WINDOW;^}">{!SEE_FULL_IMAGE;^}</a></span>')) + ' \
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
        },
        modal = $cms.openModalWindow(my_lightbox);

    // Load proper image
    window.setTimeout(function () { // Defer execution until the HTML was parsed
        if (is_video) {
            var video = document.createElement('video');
            video.id = 'lightbox_image';
            video.className = 'lightbox_image';
            video.controls = 'controls';
            video.autoplay = 'autoplay';
            $cms.dom.html(video, initial_img_url);
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
    });

    return modal;
}

function _resize_lightbox_dimensions_img(modal, img, has_full_button, is_video) {
    if (!modal.boxWrapperEl) {
        /* Overlay closed already */
        return;
    }

    var real_width = is_video ? img.videoWidth : img.width,
        width = real_width,
        real_height = is_video ? img.videoHeight : img.height,
        height = real_height,
        lightbox_image = modal.top_window.$cms.dom.$id('lightbox_image'),
        lightbox_meta = modal.top_window.$cms.dom.$id('lightbox_meta'),
        lightbox_description = modal.top_window.$cms.dom.$id('lightbox_description'),
        lightbox_position_in_set = modal.top_window.$cms.dom.$id('lightbox_position_in_set'),
        lightbox_full_link = modal.top_window.$cms.dom.$id('lightbox_full_link');

    var sup = lightbox_image.parentNode;
    sup.removeChild(lightbox_image);
    if (sup.firstChild) {
        sup.insertBefore(img, sup.firstChild);
    } else {
        sup.appendChild(img);
    }
    sup.className = '';
    sup.style.textAlign = 'center';
    sup.style.overflow = 'hidden';

    dims_func();
    $cms.dom.on(window, 'resize', dims_func);

    function dims_func() {
        lightbox_description.style.display = (lightbox_description.firstChild) ? 'inline' : 'none';
        if (lightbox_full_link) {
            var showLightboxFullLink = !!(!is_video && has_full_button && ((real_width > max_width) || (real_height > max_height)));
            $cms.dom.toggle(lightbox_full_link, showLightboxFullLink);
        }
        var showLightboxMeta = !!((lightbox_description.style.display === 'inline') || (lightbox_position_in_set !== null) || (lightbox_full_link && lightbox_full_link.style.display === 'inline'));
        $cms.dom.toggle(lightbox_meta, showLightboxMeta);

        // Might need to rescale using some maths, if natural size is too big
        var max_dims = _get_max_lightbox_img_dims(modal, has_full_button),
            max_width = max_dims[0],
            max_height = max_dims[1];

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
        });

        if (img.parentElement) {
            img.parentElement.parentElement.parentElement.style.width = 'auto';
            img.parentElement.parentElement.parentElement.style.height = 'auto';
        }

        function _get_max_lightbox_img_dims(modal, has_full_button) {
            var max_width = modal.top_window.get_window_width() - 20;
            var max_height = modal.top_window.get_window_height() - 60;
            if (has_full_button) {
                max_height -= 120;
            }
            return [max_width, max_height];
        }
    }
}


function fauxmodal_confirm(question, callback, title, unescaped) {
    title || (title = '{!Q_SURE;^}');
    unescaped = !!unescaped;

    if (!$cms.$CONFIG_OPTION.js_overlays) {
        callback(window.confirm(question));
        return;
    }

    var my_confirm = {
        type: 'confirm',
        text: unescaped ? question : $cms.filter.html(question).replace(/\n/g, '<br />'),
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
    $cms.openModalWindow(my_confirm);
}

function fauxmodal_alert(notice, callback, title, unescaped) {
    notice = strVal(notice);
    callback || (callback = noop);
    title = strVal(title) || '{!MESSAGE;^}';
    unescaped = !!unescaped;

    if (!$cms.$CONFIG_OPTION.js_overlays) {
        window.alert(notice);
        callback();
        return;
    }

    var myAlert = {
        type: 'alert',
        text: unescaped ? notice : $cms.filter.html(notice).replace(/\n/g, '<br />'),
        yes_button: '{!INPUTSYSTEM_OK;^}',
        width: '600',
        yes: callback,
        title: title,
        cancel_button: null
    };

    $cms.openModalWindow(myAlert);
}

function fauxmodal_prompt(question, defaultValue, callback, title, input_type) {
    if (!$cms.$CONFIG_OPTION.js_overlays) {
        callback(window.prompt(question, defaultValue));
        return;
    }

    var myPrompt = {
        type: 'prompt',
        text: $cms.filter.html(question).replace(/\n/g, '<br />'),
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
        myPrompt.input_type = input_type;
    }
    $cms.openModalWindow(myPrompt);
}

function faux_showModalDialog(url, name, options, callback, target, cancel_text) {
    callback = callback || noop;

    if (!($cms.$CONFIG_OPTION.js_overlays)) {
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

    if (url.includes(window.location.host)) {
        url += (!url.includes('?') ? '?' : '&') + 'overlay=1';
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
    $cms.openModalWindow(my_frame);
}

function faux_open(url, name, options, target, cancel_text) {
    if (cancel_text === undefined) {
        cancel_text = '{!INPUTSYSTEM_CANCEL;^}';
    }

    if (!$cms.$CONFIG_OPTION.js_overlays) {
        options = options.replace('height=auto', 'height=520');
        window.open(url, name, options);
        return;
    }

    faux_showModalDialog(url, name, options, null, target, cancel_text);
}

(function () {
    /*
     Faux frames and faux scrolling
     */

    window.infinite_scrolling_block = infinite_scrolling_block;
    window.infinite_scrolling_block_hold = infinite_scrolling_block_hold;
    window.infinite_scrolling_block_unhold = infinite_scrolling_block_unhold;
    window.internalise_infinite_scrolling = internalise_infinite_scrolling;
    window.internalise_infinite_scrolling_go = internalise_infinite_scrolling_go;
    window.internalise_ajax_block_wrapper_links = internalise_ajax_block_wrapper_links;


    var infinite_scroll_pending = false, // Blocked due to queued HTTP request
        infinite_scroll_blocked = false, // Blocked due to event tracking active
        infinite_scroll_mouse_held = false;

    function infinite_scrolling_block(event) {
        if (event.keyCode === 35) {// 'End' key pressed, so stop the expand happening for a few seconds while the browser scrolls down
            infinite_scroll_blocked = true;
            window.setTimeout(function () {
                infinite_scroll_blocked = false;
            }, 3000);
        }
    }

    function infinite_scrolling_block_hold() {
        if (!infinite_scroll_blocked) {
            infinite_scroll_blocked = true;
            infinite_scroll_mouse_held = true;
        }
    }
    function infinite_scrolling_block_unhold(infinite_scrolling) {
        if (infinite_scroll_mouse_held) {
            infinite_scroll_blocked = false;
            infinite_scroll_mouse_held = false;
            infinite_scrolling();
        }
    }
    function internalise_infinite_scrolling(url_stem, wrapper) {
        if (infinite_scroll_blocked || infinite_scroll_pending) {
            // Already waiting for a result
            return false;
        }

        var _pagination = wrapper.querySelectorAll('.pagination');

        if (_pagination.length === 0) {
            return false;
        }

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
                $cms.dom.html(load_more_link_a, '{!LOAD_MORE;^}');
                load_more_link_a.href = '#!';
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
            } else {// Find links from an already-hidden pagination

                more_links = pagination.getElementsByTagName('a');
                if (more_links.length != 0) {
                    break;
                }
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
            if (pagination_load_more.length > 0) {
                pagination_load_more[0].parentNode.removeChild(pagination_load_more[0]);
            }

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
        if (infinite_scroll_pending) {
            return false;
        }

        var wrapper_inner = $cms.dom.$id(wrapper.id + '_inner');
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
                    infinite_scroll_pending = true;

                    return call_block(url_stem + url_stub, '', wrapper_inner, true, function () {
                        infinite_scroll_pending = false;
                        internalise_infinite_scrolling(url_stem, wrapper);
                    });
                }
            }
        }

        return false;
    }

    function internalise_ajax_block_wrapper_links(url_stem, block_element, look_for, extra_params, append, forms_too, scroll_to_top) {
        look_for || (look_for = []);
        extra_params || (extra_params = []);
        append = !!append;
        forms_too = !!forms_too;
        scroll_to_top = (scroll_to_top !== undefined) ? !!scroll_to_top : true;

        var block_pos_y = find_pos_y(block_element, true);
        if (block_pos_y > window.pageYOffset) {
            scroll_to_top = false;
        }

        var _link_wrappers = block_element.querySelectorAll('.ajax_block_wrapper_links');
        if (_link_wrappers.length === 0) {
            _link_wrappers = [block_element];
        }
        var links = [];
        for (var i = 0; i < _link_wrappers.length; i++) {
            var _links = _link_wrappers[i].getElementsByTagName('a');

            for (var j = 0; j < _links.length; j++) {
                links.push(_links[j]);
            }

            if (forms_too) {
                _links = _link_wrappers[i].getElementsByTagName('form');

                for (var j = 0; j < _links.length; j++) {
                    links.push(_links[j]);
                }

                if (_link_wrappers[i].localName === 'form') {
                    links.push(_link_wrappers[i]);
                }
            }
        }

        links.forEach(function (link) {
            if (!link.target || (link.target !== '_self') || (link.href && link.href.startsWith('#'))) {
                return; // (continue)
            }

            if (link.localName === 'a') {
                $cms.dom.on(link, 'click', submit_func);
            } else {
                $cms.dom.on(link, 'submit', submit_func);
            }
        });

        function submit_func() {
            var url_stub = '', j;

            var href = (this.localName === 'a') ? this.href : this.action;

            // Any parameters matching a pattern must be sent in the URL to the AJAX block call
            for (j = 0; j < look_for.length; j++) {
                var matches = href.match(new RegExp('[&\?](' + look_for[j] + ')=([^&]*)'));
                if (matches) {
                    url_stub += (url_stem.indexOf('?') === -1) ? '?' : '&';
                    url_stub += matches[1] + '=' + matches[2];
                }
            }
            for (j in extra_params) {
                url_stub += (url_stem.indexOf('?') === -1) ? '?' : '&';
                url_stub += j + '=' + encodeUC(extra_params[j]);
            }

            // Any POST parameters?
            var post_params = null, param;
            if (this.localName === 'form') {
                post_params = '';
                for (j = 0; j < this.elements.length; j++) {
                    if (this.elements[j].name) {
                        param = this.elements[j].name + '=' + encodeUC(clever_find_value(this, this.elements[j]));

                        if ((!this.method) || (this.method.toLowerCase() !== 'get')) {
                            if (post_params != '') post_params += '&';
                            post_params += param;
                        } else {
                            url_stub += (url_stem.indexOf('?') == -1) ? '?' : '&';
                            url_stub += param;
                        }
                    }
                }
            }

            if (window.history && window.history.pushState) {
                try {
                    window.has_js_state = true;
                    window.history.pushState({js: true}, document.title, href.replace('&ajax=1', '').replace(/&zone=[{$URL_CONTENT_REGEXP_JS}]+/, ''));
                } catch (ignore) {
                    // Exception could have occurred due to cross-origin error (e.g. "Failed to execute 'pushState' on 'History':
                    // A history state object with URL 'https://xxx' cannot be created in a document with origin 'http://xxx'")
                }
            }

            clear_out_tooltips();

            // Make AJAX block call
            return call_block(url_stem + url_stub, '', block_element, append, function () {
                if (scroll_to_top) {
                    window.scrollTo(0, block_pos_y);
                }
            }, false, post_params);
        }
    }
}());

(function () {
    window.call_block = call_block;

    var _blockDataCache = {};
    // This function will load a block, with options for parameter changes, and render the results in specified way - with optional callback support
    function call_block(url, new_block_params, target_div, append, callback, scroll_to_top_of_wrapper, post_params, inner, show_loading_animation) {
        scroll_to_top_of_wrapper = !!scroll_to_top_of_wrapper;
        post_params = (post_params !== undefined) ? post_params : null;
        inner = !!inner;
        show_loading_animation = (show_loading_animation !== undefined) ? !!show_loading_animation : true;
        if ((_blockDataCache[url] === undefined) && (new_block_params != '')) {
            // Cache start position. For this to be useful we must be smart enough to pass blank new_block_params if returning to fresh state
            _blockDataCache[url] = $cms.dom.html(target_div);
        }

        var ajax_url = url;
        if (new_block_params != '') {
            ajax_url += '&block_map_sup=' + encodeUC(new_block_params);
        }

        ajax_url += '&utheme=' + $cms.$THEME;
        if ((_blockDataCache[ajax_url] !== undefined) && post_params == null) {
            // Show results from cache
            show_block_html(_blockDataCache[ajax_url], target_div, append, inner);
            if (callback) {
                callback();
            }
            return false;
        }

        // Show loading animation
        var loading_wrapper = target_div;
        if ((loading_wrapper.id.indexOf('carousel_') === -1) && ($cms.dom.html(loading_wrapper).indexOf('ajax_loading_block') === -1) && (show_loading_animation)) {
            var raw_ajax_grow_spot = target_div.querySelectorAll('.raw_ajax_grow_spot');

            if (raw_ajax_grow_spot[0] !== undefined && append) {
                // If we actually are embedding new results a bit deeper
                loading_wrapper = raw_ajax_grow_spot[0];
            }

            var loading_wrapper_inner = document.createElement('div');
            if (!$cms.dom.isCss(loading_wrapper, 'position', ['relative', 'absolute'])) {
                if (append) {
                    loading_wrapper_inner.style.position = 'relative';
                } else {
                    loading_wrapper.style.position = 'relative';
                    loading_wrapper.style.overflow = 'hidden'; // Stops margin collapsing weirdness
                }
            }

            var loading_image = $cms.dom.create('img', {
                class: 'ajax_loading_block',
                src: $cms.img('{$IMG;,loading}'),
                css: {
                    position: 'absolute',
                    zIndex: 1000,
                    left: (target_div.offsetWidth / 2 - 10) + 'px'
                }
            });
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
        _blockDataCache[ajax_url] = new_html;

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
            } catch (e) {}
        }

        // Defined callback
        if (callback) {
            callback();
        }
    }

    function show_block_html(new_html, target_div, append, inner) {
        var raw_ajax_grow_spot = target_div.querySelectorAll('.raw_ajax_grow_spot');
        if (raw_ajax_grow_spot[0] !== undefined && append) target_div = raw_ajax_grow_spot[0]; // If we actually are embedding new results a bit deeper
        if (append) {
            $cms.dom.appendHtml(target_div, new_html);
        } else {
            if (inner) {
                $cms.dom.html(target_div, new_html);
            } else {
                $cms.dom.outerHtml(target_div, new_html);
            }
        }
    }


    /*
     Validation
     */

    window.do_ajax_field_test = do_ajax_field_test;
    window.merge_text_nodes = merge_text_nodes;
    window.update_ajax_search_list = update_ajax_search_list;
    window.update_ajax_member_list = update_ajax_member_list;

    /* Calls up a URL to check something, giving any 'feedback' as an error (or if just 'false' then returning false with no message) */
    function do_ajax_field_test(url, post) {
        var xhr = do_ajax_request(url, null, post);
        if ((xhr.responseText != '') && (xhr.responseText.replace(/[ \t\n\r]/g, '') != '0'/*some cache layers may change blank to zero*/)) {
            if (xhr.responseText !== 'false') {
                if (xhr.responseText.length > 1000) {
                    $cms.log('do_ajax_field_test()', 'xhr.responseText:', xhr.responseText);
                    window.fauxmodal_alert(xhr.responseText, null, '{!ERROR_OCCURRED;^}', true);
                } else {
                    window.fauxmodal_alert(xhr.responseText);
                }
            }
            return false;
        }
        return true;
    }

    function merge_text_nodes(childNodes) {
        var i, text = '';
        for (i = 0; i < childNodes.length; i++) {
            if (childNodes[i].nodeName === '#text') {
                text += childNodes[i].data;
            }
        }
        return text;
    }

    function update_ajax_search_list(target, e, search_type) {
        var special = 'search';
        search_type = strVal(search_type);
        if (search_type) {
            special += '&search_type=' + encodeURIComponent(search_type);
        }
        update_ajax_member_list(target, special, false, e);
    }

    var currentlyDoingListTimer = 0,
        currentListForEl = null;

    function update_ajax_member_list(target, special, delayed, event) {
        if ((event && $cms.dom.keyPressed(event, 'Enter')) || target.disabled) {
            return;
        }

        if (!browser_matches('ios') && !target.onblur) {
            target.onblur = function () {
                setTimeout(function () {
                    close_down_ajax_list();
                }, 300);
            }
        }

        if (!delayed) {// A delay, so as not to throw out too many requests
            if (currentlyDoingListTimer) {
                window.clearTimeout(currentlyDoingListTimer);
            }
            var e_copy = { 'keyCode': event.keyCode, 'which': event.which };

            currentlyDoingListTimer = window.setTimeout(function () {
                update_ajax_member_list(target, special, true, e_copy);
            }, 400);
            return;
        } else {
            currentlyDoingListTimer = 0;
        }

        target.special = special;

        var v = target.value;

        currentListForEl = target;
        var script = '{$FIND_SCRIPT_NOHTTP;,namelike}?id=' + encodeURIComponent(v);
        if (special) {
            script = script + '&special=' + special;
        }

        do_ajax_request(script + keep_stub(), update_ajax_member_list_response);

        function close_down_ajax_list() {
            var current = $cms.dom.$('#ajax_list');
            if (current) {
                current.parentNode.removeChild(current);
            }
        }

        function update_ajax_member_list_response(result, list_contents) {
            if (!list_contents || !currentListForEl) {
                return;
            }

            close_down_ajax_list();

            var isDataList = false;//(document.createElement('datalist').options!==undefined);	Still too buggy in browsers

            //if (list_contents.childNodes.length==0) return;
            var list = document.createElement(isDataList ? 'datalist' : 'select');
            list.className = 'people_list';
            list.setAttribute('id', 'ajax_list');
            if (isDataList) {
                currentListForEl.setAttribute('list', 'ajax_list');
            } else {
                if (list_contents.childNodes.length == 1) {// We need to make sure it is not a dropdown. Normally we'd use size (multiple isn't correct, but we'll try this for 1 as it may be more stable on some browsers with no side effects)
                    list.setAttribute('multiple', 'multiple');
                } else {
                    list.setAttribute('size', list_contents.childNodes.length + 1);
                }
                list.style.position = 'absolute';
                list.style.left = (find_pos_x(currentListForEl)) + 'px';
                list.style.top = (find_pos_y(currentListForEl) + currentListForEl.offsetHeight) + 'px';
            }
            setTimeout(function () {
                list.style.zIndex++;
            }, 100); // Fixes Opera by causing a refresh

            if (list_contents.children.length === 0) {
                return;
            }

            var i, item, displaytext;
            for (i = 0; i < list_contents.children.length; i++) {
                item = document.createElement('option');
                item.value = list_contents.children[i].getAttribute('value');
                displaytext = item.value;
                if (list_contents.children[i].getAttribute('displayname') != '')
                    displaytext = list_contents.children[i].getAttribute('displayname');
                item.text = displaytext;
                item.textContent = displaytext;
                list.appendChild(item);
            }
            item = document.createElement('option');
            item.disabled = true;
            item.text = '{!javascript:SUGGESTIONS_ONLY;^}'.toUpperCase();
            item.textContent = '{!javascript:SUGGESTIONS_ONLY;^}'.toUpperCase();
            list.appendChild(item);
            currentListForEl.parentNode.appendChild(list);

            if (isDataList) {
                return;
            }

            clear_transition_and_set_opacity(list, 0.0);
            fade_transition(list, 100, 30, 8);

            var current_list_for_copy = currentListForEl;

            if (currentListForEl.old_onkeyup === undefined) {
                currentListForEl.old_onkeyup = currentListForEl.onkeyup;
            }

            if (currentListForEl.old_onchange === undefined) {
                currentListForEl.old_onchange = currentListForEl.onchange;
            }

            currentListForEl.down_once = false;

            currentListForEl.onkeyup = function (event) {
                var ret = handle_arrow_usage(event);
                if (ret != null) {
                    return ret;
                }
                return update_ajax_member_list(current_list_for_copy, current_list_for_copy.special, false, event);
            };
            currentListForEl.onchange = function (event) {
                current_list_for_copy.onkeyup = current_list_for_copy.old_onkeyup;
                current_list_for_copy.onchange = current_list_for_copy.old_onchange;
                if (current_list_for_copy.onchange) {
                    current_list_for_copy.onchange(event);
                }
            };
            list.onkeyup = function (event) {
                var ret = handle_arrow_usage(event);
                if (ret != null) {
                    return ret;
                }

                if ($cms.dom.keyPressed(event, 'Enter')) {// ENTER
                    make_selection(event);
                    current_list_for_copy.disabled = true;
                    window.setTimeout(function () {
                        current_list_for_copy.disabled = false;
                    }, 200);

                    return cancel_bubbling(event);
                }
                if (!event.shiftKey && $cms.dom.keyPressed(event, ['ArrowUp', 'ArrowDown'])) {
                    if (event.cancelable) {
                        event.preventDefault();
                    }
                    return cancel_bubbling(event);
                }
                return null;
            };

            currentListForEl.onkeypress = function (event) {
                if (!event.shiftKey && $cms.dom.keyPressed(event, ['ArrowUp', 'ArrowDown'])) {
                    if (event.cancelable) {
                        event.preventDefault();
                    }
                    return cancel_bubbling(event);
                }
                return null;
            };
            list.onkeypress = function (event) {
                if (!event.shiftKey && $cms.dom.keyPressed(event, ['Enter', 'ArrowUp', 'ArrowDown'])) {
                    if (event.cancelable) {
                        event.preventDefault();
                    }
                    return cancel_bubbling(event);
                }
                return null;
            };

            list.addEventListener(browser_matches('ios') ? 'change' : 'click', make_selection, false);

            currentListForEl = null;

            function handle_arrow_usage(event) {
                if (!event.shiftKey && $cms.dom.keyPressed(event, 'ArrowDown')) {// DOWN
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

                if (!event.shiftKey && $cms.dom.keyPressed(event, 'ArrowUp')) {// UP
                    current_list_for_copy.disabled = true;
                    window.setTimeout(function () {
                        current_list_for_copy.disabled = false;
                    }, 1000);

                    var temp = current_list_for_copy.onblur;
                    current_list_for_copy.onblur = function () {};
                    list.focus();
                    current_list_for_copy.onblur = temp;
                    if (!current_list_for_copy.down_once) {
                        current_list_for_copy.down_once = true;
                        list.selectedIndex = 0;
                    } else {
                        if (list.selectedIndex > 0) {
                            list.selectedIndex--;
                        }
                    }
                    list.options[list.selectedIndex].selected = true;
                    return cancel_bubbling(event);
                }
                return null;
            }

            function make_selection(e) {
                var el = e.target;

                current_list_for_copy.value = el.value;
                current_list_for_copy.onkeyup = current_list_for_copy.old_onkeyup;
                current_list_for_copy.onchange = current_list_for_copy.old_onchange;
                current_list_for_copy.onkeypress = function () {
                };
                if (current_list_for_copy.onrealchange) {
                    current_list_for_copy.onrealchange(e);
                }
                if (current_list_for_copy.onchange) {
                    current_list_for_copy.onchange(e);
                }
                var al = $cms.dom.$id('ajax_list');
                al.parentNode.removeChild(al);
                window.setTimeout(function () {
                    current_list_for_copy.focus();
                }, 300);
            }
        }
    }
}());


(function (){
    /* Validation code and other general code relating to forms */
    'use strict';

    window.radio_value = radio_value;
    window.set_field_error = set_field_error;
    window.do_form_submit = do_form_submit;
    window.do_form_preview = do_form_preview;
    window.is_wysiwyg_field = is_wysiwyg_field;
    window.clever_find_value = clever_find_value;
    window.check_form = check_form;
    window.set_locked = set_locked;
    window.set_required = set_required;
    window.disable_preview_scripts = disable_preview_scripts;

    function radio_value(radios) {
        for (var i = 0; i < radios.length; i++) {
            if (radios[i].checked) {
                return radios[i].value;
            }
        }
        return '';
    }

    function set_field_error(the_element, error_msg) {
        if (the_element.name !== undefined) {
            var id = the_element.name;
            var errormsg_element = get_errormsg_element(id);
            if ((error_msg == '') && (id.indexOf('_hour') != -1) || (id.indexOf('_minute') != -1)) return; // Do not blank out as day/month/year (which comes first) would have already done it
            if (errormsg_element) {
                // Make error message visible, if there's an error
                errormsg_element.style.display = (error_msg == '') ? 'none' : 'block';

                // Changed error message
                if ($cms.dom.html(errormsg_element) != $cms.filter.html(error_msg)) {
                    $cms.dom.html(errormsg_element, '');
                    if (error_msg != '') // If there actually an error
                    {
                        the_element.setAttribute('aria-invalid', 'true');

                        // Need to switch tab?
                        var p = errormsg_element;
                        while (p !== null) {
                            p = p.parentNode;
                            if ((error_msg.substr(0, 5) != '{!DISABLED_FORM_FIELD;^}'.substr(0, 5)) && (p) && (p.getAttribute !== undefined) && (p.getAttribute('id')) && (p.getAttribute('id').substr(0, 2) == 'g_') && (p.style.display == 'none')) {
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
        if ((window.is_wysiwyg_field !== undefined) && (is_wysiwyg_field(the_element))) {
            the_element = the_element.parentNode;
        }

        the_element.classList.remove('input_erroneous');

        if (error_msg != '') {
            the_element.classList.add('input_erroneous');
        }

        function get_errormsg_element(id) {
            var errormsg_element = $cms.dom.$('#error_' + id);
            if (!errormsg_element) {
                errormsg_element = $cms.dom.$('#error_' + id.replace(/\_day$/, '').replace(/\_month$/, '').replace(/\_year$/, '').replace(/\_hour$/, '').replace(/\_minute$/, ''));
            }
            return errormsg_element;
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

        $cms.ui.disableSubmitAndPreviewButtons();

        if (window.detect_interval !== undefined) {
            window.clearInterval(window.detect_interval);
            delete window.detect_interval;
        }

        return true;
    }

    function do_form_preview(event, form, preview_url, has_separate_preview) {
        has_separate_preview = !!has_separate_preview;

        if (!$cms.dom.$id('preview_iframe')) {
            fauxmodal_alert('{!ADBLOCKER;^}');
            return false;
        }

        preview_url += ((window.mobile_version_for_preview === undefined) ? '' : ('&keep_mobile=' + (window.mobile_version_for_preview ? '1' : '0')));

        var old_action = form.getAttribute('action');

        if (!form.old_action) {
            form.old_action = old_action;
        }
        form.setAttribute('action', /*maintain_theme_in_link - no, we want correct theme images to work*/(preview_url) + ((form.old_action.indexOf('&uploading=1') != -1) ? '&uploading=1' : ''));
        var old_target = form.getAttribute('target');
        if (!old_target) {
            old_target = '_top';
        }
        /* not _self due to edit screen being a frame itself */
        if (!form.old_target) {
            form.old_target = old_target;
        }
        form.setAttribute('target', 'preview_iframe');

        if ((window.check_form) && (!check_form(form, true))) {
            return false;
        }

        if (form.onsubmit) {
            var test = form.onsubmit.call(form, event, true);
            if (!test) {
                return false;
            }
        }

        if ((has_separate_preview) || (window.has_separate_preview)) {
            form.setAttribute('action', form.old_action + ((form.old_action.indexOf('?') == -1) ? '?' : '&') + 'preview=1');
            return true;
        }

        $cms.dom.$id('submit_button').style.display = 'inline';

        /* Do our loading-animation */
        if (!window.just_checking_requirements) {
            window.setInterval(window.trigger_resize, 500);
            /* In case its running in an iframe itself */
            illustrate_frame_load('preview_iframe');
        }

        $cms.ui.disableSubmitAndPreviewButtons();

        // Turn main post editing back off
        if (window.wysiwyg_set_readonly !== undefined) {
            wysiwyg_set_readonly('post', true);
        }

        return true;
    }

    function is_wysiwyg_field(the_element) {
        var id = the_element.id;
        return window.wysiwyg_editors && (typeof window.wysiwyg_editors === 'object') && (typeof window.wysiwyg_editors[id] === 'object');
    }

    function clever_find_value(form, element) {
        if ((element.length !== undefined) && (element.nodeName === undefined)) {
            // Radio button
            element = element[0];
        }

        var value;
        switch (element.localName) {
            case 'textarea':
                value = (window.get_textbox === undefined) ? element.value : get_textbox(element);
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
                        if ((value == '') && (element.getAttribute('size') > 1)) {
                            value = '-1';  // Fudge, as we have selected something explicitly that is blank
                        }
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
                            if ((form.elements[i].name == element.name) && (form.elements[i].checked)) {
                                value = form.elements[i].value;
                            }
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

    function check_form(the_form, for_preview) {
        var delete_element = $cms.dom.$('#delete');
        if ((!for_preview) && (delete_element != null) && (((delete_element.classList[0] == 'input_radio') && (delete_element.value != '0')) || (delete_element.classList[0] == 'input_tick')) && (delete_element.checked)) {
            return true;
        }

        var j, the_element, erroneous = false, total_file_size = 0, alerted = false, error_element = null, check_result;
        for (j = 0; j < the_form.elements.length; j++) {
            if (!the_form.elements[j]) {
                continue;
            }

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
                                var e = $cms.dom.$id(the_element.id.replace(/\_(day|month|year)$/, '_day'));
                                if (e != the_element) {
                                    e.onblur(event, true);
                                }
                                var e = $cms.dom.$id(the_element.id.replace(/\_(day|month|year)$/, '_month'));
                                if (e != the_element) {
                                    e.onblur(event, true);
                                }
                                var e = $cms.dom.$id(the_element.id.replace(/\_(day|month|year)$/, '_year'));
                                if (e != the_element) {
                                    e.onblur(event, true);
                                }
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
            var delete_e = $cms.dom.$id('delete');
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

        function check_field(the_element, the_form) {
            var i, the_class, required, my_value, erroneous = false, error_msg = '', regexp, total_file_size = 0, alerted = false;

            // No checking for hidden elements
            if (((the_element.type === 'hidden') || (((the_element.style.display == 'none') || (the_element.parentNode.style.display == 'none') || (the_element.parentNode.parentNode.style.display == 'none') || (the_element.parentNode.parentNode.parentNode.style.display == 'none')) && ((window.is_wysiwyg_field === undefined) || (!is_wysiwyg_field(the_element))))) && ((!the_element.className) || (the_element.classList.contains('hidden_but_needed')) == null)) {
                return null;
            }
            if (the_element.disabled) {
                return null;
            }

            // Test file sizes
            if ((the_element.type == 'file') && (the_element.files) && (the_element.files.item) && (the_element.files.item(0)) && (the_element.files.item(0).fileSize))
                total_file_size += the_element.files.item(0).fileSize;

            // Test file types
            if ((the_element.type == 'file') && (the_element.value) && (the_element.name != 'file_anytype')) {
                var allowed_types = '{$VALID_FILE_TYPES;^}'.split(/,/);
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
                required = (the_form.elements['require__' + the_element.name] !== undefined) && (the_form.elements['require__' + the_element.name].value == '1');
            } else {
                required = the_element.className.includes('_required');
            }
            my_value = clever_find_value(the_form, the_element);

            // Prepare for custom error messages, stored as HTML5 data on the error message display element
            var errormsg_element = (the_element.name === undefined) ? null : get_errormsg_element(the_element.name);

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
                if (((the_class == 'input_username') || (the_class == 'input_username_required')) && (my_value != '') && (window.do_ajax_field_test) && (!do_ajax_field_test('{$FIND_SCRIPT_NOHTTP;,username_exists}?username=' + encodeUC(my_value)))) {
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

            function get_errormsg_element(id) {
                var errormsg_element = $cms.dom.$id('error_' + id);
                if (!errormsg_element) {
                    errormsg_element = $cms.dom.$id('error_' + id.replace(/\_day$/, '').replace(/\_month$/, '').replace(/\_year$/, '').replace(/\_hour$/, '').replace(/\_minute$/, ''));
                }
                return errormsg_element;
            }
        }
    }

    function set_locked(field, is_locked, chosen_ob) {
        var radio_button = $cms.dom.$id('choose_' + field.name.replace(/\[\]$/, ''));
        if (!radio_button) {
            radio_button = $cms.dom.$id('choose_' + field.name.replace(/\_\d+$/, '_'));
        }

        // For All-and-not,Line-multi,Compound-Tick,Radio-List,Date/Time: set_locked assumes that the calling code is clever
        // special input types are coded to observe their master input field readonly status)
        var button = $cms.dom.$id('uploadButton_' + field.name.replace(/\[\]$/, ''));

        if (is_locked) {
            var labels = document.getElementsByTagName('label'), label = null;
            for (var i = 0; i < labels.length; i++) {
                if (chosen_ob && (labels[i].getAttribute('for') == chosen_ob.id)) {
                    label = labels[i];
                    break;
                }
            }
            if (!radio_button) {
                if (label) {
                    var label_nice = $cms.dom.html(label).replace('&raquo;', '').replace(/^\s*/, '').replace(/\s*$/, '');
                    if (field.type == 'file') {
                        set_field_error(field, '{!DISABLED_FORM_FIELD_ENCHANCEDMSG_UPLOAD;^}'.replace(/\\{1\\}/, label_nice));
                    } else {
                        set_field_error(field, '{!DISABLED_FORM_FIELD_ENCHANCEDMSG;^}'.replace(/\\{1\\}/, label_nice));
                    }
                } else {
                    set_field_error(field, '{!DISABLED_FORM_FIELD;^}');
                }
            }
            field.classList.remove('input_erroneous');
        } else if (!radio_button) {
            set_field_error(field, '');
        }
        field.disabled = is_locked;

        if (button) {
            button.disabled = is_locked;
        }
    }

    function set_required(fieldName, isRequired) {
        var radio_button = $cms.dom.$('#choose_' + fieldName);

        isRequired = !!isRequired;

        if (radio_button) {
            if (isRequired) {
                radio_button.checked = true;
            }
        } else {
            var required_a = $cms.dom.$('#form_table_field_name__' + fieldName),
                required_b = $cms.dom.$('#required_readable_marker__' + fieldName),
                required_c = $cms.dom.$('#required_posted__' + fieldName),
                required_d = $cms.dom.$('#form_table_field_input__' + fieldName);

            if (required_a) {
                required_a.className = 'form_table_field_name';

                if (isRequired) {
                    required_a.classList.add('required');
                }
            }

            if (required_b) {
                $cms.dom.toggle(required_b, isRequired);
            }

            if (required_c) {
                required_c.value = isRequired ? 1 : 0;
            }

            if (required_d) {
                required_d.className = 'form_table_field_input';
            }
        }

        var element = $cms.dom.$('#' + fieldName);

        if (element) {
            element.className = element.className.replace(/(input_[a-z_]+)_required/g, '$1');

            if (isRequired) {
                element.className = element.className.replace(/(input_[a-z_]+)/g, '$1_required');
            }

            if (element.plupload_object) {
                element.plupload_object.settings.required = isRequired;
            }
        }

        if (!isRequired) {
            var error = $cms.dom.$('#error__' + fieldName);
            if (error) {
                error.style.display = 'none';
            }
        }
    }

    function disable_preview_scripts(context) {
        if (context === undefined) {
            context = document;
        }

        var elements, i;

        elements = $cms.dom.$$(context, 'button, input[type="button"], input[type="image"]');
        for (i = 0; i < elements.length; i++) {
            elements[i].addEventListener('click', alertNotInPreviewMode);
        }

        // Make sure links in the preview don't break it - put in a new window
        elements = $cms.dom.$$(context, 'a');
        for (i = 0; i < elements.length; i++) {
            if (elements[i].href && elements[i].href.includes('://')) {
                try {
                    if (!elements[i].href.toLowerCase().startsWith('javascript:') && (elements[i].target !== '_self') && (elements[i].target !== '_blank')) {// guard due to weird Firefox bug, JS actions still opening new window
                        elements[i].target = 'false_blank'; // Real _blank would trigger annoying CSS. This is better anyway.
                    }
                } catch (ignore) {} // IE can have security exceptions
            }
        }

        function alertNotInPreviewMode() {
            window.fauxmodal_alert('{!NOT_IN_PREVIEW_MODE;^}');
            return false;
        }
    }
}());
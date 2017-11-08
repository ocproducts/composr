(function ($cms) {
    'use strict';

    var IN_MINIKERNEL_VERSION = document.documentElement.classList.contains('in-minikernel-version');

    var symbols =  (!IN_MINIKERNEL_VERSION ? JSON.parse(document.getElementById('composr-symbol-data').content) : {});

    // Cached references
    var smile = ':)',
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
        // Clever helper for merging arrays in-place using `[].push`
        pushArray = Function.bind.call(Function.apply, emptyArr.push);

    function noop() {}

    // Too useful to not have globally!
    window.intVal  = intVal;
    window.numVal  = numVal;
    window.boolVal = boolVal;
    window.strVal  = strVal;
    window.arrVal  = arrVal;
    window.objVal  = objVal;

    $cms.init  || ($cms.init = []);
    $cms.ready || ($cms.ready = []);
    $cms.load  || ($cms.load = []);

    /** @namespace $cms */
    $cms = extendDeep($cms, /**@lends $cms*/ {
        // Unique for each copy of Composr on the page
        /**@member {string}*/
        id: 'composr' + ('' + Math.random()).substr(2),

        // Load up symbols data
        /**
         * @method
         * @returns {boolean}
         */
        $IS_GUEST: constant(boolVal(symbols.IS_GUEST)),
        /**
         * @method
         * @returns {boolean}
         */
        $IS_STAFF: constant(boolVal(symbols.IS_STAFF)),
        /**
         * @method
         * @returns {boolean}
         */
        $IS_ADMIN: constant(boolVal(symbols.IS_ADMIN)),
        /**
         * @method
         * @returns {boolean}
         */
        $IS_HTTPAUTH_LOGIN: constant(boolVal(symbols.IS_HTTPAUTH_LOGIN)),
        /**
         * @method
         * @returns {boolean}
         */
        $IS_A_COOKIE_LOGIN: constant(boolVal(symbols.IS_A_COOKIE_LOGIN)),
        /**
         * @method
         * @returns {boolean}
         */
        $DEV_MODE: constant(IN_MINIKERNEL_VERSION || boolVal(symbols.DEV_MODE)),
        /**
         * @method
         * @returns {boolean}
         */
        $JS_ON: constant(boolVal(symbols.JS_ON)),
        /**
         * @method
         * @returns {boolean}
         */
        $MOBILE: constant(boolVal(symbols.MOBILE)),
        /**
         * @method
         * @returns {boolean}
         */
        $FORCE_PREVIEWS: constant(boolVal(symbols.FORCE_PREVIEWS)),
        /**
         * @method
         * @returns {boolean}
         */
        $INLINE_STATS: constant(boolVal(symbols.INLINE_STATS)),
        /**
         * @method
         * @returns {number}
         */
        $HTTP_STATUS_CODE: constant(+symbols.HTTP_STATUS_CODE || 0),
        /**
         * @method
         * @returns {string}
         */
        $PAGE: constant(strVal(symbols.PAGE)),
        /**
         * @method
         * @returns {string}
         */
        $ZONE: constant(strVal(symbols.ZONE)),
        /**
         * @method
         * @returns {string}
         */
        $MEMBER: constant(strVal(symbols.MEMBER)),
        /**
         * @method
         * @returns {string}
         */
        $USERNAME: constant(strVal(symbols.USERNAME)),
        /**
         * @method
         * @returns {string}
         */
        $THEME: constant(strVal(symbols.THEME)),
        /**
         * @method
         * @returns {string}
         */
        $LANG: constant(strVal(symbols.LANG)),
        /**
         * @method
         * @returns {string}
         */
        $KEEP: function $KEEP(starting, forceSession) {
            var keep = pageKeepSearchParams(forceSession).toString();
            
            if (keep === '') {
                return '';
            }
            
            return (starting ? '?' : '&') + keep;
        },
        /**
         * @method
         * @returns {string}
         */
        $PREVIEW_URL: function $PREVIEW_URL() {
            var value = '{$FIND_SCRIPT_NOHTTP;,preview}';
            value += '?page=' + urlencode($cms.getPageName());
            value += '&type=' + urlencode(symbols['page_type']);
            return value;
        },
        /**
         * @method
         * @returns {string}
         */
        $SITE_NAME: constant(strVal('{$SITE_NAME;}')),
        /**
         * @method
         * @returns {string}
         */
        $BASE_URL: constant(strVal('{$BASE_URL;}')),
        /**
         * @method
         * @returns {string}
         */
        $BASE_URL_NOHTTP: constant(strVal('{$BASE_URL_NOHTTP;}')),
        /**
         * @method
         * @returns {string}
         */
        $CUSTOM_BASE_URL: constant(strVal('{$CUSTOM_BASE_URL;}')),
        /**
         * @method
         * @returns {string}
         */
        $CUSTOM_BASE_URL_NOHTTP: constant(strVal('{$CUSTOM_BASE_URL_NOHTTP;}')),
        /**
         * @method
         * @returns {string}
         */
        $FORUM_BASE_URL: constant(strVal('{$FORUM_BASE_URL;}')),
        /**
         * @method
         * @returns {string}
         */
        $BRAND_NAME: constant(strVal('{$BRAND_NAME;}')),
        /**
         * @method
         * @returns {string}
         */
        $SESSION_COOKIE_NAME: constant(strVal('{$SESSION_COOKIE_NAME;}')),
        /**
         * @method
         * @returns {string}
         */
        $COOKIE_PATH: constant(strVal('{$COOKIE_PATH;}')),
        /**
         * @method
         * @returns {string}
         */
        $COOKIE_DOMAIN: constant(strVal('{$COOKIE_DOMAIN;}')),
        /**
         * @method
         * @returns {string}
         */
        $RUNNING_SCRIPT: constant(strVal(symbols.RUNNING_SCRIPT)),
        /**
         * @method
         * @returns {string}
         */
        $CSP_NONCE: constant(strVal(symbols.CSP_NONCE)),

        /**
         * WARNING: This is a very limited subset of the $CONFIG_OPTION tempcode symbol
         * @method
         * @param {string} optionName
         * @returns {boolean|string|number}
         */
        $CONFIG_OPTION: (function () {
            if (IN_MINIKERNEL_VERSION) {
                // Installer, likely executing global.js
                return constant('');
            }

            var $PUBLIC_CONFIG_OPTIONS_JSON = JSON.parse('{$PUBLIC_CONFIG_OPTIONS_JSON;}');
            return function $CONFIG_OPTION(optionName) {
                if (hasOwn($PUBLIC_CONFIG_OPTIONS_JSON, optionName)) {
                    return $PUBLIC_CONFIG_OPTIONS_JSON[optionName];
                }

                $cms.fatal('$cms.$CONFIG_OPTION(): Option "' + optionName + '" is either unsupported in JS or doesn\'t exist. Please try using the actual Tempcode symbol.');
            };
        }()),
        // Just some more useful stuff, (not tempcode symbols)
        /**
         * @method
         * @returns {boolean}
         */
        seesJavascriptErrorAlerts: constant(boolVal(symbols['sees_javascript_error_alerts'])),
        /**
         * @method
         * @returns {boolean}
         */
        canTryUrlSchemes: constant(boolVal(symbols['can_try_url_schemes'])),
        /**
         * @method
         * @returns {string}
         */
        zoneDefaultPage: constant(strVal(symbols['zone_default_page'])),
        /**
         * @method
         * @returns {object}
         */
        staffTooltipsUrlPatterns: constant(objVal(JSON.parse('{$STAFF_TOOLTIPS_URL_PATTERNS_JSON;}')))
    });

    extendDeep($cms, /**@lends $cms*/{
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
        returnTrue: returnTrue,
        /**@method*/
        returnFalse: returnFalse,
        /**@method*/
        isObj: isObj,
        /**@method*/
        hasEnumerable: hasEnumerable,
        /**@method*/
        hasOwnEnumerable: hasOwnEnumerable,
        /**@method*/
        isPlainObj: isPlainObj,
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
        isEmpty: boolVal,
        /**@method*/
        noop: noop,
        /**@method*/
        random: random,
        /**@method*/
        camelCase: camelCase,
        /**@method*/
        once: once,
        /**@method*/
        findOnce: findOnce,
        /**@method*/
        removeOnce: removeOnce,
        /**@method*/
        each: each,
        /**@method*/
        eachIter: eachIter,
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
        format: format,
        /**@method*/
        ucFirst: ucFirst,
        /**@method*/
        numberFormat: numberFormat,
        /**@method*/
        inherits: inherits,
        /**@method*/
        baseUrl: baseUrl,
        /**@method*/
        getPageName: getPageName,
        /**@method*/
        pageUrl: pageUrl,
        /**@method*/
        pageSearchParams: pageSearchParams,
        /**@method*/
        pageKeepSearchParams: pageKeepSearchParams,
        /**@method*/
        img: img,
        /**@method*/
        navigate: navigate,
        /**@method*/
        inform: inform,
        /**@method*/
        warn: warn,
        /**@method*/
        fatal: fatal,
        /**@method*/
        waitForResources: waitForResources,
        /**@method*/
        requireCss: requireCss,
        /**@method*/
        requireJavascript: requireJavascript,
        /**@method*/
        promiseSequence: promiseSequence,
        /**@method*/
        promiseHalt: promiseHalt,
        /**@method*/
        setPostDataFlag: setPostDataFlag,
        /**@method*/
        parseJson: parseJson,
        /**@method*/
        parseJson5: parseJson5,
        /**@method*/
        getCsrfToken: getCsrfToken,
        /**@method*/
        getSessionId: getSessionId,
        /**@method*/
        defineBehaviors: defineBehaviors,
        /**@method*/
        attachBehaviors: attachBehaviors,
        /**@method*/
        detachBehaviors: detachBehaviors,
        /**@method*/
        callBlock: callBlock,
        /**@method*/
        loadSnippet: loadSnippet,
        /**@method*/
        maintainThemeInLink: maintainThemeInLink,
        /**@method*/
        addKeepStub: addKeepStub,
        /**@method*/
        gaTrack: gaTrack,
        /**@method*/
        googlePlusTrack: googlePlusTrack,
        /**@method*/
        playSelfAudioLink: playSelfAudioLink,
        /**@method*/
        setCookie: setCookie,
        /**@method*/
        readCookie: readCookie,
        /**@method*/
        createRollover: createRollover,
        /**@method*/
        browserMatches: browserMatches,
        /**@method*/
        undoStaffUnloadAction: undoStaffUnloadAction,
        /**@method*/
        getMainCmsWindow: getMainCmsWindow,
        /**@method*/
        magicKeypress: magicKeypress,
        /**@method*/
        manageScrollHeight: manageScrollHeight,
        /**@method*/
        executeJsFunctionCalls: executeJsFunctionCalls,
        /**@method*/
        doAjaxRequest: doAjaxRequest,
        /**@method*/
        protectURLParameter: protectURLParameter,
        /**@method*/
        pageMeta: pageMeta,
        /**
         * Addons will add template related methods under this object
         * @namespace $cms.templates
         */
        templates: {},
        /**
         * Addons can add functions under this object
         * @namespace $cms.functions
         */
        functions: {},
        /**
         * Addons will add $cms.View subclasses under this object
         * @namespace $cms.views
         */
        views: {},
        /**
         * @namespace $cms.ui
         */
        ui: {},
        /**
         * Validation code and other general code relating to forms
         * @namespace $cms.form
         */
        form: {},
        /**
         * @namespace $cms.settings
         */
        settings: {},
        /**
         * Addons will add "behaviors" under this object
         * @namespace $cms.behaviors
         */
        behaviors: {},
        /**
         * Browser feature detection
         * @namespace $cms.support
         */
        support: {},
        /**
         * DOM helper methods
         * @namespace $cms.dom
         */
        dom: {}
    });

    setTimeout(function () {
        executeCmsInitQueue();

        if (document.readyState === 'interactive') {
            // Workaround for browser bug, document.readyState == 'interactive' before [defer]'d <script>s are loaded.
            // See: https://github.com/jquery/jquery/issues/3271
            $cms.waitForResources(toArray(document.querySelectorAll('script[src][defer]'))).then(function () {
                executeCmsReadyQueue();
            });
        } else if (document.readyState === 'complete') {
            executeCmsReadyQueue();
        } else {
            document.addEventListener('DOMContentLoaded', function listener() {
                document.removeEventListener('DOMContentLoaded', listener);
                executeCmsReadyQueue();
            });
        }

        if (document.readyState === 'complete') {
            executeCmsLoadQueue();
        } else {
            window.addEventListener('load', function listener() {
                window.removeEventListener('load', listener);
                executeCmsLoadQueue();
            });
        }
    }, 0);

    function executeCmsInitQueue() {
        var fn;

        while ($cms.init.length > 0) {
            fn = $cms.init.shift();
            if (typeof fn === 'function') {
                fn();
            }
        }

        properties($cms.init, {
            unshift: function unshift(fn) {
                fn();
            },
            push: function push(fn) {
                fn();
            }
        });
    }

    function executeCmsReadyQueue() {
        var fn;

        while ($cms.ready.length > 0) {
            fn = $cms.ready.shift();
            if (typeof fn === 'function') {
                fn();
            }
        }

        properties($cms.ready, {
            unshift: function unshift(fn) {
                fn();
            },
            push: function push(fn) {
                fn();
            }
        });
    }

    function executeCmsLoadQueue() {
        var fn;

        while ($cms.load.length > 0) {
            fn = $cms.load.shift();
            if (typeof fn === 'function') {
                fn();
            }
        }

        properties($cms.load, {
            unshift: function unshift(fn) {
                fn();
            },
            push: function push(fn) {
                fn();
            }
        });
    }

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

    /**
     * @returns {boolean}
     */
    function returnTrue() {
        return true;
    }

    /**
     * @returns {boolean}
     */
    function returnFalse() {
        return false;
    }

    /**
     * @param first
     * @returns {*}
     */
    function returnFirst(first) {
        return first;
    }

    /**
     * Creates a function that always returns the same value that is passed as the first argument here
     * @param value
     * @returns { function }
     */
    function constant(value) {
        return function _constant() {
            return value;
        };
    }

    /**
     * @param val
     * @param withEnumerable (boolean)
     * @returns {boolean}
     */
    function isObj(val, withEnumerable) {
        return (val != null) && (typeof val === 'object') && (!withEnumerable || hasEnumerable(val));
    }

    /**
     * @param val
     * @returns {boolean}
     */
    function hasEnumerable(val) {
        if (val != null) {
            for (var key in val) {
                return true;
            }
        }
        return false;
    }

    /**
     * @param val
     * @returns {boolean}
     */
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

    /**
     * @param obj
     * @returns {*|boolean}
     */
    function isPlainObj(obj) {
        var proto;
        return isObj(obj) && (internalName(obj) === 'Object') && (((proto = Object.getPrototypeOf(obj)) === Object.prototype) || (proto === null));
    }

    /**
     * @param val
     * @returns { boolean }
     */
    function isArrayOrPlainObj(val) {
        return (val != null) && (Array.isArray(val) || isPlainObj(val));
    }

    /**
     * @param val
     * @returns {boolean}
     */
    function isScalar(val) {
        return (val != null) && ((typeof val === 'boolean') || (typeof val === 'number') || (typeof val === 'string'));
    }

    /**
     * @param obj
     * @param keys
     * @returns {boolean}
     */
    function hasMatchingKey(obj, keys) {
        keys = arrVal(keys);

        for (var i = 0, len = keys.length; i < len; i++) {
            if (keys[i] in obj) {
                return true;
            }
        }

        return false;
    }

    /**
     * @param prototype
     * @param data
     * @returns {prototype}
     */
    function withProto(prototype, data) {
        var obj = Object.create(prototype);
        if (data != null) {
            Object.assign(obj, data);
        }
        return obj;
    }

    /**
     * @param data
     * @returns {prototype}
     */
    function pureObj(data) {
        return withProto(null, data);
    }

    /**
     * @param key
     * @param value
     * @returns {object}
     */
    function keyValue(key, value) {
        var obj = {};
        obj[key] = value;
        return obj;
    }

    /**
     * @param obj
     * @returns {boolean}
     */
    function isPromise(obj) {
        return (obj != null) && (typeof obj === 'object') && (typeof obj.then === 'function');
    }

    /**
     * @param obj
     * @returns {boolean}
     */
    function isWindow(obj) {
        return isObj(obj) && (obj === obj.window) && (obj === obj.self) && (internalName(obj) === 'Window');
    }

    /**
     * @param obj
     * @returns {boolean|*}
     */
    function nodeType(obj) {
        return isObj(obj) && (typeof obj.nodeName === 'string') && (typeof obj.nodeType === 'number') && obj.nodeType;
    }

    var ELEMENT_NODE = 1,
        DOCUMENT_NODE = 9,
        DOCUMENT_FRAGMENT_NODE = 11;

    /**
     * @param obj
     * @returns {boolean}
     */
    function isNode(obj) {
        return nodeType(obj) !== false;
    }

    /**
     * @param obj
     * @returns {boolean}
     */
    function isEl(obj) {
        return nodeType(obj) === ELEMENT_NODE;
    }

    /**
     * @param obj
     * @returns {boolean}
     */
    function isDoc(obj) {
        return nodeType(obj) === DOCUMENT_NODE;
    }

    /**
     * @param obj
     * @returns {boolean}
     */
    function isDocFrag(obj) {
        return nodeType(obj) === DOCUMENT_FRAGMENT_NODE;
    }

    /**
     * @param obj
     * @returns {boolean}
     */
    function isDocOrEl(obj) {
        var t = nodeType(obj);
        return (t === ELEMENT_NODE) || (t === DOCUMENT_NODE);
    }

    /**
     * @param obj
     * @returns {boolean}
     */
    function isDocOrFragOrEl(obj) {
        var t = nodeType(obj);
        return (t === ELEMENT_NODE) || (t === DOCUMENT_NODE) || (t === DOCUMENT_FRAGMENT_NODE);
    }

    /**
     * @param obj
     * @returns {boolean}
     */
    function isRegExp(obj) {
        return (obj != null) && (internalName(obj) === 'RegExp');
    }

    /**
     * @param obj
     * @returns {boolean}
     */
    function isDate(obj) {
        return (obj != null) && (internalName(obj) === 'Date');
    }

    /**
     * @param val
     * @returns {boolean}
     */
    function isNumeric(val) {
        if (typeof val === 'string') {
            return (val !== '') && isFinite(val);
        }
        
        return Number.isFinite(val);
    }

    /**
     * @param obj
     * @param minLength
     * @returns {boolean}
     */
    function isArrayLike(obj, minLength) {
        var len;
        minLength = Number(minLength) || 0;

        return (obj != null)
            && (typeof obj === 'object')
            && (internalName(obj) !== 'Window')
            && (typeof (len = obj.length) === 'number')
            && (len >= minLength)
            && ((len === 0) || ((0 in obj) && ((len - 1) in obj)));
    }

    /**
     * Returns a random integer between min (inclusive) and max (inclusive)
     * Using Math.round() will give you a non-uniform distribution!
     * @param [min] {number}
     * @param [max] {number}
     * @returns {number}
     */
    function random(min, max) {
        min = intVal(min, 0);
        max = intVal(max, 1000000000000); // 1 Trillion

        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    /**
     * Bind a number of an object's methods to that object. Remaining arguments
     * are the method names to be bound. Useful for ensuring that all callbacks
     * defined on an object belong to it.
     * @param obj
     * @param methodNames
     * @returns {object}
     */
    function bindAll(obj, /*...*/methodNames) {
        var i, len = arguments.length, methodName;
        for (i = 1; i < len; i++) {
            methodName = arguments[i];
            obj[methodName] = obj[methodName].bind(obj);
        }
        return obj;
    }

    /**
     * @param obj
     * @param callback
     * @returns {*}
     */
    function each(obj, callback) {
        if (obj == null) {
            return obj;
        }

        for (var name in obj) {
            if (callback.call(obj, name, obj[name]) === false) {
                return obj;
            }
        }

        return obj;
    }

    /**
     * Iterates over iterable objects
     * @param iterable
     * @param callback
     * @returns {*}
     */
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

    /**
     * Copy all except undefined properties from one or more objects to the `target` object.
     * @param target
     * @param {...object} sources - Source objects
     * @returns {*}
     */
    function extend(target, /*...*/sources) {
        sources = toArray(arguments, 1);

        for (var i = 0, len = sources.length; i < len; i++) {
            _extend(target, sources[i]);
        }
        return target
    }

    /**
     * Extends `target` with source own-properties only.
     * @param target
     * @param {...object} sources - Source objects
     * @returns {*}
     */
    function extendOwn(target, /*...*/sources) {
        sources = toArray(arguments, 1);

        for (var i = 0, len = sources.length; i < len; i++) {
            _extend(target, sources[i], EXTEND_SRC_OWN_ONLY);
        }
        return target
    }

    /**
     * Deep extend, clones any arrays and plain objects found in sources.
     * @param target
     * @param {...object} sources - Source objects
     * @returns {object}
     */
    function extendDeep(target, /*...*/sources) {
        sources = toArray(arguments, 1);

        for (var i = 0, len = sources.length; i < len; i++) {
            _extend(target, sources[i], EXTEND_DEEP);
        }
        return target
    }

    /**
     * Returns a function that always returns a deep-clone of `obj`
     * @param obj
     * @returns {function}
     */
    function cloner(obj) {
        obj = objVal(obj);
        return function cloned() {
            return extendDeep({}, obj);
        };
    }

    /**
     * Apply `options` to the `defaults` object. Only copies over properties with keys already defined in the `defaults` object.
     * @param defaults
     * @param {...object} options - Options
     * @returns {*}
     */
    function defaults(defaults, /*...*/options) {
        options = toArray(arguments, 1);

        for (var i = 0, len = options.length; i < len; i++) {
            _extend(defaults, options[i], EXTEND_TGT_OWN_ONLY);
        }
        return defaults
    }

    /**
     * If the value of the named `property` is a function then invoke it with the
     * `object` as context; otherwise, return it.
     * @param object
     * @param property
     * @param fallback
     * @returns {*}
     */
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

        mask = strVal(mask);

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

    /**
     * Gets the internal type/constructor name of the provided `val`
     * @param val
     * @returns {string}
     */
    function internalName(val) {
        return emptyObj.toString.call(val).slice(8, -1); // slice off the surrounding '[object ' and ']'
    }

    /**
     * @param obj
     * @returns {*}
     */
    function constructorName(obj) {
        if ((obj != null) && (typeof obj.constructor === 'function') && (typeof obj.constructor.name === 'string')) {
            return obj.constructor.name;
        }
    }

    /**
     * @param obj
     * @returns {*}
     */
    function typeName(obj) {
        var name = constructorName(obj);
        return ((name !== undefined) && (name !== '')) ? name : internalName(obj);
    }

    /**
     * Port of PHP's boolval() function
     * @param val
     * @param [defaultValue]
     * @returns { Boolean }
     */
    function boolVal(val, defaultValue) {
        var p;
        if (defaultValue === undefined) {
            defaultValue = false;
        }

        if (val == null) {
            return defaultValue;
        }

        return !!val && (val !== '0'); //&& ((typeof val !== 'object') || !((p = isPlainObj(val)) || isArrayLike(val)) || (p ? hasEnumerable(val) : (val.length > 0)));
    }

    /**
     * Port of PHP's empty() function
     * @param val
     * @returns { Boolean }
     */
    function isEmpty(val) {
        var p;
        return !!val && (val !== '0'); // && ((typeof val !== 'object') || !((p = isPlainObj(val)) || isArrayLike(val)) || (p ? hasEnumerable(val) : (val.length > 0)));
    }

    /**
     * @param val
     * @param [defaultValue]
     * @returns { Number }
     */
    function intVal(val, defaultValue) {
        if (defaultValue === undefined) {
            defaultValue = 0;
        }

        if (val == null) {
            return defaultValue;
        }

        // if (((typeof val === 'object') && (val.valueOf === emptyObj.valueOf)) || ((typeof val === 'function') && (val.valueOf === noop.valueOf))) {
        //     throw new TypeError('intVal(): Cannot coerce `val` of type "' + typeName(val) + '" to an integer.');
        // }

        val = Math.floor(val);

        return (val && (val !== Infinity) && (val !== -Infinity)) ? val : 0;
    }

    /**
     * @param val
     * @param [defaultValue]
     * @returns { Number }
     */
    function numVal(val, defaultValue) {
        if (defaultValue === undefined) {
            defaultValue = 0;
        }

        if (val == null) {
            return defaultValue;
        }

        // if (((typeof val === 'object') && (val.valueOf === emptyObj.valueOf)) || ((typeof val === 'function') && (val.valueOf === noop.valueOf))) {
        //     throw new TypeError('numVal(): Cannot coerce `val` of type "' + typeName(val) + '" to a number.');
        // }

        val = Number(val);

        return (val && (val !== Infinity) && (val !== -Infinity)) ? val : 0;
    }

    function numberFormat(num) {
        num = Number(num) || 0;
        return num.toLocaleString();
    }

    /**
     * @param val
     * @param [defaultValue]
     * @returns { Array }
     */
    function arrVal(val, defaultValue) {
        if (defaultValue === undefined) {
            defaultValue = [];
        }

        if (val == null) {
            return defaultValue;
        }

        if ((typeof val === 'object') && (Array.isArray(val) || isArrayLike(val))) {
            return toArray(val);
        }

        return [val];
    }

    /**
     * @param val
     * @param [defaultValue]
     * @param [defaultPropertyName]
     * @returns { Object }
     */
    function objVal(val, defaultValue, defaultPropertyName) {
        if (defaultValue === undefined) {
            defaultValue = {};
        }

        if (val == null) {
            return defaultValue;
        }

        if (!isObj(val)) {
            if (defaultPropertyName != null) {
                val = keyValue(defaultPropertyName, val);
            } else {
                throw new TypeError('objVal(): Cannot coerce `val` of type "' + typeName(val) + '" to an object.');
            }
        }
        
        return val;
    }

    /**
     * Sensible PHP-like string coercion
     * @param val
     * @param [defaultValue]
     * @returns { string }
     */
    function strVal(val, defaultValue) {
        var ret;
        
        if (defaultValue === undefined) {
            defaultValue = '';
        }

         if (!val) {
            ret = (val === 0) ? '0' : '';
        } else if (val === true) {
            ret = '1';
        } else if (typeof val === 'string') {
            ret = val;
        } else if (typeof val === 'number') {
            ret = ((val !== Infinity) && (val !== -Infinity)) ? ('' + val) : '';
        } else if ((typeof val === 'object') && (val.toString !== emptyObj.toString) && (typeof val.toString === 'function')) {
            // `val` has a .toString() implementation other than the useless generic one
            ret = '' + val;
        } else {
            throw new TypeError('strVal(): Cannot coerce `val` of type "' + typeName(val) + '" to a string.');
        }
        
        return (ret !== '') ? ret : defaultValue;
    }

    /**
     * String interpolation
     * @param str
     * @param { Array|object } values
     * @returns { string }
     */
    function format(str, values) {
        str = strVal(str);

        if ((str === '') || (values == null) || (typeof values !== 'object')) {
            return str; // Nothing to do
        }
        
        if (isArrayLike(values)) {
            return str.replace(/\{(\d+)\}/g, function (match, key) {
                key--; // So that interpolation starts from '{1}'
                return (key in values) ? strVal(values[key]) : match;
            })
        }

        return str.replace(/\{(\w+)\}/g, function (match, key) {
            return (key in values) ? strVal(values[key]) : match;
        });
    }

    /**
     * @param str
     * @returns {string}
     */
    function ucFirst(str) {
        return ((str != null) && (str = strVal(str))) ? str.charAt(0).toUpperCase() + str.substr(1) : '';
    }

    /**
     * @param str
     * @returns {string}
     */
    function lcFirst(str) {
        return ((str != null) && (str = strVal(str))) ? str.charAt(0).toLowerCase() + str.substr(1) : '';
    }

    /**
     * Credit: http://stackoverflow.com/a/32604073/362006
     * @param str
     * @returns {string}
     */
    function camelCase(str) {
        return ((str != null) && (str = strVal(str))) ?
            str.replace(/[\-_]+/g, ' ') // Replaces any - or _ characters with a space
                .replace(/[^\w\s]/g, '') // Removes any non alphanumeric characters
                .replace(/ (.)/g, function ($1) { // Uppercases the first character in each group immediately following a space (delimited by spaces)
                    return $1.toUpperCase();
                })
                .replace(/ /g, '') // Removes spaces
            : '';
    }

    // Inspired by https://github.com/RobLoach/jquery-once
    // https://www.drupal.org/docs/7/api/javascript-api/managing-javascript-in-drupal-7#jquery-once
    var _onced = {};
    /**
     * @param objects
     * @param flag
     * @return { Array.<T> }
     */
    function once(objects, flag) {
        objects = arrVal(objects);
        flag = strVal(flag);

        _onced[flag] || (_onced[flag] = {});

        return objects.filter(function (obj) {
            var uid = $cms.uid(obj);
            if (_onced[flag][uid] === true) {
                return false;
            }
            _onced[flag][uid] = true;
            return true;
        });
    }
    /**
     * @param objects
     * @param flag
     * @return { Array.<T> }
     */
    function findOnce(objects, flag) {
        objects = arrVal(objects);
        flag = strVal(flag);

        if (!_onced[flag]) {
            return [];
        }

        return objects.filter(function (obj) {
            var uid = $cms.uid(obj);
            return _onced[flag][uid] === true;
        });
    }
    /**
     * @param objects
     * @param flag
     */
    function removeOnce(objects, flag) {
        objects = arrVal(objects);
        flag = strVal(flag);

        if (!_onced[flag]) {
            return;
        }

        objects.forEach(function (obj) {
            var uid = $cms.uid(obj);
            delete _onced[flag][uid];
        });
    }
    /**
     * @param iterable
     * @returns { Array }
     */
    function arrayFromIterable(iterable) {
        var item, array = [];

        if (iterable != null) {
            while (!(item = iterable.next()).done) {
                array.push(item.value);
            }
        }

        return array;
    }
    
    var rgxProtocol = /^[a-z0-9\-\.]+:(?=\/\/)/i,
        rgxHttp = /^https?:(?=\/\/)/i,
        rgxHttpRel = /^(?:https?:)?(?=\/\/)/i;
    /**
     * NB: Has a trailing slash when having the base url only
     * @memberof $cms
     * @namespace
     * @method
     * @param {string} url - An absolute or relative URL. If url is a relative URL, `base` will be used as the base URL. If url is an absolute URL, a given `base` will be ignored.
     * @param {string} [base] - The base URL to use in case url is a relative URL. If not specified, it defaults to $cms.$BASE_URL().
     * @return { URL }
     */
    $cms.url = function url(url, base) {
        url = strVal(url);
        base = strVal(base) || ($cms.$BASE_URL() + '/');

        return new URL(url, base);
    };

    extend($cms.url, /**@lends $cms.url*/{
        isAbsolute: isAbsolute,
        isRelative: isRelative,
        isSchemeRelative: isSchemeRelative,
        isAbsoluteOrSchemeRelative: isAbsoluteOrSchemeRelative,
        schemeRelative: schemeRelative
    });

    /**
     * @param relativeUrl - Pass a relative URL but an absolute url works as well for robustness' sake
     * @returns {string}
     */
    function baseUrl(relativeUrl) {
        relativeUrl = strVal(relativeUrl);

        if (relativeUrl === '') {
            return $cms.$BASE_URL();
        }
        
        var url = $cms.url(relativeUrl).toString();
        
        if (window.location.protocol === 'https:') {
            // Match protocol with the current page if using SSL
            url = url.replace(/^http\:/, 'https:');
        }
        
        return url;
    }
    
    function getPageName() {
        return $cms.$PAGE();
    }

    /**
     * Returns a { URL } instance for the current page
     * @see https://developer.mozilla.org/en-US/docs/Web/API/URL
     * @return { URL }
     */
    function pageUrl() {
        return new URL(window.location);
    }

    /**
     * Returns a { URLSearchParams } instance for the current page URL's query string
     * @see https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams
     * @return { URLSearchParams }
     */
    function pageSearchParams() {
        return pageUrl().searchParams;
    }
    
    function pageKeepSearchParams(forceSession) {
        var keepSp = new URLSearchParams();

        eachIter($cms.pageSearchParams().entries(), function (entry) {
            var name = entry[0],
                value = entry[1];

            if (name.startsWith('keep_')) {
                keepSp.set(name, value);
            }
        });

        if (forceSession && !keepSp.has('keep_session') && ($cms.getSessionId() !== '')) {
            keepSp.set('keep_session', $cms.getSessionId());
        }
        
        return keepSp;
    }

    function isAbsolute(url) {
        url = strVal(url);
        return rgxHttp.test(url);
    }

    function isRelative(url) {
        url = strVal(url);
        return !isAbsoluteOrSchemeRelative(url);
    }

    function isSchemeRelative(url) {
        url = strVal(url);
        return url.startsWith('//');
    }
    
    function isAbsoluteOrSchemeRelative(url) {
        url = strVal(url);
        return rgxHttpRel.test(url);
    }
    /**
     * Make a URL scheme-relative
     * @param url
     * @returns {string}
     */
    function schemeRelative(url) {
        url = strVal(url);

        return $cms.url(url).toString().replace(rgxProtocol, '');
    }

    /**
     * Dynamically fixes the protocol for image URLs
     * @param url
     * @returns {string}
     */
    function img(url) {
        return strVal(url).replace(rgxHttp, window.location.protocol);
    }

    /**
     * Force a link to be clicked without user clicking it directly (useful if there's a confirmation dialog inbetween their click)
     * @param url
     * @param target
     */
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

        url = strVal(url);
        target = strVal(target) || '_self';

        if (!url) {
            return;
        }

        if (target === '_self') {
            window.location = url;
        } else {
            window.open(url, target);
        }
    }

    /**
     * @param source
     * @returns {*}
     */
    function parseJson(source) {
        return window.JSON.parse(strVal(source));
    }

    /**
     * @param source
     * @returns {*}
     */
    function parseJson5(source) {
        return window.JSON5.parse(strVal(source));
    }

    function inform() {
        if ($cms.$DEV_MODE()) {
            return console.log.apply(undefined, arguments);
        }
    }

    function warn() {
        return console.warn.apply(undefined, arguments);
    }

    function fatal() {
        return console.error.apply(undefined, arguments);
    }

    function waitForResources(resourceEls) {
        if (resourceEls == null) {
            return Promise.resolve();
        }

        if (isEl(resourceEls)) {
            resourceEls = [resourceEls];
        }

        if (!Array.isArray(resourceEls)) {
            $cms.fatal('$cms.waitForResources(): Argument 1 must be of type {array|HTMLElement}, "' + typeName(resourceEls) + '" provided.');
            return Promise.reject();
        }

        if (resourceEls.length < 1) {
            return Promise.resolve();
        }

        //$cms.inform('$cms.waitForResources(): Waiting for resources', resourceEls);

        var resourcesToLoad = new Set();
        resourceEls.forEach(function (el) {
            if (!isEl(el)) {
                $cms.fatal('$cms.waitForResources(): Invalid item of type "' + typeName(resourceEls) + '" in the `resourceEls` parameter.');
                return;
            }
            
            if ($cms.dom.hasElementLoaded(el)) {
                return;
            }

            switch (el.localName) {
                case 'script':
                    if (el.src && jsTypeRE.test(el.type)) {
                        resourcesToLoad.add(el);
                    }
                    break;
                    
                case 'link':
                    if (el.rel === 'stylesheet') {
                        resourcesToLoad.add(el);
                    }
                    break;
                    
                case 'img':
                case 'iframe':
                    resourcesToLoad.add(el);
                    break;
            }
        });

        if (resourcesToLoad.size < 1) {
            return Promise.resolve();
        }

        return new Promise(function (resolve) {
            document.addEventListener('load', resourceLoadListener, true);
            document.addEventListener('error', resourceLoadListener, true);

            function resourceLoadListener(event) {
                var loadedEl = event.target;

                if (!resourcesToLoad.has(loadedEl)) {
                    return;
                }

                if (event.type === 'load') {
                    //$cms.inform('$cms.waitForResources(): Resource loaded successfully', loadedEl);
                } else {
                    $cms.fatal('$cms.waitForResources(): Resource failed to load', loadedEl);
                }

                resourcesToLoad.delete(loadedEl);

                if (resourcesToLoad.size < 1) {
                    resolve(event);
                }
            }
        });
    }

    var validIdRE = /^[a-zA-Z][\w:.-]*$/;
    /**
     * @private
     * @param sheetNameOrHref
     */
    function _requireCss(sheetNameOrHref) {
        var sheetName, sheetHref, sheetEl;

        if (validIdRE.test(sheetNameOrHref)) {
            sheetName = sheetNameOrHref;
            sheetHref = $cms.url.schemeRelative('{$FIND_SCRIPT_NOHTTP;,sheet}?sheet=' + sheetName + $cms.$KEEP());
        } else {
            sheetHref = $cms.url.schemeRelative(sheetNameOrHref);
        }

        if (sheetName != null) {
            sheetEl = _findCssByName(sheetName);
        }

        if (sheetEl == null) {
            sheetEl = _findCssByHref(sheetHref);
        }

        if (sheetEl == null) {
            sheetEl = document.createElement('link');
            sheetEl.id = 'css-' + ((sheetName != null) ? sheetName : $cms.random());
            sheetEl.rel = 'stylesheet';
            sheetEl.nonce = $cms.$CSP_NONCE();
            sheetEl.href = sheetHref;
            document.head.appendChild(sheetEl);
        }

        return $cms.waitForResources(sheetEl);
    }

    function _findCssByName(stylesheetName) {
        stylesheetName = strVal(stylesheetName);

        var els = $cms.dom.$$('link[id^="css-' + stylesheetName + '"]'), scriptEl;

        for (var i = 0; i < els.length; i++) {
            scriptEl = els[i];
            if ((new RegExp('^css-' + stylesheetName + '(?:_non_minified)?(?:_ssl)?(?:_mobile)?$', 'i')).test(scriptEl.id)) {
                return scriptEl;
            }
        }

        return null;
    }
    
    function _findCssByHref(href) {
        var els = $cms.dom.$$('link[rel="stylesheet"][href]'), el;

        href = $cms.url.schemeRelative(href);

        for (var i = 0; i < els.length; i++) {
            el = els[i];
            if ($cms.url.schemeRelative(el.href) === href) {
                return el;
            }
        }

        return null;
    }

    /**
     * @param sheetNames
     * @returns { Promise }
     */
    function requireCss(sheetNames) {
        sheetNames = arrVal(sheetNames);

        return Promise.all(sheetNames.map(_requireCss));
    }
    
    /**
     * @private
     * @param scriptNameOrSrc
     * @returns { Promise }
     */
    function _requireJavascript(scriptNameOrSrc) {
        scriptNameOrSrc = strVal(scriptNameOrSrc);

        var scriptName, scriptSrc, scriptEl;
        
        if (validIdRE.test(scriptNameOrSrc)) {
            scriptName = scriptNameOrSrc;
            scriptSrc = $cms.url.schemeRelative('{$FIND_SCRIPT_NOHTTP;,javascript}?script=' + scriptName + $cms.$KEEP());
        } else {
            scriptSrc = $cms.url.schemeRelative(scriptNameOrSrc);
        }
        
        if (scriptName != null) {
            scriptEl = _findScriptByName(scriptName);
        }
        
        if (scriptEl == null) {
            scriptEl = _findScriptBySrc(scriptSrc);
        }

        if (scriptEl == null) {
            scriptEl = document.createElement('script');
            scriptEl.defer = true;
            scriptEl.id = 'javascript-' + ((scriptName != null) ? scriptName : $cms.random());
            scriptEl.nonce = $cms.$CSP_NONCE();
            scriptEl.src = scriptSrc;
            document.body.appendChild(scriptEl);
        }

        return $cms.waitForResources(scriptEl);
    }
    
    function _findScriptByName(scriptName) {
        scriptName = strVal(scriptName);

        var els = $cms.dom.$$('script[id^="javascript-' + scriptName + '"]'), el;

        for (var i = 0; i < els.length; i++) {
            el = els[i];
            if ((new RegExp('^javascript-' + scriptName + '(?:_non_minified)?(?:_ssl)?(?:_mobile)?$', 'i')).test(el.id)) {
                return el;
            }
        }

        return null;
    }
    
    function _findScriptBySrc(src) {
        var els = $cms.dom.$$('script[src]'), el;
        
        src = $cms.url.schemeRelative(src);
        
        for (var i = 0; i < els.length; i++) {
            el = els[i];
            if ($cms.url.schemeRelative(el.src) === src) {
                return el;
            }
        }
        
        return null;
    }

    /**
     * @param scripts
     * @returns { Promise }
     */
    function requireJavascript(scripts) {
        var calls = [];

        scripts = arrVal(scripts);

        scripts.forEach(function (script) {
            calls.push(function () {
                return _requireJavascript(script)
            });
        });

        return promiseSequence(calls);
    }

    /**
     * Used to execute a series promises one after another, in a sequence.
     * @see https://pouchdb.com/2015/05/18/we-have-a-problem-with-promises.html
     * @param {function[]} promiseFactories
     * @returns { Promise }
     */
    function promiseSequence(promiseFactories) {
        promiseFactories = arrVal(promiseFactories);

        var result = Promise.resolve();
        promiseFactories.forEach(function (promiseFactory) {
            result = result.then(promiseFactory);
        });

        return result;
    }

    var _haltedPromise;
    /**
     * Use this to halt promise chain execution since using unresolved promises used to stop the execution chain can cause memory leaks.
     * This will simply keep a single unresolved promise around, which will be the only promise that isn't garbage collected.
     * Since then() and catch() are overridden in this new promise, the chain should not build up, and old parts of the chain should be garbage collected.
     * @see https://github.com/elastic/kibana/issues/3015
     * @return { Promise }
     */
    function promiseHalt() {
        if (_haltedPromise === undefined) {
            _haltedPromise = new Promise(function () {});
            properties(_haltedPromise, {
                then: function then() {
                    return _haltedPromise;
                },
                'catch': function _catch() {
                    return _haltedPromise;
                }
            });
        }

        return _haltedPromise;
    }

    /**
     * @param flag
     */
    function setPostDataFlag(flag) {
        flag = strVal(flag);

        var forms = $cms.dom.$$('form'),
            form, postData;

        for (var i = 0; i < forms.length; i++) {
            form = forms[i];

            if (form.elements['post_data'] == null) {
                postData = document.createElement('input');
                postData.type = 'hidden';
                postData.name = 'post_data';
                postData.value = '';
                form.appendChild(postData);
            } else {
                postData = form.elements['post_data'];
                if (postData.value !== '') {
                    postData.value += ',';
                }
            }

            postData.value += flag;
        }
    }

    // Inspired by goog.inherits and Babel's generated output for ES6 classes
    /**
     * @param SubClass
     * @param SuperClass
     * @param protoProps
     */
    function inherits(SubClass, SuperClass, protoProps) {
        Object.setPrototypeOf(SubClass, SuperClass);

        properties(SubClass, { base: base.bind(undefined, SuperClass) });

        // Set the prototype chain to inherit from `SuperClass`
        SubClass.prototype = Object.create(SuperClass.prototype);

        protoProps || (protoProps = {});
        protoProps.constructor = SubClass;

        properties(SubClass.prototype, protoProps);
    }

    function getCsrfToken() {
        return readCookie($cms.$SESSION_COOKIE_NAME()); // Session also works as a CSRF-token, as client-side knows it (AJAX)
    }

    function getSessionId() {
        return readCookie($cms.$SESSION_COOKIE_NAME());
    }

    /**
     * Emulates super.method() call
     * @param SuperClass
     * @param that
     * @param method
     * @param args
     * @returns {*}
     */
    function base(SuperClass, that, method, args) {
        return (args && (args.length > 0)) ? SuperClass.prototype[method].apply(that, args) : SuperClass.prototype[method].call(that);
    }

    /* Cookies */

    var alertedCookieConflict = false;
    /**
     * @param cookieName
     * @param cookieValue
     * @param numDays
     */
    function setCookie(cookieName, cookieValue, numDays) {
        var expires = new Date(),
            output;

        cookieName = strVal(cookieName);
        cookieValue = strVal(cookieValue);
        numDays = Number(numDays) || 1;

        expires.setDate(expires.getDate() + numDays); // Add days to date

        output = cookieName + '=' + encodeURIComponent(cookieValue) + ';expires=' + expires.toUTCString();

        if ($cms.$COOKIE_PATH() !== '') {
            output += ';path=' + $cms.$COOKIE_PATH();
        }

        if ($cms.$COOKIE_DOMAIN() !== '') {
            output += ';domain=' + $cms.$COOKIE_DOMAIN();
        }

        document.cookie = output;

        var read = $cms.readCookie(cookieName);

        if (read && (read !== cookieValue) && $cms.$DEV_MODE() && !alertedCookieConflict) {
            $cms.ui.alert('{!COOKIE_CONFLICT_DELETE_COOKIES;^}' + '... ' + document.cookie + ' (' + output + ')', '{!ERROR_OCCURRED;^}');
            alertedCookieConflict = true;
        }
    }

    /**
     * @param cookieName
     * @param defaultValue
     * @returns {string}
     */
    function readCookie(cookieName, defaultValue) {
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

        return decodeURIComponent(cookies.substring(startIdx + cookieName.length + 1, endIdx));
    }

    // Web animations API support (https://developer.mozilla.org/de/docs/Web/API/Element/animate)
    $cms.support.animation = ('animate' in emptyEl);
    /**
     * If the browser has support for an input[type=???]
     * @memberof $cms.support
     */
    $cms.support.inputTypes = {
        search: false, tel: false, url: false, email: false, datetime: false, date: false, month: false,
        week: false, time: false, 'datetime-local': false, number: false, range: false, color: false
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

            $cms.support.inputTypes[type] = Boolean(bool);
        }
    }());

    /**
     * @param windowOrNodeOrSelector
     * @returns { Window|Node }
     */
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

    /**
     * @param nodeOrSelector
     * @returns { Node }
     */
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

    /**
     * @param { string|Element } elementOrSelector
     * @returns { Element }
     */
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

    /**
     * @param el
     * @param property
     * @returns {*}
     */
    function computedStyle(el, property) {
        var cs = el.ownerDocument.defaultView.getComputedStyle(el);
        return (property !== undefined) ? cs.getPropertyValue(dasherize(property)) : cs;
    }

    var rgxIdSelector = /^\#[\w\-]+$/,
        rgxSimpleSelector = /^[\#\.]?[\w\-]+$/,
        // Special attributes that should be set via method calls
        methodAttributes = { val: true, css: true, html: true, text: true, data: true, width: true, height: true, offset: true },
        rgxNotWhite = /\S+/g;

    var DOM_ANIMATE_DEFAULT_DURATION = 400, // Milliseconds
        DOM_ANIMATE_DEFAULT_EASING = 'ease-in-out'; // Possible values: https://developer.mozilla.org/en-US/docs/Web/API/AnimationEffectTimingProperties/easing

    /** @namespace $cms */
    $cms.dom = extendDeep($cms.dom, /**@lends $cms.dom*/{
        domArg: domArg,
        nodeArg: nodeArg,
        elArg: elArg,
        
        /**
         * Ensures the passed `el` has an id and returns the id
         * @param { Element } el
         * @param {string} prefix
         * @return {string}
         */
        id: function id(el, prefix) {
            el = elArg(el);
            prefix = strVal(prefix) || 'rand-';
            
            if (el.id === '') {
                el.id = prefix + $cms.random();
            }
            
            return el.id;
        },
        
        /**
         * Returns a single matching child element, defaults to 'document' as parent
         * @method
         * @param context
         * @param id
         * @returns {*}
         */
        $id: function $id(context, id) {
            if (id === undefined) {
                id = context;
                context = document;
            } else {
                context = nodeArg(context);
            }
            id = strVal(id);

            return ('getElementById' in context) ? context.getElementById(id) : context.querySelector('#' + id);
        },
        /**
         * Returns a single matching child element, `context` defaults to 'document'
         * @memberof $cms.dom
         * @param context
         * @param selector
         * @returns {*}
         */
        $: function $(context, selector) {
            if (selector === undefined) {
                selector = context;
                context = document;
            } else {
                context = nodeArg(context);
            }
            selector = strVal(selector);

            return (rgxIdSelector.test(selector) && ('getElementById' in context)) ? context.getElementById(selector.substr(1)) : context.querySelector(selector);
        },
        /**
         * `$cms.dom.$$` is a CSS selector implementation which uses `document.querySelectorAll` and optimizes for some special cases, like `#id`, `.someclass` and `div`.
         * @memberof $cms.dom
         * @param context
         * @param selector
         * @returns {*}
         */
        $$: function $$(context, selector) {
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
        },
        /**
         * @memberof $cms.dom
         * @param context
         * @param selector
         * @returns { Element }
         */
        $last: function $last(context, selector) {
            return $cms.dom.$$(context, selector).pop();
        },
        /**
         * This one (3 dollars) also includes the context element (at offset 0) if it matches the selector
         * @memberof $cms.dom
         * @param context
         * @param selector
         * @returns { Array }
         */
        $$$: function $$$(context, selector) {
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
        },
        /**
         * @memberof $cms.dom
         * @param tag
         * @param properties
         * @param attributes
         * @returns { Element }
         */
        create: function create(tag, properties, attributes) {
            var el = document.createElement(strVal(tag));

            if (isObj(properties)) {
                each(properties, function (key, value) {
                    if (key in methodAttributes) {
                        $cms.dom[key](el, value);
                    } else if (isObj(el[key]) && isObj(value)) {
                        extendDeep(el[key], value);
                    } else {
                        el[key] = value;
                    }
                });
            }

            if (isObj(attributes)) {
                each(attributes, function (key, value) {
                    $cms.dom.attr(el, key, value)
                });
            }

            return el;
        },

        /**
         * Elements are considered visible if they consume space in the document. Visible elements have a width or height that is greater than zero.
         * Elements with visibility: hidden or opacity: 0 are considered to be visible, since they still consume space in the layout.
         * @memberof $cms.dom
         * @param el
         * @return {boolean} - Whether the passed element is visible
         */
        isVisible: function (el) {
            el = elArg(el);
            
            return Boolean($cms.dom.width(el) || $cms.dom.height(el)) && ($cms.dom.css(el, 'display') !== 'none');
        },
        /**
         * @memberof $cms.dom
         * @param el
         * @return {boolean} - Whether the passed element is visible
         */
        isHidden: function (el) {
            el = elArg(el);
            
            return !$cms.dom.isVisible(el);
        },
        /**
         * @memberof $cms.dom
         * @param el
         * @param value
         * @returns {*}
         */
        value: function value(el, value) {
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

            el.value = strVal((typeof value === 'function') ? value.call(el, $cms.dom.value(el), el) : value);
        },
        /**
         * Also triggers the 'change' event
         * @memberof $cms.dom
         * @param el
         * @param value
         * @returns {*}
         */
        changeValue: function changeValue(el, value) {
            el = elArg(el);

            el.value = strVal((typeof value === 'function') ? value.call(el, $cms.dom.value(el), el) : value);
            $cms.dom.trigger(el, 'change');
        },

        /**
         * Triggers the 'change' event after changing checked state
         * @memberof $cms.dom
         * @param el
         * @param bool
         * @returns {*}
         */
        changeChecked: function changeChecked(el, bool) {
            el = elArg(el);

            el.checked = strVal((typeof bool === 'function') ? bool.call(el, el.checked, el) : bool);
            $cms.dom.trigger(el, 'change');
        },
        /**
         * @memberof $cms.dom
         * @param node
         * @param newText
         * @returns {string|*}
         */
        text: function text(node, newText) {
            node = nodeArg(node);

            if (newText === undefined) {
                return node.textContent;
            }

            node.textContent = strVal((typeof newText === 'function') ? newText.call(node, node.textContent, node) : newText);
        }
    });
    
    var domDataMap = new WeakMap();
    
    function dataCache(el) {
        // Check if the el object already has a cache
        var value = domDataMap.get(el), key;
        if (!value) { // If not, create one with the dataset
            value = {};
            domDataMap.set(el, value);
            for (key in el.dataset) {
                dataAttr(el, key);
            }
        }

        return value;
    }
    
    function dataAttr(el, key) {
        var data, trimmed;
        // If nothing was found internally, try to fetch any
        // data from the HTML5 data-* attribute
        if (typeof (data = el.dataset[key]) === 'string') {
            trimmed = data.trim();

            if ((trimmed.startsWith('{') && trimmed.endsWith('}')) || (trimmed.startsWith('[') && trimmed.endsWith(']'))) { // Object or array?
                data = parseJson5(data);
            } else if ((Number(data).toString() === data) && isFinite(data)) { // Only convert to a number if it doesn't change the string
                data = Number(data);
            }

            // Make sure we set the data so it isn't changed later
            dataCache(el)[key] = data;
        }
        return data;
    }

    /**
     * Data retrieval and storage
     * @memberof $cms.dom
     * @param el
     * @param [key]
     * @param [value]
     * @returns {*}
     */
    $cms.dom.data = function data(el, key, value) {
        // Note: We have internalised caching here. You must not change data-* attributes manually and expect this API to pick up on it.

        var data, prop;

        el = elArg(el);

        // Gets all values
        if (key === undefined) {
            return dataCache(el);
        }

        // Sets multiple values
        if (isObj(key)) {
            data = dataCache(el);
            // Copy the properties one-by-one to the cache object
            for (prop in key) {
                data[camelCase(key)] = key[prop];
            }
            
            return data;
        }

        if (value === undefined) {
            // Attempt to get data from the cache
            // The key will always be camelCased in Data
            data = dataCache(el)[camelCase(key)];
            
            return (data !== undefined) ? data : dataAttr(el, key); // Check in el.dataset.* too
        }

        // Set the data...
        // We always store the camelCased key
        return dataCache(el)[camelCase(key)] = value;
    };

    /**
     * @memberof $cms.dom
     * @param owner
     * @param key
     */
    $cms.dom.removeData = function removeData(owner, key) {
        owner = elArg(owner);

        var i, cache = domDataMap.get(owner);

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

        // Remove if there's no more data
        if ((key === undefined) || !hasEnumerable(cache)) {
            domDataMap.delete(owner);
        }
    };

    /**
     * @memberof $cms.dom
     * @param win
     * @returns {number}
     */
    $cms.dom.getWindowWidth = function getWindowWidth(win) {
        return (win || window).innerWidth - 18;
    };

    /**
     * @memberof $cms.dom
     * @param win
     * @returns {number}
     */
    $cms.dom.getWindowHeight = function getWindowHeight(win) {
        return (win || window).innerHeight - 18;
    };

    /**
     * @memberof $cms.dom
     * @param win
     * @returns {number}
     */
    $cms.dom.getWindowScrollHeight = function getWindowScrollHeight(win) {
        win || (win = window);

        var rectA = win.document.body.parentElement.getBoundingClientRect(),
            rectB = win.document.body.getBoundingClientRect(),
            a = (rectA.bottom - rectA.top),
            b = (rectB.bottom - rectB.top);

        return (a > b) ? a : b;
    };

    /**
     * @memberof $cms.dom
     * @deprecated
     * @param el
     * @param {boolean} notRelative - If true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree.
     * @returns {number}
     */
    $cms.dom.findPosX = function findPosX(el, notRelative) {
        if (!el) {
            return 0;
        }

        el = elArg(el);
        notRelative = Boolean(notRelative);

        var left = el.getBoundingClientRect().left + window.pageXOffset;

        if (!notRelative) {
            var position;
            while (el) {
                if ($cms.dom.isCss(el, 'position', ['absolute', 'relative', 'fixed'])) {
                    left -= $cms.dom.findPosX(el, true);
                    break;
                }
                el = el.parentElement;
            }
        }

        return left;
    };

    /**
     * @memberof $cms.dom
     * @deprecated
     * @param el
     * @param {boolean} notRelative - If true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree.
     * @returns {number}
     */
    $cms.dom.findPosY = function findPosY(el, notRelative) {
        if (!el) {
            return 0;
        }

        el = elArg(el);
        notRelative = Boolean(notRelative);

        var top = el.getBoundingClientRect().top + window.pageYOffset;

        if (!notRelative) {
            var position;
            while (el != null) {
                if ($cms.dom.isCss(el, 'position', ['absolute', 'relative', 'fixed'])) {
                    top -= $cms.dom.findPosY(el, true);
                    break;
                }
                el = el.parentElement;
            }
        }
        return top;
    };

    /**
     * @memberof $cms.dom
     * @param obj
     * @param value
     * @returns {number}
     */
    $cms.dom.width = function width(obj, value) {
        var offset;

        obj = domArg(obj);

        if (value === undefined) {
            return isWindow(obj) ? obj.innerWidth :
                isDoc(obj) ? obj.documentElement.scrollWidth :
                    (offset = $cms.dom.offset(obj)) && (Number(offset.width) || 0);
        }

        $cms.dom.css(obj, 'width', (typeof value === 'function') ? value.call(obj, $cms.dom.width(obj)) : value);
    };

    /**
     * @memberof $cms.dom
     * @param obj
     * @param value
     * @returns {number}
     */
    $cms.dom.height = function height(obj, value) {
        var offset;

        obj = domArg(obj);

        if (value === undefined) {
            return isWindow(obj) ? obj.innerHeight :
                isDoc(obj) ? obj.documentElement.scrollHeight :
                    (offset = $cms.dom.offset(obj)) && (Number(offset.height) || 0);
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
            if (!el.ownerDocument.documentElement.contains(el)) {
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

    $cms.dom.hasElementLoaded = function hasElementLoaded(el) {
        el = elArg(el);
        
        return $cms.elementsLoaded.has(el);
    };

    /**
     * 
     * @param { Element|string } src
     * @return {*}
     */
    $cms.dom.hasScriptSrcLoaded = function hasScriptSrcLoaded(src) {
        var scriptEl = _findScriptBySrc(src);
        return (scriptEl != null) && $cms.dom.hasElementLoaded(scriptEl);
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

    /**
     * Check if the given element matches selector
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

        var parents = [];

        while (el = el.parentElement) {
            if ((selector === undefined) || $cms.dom.matches(el, selector)) {
                parents.push(el);
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

        while (el = el.parentElement) {
            if ((selector === undefined) || $cms.dom.matches(el, selector)) {
                return el;
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

            sibling = sibling.nextElementSibling;
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

            sibling = sibling.previousElementSibling;
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
        return (!!handler.del && (!focusinSupported && (handler.e in focusEvents))) || !!captureSetting;
    }

    function realEvent(type) {
        return (focusinSupported && focusEvents[type]) || type;
    }

    function addEvent(el, events, fn, selector, delegator, capture) {
        var id = uid(el),
            set = eventHandlers[id] || (eventHandlers[id] = []);

        events.split(/\s/).forEach(function (event) {
            var handler = parseEventName(event);
            handler.fn = fn;
            handler.sel = selector;
            handler.del = delegator;
            var callback = delegator || fn;
            handler.proxy = function proxy(e) {
                var result = callback.call(el, e, el);
                if (result === false) {
                    e.stopPropagation();
                    e.preventDefault();
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

    // Enable for debugging only
    $cms.dom.findHandlers = findHandlers;

    /**
     * @memberof $cms.dom
     * @param el { Window|Document|Element|string }
     * @param event {string|object}
     * @param [selector] {string|function}
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

        addEvent(el, event, callback, selector, delegator || autoRemove);
    };

    /**
     * @memberof $cms.dom
     * @param { Window|Document|Element|string } el
     * @param {string|object} event
     * @param {string|function} selector
     * @param {object|function} [data]
     * @param {function} [callback]
     */
    $cms.dom.one = function one(el, event, selector, data, callback) {
        el = domArg(el);

        return $cms.dom.on(el, event, selector, data, callback, 1);
    };

    /**
     * @memberof $cms.dom
     * @param { Window|Document|Element|string } el
     * @param {string|object} event
     * @param {string|function} [selector]
     * @param {function} [callback]
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

    var mouseEvents = { click: true, mousedown: true, mouseup: true, mousemove: true };

    /**
     * @memberof $cms.dom
     * @param {string} type
     * @param eventInit
     * @returns { Event }
     */
    $cms.dom.createEvent = function createEvent(type, eventInit) {
        var event = document.createEvent((type in mouseEvents) ? 'MouseEvents' : 'Events'),
            bubbles = true,
            cancelable = true;

        type = strVal(type);
        
        if (eventInit) {
            for (var key in eventInit) {
                if (key === 'bubbles') {
                    bubbles = !!eventInit.bubbles;
                } else if (key === 'cancelable') {
                    cancelable = !!eventInit.cancelable;
                } else if (key !== 'type') {
                    event[key] = eventInit[key];
                }
            }
        }
        event.initEvent(type, bubbles, cancelable);
        return event;
    };

    /**
     * NB: Unlike jQuery (but like Zepto.js), triggering the submit event using this doesn't actually submit the form, use $cms.dom.submit() for that.
     * @memberof $cms.dom
     * @param el
     * @param event
     * @param [eventInit]
     * @returns {boolean}
     */
    $cms.dom.trigger = function trigger(el, event, eventInit) {
        el = domArg(el);
        event = isObj(event) ? event : $cms.dom.createEvent(event, eventInit);

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

    /**
     * Called with 1 argument, it's similar to $cms.dom.trigger(el, 'submit') except this also 
     * actually submits the form using el.submit(), unless default is prevented by an event handler.
     * 
     * Called with 2 arguments, it's the same as $cms.dom.on(el, 'submit', callback).
     * @memberof $cms.dom
     * @param { string|HTMLFormElement } el
     * @param {function} [callback]
     */
    $cms.dom.submit = function submit(el, callback) {
        el = elArg(el);
        
        if (callback === undefined) {
            var defaultNotPrevented = $cms.dom.trigger(el, 'submit');

            if (defaultNotPrevented) {
                el.submit();
            }
            return;
        }
        
        $cms.dom.on(el, 'submit', callback);
    };

    /**
     * @param str
     * @returns {string}
     */
    function camelize(str) {
        return strVal(str).replace(/-+(.)?/g, function (match, chr) {
            return chr ? chr.toUpperCase() : '';
        });
    }

    /**
     * @param str
     * @returns {string}
     */
    function dasherize(str) {
        return strVal(str).replace(/::/g, '/')
            .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
            .replace(/([a-z\d])([A-Z])/g, '$1_$2')
            .replace(/_/g, '-')
            .toLowerCase();
    }

    var cssNumericProps = {'column-count': true, 'columns': true, 'font-weight': true, 'line-height': true, 'opacity': true, 'z-index': true, 'zoom': true};

    /**
     * @param name
     * @param value
     * @returns {*}
     */
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
                    props[prop] = (el.style[camelize(prop)] || cs.getPropertyValue(dasherize(prop)));
                });
                return props;
            }
        }

        var css = '';
        if (typeof property === 'string') {
            if (!value && (value !== 0)) {
                el.style.removeProperty(dasherize(property));
            } else {
                css = dasherize(property) + ':' + maybeAddPx(dasherize(property), value);
            }
        } else {
            for (key in property) {
                if (!property[key] && (property[key] !== 0)) {
                    el.style.removeProperty(dasherize(key));
                } else {
                    css += dasherize(key) + ':' + maybeAddPx(dasherize(key), property[key]) + ';';
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
     * @memberof $cms.dom
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
     * @param {function} [callback]
     */
    $cms.dom.fadeIn = function fadeIn(el, duration, callback) {
        el = elArg(el);

        if ((typeof duration === 'function') && (callback === undefined)) {
            callback = duration;
            duration = undefined;
        }

        duration = intVal(duration, DOM_ANIMATE_DEFAULT_DURATION);

        var target = /*Number($cms.dom.css(el, 'opacity')) || */1;

        $cms.dom.show(el);

        if ($cms.support.animation && (duration > 0)) { // Progressive enhancement using the web animations API
            var keyFrames = [{ opacity: 0 }, { opacity: target }],
                options = { duration : duration },
                animation = el.animate(keyFrames, options);

            animation.onfinish = function (e) {
                el.style.removeProperty('opacity');

                if (Number($cms.dom.css(el, 'opacity')) !== target) {
                    el.style.opacity = target;
                }

                if (callback) {
                    callback.call(el, e, el);
                }
            };
        } else {
            el.style.removeProperty('opacity');

            if (Number($cms.dom.css(el, 'opacity')) !== target) {
                el.style.opacity = target;
            }

            if (callback) {
                callback.call(el, null, el);
            }
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param {function} [callback]
     */
    $cms.dom.fadeOut = function fadeOut(el, duration, callback) {
        el = elArg(el);

        if ((typeof duration === 'function') && (callback === undefined)) {
            callback = duration;
            duration = undefined;
        }

        duration = intVal(duration, DOM_ANIMATE_DEFAULT_DURATION);

        if ($cms.support.animation && (duration > 0)) { // Progressive enhancement using the web animations API
            var keyFrames = [{ opacity: $cms.dom.css(el, 'opacity')}, { opacity: 0 }],
                options = { duration: duration, easing: DOM_ANIMATE_DEFAULT_EASING },
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
                callback.call(el, null, el);
            }
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param opacity
     * @param {function} [callback]
     */
    $cms.dom.fadeTo = function fadeTo(el, duration, opacity, callback) {
        el = elArg(el);

        if (opacity == null) { // Required argument
            $cms.fatal('$cms.dom.fadeTo(): Argument "opacity" is required.');
            return;
        }

        duration = intVal(duration, DOM_ANIMATE_DEFAULT_DURATION);
        opacity = numVal(opacity);

        $cms.dom.show(el);

        if ($cms.support.animation && (duration > 0)) { // Progressive enhancement using the web animations API
            var keyFrames = [{ opacity: $cms.dom.css(el, 'opacity')}, { opacity: opacity }],
                options = { duration: duration, easing: DOM_ANIMATE_DEFAULT_EASING },
                animation = el.animate(keyFrames, options);

            animation.onfinish = function (e) {
                el.style.opacity = opacity;
                if (callback) {
                    callback.call(el, e, el);
                }
            };
        } else {
            el.style.opacity = opacity;
            if (callback) {
                callback.call(el, null, el);
            }
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param {function} [callback]
     */
    $cms.dom.fadeToggle = function fadeToggle(el, duration, callback) {
        el = elArg(el);

        var fadeIn = $cms.dom.notDisplayed(el);

        if (fadeIn) {
            $cms.dom.fadeIn(el, duration, callback);
        } else {
            $cms.dom.fadeOut(el, duration, callback)
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param {function} [callback]
     */
    $cms.dom.slideDown = function slideDown(el, duration, callback) {
        el = elArg(el);

        if ((typeof duration === 'function') && (callback === undefined)) {
            callback = duration;
            duration = undefined;
        }

        duration = intVal(duration, DOM_ANIMATE_DEFAULT_DURATION);

        // Show element if it is hidden
        $cms.dom.show(el);

        // Get the element position to restore it then
        var prevPosition = el.style.position,
            prevVisibility = el.style.visibility;

        // place it so it displays as usually but hidden
        el.style.position = 'absolute';
        el.style.visibility = 'hidden';

        var startKeyframe = {
                height: 0,
                marginTop: 0,
                marginBottom: 0,
                paddingTop: 0,
                paddingBottom: 0
            },
            // Fetch natural height, margin, padding
            endKeyframe = {
                height: $cms.dom.css(el, 'height'),
                marginTop: $cms.dom.css(el, 'margin-top'),
                marginBottom: $cms.dom.css(el, 'margin-bottom'),
                paddingTop: $cms.dom.css(el, 'padding-top'),
                paddingBottom: $cms.dom.css(el, 'padding-bottom')
            };

        // Set initial css for animation
        el.style.position = prevPosition;
        el.style.visibility = prevVisibility;

        var prevOverflow = el.style.overflow;
        el.style.overflow = 'hidden';

        if ($cms.support.animation) { // Progressive enhancement using the web animations API
            var keyFrames = [startKeyframe, endKeyframe],
                options = { duration: duration, easing: DOM_ANIMATE_DEFAULT_EASING },
                animation = el.animate(keyFrames, options);

            animation.onfinish = function (e) {
                el.style.overflow = prevOverflow;
                if (callback) {
                    callback.call(el, e, el);
                }
            };
        } else {
            el.style.overflow = prevOverflow;
            if (callback) {
                callback.call(el, null, el);
            }
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param {function} [callback]
     */
    $cms.dom.slideUp = function slideUp(el, duration, callback) {
        el = elArg(el);

        if ((typeof duration === 'function') && (callback === undefined)) {
            callback = duration;
            duration = undefined;
        }

        duration = intVal(duration, DOM_ANIMATE_DEFAULT_DURATION);

        if ($cms.dom.notDisplayed(el)) {
            // Already hidden
            return;
        }

        var prevOverflow = el.style.overflow;
        el.style.overflow = 'hidden';

        var startKeyframe = {
                height: $cms.dom.css(el, 'height'),
                marginTop: $cms.dom.css(el, 'marginTop'),
                marginBottom: $cms.dom.css(el, 'marginBottom'),
                paddingTop: $cms.dom.css(el, 'paddingTop'),
                paddingBottom: $cms.dom.css(el, 'paddingBottom')
            },
            endKeyframe = {
                height: 0,
                marginTop: 0,
                marginBottom: 0,
                paddingTop: 0,
                paddingBottom: 0
            };

        if ($cms.support.animation) { // Progressive enhancement using the web animations API
            var keyFrames = [startKeyframe, endKeyframe],
                options = { duration: duration, easing: DOM_ANIMATE_DEFAULT_EASING },
                animation = el.animate(keyFrames, options);

            animation.onfinish = function (e) {
                el.style.overflow = prevOverflow;
                $cms.dom.hide(el);
                if (callback) {
                    callback.call(el, e, el);
                }
            };
        } else {
            el.style.overflow = prevOverflow;
            $cms.dom.hide(el);
            if (callback) {
                callback.call(el, null, el);
            }
        }
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param {function} [callback]
     */
    $cms.dom.slideToggle = function slideToggle(el, duration, callback) {
        el = elArg(el);

        var slideDown = $cms.dom.notDisplayed(el);

        if (slideDown) {
            $cms.dom.slideDown(el, duration, callback);
        } else {
            $cms.dom.slideUp(el, duration, callback)
        }
    };

    /**
     * Animate the loading of an iframe
     * @memberof $cms.dom
     * @param pf
     * @param frame
     * @param leaveGapTop
     * @param leaveHeight
     */
    $cms.dom.animateFrameLoad = function animateFrameLoad(pf, frame, leaveGapTop, leaveHeight) {
        if (!pf) {
            return;
        }

        leaveGapTop = Number(leaveGapTop) || 0;
        leaveHeight = Boolean(leaveHeight);

        if (!leaveHeight) {
            // Enough to stop jumping around
            pf.style.height = window.top.$cms.dom.getWindowHeight() + 'px';
        }

        $cms.dom.illustrateFrameLoad(frame);

        var ifuob = window.top.$cms.dom.$('#iframe_under'),
            extra = ifuob ? ((window !== window.top) ? $cms.dom.findPosY(ifuob) : 0) : 0;

        if (ifuob) {
            ifuob.scrolling = 'no';
        }

        if (window === window.top) {
            window.top.$cms.dom.smoothScroll($cms.dom.findPosY(pf) + extra - leaveGapTop);
        }
    };

    /**
     * @memberof $cms.dom
     * @param iframeId
     */
    $cms.dom.illustrateFrameLoad = function illustrateFrameLoad(iframeId) {
        var iframe = $cms.dom.$id(iframeId), doc;

        if (!$cms.$CONFIG_OPTION('enable_animations') || !iframe || !iframe.contentDocument || !iframe.contentDocument.documentElement) {
            return;
        }

        iframe.style.height = '80px';

        try {
            doc = iframe.contentDocument;
        } catch (e) {
            // May be connection interference somehow
            iframe.scrolling = 'auto';
            return;
        }

        doc.body.classList.add('website_body', 'main_website_faux');

        $cms.dom.html(doc.body, '<div aria-busy="true" class="spaced"><div class="ajax_loading"><img id="loading_image" class="vertical_alignment" src="' + $cms.img('{$IMG_INLINE*;,loading}') + '" alt="{!LOADING;^}" /> <span class="vertical_alignment">{!LOADING;^}<\/span><\/div><\/div>');

        // Stupid workaround for Google Chrome not loading an image on unload even if in cache
        setTimeout(function () {
            if (!doc.getElementById('loading_image')) {
                return;
            }

            var iDefault = doc.getElementById('loading_image'),
                iNew = doc.createElement('img');
            
            iNew.src = iDefault.src;
            iNew.className = iDefault.className;
            iNew.alt = iDefault.alt;
            iNew.id = iDefault.id;
            iDefault.parentNode.replaceChild(iNew, iDefault);
        });
    };

    /**
     * Smoothly scroll to another position on the page
     * @memberof $cms.dom
     * @param { HTMLElement|number} destY
     * @param [expectedScrollY]
     * @param [dir]
     * @param [eventAfter]
     */
    $cms.dom.smoothScroll = function smoothScroll(destY, expectedScrollY, dir, eventAfter) {
        if (isEl(destY)) {
            destY = $cms.dom.findPosY(destY, true);
        }
        
        if (!$cms.$CONFIG_OPTION('enable_animations')) {
            try {
                scrollTo(0, destY);
            } catch (ignore) {}
            return;
        }

        var scrollY = window.pageYOffset;
        if (typeof destY === 'string') {
            destY = $cms.dom.findPosY($cms.dom.$id(destY), true);
        }
        if (destY < 0) {
            destY = 0;
        }
        if ((expectedScrollY != null) && (expectedScrollY != scrollY)) {
            // We must terminate, as the user has scrolled during our animation and we do not want to interfere with their action -- or because our last scroll failed, due to us being on the last scroll screen already
            return;
        }

        dir = (destY > scrollY) ? 1 : -1;

        var distanceToGo = (destY - scrollY) * dir;
        var dist = Math.round(dir * (distanceToGo / 25));

        if (dir === -1 && dist > -25) {
            dist = -25;
        }
        if (dir === 1 && dist < 25) {
            dist = 25;
        }

        if (((dir === 1) && (scrollY + dist >= destY)) || ((dir === -1) && (scrollY + dist <= destY)) || (distanceToGo > 2000)) {
            try {
                scrollTo(0, destY);
            } catch (e) {}

            if (eventAfter) {
                eventAfter();
            }
            return;
        }

        try {
            scrollBy(0, dist);
        } catch (e) {
            return; // May be stopped by popup blocker
        }

        setTimeout(function () {
            $cms.dom.smoothScroll(destY, scrollY + dist, dir, eventAfter);
        }, 30);
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
        if (value != null) {
            try {
                el.setAttribute(name, value);
            } catch (e) {}
        } else {
            el.removeAttribute(name);
        }
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
        name = strVal(name);

        name.split(' ').forEach(function (attribute) {
            setAttr(el, attribute, null)
        });
    };

    var fragmentRE = /^\s*<(\w+|!)[^>]*>/,
        singleTagRE = /^<(\w+)\s*\/?>(?:<\/\1>|)$/,
        tagExpanderRE = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/ig,
        jsTypeRE = /^(?:|application\/javascript|text\/javascript)$/i,
        table = document.createElement('table'),
        tableRow = document.createElement('tr'),
        containers = {
            'tr': document.createElement('tbody'),
            'tbody': table, 'thead': table, 'tfoot': table,
            'td': tableRow, 'th': tableRow,
            '*': document.createElement('div')
        };

    // `$cms.dom.fragment` takes an html string and an optional tag name
    // to generate DOM nodes from the given html string.
    // The generated DOM nodes are returned as an array.
    // This function can be overridden in plugins for example to make
    // it compatible with browsers that don't support the DOM fully.
    $cms.dom.fragment = function(html, name, properties) {
        var container, dom, i;

        html = strVal(html);

        // A special case optimization for a single tag
        if (singleTagRE.test(html)) {
            dom = [document.createElement(RegExp.$1)];
        } else {
            html = html.replace(tagExpanderRE, "<$1></$2>");

            if (name === undefined) {
                name = fragmentRE.test(html) && RegExp.$1;
            }
            if (!(name in containers)) {
                name = '*';
            }

            container = containers[name];
            container.innerHTML = strVal(html);
            dom = toArray(container.childNodes);
            forEach(container.childNodes, function(child){
                container.removeChild(child)
            });

            for (i = 0; i < dom.length; i++) {
                // Cloning script[src] elements inserted using innerHTML is required for them to actually work
                if ((dom[i].localName === 'script') && jsTypeRE.test(dom[i].type) && dom[i].src) {
                    dom[i] = cloneScriptEl(dom[i]);
                }
            }
        }

        if (isPlainObj(properties)) {
            each(properties, function(key, value) {
                dom.forEach(function (node) {
                    if (!isEl(node)) {
                        return;
                    }

                    if (methodAttributes[key]) {
                        $cms.dom[key](node, value);
                    } else {
                        $cms.dom.attr(node, key, value)
                    }
                });
            })
        }

        return dom;
    };

    function traverseNode(node, func) {
        func(node);
        for (var i = 0, len = node.childNodes.length; i < len; i++) {
            traverseNode(node.childNodes[i], func);
        }
    }

    // Generates the `after`, `prepend`, `before` and `append` methods
    function createInsertionFunction(funcName) {
        var inside = (funcName === 'prepend') || (funcName === 'append');

        return function insertionFunction(target, /*...*/args) {  // `args` can be nodes, arrays of nodes and HTML strings
            target = elArg(target);
            args = toArray(arguments, 1);

            var nodes = [],
                newParent = inside ? target : target.parentNode;

            args.forEach(function(arg) {
                if (Array.isArray(arg)) {
                    arg.forEach(function(el) {
                        if (Array.isArray(el)) {
                            nodes = nodes.concat(el);
                        } else if (isNode(el)) {
                            nodes.push(el);
                        } else {
                            // Probably an html string
                            var html = strVal(el);
                            nodes = nodes.concat($cms.dom.fragment(html));
                        }
                    });
                } else if (isNode(arg)) {
                    nodes.push(arg);
                } else {
                    // Probably an html string
                    var html = strVal(arg);
                    nodes = nodes.concat($cms.dom.fragment(html));
                }
            });

            if (nodes.length < 1) {
                return Promise.resolve();
            }

            // convert all methods to a "before" operation
            target = funcName === 'after' ? target.nextSibling :
                funcName === 'prepend' ? target.firstChild :
                    funcName === 'before' ? target :
                        null;

            var parentInDocument = $cms.dom.contains(document.documentElement, newParent),
                scriptEls = [];

            nodes.forEach(function (node) {
                if (!isNode(node)) {
                    return;
                }

                if (!newParent) {
                    node.remove();
                    return;
                }
                // Insert the node
                newParent.insertBefore(node, target);

                if (!isEl(node)) {
                    return;
                }

                if (parentInDocument) {
                    var tmp = $cms.dom.$$$(node, 'script');
                    if (tmp.length > 0) {
                        scriptEls = scriptEls.concat(tmp);
                    }
                }
            });

            if (scriptEls.length > 0) {
                return new Promise(function (resolve) {
                    $cms.waitForResources(scriptEls).then(function () {
                        // Patch stupid DOM behavior when dynamically inserting inline script elements
                        scriptEls.forEach(function (el) {
                            if (!el.src && jsTypeRE.test(el.type)) {
                                var win = el.ownerDocument ? el.ownerDocument.defaultView : window;
                                win['eval'].call(win, el.innerHTML); // eval() call
                            }
                        });

                        nodes.forEach(function (node) {
                            if (isEl(node)) {
                                $cms.attachBehaviors(node);
                            }
                        });

                        resolve();
                    });
                });
            } 
                
            return new Promise(function (resolve) {
                setTimeout(function () {
                    nodes.forEach(function (node) {
                        if (isEl(node)) {
                            $cms.attachBehaviors(node);
                        }
                    });

                    resolve();
                }, 0);
            });
        };
    }

    function cloneScriptEl(scriptEl) {
        scriptEl = elArg(scriptEl);

        var clone = document.createElement('script');

        if (scriptEl.id) {
            clone.id = scriptEl.id
        }

        if (scriptEl.className) {
            clone.className = scriptEl.className;
        }

        if (scriptEl.dataset) {
            for (var key in scriptEl.dataset) {
                clone.dataset[key] = scriptEl.dataset[key];
            }
        }

        clone.defer = scriptEl.defer;
        clone.async = scriptEl.async;
        if (scriptEl.src !== '') {
            clone.src = scriptEl.src;
        }

        return clone;
    }

    /**
     * @memberof $cms.dom
     * @method
     * @param el
     * @param html
     * @returns { Promise }
     */
    $cms.dom.after = createInsertionFunction('after');

    /**
     * @memberof $cms.dom
     * @method
     * @param el
     * @param html
     * @returns { Promise }
     */
    $cms.dom.prepend = createInsertionFunction('prepend');

    /**
     * @memberof $cms.dom
     * @method
     * @param el
     * @param html
     * @returns { Promise }
     */
    $cms.dom.before = createInsertionFunction('before');

    /**
     * @memberof $cms.dom
     * @method append
     * @param el
     * @param html
     * @returns { Promise }
     */
    $cms.dom.append = createInsertionFunction('append');

    /**
     * @memberof $cms.dom
     * @param el
     */
    $cms.dom.empty = function empty(el) {
        el = elArg(el);

        forEach(el.children, function (child) {
            $cms.detachBehaviors(child);
        });

        el.innerHTML = '';
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param html
     * @returns {string|Promise}
     */
    $cms.dom.html = function html(el, html) {
        el = elArg(el);

        if (html === undefined) {
            return el.innerHTML;
        }

        $cms.dom.empty(el);
        return $cms.dom.append(el, html);
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param {string|Node|Array} html
     * @returns { Promise }
     */
    $cms.dom.replaceWith = function replaceWith(el, html) {
        el = elArg(el);
        
        var promise = $cms.dom.before(el, html);
        $cms.dom.remove(el);
        return promise;
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param text
     * @returns {string}
     */
    $cms.dom.text = function text(el, text) {
        el = elArg(el);

        if (text === undefined) {
            return el.textContent;
        }

        return el.textContent = strVal(text);
    };

    /**
     * @memberof $cms.dom
     * @param node
     */
    $cms.dom.remove = function remove(node) {
        node = nodeArg(node);

        // if (isEl(node)) {
        //     $cms.detachBehaviors(node);
        // }

        node.parentNode.removeChild(node);
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

        arrVal(form.elements).forEach(function (field) {
            name = field.name;
            if (name && (field.localName !== 'fieldset') && !field.disabled && !(field.type in serializeExcludedTypes) && (!['radio', 'checkbox'].includes(field.type) || field.checked)) {
                add($cms.dom.value(field));
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
            result.push(encodeURIComponent(el.name) + '=' + encodeURIComponent(el.value))
        });
        return result.join('&');
    };

    /**
     * Tabs
     * @memberof $cms.dom
     * @param [hash]
     */
    $cms.dom.findUrlTab = function findUrlTab(hash) {
        hash = strVal(hash, window.location.hash);

        if (hash.replace(/^#\!?/, '') !== '') {
            var tab = hash.replace(/^#/, '').replace(/^tab\_\_/, '');

            if ($cms.dom.$id('g_' + tab)) {
                $cms.ui.selectTab('g', tab);
            } else if ((tab.indexOf('__') !== -1) && ($cms.dom.$id('g_' + tab.substr(0, tab.indexOf('__'))))) {
                var old = hash;
                $cms.ui.selectTab('g', tab.substr(0, tab.indexOf('__')));
                window.location.hash = old;
            }
        }
    };

    /**
     * @memberof $cms.dom
     * @param src
     * @param url
     * @returns {boolean}
     */
    $cms.dom.matchesThemeImage = function matchesThemeImage(src, url) {
        return $cms.img(src) === $cms.img(url);
    };

    /**
     * Dimension functions
     * @memberof $cms.dom
     */
    $cms.dom.registerMouseListener = function registerMouseListener() {
        $cms.dom.registerMouseListener = noop; // ensure this function is only executed once

        document.documentElement.addEventListener('mousemove', function (e) {
            window.currentMouseX = getMouseX(e);
            window.currentMouseY = getMouseY(e);

            function getMouseX(event) {
                try {
                    if (event.pageX) {
                        return event.pageX;
                    } else if (event.clientX) {
                        return event.clientX + window.pageXOffset;
                    }
                } catch (ignore) {}

                return 0;
            }

            function getMouseY(event) {
                try {
                    if (event.pageY) {
                        return event.pageY;
                    } else if (event.clientY) {
                        return event.clientY + window.pageYOffset
                    }
                } catch (ignore) {}

                return 0;
            }
        });
    };

    /**
     * Automatic resizing to make frames seamless. Composr calls this automatically. Make sure id&name attributes are defined on your iframes!
     * @memberof $cms.dom
     * @deprecated
     * @param name
     * @param minHeight
     */
    $cms.dom.resizeFrame = function resizeFrame(name, minHeight) {
        minHeight = +minHeight || 0;

        var frameElement = $cms.dom.$id(name),
            frameWindow;

        if (window.frames[name] !== undefined) {
            frameWindow = window.frames[name];
        } else if (window.parent && window.parent.frames[name]) {
            frameWindow = window.parent.frames[name];
        } else {
            return;
        }

        if (frameElement && frameWindow && frameWindow.document && frameWindow.document.body) {
            var h = $cms.dom.getWindowScrollHeight(frameWindow);

            if ((h === 0) && (frameElement.parentElement.style.display === 'none')) {
                h = minHeight ? minHeight : 100;

                if (frameWindow.parent) {
                    setTimeout(function () {
                        if (frameWindow.parent) {
                            frameWindow.parent.$cms.dom.triggerResize();
                        }
                    }, 0);
                }
            }

            if ((h + 'px') !== frameElement.style.height) {
                if ((frameElement.scrolling !== 'auto' && frameElement.scrolling !== 'yes') || (frameElement.style.height == '0px')) {
                    frameElement.style.height = ((h >= minHeight) ? h : minHeight) + 'px';
                    if (frameWindow.parent) {
                        setTimeout(function () {
                            if (frameWindow.parent) {
                                frameWindow.parent.$cms.dom.triggerResize();
                            }
                        });
                    }
                    frameElement.scrolling = 'no';
                    frameWindow.onscroll = function (event) {
                        if (event == null) {
                            return false;
                        }
                        try {
                            frameWindow.scrollTo(0, 0);
                        } catch (ignore) {}
                    };
                }
            }
        }
    };

    /**
     * @memberof $cms.dom
     * @deprecated
     * @param andSubframes
     */
    $cms.dom.triggerResize = function triggerResize(andSubframes) {
        andSubframes = !!andSubframes;

        if (!window.parent || !window.parent.document) {
            return;
        }
        var i, iframes = window.parent.document.querySelectorAll('iframe');

        for (i = 0; i < iframes.length; i++) {
            if ((iframes[i].src === window.location.href) || (iframes[i].contentWindow === window) || ((iframes[i].id != '') && (window.parent.frames[iframes[i].id] !== undefined) && (window.parent.frames[iframes[i].id] == window))) {
                if (iframes[i].style.height === '900px') {
                    iframes[i].style.height = 'auto';
                }
                window.parent.$cms.dom.resizeFrame(iframes[i].name);
            }
        }

        if (andSubframes) {
            iframes = document.querySelectorAll('iframe');
            for (i = 0; i < iframes.length; i++) {
                if ((iframes[i].name != '') && ((iframes[i].classList.contains('expandable_iframe')) || (iframes[i].classList.contains('dynamic_iframe')))) {
                    $cms.dom.resizeFrame(iframes[i].name);
                }
            }
        }
    };

    /**
     * @param behaviors
     */
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
            priority = Number(behavior.priority) || 0;

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
     * @param context
     * @param settings
     */
    function attachBehaviors(context, settings) {
        if (!isDocOrEl(context)) {
            throw new TypeError('Invalid argument type: `context` must be of type HTMLDocument or HTMLElement');
        }

        settings || (settings = $cms.settings);

        //$cms.waitForResources($cms.dom.$$$(context, 'script[src]')).then(function () { // Wait for <script> dependencies to load
        // Execute all of them.
        var names = behaviorNamesByPriority();

        _attach(0);

        function _attach(i) {
            var name = names[i], ret;

            if (isObj($cms.behaviors[name]) && (typeof $cms.behaviors[name].attach === 'function')) {
                try {
                    ret = $cms.behaviors[name].attach(context, settings);
                    //$cms.inform('$cms.attachBehaviors(): attached behavior "' + name + '" to context', context);
                } catch (e) {
                    $cms.fatal('$cms.attachBehaviors(): Error while attaching behavior "' + name + '"  to', context, '\n', e);
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
        //});

        return Promise.all([]);
    }

    /**
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
                    //$cms.inform('$cms.detachBehaviors(): detached behavior "' + name + '" from context', context);
                } catch (e) {
                    $cms.fatal('$cms.detachBehaviors(): Error while detaching behavior \'' + name + '\' from', context, '\n', e);
                }
            }
        }

        return Promise.all([]);
    }

    var _blockDataCache = {};

    /**
     * This function will load a block, with options for parameter changes, and render the results in specified way - with optional callback support
     * @param url
     * @param newBlockParams
     * @param targetDiv
     * @param append
     * @param scrollToTopOfWrapper
     * @param postParams
     * @param inner
     * @param showLoadingAnimation
     * @returns { Promise }
     */
    function callBlock(url, newBlockParams, targetDiv, append, scrollToTopOfWrapper, postParams, inner, showLoadingAnimation) {
        url = strVal(url);
        newBlockParams = strVal(newBlockParams);
        scrollToTopOfWrapper = Boolean(scrollToTopOfWrapper);
        postParams = (postParams !== undefined) ? postParams : null;
        inner = Boolean(inner);
        showLoadingAnimation = (showLoadingAnimation !== undefined) ? Boolean(showLoadingAnimation) : true;

        if ((_blockDataCache[url] === undefined) && (newBlockParams !== '')) {
            // Cache start position. For this to be useful we must be smart enough to pass blank newBlockParams if returning to fresh state
            _blockDataCache[url] = $cms.dom.html(targetDiv);
        }

        var ajaxUrl = url;
        if (newBlockParams !== '') {
            ajaxUrl += '&block_map_sup=' + encodeURIComponent(newBlockParams);
        }

        ajaxUrl += '&utheme=' + $cms.$THEME();
        if ((_blockDataCache[ajaxUrl] !== undefined) && (postParams == null)) {
            // Show results from cache
            showBlockHtml(_blockDataCache[ajaxUrl], targetDiv, append, inner);
            return Promise.resolve();
        }

        
        var loadingWrapper = targetDiv;
        if (!loadingWrapper.id.includes('carousel_') && !$cms.dom.html(loadingWrapper).includes('ajax_loading_block') && showLoadingAnimation) {
            document.body.style.cursor = 'wait';
        }

        return new Promise(function (resolvePromise) {
            // Make AJAX call
            $cms.doAjaxRequest(ajaxUrl + $cms.$KEEP(), null, postParams).then(function (xhr) { // Show results when available
                callBlockRender(xhr, ajaxUrl, targetDiv, append, function () {
                    resolvePromise();
                }, scrollToTopOfWrapper, inner);
            });
        });

        function callBlockRender(rawAjaxResult, ajaxUrl, targetDiv, append, callback, scrollToTopOfWrapper, inner) {
            var newHtml = rawAjaxResult.responseText;
            _blockDataCache[ajaxUrl] = newHtml;

            // Remove loading animation if there is one
            var ajaxLoading = targetDiv.querySelector('.ajax_loading_block');
            if (ajaxLoading) {
                $cms.dom.remove(ajaxLoading.parentNode);
            }
            
            document.body.style.cursor = '';

            // Put in HTML
            showBlockHtml(newHtml, targetDiv, append, inner);

            // Scroll up if required
            if (scrollToTopOfWrapper) {
                try {
                    window.scrollTo(0, $cms.dom.findPosY(targetDiv));
                } catch (e) {}
            }

            // Defined callback
            if (callback != null) {
                callback();
            }
        }

        function showBlockHtml(newHtml, targetDiv, append, inner) {
            var rawAjaxGrowSpot = targetDiv.querySelector('.raw_ajax_grow_spot');
            if ((rawAjaxGrowSpot != null) && append) {  // If we actually are embedding new results a bit deeper
                targetDiv = rawAjaxGrowSpot;
            }
            if (append) {
                $cms.dom.append(targetDiv, newHtml);
            } else {
                if (inner) {
                    $cms.dom.html(targetDiv, newHtml);
                } else {
                    $cms.dom.replaceWith(targetDiv, newHtml);
                }
            }
        }
    }

    /**
     * Dynamic inclusion
     * @memberof $cms
     * @param snippetHook
     * @param [post]
     * @returns { Promise|string }
     */
    function loadSnippet(snippetHook, post) {
        snippetHook = strVal(snippetHook);

        var title = $cms.dom.html(document.querySelector('title')).replace(/ \u2013 .*/, ''),
            canonical = document.querySelector('link[rel="canonical"]'),
            url = canonical ? canonical.getAttribute('href') : window.location.href,
            url2 = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=' + snippetHook + '&url=' + encodeURIComponent($cms.protectURLParameter(url)) + '&title=' + encodeURIComponent(title) + $cms.$KEEP();

        return new Promise(function (resolve) {
            $cms.doAjaxRequest($cms.maintainThemeInLink(url2), null, post).then(function (xhr) {
                resolve(xhr.responseText);
            });
        });
    }

    /**
     * Update a URL to maintain the current theme into it
     * @param url
     * @returns {string}
     */
    function maintainThemeInLink(url) {
        url = $cms.url(url);
        
        if (!url.searchParams.has('utheme') && !url.searchParams.has('keep_theme')) {
            url.searchParams.set('utheme', $cms.$THEME());
        }

        return url.toString();
    }

    /**
     * Alternative to $cms.$KEEP(), accepts a URL and ensures not to cause duplicate keep_* params
     * @param url
     * @return {string}
     */
    function addKeepStub(url) {
        url = $cms.url(url);

        var keepSp = pageKeepSearchParams(true);
        
        eachIter(keepSp.entries(), function (entry) {
            var name = entry[0],
                value = entry[1];

            if (!url.searchParams.has(name)) {
                url.searchParams.set(name, value);
            }
        });
        
        return url.toString();
    }

    /**
     * Google Analytics tracking for links; particularly useful if you have no server-side stat collection
     * @memberof $cms
     * @param el
     * @param category
     * @param action
     * @param callback
     * @returns {boolean}
     */
    function gaTrack(el, category, action, callback) {
        if ($cms.$CONFIG_OPTION('google_analytics') && !$cms.$IS_STAFF() && !$cms.$IS_ADMIN()) {
            if (!category) {
                category = '{!URL;^}';
            }

            if (!action) {
                action = el ? el.href : '{!UNKNOWN;^}';
            }

            var okay = true;
            try {
                $cms.inform('Beacon', 'send', 'event', category, action);

                window.ga('send', 'event', category, action, { transport: 'beacon', hitCallback: callback});
            } catch(err) {
                okay = false;
            }

            if (okay) {
                if (el) { // pass as null if you don't want this
                    setTimeout(function () {
                        $cms.navigate(el);
                    }, 100);
                }

                return false; // Cancel event because we'll be submitting by ourselves, either via click_link or callback
            }
        }

        if (callback != null) {
            setTimeout(function () {
                callback();
            }, 100);
        }

        return null;
    }

    function googlePlusTrack() {
        $cms.gaTrack(null, 'social__google_plus');
    }

    /**
     * Used by audio CAPTCHA.
     * @param ob
     */
    function playSelfAudioLink(ob) {
        $cms.requireJavascript('sound').then(function () {
            window.soundManager.setup({
                url: $cms.baseUrl('data'),
                debugMode: false,
                onready: function () {
                    var soundObject = window.soundManager.createSound({url: ob.href});
                    if (soundObject) {
                        soundObject.play();
                    }
                }
            });
        });
    }

    // Serves as a flag to indicate any new errors are probably due to us transitioning
    window.unloaded = !!window.unloaded;
    window.addEventListener('beforeunload', function () {
        window.unloaded = true;
    });

    function undoStaffUnloadAction() {
        var pre = document.body.querySelectorAll('.unload_action');
        for (var i = 0; i < pre.length; i++) {
            pre[i].parentNode.removeChild(pre[i]);
        }
        var bi = $cms.dom.$id('main_website_inner');
        if (bi) {
            bi.classList.remove('site_unloading');
        }
    }

    /**
     * Making the height of a textarea match its contents
     * @param textAreaEl
     */
    function manageScrollHeight(textAreaEl) {
        var scrollHeight = textAreaEl.scrollHeight,
            offsetHeight = textAreaEl.offsetHeight,
            currentHeight = parseInt($cms.dom.css(textAreaEl, 'height')) || 0;

        if ((scrollHeight > 5) && (currentHeight < scrollHeight) && (offsetHeight < scrollHeight)) {
            $cms.dom.css(textAreaEl, {
                height: (scrollHeight + 2) + 'px',
                boxSizing: 'border-box',
                overflowY: 'auto'
            });
            $cms.dom.triggerResize();
        }
    }

    $cms.ui.openModalWindow = openModalWindow;
    /**
     * @param options
     * @returns { $cms.views.ModalWindow }
     */
    function openModalWindow(options) {
        return new $cms.views.ModalWindow(options);
    }

    /**
     * @param functionCallsArray
     * @param [thisRef]
     */
    function executeJsFunctionCalls(functionCallsArray, thisRef) {
        if (!Array.isArray(functionCallsArray)) {
            $cms.fatal('$cms.executeJsFunctionCalls(): Argument 1 must be an array, "' + typeName(functionCallsArray) + '" passed');
            return;
        }

        functionCallsArray.forEach(function (func) {
            var funcName, args;

            if (typeof func === 'string') {
                func = [func];
            }

            if (!Array.isArray(func) || (func.length < 1)) {
                $cms.fatal('$cms.executeJsFunctionCalls(): Invalid function call format', func);
                return;
            }

            funcName = strVal(func[0]);
            args = func.slice(1);

            if (typeof $cms.functions[funcName] === 'function') {
                $cms.functions[funcName].apply(thisRef, args);
            } else {
                $cms.fatal('$cms.executeJsFunctionCalls(): Function not found: $cms.functions.' + funcName);
            }
        });
    }

    /**
     * Find the main Composr window
     * @param anyLargeOk
     * @returns { Window }
     */
    function getMainCmsWindow(anyLargeOk) {
        anyLargeOk = !!anyLargeOk;

        if ($cms.dom.$('#main_website')) {
            return window;
        }

        if (anyLargeOk && ($cms.dom.getWindowWidth() > 300)) {
            return window;
        }

        try {
            if (window.parent && (window.parent !== window) && (window.parent.$cms.getMainCmsWindow !== undefined)) {
                return window.parent.$cms.getMainCmsWindow();
            }
        } catch (ignore) {}

        try {
            if (window.opener && (window.opener.$cms.getMainCmsWindow !== undefined)) {
                return window.opener.$cms.getMainCmsWindow();
            }
        } catch (ignore) {}

        return window;
    }

    /**
     * Find if the user performed the Composr "magic keypress" to initiate some action
     * @param event
     * @returns {boolean}
     */
    function magicKeypress(event) {
        // Cmd+Shift works on Mac - cannot hold down control or alt in Mac Firefox at least
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

    /**
     * Image rollover effects
     * @param rand
     * @param rollover
     */
    function createRollover(rand, rollover) {
        var img = rand && $cms.dom.$id(rand);
        if (!img) {
            return;
        }
        new Image().src = rollover; // precache

        $cms.dom.on(img, 'mouseover', activate);
        $cms.dom.on(img, 'click mouseout', deactivate);

        function activate() {
            img.oldSrc = img.getAttribute('src');
            if (img.origsrc !== undefined) {
                img.oldSrc = img.origsrc;
            }
            img.setAttribute('src', rollover);
        }

        function deactivate() {
            img.setAttribute('src', img.oldSrc);
        }
    }

    /**
     * Browser sniffing
     * @param {string} code
     * @returns {boolean}
     */
    function browserMatches(code) {
        var browser = navigator.userAgent.toLowerCase(),
            os = navigator.platform.toLowerCase() + ' ' + browser;

        var isSafari = browser.includes('applewebkit'),
            isChrome = browser.includes('chrome/'),
            isGecko = browser.includes('gecko') && !isSafari,
            _isIe = browser.includes('msie') || browser.includes('trident') || browser.includes('edge/');

        switch (code) {
            case 'touch_enabled':
                return ('ontouchstart' in docEl);
            case 'simplified_attachments_ui':
                return Boolean($cms.$CONFIG_OPTION('simplified_attachments_ui') && $cms.$CONFIG_OPTION('complex_uploader'));
            case 'non_concurrent':
                return browser.includes('iphone') || browser.includes('ipad') || browser.includes('android') || browser.includes('phone') || browser.includes('tablet');
            case 'ios':
                return browser.includes('iphone') || browser.includes('ipad');
            case 'android':
                return browser.includes('android');
            case 'wysiwyg':
                return !!$cms.$CONFIG_OPTION('wysiwyg');
            case 'windows':
                return os.includes('windows') || os.includes('win32');
            case 'mac':
                return os.includes('mac');
            case 'linux':
                return os.includes('linux');
            case 'ie':
                return _isIe;
            case 'chrome':
                return isChrome;
            case 'gecko':
                return isGecko;
            case 'safari':
                return isSafari;
        }

        // Should never get here
        return false;
    }

    // List of view options that can be set as properties.
    var viewOptionsList = { el: 1, id: 1, attributes: 1, className: 1, tagName: 1, events: 1 };

    $cms.View = View;
    /**
     * @memberof $cms
     * @class $cms.View
     */
    function View(params, viewOptions) {
        /** @member {number}*/
        this.uid = $cms.uid(this);
        /** @member {string} */
        this.tagName = 'div';
        /** @member { HTMLElement } */
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

        /**
         * Remove this view by taking the element out of the DOM.
         * @method
         */
        remove: function () {
            this._removeElement();
            return this;
        },

        /**
         * Remove this view's element from the document and all event listeners
         * attached to it. Exposed for subclasses using an alternative DOM
         * manipulation API.
         * @method
         */
        _removeElement: function () {
            this.el && this.el.parentNode && this.el.parentNode.removeChild(this.el);
        },

        /**
         * Change the view's element (`this.el` property) and re-delegate the
         * view's events on the new element.
         * @method
         */
        setElement: function (element) {
            this.undelegateEvents();
            this._setElement(element);
            this.delegateEvents();
            return this;
        },


        /**
         * Creates the `this.el` reference for this view using the
         * given `el`. `el` can be a CSS selector or an HTML element.
         * Subclasses can override this to utilize an
         * alternative DOM manipulation API and are only required to set the `this.el` property.
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

        /**
         * Set callbacks, where `this.events` is a hash of
         * *{"event selector": "callback"}*
         * pairs. Callbacks will be bound to the view, with `this` set properly.
         * Uses event delegation for efficiency.
         * Omitting the selector binds the event to `this.el`.
         * @method
         */
        delegateEvents: function (events) {
            var key, method, match;

            if (typeof events === 'function') {
                events = events.call(this);
            } else if ((events == null) && (typeof this.events === 'function')) {
                events = this.events();
            }

            if (typeof events !== 'object') {
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

        /**
         * Add a single event listener to the view's element (or a child element using `selector`).
         * @method
         */
        delegate: function (eventName, selector, listener) {
            //$cms.inform('$cms.View#delegate(): delegating event "' + eventName + '" for selector "' + selector + '" with listener', listener, 'and view', this);
            $cms.dom.on(this.el, (eventName + '.delegateEvents' + uid(this)), selector, listener);
            return this;
        },

        /**
         * Clears all callbacks previously bound to the view by `delegateEvents`.
         * You usually don't need to use this, but may wish to if you have multiple
         * views attached to the same DOM element.
         * @method
         */
        undelegateEvents: function () {
            if (this.el) {
                $cms.dom.off(this.el, '.delegateEvents' + uid(this));
            }
            return this;
        },

        /**
         * A finer-grained `undelegateEvents` for removing a single delegated event. `selector` and `listener` are both optional.
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
                    attrs.className = result(this, 'className');
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
     * 1:1 JavaScript port of PHP's urlencode function
     * Credit: http://locutus.io/php/url/urlencode/
     * @param str
     * @returns {string}
     */
    function urlencode(str) {
        return ((str != null) && (str = strVal(str))) ?
            encodeURIComponent(str)
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
        canTryUrlSchemes = (canTryUrlSchemes !== undefined) ? Boolean(canTryUrlSchemes) : $cms.canTryUrlSchemes();

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
        var i, character, ascii, out = '';

        str = strVal(str);

        for (i = 0; i < str.length; i++) {
            character = str[i];

            if (character in filterIdReplace) {
                out += filterIdReplace[character];
            } else {
                ascii = character.charCodeAt(0);

                if (
                    ((i !== 0) && (character === '_'))
                    || ((ascii >= 48) && (ascii <= 57))
                    || ((ascii >= 65) && (ascii <= 90))
                    || ((ascii >= 97) && (ascii <= 122))
                ) {
                    out += character;
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
                .replace(new RegExp('/<' + '/', 'g'), '&lt;')
                .replace(/>/g, '&gt;')
            : '';
    };

    /**
     * JS port of the escape_comcode()
     * @memberof $cms.filter
     * @param {string} str
     * @returns {string}
     */
    $cms.filter.comcode = function comcode(str) {
        return ((str != null) && (str = strVal(str))) ?
            str.replace(/\\/g, '\\\\')
                .replace(/"/g, '\\"')
            : '';
    };

    /**
     * Enforcing a session using AJAX
     * @memberof $cms.ui
     * @returns { Promise } - Resolves with a boolean indicating whether session confirmed or not
     */
    $cms.ui.confirmSession = function confirmSession() {
        var scriptUrl = '{$FIND_SCRIPT_NOHTTP;,confirm_session}' + $cms.$KEEP(true);

        return new Promise(function (resolvePromise) {
            $cms.doAjaxRequest(scriptUrl).then(function (xhr) {
                var username = xhr.responseText;

                if (username === '') { // Blank means success, no error - so we can call callback
                    resolvePromise(true);
                    return;
                }

                // But non blank tells us the username, and there is an implication that no session is confirmed for this login
                if (username === '{!GUEST;^}') { // Hmm, actually whole login was lost, so we need to ask for username too
                    $cms.ui.prompt('{!USERNAME;^}', '', null, '{!_LOGIN;^}').then(function (prompt) {
                        _confirmSession(function (bool) {
                            resolvePromise(bool);
                        }, prompt);
                    });
                    return;
                }

                _confirmSession(function (bool) {
                    resolvePromise(bool);
                }, username);
            });
        });


        function _confirmSession(callback, username) {
            $cms.ui.prompt(
                $cms.$CONFIG_OPTION('js_overlays') ? '{!ENTER_PASSWORD_JS_2;^}' : '{!ENTER_PASSWORD_JS;^}', '', null, '{!_LOGIN;^}', 'password'
            ).then(function (prompt) {
                if (prompt != null) {
                    $cms.doAjaxRequest(scriptUrl, null, 'login_username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(prompt)).then(function (xhr) {
                        if (xhr.responseText === '') { // Blank means success, no error - so we can call callback
                            callback(true);
                        } else {
                            _confirmSession(callback, username); // Recurse
                        }
                    });
                } else {
                    callback(false);
                }
            });
        }
    };

    /**
     * @memberof $cms.ui
     * @param id
     * @param tab
     * @param fromUrl
     * @param automated
     * @returns {boolean}
     */
    $cms.ui.selectTab = function selectTab(id, tab, fromUrl, automated) {
        fromUrl = !!fromUrl;
        automated = !!automated;

        if (!fromUrl) {
            var tabMarker = $cms.dom.$id('tab__' + tab.toLowerCase());
            if (tabMarker) {
                // For URL purposes, we will change URL to point to tab
                // HOWEVER, we do not want to cause a scroll so we will be careful
                tabMarker.id = '';
                window.location.hash = '#tab__' + tab.toLowerCase();
                tabMarker.id = 'tab__' + tab.toLowerCase();
            }
        }

        var tabs = [], i, element;

        element = $cms.dom.$id('t_' + tab);
        for (i = 0; i < element.parentElement.children.length; i++) {
            if (element.parentElement.children[i].id && (element.parentElement.children[i].id.substr(0, 2) === 't_')) {
                tabs.push(element.parentElement.children[i].id.substr(2));
            }
        }

        for (i = 0; i < tabs.length; i++) {
            element = $cms.dom.$id(id + '_' + tabs[i]);
            if (element) {
                $cms.dom.toggle(element, (tabs[i] === tab));

                if (tabs[i] === tab) {
                    if (window['load_tab__' + tab] === undefined) {
                        $cms.dom.fadeIn(element);
                    }
                }
            }

            element = $cms.dom.$id('t_' + tabs[i]);
            if (element) {
                element.classList.toggle('tab_active', tabs[i] === tab);
            }
        }

        if (window['load_tab__' + tab] !== undefined) {
            // Usually an AJAX loader
            window['load_tab__' + tab](automated, $cms.dom.$id(id + '_' + tab));
        }

        return false;
    };

    /**
     * Tooltips that can work on any element with rich HTML support
     * @memberof $cms.ui
     * @param el - the element
     * @param event - the event handler
     * @param tooltip - the text for the tooltip
     * @param width - width is in pixels (but you need 'px' on the end), can be null or auto
     * @param pic - the picture to show in the top-left corner of the tooltip; should be around 30px x 30px
     * @param height - the maximum height of the tooltip for situations where an internal but unusable scrollbar is wanted
     * @param bottom - set to true if the tooltip should definitely appear upwards; rarely use this parameter
     * @param noDelay - set to true if the tooltip should appear instantly
     * @param lightsOff - set to true if the image is to be dimmed
     * @param forceWidth - set to true if you want width to not be a max width
     * @param win - window to open in
     * @param haveLinks - set to true if we activate/deactivate by clicking due to possible links in the tooltip or the need for it to work on mobile
     */
    $cms.ui.activateTooltip = function activateTooltip(el, event, tooltip, width, pic, height, bottom, noDelay, lightsOff, forceWidth, win, haveLinks) {
        event || (event = {});
        width = strVal(width, 'auto');
        pic = strVal(pic);
        height = strVal(height, 'auto');
        bottom = !!bottom;
        noDelay = !!noDelay;
        lightsOff = !!lightsOff;
        forceWidth = !!forceWidth;
        win || (win = window);
        haveLinks = !!haveLinks;

        if ((el.deactivatedAt) && (Date.now() - el.deactivatedAt < 200)) {
            return;
        }

        if (!tooltip) {
            return;
        }

        if (window.isDoingADrag) {
            // Don't want tooltips appearing when doing a drag and drop operation
            return;
        }

        if (!el) {
            return;
        }

        if (!haveLinks && $cms.browserMatches('touch_enabled')) {
            return; // Too erratic
        }

        $cms.ui.clearOutTooltips(el.tooltipId);

        // Add in move/leave events if needed
        if (!haveLinks) {
            $cms.dom.on(el, 'mouseout.cmsTooltip', function () {
                $cms.ui.deactivateTooltip(el);
            });

            $cms.dom.on(el, 'mousemove.cmsTooltip', function () {
                $cms.ui.repositionTooltip(el, event, false, false, null, false, win);
            });
        } else {
            $cms.dom.on(window, 'click.cmsTooltip', function (e) {
                if ($cms.dom.$id(el.tooltipId) && $cms.dom.isDisplayed($cms.dom.$id(el.tooltipId))) {
                    $cms.ui.deactivateTooltip(el);
                }
            });
        }

        if (typeof tooltip === 'function') {
            tooltip = tooltip();
        }

        tooltip = strVal(tooltip);

        if (!tooltip) {
            return;
        }

        el.isOver = true;
        el.deactivatedAt = null;
        el.tooltipOn = false;
        el.initialWidth = width;
        el.haveLinks = haveLinks;

        var children = el.querySelectorAll('img');
        for (var i = 0; i < children.length; i++) {
            children[i].setAttribute('title', '');
        }

        var tooltipEl;
        if ((el.tooltipId != null) && ($cms.dom.$id(el.tooltipId))) {
            tooltipEl = $cms.dom.$id(el.tooltipId);
            tooltipEl.style.display = 'none';
            $cms.dom.empty(tooltipEl);
            setTimeout(function () {
                $cms.ui.repositionTooltip(el, event, bottom, true, tooltipEl, forceWidth);
            }, 0);
        } else {
            tooltipEl = document.createElement('div');
            tooltipEl.role = 'tooltip';
            tooltipEl.style.display = 'none';
            var rtPos = tooltip.indexOf('results_table');
            tooltipEl.className = 'tooltip ' + ((rtPos === -1 || rtPos > 100) ? 'tooltip_ownlayout' : 'tooltip_nolayout') + ' boxless_space' + (haveLinks ? ' have_links' : '');
            if (el.className.substr(0, 3) === 'tt_') {
                tooltipEl.className += ' ' + el.className;
            }
            if (tooltip.length < 50) {  // Only break words on long tooltips. Otherwise it messes with alignment.
                tooltipEl.style.wordWrap = 'normal';
            }
            if (forceWidth) {
                tooltipEl.style.width = width;
            } else {
                if (width === 'auto') {
                    var newAutoWidth = $cms.dom.getWindowWidth(win) - 30 - window.currentMouseX;
                    if (newAutoWidth < 150) { // For tiny widths, better let it slide to left instead, which it will as this will force it to not fit
                        newAutoWidth = 150;
                    }
                    tooltipEl.style.maxWidth = newAutoWidth + 'px';
                } else {
                    tooltipEl.style.maxWidth = width;
                }
                tooltipEl.style.width = 'auto';
            }
            if (height && (height !== 'auto')) {
                tooltipEl.style.maxHeight = height;
                tooltipEl.style.overflow = 'auto';
            }
            tooltipEl.style.position = 'absolute';
            tooltipEl.id = 't_' + $cms.random();
            el.tooltipId = tooltipEl.id;
            $cms.ui.repositionTooltip(el, event, bottom, true, tooltipEl, forceWidth);
            document.body.appendChild(tooltipEl);
        }
        tooltipEl.ac = el;

        if (pic) {
            var img = win.document.createElement('img');
            img.src = pic;
            img.className = 'tooltip_img';
            if (lightsOff) {
                img.classList.add('faded_tooltip_img');
            }
            tooltipEl.appendChild(img);
            tooltipEl.classList.add('tooltip_with_img');
        }

        var eventCopy = { // Needs to be copied as it will get erased on IE after this function ends
            'pageX': +event.pageX || 0,
            'pageY': +event.pageY || 0,
            'clientX': +event.clientX || 0,
            'clientY': +event.clientY || 0,
            'type': event.type || ''
        };

        setTimeout(function () {
            if (!el.isOver) {
                return;
            }

            if ((!el.tooltipOn) || (tooltipEl.childNodes.length === 0)) { // Some other tooltip jumped in and wiped out tooltip on a delayed-show yet never triggers due to losing focus during that delay
                $cms.dom.append(tooltipEl, tooltip);
            }

            el.tooltipOn = true;
            tooltipEl.style.display = 'block';
            if ((tooltipEl.style.width === 'auto') && ((tooltipEl.childNodes.length !== 1) || (tooltipEl.childNodes[0].nodeName.toLowerCase() !== 'img'))) {
                tooltipEl.style.width = ($cms.dom.contentWidth(tooltipEl) + 1/*for rounding issues from em*/) + 'px'; // Fix it, to stop the browser retroactively reflowing ambiguous layer widths on mouse movement
            }

            if (!noDelay) {
                // If delayed we will sub in what the currently known global mouse coordinate is
                eventCopy.pageX = win.currentMouseX;
                eventCopy.pageY = win.currentMouseY;
            }

            $cms.ui.repositionTooltip(el, eventCopy, bottom, true, tooltipEl, forceWidth, win);
        }, noDelay ? 0 : 666);
    };

    /**
     * @param el
     * @param event
     * @param bottom
     * @param starting
     * @param tooltipElement
     * @param forceWidth
     * @param win
     */
    $cms.ui.repositionTooltip = function repositionTooltip(el, event, bottom, starting, tooltipElement, forceWidth, win) {
        bottom = !!bottom;
        win || (win = window);

        if (!el.isOver) {
            return;
        }

        if (!starting) { // Real JS mousemove event, so we assume not a screen-reader and have to remove natural tooltip
            if (el.getAttribute('title')) {
                el.setAttribute('title', '');
            }

            if ((el.parentElement.localName === 'a') && (el.parentElement.getAttribute('title')) && ((el.localName === 'abbr') || (el.parentElement.getAttribute('title').includes('{!LINK_NEW_WINDOW;^}')))) {
                el.parentElement.setAttribute('title', '');  // Do not want second tooltips that are not useful
            }
        }

        if (!el.tooltipId) {
            if (el.onmouseover) {
                el.onmouseover(event);
            }
            return;
        }

        tooltipElement || (tooltipElement = $cms.dom.$id(el.tooltipId));

        if (!tooltipElement) {
            return;
        }

        var styleOffsetX = 9,
            styleOffsetY = (el.haveLinks) ? 18 : 9,
            x, y;

        // Find mouse position
        x = window.currentMouseX;
        y = window.currentMouseY;
        x += styleOffsetX;
        y += styleOffsetY;
        try {
            if (event.type) {
                if (event.type !== 'focus') {
                    el.doneNoneFocus = true;
                }

                if ((event.type === 'focus') && (el.doneNoneFocus)) {
                    return;
                }

                x = (event.type === 'focus') ? (win.pageXOffset + $cms.dom.getWindowWidth(win) / 2) : (window.currentMouseX + styleOffsetX);
                y = (event.type === 'focus') ? (win.pageYOffset + $cms.dom.getWindowHeight(win) / 2 - 40) : (window.currentMouseY + styleOffsetY);
            }
        } catch (ignore) {}
        // Maybe mouse position actually needs to be in parent document?
        try {
            if (event.target && (event.target.ownerDocument !== win.document)) {
                x = win.currentMouseX + styleOffsetX;
                y = win.currentMouseY + styleOffsetY;
            }
        } catch (ignore) {}

        // Work out which direction to render in
        var width = $cms.dom.contentWidth(tooltipElement);
        if (tooltipElement.style.width === 'auto') {
            if (width < 200) {
                // Give some breathing room, as might already have painfully-wrapped when it found there was not much space
                width = 200;
            }
        }
        var height = tooltipElement.offsetHeight;
        var xExcess = x - $cms.dom.getWindowWidth(win) - win.pageXOffset + width + 10/*magic tolerance factor*/;
        if (xExcess > 0) { // Either we explicitly gave too much width, or the width auto-calculated exceeds what we THINK is the maximum width in which case we have to re-compensate with an extra contingency to stop CSS/JS vicious disagreement cycles
            var xBefore = x;
            x -= xExcess + 20 + styleOffsetX;
            if (x < 100) { // Do not make it impossible to de-focus the tooltip
                x = (xBefore < 100) ? xBefore : 100;
            }
        }
        if (x < 0) {
            x = 0;
        }
        if (bottom) {
            tooltipElement.style.top = (y - height) + 'px';
        } else {
            var yExcess = y - $cms.dom.getWindowHeight(win) - win.pageYOffset + height + styleOffsetY;
            if (yExcess > 0) {
                y -= yExcess;
            }
            var scrollY = win.pageYOffset;
            if (y < scrollY) {
                y = scrollY;
            }
            tooltipElement.style.top = y + 'px';
        }
        tooltipElement.style.left = x + 'px';
    };

    /**
     * @param el
     * @param tooltipElement
     */
    $cms.ui.deactivateTooltip = function deactivateTooltip(el, tooltipElement) {
        if (el.isOver) {
            el.deactivatedAt = Date.now();
        }
        el.isOver = false;

        if (el.tooltipId == null) {
            return;
        }

        tooltipElement || (tooltipElement = $cms.dom.$('#' + el.tooltipId));

        if (tooltipElement) {
            $cms.dom.off(tooltipElement, 'mouseout.cmsTooltip');
            $cms.dom.off(tooltipElement, 'mousemove.cmsTooltip');
           // $cms.dom.off(window, 'click.cmsTooltip');
            $cms.dom.hide(tooltipElement);
        }
    };

    /**
     * @param tooltipBeingOpened
     */
    $cms.ui.clearOutTooltips = function clearOutTooltips(tooltipBeingOpened) {
        // Delete other tooltips, which due to browser bugs can get stuck
        var selector = '.tooltip';
        if (tooltipBeingOpened) {
            selector += ':not(#' + tooltipBeingOpened + ')';
        }
        $cms.dom.$$(selector).forEach(function (el) {
            $cms.ui.deactivateTooltip(el.ac, el);
        });
    };

    $cms.ready.push(function () {
        // Tooltips close on browser resize
        $cms.dom.on(window, 'resize', function () {
            $cms.ui.clearOutTooltips();
        });
    });

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

    /**
     * @memberof $cms.ui
     * @param question
     * @param callback
     * @param title
     * @param unescaped
     */
    $cms.ui.confirm = function confirm(question, callback, title, unescaped) {
        question = strVal(question);
        title = strVal(title, '{!Q_SURE;^}');
        unescaped = boolVal(unescaped);

        return new Promise(function (resolveConfirm) {
            if (!$cms.$CONFIG_OPTION('js_overlays')) {
                var bool = window.confirm(question);
                if (callback != null) {
                    callback(bool);
                }
                resolveConfirm(bool);
                return;
            }

            var myConfirm = {
                type: 'confirm',
                text: unescaped ? question : $cms.filter.html(question).replace(/\n/g, '<br />'),
                yesButton: '{!YES;^}',
                noButton: '{!NO;^}',
                cancelButton: null,
                title: title,
                yes: function () {
                    if (callback != null) {
                        callback(true);
                    }
                    resolveConfirm(true);
                },
                no: function () {
                    if (callback != null) {
                        callback(false);
                    }
                    resolveConfirm(false);
                },
                width: '450'
            };
            $cms.ui.openModalWindow(myConfirm);
        });
    };

    var currentAlertNotice,
        currentAlertTitle,
        currentAlertPromise;
    /**
     * @memberof $cms.ui
     * @param notice
     * @param title
     * @param unescaped
     * @returns { Promise }
     */
    $cms.ui.alert = function alert(notice, title, unescaped) {
        var options, 
            single = false;
        
        if (isObj(notice)) {
            options = notice;
            notice = strVal(options.notice);
            title = strVal(options.title) || '{!MESSAGE;^}';
            unescaped = Boolean(options.unescaped);
            single = Boolean(options.single);
        } else {
            notice = strVal(notice);
            title = strVal(title) || '{!MESSAGE;^}';
            unescaped = Boolean(unescaped);
        }
        
        if (single && (currentAlertNotice === notice) && (currentAlertTitle === title)) {
            return currentAlertPromise;
        }

        currentAlertNotice = notice;
        currentAlertTitle = title;
        currentAlertPromise = new Promise(function (resolveAlert) {
            if (!$cms.$CONFIG_OPTION('js_overlays')) {
                window.alert(notice);
                currentAlertNotice = null;
                currentAlertTitle = null;
                currentAlertPromise = null;
                resolveAlert();
                return;
            }

            var myAlert = {
                type: 'alert',
                text: unescaped ? notice : $cms.filter.html(notice).replace(/\n/g, '<br />'),
                yesButton: '{!INPUTSYSTEM_OK;^}',
                width: '600',
                yes: function () {
                    currentAlertNotice = null;
                    currentAlertTitle = null;
                    currentAlertPromise = null;
                    resolveAlert();
                },
                title: title,
                cancelButton: null
            };

            $cms.ui.openModalWindow(myAlert);
        });
        
        return currentAlertPromise;
    };

    /**
     * @memberof $cms.ui
     * @param question
     * @param defaultValue
     * @param callback
     * @param title
     * @param inputType
     * @returns { Promise }
     */
    $cms.ui.prompt = function prompt(question, defaultValue, callback, title, inputType) {
        question = strVal(question);
        defaultValue = strVal(defaultValue);
        inputType = strVal(inputType);

        return new Promise(function (resolvePrompt) {
            if (!$cms.$CONFIG_OPTION('js_overlays')) {
                var value = window.prompt(question, defaultValue);
                if (callback != null) {
                    callback(value);
                }
                resolvePrompt(value);
                return;
            }

            var myPrompt = {
                type: 'prompt',
                text: $cms.filter.html(question).replace(/\n/g, '<br />'),
                yesButton: '{!INPUTSYSTEM_OK;^}',
                cancelButton: '{!INPUTSYSTEM_CANCEL;^}',
                defaultValue: defaultValue,
                title: title,
                yes: function (value) {
                    if (callback != null) {
                        callback(value);
                    }
                    resolvePrompt(value);
                },
                cancel: function () {
                    if (callback != null) {
                        callback(null);
                    }
                    resolvePrompt(null);
                },
                width: '450'
            };
            if (inputType) {
                myPrompt.inputType = inputType;
            }
            $cms.ui.openModalWindow(myPrompt);
        });
    };

    /**
     * @memberof $cms.ui
     * @param url
     * @param name
     * @param options
     * @param callback
     * @param target
     * @param cancelText
     * @returns { Promise }
     */
    $cms.ui.showModalDialog = function showModalDialog(url, name, options, callback, target, cancelText) {
        url = strVal(url);
        name = strVal(name);
        options = strVal(options);
        target = strVal(target);
        cancelText = strVal(cancelText) || '{!INPUTSYSTEM_CANCEL;^}';

        return new Promise(function (resolveModal) {
            if (!$cms.$CONFIG_OPTION('js_overlays')) {
                if (!window.showModalDialog) {
                    throw new Error('$cms.ui.showModalDialog(): window.showModalDialog is not supported by the current browser');
                }

                options = options.replace('height=auto', 'height=520');

                var timer = new Date().getTime();
                try {
                    var result = window.showModalDialog(url, name, options);
                } catch (ignore) {
                    // IE gives "Access is denied" if popup was blocked, due to var result assignment to non-real window
                }
                var timerNow = new Date().getTime();
                if (timerNow - 100 > timer) { // Not popup blocked
                    if (result == null) {
                        if (callback != null) {
                            callback(null);
                        }
                        resolveModal(null);
                    } else {
                        if (callback != null) {
                            callback(result);
                        }
                        resolveModal(result);
                    }
                }
                return;
            }

            var width = null, height = null,
                scrollbars = null, unadorned = null;

            if (options) {
                var parts = options.split(/[;,]/g), i;
                for (i = 0; i < parts.length; i++) {
                    var bits = parts[i].split('=');
                    if (bits[1] !== undefined) {
                        if ((bits[0] === 'dialogWidth') || (bits[0] === 'width')) {
                            width = bits[1].replace(/px$/, '');
                        }

                        if ((bits[0] === 'dialogHeight') || (bits[0] === 'height')) {
                            if (bits[1] === '100%') {
                                height = '' + ($cms.dom.getWindowHeight() - 200);
                            } else {
                                height = bits[1].replace(/px$/, '');
                            }
                        }

                        if (((bits[0] === 'resizable') || (bits[0] === 'scrollbars')) && (scrollbars !== true)) {
                            scrollbars = ((bits[1] === 'yes') || (bits[1] === '1'))/*if either resizable or scrollbars set we go for scrollbars*/;
                        }

                        if (bits[0] === 'unadorned') {
                            unadorned = ((bits[1] === 'yes') || (bits[1] === '1'));
                        }
                    }
                }
            }

            if (url.includes(window.location.host)) {
                url += (!url.includes('?') ? '?' : '&') + 'overlay=1';
            }

            var myFrame = {
                type: 'iframe',
                finished: function (value) {
                    if (callback != null) {
                        callback(value)
                    }
                    resolveModal(value);
                },
                name: name,
                width: width,
                height: height,
                scrollbars: scrollbars,
                href: url.replace(/^https?:/, window.location.protocol),
                cancelButton: (unadorned !== true) ? cancelText : null
            };
            if (target) {
                myFrame.target = target;
            }
            $cms.ui.openModalWindow(myFrame);
        });
    };

    /**
     * @memberof $cms.ui
     * @param url
     * @param name
     * @param options
     * @param target
     * @param [cancelText]
     * @returns { Promise }
     */
    $cms.ui.open = function open(url, name, options, target, cancelText) {
        url = strVal(url);
        name = strVal(name);
        options = strVal(options);
        target = strVal(target);
        cancelText = strVal(cancelText, '{!INPUTSYSTEM_CANCEL;^}');

        return new Promise(function (resolveOpen) {
            if (!$cms.$CONFIG_OPTION('js_overlays')) {
                options = options.replace('height=auto', 'height=520');
                window.open(url, name, options);
                resolveOpen();
                return;
            }

            $cms.ui.showModalDialog(url, name, options, null, target, cancelText);
            resolveOpen();
        });
    };

    var tempDisabledButtons = {};
    /**
     * @memberof $cms.ui
     * @param btn
     * @param [permanent]
     */
    $cms.ui.disableButton = function disableButton(btn, permanent) {
        permanent = Boolean(permanent);

        if (btn.form && (btn.form.target === '_blank')) {
            return;
        }

        var uid = $cms.uid(btn),
            timeout, interval;

        setTimeout(function () {
            btn.style.cursor = 'wait';
            btn.disabled = true;
            if (!permanent) {
                tempDisabledButtons[uid] = true;
            }
        }, 20);

        if (!permanent) {
            timeout = setTimeout(enableDisabledButton, 5000);

            if (btn.form.target === 'preview_iframe') {
                interval = window.setInterval(function () {
                    if (window.frames['preview_iframe'].document && window.frames['preview_iframe'].document.body) {
                        if (interval != null) {
                            window.clearInterval(interval);
                            interval = null;
                        }
                        enableDisabledButton();
                    }
                }, 500);
            }

            $cms.dom.on(window, 'pagehide', enableDisabledButton);
        }

        function enableDisabledButton() {
            if (timeout != null) {
                clearTimeout(timeout);
                timeout = null;
            }

            if (tempDisabledButtons[uid]) {
                btn.disabled = false;
                btn.style.removeProperty('cursor');
                delete tempDisabledButtons[uid];
            }
        }
    };

    /**
     * @memberof $cms.ui
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
     * @memberof $cms.ui
     * @param permanent
     */
    $cms.ui.disableSubmitAndPreviewButtons = function disableSubmitAndPreviewButtons(permanent) {
        // [accesskey="u"] identifies submit button, [accesskey="p"] identifies preview button
        var buttons = $cms.dom.$$('input[accesskey="u"], button[accesskey="u"], input[accesskey="p"], button[accesskey="p"]');

        permanent = Boolean(permanent);

        buttons.forEach(function (btn) {
            if (!btn.disabled && !tempDisabledButtons[$cms.uid(btn)]/*We do not want to interfere with other code potentially operating*/) {
                $cms.ui.disableButton(btn, permanent);
            }
        });
    };
    
    $cms.ui.enableSubmitAndPreviewButtons = function enableSubmitAndPreviewButtons() {
        // [accesskey="u"] identifies submit button, [accesskey="p"] identifies preview button
        var buttons = $cms.dom.$$('input[accesskey="u"], button[accesskey="u"], input[accesskey="p"], button[accesskey="p"]');
        
        buttons.forEach(function (btn) {
            if (btn.disabled && !tempDisabledButtons[$cms.uid(btn)]/*We do not want to interfere with other code potentially operating*/) { 
                btn.style.cursor = '';
                btn.disabled = false;
            }
        });
    };

    /**
     * Originally _open_image_into_lightbox
     * @memberof $cms.ui
     * @param initialImgUrl
     * @param description
     * @param x
     * @param n
     * @param hasFullButton
     * @param isVideo
     * @returns { $cms.views.ModalWindow }
     */
    $cms.ui.openImageIntoLightbox = function openImageIntoLightbox(initialImgUrl, description, x, n, hasFullButton, isVideo) {
        hasFullButton = !!hasFullButton;
        isVideo = !!isVideo;

        // Set up overlay for Lightbox
        var lightboxCode = /** @lang HTML */' \
            <div style="text-align: center"> \
                <p class="ajax_loading" id="lightbox_image"><img src="' + $cms.img('{$IMG*;,loading}') + '" /></p> \
                <p id="lightbox_meta" style="display: none" class="associated_link associated_links_block_group"> \
                    <span id="lightbox_description">' + description + '</span> \
                    ' + ((n === null) ? '' : ('<span id="lightbox_position_in_set"><span id="lightbox_position_in_set_x">' + x + '</span> / <span id="lightbox_position_in_set_n">' + n + '</span></span>')) + ' \
                    ' + (isVideo ? '' : ('<span id="lightbox_full_link"><a href="' + $cms.filter.html(initialImgUrl) + '" target="_blank" title="{$STRIP_TAGS;^,{!SEE_FULL_IMAGE}} {!LINK_NEW_WINDOW;^}">{!SEE_FULL_IMAGE;^}</a></span>')) + ' \
                </p> \
            </div>';

        // Show overlay
        var myLightbox = {
                type: 'lightbox',
                text: lightboxCode,
                cancelButton: '{!INPUTSYSTEM_CLOSE;^}',
                width: '450', // This will be updated with the real image width, when it has loaded
                height: '300' // "
            },
            modal = $cms.ui.openModalWindow(myLightbox);

        // Load proper image
        setTimeout(function () { // Defer execution until the HTML was parsed
            if (isVideo) {
                var video = document.createElement('video');
                video.id = 'lightbox_image';
                video.className = 'lightbox_image';
                video.controls = 'controls';
                video.autoplay = 'autoplay';
                $cms.dom.html(video, initialImgUrl);
                video.addEventListener('loadedmetadata', function () {
                    $cms.ui.resizeLightboxDimensionsImg(modal, video, hasFullButton, true);
                });
            } else {
                var img = modal.topWindow.document.createElement('img');
                img.className = 'lightbox_image';
                img.id = 'lightbox_image';
                img.onload = function () {
                    $cms.ui.resizeLightboxDimensionsImg(modal, img, hasFullButton, false);
                };
                img.src = initialImgUrl;
            }
        }, 0);

        return modal;
    };

    /**
     * @memberof $cms.ui
     * @param modal
     * @param img
     * @param hasFullButton
     * @param isVideo
     */
    $cms.ui.resizeLightboxDimensionsImg = function resizeLightboxDimensionsImg(modal, img, hasFullButton, isVideo) {
        if (!modal.el) {
            /* Overlay closed already */
            return;
        }

        var realWidth = isVideo ? img.videoWidth : img.width,
            width = realWidth,
            realHeight = isVideo ? img.videoHeight : img.height,
            height = realHeight,
            lightboxImage = modal.topWindow.$cms.dom.$id('lightbox_image'),
            lightboxMeta = modal.topWindow.$cms.dom.$id('lightbox_meta'),
            lightboxDescription = modal.topWindow.$cms.dom.$id('lightbox_description'),
            lightboxPositionInSet = modal.topWindow.$cms.dom.$id('lightbox_position_in_set'),
            lightboxFullLink = modal.topWindow.$cms.dom.$id('lightbox_full_link'),
            sup = lightboxImage.parentNode;
        sup.removeChild(lightboxImage);
        if (sup.firstChild) {
            sup.insertBefore(img, sup.firstChild);
        } else {
            sup.appendChild(img);
        }
        sup.className = '';
        sup.style.textAlign = 'center';
        sup.style.overflow = 'hidden';

        dimsFunc();
        $cms.dom.on(window, 'resize', dimsFunc);

        function dimsFunc() {
            lightboxDescription.style.display = (lightboxDescription.firstChild) ? 'inline' : 'none';
            if (lightboxFullLink) {
                var showLightboxFullLink = !!(!isVideo && hasFullButton && ((realWidth > maxWidth) || (realHeight > maxHeight)));
                $cms.dom.toggle(lightboxFullLink, showLightboxFullLink);
            }
            var showLightboxMeta = !!((lightboxDescription.style.display === 'inline') || (lightboxPositionInSet !== null) || (lightboxFullLink && lightboxFullLink.style.display === 'inline'));
            $cms.dom.toggle(lightboxMeta, showLightboxMeta);

            // Might need to rescale using some maths, if natural size is too big
            var maxDims = _getMaxLightboxImgDims(modal, hasFullButton),
                maxWidth = maxDims[0],
                maxHeight = maxDims[1];

            if (width > maxWidth) {
                width = maxWidth;
                height = parseInt(maxWidth * realHeight / realWidth - 1);
            }

            if (height > maxHeight) {
                width = parseInt(maxHeight * realWidth / realHeight - 1);
                height = maxHeight;
            }

            img.width = width;
            img.height = height;
            modal.resetDimensions('' + width, '' + height, false, true); // Temporarily forced, until real height is known (includes extra text space etc)

            setTimeout(function () {
                modal.resetDimensions('' + width, '' + height, false);
            });

            if (img.parentElement) {
                img.parentElement.parentElement.parentElement.style.width = 'auto';
                img.parentElement.parentElement.parentElement.style.height = 'auto';
            }

            function _getMaxLightboxImgDims(modal, hasFullButton) {
                var maxWidth = modal.topWindow.$cms.dom.getWindowWidth() - 20,
                    maxHeight = modal.topWindow.$cms.dom.getWindowHeight() - 60;

                if (hasFullButton) {
                    maxHeight -= 120;
                }

                return [maxWidth, maxHeight];
            }
        }
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
     * @class $cms.views.ModalWindow
     * @extends $cms.View
     */
    function ModalWindow(params) {
        // Constants
        this.WINDOW_SIDE_GAP = $cms.$MOBILE() ? 5 : 25;
        this.WINDOW_TOP_GAP = 25; // Will also be used for bottom gap for percentage heights
        this.BOX_EAST_PERIPHERARY = 4;
        this.BOX_WEST_PERIPHERARY = 4;
        this.BOX_NORTH_PERIPHERARY = 4;
        this.BOX_SOUTH_PERIPHERARY = 4;
        this.VCENTRE_FRACTION_SHIFT = 0.5; // Fraction of remaining top gap also removed (as overlays look better slightly higher than vertical centre)
        this.LOADING_SCREEN_HEIGHT = 100;

        // Properties
        /** @type { Element }*/
        this.el =  null;
        /** @type { Element }*/
        this.overlayEl = null;
        /** @type { Element }*/
        this.containerEl = null;
        /** @type { Element }*/
        this.buttonContainerEl = null;
        this.returnValue = null;
        this.topWindow = null;
        this.iframeRestyleTimer = null;
        
        // Set params
        params = defaults({ // apply defaults
            type: 'alert',
            opacity: '0.5',
            width: 'auto',
            height: 'auto',
            title: '',
            text: '',
            yesButton: '{!YES;^}',
            noButton: '{!NO;^}',
            cancelButton: '{!INPUTSYSTEM_CANCEL;^}',
            yes: null,
            no: null,
            finished: null,
            cancel: null,
            href: null,
            scrollbars: null,
            defaultValue: null,
            target: '_self',
            inputType: 'text'
        }, params || {});

        for (var key in params) {
            this[key] = params[key];
        }
        
        this.topWindow = window.top;
        this.opened = true;

        ModalWindow.base(this, 'constructor', arguments);
    }

    $cms.inherits(ModalWindow, $cms.View, /**@lends $cms.views.ModalWindow#*/ {
        events: function events() {
            return {
                'click .js-onclick-do-option-yes': 'doOptionYes',
                'click .js-onclick-do-option-no': 'doOptionNo',
                'click .js-onclick-do-option-cancel': 'doOptionCancel',
                'click .js-onclick-do-option-finished': 'doOptionFinished',
                'click .js-onclick-do-option-left': 'doOptionLeft',
                'click .js-onclick-do-option-right': 'doOptionRight',
            }
        },

        doOptionYes: function doOptionYes() {
            this.option('yes')
        },

        doOptionNo: function doOptionNo() {
            this.option('no')
        },

        doOptionCancel: function doOptionCancel() {
            this.option('cancel')
        },

        doOptionFinished: function doOptionFinished() {
            this.option('finished')
        },

        doOptionLeft: function doOptionLeft() {
            this.option('left')
        },

        doOptionRight: function doOptionRight() {
            this.option('right')
        },
        
        _setElement: function _setElement() {
            var button;

            this.topWindow.overlayZIndex || (this.topWindow.overlayZIndex = 999999); // Has to be higher than plupload, which is 99999

            this.el = $cms.dom.create('div', { // Black out the background
                'className': 'js-modal-background js-modal-type-' + this.type,
                'css': {
                    'background': 'rgba(0,0,0,0.7)',
                    'zIndex': this.topWindow.overlayZIndex++,
                    'overflow': 'hidden',
                    'position': $cms.$MOBILE() ? 'absolute' : 'fixed',
                    'left': '0',
                    'top': '0',
                    'width': '100%',
                    'height': '100%'
                }
            });
            
            this.topWindow.document.body.appendChild(this.el);

            this.overlayEl = this.el.appendChild($cms.dom.create('div', { // The main overlay
                'className': 'box overlay js-modal-overlay ' + this.type,
                'role': 'dialog',
                'css': {
                    // This will be updated immediately in resetDimensions
                    'position': $cms.$MOBILE() ? 'static' : 'fixed',
                    'margin': '0 auto' // Centering for iOS/Android which is statically positioned (so the container height as auto can work)
                }
            }));

            this.containerEl = this.overlayEl.appendChild($cms.dom.create('div', {
                'className': 'box_inner js-modal-container',
                'css': {
                    'width': 'auto',
                    'height': 'auto'
                }
            }));

            var overlayHeader = null;
            if (this.title !== '' || this.type === 'iframe') {
                overlayHeader = $cms.dom.create('h3', {
                    'html': this.title,
                    'css': {
                        'display': (this.title === '') ? 'none' : 'block'
                    }
                });
                this.containerEl.appendChild(overlayHeader);
            }

            if (this.text !== '') {
                if (this.type === 'prompt') {
                    var div = $cms.dom.create('p');
                    div.appendChild($cms.dom.create('label', {
                        'htmlFor': 'overlay_prompt',
                        'html': this.text
                    }));
                    this.containerEl.appendChild(div);
                } else {
                    this.containerEl.appendChild($cms.dom.create('div', {
                        'html': this.text
                    }));
                }
            }

            this.buttonContainerEl = $cms.dom.create('p', {
                'className': 'proceed_button js-modal-button-container'
            });

            var self = this;

            $cms.dom.on(this.overlayEl, 'click', function (e) {
                if ($cms.$MOBILE() && (self.type === 'lightbox')) { // IDEA: Swipe detect would be better, but JS does not have this natively yet
                    self.option('right');
                }
            });

            switch (this.type) {
                case 'iframe':
                    var iframeWidth = (this.width.match(/^[\d\.]+$/) !== null) ? ((this.width - 14) + 'px') : this.width,
                        iframeHeight = (this.height.match(/^[\d\.]+$/) !== null) ? (this.height + 'px') : ((this.height === 'auto') ? (this.LOADING_SCREEN_HEIGHT + 'px') : this.height);

                    var iframe = $cms.dom.create('iframe', {
                        'frameBorder': '0',
                        'scrolling': 'no',
                        'title': '',
                        'name': 'overlay_iframe',
                        'id': 'overlay_iframe',
                        'className': 'js-modal-overlay-iframe',
                        'allowTransparency': 'true',
                        //'seamless': 'seamless',// Not supported, and therefore testable yet. Would be great for mobile browsing.
                        'css': {
                            'width': iframeWidth,
                            'height': iframeHeight,
                            'background': 'transparent'
                        }
                    });

                    this.containerEl.appendChild(iframe);

                    $cms.dom.animateFrameLoad(iframe, 'overlay_iframe', 50, true);

                    setTimeout(function () {
                        if (self.el) {
                            $cms.dom.on(self.el, 'click', function (e) { 
                                if (!self.containerEl.contains(e.target)) {
                                    // Background overlay clicked
                                    self.option('finished');
                                }
                            });
                        }
                    }, 1000);

                    $cms.dom.on(iframe, 'load', function () {
                        if ($cms.dom.hasIframeAccess(iframe) && (!iframe.contentDocument.querySelector('h1')) && (!iframe.contentDocument.querySelector('h2'))) {
                            if (iframe.contentDocument.title) {
                                $cms.dom.html(overlayHeader, $cms.filter.html(iframe.contentDocument.title));
                                $cms.dom.show(overlayHeader);
                            }
                        }
                    });

                    // Fiddle it, to behave like a popup would
                    setTimeout(function () {
                        $cms.dom.illustrateFrameLoad('overlay_iframe');
                        iframe.src = self.href;
                        self.makeFrameLikePopup(iframe);

                        if (self.iframeRestyleTimer == null) { // In case internal nav changes
                            self.iframeRestyleTimer = setInterval(function () {
                                self.makeFrameLikePopup(iframe);
                            }, 300);
                        }
                    }, 0);
                    break;

                case 'lightbox':
                case 'alert':
                    if (this.yes) {
                        button = $cms.dom.create('button', {
                            'type': 'button',
                            'html': this.yesButton,
                            'className': 'buttons__proceed button_screen_item js-onclick-do-option-yes'
                        });

                        this.buttonContainerEl.appendChild(button);
                    }
                    setTimeout(function () {
                        if (self.el) {
                            $cms.dom.on(self.el, 'click', function (e) {
                                if (!self.containerEl.contains(e.target)) {
                                    // Background overlay clicked
                                    if (self.yes) {
                                        self.option('yes');
                                    } else {
                                        self.option('cancel')
                                    }
                                }
                            });
                        }
                    }, 1000);
                    break;

                case 'confirm':
                    button = $cms.dom.create('button', {
                        'type': 'button',
                        'html': this.yesButton,
                        'className': 'buttons__yes button_screen_item js-onclick-do-option-yes',
                        'style': 'font-weight: bold;'
                    });
                    this.buttonContainerEl.appendChild(button);
                    button = $cms.dom.create('button', {
                        'type': 'button',
                        'html': this.noButton,
                        'className': 'buttons__no button_screen_item js-onclick-do-option-no'
                    });
                    this.buttonContainerEl.appendChild(button);
                    break;

                case 'prompt':
                    this.input = $cms.dom.create('input', {
                        'name': 'prompt',
                        'id': 'overlay_prompt',
                        'type': this.inputType,
                        'size': '40',
                        'className': 'wide_field',
                        'value': (this.defaultValue === null) ? '' : this.defaultValue
                    });
                    var inputWrap = $cms.dom.create('div');
                    inputWrap.appendChild(this.input);
                    this.containerEl.appendChild(inputWrap);

                    if (this.yes) {
                        button = $cms.dom.create('button', {
                            'type': 'button',
                            'html': this.yesButton,
                            'className': 'buttons__yes button_screen_item js-onclick-do-option-yes',
                            'css': {
                                'font-weight': 'bold'
                            }
                        });
                        this.buttonContainerEl.appendChild(button);
                    }
                    
                    setTimeout(function () {
                        if (self.el) {
                            $cms.dom.on(self.el, 'click', function (e) {
                                if (!self.containerEl.contains(e.target)) {
                                    // Background overlay clicked
                                    self.option('cancel');
                                }
                            });
                        }
                    }, 1000);
                    break;
            }

            // Cancel button handled either via button in corner (if there's no other buttons) or another button in the panel (if there's other buttons)
            if (this.cancelButton) {
                if (this.buttonContainerEl.firstElementChild) {
                    button = $cms.dom.create('button', {
                        'type': 'button',
                        'html': this.cancelButton,
                        'className': 'button_screen_item buttons__cancel ' + (this.cancel ? 'js-onclick-do-option-cancel' : 'js-onclick-do-option-finished')
                    });
                    this.buttonContainerEl.appendChild(button);
                } else {
                    button = $cms.dom.create('img', {
                        'src': $cms.img('{$IMG;,button_lightbox_close}'),
                        'alt': this.cancelButton,
                        'className': 'overlay_close_button ' + (this.cancel ? 'js-onclick-do-option-cancel' : 'js-onclick-do-option-finished')
                    });
                    this.containerEl.appendChild(button);
                }
            }

            // Put together
            if (this.buttonContainerEl.firstElementChild) {
                if (this.type === 'iframe') {
                    this.containerEl.appendChild($cms.dom.create('hr', {'className': 'spaced_rule'}));
                }
                this.containerEl.appendChild(this.buttonContainerEl);
            }

            // Handle dimensions
            this.resetDimensions(this.width, this.height, true);
            $cms.dom.on(window, 'resize', function () {
                self.resetDimensions(self.width, self.height, false);
            });

            // Focus first button by default
            if (this.input) {
                setTimeout(function () {
                    self.input.focus();
                });
            } else if (this.el.querySelector('button')) {
                this.el.querySelector('button').focus();
            }

            setTimeout(function () { // Timeout needed else keyboard activation of overlay opener may cause instant shutdown also
                $cms.dom.on(document, 'keyup.modalWindow' + this.uid, self.keyup.bind(self));
                $cms.dom.on(document, 'mousemove.modalWindow' + this.uid, self.mousemove.bind(self));
            }, 100);
        },

        keyup: function keyup(e) {
            if (e.key === 'ArrowLeft') {
                this.option('left');
            } else if (e.key === 'ArrowRight') {
                this.option('right');
            } else if ((e.key === 'Enter') && (this.yes)) {
                this.option('yes');
            } else if ((e.key === 'Enter') && (this.finished)) {
                this.option('finished');
            } else if ((e.key === 'Escape') && (this.cancelButton) && /^(prompt|confirm|lightbox|alert)$/.test(this.type)) {
                this.option('cancel');
            }
        },

        mousemove: function mousemove() {
            var self = this;
            if (!this.overlayEl.classList.contains('mousemove')) {
                this.overlayEl.classList.add('mousemove');
                setTimeout(function () {
                    if (self.overlayEl) {
                        self.overlayEl.classList.remove('mousemove');
                    }
                }, 2000);
            }
        },
        // Methods...
        close: function () {
            if (this.el) {
                this.topWindow.document.body.style.overflow = '';

                this.el.remove();
                this.el = null;

                $cms.dom.off(document, 'keyup.modalWindow' + this.uid);
                $cms.dom.off(document, 'mousemove.modalWindow' + this.uid);
            }
            this.opened = false;
        },

        option: function (method) {
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
                this.close();
            }
        },

        /**
         * @param {string} width
         * @param {string} height
         * @param {boolean} [init]
         * @param {boolean} [forceHeight]
         */
        resetDimensions: function (width, height, init, forceHeight) {
            width = strVal(width);
            height = strVal(height);
            init = Boolean(init);
            forceHeight = Boolean(forceHeight);

            if (!this.el) {
                return;
            }
            
            var topPageHeight = this.topWindow.$cms.dom.getWindowScrollHeight(),
                topWindowWidth = this.topWindow.$cms.dom.getWindowWidth(),
                topWindowHeight = this.topWindow.$cms.dom.getWindowHeight();
                
            var bottomGap = this.WINDOW_TOP_GAP;
            if (this.buttonContainerEl.firstElementChild) {
                bottomGap += this.buttonContainerEl.offsetHeight;
            }

            if (!forceHeight) {
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
                if ((parseInt(width) > topWindowWidth - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY) || (width === 'auto')) {
                    width = '' + (topWindowWidth - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY);
                }
            }

            // Auto width means full width
            if (width === 'auto') {
                width = '' + (topWindowWidth - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY);
            }
            // NB: auto height feeds through without a constraint (due to infinite growth space), with dynamic adjustment for iframes

            // Calculate percentage sizes
            var match;
            match = width.match(/^([\d\.]+)%$/);
            if (match !== null) {
                width = '' + (parseFloat(match[1]) * (topWindowWidth - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY));
            }
            match = height.match(/^([\d\.]+)%$/);
            if (match !== null) {
                height = '' + (parseFloat(match[1]) * (topPageHeight - this.WINDOW_TOP_GAP - bottomGap - this.BOX_NORTH_PERIPHERARY - this.BOX_SOUTH_PERIPHERARY));
            }

            // Work out box dimensions
            var boxWidth, boxHeight;
            if (width.match(/^\d+$/) !== null) {
                boxWidth = width + 'px';
            } else {
                boxWidth = width;
            }
            if (height.match(/^\d+$/) !== null) {
                boxHeight = height + 'px';
            } else {
                boxHeight = height;
            }

            // Save into HTML
            var detectedBoxHeight;
            this.overlayEl.style.width = boxWidth;
            this.overlayEl.style.height = boxHeight;
            var iframe = this.el.querySelector('iframe');

            if ($cms.dom.hasIframeAccess(iframe) && (iframe.contentDocument.body)) { // Balance iframe height
                iframe.style.width = '100%';
                if (height === 'auto') {
                    if (!init) {
                        detectedBoxHeight = $cms.dom.getWindowScrollHeight(iframe.contentWindow);
                        iframe.style.height = detectedBoxHeight + 'px';
                    }
                } else {
                    iframe.style.height = '100%';
                }
            }

            // Work out box position
            if (!detectedBoxHeight) {
                detectedBoxHeight = this.overlayEl.offsetHeight;
            }
            var boxPosTop, boxPosLeft;

            if (boxHeight === 'auto') {
                if (init) {
                    boxPosTop = (topWindowHeight / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (this.LOADING_SCREEN_HEIGHT / 2) + this.WINDOW_TOP_GAP; // This is just temporary
                } else {
                    boxPosTop = (topWindowHeight / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (detectedBoxHeight / 2) + this.WINDOW_TOP_GAP;
                }

                if (iframe) { // Actually, for frames we'll put at top so things don't bounce about during loading and if the frame size changes
                    boxPosTop = this.WINDOW_TOP_GAP;
                }
            } else {
                boxPosTop = (topWindowHeight / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (parseInt(boxHeight) / 2) + this.WINDOW_TOP_GAP;
            }
            if (boxPosTop < this.WINDOW_TOP_GAP) {
                boxPosTop = this.WINDOW_TOP_GAP;
            }
            boxPosLeft = ((topWindowWidth / 2) - (parseInt(boxWidth) / 2));

            // Save into HTML
            this.overlayEl.style.top = boxPosTop + 'px';
            this.overlayEl.style.left = boxPosLeft + 'px';

            var doScroll = false;

            // Absolute positioning instead of fixed positioning
            if ($cms.$MOBILE() || (detectedBoxHeight > topWindowHeight) || (this.el.style.position === 'absolute'/*don't switch back to fixed*/)) {
                var wasFixed = (this.el.style.position === 'fixed');

                this.el.style.position = 'absolute';
                this.el.style.height = ((topPageHeight > (detectedBoxHeight + bottomGap + boxPosLeft)) ? topPageHeight : (detectedBoxHeight + bottomGap + boxPosLeft)) + 'px';
                this.topWindow.document.body.style.overflow = '';

                if (!$cms.$MOBILE()) {
                    this.overlayEl.style.position = 'absolute';
                    this.overlayEl.style.top = this.WINDOW_TOP_GAP + 'px';
                }

                if (init || wasFixed) {
                    doScroll = true;
                }

                if (iframe && ($cms.dom.hasIframeAccess(iframe)) && (iframe.contentWindow.scrolledUpFor === undefined)) { /*maybe a navigation has happened and we need to scroll back up*/
                    doScroll = true;
                }
            } else { // Fixed positioning, with scrolling turned off until the overlay is closed
                this.el.style.position = 'fixed';
                this.overlayEl.style.position = 'fixed';
                this.topWindow.document.body.style.overflow = 'hidden';
            }

            if (doScroll) {
                try { // Scroll to top to see
                    this.topWindow.scrollTo(0, 0);
                    if (iframe && ($cms.dom.hasIframeAccess(iframe))) {
                        iframe.contentWindow.scrolledUpFor = true;
                    }
                } catch (ignore) {}
            }
        },
        /**
         * Fiddle it, to behave like a popup would
         * @param { HTMLIFrameElement } iframe
         */
        makeFrameLikePopup: function makeFrameLikePopup(iframe) {
            var mainWebsiteInner, mainWebsite, popupSpacer, baseElement;

            if ((iframe.parentNode.parentNode.parentNode.parentNode == null) && (this.iframeRestyleTimer != null)) {
                clearInterval(this.iframeRestyleTimer);
                this.iframeRestyleTimer = null;
                return;
            }
            
            var iDoc = iframe.contentDocument;
            
            if (!$cms.dom.hasIframeAccess(iframe) || !iDoc.body || (iDoc.body.donePopupTrans !== undefined)) {
                if (hasIframeLoaded(iframe) && !hasIframeOwnership(iframe)) {
                    iframe.scrolling = 'yes';
                    iframe.style.height = '500px';
                }

                // Handle iframe sizing
                if (this.height === 'auto') {
                    this.resetDimensions(this.width, this.height, false);
                }
                return;
            }
            
            iDoc.body.style.background = 'transparent';
            iDoc.body.classList.add('overlay');
            iDoc.body.classList.add('lightbox');
            
            // Allow scrolling, if we want it
            //iframe.scrolling = (_this.scrollbars === false) ? 'no' : 'auto';  Actually, not wanting this now

            // Remove fixed width
            mainWebsiteInner = iDoc.getElementById('main_website_inner');

            if (mainWebsiteInner) {
                mainWebsiteInner.id = '';
            }

            // Remove main_website marker
            mainWebsite = iDoc.getElementById('main_website');
            if (mainWebsite) {
                mainWebsite.id = '';
            }

            // Remove popup spacing
            popupSpacer = iDoc.getElementById('popup_spacer');
            if (popupSpacer) {
                popupSpacer.id = '';
            }

            // Set linking scheme
            baseElement = iDoc.querySelector('base');

            if (!baseElement) {
                baseElement = iDoc.createElement('base');
                if (iDoc.head) {
                    iDoc.head.appendChild(baseElement);
                }
            }

            baseElement.target = this.target;

            // Set frame name
            if (this.name && (iframe.contentWindow.name !== this.name)) {
                iframe.contentWindow.name = this.name;
            }

            var self = this;
            // Create close function
            if (iframe.contentWindow.fauxClose === undefined) {
                iframe.contentWindow.fauxClose = function fauxClose() {
                    if (iframe && iframe.contentWindow && (iframe.contentWindow.returnValue !== undefined)) {
                        self.returnValue = iframe.contentWindow.returnValue;
                    }
                    self.option('finished');
                };
            }

            if ($cms.dom.html(iDoc.body).length > 300) { // Loaded now
                iDoc.body.donePopupTrans = true;
            }

            // Handle iframe sizing
            if (this.height === 'auto') {
                this.resetDimensions(this.width, this.height, false);
            }

            function hasIframeLoaded(iframe) {
                try {
                    return (iframe != null) && (iframe.contentWindow.location.host !== '');
                } catch (ignore) {}

                return false;
            }

            function hasIframeOwnership(iframe) {
                try {
                    return (iframe != null) && (iframe.contentWindow.location.host === window.location.host) && (iframe.contentWindow.document != null);
                } catch (ignore) {}

                return false;
            }
        }
    });

    /**
     * Ask a user a question: they must click a button
     * 'Cancel' should come as index 0 and Ok/default-option should come as index 1. This is so that the fallback works right.
     * @param message
     * @param buttonSet
     * @param windowTitle
     * @param fallbackMessage
     * @param callback
     * @param dialogWidth
     * @param dialogHeight
     * @returns { Promise }
     */
    $cms.ui.generateQuestionUi = function generateQuestionUi(message, buttonSet, windowTitle, fallbackMessage, callback, dialogWidth, dialogHeight) {
        message = strVal(message);

        return new Promise(function (resolvePromise) {
            var imageSet = [],
                newButtonSet = [];
            for (var s in buttonSet) {
                newButtonSet.push(buttonSet[s]);
                imageSet.push(s);
            }
            buttonSet = newButtonSet;

            if ((window.showModalDialog !== undefined) || $cms.$CONFIG_OPTION('js_overlays')) {
                // @TODO: window.showModalDialog() was removed completely in Chrome 43, and Firefox 55. See WebKit bug 151885 for possible future removal from Safari.
                if (buttonSet.length > 4) {
                    dialogHeight += 5 * (buttonSet.length - 4);
                }

                // Intentionally FIND_SCRIPT and not FIND_SCRIPT_NOHTTP, because no needs-HTTPS security restriction applies to popups, yet popups do not know if they run on HTTPS if behind a transparent reverse proxy
                var url = $cms.maintainThemeInLink('{$FIND_SCRIPT;,question_ui}?message=' + encodeURIComponent(message) + '&image_set=' + encodeURIComponent(imageSet.join(',')) + '&button_set=' + encodeURIComponent(buttonSet.join(',')) + '&window_title=' + encodeURIComponent(windowTitle) + $cms.$KEEP());
                if (dialogWidth == null) {
                    dialogWidth = 440;
                }
                if (dialogHeight == null) {
                    dialogHeight = 180;
                }
                $cms.ui.showModalDialog(url, null, 'dialogWidth=' + dialogWidth + ';dialogHeight=' + dialogHeight + ';status=no;unadorned=yes').then(function (result) {
                    if (result == null) {
                        if (callback != null) {
                            callback(buttonSet[0]); // just pressed 'cancel', so assume option 0
                        }
                        resolvePromise(buttonSet[0]);
                    } else {
                        if (callback != null) {
                            callback(result);
                        }
                        resolvePromise(result);
                    }
                });
                return;
            }

            if (buttonSet.length === 1) {
                $cms.ui.alert(fallbackMessage ? fallbackMessage : message, windowTitle).then(function () {
                    if (callback != null) {
                        callback(buttonSet[0]);
                    }
                    resolvePromise(buttonSet[0]);
                });
            } else if (buttonSet.length === 2) {
                $cms.ui.confirm(fallbackMessage ? fallbackMessage : message, null, windowTitle).then(function (result) {
                    if (callback != null) {
                        callback(result ? buttonSet[1] : buttonSet[0]);
                    }
                    resolvePromise(result ? buttonSet[1] : buttonSet[0]);
                });
            } else {
                if (!fallbackMessage) {
                    message += '\n\n{!INPUTSYSTEM_TYPE_EITHER;^}';
                    for (var i = 0; i < buttonSet.length; i++) {
                        message += buttonSet[i] + ',';
                    }
                    message = message.substr(0, message.length - 1);
                } else {
                    message = fallbackMessage;
                }

                $cms.ui.prompt(message, '', null, windowTitle).then(function (result) {
                    if (result == null) {
                        if (callback != null) {
                            callback(buttonSet[0]); // just pressed 'cancel', so assume option 0
                        }
                        resolvePromise(buttonSet[0]);
                        return;
                    } else {
                        if (result === '') {
                            if (callback != null) {
                                callback(buttonSet[1]); // just pressed 'ok', so assume option 1
                            }
                            resolvePromise(buttonSet[1]);
                            return;
                        }
                        for (var i = 0; i < buttonSet.length; i++) {
                            if (result.toLowerCase() === buttonSet[i].toLowerCase()) { // match
                                if (callback != null) {
                                    callback(result);
                                }
                                resolvePromise(result);
                                return;
                            }
                        }
                    }

                    // unknown
                    if (callback != null) {
                        callback(buttonSet[0]);
                    }
                    resolvePromise(buttonSet[0]);
                });
            }
        });
    };

    var networkDownAlerted = false;

    /**
     * @param {string} url
     * @param {function|null} [callback]
     * @param {string|null} [post] - Note that 'post' is not an array, it's a string (a=b)
     * @returns { Promise }
     */
    function doAjaxRequest(url, callback, post) {
        url = $cms.url(url).toString();

        return new Promise(function (resolvePromise) {
            var xhr = new XMLHttpRequest();

            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    readyStateChangeListener(xhr, function (responseXml) {
                        if (callback != null) {
                            callback(responseXml, xhr);
                        }
                        resolvePromise(xhr);
                    });
                }
            };

            if (typeof post === 'string') {
                if (!post.includes('&csrf_token=')) { // For CSRF prevention
                    post += '&csrf_token=' + encodeURIComponent($cms.getCsrfToken());
                }

                xhr.open('POST', url, true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.send(post);
            } else {
                xhr.open('GET', url, true);
                xhr.send(null);
            }
        });

        function readyStateChangeListener(xhr, ajaxCallback) {
            var okStatusCodes = [200, 500, 400, 401];
            // If status is 'OK'
            if (xhr.status && okStatusCodes.includes(xhr.status)) {
                // Process the result
                // XML result. Handle with a potentially complex call
                var responseXML = (xhr.responseXML && xhr.responseXML.firstChild) ? xhr.responseXML : null;

                if ((responseXML == null) && xhr.responseText && xhr.responseText.includes('<html')) {
                    $cms.ui.alert(xhr.responseText, '{!ERROR_OCCURRED;^}', true);
                }

                if (ajaxCallback != null) {
                    ajaxCallback(responseXML, xhr);
                }

                if (responseXML != null) {
                    var messageEl = responseXML.querySelector('message');
                    if (messageEl) {
                        // Either an error or a message was returned. :(
                        var message = messageEl.firstChild.textContent;
                        if (responseXML.querySelector('error')) {
                            // It's an error :|
                            $cms.ui.alert({ notice: 'An error (' + responseXML.querySelector('error').firstChild.textContent + ') message was returned by the server: ' + message });
                            return;
                        }

                        $cms.ui.alert({ notice: 'An informational message was returned by the server: ' + message });
                    }
                }
            } else {
                // HTTP error...
                if (ajaxCallback != null) {
                    ajaxCallback(null, xhr);
                }

                try {
                    if ((xhr.status === 0) || (xhr.status > 10000)) { // implies site down, or network down
                        if (!networkDownAlerted && !window.unloaded) {
                            //$cms.ui.alert('{!NETWORK_DOWN;^}');   Annoying because it happens when unsleeping a laptop (for example)
                            networkDownAlerted = true;
                        }
                    } else {
                        $cms.fatal('$cms.doAjaxRequest(): {!PROBLEM_RETRIEVING_XML;^}\n' + xhr.status + ': ' + xhr.statusText + '.', xhr);
                    }
                } catch (e) {
                    $cms.fatal('$cms.doAjaxRequest(): {!PROBLEM_RETRIEVING_XML;^}', e); // This is probably clicking back
                }
            }
        }
    }

    /**
     * Convert the format of a URL so it can be embedded as a parameter that ModSecurity will not trigger security errors on
     * @memberof $cms
     * @param {string} parameter
     * @returns {string}
     */
    function protectURLParameter(parameter) {
        parameter = strVal(parameter);
        
        var baseUrl = $cms.$BASE_URL();

        if (parameter.startsWith('https://')) {
            baseUrl = baseUrl.replace(/^http:\/\//, 'https://');
            if (parameter.startsWith(baseUrl + '/')) {
                return 'https-cms:' + parameter.substr(baseUrl.length + 1);
            }
        } else if (parameter.startsWith('http://')) {
            baseUrl = baseUrl.replace(/^https:\/\//, 'http://');
            if (parameter.startsWith(baseUrl + '/')) {
                return 'http-cms:' + parameter.substr(baseUrl.length + 1);
            }
        }

        return parameter;
    }

    var pageMetaCache;
    function pageMeta(name) {
        if (pageMetaCache === undefined) {
            pageMetaCache = {};
        }

        name = strVal(name);

        var metaEl = document.querySelector('meta[name="' + name + '"]'),
            data = pageMetaCache[name], trimmed;

        if (metaEl == null) {
            return '';
        }

        // If nothing was found internally, try to fetch any
        if ((data === undefined) && (typeof (data = metaEl.content) === 'string')) {
            trimmed = data.trim();

            if ((trimmed.startsWith('{') && trimmed.endsWith('}')) || (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
                data = parseJson(data);
            } else if (isNumeric(trimmed)) {
                data = Number(trimmed);
            }

            pageMetaCache[name] = data;
        }

        return data;
    }

    /**
     * Calls up a URL to check something, giving any 'feedback' as an error (or if just 'false' then returning false with no message)
     * @memberof $cms.form
     * @param url
     * @param post
     * @returns { Promise }
     */
    $cms.form.doAjaxFieldTest = function doAjaxFieldTest(url, post) {
        url = strVal(url);

        return new Promise(function (resolve) {
            $cms.doAjaxRequest(url, null, post).then(function (xhr) {
                if ((xhr.responseText !== '') && (xhr.responseText.replace(/[ \t\n\r]/g, '') !== '0'/*some cache layers may change blank to zero*/)) {
                    if (xhr.responseText !== 'false') {
                        if (xhr.responseText.length > 1000) {
                            //$cms.inform('$cms.form.doAjaxFieldTest()', 'xhr.responseText:', xhr.responseText);
                            $cms.ui.alert(xhr.responseText, '{!ERROR_OCCURRED;^}', true);
                        } else {
                            $cms.ui.alert(xhr.responseText);
                        }
                    }
                    resolve(false);
                    return;
                }
                resolve(true);
            });
        });
    };

    $cms.ready.push(function () {
        $cms.attachBehaviors(document);
    });

    $cms.defineBehaviors(/**@lends $cms.behaviors*/{

        // Implementation for [data-require-javascript="[<scripts>...]"]
        //initializeRequireJavascript: {
        //    priority: 10000,
        //    attach: function (context) {
        //        var promises = [];
        //
        //        $cms.dom.$$$(context, '[data-require-javascript]').forEach(function (el) {
        //            var scripts = arrVal($cms.dom.data(el, 'requireJavascript'));
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
        //},
        // TODO: Is this dead code? Is data-require-javascript in use or should be stripped? What's the purpose verses Tempcode method?

        // Implementation for [data-view]
        initializeViews: {
            attach: function (context) {
                $cms.once($cms.dom.$$$(context, '[data-view]'), 'behavior.initializeViews').forEach(function (el) {
                    var params = objVal($cms.dom.data(el, 'viewParams')),
                        view, viewOptions = { el: el };

                    if (typeof $cms.views[el.dataset.view] !== 'function') {
                        $cms.fatal('$cms.behaviors.initializeViews.attach(): Missing view constructor "' + el.dataset.view + '" for', el);
                        return;
                    }

                    try {
                        view = new $cms.views[el.dataset.view](params, viewOptions);
                        $cms.dom.data(el, 'viewObject', view);
                        //$cms.inform('$cms.behaviors.initializeViews.attach(): Initialized view "' + el.dataset.view + '" for', el, view);
                    } catch (ex) {
                        $cms.fatal('$cms.behaviors.initializeViews.attach(): Exception thrown while initializing view "' + el.dataset.view + '" for', el, ex);
                    }
                });
            }
        },

        // Implementation for [data-tpl]
        initializeTemplates: {
            attach: function (context) {
                $cms.once($cms.dom.$$$(context, '[data-tpl]'), 'behavior.initializeTemplates').forEach(function (el) {
                    var template = el.dataset.tpl,
                        params = objVal($cms.dom.data(el, 'tplParams'));

                    if (typeof $cms.templates[template] !== 'function') {
                        $cms.fatal('$cms.behaviors.initializeTemplates.attach(): Missing template function "' + template + '" for', el);
                        return;
                    }

                    try {
                        $cms.templates[template].call(el, params, el);
                        //$cms.inform('$cms.behaviors.initializeTemplates.attach(): Initialized template "' + template + '" for', el);
                    } catch (ex) {
                        $cms.fatal('$cms.behaviors.initializeTemplates.attach(): Exception thrown while calling the template function "' + template + '" for', el, ex);
                    }
                });
            }
        },

        initializeAnchors: {
            attach: function (context) {
                var anchors = $cms.once($cms.dom.$$$(context, 'a'), 'behavior.initializeAnchors'),
                    hasBaseEl = !!document.querySelector('base');

                anchors.forEach(function (anchor) {
                    var href = strVal(anchor.getAttribute('href'));
                    // So we can change base tag especially when on debug mode
                    if (hasBaseEl && href.startsWith('#') && (href !== '#!')) {
                        anchor.setAttribute('href', window.location.href.replace(/#.*$/, '') + href);
                    }

                    if ($cms.$CONFIG_OPTION('js_overlays')) {
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
                        if (anchor.href && anchor.href.startsWith($cms.$BASE_URL() + '/')) {
                            anchor.href += $cms.addKeepStub(anchor.href);
                        }
                    }
                });
            }
        },

        initializeForms: {
            attach: function (context) {
                var forms = $cms.once($cms.dom.$$$(context, 'form'), 'behavior.initializeForms');

                forms.forEach(function (form) {
                    // HTML editor
                    if (window.loadHtmlEdit !== undefined) {
                        window.loadHtmlEdit(form);
                    }

                    // Remove tooltips from forms as they are for screen-reader accessibility only
                    form.title = '';

                    // Convert form element title attributes into composr tooltips
                    if ($cms.$CONFIG_OPTION('js_overlays')) {
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
                        if (form.action && form.action.startsWith($cms.$BASE_URL() + '/')) {
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
        },

        initializeInputs: {
            attach: function (context) {
                var inputs = $cms.once($cms.dom.$$$(context, 'input'), 'behavior.initializeInputs');

                inputs.forEach(function (input) {
                    if (input.type === 'checkbox') {
                        // Implementatioin for input[data-cms-unchecked-is-indeterminate]
                        if (input.dataset.cmsUncheckedIsIndeterminate != null) {
                            input.indeterminate = !input.checked;
                        }
                    }
                });
            }
        },

        initializeTables: {
            attach: function attach(context) {
                var tables = $cms.once($cms.dom.$$$(context, 'table'), 'behavior.initializeTables');

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
        },
        
        // Implementation for [data-textarea-auto-height]
        textareaAutoHeight: {
            attach: function attach(context) {
                if ($cms.$MOBILE()) {
                    return;
                }
                
                var textareas = $cms.dom.$$$(context, '[data-textarea-auto-height]');
                
                for (var i = 0; i < textareas.length; i++) {
                    $cms.manageScrollHeight(textareas[i]);
                }
            }
        },

        columnHeightBalancing: {
            attach: function attach(context) {
                var cols = $cms.once($cms.dom.$$$(context, '.col_balance_height'), 'behavior.columnHeightBalancing'),
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
        },

        // Convert img title attributes into composr tooltips
        imageTooltips: {
            attach: function (context) {
                if (!$cms.$CONFIG_OPTION('js_overlays')) {
                    return;
                }

                $cms.once($cms.dom.$$$(context, 'img:not([data-cms-rich-tooltip])'), 'behavior.imageTooltips').forEach(function (img) {
                    convertTooltip(img);
                });
            }
        },

        // Implementation for [data-remove-if-js-enabled]
        removeIfJsEnabled: {
            attach: function (context) {
                var els = $cms.dom.$$$(context, '[data-remove-if-js-enabled]');

                els.forEach(function (el) {
                    $cms.dom.remove(el);
                });
            }
        },

        // Implementation for [data-js-function-calls]
        jsFunctionCalls: {
            attach: function (context) {
                var els = $cms.once($cms.dom.$$$(context, '[data-js-function-calls]'), 'behavior.jsFunctionCalls');

                els.forEach(function (el) {
                    var jsFunctionCalls = $cms.dom.data(el, 'jsFunctionCalls');

                    if (typeof jsFunctionCalls === 'string') {
                        jsFunctionCalls = [jsFunctionCalls];
                    }

                    if (jsFunctionCalls != null) {
                        $cms.executeJsFunctionCalls(jsFunctionCalls);
                    }
                });
            }
        },


        // Implementation for [data-cms-select2]
        select2Plugin: {
            attach: function (context) {
                if (IN_MINIKERNEL_VERSION) {
                    return;
                }

                $cms.requireJavascript(['jquery', 'select2']).then(function () {
                    var els = $cms.once($cms.dom.$$$(context, '[data-cms-select2]'), 'behavior.select2Plugin');

                    // Select2 plugin hook
                    els.forEach(function (el) {
                        var options = objVal($cms.dom.data(el, 'cmsSelect2'));
                        if (window.jQuery && window.jQuery.fn.select2) {
                            window.jQuery(el).select2(options);
                        }
                    });
                });
            }
        },

        // Implementation for img[data-gd-text]
        gdTextImages: {
            attach: function (context) {
                var els = $cms.once($cms.dom.$$$(context, 'img[data-gd-text]'), 'behavior.gdTextImages');

                els.forEach(function (img) {
                    gdImageTransform(img);
                });

                function gdImageTransform(el) {
                    /* GD text maybe can do with transforms */
                    var span = document.createElement('span');
                    if (typeof span.style.transform === 'string') {
                        el.style.display = 'none';
                        $cms.dom.css(span, {
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
        },

        // Implementation for [data-toggleable-tray]
        toggleableTray: {
            attach: function (context) {
                var els = $cms.once($cms.dom.$$$(context, '[data-toggleable-tray]'), 'behavior.toggleableTray');

                els.forEach(function (el) {
                    var options = objVal($cms.dom.data(el, 'toggleableTray')),
                        tray = new $cms.views.ToggleableTray(options, { el: el });
                });
            }
        }
    });

    /**
     * @memberof $cms.views
     * @class Global
     * @extends $cms.View
     * */
    $cms.views.Global = function Global() {
        Global.base(this, 'constructor', arguments);

        /*START JS from HTML_HEAD.tpl*/
        // Google Analytics account, if one set up
        if ($cms.$CONFIG_OPTION('google_analytics').trim() && !$cms.$IS_STAFF() && !$cms.$IS_ADMIN()) {
            (function (i, s, o, g, r, a, m) {
                i['GoogleAnalyticsObject'] = r;
                i[r] = i[r] || function () {
                        (i[r].q = i[r].q || []).push(arguments)
                    };
                i[r].l = 1 * new Date();
                a = s.createElement(o);
                m = s.getElementsByTagName(o)[0];
                a.async = 1;
                a.src = g;
                m.parentNode.insertBefore(a, m)
            })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

            var aConfig = {};

            if ($cms.$COOKIE_DOMAIN() !== '') {
                aConfig.cookieDomain = $cms.$COOKIE_DOMAIN();
            }
            if (!$cms.$CONFIG_OPTION('long_google_cookies')) {
                aConfig.cookieExpires = 0;
            }

            window.ga('create', $cms.$CONFIG_OPTION('google_analytics').trim(), aConfig);

            if (!$cms.$IS_GUEST()) {
                window.ga('set', 'userId', strVal($cms.$MEMBER()));
            }

            if ($cms.pageSearchParams().has('_t')) {
                window.ga('send', 'event', 'tracking__' + strVal($cms.pageSearchParams().get('_t')), window.location.href);
            }

            window.ga('send', 'pageview');
        }

        // Cookie Consent plugin by Silktide - http://silktide.com/cookieconsent
        if ($cms.$CONFIG_OPTION('cookie_notice') && ($cms.$RUNNING_SCRIPT() === 'index')) {
            window.cookieconsent_options = {
                message: $cms.format('{!COOKIE_NOTICE;}', [$cms.$SITE_NAME()]),
                dismiss: '{!INPUTSYSTEM_OK;}',
                learnMore: '{!READ_MORE;}',
                link: '{$PAGE_LINK;,:privacy}',
                theme: 'dark-top'
            };
            $cms.requireJavascript('https://cdnjs.cloudflare.com/ajax/libs/cookieconsent2/1.0.9/cookieconsent.min.js');
        }

        if ($cms.$CONFIG_OPTION('detect_javascript')) {
            this.detectJavascript();
        }
        /*END JS from HTML_HEAD.tpl*/

        $cms.dom.registerMouseListener();

        if ($cms.dom.$('#global_messages_2')) {
            var m1 = $cms.dom.$('#global_messages');
            if (!m1) {
                return;
            }
            var m2 = $cms.dom.$('#global_messages_2');
            $cms.dom.append(m1, $cms.dom.html(m2));
            m2.parentNode.removeChild(m2);
        }

        if (boolVal($cms.pageSearchParams().get('wide_print'))) {
            try {
                window.print();
            } catch (ignore) {}
        }

        if (($cms.$ZONE() === 'adminzone') && $cms.$CONFIG_OPTION('background_template_compilation')) {
            var page = $cms.filter.url($cms.getPageName());
            $cms.loadSnippet('background_template_compilation&page=' + page, '', true);
        }

        if (((window === window.top) && !window.opener) || (window.name === '')) {
            window.name = '_site_opener';
        }

        // Are we dealing with a touch device?
        if ($cms.browserMatches('touch_enabled')) {
            document.body.classList.add('touch_enabled');
        }

        if ($cms.seesJavascriptErrorAlerts()) {
            this.initialiseErrorMechanism();
        }

        // Dynamic images need preloading
        var preloader = new Image();
        preloader.src = $cms.img('{$IMG;,loading}');

        // Tell the server we have JavaScript, so do not degrade things for reasons of compatibility - plus also set other things the server would like to know
        if ($cms.$CONFIG_OPTION('detect_javascript')) {
            $cms.setCookie('js_on', 1, 120);
        }

        if ($cms.$CONFIG_OPTION('is_on_timezone_detection')) {
            if (!window.parent || (window.parent === window)) {
                $cms.setCookie('client_time', (new Date()).toString(), 120);
                $cms.setCookie('client_time_ref', (Date.now() / 1000), 120);
            }
        }

        // Mouse/keyboard listening
        window.currentMouseX = 0;
        window.currentMouseY = 0;

        this.stuckNavs();

        // If back button pressed back from an AJAX-generated page variant we need to refresh page because we aren't doing full JS state management
        window.addEventListener('popstate', function () {
            setTimeout(function () {
                if (!window.location.hash && window.hasJsState) {
                    window.location.reload();
                }
            });
        });

        // Monitor pasting, for anti-spam reasons
        window.addEventListener('paste', function (event) {
            var clipboardData = event.clipboardData || window.clipboardData;
            var pastedData = clipboardData.getData('Text');
            if (pastedData && (pastedData.length > $cms.$CONFIG_OPTION('spam_heuristic_pasting'))) {
                $cms.setPostDataFlag('paste');
            }
        });

        if ($cms.$IS_STAFF()) {
            this.loadStuffStaff()
        }
    };

    $cms.inherits($cms.views.Global, $cms.View, /**@lends Global#*/{
        events: function () {
            return {
                // Show a confirmation dialog for clicks on a link (is higher up for priority)
                'click [data-cms-confirm-click]': 'confirmClick',

                'click [data-click-eval]': 'clickEval',

                'click [data-click-alert]': 'showModalAlert',
                'keypress [data-keypress-alert]': 'showModalAlert',

                'keypress [data-submit-on-enter]': 'submitOnEnter',

                // Prevent url change for clicks on anchor tags with a placeholder href
                'click a[href$="#!"]': 'preventDefault',
                // Prevent form submission for forms with a placeholder action
                'submit form[action$="#!"]': 'preventDefault',
                // Prevent-default for JS-activated elements (which may have noscript fallbacks as default actions)
                'click [data-click-pd]': 'clickPreventDefault',
                'submit [data-submit-pd]': 'submitPreventDefault',

                // Simulated href for non <a> elements
                'click [data-cms-href]': 'cmsHref',

                'click [data-click-forward]': 'clickForward',

                // Toggle classes on mouseover/out
                'mouseover [data-mouseover-class]': 'mouseoverClass',
                'mouseout [data-mouseout-class]': 'mouseoutClass',

                'click [data-click-toggle-checked]': 'clickToggleChecked',

                // Disable button after click
                'click [data-disable-on-click]': 'disableButton',

                // Submit form when the change event is fired on an input element
                'change [data-change-submit-form]': 'changeSubmitForm',

                // Disable form buttons
                'submit form[data-disable-buttons-on-submit]': 'disableFormButtons',

                // mod_security workaround
                'submit form[data-submit-modsecurity-workaround]': 'submitModSecurityWorkaround',

                // Prevents input of matching characters
                'input input[data-cms-invalid-pattern]': 'invalidPattern',
                'keydown input[data-cms-invalid-pattern]': 'invalidPattern',
                'keypress input[data-cms-invalid-pattern]': 'invalidPattern',

                'click textarea[data-textarea-auto-height]': 'doTextareaAutoHeight',
                'input textarea[data-textarea-auto-height]': 'doTextareaAutoHeight',
                'change textarea[data-textarea-auto-height]': 'doTextareaAutoHeight',
                'keyup textarea[data-textarea-auto-height]': 'doTextareaAutoHeight',
                'keydown textarea[data-textarea-auto-height]': 'doTextareaAutoHeight',

                // Open page in overlay
                'click [data-open-as-overlay]': 'openOverlay',

                'click [data-click-faux-open]': 'clickFauxOpen',

                // Lightboxes
                'click a[rel*="lightbox"]': 'lightBoxes',

                // Go back in browser history
                'click [data-cms-btn-go-back]': 'goBackInHistory',

                'mouseover [data-mouseover-activate-tooltip]': 'mouseoverActivateTooltip',
                'focus [data-focus-activate-tooltip]': 'focusActivateTooltip',
                'blur [data-blur-deactivate-tooltip]': 'blurDeactivateTooltip',

                // "Rich semantic tooltips"
                'click [data-cms-rich-tooltip]': 'activateRichTooltip',
                'mouseover [data-cms-rich-tooltip]': 'activateRichTooltip',
                'keypress [data-cms-rich-tooltip]': 'activateRichTooltip',

                'change input[data-cms-unchecked-is-indeterminate]': 'uncheckedIsIndeterminate',
                
                'click [data-click-ga-track]': 'gaTrackClick',

                // Toggle tray
                'click [data-click-tray-toggle]': 'clickTrayToggle',

                'click [data-click-ui-open]': 'clickUiOpen',

                'click [data-click-do-input]': 'clickDoInput',

                /* Footer links */
                'click .js-global-click-load-software-chat': 'loadSoftwareChat',

                'submit .js-global-submit-staff-actions-select': 'staffActionsSelect',

                'keypress .js-global-input-su-keypress-enter-submit-form': 'inputSuKeypress',

                'click .js-global-click-load-realtime-rain': 'loadRealtimeRain',

                'click .js-global-click-load-commandr': 'loadCommandr'
            };
        },

        stuckNavs: function () {
            // Pinning to top if scroll out (LEGACY: CSS is going to have a better solution to this soon)
            var stuckNavs = $cms.dom.$$('.stuck_nav');

            if (!stuckNavs.length) {
                return;
            }

            $cms.dom.on(window, 'scroll', function () {
                for (var i = 0; i < stuckNavs.length; i++) {
                    var stuckNav = stuckNavs[i],
                        stuckNavHeight = (stuckNav.realHeight === undefined) ? $cms.dom.contentHeight(stuckNav) : stuckNav.realHeight;

                    stuckNav.realHeight = stuckNavHeight;
                    var posY = $cms.dom.findPosY(stuckNav.parentNode, true),
                        footerHeight = document.querySelector('footer') ? document.querySelector('footer').offsetHeight : 0,
                        panelBottom = $cms.dom.$id('panel_bottom');

                    if (panelBottom) {
                        footerHeight += panelBottom.offsetHeight;
                    }
                    panelBottom = $cms.dom.$id('global_messages_2');
                    if (panelBottom) {
                        footerHeight += panelBottom.offsetHeight;
                    }
                    if (stuckNavHeight < $cms.dom.getWindowHeight() - footerHeight) { // If there's space in the window to make it "float" between header/footer
                        var extraHeight = (window.pageYOffset - posY);
                        if (extraHeight > 0) {
                            var width = $cms.dom.contentWidth(stuckNav);
                            var height = $cms.dom.contentHeight(stuckNav);
                            var stuckNavWidth = $cms.dom.contentWidth(stuckNav);
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
            });
        },

        // Implementation for [data-cms-confirm-click="<Message>"]
        confirmClick: function (e, clicked) {
            var view = this, message,
                uid = $cms.uid(clicked);

            // Stores an element's `uid`
            this._confirmedClick || (this._confirmedClick = null);

            if (uid === this._confirmedClick) {
                // Confirmed, let it through
                this._confirmedClick = null;
                return;
            }

            e.preventDefault();
            message = clicked.dataset.cmsConfirmClick;
            $cms.ui.confirm(message, function (result) {
                if (result) {
                    view._confirmedClick = uid;
                    clicked.click();
                }
            });
        },

        // Implementation for [data-click-eval="<code to eval>"]
        clickEval: function (e, target) {
            var code = strVal(target.dataset.clickEval);

            if (code) {
                window.eval.call(target, code);
            }
        },

        // Implementation for [data-click-alert] and [data-keypress-alert]
        showModalAlert: function (e, target) {
            var options = objVal($cms.dom.data(target, e.type + 'Alert'), {}, 'notice');
            $cms.ui.alert(options.notice);
        },

        // Implementation for [data-submit-on-enter]
        submitOnEnter: function submitOnEnter(e, input) {
            if ($cms.dom.keyPressed(e, 'Enter')) {
                $cms.dom.submit(input.form);
                e.preventDefault();
            }
        },

        preventDefault: function (e) {
            e.preventDefault();
        },

        // Implementation for [data-click-pd]
        clickPreventDefault: function (e, el) {
            if (el.dataset.clickPd !== '0') {
                e.preventDefault();
            }
        },

        // Implementation for [data-submit-pd]
        submitPreventDefault: function (e, form) {
            if (form.dataset.submitPd !== '0') {
                e.preventDefault();
            }
        },

        // Implementation for [data-cms-href="<URL>"]
        cmsHref: function (e, el) {
            var anchorClicked = !!$cms.dom.closest(e.target, 'a', el);

            // Make sure a child <a> element wasn't clicked and default wasn't prevented
            if (!anchorClicked && !e.defaultPrevented) {
                $cms.navigate(el);
            }
        },

        // Implementation for [data-click-forward="{ child: '.some-selector' }"]
        clickForward: function (e, el) {
            var options = objVal($cms.dom.data(el, 'clickForward'), {}, 'child'),
                child = strVal(options.child), // Selector for target child element
                except = strVal(options.except), // Optional selector for excluded elements to let pass-through
                childEl = $cms.dom.$(el, child);

            if (!childEl) {
                // Nothing to do
                return;
            }

            if (!childEl.contains(e.target) && (!except || !$cms.dom.closest(e.target, except, el.parentElement))) {
                // ^ Make sure the child isn't the current event's target already, and check for excluded elements to let pass-through
                e.preventDefault();
                $cms.dom.trigger(childEl, 'click');
            }
        },

        // Implementation for [data-mouseover-class="{ 'some-class' : 1|0 }"]
        mouseoverClass: function (e, target) {
            var classes = objVal($cms.dom.data(target, 'mouseoverClass')), key, bool;

            if (!e.relatedTarget || !target.contains(e.relatedTarget)) {
                for (key in classes) {
                    bool = !!classes[key] && (classes[key] !== '0');
                    target.classList.toggle(key, bool);
                }
            }
        },

        // Implementation for [data-mouseout-class="{ 'some-class' : 1|0 }"]
        mouseoutClass: function (e, target) {
            var classes = objVal($cms.dom.data(target, 'mouseoutClass')), key, bool;

            if (!e.relatedTarget || !target.contains(e.relatedTarget)) {
                for (key in classes) {
                    bool = !!classes[key] && (classes[key] !== '0');
                    target.classList.toggle(key, bool);
                }
            }
        },

        // Implementation for [data-click-toggle-checked]
        clickToggleChecked: function (e, target) {
            var selector = strVal(target.dataset.clickToggleChecked),
                checkboxes  = [];

            if (selector === '') {
                checkboxes.push(target);
            } else {
                checkboxes = $cms.dom.$$$(selector)
            }

            checkboxes.forEach(function (checkbox) {
                $cms.dom.toggleChecked(checkbox);
            });
        },

        // Implementation for [data-disable-on-click]
        disableButton: function (e, target) {
            $cms.ui.disableButton(target);
        },

        // Implementation for [data-change-submit-form]
        changeSubmitForm: function (e, input) {
            if (input.form != null) {
                $cms.dom.submit(input.form);
            }
        },

        // Implementation for form[data-disable-buttons-on-submit]
        disableFormButtons: function (e, target) {
            $cms.ui.disableFormButtons(target);
        },

        // Implementation for form[data-submit-modsecurity-workaround]
        submitModSecurityWorkaround: function (e, form) {
            if ($cms.form.isModSecurityWorkaroundEnabled()) {
                e.preventDefault();
                $cms.form.modSecurityWorkaround(form);
            }
        },

        // Implementation for input[data-cms-invalid-pattern]
        invalidPattern: function (e, input) {
            var pattern = input.dataset.cmsInvalidPattern, regex;

            this._invalidPatternCache || (this._invalidPatternCache = {});

            regex = this._invalidPatternCache[pattern] || (this._invalidPatternCache[pattern] = new RegExp(pattern, 'g'));

            if (e.type === 'input') {
                if (input.value.length === 0) {
                    input.value = ''; // value.length is also 0 if invalid value is entered for input[type=number] et al., clear that
                } else if (input.value.search(regex) !== -1) {
                    input.value = input.value.replace(regex, '');
                }
            } else if ($cms.dom.keyOutput(e, regex)) { // keydown/keypress event
                // pattern matched, prevent input
                e.preventDefault();
            }
        },

        // Implementation for textarea[data-textarea-auto-height]
        doTextareaAutoHeight: function (e, textarea) {
            if ($cms.$MOBILE()) {
                return;
            }

            $cms.manageScrollHeight(textarea);
        },

        // Implementation for [data-open-as-overlay]
        openOverlay: function (e, el) {
            var options, url = (el.href === undefined) ? el.action : el.href;

            if (!($cms.$CONFIG_OPTION('js_overlays'))) {
                return;
            }

            if (/:\/\/(.[^\/]+)/.exec(url)[1] !== window.location.hostname) {
                return; // Cannot overlay, different domain
            }

            e.preventDefault();

            options = objVal($cms.dom.data(el, 'openAsOverlay'));
            options.el = el;

            openLinkAsOverlay(options);
        },

        // Implementation for [data-click-faux-open]
        clickFauxOpen: function (e, el) {
            var args = arrVal($cms.dom.data(el, 'clickFauxOpen'));
            $cms.ui.open.apply(undefined, args);
        },

        // Implementation for `click a[rel*="lightbox"]`
        lightBoxes: function (e, el) {
            if (!($cms.$CONFIG_OPTION('js_overlays'))) {
                return;
            }

            e.preventDefault();

            if (el.querySelector('img, video')) {
                openImageIntoLightbox(el);
            } else {
                openLinkAsOverlay({ el: el });
            }

            function openImageIntoLightbox(el) {
                var hasFullButton = (el.firstElementChild === null) || (el.href !== el.firstElementChild.src);
                $cms.ui.openImageIntoLightbox(el.href, ((el.cmsTooltipTitle !== undefined) ? el.cmsTooltipTitle : el.title), null, null, hasFullButton);
            }
        },

        // Implementation for [data-cms-btn-go-back]
        goBackInHistory: function () {
            window.history.back();
        },

        // Implementation for [data-mouseover-activate-tooltip]
        mouseoverActivateTooltip: function (e, el) {
            var args = arrVal($cms.dom.data(el, 'mouseoverActivateTooltip'));

            args.unshift(el, e);

            try {
                //arguments: el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, haveLinks
                $cms.ui.activateTooltip.apply(undefined, args);
            } catch (ex) {
                $cms.fatal('$cms.views.Global#mouseoverActivateTooltip(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
            }
        },

        // Implementation for [data-focus-activate-tooltip]
        focusActivateTooltip: function (e, el) {
            var args = arrVal($cms.dom.data(el, 'focusActivateTooltip'));

            args.unshift(el, e);

            try {
                //arguments: el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, haveLinks
                $cms.ui.activateTooltip.apply(undefined, args);
            } catch (ex) {
                $cms.fatal('$cms.views.Global#focusActivateTooltip(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
            }
        },

        // Implementation for [data-blur-deactivate-tooltip]
        blurDeactivateTooltip: function (e, el) {
            $cms.ui.deactivateTooltip(el);
        },

        // Implementation for [data-cms-rich-tooltip]
        activateRichTooltip: function (e, el) {
            var options = objVal($cms.dom.data(el, 'cmsRichTooltip'));

            if (el.ttitle === undefined) {
                el.ttitle = (el.attributes['data-title'] ? el.getAttribute('data-title') : el.title);
                el.title = '';
            }

            if ((e.type === 'mouseover') && options.haveLinks) {
                return;
            }

            //arguments: el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, haveLinks
            var args = [el, e, el.ttitle, 'auto', null, null, false, true, false, false, window, true/*!!el.haveLinks*/];

            try {
                $cms.ui.activateTooltip.apply(undefined, args);
            } catch (ex) {
                $cms.fatal('$cms.views.Global#activateRichTooltip(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
            }
        },

        // Implementatioin for input[data-cms-unchecked-is-indeterminate]
        uncheckedIsIndeterminate: function (e, input) {
            if (!input.checked) {
                input.indeterminate = true;
            }
        },

        // Implementation for [data-click-ga-track]
        gaTrackClick: function (e, clicked) {
            var options = objVal($cms.dom.data(clicked, 'clickGaTrack'));

            e.preventDefault();
            $cms.gaTrack(clicked, options.category, options.action);
        },

        // Implementation for [data-click-tray-toggle="<TRAY ID>"]
        clickTrayToggle: function (e, clicked) {
            var trayId = strVal(clicked.dataset.clickTrayToggle),
                trayEl = $cms.dom.$('#' + trayId),
                trayCookie;

            if (!trayEl) {
                return;
            }

            trayCookie = strVal(trayEl.dataset.trayCookie);

            if (trayCookie) {
                $cms.setCookie('tray_' + trayCookie, $cms.dom.isDisplayed(trayEl) ? 'closed' : 'open');
            }

            $cms.ui.toggleableTray(trayEl);
        },

        // Implementation for [data-click-ui-open]
        clickUiOpen: function (e, clicked) {
            var args = arrVal($cms.dom.data(clicked, 'clickUiOpen'));
            args[0] = $cms.maintainThemeInLink(args[0]);
            $cms.ui.open.apply(undefined, args);
        },

        // Implementation for [data-click-do-input]
        clickDoInput: function (e, clicked) {
            var args = arrVal($cms.dom.data(clicked, 'clickDoInput')),
                type = strVal(args[0]),
                fieldName = strVal(args[1]),
                tag = strVal(args[2]),
                fnName = 'doInput' + $cms.ucFirst($cms.camelCase(type));

            if (typeof window[fnName] === 'function') {
                window[fnName](fieldName, tag);
            } else {
                $cms.fatal('$cms.views.Global#clickDoInput(): Function not found "window.' + fnName + '()"');
            }
        },

        // Detecting of JavaScript support
        detectJavascript: function () {
            var url = window.location.href,
                append = '?';

            if ($cms.$JS_ON() || boolVal($cms.pageSearchParams().get('keep_has_js')) || url.includes('upgrader.php') || url.includes('webdav.php')) {
                return;
            }

            if (window.location.search.length === 0) {
                if (!url.includes('.htm') && !url.includes('.php')) {
                    append = 'index.php?';

                    if (!url.endsWith('/')) {
                        append = '/' + append;
                    }
                }
            } else {
                append = '&';
            }

            append += 'keep_has_js=1';

            if ($cms.$DEV_MODE()) {
                append += '&keep_devtest=1';
            }

            // Redirect with JS on, and then hopefully we can remove keep_has_js after one click. This code only happens if JS is marked off, no infinite loops can happen.
            window.location = url + append;
        },

        /* Software Chat */
        loadSoftwareChat: function () {
            var url = 'https://kiwiirc.com/client/irc.kiwiirc.com/?nick=';
            if ($cms.$USERNAME() !== 'admin') {
                url += encodeURIComponent($cms.$USERNAME().replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g, ''));
            } else {
                url += encodeURIComponent($cms.$SITE_NAME().replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g, ''));
            }
            url += '#composrcms';

            var SOFTWARE_CHAT_EXTRA = $cms.format('{!SOFTWARE_CHAT_EXTRA;^}', [$cms.filter.html(window.location.href.replace($cms.$BASE_URL(), 'http://baseurl'))]);
            var html = /** @lang HTML */' \
                <div class="software_chat"> \
                    <h2>{!CMS_COMMUNITY_HELP}</h2> \
                    <ul class="spaced_list">' + SOFTWARE_CHAT_EXTRA + '</ul> \
                    <p class="associated_link associated_links_block_group"> \
                        <a title="{!SOFTWARE_CHAT_STANDALONE} {!LINK_NEW_WINDOW;^}" target="_blank" href="' + $cms.filter.html(url) + '">{!SOFTWARE_CHAT_STANDALONE}</a> \
                        <a href="#!" class="js-global-click-load-software-chat">{!HIDE}</a> \
                    </p> \
                </div> \
                <iframe class="software_chat_iframe" style="border: 0" src="' + $cms.filter.html(url) + '"></iframe>';

            var box = $cms.dom.$('#software_chat_box'), img;
            if (box) {
                box.parentNode.removeChild(box);

                img = $cms.dom.$('#software_chat_img');
                img.style.opacity = 1;
            } else {
                var width = 950,
                    height = 550;

                box = $cms.dom.create('div', {
                    id: 'software_chat_box',
                    css: {
                        width: width + 'px',
                        height: height + 'px',
                        background: '#EEE',
                        color: '#000',
                        padding: '5px',
                        border: '3px solid #AAA',
                        position: 'absolute',
                        zIndex: 2000,
                        left: ($cms.dom.getWindowWidth() - width) / 2 + 'px',
                        top: 100 + 'px'
                    },
                    html: html
                });

                document.body.appendChild(box);

                $cms.dom.smoothScroll(0);

                img = $cms.dom.$('#software_chat_img');
                img.style.opacity = 0.5;
            }
        },

        /* Staff Actions links */
        staffActionsSelect: function (e, form) {
            var ob = form.elements['special_page_type'],
                val = ob.options[ob.selectedIndex].value;
            
            if (val !== 'view') {
                if (form.elements.cache !== undefined) {
                    form.elements.cache.value = (val.substring(val.length - 4, val.length) === '.css') ? '1' : '0';
                }

                var windowName = 'cms_dev_tools' + Math.floor(Math.random() * 10000),
                    windowOptions;
                
                if (val === 'templates') {
                    windowOptions = 'width=' + window.screen.availWidth + ',height=' + window.screen.availHeight + ',scrollbars=yes';

                    setTimeout(function () { // Do a refresh with magic markers, in a comfortable few seconds
                        var oldUrl = window.location.href;
                        if (!oldUrl.includes('keep_template_magic_markers=1')) {
                            window.location.href = oldUrl + (oldUrl.includes('?') ? '&' : '?') + 'keep_template_magic_markers=1&cache_blocks=0&cache_comcode_pages=0';
                        }
                    }, 10000);
                } else {
                    windowOptions = 'width=1020,height=700,scrollbars=yes';
                }
                
                var test = window.open('', windowName, windowOptions);

                if (test) {
                    form.setAttribute('target', test.name);
                }
            }
        },

        inputSuKeypress: function (e, input) {
            if ($cms.dom.keyPressed(e, 'Enter')) {
                $cms.dom.submit(input.form);
            }
        },

        loadRealtimeRain: function () {
            $cms.requireJavascript('button_realtime_rain').then(function () {
                loadRealtimeRain();
            });
        },

        loadCommandr: function () {
            if (window.loadCommandr) {
                window.loadCommandr();
            }
        },

        loadStuffStaff: function () {
            var loc = window.location.href;

            // Navigation loading screen
            if ($cms.$CONFIG_OPTION('enable_animations')) {
                if ((window.parent === window) && !loc.includes('js_cache=1') && (loc.includes('/cms/') || loc.includes('/adminzone/'))) {
                    window.addEventListener('beforeunload', function () {
                        staffUnloadAction();
                    });
                }
            }

            // Theme image editing hovers
            var els = $cms.dom.$$('*:not(.no_theme_img_click)'), i, el, isImage;
            for (i = 0; i < els.length; i++) {
                el = els[i];
                isImage = (el.localName === 'img') || ((el.localName === 'input') && (el.type === 'image')) || $cms.dom.css(el, 'background-image').includes('url');

                if (isImage) {
                    $cms.dom.on(el, {
                        mouseover: handleImageMouseOver,
                        mouseout: handleImageMouseOut,
                        click: handleImageClick
                    });
                }
            }

            /* Thumbnail tooltips */
            if ($cms.$DEV_MODE() || loc.replace($cms.$BASE_URL_NOHTTP(), '').includes('/cms/')) {
                var urlPatterns = $cms.staffTooltipsUrlPatterns(),
                    links, pattern, hook, patternRgx;

                links = $cms.dom.$$('td a');
                for (pattern in urlPatterns) {
                    hook = urlPatterns[pattern];
                    patternRgx = new RegExp(pattern);

                    links.forEach(function (link) {
                        if (link.href && !link.onmouseover) {
                            var id = link.href.match(patternRgx);
                            if (id) {
                                applyComcodeTooltip(hook, id, link);
                            }
                        }
                    });
                }
            }

            /* Screen transition, for staff */
            function staffUnloadAction() {
                $cms.undoStaffUnloadAction();

                // If clicking a download link then don't show the animation
                if (document.activeElement && document.activeElement.href !== undefined && document.activeElement.href != null) {
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
                var bi = $cms.dom.$id('main_website_inner');
                if (bi) {
                    bi.classList.add('site_unloading');
                    $cms.dom.fadeTo(bi, null, 0.2);
                }
                var div = document.createElement('div');
                div.className = 'unload_action';
                div.style.width = '100%';
                div.style.top = ($cms.dom.getWindowHeight() / 2 - 160) + 'px';
                div.style.position = 'fixed';
                div.style.zIndex = 10000;
                div.style.textAlign = 'center';
                $cms.dom.html(div, '<div aria-busy="true" class="loading_box box"><h2>{!LOADING;^}</h2><img id="loading_image" alt="" src="{$IMG_INLINE*;,loading}" /></div>');
                setTimeout(function () {
                    // Stupid workaround for Google Chrome not loading an image on unload even if in cache
                    if ($cms.dom.$('#loading_image')) {
                        $cms.dom.$('#loading_image').src += '';
                    }
                }, 100);
                document.body.appendChild(div);

                // Allow unloading of the animation
                $cms.dom.on(window, 'pageshow keydown click', $cms.undoStaffUnloadAction)
            }

            /*
             TOOLTIPS FOR THUMBNAILS TO CONTENT, AS DISPLAYED IN CMS ZONE
             */
            function applyComcodeTooltip(hook, id, link) {
                link.addEventListener('mouseout', function () {
                    $cms.ui.deactivateTooltip(link);
                });
                link.addEventListener('mousemove', function (event) {
                    $cms.ui.repositionTooltip(link, event, false, false, null, true);
                });
                link.addEventListener('mouseover', function (event) {
                    var idChopped = id[1];
                    if (id[2] !== undefined) {
                        idChopped += ':' + id[2];
                    }
                    var comcode = '[block="' + hook + '" id="' + decodeURIComponent(idChopped) + '" no_links="1"]main_content[/block]';
                    if (link.renderedTooltip === undefined) {
                        link.isOver = true;

                        $cms.doAjaxRequest($cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?css=1&javascript=1&raw_output=1&box_title={!PREVIEW;&}' + $cms.$KEEP()), null, 'data=' + encodeURIComponent(comcode)).then(function (xhr) {
                            if (xhr && xhr.responseText) {
                                link.renderedTooltip = xhr.responseText;
                            }
                            if (link.renderedTooltip !== undefined) {
                                if (link.isOver) {
                                    $cms.ui.activateTooltip(link, event, link.renderedTooltip, '400px', null, null, false, false, false, true);
                                }
                            }
                        });
                    } else {
                        $cms.ui.activateTooltip(link, event, link.renderedTooltip, '400px', null, null, false, false, false, true);
                    }
                });
            }

            /*
             THEME IMAGE CLICKING
             */
            function handleImageMouseOver(event) {
                var target = event.target;
                if (target.previousElementSibling && (target.previousElementSibling.classList.contains('magic_image_edit_link'))) {
                    return;
                }
                if (target.offsetWidth < 130) {
                    return;
                }

                var src = (target.src === undefined) ? $cms.dom.css(target, 'background-image') : target.src;

                if ((target.src === undefined) && (!event.ctrlKey) && (!event.metaKey) && (!event.altKey)) {
                    return;  // Needs ctrl key for background images
                }
                if (!src.includes('/themes/') || window.location.href.includes('admin_themes')) {
                    return;
                }

                if ($cms.$CONFIG_OPTION('enable_theme_img_buttons')) {
                    // Remove other edit links
                    var old = document.querySelectorAll('.magic_image_edit_link');
                    for (var i = old.length - 1; i >= 0; i--) {
                        old[i].parentNode.removeChild(old[i]);
                    }

                    // Add edit button
                    var ml = document.createElement('input');
                    ml.onclick = function (event) {
                        handleImageClick(event, target, true);
                    };
                    ml.type = 'button';
                    ml.id = 'editimg_' + target.id;
                    ml.value = '{!themes:EDIT_THEME_IMAGE;^}';
                    ml.className = 'magic_image_edit_link button_micro';
                    ml.style.position = 'absolute';
                    ml.style.left = $cms.dom.findPosX(target) + 'px';
                    ml.style.top = $cms.dom.findPosY(target) + 'px';
                    ml.style.zIndex = 3000;
                    ml.style.display = 'none';
                    target.parentNode.insertBefore(ml, target);

                    if (target.moLink) {
                        clearTimeout(target.moLink);
                    }
                    target.moLink = setTimeout(function () {
                        if (ml) {
                            ml.style.display = 'block';
                        }
                    }, 2000);
                }

                window.oldStatusImg = window.status;
                window.status = '{!SPECIAL_CLICK_TO_EDIT;^}';
            }

            function handleImageMouseOut(event) {
                var target = event.target;

                if ($cms.$CONFIG_OPTION('enable_theme_img_buttons')) {
                    if (target.previousElementSibling && (target.previousElementSibling.classList.contains('magic_image_edit_link'))) {
                        if ((target.moLink !== undefined) && (target.moLink)) {// Clear timed display of new edit button
                            clearTimeout(target.moLink);
                            target.moLink = null;
                        }

                        // Time removal of edit button
                        if (target.moLink) {
                            clearTimeout(target.moLink);
                        }

                        target.moLink = setTimeout(function () {
                            if ((target.editWindow === undefined) || (!target.editWindow) || (target.editWindow.closed)) {
                                if (target.previousElementSibling && (target.previousElementSibling.classList.contains('magic_image_edit_link'))) {
                                    target.parentNode.removeChild(target.previousElementSibling);
                                }
                            }
                        }, 3000);
                    }
                }

                if (window.oldStatusImg === undefined) {
                    window.oldStatusImg = '';
                }
                window.status = window.oldStatusImg;
            }

            function handleImageClick(event, ob, force) {
                ob || (ob = this);

                var src = ob.origsrc ? ob.origsrc : ((ob.src == null) ? $cms.dom.css(ob, 'background-image').replace(/.*url\(['"]?(.*)['"]?\).*/, '$1') : ob.src);
                if (src && (force || ($cms.magicKeypress(event)))) {
                    // Bubbling needs to be stopped because shift+click will open a new window on some lower event handler (in Firefox anyway)
                    event.preventDefault();

                    if (src.includes($cms.$BASE_URL_NOHTTP() + '/themes/')) {
                        ob.editWindow = window.open('{$BASE_URL;,0}/adminzone/index.php?page=admin_themes&type=edit_image&lang=' + encodeURIComponent($cms.$LANG()) + '&theme=' + encodeURIComponent($cms.$THEME()) + '&url=' + encodeURIComponent($cms.protectURLParameter(src.replace('{$BASE_URL;,0}/', ''))) + $cms.$KEEP(), 'edit_theme_image_' + ob.id);
                    } else {
                        $cms.ui.alert('{!NOT_THEME_IMAGE;^}');
                    }

                    return false;
                }

                return true;
            }
        },

        /* Staff JS error display */
        initialiseErrorMechanism: function () {
            window.onerror = function (msg, file, code) {
                if (document.readyState !== 'complete') {
                    // Probably not loaded yet
                    return null;
                }

                msg = strVal(msg);

                if (
                    (msg.includes('AJAX_REQUESTS is not defined')) || // Intermittent during page out-clicks

                    // LEGACY

                    // Internet Explorer false positives
                    (((msg.includes("'null' is not an object")) || (msg.includes("'undefined' is not a function"))) && ((file === undefined) || (file === 'undefined'))) || // Weird errors coming from outside
                    (((code === 0) || (code === '0')) && (msg.includes('Script error.'))) || // Too generic, can be caused by user's connection error

                    // Firefox false positives
                    (msg.includes("attempt to run compile-and-go script on a cleared scope")) || // Intermittent buggyness
                    (msg.includes('UnnamedClass.toString')) || // Weirdness
                    (msg.includes('ASSERT: ')) || // Something too generic
                    ((file) && (file.includes('TODO: FIXME'))) || // Something too generic / Can be caused by extensions
                    (msg.includes('TODO: FIXME')) || // Something too generic / Can be caused by extensions
                    (msg.includes('Location.toString')) || // Buggy extensions may generate
                    (msg.includes('Error loading script')) || // User's connection error
                    (msg.includes('NS_ERROR_FAILURE')) || // Usually an internal error

                    // Google Chrome false positives
                    (msg.includes('can only be used in extension processes')) || // Can come up with MeasureIt
                    (msg.includes('extension.')) || // E.g. "Uncaught Error: Invocation of form extension.getURL() doesn't match definition extension.getURL(string path) schema_generated_bindings"

                    false // Just to allow above lines to be reordered
                ) {
                    // Comes up on due to various Firefox/extension/etc bugs
                    return null;
                }

                if (!window.doneOneError) {
                    window.doneOneError = true;
                    var alert = '{!JAVASCRIPT_ERROR;^}\n\n' + code + ': ' + msg + '\n' + file;
                    if (document.body) { // i.e. if loaded
                        $cms.ui.alert(alert, '{!ERROR_OCCURRED;^}');
                    }
                }
                return false;
            };

            window.addEventListener('beforeunload', function () {
                window.onerror = null;
            });
        }
    });

    $cms.views.GlobalHelperPanel = GlobalHelperPanel;
    /**
     * @memberof $cms.views
     * @class GlobalHelperPanel
     * @extends $cms.View
     */
    function GlobalHelperPanel(params) {
        GlobalHelperPanel.base(this, 'constructor', arguments);
        this.contentsEl = this.$('.js-helper-panel-contents');
    }

    $cms.inherits(GlobalHelperPanel, $cms.View, /**@lends GlobalHelperPanel#*/{
        events: function () {
            return {
                'click .js-click-toggle-helper-panel': 'toggleHelperPanel'
            };
        },
        toggleHelperPanel: function () {
            var show = $cms.dom.notDisplayed(this.contentsEl),
                panelRight = $cms.dom.$('#panel_right'),
                helperPanelContents = $cms.dom.$('#helper_panel_contents'),
                helperPanelToggle = $cms.dom.$('#helper_panel_toggle');

            if (show) {
                panelRight.classList.remove('helper_panel_hidden');
                panelRight.classList.add('helper_panel_visible');
                helperPanelContents.setAttribute('aria-expanded', 'true');
                helperPanelContents.style.display = 'block';
                $cms.dom.fadeIn(helperPanelContents);

                if ($cms.readCookie('hide_helper_panel') === '1') {
                    $cms.setCookie('hide_helper_panel', '0', 100);
                }

                helperPanelToggle.firstElementChild.src = $cms.img('{$IMG;,icons/14x14/helper_panel_hide}');
                if (helperPanelToggle.firstElementChild.srcset !== undefined) {
                    helperPanelToggle.firstElementChild.srcset = $cms.img('{$IMG;,icons/28x28/helper_panel_hide} 2x');
                }
            } else {
                if ($cms.readCookie('hide_helper_panel') === '') {
                    $cms.ui.confirm('{!CLOSING_HELP_PANEL_CONFIRM;^}', function (answer) {
                        if (answer) {
                            _hideHelperPanel(panelRight, helperPanelContents, helperPanelToggle);
                        }
                    });
                } else {
                    _hideHelperPanel(panelRight, helperPanelContents, helperPanelToggle);
                }
            }

            function _hideHelperPanel(panelRight, helperPanelContents, helperPanelToggle) {
                panelRight.classList.remove('helper_panel_visible');
                panelRight.classList.add('helper_panel_hidden');
                helperPanelContents.setAttribute('aria-expanded', 'false');
                helperPanelContents.style.display = 'none';
                $cms.setCookie('hide_helper_panel', '1', 100);
                helperPanelToggle.firstElementChild.src = $cms.img('{$IMG;,icons/14x14/helper_panel_show}');

                if (helperPanelToggle.firstElementChild.srcset !== undefined) {
                    helperPanelToggle.firstElementChild.srcset = $cms.img('{$IMG;,icons/28x28/helper_panel_show} 2x');
                }
            }
        }
    });


    $cms.views.Menu = Menu;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function Menu(params) {
        Menu.base(this, 'constructor', arguments);

        /** @var {string} */
        this.menu = strVal(params.menu);
        /** @var {string} */
        this.menuId = strVal(params.menuId);

        if (params.javascriptHighlighting) {
            menuActiveSelection(this.menuId);
        }
    }

    $cms.inherits(Menu, $cms.View);

    // Templates:
    // MENU_dropdown.tpl
    // - MENU_BRANCH_dropdown.tpl
    $cms.views.DropdownMenu = DropdownMenu;
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function DropdownMenu(params) {
        DropdownMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(DropdownMenu, Menu, /**@lends DropdownMenu#*/{
        events: function () {
            return {
                'mousemove .js-mousemove-timer-pop-up-menu': 'timerPopUpMenu',
                'mouseout .js-mouseout-clear-pop-up-timer': 'clearPopUpTimer',
                'focus .js-focus-pop-up-menu': 'focusPopUpMenu',
                'mousemove .js-mousemove-pop-up-menu': 'popUpMenu',
                'mouseover .js-mouseover-set-active-menu': 'setActiveMenu',
                'click .js-click-unset-active-menu': 'unsetActiveMenu',
                'mouseout .js-mouseout-unset-active-menu': 'unsetActiveMenu',
                // For admin/templates/MENU_dropdown.tpl:
                'mousemove .js-mousemove-admin-timer-pop-up-menu': 'adminTimerPopUpMenu',
                'mouseout .js-mouseout-admin-clear-pop-up-timer': 'adminClearPopUpTimer'
            };
        },

        timerPopUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            if (!target.timer) {
                target.timer = setTimeout(function () {
                    popUpMenu(menu + '_dexpand_' + rand, 'below', menu + '_d');
                }, 200);
            }
        },

        clearPopUpTimer: function (e, target) {
            if (target.timer) {
                clearTimeout(target.timer);
                target.timer = null;
            }
        },

        focusPopUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            popUpMenu(menu + '_dexpand_' + rand, 'below', menu + '_d', true);
        },

        popUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            popUpMenu(menu + '_dexpand_' + rand, null, menu + '_d');
        },

        setActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                var menu = $cms.filter.id(this.menu);

                if (window.activeMenu == null) {
                    setActiveMenu(target.id, menu + '_d');
                }
            }
        },

        unsetActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                window.activeMenu = null;
                recreateCleanTimeout();
            }
        },

        /* For admin/templates/MENU_dropdown.tpl */
        adminTimerPopUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            window.menuHoldTime = 3000;
            if (!target.dataset.timer) {
                target.dataset.timer = setTimeout(function () {
                    var ret = popUpMenu(menu + '_dexpand_' + rand, 'below', menu + '_d', true);
                    try {
                        document.getElementById('search_content').focus();
                    } catch (ignore) {}
                    return ret;
                }, 200);
            }
        },
        adminClearPopUpTimer: function (e, target) {
            if (target.dataset.timer) {
                clearTimeout(target.dataset.timer);
                target.dataset.timer = null;
            }
        }
    });

    $cms.views.PopupMenu = PopupMenu;
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function PopupMenu(params) {
        PopupMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(PopupMenu, Menu, /**@lends PopupMenu#*/{
        events: function () {
            return {
                'click .js-click-unset-active-menu': 'unsetActiveMenu',
                'mouseout .js-mouseout-unset-active-menu': 'unsetActiveMenu'
            };
        },

        unsetActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                window.activeMenu = null;
                recreateCleanTimeout();
            }
        }
    });

    $cms.views.PopupMenuBranch = PopupMenuBranch;
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function PopupMenuBranch() {
        PopupMenuBranch.base(this, 'constructor', arguments);

        this.rand = this.params.rand;
        this.menu = $cms.filter.id(this.params.menu);
        this.popup = this.menu + '_pexpand_' + this.rand;
    }

    $cms.inherits(PopupMenuBranch, $cms.View, /**@lends PopupMenuBranch#*/{
        events: function () {
            return {
                'focus .js-focus-pop-up-menu': 'popUpMenu',
                'mousemove .js-mousemove-pop-up-menu': 'popUpMenu',
                'mouseover .js-mouseover-set-active-menu': 'setActiveMenu'
            };
        },
        popUpMenu: function () {
            popUpMenu(this.popup, null, this.menu + '_p');
        },
        setActiveMenu: function () {
            if (!window.activeMenu) {
                setActiveMenu(this.popup, this.menu + '_p');
            }
        }
    });

    $cms.views.TreeMenu = TreeMenu;
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function TreeMenu() {
        TreeMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(TreeMenu, Menu, /**@lends TreeMenu#*/{
        events: function () {
            return {
                'click [data-menu-tree-toggle]': 'toggleMenu'
            };
        },

        toggleMenu: function (e, target) {
            var menuId = target.dataset.menuTreeToggle;

            $cms.ui.toggleableTray($cms.dom.$('#' + menuId));
        }
    });

    // Templates:
    // MENU_mobile.tpl
    // - MENU_BRANCH_mobile.tpl
    $cms.views.MobileMenu = MobileMenu;
    /**
     * @memberof $cms.views
     * @class $cms.views.MobileMenu
     * @extends Menu
     */
    function MobileMenu() {
        MobileMenu.base(this, 'constructor', arguments);
        this.menuContentEl = this.$('.js-el-menu-content');
    }

    $cms.inherits(MobileMenu, Menu, /**@lends $cms.views.MobileMenu#*/{
        events: function () {
            return {
                'click .js-click-toggle-content': 'toggleContent',
                'click .js-click-toggle-sub-menu': 'toggleSubMenu'
            };
        },
        toggleContent: function (e) {
            e.preventDefault();
            $cms.dom.toggle(this.menuContentEl);
        },
        toggleSubMenu: function (e, link) {
            var rand = link.dataset.vwRand,
                subEl = this.$('#' + this.menuId + '_pexpand_' + rand),
                href;

            if ($cms.dom.notDisplayed(subEl)) {
                $cms.dom.show(subEl);
            } else {
                href = link.getAttribute('href');
                // Second click goes to it
                if (href && !href.startsWith('#')) {
                    return;
                }
                $cms.dom.hide(subEl);
            }

            e.preventDefault();
        }
    });

    // For admin/templates/MENU_mobile.tp
    $cms.templates.menuMobile = function menuMobile(params) {
        var menuId = strVal(params.menuId);
        $cms.dom.on(document.body, 'click', '.js-click-toggle-' + menuId + '-content', function (e) {
            var branch = document.getElementById(menuId);

            if (branch) {
                $cms.dom.toggle(branch.parentElement);
                e.preventDefault();
            }
        });
    };

    $cms.views.SelectMenu = SelectMenu;
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function SelectMenu() {
        SelectMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(SelectMenu, Menu, /**@lends SelectMenu#*/{
        events: function () {
            return {
                'change .js-change-redirect-to-value': 'redirect'
            };
        },
        redirect: function (e, changed) {
            if (changed.value) {
                window.location.href = changed.value;
            }
        }
    });

    function menuActiveSelection(menuId) {
        var menuElement = $cms.dom.$('#' + menuId),
            possibilities = [], isSelected, url, minScore, i;

        if (menuElement.localName === 'select') {
            for (i = 0; i < menuElement.options.length; i++) {
                url = menuElement.options[i].value;
                isSelected = menuItemIsSelected(url);
                if (isSelected !== null) {
                    possibilities.push({
                        url: url,
                        score: isSelected,
                        element: menuElement.options[i]
                    });
                }
            }

            if (possibilities.length > 0) {
                possibilities.sort(function (a, b) {
                    return a.score - b.score
                });

                minScore = possibilities[0].score;
                for (i = 0; i < possibilities.length; i++) {
                    if (possibilities[i].score != minScore) {
                        break;
                    }
                    possibilities[i].element.selected = true;
                }
            }
        } else {
            var menuItems = menuElement.querySelectorAll('.non_current'), a;
            for (i = 0; i < menuItems.length; i++) {
                a = null;
                for (var j = 0; j < menuItems[i].children.length; j++) {
                    if (menuItems[i].children[j].localName === 'a') {
                        a = menuItems[i].children[j];
                    }
                }
                if (!a) {
                    continue;
                }

                url = (a.getAttribute('href') === '') ? '' : a.href;
                isSelected = menuItemIsSelected(url);
                if (isSelected !== null) {
                    possibilities.push({
                        url: url,
                        score: isSelected,
                        element: menuItems[i]
                    });
                }
            }

            if (possibilities.length > 0) {
                possibilities.sort(function (a, b) {
                    return a.score - b.score
                });

                minScore = possibilities[0].score;
                for (i = 0; i < possibilities.length; i++) {
                    if (possibilities[i].score != minScore) {
                        break;
                    }
                    possibilities[i].element.classList.remove('non_current');
                    possibilities[i].element.classList.add('current');
                }
            }
        }

        function menuItemIsSelected(url) {
            url = strVal(url);

            if (url === '') {
                return null;
            }

            var currentUrl = window.location.href;
            if (currentUrl === url) {
                return 0;
            }
            var globalBreadcrumbs = document.getElementById('global_breadcrumbs');

            if (globalBreadcrumbs) {
                var links = globalBreadcrumbs.querySelectorAll('a');
                for (var i = 0; i < links.length; i++) {
                    if (url == links[links.length - 1 - i].href) {
                        return i + 1;
                    }
                }
            }

            return null;
        }
    }

    window.menuHoldTime = 500;
    window.activeMenu = null;
    window.lastActiveMenu = null;

    var cleanMenusTimeout,
        lastActiveMenu;

    function setActiveMenu(id, menu) {
        window.activeMenu = id;
        if (menu != null) {
            lastActiveMenu = menu;
        }
    }

    function recreateCleanTimeout() {
        if (cleanMenusTimeout) {
            clearTimeout(cleanMenusTimeout);
        }
        cleanMenusTimeout = setTimeout(cleanMenus, window.menuHoldTime);
    }

    function popUpMenu(id, place, menu, outsideFixedWidth) {
        place = strVal(place, 'right');
        outsideFixedWidth = !!outsideFixedWidth;

        var el = $cms.dom.$('#' + id);

        if (!el) {
            return;
        }

        if (cleanMenusTimeout) {
            clearTimeout(cleanMenusTimeout);
        }

        if ($cms.dom.isDisplayed(el)) {
            return false;
        }

        window.activeMenu = id;
        lastActiveMenu = menu;
        cleanMenus();

        var l = 0;
        var t = 0;
        var p = el.parentNode;

        // Our own position computation as we are positioning relatively, as things expand out
        if ($cms.dom.isCss(p.parentElement, 'position', 'absolute')) {
            l += p.offsetLeft;
            t += p.offsetTop;
        } else {
            while (p) {
                if (p && $cms.dom.isCss(p, 'position', 'relative')) {
                    break;
                }

                l += p.offsetLeft;
                t += p.offsetTop - (parseInt(p.style.borderTop) || 0);
                p = p.offsetParent;

                if (p && $cms.dom.isCss(p, 'position', 'absolute')) {
                    break;
                }
            }
        }
        if (place === 'below') {
            t += el.parentNode.offsetHeight;
        } else {
            l += el.parentNode.offsetWidth;
        }

        var fullHeight = $cms.dom.getWindowScrollHeight(); // Has to be got before e is visible, else results skewed
        el.style.position = 'absolute';
        el.style.left = '0'; // Setting this lets the browser calculate a more appropriate (larger) width, before we set the correct left for that width will fit
        el.style.display = 'block';
        $cms.dom.fadeIn(el);

        var fullWidth = (window.scrollX == 0) ? $cms.dom.getWindowWidth() : window.document.body.scrollWidth;

        if ($cms.$CONFIG_OPTION('fixed_width') && !outsideFixedWidth) {
            var mainWebsiteInner = document.getElementById('main_website_inner');
            if (mainWebsiteInner) {
                fullWidth = mainWebsiteInner.offsetWidth;
            }
        }

        var eParentWidth = el.parentNode.offsetWidth;
        el.style.minWidth = eParentWidth + 'px';
        var eParentHeight = el.parentNode.offsetHeight;
        var eWidth = el.offsetWidth;
        function positionL() {
            var posLeft = l;
            if (place === 'below') { // Top-level of drop-down
                if (posLeft + eWidth > fullWidth) {
                    posLeft += eParentWidth - eWidth;
                }
            } else { // NB: For non-below, we can't assume 'left' is absolute, as it is actually relative to parent node which is itself positioned
                if ($cms.dom.findPosX(el.parentNode, true) + eWidth + eParentWidth + 10 > fullWidth) posLeft -= eWidth + eParentWidth;
            }
            el.style.left = posLeft + 'px';
        }
        positionL();
        setTimeout(positionL, 0);
        function positionT() {
            var posTop = t;
            if (posTop + el.offsetHeight + 10 > fullHeight) {
                var abovePosTop = posTop - $cms.dom.contentHeight(el) + eParentHeight - 10;
                if (abovePosTop > 0) {
                    posTop = abovePosTop;
                }
            }
            el.style.top = posTop + 'px';
        }
        positionT();
        setTimeout(positionT, 0);
        el.style.zIndex = 200;

        recreateCleanTimeout();

        return false;
    }

    function cleanMenus() {
        cleanMenusTimeout = null;

        var m = $cms.dom.$('#r_' + lastActiveMenu);
        if (!m) {
            return;
        }
        var tags = m.querySelectorAll('.nlevel');
        var e = (window.activeMenu == null) ? null : document.getElementById(window.activeMenu), t;
        var i, hideable;
        for (i = tags.length - 1; i >= 0; i--) {
            if (tags[i].localName !== 'ul' && tags[i].localName !== 'div') continue;

            hideable = true;
            if (e) {
                t = e;
                do {
                    if (tags[i].id == t.id) {
                        hideable = false;
                    }
                    t = t.parentNode.parentNode;
                } while (t.id !== 'r_' + lastActiveMenu);
            }
            if (hideable) {
                tags[i].style.left = '-999px';
                tags[i].style.display = 'none';
            }
        }
    }

    $cms.templates.globalHtmlWrap = function () {
        if (document.getElementById('global_messages_2')) {
            var m1 = document.getElementById('global_messages');
            if (!m1) {
                return;
            }
            var m2 = document.getElementById('global_messages_2');
            $cms.dom.append(m1, $cms.dom.html(m2));
            m2.parentNode.removeChild(m2);
        }

        if (boolVal($cms.pageSearchParams().get('wide_print'))) {
            try {
                window.print();
            } catch (ignore) {}
        }
    };

    $cms.templates.installerStepLog = function installerStepLog() {
        /* Code to auto-submit the form after 5 seconds, but only if there were no errors */
        var doh = !!document.querySelector('.installer_warning');
        if (doh) {
            return;
        }

        var button = document.getElementById('proceed_button'),
            timer;

        button.countdown = 6;

        continueFunc();
        timer = window.setInterval(continueFunc, 1000);
        button.addEventListener('mouseover', function () {
            if (timer) {
                window.clearInterval(timer);
                timer = null;
            }
        });
        window.addEventListener('unload', function () {
            if (timer) {
                window.clearInterval(timer);
                timer = null;
            }
        });
        button.addEventListener('mouseout', function (e) {
            timer = window.setInterval(continueFunc, 1000);
        });

        function continueFunc() {
            button.value = "{!PROCEED} ({!AUTO_IN} " + button.countdown + ")";
            if (button.countdown === 0) {
                if (timer) {
                    window.clearInterval(timer);
                    timer = null;
                }
                $cms.dom.submit(button.form);
            } else {
                button.countdown--;
            }
        }
    };

    $cms.templates.installerHtmlWrap = function installerHtmlWrap(params, container) {
        var defaultForm = strVal(params.defaultForm);

        var none = document.getElementById(defaultForm);
        if (none) {
            none.checked = true;
        }

        if ((defaultForm !== 'none') && (defaultForm !== 'cns')) {
            var d = document.getElementById('forum_path');
            if (d) {
                d.style.display = 'block';
            }
        }

        var form = document.querySelector('form');
        if (form != null) {
            form.title = '';
        }

        var cns = document.getElementById('cns');
        if (cns) {
            useMultiDbLocker();

            for (var i=0; i < form.elements['forum'].length; i++) {
                form.elements['forum'][i].onclick = useMultiDbLocker;
            }
        }

        function useMultiDbLocker() {
            form.elements['use_multi_db'][0].disabled = cns.checked;
            form.elements['use_multi_db'][1].disabled = cns.checked;
            if (cns.checked) {
                form.elements['use_multi_db'][1].checked = true;
            }
        }
    };

    function toggleInstallerSection(id) {
        // Try and grab our item
        var itm = document.getElementById(id),
            img = document.getElementById('img_' + id);

        if (itm.style.display === 'none') {
            itm.style.display = 'block';
            if (img) {
                img.src = $cms.baseUrl('install.php?type=contract');
                img.alt = img.alt.replace('{!EXPAND;}', '{!CONTRACT;}');
                img.title = img.title.replace('{!EXPAND;}', '{!CONTRACT;}');
            }
        } else {
            itm.style.display = 'none';
            if (img) {
                img.src = $cms.baseUrl('install.php?type=expand');
                img.alt = img.alt.replace('{!CONTRACT;}', '{!EXPAND;}');
                img.title = img.title.replace('{!CONTRACT;}', '{!EXPAND;}');
            }
        }
    }

    $cms.templates.installerStep3 = function installerStep3(params, container) {
        $cms.dom.on(container, 'click', '.js-click-toggle-advanced-db-setup-section', function (e, clicked) {
            var id = strVal(clicked.dataset.tpSection);
            toggleInstallerSection(id);
        });
    };

    $cms.templates.installerForumChoice = function installerForumChoice(params, container) {
        var versions = strVal(params.versions);

        $cms.dom.on(container, 'click', '.js-click-do-forum-choose', function (e, clicked) {
            doForumChoose(clicked, $cms.filter.nl(versions));
        });

        function doForumChoose(el, versions) {
            $cms.dom.html('#versions', versions);

            var type = 'none';
            if ((el.id !== 'none') && (el.id !== 'cns')) {
                type = 'block';
                var label = document.getElementById('sep_forum');
                if (label) {
                    $cms.dom.html(label, el.nextSibling.nodeValue);
                }
            }

            document.getElementById('forum_database_info').style.display = type;
            if (document.getElementById('forum_path')) {
                document.getElementById('forum_path').style.display = type;
            }
        }
    };

    $cms.templates.installerInputLine = function installerInputLine(params, input) {
        $cms.dom.on(input, 'change', function () {
            input.changed = true;
        });
    };

    $cms.templates.installerStep4 = function installerStep4(params, container) {
        var passwordPrompt = strVal(params.passwordPrompt),
            domain = document.getElementById('domain');

        if (domain) {
            domain.addEventListener('change', function () {
                var cs = document.getElementById('Cookie_space_settings');
                if (cs && (cs.style.display === 'none')) {
                    toggleInstallerSection('Cookie_space_settings');
                }
                var cd = document.getElementById('cookie_domain');
                if (cd && (cd.value !== '')) {
                    cd.value = '.' + domain.value;
                }
            });
        }

        var gaeApp = document.getElementById('gae_application');

        if (gaeApp) {
            gaeOnChange();
            gaeApp.addEventListener('change', gaeOnChange);
        }

        function gaeOnChange() {
            var gaeLiveDbSite = document.getElementById('gae_live_db_site'),
                gaeLiveDbSiteHost = document.getElementById('gae_live_db_site_host'),
                gaeBucketName = document.getElementById('gae_bucket_name');

            gaeLiveDbSite.value = gaeLiveDbSite.value.replace(/(<application>|composr)/g, gaeApp.value);
            gaeLiveDbSiteHost.value = gaeLiveDbSiteHost.value.replace(/(<application>|composr)/g, gaeApp.value);
            gaeBucketName.value = gaeBucketName.value.replace(/(<application>|composr)/g, gaeApp.value);
        }

        var step4Form = document.getElementById('form-installer-step-4');

        if (step4Form) {
            step4Form.addEventListener('submit', validateSettings);
        }

        function validateSettings(e) {
            e.preventDefault();

            if ((step4Form.elements['forum_base_url']) && (step4Form.elements['forum_base_url'].type !== 'hidden') && (step4Form.elements['forum_base_url'].value === step4Form.elements['base_url'].value)) {
                window.alert('{!FORUM_BASE_URL_INVALID;/}');
                return;
            }

            if ((step4Form.elements['forum_base_url']) && (step4Form.elements['forum_base_url'].type !== 'hidden') && (step4Form.elements['forum_base_url'].value.substr(-7) === '/forums') && (!step4Form.elements['forum_base_url'].changed)) {
                if (!window.confirm('{!FORUM_BASE_URL_UNCHANGED;/}')) {
                    return;
                }
            }

            for (var i = 0; i < step4Form.elements.length; i++) {
                if ((step4Form.elements[i].classList.contains('required1')) && (step4Form.elements[i].value === '')) {
                    window.alert('{!IMPROPERLY_FILLED_IN;^}');
                    return;
                }
            }

            if (!checkPasswords(step4Form)) {
                return;
            }

            var checkPromises = [], post;

            if ((step4Form.elements['db_site_password'])) {
                var sitePwdCheckUrl = 'install.php?type=ajax_db_details';
                post = 'db_type=' + encodeURIComponent(step4Form.elements['db_type'].value) + '&db_site_host=' + encodeURIComponent(step4Form.elements['db_site_host'].value) + '&db_site=' + encodeURIComponent(step4Form.elements['db_site'].value) + '&db_site_user=' + encodeURIComponent(step4Form.elements['db_site_user'].value) + '&db_site_password=' + encodeURIComponent(step4Form.elements['db_site_password'].value);
                checkPromises.push($cms.form.doAjaxFieldTest(sitePwdCheckUrl, post));
            }

            if (step4Form.elements['db_forums_password']) {
                var forumsPwdCheckUrl = 'install.php?type=ajax_db_details';
                post = 'db_type=' + encodeURIComponent(step4Form.elements['db_type'].value) + '&db_forums_host=' + encodeURIComponent(step4Form.elements['db_forums_host'].value) + '&db_forums=' + encodeURIComponent(step4Form.elements['db_forums'].value) + '&db_forums_user=' + encodeURIComponent(step4Form.elements['db_forums_user'].value) + '&db_forums_password=' + encodeURIComponent(step4Form.elements['db_forums_password'].value);
                checkPromises.push($cms.form.doAjaxFieldTest(forumsPwdCheckUrl, post));
            }

            if (step4Form.elements['ftp_domain']) {
                var ftpDomainCheckUrl = 'install.php?type=ajax_ftp_details';
                post = 'ftp_domain=' + encodeURIComponent(step4Form.elements['ftp_domain'].value) + '&ftp_folder=' + encodeURIComponent(step4Form.elements['ftp_folder'].value) + '&ftp_username=' + encodeURIComponent(step4Form.elements['ftp_username'].value) + '&ftp_password=' + encodeURIComponent(step4Form.elements['ftp_password'].value);
                checkPromises.push($cms.form.doAjaxFieldTest(ftpDomainCheckUrl, post));
            }

            Promise.all(checkPromises).then(function (validities) {
                if (!validities.includes(false)) {
                    // All valid!
                    step4Form.submit();
                }
            });
        }

        /**
         * NOTE: This function also has a copy in PASSWORD_CHECK_JS.tpl so update that as well when modifying here.
         * @param form
         * @return {boolean}
         */
        function checkPasswords(form) {
            if (form.confirm) {
                return true;
            }

            if (form.elements['cns_admin_password_confirm'] != null) {
                if (!checkPassword(form, 'cns_admin_password', '{!ADMIN_USERS_PASSWORD;^}')) {
                    return false;
                }
            }

            if (form.elements['master_password_confirm'] != null) {
                if (!checkPassword(form, 'master_password', '{!MASTER_PASSWORD;^}')) {
                    return false;
                }
            }

            if (passwordPrompt !== '') {
                window.alert(passwordPrompt);
            }

            return true;

            function checkPassword(form, fieldName, fieldLabel) {
                // Check matches with confirm field
                if (form.elements[fieldName + '_confirm'].value !== form.elements[fieldName].value) {
                    window.alert('{!PASSWORDS_DO_NOT_MATCH;^/}'.replace('\{1\}', fieldLabel));
                    return false;
                }

                // Check does not match database password
                if (form.elements['db_site_password'] != null) {
                    if ((form.elements[fieldName].value !== '') && (form.elements[fieldName].value === form.elements['db_site_password'].value)) {
                        window.alert('{!PASSWORDS_DO_NOT_REUSE;^/}'.replace('\{1\}', fieldLabel));
                        return false;
                    }
                }

                // Check password is secure
                var isSecurePassword = true;
                if (form.elements[fieldName].value.length < 8) {
                    isSecurePassword = false;
                }
                if (!form.elements[fieldName].value.match(/[a-z]/)) {
                    isSecurePassword = false;
                }
                if (!form.elements[fieldName].value.match(/[A-Z]/)) {
                    isSecurePassword = false;
                }
                if (!form.elements[fieldName].value.match(/\d/)) {
                    isSecurePassword = false;
                }
                if (!form.elements[fieldName].value.match(/[^a-zA-Z\d]/)) {
                    isSecurePassword = false;
                }

                if (!isSecurePassword) {
                    return window.confirm('{!PASSWORD_INSECURE;^/}'.replace('\{1\}', fieldLabel)) && window.confirm('{!CONFIRM_REALLY;^/} {!PASSWORD_INSECURE;^/}'.replace('\{1\}', fieldLabel));
                }

                return true;
            }
        }
    };

    $cms.templates.installerStep4SectionHide = function installerStep4SectionHide(params, container) {
        var title = strVal(params.title);

        $cms.dom.on(container, 'click', '.js-click-toggle-title-section', function () {
            toggleInstallerSection($cms.filter.id($cms.filter.nl(title)));
        });
    };

    $cms.templates.blockMainScreenActions = function blockMainScreenActions(params, container) {
        var easySelfUrl = strVal(params.easySelfUrl);

        $cms.dom.on(container, 'click', '.js-click-action-print-screen', function (e, link) {
            $cms.gaTrack(null,'{!recommend:PRINT_THIS_SCREEN;}');
        });

        $cms.dom.on(container, 'click', '.js-click-action-add-to-facebook', function (e, link) {
            $cms.gaTrack(null,'social__facebook');
        });

        $cms.dom.on(container, 'click', '.js-click-action-add-to-twitter', function (e, link) {
            link.setAttribute('href', 'https://twitter.com/share?count=horizontal&counturl=' + easySelfUrl + '&original_referer=' + easySelfUrl + '&text=' + encodeURIComponent(document.title) + '&url=' + easySelfUrl);

            $cms.gaTrack(null,'social__twitter');
        });

        $cms.dom.on(container, 'click', '.js-click-action-add-to-stumbleupon', function (e, link) {
            $cms.gaTrack(null,'social__stumbleupon');
        });

        $cms.dom.on(container, 'click', '.js-click-action-add-to-digg', function (e, link) {
            $cms.gaTrack(null,'social__digg');
        });
    };

    $cms.views.ToggleableTray = ToggleableTray;
    /**
     * @memberof $cms.views
     * @class ToggleableTray
     * @extends $cms.View
     */
    function ToggleableTray() {
        ToggleableTray.base(this, 'constructor', arguments);

        this.contentEl = this.$('.toggleable_tray');
        this.trayCookie = strVal(this.el.dataset.trayCookie);

        if (this.trayCookie) {
            this.handleTrayCookie(this.trayCookie);
        }
    }

    $cms.inherits(ToggleableTray, $cms.View, /**@lends $cms.views.ToggleableTray#*/{
        /**@method*/
        events: function () {
            return {
                'click .js-btn-tray-toggle': 'toggle',
                'click .js-btn-tray-accordion': 'toggleAccordionItems'
            };
        },

        /**@method*/
        toggle: function () {
            var openend = $cms.ui.toggleableTray(this.el);

            if (this.trayCookie) {
                $cms.setCookie('tray_' + this.trayCookie, openend ? 'open' : 'closed');
            }
        },

        /**@method*/
        accordion: function (el) {
            var nodes = $cms.dom.$$(el.parentNode.parentNode, '.toggleable_tray');

            nodes.forEach(function (node) {
                if ((node.parentNode !== el) && $cms.dom.isDisplayed(node) && node.parentNode.classList.contains('js-tray-accordion-item')) {
                    $cms.ui.toggleableTray({ el: node, animate: false });
                }
            });

            $cms.ui.toggleableTray(el);
        },

        /**@method*/
        toggleAccordionItems: function (e, btn) {
            var accordionItem = $cms.dom.closest(btn, '.js-tray-accordion-item');

            if (accordionItem) {
                this.accordion(accordionItem);
            }
        },

        /**@method*/
        handleTrayCookie: function () {
            var cookieValue = $cms.readCookie('tray_' + this.trayCookie);

            if (($cms.dom.notDisplayed(this.contentEl) && (cookieValue === 'open')) || ($cms.dom.isDisplayed(this.contentEl) && (cookieValue === 'closed'))) {
                $cms.ui.toggleableTray({ el: this.contentEl, animate: false });
            }
        }
    });

    /**
     * Toggle a ToggleableTray
     * @memberof $cms.ui
     * @param elOrOptions
     * @return {boolean} - true when it is opened, false when it is closed
     */
    $cms.ui.toggleableTray = function toggleableTray(elOrOptions) {
        var options, el, animate,
            $IMG_expand = '{$IMG;,1x/trays/expand}',
            $IMG_expand2 = '{$IMG;,1x/trays/expand2}',
            $IMG_contract = '{$IMG;,1x/trays/contract}',
            $IMG_contract2 = '{$IMG;,1x/trays/contract2}';
        // TODO: We have expcon and expcon2 theme images, for use during animation. Are we removing this? If so those theme images should be deleted fully.

        if ($cms.isPlainObj(elOrOptions)) {
            options = elOrOptions;
            el =  options.el;
            animate = $cms.$CONFIG_OPTION('enable_animations') ? boolVal(options.animate, true) : false;
        } else {
            el = elOrOptions;
            animate = $cms.$CONFIG_OPTION('enable_animations');
        }
        
        el = $cms.dom.elArg(el);

        if (!el.classList.contains('toggleable_tray')) { // Suspicious, maybe we need to probe deeper
            el = $cms.dom.$(el, '.toggleable_tray') || el;
        }
        
        var pic = $cms.dom.$(el.parentNode, '.toggleable_tray_button img') || $cms.dom.$('img#e_' + el.id);

        if ($cms.dom.notDisplayed(el)) {
            el.setAttribute('aria-expanded', 'true');

            if (animate) {
                $cms.dom.slideDown(el);
            } else {
                $cms.dom.fadeIn(el);
            }

            if (pic) {
                setTrayThemeImage('expand', 'contract', $IMG_expand, $IMG_contract, $IMG_contract2);
            }

            $cms.dom.triggerResize(true);
            
            return true;
        } else {
            el.setAttribute('aria-expanded', 'false');

            if (animate) {
                $cms.dom.slideUp(el);
            } else {
                $cms.dom.hide(el);
            }

            if (pic) {
                setTrayThemeImage('contract', 'expand', $IMG_contract, $IMG_expand, $IMG_expand2);
                pic.setAttribute('alt', pic.getAttribute('alt').replace('{!CONTRACT;^}', '{!EXPAND;^}'));
                pic.title = '{!EXPAND;^}';
            }

            $cms.dom.triggerResize(true);
            
            return false;
        }
        
        // Execution ends here

        var isThemeWizard = !!(pic && pic.src && pic.src.includes('themewizard.php'));
        function setTrayThemeImage(beforeThemeImg, afterThemeImg, before1Url, after1Url, after2Url) {
            var is1 = $cms.dom.matchesThemeImage(pic.src, before1Url);

            if (is1) {
                if (isThemeWizard) {
                    pic.src = pic.src.replace(beforeThemeImg, afterThemeImg);
                } else {
                    pic.src = $cms.img(after1Url);
                }
            } else {
                if (isThemeWizard) {
                    pic.src = pic.src.replace(beforeThemeImg + '2', afterThemeImg + '2');
                } else {
                    pic.src = $cms.img(after2Url);
                }
            }
        }
    };

    $cms.functions.abstractFileManagerGetAfmForm = function abstractFileManagerGetAfmForm() {
        var usesFtp = document.getElementById('uses_ftp');
        if (!usesFtp) {
            return;
        }

        ftpTicker();
        usesFtp.onclick = ftpTicker;

        function ftpTicker() {
            var form = usesFtp.form;
            form.elements['ftp_domain'].disabled = !usesFtp.checked;
            form.elements['ftp_directory'].disabled = !usesFtp.checked;
            form.elements['ftp_username'].disabled = !usesFtp.checked;
            form.elements['ftp_password'].disabled = !usesFtp.checked;
            form.elements['remember_password'].disabled = !usesFtp.checked;
        }
    };

    $cms.templates.standaloneHtmlWrap = function (params) {
        if (window.parent) {
            $cms.load.push(function () {
                document.body.classList.add('frame');

                try {
                    $cms.dom.triggerResize();
                } catch (e) {}

                setTimeout(function () { // Needed for IE10
                    try {
                        $cms.dom.triggerResize();
                    } catch (e) {}
                }, 1000);
            });
        }

        if (params.isPreview) {
            $cms.form.disablePreviewScripts();
        }
    };

    $cms.templates.jsRefresh = function (params){
        if (!window.location.hash.includes('redirected_once')) {
            window.location.hash = 'redirected_once';
            $cms.dom.submit(document.getElementById(params.formName));
        } else {
            window.history.go(-2); // We've used back button, don't redirect forward again
        }
    };

    $cms.templates.forumsEmbed = function () {
        var frame = this;
        setInterval(function () {
            $cms.dom.resizeFrame(frame.name);
        }, 500);
    };

    $cms.templates.massSelectFormButtons = function (params, delBtn) {
        var form = delBtn.form;

        $cms.dom.on(delBtn, 'click', function () {
            confirmDelete(form, true, function () {
                var idEl = $cms.dom.$id('id'),
                    ids = (idEl.value === '') ? [] : idEl.value.split(',');

                for (var i = 0; i < ids.length; i++) {
                    prepareMassSelectMarker('', params.type, ids[i], true);
                }

                form.method = 'post';
                form.action = params.actionUrl;
                form.target = '_top';
                $cms.dom.submit(form);
            });
        });

        $cms.dom.on('#id', 'change', initialiseButtonVisibility);
        initialiseButtonVisibility();

        function initialiseButtonVisibility() {
            var id = $cms.dom.$('#id'),
                ids = (id.value === '') ? [] : id.value.split(/,/);

            $cms.dom.$('#submit_button').disabled = (ids.length !== 1);
            $cms.dom.$('#mass_select_button').disabled = (ids.length === 0);
        }
    };

    $cms.templates.massSelectDeleteForm = function (e, form) {
        $cms.dom.on(form, 'submit', function (e) {
            e.preventDefault();
            confirmDelete(form, true);
        });
    };

    $cms.templates.groupMemberTimeoutManageScreen = function groupMemberTimeoutManageScreen(params, container) {
        $cms.dom.on(container, 'focus', '.js-focus-update-ajax-member-list', function (e, input) {
            if (input.value === '') {
                $cms.form.updateAjaxMemberList(input, null, true, e);
            }
        });

        $cms.dom.on(container, 'keyup', '.js-keyup-update-ajax-member-list', function (e, input) {
            $cms.form.updateAjaxMemberList(input, null, false, e)
        });
    };

    $cms.templates.uploadSyndicationSetupScreen = function (params) {
        var winParent = window.parent || window.opener,
            id = 'upload_syndicate__' + params.hook + '__' + params.name,
            el = winParent.document.getElementById(id);

        el.checked = true;

        setTimeout(function () {
            if (window.fauxClose !== undefined) {
                window.fauxClose();
            } else {
                window.close();
            }
        }, 4000);
    };
    
    $cms.templates.blockMainComcodePageChildren = function blockMainComcodePageChildren() {};

    $cms.templates.loginScreen = function loginScreen(params, container) {
        if ((document.activeElement != null) || (document.activeElement !== $cms.dom.$('#password'))) {
            try {
                $cms.dom.$('#login_username').focus();
            } catch (ignore) {}
        }

        $cms.dom.on(container, 'click', '.js-click-checkbox-remember-me-confirm', function (e, checkbox) {
            var checkboxWasFocused = (document.activeElement === checkbox);

            if (checkbox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}').then(function (answer) {
                    if (!answer) {
                        checkbox.checked = false;
                    }

                    if (checkboxWasFocused) {
                        checkbox.focus();
                    }
                });
            }
        });

        $cms.dom.on(container, 'submit', '.js-submit-check-login-username-field', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });
    };

    $cms.templates.blockTopLogin = function (blockTopLogin, container) {
        $cms.dom.on(container, 'submit', '.js-form-top-login', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-confirm-remember-me', function (e, checkbox) {
            var checkboxWasFocused = (document.activeElement === checkbox);
            
            if (checkbox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}').then(function (answer) {
                    if (!answer) {
                        checkbox.checked = false;
                    }
                    
                    if (checkboxWasFocused) {
                        checkbox.focus();
                    }
                });
            }
        });
    };

    $cms.templates.ipBanScreen = function (params, container) {
        var textarea = container.querySelector('#bans');
        $cms.manageScrollHeight(textarea);

        if (!$cms.$MOBILE()) {
            $cms.dom.on(container, 'keyup', '#bans', function (e, textarea) {
                $cms.manageScrollHeight(textarea);
            });
        }
    };

    $cms.templates.jsBlock = function jsBlock(params) {
        $cms.callBlock(params.blockCallUrl, '', $cms.dom.$id(params.jsBlockId), false, false, null, false, false);
    };

    $cms.templates.massSelectMarker = function (params, container) {
        $cms.dom.on(container, 'click', '.js-chb-prepare-mass-select', function (e, checkbox) {
            prepareMassSelectMarker(params.supportMassSelect, params.type, params.id, checkbox.checked);
        });
    };


    $cms.templates.blockTopPersonalStats = function (params, container) {
        $cms.dom.on(container, 'click', '.js-click-toggle-top-personal-stats', function (e) {
            if (toggleTopPersonalStats(e) === false) {
                e.preventDefault();
            }
        });

        function toggleTopPersonalStats(event) {
            _toggleMessagingBox(event, 'pts', true);
            _toggleMessagingBox(event, 'web_notifications', true);
            return _toggleMessagingBox(event, 'top_personal_stats');
        }
    };

    $cms.templates.blockSidePersonalStatsNo = function blockSidePersonalStatsNo(params, container) {
        $cms.dom.on(container, 'submit', '.js-submit-check-login-username-field', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-checkbox-remember-me-confirm', function (e, checkbox) {
            var checkboxWasFocused = (document.activeElement === checkbox);

            if (checkbox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}').then(function (answer) {
                    if (!answer) {
                        checkbox.checked = false;
                    }

                    if (checkboxWasFocused) {
                        checkbox.focus();
                    }
                });
            }
        });
    };

    $cms.templates.memberTooltip = function (params, container) {
        var submitter = strVal(params.submitter);

        $cms.dom.on(container, 'mouseover', '.js-mouseover-activate-member-tooltip', function (e, el) {
            el.cancelled = false;
            $cms.loadSnippet('member_tooltip&member_id=' + submitter, null, true).then(function (result) {
                if (!el.cancelled) {
                    $cms.ui.activateTooltip(el, e, result, 'auto', null, null, false, true);
                }
            });
        });

        $cms.dom.on(container, 'mouseout', '.js-mouseout-deactivate-member-tooltip', function (e, el) {
            $cms.ui.deactivateTooltip(el);
            el.cancelled = true;
        });
    };

    $cms.templates.resultsLauncherContinue = function resultsLauncherContinue(params, link) {
        var max = params.max,
            urlStub = params.urlStub,
            numPages = params.numPages,
            message = $cms.format('{!javascript:ENTER_PAGE_NUMBER;^}', [numPages]);

        $cms.dom.on(link, 'click', function () {
            $cms.ui.prompt(message, numPages, function (res) {
                if (!res) {
                    return;
                }

                res = parseInt(res);
                if ((res >= 1) && (res <= numPages)) {
                    $cms.navigate(urlStub + (urlStub.includes('?') ? '&' : '?') + 'start=' + (max * (res - 1)));
                }
            }, '{!JUMP_TO_PAGE;^}');
        });
    };

    $cms.templates.doNextItem = function doNextItem(params, container) {
        var rand = params.randDoNextItem,
            url = params.url,
            target = params.target,
            warning = params.warning,
            autoAdd = params.autoAdd;

        $cms.dom.on(container, 'click', function (e) {
            var clickedLink = $cms.dom.closest(e.target, 'a', container);

            if (!clickedLink) {
                $cms.navigate(url, target);
                return;
            }

            if (autoAdd) {
                e.preventDefault();
                $cms.ui.confirm('{!KEEP_ADDING_QUESTION;^}', function (answer) {
                    var append = '';
                    if (answer) {
                        append += url.includes('?') ? '&' : '?';
                        append += autoAdd + '=1';
                    }
                    $cms.navigate(url + append, target);
                });
                return;
            }

            if (warning && clickedLink.classList.contains('js-click-confirm-warning')) {
                e.preventDefault();
                $cms.ui.confirm(warning, function (answer) {
                    if (answer) {
                        $cms.navigate(url, target);
                    }
                });
            }
        });

        var docEl = document.getElementById('doc_' + rand),
            helpEl = document.getElementById('help');

        if (docEl && helpEl) {
            /* Do-next document tooltips */
            $cms.dom.on(container, 'mouseover', function () {
                if ($cms.dom.html(docEl) !== '') {
                    window.origHelperText = $cms.dom.html(helpEl);
                    $cms.dom.html(helpEl, $cms.dom.html(docEl));
                    $cms.dom.fadeIn(helpEl);

                    helpEl.classList.remove('global_helper_panel_text');
                    helpEl.classList.add('global_helper_panel_text_over');
                }
            });

            $cms.dom.on(container, 'mouseout', function () {
                if (window.origHelperText !== undefined) {
                    $cms.dom.html(helpEl, window.origHelperText);
                    $cms.dom.fadeIn(helpEl);

                    helpEl.classList.remove('global_helper_panel_text_over');
                    helpEl.classList.add('global_helper_panel_text');
                }
            });
        }

        if (autoAdd) {
            var links = $cms.dom.$$(container, 'a');

            links.forEach(function (link) {
                link.onclick = function (event) {
                    event.preventDefault();
                    $cms.ui.confirm(
                        '{!KEEP_ADDING_QUESTION;^}',
                        function (test) {
                            if (test) {
                                link.href += link.href.includes('?') ? '&' : '?';
                                link.href += autoAdd + '=1';
                            }

                            $cms.navigate(link);
                        }
                    );
                };
            });
        }
    };

    $cms.templates.internalizedAjaxScreen = function internalizedAjaxScreen(params, element) {
        var url = strVal(params.url),
            changeDetectionUrl = strVal(params.changeDetectionUrl),
            refreshTime = Number(params.refreshTime) || 0,
            refreshIfChanged = strVal(params.refreshIfChanged);

        if (changeDetectionUrl && (refreshTime > 0)) {
            window.ajaxScreenDetectInterval = setInterval(function () {
                detectChange(changeDetectionUrl, refreshIfChanged, function () {
                    if (!document.getElementById('post') || (document.getElementById('post').value === '')) {
                        $cms.callBlock(url, '', element, false, true, null, true).then(function () {
                            detectedChange();
                        });
                    }
                });
            }, refreshTime * 1000);
        }

        $cms.dom.internaliseAjaxBlockWrapperLinks(url, element, ['.*'], {}, false, true);
    };

    $cms.templates.ajaxPagination = function ajaxPagination(params) {
        var wrapperEl = $cms.dom.$id(params.wrapperId),
            blockCallUrl = params.blockCallUrl,
            infiniteScrollCallUrl = params.infiniteScrollCallUrl,
            infiniteScrollFunc;
        
        if (wrapperEl) {
            $cms.dom.internaliseAjaxBlockWrapperLinks(blockCallUrl, wrapperEl, ['^[^_]*_start$', '^[^_]*_max$'], {});

            if (infiniteScrollCallUrl) {
                infiniteScrollFunc = $cms.dom.internaliseInfiniteScrolling.bind(undefined, infiniteScrollCallUrl, wrapperEl);

                $cms.dom.on(window, {
                    scroll: infiniteScrollFunc,
                    touchmove: infiniteScrollFunc,
                    keydown: $cms.dom.infiniteScrollingBlock,
                    mousedown: $cms.dom.infiniteScrollingBlockHold,
                    mousemove: function () {
                        // mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
                        $cms.dom.infiniteScrollingBlockUnhold(infiniteScrollFunc);
                    }
                });

                infiniteScrollFunc();
            }            
        } else {
            $cms.inform('$cms.templates.ajaxPagination(): Wrapper element not found.');
        }
    };

    $cms.templates.confirmScreen = function confirmScreen(params) {};

    $cms.templates.warnScreen = function warnScreen() {
        if ((window.$cms.dom.triggerResize != null) && (window.top !== window)) {
            $cms.dom.triggerResize();
        }
    };

    $cms.templates.fatalScreen = function fatalScreen() {
        if ((window.$cms.dom.triggerResize != null) && (window.top !== window)) {
            $cms.dom.triggerResize();
        }
    };

    $cms.templates.columnedTableScreen = function columnedTableScreen(params) {
        if (params.jsFunctionCalls != null) {
            $cms.executeJsFunctionCalls(params.jsFunctionCalls);
        }
    };

    $cms.templates.questionUiButtons = function questionUiButtons(params, container) {
        $cms.dom.on(container, 'click', '.js-click-close-window-with-val', function (e, clicked) {
            window.returnValue = clicked.dataset.tpReturnValue;

            if (window.fauxClose !== undefined) {
                window.fauxClose();
            } else {
                try {
                    window.$cms.getMainCmsWindow().focus();
                } catch (ignore) {}

                window.close();
            }
        });
    };

    $cms.templates.buttonScreenItem = function buttonScreenItem(params, btn) {
        var onclickCallFunctions = params.onclickCallFunctions;
        
        if (onclickCallFunctions != null) {
            $cms.dom.on(btn, 'click', function (e) {
                e.preventDefault();
                $cms.executeJsFunctionCalls(onclickCallFunctions, btn);
            });
        }
    };

    $cms.templates.cropTextMouseOver = function (params, el) {
        var textLarge = $cms.filter.nl(params.textLarge);

        $cms.dom.on(el, 'mouseover', function (e) {
            $cms.ui.activateTooltip(el, e, textLarge, '40%');
        });
    };

    $cms.templates.cropTextMouseOverInline = function (params, el) {
        var textLarge = $cms.filter.nl(params.textLarge);

        $cms.dom.on(el, 'mouseover', function (e) {
            var window = $cms.getMainCmsWindow(true);
            window.$cms.ui.activateTooltip(el, e, textLarge, '40%', null, null, null, false, false, false, window);
        });
    };

    $cms.templates.handleConflictResolution = function (params) {
        var pingUrl = strVal(params.pingUrl);
        
        if ('{$VALUE_OPTION;,disable_handle_conflict_resolution}' === '1') {
            return;
        }
        
        if (pingUrl) {
            $cms.doAjaxRequest(pingUrl);

            setInterval(function () {
                $cms.doAjaxRequest(pingUrl);
            }, 12000);
        }
    };

    $cms.templates.indexScreenFancierScreen = function indexScreenFancierScreen(params) {
        if (document.getElementById('search_content')) {
            document.getElementById('search_content').value = strVal(params.rawSearchString);    
        }
    };

    $cms.templates.doNextScreen = function doNextScreen(params) {};

    function detectChange(changeDetectionUrl, refreshIfChanged, callback) {
        $cms.doAjaxRequest(changeDetectionUrl, null, 'refresh_if_changed=' + encodeURIComponent(refreshIfChanged)).then(function (xhr) {
            var response = strVal(xhr.responseText);
            if (response === '1') {
                clearInterval(window.ajaxScreenDetectInterval);
                $cms.inform('detectChange(): Change detected');
                callback();
            }
        });
    }

    function detectedChange() {
        $cms.inform('detectedChange(): Change notification running');

        try {
            window.focus();
        } catch (e) {}
        
        var soundUrl = 'data/sounds/message_received.mp3',
            baseUrl = (!soundUrl.includes('data_custom') && !soundUrl.includes('uploads/')) ? $cms.$BASE_URL_NOHTTP : $cms.$CUSTOM_BASE_URL_NOHTTP,
            soundObject = window.soundManager.createSound({ url: baseUrl + '/' + soundUrl });

        if (soundObject && document.hasFocus()/*don't want multiple tabs all pinging*/) {
            soundObject.play();
        }
    }

    $cms.functions.decisionTreeRender = function decisionTreeRender(parameter, value, notice, noticeTitle) {
        var els = document.getElementById('main_form').elements[parameter];
        if (els.length === undefined) {
            els = [els];
        }
        for (var i = 0; i < els.length; i++) {
            els[i].addEventListener('click', function (el) {
                return function () {
                    var selected = false;
                    if (el.type === 'checkbox') {
                        selected = (el.checked && (el.value == value)) || (!el.checked && ('' == value));
                    } else {
                        selected = (el.value == value);
                    }
                    if (selected) {
                        $cms.ui.alert(notice, noticeTitle, true);
                    }
                }
            }(els[i]));
        }
    };

    function openLinkAsOverlay(options) {
        options = $cms.defaults({
            width: '800',
            height: 'auto',
            target: '_top',
            el: null
        }, options);

        if (options.width.match(/^\d+$/)) { // Restrain width to viewport width
            options.width = Math.min(parseInt(options.width), $cms.dom.getWindowWidth() - 60) + '';
        }

        var el = options.el,
            url = (el.href === undefined) ? el.action : el.href,
            urlStripped = url.replace(/#.*/, ''),
            newUrl = urlStripped + (!urlStripped.includes('?') ? '?' : '&') + 'wide_high=1' + url.replace(/^[^\#]+/, '');

        $cms.ui.open(newUrl, null, 'width=' + options.width + ';height=' + options.height, options.target);
    }

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

        $cms.dom.on(el, 'mouseover.convertTooltip', function (event) {
            global.$cms.ui.activateTooltip(el, event, el.cmsTooltipTitle, 'auto', '', null, false, false, false, false, global);
        });

        $cms.dom.on(el, 'mousemove.convertTooltip', function (event) {
            global.$cms.ui.repositionTooltip(el, event, false, false, null, false, global);
        });

        $cms.dom.on(el, 'mouseout.convertTooltip', function () {
            global.$cms.ui.deactivateTooltip(el);
        });
    }

    function confirmDelete(form, multi, callback) {
        multi = !!multi;

        $cms.ui.confirm(multi ? '{!_ARE_YOU_SURE_DELETE;^}' : '{!ARE_YOU_SURE_DELETE;^}').then(function (result) {
            if (result) {
                if (callback != null) {
                    callback();
                } else {
                    $cms.dom.submit(form);
                }
            }
        });
    }

    function prepareMassSelectMarker(set, type, id, checked) {
        var massDeleteForm = $cms.dom.$id('mass_select_form__' + set);
        if (!massDeleteForm) {
            massDeleteForm = $cms.dom.$id('mass_select_button').form;
        }
        var key = type + '_' + id;
        var hidden;
        if (massDeleteForm.elements[key] === undefined) {
            hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = key;
            massDeleteForm.appendChild(hidden);
        } else {
            hidden = massDeleteForm.elements[key];
        }
        hidden.value = checked ? '1' : '0';
        massDeleteForm.style.display = 'block';
    }
    /*
     Faux frames and faux scrolling
     */
    var infiniteScrollPending = false, // Blocked due to queued HTTP request
        infiniteScrollBlocked = false, // Blocked due to event tracking active
        infiniteScrollMouseHeld = false;

    /**
     * @param event
     */
    $cms.dom.infiniteScrollingBlockUnhold = function infiniteScrollingBlockUnhold(event) {
        if (event.keyCode === 35) { // 'End' key pressed, so stop the expand happening for a few seconds while the browser scrolls down
            infiniteScrollBlocked = true;
            setTimeout(function () {
                infiniteScrollBlocked = false;
            }, 3000);
        }
    };

    $cms.dom.infiniteScrollingBlockUnhold = function infiniteScrollingBlockUnhold() {
        if (!infiniteScrollBlocked) {
            infiniteScrollBlocked = true;
            infiniteScrollMouseHeld = true;
        }
    };

    /**
     * @param infiniteScrolling
     */
    $cms.dom.infiniteScrollingBlockUnhold = function infiniteScrollingBlockUnhold(infiniteScrolling) {
        if (infiniteScrollMouseHeld) {
            infiniteScrollBlocked = false;
            infiniteScrollMouseHeld = false;
            infiniteScrolling();
        }
    };

    /**
     * @param urlStem
     * @param wrapper
     * @returns {*}
     */
    $cms.dom.internaliseInfiniteScrolling = function internaliseInfiniteScrolling(urlStem, wrapper) {
        if (infiniteScrollBlocked || infiniteScrollPending) {
            // Already waiting for a result
            return false;
        }

        var paginations = wrapper.querySelectorAll('.pagination'),
            paginationLoadMore;

        if (paginations.length === 0) {
            return false;
        }

        var moreLinks = [], foundNewLinks = null, z, pagination, m;

        for (z = 0; z < paginations.length; z++) {
            pagination = paginations[z];
            if (pagination.style.display !== 'none') {
                // Remove visibility of pagination, now we've replaced with AJAX load more link
                var paginationParent = pagination.parentNode;
                pagination.style.display = 'none';
                var numNodeChildren = paginationParent.children.length;
                
                if (numNodeChildren === 0) { // Remove empty pagination wrapper
                    paginationParent.style.display = 'none';
                }

                // Add AJAX load more link before where the last pagination control was
                // Remove old pagination_load_more's
                paginationLoadMore = wrapper.querySelector('.pagination_load_more');
                if (paginationLoadMore) {
                    paginationLoadMore.parentNode.removeChild(paginationLoadMore);
                }

                // Add in new one
                var loadMoreLink = document.createElement('div');
                loadMoreLink.className = 'pagination_load_more';
                var loadMoreLinkA = document.createElement('a');
                $cms.dom.html(loadMoreLinkA, '{!LOAD_MORE;^}');
                loadMoreLinkA.href = '#!';
                loadMoreLinkA.onclick = (function (moreLinks) {
                    return function () {
                        $cms.dom.internaliseInfiniteScrollingGo(urlStem, wrapper, moreLinks);
                        return false;
                    };
                }(moreLinks)); // Click link -- load
                loadMoreLink.appendChild(loadMoreLinkA);
                paginations[paginations.length - 1].parentNode.insertBefore(loadMoreLink, paginations[paginations.length - 1].nextSibling);

                moreLinks = pagination.getElementsByTagName('a');
                foundNewLinks = z;
            }
        }
        
        for (z = 0; z < paginations.length; z++) {
            pagination = paginations[z];
            if (foundNewLinks != null) {// Cleanup old pagination
                if (z != foundNewLinks) {
                    var _moreLinks = pagination.getElementsByTagName('a');
                    var numLinks = _moreLinks.length;
                    for (var i = numLinks - 1; i >= 0; i--) {
                        _moreLinks[i].parentNode.removeChild(_moreLinks[i]);
                    }
                }
            } else { // Find links from an already-hidden pagination

                moreLinks = pagination.getElementsByTagName('a');
                if (moreLinks.length !== 0) {
                    break;
                }
            }
        }

        // Is more scrolling possible?
        var rel, foundRel = false;
        for (var k = 0; k < moreLinks.length; k++) {
            rel = moreLinks[k].getAttribute('rel');
            if (rel && rel.includes('next')) {
                foundRel = true;
            }
        }
        if (!foundRel) { // Ah, no more scrolling possible
            // Remove old pagination_load_more's
            paginationLoadMore = wrapper.querySelector('.pagination_load_more');
            if (paginationLoadMore) {
                paginationLoadMore.parentNode.removeChild(paginationLoadMore);
            }

            return;
        }

        // Used for calculating if we need to scroll down
        var wrapperPosY = $cms.dom.findPosY(wrapper),
            wrapperHeight = wrapper.offsetHeight,
            wrapperBottom = wrapperPosY + wrapperHeight,
            windowHeight = $cms.dom.getWindowHeight(),
            pageHeight = $cms.dom.getWindowScrollHeight(),
            scrollY = window.pageYOffset;

        // Scroll down -- load
        if ((scrollY + windowHeight > wrapperBottom - windowHeight * 2) && (scrollY + windowHeight < pageHeight - 30)) {// If within windowHeight*2 pixels of load area and not within 30 pixels of window bottom (so you can press End key)
            return $cms.dom.internaliseInfiniteScrollingGo(urlStem, wrapper, moreLinks);
        }

        return false;
    };

    /**
     * @param urlStem
     * @param wrapper
     * @param moreLinks
     * @returns {boolean}
     */
    $cms.dom.internaliseInfiniteScrollingGo = function internaliseInfiniteScrollingGo(urlStem, wrapper, moreLinks) {
        if (infiniteScrollPending) {
            return false;
        }

        var wrapperInner = $cms.dom.$id(wrapper.id + '_inner');
        if (!wrapperInner) {
            wrapperInner = wrapper;
        }

        var rel;
        for (var i = 0; i < moreLinks.length; i++) {
            rel = moreLinks[i].getAttribute('rel');
            if (rel && rel.indexOf('next') !== -1) {
                var nextLink = moreLinks[i];
                var urlStub = '';

                var matches = nextLink.href.match(new RegExp('[&?](start|[^_]*_start|start_[^_]*)=([^&]*)'));
                if (matches) {
                    urlStub += (urlStem.indexOf('?') === -1) ? '?' : '&';
                    urlStub += matches[1] + '=' + matches[2];
                    urlStub += '&raw=1';
                    infiniteScrollPending = true;

                    $cms.callBlock(urlStem + urlStub, '', wrapperInner, true).then(function () {
                        infiniteScrollPending = false;
                        $cms.dom.internaliseInfiniteScrolling(urlStem, wrapper);
                    });
                    return false;
                }
            }
        }

        return false;
    };

    /**
     * @param urlStem
     * @param blockElement
     * @param lookFor
     * @param extraParams
     * @param append
     * @param formsToo
     * @param scrollToTop
     */
    $cms.dom.internaliseAjaxBlockWrapperLinks = function internaliseAjaxBlockWrapperLinks(urlStem, blockElement, lookFor, extraParams, append, formsToo, scrollToTop) {
        urlStem = strVal(urlStem);
        lookFor = arrVal(lookFor);
        append = Boolean(append);
        formsToo = Boolean(formsToo);
        scrollToTop = (scrollToTop !== undefined) ? Boolean(scrollToTop) : true;

        if (!blockElement) {
            return;
        }

        var blockPosY = blockElement ? $cms.dom.findPosY(blockElement, true) : 0;

        if (blockPosY > window.pageYOffset) {
            scrollToTop = false;
        }
        
        var linkWrappers = blockElement.querySelectorAll('.ajax_block_wrapper_links');
        if (linkWrappers.length === 0) {
            linkWrappers = [blockElement];
        }
        var targets = [];
        for (var i = 0; i < linkWrappers.length; i++) {
            var linkWrapper = linkWrappers[i],
                links = $cms.dom.$$(linkWrapper, 'a');

            targets = targets.concat(links);

            if (formsToo) {
                var forms = $cms.dom.$$(linkWrapper, 'form');

                targets = targets.concat(forms);

                if (linkWrapper.localName === 'form') {
                    targets.push(linkWrapper);
                }
            }
        }
        
        targets.forEach(function (target) {
            if ((target.target !== '_self') || (target.href && target.getAttribute('href').startsWith('#')) || (target.action && target.getAttribute('action').startsWith('#'))) {
                return; // (continue)
            }

            if (target.localName === 'a') {
                $cms.dom.on(target, 'click', submitFunc);
            } else {
                $cms.dom.on(target, 'submit', submitFunc);
            }
        });

        function submitFunc(e) {
            var blockCallUrl = $cms.url(urlStem),
                hrefUrl = $cms.url((this.localName === 'a') ? this.href : this.action);
            
            e.preventDefault();
            
            // Any parameters matching a pattern must be sent in the URL to the AJAX block call
            $cms.eachIter(hrefUrl.searchParams.entries(), function (param) {
                var paramName = param[0],
                    paramValue = param[1];

                lookFor.forEach(function (pattern) {
                    pattern = new RegExp(pattern);
                    
                    if (pattern.test(paramName)) {
                        blockCallUrl.searchParams.set(paramName, paramValue);
                    }
                });
            });
            
            if (extraParams != null) {
                for (var key in extraParams) {
                    blockCallUrl.searchParams.set(key, extraParams[key]);
                }    
            }
            
            // Any POST parameters?
            var j, postParams, paramName, paramValue;

            if (this.localName === 'form') {
                if (this.method.toLowerCase() === 'post') {
                    postParams = '';
                }
                
                for (j = 0; j < this.elements.length; j++) {
                    if (this.elements[j].name) {
                        paramName = this.elements[j].name;
                        paramValue = $cms.form.cleverFindValue(this, this.elements[j]);

                        if (this.method.toLowerCase() === 'post') {
                            if (postParams !== '') {
                                postParams += '&';
                            }
                            postParams += paramName + '=' + encodeURIComponent(paramValue);
                        } else {
                            blockCallUrl.searchParams.set(paramName, paramValue);
                        }
                    }
                }
            }

            hrefUrl.searchParams.delete('ajax');
            hrefUrl.searchParams.delete('zone');
            
            try {
                window.hasJsState = true;
                window.history.pushState({ js: true }, document.title, hrefUrl.toString());
            } catch (ignore) {
                // Exception could have occurred due to cross-origin error (e.g. "Failed to execute 'pushState' on 'History':
                // A history state object with URL 'https://xxx' cannot be created in a document with origin 'http://xxx'")
            }

            $cms.ui.clearOutTooltips();

            // Make AJAX block call
            $cms.callBlock(blockCallUrl.toString(), '', blockElement, append, false, postParams).then(function () {
                if (scrollToTop) {
                    window.scrollTo(0, blockPosY);
                }
            });
        }
    };
}(window.$cms || (window.$cms = {})));

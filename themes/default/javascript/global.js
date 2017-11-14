(function ($cms, $util, $dom) {
    'use strict';

    var IN_MINIKERNEL_VERSION = document.documentElement.classList.contains('in-minikernel-version');

    var symbols =  (!IN_MINIKERNEL_VERSION ? JSON.parse(document.getElementById('composr-symbol-data').content) : {});

    // Cached references
    var hasOwn = Function.bind.call(Function.call, Object.prototype.hasOwnProperty),
        toArray = Function.bind.call(Function.call, Array.prototype.slice),
        forEach = Function.bind.call(Function.call, Array.prototype.forEach),
        includes = Function.bind.call(Function.call, Array.prototype.includes),
        // Helper for merging existing arrays
        pushArray = Function.bind.call(Function.apply, Array.prototype.push);

    // Too useful to not have globally!
    window.intVal  = intVal;
    window.numVal  = numVal;
    window.boolVal = boolVal;
    window.strVal  = strVal;
    window.arrVal  = arrVal;
    window.objVal  = objVal;
    
    setTimeout(function () {
        $dom._resolveInit();

        if (document.readyState === 'interactive') {
            // Workaround for browser bug, document.readyState == 'interactive' before [defer]'d <script>s are loaded.
            // See: https://github.com/jquery/jquery/issues/3271
            $dom.waitForResources(toArray(document.querySelectorAll('script[src][defer]'))).then(function () {
                $dom._resolveReady();
            });
        } else if (document.readyState === 'complete') {
            $dom._resolveReady();
        } else {
            document.addEventListener('DOMContentLoaded', function listener() {
                document.removeEventListener('DOMContentLoaded', listener);
                $dom._resolveReady();
            });
        }

        if (document.readyState === 'complete') {
            $dom._resolveLoad();
        } else {
            window.addEventListener('load', function listener() {
                window.removeEventListener('load', listener);
                $dom._resolveLoad();
            });
        }
    }, 0);

    /** @namespace $cms */
    $cms = extendDeep($cms, /**@lends $cms*/{
        /**
         * Unique for each copy of Composr on the page
         * @method
         * @returns {boolean}
         */
        id: constant('composr' + ('' + Math.random()).substr(2)),

        // Load up symbols data
        /**
         * @method
         * @returns {boolean}
         */
        isGuest: constant(boolVal(symbols.IS_GUEST)),
        /**
         * @method
         * @returns {boolean}
         */
        isStaff: constant(boolVal(symbols.IS_STAFF)),
        /**
         * @method
         * @returns {boolean}
         */
        isAdmin: constant(boolVal(symbols.IS_ADMIN)),
        /**
         * @method
         * @returns {boolean}
         */
        isHttpauthLogin: constant(boolVal(symbols.IS_HTTPAUTH_LOGIN)),
        /**
         * @method
         * @returns {boolean}
         */
        isACookieLogin: constant(boolVal(symbols.IS_A_COOKIE_LOGIN)),
        /**
         * @method
         * @returns {boolean}
         */
        isDevMode: constant(IN_MINIKERNEL_VERSION || boolVal(symbols.DEV_MODE)),
        /**
         * @method
         * @returns {boolean}
         */
        isJsOn: constant(boolVal(symbols.JS_ON)),
        /**
         * @method
         * @returns {boolean}
         */
        isMobile: constant(boolVal(symbols.MOBILE)),
        /**
         * @method
         * @returns {boolean}
         */
        isForcePreviews: constant(boolVal(symbols.FORCE_PREVIEWS)),
        /**
         * @method
         * @returns {boolean}
         */
        isInlineStats: constant(boolVal(symbols.INLINE_STATS)),
        /**
         * @method
         * @returns {number}
         */
        httpStatusCode: constant(Number(symbols.HTTP_STATUS_CODE)),
        /**
         * @method
         * @returns {string}
         */
        getPageName: constant(strVal(symbols.PAGE)),
        /**
         * @method
         * @returns {string}
         */
        getZoneName: constant(strVal(symbols.ZONE)),
        /**
         * @method
         * @returns {string}
         */
        getMember: constant(strVal(symbols.MEMBER)),
        /**
         * @method
         * @returns {string}
         */
        getUsername: constant(strVal(symbols.USERNAME)),
        /**
         * @method
         * @returns {string}
         */
        getTheme: constant(strVal(symbols.THEME)),
        /**
         * @method
         * @returns {string}
         */
        userLang: constant(strVal(symbols.LANG)),
        /**
         * @method
         * @returns {string}
         */
        keep: function keep(starting, forceSession) {
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
        getPreviewUrl: function getPreviewUrl() {
            var value = '{$FIND_SCRIPT_NOHTTP;,preview}';
            value += '?page=' + urlencode($cms.getPageName());
            value += '&type=' + urlencode(symbols['page_type']);
            return value;
        },
        /**
         * @method
         * @returns {string}
         */
        getSiteName: constant(strVal('{$SITE_NAME;}')),
        /**
         * @method
         * @returns {string}
         */
        getBaseUrl: constant(strVal('{$BASE_URL;}')),
        /**
         * @param relativeUrl - Pass a relative URL but an absolute url works as well for robustness' sake
         * @returns {string}
         */
        baseUrl: function baseUrl(relativeUrl) {
            relativeUrl = strVal(relativeUrl);

            if (relativeUrl === '') {
                return $cms.getBaseUrl();
            }

            var url = $cms.url(relativeUrl).toString();

            if (window.location.protocol === 'https:') {
                // Match protocol with the current page if using SSL
                url = url.replace(/^http\:/, 'https:');
            }

            return url;
        },
        /**
         * @method
         * @returns {string}
         */
        getBaseUrlNohttp: constant(strVal('{$BASE_URL_NOHTTP;}')),
        /**
         * @method
         * @returns {string}
         */
        getCustomBaseUrl: constant(strVal('{$CUSTOM_BASE_URL;}')),
        /**
         * @method
         * @returns {string}
         */
        getCustomBaseUrlNohttp: constant(strVal('{$CUSTOM_BASE_URL_NOHTTP;}')),
        /**
         * @method
         * @returns {string}
         */
        getForumBaseUrl: constant(strVal('{$FORUM_BASE_URL;}')),
        /**
         * @method
         * @returns {string}
         */
        brandName: constant(strVal('{$BRAND_NAME;}')),
        /**
         * @method
         * @returns {string}
         */
        getSessionCookie: constant(strVal('{$SESSION_COOKIE_NAME;}')),
        /**
         * @method
         * @returns {string}
         */
        getCookiePath: constant(strVal('{$COOKIE_PATH;}')),
        /**
         * @method
         * @returns {string}
         */
        getCookieDomain: constant(strVal('{$COOKIE_DOMAIN;}')),
        /**
         * @method
         * @returns {string}
         */
        runningScript: constant(strVal(symbols.RUNNING_SCRIPT)),
        /**
         * @method
         * @returns {string}
         */
        getCspNonce: constant(strVal(symbols.CSP_NONCE)),

        /**
         * WARNING: This is a very limited subset of the $CONFIG_OPTION tempcode symbol
         * @method
         * @param {string} optionName
         * @returns {boolean|string|number}
         */
        configOption: (function () {
            if (IN_MINIKERNEL_VERSION) {
                // Installer, likely executing global.js
                return constant('');
            }

            var configOptionsJson = JSON.parse('{$PUBLIC_CONFIG_OPTIONS_JSON;}');
            return function configOption(optionName) {
                if (hasOwn(configOptionsJson, optionName)) {
                    return configOptionsJson[optionName];
                }

                $util.fatal('$cms.configOption(): Option "' + optionName + '" is either unsupported in JS or doesn\'t exist. Please try using the actual Tempcode symbol.');
            };
        }()),
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
        staffTooltipsUrlPatterns: constant(objVal(JSON.parse('{$STAFF_TOOLTIPS_URL_PATTERNS_JSON;}'))),

        /* Export useful stuff  */
        /**@method*/
        pageUrl: pageUrl,
        /**@method*/
        pageSearchParams: pageSearchParams,
        /**@method*/
        pageKeepSearchParams: pageKeepSearchParams,
        /**@method*/
        img: img,
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
         * Addons will add "behaviors" under this object
         * @namespace $cms.behaviors
         */
        behaviors: {},
    });

    /**@namespace $util*/
    $util = extendDeep($util, /**@lends $util*/{
        /**
         * @method
         * @returns {boolean}
         */
        hasOwn: hasOwn,
        /**
         * @method
         * @returns { Array }
         */
        toArray: toArray,
        /**
         * @method
         * @returns { Array }
         */
        pushArray: pushArray,
        /**@method*/
        isObj: isObj,
        /**@method*/
        isPlainObj: isPlainObj,
        /**@method*/
        isArrayLike: isArrayLike,
        /**@method*/
        isPromise: isPromise,
        /**@method*/
        isWindow: isWindow,
        /**@method*/
        isNode: isNode,
        /**@method*/
        isEl: isEl,
        /**@method*/
        isDoc: isDoc,
        /**@method*/
        isDocFrag: isDocFrag,
        /**@method*/
        isRegExp: isRegExp,
        /**@method*/
        isDate: isDate,
        /**@method*/
        isNumeric: isNumeric,
        /**@method*/
        uid: uid,
        /**@method*/
        hasEnumerable: hasEnumerable,
        /**@method*/
        hasOwnEnumerable: hasOwnEnumerable,
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
        defaults: defaults,
        /**@method*/
        properties: properties,
        /**@method*/
        inherits: inherits,
        /**@method*/
        camelCase: camelCase,
        /**@method*/
        ucFirst: ucFirst,
        /**@method*/
        lcFirst: lcFirst,
        /**@method*/
        format: format,
        /**@method*/
        isAbsolute: isAbsolute,
        /**@method*/
        isRelative: isRelative,
        /**@method*/
        schemeRelative: schemeRelative,
        /**@method*/
        random: random,
        /**@method*/
        once: once,
        /**@method*/
        findOnce: findOnce,
        /**@method*/
        removeOnce: removeOnce,
        /**@method*/
        throttle: throttle,
        /**@method*/
        debounce: debounce,
        /**@method*/
        arrayFromIterable: arrayFromIterable,
        /**@method*/
        parseJson5: parseJson5,
        /**@method*/
        pageMeta: pageMeta,
        /**@method*/
        navigate: navigate,
        /**@method*/
        inform: inform,
        /**@method*/
        warn: warn,
        /**@method*/
        fatal: fatal
    });

    /*{+START,INCLUDE,DOM,.js,javascript}{+END}*/

    // Generate a unique integer id (unique within the entire client session).
    var _uniqueId;
    function uniqueId() {
        if (_uniqueId === undefined) {
            _uniqueId = 0;
        }
        return ++_uniqueId;
    }

    /**
     * Used to uniquely identify objects/functions
     * @param {object|function} obj
     * @returns {number}
     */
    function uid(obj) {
        if ((obj == null) || ((typeof obj !== 'object') && (typeof obj !== 'function'))) {
            throw new TypeError('$util.uid(): Parameter `obj` must be an object or a function.');
        }

        if ($util.hasOwn(obj, $cms.id())) {
            return obj[$cms.id()];
        }

        var id = uniqueId();
        properties(obj, keyValue($cms.id(), id));
        return id;
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
                if ($util.hasOwn(val, key)) {
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
        val = strVal(val);
        
        return (val !== '') && isFinite(val);
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

        mask = Number(mask) || 0;

        for (key in source) {
            tgt = target[key];
            src = source[key];

            if (
                (src === undefined)
                || ((mask & EXTEND_TGT_OWN_ONLY) && !$util.hasOwn(target, key))
                || ((mask & EXTEND_SRC_OWN_ONLY) && !$util.hasOwn(source, key))
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
            if (!$util.hasOwn(props, key)) {
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
        return Object.prototype.toString.call(val).slice(8, -1); // slice off the surrounding '[object ' and ']'
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

        // if (((typeof val === 'object') && (val.valueOf === Object.prototype.valueOf)) || ((typeof val === 'function') && (val.valueOf === noop.valueOf))) {
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

        // if (((typeof val === 'object') && (val.valueOf === Object.prototype.valueOf)) || ((typeof val === 'function') && (val.valueOf === noop.valueOf))) {
        //     throw new TypeError('numVal(): Cannot coerce `val` of type "' + typeName(val) + '" to a number.');
        // }

        val = Number(val);

        return (val && (val !== Infinity) && (val !== -Infinity)) ? val : 0;
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
        } else if ((typeof val === 'object') && (val.toString !== Object.prototype.toString) && (typeof val.toString === 'function')) {
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

    /**
     * Creates and returns a new, throttled version of the passed function, that, when invoked repeatedly, 
     * will only actually call the original function at most once per every wait milliseconds. 
     * Useful for rate-limiting events that occur faster than you can keep up with.
     * By default, throttle will execute the function as soon as you call it for the first time, and, if you call it again any number of times during 
     * the wait period, as soon as that period is over. If you'd like to disable the leading-edge call, pass {leading: false}, 
     * and if you'd like to disable the execution on the trailing-edge, pass {trailing: false}.
     * @param func
     * @param wait
     * @param options
     * @return {function}
     */
    function throttle(func, wait, options) {
        var context, args, result,
            timeout = null,
            previous = 0;
        
        if (!options) {
            options = {};
        }
        
        var later = function() {
            previous = options.leading === false ? 0 : Date.now();
            timeout = null;
            result = func.apply(context, args);
            if (!timeout) {
                context = args = null;
            }
        };
        
        return function throttledFn() {
            var now = Date.now();
            if (!previous && options.leading === false) {
                previous = now;
            }
            var remaining = wait - (now - previous);
            context = this;
            args = arguments;
            if (remaining <= 0 || remaining > wait) {
                if (timeout) {
                    clearTimeout(timeout);
                    timeout = null;
                }
                previous = now;
                result = func.apply(context, args);
                if (!timeout) {
                    context = args = null;
                }
            } else if (!timeout && options.trailing !== false) {
                timeout = setTimeout(later, remaining);
            }
            return result;
        };
    }

    /**
     * Creates and returns a new debounced version of the passed function which will postpone its execution until after wait milliseconds have elapsed since the last time it was invoked. 
     * Useful for implementing behavior that should only happen after the input has stopped arriving. 
     * For example: rendering a preview of a Markdown comment, recalculating a layout after the window has stopped being resized, and so on.
     * At the end of the wait interval, the function will be called with the arguments that were passed most recently to the debounced function.
     * Pass true for the immediate argument to cause debounce to trigger the function on the leading instead of the trailing edge of the wait interval. 
     * Useful in circumstances like preventing accidental double-clicks on a "submit" button from firing a second time.
     * @param func
     * @param wait
     * @param immediate
     * @return {function}
     */
    function debounce(func, wait, immediate) {
        var timeout, args, context, timestamp, result;

        var later = function() {
            var last = Date.now() - timestamp;

            if (last < wait && last >= 0) {
                timeout = setTimeout(later, wait - last);
            } else {
                timeout = null;
                if (!immediate) {
                    result = func.apply(context, args);
                    if (!timeout) {
                        context = args = null;
                    }
                }
            }
        };

        return function debouncedFn() {
            context = this;
            args = arguments;
            timestamp = Date.now();
            var callNow = immediate && !timeout;
            if (!timeout) {
                timeout = setTimeout(later, wait);
            }
            if (callNow) {
                result = func.apply(context, args);
                context = args = null;
            }

            return result;
        };
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
            var uid = $util.uid(obj);
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
            var uid = $util.uid(obj);
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
            var uid = $util.uid(obj);
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
        rgxHttp = /^https?:(?=\/\/)/i;
    /**
     * NB: Has a trailing slash when having the base url only
     * @memberof $cms
     * @namespace
     * @method
     * @param {string} url - An absolute or relative URL. If url is a relative URL, `base` will be used as the base URL. If url is an absolute URL, a given `base` will be ignored.
     * @param {string} [base] - The base URL to use in case url is a relative URL. If not specified, it defaults to $cms.baseUrl().
     * @return { URL }
     */
    $cms.url = function url(url, base) {
        url = strVal(url);
        base = strVal(base) || ($cms.getBaseUrl() + '/');

        if (url.startsWith('//')) {
            // URL constructor throws on scheme-relative URLs
            url = window.location.protocol + url;
        }
        
        return new URL(url, base);
    };

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
        return !isAbsolute(url) && !$util.isSchemeRelative(url);
    }

    $util.isSchemeRelative = function isSchemeRelative(url) {
        url = strVal(url);
        return url.startsWith('//');
    };
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
    function parseJson5(source) {
        return window.JSON5.parse(strVal(source));
    }

    function inform() {
        if ($cms.isDevMode()) {
            return console.log.apply(undefined, arguments);
        }
    }

    function warn() {
        return console.warn.apply(undefined, arguments);
    }

    function fatal() {
        return console.error.apply(undefined, arguments);
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
            sheetHref = schemeRelative('{$FIND_SCRIPT_NOHTTP;,sheet}?sheet=' + sheetName + $cms.keep());
        } else {
            sheetHref = schemeRelative(sheetNameOrHref);
        }

        if (sheetName != null) {
            sheetEl = _findCssByName(sheetName);
        }

        if (sheetEl == null) {
            sheetEl = _findCssByHref(sheetHref);
        }

        if (sheetEl == null) {
            sheetEl = document.createElement('link');
            sheetEl.id = 'css-' + ((sheetName != null) ? sheetName : $util.random());
            sheetEl.rel = 'stylesheet';
            sheetEl.nonce = $cms.getCspNonce();
            sheetEl.href = sheetHref;
            document.head.appendChild(sheetEl);
        }

        return $dom.waitForResources(sheetEl);
    }

    function _findCssByName(stylesheetName) {
        stylesheetName = strVal(stylesheetName);

        var els = $dom.$$('link[id^="css-' + stylesheetName + '"]'), scriptEl;

        for (var i = 0; i < els.length; i++) {
            scriptEl = els[i];
            if ((new RegExp('^css-' + stylesheetName + '(?:_non_minified)?(?:_ssl)?(?:_mobile)?$', 'i')).test(scriptEl.id)) {
                return scriptEl;
            }
        }

        return null;
    }
    
    function _findCssByHref(href) {
        var els = $dom.$$('link[rel="stylesheet"][href]'), el;

        href = schemeRelative(href);

        for (var i = 0; i < els.length; i++) {
            el = els[i];
            if (schemeRelative(el.href) === href) {
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
            scriptSrc = schemeRelative('{$FIND_SCRIPT_NOHTTP;,javascript}?script=' + scriptName + $cms.keep());
        } else {
            scriptSrc = schemeRelative(scriptNameOrSrc);
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
            scriptEl.id = 'javascript-' + ((scriptName != null) ? scriptName : $util.random());
            scriptEl.nonce = $cms.getCspNonce();
            scriptEl.src = scriptSrc;
            document.body.appendChild(scriptEl);
        }

        return $dom.waitForResources(scriptEl);
    }
    
    function _findScriptByName(scriptName) {
        scriptName = strVal(scriptName);

        var els = $dom.$$('script[id^="javascript-' + scriptName + '"]'), el;

        for (var i = 0; i < els.length; i++) {
            el = els[i];
            if ((new RegExp('^javascript-' + scriptName + '(?:_non_minified)?(?:_ssl)?(?:_mobile)?$', 'i')).test(el.id)) {
                return el;
            }
        }

        return null;
    }
    
    function _findScriptBySrc(src) {
        var els = $dom.$$('script[src]'), el;
        
        src = schemeRelative(src);
        
        for (var i = 0; i < els.length; i++) {
            el = els[i];
            if (schemeRelative(el.src) === src) {
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

        var forms = $dom.$$('form'),
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
    
    /**
     * Inspired by goog.inherits and Babel's generated output for ES6 classes
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
        return readCookie($cms.getSessionCookie()); // Session also works as a CSRF-token, as client-side knows it (AJAX)
    }

    function getSessionId() {
        return readCookie($cms.getSessionCookie());
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

        if ($cms.getCookiePath() !== '') {
            output += ';path=' + $cms.getCookiePath();
        }

        if ($cms.getCookieDomain() !== '') {
            output += ';domain=' + $cms.getCookieDomain();
        }

        document.cookie = output;

        var read = $cms.readCookie(cookieName);

        if (read && (read !== cookieValue) && $cms.isDevMode() && !alertedCookieConflict) {
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
            names = names.concat(byPriority[priority]);
        }

        return names;
    }

    /**
     * @param context
     * @param settings
     */
    function attachBehaviors(context, settings) {
        if (!isDoc(context) && !isEl(context)) {
            throw new TypeError('Invalid argument type: `context` must be of type HTMLDocument or HTMLElement');
        }

        settings || (settings = $cms.settings);

        //$dom.waitForResources($dom.$$$(context, 'script[src]')).then(function () { // Wait for <script> dependencies to load
        // Execute all of them.
        var names = behaviorNamesByPriority();

        _attach(0);

        function _attach(i) {
            var name = names[i], ret;

            if (isObj($cms.behaviors[name]) && (typeof $cms.behaviors[name].attach === 'function')) {
                try {
                    ret = $cms.behaviors[name].attach(context, settings);
                    //$util.inform('$cms.attachBehaviors(): attached behavior "' + name + '" to context', context);
                } catch (e) {
                    $util.fatal('$cms.attachBehaviors(): Error while attaching behavior "' + name + '"  to', context, '\n', e);
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

        if (!isDoc(context) && !isEl(context)) {
            throw new TypeError('Invalid argument type: `context` must be of type HTMLDocument or HTMLElement');
        }

        settings || (settings = $cms.settings);
        trigger || (trigger = 'unload');

        // Detach all of them.
        for (name in $cms.behaviors) {
            if (isObj($cms.behaviors[name]) && (typeof $cms.behaviors[name].detach === 'function')) {
                try {
                    $cms.behaviors[name].detach(context, settings, trigger);
                    //$util.inform('$cms.detachBehaviors(): detached behavior "' + name + '" from context', context);
                } catch (e) {
                    $util.fatal('$cms.detachBehaviors(): Error while detaching behavior \'' + name + '\' from', context, '\n', e);
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
            _blockDataCache[url] = $dom.html(targetDiv);
        }

        var ajaxUrl = url;
        if (newBlockParams !== '') {
            ajaxUrl += '&block_map_sup=' + encodeURIComponent(newBlockParams);
        }

        ajaxUrl += '&utheme=' + $cms.getTheme();
        if ((_blockDataCache[ajaxUrl] !== undefined) && (postParams == null)) {
            // Show results from cache
            showBlockHtml(_blockDataCache[ajaxUrl], targetDiv, append, inner);
            return Promise.resolve();
        }

        
        var loadingWrapper = targetDiv;
        if (!loadingWrapper.id.includes('carousel_') && !$dom.html(loadingWrapper).includes('ajax_loading_block') && showLoadingAnimation) {
            document.body.style.cursor = 'wait';
        }

        return new Promise(function (resolvePromise) {
            // Make AJAX call
            $cms.doAjaxRequest(ajaxUrl + $cms.keep(), null, postParams).then(function (xhr) { // Show results when available
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
                $dom.remove(ajaxLoading.parentNode);
            }
            
            document.body.style.cursor = '';

            // Put in HTML
            showBlockHtml(newHtml, targetDiv, append, inner);

            // Scroll up if required
            if (scrollToTopOfWrapper) {
                try {
                    window.scrollTo(0, $dom.findPosY(targetDiv));
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
                $dom.append(targetDiv, newHtml);
            } else {
                if (inner) {
                    $dom.html(targetDiv, newHtml);
                } else {
                    $dom.replaceWith(targetDiv, newHtml);
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

        var title = $dom.html(document.querySelector('title')).replace(/ \u2013 .*/, ''),
            canonical = document.querySelector('link[rel="canonical"]'),
            url = canonical ? canonical.getAttribute('href') : window.location.href,
            url2 = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=' + snippetHook + '&url=' + encodeURIComponent($cms.protectURLParameter(url)) + '&title=' + encodeURIComponent(title) + $cms.keep();

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
            url.searchParams.set('utheme', $cms.getTheme());
        }

        return url.toString();
    }

    /**
     * Alternative to $cms.keep(), accepts a URL and ensures not to cause duplicate keep_* params
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
        if ($cms.configOption('google_analytics') && !$cms.isStaff() && !$cms.isAdmin()) {
            if (!category) {
                category = '{!URL;^}';
            }

            if (!action) {
                action = el ? el.href : '{!UNKNOWN;^}';
            }

            var okay = true;
            try {
                $util.inform('Beacon', 'send', 'event', category, action);

                window.ga('send', 'event', category, action, { transport: 'beacon', hitCallback: callback});
            } catch(err) {
                okay = false;
            }

            if (okay) {
                if (el) { // pass as null if you don't want this
                    setTimeout(function () {
                        $util.navigate(el);
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
        var bi = $dom.$id('main_website_inner');
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
            currentHeight = parseInt($dom.css(textAreaEl, 'height')) || 0;

        if ((scrollHeight > 5) && (currentHeight < scrollHeight) && (offsetHeight < scrollHeight)) {
            $dom.css(textAreaEl, {
                height: (scrollHeight + 2) + 'px',
                boxSizing: 'border-box',
                overflowY: 'auto'
            });
            $dom.triggerResize();
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
            $util.fatal('$cms.executeJsFunctionCalls(): Argument 1 must be an array, "' + typeName(functionCallsArray) + '" passed');
            return;
        }

        functionCallsArray.forEach(function (func) {
            var funcName, args;

            if (typeof func === 'string') {
                func = [func];
            }

            if (!Array.isArray(func) || (func.length < 1)) {
                $util.fatal('$cms.executeJsFunctionCalls(): Invalid function call format', func);
                return;
            }

            funcName = strVal(func[0]);
            args = func.slice(1);

            if (typeof $cms.functions[funcName] === 'function') {
                $cms.functions[funcName].apply(thisRef, args);
            } else {
                $util.fatal('$cms.executeJsFunctionCalls(): Function not found: $cms.functions.' + funcName);
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

        if ($dom.$('#main_website')) {
            return window;
        }

        if (anyLargeOk && ($dom.getWindowWidth() > 300)) {
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
        var img = rand && $dom.$id(rand);
        if (!img) {
            return;
        }
        new Image().src = rollover; // precache

        $dom.on(img, 'mouseover', activate);
        $dom.on(img, 'click mouseout', deactivate);

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
                return ('ontouchstart' in document.documentElement);
            case 'simplified_attachments_ui':
                return Boolean($cms.configOption('simplified_attachments_ui') && $cms.configOption('complex_uploader'));
            case 'non_concurrent':
                return browser.includes('iphone') || browser.includes('ipad') || browser.includes('android') || browser.includes('phone') || browser.includes('tablet');
            case 'ios':
                return browser.includes('iphone') || browser.includes('ipad');
            case 'android':
                return browser.includes('android');
            case 'wysiwyg':
                return !!$cms.configOption('wysiwyg');
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
        this.uid = $util.uid(this);
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
            return $dom.$(this.el, selector);
        },
        /**
         * @method
         */
        $$: function (selector) {
            return $dom.$$(this.el, selector);
        },
        /**
         * @method
         */
        $$$: function (selector) {
            return $dom.$$$(this.el, selector);
        },
        /**
         * @method
         */
        $closest: function (el, selector) {
            return $dom.closest(el, selector, this.el);
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
            this.el = (typeof el === 'string') ? $dom.$(el) : el;
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
            //$util.inform('$cms.View#delegate(): delegating event "' + eventName + '" for selector "' + selector + '" with listener', listener, 'and view', this);
            $dom.on(this.el, (eventName + '.delegateEvents' + uid(this)), selector, listener);
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
                $dom.off(this.el, '.delegateEvents' + uid(this));
            }
            return this;
        },

        /**
         * A finer-grained `undelegateEvents` for removing a single delegated event. `selector` and `listener` are both optional.
         * @method
         */
        undelegate: function (eventName, selector, listener) {
            $dom.off(this.el, (eventName + '.delegateEvents' + uid(this)), selector, listener);
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
                this.setElement($dom.create(result(this, 'tagName') || 'div', attrs));
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
        var scriptUrl = '{$FIND_SCRIPT_NOHTTP;,confirm_session}' + $cms.keep(true);

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
                $cms.configOption('js_overlays') ? '{!ENTER_PASSWORD_JS_2;^}' : '{!ENTER_PASSWORD_JS;^}', '', null, '{!_LOGIN;^}', 'password'
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
        id = strVal(id);
        tab = strVal(tab);
        fromUrl = !!fromUrl;
        automated = !!automated;

        if (!fromUrl) {
            var tabMarker = $dom.$id('tab__' + tab.toLowerCase());
            if (tabMarker) {
                // For URL purposes, we will change URL to point to tab
                // HOWEVER, we do not want to cause a scroll so we will be careful
                tabMarker.id = '';
                window.location.hash = '#tab__' + tab.toLowerCase();
                tabMarker.id = 'tab__' + tab.toLowerCase();
            }
        }

        var tabs = [], i, element;

        element = $dom.$id('t_' + tab);
        
        if (!element) {
            $util.fatal('$cms.ui.selectTab(): "#t_' + tab + '" element not found');
        }
        
        for (i = 0; i < element.parentElement.children.length; i++) {
            if (element.parentElement.children[i].id && (element.parentElement.children[i].id.substr(0, 2) === 't_')) {
                tabs.push(element.parentElement.children[i].id.substr(2));
            }
        }

        for (i = 0; i < tabs.length; i++) {
            element = $dom.$id(id + '_' + tabs[i]);
            if (element) {
                $dom.toggle(element, (tabs[i] === tab));

                if (tabs[i] === tab) {
                    if (window['load_tab__' + tab] === undefined) {
                        $dom.fadeIn(element);
                    }
                }
            }

            element = $dom.$id('t_' + tabs[i]);
            if (element) {
                element.classList.toggle('tab_active', tabs[i] === tab);
            }
        }

        if (window['load_tab__' + tab] !== undefined) {
            // Usually an AJAX loader
            window['load_tab__' + tab](automated, $dom.$id(id + '_' + tab));
        }
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
        width = strVal(width) || 'auto';
        pic = strVal(pic);
        height = strVal(height) || 'auto';
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
            $dom.on(el, 'mouseout.cmsTooltip', function (e) {
                if (!e.relatedTarget || !el.contains(e.relatedTarget)) {
                    $cms.ui.deactivateTooltip(el);
                }
            });

            $dom.on(el, 'mousemove.cmsTooltip', function () {
                $cms.ui.repositionTooltip(el, event, false, false, null, false, win);
            });
        } else {
            $dom.on(window, 'click.cmsTooltip', function (e) {
                if ($dom.$id(el.tooltipId) && $dom.isDisplayed($dom.$id(el.tooltipId))) {
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
        if ((el.tooltipId != null) && ($dom.$id(el.tooltipId))) {
            tooltipEl = $dom.$id(el.tooltipId);
            tooltipEl.style.display = 'none';
            $dom.empty(tooltipEl);
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
                    var newAutoWidth = $dom.getWindowWidth(win) - 30 - window.currentMouseX;
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
            tooltipEl.id = 't_' + $util.random();
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
                $dom.append(tooltipEl, tooltip);
            }

            el.tooltipOn = true;
            tooltipEl.style.display = 'block';
            if ((tooltipEl.style.width === 'auto') && ((tooltipEl.childNodes.length !== 1) || (tooltipEl.childNodes[0].nodeName.toLowerCase() !== 'img'))) {
                tooltipEl.style.width = ($dom.contentWidth(tooltipEl) + 1/*for rounding issues from em*/) + 'px'; // Fix it, to stop the browser retroactively reflowing ambiguous layer widths on mouse movement
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

        tooltipElement || (tooltipElement = $dom.$id(el.tooltipId));

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

                x = (event.type === 'focus') ? (win.pageXOffset + $dom.getWindowWidth(win) / 2) : (window.currentMouseX + styleOffsetX);
                y = (event.type === 'focus') ? (win.pageYOffset + $dom.getWindowHeight(win) / 2 - 40) : (window.currentMouseY + styleOffsetY);
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
        var width = $dom.contentWidth(tooltipElement);
        if (tooltipElement.style.width === 'auto') {
            if (width < 200) {
                // Give some breathing room, as might already have painfully-wrapped when it found there was not much space
                width = 200;
            }
        }
        var height = tooltipElement.offsetHeight;
        var xExcess = x - $dom.getWindowWidth(win) - win.pageXOffset + width + 10/*magic tolerance factor*/;
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
            var yExcess = y - $dom.getWindowHeight(win) - win.pageYOffset + height + styleOffsetY;
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

        tooltipElement || (tooltipElement = $dom.$('#' + el.tooltipId));

        if (tooltipElement) {
            $dom.off(tooltipElement, 'mouseout.cmsTooltip');
            $dom.off(tooltipElement, 'mousemove.cmsTooltip');
           // $dom.off(window, 'click.cmsTooltip');
            $dom.hide(tooltipElement);
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
        $dom.$$(selector).forEach(function (el) {
            $cms.ui.deactivateTooltip(el.ac, el);
        });
    };

    $dom.ready.then(function () {
        // Tooltips close on browser resize
        $dom.on(window, 'resize', function () {
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
        title = strVal(title) || '{!Q_SURE;^}';
        unescaped = boolVal(unescaped);

        return new Promise(function (resolveConfirm) {
            if (!$cms.configOption('js_overlays')) {
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
            if (!$cms.configOption('js_overlays')) {
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
            if (!$cms.configOption('js_overlays')) {
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
            if (!$cms.configOption('js_overlays')) {
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
                                height = '' + ($dom.getWindowHeight() - 200);
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
        cancelText = strVal(cancelText) || '{!INPUTSYSTEM_CANCEL;^}';

        return new Promise(function (resolveOpen) {
            if (!$cms.configOption('js_overlays')) {
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

        var uid = $util.uid(btn),
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

            $dom.on(window, 'pagehide', enableDisabledButton);
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
        var buttons = $dom.$$(form, 'input[type="submit"], input[type="button"], input[type="image"], button');

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
        var buttons = $dom.$$('input[accesskey="u"], button[accesskey="u"], input[accesskey="p"], button[accesskey="p"]');

        permanent = Boolean(permanent);

        buttons.forEach(function (btn) {
            if (!btn.disabled && !tempDisabledButtons[$util.uid(btn)]/*We do not want to interfere with other code potentially operating*/) {
                $cms.ui.disableButton(btn, permanent);
            }
        });
    };
    
    $cms.ui.enableSubmitAndPreviewButtons = function enableSubmitAndPreviewButtons() {
        // [accesskey="u"] identifies submit button, [accesskey="p"] identifies preview button
        var buttons = $dom.$$('input[accesskey="u"], button[accesskey="u"], input[accesskey="p"], button[accesskey="p"]');
        
        buttons.forEach(function (btn) {
            if (btn.disabled && !tempDisabledButtons[$util.uid(btn)]/*We do not want to interfere with other code potentially operating*/) { 
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
                $dom.html(video, initialImgUrl);
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
            lightboxImage = modal.topWindow.$dom.$id('lightbox_image'),
            lightboxMeta = modal.topWindow.$dom.$id('lightbox_meta'),
            lightboxDescription = modal.topWindow.$dom.$id('lightbox_description'),
            lightboxPositionInSet = modal.topWindow.$dom.$id('lightbox_position_in_set'),
            lightboxFullLink = modal.topWindow.$dom.$id('lightbox_full_link'),
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
        $dom.on(window, 'resize', dimsFunc);

        function dimsFunc() {
            lightboxDescription.style.display = (lightboxDescription.firstChild) ? 'inline' : 'none';
            if (lightboxFullLink) {
                var showLightboxFullLink = !!(!isVideo && hasFullButton && ((realWidth > maxWidth) || (realHeight > maxHeight)));
                $dom.toggle(lightboxFullLink, showLightboxFullLink);
            }
            var showLightboxMeta = !!((lightboxDescription.style.display === 'inline') || (lightboxPositionInSet !== null) || (lightboxFullLink && lightboxFullLink.style.display === 'inline'));
            $dom.toggle(lightboxMeta, showLightboxMeta);

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
                var maxWidth = modal.topWindow.$dom.getWindowWidth() - 20,
                    maxHeight = modal.topWindow.$dom.getWindowHeight() - 60;

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
        this.WINDOW_SIDE_GAP = $cms.isMobile() ? 5 : 25;
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
        params = $util.defaults({ // apply defaults
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

    $util.inherits(ModalWindow, $cms.View, /**@lends $cms.views.ModalWindow#*/ {
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

            this.el = $dom.create('div', { // Black out the background
                'className': 'js-modal-background js-modal-type-' + this.type,
                'css': {
                    'background': 'rgba(0,0,0,0.7)',
                    'zIndex': this.topWindow.overlayZIndex++,
                    'overflow': 'hidden',
                    'position': $cms.isMobile() ? 'absolute' : 'fixed',
                    'left': '0',
                    'top': '0',
                    'width': '100%',
                    'height': '100%'
                }
            });
            
            this.topWindow.document.body.appendChild(this.el);

            this.overlayEl = this.el.appendChild($dom.create('div', { // The main overlay
                'className': 'box overlay js-modal-overlay ' + this.type,
                'role': 'dialog',
                'css': {
                    // This will be updated immediately in resetDimensions
                    'position': $cms.isMobile() ? 'static' : 'fixed',
                    'margin': '0 auto' // Centering for iOS/Android which is statically positioned (so the container height as auto can work)
                }
            }));

            this.containerEl = this.overlayEl.appendChild($dom.create('div', {
                'className': 'box_inner js-modal-container',
                'css': {
                    'width': 'auto',
                    'height': 'auto'
                }
            }));

            var overlayHeader = null;
            if (this.title !== '' || this.type === 'iframe') {
                overlayHeader = $dom.create('h3', {
                    'html': this.title,
                    'css': {
                        'display': (this.title === '') ? 'none' : 'block'
                    }
                });
                this.containerEl.appendChild(overlayHeader);
            }

            if (this.text !== '') {
                if (this.type === 'prompt') {
                    var div = $dom.create('p');
                    div.appendChild($dom.create('label', {
                        'htmlFor': 'overlay_prompt',
                        'html': this.text
                    }));
                    this.containerEl.appendChild(div);
                } else {
                    this.containerEl.appendChild($dom.create('div', {
                        'html': this.text
                    }));
                }
            }

            this.buttonContainerEl = $dom.create('p', {
                'className': 'proceed_button js-modal-button-container'
            });

            var self = this;

            $dom.on(this.overlayEl, 'click', function (e) {
                if ($cms.isMobile() && (self.type === 'lightbox')) { // IDEA: Swipe detect would be better, but JS does not have this natively yet
                    self.option('right');
                }
            });

            switch (this.type) {
                case 'iframe':
                    var iframeWidth = (this.width.match(/^[\d\.]+$/) !== null) ? ((this.width - 14) + 'px') : this.width,
                        iframeHeight = (this.height.match(/^[\d\.]+$/) !== null) ? (this.height + 'px') : ((this.height === 'auto') ? (this.LOADING_SCREEN_HEIGHT + 'px') : this.height);

                    var iframe = $dom.create('iframe', {
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

                    $dom.animateFrameLoad(iframe, 'overlay_iframe', 50, true);

                    setTimeout(function () {
                        if (self.el) {
                            $dom.on(self.el, 'click', function (e) { 
                                if (!self.containerEl.contains(e.target)) {
                                    // Background overlay clicked
                                    self.option('finished');
                                }
                            });
                        }
                    }, 1000);

                    $dom.on(iframe, 'load', function () {
                        if ($dom.hasIframeAccess(iframe) && (!iframe.contentDocument.querySelector('h1')) && (!iframe.contentDocument.querySelector('h2'))) {
                            if (iframe.contentDocument.title) {
                                $dom.html(overlayHeader, $cms.filter.html(iframe.contentDocument.title));
                                $dom.show(overlayHeader);
                            }
                        }
                    });

                    // Fiddle it, to behave like a popup would
                    setTimeout(function () {
                        $dom.illustrateFrameLoad('overlay_iframe');
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
                        button = $dom.create('button', {
                            'type': 'button',
                            'html': this.yesButton,
                            'className': 'buttons__proceed button_screen_item js-onclick-do-option-yes'
                        });

                        this.buttonContainerEl.appendChild(button);
                    }
                    setTimeout(function () {
                        if (self.el) {
                            $dom.on(self.el, 'click', function (e) {
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
                    button = $dom.create('button', {
                        'type': 'button',
                        'html': this.yesButton,
                        'className': 'buttons__yes button_screen_item js-onclick-do-option-yes',
                        'style': 'font-weight: bold;'
                    });
                    this.buttonContainerEl.appendChild(button);
                    button = $dom.create('button', {
                        'type': 'button',
                        'html': this.noButton,
                        'className': 'buttons__no button_screen_item js-onclick-do-option-no'
                    });
                    this.buttonContainerEl.appendChild(button);
                    break;

                case 'prompt':
                    this.input = $dom.create('input', {
                        'name': 'prompt',
                        'id': 'overlay_prompt',
                        'type': this.inputType,
                        'size': '40',
                        'className': 'wide_field',
                        'value': (this.defaultValue === null) ? '' : this.defaultValue
                    });
                    var inputWrap = $dom.create('div');
                    inputWrap.appendChild(this.input);
                    this.containerEl.appendChild(inputWrap);

                    if (this.yes) {
                        button = $dom.create('button', {
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
                            $dom.on(self.el, 'click', function (e) {
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
                    button = $dom.create('button', {
                        'type': 'button',
                        'html': this.cancelButton,
                        'className': 'button_screen_item buttons__cancel ' + (this.cancel ? 'js-onclick-do-option-cancel' : 'js-onclick-do-option-finished')
                    });
                    this.buttonContainerEl.appendChild(button);
                } else {
                    button = $dom.create('img', {
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
                    this.containerEl.appendChild($dom.create('hr', {'className': 'spaced_rule'}));
                }
                this.containerEl.appendChild(this.buttonContainerEl);
            }

            // Handle dimensions
            this.resetDimensions(this.width, this.height, true);
            $dom.on(window, 'resize', function () {
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
                $dom.on(document, 'keyup.modalWindow' + this.uid, self.keyup.bind(self));
                $dom.on(document, 'mousemove.modalWindow' + this.uid, self.mousemove.bind(self));
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

                $dom.off(document, 'keyup.modalWindow' + this.uid);
                $dom.off(document, 'mousemove.modalWindow' + this.uid);
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
            
            var topPageHeight = this.topWindow.$dom.getWindowScrollHeight(),
                topWindowWidth = this.topWindow.$dom.getWindowWidth(),
                topWindowHeight = this.topWindow.$dom.getWindowHeight();
                
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

            if ($dom.hasIframeAccess(iframe) && (iframe.contentDocument.body)) { // Balance iframe height
                iframe.style.width = '100%';
                if (height === 'auto') {
                    if (!init) {
                        detectedBoxHeight = $dom.getWindowScrollHeight(iframe.contentWindow);
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
            if ($cms.isMobile() || (detectedBoxHeight > topWindowHeight) || (this.el.style.position === 'absolute'/*don't switch back to fixed*/)) {
                var wasFixed = (this.el.style.position === 'fixed');

                this.el.style.position = 'absolute';
                this.el.style.height = ((topPageHeight > (detectedBoxHeight + bottomGap + boxPosLeft)) ? topPageHeight : (detectedBoxHeight + bottomGap + boxPosLeft)) + 'px';
                this.topWindow.document.body.style.overflow = '';

                if (!$cms.isMobile()) {
                    this.overlayEl.style.position = 'absolute';
                    this.overlayEl.style.top = this.WINDOW_TOP_GAP + 'px';
                }

                if (init || wasFixed) {
                    doScroll = true;
                }

                if (iframe && ($dom.hasIframeAccess(iframe)) && (iframe.contentWindow.scrolledUpFor === undefined)) { /*maybe a navigation has happened and we need to scroll back up*/
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
                    if (iframe && ($dom.hasIframeAccess(iframe))) {
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
            
            if (!$dom.hasIframeAccess(iframe) || !iDoc.body || (iDoc.body.donePopupTrans !== undefined)) {
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

            if ($dom.html(iDoc.body).length > 300) { // Loaded now
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

            if ((window.showModalDialog !== undefined) || $cms.configOption('js_overlays')) {
                // @TODO: window.showModalDialog() was removed completely in Chrome 43, and Firefox 55. See WebKit bug 151885 for possible future removal from Safari.
                if (buttonSet.length > 4) {
                    dialogHeight += 5 * (buttonSet.length - 4);
                }

                // Intentionally FIND_SCRIPT and not FIND_SCRIPT_NOHTTP, because no needs-HTTPS security restriction applies to popups, yet popups do not know if they run on HTTPS if behind a transparent reverse proxy
                var url = $cms.maintainThemeInLink('{$FIND_SCRIPT;,question_ui}?message=' + encodeURIComponent(message) + '&image_set=' + encodeURIComponent(imageSet.join(',')) + '&button_set=' + encodeURIComponent(buttonSet.join(',')) + '&window_title=' + encodeURIComponent(windowTitle) + $cms.keep());
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
                    //$cms.ui.alert(xhr.responseText, '{!ERROR_OCCURRED;^}', true);
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
                        $util.fatal('$cms.doAjaxRequest(): {!PROBLEM_RETRIEVING_XML;^}\n' + xhr.status + ': ' + xhr.statusText + '.', xhr);
                    }
                } catch (e) {
                    $util.fatal('$cms.doAjaxRequest(): {!PROBLEM_RETRIEVING_XML;^}', e); // This is probably clicking back
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
        
        var baseUrl = $cms.baseUrl();

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
                data = parseJson5(data);
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
                            //$util.inform('$cms.form.doAjaxFieldTest()', 'xhr.responseText:', xhr.responseText);
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

    $dom.ready.then(function () {
        $cms.attachBehaviors(document);
    });

    $cms.defineBehaviors(/**@lends $cms.behaviors*/{

        // Implementation for [data-require-javascript="[<scripts>...]"]
        //initializeRequireJavascript: {
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
        //},
        // TODO: Is this dead code? Is data-require-javascript in use or should be stripped? What's the purpose verses Tempcode method?

        // Implementation for [data-view]
        initializeViews: {
            attach: function (context) {
                $util.once($dom.$$$(context, '[data-view]'), 'behavior.initializeViews').forEach(function (el) {
                    var params = objVal($dom.data(el, 'viewParams')),
                        viewName = el.dataset.view,
                        viewOptions = { el: el };

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
        },

        // Implementation for [data-tpl]
        initializeTemplates: {
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
        },

        initializeAnchors: {
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
        },

        initializeForms: {
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
        },

        initializeInputs: {
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
        },

        initializeTables: {
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
        },
        
        // Implementation for [data-textarea-auto-height]
        textareaAutoHeight: {
            attach: function attach(context) {
                if ($cms.isMobile()) {
                    return;
                }
                
                var textareas = $dom.$$$(context, '[data-textarea-auto-height]');
                
                for (var i = 0; i < textareas.length; i++) {
                    $cms.manageScrollHeight(textareas[i]);
                }
            }
        },

        columnHeightBalancing: {
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
        },

        // Convert img title attributes into composr tooltips
        imageTooltips: {
            attach: function (context) {
                if (!$cms.configOption('js_overlays')) {
                    return;
                }

                $util.once($dom.$$$(context, 'img:not([data-cms-rich-tooltip])'), 'behavior.imageTooltips').forEach(function (img) {
                    convertTooltip(img);
                });
            }
        },

        // Implementation for [data-remove-if-js-enabled]
        removeIfJsEnabled: {
            attach: function (context) {
                var els = $dom.$$$(context, '[data-remove-if-js-enabled]');

                els.forEach(function (el) {
                    $dom.remove(el);
                });
            }
        },

        // Implementation for [data-js-function-calls]
        jsFunctionCalls: {
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
        },


        // Implementation for [data-cms-select2]
        select2Plugin: {
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
        },

        // Implementation for img[data-gd-text]
        gdTextImages: {
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
        },

        // Implementation for [data-toggleable-tray]
        toggleableTray: {
            attach: function (context) {
                var els = $util.once($dom.$$$(context, '[data-toggleable-tray]'), 'behavior.toggleableTray');

                els.forEach(function (el) {
                    var options = $dom.data(el, 'toggleableTray') || {};
                    
                    $dom.data(el).toggleableTrayObject = new $cms.views.ToggleableTray(options, { el: el });
                });
            }
        }
    });

    /**
     * @memberof $cms.views
     * @class $cms.views.Global
     * @extends $cms.View
     * */
    $cms.views.Global = function Global() {
        Global.base(this, 'constructor', arguments);

        /*START JS from HTML_HEAD.tpl*/
        // Google Analytics account, if one set up
        if ($cms.configOption('google_analytics').trim() && !$cms.isStaff() && !$cms.isAdmin()) {
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

            if ($cms.getCookieDomain() !== '') {
                aConfig.cookieDomain = $cms.getCookieDomain();
            }
            if (!$cms.configOption('long_google_cookies')) {
                aConfig.cookieExpires = 0;
            }

            window.ga('create', $cms.configOption('google_analytics').trim(), aConfig);

            if (!$cms.isGuest()) {
                window.ga('set', 'userId', strVal($cms.getMember()));
            }

            if ($cms.pageSearchParams().has('_t')) {
                window.ga('send', 'event', 'tracking__' + strVal($cms.pageSearchParams().get('_t')), window.location.href);
            }

            window.ga('send', 'pageview');
        }

        // Cookie Consent plugin by Silktide - http://silktide.com/cookieconsent
        if ($cms.configOption('cookie_notice') && ($cms.runningScript() === 'index')) {
            window.cookieconsent_options = {
                message: $util.format('{!COOKIE_NOTICE;}', [$cms.getSiteName()]),
                dismiss: '{!INPUTSYSTEM_OK;}',
                learnMore: '{!READ_MORE;}',
                link: '{$PAGE_LINK;,:privacy}',
                theme: 'dark-top'
            };
            $cms.requireJavascript('https://cdnjs.cloudflare.com/ajax/libs/cookieconsent2/1.0.9/cookieconsent.min.js');
        }

        if ($cms.configOption('detect_javascript')) {
            this.detectJavascript();
        }
        /*END JS from HTML_HEAD.tpl*/

        $dom.registerMouseListener();

        if ($dom.$('#global_messages_2')) {
            var m1 = $dom.$('#global_messages');
            if (!m1) {
                return;
            }
            var m2 = $dom.$('#global_messages_2');
            $dom.append(m1, $dom.html(m2));
            m2.parentNode.removeChild(m2);
        }

        if (boolVal($cms.pageSearchParams().get('wide_print'))) {
            try {
                window.print();
            } catch (ignore) {}
        }

        if (($cms.getZoneName() === 'adminzone') && $cms.configOption('background_template_compilation')) {
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
        if ($cms.configOption('detect_javascript')) {
            $cms.setCookie('js_on', 1, 120);
        }

        if ($cms.configOption('is_on_timezone_detection')) {
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
            if (pastedData && (pastedData.length > $cms.configOption('spam_heuristic_pasting'))) {
                $cms.setPostDataFlag('paste');
            }
        });

        if ($cms.isStaff()) {
            this.loadStuffStaff()
        }
    };

    $util.inherits($cms.views.Global, $cms.View, /**@lends $cms.views.Global#*/{
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
            var stuckNavs = $dom.$$('.stuck_nav');

            if (!stuckNavs.length) {
                return;
            }

            $dom.on(window, 'scroll', function () {
                for (var i = 0; i < stuckNavs.length; i++) {
                    var stuckNav = stuckNavs[i],
                        stuckNavHeight = (stuckNav.realHeight === undefined) ? $dom.contentHeight(stuckNav) : stuckNav.realHeight;

                    stuckNav.realHeight = stuckNavHeight;
                    var posY = $dom.findPosY(stuckNav.parentNode, true),
                        footerHeight = document.querySelector('footer') ? document.querySelector('footer').offsetHeight : 0,
                        panelBottom = $dom.$id('panel_bottom');

                    if (panelBottom) {
                        footerHeight += panelBottom.offsetHeight;
                    }
                    panelBottom = $dom.$id('global_messages_2');
                    if (panelBottom) {
                        footerHeight += panelBottom.offsetHeight;
                    }
                    if (stuckNavHeight < $dom.getWindowHeight() - footerHeight) { // If there's space in the window to make it "float" between header/footer
                        var extraHeight = (window.pageYOffset - posY);
                        if (extraHeight > 0) {
                            var width = $dom.contentWidth(stuckNav);
                            var height = $dom.contentHeight(stuckNav);
                            var stuckNavWidth = $dom.contentWidth(stuckNav);
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
                uid = $util.uid(clicked);

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
            var options = objVal($dom.data(target, e.type + 'Alert'), {}, 'notice');
            $cms.ui.alert(options.notice);
        },

        // Implementation for [data-submit-on-enter]
        submitOnEnter: function submitOnEnter(e, input) {
            if ($dom.keyPressed(e, 'Enter')) {
                $dom.submit(input.form);
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
            var anchorClicked = !!$dom.closest(e.target, 'a', el);

            // Make sure a child <a> element wasn't clicked and default wasn't prevented
            if (!anchorClicked && !e.defaultPrevented) {
                $util.navigate(el);
            }
        },

        // Implementation for [data-click-forward="{ child: '.some-selector' }"]
        clickForward: function (e, el) {
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
        },

        // Implementation for [data-mouseover-class="{ 'some-class' : 1|0 }"]
        mouseoverClass: function (e, target) {
            var classes = objVal($dom.data(target, 'mouseoverClass')), key, bool;

            if (!e.relatedTarget || !target.contains(e.relatedTarget)) {
                for (key in classes) {
                    bool = !!classes[key] && (classes[key] !== '0');
                    target.classList.toggle(key, bool);
                }
            }
        },

        // Implementation for [data-mouseout-class="{ 'some-class' : 1|0 }"]
        mouseoutClass: function (e, target) {
            var classes = objVal($dom.data(target, 'mouseoutClass')), key, bool;

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
                checkboxes = $dom.$$$(selector)
            }

            checkboxes.forEach(function (checkbox) {
                $dom.toggleChecked(checkbox);
            });
        },

        // Implementation for [data-disable-on-click]
        disableButton: function (e, target) {
            $cms.ui.disableButton(target);
        },

        // Implementation for [data-change-submit-form]
        changeSubmitForm: function (e, input) {
            if (input.form != null) {
                $dom.submit(input.form);
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
            } else if ($dom.keyOutput(e, regex)) { // keydown/keypress event
                // pattern matched, prevent input
                e.preventDefault();
            }
        },

        // Implementation for textarea[data-textarea-auto-height]
        doTextareaAutoHeight: function (e, textarea) {
            if ($cms.isMobile()) {
                return;
            }

            $cms.manageScrollHeight(textarea);
        },

        // Implementation for [data-open-as-overlay]
        openOverlay: function (e, el) {
            var options, url = (el.href === undefined) ? el.action : el.href;

            if (!($cms.configOption('js_overlays'))) {
                return;
            }

            if (/:\/\/(.[^\/]+)/.exec(url)[1] !== window.location.hostname) {
                return; // Cannot overlay, different domain
            }

            e.preventDefault();

            options = objVal($dom.data(el, 'openAsOverlay'));
            options.el = el;

            openLinkAsOverlay(options);
        },

        // Implementation for [data-click-faux-open]
        clickFauxOpen: function (e, el) {
            var args = arrVal($dom.data(el, 'clickFauxOpen'));
            $cms.ui.open.apply(undefined, args);
        },

        // Implementation for `click a[rel*="lightbox"]`
        lightBoxes: function (e, el) {
            if (!($cms.configOption('js_overlays'))) {
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
            var args = arrVal($dom.data(el, 'mouseoverActivateTooltip'));

            args.unshift(el, e);

            try {
                //arguments: el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, haveLinks
                $cms.ui.activateTooltip.apply(undefined, args);
            } catch (ex) {
                $util.fatal('$cms.views.Global#mouseoverActivateTooltip(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
            }
        },

        // Implementation for [data-focus-activate-tooltip]
        focusActivateTooltip: function (e, el) {
            var args = arrVal($dom.data(el, 'focusActivateTooltip'));

            args.unshift(el, e);

            try {
                //arguments: el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, haveLinks
                $cms.ui.activateTooltip.apply(undefined, args);
            } catch (ex) {
                $util.fatal('$cms.views.Global#focusActivateTooltip(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
            }
        },

        // Implementation for [data-blur-deactivate-tooltip]
        blurDeactivateTooltip: function (e, el) {
            $cms.ui.deactivateTooltip(el);
        },

        // Implementation for [data-cms-rich-tooltip]
        activateRichTooltip: function (e, el) {
            var options = objVal($dom.data(el, 'cmsRichTooltip'));

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
                $util.fatal('$cms.views.Global#activateRichTooltip(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
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
            var options = objVal($dom.data(clicked, 'clickGaTrack'));

            e.preventDefault();
            $cms.gaTrack(clicked, options.category, options.action);
        },

        // Implementation for [data-click-tray-toggle="<TRAY ID>"]
        clickTrayToggle: function (e, clicked) {
            var trayId = strVal(clicked.dataset.clickTrayToggle),
                trayEl = $dom.$(trayId);

            if (!trayEl) {
                return;
            }
            
            var ttObj = $dom.data(trayEl).toggleableTrayObject;
            if (ttObj) {
                ttObj.toggleTray();
            }
        },

        // Implementation for [data-click-ui-open]
        clickUiOpen: function (e, clicked) {
            var args = arrVal($dom.data(clicked, 'clickUiOpen'));
            args[0] = $cms.maintainThemeInLink(args[0]);
            $cms.ui.open.apply(undefined, args);
        },

        // Implementation for [data-click-do-input]
        clickDoInput: function (e, clicked) {
            var args = arrVal($dom.data(clicked, 'clickDoInput')),
                type = strVal(args[0]),
                fieldName = strVal(args[1]),
                tag = strVal(args[2]),
                fnName = 'doInput' + $util.ucFirst($util.camelCase(type));

            if (typeof window[fnName] === 'function') {
                window[fnName](fieldName, tag);
            } else {
                $util.fatal('$cms.views.Global#clickDoInput(): Function not found "window.' + fnName + '()"');
            }
        },

        // Detecting of JavaScript support
        detectJavascript: function () {
            var url = window.location.href,
                append = '?';

            if ($cms.isJsOn() || boolVal($cms.pageSearchParams().get('keep_has_js')) || url.includes('upgrader.php') || url.includes('webdav.php')) {
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

            if ($cms.isDevMode()) {
                append += '&keep_devtest=1';
            }

            // Redirect with JS on, and then hopefully we can remove keep_has_js after one click. This code only happens if JS is marked off, no infinite loops can happen.
            window.location = url + append;
        },

        /* Software Chat */
        loadSoftwareChat: function () {
            var url = 'https://kiwiirc.com/client/irc.kiwiirc.com/?nick=';
            if ($cms.getUsername() !== 'admin') {
                url += encodeURIComponent($cms.getUsername().replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g, ''));
            } else {
                url += encodeURIComponent($cms.getSiteName().replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g, ''));
            }
            url += '#composrcms';

            var SOFTWARE_CHAT_EXTRA = $util.format('{!SOFTWARE_CHAT_EXTRA;^}', [$cms.filter.html(window.location.href.replace($cms.baseUrl(), 'http://baseurl'))]);
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

            var box = $dom.$('#software_chat_box'), img;
            if (box) {
                box.parentNode.removeChild(box);

                img = $dom.$('#software_chat_img');
                img.style.opacity = 1;
            } else {
                var width = 950,
                    height = 550;

                box = $dom.create('div', {
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
                        left: ($dom.getWindowWidth() - width) / 2 + 'px',
                        top: 100 + 'px'
                    },
                    html: html
                });

                document.body.appendChild(box);

                $dom.smoothScroll(0);

                img = $dom.$('#software_chat_img');
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
            if ($dom.keyPressed(e, 'Enter')) {
                $dom.submit(input.form);
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
            if ($cms.configOption('enable_animations')) {
                if ((window.parent === window) && !loc.includes('js_cache=1') && (loc.includes('/cms/') || loc.includes('/adminzone/'))) {
                    window.addEventListener('beforeunload', function () {
                        staffUnloadAction();
                    });
                }
            }

            // Theme image editing hovers
            var els = $dom.$$('*:not(.no_theme_img_click)'), i, el, isImage;
            for (i = 0; i < els.length; i++) {
                el = els[i];
                isImage = (el.localName === 'img') || ((el.localName === 'input') && (el.type === 'image')) || $dom.css(el, 'background-image').includes('url');

                if (isImage) {
                    $dom.on(el, {
                        mouseover: handleImageMouseOver,
                        mouseout: handleImageMouseOut,
                        click: handleImageClick
                    });
                }
            }

            /* Thumbnail tooltips */
            if ($cms.isDevMode() || loc.replace($cms.getBaseUrlNohttp(), '').includes('/cms/')) {
                var urlPatterns = $cms.staffTooltipsUrlPatterns(),
                    links, pattern, hook, patternRgx;

                links = $dom.$$('td a');
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
                var bi = $dom.$id('main_website_inner');
                if (bi) {
                    bi.classList.add('site_unloading');
                    $dom.fadeTo(bi, null, 0.2);
                }
                var div = document.createElement('div');
                div.className = 'unload_action';
                div.style.width = '100%';
                div.style.top = ($dom.getWindowHeight() / 2 - 160) + 'px';
                div.style.position = 'fixed';
                div.style.zIndex = 10000;
                div.style.textAlign = 'center';
                $dom.html(div, '<div aria-busy="true" class="loading_box box"><h2>{!LOADING;^}</h2><img id="loading_image" alt="" src="{$IMG_INLINE*;,loading}" /></div>');
                setTimeout(function () {
                    // Stupid workaround for Google Chrome not loading an image on unload even if in cache
                    if ($dom.$('#loading_image')) {
                        $dom.$('#loading_image').src += '';
                    }
                }, 100);
                document.body.appendChild(div);

                // Allow unloading of the animation
                $dom.on(window, 'pageshow keydown click', $cms.undoStaffUnloadAction)
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

                        $cms.doAjaxRequest($cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?css=1&javascript=1&raw_output=1&box_title={!PREVIEW;&}' + $cms.keep()), null, 'data=' + encodeURIComponent(comcode)).then(function (xhr) {
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

                var src = (target.src === undefined) ? $dom.css(target, 'background-image') : target.src;

                if ((target.src === undefined) && (!event.ctrlKey) && (!event.metaKey) && (!event.altKey)) {
                    return;  // Needs ctrl key for background images
                }
                if (!src.includes('/themes/') || window.location.href.includes('admin_themes')) {
                    return;
                }

                if ($cms.configOption('enable_theme_img_buttons')) {
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
                    ml.style.left = $dom.findPosX(target) + 'px';
                    ml.style.top = $dom.findPosY(target) + 'px';
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

                if ($cms.configOption('enable_theme_img_buttons')) {
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

                var src = ob.origsrc ? ob.origsrc : ((ob.src == null) ? $dom.css(ob, 'background-image').replace(/.*url\(['"]?(.*)['"]?\).*/, '$1') : ob.src);
                if (src && (force || ($cms.magicKeypress(event)))) {
                    // Bubbling needs to be stopped because shift+click will open a new window on some lower event handler (in Firefox anyway)
                    event.preventDefault();

                    if (src.includes($cms.getBaseUrlNohttp() + '/themes/')) {
                        ob.editWindow = window.open('{$BASE_URL;,0}/adminzone/index.php?page=admin_themes&type=edit_image&lang=' + encodeURIComponent($cms.userLang()) + '&theme=' + encodeURIComponent($cms.getTheme()) + '&url=' + encodeURIComponent($cms.protectURLParameter(src.replace('{$BASE_URL;,0}/', ''))) + $cms.keep(), 'edit_theme_image_' + ob.id);
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

    $util.inherits(GlobalHelperPanel, $cms.View, /**@lends GlobalHelperPanel#*/{
        events: function () {
            return {
                'click .js-click-toggle-helper-panel': 'toggleHelperPanel'
            };
        },
        toggleHelperPanel: function () {
            var show = $dom.notDisplayed(this.contentsEl),
                panelRight = $dom.$('#panel_right'),
                helperPanelContents = $dom.$('#helper_panel_contents'),
                helperPanelToggle = $dom.$('#helper_panel_toggle');

            if (show) {
                panelRight.classList.remove('helper_panel_hidden');
                panelRight.classList.add('helper_panel_visible');
                helperPanelContents.setAttribute('aria-expanded', 'true');
                helperPanelContents.style.display = 'block';
                $dom.fadeIn(helperPanelContents);

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

    $util.inherits(Menu, $cms.View);

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

    $util.inherits(DropdownMenu, Menu, /**@lends DropdownMenu#*/{
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

    $util.inherits(PopupMenu, Menu, /**@lends PopupMenu#*/{
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

    $util.inherits(PopupMenuBranch, $cms.View, /**@lends PopupMenuBranch#*/{
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

    $util.inherits(TreeMenu, Menu, /**@lends TreeMenu#*/{
        events: function () {
            return {
                'click [data-menu-tree-toggle]': 'toggleMenu'
            };
        },

        toggleMenu: function (e, target) {
            var menuId = target.dataset.menuTreeToggle;

            $cms.ui.toggleableTray($dom.$('#' + menuId));
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

    $util.inherits(MobileMenu, Menu, /**@lends $cms.views.MobileMenu#*/{
        events: function () {
            return {
                'click .js-click-toggle-content': 'toggleContent',
                'click .js-click-toggle-sub-menu': 'toggleSubMenu'
            };
        },
        toggleContent: function (e) {
            e.preventDefault();
            $dom.toggle(this.menuContentEl);
        },
        toggleSubMenu: function (e, link) {
            var rand = link.dataset.vwRand,
                subEl = this.$('#' + this.menuId + '_pexpand_' + rand),
                href;

            if ($dom.notDisplayed(subEl)) {
                $dom.show(subEl);
            } else {
                href = link.getAttribute('href');
                // Second click goes to it
                if (href && !href.startsWith('#')) {
                    return;
                }
                $dom.hide(subEl);
            }

            e.preventDefault();
        }
    });

    // For admin/templates/MENU_mobile.tpl
    /**
     * @param params
     */
    $cms.templates.menuMobile = function menuMobile(params) {
        var menuId = strVal(params.menuId);
        $dom.on(document.body, 'click', '.js-click-toggle-' + menuId + '-content', function (e) {
            var branch = document.getElementById(menuId);

            if (branch) {
                $dom.toggle(branch.parentElement);
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

    $util.inherits(SelectMenu, Menu, /**@lends SelectMenu#*/{
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
        var menuElement = $dom.$('#' + menuId),
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
        place = strVal(place) || 'right';
        outsideFixedWidth = !!outsideFixedWidth;

        var el = $dom.$('#' + id);

        if (!el) {
            return;
        }

        if (cleanMenusTimeout) {
            clearTimeout(cleanMenusTimeout);
        }

        if ($dom.isDisplayed(el)) {
            return false;
        }

        window.activeMenu = id;
        lastActiveMenu = menu;
        cleanMenus();

        var l = 0;
        var t = 0;
        var p = el.parentNode;

        // Our own position computation as we are positioning relatively, as things expand out
        if ($dom.isCss(p.parentElement, 'position', 'absolute')) {
            l += p.offsetLeft;
            t += p.offsetTop;
        } else {
            while (p) {
                if (p && $dom.isCss(p, 'position', 'relative')) {
                    break;
                }

                l += p.offsetLeft;
                t += p.offsetTop - (parseInt(p.style.borderTop) || 0);
                p = p.offsetParent;

                if (p && $dom.isCss(p, 'position', 'absolute')) {
                    break;
                }
            }
        }
        if (place === 'below') {
            t += el.parentNode.offsetHeight;
        } else {
            l += el.parentNode.offsetWidth;
        }

        var fullHeight = $dom.getWindowScrollHeight(); // Has to be got before e is visible, else results skewed
        el.style.position = 'absolute';
        el.style.left = '0'; // Setting this lets the browser calculate a more appropriate (larger) width, before we set the correct left for that width will fit
        el.style.display = 'block';
        $dom.fadeIn(el);

        var fullWidth = (window.scrollX == 0) ? $dom.getWindowWidth() : window.document.body.scrollWidth;

        if ($cms.configOption('fixed_width') && !outsideFixedWidth) {
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
                if ($dom.findPosX(el.parentNode, true) + eWidth + eParentWidth + 10 > fullWidth) posLeft -= eWidth + eParentWidth;
            }
            el.style.left = posLeft + 'px';
        }
        positionL();
        setTimeout(positionL, 0);
        function positionT() {
            var posTop = t;
            if (posTop + el.offsetHeight + 10 > fullHeight) {
                var abovePosTop = posTop - $dom.contentHeight(el) + eParentHeight - 10;
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

        var m = $dom.$('#r_' + lastActiveMenu);
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
            $dom.append(m1, $dom.html(m2));
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
                $dom.submit(button.form);
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
        $dom.on(container, 'click', '.js-click-toggle-advanced-db-setup-section', function (e, clicked) {
            var id = strVal(clicked.dataset.tpSection);
            toggleInstallerSection(id);
        });
    };

    $cms.templates.installerForumChoice = function installerForumChoice(params, container) {
        var versions = strVal(params.versions);

        $dom.on(container, 'click', '.js-click-do-forum-choose', function (e, clicked) {
            doForumChoose(clicked, $cms.filter.nl(versions));
        });

        function doForumChoose(el, versions) {
            $dom.html('#versions', versions);

            var type = 'none';
            if ((el.id !== 'none') && (el.id !== 'cns')) {
                type = 'block';
                var label = document.getElementById('sep_forum');
                if (label) {
                    $dom.html(label, el.nextElementSibling.textContent);
                }
            }

            document.getElementById('forum_database_info').style.display = type;
            if (document.getElementById('forum_path')) {
                document.getElementById('forum_path').style.display = type;
            }
        }
    };

    $cms.templates.installerInputLine = function installerInputLine(params, input) {
        $dom.on(input, 'change', function () {
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
                    window.alert($util.format('{!PASSWORDS_DO_NOT_MATCH;^/}', [fieldLabel]));
                    return false;
                }

                // Check does not match database password
                if (form.elements['db_site_password'] != null) {
                    if ((form.elements[fieldName].value !== '') && (form.elements[fieldName].value === form.elements['db_site_password'].value)) {
                        window.alert($util.format('{!PASSWORDS_DO_NOT_REUSE;^/}', [fieldLabel]));
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
                    return window.confirm($util.format('{!PASSWORD_INSECURE;^}', [fieldLabel])) && window.confirm($util.format('{!CONFIRM_REALLY;^} {!PASSWORD_INSECURE;^}', [fieldLabel]));
                }

                return true;
            }
        }
    };

    $cms.templates.installerStep4SectionHide = function installerStep4SectionHide(params, container) {
        var title = strVal(params.title);

        $dom.on(container, 'click', '.js-click-toggle-title-section', function () {
            toggleInstallerSection($cms.filter.id($cms.filter.nl(title)));
        });
    };

    $cms.templates.blockMainScreenActions = function blockMainScreenActions(params, container) {
        var easySelfUrl = strVal(params.easySelfUrl);

        $dom.on(container, 'click', '.js-click-action-print-screen', function (e, link) {
            $cms.gaTrack(null,'{!recommend:PRINT_THIS_SCREEN;}');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-facebook', function (e, link) {
            $cms.gaTrack(null,'social__facebook');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-twitter', function (e, link) {
            link.setAttribute('href', 'https://twitter.com/share?count=horizontal&counturl=' + easySelfUrl + '&original_referer=' + easySelfUrl + '&text=' + encodeURIComponent(document.title) + '&url=' + easySelfUrl);

            $cms.gaTrack(null,'social__twitter');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-stumbleupon', function (e, link) {
            $cms.gaTrack(null,'social__stumbleupon');
        });

        $dom.on(container, 'click', '.js-click-action-add-to-digg', function (e, link) {
            $cms.gaTrack(null,'social__digg');
        });
    };

    $cms.views.ToggleableTray = ToggleableTray;
    /**
     * @memberof $cms.views
     * @class $cms.views.ToggleableTray
     * @extends $cms.View
     */
    function ToggleableTray(params) {
        var id;
        
        ToggleableTray.base(this, 'constructor', arguments);

        this.contentEl = this.$('.js-tray-content');
        
        this.cookie = null;
        
        if (params.save) {
            id = $dom.id(this.el, 'tray-');
            this.cookie = id.startsWith('tray') ? id : 'tray-' + id;
        }
        
        if (this.cookie) {
            this.handleTrayCookie();
        }
    }

    $util.inherits(ToggleableTray, $cms.View, /**@lends $cms.views.ToggleableTray#*/{
        /**@method*/
        events: function () {
            return {
                'click .js-tray-onclick-toggle-tray': 'toggleTray',
                'click .js-tray-onclick-toggle-accordion': 'handleToggleAccordion'
            };
        },

        /**@method*/
        toggleTray: function () {
            var opened = $cms.ui.toggleableTray(this.contentEl);

            if (this.cookie) {
                $cms.setCookie(this.cookie, opened ? 'open' : 'closed');
            }
        },

        /**
         * @param toggledAccordionItem - Accordion item to be made active
         */
        toggleAccordion: function (toggledAccordionItem) {
            var accordionItems = this.$$('.js-tray-accordion-item');
            
            accordionItems.forEach(function (accordionItem) {
                var body = accordionItem.querySelector('.js-tray-accordion-item-body'),
                    opened;
                
                if ((accordionItem === toggledAccordionItem) || $dom.isDisplayed(body)) {
                    opened = $cms.ui.toggleableTray({ el: body });
                    accordionItem.classList.toggle('accordion_trayitem-active', opened);
                }
            });
            
        },
        /**@method*/
        handleToggleAccordion: function (e, btn) {
            var accordionItem = $dom.closest(btn, '.js-tray-accordion-item'); // Accordion item to be made active
            this.toggleAccordion(accordionItem);
        },

        /**@method*/
        handleTrayCookie: function () {
            var cookieValue = $cms.readCookie(this.cookie);

            if (($dom.notDisplayed(this.contentEl) && (cookieValue === 'open')) || ($dom.isDisplayed(this.contentEl) && (cookieValue === 'closed'))) {
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

        if ($util.isPlainObj(elOrOptions)) {
            options = elOrOptions;
            el =  options.el;
            animate = $cms.configOption('enable_animations') ? boolVal(options.animate, true) : false;
        } else {
            el = elOrOptions;
            animate = $cms.configOption('enable_animations');
        }
        
        el = $dom.elArg(el);

        var pic = $dom.$(el.parentNode, '.toggleable_tray_button img') || $dom.$('img#e_' + el.id),
            isThemeWizard = Boolean(pic && pic.src && pic.src.includes('themewizard.php'));

        if ($dom.notDisplayed(el)) {
            el.setAttribute('aria-expanded', 'true');

            if (animate) {
                $dom.slideDown(el);
            } else {
                $dom.fadeIn(el);
            }

            if (pic) {
                setTrayThemeImage('expand', 'contract', $IMG_expand, $IMG_contract, $IMG_contract2);
                pic.setAttribute('alt', pic.getAttribute('alt').replace('{!EXPAND;^}', '{!CONTRACT;^}'));
                pic.title = '{!CONTRACT;^}';
            }

            $dom.triggerResize(true);
            
            return true;
        } else {
            el.setAttribute('aria-expanded', 'false');

            if (animate) {
                $dom.slideUp(el);
            } else {
                $dom.hide(el);
            }

            if (pic) {
                setTrayThemeImage('contract', 'expand', $IMG_contract, $IMG_expand, $IMG_expand2);
                pic.setAttribute('alt', pic.getAttribute('alt').replace('{!CONTRACT;^}', '{!EXPAND;^}'));
                pic.title = '{!EXPAND;^}';
            }

            $dom.triggerResize(true);
            
            return false;
        }
        
        // Execution ends here

        function setTrayThemeImage(beforeThemeImg, afterThemeImg, before1Url, after1Url, after2Url) {
            var is1 = $dom.matchesThemeImage(pic.src, before1Url);

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
            $dom.load.then(function () {
                document.body.classList.add('frame');

                try {
                    $dom.triggerResize();
                } catch (e) {}

                setTimeout(function () { // Needed for IE10
                    try {
                        $dom.triggerResize();
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
            $dom.submit(document.getElementById(params.formName));
        } else {
            window.history.go(-2); // We've used back button, don't redirect forward again
        }
    };

    $cms.templates.forumsEmbed = function () {
        var frame = this;
        setInterval(function () {
            $dom.resizeFrame(frame.name);
        }, 500);
    };

    $cms.templates.massSelectFormButtons = function (params, delBtn) {
        var form = delBtn.form;

        $dom.on(delBtn, 'click', function () {
            confirmDelete(form, true, function () {
                var idEl = $dom.$id('id'),
                    ids = (idEl.value === '') ? [] : idEl.value.split(',');

                for (var i = 0; i < ids.length; i++) {
                    prepareMassSelectMarker('', params.type, ids[i], true);
                }

                form.method = 'post';
                form.action = params.actionUrl;
                form.target = '_top';
                $dom.submit(form);
            });
        });

        $dom.on('#id', 'change', initialiseButtonVisibility);
        initialiseButtonVisibility();

        function initialiseButtonVisibility() {
            var id = $dom.$('#id'),
                ids = (id.value === '') ? [] : id.value.split(/,/);

            $dom.$('#submit_button').disabled = (ids.length !== 1);
            $dom.$('#mass_select_button').disabled = (ids.length === 0);
        }
    };

    $cms.templates.massSelectDeleteForm = function (e, form) {
        $dom.on(form, 'submit', function (e) {
            e.preventDefault();
            confirmDelete(form, true);
        });
    };

    $cms.templates.groupMemberTimeoutManageScreen = function groupMemberTimeoutManageScreen(params, container) {
        $dom.on(container, 'focus', '.js-focus-update-ajax-member-list', function (e, input) {
            if (input.value === '') {
                $cms.form.updateAjaxMemberList(input, null, true, e);
            }
        });

        $dom.on(container, 'keyup', '.js-keyup-update-ajax-member-list', function (e, input) {
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
        if ((document.activeElement != null) || (document.activeElement !== $dom.$('#password'))) {
            try {
                $dom.$('#login_username').focus();
            } catch (ignore) {}
        }

        $dom.on(container, 'click', '.js-click-checkbox-remember-me-confirm', function (e, checkbox) {
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

        $dom.on(container, 'submit', '.js-submit-check-login-username-field', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });
    };

    $cms.templates.blockTopLogin = function (blockTopLogin, container) {
        $dom.on(container, 'submit', '.js-form-top-login', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $dom.on(container, 'click', '.js-click-confirm-remember-me', function (e, checkbox) {
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

        if (!$cms.isMobile()) {
            $dom.on(container, 'keyup', '#bans', function (e, textarea) {
                $cms.manageScrollHeight(textarea);
            });
        }
    };

    $cms.templates.jsBlock = function jsBlock(params) {
        $cms.callBlock(params.blockCallUrl, '', $dom.$id(params.jsBlockId), false, false, null, false, false);
    };

    $cms.templates.massSelectMarker = function (params, container) {
        $dom.on(container, 'click', '.js-chb-prepare-mass-select', function (e, checkbox) {
            prepareMassSelectMarker(params.supportMassSelect, params.type, params.id, checkbox.checked);
        });
    };


    $cms.templates.blockTopPersonalStats = function (params, container) {
        $dom.on(container, 'click', '.js-click-toggle-top-personal-stats', function (e) {
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
        $dom.on(container, 'submit', '.js-submit-check-login-username-field', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements['login_username'])) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $dom.on(container, 'click', '.js-click-checkbox-remember-me-confirm', function (e, checkbox) {
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

        $dom.on(container, 'mouseover', '.js-mouseover-activate-member-tooltip', function (e, el) {
            el.cancelled = false;
            $cms.loadSnippet('member_tooltip&member_id=' + submitter, null, true).then(function (result) {
                if (!el.cancelled) {
                    $cms.ui.activateTooltip(el, e, result, 'auto', null, null, false, true);
                }
            });
        });

        $dom.on(container, 'mouseout', '.js-mouseout-deactivate-member-tooltip', function (e, el) {
            $cms.ui.deactivateTooltip(el);
            el.cancelled = true;
        });
    };

    $cms.templates.resultsLauncherContinue = function resultsLauncherContinue(params, link) {
        var max = params.max,
            urlStub = params.urlStub,
            numPages = params.numPages,
            message = $util.format('{!javascript:ENTER_PAGE_NUMBER;^}', [numPages]);

        $dom.on(link, 'click', function () {
            $cms.ui.prompt(message, numPages, function (res) {
                if (!res) {
                    return;
                }

                res = parseInt(res);
                if ((res >= 1) && (res <= numPages)) {
                    $util.navigate(urlStub + (urlStub.includes('?') ? '&' : '?') + 'start=' + (max * (res - 1)));
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

        $dom.on(container, 'click', function (e) {
            var clickedLink = $dom.closest(e.target, 'a', container);

            if (!clickedLink) {
                $util.navigate(url, target);
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
                    $util.navigate(url + append, target);
                });
                return;
            }

            if (warning && clickedLink.classList.contains('js-click-confirm-warning')) {
                e.preventDefault();
                $cms.ui.confirm(warning, function (answer) {
                    if (answer) {
                        $util.navigate(url, target);
                    }
                });
            }
        });

        var docEl = document.getElementById('doc_' + rand),
            helpEl = document.getElementById('help');

        if (docEl && helpEl) {
            /* Do-next document tooltips */
            $dom.on(container, 'mouseover', function () {
                if ($dom.html(docEl) !== '') {
                    window.origHelperText = $dom.html(helpEl);
                    $dom.html(helpEl, $dom.html(docEl));
                    $dom.fadeIn(helpEl);

                    helpEl.classList.remove('global_helper_panel_text');
                    helpEl.classList.add('global_helper_panel_text_over');
                }
            });

            $dom.on(container, 'mouseout', function () {
                if (window.origHelperText !== undefined) {
                    $dom.html(helpEl, window.origHelperText);
                    $dom.fadeIn(helpEl);

                    helpEl.classList.remove('global_helper_panel_text_over');
                    helpEl.classList.add('global_helper_panel_text');
                }
            });
        }

        if (autoAdd) {
            var links = $dom.$$(container, 'a');

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

                            $util.navigate(link);
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

        $dom.internaliseAjaxBlockWrapperLinks(url, element, ['.*'], {}, false, true);
    };

    $cms.templates.ajaxPagination = function ajaxPagination(params) {
        var wrapperEl = $dom.$id(params.wrapperId),
            blockCallUrl = params.blockCallUrl,
            infiniteScrollCallUrl = params.infiniteScrollCallUrl,
            infiniteScrollFunc;
        
        if (wrapperEl) {
            $dom.internaliseAjaxBlockWrapperLinks(blockCallUrl, wrapperEl, ['^[^_]*_start$', '^[^_]*_max$'], {});

            if (infiniteScrollCallUrl) {
                infiniteScrollFunc = $dom.internaliseInfiniteScrolling.bind(undefined, infiniteScrollCallUrl, wrapperEl);

                $dom.on(window, {
                    scroll: infiniteScrollFunc,
                    touchmove: infiniteScrollFunc,
                    keydown: $dom.infiniteScrollingBlock,
                    mousedown: $dom.infiniteScrollingBlockHold,
                    mousemove: function () {
                        // mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
                        $dom.infiniteScrollingBlockUnhold(infiniteScrollFunc);
                    }
                });

                infiniteScrollFunc();
            }            
        } else {
            $util.inform('$cms.templates.ajaxPagination(): Wrapper element not found.');
        }
    };

    $cms.templates.confirmScreen = function confirmScreen(params) {};

    $cms.templates.warnScreen = function warnScreen() {
        if (window.top !== window) {
            $dom.triggerResize();
        }
    };

    $cms.templates.fatalScreen = function fatalScreen() {
        if (window.top !== window) {
            $dom.triggerResize();
        }
    };

    $cms.templates.columnedTableScreen = function columnedTableScreen(params) {
        if (params.jsFunctionCalls != null) {
            $cms.executeJsFunctionCalls(params.jsFunctionCalls);
        }
    };

    $cms.templates.questionUiButtons = function questionUiButtons(params, container) {
        $dom.on(container, 'click', '.js-click-close-window-with-val', function (e, clicked) {
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
            $dom.on(btn, 'click', function (e) {
                e.preventDefault();
                $cms.executeJsFunctionCalls(onclickCallFunctions, btn);
            });
        }
    };

    $cms.templates.cropTextMouseOver = function (params, el) {
        var textLarge = $cms.filter.nl(params.textLarge);

        $dom.on(el, 'mouseover', function (e) {
            $cms.ui.activateTooltip(el, e, textLarge, '40%');
        });
    };

    $cms.templates.cropTextMouseOverInline = function (params, el) {
        var textLarge = $cms.filter.nl(params.textLarge);

        $dom.on(el, 'mouseover', function (e) {
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
                $util.inform('detectChange(): Change detected');
                callback();
            }
        });
    }

    function detectedChange() {
        $util.inform('detectedChange(): Change notification running');

        try {
            window.focus();
        } catch (e) {}
        
        var soundUrl = 'data/sounds/message_received.mp3',
            baseUrl = (!soundUrl.includes('data_custom') && !soundUrl.includes('uploads/')) ? $cms.getBaseUrlNohttp() : $cms.getCustomBaseUrlNohttp(),
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

    function confirmDelete(form, multi, callback) {
        multi = !!multi;

        $cms.ui.confirm(multi ? '{!_ARE_YOU_SURE_DELETE;^}' : '{!ARE_YOU_SURE_DELETE;^}').then(function (result) {
            if (result) {
                if (callback != null) {
                    callback();
                } else {
                    $dom.submit(form);
                }
            }
        });
    }

    function prepareMassSelectMarker(set, type, id, checked) {
        var massDeleteForm = $dom.$id('mass_select_form__' + set);
        if (!massDeleteForm) {
            massDeleteForm = $dom.$id('mass_select_button').form;
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
 
}(window.$cms || (window.$cms = {}), window.$util || (window.$util = {}), window.$dom));

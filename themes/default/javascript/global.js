(function ($cms, symbols) {
    'use strict';

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
        // Clever helper for merging arrays using `[].push`
        pushArray = Function.bind.call(Function.apply, emptyArr.push);

    // Too useful to not have globally!
    window.intVal   = intVal;
    window.floatVal = floatVal;
    window.strVal   = strVal;
    window.arrVal   = arrVal;
    window.objVal   = objVal;

    (window.$cmsInit  || (window.$cmsInit = []));
    (window.$cmsReady || (window.$cmsReady = []));
    (window.$cmsLoad  || (window.$cmsLoad = []));

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
        $DEV_MODE: constant(window.IN_MINIKERNEL_VERSION || boolVal(symbols.DEV_MODE)),
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
         * @returns {boolean}
         */
        $VERBOSE: constant(true),
        /**
         * @method
         * @returns {number}
         */
        $HTTP_STATUS_CODE: constant(+symbols.HTTP_STATUS_CODE || 0),
        /**
         * @method
         * @returns {number}
         */
        $GROUP_ID: constant(+symbols.GROUP_ID || 0),
        /**
         * @method
         * @returns {string}
         */
        $VERSION: constant(strVal(symbols.VERSION)),
        /**
         * @method
         * @returns {string}
         */
        $PAGE: constant(strVal(symbols.PAGE)),
        /**
         * @method
         * @returns {string}
         */
        $PAGE_TITLE: constant(strVal(symbols.PAGE_TITLE)),
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
        $AVATAR: constant(strVal(symbols.AVATAR)),
        /**
         * @method
         * @returns {string}
         */
        $MEMBER_EMAIL: constant(strVal(symbols.MEMBER_EMAIL)),
        /**
         * @method
         * @returns {string}
         */
        $PHOTO: constant(strVal(symbols.PHOTO)),
        /**
         * @method
         * @returns {string}
         */
        $MEMBER_PROFILE_URL: constant(strVal(symbols.MEMBER_PROFILE_URL)),
        /**
         * @method
         * @returns {string}
         */
        $FROM_TIMESTAMP: constant(symbols.FROM_TIMESTAMP),
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
        $BROWSER_UA: constant(strVal(symbols.BROWSER_UA)),
        /**
         * @method
         * @returns {string}
         */
        $OS: constant(strVal(symbols.OS)),
        /**
         * @method
         * @returns {string}
         */
        $USER_AGENT: constant(strVal(symbols.USER_AGENT)),
        /**
         * @method
         * @returns {string}
         */
        $IP_ADDRESS: constant(strVal(symbols.IP_ADDRESS)),
        /**
         * @method
         * @returns {string}
         */
        $TIMEZONE: constant(strVal(symbols.TIMEZONE)),
        /**
         * @method
         * @returns {string}
         */
        $CHARSET: constant(strVal(symbols.CHARSET)),
        /**
         * @method
         * @returns {string}
         */
        $KEEP: constant(strVal(symbols.KEEP)),
        /**
         * @method
         * @returns {string}
         */
        $PREVIEW_URL: constant(strVal(symbols.PREVIEW_URL)),
        /**
         * @method
         * @returns {string}
         */
        $SITE_NAME: constant(strVal(symbols.SITE_NAME)),
        /**
         * @method
         * @returns {string}
         */
        $COPYRIGHT: constant(strVal(symbols.COPYRIGHT)),
        /**
         * @method
         * @returns {string}
         */
        $DOMAIN: constant(strVal(symbols.DOMAIN)),
        /**
         * @method
         * @returns {string}
         */
        $BASE_URL: constant(strVal(symbols.BASE_URL)),
        /**
         * @method
         * @returns {string}
         */
        $BASE_URL_S: constant(strVal(symbols.BASE_URL) + '/'), // With trailing slash
        /**
         * @method
         * @returns {string}
         */
        $BASE_URL_PRL: constant(toProtocolRelative(symbols.BASE_URL)), // Protocol relative
        /**
         * @method
         * @returns {string}
         */
        $BASE_URL_NOHTTP: constant(strVal(symbols.BASE_URL_NOHTTP)),
        /**
         * @method
         * @returns {string}
         */
        $BASE_URL_NOHTTP_S: constant(strVal(symbols.BASE_URL_NOHTTP) + '/'), // With trailing slash
        /**
         * @method
         * @returns {string}
         */
        $CUSTOM_BASE_URL: constant(strVal(symbols.CUSTOM_BASE_URL)),
        /**
         * @method
         * @returns {string}
         */
        $CUSTOM_BASE_URL_NOHTTP: constant(strVal(symbols.CUSTOM_BASE_URL_NOHTTP)),
        /**
         * @method
         * @returns {string}
         */
        $FORUM_BASE_URL: constant(strVal(symbols.FORUM_BASE_URL)),
        /**
         * @method
         * @returns {string}
         */
        $BRAND_NAME: constant(strVal(symbols.BRAND_NAME)),
        /**
         * @method
         * @returns {string}
         */
        $SESSION_COOKIE_NAME: constant(strVal(symbols.SESSION_COOKIE_NAME)),
        /**
         * @method
         * @returns {string}
         */
        $COOKIE_PATH: constant(strVal(symbols.COOKIE_PATH)),
        /**
         * @method
         * @returns {string}
         */
        $COOKIE_DOMAIN: constant(strVal(symbols.COOKIE_DOMAIN)),
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
         * @returns {string|boolean|number}
         */
        $CONFIG_OPTION: function $CONFIG_OPTION(optionName) {
            // Installer, likely executing global.js
            if (window.IN_MINIKERNEL_VERSION) {
                return '';
            }

            var options =  {
                /**@member {boolean}*/
                js_overlays: boolVal(symbols.CONFIG_OPTION.js_overlays),
                /**@member {boolean}*/
                enable_animations: boolVal(symbols.CONFIG_OPTION.enable_animations),
                /**@member {boolean}*/
                detect_javascript: boolVal(symbols.CONFIG_OPTION.detect_javascript),
                /**@member {boolean}*/
                is_on_timezone_detection: boolVal(symbols.CONFIG_OPTION.is_on_timezone_detection),
                /**@member {boolean}*/
                wysiwyg: boolVal(symbols.CONFIG_OPTION.wysiwyg),
                /**@member {boolean}*/
                complex_uploader: boolVal(symbols.CONFIG_OPTION.complex_uploader),
                /**@member {boolean}*/
                collapse_user_zones: boolVal(symbols.CONFIG_OPTION.collapse_user_zones),
                /**@member {boolean}*/
                sitewide_im: boolVal(symbols.CONFIG_OPTION.sitewide_im),
                /**@member {boolean}*/
                simplified_attachments_ui: boolVal(symbols.CONFIG_OPTION.simplified_attachments_ui),
                /**@member {boolean}*/
                spam_heuristic_pasting: boolVal(symbols.CONFIG_OPTION.spam_heuristic_pasting),
                /**@member {boolean}*/
                long_google_cookies: boolVal(symbols.CONFIG_OPTION.long_google_cookies),
                /**@member {boolean}*/
                enable_theme_img_buttons: boolVal(symbols.CONFIG_OPTION.enable_theme_img_buttons),
                /**@member {boolean}*/
                enable_previews: boolVal(symbols.CONFIG_OPTION.enable_previews),
                /**@member {boolean}*/
                show_inline_stats: boolVal(symbols.CONFIG_OPTION.show_inline_stats),
                /**@member {boolean}*/
                background_template_compilation: boolVal(symbols.CONFIG_OPTION.background_template_compilation),
                /**@member {boolean}*/
                notification_desktop_alerts: boolVal(symbols.CONFIG_OPTION.notification_desktop_alerts),
                /**@member {boolean}*/
                eager_wysiwyg: boolVal(symbols.CONFIG_OPTION.eager_wysiwyg),
                /**@member {boolean}*/
                fixed_width: boolVal(symbols.CONFIG_OPTION.fixed_width),
                /**@member {boolean}*/
                infinite_scrolling: boolVal(symbols.CONFIG_OPTION.infinite_scrolling),
                /**@member {boolean}*/
                js_captcha: boolVal(symbols.CONFIG_OPTION.js_captcha),
                /**@member {boolean}*/
                editarea: boolVal(symbols.CONFIG_OPTION.editarea),

                /**@member {number}*/
                thumb_width: intVal(symbols.CONFIG_OPTION.thumb_width),
                /**@member {number}*/
                topic_pin_max_days: intVal(symbols.CONFIG_OPTION.topic_pin_max_days),

                /**@member {string}*/
                google_analytics: strVal(symbols.CONFIG_OPTION.google_analytics),
                /**@member {string}*/
                cookie_notice: strVal(symbols.CONFIG_OPTION.cookie_notice)
            };

            if (hasOwn(options, optionName)) {
                return options[optionName];
            }

            $cms.error('$cms.$CONFIG_OPTION(): Option "' + optionName + '" is either unsupported in JS or doesn\'t exist. Please try using the actual Tempcode symbol.');
        },
        /**
         * WARNING: This is a very limited subset of the $VALUE_OPTION tempcode symbol
         * @method
         * @returns {string|boolean|number}
         */
        $VALUE_OPTION: function $VALUE_OPTION(optionName) {
            // Installer, likely executing global.js
            if (window.IN_MINIKERNEL_VERSION) {
                return '';
            }

            var options = {
                /**@member {string}*/
                js_keep_params: symbols.VALUE_OPTION.js_keep_params,
                /**@member {string}*/
                commercial_spellchecker: symbols.VALUE_OPTION.commercial_spellchecker
            };

            if (hasOwn(options, optionName)) {
                return options[optionName];
            }

            $cms.error('$cms.$VALUE_OPTION(): Option "' + optionName + '" is either unsupported in JS or doesn\'t exist. Please try using the actual Tempcode symbol.');
        },
        /**
         * WARNING: This is a very limited subset of the $HAS_PRIVILEGE tempcode symbol
         * @method
         * @returns {boolean}
         */
        $HAS_PRIVILEGE: function $HAS_PRIVILEGE(optionName) {
            // Installer, likely executing global.js
            if (window.IN_MINIKERNEL_VERSION) {
                return false;
            }

            var options = {
                /**@member {string}*/
                sees_javascript_error_alerts: symbols.HAS_PRIVILEGE.sees_javascript_error_alerts
            };

            if (hasOwn(options, optionName)) {
                return options[optionName];
            }

            $cms.error('$cms.$HAS_PRIVILEGE(): Privilege "' + optionName + '" is either unsupported in JS or doesn\'t exist. Please try using the actual Tempcode symbol.');
        },

        // Just some more useful stuff, (not tempcode symbols)
        /**@member {boolean}*/
        canTryUrlSchemes: boolVal(symbols['can_try_url_schemes']),
        /**@member {object}*/
        staffTooltipsUrlPatterns: objVal(symbols['staff_tooltips_url_patterns'])
    });

    extendDeep($cms, /**@lends $cms*/{
        // Browser detection. Credit: http://stackoverflow.com/a/9851769/362006
        // Opera 8.0+
        /**
         * @method
         * @returns {boolean}
         */
        isOpera: constant((!!window.opr && !!window.opr.addons) || !!window.opera || (navigator.userAgent.includes(' OPR/'))),
        // Firefox 1.0+
        /**
         * @method
         * @returns {boolean}
         */
        isFirefox: constant(window.InstallTrigger !== undefined),
        // At least Safari 3+: HTMLElement's constructor's name is HTMLElementConstructor
        /**
         * @method
         * @returns {boolean}
         */
        isSafari: constant(internalName(window.HTMLElement) === 'HTMLElementConstructor'),
        // Internet Explorer 6-11
        /**
         * @method
         * @returns {boolean}
         */
        isIE: constant(/*@cc_on!@*/0 || (typeof document.documentMode === 'number')),
        // Edge 20+
        /**
         * @method
         * @returns {boolean}
         */
        isEdge: constant(!(/*@cc_on!@*/0 || (typeof document.documentMode === 'number')) && !!window.StyleMedia),
        // Chrome 1+
        /**
         * @method
         * @returns {boolean}
         */
        isChrome: constant(!!window.chrome && !!window.chrome.webstore),
        /**
         * @method
         * @returns {boolean}
         */
        isTouchEnabled: constant('ontouchstart' in docEl),

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
        keepStub: keepStub,
        /**@method*/
        gaTrack: gaTrack,
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
        openModalWindow: openModalWindow,
        /**@method*/
        executeJsFunctionCalls: executeJsFunctionCalls,
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
         * @namespace $cms.viewInstances
         */
        viewInstances: {},
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

        if ((document.readyState === 'interactive') || (document.readyState === 'complete')) {
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

        while (window.$cmsInit.length) {
            fn = window.$cmsInit.shift();
            if (typeof fn === 'function') {
                fn();
            }
        }

        properties(window.$cmsInit, {
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

        while (window.$cmsReady.length) {
            fn = window.$cmsReady.shift();
            if (typeof fn === 'function') {
                fn();
            }
        }

        properties(window.$cmsReady, {
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

        while (window.$cmsLoad.length) {
            fn = window.$cmsLoad.shift();
            if (typeof fn === 'function') {
                fn();
            }
        }

        properties(window.$cmsLoad, {
            unshift: function unshift(fn) {
                fn();
            },
            push: function push(fn) {
                fn();
            }
        });
    }

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

    var sessionId = $cms.getSessionId();

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

    /**
     *
     * @returns {boolean}
     */
    function returnTrue() {
        return true;
    }

    /**
     *
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
        return function () {
            return value;
        };
    }

    /**
     *
     * @param val
     * @param withEnumerable (boolean)
     * @returns {boolean}
     */
    function isObj(val, withEnumerable) {
        return (val != null) && (typeof val === 'object') && (!withEnumerable || hasEnumerable(val));
    }

    /**
     *
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
     *
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
     *
     * @param val
     * @returns { boolean }
     */
    function isArrayOrPlainObj(val) {
        return (val != null) && (Array.isArray(val) || isPlainObj(val));
    }

    /**
     *
     * @param val
     * @returns {boolean}
     */
    function isScalar(val) {
        return (val != null) && ((typeof val === 'boolean') || (typeof val === 'number') || (typeof val === 'string'));
    }

    /**
     *
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
     *
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
     *
     * @param data
     * @returns {prototype}
     */
    function pureObj(data) {
        return withProto(null, data);
    }

    /**
     *
     * @param key
     * @param value
     * @returns {{}}
     */
    function keyValue(key, value) {
        var obj = {};
        obj[key] = value;
        return obj;
    }

    /**
     *
     * @param obj
     * @returns {boolean}
     */
    function isPromise(obj) {
        return (obj != null) && (typeof obj === 'object') && (typeof obj.then === 'function');
    }

    /**
     *
     * @param obj
     * @returns {boolean}
     */
    function isWindow(obj) {
        return isObj(obj) && (obj === obj.window) && (obj === obj.self) && (internalName(obj) === 'Window');
    }

    /**
     *
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
     *
     * @param obj
     * @returns {boolean}
     */
    function isNode(obj) {
        return nodeType(obj) !== false;
    }

    /**
     *
     * @param obj
     * @returns {boolean}
     */
    function isEl(obj) {
        return nodeType(obj) === ELEMENT_NODE;
    }

    /**
     *
     * @param obj
     * @returns {boolean}
     */
    function isDoc(obj) {
        return nodeType(obj) === DOCUMENT_NODE;
    }

    /**
     *
     * @param obj
     * @returns {boolean}
     */
    function isDocFrag(obj) {
        return nodeType(obj) === DOCUMENT_FRAGMENT_NODE;
    }

    /**
     *
     * @param obj
     * @returns {boolean}
     */
    function isDocOrEl(obj) {
        var t = nodeType(obj);
        return (t === ELEMENT_NODE) || (t === DOCUMENT_NODE);
    }

    /**
     *
     * @param obj
     * @returns {boolean}
     */
    function isDocOrFragOrEl(obj) {
        var t = nodeType(obj);
        return (t === ELEMENT_NODE) || (t === DOCUMENT_NODE) || (t === DOCUMENT_FRAGMENT_NODE);
    }

    /**
     *
     * @param obj
     * @returns {boolean}
     */
    function isRegExp(obj) {
        return (obj != null) && (internalName(obj) === 'RegExp');
    }

    /**
     *
     * @param obj
     * @returns {boolean}
     */
    function isDate(obj) {
        return (obj != null) && (internalName(obj) === 'Date');
    }

    /**
     * Inspired by jQuery.isNumeric
     * @param val
     * @returns {boolean}
     */
    function isNumeric(val) {
        // parseFloat NaNs numeric-cast false positives ("")
        // ...but misinterprets leading-number strings, particularly hex literals ("0x...")
        val = (typeof val === 'string') ? parseFloat(val) : val;
        return Number.isFinite(val);
    }

    /**
     *
     * @param obj
     * @param minLength
     * @returns {boolean}
     */
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

    /**
     * Returns a random integer between min (inclusive) and max (inclusive)
     * Using Math.round() will give you a non-uniform distribution!
     * @param min {number}
     * @param max {number}
     * @returns {*}
     */
    function random(min, max) {
        min = Number.isFinite(+min) ? +min : 0;
        max = Number.isFinite(+max) ? +max : 1000000000000; // 1 Trillion

        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    /**
     * Bind a number of an object's methods to that object. Remaining arguments
     * are the method names to be bound. Useful for ensuring that all callbacks
     * defined on an object belong to it.
     * @param obj
     * @param methodNames
     * @returns {*}
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
     *
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
                break;
            }
        }

        return obj;
    }

    /**
     *
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
        for (var i = 1, len = arguments.length; i < len; i++) {
            _extend(target, arguments[i]);
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
        for (var i = 1, len = arguments.length; i < len; i++) {
            _extend(target, arguments[i], EXTEND_SRC_OWN_ONLY);
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
        for (var i = 1, len = arguments.length; i < len; i++) {
            _extend(target, arguments[i], EXTEND_DEEP);
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
        for (var i = 1, len = arguments.length; i < len; i++) {
            _extend(defaults, arguments[i], EXTEND_TGT_OWN_ONLY);
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
     *
     * @param obj
     * @returns {*}
     */
    function constructorName(obj) {
        if ((obj != null) && (typeof obj.constructor === 'function') && (typeof obj.constructor.name === 'string')) {
            return obj.constructor.name;
        }
    }

    /**
     *
     * @param obj
     * @returns {*}
     */
    function typeName(obj) {
        var name = constructorName(obj);
        return (name !== undefined) ? name : internalName(obj);
    }

    /**
     * Port of PHP's boolval() function
     * @param val
     * @returns { Boolean }
     */
    function boolVal(val) {
        var p;
        return !!val && (val !== '0') && ((typeof val !== 'object') || !((p = isPlainObj(val)) || isArrayLike(val)) || (p ? hasEnumerable(val) : (val.length > 0)));
    }

    /**
     * Port of PHP's empty() function
     * @param val
     * @returns { Boolean }
     */
    function isEmpty(val) {
        var p;
        return !!val && (val !== '0') && ((typeof val !== 'object') || !((p = isPlainObj(val)) || isArrayLike(val)) || (p ? hasEnumerable(val) : (val.length > 0)));
    }

    /**
     * @param val
     * @returns { Number }
     */
    function intVal(val) {
        return ((val != null) && (val = Math.floor(val)) && (val !== Infinity) && (val !== -Infinity)) ? val : 0;
    }

    /**
     * @param val
     * @returns { Number }
     */
    function floatVal(val) {
        return (val && (val !== Infinity) && (val !== -Infinity)) ? val : 0;
    }

    function numberFormat(num) {
        num = +num || 0;
        return num.toLocaleString();
    }

    /**
     * @param val
     * @returns { Array|null } array or array-like object
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
     * @param val
     * @param defaultPropertyName
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
     * @param val
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
     * @param str
     * @param values
     * @returns { string }
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

    /**
     *
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

    /* Generate url */

    $cms.url = function () {
        return baseUrl.apply(undefined, arguments);
    };

    var rgxProtocol = /^[a-z0-9\-\.]+:(?=\/\/)/i,
        rgxHttp = /^https?:(?=\/\/)/i;

    /**
     *
     * @param absoluteUrl
     * @returns {string}
     */
    function toProtocolRelative(absoluteUrl) {
        return strVal(absoluteUrl).replace(rgxProtocol, '');
    }

    /**
     *
     * @param relativeUrl
     * @returns {string}
     */
    function baseUrl(relativeUrl) {
        relativeUrl = strVal(relativeUrl);

        if (relativeUrl === '') {
            return $cms.$BASE_URL_S();
        }

        if (rgxHttp.test(relativeUrl)) {
            // Already an absolute url, just ensure matching protocol as the current page.
            return relativeUrl.replace(rgxHttp, window.location.protocol);
        }

        return ((relativeUrl.startsWith('/')) ? $cms.$BASE_URL() : $cms.$BASE_URL_S()) + relativeUrl;
    }

    function isAbsoluteHttp(url) {
        url = strVal(url);
        return rgxHttp.test(url);
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

    /**
     *
     * @param source
     * @returns {*}
     */
    function parseJson(source) {
        return window.JSON5.parse(strVal(source));
    }

    function log() {
        if ($cms.$DEV_MODE() && $cms.$VERBOSE()) {
            return console.log.apply(undefined, arguments);
        }
    }

    function info() {
        if ($cms.$DEV_MODE()) {
            return console.info.apply(undefined, arguments);
        }
    }

    function warn() {
        if ($cms.$DEV_MODE()) {
            return console.warn.apply(undefined, arguments);
        }
    }

    function dir() {
        if ($cms.$DEV_MODE()) {
            return console.dir.apply(undefined, arguments);
        }
    }

    function assert() {
        if ($cms.$DEV_MODE()) {
            return console.assert.apply(undefined, arguments);
        }
    }

    function error() {
        if ($cms.$DEV_MODE()) {
            return console.error.apply(undefined, arguments);
        }
    }

    function exception(ex) {
        if ($cms.$DEV_MODE()) {
            if (typeof ex === 'string') {
                throw new Error(ex);
            }
            throw ex;
        }
    }

    /**
     *
     * @param sheet
     */
    function requireCss(sheet) {
        if ($cms.dom.$('link#css-' + sheet)) {
            return;
        }
        var link = document.createElement('link');
        link.id = 'css-' + sheet;
        link.rel = 'stylesheet';
        link.href = '{$FIND_SCRIPT_NOHTTP;,sheet}?sheet=' + sheet + $cms.keepStub();
        document.head.appendChild(link);
    }

    var requireJavascriptPromises = Object.create(null);
    function _requireJavascript(script) {
        script = strVal(script);

        if (requireJavascriptPromises[script] == null) {
            var scriptEl = $cms.dom.$('script#javascript-' + script) || $cms.dom.$('script#javascript-' + script + '_non_minified') || $cms.dom.$('script[src='+ script + ']');

            if (scriptEl) {
                if (Array.isArray($cms.loadedScripts) && $cms.loadedScripts.includes(scriptEl)) {
                    requireJavascriptPromises[script] = Promise.resolve({ target: scriptEl });
                } else {
                    requireJavascriptPromises[script] = new Promise(function (resolve, reject) {
                        scriptEl.addEventListener('load', function (e) {
                            resolve(e)
                        });
                        scriptEl.addEventListener('error', function (e) {
                            $cms.error('$cms.requireJavascript(): Error loading script "' + script + '"', e);
                            reject(e);
                        });
                    });
                }

            } else {
                requireJavascriptPromises[script] = new Promise(function (resolve, reject) {
                    var sEl = document.createElement('script');
                    sEl.defer = true;
                    sEl.addEventListener('load', function (e) {
                        resolve(e)
                    });
                    sEl.addEventListener('error', function (e) {
                        $cms.error('$cms.requireJavascript(): Error loading script "' + script + '"', e);
                        reject(e);
                    });

                    if (isAbsoluteHttp(script)) {
                      sEl.src = script;
                    } else {
                        sEl.id = 'javascript-' + script;
                        sEl.src = '{$FIND_SCRIPT_NOHTTP;,javascript}?script=' + script + $cms.keepStub();
                    }

                    if (document.body) {
                        document.body.appendChild(sEl);
                    } else {
                        document.head.appendChild(sEl);
                    }
                });
            }
        }

        return requireJavascriptPromises[script];
    }

    /**
     *
     * @param scripts
     * @returns { Promise }
     */
    function requireJavascript(scripts) {
        scripts = arrVal(scripts);

        return Promise.all(scripts.map(_requireJavascript));
    }

    /**
     *
     * @param flag
     */
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
    /**
     *
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
        return $cms.readCookie($cms.$SESSION_COOKIE_NAME()); // Session also works as a CSRF-token, as client-side knows it (AJAX)
    }

    function getSessionId() {
        return $cms.readCookie($cms.$SESSION_COOKIE_NAME());
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

    properties(CookieMonster.prototype, /**@lends CookieMonster#*/ {
        /**@method*/
        get: function get(cookieName) {
            cookieName = strVal(cookieName);
            if (cookieName) {
                return this.getAll(cookieName);
            }
        },

        /**@method*/
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

                var name = parts[0].replace(rdecode, decodeURIComponent);
                cookie = cookie.replace(rdecode, decodeURIComponent);

                if (cookieName == null) {
                    result[name] = cookie;
                } else if (cookieName === name) {
                    result = cookie;
                    break;
                }
            }

            return result;
        },

        /**@method*/
        set: function set(details, value) {
            var defaults = {
                value: '',
                expires: 1, // 1 day
                path: $cms.$COOKIE_PATH(),
                domain: $cms.$COOKIE_DOMAIN(),
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

            value = encodeURIComponent(strVal(details.value)).replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeURIComponent);

            var cookieName = strVal(details.name);
            cookieName = encodeURIComponent(cookieName);
            cookieName = cookieName.replace(/%(23|24|26|2B|5E|60|7C)/g, decodeURIComponent);
            cookieName = cookieName.replace(/[\(\)]/g, escape);

            document.cookie = [
                cookieName + '=' + value,
                details.expires ? '; expires=' + details.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                details.path ? '; path=' + details.path : '',
                details.domain ? '; domain=' + details.domain : '',
                details.secure ? '; secure' : ''
            ].join('');
        },

        /**@method*/
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

    /**
     *
     * @param cookieName
     * @param cookieValue
     * @param numDays
     */
    function setCookie(cookieName, cookieValue, numDays) {
        var expires = new Date(),
            output;

        numDays = +numDays || 1;

        expires.setDate(expires.getDate() + numDays); // Add days to date

        output = cookieName + '=' + encodeURIComponent(cookieValue) + ';expires=' + expires.toUTCString();

        if ($cms.$COOKIE_PATH()) {
            output += ';path=' + $cms.$COOKIE_PATH();
        }

        if ($cms.$COOKIE_DOMAIN()) {
            output += ';domain=' + $cms.$COOKIE_DOMAIN();
        }

        document.cookie = output;

        var read = $cms.readCookie(cookieName);

        if (read && (read !== cookieValue) && $cms.$DEV_MODE() && !alertedCookieConflict) {
            $cms.ui.alert('{!COOKIE_CONFLICT_DELETE_COOKIES;^}' + '... ' + document.cookie + ' (' + output + ')', null, '{!ERROR_OCCURRED;^}');
            alertedCookieConflict = true;
        }
    }

    /**
     *
     * @param cookieName
     * @param defaultValue
     * @returns {*}
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
     * If the browser has support for CSS transitions
     * @memberof $cms.support
     * @type {boolean}
     */
    $cms.support.cssTransitions = ('transition' in emptyElStyle) || ('WebkitTransition' in emptyElStyle) || ('msTransition' in emptyElStyle);

    /**
     * If the browser has support for an input[type=???]
     * @memberof $cms.support
     * @type {{search: boolean, tel: boolean, url: boolean, email: boolean, datetime: boolean, date: boolean, month: boolean, week: boolean, time: boolean, datetime-local: boolean, number: boolean, range: boolean, color: boolean}}
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

            $cms.support.inputTypes[type] = !!bool;
        }
    }());

    /**
     *
     * @param windowOrNodeOrSelector
     * @returns {*}
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
     *
     * @param nodeOrSelector
     * @returns {*}
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
     *
     * @param elementOrSelector
     * @returns {*}
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
     *
     * @param el
     * @param property
     * @returns {*}
     */
    function computedStyle(el, property) {
        var cs = el.ownerDocument.defaultView.getComputedStyle(el);
        return (property !== undefined) ? cs.getPropertyValue(property) : cs;
    }

    /**
     * Returns a single matching child element, defaults to 'document' as parent
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

    var rgxIdSelector = /^\#[\w\-]+$/;
    /**
     * Returns a single matching child element, `context` defaults to 'document'
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

    var rgxSimpleSelector = /^[\#\.]?[\w\-]+$/;
    /**
     * `$cms.dom.$$` is a CSS selector implementation which uses `document.querySelectorAll` and optimizes for some special cases, like `#id`, `.someclass` and `div`.
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
    $cms.dom.$last = function last(context, selector) {
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
        cache: function cache(owner) {
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
        set: function set(owner, data, value) {
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
        get: function get(owner, key) {
            return key === undefined ?
                this.cache(owner) :
                // Always use camelCase key (gh-2257)
                (owner[this.expando] && owner[this.expando][camelCase(key)]);
        },
        access: function access(owner, key, value) {
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
        remove: function remove(owner, key) {
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
        hasData: function hasData(owner) {
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
                $cms.error('$cms.dom.data(): Exception thrown while parsing JSON in data attribute "' + key + '" of', el, e);
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
     * @param el { Window|Document|Element|string }
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
     * @memberof $cms.dom
     * @param el { Window|Document|Element }
     * @param event {string|object}
     * @param [selector] {string|function}
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

    var mouseEvents = { click: true, mousedown: true, mouseup: true, mousemove: true };

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
     * @param [args]
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

    /**
     *
     * @param str
     * @returns {string}
     */
    function camelize(str) {
        return strVal(str).replace(/-+(.)?/g, function (match, chr) {
            return chr ? chr.toUpperCase() : '';
        });
    }

    /**
     *
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
     *
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
            result.push(encodeURIComponent(el.name) + '=' + encodeURIComponent(el.value))
        });
        return result.join('&');
    };

    /**
     * Tabs
     * @memberof $cms.dom
     * @param hash
     */
    $cms.dom.findUrlTab = function findUrlTab(hash) {
        if (hash === undefined) {
            hash = window.location.hash;
        }

        if (hash.replace(/^#\!?/, '') !== '') {
            var tab = hash.replace(/^#/, '').replace(/^tab\_\_/, '');

            if ($cms.dom.$id('g_' + tab)) {
                $cms.ui.selectTab('g', tab);
            }
            else if ((tab.indexOf('__') != -1) && ($cms.dom.$id('g_' + tab.substr(0, tab.indexOf('__'))))) {
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
     * Animate the loading of an iframe
     * @memberof $cms.dom
     * @param pf
     * @param frame
     * @param leave_gap_top
     * @param leave_height
     */
    $cms.dom.animateFrameLoad = function animateFrameLoad(pf, frame, leave_gap_top, leave_height) {
        if (!pf) {
            return;
        }

        leave_gap_top = +leave_gap_top || 0;
        leave_height = !!leave_height;

        if (!leave_height) {
            // Enough to stop jumping around
            pf.style.height = window.top.$cms.dom.getWindowHeight() + 'px';
        }

        $cms.dom.illustrateFrameLoad(frame);

        var ifuob = window.top.$cms.dom.$('#iframe_under');
        var extra = ifuob ? ((window != window.top) ? $cms.dom.findPosY(ifuob) : 0) : 0;
        if (ifuob) {
            ifuob.scrolling = 'no';
        }

        if (window === window.top) {
            window.top.$cms.dom.smoothScroll($cms.dom.findPosY(pf) + extra - leave_gap_top);
        }
    };

    /**
     * @memberof $cms.dom
     * @param iframeId
     */
    $cms.dom.illustrateFrameLoad = function illustrateFrameLoad(iframeId) {
        var head, cssText = '', i, iframe = $cms.dom.$id(iframeId), doc, de;

        if (!$cms.$CONFIG_OPTION('enable_animations') || !iframe || !iframe.contentDocument || !iframe.contentDocument.documentElement) {
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
            } catch (ignore) {}
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
    };

    /**
     * Smoothly scroll to another position on the page
     * @memberof $cms.dom
     * @param dest_y
     * @param expected_scroll_y
     * @param dir
     * @param event_after
     */
    $cms.dom.smoothScroll = function smoothScroll(dest_y, expected_scroll_y, dir, event_after) {
        if (!$cms.$CONFIG_OPTION('enable_animations')) {
            try {
                window.scrollTo(0, dest_y);
            } catch (ignore) {}
            return;
        }

        var scroll_y = window.pageYOffset;
        if (typeof dest_y === 'string') {
            dest_y = $cms.dom.findPosY($cms.dom.$id(dest_y), true);
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
            $cms.dom.smoothScroll(dest_y, scroll_y + dist, dir, event_after);
        }, 30);
    };

    /**
     * Dimension functions
     * @memberof $cms.dom
     * @param e
     */
    $cms.dom.registerMouseListener = function registerMouseListener(e) {
        $cms.dom.registerMouseListener = noop; // ensure this function is only executed once

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
            } catch (ignore) {}

            return 0;
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

        var rect_a = win.document.body.parentElement.getBoundingClientRect(),
            rect_b = win.document.body.getBoundingClientRect(),
            a = (rect_a.bottom - rect_a.top),
            b = (rect_b.bottom - rect_b.top);

        return (a > b) ? a : b;
    };

    /**
     * @memberof $cms.dom
     * @deprecated
     * @param el
     * @param not_relative
     * @returns {number}
     */
    $cms.dom.findPosX = function findPosX(el, not_relative) {/* if not_relative is true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree */
        not_relative = !!not_relative;

        var left = el.getBoundingClientRect().left + window.pageXOffset;

        if (!not_relative) {
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
     * @param not_relative
     * @returns {number}
     */
    $cms.dom.findPosY = function findPosY(el, not_relative) {/* if not_relative is true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree */
        el = elArg(el);
        not_relative = !!not_relative;

        var top = el.getBoundingClientRect().top + window.pageYOffset;

        if (!not_relative) {
            var position;
            while (el) {
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
     * Automatic resizing to make frames seamless. Composr calls this automatically. Make sure id&name attributes are defined on your iframes!
     * @memberof $cms.dom
     * @deprecated
     * @param name
     * @param min_height
     */
    $cms.dom.resizeFrame = function resizeFrame(name, min_height) {
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
            var h = $cms.dom.getWindowScrollHeight(frame_window);

            if ((h === 0) && (frame_element.parentElement.style.display === 'none')) {
                h = min_height ? min_height : 100;

                if (frame_window.parent) {
                    window.setTimeout(function () {
                        if (frame_window.parent) {
                            frame_window.parent.$cms.dom.triggerResize();
                        }
                    }, 0);
                }
            }

            if (h + 'px' != frame_element.style.height) {
                if ((frame_element.scrolling !== 'auto' && frame_element.scrolling !== 'yes') || (frame_element.style.height == '0px')) {
                    frame_element.style.height = ((h >= min_height) ? h : min_height) + 'px';
                    if (frame_window.parent) {
                        window.setTimeout(function () {
                            if (frame_window.parent) frame_window.parent.$cms.dom.triggerResize();
                        });
                    }
                    frame_element.scrolling = 'no';
                    frame_window.onscroll = function (event) {
                        if (event == null) {
                            return false;
                        }
                        try {
                            frame_window.scrollTo(0, 0);
                        } catch (ignore) {}

                        return !!(event && event.target && event.stopPropagation && (event.stopPropagation() === undefined));
                    }; // Needed for Opera
                }
            }
        }

        frame_element.style.transform = 'scale(1)'; // Workaround Chrome painting bug
    };

    /**
     * @memberof $cms.dom
     * @deprecated
     * @param and_subframes
     */
    $cms.dom.triggerResize = function triggerResize(and_subframes) {
        and_subframes = !!and_subframes;

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

        if (and_subframes) {
            iframes = document.querySelectorAll('iframe');
            for (i = 0; i < iframes.length; i++) {
                if ((iframes[i].name != '') && ((iframes[i].classList.contains('expandable_iframe')) || (iframes[i].classList.contains('dynamic_iframe')))) {
                    $cms.dom.resizeFrame(iframes[i].name);
                }
            }
        }
    };

    // <{element's uid}, {setTimeout id}>
    var timeouts = {};

    /**
     * @memberof $cms.dom
     * @deprecated
     * @param el
     * @param destPercentOpacity
     * @param periodInMsecs
     * @param increment
     * @param destroyAfter
     */
    $cms.dom.fadeTransition = function fadeTransition(el, destPercentOpacity, periodInMsecs, increment, destroyAfter) {
        if (!$cms.isEl(el)) {
            return;
        }

        destPercentOpacity = +destPercentOpacity || 0;
        periodInMsecs = +periodInMsecs || 0;
        increment = +increment || 0;
        destroyAfter = !!destroyAfter;

        if (!$cms.$CONFIG_OPTION('enable_animations')) {
            el.style.opacity = destPercentOpacity / 100.0;
            return;
        }

        $cms.dom.clearTransition(el);

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
                $cms.dom.fadeTransition(el, destPercentOpacity, periodInMsecs, increment, destroyAfter);
            }, periodInMsecs);
        } else if (destroyAfter && el.parentNode) {
            $cms.dom.clearTransition(el);
            el.parentNode.removeChild(el);
        }
    };

    /**
     * @memberof $cms.dom
     * @deprecated
     * @param el
     * @returns {*|boolean}
     */
    $cms.dom.hasFadeTransition = function hasFadeTransition(el) {
        return $cms.isEl(el) && ($cms.uid(el) in timeouts);
    };

    /**
     * @memberof $cms.dom
     * @param el
     */
    $cms.dom.clearTransition = function clearTransition(el) {
        var uid = $cms.isEl(el) && $cms.uid(el);

        if (uid && timeouts[uid]) {
            try { // Cross-frame issues may cause error
                window.clearTimeout(timeouts[uid]);
            } catch (ignore) {}
            delete timeouts[uid];
        }
    };

    /**
     * Set opacity, without interfering with the thumbnail timer
     * @memberof $cms.dom
     * @deprecated
     * @param el
     * @param fraction
     */
    $cms.dom.clearTransitionAndSetOpacity = function clearTransitionAndSetOpacity(el, fraction) {
        $cms.dom.clearTransition(el);
        el.style.opacity = fraction;
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
                    //$cms.log('$cms.attachBehaviors(): attached behavior "' + name + '" to context', context);
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

    var _blockDataCache = {};
    /**
     * This function will load a block, with options for parameter changes, and render the results in specified way - with optional callback support
     * @param url
     * @param new_block_params
     * @param target_div
     * @param append
     * @param callback
     * @param scroll_to_top_of_wrapper
     * @param post_params
     * @param inner
     * @param show_loading_animation
     * @returns {boolean}
     */
    function callBlock(url, new_block_params, target_div, append, callback, scroll_to_top_of_wrapper, post_params, inner, show_loading_animation) {
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
            ajax_url += '&block_map_sup=' + encodeURIComponent(new_block_params);
        }

        ajax_url += '&utheme=' + $cms.$THEME();
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
        $cms.doAjaxRequest(
            ajax_url + $cms.keepStub(),
            function (raw_ajax_result) { // Show results when available
                _callBlockRender(raw_ajax_result, ajax_url, target_div, append, callback, scroll_to_top_of_wrapper, inner);
            },
            post_params
        );

        return false;

        function _callBlockRender(raw_ajax_result, ajax_url, target_div, append, callback, scroll_to_top_of_wrapper, inner) {
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
                    window.scrollTo(0, $cms.dom.findPosY(target_div));
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
    }


    /**
     * Dynamic inclusion
     * @memberof $cms
     * @param snippet_hook
     * @param post
     * @param callback
     */
    function loadSnippet(snippet_hook, post, callback) {
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
        var url2 = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=' + snippet_hook + '&url=' + encodeURIComponent(url) + '&title=' + encodeURIComponent(title) + $cms.keepStub(),
            html = $cms.doAjaxRequest($cms.maintainThemeInLink(url2), callback, post);
        if (callback) {
            return null;
        }
        return html.responseText;
    }

    /**
     * Update a URL to maintain the current theme into it
     * @param url
     * @returns {string}
     */
    function maintainThemeInLink(url) {
        var usp = $cms.uspFromUrl(url),
            theme = encodeURIComponent($cms.$THEME());

        if (usp.keys().next().done) {
            // `url` doesn't have a query string
            return url + '?utheme=' + theme;
        } else if (!usp.has('utheme') && !usp.has('keep_theme')) {
            return url + '&utheme=' + theme;
        }

        return url;
    }

    /**
     * Get URL stub to propagate keep_* parameters
     * @param starting
     * @returns {string}
     */
    function keepStub(starting) {// `starting` set to true means "Put a '?' for the first parameter"
        var keep = $cms.uspKeepSession.toString();

        if (!keep) {
            return '';
        }

        return (starting ? '?' : '&') + keep;
    }

    /**
     * Google Analytics tracking for links; particularly useful if you have no server-side stat collection
     * @memberof $cms
     * @param el
     * @param category
     * @param action
     * @returns {boolean}
     */
    function gaTrack(el, category, action) {
        if (!$cms.$CONFIG_OPTION('google_analytics') || $cms.$IS_STAFF() || $cms.$IS_ADMIN()) {
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
                    var sound_object = window.soundManager.createSound({url: ob.href});
                    if (sound_object) {
                        sound_object.play();
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
            $cms.dom.clearTransition(bi);
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
                height: scrollHeight + 'px',
                boxSizing: 'border-box',
                overflowY: 'hidden'
            });
            $cms.dom.triggerResize();
        }
    }


    /**
     * @param options
     * @returns { $cms.views.ModalWindow }
     */
    function openModalWindow(options) {
        return new $cms.views.ModalWindow(options);
    }

    /**
     * @param functionCallsArray
     */
    function executeJsFunctionCalls(functionCallsArray) {
        if (!Array.isArray(functionCallsArray)) {
            $cms.error('$cms.executeJsFunctionCalls(): Argument 1 must be an array, "' + typeName(functionCallsArray) + '" passed');
            return;
        }

        functionCallsArray.forEach(function (func) {
            var funcName, args;

            if (typeof func === 'string') {
                func = [func];
            }

            if (!Array.isArray(func) || (func.length < 1)) {
                $cms.error('$cms.executeJsFunctionCalls(): Invalid function call format', func);
                return;
            }

            funcName = strVal(func[0]);
            args = func.slice(1);

            if (typeof $cms.functions[funcName] === 'function') {
                $cms.functions[funcName].apply(undefined, args);
            } else {
                $cms.error('$cms.executeJsFunctionCalls(): Function not found: $cms.functions.' + funcName);
            }
        });
    }

    /**
     * Find the main Composr window
     * @param any_large_ok
     * @returns {*}
     */
    function getMainCmsWindow(any_large_ok) {
        any_large_ok = !!any_large_ok;

        if ($cms.dom.$('#main_website')) {
            return window;
        }

        if (any_large_ok && ($cms.dom.getWindowWidth() > 300)) {
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

    /**
     * Browser sniffing
     * @param {string} code
     * @returns {boolean}
     */
    function browserMatches(code) {
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
                return !is_ie_8 && !is_ie_9 && $cms.$CONFIG_OPTION('simplified_attachments_ui') && $cms.$CONFIG_OPTION('complex_uploader');
            case 'non_concurrent':
                return browser.includes('iphone') || browser.includes('ipad') || browser.includes('android') || browser.includes('phone') || browser.includes('tablet');
            case 'ios':
                return browser.includes('iphone') || browser.includes('ipad');
            case 'android':
                return browser.includes('android');
            case 'wysiwyg':
                return $cms.$CONFIG_OPTION('wysiwyg');
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

    // List of view options that can be set as properties.
    var viewOptionsList = { el: 1, id: 1, attributes: 1, className: 1, tagName: 1, events: 1 };

    $cms.View = View;
    /**
     * @memberof $cms
     * @class
     */
    function View(params, viewOptions) {
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
            //$cms.log('$cms.View#delegate(): delegating event "' + eventName + '" for selector "' + selector + '" with listener', listener, 'and view', this);
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
        title || (title = '{!Q_SURE;^}');
        unescaped = !!unescaped;

        if (!$cms.$CONFIG_OPTION('js_overlays')) {
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
    };

    /**
     * @memberof $cms.ui
     * @param notice
     * @param callback
     * @param title
     * @param unescaped
     */
    $cms.ui.alert = function alert(notice, callback, title, unescaped) {
        notice = strVal(notice);
        callback || (callback = noop);
        title = strVal(title) || '{!MESSAGE;^}';
        unescaped = !!unescaped;

        if (!$cms.$CONFIG_OPTION('js_overlays')) {
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
    };

    /**
     * @memberof $cms.ui
     * @param question
     * @param defaultValue
     * @param callback
     * @param title
     * @param input_type
     */
    $cms.ui.prompt = function prompt(question, defaultValue, callback, title, input_type) {
        if (!$cms.$CONFIG_OPTION('js_overlays')) {
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
    };

    /**
     * @memberof $cms.ui
     * @param url
     * @param name
     * @param options
     * @param callback
     * @param target
     * @param cancel_text
     */
    $cms.ui.showModalDialog = function showModalDialog(url, name, options, callback, target, cancel_text) {
        callback = callback || noop;

        if (!$cms.$CONFIG_OPTION('js_overlays')) {
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
                            height = '' + ($cms.dom.getWindowHeight() - 200);
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
    };

    /**
     * @memberof $cms.ui
     * @param url
     * @param name
     * @param options
     * @param target
     * @param [cancel_text]
     */
    $cms.ui.open = function open(url, name, options, target, cancel_text) {
        if (cancel_text === undefined) {
            cancel_text = '{!INPUTSYSTEM_CANCEL;^}';
        }

        if (!$cms.$CONFIG_OPTION('js_overlays')) {
            options = options.replace('height=auto', 'height=520');
            window.open(url, name, options);
            return;
        }

        $cms.ui.showModalDialog(url, name, options, null, target, cancel_text);
    };

    var tempDisabledButtons = {};
    /**
     * @memberof $cms.ui
     * @param btn
     * @param [permanent]
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

        permanent = !!permanent;

        buttons.forEach(function (btn) {
            if (!btn.disabled && !tempDisabledButtons[$cms.uid(btn)]) {// We do not want to interfere with other code potentially operating
                $cms.ui.disableButton(btn, permanent);
            }
        });
    };

    /**
     * Originally _open_image_into_lightbox
     * @memberof $cms.ui
     * @param initial_img_url
     * @param description
     * @param x
     * @param n
     * @param has_full_button
     * @param is_video
     * @returns { $cms.views.ModalWindow }
     */
    $cms.ui.openImageIntoLightbox = function openImageIntoLightbox(initial_img_url, description, x, n, has_full_button, is_video) {
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
                    $cms.ui.resizeLightboxDimensionsImg(modal, video, has_full_button, true);
                });
            } else {
                var img = modal.top_window.document.createElement('img');
                img.className = 'lightbox_image';
                img.id = 'lightbox_image';
                img.onload = function () {
                    $cms.ui.resizeLightboxDimensionsImg(modal, img, has_full_button, false);
                };
                img.src = initial_img_url;
            }
        }, 0);

        return modal;
    };

    /**
     * @memberof $cms.ui
     * @param modal
     * @param img
     * @param has_full_button
     * @param is_video
     */
    $cms.ui.resizeLightboxDimensionsImg = function resizeLightboxDimensionsImg(modal, img, has_full_button, is_video) {
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
                var max_width = modal.top_window.$cms.dom.getWindowWidth() - 20;
                var max_height = modal.top_window.$cms.dom.getWindowHeight() - 60;
                if (has_full_button) {
                    max_height -= 120;
                }
                return [max_width, max_height];
            }
        }
    };

    /**
     * Enforcing a session using AJAX
     * @memberof $cms.ui
     * @param callback
     */
    $cms.ui.confirmSession = function confirmSession(callback) {
        var url = '{$FIND_SCRIPT_NOHTTP;,confirm_session}' + $cms.keepStub(true);

        $cms.doAjaxRequest(url, function (ret) {
            if (!ret) {
                return;
            }

            if (ret.responseText === '') {// Blank means success, no error - so we can call callback
                callback(true);
                return;
            }

            // But non blank tells us the username, and there is an implication that no session is confirmed for this login
            if (ret.responseText === '{!GUEST;^}') {// Hmm, actually whole login was lost, so we need to ask for username too
                $cms.ui.prompt(
                    '{!USERNAME;^}',
                    '',
                    function (promptt) {
                        _confirmSession(callback, promptt, url);
                    },
                    '{!_LOGIN;^}'
                );
                return;
            }

            _confirmSession(callback, ret.responseText, url);
        });

        function _confirmSession(callback, username, url) {
            $cms.ui.prompt(
                $cms.$CONFIG_OPTION('js_overlays') ? '{!ENTER_PASSWORD_JS_2;^}' : '{!ENTER_PASSWORD_JS;^}',
                '',
                function (promptt) {
                    if (promptt !== null) {
                        $cms.doAjaxRequest(url, function (ret) {
                            if (ret && ret.responseText === '') {// Blank means success, no error - so we can call callback
                                callback(true);
                            } else {
                                _confirmSession(callback, username, url); // Recurse
                            }
                        }, 'login_username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(promptt));
                    } else {
                        callback(false);
                    }
                },
                '{!_LOGIN;^}',
                'password'
            );
        }
    };

    /**
     * @memberof $cms.ui
     * @param id
     * @param tab
     * @param from_url
     * @param automated
     * @returns {boolean}
     */
    $cms.ui.selectTab = function selectTab(id, tab, from_url, automated) {
        from_url = !!from_url;
        automated = !!automated;

        if (!from_url) {
            var tab_marker = $cms.dom.$id('tab__' + tab.toLowerCase());
            if (tab_marker) {
                // For URL purposes, we will change URL to point to tab
                // HOWEVER, we do not want to cause a scroll so we will be careful
                tab_marker.id = '';
                window.location.hash = '#tab__' + tab.toLowerCase();
                tab_marker.id = 'tab__' + tab.toLowerCase();
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
                        $cms.dom.clearTransitionAndSetOpacity(element, 0.0);
                        $cms.dom.fadeTransition(element, 100, 30, 8);
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
     *  Tooltips that can work on any element with rich HTML support
     * @memberof $cms.ui
     * @param el - the element
     * @param event - the event handler
     * @param tooltip - the text for the tooltip
     * @param width - width is in pixels (but you need 'px' on the end), can be null or auto
     * @param pic - the picture to show in the top-left corner of the tooltip; should be around 30px x 30px
     * @param height - the maximum height of the tooltip for situations where an internal but unusable scrollbar is wanted
     * @param bottom - set to true if the tooltip should definitely appear upwards; rarely use this parameter
     * @param no_delay - set to true if the tooltip should appear instantly
     * @param lights_off - set to true if the image is to be dimmed
     * @param force_width - set to true if you want width to not be a max width
     * @param win - window to open in
     * @param have_links - set to true if we activate/deactivate by clicking due to possible links in the tooltip or the need for it to work on mobile
     */
    $cms.ui.activateTooltip = function activateTooltip(el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, have_links) {
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

        if (!have_links && $cms.isTouchEnabled()) {
            return; // Too erratic
        }

        $cms.ui.clearOutTooltips(el.tooltip_id);

        // Add in move/leave events if needed
        if (!have_links) {
            $cms.dom.on(el, 'mouseout.cmsTooltip', function () {
                $cms.ui.deactivateTooltip(el);
            });

            $cms.dom.on(el, 'mousemove.cmsTooltip', function () {
                $cms.ui.repositionTooltip(el, event, false, false, null, false, win);
            });
        } else {
            $cms.dom.on(el, 'click.cmsTooltip', function () {
                $cms.ui.deactivateTooltip(el);
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
        if ((el.tooltip_id != null) && ($cms.dom.$id(el.tooltip_id))) {
            tooltipEl = $cms.dom.$('#' + el.tooltip_id);
            tooltipEl.style.display = 'none';
            $cms.dom.html(tooltipEl, '');
            window.setTimeout(function () {
                $cms.ui.repositionTooltip(el, event, bottom, true, tooltipEl, force_width);
            }, 0);
        } else {
            tooltipEl = document.createElement('div');
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
                    var new_auto_width = $cms.dom.getWindowWidth(win) - 30 - window.mouse_x;
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
            $cms.ui.repositionTooltip(el, event, bottom, true, tooltipEl, force_width);
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

        var eventCopy = { // Needs to be copied as it will get erased on IE after this function ends
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

            if ((!el.tooltip_on) || (tooltipEl.childNodes.length === 0)) {// Some other tooltip jumped in and wiped out tooltip on a delayed-show yet never triggers due to losing focus during that delay
                $cms.dom.appendHtml(tooltipEl, tooltip);
            }

            el.tooltip_on = true;
            tooltipEl.style.display = 'block';
            if (tooltipEl.style.width == 'auto')
                tooltipEl.style.width = ($cms.dom.contentWidth(tooltipEl) + 1/*for rounding issues from em*/) + 'px'; // Fix it, to stop the browser retroactively reflowing ambiguous layer widths on mouse movement

            if (!no_delay) {
                // If delayed we will sub in what the currently known global mouse coordinate is
                eventCopy.pageX = win.mouse_x;
                eventCopy.pageY = win.mouse_y;
            }

            $cms.ui.repositionTooltip(el, eventCopy, bottom, true, tooltipEl, force_width, win);
        }, no_delay ? 0 : 666);
    };

    /**
     *
     * @param el
     * @param event
     * @param bottom
     * @param starting
     * @param tooltip_element
     * @param force_width
     * @param win
     */
    $cms.ui.repositionTooltip = function repositionTooltip(el, event, bottom, starting, tooltip_element, force_width, win) {
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

                x = (event.type === 'focus') ? (win.pageXOffset + $cms.dom.getWindowWidth(win) / 2) : (window.mouse_x + style__offset_x);
                y = (event.type === 'focus') ? (win.pageYOffset + $cms.dom.getWindowHeight(win) / 2 - 40) : (window.mouse_y + style__offset_y);
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
        var x_excess = x - $cms.dom.getWindowWidth(win) - win.pageXOffset + width + 10/*magic tolerance factor*/;
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
            var y_excess = y - $cms.dom.getWindowHeight(win) - win.pageYOffset + height + style__offset_y;
            if (y_excess > 0) y -= y_excess;
            var scroll_y = win.pageYOffset;
            if (y < scroll_y) y = scroll_y;
            tooltip_element.style.top = y + 'px';
        }
        tooltip_element.style.left = x + 'px';
    };

    /**
     *
     * @param el
     * @param tooltip_element
     */
    $cms.ui.deactivateTooltip = function deactivateTooltip(el, tooltip_element) {
        el.is_over = false;

        if (el.tooltip_id == null) {
            return;
        }

        tooltip_element || (tooltip_element = $cms.dom.$('#' + el.tooltip_id));

        if (tooltip_element) {
            $cms.dom.off(tooltip_element, 'mouseout.cmsTooltip');
            $cms.dom.off(tooltip_element, 'mousemove.cmsTooltip');
            $cms.dom.off(tooltip_element, 'click.cmsTooltip');
            $cms.dom.hide(tooltip_element);
        }
    };

    /**
     *
     * @param tooltip_being_opened
     */
    $cms.ui.clearOutTooltips = function clearOutTooltips(tooltip_being_opened) {
        // Delete other tooltips, which due to browser bugs can get stuck
        var selector = '.tooltip';
        if (tooltip_being_opened) {
            selector += ':not(#' + tooltip_being_opened + ')';
        }
        $cms.dom.$$(selector).forEach(function (el) {
            $cms.ui.deactivateTooltip(el.ac, el);
        });
    };

    window.$cmsReady.push(function () {
        // Tooltips close on browser resize
        $cms.dom.on(window, 'resize', function () {
            $cms.ui.clearOutTooltips();
        });
    });

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
        this.WINDOW_SIDE_GAP = $cms.$MOBILE() ? 5 : 25;
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

    $cms.inherits(ModalWindow, $cms.View, /**@lends $cms.views.ModalWindow#*/ {
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
                        detected_box_height = $cms.dom.getWindowScrollHeight(iframe.contentWindow);
                        iframe.style.height = detected_box_height + 'px';
                    }
                } else {
                    iframe.style.height = '100%';
                }
            }

            // Work out box position
            if (!detected_box_height) {
                detected_box_height = this.boxWrapperEl.firstElementChild.offsetHeight;
            }
            var _box_pos_top, _box_pos_left, box_pos_top, box_pos_left;
            if (box_height === 'auto') {
                if (init) {
                    _box_pos_top = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (this.LOADING_SCREEN_HEIGHT / 2) + this.WINDOW_TOP_GAP; // This is just temporary
                } else {
                    _box_pos_top = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (detected_box_height / 2) + this.WINDOW_TOP_GAP;
                }

                if (iframe) { // Actually, for frames we'll put at top so things don't bounce about during loading and if the frame size changes
                    _box_pos_top = this.WINDOW_TOP_GAP;
                }
            } else {
                _box_pos_top = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (parseInt(box_height) / 2) + this.WINDOW_TOP_GAP;
            }
            if (_box_pos_top < this.WINDOW_TOP_GAP) {
                _box_pos_top = this.WINDOW_TOP_GAP;
            }
            _box_pos_left = ((dim.window_width / 2) - (parseInt(box_width) / 2));
            box_pos_top = _box_pos_top + 'px';
            box_pos_left = _box_pos_left + 'px';

            // Save into HTML
            this.boxWrapperEl.firstElementChild.style.top = box_pos_top;
            this.boxWrapperEl.firstElementChild.style.left = box_pos_left;

            var do_scroll = false;

            // Absolute positioning instead of fixed positioning
            if ($cms.$MOBILE() || (detected_box_height > dim.window_height) || (this.boxWrapperEl.style.position === 'absolute'/*don't switch back to fixed*/)) {
                var was_fixed = (this.boxWrapperEl.style.position == 'fixed');

                this.boxWrapperEl.style.position = 'absolute';
                this.boxWrapperEl.style.height = ((dim.page_height > (detected_box_height + bottom_gap + _box_pos_left)) ? dim.page_height : (detected_box_height + bottom_gap + _box_pos_left)) + 'px';
                this.top_window.document.body.style.overflow = '';

                if (!$cms.$MOBILE()) {
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
                    'position': $cms.$MOBILE() ? 'absolute' : 'fixed',
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
                    'position': $cms.$MOBILE() ? 'static' : 'fixed',
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
                    e && e.target && e.stopPropagation && e.stopPropagation();
                } catch (e) {}

                if ($cms.$MOBILE() && (that.type === 'lightbox')) {// IDEA: Swipe detect would be better, but JS does not have this natively yet
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

                    $cms.dom.animateFrameLoad(iframe, 'overlay_iframe', 50, true);

                    if (that.boxWrapperEl) {
                        window.setTimeout(function () {
                            $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_finished);
                        }, 1000);
                    }

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
                        $cms.dom.illustrateFrameLoad('overlay_iframe');
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

                        if (that.boxWrapperEl) {
                            window.setTimeout(function () {
                                $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_yes);
                            }, 1000);
                        }

                        this.button_container.appendChild(button);
                    } else {
                        if (that.boxWrapperEl) {
                            window.setTimeout(function () {
                                $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_cancel);
                            }, 1000);
                        }
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
                    if (that.boxWrapperEl) {
                        window.setTimeout(function () {
                            $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_cancel);
                        }, 1000);
                    }
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
                } catch (ignore) {}
                return has_loaded;
            }

            function has_iframe_ownership(iframe) {
                var has_ownership = false;
                try {
                    has_ownership = (typeof iframe != 'undefined') && (iframe != null) && (iframe.contentWindow.location.host == window.location.host) && (iframe.contentWindow.document != null);
                } catch (ignore) {}
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
                'page_width': this.top_window.document.body.scrollWidth,
                'page_height': this.top_window.$cms.dom.getWindowScrollHeight(this.top_window),
                'window_width': this.top_window.$cms.dom.getWindowWidth(this.top_window),
                'window_height': this.top_window.$cms.dom.getWindowHeight()
            };
        }
    });

    /**
     * Ask a user a question: they must click a button
     * 'Cancel' should come as index 0 and Ok/default-option should come as index 1. This is so that the fallback works right.
     * @param message
     * @param button_set
     * @param window_title
     * @param fallback_message
     * @param callback
     * @param dialog_width
     * @param dialog_height
     */
    $cms.ui.generateQuestionUi = function generateQuestionUi(message, button_set, window_title, fallback_message, callback, dialog_width, dialog_height) {
        var image_set = [];
        var new_button_set = [];
        for (var s in button_set) {
            new_button_set.push(button_set[s]);
            image_set.push(s);
        }
        button_set = new_button_set;

        if ((window.showModalDialog !== undefined) || $cms.$CONFIG_OPTION('js_overlays')) {
            if (button_set.length > 4) {
                dialog_height += 5 * (button_set.length - 4);
            }

            // Intentionally FIND_SCRIPT and not FIND_SCRIPT_NOHTTP, because no needs-HTTPS security restriction applies to popups, yet popups do not know if they run on HTTPS if behind a transparent reverse proxy
            var url = $cms.maintainThemeInLink('{$FIND_SCRIPT;,question_ui}?message=' + encodeURIComponent(message) + '&image_set=' + encodeURIComponent(image_set.join(',')) + '&button_set=' + encodeURIComponent(button_set.join(',')) + '&window_title=' + encodeURIComponent(window_title) + $cms.keepStub());
            if (dialog_width === undefined) {
                dialog_width = 440;
            }
            if (dialog_height === undefined) {
                dialog_height = 180;
            }
            $cms.ui.showModalDialog(
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
            $cms.ui.alert(
                fallback_message ? fallback_message : message,
                function () {
                    callback(button_set[0]);
                },
                window_title
            );
        } else if (button_set.length == 2) {
            $cms.ui.confirm(
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

            $cms.ui.prompt(
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
    };

    var ajaxInstances,
        ajaxCallbacks,
        networkDownAlerted = false;

    /**
     *
     * @param url
     * @param callbackMethod
     * @param post
     * @returns {*}
     */
    $cms.doAjaxRequest = function doAjaxRequest(url, callbackMethod, post) { // Note: 'post' is not an array, it's a string (a=b)
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
                post += '&csrf_token=' + encodeURIComponent($cms.getCsrfToken());
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
                                $cms.ui.alert('{!NETWORK_DOWN;^}');
                                networkDownAlerted = true;
                            }
                        } else {
                            $cms.error('$cms.doAjaxRequest(): {!PROBLEM_RETRIEVING_XML;^}\n' + xhr.status + ': ' + xhr.statusText + '.', xhr);
                        }
                    } catch (e) {
                        $cms.error('$cms.doAjaxRequest(): {!PROBLEM_RETRIEVING_XML;^}', e); // This is probably clicking back
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
                method = methodEl ? eval('return ' + methodEl.textContent) : ajaxCallbacks[i];
            }

            var messageEl = ajaxResultFrame.querySelector('message');
            if (messageEl) {
                // Either an error or a message was returned. :(
                var message = messageEl.firstChild.data;

                callAjaxMethod(method);

                if (ajaxResultFrame.querySelector('error')) {
                    // It's an error :|
                    $cms.ui.alert('An error (' + ajaxResultFrame.querySelector('error').firstChild.data + ') message was returned by the server: ' + message);
                    return;
                }

                $cms.ui.alert('An informational message was returned by the server: ' + message);
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
                $cms.error('$cms.doAjaxRequest(): ', xhr);
                $cms.ui.alert(xhr.responseText, null, '{!ERROR_OCCURRED;^}', true);
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
    };


}(window.$cms || (window.$cms = {}), !window.IN_MINIKERNEL_VERSION ? JSON.parse(document.getElementById('composr-symbol-data').content) : {}));

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

    /**
     *
     * @param event
     */
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

    /**
     *
     * @param infinite_scrolling
     */
    function infinite_scrolling_block_unhold(infinite_scrolling) {
        if (infinite_scroll_mouse_held) {
            infinite_scroll_blocked = false;
            infinite_scroll_mouse_held = false;
            infinite_scrolling();
        }
    }

    /**
     *
     * @param url_stem
     * @param wrapper
     * @returns {*}
     */
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
        var wrapper_pos_y = $cms.dom.findPosY(wrapper);
        var wrapper_height = wrapper.offsetHeight;
        var wrapper_bottom = wrapper_pos_y + wrapper_height;
        var window_height = $cms.dom.getWindowHeight();
        var page_height = $cms.dom.getWindowScrollHeight();
        var scroll_y = window.pageYOffset;

        // Scroll down -- load
        if ((scroll_y + window_height > wrapper_bottom - window_height * 2) && (scroll_y + window_height < page_height - 30)) // If within window_height*2 pixels of load area and not within 30 pixels of window bottom (so you can press End key)
        {
            return internalise_infinite_scrolling_go(url_stem, wrapper, more_links);
        }

        return false;
    }

    /**
     *
     * @param url_stem
     * @param wrapper
     * @param more_links
     * @returns {boolean}
     */
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

                    return $cms.callBlock(url_stem + url_stub, '', wrapper_inner, true, function () {
                        infinite_scroll_pending = false;
                        internalise_infinite_scrolling(url_stem, wrapper);
                    });
                }
            }
        }

        return false;
    }

    /**
     *
     * @param url_stem
     * @param block_element
     * @param look_for
     * @param extra_params
     * @param append
     * @param forms_too
     * @param scroll_to_top
     */
    function internalise_ajax_block_wrapper_links(url_stem, block_element, look_for, extra_params, append, forms_too, scroll_to_top) {
        look_for || (look_for = []);
        extra_params || (extra_params = []);
        append = !!append;
        forms_too = !!forms_too;
        scroll_to_top = (scroll_to_top !== undefined) ? !!scroll_to_top : true;

        var block_pos_y = $cms.dom.findPosY(block_element, true);
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

                for (var k = 0; k < _links.length; k++) {
                    links.push(_links[k]);
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
                url_stub += j + '=' + encodeURIComponent(extra_params[j]);
            }

            // Any POST parameters?
            var post_params = null, param;
            if (this.localName === 'form') {
                post_params = '';
                for (j = 0; j < this.elements.length; j++) {
                    if (this.elements[j].name) {
                        param = this.elements[j].name + '=' + encodeURIComponent($cms.form.cleverFindValue(this, this.elements[j]));

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

            $cms.ui.clearOutTooltips();

            // Make AJAX block call
            return $cms.callBlock(url_stem + url_stub, '', block_element, append, function () {
                if (scroll_to_top) {
                    window.scrollTo(0, block_pos_y);
                }
            }, false, post_params);
        }
    }
}());


(function ($cms) {
    'use strict';

    window.$cmsReady.push(function () {
        $cms.attachBehaviors(document);
    });

    $cms.defineBehaviors(/**@lends $cms.behaviors*/{
        // Implementation for [data-require-javascript="[<scripts>...]"]
        initializeRequireJavascript: {
            priority: 10000,
            attach: function (context) {
                var promises = [];

                $cms.dom.$$$(context, '[data-require-javascript]').forEach(function (el) {
                    var scripts = arrVal($cms.dom.data(el, 'requireJavascript'));

                    if (scripts.length) {
                        promises.push($cms.requireJavascript(scripts));
                    }
                });

                return Promise.all(promises);
            }
        },

        // Implementation for [data-view]
        initializeViews: {
            attach: function (context) {
                $cms.dom.$$$(context, '[data-view]').forEach(function (el) {
                    var params = objVal($cms.dom.data(el, 'viewParams')),
                        view, viewOptions = { el: el };

                    try {
                        view = new $cms.views[el.dataset.view](params, viewOptions);
                        $cms.viewInstances[$cms.uid(view)] = view;
                        //$cms.log('$cms.behaviors.initializeViews.attach(): Initialized view "' + el.dataset.view + '"', view);
                    } catch (ex) {
                        $cms.error('$cms.behaviors.initializeViews.attach(): Exception thrown while initializing view "' + el.dataset.view + '" for', el, ex);
                    }
                });
            }
        },

        // Implementation for [data-tpl]
        initializeTemplates: {
            attach: function (context) {
                $cms.dom.$$$(context, '[data-tpl]').forEach(function (el) {
                    var template = el.dataset.tpl,
                        params = objVal($cms.dom.data(el, 'tplParams'));

                    try {
                        $cms.templates[template].call(el, params, el);
                    } catch (ex) {
                        $cms.error('$cms.behaviors.initializeTemplates.attach(): Exception thrown while calling the template function "' + template + '" for', el, ex);
                    }
                });
            }
        },

        initializeAnchors: {
            attach: function (context) {
                var anchors = $cms.dom.$$$(context, 'a'),
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
                            convert_tooltip(anchor);
                        }
                    }

                    if ($cms.$VALUE_OPTION('js_keep_params')) {
                        // Keep parameters need propagating
                        if (anchor.href && anchor.href.startsWith($cms.$BASE_URL_S())) {
                            anchor.href += keep_stub_with_context(anchor.href);
                        }
                    }
                });
            }
        },

        initializeForms: {
            attach: function (context) {
                var forms = $cms.dom.$$$(context, 'form');

                forms.forEach(function (form) {
                    // HTML editor
                    if (window.load_html_edit !== undefined) {
                        load_html_edit(form);
                    }

                    // Remove tooltips from forms as they are for screenreader accessibility only
                    form.title = '';

                    // Convert form element title attributes into composr tooltips
                    if ($cms.$CONFIG_OPTION('js_overlays')) {
                        // Convert title attributes into composr tooltips
                        var elements = form.elements, j;

                        for (j = 0; j < elements.length; j++) {
                            if ((elements[j].title !== undefined) && (elements[j]['original-title'] === undefined/*check tipsy not used*/) && !elements[j].classList.contains('no_tooltip')) {
                                convert_tooltip(elements[j]);
                            }
                        }

                        elements = form.querySelectorAll('input[type="image"][title]'); // JS DOM does not include type="image" ones in form.elements
                        for (j = 0; j < elements.length; j++) {
                            if ((elements[j]['original-title'] === undefined/*check tipsy not used*/) && !elements[j].classList.contains('no_tooltip')) {
                                convert_tooltip(elements[j]);
                            }
                        }
                    }

                    if ($cms.$VALUE_OPTION('js_keep_params')) {
                        /* Keep parameters need propagating */
                        if (form.action && form.action.startsWith($cms.$BASE_URL_S())) {
                            form.action += keep_stub_with_context(form.action);
                        }
                    }

                    // This "proves" that JS is running, which is an anti-spam heuristic (bots rarely have working JS)
                    if (typeof form.elements['csrf_token'] != 'undefined' && typeof form.elements['js_token'] == 'undefined') {
                        var js_token = document.createElement('input');
                        js_token.name = 'js_token';
                        js_token.value = form.elements['csrf_token'].value.split("").reverse().join(""); // Reverse the CSRF token for our JS token
                        js_token.type = 'hidden';
                        form.appendChild(js_token);
                    }
                });
            }
        },

        initializeInputs: {
            attach: function (context) {
                var inputs = $cms.dom.$$$(context, 'input');

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

        // Convert img title attributes into composr tooltips
        imageTooltips: {
            attach: function (context) {
                if (!$cms.$CONFIG_OPTION('js_overlays')) {
                    return;
                }

                $cms.dom.$$$(context, 'img:not([data-cms-rich-tooltip])').forEach(function (img) {
                    convert_tooltip(img);
                });
            }
        },

        // Implementation for [data-js-function-calls]
        jsFunctionCalls: {
            attach: function (context) {
                var els = $cms.dom.$$$(context, '[data-js-function-calls]');

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
                if (!window.jQuery || !window.jQuery.fn.select2) {
                    return;
                }

                var els = $cms.dom.$$$(context, '[data-cms-select2]');

                // Select2 plugin hook
                els.forEach(function (el) {
                    var options = objVal($cms.dom.data(el, 'cmsSelect2'));
                    window.jQuery(el).select2(options);
                });
            }
        },

        // Implementation for img[data-gd-text]
        gdTextImages: {
            attach: function (context) {
                var els = $cms.dom.$$$(context, 'img[data-gd-text]');

                els.forEach(function (img) {
                    gdImageTransform(img);
                });
            }
        },

        // Implementation for [data-toggleable-tray]
        toggleableTray: {
            attach: function (context) {
                var els = $cms.dom.$$$(context, '[data-toggleable-tray]');

                els.forEach(function (el) {
                    var options = objVal($cms.dom.data(el, 'toggleableTray')),
                        tray = new $cms.views.ToggleableTray(options, { el: el });
                });
            }
        }
    });

    function keep_stub_with_context(context) {
        context || (context = '');

        var starting = !context || !context.includes('?');

        var to_add = '', i,
            bits = (window.location.search || '?').substr(1).split('&'),
            gapSymbol;

        for (i = 0; i < bits.length; i++) {
            if (bits[i].startsWith('keep_')) {
                if (!context || (!context.includes('?' + bits[i]) && !context.includes('&' + bits[i]))) {
                    gapSymbol = ((to_add === '') && starting) ? '?' : '&';
                    to_add += gapSymbol + bits[i];
                }
            }
        }

        return to_add;
    }

    /**
     * @memberof $cms.views
     * @class
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

            if ($cms.$CONFIG_OPTION('long_google_cookies')) {
                window.ga('create', $cms.$CONFIG_OPTION('google_analytics').trim(), 'auto');
            } else {
                window.ga('create', $cms.$CONFIG_OPTION('google_analytics').trim(), { cookieExpires: 0 });
            }
            window.ga('send','pageview');
        }

        // Cookie Consent plugin by Silktide - http://silktide.com/cookieconsent
        if ($cms.$CONFIG_OPTION('cookie_notice') && ($cms.$RUNNING_SCRIPT() === 'index')) {
            window.cookieconsent_options = {
                'message': $cms.format('{!COOKIE_NOTICE;}', $cms.$SITE_NAME()),
                'dismiss': '{!INPUTSYSTEM_OK;}',
                'learnMore': '{!READ_MORE;}',
                'link': '{$PAGE_LINK;,:privacy}',
                'theme': 'dark-top'
            };
            document.body.appendChild($cms.dom.create('script', null, {
                src: 'https://cdnjs.cloudflare.com/ajax/libs/cookieconsent2/1.0.9/cookieconsent.min.js',
                defer: true
            }));
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
            $cms.dom.appendHtml(m1, $cms.dom.html(m2));
            m2.parentNode.removeChild(m2);
        }

        if ($cms.usp.get('wide_print') && ($cms.usp.get('wide_print') !== '0')) {
            try {
                window.print();
            } catch (ignore) {}
        }

        if (($cms.$ZONE() === 'adminzone') && $cms.$CONFIG_OPTION('background_template_compilation')) {
            var page = $cms.filter.url($cms.$PAGE());
            $cms.loadSnippet('background_template_compilation&page=' + page, '', function () {
            });
        }

        if (((window === window.top) && !window.opener) || (window.name === '')) {
            window.name = '_site_opener';
        }

        // Are we dealing with a touch device?
        if ($cms.isTouchEnabled()) {
            document.body.classList.add('touch_enabled');
        }

        if ($cms.$HAS_PRIVILEGE('sees_javascript_error_alerts')) {
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
                $cms.setCookie('client_time_ref', $cms.$FROM_TIMESTAMP(), 120);
            }
        }

        // Mouse/keyboard listening
        window.mouse_x = 0;
        window.mouse_y = 0;

        this.stuckNavs();

        // If back button pressed back from an AJAX-generated page variant we need to refresh page because we aren't doing full JS state management
        window.onpopstate = function () {
            window.setTimeout(function () {
                if (!window.location.hash && window.has_js_state) {
                    window.location.reload();
                }
            });
        };

        // Monitor pasting, for anti-spam reasons
        window.addEventListener('paste', function (event) {
            var clipboard_data = event.clipboardData || window.clipboardData;
            var pasted_data = clipboard_data.getData('Text');
            if (pasted_data && pasted_data.length > $cms.$CONFIG_OPTION('spam_heuristic_pasting')) {
                $cms.setPostDataFlag('paste');
            }
        });

        window.page_loaded = true;

        var view = this;
        /* Tidying up after the page is rendered */
        window.$cmsLoad.push(function () {
            // When images etc have loaded
            // Move the help panel if needed
            if ($cms.$CONFIG_OPTION('fixed_width') || ($cms.dom.getWindowWidth() > 990)) {
                return;
            }

            var panel_right = view.$('#panel_right');
            if (!panel_right) {
                return;
            }

            var helperPanel = panel_right.querySelector('.global_helper_panel');
            if (!helperPanel) {
                return;
            }

            var middle = panel_right.parentNode.querySelector('.global_middle');
            if (!middle) {
                return;
            }

            middle.style.marginRight = '0';
            var boxes = panel_right.querySelectorAll('.standardbox_curved'), i;
            for (i = 0; i < boxes.length; i++) {
                boxes[i].style.width = 'auto';
            }
            panel_right.classList.add('horiz_helper_panel');
            panel_right.parentNode.removeChild(panel_right);
            middle.parentNode.appendChild(panel_right);
            $cms.dom.$('#helper_panel_toggle').style.display = 'none';
            helperPanel.style.minHeight = '0';
        });

        if ($cms.$IS_STAFF()) {
            this.loadStuffStaff()
        }
    };

    $cms.inherits($cms.views.Global, $cms.View, /**@lends $cms.views.Global#*/{
        events: function () {
            return {
                // Show a confirmation dialog for clicks on a link (is higher up for priority)
                'click [data-cms-confirm-click]': 'confirmClick',

                'click [data-click-eval]': 'clickEval',

                'click [data-click-alert]': 'showModalAlert',
                'click [data-keypress-alert]': 'showModalAlert',

                // Prevent url change for clicks on anchor tags with a placeholder href
                'click a[href$="#!"]': 'preventDefault',
                // Prevent form submission for forms with a placeholder action
                'submit form[action$="#!"]': 'preventDefault',
                // Prevent-default for JS-activated elements (which may have noscript fallbacks as default actions)
                'submit [data-click-pd]': 'clickPreventDefault',
                'submit [data-submit-pd]': 'submitPreventDefault',

                // Simulated href for non <a> elements
                'click [data-cms-href]': 'cmsHref',

                'click [data-click-forward]': 'clickForward',

                // Toggle classes on mouseover/out
                'mouseover [data-mouseover-class]': 'mouseoverClass',
                'mouseout [data-mouseout-class]': 'mouseoutClass',

                // Disable button after click
                'click [data-disable-on-click]': 'disableButton',

                // Submit form when the change event is fired on an input element
                'change [data-change-submit-form]': 'changeSubmitForm',

                // Disable form buttons
                'submit form[data-disable-buttons-on-submit]': 'disableFormButtons',

                // mod_security workaround
                'submit form[data-submit-modsecurity-workaround]': 'submitModsecurityWorkaround',

                // Prevents input of matching characters
                'input input[data-cms-invalid-pattern]': 'invalidPattern',
                'keydown input[data-cms-invalid-pattern]': 'invalidPattern',
                'keypress input[data-cms-invalid-pattern]': 'invalidPattern',

                'change textarea[data-textarea-auto-height]': 'textareaAutoHeight',
                'keyup textarea[data-textarea-auto-height]': 'textareaAutoHeight',

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
                'click [data-click-tray-accordion-toggle]': 'clickTrayAccordionToggle',

                /* Footer links */
                'click .js-click-load-software-chat': 'loadSoftwareChat',

                'submit .js-submit-staff-actions-select': 'staffActionsSelect',

                'keypress .js-input-su-keypress-enter-submit-form': 'inputSuKeypress',

                'click .js-global-click-load-realtime-rain': 'loadRealtimeRain',

                'click .js-global-click-load-commandr': 'loadCommandr'

            };
        },

        stuckNavs: function () {
            // Pinning to top if scroll out
            var stuck_navs = $cms.dom.$$('.stuck_nav');

            if (!stuck_navs.length) {
                return;
            }

            $cms.dom.on(window, 'scroll', function () {
                for (var i = 0; i < stuck_navs.length; i++) {
                    var stuck_nav = stuck_navs[i],
                        stuck_nav_height = (stuck_nav.real_height === undefined) ? $cms.dom.contentHeight(stuck_nav) : stuck_nav.real_height;

                    stuck_nav.real_height = stuck_nav_height;
                    var pos_y = $cms.dom.findPosY(stuck_nav.parentNode, true),
                        footer_height = document.querySelector('footer').offsetHeight,
                        panel_bottom = $cms.dom.$id('panel_bottom');

                    if (panel_bottom) {
                        footer_height += panel_bottom.offsetHeight;
                    }
                    panel_bottom = $cms.dom.$id('global_messages_2');
                    if (panel_bottom) {
                        footer_height += panel_bottom.offsetHeight;
                    }
                    if (stuck_nav_height < $cms.dom.getWindowHeight() - footer_height) {// If there's space in the window to make it "float" between header/footer
                        var extra_height = (window.pageYOffset - pos_y);
                        if (extra_height > 0) {
                            var width = $cms.dom.contentWidth(stuck_nav);
                            var height = $cms.dom.contentHeight(stuck_nav);
                            var stuck_nav_width = $cms.dom.contentWidth(stuck_nav);
                            if (!window.getComputedStyle(stuck_nav).getPropertyValue('width')) {// May be centered or something, we should be careful
                                stuck_nav.parentNode.style.width = width + 'px';
                            }
                            stuck_nav.parentNode.style.height = height + 'px';
                            stuck_nav.style.position = 'fixed';
                            stuck_nav.style.top = '0px';
                            stuck_nav.style.zIndex = '1000';
                            stuck_nav.style.width = stuck_nav_width + 'px';
                        } else {
                            stuck_nav.parentNode.style.width = '';
                            stuck_nav.parentNode.style.height = '';
                            stuck_nav.style.position = '';
                            stuck_nav.style.top = '';
                            stuck_nav.style.width = '';
                        }
                    } else {
                        stuck_nav.parentNode.style.width = '';
                        stuck_nav.parentNode.style.height = '';
                        stuck_nav.style.position = '';
                        stuck_nav.style.top = '';
                        stuck_nav.style.width = '';
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
            var options = objVal($cms.dom.data(target, e.type + 'Alert'), 'notice');
            $cms.ui.alert(options.notice);
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
            var options = objVal($cms.dom.data(el, 'clickForward'), 'child'),
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

        // Implementation for [data-disable-on-click]
        disableButton: function (e, target) {
            $cms.ui.disableButton(target);
        },

        // Implementation for [data-change-submit-form]
        changeSubmitForm: function (e, input) {
            if (input.form != null) {
                input.form.submit();
            }
        },

        // Implementation for form[data-disable-buttons-on-submit]
        disableFormButtons: function (e, target) {
            $cms.ui.disableFormButtons(target);
        },

        // Implementation for form[data-submit-modsecurity-workaround]
        submitModsecurityWorkaround: function (e, form) {
            e.preventDefault();
            $cms.form.modsecurityWorkaround(form);
        },

        // Implementation for input[data-cms-invalid-pattern]
        invalidPattern: function (e, input) {
            var pattern = input.dataset.cmsInvalidPattern, regex;

            this._invalidPatternCache || (this._invalidPatternCache = {});

            regex = this._invalidPatternCache[pattern] || (this._invalidPatternCache[pattern] = new RegExp(pattern, 'g'));

            if (e.type === 'input') {
                if (input.value.length === 0) {
                    input.value = ''; // value.length is also 0 if invalid value is entered for input[type=number] et al., clear that
                } else if (regex.test(input.value)) {
                    input.value = input.value.replace(regex, '');
                }
            } else if ($cms.dom.keyOutput(e, regex)) { // keydown/keypress event
                // pattern matched, prevent input
                e.preventDefault();
            }
        },

        // Implementation for textarea[data-textarea-auto-height]
        textareaAutoHeight: function (e, textarea) {
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

            if (/:\/\/(.[^/]+)/.exec(url)[1] !== window.location.hostname) {
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
                var has_full_button = (el.firstElementChild === null) || (el.href !== el.firstElementChild.src);
                $cms.ui.openImageIntoLightbox(el.href, ((el.cms_tooltip_title !== undefined) ? el.cms_tooltip_title : el.title), null, null, has_full_button);
            }
        },

        goBackInHistory: function () {
            window.history.back();
        },

        // Implementation for [data-mouseover-activate-tooltip]
        mouseoverActivateTooltip: function (e, el) {
            var args = arrVal($cms.dom.data(el, 'mouseoverActivateTooltip'), true);

            args.unshift(el, e);

            try {
                //arguments: el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, have_links
                $cms.ui.activateTooltip.apply(undefined, args);
            } catch (ex) {
                $cms.error('$cms.views.Global#mouseoverActivateTooltip(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
            }
        },

        // Implementation for [data-focus-activate-tooltip]
        focusActivateTooltip: function (e, el) {
            var args = arrVal($cms.dom.data(el, 'focusActivateTooltip'), true);

            args.unshift(el, e);

            try {
                //arguments: el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, have_links
                $cms.ui.activateTooltip.apply(undefined, args);
            } catch (ex) {
                $cms.error('$cms.views.Global#focusActivateTooltip(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
            }
        },

        // Implementation for [data-blur-deactivate-tooltip]
        blurDeactivateTooltip: function (e, el) {
            $cms.ui.deactivateTooltip(el);
        },

        activateRichTooltip: function (e, el) {
            if (el.ttitle === undefined) {
                el.ttitle = el.title;
            }

            //arguments: el, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, have_links
            var args = [el, e, el.ttitle, 'auto', null, null, false, true, false, false, window, !!el.have_links];

            try {
                $cms.ui.activateTooltip.apply(undefined, args);
            } catch (ex) {
                $cms.error('$cms.views.Global#activateRichTooltip(): Exception thrown by $cms.ui.activateTooltip()', ex, 'called with args:', args);
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
                return
            }

            trayCookie = strVal(trayEl.dataset.trayCookie);

            if (trayCookie) {
                $cms.setCookie('tray_' + trayCookie, $cms.dom.isDisplayed(trayEl) ? 'closed' : 'open');
            }

            $cms.toggleableTray(trayEl);
        },

        // Implementation for [data-click-tray-accordion-toggle]
        clickTrayAccordionToggle: function () {

        },

        // Detecting of JavaScript support
        detectJavascript: function () {
            var url = window.location.href,
                append = '?';

            if ($cms.$JS_ON() || $cms.usp.get('keep_has_js') || url.includes('upgrader.php') || url.includes('webdav.php')) {
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

        /* SOFTWARE CHAT */
        loadSoftwareChat: function () {
            var url = 'https://kiwiirc.com/client/irc.kiwiirc.com/?nick=';
            if ($cms.$USERNAME() !== 'admin') {
                url += encodeURIComponent($cms.$USERNAME().replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g, ''));
            } else {
                url += encodeURIComponent($cms.$SITE_NAME().replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g, ''));
            }
            url += '#composrcms';

            var SOFTWARE_CHAT_EXTRA = '{!SOFTWARE_CHAT_EXTRA;^}'.replace(/\{1\}/, $cms.filter.html(window.location.href.replace($cms.$BASE_URL(), 'http://baseurl')));
            var html = '\
    <div class="software_chat">\
        <h2>{!CMS_COMMUNITY_HELP}</h2>\
        <ul class="spaced_list">' + SOFTWARE_CHAT_EXTRA + '</ul>\
        <p class="associated_link associated_links_block_group">\
            <a title="{!SOFTWARE_CHAT_STANDALONE} {!LINK_NEW_WINDOW;^}" target="_blank" href="' + $cms.filter.html(url) + '">{!SOFTWARE_CHAT_STANDALONE}</a>\
            <a href="#!" class="js-click-load-software-chat">{!HIDE}</a>\
        </p>\
    </div>\
    <iframe class="software_chat_iframe" style="border: 0" src="' + $cms.filter.html(url) + '"></iframe>';

            var box = $cms.dom.$('#software_chat_box'), img;
            if (box) {
                box.parentNode.removeChild(box);

                img = $cms.dom.$('#software_chat_img');
                $cms.dom.clearTransitionAndSetOpacity(img, 1.0);
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
                $cms.dom.clearTransitionAndSetOpacity(img, 0.5);
            }
        },

        /* STAFF ACTIONS LINKS */
        staffActionsSelect: function (e, form) {
            var ob = form.elements.special_page_type;

            var val = ob.options[ob.selectedIndex].value;
            if (val !== 'view') {
                if (form.elements.cache !== undefined) {
                    form.elements.cache.value = (val.substring(val.length - 4, val.length) == '.css') ? '1' : '0';
                }

                var window_name = 'cms_dev_tools' + Math.floor(Math.random() * 10000);
                var window_options;
                if (val == 'templates') {
                    window_options = 'width=' + window.screen.availWidth + ',height=' + window.screen.availHeight + ',scrollbars=yes';

                    window.setTimeout(function () { // Do a refresh with magic markers, in a comfortable few seconds
                        var old_url = window.location.href;
                        if (old_url.indexOf('keep_template_magic_markers=1') == -1) {
                            window.location.href = old_url + ((old_url.indexOf('?') == -1) ? '?' : '&') + 'keep_template_magic_markers=1&cache_blocks=0&cache_comcode_pages=0';
                        }
                    }, 10000);
                } else {
                    window_options = 'width=1020,height=700,scrollbars=yes';
                }
                var test = window.open('', window_name, window_options);

                if (test) {
                    form.setAttribute('target', test.name);
                }
            }
        },

        inputSuKeypress: function (e, input) {
            if ($cms.dom.keyPressed(e, 'Enter')) {
                input.form.submit();
            }
        },

        loadRealtimeRain: function () {
            if (window.load_realtime_rain) {
                load_realtime_rain();
            }
        },

        loadCommandr: function () {
            if (window.load_commandr) {
                load_commandr();
            }
        },

        loadStuffStaff: function () {
            var loc = window.location.href;

            // Navigation loading screen
            if ($cms.$CONFIG_OPTION('enable_animations')) {
                if ((window.parent === window) && !loc.includes('js_cache=1') && (loc.includes('/cms/') || loc.includes('/adminzone/'))) {
                    window.addEventListener('beforeunload', function () {
                        staff_unload_action();
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
                        mouseover: handle_image_mouse_over,
                        mouseout: handle_image_mouse_out,
                        click: handle_image_click
                    });
                }
            }

            /* Thumbnail tooltips */
            if ($cms.$DEV_MODE() || loc.replace($cms.$BASE_URL_NOHTTP(), '').includes('/cms/')) {
                var urlPatterns = $cms.staffTooltipsUrlPatterns,
                    links, pattern, hook, patternRgx;

                links = $cms.dom.$$('td a');
                for (pattern in urlPatterns) {
                    hook = urlPatterns[pattern];
                    patternRgx = new RegExp(pattern);

                    links.forEach(function (link) {
                        if (link.href && !link.onmouseover) {
                            var id = link.href.match(patternRgx);
                            if (id) {
                                apply_comcode_tooltip(hook, id, link);
                            }
                        }
                    });
                }
            }

            /* Screen transition, for staff */
            function staff_unload_action() {
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
                    $cms.dom.fadeTransition(bi, 20, 30, -4);
                }
                var div = document.createElement('div');
                div.className = 'unload_action';
                div.style.width = '100%';
                div.style.top = ($cms.dom.getWindowHeight() / 2 - 160) + 'px';
                div.style.position = 'fixed';
                div.style.zIndex = 10000;
                div.style.textAlign = 'center';
                $cms.dom.html(div, '<div aria-busy="true" class="loading_box box"><h2>{!LOADING;^}</h2><img id="loading_image" alt="" src="{$IMG_INLINE*;,loading}" /></div>');
                window.setTimeout(function () {
                    // Stupid workaround for Google Chrome not loading an image on unload even if in cache
                    if ($cms.dom.$id('loading_image')) {
                        $cms.dom.$id('loading_image').src += '';
                    }
                }, 100);
                document.body.appendChild(div);

                // Allow unloading of the animation
                $cms.dom.on(window, 'pageshow keydown click', $cms.undoStaffUnloadAction)
            }

            /*
             TOOLTIPS FOR THUMBNAILS TO CONTENT, AS DISPLAYED IN CMS ZONE
             */

            function apply_comcode_tooltip(hook, id, link) {
                link.addEventListener('mouseout', function () {
                    $cms.ui.deactivateTooltip(link);
                });
                link.addEventListener('mousemove', function (event) {
                    $cms.ui.repositionTooltip(link, event, false, false, null, true);
                });
                link.addEventListener('mouseover', function (event) {
                    var id_chopped = id[1];
                    if (id[2] !== undefined) {
                        id_chopped += ':' + id[2];
                    }
                    var comcode = '[block="' + hook + '" id="' + decodeURIComponent(id_chopped) + '" no_links="1"]main_content[/block]';
                    if (link.rendered_tooltip === undefined) {
                        link.is_over = true;

                        $cms.doAjaxRequest($cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?css=1&javascript=1&raw_output=1&box_title={!PREVIEW;&}' + $cms.keepStub()), function (ajax_result_frame) {
                            if (ajax_result_frame && ajax_result_frame.responseText) {
                                link.rendered_tooltip = ajax_result_frame.responseText;
                            }
                            if (link.rendered_tooltip !== undefined) {
                                if (link.is_over) {
                                    $cms.ui.activateTooltip(link, event, link.rendered_tooltip, '400px', null, null, false, false, false, true);
                                }
                            }
                        }, 'data=' + encodeURIComponent(comcode));
                    } else {
                        $cms.ui.activateTooltip(link, event, link.rendered_tooltip, '400px', null, null, false, false, false, true);
                    }
                });
            }

            /*
             THEME IMAGE CLICKING
             */
            function handle_image_mouse_over(event) {
                var target = event.target;
                if (target.previousSibling && (target.previousSibling.className !== undefined) && (target.previousSibling.className.indexOf !== undefined) && (target.previousSibling.className.indexOf('magic_image_edit_link') != -1)) {
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
                        handle_image_click(event, target, true);
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

                    if (target.mo_link)
                        window.clearTimeout(target.mo_link);
                    target.mo_link = window.setTimeout(function () {
                        if (ml) ml.style.display = 'block';
                    }, 2000);
                }

                window.old_status_img = window.status;
                window.status = '{!SPECIAL_CLICK_TO_EDIT;^}';
            }

            function handle_image_mouse_out(event) {
                var target = event.target;

                if ($cms.$CONFIG_OPTION('enable_theme_img_buttons')) {
                    if (target.previousSibling && (target.previousSibling.className !== undefined) && (target.previousSibling.className.indexOf !== undefined) && (target.previousSibling.className.indexOf('magic_image_edit_link') != -1)) {
                        if ((target.mo_link !== undefined) && (target.mo_link)) // Clear timed display of new edit button
                        {
                            window.clearTimeout(target.mo_link);
                            target.mo_link = null;
                        }

                        // Time removal of edit button
                        if (target.mo_link)
                            window.clearTimeout(target.mo_link);
                        target.mo_link = window.setTimeout(function () {
                            if ((target.edit_window === undefined) || (!target.edit_window) || (target.edit_window.closed)) {
                                if (target.previousSibling && (target.previousSibling.className !== undefined) && (target.previousSibling.className.indexOf !== undefined) && (target.previousSibling.className.indexOf('magic_image_edit_link') != -1))
                                    target.parentNode.removeChild(target.previousSibling);
                            }
                        }, 3000);
                    }
                }

                if (window.old_status_img === undefined) {
                    window.old_status_img = '';
                }
                window.status = window.old_status_img;
            }

            function handle_image_click(event, ob, force) {
                ob || (ob = this);

                var src = ob.origsrc ? ob.origsrc : ((ob.src === undefined) ? $cms.dom.css(ob, 'background-image').replace(/.*url\(['"]?(.*)['"]?\).*/, '$1') : ob.src);
                if (src && (force || ($cms.magicKeypress(event)))) {
                    // Bubbling needs to be stopped because shift+click will open a new window on some lower event handler (in firefox anyway)
                    event.stopPropagation();

                    if (event.preventDefault !== undefined) event.preventDefault();

                    if (src.includes('{$BASE_URL_NOHTTP;^}/themes/')) {
                        ob.edit_window = window.open('{$BASE_URL;,0}/adminzone/index.php?page=admin_themes&type=edit_image&lang=' + encodeURIComponent($cms.$LANG()) + '&theme=' + encodeURIComponent($cms.$THEME()) + '&url=' + encodeURIComponent(src.replace('{$BASE_URL;,0}/', '')) + $cms.keepStub(), 'edit_theme_image_' + ob.id);
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
                if (msg.includes === undefined) {
                    return null;
                }

                if (window.document.readyState !== 'complete') {
                    // Probably not loaded yet
                    return null;
                }

                if (
                    (msg.includes('AJAX_REQUESTS is not defined')) || // Intermittent during page out-clicks
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
                )
                    return null; // Comes up on due to various Firefox/extension/etc bugs

                if (!window.done_one_error) {
                    window.done_one_error = true;
                    var alert = '{!JAVASCRIPT_ERROR;^}\n\n' + code + ': ' + msg + '\n' + file;
                    if (window.document.body) {// i.e. if loaded
                        $cms.ui.alert(alert, null, '{!ERROR_OCCURRED;^}');
                    }
                }
                return false;
            };

            window.addEventListener('beforeunload', function () {
                window.onerror = null;
            });
        }
    });

    $cms.views.ToggleableTray = ToggleableTray;
    /**
     * @memberof $cms.views
     * @class
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

    $cms.inherits(ToggleableTray, $cms.View, /** @lends $cms.views.ToggleableTray# */{
        /**@method*/
        events: function () {
            return {
                'click .js-btn-tray-toggle': 'toggle',
                'click .js-btn-tray-accordion': 'toggleAccordionItems'
            };
        },

        /**@method*/
        toggle: function () {
            if (this.trayCookie) {
                $cms.setCookie('tray_' + this.trayCookie, $cms.dom.isDisplayed(this.el) ? 'closed' : 'open');
            }

            $cms.toggleableTray(this.el);
        },

        /**@method*/
        accordion: function (el) {
            var nodes = $cms.dom.$$(el.parentNode.parentNode, '.toggleable_tray');

            nodes.forEach(function (node) {
                if ((node.parentNode !== el) && $cms.dom.isDisplayed(node) && node.parentNode.classList.contains('js-tray-accordion-item')) {
                    $cms.toggleableTray(node, true);
                }
            });

            $cms.toggleableTray(el);
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
                $cms.toggleableTray(this.contentEl, true);
            }
        }
    });

    $cms.toggleableTray = toggleableTray;
    // Toggle a ToggleableTray
    function toggleableTray(el, noAnimateHeight) {
        var $IMG_expand = '{$IMG;,1x/trays/expand}',
            $IMG_expand2 = '{$IMG;,1x/trays/expand2}',
            $IMG_contract = '{$IMG;,1x/trays/contract}',
            $IMG_contract2 = '{$IMG;,1x/trays/contract2}';

        if (!el) {
            return;
        }

        //@TODO: Implement slide-up/down animation which is triggered by this boolean
        //noAnimateHeight = $cms.$CONFIG_OPTION('enable_animations') ? !!noAnimateHeight : true;

        if (!el.classList.contains('toggleable_tray')) {// Suspicious, maybe we need to probe deeper
            el = $cms.dom.$(el, '.toggleable_tray') || el;
        }

        if (!el) {
            return;
        }

        var pic = $cms.dom.$(el.parentNode, '.toggleable_tray_button img') || $cms.dom.$('img#e_' + el.id);

        el.setAttribute('aria-expanded', 'true');

        if ($cms.dom.notDisplayed(el)) {
            $cms.dom.fadeIn(el);

            if (pic) {
                set_tray_theme_image('expand', 'contract', $IMG_expand, $IMG_contract, $IMG_contract2);
            }
        } else {
            $cms.dom.hide(el);

            if (pic) {
                set_tray_theme_image('contract', 'expand', $IMG_contract, $IMG_expand, $IMG_expand2);
                pic.setAttribute('alt', pic.getAttribute('alt').replace('{!CONTRACT;^}', '{!EXPAND;^}'));
                pic.title = '{!EXPAND;^}';
            }
        }

        $cms.dom.triggerResize(true);

        // Execution ends here

        var isThemeWizard = !!(pic && pic.src && pic.src.includes('themewizard.php'));
        function set_tray_theme_image(before_theme_img, after_theme_img, before1_url, after1_url, after2_url) {
            var is_1 = $cms.dom.matchesThemeImage(pic.src, before1_url);

            if (is_1) {
                if (isThemeWizard) {
                    pic.src = pic.src.replace(before_theme_img, after_theme_img);
                } else {
                    pic.src = $cms.img(after1_url);
                }
            } else {
                if (isThemeWizard) {
                    pic.src = pic.src.replace(before_theme_img + '2', after_theme_img + '2');
                } else {
                    pic.src = $cms.img(after2_url);
                }
            }
        }
    }

    $cms.functions.abstractFileManagerGetAfmForm = function abstractFileManagerGetAfmForm() {
        var usesFtp = document.getElementById('uses_ftp');
        if (!usesFtp) {
            return;
        }

        ftp_ticker();
        usesFtp.onclick = ftp_ticker;

        function ftp_ticker() {
            var form = usesFtp.form;
            form.elements.ftp_domain.disabled = !usesFtp.checked;
            form.elements.ftp_directory.disabled = !usesFtp.checked;
            form.elements.ftp_username.disabled = !usesFtp.checked;
            form.elements.ftp_password.disabled = !usesFtp.checked;
            form.elements.remember_password.disabled = !usesFtp.checked;
        }
    };

    $cms.templates.forumsEmbed = function () {
        var frame = this;
        window.setInterval(function () {
            $cms.dom.resizeFrame(frame.name);
        }, 500);
    };

    $cms.templates.massSelectFormButtons = function (params) {
        var delBtn = this,
            form = delBtn.form;

        $cms.dom.on(delBtn, 'click', function () {
            confirm_delete(form, true, function () {
                var idEl = $cms.dom.$id('id'),
                    ids = (idEl.value === '') ? [] : idEl.value.split(',');

                for (var i = 0; i < ids.length; i++) {
                    prepareMassSelectMarker('', params.type, ids[i], true);
                }

                form.method = 'post';
                form.action = params.actionUrl;
                form.target = '_top';
                form.submit();
            });
        });

        $cms.dom.$id('id').fakeonchange = initialiseButtonVisibility;
        initialiseButtonVisibility();

        function initialiseButtonVisibility() {
            var id = $cms.dom.$('#id'),
                ids = (id.value === '') ? [] : id.value.split(/,/);

            $cms.dom.$('#submit_button').disabled = (ids.length !== 1);
            $cms.dom.$('#mass_select_button').disabled = (ids.length === 0);
        }
    };

    $cms.templates.massSelectDeleteForm = function () {
        var form = this;
        $cms.dom.on(form, 'submit', function (e) {
            e.preventDefault();
            confirm_delete(form, true);
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
        var win_parent = window.parent || window.opener,
            id = 'upload_syndicate__' + params.hook + '__' + params.name,
            el = win_parent.document.getElementById(id);

        el.checked = true;

        var win = window;
        window.setTimeout(function () {
            if (win.faux_close !== undefined) {
                win.faux_close();
            } else {
                win.close();
            }
        }, 4000);
    };

    $cms.templates.loginScreen = function loginScreen(params, container) {
        if ((document.activeElement != null) || (document.activeElement !== $cms.dom.$('#password'))) {
            try {
                $cms.dom.$('#login_username').focus();
            } catch (ignore) {}
        }

        $cms.dom.on(container, 'click', '.js-click-checkbox-remember-me-confirm', function (e, checkbox) {
            if (checkbox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}', function (answer) {
                    if (!answer) {
                        checkbox.checked = false;
                    }
                });
            }
        });

        $cms.dom.on(container, 'submit', '.js-submit-check-login-username-field', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements.login_username)) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });
    };

    $cms.templates.blockTopLogin = function (blockTopLogin, container) {
        $cms.dom.on(container, 'submit', '.js-form-top-login', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements.login_username)) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-confirm-remember-me', function (e, checkbox) {
            if (checkbox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}', function (answer) {
                    if (!answer) {
                        checkbox.checked = false;
                    }
                });
            }
        });
    };

    $cms.templates.ipBanScreen = function (params, container) {
        var textarea = commandrLs.querySelector('#bans');
        $cms.manageScrollHeight(textarea);

        if (!$cms.$MOBILE()) {
            $cms.dom.on(container, 'keyup', '#bans', function (e, textarea) {
                $cms.manageScrollHeight(textarea);
            });
        }
    };

    $cms.templates.jsBlock = function jsBlock(params) {
        $cms.callBlock(params.blockCallUrl, '', $cms.dom.$id(params.jsBlockId), false, null, false, null, false, false);
    };

    $cms.templates.massSelectMarker = function (params, container) {
        $cms.dom.on(container, 'click', '.js-chb-prepare-mass-select', function (e, checkbox) {
            prepareMassSelectMarker(params.supportMassSelect, params.type, params.id, checkbox.checked);
        });
    };


    $cms.templates.blockTopPersonalStats = function (params, container) {
        $cms.dom.on(container, 'click', '.js-click-toggle-top-personal-stats', function (e) {
            if (toggle_top_personal_stats(e) === false) {
                e.preventDefault();
            }
        });
    };

    $cms.templates.blockSidePersonalStatsNo = function blockSidePersonalStatsNo(params, container) {
        $cms.dom.on(container, 'submit', '.js-submit-check-login-username-field', function (e, form) {
            if ($cms.form.checkFieldForBlankness(form.elements.login_username)) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'click', '.js-click-checkbox-remember-me-confirm', function (e, checkbox) {
            if (checkbox.checked) {
                $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}', function (answer) {
                    if (!answer) {
                        checkbox.checked = false;
                    }
                });
            }
        });
    };

    $cms.functions.decisionTreeRender = function decisionTreeRender(parameter, value, notice, noticeTitle) {
        var e=document.getElementById('main_form').elements[parameter];
        if (e.length === undefined) {
            e=[e];
        }
        for (var i=0;i<e.length;i++) {
            e[i].addEventListener('click',function(_e) { return function() {
                var selected=false;
                if (_e.type!='undefined' && _e.type=='checkbox') {
                    selected=(_e.checked && _e.value==value) || (!_e.checked && ''==value);
                } else {
                    selected=(_e.value== value);
                }
                if (selected) {
                    $cms.ui.alert(notice, null, noticeTitle, true);
                }
            }}(e[i]));
        }
    };

    function gdImageTransform(el) {
        /* GD text maybe can do with transforms */
        var span = document.createElement('span');
        if (typeof span.style.writingMode === 'string') {// IE (which has buggy rotation space reservation, but a decent writing-mode instead)
            el.style.display = 'none';
            span.style.writingMode = 'tb-lr';
            if (span.style.writingMode !== 'tb-lr') {
                span.style.writingMode = 'vertical-lr';
            }
            span.style.webkitWritingMode = 'vertical-lr';
            span.style.whiteSpace = 'nowrap';
            span.textContent = el.alt;
            el.parentNode.insertBefore(span, el);
        } else if (typeof span.style.transform === 'string') {
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
            el.parentNode.style.overflow = 'hidden'; // Needed due to https://bugzilla.mozilla.org/show_bug.cgi?id=456497
            el.parentNode.style.verticalAlign = 'top';
            span.textContent = el.alt;

            el.parentNode.insertBefore(span, el);
            var span_proxy = span.cloneNode(true); // So we can measure width even with hidden tabs
            span_proxy.style.position = 'absolute';
            span_proxy.style.visibility = 'hidden';
            document.body.appendChild(span_proxy);

            window.setTimeout(function () {
                var width = span_proxy.offsetWidth + 15;
                span_proxy.parentNode.removeChild(span_proxy);
                if (el.parentNode.nodeName === 'TH' || el.parentNode.nodeName === 'TD') {
                    el.parentNode.style.height = width + 'px';
                } else {
                    el.parentNode.style.minHeight = width + 'px';
                }
            }, 0);
        }
    }

    function openLinkAsOverlay(options) {
        options = $cms.defaults({
            width: '800',
            height: 'auto',
            target: '_top',
            el: null
        }, options);

        var el = options.el,
            url = (el.href === undefined) ? el.action : el.href,
            url_stripped = url.replace(/#.*/, ''),
            new_url = url_stripped + (!url_stripped.includes('?') ? '?' : '&') + 'wide_high=1' + url.replace(/^[^\#]+/, '');

        $cms.ui.open(new_url, null, 'width=' + options.width + ';height=' + options.height, options.target);
    }

    function convert_tooltip(el) {
        var title = el.title;

        if (!title || $cms.isTouchEnabled() || el.classList.contains('leave_native_tooltip')) {
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
            }
            else if (title === el.textContent) {
                return;
            }
        }

        // Stop the tooltip code adding to these events, by defining our own (it will not overwrite existing events).
        if (!el.onmouseout) {
            el.onmouseout = function () {
            };
        }
        if (!el.onmousemove) {
            el.onmouseover = function () {
            };
        }

        // And now define nice listeners for it all...
        var global = $cms.getMainCmsWindow(true);

        el.cms_tooltip_title = $cms.filter.html(title);

        $cms.dom.on(el, 'mouseover.convertTooltip', function (event) {
            global.$cms.ui.activateTooltip(el, event, el.cms_tooltip_title, 'auto', '', null, false, false, false, false, global);
        });

        $cms.dom.on(el, 'mousemove.convertTooltip', function (event) {
            global.$cms.ui.repositionTooltip(el, event, false, false, null, false, global);
        });

        $cms.dom.on(el, 'mouseout.convertTooltip', function () {
            global.$cms.ui.deactivateTooltip(el);
        });
    }

    function confirm_delete(form, multi, callback) {
        multi = !!multi;

        $cms.ui.confirm(
            multi ? '{!_ARE_YOU_SURE_DELETE;^}' : '{!ARE_YOU_SURE_DELETE;^}',
            function (result) {
                if (result) {
                    if (callback !== undefined) {
                        callback();
                    } else {
                        form.submit();
                    }
                }
            }
        );
    }


    function prepareMassSelectMarker(set, type, id, checked) {
        var mass_delete_form = $cms.dom.$id('mass_select_form__' + set);
        if (!mass_delete_form) {
            mass_delete_form = $cms.dom.$id('mass_select_button').form;
        }
        var key = type + '_' + id;
        var hidden;
        if (mass_delete_form.elements[key] === undefined) {
            hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = key;
            mass_delete_form.appendChild(hidden);
        } else {
            hidden = mass_delete_form.elements[key];
        }
        hidden.value = checked ? '1' : '0';
        mass_delete_form.style.display = 'block';
    }
}(window.$cms));

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
    //window.numVal = numVal;
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
        $VERBOSE: constant(false),
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
        $BASE_URL_PRL: constant(toSchemeRelative(symbols.BASE_URL)), // Scheme relative
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
         * @param {configOptions} optionName
         * @returns {boolean|string|number}
         */
        $CONFIG_OPTION: function $CONFIG_OPTION(optionName) {
            if (window.IN_MINIKERNEL_VERSION) {
                // Installer, likely executing global.js
                return '';
            }

            /**
             * @enum configOptions
             * @readonly
             */
            var configOptions =  {
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

                /**@member {string}*/
                google_analytics: strVal(symbols.CONFIG_OPTION.google_analytics),
                /**@member {string}*/
                cookie_notice: strVal(symbols.CONFIG_OPTION.cookie_notice), 
                /**@member {string}*/
                chat_message_direction: strVal(symbols.CONFIG_OPTION.chat_message_direction)
            };

            if (hasOwn(configOptions, optionName)) {
                return configOptions[optionName];
            }

            $cms.error('$cms.$CONFIG_OPTION(): Option "' + optionName + '" is either unsupported in JS or doesn\'t exist. Please try using the actual Tempcode symbol.');
        },
        /**
         * WARNING: This is a very limited subset of the $VALUE_OPTION tempcode symbol
         * @method
         * @returns {string|boolean|number}
         */
        $VALUE_OPTION: function $VALUE_OPTION(optionName) {
            if (window.IN_MINIKERNEL_VERSION) {
                // Installer, likely executing global.js
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
            if (window.IN_MINIKERNEL_VERSION) {
                // Installer, likely executing global.js
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
        verbose: verbose,
        /**@method*/
        error: error,
        /**@method*/
        exception: exception,
        /**
         * @method
         * @param resourceEls
         */
        waitForResources: function waitForResources(resourceEls) {
            if (resourceEls == null) {
                return;
            }

            if (isEl(resourceEls)) {
                resourceEls = [resourceEls];
            }

            if (!Array.isArray(resourceEls)) {
                $cms.error('$cms.waitForResources(): Argument 1 must be of type {array|HTMLElement}, "' + typeName(resourceEls) + '" provided.');
            }

            if (resourceEls.length < 1) {
                return Promise.resolve();
            }

            $cms.verbose('$cms.waitForResources(): Waiting for resources', resourceEls);

            var scriptsToLoad = [];
            resourceEls.forEach(function (el) {
                if (!isEl(el)) {
                    $cms.error('$cms.waitForResources(): Invalid item of type "' + typeName(resourceEls) + '" in the `resourceEls` parameter.');
                    return;
                }

                if (el.localName === 'script') {
                    if (el.src && !$cms.dom.hasScriptLoaded(el) && jsTypeRE.test(el.type) && !scriptsToLoad.includes(el)) {
                        scriptsToLoad.push(el);
                    }
                }
            });

            if (scriptsToLoad.length < 1) {
                return Promise.resolve();
            }

            return new Promise(function (resolve) {
                $cms.scriptsLoadedListeners.push(function scriptResourceListener(event) {
                    var loadedEl = event.target;

                    if (!scriptsToLoad.includes(loadedEl)) {
                        return;
                    }

                    if (event.type === 'load') {
                        $cms.verbose('$cms.waitForResources(): Resource loaded successfully', loadedEl);
                    } else {
                        $cms.error('$cms.waitForResources(): Resource failed to load', loadedEl);
                    }

                    scriptsToLoad = scriptsToLoad.filter(function (el) {
                        return el !== loadedEl;
                    });

                    if (scriptsToLoad.length < 1) {
                        resolve(event);
                    }
                });
            });
        },
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
        /**@method*/
        doAjaxRequest: doAjaxRequest,
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
        return function () {
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
     * @returns {{}}
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
    function numVal(val) {
        return ((val != null) && (val = Number(val)) && (val !== Infinity) && (val !== -Infinity)) ? val : 0;
    }

    function numberFormat(num) {
        num = +num || 0;
        return num.toLocaleString();
    }

    /**
     * @param val
     * @param clone
     * @returns { Array } array or array-like object
     */
    function arrVal(val, clone) {
        var isArr = false;

        clone = !!clone;

        if (val == null) {
            return [];
        }

        if ((typeof val === 'object') && ((isArr = Array.isArray(val)) || isArrayLike(val))) {
            return (!isArr || clone) ? toArray(val) : val;
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
        rgxHttp = /^https?:(?=\/\/)/i,
        rgxRel = /^\/\//i,
        rgxHttpRel = /^(?:https?:)?(?=\/\/)/i;

    /**
     * @param relativeUrl
     * @returns {string}
     */
    function baseUrl(relativeUrl) {
        relativeUrl = strVal(relativeUrl);

        if (relativeUrl === '') {
            return $cms.$BASE_URL_S();
        }

        if (isAbsolute(relativeUrl)) {
            // Already an absolute url, just ensure matching protocol as the current page.
            return relativeUrl.replace(rgxHttp, window.location.protocol);
        } else if (isSchemeRelative(relativeUrl)) {
            // Scheme-relative URL, add current protocol
            return window.location.protocol + relativeUrl;
        }

        return ((relativeUrl.startsWith('/')) ? $cms.$BASE_URL() : $cms.$BASE_URL_S()) + relativeUrl;
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
        return rgxRel.test(url);
    }

    function isAbsoluteOrSchemeRelative(url) {
        url = strVal(url);
        return rgxHttpRel.test(url);
    }

    /**
     * @param absoluteUrl
     * @returns {string}
     */
    function toSchemeRelative(absoluteUrl) {
        return strVal(absoluteUrl).replace(rgxProtocol, '');
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
     * @param source
     * @returns {*}
     */
    function parseJson(source) {
        return window.JSON5.parse(strVal(source));
    }

    function log() {
        if ($cms.$DEV_MODE()) {
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

    function verbose() {
        if ($cms.$DEV_MODE() && $cms.$VERBOSE()) {
            return console.log.apply(undefined, arguments);
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

    var validIdRE = /^[a-zA-Z][\w:.-]*$/;

    /**
     * @private
     * @param sheetName
     */
    function _requireCss(sheetName) {
        var linkEl;

        linkEl = $cms.dom.$('link[id^="css-' + sheetName + '"]');

        if (linkEl && !(new RegExp('^css-' + sheetName + '(?:_non_minified)?(?:_ssl)?(?:_mobile)?$', 'i')).test(linkEl.id)) {
            linkEl = null;
        }

        if (!linkEl) {
            linkEl = document.createElement('link');
            linkEl.id = 'css-' + sheetName;
            linkEl.rel = 'stylesheet';
            linkEl.href = '{$FIND_SCRIPT_NOHTTP;,sheetName}?sheetName=' + sheetName + $cms.keepStub();
            linkEl.nonce = $cms.$CSP_NONCE;
            document.head.appendChild(linkEl);
        }

        return Promise.resolve();
    }

    /**
     * @param sheetNames
     * @returns { Promise }
     */
    function requireCss(sheetNames) {
        sheetNames = arrVal(sheetNames);

        return Promise.all(sheetNames.map(_requireCss));
    }

    var requireJavascriptPromises = Object.create(null);

    /**
     * @private
     * @param script
     * @returns { Promise }
     */
    function _requireJavascript(script) {
        var scriptEl;

        script = strVal(script);

        if (requireJavascriptPromises[script] != null) {
            return requireJavascriptPromises[script];
        }

        if (isAbsoluteOrSchemeRelative(script) && $cms.dom.hasScriptLoaded(script)) {
            return (requireJavascriptPromises[script] = Promise.resolve());
        } else if (validIdRE.test(script)) {
            scriptEl = $cms.dom.$('script[id^="javascript-' + script + '"]');
            if (scriptEl && !(new RegExp('^javascript-' + script + '(?:_non_minified)?(?:_ssl)?(?:_mobile)?$', 'i')).test(scriptEl.id)) {
                scriptEl = null;
            }
        }

        if (!scriptEl) {
            $cms.log('_requireJavascript', script);

            scriptEl = document.createElement('script');
            scriptEl.defer = true;
            if (isAbsoluteOrSchemeRelative(script)) {
                scriptEl.src = script;
            } else {
                scriptEl.id = 'javascript-' + script;
                scriptEl.src = '{$FIND_SCRIPT_NOHTTP;,javascript}?script=' + script + $cms.keepStub();
            }
            scriptEl.nonce = $cms.$CSP_NONCE;

            document.body.appendChild(scriptEl);
            requireJavascriptPromises[script] = $cms.waitForResources(scriptEl);
        }

        return requireJavascriptPromises[script];
    }

    /**
     * @param scripts
     * @returns { Promise }
     */
    function requireJavascript(scripts) {
        var calls = [];

        scripts = arrVal(scripts);

        scripts.forEach(function (script) {
            calls.push(_requireJavascript.bind(undefined, script));
        });

        return sequentialPromises(calls);
    }

    function sequentialPromises(funcs) {
        funcs = arrVal(funcs, true);

        if (funcs.length < 1) {
            return Promise.resolve();
        }

        var func = funcs.shift(),
            promise = func();
        if (!isPromise(promise)) {
            promise = Promise.resolve(promise);
        }
        return promise.then(function(val){
            return (funcs.length > 0) ? sequentialPromises(funcs) : val;
        }, function () {
            return (funcs.length > 0) ? sequentialPromises(funcs) : val;
        });
    }

    /**
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
     * Emulates super.method() call
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
                details.expires ? '; expires=' + details.expires.toUTCString() : '', // use expires attribute, max-age is not supported by all browsers
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
     * @param el
     * @param property
     * @returns {*}
     */
    function computedStyle(el, property) {
        var cs = el.ownerDocument.defaultView.getComputedStyle(el);
        return (property !== undefined) ? cs.getPropertyValue(property) : cs;
    }

    var rgxIdSelector = /^\#[\w\-]+$/,
        rgxSimpleSelector = /^[\#\.]?[\w\-]+$/,
        // Special attributes that should be set via method calls
        methodAttributes = { val: 1, css: 1, html: 1, text: 1, data: 1, width: 1, height: 1, offset: 1 },
        rgxNotWhite = /\S+/g;

    /** @namespace $cms */
    $cms.dom = extendDeep($cms.dom, /**@lends $cms.dom*/{
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
        $last: function last(context, selector) {
            return $cms.dom.$$(context, selector).pop();
        },
        /**
         * This one (3 dollars) also includes the context element (at offset 0) if it matches the selector
         * @memberof $cms.dom
         * @param context
         * @param selector
         * @returns {*}
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
         * @param attributes
         * @param properties
         * @returns { Element }
         */
        create: function create(tag, attributes, properties) {
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
        },
        /**
         * @memberof $cms.dom
         * @param el
         * @param value
         * @returns {*}
         */
        val: function val(el, value) {
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
        // Note: We have internalised caching here. You must not change data-* attributes manually and expect this API to pick up on it.

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
     * @param notRelative
     * @returns {number}
     */
    $cms.dom.findPosX = function findPosX(el, notRelative) {/* if not_relative is true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree */
        if (!el) {
            return 0;
        }

        el = elArg(el);
        notRelative = !!notRelative;

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
     * @param notRelative
     * @returns {number}
     */
    $cms.dom.findPosY = function findPosY(el, notRelative) {/* if not_relative is true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree */
        if (!el) {
            return 0;
        }

        el = elArg(el);
        notRelative = !!notRelative;

        var top = el.getBoundingClientRect().top + window.pageYOffset;

        if (!notRelative) {
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

    $cms.dom.hasStyleSheetLoaded = function (elOrHref) {
        if (isNode(elOrHref)) {
            return $cms.styleSheetsLoaded.includes(elOrHref);
        }

        // It's a href value
        var href = strVal(elOrHref),
            linkEl;

        if (href === '') {
            return false;
        }

        if (isSchemeRelative(href)) {
            href = window.location.protocol + href;
        } else if (isRelative(href)) {
            href = $cms.baseUrl(href);
        }

        for (var i = 0; i < $cms.styleSheetsLoaded.length; i++) {
            linkEl = $cms.styleSheetsLoaded[i];
            if (linkEl.href === href) {
                return true;
            }
        }
    };

    $cms.dom.hasScriptLoaded = function hasScriptLoaded(elOrSrc) {
        if (isNode(elOrSrc)) {
            return $cms.scriptsLoaded.includes(elOrSrc);
        }

        // It's an src value
        // NB: Inaccurate when a script with the same src is supposed to be loaded/executed multiple times.
        var src = strVal(elOrSrc),
            scriptEl;

        if (src === '') {
            return false;
        }

        if (isSchemeRelative(src)) {
            src = window.location.protocol + src;
        } else if (isRelative(src)) {
            src = $cms.baseUrl(src);
        }

        for (var i = 0; i < $cms.scriptsLoaded.length; i++) {
            scriptEl = $cms.scriptsLoaded[i];
            if (scriptEl.src === src) {
                return true;
            }
        }
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
     * @param el
     * @param duration
     * @param callback
     */
    $cms.dom.fadeToggle = function fadeToggle(el, duration, callback) {
        // TODO Salman. To be implemented
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param callback
     */
    $cms.dom.slideDown = function slideDown(el, duration, callback) {
        // TODO Salman. To be implemented
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param callback
     */
    $cms.dom.slideUp = function slideUp(el, duration, callback) {
        // TODO Salman. To be implemented
    };

    /**
     * @memberof $cms.dom
     * @param el
     * @param duration
     * @param callback
     */
    $cms.dom.slideToggle = function slideToggle(el, duration, callback) {
        // TODO Salman. To be implemented
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

        leaveGapTop = +leaveGapTop || 0;
        leaveHeight = !!leaveHeight;

        if (!leaveHeight) {
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
            window.top.$cms.dom.smoothScroll($cms.dom.findPosY(pf) + extra - leaveGapTop);
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
        } catch (e) {
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

        if (!de.querySelector('style')) { // The conditional is needed for Firefox - for some odd reason it is unable to parse any head tags twice
            $cms.dom.html(doc.head, head);
        }

        $cms.dom.html(doc.body, '<div aria-busy="true" class="spaced"><div class="ajax_loading"><img id="loading_image" class="vertical_alignment" src="' + $cms.img('{$IMG_INLINE*;,loading}') + '" alt="{!LOADING;^}" /> <span class="vertical_alignment">{!LOADING;^}<\/span><\/div><\/div>');

        // Stupid workaround for Google Chrome not loading an image on unload even if in cache
        setTimeout(function () {
            if (!doc.getElementById('loading_image')) {
                return;
            }

            var iNew = doc.createElement('img');
            iNew.src = doc.getElementById('loading_image').src;

            var iDefault = doc.getElementById('loading_image');
            if (iDefault) {
                iNew.className = iDefault.className;
                iNew.alt = iDefault.alt;
                iNew.id = iDefault.id;
                iDefault.parentNode.replaceChild(iNew, iDefault);
            }
        }, 0);
    };

    /**
     * Smoothly scroll to another position on the page
     * @memberof $cms.dom
     * @param destY
     * @param expectedScrollY
     * @param dir
     * @param eventAfter
     */
    $cms.dom.smoothScroll = function smoothScroll(destY, expectedScrollY, dir, eventAfter) {
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
            } catch (e) {
            }
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
            }
            catch (e) {};
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

        return function insertionFunction(target/*, ...args*/) {  // `args` can be nodes, arrays of nodes and HTML strings
            target = elArg(target);

            var args = toArray(arguments, 1),
                nodes = [],
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
            } else {
                nodes.forEach(function (node) {
                    if (isEl(node)) {
                        $cms.attachBehaviors(node);
                    }
                });

                return Promise.resolve();
            }
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

        clone.defer = !!scriptEl.defer;
        clone.async = !!scriptEl.async;
        clone.src = strVal(scriptEl.src);

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
        if (isArrayLike(node)) {
            forEach(node, function (item) {
                $cms.dom.remove(item);
            });
        } else {
            node = nodeArg(node);

            if (isEl(node)) {
                $cms.detachBehaviors(node);
            }

            node.parentNode.removeChild(node);
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
     * Dimension functions
     * @memberof $cms.dom
     * @param e
     */
    $cms.dom.registerMouseListener = function registerMouseListener(e) {
        $cms.dom.registerMouseListener = noop; // ensure this function is only executed once

        if (e) {
            window.mouse_x = getMouseX(e);
            window.mouse_y = getMouseY(e);
        }

        document.documentElement.addEventListener('mousemove', function (event) {
            window.mouse_x = getMouseX(event);
            window.mouse_y = getMouseY(event);
        });

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

        if ((frameElement) && (frameWindow) && (frameWindow.document) && (frameWindow.document.body)) {
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

            if (h + 'px' != frameElement.style.height) {
                if ((frameElement.scrolling !== 'auto' && frameElement.scrolling !== 'yes') || (frameElement.style.height == '0px')) {
                    frameElement.style.height = ((h >= minHeight) ? h : minHeight) + 'px';
                    if (frameWindow.parent) {
                        setTimeout(function () {
                            if (frameWindow.parent) frameWindow.parent.$cms.dom.triggerResize();
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

                        return !!(event && event.target && event.stopPropagation && (event.stopPropagation() === undefined));
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
            timeouts[$cms.uid(el)] = setTimeout(function () {
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
                clearTimeout(timeouts[uid]);
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
                        $cms.verbose('$cms.attachBehaviors(): attached behavior "' + name + '" to context', context);
                    } catch (e) {
                        $cms.error('$cms.attachBehaviors(): Error while attaching behavior "' + name + '"  to', context, '\n', e);
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
                    $cms.verbose('$cms.detachBehaviors(): detached behavior "' + name + '" from context', context);
                } catch (e) {
                    $cms.error('$cms.detachBehaviors(): Error while detaching behavior \'' + name + '\' from', context, '\n', e);
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
        scrollToTopOfWrapper = !!scrollToTopOfWrapper;
        postParams = (postParams !== undefined) ? postParams : null;
        inner = !!inner;
        showLoadingAnimation = (showLoadingAnimation !== undefined) ? !!showLoadingAnimation : true;
        if ((_blockDataCache[url] === undefined) && (newBlockParams != '')) {
            // Cache start position. For this to be useful we must be smart enough to pass blank new_block_params if returning to fresh state
            _blockDataCache[url] = $cms.dom.html(targetDiv);
        }

        var ajaxUrl = url;
        if (newBlockParams != '') {
            ajaxUrl += '&block_map_sup=' + encodeURIComponent(newBlockParams);
        }

        ajaxUrl += '&utheme=' + $cms.$THEME();
        if ((_blockDataCache[ajaxUrl] !== undefined) && postParams == null) {
            // Show results from cache
            showBlockHtml(_blockDataCache[ajaxUrl], targetDiv, append, inner);
            return Promise.resolve();
        }

        // Show loading animation
        var loadingWrapper = targetDiv;
        if ((loadingWrapper.id.indexOf('carousel_') === -1) && ($cms.dom.html(loadingWrapper).indexOf('ajax_loading_block') === -1) && (showLoadingAnimation)) {
            var rawAjaxGrowSpot = targetDiv.querySelectorAll('.raw_ajax_grow_spot');

            if (rawAjaxGrowSpot[0] !== undefined && append) {
                // If we actually are embedding new results a bit deeper
                loadingWrapper = rawAjaxGrowSpot[0];
            }

            var loadingWrapperInner = document.createElement('div');
            if (!$cms.dom.isCss(loadingWrapper, 'position', ['relative', 'absolute'])) {
                if (append) {
                    loadingWrapperInner.style.position = 'relative';
                } else {
                    loadingWrapper.style.position = 'relative';
                    loadingWrapper.style.overflow = 'hidden'; // Stops margin collapsing weirdness
                }
            }

            var loadingImage = $cms.dom.create('img', {
                'class': 'ajax_loading_block',
                'src': $cms.img('{$IMG;,loading}'),
                'css': {
                    position: 'absolute',
                    zIndex: 1000,
                    left: (targetDiv.offsetWidth / 2 - 10) + 'px'
                }
            });
            if (!append) {
                loadingImage.style.top = (targetDiv.offsetHeight / 2 - 20) + 'px';
            } else {
                loadingImage.style.top = 0;
                loadingWrapperInner.style.height = '30px';
            }
            loadingWrapperInner.appendChild(loadingImage);
            loadingWrapper.appendChild(loadingWrapperInner);
            window.document.body.style.cursor = 'wait';
        }

        return new Promise(function (resolve) {
            // Make AJAX call
            $cms.doAjaxRequest(
                ajaxUrl + $cms.keepStub(),
                function (rawAjaxResult) { // Show results when available
                    _callBlockRender(rawAjaxResult, ajaxUrl, targetDiv, append, function () {
                        resolve();
                    }, scrollToTopOfWrapper, inner);
                },
                postParams
            );
        });

        function _callBlockRender(rawAjaxResult, ajaxUrl, targetDiv, append, callback, scrollToTopOfWrapper, inner) {
            var newHtml = rawAjaxResult.responseText;
            _blockDataCache[ajaxUrl] = newHtml;

            // Remove loading animation if there is one
            var ajaxLoading = targetDiv.querySelector('.ajax_loading_block');
            if (ajaxLoading) {
                ajaxLoading.parentNode.parentNode.removeChild(ajaxLoading.parentNode);
            }
            window.document.body.style.cursor = '';

            // Put in HTML
            showBlockHtml(newHtml, targetDiv, append, inner);

            // Scroll up if required
            if (scrollToTopOfWrapper) {
                try {
                    scrollTo(0, $cms.dom.findPosY(targetDiv));
                } catch (e) {}
            }

            // Defined callback
            if (callback) {
                callback();
            }
        }

        function showBlockHtml(newHtml, targetDiv, append, inner) {
            var rawAjaxGrowSpot = targetDiv.querySelectorAll('.raw_ajax_grow_spot');
            if (rawAjaxGrowSpot[0] !== undefined && append) targetDiv = rawAjaxGrowSpot[0]; // If we actually are embedding new results a bit deeper
            if (append) {
                $cms.dom.append(targetDiv, newHtml);
            } else {
                if (inner) {
                    $cms.dom.html(targetDiv, newHtml);
                } else {
                    $cms.dom.outerHtml(targetDiv, newHtml);
                }
            }
        }
    }

    /**
     * Dynamic inclusion
     * @memberof $cms
     * @param snippetHook
     * @param [post]
     * @param {boolean} [async]
     * @returns { Promise|string }
     */
    function loadSnippet(snippetHook, post, async) {
        snippetHook = strVal(snippetHook);

        if (!window.location) { // In middle of page navigation away
            return null;
        }

        var title = $cms.dom.html(document.querySelector('title')).replace(/ \u2013 .*/, ''),
            metas = document.getElementsByTagName('link'), i, url;

        for (i = 0; i < metas.length; i++) {
            if (metas[i].getAttribute('rel') === 'canonical') {
                url = metas[i].getAttribute('href');
            }
        }
        if (!url) {
            url = window.location.href;
        }
        var url2 = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=' + snippetHook + '&url=' + encodeURIComponent($cms.protectURLParameter(url)) + '&title=' + encodeURIComponent(title) + $cms.keepStub();

        if (async) {
            return new Promise(function (resolve) {
                $cms.doAjaxRequest($cms.maintainThemeInLink(url2), function (ajaxResult) {
                    resolve(ajaxResult);
                }, post);
            });
        }

        /*TODO: Synchronous XHR*/
        var html = $cms.doAjaxRequest($cms.maintainThemeInLink(url2), null, post);
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
    function keepStub(starting) { // `starting` set to true means "Put a '?' for the first parameter"
        starting = !!starting;

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
                $cms.info('Beacon', 'send', 'event', category, action);

                window.ga(
                    'send',
                    'event',
                    category,
                    action,
                    {
                        transport: 'beacon',
                        hitCallback: callback
                    }
                );
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

        if (callback) {
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
     * @param anyLargeOk
     * @returns {*}
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

        var isSafari = browser.includes('applewebkit'),
            isChrome = browser.includes('chrome/'),
            isGecko = browser.includes('gecko') && !isSafari,
            _isIe = browser.includes('msie') || browser.includes('trident') || browser.includes('edge/');

        switch (code) {
            case 'simplified_attachments_ui':
                return !isIe8 && !isIe9 && $cms.$CONFIG_OPTION('simplified_attachments_ui') && $cms.$CONFIG_OPTION('complex_uploader');
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
            //$cms.verbose('$cms.View#delegate(): delegating event "' + eventName + '" for selector "' + selector + '" with listener', listener, 'and view', this);
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
    * Convert the format of a URL so it can be embedded as a parameter that ModSecurity will not trigger security errors on
    * @memberof $cms.filter
    * @param {string} parameter
    * @returns {string}
    */
    $cms.protectURLParameter = function protectURLParameter(parameter) {
        var baseURL = $cms.$BASE_URL;

        if (parameter.startsWith('https://')) {
            baseURL = baseURL.replace(/^http:\/\//, 'https://');
            if (parameter.startsWith(baseURL + '/')) {
                return 'https-cms:' + parameter.substr(baseURL.length + 1);
            }
        }
        else if (parameter.startsWith('http://')) {
            baseURL = baseURL.replace(/^https:\/\//, 'http://');
            if (parameter.startsWith(baseURL + '/')) {
                return 'http-cms:' + parameter.substr(baseURL.length + 1);
            }
        }

        return parameter;
    };

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
     * @param callback
     */
    $cms.ui.confirmSession = function confirmSession(callback) {
        var url = '{$FIND_SCRIPT_NOHTTP;,confirm_session}' + $cms.keepStub(true);

        $cms.doAjaxRequest(url, function (ret) {
            if (!ret) {
                return;
            }

            if (ret.responseText === '') { // Blank means success, no error - so we can call callback
                callback(true);
                return;
            }

            // But non blank tells us the username, and there is an implication that no session is confirmed for this login
            if (ret.responseText === '{!GUEST;^}') { // Hmm, actually whole login was lost, so we need to ask for username too
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
                            if (ret && ret.responseText === '') { // Blank means success, no error - so we can call callback
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

    // TODO: Salman haveLinks does not seem to be working. In admin_config the config option descriptions should be click-to-see, not hover
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
        width || (width = 'auto');
        pic || (pic = '');
        height || (height = 'auto');
        bottom = !!bottom;
        noDelay = !!noDelay;
        lightsOff = !!lightsOff;
        forceWidth = !!forceWidth;
        win || (win = window);
        haveLinks = !!haveLinks;

        if ((el.deactivated_at) && (Date.now() - el.deactivated_at < 200)) {
            return;
        }

        if (!window.page_loaded || !tooltip) {
            return;
        }

        if (window.is_doing_a_drag) {
            // Don't want tooltips appearing when doing a drag and drop operation
            return;
        }

        if (!el) {
            return;
        }

        $cms.log('$cms.ui.activateTooltip');

        if (!haveLinks && $cms.isTouchEnabled()) {
            return; // Too erratic
        }

        $cms.ui.clearOutTooltips(el.tooltip_id);

        // Add in move/leave events if needed
        if (!haveLinks) {
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
        el.deactivated_at = null;
        el.tooltip_on = false;
        el.initial_width = width;
        el.have_links = haveLinks;

        var children = el.querySelectorAll('img');
        for (var i = 0; i < children.length; i++) {
            children[i].setAttribute('title', '');
        }

        var tooltipEl;
        if ((el.tooltip_id != null) && ($cms.dom.$id(el.tooltip_id))) {
            tooltipEl = $cms.dom.$('#' + el.tooltip_id);
            tooltipEl.style.display = 'none';
            $cms.dom.html(tooltipEl, '');
            setTimeout(function () {
                $cms.ui.repositionTooltip(el, event, bottom, true, tooltipEl, forceWidth);
            }, 0);
        } else {
            tooltipEl = document.createElement('div');
            tooltipEl.role = 'tooltip';
            tooltipEl.style.display = 'none';
            var rtPos = tooltip.indexOf('results_table');
            tooltipEl.className = 'tooltip ' + ((rtPos == -1 || rtPos > 100) ? 'tooltip_ownlayout' : 'tooltip_nolayout') + ' boxless_space' + (haveLinks ? ' have_links' : '');
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
                    var newAutoWidth = $cms.dom.getWindowWidth(win) - 30 - window.mouse_x;
                    if (newAutoWidth < 150) newAutoWidth = 150; // For tiny widths, better let it slide to left instead, which it will as this will force it to not fit
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
            el.tooltip_id = tooltipEl.id;
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

        // This allows turning off tooltips by pressing anywhere, on iPhone (and probably Android etc). The clickability of body forces the simulated onmouseout events to fire.
        var bi = $cms.dom.$('#main_website_inner') || document.body;
        if ((window.TouchEvent !== undefined) && !bi.onmouseover) {
            bi.onmouseover = function () {
                return true;
            };
        }

        setTimeout(function () {
            if (!el.is_over) {
                return;
            }

            if ((!el.tooltip_on) || (tooltipEl.childNodes.length === 0)) { // Some other tooltip jumped in and wiped out tooltip on a delayed-show yet never triggers due to losing focus during that delay
                $cms.dom.append(tooltipEl, tooltip);
            }

            el.tooltip_on = true;
            tooltipEl.style.display = 'block';
            if ((tooltipEl.style.width == 'auto') && ((tooltipEl.childNodes.length != 1) || (tooltipEl.childNodes[0].nodeName.toLowerCase() != 'img'))) {
                tooltipEl.style.width = ($cms.dom.contentWidth(tooltipEl) + 1/*for rounding issues from em*/) + 'px'; // Fix it, to stop the browser retroactively reflowing ambiguous layer widths on mouse movement
            }

            if (!noDelay) {
                // If delayed we will sub in what the currently known global mouse coordinate is
                eventCopy.pageX = win.mouse_x;
                eventCopy.pageY = win.mouse_y;
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

        if (!el.is_over) {
            return;
        }

        //console.log('reposition_tooltip');

        if (!starting) { // Real JS mousemove event, so we assume not a screen reader and have to remove natural tooltip

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

        tooltipElement || (tooltipElement = $cms.dom.$id(el.tooltip_id));

        if (!tooltipElement) {
            return;
        }

        var styleOffsetX = 9,
            styleOffsetY = (el.have_links) ? 18 : 9,
            x, y;

        // Find mouse position
        x = window.mouse_x;
        y = window.mouse_y;
        x += styleOffsetX;
        y += styleOffsetY;
        try {
            if (event.type) {
                if (event.type != 'focus') {
                    el.done_none_focus = true;
                }

                if ((event.type === 'focus') && (el.done_none_focus)) {
                    return;
                }

                x = (event.type === 'focus') ? (win.pageXOffset + $cms.dom.getWindowWidth(win) / 2) : (window.mouse_x + styleOffsetX);
                y = (event.type === 'focus') ? (win.pageYOffset + $cms.dom.getWindowHeight(win) / 2 - 40) : (window.mouse_y + styleOffsetY);
            }
        } catch (ignore) {
        }
        // Maybe mouse position actually needs to be in parent document?
        try {
            if (event.target && (event.target.ownerDocument !== win.document)) {
                x = win.mouse_x + styleOffsetX;
                y = win.mouse_y + styleOffsetY;
            }
        } catch (ignore) {
        }

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
            if (yExcess > 0) y -= yExcess;
            var scrollY = win.pageYOffset;
            if (y < scrollY) y = scrollY;
            tooltipElement.style.top = y + 'px';
        }
        tooltipElement.style.left = x + 'px';
    };

    /**
     * @param el
     * @param tooltipElement
     */
    $cms.ui.deactivateTooltip = function deactivateTooltip(el, tooltipElement) {
        if (el.is_over) {
            el.deactivated_at = Date.now();
        }
        el.is_over = false;

        //console.log('deactivate_tooltip');

        if (el.tooltip_id == null) {
            return;
        }

        tooltipElement || (tooltipElement = $cms.dom.$('#' + el.tooltip_id));

        if (tooltipElement) {
            $cms.dom.off(tooltipElement, 'mouseout.cmsTooltip');
            $cms.dom.off(tooltipElement, 'mousemove.cmsTooltip');
            $cms.dom.off(tooltipElement, 'click.cmsTooltip');
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

    window.$cmsReady.push(function () {
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
        title || (title = '{!Q_SURE;^}');
        unescaped = !!unescaped;

        if (!$cms.$CONFIG_OPTION('js_overlays')) {
            callback(confirm(question));
            return;
        }

        var myConfirm = {
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
        $cms.openModalWindow(myConfirm);
        return Promise.resolve();
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
            alert(notice);
            callback();
            return Promise.resolve();
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
        return Promise.resolve();
    };

    /**
     * @memberof $cms.ui
     * @param question
     * @param defaultValue
     * @param callback
     * @param title
     * @param inputType
     */
    $cms.ui.prompt = function prompt(question, defaultValue, callback, title, inputType) {
        if (!$cms.$CONFIG_OPTION('js_overlays')) {
            callback(prompt(question, defaultValue));
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
        if (inputType) {
            myPrompt.input_type = inputType;
        }
        $cms.openModalWindow(myPrompt);
        return Promise.resolve();
    };

    /**
     * @memberof $cms.ui
     * @param url
     * @param name
     * @param options
     * @param callback
     * @param target
     * @param cancelText
     */
    $cms.ui.showModalDialog = function showModalDialog(url, name, options, callback, target, cancelText) {
        callback = callback || noop;

        if (!$cms.$CONFIG_OPTION('js_overlays')) {
            options = options.replace('height=auto', 'height=520');

            var timer = new Date().getTime();
            try {
                var result = window.showModalDialog(url, name, options);
            } catch (ignore) {
                // IE gives "Access is denied" if popup was blocked, due to var result assignment to non-real window
            }
            var timerNow = new Date().getTime();
            if (timerNow - 100 > timer) { // Not popup blocked
                if ((result === undefined) || (result === null)) {
                    callback(null);
                } else {
                    callback(result);
                }
            }
            return;
        }

        var width = null, height = null, scrollbars = null, unadorned = null;

        if (cancelText === undefined) {
            cancelText = '{!INPUTSYSTEM_CANCEL;^}';
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

        var myFrame = {
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
        myFrame.cancel_button = (unadorned !== true) ? cancelText : null;
        if (target) {
            myFrame.target = target;
        }
        $cms.openModalWindow(myFrame);
        return Promise.resolve();
    };

    /**
     * @memberof $cms.ui
     * @param url
     * @param name
     * @param options
     * @param target
     * @param [cancelText]
     */
    $cms.ui.open = function open(url, name, options, target, cancelText) {
        if (cancelText === undefined) {
            cancelText = '{!INPUTSYSTEM_CANCEL;^}';
        }

        if (!$cms.$CONFIG_OPTION('js_overlays')) {
            options = options.replace('height=auto', 'height=520');
            window.open(url, name, options);
            return;
        }

        $cms.ui.showModalDialog(url, name, options, null, target, cancelText);
        return Promise.resolve();
    };

    var tempDisabledButtons = {};

    /**
     * @memberof $cms.ui
     * @param btn
     * @param [permanent]
     */
    $cms.ui.disableButton = function disableButton(btn, permanent) {
        permanent = !!permanent;

        // TODO: Salman merge in this change https://github.com/ocproducts/composr/commit/670ad2c791eedd4f0e3bf2290854d1f1a02369ff and also the relevant bits in here which fix this change https://github.com/ocproducts/composr/commit/f42749ec932a3143e6d3d4f59ce48f48b04a331c

        if (btn.form && (btn.form.target === '_blank')) {
            return;
        }

        var uid = $cms.uid(btn);

        setTimeout(function () {
            btn.style.cursor = 'wait';
            btn.disabled = true;
            if (!permanent) {
                tempDisabledButtons[uid] = true;
            }
        }, 20);

        if (!permanent) {
            setTimeout(enableDisabledButton, 5000);
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
            if (!btn.disabled && !tempDisabledButtons[$cms.uid(btn)]) { // We do not want to interfere with other code potentially operating
                $cms.ui.disableButton(btn, permanent);
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
                cancel_button: '{!INPUTSYSTEM_CLOSE;^}',
                width: '450', // This will be updated with the real image width, when it has loaded
                height: '300' // "
            },
            modal = $cms.openModalWindow(myLightbox);

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
                var img = modal.top_window.document.createElement('img');
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
        if (!modal.boxWrapperEl) {
            /* Overlay closed already */
            return;
        }

        var realWidth = isVideo ? img.videoWidth : img.width,
            width = realWidth,
            realHeight = isVideo ? img.videoHeight : img.height,
            height = realHeight,
            lightboxImage = modal.top_window.$cms.dom.$id('lightbox_image'),
            lightboxMeta = modal.top_window.$cms.dom.$id('lightbox_meta'),
            lightboxDescription = modal.top_window.$cms.dom.$id('lightbox_description'),
            lightboxPositionInSet = modal.top_window.$cms.dom.$id('lightbox_position_in_set'),
            lightboxFullLink = modal.top_window.$cms.dom.$id('lightbox_full_link');

        var sup = lightboxImage.parentNode;
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
            modal.reset_dimensions('' + width, '' + height, false, true); // Temporarily forced, until real height is known (includes extra text space etc)

            setTimeout(function () {
                modal.reset_dimensions('' + width, '' + height, false);
            });

            if (img.parentElement) {
                img.parentElement.parentElement.parentElement.style.width = 'auto';
                img.parentElement.parentElement.parentElement.style.height = 'auto';
            }

            function _getMaxLightboxImgDims(modal, hasFullButton) {
                var maxWidth = modal.top_window.$cms.dom.getWindowWidth() - 20,
                    maxHeight = modal.top_window.$cms.dom.getWindowHeight() - 60;

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

        reset_dimensions: function (width, height, init, forceHeight) {
            forceHeight = !!forceHeight;

            if (!this.boxWrapperEl) {
                return;
            }

            var dim = this.getPageSize();

            var bottomGap = this.WINDOW_TOP_GAP;
            if (this.button_container.firstChild) {
                bottomGap += this.button_container.offsetHeight;
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
                if ((parseInt(width) > dim.window_width - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY) || (width == 'auto')) {
                    width = '' + (dim.window_width - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY);
                }
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
                width = '' + (parseFloat(match[1]) * (dim.window_width - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY));
            }
            match = height.match(/^([\d\.]+)%$/);
            if (match !== null) {
                height = '' + (parseFloat(match[1]) * (dim.page_height - this.WINDOW_TOP_GAP - bottomGap - this.BOX_NORTH_PERIPHERARY - this.BOX_SOUTH_PERIPHERARY));
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
            this.boxWrapperEl.firstElementChild.style.width = boxWidth;
            this.boxWrapperEl.firstElementChild.style.height = boxHeight;
            var iframe = this.boxWrapperEl.querySelector('iframe');

            if (($cms.dom.hasIframeAccess(iframe)) && (iframe.contentWindow.document.body)) { // Balance iframe height
                iframe.style.width = '100%';
                if (height == 'auto') {
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
                detectedBoxHeight = this.boxWrapperEl.firstElementChild.offsetHeight;
            }
            var _boxPosTop, _boxPosLeft, boxPosTop, boxPosLeft;
            if (boxHeight === 'auto') {
                if (init) {
                    _boxPosTop = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (this.LOADING_SCREEN_HEIGHT / 2) + this.WINDOW_TOP_GAP; // This is just temporary
                } else {
                    _boxPosTop = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (detectedBoxHeight / 2) + this.WINDOW_TOP_GAP;
                }

                if (iframe) { // Actually, for frames we'll put at top so things don't bounce about during loading and if the frame size changes
                    _boxPosTop = this.WINDOW_TOP_GAP;
                }
            } else {
                _boxPosTop = (dim.window_height / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (parseInt(boxHeight) / 2) + this.WINDOW_TOP_GAP;
            }
            if (_boxPosTop < this.WINDOW_TOP_GAP) {
                _boxPosTop = this.WINDOW_TOP_GAP;
            }
            _boxPosLeft = ((dim.window_width / 2) - (parseInt(boxWidth) / 2));
            boxPosTop = _boxPosTop + 'px';
            boxPosLeft = _boxPosLeft + 'px';

            // Save into HTML
            this.boxWrapperEl.firstElementChild.style.top = boxPosTop;
            this.boxWrapperEl.firstElementChild.style.left = boxPosLeft;

            var doScroll = false;

            // Absolute positioning instead of fixed positioning
            if ($cms.$MOBILE() || (detectedBoxHeight > dim.window_height) || (this.boxWrapperEl.style.position === 'absolute'/*don't switch back to fixed*/)) {
                var wasFixed = (this.boxWrapperEl.style.position == 'fixed');

                this.boxWrapperEl.style.position = 'absolute';
                this.boxWrapperEl.style.height = ((dim.page_height > (detectedBoxHeight + bottomGap + _boxPosLeft)) ? dim.page_height : (detectedBoxHeight + bottomGap + _boxPosLeft)) + 'px';
                this.top_window.document.body.style.overflow = '';

                if (!$cms.$MOBILE()) {
                    this.boxWrapperEl.firstElementChild.style.position = 'absolute';
                    boxPosTop = this.WINDOW_TOP_GAP + 'px';
                    this.boxWrapperEl.firstElementChild.style.top = boxPosTop;
                }

                if ((init) || (wasFixed)) doScroll = true;
                if (/*maybe a navigation has happened and we need to scroll back up*/iframe && ($cms.dom.hasIframeAccess(iframe)) && (iframe.contentWindow.scrolled_up_for === undefined)) {
                    doScroll = true;
                }
            } else { // Fixed positioning, with scrolling turned off until the overlay is closed
                this.boxWrapperEl.style.position = 'fixed';
                this.boxWrapperEl.firstElementChild.style.position = 'fixed';
                this.top_window.document.body.style.overflow = 'hidden';
            }

            if (doScroll) {
                try { // Scroll to top to see
                    this.top_scrollTo(0, 0);
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
                'css': {
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
                'css': {
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
                'css': {
                    'width': 'auto',
                    'height': 'auto'
                }
            });

            var overlayHeader = null;
            if (this.title != '' || this.type == 'iframe') {
                overlayHeader = this.element('h3', {
                    'html': this.title,
                    'css': {
                        'display': (this.title == '') ? 'none' : 'block'
                    }
                });
                container.appendChild(overlayHeader);
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
                var keyCode = (e) ? (e.which || e.keyCode) : null;

                if (keyCode == 37) // Left arrow
                {
                    that.option('left');
                } else if (keyCode == 39) // Right arrow
                {
                    that.option('right');
                } else if ((keyCode == 13/*enter*/) && (that.yes)) {
                    that.option('yes');
                }
                if ((keyCode == 13/*enter*/) && (that.finished)) {
                    that.option('finished');
                } else if ((keyCode == 27/*esc*/) && (that.cancel_button) && ((that.type == 'prompt') || (that.type == 'confirm') || (that.type == 'lightbox') || (that.type == 'alert'))) {
                    that.option('cancel');
                }
            };

            this.mousemove = function (e) {
                if (that.boxWrapperEl && that.boxWrapperEl.firstElementChild.className.indexOf(' mousemove') == -1) {
                    that.boxWrapperEl.firstElementChild.className += ' mousemove';
                    setTimeout(function () {
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

                if ($cms.$MOBILE() && (that.type === 'lightbox')) { // IDEA: Swipe detect would be better, but JS does not have this natively yet
                    that.option('right');
                }
            });

            switch (this.type) {
                case 'iframe':
                    var iframeWidth = (this.width.match(/^[\d\.]+$/) !== null) ? ((this.width - 14) + 'px') : this.width;
                    var iframeHeight = (this.height.match(/^[\d\.]+$/) !== null) ? (this.height + 'px') : ((this.height == 'auto') ? (this.LOADING_SCREEN_HEIGHT + 'px') : this.height);

                    var iframe = this.element('iframe', {
                        'frameBorder': '0',
                        'scrolling': 'no',
                        'title': '',
                        'name': 'overlay_iframe',
                        'id': 'overlay_iframe',
                        'allowTransparency': 'true',
                        //'seamless': 'seamless',   Not supported, and therefore testable yet. Would be great for mobile browsing.
                        'css': {
                            'width': iframeWidth,
                            'height': iframeHeight,
                            'background': 'transparent'
                        }
                    });

                    container.appendChild(iframe);

                    $cms.dom.animateFrameLoad(iframe, 'overlay_iframe', 50, true);

                    setTimeout(function () {
                        if (isEl(that.boxWrapperEl)) {
                            $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_finished);
                        }
                    }, 1000);

                    $cms.dom.on(iframe, 'load', function () {
                        if (($cms.dom.hasIframeAccess(iframe)) && (!iframe.contentWindow.document.querySelector('h1')) && (!iframe.contentWindow.document.querySelector('h2'))) {
                            if (iframe.contentWindow.document.title) {
                                $cms.dom.html(overlayHeader, $cms.filter.html(iframe.contentWindow.document.title));
                                overlayHeader.style.display = 'block';
                            }
                        }
                    });

                    // Fiddle it, to behave like a popup would
                    var name = this.name;
                    var makeFrameLikePopup = function makeFrameLikePopup() {
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
                            //iframe.scrolling=(_this.scrollbars===false)?'no':'auto';  Actually, not wanting this now

                            if (iframe.contentWindow.$cms != undefined) {
                                // Remove fixed width
                                var mainWebsiteInner = iframe.contentWindow.$cms.dom.$id('main_website_inner');
                                if (mainWebsiteInner) mainWebsiteInner.id = '';

                                // Remove main_website marker
                                var mainWebsite = iframe.contentWindow.$cms.dom.$id('main_website');
                                if (mainWebsite) mainWebsite.id = '';

                                // Remove popup spacing
                                var popupSpacer = iframe.contentWindow.$cms.dom.$id('popup_spacer');
                                if (popupSpacer) popupSpacer.id = '';
                            }

                            // Set linking scheme
                            var bases = iframe.contentWindow.document.getElementsByTagName('base');
                            var baseElement;
                            if (!bases[0]) {
                                baseElement = iframe.contentWindow.document.createElement('base');
                                if (iframe.contentWindow.document) {
                                    var heads = iframe.contentWindow.document.getElementsByTagName('head');
                                    if (heads[0]) {
                                        heads[0].appendChild(baseElement);
                                    }
                                }
                            } else {
                                baseElement = bases[0];
                            }
                            baseElement.target = that.target;

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

                            if ($cms.dom.html(iframe.contentWindow.document.body).length > 300) { // Loaded now
                                iframe.contentWindow.document.body.done_popup_trans = true;
                            }
                        } else
                        {
                            if (hasIframeLoaded(iframe) && !hasIframeOwnership(iframe)) {
                                iframe.scrolling='yes';
                                iframe.style.height='500px';
                            }
                        }

                        // Handle iframe sizing
                        if (that.height == 'auto') {
                            that.reset_dimensions(that.width, that.height, false);
                        }
                    };
                    setTimeout(function () {
                        $cms.dom.illustrateFrameLoad('overlay_iframe');
                        iframe.src = that.href;
                        makeFrameLikePopup();

                        if (that.iframe_restyle_timer == null)
                            that.iframe_restyle_timer = setInterval(makeFrameLikePopup, 300); // In case internal nav changes
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

                        setTimeout(function () {
                            if (that.boxWrapperEl) {
                                $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_yes);
                            }
                        }, 1000);

                        this.button_container.appendChild(button);
                    } else {
                        setTimeout(function () {
                            if (that.boxWrapperEl) {
                                $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_cancel);
                            }
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
                    var inputWrap = this.element('div', {});
                    inputWrap.appendChild(this.input);
                    container.appendChild(inputWrap);

                    if (this.yes) {
                        button = this.element('button', {
                            'html': this.yes_button,
                            'class': 'buttons__yes button_screen_item',
                            'css': {
                                'font-weight': 'bold'
                            }
                        });
                        $cms.dom.on(button, 'click', function () {
                            that.option('yes');
                        });
                        this.button_container.appendChild(button);
                    }

                    setTimeout(function () {
                        if (that.boxWrapperEl) {
                            $cms.dom.on(that.boxWrapperEl, 'click', that.clickout_cancel);
                        }
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
                if (this.type === 'iframe') {
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


            function hasIframeLoaded(iframe) {
                var hasLoaded = false;
                try {
                    hasLoaded = (iframe != null) && (iframe.contentWindow.location.host != '');
                } catch (ignore) {}
                return hasLoaded;
            }

            function hasIframeOwnership(iframe) {
                var hasOwnership = false;
                try {
                    hasOwnership = (iframe != null) && (iframe.contentWindow.location.host == window.location.host) && (iframe.contentWindow.document != null);
                } catch (ignore) {}
                return hasOwnership;
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
            var el = this.top_window.document.createElement(tag);

            if (isObj(options)) {
                for (var name in options) {
                    var value = options[name];
                    if ((name === 'styles') || (name === 'css')) {
                        $cms.dom.css(el, value);
                    } else if (name === 'html') {
                        $cms.dom.html(el, value);
                    } else if (name === 'class') {
                        el.className = value;
                    } else if (name === 'text') {
                        el.textContent = value;
                    } else if (name === 'for') {
                        el.htmlFor = value;
                    } else {
                        $cms.dom.attr(el, name, value);
                    }
                }
            }
            return el;
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
     * @param buttonSet
     * @param windowTitle
     * @param fallbackMessage
     * @param callback
     * @param dialogWidth
     * @param dialogHeight
     */
    $cms.ui.generateQuestionUi = function generateQuestionUi(message, buttonSet, windowTitle, fallbackMessage, callback, dialogWidth, dialogHeight) {
        var imageSet = [];
        var newButtonSet = [];
        for (var s in buttonSet) {
            newButtonSet.push(buttonSet[s]);
            imageSet.push(s);
        }
        buttonSet = newButtonSet;

        if ((window.showModalDialog !== undefined) || $cms.$CONFIG_OPTION('js_overlays')) {
            if (buttonSet.length > 4) {
                dialogHeight += 5 * (buttonSet.length - 4);
            }

            // Intentionally FIND_SCRIPT and not FIND_SCRIPT_NOHTTP, because no needs-HTTPS security restriction applies to popups, yet popups do not know if they run on HTTPS if behind a transparent reverse proxy
            var url = $cms.maintainThemeInLink('{$FIND_SCRIPT;,question_ui}?message=' + encodeURIComponent(message) + '&image_set=' + encodeURIComponent(imageSet.join(',')) + '&button_set=' + encodeURIComponent(buttonSet.join(',')) + '&window_title=' + encodeURIComponent(windowTitle) + $cms.keepStub());
            if (dialogWidth === undefined) {
                dialogWidth = 440;
            }
            if (dialogHeight === undefined) {
                dialogHeight = 180;
            }
            $cms.ui.showModalDialog(
                url,
                null,
                'dialogWidth=' + dialogWidth + ';dialogHeight=' + dialogHeight + ';status=no;unadorned=yes',
                function (result) {
                    if (result == null) {
                        callback(buttonSet[0]); // just pressed 'cancel', so assume option 0
                    } else {
                        callback(result);
                    }
                }
            );

            return;
        }

        if (buttonSet.length == 1) {
            $cms.ui.alert(
                fallbackMessage ? fallbackMessage : message,
                function () {
                    callback(buttonSet[0]);
                },
                windowTitle
            );
        } else if (buttonSet.length == 2) {
            $cms.ui.confirm(
                fallbackMessage ? fallbackMessage : message,
                function (result) {
                    callback(result ? buttonSet[1] : buttonSet[0]);
                },
                windowTitle
            );
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

            $cms.ui.prompt(
                message,
                '',
                function (result) {
                    if ((result === undefined) || (result === null)) {
                        callback(buttonSet[0]); // just pressed 'cancel', so assume option 0
                        return;
                    } else {
                        if (result == '') {
                            callback(buttonSet[1]); // just pressed 'ok', so assume option 1
                            return;
                        }
                        for (var i = 0; i < buttonSet.length; i++) {
                            if (result.toLowerCase() === buttonSet[i].toLowerCase()) { // match
                                callback(result);
                                return;
                            }
                        }
                    }

                    // unknown
                    callback(buttonSet[0]);
                },
                windowTitle
            );
        }
    };

    // ---

    var networkDownAlerted = false;

    /**
     * @param url
     * @param ajaxCallback
     * @param post - Note that 'post' is not an array, it's a string (a=b)
     * @returns {*}
     */
    function doAjaxRequest(url, ajaxCallback, post) {
        var async = !!ajaxCallback;

        url = strVal(url);

        if (!url.includes('://') && url.startsWith('/')) {
            url = window.location.protocol + '//' + window.location.host + url;
        }

        var ajaxInstance = new XMLHttpRequest();

        if (async) {
            ajaxInstance.onreadystatechange = function () {
                if ((ajaxInstance.readyState === XMLHttpRequest.DONE) && (typeof ajaxCallback === 'function')) {
                    readyStateChangeListener(ajaxInstance, ajaxCallback);
                }
            };
        }

        if (typeof post === 'string') {
            if (!post.includes('&csrf_token')) { // For CSRF prevention
                post += '&csrf_token=' + encodeURIComponent($cms.getCsrfToken());
            }

            ajaxInstance.open('POST', url, async);
            ajaxInstance.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            ajaxInstance.send(post);
        } else {
            ajaxInstance.open('GET', url, async);
            ajaxInstance.send(null);
        }

        return ajaxInstance;

        function readyStateChangeListener(ajaxInstance, ajaxCallback) {
            var okStatusCodes = [200, 500, 400, 401];
            // If status is 'OK'
            if (ajaxInstance.status && okStatusCodes.includes(ajaxInstance.status)) {
                // Process the result
                if ((!ajaxInstance.responseXML/*Not payload handler and not stack trace*/ || !ajaxInstance.responseXML.firstChild)) {
                    return callAjaxMethod(ajaxCallback, ajaxInstance);
                }

                // XML result. Handle with a potentially complex call
                var xml = (ajaxInstance.responseXML && ajaxInstance.responseXML.firstChild) ? ajaxInstance.responseXML : handleErrorsInResult(ajaxInstance);

                if (xml) {
                    xml.validateOnParse = false;
                    processRequestChange(xml.documentElement || xml, ajaxCallback);
                } else {
                    // Error parsing
                    return callAjaxMethod(ajaxCallback);
                }
            } else {
                // HTTP error...
                callAjaxMethod(ajaxCallback);

                try {
                    if ((ajaxInstance.status === 0) || (ajaxInstance.status > 10000)) { // implies site down, or network down
                        if (!networkDownAlerted && !window.unloaded) {
                            //$cms.ui.alert('{!NETWORK_DOWN;^}');   Annoying because it happens when unsleeping a laptop (for example)
                            networkDownAlerted = true;
                        }
                    } else {
                        $cms.error('$cms.doAjaxRequest(): {!PROBLEM_RETRIEVING_XML;^}\n' + ajaxInstance.status + ': ' + ajaxInstance.statusText + '.', ajaxInstance);
                    }
                } catch (e) {
                    $cms.error('$cms.doAjaxRequest(): {!PROBLEM_RETRIEVING_XML;^}', e); // This is probably clicking back
                }
            }
        }

        function processRequestChange(ajaxResultFrame, ajaxCallback) {
            var method = null,
                methodEl = ajaxResultFrame.querySelector('method');

            if (methodEl || ajaxCallback) {
                // TODO: Salman remove eval, but first check that we are no longer using any <method> AJAX results [the initiating JS should define the callback] (and then all the <method> code can be removed)
                method = methodEl ? eval('return ' + methodEl.textContent) : ajaxCallback;
            }

            var messageEl = ajaxResultFrame.querySelector('message');
            if (messageEl) {
                // Either an error or a message was returned. :(
                var message = messageEl.firstChild.textContent;

                callAjaxMethod(method);

                if (ajaxResultFrame.querySelector('error')) {
                    // It's an error :|
                    $cms.ui.alert('An error (' + ajaxResultFrame.querySelector('error').firstChild.textContent + ') message was returned by the server: ' + message);
                    return;
                }

                $cms.ui.alert('An informational message was returned by the server: ' + message);
                return;
            }

            var ajaxResultEl = ajaxResultFrame.querySelector('result');
            if (ajaxResultEl) {
                callAjaxMethod(method, ajaxResultFrame, ajaxResultEl);
                return;
            }

            callAjaxMethod(method);
        }

        function handleErrorsInResult(xhr) {
            // Try and parse again. Firefox can be weird.
            var xml;
            try {
                xml = (new DOMParser()).parseFromString(xhr.responseText, 'application/xml');
                if ((xml) && (xml.documentElement.nodeName == 'parsererror')) xml = null;
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

            if (typeof method === 'function') {
                method(ajaxResultFrame, ajaxResult);
            }
        }
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
            $cms.doAjaxRequest(url, function (xhr) {
                if ((xhr.responseText !== '') && (xhr.responseText.replace(/[ \t\n\r]/g, '') !== '0'/*some cache layers may change blank to zero*/)) {
                    if (xhr.responseText !== 'false') {
                        if (xhr.responseText.length > 1000) {
                            $cms.log('$cms.form.doAjaxFieldTest()', 'xhr.responseText:', xhr.responseText);
                            $cms.ui.alert(xhr.responseText, null, '{!ERROR_OCCURRED;^}', true);
                        } else {
                            $cms.ui.alert(xhr.responseText);
                        }
                    }
                    resolve(false);
                    return;
                }
                resolve(true);
            }, post);
        });
    };
}(window.$cms || (window.$cms = {}), (!window.IN_MINIKERNEL_VERSION ? JSON.parse(document.getElementById('composr-symbol-data').content) : {})));

(function ($cms) {
    'use strict';

    window.$cmsReady.push(function () {
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

        // Implementation for [data-view]
        initializeViews: {
            attach: function (context) {
                $cms.dom.$$$(context, '[data-view]').forEach(function (el) {
                    var params = objVal($cms.dom.data(el, 'viewParams')),
                        view, viewOptions = { el: el };

                    if (typeof $cms.views[el.dataset.view] !== 'function') {
                        $cms.error('$cms.behaviors.initializeViews.attach(): Missing view constructor "' + el.dataset.view + '" for', el);
                        return;
                    }

                    try {
                        view = new $cms.views[el.dataset.view](params, viewOptions);
                        $cms.viewInstances[$cms.uid(view)] = view;
                        $cms.verbose('$cms.behaviors.initializeViews.attach(): Initialized view "' + el.dataset.view + '" for', el, view);
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

                    if (typeof $cms.templates[template] !== 'function') {
                        $cms.error('$cms.behaviors.initializeTemplates.attach(): Missing template function "' + template + '" for', el);
                        return;
                    }

                    try {
                        $cms.templates[template].call(el, params, el);
                        $cms.verbose('$cms.behaviors.initializeTemplates.attach(): Initialized template "' + template + '" for', el);
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
                            convertTooltip(anchor);
                        }
                    }

                    if ($cms.$VALUE_OPTION('js_keep_params')) {
                        // Keep parameters need propagating
                        if (anchor.href && anchor.href.startsWith($cms.$BASE_URL_S())) {
                            anchor.href += keepStubWithContext(anchor.href);
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
                    if (window.loadHtmlEdit !== undefined) {
                        loadHtmlEdit(form);
                    }

                    // Remove tooltips from forms as they are for screenreader accessibility only
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

                        elements = form.querySelectorAll('input[type="image"][title]'); // JS DOM does not include type="image" ones in form.elements
                        for (j = 0; j < elements.length; j++) {
                            if ((elements[j]['original-title'] === undefined/*check tipsy not used*/) && !elements[j].classList.contains('no_tooltip')) {
                                convertTooltip(elements[j]);
                            }
                        }
                    }

                    if ($cms.$VALUE_OPTION('js_keep_params')) {
                        /* Keep parameters need propagating */
                        if (form.action && form.action.startsWith($cms.$BASE_URL_S())) {
                            form.action += keepStubWithContext(form.action);
                        }
                    }

                    // This "proves" that JS is running, which is an anti-spam heuristic (bots rarely have working JS)
                    if (form.elements['csrf_token'] != undefined && form.elements['js_token'] == undefined) {
                        var jsToken = document.createElement('input');
                        jsToken.name = 'js_token';
                        jsToken.value = form.elements['csrf_token'].value.split("").reverse().join(""); // Reverse the CSRF token for our JS token
                        jsToken.type = 'hidden';
                        form.appendChild(jsToken);
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

        initializeTables: {
            attach: function attach(context) {
                var tables = $cms.dom.$$$(context, 'table');

                tables.forEach(function (table) {
                    // Responsive table prep work
                    if (table.classList.contains('responsive_table')) {
                        var trs = table.getElementsByTagName('tr'),
                            ths_first_row = trs[0].cells,
                            i, tds, j, data;
                        
                        for (i = 0; i < trs.length; i++) {
                            tds = trs[i].cells;
                            for (j = 0; j < tds.length; j++) {
                                if (!tds[j].classList.contains('responsive_table_no_prefix')) {
                                    data = (ths_first_row[j] === undefined) ? '' : ths_first_row[j].textContent.replace(/^\s+/, '').replace(/\s+$/, '');
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
        
        columnHeightBalancing: {
            attach: function attach(context) {
                var cols = $cms.dom.$$$('.col_balance_height'),
                    i, max, j, height;

                for (i = 0; i < cols.length; i++) {
                    max = null;
                    for (j = 0; j < cols.length; j++) {
                        if (cols[i].className === cols[j].className) {
                            height = cols[j].offsetHeight;
                            if (max === null || height > max) {
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

                $cms.dom.$$$(context, 'img:not([data-cms-rich-tooltip])').forEach(function (img) {
                    convertTooltip(img);
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
                if (window.IN_MINIKERNEL_VERSION) {
                    return;
                }

                $cms.requireJavascript(['jquery', 'select2']).then(function () {
                    var els = $cms.dom.$$$(context, '[data-cms-select2]');

                    // Select2 plugin hook
                    els.forEach(function (el) {
                        var options = objVal($cms.dom.data(el, 'cmsSelect2'));
                        window.jQuery(el).select2(options);
                    });
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

    function keepStubWithContext(context) {
        context = strVal(context);

        var starting = !context || !context.includes('?');

        var toAdd = '', i,
            bits = (window.location.search || '?').substr(1).split('&'),
            gapSymbol;

        for (i = 0; i < bits.length; i++) {
            if (bits[i].startsWith('keep_')) {
                if (!context || (!context.includes('?' + bits[i]) && !context.includes('&' + bits[i]))) {
                    gapSymbol = ((toAdd === '') && starting) ? '?' : '&';
                    toAdd += gapSymbol + bits[i];
                }
            }
        }

        return toAdd;
    }

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
            if ($cms.$COOKIE_DOMAIN() != '') {
                aConfig.cookieDomain = $cms.$COOKIE_DOMAIN();
            }
            if (!$cms.$CONFIG_OPTION('long_google_cookies')) {
                aConfig.cookieExpires = 0;
            }
            window.ga('create', $cms.$CONFIG_OPTION('google_analytics').trim(), aConfig);
            if (!$cms.$IS_GUEST) {
                window.ga('set', 'userId', strVal($cms.$MEMBER()));
            }
            if ($cms.usp.get('_t') != '') {
                window.ga('send', 'event', 'tracking__' + $cms.usp.get('_t'), window.location.href);
            }

            window.ga('send', 'pageview');
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
                defer: true,
                nonce: $cms.$CSP_NONCE
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
            $cms.dom.append(m1, $cms.dom.html(m2));
            m2.parentNode.removeChild(m2);
        }

        if ($cms.usp.get('wide_print') && ($cms.usp.get('wide_print') !== '0')) {
            try {
                print();
            } catch (ignore) {}
        }

        if (($cms.$ZONE() === 'adminzone') && $cms.$CONFIG_OPTION('background_template_compilation')) {
            var page = $cms.filter.url($cms.$PAGE());
            $cms.loadSnippet('background_template_compilation&page=' + page, '', true);
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
            setTimeout(function () {
                if (!window.location.hash && window.has_js_state) {
                    window.location.reload();
                }
            });
        };

        // Monitor pasting, for anti-spam reasons
        window.addEventListener('paste', function (event) {
            var clipboardData = event.clipboardData || window.clipboardData;
            var pastedData = clipboardData.getData('Text');
            if (pastedData && pastedData.length > $cms.$CONFIG_OPTION('spam_heuristic_pasting')) {
                $cms.setPostDataFlag('paste');
            }
        });

        window.page_loaded = true;

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
            // Pinning to top if scroll out (LEGACY: CSS is going to have a better solution to this soon)
            var stuckNavs = $cms.dom.$$('.stuck_nav');

            if (!stuckNavs.length) {
                return;
            }

            $cms.dom.on(window, 'scroll', function () {
                for (var i = 0; i < stuckNavs.length; i++) {
                    var stuckNav = stuckNavs[i],
                        stuckNavHeight = (stuckNav.real_height === undefined) ? $cms.dom.contentHeight(stuckNav) : stuckNav.real_height;

                    stuckNav.real_height = stuckNavHeight;
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
            var options = objVal($cms.dom.data(target, e.type + 'Alert'), 'notice');
            $cms.ui.alert(options.notice);
        },

        // Implementation for [data-submit-on-enter]
        submitOnEnter: function submitOnEnter(e, input) {
            if ($cms.dom.keyPressed(e, 'Enter')) {
                input.form.submit();
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
                input.form.submit();
            }
        },

        // Implementation for form[data-disable-buttons-on-submit]
        disableFormButtons: function (e, target) {
            $cms.ui.disableFormButtons(target);
        },

        // Implementation for form[data-submit-modsecurity-workaround]
        submitModSecurityWorkaround: function (e, form) {
            e.preventDefault();
            $cms.form.modSecurityWorkaround(form);
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
                $cms.ui.openImageIntoLightbox(el.href, ((el.cms_tooltip_title !== undefined) ? el.cms_tooltip_title : el.title), null, null, hasFullButton);
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
                el.ttitle = (el.attributes['data-title'] ? el.getAttribute('data-title') : el.title);
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
                return;
            }

            trayCookie = strVal(trayEl.dataset.trayCookie);

            if (trayCookie) {
                $cms.setCookie('tray_' + trayCookie, $cms.dom.isDisplayed(trayEl) ? 'closed' : 'open');
            }

            $cms.toggleableTray(trayEl);
        },

        // Implementation for [data-click-tray-accordion-toggle]
        clickTrayAccordionToggle: function () {
            // TODO: Salman ???
        },

        // Detecting of JavaScript support
        detectJavascript: function () {
            var url = window.location.href,
                append = '?';

            if ($cms.$JS_ON() || +$cms.usp.get('keep_has_js') || url.includes('upgrader.php') || url.includes('webdav.php')) {
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

            var SOFTWARE_CHAT_EXTRA = '{!SOFTWARE_CHAT_EXTRA;^}'.replace(/\{1\}/, $cms.filter.html(window.location.href.replace($cms.$BASE_URL(), 'http://baseurl')));
            var html = /** @lang HTML */' \
                <div class="software_chat"> \
                    <h2>{!CMS_COMMUNITY_HELP}</h2> \
                    <ul class="spaced_list">' + SOFTWARE_CHAT_EXTRA + '</ul> \
                    <p class="associated_link associated_links_block_group"> \
                        <a title="{!SOFTWARE_CHAT_STANDALONE} {!LINK_NEW_WINDOW;^}" target="_blank" href="' + $cms.filter.html(url) + '">{!SOFTWARE_CHAT_STANDALONE}</a> \
                        <a href="#!" class="js-click-load-software-chat">{!HIDE}</a> \
                    </p> \
                </div> \
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

        /* Staff Actions links */
        staffActionsSelect: function (e, form) {
            var ob = form.elements.special_page_type;

            var val = ob.options[ob.selectedIndex].value;
            if (val !== 'view') {
                if (form.elements.cache !== undefined) {
                    form.elements.cache.value = (val.substring(val.length - 4, val.length) == '.css') ? '1' : '0';
                }

                var windowName = 'cms_dev_tools' + Math.floor(Math.random() * 10000);
                var windowOptions;
                if (val == 'templates') {
                    windowOptions = 'width=' + window.screen.availWidth + ',height=' + window.screen.availHeight + ',scrollbars=yes';

                    setTimeout(function () { // Do a refresh with magic markers, in a comfortable few seconds
                        var oldUrl = window.location.href;
                        if (oldUrl.indexOf('keep_template_magic_markers=1') == -1) {
                            window.location.href = oldUrl + ((oldUrl.indexOf('?') == -1) ? '?' : '&') + 'keep_template_magic_markers=1&cache_blocks=0&cache_comcode_pages=0';
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
                input.form.submit();
            }
        },

        loadRealtimeRain: function () {
            $cms.requireJavascript('button_realtime_rain').then(function () {
                loadRealtimeRain();
            });
        },

        loadCommandr: function () {
            if (window.loadCommandr) {
                loadCommandr();
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
                setTimeout(function () {
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
                    if (link.rendered_tooltip === undefined) {
                        link.is_over = true;

                        $cms.doAjaxRequest($cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?css=1&javascript=1&raw_output=1&box_title={!PREVIEW;&}' + $cms.keepStub()), function (ajaxResultFrame) {
                            if (ajaxResultFrame && ajaxResultFrame.responseText) {
                                link.rendered_tooltip = ajaxResultFrame.responseText;
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
            function handleImageMouseOver(event) {
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

                    if (target.mo_link)
                        clearTimeout(target.mo_link);
                    target.mo_link = setTimeout(function () {
                        if (ml) ml.style.display = 'block';
                    }, 2000);
                }

                window.old_status_img = window.status;
                window.status = '{!SPECIAL_CLICK_TO_EDIT;^}';
            }

            function handleImageMouseOut(event) {
                var target = event.target;

                if ($cms.$CONFIG_OPTION('enable_theme_img_buttons')) {
                    if (target.previousSibling && (target.previousSibling.className !== undefined) && (target.previousSibling.className.indexOf !== undefined) && (target.previousSibling.className.indexOf('magic_image_edit_link') != -1)) {
                        if ((target.mo_link !== undefined) && (target.mo_link)) // Clear timed display of new edit button
                        {
                            clearTimeout(target.mo_link);
                            target.mo_link = null;
                        }

                        // Time removal of edit button
                        if (target.mo_link)
                            clearTimeout(target.mo_link);
                        target.mo_link = setTimeout(function () {
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

            function handleImageClick(event, ob, force) {
                ob || (ob = this);

                var src = ob.origsrc ? ob.origsrc : ((ob.src === undefined) ? $cms.dom.css(ob, 'background-image').replace(/.*url\(['"]?(.*)['"]?\).*/, '$1') : ob.src);
                if (src && (force || ($cms.magicKeypress(event)))) {
                    // Bubbling needs to be stopped because shift+click will open a new window on some lower event handler (in Firefox anyway)
                    event.stopPropagation();

                    if (event.preventDefault !== undefined) event.preventDefault();

                    if (src.includes('{$BASE_URL_NOHTTP;^}/themes/')) {
                        ob.edit_window = window.open('{$BASE_URL;,0}/adminzone/index.php?page=admin_themes&type=edit_image&lang=' + encodeURIComponent($cms.$LANG()) + '&theme=' + encodeURIComponent($cms.$THEME()) + '&url=' + encodeURIComponent($cms.protectURLParameter(src.replace('{$BASE_URL;,0}/', ''))) + $cms.keepStub(), 'edit_theme_image_' + ob.id);
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
                )
                    return null; // Comes up on due to various Firefox/extension/etc bugs

                if (!window.done_one_error) {
                    window.done_one_error = true;
                    var alert = '{!JAVASCRIPT_ERROR;^}\n\n' + code + ': ' + msg + '\n' + file;
                    if (window.document.body) { // i.e. if loaded
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
                $cms.dom.clearTransitionAndSetOpacity(helperPanelContents, 0.0);
                $cms.dom.fadeTransition(helperPanelContents, 100, 30, 4);

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

                if (window.active_menu == null) {
                    setActiveMenu(target.id, menu + '_d');
                }
            }
        },

        unsetActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                window.active_menu = null;
                recreateCleanTimeout();
            }
        },

        /* For admin/templates/MENU_dropdown.tpl */
        adminTimerPopUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            window.menu_hold_time = 3000;
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
                window.active_menu = null;
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
            if (!window.active_menu) {
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

            $cms.toggleableTray($cms.dom.$('#' + menuId));
        }
    });

    // Templates:
    // MENU_mobile.tpl
    // - MENU_BRANCH_mobile.tpl
    $cms.views.MobileMenu = MobileMenu;
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function MobileMenu() {
        MobileMenu.base(this, 'constructor', arguments);
        this.menuContentEl = this.$('.js-el-menu-content');
    }

    $cms.inherits(MobileMenu, Menu, /**@lends MobileMenu#*/{
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
        $cms.dom.on(document.body, 'click', 'click .js-click-toggle-' + menuId + '-content', function (e) {
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
            possibilities = [], isSelected, url, min_score, i;

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

                min_score = possibilities[0].score;
                for (i = 0; i < possibilities.length; i++) {
                    if (possibilities[i].score != min_score) {
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

                min_score = possibilities[0].score;
                for (i = 0; i < possibilities.length; i++) {
                    if (possibilities[i].score != min_score) {
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

    window.menu_hold_time = 500;
    window.active_menu = null;
    window.last_active_menu = null;

    var cleanMenusTimeout,
        lastActiveMenu;

    function setActiveMenu(id, menu) {
        window.active_menu = id;
        if (menu != null) {
            lastActiveMenu = menu;
        }
    }

    function recreateCleanTimeout() {
        if (cleanMenusTimeout) {
            clearTimeout(cleanMenusTimeout);
        }
        cleanMenusTimeout = setTimeout(cleanMenus, window.menu_hold_time);
    }

    function popUpMenu(id, place, menu, outsideFixedWidth) {
        place || (place = 'right');
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

        window.active_menu = id;
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
        $cms.dom.clearTransitionAndSetOpacity(el, 0.0);
        $cms.dom.fadeTransition(el, 100, 30, 8);

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
            if (place == 'below') { // Top-level of drop-down
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
                if (abovePosTop > 0) posTop = abovePosTop;
            }
            el.style.top = posTop + 'px';
        }
        positionT();
        setTimeout(positionT, 0);
        el.style.zIndex = 200;

        recreateCleanTimeout();

        return false;

        function cleanMenus() {
            cleanMenusTimeout = null;

            var m = $cms.dom.$('#r_' + lastActiveMenu);
            if (!m) {
                return;
            }
            var tags = m.querySelectorAll('.nlevel');
            var e = (window.active_menu == null) ? null : document.getElementById(window.active_menu), t;
            var i, hideable;
            for (i = tags.length - 1; i >= 0; i--) {
                if (tags[i].localName !== 'ul' && tags[i].localName !== 'div') continue;

                hideable = true;
                if (e) {
                    t = e;
                    do {
                        if (tags[i].id == t.id) hideable = false;
                        t = t.parentNode.parentNode;
                    } while (t.id != 'r_' + lastActiveMenu);
                }
                if (hideable) {
                    tags[i].style.left = '-999px';
                    tags[i].style.display = 'none';
                }
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

        if ($cms.usp.has('wide_print')) {
            try { print(); } catch (ignore) {}
        }
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
                    $cms.toggleableTray({ el: node, animate: false });
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
                $cms.toggleableTray({ el: this.contentEl, animate: false });
            }
        }
    });

    // Toggle a ToggleableTray
    $cms.toggleableTray = function toggleableTray(elOrOptions) {
        var options, el, animate,
            $IMG_expand = '{$IMG;,1x/trays/expand}',
            $IMG_expand2 = '{$IMG;,1x/trays/expand2}',
            $IMG_contract = '{$IMG;,1x/trays/contract}',
            $IMG_contract2 = '{$IMG;,1x/trays/contract2}';

        if ($cms.isPlainObj(elOrOptions)) {
            options = elOrOptions;
            el =  options.el;
            //@TODO: Implement slide-up/down animation triggered by this boolean    Salman
            animate = $cms.$CONFIG_OPTION('enable_animations') ? ((options.animate != null) ? !!options.animate : true) : false;
        } else {
            el = elOrOptions;
            animate = $cms.$CONFIG_OPTION('enable_animations');
        }

        if (!$cms.isEl(el)) {
            return;
        }

        if (!el.classList.contains('toggleable_tray')) { // Suspicious, maybe we need to probe deeper
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
                setTrayThemeImage('expand', 'contract', $IMG_expand, $IMG_contract, $IMG_contract2);
            }
        } else {
            $cms.dom.hide(el);

            if (pic) {
                setTrayThemeImage('contract', 'expand', $IMG_contract, $IMG_expand, $IMG_expand2);
                pic.setAttribute('alt', pic.getAttribute('alt').replace('{!CONTRACT;^}', '{!EXPAND;^}'));
                pic.title = '{!EXPAND;^}';
            }
        }

        $cms.dom.triggerResize(true);

        // Execution ends here

        var isThemeWizard = !!(pic && pic.src && pic.src.includes('themewizard.php'));
        function setTrayThemeImage(beforeThemeImg, afterThemeImg, before1Url, after1Url, after2Url) {
            var is_1 = $cms.dom.matchesThemeImage(pic.src, before1Url);

            if (is_1) {
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
            form.elements.ftp_domain.disabled = !usesFtp.checked;
            form.elements.ftp_directory.disabled = !usesFtp.checked;
            form.elements.ftp_username.disabled = !usesFtp.checked;
            form.elements.ftp_password.disabled = !usesFtp.checked;
            form.elements.remember_password.disabled = !usesFtp.checked;
        }
    };

    $cms.templates.standaloneHtmlWrap = function (params) {
        if (window.parent) {
            window.$cmsLoad.push(function () {
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
            document.getElementById(params.formName).submit();
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

    $cms.templates.massSelectFormButtons = function (params) {
        var delBtn = this,
            form = delBtn.form;

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

        var win = window;
        setTimeout(function () {
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


    $cms.templates.memberTooltip = function (params, container) {
        var submitter = strVal(params.submitter);

        $cms.dom.on(container, 'mouseover', '.js-mouseover-activate-member-tooltip', function (e, el) {
            el.cancelled = false;
            $cms.loadSnippet('member_tooltip&member_id=' + submitter, null, true).then(function (result) {
                if (!el.cancelled) {
                    $cms.ui.activateTooltip(el, e, result.responseText, 'auto', null, null, false, true);
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
            message = $cms.format('{!javascript:ENTER_PAGE_NUMBER;^}', numPages);

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
                    window.orig_helper_text = $cms.dom.html(helpEl);
                    $cms.dom.html(helpEl, $cms.dom.html(docEl));
                    $cms.dom.clearTransitionAndSetOpacity(helpEl, 0.0);
                    $cms.dom.fadeTransition(helpEl, 100, 30, 4);

                    helpEl.classList.remove('global_helper_panel_text');
                    helpEl.classList.add('global_helper_panel_text_over');
                }
            });

            $cms.dom.on(container, 'mouseout', function () {
                if (window.orig_helper_text !== undefined) {
                    $cms.dom.html(helpEl, window.orig_helper_text);
                    $cms.dom.clearTransitionAndSetOpacity(helpEl, 0.0);
                    $cms.dom.fadeTransition(helpEl, 100, 30, 4);

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
                    event.stopPropagation();
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
                    return false;
                };
            });
        }
    };

    $cms.templates.internalizedAjaxScreen = function internalizedAjaxScreen(params, element) {
        internaliseAjaxBlockWrapperLinks(params.url, element, ['.*'], {}, false, true);

        if (params.changeDetectionUrl && (Number(params.refreshTime) > 0)) {
            window.detect_interval = setInterval(function () {
                detectChange(params.changeDetectionUrl, params.refreshIfChanged, function () {
                    if ((!document.getElementById('post')) || (document.getElementById('post').value === '')) {
                        $cms.callBlock(params.url, '', element, false, true, null, true).then(function () {
                            detectedChange();
                        });
                    }
                });
            }, params.refreshTime * 1000);
        }
    };

    $cms.templates.ajaxPagination = function ajaxPagination(params) {
        var wrapperEl = $cms.dom.$id(params.wrapperId),
            blockCallUrl = params.blockCallUrl,
            infiniteScrollCallUrl = params.infiniteScrollCallUrl,
            infiniteScrollFunc;

        internaliseAjaxBlockWrapperLinks(blockCallUrl, wrapperEl, ['[^_]*_start', '[^_]*_max'], {});

        if (infiniteScrollCallUrl) {
            infiniteScrollFunc = internaliseInfiniteScrolling.bind(undefined, infiniteScrollCallUrl, wrapperEl);

            $cms.dom.on(window, {
                scroll: infiniteScrollFunc,
                touchmove: infiniteScrollFunc,
                keydown: infiniteScrollingBlock,
                mousedown: infiniteScrollingBlockHold,
                mousemove: function () {
                    // mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
                    infiniteScrollingBlockUnhold(infiniteScrollFunc);
                }
            });

            infiniteScrollFunc();
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

            if (window.faux_close !== undefined) {
                window.faux_close();
            } else {
                try {
                    window.$cms.getMainCmsWindow().focus();
                } catch (ignore) {}

                window.close();
            }
        });
    };

    $cms.templates.buttonScreenItem = function buttonScreenItem() {};

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
        if (params.pingUrl) {
            $cms.doAjaxRequest(params.pingUrl, /*async*/function () {});

            setInterval(function () {
                $cms.doAjaxRequest(params.pingUrl, /*async*/function () {});
            }, 12000);
        }
    };

    $cms.templates.indexScreenFancierScreen = function indexScreenFancierScreen(params) {
        document.getElementById('search_content').value = strVal(params.rawSearchString);
    };

    function detectChange(changeDetectionUrl, refreshIfChanged, callback) {
        $cms.doAjaxRequest(changeDetectionUrl, function (result) {
            var response = strVal(result.responseText);
            if (response === '1') {
                clearInterval(window.detect_interval);
                $cms.log('detectChange(): Change detected');
                callback();
            }
        }, 'refresh_if_changed=' + encodeURIComponent(refreshIfChanged));
    }

    function detectedChange() {
        $cms.log('detectedChange(): Change notification running');

        try {
            focus();
        } catch (e) {}

        if (window.soundManager !== undefined) {
            var soundUrl = 'data/sounds/message_received.mp3',
                baseUrl = (!soundUrl.includes('data_custom') && !soundUrl.includes('uploads/')) ? $cms.$BASE_URL_NOHTTP : $cms.$CUSTOM_BASE_URL_NOHTTP,
                soundObject = window.soundManager.createSound({ url: baseUrl + '/' + soundUrl });

            if (soundObject && document.hasFocus()/*don't want multiple tabs all pinging*/) {
                soundObject.play();
            }
        }
    }

    $cms.functions.decisionTreeRender = function decisionTreeRender(parameter, value, notice, noticeTitle) {
        var e = document.getElementById('main_form').elements[parameter];
        if (e.length === undefined) {
            e = [e];
        }
        for (var i = 0; i < e.length; i++) {
            e[i].addEventListener('click', function (_e) {
                return function () {
                    var selected = false;
                    if (_e.type != 'undefined' && _e.type == 'checkbox') {
                        selected = (_e.checked && _e.value == value) || (!_e.checked && '' == value);
                    } else {
                        selected = (_e.value == value);
                    }
                    if (selected) {
                        $cms.ui.alert(notice, null, noticeTitle, true);
                    }
                }
            }(e[i]));
        }
    };

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

    function openLinkAsOverlay(options) {
        options = $cms.defaults({
            width: '800',
            height: 'auto',
            target: '_top',
            el: null
        }, options);

        if (width.match(/^\d+$/)) { // Restrain width to viewport width
            width = Math.min(parseInt(width), $cms.dom.getWindowWidth() - 60) + '';
        }

        var el = options.el,
            url = (el.href === undefined) ? el.action : el.href,
            urlStripped = url.replace(/#.*/, ''),
            newUrl = urlStripped + (!urlStripped.includes('?') ? '?' : '&') + 'wide_high=1' + url.replace(/^[^\#]+/, '');

        $cms.ui.open(newUrl, null, 'width=' + options.width + ';height=' + options.height, options.target);
    }

    function convertTooltip(el) {
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
                // TODO: Salman, why empty?
            };
        }
        if (!el.onmousemove) {
            el.onmouseover = function () {
                // TODO: Salman, why empty?
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

    function confirmDelete(form, multi, callback) {
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
}(window.$cms));

(function () {
    /*
     Faux frames and faux scrolling
     */
    window.infiniteScrollingBlock = infiniteScrollingBlock;
    window.infiniteScrollingBlockHold = infiniteScrollingBlockHold;
    window.infiniteScrollingBlockUnhold = infiniteScrollingBlockUnhold;
    window.internaliseInfiniteScrolling = internaliseInfiniteScrolling;
    window.internaliseInfiniteScrollingGo = internaliseInfiniteScrollingGo;
    window.internaliseAjaxBlockWrapperLinks = internaliseAjaxBlockWrapperLinks;

    var infiniteScrollPending = false, // Blocked due to queued HTTP request
        infiniteScrollBlocked = false, // Blocked due to event tracking active
        infiniteScrollMouseHeld = false;

    /**
     * @param event
     */
    function infiniteScrollingBlock(event) {
        if (event.keyCode === 35) { // 'End' key pressed, so stop the expand happening for a few seconds while the browser scrolls down
            infiniteScrollBlocked = true;
            setTimeout(function () {
                infiniteScrollBlocked = false;
            }, 3000);
        }
    }

    function infiniteScrollingBlockHold() {
        if (!infiniteScrollBlocked) {
            infiniteScrollBlocked = true;
            infiniteScrollMouseHeld = true;
        }
    }

    /**
     * @param infiniteScrolling
     */
    function infiniteScrollingBlockUnhold(infiniteScrolling) {
        if (infiniteScrollMouseHeld) {
            infiniteScrollBlocked = false;
            infiniteScrollMouseHeld = false;
            infiniteScrolling();
        }
    }

    /**
     * @param urlStem
     * @param wrapper
     * @returns {*}
     */
    function internaliseInfiniteScrolling(urlStem, wrapper) {
        if (infiniteScrollBlocked || infiniteScrollPending) {
            // Already waiting for a result
            return false;
        }

        var _pagination = wrapper.querySelectorAll('.pagination');

        if (_pagination.length === 0) {
            return false;
        }

        var moreLinks = [], foundNewLinks = null;

        for (var _i = 0; _i < _pagination.length; _i++) {
            var pagination = _pagination[_i];

            if (pagination.style.display != 'none') {
                // Remove visibility of pagination, now we've replaced with AJAX load more link
                var paginationParent = pagination.parentNode;
                pagination.style.display = 'none';
                var numNodeChildren = 0;
                for (var i = 0; i < paginationParent.childNodes.length; i++) {
                    if (paginationParent.childNodes[i].nodeName != '#text') numNodeChildren++;
                }
                if (numNodeChildren == 0) // Remove empty pagination wrapper
                {
                    paginationParent.style.display = 'none';
                }

                // Add AJAX load more link before where the last pagination control was
                // Remove old pagination_load_more's
                var paginationLoadMore = wrapper.querySelectorAll('.pagination_load_more');
                if (paginationLoadMore.length > 0) paginationLoadMore[0].parentNode.removeChild(paginationLoadMore[0]);

                // Add in new one
                var loadMoreLink = document.createElement('div');
                loadMoreLink.className = 'pagination_load_more';
                var loadMoreLinkA = document.createElement('a');
                $cms.dom.html(loadMoreLinkA, '{!LOAD_MORE;^}');
                loadMoreLinkA.href = '#!';
                loadMoreLinkA.onclick = function () {
                    internaliseInfiniteScrollingGo(urlStem, wrapper, moreLinks);
                    return false;
                }; // Click link -- load
                loadMoreLink.appendChild(loadMoreLinkA);
                _pagination[_pagination.length - 1].parentNode.insertBefore(loadMoreLink, _pagination[_pagination.length - 1].nextSibling);

                moreLinks = pagination.getElementsByTagName('a');
                foundNewLinks = _i;
            }
        }
        for (var _i = 0; _i < _pagination.length; _i++) {
            var pagination = _pagination[_i];
            if (foundNewLinks != null) // Cleanup old pagination
            {
                if (_i != foundNewLinks) {
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
        for (var i = 0; i < moreLinks.length; i++) {
            rel = moreLinks[i].getAttribute('rel');
            if (rel && rel.indexOf('next') !== -1) {
                foundRel = true;
            }
        }
        if (!foundRel) // Ah, no more scrolling possible
        {
            // Remove old pagination_load_more's
            var paginationLoadMore = wrapper.querySelectorAll('.pagination_load_more');
            if (paginationLoadMore.length > 0) {
                paginationLoadMore[0].parentNode.removeChild(paginationLoadMore[0]);
            }

            return;
        }

        // Used for calculating if we need to scroll down
        var wrapperPosY = $cms.dom.findPosY(wrapper);
        var wrapperHeight = wrapper.offsetHeight;
        var wrapperBottom = wrapperPosY + wrapperHeight;
        var windowHeight = $cms.dom.getWindowHeight();
        var pageHeight = $cms.dom.getWindowScrollHeight();
        var scrollY = window.pageYOffset;

        // Scroll down -- load
        if ((scrollY + windowHeight > wrapperBottom - windowHeight * 2) && (scrollY + windowHeight < pageHeight - 30)) // If within window_height*2 pixels of load area and not within 30 pixels of window bottom (so you can press End key)
        {
            return internaliseInfiniteScrollingGo(urlStem, wrapper, moreLinks);
        }

        return false;
    }

    /**
     * @param urlStem
     * @param wrapper
     * @param moreLinks
     * @returns {boolean}
     */
    function internaliseInfiniteScrollingGo(urlStem, wrapper, moreLinks) {
        if (infiniteScrollPending) {
            return false;
        }

        var wrapperInner = $cms.dom.$id(wrapper.id + '_inner');
        if (!wrapperInner) wrapperInner = wrapper;

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
                        internaliseInfiniteScrolling(urlStem, wrapper);
                    });
                    return false;
                }
            }
        }

        return false;
    }

    /**
     * @param urlStem
     * @param blockElement
     * @param lookFor
     * @param extraParams
     * @param append
     * @param formsToo
     * @param scrollToTop
     */
    function internaliseAjaxBlockWrapperLinks(urlStem, blockElement, lookFor, extraParams, append, formsToo, scrollToTop) {
        lookFor || (lookFor = []);
        extraParams || (extraParams = []);
        append = !!append;
        formsToo = !!formsToo;
        scrollToTop = (scrollToTop !== undefined) ? !!scrollToTop : true;

        if (!blockElement) {
            return;
        }

        var blockPosY = blockElement ? $cms.dom.findPosY(blockElement, true) : 0;

        if (blockPosY > window.pageYOffset) {
            scrollToTop = false;
        }

        var _linkWrappers = blockElement.querySelectorAll('.ajax_block_wrapper_links');
        if (_linkWrappers.length === 0) {
            _linkWrappers = [blockElement];
        }
        var links = [];
        for (var i = 0; i < _linkWrappers.length; i++) {
            var _links = _linkWrappers[i].getElementsByTagName('a');

            for (var j = 0; j < _links.length; j++) {
                links.push(_links[j]);
            }

            if (formsToo) {
                _links = _linkWrappers[i].getElementsByTagName('form');

                for (var k = 0; k < _links.length; k++) {
                    links.push(_links[k]);
                }

                if (_linkWrappers[i].localName === 'form') {
                    links.push(_linkWrappers[i]);
                }
            }
        }

        links.forEach(function (link) {
            if (!link.target || (link.target !== '_self') || (link.href && link.href.startsWith('#'))) {
                return; // (continue)
            }

            if (link.localName === 'a') {
                $cms.dom.on(link, 'click', submitFunc);
            } else {
                $cms.dom.on(link, 'submit', submitFunc);
            }
        });

        function submitFunc() {
            var urlStub = '', j;

            var href = (this.localName === 'a') ? this.href : this.action;

            // Any parameters matching a pattern must be sent in the URL to the AJAX block call
            for (j = 0; j < lookFor.length; j++) {
                var matches = href.match(new RegExp('[&\?](' + lookFor[j] + ')=([^&]*)'));
                if (matches) {
                    urlStub += (urlStem.indexOf('?') === -1) ? '?' : '&';
                    urlStub += matches[1] + '=' + matches[2];
                }
            }
            for (j in extraParams) {
                urlStub += (urlStem.indexOf('?') === -1) ? '?' : '&';
                urlStub += j + '=' + encodeURIComponent(extraParams[j]);
            }

            // Any POST parameters?
            var postParams = null, param;
            if (this.localName === 'form') {
                postParams = '';
                for (j = 0; j < this.elements.length; j++) {
                    if (this.elements[j].name) {
                        param = this.elements[j].name + '=' + encodeURIComponent($cms.form.cleverFindValue(this, this.elements[j]));

                        if ((!this.method) || (this.method.toLowerCase() !== 'get')) {
                            if (postParams != '') {
                                postParams += '&';
                            }
                            postParams += param;
                        } else {
                            urlStub += (urlStem.indexOf('?') === -1) ? '?' : '&';
                            urlStub += param;
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
            $cms.callBlock(urlStem + urlStub, '', blockElement, append, false, postParams).then(function () {
                if (scrollToTop) {
                    scrollTo(0, blockPosY);
                }
            });
            return false;
        }
    }
}());

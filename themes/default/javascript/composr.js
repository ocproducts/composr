(function ($){
    'use strict';

    var Composr = {};

    bindSymbols();

    var loadPolyfillsPromise = new Promise(function(resolve) {
        loadPolyfills(resolve);
    });

    var domReadyPromise = new Promise(function(resolve) {
        if (document.readyState === 'interactive') {
            resolve();
        } else {
            $(function () {
                resolve();
            });
        }
    });

    var windowLoadPromise = new Promise(function (resolve) {
        if (document.readyState === 'complete') {
            resolve();
        }  else {
            window.addEventListener('load', function () {
                resolve();
            });
        }
    });

    Composr.ready = Promise.all([loadPolyfillsPromise, domReadyPromise]);
    Composr.loadWindow = Promise.all([Composr.ready, windowLoadPromise]);

    /**
     * Helper to rethrow errors asynchronously.
     *
     * This way Errors bubbles up outside of the original callstack, making it
     * easier to debug errors in the browser.
     *
     * @param Error|string error
     *   The error to be thrown.
     */
    Composr.throwError = function (error) {
        setTimeout(function () { throw error; }, 0);
    };

    var composrSettings = {};

    /* Addons will add "behaviors" under this object */
    Composr.behaviors = {};

    Composr.attachBehaviors = function (context, settings) {
        context = context || document;
        settings = settings || composrSettings;
        var addons = Composr.behaviors;
        // Execute all of them.
        for (var i in addons) {
            if (!addons.hasOwnProperty(i) || (typeof addons[i] !== 'object')) {
                continue;
            }

            var behaviors = addons[i];

            for (var j in behaviors) {
                if (!behaviors.hasOwnProperty(j) || (typeof behaviors[j] !== 'object')) {
                    continue;
                }

                if (typeof behaviors[j].attach === 'function') {
                    // Don't stop the execution of behaviors in case of an error.
                    try {
                        behaviors[j].attach(context, settings);
                    } catch (e) {
                        Composr.throwError(e);
                    }
                }
            }
        }
    };

    Composr.detachBehaviors = function (context, settings, trigger) {
        context = context || document;
        settings = settings || composrSettings;
        trigger = trigger || 'unload';
        var behaviors = Composr.behaviors;
        // Execute all of them.
        for (var i in behaviors) {
            if (behaviors.hasOwnProperty(i) && typeof behaviors[i].detach === 'function') {
                // Don't stop the execution of behaviors in case of an error.
                try {
                    behaviors[i].detach(context, settings, trigger);
                }
                catch (e) {
                    Composr.throwError(e);
                }
            }
        }
    };

    /* Addons will add template related methods under this object */
    Composr.templates = {};

    Composr.initializeTemplates = function initializeTemplates(context, addonName) {
        addonName = addonName.replace('_', '-');

        $('[data-tpl-' + addonName + ']', context).each(function () {
            var datasetProperty = Composr.utils.camelCase('tpl-' + addonName),
                funcName = this.dataset[datasetProperty].trim(),
                addonArgs = '',
                args = [];

            if (typeof this.dataset.tplArgs === 'string') { // Arguments provided in the data-tpl-args attribute
                addonArgs = this.dataset.tplArgs.trim();
            } else if ((this.nodeName === 'SCRIPT') && (this.type === 'application/json')) { // Arguments provided inside the <script> tag
                addonArgs = this.innerHTML.trim();
            }

            if (addonArgs !== '') {
                var _args;

                try {
                    _args = JSON.parse(addonArgs);
                } catch (e) {
                    Composr.throwError(e);
                }

                if (_args) {
                    args = _args;
                }

                if (!Array.isArray(args)) {
                    args = [args];
                }
            }

            var addonNameCamelCased = Composr.utils.camelCase(addonName);
            var func = Composr.templates[addonNameCamelCased] ? Composr.templates[addonNameCamelCased][funcName] : null;

            if (typeof func === 'function') {
                func.apply(this, args);
            }
        });
    };

    /* Addons will add Backbone.View subclasses under this object */
    Composr.views = {};

    /* General utility methods */
    Composr.utils = {};

    // Credit: http://stackoverflow.com/a/32604073/362006
    Composr.utils.camelCase = function camelCase(str) {
        // Lower cases the string
        return str.toLowerCase()
            // Replaces any - or _ characters with a space
            .replace( /[-_]+/g, ' ')
            // Removes any non alphanumeric characters
            .replace( /[^\w\s]/g, '')
            // Uppercases the first character in each group immediately following a space
            // (delimited by spaces)
            .replace( / (.)/g, function($1) { return $1.toUpperCase(); })
            // Removes spaces
            .replace( / /g, '' );
    };

    /* DOM helper methods */
    Composr.dom = {};

    /* Returns the provided element's width excluding padding and borders */
    Composr.dom.contentWidth = function contentWidth(element) {
        var cs = getComputedStyle(element),
            padding = parseFloat(cs.paddingLeft) + parseFloat(cs.paddingRight),
            border = parseFloat(cs.borderLeftWidth) + parseFloat(cs.borderRightWidth);

        return element.offsetWidth - padding - border;
    };

    /* Returns the provided element's height excluding padding and border */
    Composr.dom.contentHeight = function contentHeigt(element) {
        var cs = getComputedStyle(element),
            padding = parseFloat(cs.paddingTop) + parseFloat(cs.paddingBottom),
            border = parseFloat(cs.borderTopWidth) + parseFloat(cs.borderBottomWidth);

        return element.offsetHeight - padding - border;
    };

    function bindSymbols() {
        var data = JSON.parse(document.getElementsByName('composr-symbol-data')[0].content);
        Composr.$PAGE_TITLE = data.PAGE_TITLE;
        Composr.$MEMBER = data.MEMBER;
        Composr.$IS_GUEST = data.IS_GUEST;
        Composr.$USERNAME = data.USERNAME;
        Composr.$AVATAR = data.AVATAR;
        Composr.$MEMBER_EMAIL = data.MEMBER_EMAIL;
        Composr.$PHOTO = data.PHOTO;
        Composr.$MEMBER_PROFILE_URL = data.MEMBER_PROFILE_URL;
        Composr.$FROM_TIMESTAMP = data.FROM_TIMESTAMP;
        Composr.$MOBILE = data.MOBILE;
        Composr.$THEME = data.THEME;
        Composr.$JS_ON = data.JS_ON;
        Composr.$LANG = data.LANG;
        Composr.$BROWSER_UA = data.BROWSER_UA;
        Composr.$OS = data.OS;
        Composr.$DEV_MODE = data.DEV_MODE;
        Composr.$USER_AGENT = data.USER_AGENT;
        Composr.$IP_ADDRESS = data.IP_ADDRESS;
        Composr.$TIMEZONE = data.TIMEZONE;
        Composr.$HTTP_STATUS_CODE = data.HTTP_STATUS_CODE;
        Composr.$CHARSET = data.CHARSET;
        Composr.$KEEP = data.KEEP;
        Composr.$SITE_NAME = data.SITE_NAME;
        Composr.$COPYRIGHT = data.COPYRIGHT;
        Composr.$DOMAIN = data.DOMAIN;
        Composr.$FORUM_BASE_URL = data.FORUM_BASE_URL;
        Composr.$BASE_URL = data.BASE_URL;
        Composr.$BRAND_NAME = data.BRAND_NAME;
        Composr.$IS_STAFF = data.IS_STAFF;
        Composr.$IS_ADMIN = data.IS_ADMIN;
        Composr.$VERSION = data.VERSION;
        Composr.$COOKIE_PATH = data.COOKIE_PATH;
        Composr.$COOKIE_DOMAIN = data.COOKIE_DOMAIN;
        Composr.$IS_A_COOKIE_LOGIN = data.IS_A_COOKIE_LOGIN;
        Composr.$SESSION_COOKIE_NAME = data.SESSION_COOKIE_NAME;
        Composr.$GROUP_ID = data.GROUP_ID;
    }

    function loadPolyfills(callback) {
        var scriptsToLoad = 0,
            scriptsLoaded = 0;

        // Credit: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/String/includes
        if (typeof String.prototype.includes === 'undefined') {
            String.prototype.includes = function(search, start) {
                if (typeof start !== 'number') {
                    start = 0;
                }

                if (start + search.length > this.length) {
                    return false;
                } else {
                    return this.indexOf(search, start) !== -1;
                }
            };
        }

        if (typeof NodeList.prototype.forEach === 'undefined') {
            // Only Chrome has native support as of writing
            NodeList.prototype.forEach = Array.prototype.forEach;
        }

        if (typeof window.CustomEvent !== 'function') {
            polyfillCustomEvent();
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

        if (typeof window.URLSearchParams === 'undefined') {
            loadScript(Composr.$BASE_URL + '/data/polyfills/url-search-params.max.js');
        }

        if (scriptsToLoad === 0) {
            callback();
        }
    }

    // Credit: https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent/CustomEvent
    function polyfillCustomEvent() {
        function CustomEvent ( event, params ) {
            params = params || { bubbles: false, cancelable: false, detail: undefined };
            var evt = document.createEvent( 'CustomEvent' );
            evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
            return evt;
        }

        CustomEvent.prototype = window.Event.prototype;

        window.CustomEvent = CustomEvent;
    }

    Composr.ready.then(function () {
        Composr.attachBehaviors(document, {});
    });

    Composr.behaviors.composr = {
        initialize: {
            attach: function (context) {
                // Set global variables (into the window object)
                $('[data-cms-globals]', context).each(function () {
                    var globals = this.dataset.cmsGlobals.trim();
                    if (globals) {
                        globals = JSON.parse(globals);

                        for (var name in globals) {
                            if (globals.hasOwnProperty(name)) {
                                window[name] = globals[name];
                            }
                        }
                    }
                });

                // Call a global function, optionally with arguments. Inside the function, "this" will be the element calling that function.
                $('[data-cms-call]', context).each(function () {
                    var funcName = this.dataset.cmsCall.trim(),
                        cmsCallArgs = typeof this.dataset.cmsCallArgs === 'string' ? this.dataset.cmsCallArgs.trim() : '',
                        args = [];

                    if (cmsCallArgs !== '') {
                        let _args;

                        try {
                            _args = JSON.parse(this.dataset.cmsCallArgs);
                        } catch (e) {
                            Composr.throwError(e);
                        }

                        if (_args) {
                            args = _args;
                        }

                        if (!Array.isArray(args)) {
                            args = [args];
                        }
                    }

                    var func = window[funcName];

                    if (typeof func === 'function') {
                        func.apply(this, args);
                    }
                });

                // Select2 plugin hook
                $('[data-cms-select2]', context).each(function () {
                    var options = {};

                    if (this.dataset.cmsSelect2.trim()) {
                        options = JSON.parse(this.dataset.cmsSelect2);
                    }

                    $(this).select2(options);
                });

                // TODO
                // tree_list.js
                $('[data-cms-tree-list]', context).each(function () {
                    var options = {}, defaults = {};

                    if (this.dataset.cmsTreeList.trim()) {
                        options = JSON.parse(this.dataset.cmsTreeList);
                    }

                });
            }
        }
    };

    return window.Composr = Composr;
})(window.jQuery || window.Zepto);
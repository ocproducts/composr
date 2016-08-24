(function ($){
    'use strict';

    var data = JSON.parse(document.getElementsByName('composr-symbol-data')[0].content);

    var Composr = {
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
        $GROUP_ID: data.GROUP_ID
    };

    var loadPolyfillsPromise = new Promise(function(resolve) {
        loadPolyfills(resolve);
    });

    loadPolyfillsPromise.then(function () {
        Composr.queryString = new URLSearchParams(window.location.search);
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

    Composr.noop = function noop() {};

    /* Used to check strings */
    Composr.isEmptyOrZero = function isEmptyOrZero(str) {
        if (!str || !str.trim() || (str.trim() === '0')) {
            return true;
        }

        return false;
    };

    /* Used for specifying required arguments */
    Composr.required = function (obj, keys) {
        if (!Array.isArray(keys)) {
            throw new Error('Parameter \'keys\' must be an array.');
        }

        for (var i = 0; i < keys.length; i++) {
            if (!obj.hasOwnProperty(keys[i])) {
                throw new Error('Object is missing a required key: \''+ keys[i] + '\'.');
            }
        }
    };

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
        var addons = Composr.behaviors;

        context = context || document;
        settings = settings || composrSettings;

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
        var addons = Composr.behaviors;

        context = context || document;
        settings = settings || composrSettings;
        trigger = trigger || 'unload';

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

                if (typeof behaviors[j].detach === 'function') {
                    // Don't stop the execution of behaviors in case of an error.
                    try {
                        behaviors[j].detach(context, settings, trigger);
                    } catch (e) {
                        Composr.throwError(e);
                    }
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
                addonArgs = this.textContent.trim();
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

    /* Tempcode filters ported to JS */

    Composr.filter = function (filterSymbol, str) {
        switch (filterSymbol) {
            case '~':
                return Composr.filters.stripNewLines(str);

            case '|':
                return Composr.filters.identifier(str);

            default:
                throw new Error('Invalid value provided for argument \'filterChar\'.');
        }
    };

    Composr.filters = {};

    Composr.filters.stripNewLines = function (str) {
        if (typeof str !== 'string') {
            throw new Error('Invalid argument type: \'str\' must be a string.');
        }

        return str.replace(/[\r\n]/g, '');
    };

    Composr.filters.identifier = function (str) {
        var length, out, i, char, ascii;

        if (typeof str !== 'string') {
            throw new Error('Invalid argument type: \'str\' must be a string.');
        }

        length = str.length;
        out = '';

        for (i = 0; i < length; i++) {
            char = str[i];

            switch (char) {
                case '[':
                    out += '_opensquare_';
                    break;
                case ']':
                    out += '_closesquare_';
                    break;
                case '&#039;':
                case '\'':
                    out += '_apostophe_';
                    break;
                case '-':
                    out += '_minus_';
                    break;
                case ' ':
                    out += '_space_';
                    break;
                case '+':
                    out += '_plus_';
                    break;
                case '*':
                    out += '_star_';
                    break;
                case '/':
                    out += '__';
                    break;
                default:
                    ascii = char.charCodeAt(0);

                    if (((i !== 0) && (char === '_')) || ((ascii >= 48) && (ascii <= 57)) || ((ascii >= 65) && (ascii <= 90)) || ((ascii >= 97) && (ascii <= 122))) {
                        out += char;
                    } else {
                        out += '_' + ascii + '_';
                    }
                    break;
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
    Composr.utils = {};

    // Returns a random integer between min (inclusive) and max (inclusive)
    // Using Math.round() will give you a non-uniform distribution!
    Composr.utils.random = function random(min, max) {
        if (typeof min === 'undefined') {
            min = 0;
        }

        if (typeof max === 'undefined') {
            max = 4294967295;
        }

        return Math.floor(Math.random() * (max - min + 1)) + min;
    };

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

    Composr.behaviors.composr = {
        initialize: {
            attach: function (context) {
                // Call a global function, optionally with arguments. Inside the function scope, "this" will be the element calling that function.
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

    Composr.ready.then(function () {
        Composr.attachBehaviors(document, {});
    });

    return window.Composr = Composr;
})(window.jQuery || window.Zepto);
(function ($, data) {
    'use strict';
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
            $GROUP_ID: data.GROUP_ID,
            $CONFIG_OPTION: data.CONFIG_OPTION,
            $VALUE_OPTION: data.VALUE_OPTION,
            // Just some additonal stuff, not a tempcode symbol
            $EXTRA: data.EXTRA
        },
        elProto   = HTMLElement.prototype,
        elMatches = Function.bind.call(Function.call, elProto.matches || elProto.webkitMatchesSelector || elProto.msMatchesSelector),
        arrProto  = Array.prototype,
        toArray   = Function.bind.call(Function.call, arrProto.slice),
        forEach   = Function.bind.call(Function.call, arrProto.forEach),
        defined   = function (v) { return v !== undefined; },
        noop      = function () {},

        loadPolyfillsPromise = new Promise(function (resolve) {
            loadPolyfills(resolve);
        }),

        domReadyPromise = new Promise(function (resolve) {
            if (document.readyState === 'interactive') {
                resolve();
            } else {
                document.addEventListener('DOMContentLoaded', function () {
                    resolve();
                });
            }
        }),

        windowLoadPromise = new Promise(function (resolve) {
            if (document.readyState === 'complete') {
                resolve();
            } else {
                window.addEventListener('load', function () {
                    resolve();
                });
            }
        });

    loadPolyfillsPromise.then(function () {
        Composr.queryString = new window.URLSearchParams(window.location.search);
    });

    Composr.ready = Promise.all([loadPolyfillsPromise, domReadyPromise]);
    Composr.loadWindow = Promise.all([Composr.ready, windowLoadPromise]);

    /* String interpolation */
    Composr.str = function (format) {
        var args = arrProto.slice.call(arguments, 1);
        return format.replace(/\{(\d+)\}/g, function (match, number) {
            return args[number] !== undefined ? args[number] : match;
        });
    };

    /* Generate url */
    Composr.url = function (path) {
        return Composr.$BASE_URL + '/' + path;
    };

    /* Mainly used to check tempcode values, since in JavaScript '0' (string) is true */
    Composr.isFalsy = function isFalsy(val) {
        return !val || (val.length === 0) || !val.trim() || (val.trim() === '0');
    };

    Composr.areFalsy = function areFalsy() {
        var i = 0, len = arguments.length;

        while (i < len) {
            if (!Composr.isFalsy(arguments[i])) {
                return false;
            }
            i++;
        }

        return true;
    };

    Composr.isTruthy = function isTruthy(val) {
        return !Composr.isFalsy(val);
    };

    Composr.areTruthy = function areTruthy() {
        return !Composr.areFalsy.apply(this, arguments);
    };

    Composr.areDefined = function areDefined() {
        var i = 0, len = arguments.length;

        while (i < len) {
            if (arguments[i] === undefined) {
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
                throw new Error('Object is missing a required key: \''+ keys[i] + '\'.');
            }
        }
    };

    Composr.log    = Composr.$DEV_MODE ? console.log : noop;
    Composr.assert = Composr.$DEV_MODE ? console.assert : noop;
    Composr.error  = Composr.$DEV_MODE ? console.error : noop;

    Composr.settings = {};

    /* Addons will add "behaviors" under this object */
    Composr.behaviors = {};

    Composr.attachBehaviors = function (context, settings) {
        var addons = Composr.behaviors, i, behaviors, j;

        if (!(context instanceof HTMLDocument) && !(context instanceof HTMLElement)) {
            throw new Error('Invalid argument type: \'context\' must be of type HTMLDocument or HTMLElement');
        }

        settings = settings || Composr.settings;

        // Execute all of them.
        for (i in addons) {
            if (addons.hasOwnProperty(i) && (typeof addons[i] === 'object')) {
                behaviors = addons[i];

                for (j in behaviors) {
                    if (behaviors.hasOwnProperty(j) && (typeof behaviors[j] === 'object') && (typeof behaviors[j].attach === 'function')) {
                        try {
                            behaviors[j].attach(context, settings);
                        } catch (e) {
                            Composr.error('Error while attaching behavior \'' + j + '\' of addon \'' + i + '\'', e);
                        }
                    }
                }
            }
        }
    };

    Composr.detachBehaviors = function (context, settings, trigger) {
        var addons = Composr.behaviors, i, behaviors, j;

        if (!(context instanceof HTMLDocument) && !(context instanceof HTMLElement)) {
            throw new Error('Invalid argument type: \'context\' must be of type HTMLDocument or HTMLElement');
        }

        settings = settings || Composr.settings;
        trigger = trigger || 'unload';

        // Execute all of them.
        for (i in addons) {
            if (addons.hasOwnProperty(i) && (typeof addons[i] === 'object')) {
                behaviors = addons[i];

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

        forEach(context.querySelectorAll('[data-tpl-' + addonName + ']'), function (el) {
            var funcName = el.dataset[Composr.utils.camelCase('tpl-' + addonName)].trim(),
                addonArgs = '',
                args = [];

            if ((el.nodeName === 'SCRIPT') && (el.type === 'application/json')) {
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

            var addonNameCamelCased = Composr.utils.camelCase(addonName);
            var func = Composr.templates[addonNameCamelCased] ? Composr.templates[addonNameCamelCased][funcName] : null;

            if (typeof func === 'function') {
                func.apply(el.nodeName !== 'SCRIPT' ? el : context, args);
            }
        });
    };

    Composr.View = Backbone.View.extend({
        options: null,
        initialize: function (viewOptions, options) {
            this.options = options || {};
        }
    });

    /* Addons will add Composr.View subclasses under this object */
    Composr.views = {};

    Composr.initializeViews = function (context, addonName) {
        var View, addonNameKibab = addonName.replace(/_/g, '-'),
            addonNameCamelCase = Composr.utils.camelCase(addonName);

        forEach(context.querySelectorAll('[data-view-' + addonNameKibab + ']'), function (el) {
            var viewClasses = Composr.views[addonNameCamelCase],
                viewClassName = el.dataset[Composr.utils.camelCase('view-' + addonNameKibab)].trim(),
                options = Composr.parseDataObject(el.dataset.viewArgs);

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

    Composr.filters.id = Composr.filters.identifier = function (str) {
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
    Composr.utils = {};

    // Returns a random integer between min (inclusive) and max (inclusive)
    // Using Math.round() will give you a non-uniform distribution!
    Composr.utils.random = function random(min, max) {
        if (min === undefined) {
            min = 0;
        }

        if (max === undefined) {
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
            .replace( / (.)/g, function ($1) { return $1.toUpperCase(); })
            // Removes spaces
            .replace( / /g, '' );
    };

    /* DOM helper methods */
    Composr.dom = {};

    // Returns a single matching child element
    Composr.dom.$ = function (el, selector) {
        if (arguments.length === 1) {
            selector = el;
            el = document;
        }

        return el.querySelector(selector);
    };

    // Returns an array with matching child elements
    Composr.dom.$$ = function (el, selector) {
        if (arguments.length === 1) {
            selector = el;
            el = document;
        }

        return toArray(el.querySelectorAll(selector));
    };

    // This one (3 dollarydoos) also includes the parent element (at offset 0) if it matches the selector
    Composr.dom.$$$ = function (el, selector) {
        var els;

        if (!defined(el) || !defined(selector)) {
            throw new Error('Composr.dom.$$$() requires two arguments.');
        }

        els = toArray(el.querySelectorAll(selector));

        if (Composr.dom.matches(el, selector)) {
            els.unshift(el);
        }

        return els;
    };

    Composr.dom.html = function (el, html) {
        // Parser hint: .innerHTML okay
        var i, len;

        if (html === undefined) {
            return el.innerHTML;
        }

        if (el.children.length !== 0) {
            for (i = 0, len = el.children.length; i < len; i++) {
                // Detach behaviors from the elements to be deleted
                Composr.detachBehaviors(el.children[i]);
            }
        }

        el.innerHTML = html;

        if (el.children.length === 0) {
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
            ref = el.nextSibling, c, ci;

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

    // Check if the given element matches selector
    Composr.dom.matches = function (el, selector) {
        return (el instanceof HTMLElement) && elMatches(el, selector);
    };

    // Get nearest parent (or itself) element matching selector
    Composr.dom.closest = function closest(el, selector) {
        return (!el || Composr.dom.matches(el, selector)) ? el : closest(el.parentElement, selector);
    };

    Composr.parseDataObject = function (data, defaults) {
        data = typeof data === 'string' ? data.trim() : '';
        defaults = defaults || {};

        if ((data !== '') && (data !== '{}') && (data !== '1')) {
            try {
                data = JSON.parse(data);

                if (data && (typeof data === 'object')) {
                    return _.defaults(data, defaults);
                }
            } catch (ex) {
                Composr.error('Composr.parseDataArgs(), error parsing JSON: ' + data, ex);
                return defaults;
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
        var buttons = form.querySelectorAll('input[type="submit"], input[type="button"], input[type="image"], button');

        forEach(buttons, function (btn) {
            Composr.ui.disableButton(btn, permanent);
        });
    };

    // This is kinda dumb, ported from checking.js, originally named as disable_buttons_just_clicked()
    Composr.ui.disableSubmitAndPreviewButtons = function (permanent) {
        // [accesskey="u"] identifies submit button, [accesskey="p"] identifies preview button
        var buttons = document.querySelectorAll('input[accesskey="u"], button[accesskey="u"], input[accesskey="p"], button[accesskey="p"]');

        if (permanent === undefined) {
            permanent = false;
        }

        forEach(buttons, function (btn) {
            if (!btn.disabled && !btn.under_timer) {// We do not want to interfere with other code potentially operating
                Composr.ui.disableButton(btn, permanent);
            }
        });
    };

    Composr.audio = {};

    window.Composr = Composr;

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

        if (scriptsToLoad === 0) {
            callback();
        }
    }
})(window.jQuery || window.Zepto, JSON.parse(document.getElementsByName('composr-symbol-data')[0].content));
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
        // Just some additonal stuff, not a tempcode symbol
        $EXTRA: data.EXTRA
    },
        arrProto = Array.prototype,
        forEach = Function.bind.call(Function.call, arrProto.forEach),

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

    function loadPolyfills(callback) {
        var scriptsToLoad = 0,
            scriptsLoaded = 0;

        // Credit: https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/String/includes
        if (typeof String.prototype.includes === 'undefined') {
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

        if (typeof window.URLSearchParams === 'undefined') {
            loadScript(Composr.$BASE_URL + '/data/polyfills/url-search-params.max.js');
        }

        if (scriptsToLoad === 0) {
            callback();
        }
    }

    Composr.ready = Promise.all([loadPolyfillsPromise, domReadyPromise]);
    Composr.loadWindow = Promise.all([Composr.ready, windowLoadPromise]);

    Composr.noop = function noop() {};

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
            if (Composr.isTruthy(arguments[i])) {
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
        var i = 0, len = arguments.length;

        while (i < len) {
            if (Composr.isFalsy(arguments[i])) {
                return false;
            }
            i++;
        }

        return true;
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
        var addons = Composr.behaviors, i, behaviors, j;

        context = context || document;
        settings = settings || composrSettings;

        // Execute all of them.
        for (i in addons) {
            if (!addons.hasOwnProperty(i) || (typeof addons[i] !== 'object')) {
                continue;
            }

            behaviors = addons[i];

            for (j in behaviors) {
                if (!behaviors.hasOwnProperty(j) || (typeof behaviors[j] !== 'object')) {
                    continue;
                }

                if (typeof behaviors[j].attach === 'function') {
                    // Don't stop the execution of behaviors in case of an error.
                    //try {
                    behaviors[j].attach(context, settings);
                    //} catch (e) {
                    //    Composr.throwError(e + ' while attaching behavior ' + j + ' of addon ' + i);
                    //}
                }
            }
        }
    };

    Composr.detachBehaviors = function (context, settings, trigger) {
        var addons = Composr.behaviors, i, behaviors;

        context = context || document;
        settings = settings || composrSettings;
        trigger = trigger || 'unload';

        // Execute all of them.
        for (i in addons) {
            if (!addons.hasOwnProperty(i) || (typeof addons[i] !== 'object')) {
                continue;
            }

            behaviors = addons[i];

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
                var _args;

                //try {
                    _args = JSON.parse(addonArgs);
                //} catch (e) {
                //    Composr.throwError(e);
                //}

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
                func.apply(el.nodeName !== 'SCRIPT' ? el : context, args);
            } else if ((typeof func === 'object') && (func !== null)) {

            }
        });
    };

    /* Addons will add Backbone.View subclasses under this object */
    Composr.views = {};

    /* Tempcode filters ported to JS */
    Composr.filter = function (str, filterSymbols) {
        var i;

        for (i = 0; i < filterSymbols.length; i++) {
            switch (filterSymbols[i]) {
                case '&':
                    str = Composr.filters.urlEncode(str);
                    break;

                case '~':
                    str = Composr.filters.stripNewLines(str);
                    break;

                case '|':
                    str = Composr.filters.identifier(str);
                    break;

                default:
                    throw new Error('Invalid value provided for argument \'filterSymbols\'.');
            }
        }

        return str;
    };

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

    Composr.dom.$$ = function (selector, context) {
        return arrProto.slice.call((context || document).querySelectorAll(selector));
    };

    // Get nearest parent (or itself) element matching selector
    Composr.dom.closest = (function() {
        var proto = HTMLElement.prototype,
            matches = proto.matches || proto.webkitMatchesSelector || proto.mozMatchesSelector || proto.msMatchesSelector;

        return function closest(el, selector) {
            return (!el || matches.call(el, selector)) ? el : closest(el.parentElement, selector);
        };
    })();

    Composr.behaviors.composr = {
        initialize: {
            attach: function (context /** @type Document|HTMLElement */) {
                // Call a global function, optionally with arguments. Inside the function scope, "this" will be the element calling that function.
                forEach(context.querySelectorAll('[data-cms-call]'), function (el) {
                    var funcName = el.dataset.cmsCall.trim(),
                        cmsCallArgs = typeof el.dataset.cmsCallArgs === 'string' ? el.dataset.cmsCallArgs.trim() : '',
                        args = [], _args;

                    if (cmsCallArgs !== '') {
                        try {
                            _args = JSON.parse(el.dataset.cmsCallArgs);
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
                        func.apply(el, args);
                    }
                });

                // Select2 plugin hook
                forEach(context.querySelectorAll('[data-cms-select2]'), function (el) {
                    var options = {};

                    if (el.dataset.cmsSelect2.trim()) {
                        options = JSON.parse(el.dataset.cmsSelect2);
                    }

                    $(el).select2(options);
                });
            }
        }
    };

    Composr.views = {};

    Composr.views.core = {};

    Composr.views.core.View = Backbone.View.extend({});

    Composr.views.core.Global = Composr.views.core.View.extend({
        events: {
          // Prevent url change for clicks on anchor tags with a placeholder href
          'click a[href$="#!"]': function (e) {
              e.preventDefault();
          },

          'click [data-disable-after-click]': function (e) {
              disable_button_just_clicked(e.target);
          },

          'click [data-open-as-overlay]': function (e) {
              var ob = e.target,
                  url = (typeof ob.href === 'undefined') ? ob.action : ob.href;

              if (Composr.isFalsy(Composr.$CONFIG_OPTION.jsOverlays)) {
                  return;
              }

              if (/:\/\/(.[^/]+)/.exec(url)[1] != window.location.hostname) {
                  return; // Cannot overlay, different domain
              }

              e.preventDefault();
              open_link_as_overlay(e.target)
          }
        },

        options: null,

        initialize: function initialize(viewOptions, options) {
            this.options = options;
        },

        render: function render() {

        }
    });

    Composr.ready.then(function () {
        var global = new Composr.views.core.Global({
            el: document.documentElement
        });

        Composr.attachBehaviors();
    });

    window.Composr = Composr;

    function open_link_as_overlay(ob, width, height, target) {
        var url = (typeof ob.href === 'undefined') ? ob.action : ob.href;

        if ((typeof width === 'undefined') || (!width)) {
            width = '800';
        }
        if ((typeof height === 'undefined') || (!height)) {
            height = 'auto';
        }
        if ((typeof target === 'undefined') || (!target)) {
            target = '_top';
        }

        var url_stripped = url.replace(/#.*/, '');
        var new_url = url_stripped + ((url_stripped.indexOf('?') == -1) ? '?' : '&') + 'wide_high=1' + url.replace(/^[^\#]+/, '');
        faux_open(new_url, null, 'width=' + width + ';height=' + height, target);
    }

    function disable_button_just_clicked(input, permanent) {
        if (typeof permanent === 'undefined') {
            permanent = false;
        }

        if (input.nodeName === 'FORM') {
            for (var i = 0; i < input.elements.length; i++) {
                if ((input.elements[i].type === 'submit') || (input.elements[i].type === 'button') || (input.elements[i].type === 'image') || (input.elements[i].nodeName === 'BUTTON')) {
                    disable_button_just_clicked(input.elements[i]);
                }
            }

            return;
        }

        if (input.form.target === '_blank') {
            return;
        }

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
        } else {
            input.under_timer = false;
        }

        window.addEventListener('pagehide', goback);
    }
})(window.jQuery || window.Zepto, JSON.parse(document.getElementsByName('composr-symbol-data')[0].content));
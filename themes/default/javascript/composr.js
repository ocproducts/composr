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
        undef     = function (v) { return v === undefined; },
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

        context = context || document;
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
                            Composr.error('Error while attaching behavior ' + j + ' of addon ' + i, e);
                        }
                    }
                }
            }
        }
    };

    Composr.detachBehaviors = function (context, settings, trigger) {
        var addons = Composr.behaviors, i, behaviors, j;

        context = context || document;
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
                            Composr.error(e);
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

    Composr.filters.identifier = function (str) {
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
        // Parser hint: .innerHTML okay
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
        // Parser hint: .innerHTML okay
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
    Composr.dom.matches = function(el, selector) {
        return (el instanceof HTMLElement) && elMatches(el, selector);
    };

    // Get nearest parent (or itself) element matching selector
    Composr.dom.closest = function closest(el, selector) {
        return (!el || Composr.dom.matches(el, selector)) ? el : closest(el.parentElement, selector);
    };

    Composr.parseDataObject = function (data, defaults) {
        data = data.trim();
        defaults = defaults || {};

        if (data && (data !== '{}') && (data !== '1')) {
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

    var Global = Composr.View.extend({
        initialize: function initialize(viewOptions, options) {
            this.options = options || {};
        },

        events: {
            // Prevent url change for clicks on anchor tags with a placeholder href
            'click a[href$="#!"]': function (e) {
                e.preventDefault();
            },

            'click [data-disable-on-click]': function (e) {
                Composr.ui.disableButton(e.target);
            },

            'submit form[data-disable-buttons-on-submit]': function (e) {
                Composr.ui.disableFormButtons(e.target);
            },

            'click [data-open-as-overlay]': function (e) {
                var el = e.target, args,
                    url = (el.href === undefined) ? el.action : el.href;

                if (Composr.isFalsy(Composr.$CONFIG_OPTION.jsOverlays)) {
                    return;
                }

                if (/:\/\/(.[^/]+)/.exec(url)[1] !== window.location.hostname) {
                    return; // Cannot overlay, different domain
                }

                e.preventDefault();

                args = Composr.parseDataObject(el.dataset.openAsOverlay);
                args.el = el;

                openLinkAsOverlay(args);
            },

            // Lightboxes
            'click a[rel*="lightbox"]': function (e) {
                var el = e.target;

                if (Composr.isFalsy(Composr.$CONFIG_OPTION.jsOverlays)) {
                    return;
                }

                e.preventDefault();

                if (el.querySelectorAll('img').length > 0 || el.querySelectorAll('video').length > 0) {
                    open_image_into_lightbox(el);
                } else {
                    openLinkAsOverlay({el: el});
                }
            }
        }
    });

    Composr.views.core = {
        Global: Global
    };

    Composr.ready.then(function () {
        var global = new Composr.views.core.Global({
            el: document.documentElement
        });

        Composr.attachBehaviors();
    });

    window.Composr = Composr;


    Composr.behaviors.composr = {
        initialize: {
            attach: function (context) {
            }
        },

        initializeAnchors: {
            attach: function (context) {
                var anchors = Composr.dom.$$$(context, 'a');

                anchors.forEach(function (anchor) {
                    if (Composr.isTruthy(Composr.$CONFIG_OPTION.jsOverlays)) {
                        // Lightboxes
                        if (anchor.rel && anchor.rel.match(/lightbox/)) {
                            anchor.title = anchor.title.replace('{!LINK_NEW_WINDOW;}', '').trim();
                        }

                        // Convert <a> title attributes into Composr tooltips
                        if (!anchor.classList.contains('no_tooltip')) {
                            convert_tooltip(anchor);
                        }
                    }

                    // Keep parameters need propagating
                    if  (Composr.$VALUE_OPTION.jsKeepParams) {
                        if (anchor.href && anchor.href.indexOf(Composr.$BASE_URL + '/') === 0) {
                            anchor.href += keep_stub(!anchor.href.includes('?'), true, anchor.href);
                        }
                    }
                });
            }
        },

        initializeForms: {
            attach: function (context) {
                var forms = Composr.dom.$$$(context, 'form');

                forms.forEach(function (form) {
                    // HTML editor
                    if (window.load_html_edit !== undefined) {
                        load_html_edit(form);
                    }

                    // Remove tooltips from forms as they are for screenreader accessibility only
                    form.title = '';

                    // Convert a/img title attributes into Composr tooltips
                    if (Composr.isTruthy(Composr.$CONFIG_OPTION.jsOverlays)) {
                        // Convert title attributes into Composr tooltips
                        var elements, j;
                        elements = form.elements;

                        for (j = 0; j < elements.length; j++) {
                            if (elements[j].title !== undefined) {
                                convert_tooltip(elements[j]);
                            }
                        }

                        elements = form.querySelectorAll('input[type="image"][title]'); // JS DOM does not include type="image" ones in form.elements
                        for (j = 0; j < elements.length; j++) {
                            convert_tooltip(elements[j]);
                        }
                    }

                    if (Composr.isTruthy(Composr.$VALUE_OPTION.jsKeepParams)) {
                        /* Keep parameters need propagating */
                        if (form.action && form.action.indexOf(Composr.$BASE_URL + '/') === 0) {
                            form.action += keep_stub(form.action.indexOf('?') === -1, true, form.action);
                        }
                    }
                });
            }
        },

        // Convert img title attributes into Composr tooltips
        imageTooltips: {
            attach: function (context) {
                if (Composr.isFalsy(Composr.$CONFIG_OPTION.jsOverlays)) {
                    return;
                }

                Composr.dom.$$$(context, 'img:not(.activate_rich_semantic_tooltip)').forEach(function (img) {
                    convert_tooltip(img);
                });
            }
        },

        // Calls a global function, optionally with arguments. Inside the function scope, "this" will be the element calling that function.
        // @TODO: To be killed
        functionCalls: {
            attach: function (context) {
                var els = Composr.dom.$$$(context, '[data-cms-call]');

                els.forEach(function (el) {
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
            }
        },

        select2Plugin: {
            attach: function (context) {
                var els = Composr.dom.$$$(context, '[data-cms-select2]');

                // Select2 plugin hook
                els.forEach(function (el) {
                    var options = {};

                    if (el.dataset.cmsSelect2.trim()) {
                        options = JSON.parse(el.dataset.cmsSelect2);
                    }

                    $(el).select2(options);
                });
            }
        },

        gdTextImages: {
            attach: function (context) {
                var els = Composr.dom.$$$(context, 'img[data-gd-text]');

                els.forEach(function (img) {
                    gdImageTransform(img);
                });
            }
        }
    };

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
            span.style.transform = 'rotate(90deg)';
            span.style.transformOrigin = 'bottom left';
            span.style.top = '-1em';
            span.style.left = '0.5em';
            span.style.position = 'relative';
            span.style.display = 'inline-block';
            span.style.whiteSpace = 'nowrap';
            span.style.paddingRight = '0.5em';
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
        var defaults = {
                width: '800',
                height: 'auto',
                target: '_top'
            },
            opts = _.defaults(options, defaults),
            el = opts.el,
            url = (el.href === undefined) ? el.action : el.href,
            url_stripped = url.replace(/#.*/, ''),
            new_url = url_stripped + ((url_stripped.indexOf('?') == -1) ? '?' : '&') + 'wide_high=1' + url.replace(/^[^\#]+/, '');

        faux_open(new_url, null, 'width=' + opts.width + ';height=' + opts.height, opts.target);
    }

    function convert_tooltip(el) {
        var title = el.title;

        if ((title !== '') && !el.classList.contains('leave_native_tooltip') && !document.body.classList.contains('touch_enabled')) {
            // Remove old tooltip
            if (el.nodeName === 'IMG' && el.alt === '') {
                el.alt = el.title;
            }

            el.title = '';

            if ((!el.onmouseover) && ((el.childNodes.length == 0) || ((!el.childNodes[0].onmouseover) && ((!el.childNodes[0].title) || (el.childNodes[0].title == ''))))) {
                // ^ Only put on new tooltip if there's nothing with a tooltip inside the element
                if (el.textContent) {
                    var prefix = el.textContent + ': ';
                    if (title.substr(0, prefix.length) == prefix)
                        title = title.substring(prefix.length, title.length);
                    else if (title == el.textContent) return;
                }

                // Stop the tooltip code adding to these events, by defining our own (it will not overwrite existing events).
                if (!el.onmouseout) el.onmouseout = function () {
                };
                if (!el.onmousemove) el.onmouseover = function () {
                };

                // And now define nice listeners for it all...
                var win = get_main_cms_window(true);

                el.cms_tooltip_title = escape_html(title);

                el.addEventListener('mouseover', function (event) {
                    win.activate_tooltip(el, event, el.cms_tooltip_title, 'auto', '', null, false, false, false, false, win);
                });

                el.addEventListener('mousemove', function (event) {
                    win.reposition_tooltip(el, event, false, false, null, false, win);
                });

                el.addEventListener('mouseout', function (event) {
                    win.deactivate_tooltip(el);
                });
            }
        }
    }
})(window.jQuery || window.Zepto, JSON.parse(document.getElementsByName('composr-symbol-data')[0].content));
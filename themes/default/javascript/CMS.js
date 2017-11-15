(function ($cms, $util, $dom) {
    'use strict';
    
    var IN_MINIKERNEL_VERSION = document.documentElement.classList.contains('in-minikernel-version'),
        symbols = (!IN_MINIKERNEL_VERSION ? JSON.parse(document.getElementById('composr-symbol-data').content) : {});

    /** @namespace $cms */
    $cms = $util.extendDeep($cms, /**@lends $cms*/{
        // Load up symbols data
        /**
         * @method
         * @returns {boolean}
         */
        isGuest: $util.constant(boolVal(symbols.IS_GUEST)),
        /**
         * @method
         * @returns {boolean}
         */
        isStaff: $util.constant(boolVal(symbols.IS_STAFF)),
        /**
         * @method
         * @returns {boolean}
         */
        isAdmin: $util.constant(boolVal(symbols.IS_ADMIN)),
        /**
         * @method
         * @returns {boolean}
         */
        isHttpauthLogin: $util.constant(boolVal(symbols.IS_HTTPAUTH_LOGIN)),
        /**
         * @method
         * @returns {boolean}
         */
        isACookieLogin: $util.constant(boolVal(symbols.IS_A_COOKIE_LOGIN)),
        /**
         * @method
         * @returns {boolean}
         */
        isDevMode: $util.constant(IN_MINIKERNEL_VERSION || boolVal(symbols.DEV_MODE)),
        /**
         * @method
         * @returns {boolean}
         */
        isJsOn: $util.constant(boolVal(symbols.JS_ON)),
        /**
         * @method
         * @returns {boolean}
         */
        isMobile: $util.constant(boolVal(symbols.MOBILE)),
        /**
         * @method
         * @returns {boolean}
         */
        isForcePreviews: $util.constant(boolVal(symbols.FORCE_PREVIEWS)),
        /**
         * @method
         * @returns {boolean}
         */
        isInlineStats: $util.constant(boolVal(symbols.INLINE_STATS)),
        /**
         * @method
         * @returns {number}
         */
        httpStatusCode: $util.constant(Number(symbols.HTTP_STATUS_CODE)),
        /**
         * @method
         * @returns {string}
         */
        getPageName: $util.constant(strVal(symbols.PAGE)),
        /**
         * @method
         * @returns {string}
         */
        getZoneName: $util.constant(strVal(symbols.ZONE)),
        /**
         * @method
         * @returns {string}
         */
        getMember: $util.constant(strVal(symbols.MEMBER)),
        /**
         * @method
         * @returns {string}
         */
        getUsername: $util.constant(strVal(symbols.USERNAME)),
        /**
         * @method
         * @returns {string}
         */
        getTheme: $util.constant(strVal(symbols.THEME)),
        /**
         * @method
         * @returns {string}
         */
        userLang: $util.constant(strVal(symbols.LANG)),
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
        getSiteName: $util.constant(strVal('{$SITE_NAME;}')),
        /**
         * @method
         * @returns {string}
         */
        getBaseUrl: $util.constant(strVal('{$BASE_URL;}')),
        /**
         * @param relativeUrl - Pass a relative URL but an absolute url works as well for robustness' sake
         * @returns {string}
         */
        baseUrl: function baseUrl(relativeUrl) {
            relativeUrl = strVal(relativeUrl);

            if (relativeUrl === '') {
                return $cms.getBaseUrl();
            }

            var url = $util.url(relativeUrl).toString();

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
        getBaseUrlNohttp: $util.constant(strVal('{$BASE_URL_NOHTTP;}')),
        /**
         * @method
         * @returns {string}
         */
        getCustomBaseUrl: $util.constant(strVal('{$CUSTOM_BASE_URL;}')),
        /**
         * @method
         * @returns {string}
         */
        getCustomBaseUrlNohttp: $util.constant(strVal('{$CUSTOM_BASE_URL_NOHTTP;}')),
        /**
         * @method
         * @returns {string}
         */
        getForumBaseUrl: $util.constant(strVal('{$FORUM_BASE_URL;}')),
        /**
         * @method
         * @returns {string}
         */
        brandName: $util.constant(strVal('{$BRAND_NAME;}')),
        /**
         * @method
         * @returns {string}
         */
        getSessionCookie: $util.constant(strVal('{$SESSION_COOKIE_NAME;}')),
        /**
         * @method
         * @returns {string}
         */
        getCookiePath: $util.constant(strVal('{$COOKIE_PATH;}')),
        /**
         * @method
         * @returns {string}
         */
        getCookieDomain: $util.constant(strVal('{$COOKIE_DOMAIN;}')),
        /**
         * @method
         * @returns {string}
         */
        runningScript: $util.constant(strVal(symbols.RUNNING_SCRIPT)),
        /**
         * @method
         * @returns {string}
         */
        getCspNonce: $util.constant(strVal(symbols.CSP_NONCE)),

        /**
         * WARNING: This is a very limited subset of the $CONFIG_OPTION tempcode symbol
         * @method
         * @param {string} optionName
         * @returns {boolean|string|number}
         */
        configOption: (function () {
            if (IN_MINIKERNEL_VERSION) {
                // Installer, likely executing global.js
                return $util.constant('');
            }

            var configOptionsJson = JSON.parse('{$PUBLIC_CONFIG_OPTIONS_JSON;}');
            return function configOption(optionName) {
                if ($util.hasOwn(configOptionsJson, optionName)) {
                    return configOptionsJson[optionName];
                }

                $util.fatal('$cms.configOption(): Option "' + optionName + '" is either unsupported in JS or doesn\'t exist. Please try using the actual Tempcode symbol.');
            };
        }()),
        /**
         * @method
         * @returns {boolean}
         */
        seesJavascriptErrorAlerts: $util.constant(boolVal(symbols['sees_javascript_error_alerts'])),
        /**
         * @method
         * @returns {boolean}
         */
        canTryUrlSchemes: $util.constant(boolVal(symbols['can_try_url_schemes'])),
        /**
         * @method
         * @returns {string}
         */
        zoneDefaultPage: $util.constant(strVal(symbols['zone_default_page'])),
        /**
         * @method
         * @returns {object}
         */
        staffTooltipsUrlPatterns: $util.constant(objVal(JSON.parse('{$STAFF_TOOLTIPS_URL_PATTERNS_JSON;}'))),

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
        protectURLParameter: protectURLParameter
    });

    /**
     * Addons can add functions under this namespace
     * @namespace $cms.functions
     */
    $cms.functions = {};
    /**
     * Addons will add "behaviors" under this namespace
     * @namespace $cms.behaviors
     */
    $cms.behaviors = {};
    /**
     * @namespace $cms.ui
     */
    $cms.ui = {};
    /**
     * Addons will add template related methods under this namespace
     * @namespace $cms.templates
     */
    $cms.templates = {};
    /**
     * Addons will add $cms.View subclasses under this namespace
     * @namespace $cms.views
     */
    $cms.views = {};
    /**
     * Validation code and other general code relating to forms
     * @namespace $cms.form
     */
    $cms.form = {};

    var rgxHttp = /^https?:(?=\/\/)/i;

    /**
     * Dynamically fixes the protocol for image URLs
     * @param url
     * @returns {string}
     */
    function img(url) {
        return strVal(url).replace(rgxHttp, window.location.protocol);
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
        return $cms.pageUrl().searchParams;
    }

    function pageKeepSearchParams(forceSession) {
        var keepSp = new window.URLSearchParams();

        $util.eachIter($cms.pageSearchParams().entries(), function (entry) {
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

    var validIdRE = /^[a-zA-Z][\w:.-]*$/;
    /**
     * @private
     * @param sheetNameOrHref
     */
    function _requireCss(sheetNameOrHref) {
        var sheetName, sheetHref, sheetEl;

        if (validIdRE.test(sheetNameOrHref)) {
            sheetName = sheetNameOrHref;
            sheetHref = $util.schemeRelative('{$FIND_SCRIPT_NOHTTP;,sheet}?sheet=' + sheetName + $cms.keep());
        } else {
            sheetHref = $util.schemeRelative(sheetNameOrHref);
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

        href = $util.schemeRelative(href);

        for (var i = 0; i < els.length; i++) {
            el = els[i];
            if ($util.schemeRelative(el.href) === href) {
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
            scriptSrc = $util.schemeRelative('{$FIND_SCRIPT_NOHTTP;,javascript}?script=' + scriptName + $cms.keep());
        } else {
            scriptSrc = $util.schemeRelative(scriptNameOrSrc);
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

        src = $util.schemeRelative(src);

        for (var i = 0; i < els.length; i++) {
            el = els[i];
            if ($util.schemeRelative(el.src) === src) {
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
                return _requireJavascript(script);
            });
        });

        return $util.promiseSequence(calls);
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
     */
    function attachBehaviors(context) {
        if (!$util.isDoc(context) && !$util.isEl(context)) {
            throw new TypeError('Invalid argument type: `context` must be of type HTMLDocument or HTMLElement');
        }

        //$dom.waitForResources($dom.$$$(context, 'script[src]')).then(function () { // Wait for <script> dependencies to load
        // Execute all of them.
        var names = behaviorNamesByPriority();

        _attach(0);

        function _attach(i) {
            var name = names[i], ret;

            if ($util.isObj($cms.behaviors[name]) && (typeof $cms.behaviors[name].attach === 'function')) {
                try {
                    ret = $cms.behaviors[name].attach(context);
                    //$util.inform('$cms.attachBehaviors(): attached behavior "' + name + '" to context', context);
                } catch (e) {
                    $util.fatal('$cms.attachBehaviors(): Error while attaching behavior "' + name + '"  to', context, '\n', e);
                }
            }

            ++i;

            if (names.length <= i) {
                return;
            }

            if ($util.isPromise(ret)) { // If the behavior returns a promise, we wait for it before moving on
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
     * @param trigger
     */
    function detachBehaviors(context, trigger) {
        var name;

        if (!$util.isDoc(context) && !$util.isEl(context)) {
            throw new TypeError('Invalid argument type: `context` must be of type HTMLDocument or HTMLElement');
        }

        trigger || (trigger = 'unload');

        // Detach all of them.
        for (name in $cms.behaviors) {
            if ($util.isObj($cms.behaviors[name]) && (typeof $cms.behaviors[name].detach === 'function')) {
                try {
                    $cms.behaviors[name].detach(context, trigger);
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
        url = $util.url(url);

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
        url = $util.url(url);

        var keepSp = pageKeepSearchParams(true);

        $util.eachIter(keepSp.entries(), function (entry) {
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

    /**
     * @param functionCallsArray
     * @param [thisRef]
     */
    function executeJsFunctionCalls(functionCallsArray, thisRef) {
        if (!Array.isArray(functionCallsArray)) {
            $util.fatal('$cms.executeJsFunctionCalls(): Argument 1 must be an array, "' + $util.typeName(functionCallsArray) + '" passed');
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
    
    var networkDownAlerted = false;
    /**
     * @param {string} url
     * @param {function|null} [callback]
     * @param {string|null} [post] - Note that 'post' is not an array, it's a string (a=b)
     * @returns { Promise }
     */
    function doAjaxRequest(url, callback, post) {
        url = $util.url(url).toString();

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
}(window.$cms || (window.$cms = {}), window.$util, window.$dom));
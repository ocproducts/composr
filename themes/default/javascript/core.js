(function ($, Composr) {
    'use strict';

    Composr.ready.then(function () {
        Composr.attachBehaviors(document);
    });

    Composr.behaviors.core = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core');
                Composr.initializeTemplates(context, 'core');
            }
        },

        initializeAnchors: {
            attach: function (context) {
                var anchors = Composr.dom.$$$(context, 'a'),
                    hasBaseEl = !!document.querySelector('base');

                anchors.forEach(function (anchor) {
                    var href = anchor.href;
                    // So we can change base tag especially when on debug mode
                    if (hasBaseEl && (href.substr(0, 1) === '#')) {
                        anchor.href = window.location.href.replace(/#.*$/, '') + href;
                    }

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
                    if  (Composr.isTruthy(Composr.$VALUE_OPTION.jsKeepParams) && (href.indexOf(Composr.$BASE_URL + '/') === 0)) {
                        anchor.href += keep_stub(!anchor.href.includes('?'), true, href);
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

    var Global = Composr.View.extend({
        _stripPatternCache: null,

        initialize: function initialize() {
            Composr.View.prototype.initialize.apply(this, arguments);
            this._stripPatternCache = {};


        },

        events: {
            // Prevent url change for clicks on anchor tags with a placeholder href
            'click a[href$="#!"]': 'preventDefault',
            // Prevent form submission for forms with a placeholder action
            'submit form[action$="#!"]': 'preventDefault',

            // Disable button after click
            'click [data-disable-on-click]': 'disableButton',

            // Disable form buttons
            'submit form[data-disable-buttons-on-submit]': 'disableFormButtons',

            // Prevents input of matching characters
            'input input[data-cms-invalid-pattern]': 'invalidPattern',
            'keydown input[data-cms-invalid-pattern]': 'invalidPattern',
            'keypress input[data-cms-invalid-pattern]': 'invalidPattern',

            // Open page in overlay
            'click [data-open-as-overlay]': 'openOverlay',

            // Lightboxes
            'click a[rel*="lightbox"]': 'lightBoxes'
        },

        preventDefault: function (e) {
            e.preventDefault();
        },

        disableButton: function (e) {
            Composr.ui.disableButton(e.currentTarget);
        },

        disableFormButtons: function (e) {
            Composr.ui.disableFormButtons(e.currentTarget);
        },

        invalidPattern: function (e) {
            var input = e.currentTarget,
                pattern = input.dataset.cmsInvalidPattern,
                regex;

            regex = this._stripPatternCache[pattern] || (this._stripPatternCache[pattern] = new RegExp(pattern, 'g'));

            if (e.type === 'input') {
                // value.length is also 0 if invalid value is provided for input[type=number] et al.
                if (input.value.length === 0) {
                    input.value = '';
                } else if (regex.test(input.value)) {
                    input.value = input.value.replace(regex, '');
                }
                return;
            }

            // keydown/keypress event
            if (regex.test(Composr.dom.keyOutput(e))) {
                // pattern matched, prevent input
                e.preventDefault();
            }
        },

        openOverlay: function (e) {
            var el = e.currentTarget, args,
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

        lightBoxes: function (e) {
            var el = e.currentTarget;

            if (Composr.isFalsy(Composr.$CONFIG_OPTION.jsOverlays)) {
                return;
            }

            e.preventDefault();

            if (el.querySelectorAll('img').length > 0 || el.querySelectorAll('video').length > 0) {
                open_image_into_lightbox(el);
            } else {
                openLinkAsOverlay({el: el});
            }
        },

        setup: function () {
            var i;

            if ((window === window.top && !window.opener) || (window.name === '')) {
                window.name = '_site_opener';
            }

            // Are we dealing with a touch device?
            if (document.documentElement.ontouchstart !== undefined) {
                document.body.className += ' touch_enabled';
            }

            // Dynamic images need preloading
            var preloader = new Image();
            var images = [];

            images.push('{$IMG;,loading}'.replace(/^https?:/, window.location.protocol));
            for (i = 0; i < images.length; i++) {
                preloader.src = images[i];
            }

            // Tell the server we have JavaScript, so do not degrade things for reasons of compatibility - plus also set other things the server would like to know
            if (Composr.isTruthy(Composr.$CONFIG_OPTION.detectJavascript)) {
                set_cookie('js_on', 1, 120);
            }

            if (Composr.isTruthy(Composr.$CONFIG_OPTION.isOnTimezoneDetection)) {
                if (!window.parent || (window.parent === window)) {
                    set_cookie('client_time', new Date().toString(), 120);
                    set_cookie('client_time_ref', Composr.$FROM_TIMESTAMP, 120);
                }
            }

            // Column height balancing
            var cols = document.getElementsByClassName('col_balance_height');
            for (i = 0; i < cols.length; i++) {
                var max = null;
                for (var j = 0; j < cols.length; j++) {
                    if (cols[i].className == cols[j].className) {
                        var height = fcols[j].offsetHeight;
                        if (max === null || height > max) max = height;
                    }
                    cols[i].style.height = max + 'px';
                }
            }

            // Mouse/keyboard listening
            window.mouse_x = 0;
            window.mouse_y = 0;
            window.mouse_listener_enabled = false;
            window.ctrl_pressed = false;
            window.alt_pressed = false;
            window.meta_pressed = false;
            window.shift_pressed = false;

            window.addEventListener('click', capture_click_key_states, true); // Workaround for a dodgy firefox extension

            // Pinning to top if scroll out
            var stuck_navs = document.querySelectorAll('.stuck_nav');
            if (stuck_navs.length > 0) {
                window.addEventListener('scroll', function () {
                    for (var i = 0; i < stuck_navs.length; i++) {
                        var stuck_nav = stuck_navs[i];
                        var stuck_nav_height = (typeof stuck_nav.real_height == 'undefined') ? Composr.dom.contentHeight(stuck_nav) : stuck_nav.real_height;
                        stuck_nav.real_height = stuck_nav_height;
                        var pos_y = find_pos_y(stuck_nav.parentNode, true);
                        var footer_height = document.getElementsByTagName('footer')[0].offsetHeight;
                        var panel_bottom = document.getElementById('panel_bottom');
                        if (panel_bottom) footer_height += panel_bottom.offsetHeight;
                        panel_bottom = document.getElementById('global_messages_2');
                        if (panel_bottom) footer_height += panel_bottom.offsetHeight;
                        if (stuck_nav_height < get_window_height() - footer_height) // If there's space in the window to make it "float" between header/footer
                        {
                            var extra_height = (window.pageYOffset - pos_y);
                            if (extra_height > 0) {
                                var width = Composr.dom.contentWidth(stuck_nav);
                                var height = Composr.dom.contentHeight(stuck_nav);
                                var stuck_nav_width = Composr.dom.contentWidth(stuck_nav);
                                if (!window.getComputedStyle(stuck_nav).getPropertyValue('width')) // May be centered or something, we should be careful
                                {
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
            }

            // Tooltips close on browser resize
            window.addEventListener('resize', function () {
                clear_out_tooltips(null);
            });

            // If back button pressed back from an AJAX-generated page variant we need to refresh page because we aren't doing full JS state management
            window.has_js_state = false;
            window.onpopstate = function (event) {
                window.setTimeout(function () {
                    if (window.location.hash == '' && window.has_js_state) {
                        window.location.reload();
                    }
                }, 0);
            };

            window.page_loaded = true;
            window.is_doing_a_drag = false;

            Composr.loadWindow.then(function () { // When images etc have loaded
                script_page_rendered();
            });

            if (Composr.$IS_STAFF && (window.script_load_stuff_staff !== undefined)) {
                script_load_stuff_staff()
            }
        }
    });

    var ToggleableTray = Composr.View.extend({
        contentEl: null,
        // cookieId is null for trays not saving a cookie
        cookieId: null,
        initialize: function () {
            Composr.View.prototype.initialize.apply(this, arguments);

            this.contentEl = this.el.querySelector('.toggleable_tray');
            this.cookieId  = this.el.dataset.trayCookie || null;

            if (this.cookieId) {
                this.handleTrayCookie(this.cookieId);
            }
        },

        events: {
            'click .js-btn-tray-toggle': 'toggle',
            'click .js-btn-tray-accordion': 'toggleAccordionItems'
        },

        toggle: function () {
            if (this.cookieId) {
                toggleable_tray(this.el, false, this.cookieId);
            } else {
                toggleable_tray(this.el);
            }
        },

        accordion: function (el) {
            var i, nodes = Composr.dom.$$(el.parentNode.parentNode, '.toggleable_tray');

            nodes.forEach(function (node) {
                if ((node.parentNode !== el) && (node.style.display !== 'none') && node.parentNode.classList.contains('js-tray-accordion-item')) {
                    toggleable_tray(node, true);
                }
            });

            return toggleable_tray(el);
        },

        toggleAccordionItems: function (e) {
            var btn = e.currentTarget,
                accordionItem = Composr.dom.closest(btn, '.js-tray-accordion-item');

            if (accordionItem) {
                this.accordion(accordionItem);
            }
        },

        handleTrayCookie: function () {
            var cookieValue = read_cookie('tray_' + this.cookieId);

            if (((this.contentEl.style.display === 'none') && (cookieValue === 'open')) || ((this.contentEl.style.display !== 'none') && (cookieValue === 'closed'))) {
                toggleable_tray(this.contentEl, true);
            }
        }
    });

    Composr.views.core = {
        Global: Global,
        ToggleableTray: ToggleableTray
    };

    Composr.templates.core = {
        globalHtmlWrap: function globalHtmlWrap(options) {
            options = options || {};

            if (document.getElementById('global_messages_2')) {
                merge_global_messages();
            }

            if (Composr.isTruthy(Composr.queryString.get('wide_print'))) {
                try { window.print(); } catch (ignore) {}
            }

            if (Composr.isTruthy(options.bgTplCompilation)) {
                var page = Composr.filters.urlEncode(options.page);
                load_snippet('background_template_compilation&page=' + page, '', function () {});
            }
        },

        forumsEmbed: function () {
            var frame = this;
            window.setInterval(function() { resize_frame(frame.name); }, 500);
        },

        massSelectFormButtons: function massSelectFormButtons(options) {
            var delBtn = this;

            $(delBtn).on('click', function () {
                massDeleteClick(delBtn);
            });

            document.getElementById('id').fakeonchange = initialiseButtonVisibility;
            initialiseButtonVisibility();

            function initialiseButtonVisibility() {
                var id = document.getElementById('id');
                var ids = (id.value === '') ? [] : id.value.split(/,/);

                document.getElementById('submit_button').disabled = (ids.length != 1);
                document.getElementById('mass_select_button').disabled = (ids.length == 0);
            }

            function massDeleteClick(el) {
                confirm_delete(el.form, true, function () {
                    var id = document.getElementById('id');
                    var ids = (id.value === '') ? [] : id.value.split(/,/);

                    for (var i = 0; i < ids.length; i++) {
                        prepareMassSelectMarker('', options.type, ids[i], true);
                    }

                    ob.form.method = 'post';
                    ob.form.action = options.actionUrl;
                    ob.form.target = '_top';
                    ob.form.submit();
                });
            }
        },

        uploadSyndicationSetupScreen: function (id) {
            var win_parent = window.parent;
            if (!win_parent) win_parent = window.opener;

            var ob = win_parent.document.getElementById(id);
            ob.checked = true;

            var win = window;
            window.setTimeout(function () {
                if (typeof win.faux_close != 'undefined')
                    win.faux_close();
                else
                    win.close();
            }, 4000);
        },

        loginScreen: function loginScreen() {
            if ((document.activeElement === undefined) || (document.activeElement !== document.getElementById('password'))) {
                try {
                    document.getElementById('login_username').focus();
                } catch (e){}
            }
        },

        ipBanScreen: function () {
            var textarea = this.getElementById('bans');
            manage_scroll_height(textarea);

            if (!Composr.$MOBILE) {
                $(textarea).on('keyup', function () {
                    manage_scroll_height(textarea);
                });
            }
        },

        jsBlock: function jsBlock(options) {
            call_block(options.blockCallUrl, '', document.getElementById(options.jsBlockId), false, null, false, null, false, false);
        },

        massSelectMarker: function (options) {
            var checkbox = this.querySelector('.js-chb-prepare-mass-select');

            $(checkbox).on('click', function () {
                prepareMassSelectMarker(options.supportMassSelect, options.type, options.id, checkbox.checked);
            });
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

    function prepareMassSelectMarker(set, type, id, checked) {
        var mass_delete_form = document.getElementById('mass_select_form__' + set);
        if (!mass_delete_form) {
            mass_delete_form = document.getElementById('mass_select_button').form;
        }
        var key = type + '_' + id;
        var hidden;
        if (typeof mass_delete_form.elements[key] == 'undefined') {
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
})(window.jQuery || window.Zepto, window.Composr);

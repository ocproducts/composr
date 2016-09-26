(function ($, Composr) {
    'use strict';

    Composr.ready.then(function () {
        Composr.attachBehaviors(document);
    });

    Composr.behaviors.core = {
        initialize: {
            attach: function (context) {
                Composr.initializeViewsAlternate(context);
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

                    if (Composr.is(Composr.$CONFIG_OPTION.jsOverlays)) {
                        // Lightboxes
                        if (anchor.rel && anchor.rel.match(/lightbox/)) {
                            anchor.title = anchor.title.replace('{!LINK_NEW_WINDOW;^}', '').trim();
                        }

                        // Convert <a> title attributes into Composr tooltips
                        if (!anchor.classList.contains('no_tooltip')) {
                            convert_tooltip(anchor);
                        }
                    }

                    // Keep parameters need propagating
                    if (Composr.is(Composr.$VALUE_OPTION.jsKeepParams) && (href.indexOf(Composr.$BASE_URL + '/') === 0)) {
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
                    if (Composr.is(Composr.$CONFIG_OPTION.jsOverlays)) {
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

                    if (Composr.is(Composr.$VALUE_OPTION.jsKeepParams)) {
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
                if (Composr.not(Composr.$CONFIG_OPTION.jsOverlays)) {
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
            Global.__super__.initialize.apply(this, arguments);
            this._stripPatternCache = {};

            if (Composr.is(Composr.$CONFIG_OPTION.detectJavascript)) {
                this.detectJavascript();
            }

            this.setup();
        },

        events: {
            // Prevent url change for clicks on anchor tags with a placeholder href
            'click a[href$="#!"]': 'preventDefault',
            // Prevent form submission for forms with a placeholder action
            'submit form[action$="#!"]': 'preventDefault',
            // Prevent-default for JS-activated elements which have noscript fallbacks by default
            'click [data-cms-js]': 'preventDefault',
            'submit [data-cms-js]': 'preventDefault',

            // Simulated href for non <a> elements
            'click [data-cms-href]': 'cmsHref',

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
            'click a[rel*="lightbox"]': 'lightBoxes',

            // Go back in browser history
            'click [data-cms-btn-go-back]': 'goBackInHistory',

            /* STAFF */
            'click .js-click-load-software-chat': 'loadSoftwareChat',
            'submit .js-submit-staff-actions-select': 'staffActionsSelect'
        },

        preventDefault: function (e, el) {
            if (el.dataset.cmsJs !== '0') {
                e.preventDefault();
            }
        },

        cmsHref: function (e, el) {
            var anchorClicked = !!Composr.dom.closest(e.target, 'a', el);

            // Make sure a child <a> element wasn't clicked and default wasn't prevented
            if (!anchorClicked && !e.defaultPrevented) {
                Composr.navigate(el);
            }
        },

        disableButton: function (e, target) {
            Composr.ui.disableButton(target);
        },

        disableFormButtons: function (e, target) {
            Composr.ui.disableFormButtons(target);
        },

        invalidPattern: function (e, input) {
            var pattern = input.dataset.cmsInvalidPattern,
                regex;

            regex = this._stripPatternCache[pattern] || (this._stripPatternCache[pattern] = new RegExp(pattern, 'g'));

            if (e.type === 'input') {
                // value.length is also 0 if invalid value is provided for input[type=number] et al., clear that
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

        openOverlay: function (e, el) {
            var args, url = (el.href === undefined) ? el.action : el.href;

            if (Composr.not(Composr.$CONFIG_OPTION.jsOverlays)) {
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

        lightBoxes: function (e, el) {
            if (Composr.not(Composr.$CONFIG_OPTION.jsOverlays)) {
                return;
            }

            e.preventDefault();

            if (el.querySelectorAll('img').length > 0 || el.querySelectorAll('video').length > 0) {
                open_image_into_lightbox(el);
            } else {
                openLinkAsOverlay({el: el});
            }
        },

        goBackInHistory: function () {
            window.history.back();
        },

        // Detecting of JavaScript support
        detectJavascript: function () {
            var url = window.location.href,
                append = '?';

            if (Composr.is(Composr.$JS_ON) || Composr.usp.has('keep_has_js') || url.includes('upgrader.php') || url.includes('webdav.php')) {
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

            if (Composr.is(Composr.$DEV_MODE)) {
                append += '&keep_devtest=1';
            }

            // Redirect with JS on, and then hopefully we can remove keep_has_js after one click. This code only happens if JS is marked off, no infinite loops can happen.
            window.location = url + append;
        },

        setup: function () {
            var i, view = this;

            if (((window === window.top) && !window.opener) || (window.name === '')) {
                window.name = '_site_opener';
            }

            // Are we dealing with a touch device?
            if (document.documentElement.ontouchstart !== undefined) {
                document.body.classList.add('touch_enabled');
            }

            if (Composr.is(Composr.$HAS_PRIVILEGE.seesJavascriptErrorAlerts)) {
                this.initialiseErrorMechanism();
            }

            // Dynamic images need preloading
            var preloader = new Image();
            preloader.src = Composr.url('{$IMG;,loading}');

            // Tell the server we have JavaScript, so do not degrade things for reasons of compatibility - plus also set other things the server would like to know
            if (Composr.is(Composr.$CONFIG_OPTION.detectJavascript)) {
                set_cookie('js_on', 1, 120);
            }

            if (Composr.is(Composr.$CONFIG_OPTION.isOnTimezoneDetection)) {
                if (!window.parent || (window.parent === window)) {
                    set_cookie('client_time', new Date().toString(), 120);
                    set_cookie('client_time_ref', Composr.$FROM_TIMESTAMP, 120);
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

            /* Tidying up after the page is rendered */
            Composr.load.then(function () {
                // When images etc have loaded
                // Move the help panel if needed
                if (Composr.is(Composr.$CONFIG_OPTION.fixedWidth) || (get_window_width() > 990)) {
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
                document.getElementById('helper_panel_toggle').style.display = 'none';
                helperPanel.style.minHeight = '0';
            });

            if (Composr.isStaff) {
                this.loadStuffStaff()
            }
        },

        /* SOFTWARE CHAT */
        loadSoftwareChat: function () {
            var url = 'https://kiwiirc.com/client/irc.kiwiirc.com/?nick=';
            if (Composr.$USERNAME !== 'admin') {
                url += encodeURIComponent(Composr.$USERNAME.replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g, ''));
            } else {
                url += encodeURIComponent(Composr.$SITE_NAME.replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g, ''));
            }
            url += '#composrcms';
            var html = ' \
    <div class="software_chat"> \
        <h2>{!CMS_COMMUNITY_HELP}</h2> \
        <ul class="spaced_list">{!SOFTWARE_CHAT_EXTRA;}</ul> \
        <p class="associated_link associated_links_block_group"><a title="{!SOFTWARE_CHAT_STANDALONE} {!LINK_NEW_WINDOW;}" target="_blank" href="' + escape_html(url) + '">{!SOFTWARE_CHAT_STANDALONE}</a> <a href="#!" class="js-click-load-software-chat">{!HIDE}</a></p> \
    </div> \
    <iframe class="software_chat_iframe" style="border: 0" src="' + escape_html(url) + '"></iframe> \
'.replace(/\\{1\\}/, escape_html((window.location + '').replace(get_base_url(), 'http://baseurl')));

            var box = document.getElementById('software_chat_box'), img;
            if (box) {
                box.parentNode.removeChild(box);

                img = document.getElementById('software_chat_img');
                clear_transition_and_set_opacity(img, 1.0);
            } else {
                var width = 950,
                    height = 550;
                box = document.createElement('div');
                box.id = 'software_chat_box';
                Composr.dom.css(box, {
                    width: width + 'px',
                    height: height + 'px',
                    background: '#EEE',
                    color: '#000',
                    padding: '5px',
                    border: '3px solid #AAA',
                    position: 'absolute',
                    zIndex: 2000,
                    left: (get_window_width() - width) / 2 + 'px',
                    top: 100 + 'px'
                });

                Composr.dom.html(box, html);
                document.body.appendChild(box);

                smooth_scroll(0);

                img = document.getElementById('software_chat_img');
                clear_transition_and_set_opacity(img, 0.5);
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

        loadStuffStaff: function () {
            var loc = window.location.href;

            // Navigation loading screen
            if (Composr.is(Composr.$CONFIG_OPTION.enableAnimations)) {
                if ((window.parent === window) && !loc.includes('js_cache=1') && (loc.includes('/cms/') || loc.includes('/adminzone/'))) {
                    window.addEventListener('beforeunload', function () {
                        staff_unload_action();
                    });
                }
            }

            // Theme image editing hovers
            var els = Composr.dom.$$('*:not(.no_theme_img_click)'), i, el, tag, hasImage;
            for (i = 0; i < els.length; i++) {
                el = els[i];
                tag = el.localName;
                hasImage = (tag === 'img') || ((tag === 'input') && (el.type === 'image')) || Composr.dom.css(el, 'background-image').includes('url');

                if (hasImage) {
                    Composr.dom.on(el, {
                        mouseover: handle_image_mouse_over,
                        mouseout: handle_image_mouse_out,
                        click: handle_image_click
                    });
                }
            }

            /* Thumbnail tooltips */
            if (Composr.isDevMode || loc.replace(Composr.$BASE_URL_NOHTTP, '').includes('/cms/')) {
                var urlPatterns = Composr.$EXTRA.staffTooltipsUrlPatterns,
                    links, pattern, hook, patternRgx;

                if (Composr.isEmptyObj(urlPatterns)) {
                    return;
                }

                links = Composr.dom.$$('td a');
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

            /*
             TOOLTIPS FOR THUMBNAILS TO CONTENT, AS DISPLAYED IN CMS ZONE
             */

            function apply_comcode_tooltip(hook, id, link) {
                link.addEventListener('mouseout', function (event) {
                    deactivate_tooltip(link);
                });
                link.addEventListener('mousemove', function (event) {
                    reposition_tooltip(link, event, false, false, null, true);
                });
                link.addEventListener('mouseover', function (event) {
                    var id_chopped = id[1];
                    if (id[2] !== undefined) {
                        id_chopped += ':' + id[2];
                    }
                    var comcode = '[block="' + hook + '" id="' + decodeURIComponent(id_chopped) + '" no_links="1"]main_content[/block]';
                    if (link.rendered_tooltip === undefined) {
                        link.is_over = true;

                        var request = do_ajax_request(maintain_theme_in_link('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?css=1&javascript=1&raw_output=1&box_title={!PREVIEW;&}' + keep_stub(false)), function (ajax_result_frame) {
                            if (ajax_result_frame && ajax_result_frame.responseText) {
                                link.rendered_tooltip = ajax_result_frame.responseText;
                            }
                            if (typeof link.rendered_tooltip != 'undefined') {
                                if (link.is_over)
                                    activate_tooltip(link, event, link.rendered_tooltip, '400px', null, null, false, false, false, true);
                            }
                        }, 'data=' + encodeURIComponent(comcode));
                    } else {
                        activate_tooltip(link, event, link.rendered_tooltip, '400px', null, null, false, false, false, true);
                    }
                });
            }

            /*
             THEME IMAGE CLICKING
             */

            function handle_image_mouse_over(event) {
                var target = event.target;
                if (target.previousSibling && (typeof target.previousSibling.className != 'undefined') && (typeof target.previousSibling.className.indexOf != 'undefined') && (target.previousSibling.className.indexOf('magic_image_edit_link') != -1)) return;
                if (target.offsetWidth < 130) return;

                var src = (typeof target.src == 'undefined') ? window.getComputedStyle(target).getPropertyValue('background-image') : target.src;
                if ((typeof target.src == 'undefined') && (!event.ctrlKey) && (!event.metaKey) && (!event.altKey)) return; // Needs ctrl key for background images
                if (src.indexOf('/themes/') == -1) return;
                if (window.location.href.indexOf('admin_themes') != -1) return;

                if (Composr.is(Composr.$CONFIG_OPTION.enableThemeImgButtons)) {
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
                    ml.value = '{!themes:EDIT_THEME_IMAGE;}';
                    ml.className = 'magic_image_edit_link button_micro';
                    ml.style.position = 'absolute';
                    ml.style.left = find_pos_x(target) + 'px';
                    ml.style.top = find_pos_y(target) + 'px';
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
                window.status = '{!SPECIAL_CLICK_TO_EDIT;}';
            }

            function handle_image_mouse_out(event) {
                var target = event.target;

                if (Composr.is(Composr.$CONFIG_OPTION.enableThemeImgButtons)) {
                    if (target.previousSibling && (typeof target.previousSibling.className != 'undefined') && (typeof target.previousSibling.className.indexOf != 'undefined') && (target.previousSibling.className.indexOf('magic_image_edit_link') != -1)) {
                        if ((typeof target.mo_link != 'undefined') && (target.mo_link)) // Clear timed display of new edit button
                        {
                            window.clearTimeout(target.mo_link);
                            target.mo_link = null;
                        }

                        // Time removal of edit button
                        if (target.mo_link)
                            window.clearTimeout(target.mo_link);
                        target.mo_link = window.setTimeout(function () {
                            if ((typeof target.edit_window == 'undefined') || (!target.edit_window) || (target.edit_window.closed)) {
                                if (target.previousSibling && (typeof target.previousSibling.className != 'undefined') && (typeof target.previousSibling.className.indexOf != 'undefined') && (target.previousSibling.className.indexOf('magic_image_edit_link') != -1))
                                    target.parentNode.removeChild(target.previousSibling);
                            }
                        }, 3000);
                    }
                }

                if (typeof window.old_status_img == 'undefined') window.old_status_img = '';
                window.status = window.old_status_img;
            }

            function handle_image_click(event, ob, force) {
                if ((typeof ob == 'undefined') || (!ob)) var ob = this;

                var src = ob.origsrc ? ob.origsrc : ((typeof ob.src == 'undefined') ? window.getComputedStyle(ob).getPropertyValue('background-image').replace(/.*url\(['"]?(.*)['"]?\).*/, '$1') : ob.src);
                if ((src) && ((force) || (magic_keypress(event)))) {
                    // Bubbling needs to be stopped because shift+click will open a new window on some lower event handler (in firefox anyway)
                    cancel_bubbling(event);

                    if (typeof event.preventDefault != 'undefined') event.preventDefault();

                    if (src.indexOf('{$BASE_URL_NOHTTP;}/themes/') != -1)
                        ob.edit_window = window.open('{$BASE_URL;,0}/adminzone/index.php?page=admin_themes&type=edit_image&lang=' + encodeURIComponent(Composr.$LANG) + '&theme=' + encodeURIComponent(Composr.$THEME) + '&url=' + encodeURIComponent(src.replace('{$BASE_URL;,0}/', '')) + keep_stub(), 'edit_theme_image_' + ob.id);
                    else window.fauxmodal_alert('{!NOT_THEME_IMAGE;^}');

                    return false;
                }

                return true;
            }

        },

        /* Staff JS error display */
        initialiseErrorMechanism: function () {
            window.onerror = function (msg, file, code) {
                if (msg.indexOf === undefined) {
                    return null;
                }

                if (document.readyState !== 'complete') {
                    // Probably not loaded yet
                    return null;
                }

                if (
                    (msg.indexOf('AJAX_REQUESTS is not defined') != -1) || // Intermittent during page out-clicks

                        // Internet Explorer false positives
                    (((msg.indexOf("'null' is not an object") != -1) || (msg.indexOf("'undefined' is not a function") != -1)) && ((typeof file == 'undefined') || (file == 'undefined'))) || // Weird errors coming from outside
                    ((code == '0') && (msg.indexOf('Script error.') != -1)) || // Too generic, can be caused by user's connection error

                        // Firefox false positives
                    (msg.indexOf("attempt to run compile-and-go script on a cleared scope") != -1) || // Intermittent buggyness
                    (msg.indexOf('UnnamedClass.toString') != -1) || // Weirdness
                    (msg.indexOf('ASSERT: ') != -1) || // Something too generic
                    ((file) && (file.indexOf('TODO: FIXME') != -1)) || // Something too generic / Can be caused by extensions
                    (msg.indexOf('TODO: FIXME') != -1) || // Something too generic / Can be caused by extensions
                    (msg.indexOf('Location.toString') != -1) || // Buggy extensions may generate
                    (msg.indexOf('Error loading script') != -1) || // User's connection error
                    (msg.indexOf('NS_ERROR_FAILURE') != -1) || // Usually an internal error

                        // Google Chrome false positives
                    (msg.indexOf('can only be used in extension processes') != -1) || // Can come up with MeasureIt
                    (msg.indexOf('extension.') != -1) || // E.g. "Uncaught Error: Invocation of form extension.getURL() doesn't match definition extension.getURL(string path) schema_generated_bindings"

                    false // Just to allow above lines to be reordered
                )
                    return null; // Comes up on due to various Firefox/extension/etc bugs

                if ((window.done_one_error === undefined) || (!window.done_one_error)) {
                    window.done_one_error = true;
                    var alert = '{!JAVASCRIPT_ERROR;^}\n\n' + code + ': ' + msg + '\n' + file;
                    if (window.document.body) {// i.e. if loaded
                        window.fauxmodal_alert(alert, null, '{!ERROR_OCCURRED;^}');
                    }
                }
                return false;
            };

            window.addEventListener('beforeunload', function () {
                window.onerror = null;
            });
        }
    });

    var ToggleableTray = Composr.View.extend({
        contentEl: null,
        // cookieId is null for trays not saving a cookie
        cookieId: null,
        initialize: function () {
            Composr.View.prototype.initialize.apply(this, arguments);

            this.contentEl = this.el.querySelector('.toggleable_tray');
            this.cookieId = this.el.dataset.trayCookie || null;

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

        toggleAccordionItems: function (e, btn) {
            var accordionItem = Composr.dom.closest(btn, '.js-tray-accordion-item');

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
                var m1 = document.getElementById('global_messages');
                if (!m1) return;
                var m2 = document.getElementById('global_messages_2');
                Composr.dom.appendHtml(m1, Composr.dom.html(m2));
                m2.parentNode.removeChild(m2);
            }

            if (Composr.is(Composr.usp.get('wide_print'))) {
                try {
                    window.print();
                } catch (ignore) {
                }
            }

            if (Composr.is(options.bgTplCompilation)) {
                var page = Composr.filter.url(options.page);
                load_snippet('background_template_compilation&page=' + page, '', function () {
                });
            }
        },

        forumsEmbed: function () {
            var frame = this;
            window.setInterval(function () {
                resize_frame(frame.name);
            }, 500);
        },

        massSelectFormButtons: function (options) {
            var delBtn = this,
                form = delBtn.form;

            Composr.dom.on(delBtn, 'click', function () {
                confirm_delete(form, true, function () {
                    var id = document.getElementById('id');
                    var ids = (id.value === '') ? [] : id.value.split(/,/);

                    for (var i = 0; i < ids.length; i++) {
                        prepareMassSelectMarker('', options.type, ids[i], true);
                    }

                    form.method = 'post';
                    form.action = options.actionUrl;
                    form.target = '_top';
                    form.submit();
                });
            });

            document.getElementById('id').fakeonchange = initialiseButtonVisibility;
            initialiseButtonVisibility();

            function initialiseButtonVisibility() {
                var id = document.getElementById('id');
                var ids = (id.value === '') ? [] : id.value.split(/,/);

                document.getElementById('submit_button').disabled = (ids.length != 1);
                document.getElementById('mass_select_button').disabled = (ids.length == 0);
            }
        },

        massSelectDeleteForm: function () {
            var form = this;
            Composr.dom.on(form, 'submit', function (e) {
                e.preventDefault();
                confirm_delete(form, true);
            });
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
                } catch (e) {
                }
            }
        },

        ipBanScreen: function () {
            var container = this,
                textarea = this.querySelector('#bans');
            manage_scroll_height(textarea);

            if (Composr.not(Composr.$MOBILE)) {
                Composr.dom.on(container, 'keyup', '#bans', function (e, textarea) {
                    manage_scroll_height(textarea);
                });
            }
        },

        jsBlock: function jsBlock(options) {
            call_block(options.blockCallUrl, '', document.getElementById(options.jsBlockId), false, null, false, null, false, false);
        },

        massSelectMarker: function (options) {
            var container = this;

            Composr.dom.on(container, 'click', '.js-chb-prepare-mass-select', function (e, checkbox) {
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

            if ((!el.onmouseover) && ((el.children.length == 0) || ((!el.children[0].onmouseover) && ((!el.children[0].title) || (el.children[0].title == ''))))) {
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

    function confirm_delete(form, multi, callback) {
        if (multi === undefined) {
            multi = false;
        }

        window.fauxmodal_confirm(
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

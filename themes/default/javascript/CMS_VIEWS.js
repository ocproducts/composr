(function ($cms, $util, $dom) {
    'use strict';

    /**
     * Addons will add $cms.View subclasses under this namespace
     * @namespace $cms.views
     */
    $cms.views = {};

    // List of view options that can be set as properties.
    var viewOptionsList = { el: 1, id: 1, attributes: 1, className: 1, tagName: 1, events: 1 };

    $cms.View = View;
    /**
     * @memberof $cms
     * @class $cms.View
     */
    function View(/*params, viewOptions*/) {
        /** @member {number}*/
        this.uid = $util.uid(this);
        /** @member {string} */
        this.tagName = 'div';
        /** @member { HTMLElement } */
        this.el = null;

        this.initialize.apply(this, arguments);
    }

    // Cached regex to split keys for `delegate`.
    var rgxDelegateEventSplitter = /^(\S+)\s*(.*)$/;
    $util.properties(View.prototype, /**@lends $cms.View#*/{
        /**
         * @method
         */
        initialize: function (params, viewOptions) {
            this.params = objVal(params);

            if ($util.isObj(viewOptions)) {
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
            return $dom.$(this.el, selector);
        },
        /**
         * @method
         */
        $$: function (selector) {
            return $dom.$$(this.el, selector);
        },
        /**
         * @method
         */
        $$$: function (selector) {
            return $dom.$$$(this.el, selector);
        },
        /**
         * @method
         */
        $closest: function (el, selector) {
            return $dom.closest(el, selector, this.el);
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
            this.el = (typeof el === 'string') ? $dom.$(el) : el;
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
            //$util.inform('$cms.View#delegate(): delegating event "' + eventName + '" for selector "' + selector + '" with listener', listener, 'and view', this);
            $dom.on(this.el, (eventName + '.delegateEvents' + $util.uid(this)), selector, listener);
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
                $dom.off(this.el, '.delegateEvents' + $util.uid(this));
            }
            return this;
        },

        /**
         * A finer-grained `undelegateEvents` for removing a single delegated event. `selector` and `listener` are both optional.
         * @method
         */
        undelegate: function (eventName, selector, listener) {
            $dom.off(this.el, (eventName + '.delegateEvents' + $util.uid(this)), selector, listener);
            return this;
        },

        /**
         * @method
         */
        _ensureElement: function () {
            var attrs;
            if (!this.el) {
                attrs = Object.assign({}, $util.result(this, 'attributes'));
                if (this.id) {
                    attrs.id = $util.result(this, 'id');
                }
                if (this.className) {
                    attrs.className = $util.result(this, 'className');
                }
                this.setElement($dom.create($util.result(this, 'tagName') || 'div', attrs));
            } else {
                this.setElement($util.result(this, 'el'));
            }
        }
    });

    $cms.views.ToggleableTray = ToggleableTray;
    /**
     * @memberof $cms.views
     * @class $cms.views.ToggleableTray
     * @extends $cms.View
     */
    function ToggleableTray(params) {
        var id;

        ToggleableTray.base(this, 'constructor', arguments);

        this.cookie = null;
        if (params.save) {
            id = $dom.id(this.el, 'tray-');
            this.cookie = id.startsWith('tray') ? id : 'tray-' + id;
        }

        if (!params.accordion) {
            this.contentEl = this.$('.js-tray-content');

            if (this.cookie) {
                this.handleTrayCookie();
            }
        }
    }

    $util.inherits(ToggleableTray, $cms.View, /**@lends $cms.views.ToggleableTray#*/{
        /**@method*/
        events: function () {
            return {
                'click .js-tray-onclick-toggle-tray': 'toggleTray',
                'click .js-tray-onclick-toggle-accordion': 'handleToggleAccordion'
            };
        },

        /**@method*/
        toggleTray: function () {
            var expanded = $cms.ui.toggleableTray(this.contentEl);

            this.el.classList.toggle('is-expanded', expanded);
            this.el.classList.toggle('is-collapsed', !expanded);

            if (this.cookie) {
                $cms.setCookie(this.cookie, expanded ? 'open' : 'closed');
            }
        },

        /**
         * @param toggledAccordionItem - Accordion item to be made active
         */
        toggleAccordion: function (toggledAccordionItem) {
            var accordionItems = this.$$('.js-tray-accordion-item');

            accordionItems.forEach(function (accordionItem) {
                var body = accordionItem.querySelector('.js-tray-accordion-item-body'),
                    expanded;

                if ((accordionItem === toggledAccordionItem) || $dom.isDisplayed(body)) {
                    expanded = $cms.ui.toggleableTray(body);
                    accordionItem.classList.toggle('accordion-trayitem-active', expanded);
                    accordionItem.classList.toggle('is-expanded', expanded);
                    accordionItem.classList.toggle('is-collapsed', !expanded);
                }
            });

        },
        /**@method*/
        handleToggleAccordion: function (e, btn) {
            var accordionItem = $dom.closest(btn, '.js-tray-accordion-item'); // Accordion item to be made active
            this.toggleAccordion(accordionItem);
        },

        /**@method*/
        handleTrayCookie: function () {
            var cookieValue = $cms.readCookie(this.cookie), expanded;

            if (($dom.notDisplayed(this.contentEl) && (cookieValue === 'open')) || ($dom.isDisplayed(this.contentEl) && (cookieValue === 'closed'))) {
                expanded = $cms.ui.toggleableTray(this.contentEl, false);

                expanded = this.el.classList.toggle('is-expanded', expanded);
                expanded = this.el.classList.toggle('is-collapsed', !expanded);
            }
        }
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
     * @class $cms.views.ModalWindow
     * @extends $cms.View
     */
    function ModalWindow(params) {
        // Constants
        this.WINDOW_SIDE_GAP = $cms.isMobile() ? 5 : 25;
        this.WINDOW_TOP_GAP = 25; // Will also be used for bottom gap for percentage heights
        this.BOX_EAST_PERIPHERARY = 4;
        this.BOX_WEST_PERIPHERARY = 4;
        this.BOX_NORTH_PERIPHERARY = 4;
        this.BOX_SOUTH_PERIPHERARY = 4;
        this.VCENTRE_FRACTION_SHIFT = 0.5; // Fraction of remaining top gap also removed (as overlays look better slightly higher than vertical centre)
        this.LOADING_SCREEN_HEIGHT = 100;

        // Properties
        /** @type { Element }*/
        this.el =  null;
        /** @type { Element }*/
        this.overlayEl = null;
        /** @type { Element }*/
        this.containerEl = null;
        /** @type { Element }*/
        this.buttonContainerEl = null;
        this.returnValue = null;
        this.topWindow = null;
        this.iframeRestyleTimer = null;

        // Set params
        params = $util.defaults({ // apply defaults
            type: 'alert',
            opacity: '0.5',
            width: 'auto',
            height: 'auto',
            title: '',
            text: '',
            yesButton: '{!YES;^}',
            noButton: '{!NO;^}',
            cancelButton: '{!INPUTSYSTEM_CANCEL;^}',
            yes: null,
            no: null,
            finished: null,
            cancel: null,
            href: null,
            scrollbars: null,
            defaultValue: null,
            target: '_self',
            inputType: 'text'
        }, params || {});

        for (var key in params) {
            this[key] = params[key];
        }

        this.topWindow = window.top;
        this.opened = true;

        ModalWindow.base(this, 'constructor', arguments);
    }

    $util.inherits(ModalWindow, $cms.View, /**@lends $cms.views.ModalWindow#*/ {
        events: function events() {
            return {
                'click .js-onclick-do-option-yes': 'doOptionYes',
                'click .js-onclick-do-option-no': 'doOptionNo',
                'click .js-onclick-do-option-cancel': 'doOptionCancel',
                'click .js-onclick-do-option-finished': 'doOptionFinished',
                'click .js-onclick-do-option-left': 'doOptionLeft',
                'click .js-onclick-do-option-right': 'doOptionRight',
            };
        },

        doOptionYes: function doOptionYes() {
            this.option('yes');
        },

        doOptionNo: function doOptionNo() {
            this.option('no');
        },

        doOptionCancel: function doOptionCancel() {
            this.option('cancel');
        },

        doOptionFinished: function doOptionFinished() {
            this.option('finished');
        },

        doOptionLeft: function doOptionLeft() {
            this.option('left');
        },

        doOptionRight: function doOptionRight() {
            this.option('right');
        },

        _setElement: function _setElement() {
            var button;

            this.topWindow.overlayZIndex || (this.topWindow.overlayZIndex = 999999); // Has to be higher than plupload, which is 99999

            this.el = $dom.create('div', { // Black out the background
                'className': 'js-modal-background js-modal-type-' + this.type,
                'css': {
                    'background': 'rgba(0,0,0,0.7)',
                    'zIndex': this.topWindow.overlayZIndex++,
                    'overflow': 'hidden',
                    'position': $cms.isMobile() ? 'absolute' : 'fixed',
                    'left': '0',
                    'top': '0',
                    'width': '100%',
                    'height': '100%'
                }
            });

            this.topWindow.document.body.appendChild(this.el);

            this.overlayEl = this.el.appendChild($dom.create('div', { // The main overlay
                'className': 'box overlay js-modal-overlay ' + this.type,
                'role': 'dialog',
                'css': {
                    // This will be updated immediately in resetDimensions
                    'position': $cms.isMobile() ? 'static' : 'fixed',
                    'margin': '0 auto' // Centering for iOS/Android which is statically positioned (so the container height as auto can work)
                }
            }));

            this.containerEl = this.overlayEl.appendChild($dom.create('div', {
                'className': 'box-inner js-modal-container',
                'css': {
                    'width': 'auto',
                    'height': 'auto'
                }
            }));

            var overlayHeader = null;
            if (this.title !== '' || this.type === 'iframe') {
                overlayHeader = $dom.create('h3', {
                    'html': this.title,
                    'css': {
                        'display': (this.title === '') ? 'none' : 'block'
                    }
                });
                this.containerEl.appendChild(overlayHeader);
            }

            if (this.text !== '') {
                if (this.type === 'prompt') {
                    var div = $dom.create('p');
                    div.appendChild($dom.create('label', {
                        'htmlFor': 'overlay_prompt',
                        'html': this.text
                    }));
                    this.containerEl.appendChild(div);
                } else {
                    this.containerEl.appendChild($dom.create('div', {
                        'html': this.text
                    }));
                }
            }

            this.buttonContainerEl = $dom.create('p', {
                'className': 'proceed-button js-modal-button-container'
            });

            var self = this;

            $dom.on(this.overlayEl, 'click', function (e) {
                if ($cms.isMobile() && (self.type === 'lightbox')) { // IDEA: Swipe detect would be better, but JS does not have this natively yet
                    self.option('right');
                }
            });

            /*{+START,SET,icon_proceed}{+START,INCLUDE,ICON}NAME=buttons/proceed{+END}{+END}*/
            /*{+START,SET,icon_yes}{+START,INCLUDE,ICON}NAME=buttons/yes{+END}{+END}*/
            /*{+START,SET,icon_no}{+START,INCLUDE,ICON}NAME=buttons/no{+END}{+END}*/

            switch (this.type) {
                case 'iframe':
                    var iframeWidth = (this.width.match(/^[\d\.]+$/) !== null) ? ((this.width - 14) + 'px') : this.width,
                        iframeHeight = (this.height.match(/^[\d\.]+$/) !== null) ? (this.height + 'px') : ((this.height === 'auto') ? (this.LOADING_SCREEN_HEIGHT + 'px') : this.height);

                    var iframe = $dom.create('iframe', {
                        'frameBorder': '0',
                        'scrolling': 'no',
                        'title': '',
                        'name': 'overlay-iframe',
                        'id': 'overlay-iframe',
                        'className': 'js-modal-overlay-iframe',
                        'allowTransparency': 'true',
                        //'seamless': 'seamless',// Not supported, and therefore testable yet. Would be great for mobile browsing.
                        'css': {
                            'width': iframeWidth,
                            'height': iframeHeight,
                            'background': 'transparent'
                        }
                    });

                    this.containerEl.appendChild(iframe);

                    $dom.animateFrameLoad(iframe, 'overlay-iframe', 50, true);

                    setTimeout(function () {
                        if (self.el) {
                            $dom.on(self.el, 'click', function (e) {
                                if (!self.containerEl.contains(e.target)) {
                                    // Background overlay clicked
                                    self.option('finished');
                                }
                            });
                        }
                    }, 1000);

                    $dom.on(iframe, 'load', function () {
                        if ($dom.hasIframeAccess(iframe) && (!iframe.contentDocument.querySelector('h1')) && (!iframe.contentDocument.querySelector('h2'))) {
                            if (iframe.contentDocument.title) {
                                $dom.html(overlayHeader, $cms.filter.html(iframe.contentDocument.title));
                                $dom.show(overlayHeader);
                            }
                        }
                    });

                    // Fiddle it, to behave like a pop-up would
                    setTimeout(function () {
                        $dom.illustrateFrameLoad('overlay-iframe');
                        iframe.src = self.href;
                        self.makeFrameLikePopup(iframe);

                        if (self.iframeRestyleTimer == null) { // In case internal nav changes
                            self.iframeRestyleTimer = setInterval(function () {
                                self.makeFrameLikePopup(iframe);
                            }, 300);
                        }
                    }, 0);
                    break;

                case 'lightbox':
                case 'alert':
                    if (this.yes) {
                        button = $dom.create('button', {
                            'type': 'button',
                            'html': '{$GET;^,icon_proceed} ' + this.yesButton,
                            'className': 'buttons--proceed button-screen-item js-onclick-do-option-yes'
                        });

                        this.buttonContainerEl.appendChild(button);
                    }
                    setTimeout(function () {
                        if (self.el) {
                            $dom.on(self.el, 'click', function (e) {
                                if (!self.containerEl.contains(e.target)) {
                                    // Background overlay clicked
                                    if (self.yes) {
                                        self.option('yes');
                                    } else {
                                        self.option('cancel');
                                    }
                                }
                            });
                        }
                    }, 1000);
                    break;

                case 'confirm':
                    button = $dom.create('button', {
                        'type': 'button',
                        'html': '{$GET;^,icon_yes} ' + this.yesButton,
                        'className': 'buttons--yes button-screen-item js-onclick-do-option-yes',
                        'style': 'font-weight: bold;'
                    });
                    this.buttonContainerEl.appendChild(button);
                    button = $dom.create('button', {
                        'type': 'button',
                        'html': '{$GET;^,icon_no} ' + this.noButton,
                        'className': 'buttons--no button-screen-item js-onclick-do-option-no'
                    });
                    this.buttonContainerEl.appendChild(button);
                    break;

                case 'prompt':
                    this.input = $dom.create('input', {
                        'name': 'prompt',
                        'id': 'overlay_prompt',
                        'type': this.inputType,
                        'size': '40',
                        'className': 'wide-field',
                        'value': (this.defaultValue === null) ? '' : this.defaultValue
                    });
                    var inputWrap = $dom.create('div');
                    inputWrap.appendChild(this.input);
                    this.containerEl.appendChild(inputWrap);

                    if (this.yes) {
                        button = $dom.create('button', {
                            'type': 'button',
                            'html': this.yesButton,
                            'className': 'buttons--yes button-screen-item js-onclick-do-option-yes',
                            'css': {
                                'font-weight': 'bold'
                            }
                        });
                        this.buttonContainerEl.appendChild(button);
                    }

                    setTimeout(function () {
                        if (self.el) {
                            $dom.on(self.el, 'click', function (e) {
                                if (!self.containerEl.contains(e.target)) {
                                    // Background overlay clicked
                                    self.option('cancel');
                                }
                            });
                        }
                    }, 1000);
                    break;
            }

            // Cancel button handled either via button in corner (if there's no other buttons) or another button in the panel (if there's other buttons)
            if (this.cancelButton) {
                if (this.buttonContainerEl.firstElementChild) {
                    /*{+START,SET,icon_cancel}{+START,INCLUDE,ICON}NAME=buttons/cancel{+END}{+END}*/
                    button = $dom.create('button', {
                        'type': 'button',
                        'html': '{$GET;^,icon_cancel} ' + this.cancelButton,
                        'className': 'button-screen-item buttons--cancel ' + (this.cancel ? 'js-onclick-do-option-cancel' : 'js-onclick-do-option-finished')
                    });
                    this.buttonContainerEl.appendChild(button);
                } else {
                    button = $dom.create('img', {
                        'width': '38',
                        'height': '38',
                        'src': $util.srl('{$IMG;,icons/media_set/lightbox_close}'),
                        'alt': this.cancelButton,
                        'className': 'overlay-close-button ' + (this.cancel ? 'js-onclick-do-option-cancel' : 'js-onclick-do-option-finished')
                    });
                    this.containerEl.appendChild(button);
                }
            }

            // Put together
            if (this.buttonContainerEl.firstElementChild) {
                if (this.type === 'iframe') {
                    this.containerEl.appendChild($dom.create('hr', {'className': 'spaced-rule'}));
                }
                this.containerEl.appendChild(this.buttonContainerEl);
            }

            // Handle dimensions
            this.resetDimensions(this.width, this.height, true);
            $dom.on(window, 'resize', function () {
                self.resetDimensions(self.width, self.height, false);
            });

            // Focus first button by default
            if (this.input) {
                setTimeout(function () {
                    self.input.focus();
                });
            } else if (this.el.querySelector('button')) {
                this.el.querySelector('button').focus();
            }

            setTimeout(function () { // Timeout needed else keyboard activation of overlay opener may cause instant shutdown also
                $dom.on(document, 'keyup.modalWindow' + this.uid, self.keyup.bind(self));
                $dom.on(document, 'mousemove.modalWindow' + this.uid, self.mousemove.bind(self));
            }, 100);
        },

        keyup: function keyup(e) {
            if (e.key === 'ArrowLeft') {
                this.option('left');
            } else if (e.key === 'ArrowRight') {
                this.option('right');
            } else if ((e.key === 'Enter') && (this.yes)) {
                this.option('yes');
            } else if ((e.key === 'Enter') && (this.finished)) {
                this.option('finished');
            } else if ((e.key === 'Escape') && (this.cancelButton) && /^(prompt|confirm|lightbox|alert)$/.test(this.type)) {
                this.option('cancel');
            }
        },

        mousemove: function mousemove() {
            var self = this;
            if (!this.overlayEl.classList.contains('mousemove')) {
                this.overlayEl.classList.add('mousemove');
                setTimeout(function () {
                    if (self.overlayEl) {
                        self.overlayEl.classList.remove('mousemove');
                    }
                }, 2000);
            }
        },
        // Methods...
        close: function () {
            if (this.el) {
                this.topWindow.document.body.style.overflow = '';

                this.el.remove();
                this.el = null;

                $dom.off(document, 'keyup.modalWindow' + this.uid);
                $dom.off(document, 'mousemove.modalWindow' + this.uid);
            }
            this.opened = false;
        },

        option: function (method) {
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
                this.close();
            }
        },

        /**
         * @param {string} width
         * @param {string} height
         * @param {boolean} [init]
         * @param {boolean} [forceHeight]
         */
        resetDimensions: function (width, height, init, forceHeight) {
            width = strVal(width);
            height = strVal(height);
            init = Boolean(init);
            forceHeight = Boolean(forceHeight);

            if (!this.el) {
                return;
            }

            var topPageHeight = this.topWindow.$dom.getWindowScrollHeight(),
                topWindowWidth = this.topWindow.$dom.getWindowWidth(),
                topWindowHeight = this.topWindow.$dom.getWindowHeight();

            var bottomGap = this.WINDOW_TOP_GAP;
            if (this.buttonContainerEl.firstElementChild) {
                bottomGap += this.buttonContainerEl.offsetHeight;
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
                if ((parseInt(width) > topWindowWidth - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY) || (width === 'auto')) {
                    width = '' + (topWindowWidth - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY);
                }
            }

            // Auto width means full width
            if (width === 'auto') {
                width = '' + (topWindowWidth - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY);
            }
            // NB: auto height feeds through without a constraint (due to infinite growth space), with dynamic adjustment for iframes

            // Calculate percentage sizes
            var match;
            match = width.match(/^([\d\.]+)%$/);
            if (match !== null) {
                width = '' + (parseFloat(match[1]) * (topWindowWidth - this.WINDOW_SIDE_GAP * 2 - this.BOX_EAST_PERIPHERARY - this.BOX_WEST_PERIPHERARY));
            }
            match = height.match(/^([\d\.]+)%$/);
            if (match !== null) {
                height = '' + (parseFloat(match[1]) * (topPageHeight - this.WINDOW_TOP_GAP - bottomGap - this.BOX_NORTH_PERIPHERARY - this.BOX_SOUTH_PERIPHERARY));
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
            this.overlayEl.style.width = boxWidth;
            this.overlayEl.style.height = boxHeight;
            var iframe = this.el.querySelector('iframe');

            if ($dom.hasIframeAccess(iframe) && (iframe.contentDocument.body)) { // Balance iframe height
                iframe.style.width = '100%';
                if (height === 'auto') {
                    if (!init) {
                        detectedBoxHeight = $dom.getWindowScrollHeight(iframe.contentWindow);
                        iframe.style.height = detectedBoxHeight + 'px';
                    }
                } else {
                    iframe.style.height = '100%';
                }
            }

            // Work out box position
            if (!detectedBoxHeight) {
                detectedBoxHeight = this.overlayEl.offsetHeight;
            }
            var boxPosTop, boxPosLeft;

            if (boxHeight === 'auto') {
                if (init) {
                    boxPosTop = (topWindowHeight / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (this.LOADING_SCREEN_HEIGHT / 2) + this.WINDOW_TOP_GAP; // This is just temporary
                } else {
                    boxPosTop = (topWindowHeight / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (detectedBoxHeight / 2) + this.WINDOW_TOP_GAP;
                }

                if (iframe) { // Actually, for frames we'll put at top so things don't bounce about during loading and if the frame size changes
                    boxPosTop = this.WINDOW_TOP_GAP;
                }
            } else {
                boxPosTop = (topWindowHeight / (2 + (this.VCENTRE_FRACTION_SHIFT * 2))) - (parseInt(boxHeight) / 2) + this.WINDOW_TOP_GAP;
            }
            if (boxPosTop < this.WINDOW_TOP_GAP) {
                boxPosTop = this.WINDOW_TOP_GAP;
            }
            boxPosLeft = ((topWindowWidth / 2) - (parseInt(boxWidth) / 2));

            // Save into HTML
            this.overlayEl.style.top = boxPosTop + 'px';
            this.overlayEl.style.left = boxPosLeft + 'px';

            var doScroll = false;

            // Absolute positioning instead of fixed positioning
            if ($cms.isMobile() || (detectedBoxHeight > topWindowHeight) || (this.el.style.position === 'absolute'/*don't switch back to fixed*/)) {
                var wasFixed = (this.el.style.position === 'fixed');

                this.el.style.position = 'absolute';
                this.el.style.height = ((topPageHeight > (detectedBoxHeight + bottomGap + boxPosLeft)) ? topPageHeight : (detectedBoxHeight + bottomGap + boxPosLeft)) + 'px';
                this.topWindow.document.body.style.overflow = '';

                if (!$cms.isMobile()) {
                    this.overlayEl.style.position = 'absolute';
                    this.overlayEl.style.top = this.WINDOW_TOP_GAP + 'px';
                }

                if (init || wasFixed) {
                    doScroll = true;
                }

                if (iframe && ($dom.hasIframeAccess(iframe)) && (iframe.contentWindow.scrolledUpFor === undefined)) { /*maybe a navigation has happened and we need to scroll back up*/
                    doScroll = true;
                }
            } else { // Fixed positioning, with scrolling turned off until the overlay is closed
                this.el.style.position = 'fixed';
                this.overlayEl.style.position = 'fixed';
                this.topWindow.document.body.style.overflow = 'hidden';
            }

            if (doScroll) {
                try { // Scroll to top to see
                    this.topWindow.scrollTo(0, 0);
                    if (iframe && ($dom.hasIframeAccess(iframe))) {
                        iframe.contentWindow.scrolledUpFor = true;
                    }
                } catch (ignore) {}
            }
        },
        /**
         * Fiddle it, to behave like a pop-up would
         * @param { HTMLIFrameElement } iframe
         */
        makeFrameLikePopup: function makeFrameLikePopup(iframe) {
            var mainWebsiteInner, mainWebsite, popupSpacer, baseElement;

            if ((iframe.parentNode.parentNode.parentNode.parentNode == null) && (this.iframeRestyleTimer != null)) {
                clearInterval(this.iframeRestyleTimer);
                this.iframeRestyleTimer = null;
                return;
            }

            var iDoc = iframe.contentDocument;

            if (!$dom.hasIframeAccess(iframe) || !iDoc.body || (iDoc.body.donePopupTrans !== undefined)) {
                if (hasIframeLoaded(iframe) && !hasIframeOwnership(iframe)) {
                    iframe.scrolling = 'yes';
                    iframe.style.height = '500px';
                }

                // Handle iframe sizing
                if (this.height === 'auto') {
                    this.resetDimensions(this.width, this.height, false);
                }
                return;
            }

            iDoc.body.style.background = 'transparent';
            iDoc.body.classList.add('overlay');
            iDoc.body.classList.add('lightbox');

            // Allow scrolling, if we want it
            //iframe.scrolling = (_this.scrollbars === false) ? 'no' : 'auto';  Actually, not wanting this now

            // Remove fixed width
            mainWebsiteInner = iDoc.getElementById('main-website-inner');

            if (mainWebsiteInner) {
                mainWebsiteInner.id = '';
            }

            // Remove main-website marker
            mainWebsite = iDoc.getElementById('main-website');
            if (mainWebsite) {
                mainWebsite.id = '';
            }

            // Remove pop-up spacing
            popupSpacer = iDoc.getElementById('popup-spacer');
            if (popupSpacer) {
                popupSpacer.id = '';
            }

            // Set linking scheme
            baseElement = iDoc.querySelector('base');

            if (!baseElement) {
                baseElement = iDoc.createElement('base');
                if (iDoc.head) {
                    iDoc.head.appendChild(baseElement);
                }
            }

            baseElement.target = this.target;

            // Set frame name
            if (this.name && (iframe.contentWindow.name !== this.name)) {
                iframe.contentWindow.name = this.name;
            }

            var self = this;
            // Create close function
            if (iframe.contentWindow.fauxClose === undefined) {
                iframe.contentWindow.fauxClose = function fauxClose() {
                    if (iframe && iframe.contentWindow && (iframe.contentWindow.returnValue !== undefined)) {
                        self.returnValue = iframe.contentWindow.returnValue;
                    }
                    self.option('finished');
                };
            }

            if ($dom.html(iDoc.body).length > 300) { // Loaded now
                iDoc.body.donePopupTrans = true;
            }

            // Handle iframe sizing
            if (this.height === 'auto') {
                this.resetDimensions(this.width, this.height, false);
            }

            function hasIframeLoaded(iframe) {
                try {
                    return (iframe != null) && (iframe.contentWindow.location.host !== '');
                } catch (ignore) {}

                return false;
            }

            function hasIframeOwnership(iframe) {
                try {
                    return (iframe != null) && (iframe.contentWindow.location.host === window.location.host) && (iframe.contentWindow.document != null);
                } catch (ignore) {}

                return false;
            }
        }
    });

    /**
     * @memberof $cms.views
     * @class $cms.views.Global
     * @extends $cms.View
     * */
    $cms.views.Global = function Global(params) {
        Global.base(this, 'constructor', arguments);

        var pageLinkPrivacy = strVal(params.pageLinkPrivacy);

        /*START JS from HTML_HEAD.tpl*/
        // Google Analytics account, if one set up
        if (strVal($cms.configOption('google_analytics')).trim() && !$cms.isStaff() && !$cms.isAdmin()) {
            (function (i, s, o, g, r, a, m) {
                i['GoogleAnalyticsObject'] = r;
                i[r] = i[r] || function () {
                        (i[r].q = i[r].q || []).push(arguments);
                    };
                i[r].l = 1 * new Date();
                a = s.createElement(o);
                m = s.getElementsByTagName(o)[0];
                a.async = 1;
                a.src = g;
                m.parentNode.insertBefore(a, m);
            })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

            var aConfig = {};

            if ($cms.getCookieDomain() !== '') {
                aConfig.cookieDomain = $cms.getCookieDomain();
            }
            if (!$cms.configOption('long_google_cookies')) {
                aConfig.cookieExpires = 0;
            }

            window.ga('create', strVal($cms.configOption('google_analytics')).trim(), aConfig);

            if (!$cms.isGuest()) {
                window.ga('set', 'userId', strVal($cms.getMember()));
            }

            if ($cms.pageUrl().searchParams.has('_t')) {
                window.ga('send', 'event', 'tracking__' + strVal($cms.pageUrl().searchParams.get('_t')), window.location.href);
            }

            window.ga('send', 'pageview');
        }

        // Cookie Consent plugin by Silktide - http://silktide.com/cookieconsent
        if ($cms.configOption('cookie_notice') && ($cms.runningScript() === 'index')) {
            window.cookieconsent_options = {
                message: $util.format('{!COOKIE_NOTICE;}', [$cms.getSiteName()]),
                dismiss: '{!INPUTSYSTEM_OK;}',
                learnMore: '{!READ_MORE;}',
                link: pageLinkPrivacy,
                theme: 'dark-top'
            };
            $cms.requireJavascript('https://cdnjs.cloudflare.com/ajax/libs/cookieconsent2/1.0.9/cookieconsent.min.js');
        }

        if ($cms.configOption('detect_javascript')) {
            this.detectJavascript();
        }
        /*END JS from HTML_HEAD.tpl*/

        $dom.registerMouseListener();

        if ($dom.$('#global-messages-2')) {
            var m1 = $dom.$('#global-messages');
            if (!m1) {
                return;
            }
            var m2 = $dom.$('#global-messages-2');
            $dom.append(m1, $dom.html(m2));
            m2.parentNode.removeChild(m2);
        }

        if (boolVal($cms.pageUrl().searchParams.get('wide_print'))) {
            try {
                window.print();
            } catch (ignore) {}
        }

        if (($cms.getZoneName() === 'adminzone') && $cms.configOption('background_template_compilation')) {
            var page = $cms.filter.url($cms.getPageName());
            $cms.loadSnippet('background_template_compilation&page=' + page, '', true);
        }

        if (((window === window.top) && !window.opener) || (window.name === '')) {
            window.name = '_site_opener';
        }

        // Are we dealing with a touch device?
        if ($cms.browserMatches('touch_enabled')) {
            document.body.classList.add('touch-enabled');
        }

        if ($cms.seesJavascriptErrorAlerts()) {
            this.initialiseErrorMechanism();
        }

        // Dynamic images need preloading
        var preloader = new Image();
        preloader.src = $util.srl('{$IMG;,loading}');
        preloader.width = '20';
        preloader.height = '20';

        // Tell the server we have JavaScript, so do not degrade things for reasons of compatibility - plus also set other things the server would like to know
        if ($cms.configOption('detect_javascript')) {
            $cms.setCookie('js_on', 1, 120);
        }

        if ($cms.configOption('is_on_timezone_detection')) {
            if (!window.parent || (window.parent === window)) {
                $cms.setCookie('client_time', (new Date()).toString(), 120);
                $cms.setCookie('client_time_ref', (Date.now() / 1000), 120);
            }
        }

        // Mouse/keyboard listening
        window.currentMouseX = 0;
        window.currentMouseY = 0;

        // If back button pressed back from an AJAX-generated page variant we need to refresh page because we aren't doing full JS state management
        window.addEventListener('popstate', function () {
            setTimeout(function () {
                if (!window.location.hash && window.hasJsState) {
                    window.location.reload();
                }
            });
        });

        // Monitor pasting, for anti-spam reasons
        window.addEventListener('paste', function (event) {
            var clipboardData = event.clipboardData || window.clipboardData;
            var pastedData = clipboardData.getData('Text');
            if (pastedData && (pastedData.length > $cms.configOption('spam_heuristic_pasting'))) {
                $cms.setPostDataFlag('paste');
            }
        });

        if ($cms.isStaff()) {
            this.loadStuffStaff();
        }
    };

    $util.inherits($cms.views.Global, $cms.View, /**@lends $cms.views.Global#*/{
        events: function () {
            return {
                /* Footer links */
                'click .js-global-click-load-software-chat': 'loadSoftwareChat',

                'submit .js-global-submit-staff-actions-select': 'staffActionsSelect',

                'keypress .js-global-input-su-keypress-enter-submit-form': 'inputSuKeypress'
            };
        },

        // Detecting of JavaScript support
        detectJavascript: function () {
            var url = window.location.href,
                append = '?';

            if ($cms.isJsOn() || boolVal($cms.pageUrl().searchParams.get('keep_has_js')) || url.includes('/upgrader.php') || url.includes('/webdav.php')) {
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

            if ($cms.isDevMode()) {
                append += '&keep_devtest=1';
            }

            // Redirect with JS on, and then hopefully we can remove keep_has_js after one click. This code only happens if JS is marked off, no infinite loops can happen.
            window.location = url + append;
        },

        /* Software Chat */
        loadSoftwareChat: function () {
            var url = 'https://kiwiirc.com/client/irc.kiwiirc.com/?nick=';
            if ($cms.getUsername() !== 'admin') {
                url += encodeURIComponent($cms.getUsername().replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g, ''));
            } else {
                url += encodeURIComponent($cms.getSiteName().replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g, ''));
            }
            url += '#composrcms';

            var SOFTWARE_CHAT_EXTRA = $util.format('{!SOFTWARE_CHAT_EXTRA;^}', [$cms.filter.html(window.location.href.replace($cms.getBaseUrl(), 'http://baseurl'))]);
            var html = /** @lang HTML */'' +
                '<div class="software-chat">' +
                '   <h2>{!CMS_COMMUNITY_HELP}</h2>' +
                '   <ul class="spaced-list">' + SOFTWARE_CHAT_EXTRA + '</ul>' +
                '   <p class="associated-link associated-links-block-group">' +
                '       <a title="{!SOFTWARE_CHAT_STANDALONE} {!LINK_NEW_WINDOW;^}" target="_blank" href="' + $cms.filter.html(url) + '">{!SOFTWARE_CHAT_STANDALONE}</a>' +
                '       <a href="#!" class="js-global-click-load-software-chat">{!HIDE}</a>' +
                '   </p>' +
                '</div>' +
                '<iframe class="software-chat-iframe" style="border: 0" src="' + $cms.filter.html(url) + '"></iframe>';

            var box = $dom.$('#software-chat-box'), img;
            if (box) {
                box.parentNode.removeChild(box);

                img = $dom.$('.software-chat-img');
                img.style.opacity = 1;
            } else {
                var width = 950,
                    height = 550;

                box = $dom.create('div', {
                    id: 'software-chat-box',
                    css: {
                        width: width + 'px',
                        height: height + 'px',
                        background: '#EEE',
                        color: '#000',
                        padding: '5px',
                        border: '3px solid #AAA',
                        position: 'absolute',
                        zIndex: 2000,
                        left: ($dom.getWindowWidth() - width) / 2 + 'px',
                        top: 100 + 'px'
                    },
                    html: html
                });

                document.body.appendChild(box);

                $dom.smoothScroll(0);

                img = $dom.$('.software-chat-img');
                img.style.opacity = 0.5;
            }
        },

        /* Staff Actions links */
        staffActionsSelect: function (e, form) {
            var ob = form.elements['special_page_type'],
                val = ob.value;

            if (val !== 'view') {
                if (form.elements.cache !== undefined) {
                    form.elements.cache.value = (val.substring(val.length - 4, val.length) === '.css') ? '1' : '0';
                }

                var windowName = 'cms_dev_tools' + Math.floor(Math.random() * 10000),
                    windowOptions;

                if (val === 'templates') {
                    windowOptions = 'width=' + window.screen.availWidth + ',height=' + window.screen.availHeight + ',scrollbars=yes';

                    setTimeout(function () { // Do a refresh with magic markers, in a comfortable few seconds
                        var oldUrl = window.location.href;
                        if ($cms.pageUrl().searchParams.get('keep_template_magic_markers') !== '1') {
                            window.location.href = oldUrl + (oldUrl.includes('?') ? '&' : '?') + 'keep_template_magic_markers=1&cache_blocks=0&cache_comcode_pages=0';
                        }
                    }, 10000);
                } else {
                    windowOptions = 'width=1020,height=700,scrollbars=yes';
                }

                var test = window.open('', windowName, windowOptions);

                if (test) {
                    form.target = test.name;
                }
            }
        },

        inputSuKeypress: function (e, input) {
            if ($dom.keyPressed(e, 'Enter')) {
                $dom.submit(input.form);
            }
        },

        loadStuffStaff: function () {
            var loc = window.location.href;
            // Navigation loading screen
            if ($cms.configOption('enable_animations')) {
                if ((window.parent === window) && ($cms.pageUrl().searchParams.get('js_cache') !== '1') && (loc.includes('/cms/') || loc.includes('/adminzone/'))) {
                    window.addEventListener('beforeunload', function () {
                        staffUnloadAction();
                    });
                }
            }

            // Theme image editing hovers
            var els = $dom.$$('*:not(.no-theme-img-click)'), i, el, isImage;
            for (i = 0; i < els.length; i++) {
                el = els[i];
                isImage = (el.localName === 'img') || ((el.localName === 'input') && (el.type === 'image')) || $dom.css(el, 'background-image').includes('url');

                if (isImage) {
                    $dom.on(el, {
                        mouseover: handleImageMouseOver,
                        mouseout: handleImageMouseOut,
                        click: handleImageClick
                    });
                }
            }

            /* Thumbnail tooltips */
            if ($cms.isDevMode() || loc.replace($util.rel($cms.getBaseUrl()), '').includes('/cms/')) {
                var urlPatterns = $cms.staffTooltipsUrlPatterns(),
                    links, pattern, hook, patternRgx;

                links = $dom.$$('td a');
                for (pattern in urlPatterns) {
                    hook = urlPatterns[pattern];
                    patternRgx = new RegExp(pattern);

                    links.forEach(function (link) {
                        if ((link.href) && (!link.onmouseover) && !link.classList.contains('no-auto-tooltip')) {
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
                if (document.activeElement && (document.activeElement.href != null)) {
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
                var bi = $dom.$id('main-website-inner');
                if (bi) {
                    bi.classList.add('site-unloading');
                    $dom.fadeTo(bi, null, 0.2);
                }
                var div = document.createElement('div');
                div.className = 'unload_action';
                div.style.width = '100%';
                div.style.top = ($dom.getWindowHeight() / 2 - 160) + 'px';
                div.style.position = 'fixed';
                div.style.zIndex = 10000;
                div.style.textAlign = 'center';
                // Intentionally using $IMG instead of $IMG_INLINE as data URIs trigger a CSP warning when used during a 'beforeunload' event handler for some reason.
                $dom.html(div, '<div aria-busy="true" class="loading-box box"><h2>{!LOADING;^}</h2><img id="loading-image" alt="" width="20" height="20" src="' + $util.srl('{$IMG*;,loading}') + '" /></div>');
                setTimeout(function () {
                    // Stupid workaround for Google Chrome not loading an image on unload even if in cache
                    if ($dom.$('#loading-image')) {
                        $dom.$('#loading-image').src += '';
                    }
                }, 100);
                document.body.appendChild(div);

                // Allow unloading of the animation
                $dom.on(window, 'pageshow keydown click', $cms.undoStaffUnloadAction);
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
                    if (link.renderedTooltip === undefined) {
                        link.isOver = true;

                        $cms.doAjaxRequest($util.rel($cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?css=1&javascript=1&raw_output=1&box_title={!PREVIEW;&}' + $cms.keep())), null, 'data=' + encodeURIComponent(comcode)).then(function (xhr) {
                            if (xhr && xhr.responseText) {
                                link.renderedTooltip = xhr.responseText;
                            }
                            if (link.renderedTooltip !== undefined) {
                                if (link.isOver) {
                                    $cms.ui.activateTooltip(link, event, link.renderedTooltip, '400px', null, null, false, false, false, true);
                                }
                            }
                        });
                    } else {
                        $cms.ui.activateTooltip(link, event, link.renderedTooltip, '400px', null, null, false, false, false, true);
                    }
                });
            }

            /*
             THEME IMAGE CLICKING
             */
            function handleImageMouseOver(event) {
                var target = event.target;
                if (target.previousElementSibling && (target.previousElementSibling.classList.contains('magic-image-edit-link'))) {
                    return;
                }
                if (target.offsetWidth < 130) {
                    return;
                }

                var src = (target.src === undefined) ? $dom.css(target, 'background-image') : target.src;

                if ((target.src === undefined) && (!event.ctrlKey) && (!event.metaKey) && (!event.altKey)) {
                    return;  // Needs ctrl key for background images
                }
                if (!src.includes('/themes/') || ($cms.getPageName() === 'admin_themes')) {
                    return;
                }

                if ($cms.configOption('enable_theme_img_buttons')) {
                    // Remove other edit links
                    var old = document.querySelectorAll('.magic-image-edit-link');
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
                    ml.className = 'magic-image-edit-link button-micro';
                    ml.style.position = 'absolute';
                    ml.style.left = $dom.findPosX(target) + 'px';
                    ml.style.top = $dom.findPosY(target) + 'px';
                    ml.style.zIndex = 3000;
                    ml.style.display = 'none';
                    target.parentNode.insertBefore(ml, target);

                    if (target.moLink) {
                        clearTimeout(target.moLink);
                    }
                    target.moLink = setTimeout(function () {
                        if (ml) {
                            ml.style.display = 'block';
                        }
                    }, 2000);
                }

                window.oldStatusImg = window.status;
                window.status = '{!SPECIAL_CLICK_TO_EDIT;^}';
            }

            function handleImageMouseOut(event) {
                var target = event.target;

                if ($cms.configOption('enable_theme_img_buttons')) {
                    if (target.previousElementSibling && (target.previousElementSibling.classList.contains('magic-image-edit-link'))) {
                        if ((target.moLink !== undefined) && (target.moLink)) {// Clear timed display of new edit button
                            clearTimeout(target.moLink);
                            target.moLink = null;
                        }

                        // Time removal of edit button
                        if (target.moLink) {
                            clearTimeout(target.moLink);
                        }

                        target.moLink = setTimeout(function () {
                            if ((target.editWindow === undefined) || (!target.editWindow) || (target.editWindow.closed)) {
                                if (target.previousElementSibling && (target.previousElementSibling.classList.contains('magic-image-edit-link'))) {
                                    target.parentNode.removeChild(target.previousElementSibling);
                                }
                            }
                        }, 3000);
                    }
                }

                if (window.oldStatusImg === undefined) {
                    window.oldStatusImg = '';
                }
                window.status = window.oldStatusImg;
            }

            function handleImageClick(event, ob, force) {
                ob || (ob = this);

                var src = ob.origsrc ? ob.origsrc : ((ob.src == null) ? $dom.css(ob, 'background-image').replace(/.*url\(['"]?(.*)['"]?\).*/, '$1') : ob.src);
                if (src && (force || ($cms.magicKeypress(event)))) {
                    // Bubbling needs to be stopped because shift+click will open a new window on some lower event handler (in Firefox anyway)
                    event.preventDefault();

                    if (src.includes($util.rel($cms.getBaseUrl()) + '/themes/')) {
                        ob.editWindow = window.open('{$BASE_URL;,0}/adminzone/index.php?page=admin_themes&type=edit_image&lang=' + encodeURIComponent($cms.userLang()) + '&theme=' + encodeURIComponent($cms.getTheme()) + '&url=' + encodeURIComponent($cms.protectURLParameter(src.replace('{$BASE_URL;,0}/', ''))) + $cms.keep(), 'edit_theme_image_' + ob.id);
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
                if (document.readyState !== 'complete') {
                    // Probably not loaded yet
                    return null;
                }

                msg = strVal(msg);

                if (
                    (msg.includes('AJAX_REQUESTS is not defined')) || // Intermittent during page out-clicks

                    // LEGACY

                    // Internet Explorer false positives
                    (((msg.includes("'null' is not an object")) || (msg.includes("'undefined' is not a function"))) && ((file === undefined) || (file === 'undefined'))) || // Weird errors coming from outside
                    (((code === 0) || (code === '0')) && (msg.includes('Script error.'))) || // Too generic, can be caused by user's connection error

                    // Firefox false positives
                    (msg.includes("attempt to run compile-and-go script on a cleared scope")) || // Intermittent bugginess
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
                ) {
                    // Comes up on due to various Firefox/extension/etc bugs
                    return null;
                }

                if (!window.doneOneError) {
                    window.doneOneError = true;
                    var alert = '{!JAVASCRIPT_ERROR;^}\n\n' + code + ': ' + msg + '\n' + file;
                    if (document.body) { // i.e. if loaded
                        $cms.ui.alert(alert, '{!ERROR_OCCURRED;^}');
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
    function GlobalHelperPanel() {
        GlobalHelperPanel.base(this, 'constructor', arguments);
        this.contentsEl = this.$('.js-helper-panel-contents');
    }

    $util.inherits(GlobalHelperPanel, $cms.View, /**@lends GlobalHelperPanel#*/{
        events: function () {
            return {
                'click .js-click-toggle-helper-panel': 'toggleHelperPanel'
            };
        },
        toggleHelperPanel: function () {
            var show = $dom.notDisplayed(this.contentsEl),
                panelRight = $dom.$('#panel-right'),
                helperPanelContents = $dom.$('#helper-panel-contents'),
                helperPanelToggle = $dom.$('#helper-panel-toggle'),
                helperPanelToggleIcon = helperPanelToggle.querySelector('.icon');

            if (show) {
                panelRight.classList.remove('helper-panel-hidden');
                panelRight.classList.add('helper-panel-visible');
                helperPanelContents.setAttribute('aria-expanded', 'true');
                $dom.fadeIn(helperPanelContents);

                if ($cms.readCookie('hide_helper_panel') === '1') {
                    $cms.setCookie('hide_helper_panel', '0', 100);
                }

                helperPanelToggle.title = '{!HELP_OR_ADVICE}: {!HIDE}';
                $cms.setIcon(helperPanelToggleIcon, 'helper_panel/hide', '{$IMG;,icons/helper_panel/hide}');
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
                panelRight.classList.remove('helper-panel-visible');
                panelRight.classList.add('helper-panel-hidden');
                helperPanelContents.setAttribute('aria-expanded', 'false');
                helperPanelContents.style.display = 'none';
                $cms.setCookie('hide_helper_panel', '1', 100);
                helperPanelToggle.title = '{!HELP_OR_ADVICE}: {!SHOW}';
                $cms.setIcon(helperPanelToggleIcon, 'helper_panel/show', '{$IMG;,icons/helper_panel/show}');
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

    $util.inherits(Menu, $cms.View);

    // Templates:
    // MENU_dropdown.tpl
    // - MENU_BRANCH_dropdown.tpl
    $cms.views.DropdownMenu = DropdownMenu;
    /**
     * @memberof $cms.views
     * @class $cms.views.DropdownMenu
     * @extends Menu
     */
    function DropdownMenu(params) {
        DropdownMenu.base(this, 'constructor', arguments);

        this.menuContentEl = this.$('.js-el-menu-content');

        var isMobile = $cms.isCssMode('mobile'),
            that = this;
        $dom.on(window, 'resize orientationchange', $util.debounce(function () {
            if (isMobile !== $cms.isCssMode('mobile')) {
                // CSS mode changed, re-attach event listeners
                isMobile = $cms.isCssMode('mobile');
                that.delegateEvents();
            }
        }, 200));
    }

    $util.inherits(DropdownMenu, Menu, /**@lends $cms.views.DropdownMenu#*/{
        events: function () {
            var mobileEvents = {
                'click .js-click-toggle-menu-content': 'toggleMenuContent',
                'click .js-click-toggle-sub-menu': 'togleSubMenu'
            };

            var desktopEvents = {
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

            return $cms.isCssMode('mobile') ? mobileEvents : desktopEvents;
        },

        /* Mobile methods */

        toggleMenuContent: function (e) {
            e.preventDefault();
            $dom.toggle(this.menuContentEl);
        },

        togleSubMenu: function (e, clicked) {
            var subMenuId = clicked.dataset.vwSubMenuId;
            e.preventDefault();
            $dom.toggle('#' + subMenuId);
        },

        /* Desktop methods */

        timerPopUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            if (!target.timer) {
                target.timer = setTimeout(function () {
                    popupMenu(menu + '-dexpand-' + rand, 'below', menu + '-d');
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

            popupMenu(menu + '-dexpand-' + rand, 'below', menu + '-d', true);
        },

        popUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            popupMenu(menu + '-dexpand-' + rand, null, menu + '-d');
        },

        setActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                var menu = $cms.filter.id(this.menu);

                if (getActiveMenu() == null) {
                    setActiveMenu(target.id, menu + '_d');
                }
            }
        },

        unsetActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                setActiveMenu(null);
                recreateCleanTimeout();
            }
        },

        /* For admin/templates/MENU_dropdown.tpl */
        adminTimerPopUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            setMenuHoldTime(3000);
            if (!target.timer) {
                target.timer = setTimeout(function () {
                    popupMenu(menu + '-dexpand-' + rand, 'below', menu + '-d', true);
                    try {
                        document.getElementById('search-content').focus();
                    } catch (ignore) {}
                }, 200);
            }
        },
        adminClearPopUpTimer: function (e, target) {
            if (target.timer) {
                clearTimeout(target.timer);
                target.timer = null;
            }
        }
    });

    $cms.views.PopupMenu = PopupMenu;
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function PopupMenu() {
        PopupMenu.base(this, 'constructor', arguments);
    }

    $util.inherits(PopupMenu, Menu, /**@lends PopupMenu#*/{
        events: function () {
            return {
                'click .js-click-unset-active-menu': 'unsetActiveMenu',
                'mouseout .js-mouseout-unset-active-menu': 'unsetActiveMenu'
            };
        },

        unsetActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                setActiveMenu(null);
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
        this.popup = this.menu + '-pexpand-' + this.rand;
    }

    $util.inherits(PopupMenuBranch, $cms.View, /**@lends PopupMenuBranch#*/{
        events: function () {
            return {
                'focus .js-focus-pop-up-menu': 'popUpMenu',
                'mousemove .js-mousemove-pop-up-menu': 'popUpMenu',
                'mouseover .js-mouseover-set-active-menu': 'setActiveMenu'
            };
        },
        popUpMenu: function () {
            popupMenu(this.popup, null, this.menu + '-p');
        },
        setActiveMenu: function () {
            if (getActiveMenu() == null) {
                setActiveMenu(this.popup, this.menu + '-p');
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

    $util.inherits(TreeMenu, Menu, /**@lends TreeMenu#*/{
        events: function () {
            return {
                'click [data-menu-tree-toggle]': 'toggleMenu'
            };
        },

        toggleMenu: function (e, target) {
            var menuId = target.dataset.menuTreeToggle;

            $cms.ui.toggleableTray($dom.$('#' + menuId));
        }
    });

    // Templates:
    // MENU_mobile.tpl
    // - MENU_BRANCH_mobile.tpl
    $cms.views.MobileMenu = MobileMenu;
    /**
     * @memberof $cms.views
     * @class $cms.views.MobileMenu
     * @extends Menu
     */
    function MobileMenu() {
        MobileMenu.base(this, 'constructor', arguments);
        this.menuContentEl = this.$('.js-el-menu-content');
    }

    $util.inherits(MobileMenu, Menu, /**@lends $cms.views.MobileMenu#*/{
        events: function () {
            return {
                'click .js-click-toggle-content': 'toggleContent',
                'click .js-click-toggle-sub-menu': 'toggleSubMenu'
            };
        },
        toggleContent: function (e) {
            e.preventDefault();
            $dom.toggle(this.menuContentEl);
        },
        toggleSubMenu: function (e, link) {
            var subId = link.dataset.vwSubMenuId,
                subEl = this.$('#' + subId),
                href;

            if ($dom.notDisplayed(subEl)) {
                e.preventDefault();
                $dom.show(subEl);
            } else {
                href = link.type;
                // Second click goes to it
                if (href && !href.startsWith('#')) {
                    return;
                }
                e.preventDefault();
                $dom.hide(subEl);
            }
        }
    });

    // For admin/templates/MENU_mobile.tpl
    /**
     * @param params
     */
    $cms.templates.menuMobile = function menuMobile(params) {
        var menuId = strVal(params.menuId);
        $dom.on(document.body, 'click', '.js-click-toggle-' + menuId + '-content', function (e) {
            var branch = document.getElementById(menuId);

            if (branch) {
                $dom.toggle(branch.parentElement);
                e.preventDefault();
            }
        });
    };

    $cms.views.SelectMenu = SelectMenu;
    /**
     * @memberof $cms.views
     * @class $cms.views.SelectMenu
     * @extends Menu
     */
    function SelectMenu() {
        SelectMenu.base(this, 'constructor', arguments);
    }

    $util.inherits(SelectMenu, Menu, /**@lends $cms.views.SelectMenu#*/{
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
        var menuElement = $dom.$('#' + menuId),
            possibilities = [], isSelected, url, minScore, i;

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
                    return a.score - b.score;
                });

                minScore = Number(possibilities[0].score);
                for (i = 0; i < possibilities.length; i++) {
                    if (Number(possibilities[i].score) !== minScore) {
                        break;
                    }
                    possibilities[i].element.selected = true;
                }
            }
        } else {
            var menuItems = menuElement.querySelectorAll('.non-current'), a;
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

                url = (a.type === '') ? '' : a.href;
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
                    return a.score - b.score;
                });

                minScore = Number(possibilities[0].score);
                for (i = 0; i < possibilities.length; i++) {
                    if (Number(possibilities[i].score) !== minScore) {
                        break;
                    }
                    possibilities[i].element.classList.remove('non-current');
                    possibilities[i].element.classList.add('current');
                }
            }
        }

        /**
         * @param url
         * @return {number|null}
         */
        function menuItemIsSelected(url) {
            url = strVal(url);

            if (url === '') {
                return null;
            }

            var currentUrl = window.location.href;
            if (currentUrl === url) {
                return 0;
            }
            var globalBreadcrumbs = document.getElementById('global-breadcrumbs');

            if (globalBreadcrumbs) {
                var links = globalBreadcrumbs.querySelectorAll('a');
                for (var i = 0; i < links.length; i++) {
                    if (url === links[links.length - 1 - i].href) {
                        return i + 1;
                    }
                }
            }

            return null;
        }
    }

    var menuHoldTime = 500,
        activeMenu,
        cleanMenusTimeout,
        lastActiveMenu;

    function setMenuHoldTime(milliseconds) {
        menuHoldTime = milliseconds;
    }

    function setActiveMenu(id, menu) {
        activeMenu = id;
        if (menu != null) {
            lastActiveMenu = menu;
        }
    }

    function getActiveMenu() {
        return activeMenu;
    }

    function recreateCleanTimeout() {
        if (cleanMenusTimeout) {
            clearTimeout(cleanMenusTimeout);
        }
        cleanMenusTimeout = setTimeout(cleanMenus, menuHoldTime);
    }

    /**
     * @param popupId
     * @param place
     * @param menu
     * @param outsideFixedWidth
     */
    function popupMenu(popupId, place, menu, outsideFixedWidth) {
        popupId = strVal(popupId);
        place = strVal(place) || 'right';
        menu = strVal(menu);
        outsideFixedWidth = Boolean(outsideFixedWidth);

        var popupEl = $dom.$('#' + popupId);

        if (!popupEl) {
            return;
        }

        if (cleanMenusTimeout) {
            clearTimeout(cleanMenusTimeout);
        }

        if ($dom.isDisplayed(popupEl)) {
            return;
        }

        setActiveMenu(popupId);
        lastActiveMenu = menu;
        cleanMenus();

        var left = 0,
            top = 0;

        // Our own position computation as we are positioning relatively, as things expand out
        if ($dom.isCss(popupEl.parentElement.parentElement, 'position', 'absolute')) {
            left += popupEl.parentElement.offsetLeft;
            top += popupEl.parentElement.offsetTop;
        } else {
            var  offsetParent = popupEl.parentElement;
            while (offsetParent) {
                if (offsetParent && $dom.isCss(offsetParent, 'position', 'relative')) {
                    break;
                }

                left += offsetParent.offsetLeft;
                top += offsetParent.offsetTop - (parseInt(offsetParent.style.borderTop) || 0);
                offsetParent = offsetParent.offsetParent;

                if (offsetParent && $dom.isCss(offsetParent, 'position', 'absolute')) {
                    break;
                }
            }
        }
        if (place === 'below') {
            top += popupEl.parentElement.offsetHeight;
        } else {
            left += popupEl.parentElement.offsetWidth;
        }

        var fullHeight = $dom.getWindowScrollHeight(); // Has to be got before e is visible, else results skewed
        popupEl.style.position = 'absolute';
        popupEl.style.left = '0'; // Setting this lets the browser calculate a more appropriate (larger) width, before we set the correct left for that width will fit
        $dom.fadeIn(popupEl);

        var fullWidth = (window.scrollX === 0) ? $dom.getWindowWidth() : window.document.body.scrollWidth;

        if ($cms.configOption('fixed_width') && !outsideFixedWidth) {
            var mainWebsiteInner = document.getElementById('main-website-inner');
            if (mainWebsiteInner) {
                fullWidth = mainWebsiteInner.offsetWidth;
            }
        }

        var eParentWidth = popupEl.parentElement.offsetWidth;
        var eParentHeight = popupEl.parentElement.offsetHeight;
        var eWidth = popupEl.offsetWidth;

        popupEl.style.minWidth = eParentWidth + 'px';

        positionLeft();
        setTimeout(positionLeft, 0);
        positionTop();
        setTimeout(positionTop, 0);

        popupEl.style.zIndex = 200;

        recreateCleanTimeout();

        function positionLeft() {
            var posLeft = left;
            if (place === 'below') { // Top-level of drop-down
                if (posLeft + eWidth > fullWidth) {
                    posLeft += eParentWidth - eWidth;
                }
            } else { // NB: For non-below, we can't assume 'left' is absolute, as it is actually relative to parent node which is itself positioned
                if (($dom.findPosX(popupEl.parentNode, true) + eWidth + eParentWidth + 10) > fullWidth) {
                    posLeft -= eWidth + eParentWidth;
                }
            }
            popupEl.style.left = posLeft + 'px';
        }

        function positionTop() {
            var posTop = top;
            if (posTop + popupEl.offsetHeight + 10 > fullHeight) {
                var abovePosTop = posTop - $dom.contentHeight(popupEl) + eParentHeight - 10;
                if (abovePosTop > 0) {
                    posTop = abovePosTop;
                }
            }
            popupEl.style.top = posTop + 'px';
        }
    }

    function cleanMenus() {
        cleanMenusTimeout = null;

        var menuEl = $dom.$('#r-' + lastActiveMenu);
        if (!menuEl) {
            return;
        }
        var tags = menuEl.querySelectorAll('ul.nlevel, div.nlevel'),
            activeMenuEl = (getActiveMenu() != null) ? document.getElementById(getActiveMenu()) : null,
            hideable;

        for (var i = tags.length - 1; i >= 0; i--) {
            hideable = activeMenuEl ? !tags[i].contains(activeMenuEl) : true;
            if (hideable) {
                tags[i].style.left = '-999px';
                tags[i].style.display = 'none';
            }
        }
    }
}(window.$cms, window.$util, window.$dom));

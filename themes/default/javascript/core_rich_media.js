(function ($cms) {
    'use strict';

    $cms.views.Attachment = Attachment;
    $cms.views.Carousel = Carousel;
    $cms.views.ComcodeMediaSet = ComcodeMediaSet;

    function Attachment(params) {
        Attachment.base(this, 'constructor', arguments);

        preinit_file_input("attachment_multi", "file" + params.i, null, params.postingFieldName, params.filter);

        if (params.syndicationJson !== undefined) {
            $cms.requireJavascript('editing').then(function () {
                show_upload_syndication_options("file" + params.i, params.syndicationJson, !!params.noQuota);
            });
        }
    }

    $cms.inherits(Attachment, $cms.View, {
        events: function () {
            return {
                'change .js-inp-file-attachment': 'setAttachment'
            };
        },

        setAttachment: function () {
            set_attachment('post', this.params.i, '');
        }
    });

    function Carousel(params) {
        Carousel.base(this, 'constructor', arguments);

        var carouselId = strVal(params.carouselId),
            carouselNs = document.getElementById('carousel_ns_' + carouselId);

        this.mainEl = this.$('.main');

        carouselNs.parentNode.removeChild(carouselNs);
        this.mainEl.appendChild(carouselNs);
        this.el.style.display = 'block';

        var view = this;
        window.$cmsLoad.push(function () {
            view.$('.js-btn-car-move').style.height = view.mainEl.offsetHeight + 'px';

            view.createFaders();
            view.updateFaders();
        });
    }

    $cms.inherits(Carousel, $cms.View, /**@lends Carousel#*/{
        events: function () {
            return {
                'mousedown .js-btn-car-move': 'move',
                'keypress .js-btn-car-move': 'move'
            };
        },

        createFaders: function () {
            var mainEl = this.mainEl;
            var left = document.createElement('img');
            left.src = $cms.img('{$IMG;,carousel/fade_left}');
            left.style.position = 'absolute';
            left.style.left = '43px';
            left.style.top = '0';
            mainEl.parentNode.appendChild(left);

            var right = document.createElement('img');
            right.src = $cms.img('{$IMG;,carousel/fade_right}');
            right.style.position = 'absolute';
            right.style.right = '43px';
            right.style.top = '0';
            mainEl.parentNode.appendChild(right);
        },

        updateFaders: function () {
            var mainEl = this.mainEl,
                imgs = mainEl.parentNode.getElementsByTagName('img'),
                left = imgs[imgs.length - 2],
                right = imgs[imgs.length - 1];

            if (left.style.position === 'absolute') {// Check it really is a fader (stops bugs in other areas making bigger weirdness)
                left.style.visibility = (mainEl.scrollLeft == 0) ? 'hidden' : 'visible';
            }

            if (right.style.position === 'absolute'){// Ditto
                right.style.visibility = (mainEl.scrollLeft + mainEl.offsetWidth >= mainEl.scrollWidth - 1) ? 'hidden' : 'visible';
            }
        },

        move: function (e, btn) {
            var view = this,
                amount = btn.dataset.moveAmount;

            window.setTimeout(function () {
                view.carouselMove(amount);
            }, 10);
        },

        carouselMove: function (amount) {

            amount = +amount;

            if (amount > 0) {
                this.mainEl.scrollLeft += 3;
                amount--;
                if (amount < 0) {
                    amount = 0;
                }
            } else {
                this.mainEl.scrollLeft -= 3;
                amount++;
                if (amount > 0) {
                    amount = 0;
                }
            }

            this.updateFaders();
            var that = this;
            if (amount !== 0) {
                window.setTimeout(function () {
                    that.carouselMove(amount);
                }, 10);
            }
        }
    });

    function ComcodeMediaSet(params) {
        ComcodeMediaSet.base(this, 'constructor', arguments);

        if ($cms.$CONFIG_OPTION('js_overlays')) {
            this.setup(params);
        }
    }

    $cms.inherits(ComcodeMediaSet, $cms.View, {
        setup: function (params) {
            var imgs = window['imgs_' + params.rand] = [],
                imgsThumbs = window['imgs_thumbs_' + params.rand] = [],
                setImgWidthHeight = false,
                mediaSet = $cms.dom.$id('media_set_' + params.rand),
                as = window.as = mediaSet.querySelectorAll('a, video'),
                containsVideo = false,
                thumbWidthConfig = $cms.$CONFIG_OPTION('thumb_width') + 'x' + $cms.$CONFIG_OPTION('thumb_width'),
                i, x;

            if ((thumbWidthConfig !== 'x') && ((params.width + 'x' + params.height) !== 'x')) {
                setImgWidthHeight = true;
            }

            x = 0;
            for (i = 0; i < as.length; i++) {
                if (as[i].localName === 'video') {
                    var span = as[i].querySelector('span'),
                        title = '';

                    if (span) {
                        title = $cms.dom.html(span);
                        span.parentNode.removeChild(span);
                    }

                    imgs.push([$cms.dom.html(as[i]), title, true]);
                    imgsThumbs.push(as[i].poster || '{$IMG^;,video_thumb}');

                    containsVideo = true;

                    x++;

                } else if ((as[i].children.length === 1) && (as[i].firstElementChild.localName === 'img'))  {
                    as[i].title = as[i].title.replace('{!LINK_NEW_WINDOW^;}', '').replace(/^\s+/, '');

                    imgs.push([as[i].href, (as[i].title === '') ? as[i].firstElementChild.alt : as[i].title, false]);
                    imgsThumbs.push(as[i].firstElementChild.src);

                    as[i].addEventListener('click', (function (x) {
                        openImageIntoLightbox(imgs, x);
                        return false;
                    }).bind(undefined, x));

                    if (as[i].rel) {
                        as[i].rel = as[i].rel.replace('lightbox', '');
                    }

                    x++;
                }
            }

            // If you only want a single image-based thumbnail
            if (containsVideo) {// Remove this 'if' (so it always runs) if you do not want the grid-style layout (plus remove the media_set class from the outer div
                var width = params.width ? 'style="width: ' + Number(params.width) + 'px"' : '',
                    imgWidthHeight = setImgWidthHeight ? ' width="' + Number(params.width) + '" height="' + Number(params.height) + '"' : '',
                    mediaSetHtml = '\
					<figure class="attachment" ' + width + '>\
						<figcaption>' + $cms.format('{!comcode:MEDIA_SET;^}', imgs.length) + '<\/figcaption>\
						<div>\
							<div class="attachment_details">\
								<a class="js-click-open-images-into-lightbox" target="_blank" title="' + $cms.filter.html($cms.format('{!comcode:MEDIA_SET^;}', imgs.length)) + ' {!LINK_NEW_WINDOW^/}" href="#!">\
                                    <img ' + imgWidthHeight + ' src="' + $cms.filter.html(imgsThumbs[0]) + '" />\
                                <\/a>\
							<\/div>\
						<\/div>\
					<\/figure>';

                $cms.dom.html(mediaSet, mediaSetHtml);
                $cms.dom.on(mediaSet.querySelector('.js-click-open-images-into-lightbox'), 'click', function () {
                    openImageIntoLightbox(imgs);
                });
            }

            function openImageIntoLightbox(imgs, start) {
                start = +start || 0;

                var modal = $cms.ui.openImageIntoLightbox(imgs[start][0], imgs[start][1], start + 1, imgs.length, true, imgs[start][2]);
                modal.positionInSet = start;

                var previousButton = document.createElement('img');
                previousButton.className = 'previous_button';
                previousButton.src = $cms.img('{$IMG;,mediaset_previous}');
                previousButton.addEventListener('click', clickPreviousButton);
                function clickPreviousButton(e) {
                    e.stopPropagation();
                    e.preventDefault();

                    var new_position = modal.positionInSet - 1;
                    if (new_position < 0) {
                        new_position = imgs.length - 1;
                    }
                    modal.positionInSet = new_position;
                    _open_different_image_into_lightbox(modal, new_position, imgs);
                }

                modal.left = previous;
                modal.boxWrapperEl.firstElementChild.appendChild(previousButton);

                var next_button = document.createElement('img');
                next_button.className = 'next_button';
                next_button.src = $cms.img('{$IMG;,mediaset_next}');
                next_button.addEventListener('click', clickNextButton);
                function clickNextButton(e) {
                    e.stopPropagation();
                    e.preventDefault();

                    var new_position = modal.positionInSet + 1;
                    if (new_position >= imgs.length) {
                        new_position = 0;
                    }
                    modal.positionInSet = new_position;
                    _open_different_image_into_lightbox(modal, new_position, imgs);
                }

                modal.right = next;
                modal.boxWrapperEl.firstElementChild.appendChild(next_button);

                function _open_different_image_into_lightbox(modal, position, imgs) {
                    var is_video = imgs[position][2];

                    // Load proper image
                    window.setTimeout(function () { // Defer execution until the HTML was parsed
                        if (is_video) {
                            var video = document.createElement('video');
                            video.id = 'lightbox_image';
                            video.className = 'lightbox_image';
                            video.controls = 'controls';
                            video.autoplay = 'autoplay';
                            $cms.dom.html(video, imgs[position][0]);
                            video.addEventListener('loadedmetadata', function () {
                                $cms.ui.resizeLightboxDimensionsImg(modal, video, true, true);
                            });
                        } else {
                            var img = modal.top_window.document.createElement('img');
                            img.className = 'lightbox_image';
                            img.id = 'lightbox_image';
                            img.src = '{$IMG_INLINE;,loading}';
                            window.setTimeout(function () { // Defer execution until after loading is set
                                img.addEventListener('load', function () {
                                    $cms.ui.resizeLightboxDimensionsImg(modal, img, true, is_video);
                                });
                                img.src = imgs[position][0];
                            }, 0);
                        }

                        var lightbox_description = modal.top_window.$cms.dom.$id('lightbox_description'),
                            lightbox_position_in_set_x = modal.top_window.$cms.dom.$id('lightbox_position_in_set_x');

                        if (lightbox_description) {
                            $cms.dom.html(lightbox_description, imgs[position][1]);
                        }

                        if (lightbox_position_in_set_x) {
                            $cms.dom.html(lightbox_position_in_set_x, position + 1);
                        }
                    });
                }

            }
        }
    });

    function AttachmentsBrowser() {
        AttachmentsBrowser.base(this, 'constructor', arguments);
    }

    $cms.inherits(AttachmentsBrowser, $cms.View, {
        events: function () {
            return {
                'click .js-click-do-attachment-and-close': 'doAttachmentAndClose'
            };
        },
        doAttachmentAndClose: function () {
            var params = this.params,
                fieldName = params.fieldName || '',
                id = params.id || '',
                description = params.description || '';

            do_attachment(fieldName, id, description);
            (window.faux_close !== undefined) ? window.faux_close() :  window.close();
        }
    });

    $cms.functions.comcodeToolsComcodeConvertScript = function comcodeToolsComcodeConvertScript() {
        var form = $cms.dom.$('#semihtml').form;

        form.elements['from_html'][0].addEventListener('click', refresh_locked_inputs);
        form.elements['from_html'][1].addEventListener('click', refresh_locked_inputs);
        form.elements['from_html'][2].addEventListener('click', refresh_locked_inputs);

        function refresh_locked_inputs() {
            var value = $cms.form.radioValue(form.elements['from_html']);
            $cms.dom.$('#semihtml').disabled = (value != 0);
            $cms.dom.$('#is_semihtml').disabled = (value != 0);
            $cms.dom.$('#lax').disabled = (value != 0);
            $cms.dom.$('#fix_bad_html').disabled = (value == 1);
            $cms.dom.$('#force').disabled = (value != 1);
        }
    };

    $cms.functions.comcodeAddTryForSpecialComcodeTag = function comcodeAddTryForSpecialComcodeTag() {
        document.getElementById('framed').addEventListener('change', function () {
            if (this.checked && document.getElementById('_safe')) {
                document.getElementById('_safe').checked = false;
            }
        })
    };

    $cms.templates.comcodeMemberLink = function comcodeMemberLink(params, container) {
        $cms.dom.on(container, 'mouseover', '.js-mouseover-comcode-member-link', activateComcodeMemberLink);
        $cms.dom.on(container, 'focus', '.js-focus-comcode-member-link', activateComcodeMemberLink);

        function activateComcodeMemberLink(e, el) {
            el.cancelled = false;
            $cms.loadSnippet('member_tooltip&member_id=' + params.memberId, null, function (result) {
                if (!el.cancelled) {
                    $cms.ui.activateTooltip(el, e, result.responseText, 'auto', null, null, false, true);
                }
            })
        }

        $cms.dom.on(container, 'mouseout', '.js-mouseout-comcode-member-link', function (e, el) {
            $cms.ui.deactivateTooltip(el);
            el.cancelled = true;
        });
    };

    $cms.templates.comcodeMessage = function comcodeMessage(params, container) {
        var name = strVal(params.name);

        $cms.dom.on(container, 'click', '.js-link-click-open-emoticon-chooser-window', function (e, link) {
            var url = $cms.maintainThemeInLink(link.href);
            $cms.ui.open(url, 'field_emoticon_chooser', 'width=300,height=320,status=no,resizable=yes,scrollbars=no');
        });

        $cms.dom.on(container, 'click', '.js-click-toggle-wysiwyg', function () {
            toggle_wysiwyg(name);
        });
    };

    $cms.templates.comcodeTabHead = function comcodeTabHead(params, container) {
        var tabSets = $cms.filter.id(params.tabSets),
            title = $cms.filter.id(params.title);

        $cms.dom.on(container, 'click', function () {
            $cms.ui.selectTab('g', tabSets + '_' + title);
        });
    };

    $cms.templates.attachments = function attachments(params, container) {
        window.attachment_template = params.attachmentTemplate;
        window.max_attachments = +params.maxAttachments || 0;
        window.num_attachments = +params.numAttachments || 0;

        $cms.dom.on(container, 'click', '.js-click-open-attachment-popup', function (e, link) {
            e.preventDefault();
            $cms.ui.open($cms.maintainThemeInLink(link.href), 'site_attachment_chooser', 'width=550,height=600,status=no,resizable=yes,scrollbars=yes');
        });

        window.rebuild_attachment_button_for_next = rebuild_attachment_button_for_next;
        function rebuild_attachment_button_for_next(posting_field_name, attachment_upload_button) {
            if (posting_field_name !== params.postingFieldName) {
                return false;
            }

            if (attachment_upload_button === undefined) {
                attachment_upload_button = window.attachment_upload_button; // Use what was used last time
            }
            window.attachment_upload_button = attachment_upload_button;

            $cms.requireJavascript('plupload').then(function () {
                prepare_simplified_file_input('attachment_multi', 'file' + window.num_attachments, null, params.postingFieldName, strVal(params.filter), window.attachment_upload_button);
            });
        }

        if (params.simpleUi) {
            window.num_attachments = 1;

            window.$cmsLoad.push(function () {
                if (document.getElementById('attachment_upload_button')) {
                    window.rebuild_attachment_button_for_next(params.postingFieldName, 'attachment_upload_button');
                }
            });
        }
    };

    $cms.templates.comcodeImg = function comcodeImg(params) {
        var img = this,
            refreshTime = +params.refreshTime || 0;

        if ((typeof params.rollover === 'string') && (params.rollover !== '')) {
            $cms.createRollover(img.id, params.rollover);
        }

        if (refreshTime > 0) {
            window.setInterval(function () {
                if (!img.timer) {
                    img.timer = 0;
                }
                img.timer += refreshTime;

                if (img.src.indexOf('?') == -1) {
                    img.src += '?time=' + img.timer;
                } else if (img.src.indexOf('time=') == -1) {
                    img.src += '&time=' + img.timer;
                } else {
                    img.src = img.src.replace(/time=\d+/, 'time=' + img.timer);
                }
            }, refreshTime)
        }
    };

    $cms.templates.comcodeEditorButton = function comcodeEditorButton(params, btn) {
        var isPostingField = !!params.isPostingField && (params.isPostingField !== '0'),
            b = strVal(params.b),
            fieldName = strVal(params.fieldName);

        $cms.dom.on(btn, 'click', function () {
            var mainWindow = btn.ownerDocument.defaultView || btn.ownerDocument.parentWindow;
            if (!($cms.browserMatches('simplified_attachments_ui') && isPostingField && ((b === 'thumb') || (b === 'img')))) {
                mainWindow['do_input_' + b](fieldName);
            }
        });
    };

    $cms.templates.comcodeRandom = function comcodeRandom(params) {
        var rand, part, use, comcoderandom;

        rand = window.parseInt(Math.random() * params.max);

        for (var key in params.parts) {
            part = params.parts[key];
            use = part.val;

            if (part.num > rand) {
                break;
            }
        }

        comcoderandom = document.getElementById('comcoderandom' + params.randIdRandom);
        $cms.dom.html(comcoderandom, use);
    };

    $cms.templates.comcodePulse = function (params) {
        var id = 'pulse_wave_' + params.randIdPulse;

        window[id] = [0, params.maxColor, params.minColor, params.speed, []];
        window.setInterval(function() {
            process_wave(document.getElementById(id));
        }, params.speed);
    };

    $cms.templates.comcodeShocker = function (params) {
        var id = params.randIdShocker,
            parts = param.parts || [], part,
            time = +params.time;

        window.shocker_parts || (window.shocker_parts = {});
        window.shocker_pos || (window.shocker_pos = {});

        window.shocker_parts[id] = [];
        window.shocker_pos[id] = 0;

        for (var i = 0, len = parts.length; i < len; i++) {
            part = parts[i];
            window.shocker_parts[id].push([part.left, part.right]);
        }

        shocker_tick(id, time, params.maxColor, params.minColor);
        window.setInterval(function () {
            shocker_tick(id, time, params.maxColor, params.minColor);
        }, time);
    };

    $cms.templates.comcodeSectionController = function (params) {
        var container = this,
            passId = $cms.filter.id(params.passId),
            id = 'a' + passId + '_sections';

        window[id] = [];

        for (var i = 0, len = params.sections.length; i < len; i++) {
            window[id].push(params.sections[i]);
        }

        flip_page(0, passId, id);

        $cms.dom.on(container, 'click', '.js-click-flip-page', function (e, clicked) {
            var flipTo = (clicked.dataset.vwFlipTo !== undefined) ? clicked.dataset.vwFlipTo : 0;
            if ($cms.isNumeric(flipTo)) {
                flipTo = +flipTo;
            }

            flip_page(flipTo, passId, id);
        });
    };

    $cms.templates.emoticonClickCode = function emoticonClickCode(params, container) {
        var fieldName = strVal(params.fieldName);

        $cms.dom.on(container, 'click', function () {
            do_emoticon(fieldName, container, false)
        });
    };

    $cms.templates.comcodeOverlay = function comcodeOverlay(params) {
            var container = this, id = params.id;

            $cms.dom.on(container, 'click', '.js-click-dismiss-overlay', function () {
                var bi = document.getElementById('main_website_inner');
                if (bi) {
                    $cms.dom.clearTransitionAndSetOpacity(bi, 1.0);
                }

                document.getElementById(params.randIdOverlay).style.display = 'none';

                if (id) {
                    $cms.setCookie('og_' + id, '1', 365);
                }
            });

            if (!id || ($cms.readCookie('og_' + id) !== '1')) {
                window.setTimeout(function() {
                    var element, bi;

                    $cms.dom.smoothScroll(0);

                    element = document.getElementById(params.randIdOverlay);
                    element.style.display = 'block';
                    element.parentNode.removeChild(element);
                    document.body.appendChild(element);

                    bi = document.getElementById('main_website_inner');

                    if (bi) {
                        $cms.dom.clearTransitionAndSetOpacity(bi, 0.4);
                    }

                    $cms.dom.clearTransitionAndSetOpacity(element, 0.0);
                    $cms.dom.fadeTransition(element, 100, 30, 3);


                    if (params.timeout !== '-1') {
                        window.setTimeout(function () {
                            if (bi) {
                                $cms.dom.clearTransitionAndSetOpacity(bi, 1.0);
                            }

                            if (element) {
                                element.style.display = 'none';
                            }
                        }, params.timeout);
                    }
                }, params.timein + 100);
            }
        };

    $cms.templates.comcodeBigTabsController = function (params) {
            var container = this,
                passId = $cms.filter.id(params.passId),
                id = passId + '_' + params.bigTabSets,
                fullId = 'a' + id + '_big_tab',
                tabs = params.tabs,
                sections = [], i;

            /* Precache images */
            new Image().src = $cms.img('{$IMG;,big_tabs_controller_button}');
            new Image().src = $cms.img('{$IMG;,big_tabs_controller_button_active}');
            new Image().src = $cms.img('{$IMG;,big_tabs_controller_button_top_active}');
            new Image().src = $cms.img('{$IMG;,big_tabs_controller_button_top}');

            for (i = 0; i < tabs.length; i++) {
                sections.push($cms.filter.id(tabs[i]));
            }

            window[fullId] = sections;
            window['big_tabs_auto_cycler_' + id] = null;

            if (params.switchTime !== undefined) {
                window['big_tabs_switch_time_' + id] = params.switchtime;
                window['move_between_big_tabs_' + id] = function () {
                    var next_page = 0, i, x;

                    for (i = 0; i < sections.length; i++) {
                        x = document.getElementById(id + '_section_' + sections[i]);
                        if ((x.style.display === 'block') && (x.style.position !== 'absolute')) {
                            next_page = i + 1;
                        }
                    }

                    if (next_page === sections.length) {
                        next_page = 0;
                    }

                    flip_page(sections[next_page], id, sections);
                };

                flip_page(0, id, sections);
            }

            $cms.dom.on(container, 'click', '.js-click-flip-page', function (e, clicked) {
                var flipTo = (clicked.dataset.vwFlipTo !== undefined) ? clicked.dataset.vwFlipTo : 0;
                if ($cms.isNumeric(flipTo)) {
                    flipTo = Number(flipTo);
                }

                flip_page(flipTo, id, fullId);
            });
        };

    $cms.templates.comcodeTabBody = function (params) {
            var title = $cms.filter.id(params.title);

            if (params.blockCallUrl) {
                window['load_tab__' + title] = function () {
                    $cms.callBlock(params.blockCallUrl, '', document.getElementById('g_' + title));
                };
            }
        };

    $cms.templates.comcodeTicker = function (params, container) {
        window.tick_pos || (window.tick_pos = []);

        var width = $cms.filter.id(params.width),
            id = $cms.random();

        window.tick_pos[id] = params.width;
        $cms.dom.html(container, '<div class="ticker" style="text-indent: ' + width + 'px; width: ' + width + 'px;" id="' + id + '"><span>' +
            $cms.filter.nl(params.text) + '<\/span><\/div>'
        );

        window.setInterval(function () {
            ticker_tick(id, params.width);
        }, 100 / params.speed);
    };

    $cms.templates.comcodeJumping = function (params, container) {
        var id = $cms.random();

        window.jumper_parts[id] = [];
        window.jumper_pos[id] = 1;

        for (var i = 0, len = params.parts.length; i < len; i++) {
            window.jumper_parts[id].push(params.parts[i]);
        }

        $cms.dom.html(container, '<span id="' + id + '">' + window.jumper_parts[id][0] + '<\/span>');

        window.setInterval(function () {
            jumper_tick(id);
        }, params.time);
    };

    $cms.templates.mediaYoutube = function (params, element) {
            // Tie into callback event to see when finished, for our slideshows}
            // API: https://developers.google.com/youtube/iframe_api_reference}
            var youtube_callback = function () {
                var slideshow_mode = document.getElementById('next_slide');
                var player = new YT.Player(element.id, {
                    width: params.width,
                    height: params.height,
                    videoId: params.remoteId,
                    events: {
                        'onReady': function () {
                            if (slideshow_mode) {
                                player.playVideo();
                            }
                        },
                        'onStateChange': function (newState) {
                            if (slideshow_mode) {
                                if (newState == 0) player_stopped();
                            }
                        }
                    }
                });
            };

            if (window.done_youtube_player_init === undefined) {
                var tag = document.createElement('script');
                tag.src = "https://www.youtube.com/iframe_api";
                var first_script_tag = document.querySelector('script');
                first_script_tag.parentNode.insertBefore(tag, first_script_tag);
                window.done_youtube_player_init = true;

                window.onYouTubeIframeAPIReady = youtube_callback;
            } else {
                youtube_callback();
            }
        };

    $cms.templates.mediaRealmedia = function (params) {
        // Tie into callback event to see when finished, for our slideshows
        // API: http://service.real.com/help/library/guides/realone/ScriptingGuide/PDF/ScriptingGuide.pdf
        window.$cmsLoad.push(function () {
            if (document.getElementById('next_slide')) {
                stop_slideshow_timer();
                window.setTimeout(function () {
                    document.getElementById(params.playerId).addEventListener('stateChange', function (newState) {
                        if (newState == 0) {
                            player_stopped();
                        }
                    });
                    document.getElementById(params.playerId).DoPlay();
                }, 1000);
            }
        });
    };

    $cms.templates.mediaQuicktime = function (params) {
        // Tie into callback event to see when finished, for our slideshows
        // API: http://developer.apple.com/library/safari/#documentation/QuickTime/Conceptual/QTScripting_JavaScript/bQTScripting_JavaScri_Document/QuickTimeandJavaScri.html
        window.$cmsLoad.push(function () {
            if (document.getElementById('next_slide')) {
                stop_slideshow_timer();
                window.setTimeout(function () {
                    document.getElementById(params.playerId).addEventListener('qt_ended', function () {
                        player_stopped();
                    });
                    document.getElementById(params.playerId).Play();
                }, 1000);
            }
        });
    };

    $cms.templates.mediaVideoGeneral = function (params) {
            // Tie into callback event to see when finished, for our slideshows
            // API: http://developer.apple.com/library/safari/#documentation/QuickTime/Conceptual/QTScripting_JavaScript/bQTScripting_JavaScri_Document/QuickTimeandJavaScri.html
            // API: http://msdn.microsoft.com/en-us/library/windows/desktop/dd563945(v=vs.85).aspx
        window.$cmsLoad.push(function () {
                if (document.getElementById('next_slide')) {
                    stop_slideshow_timer();

                    window.setTimeout(function () {
                        var player = document.getElementById(params.playerId);
                        // WMP
                        player.addEventListener('playstatechange', function (newState) {
                            if (newState == 1) {
                                player_stopped();
                            }
                        });

                        // Quicktime
                        player.addEventListener('qt_ended', function () {
                            player_stopped();
                        });

                        try {
                            player.Play();
                        } catch (e) {
                        }
                        try {
                            player.controls.play();
                        } catch (e) {
                        }
                    }, 1000);
                }
            });
        };

    $cms.templates.mediaVimeo = function (params) {
            // Tie into callback event to see when finished, for our slideshows}
            if (document.getElementById('next_slide')) {
                stop_slideshow_timer();
                window.setTimeout(function () {
                    window.addEventListener('message', player_stopped, false);

                    var player = document.getElementById(params.playerId);
                    player.contentWindow.postMessage(JSON.stringify({method: 'addEventListener', value: 'finish'}), 'https://player.vimeo.com/video/' + params.remoteId);
                }, 1000);
            }
        };

        // API: http://www.longtailvideo.com/support/jw-player/jw-player-for-flash-v5/12540/javascript-api-reference
        // Carefully tuned to avoid this problem: http://www.longtailvideo.com/support/forums/jw-player/setup-issues-and-embedding/8439/sound-but-no-video
    $cms.templates.mediaAudioWebsafe = function (params) {
        var playerOptions = {
            width: params.width,
            height: params.height,
            autostart: false,
            file: params.url,
            type: params.type,
            image: params.thumbUrl,
            flashplayer: params.flashplayer,
            events: {
                onComplete: function () {
                    if (document.getElementById('next_slide')) {
                        player_stopped();
                    }
                },
                onReady: function () {
                    if (document.getElementById('next_slide')) {
                        stop_slideshow_timer();
                        jwplayer(params.playerId).play(true);
                    }
                }
            }
        };

        if (params.duration) {
            playerOptions.duration = params.duration;
        }

        if (!($cms.$CONFIG_OPTION('show_inline_stats'))) {
            playerOptions.events.onPlay = function () {
                $cms.gaTrack(null, '{!AUDIO;^}', params.url);
            };
        }

        jwplayer(params.playerId).setup(playerOptions);
    };

        // API: http://www.longtailvideo.com/support/jw-player/jw-player-for-flash-v5/12540/javascript-api-reference
        // Carefully tuned to avoid this problem: http://www.longtailvideo.com/support/forums/jw-player/setup-issues-and-embedding/8439/sound-but-no-video
    $cms.templates.mediaVideoWebsafe = function (params) {
        var playerOptions = {
            autostart: false,
            file: params.url,
            type: params.type,
            image: params.thumbUrl,
            flashplayer: params.flashplayer,
            events: {
                onComplete: function () {
                    if (document.getElementById('next_slide')) player_stopped();
                },
                onReady: function () {
                    if (document.getElementById('next_slide')) {
                        stop_slideshow_timer();
                        jwplayer(params.playerId).play(true);
                    }
                }
            }
        };

        if (params.duration) {
            playerOptions.duration = params.duration;
        }

        if (params.playerWidth) {
            playerOptions.width = params.playerWidth;
        }

        if (params.playerHeight) {
            playerOptions.height = params.playerHeight;
        }

        if (!$cms.$CONFIG_OPTION('show_inline_stats')) {
            playerOptions.events.onPlay = function () {
                $cms.gaTrack(null, '{!VIDEO;^}', params.url);
            };
        }

        jwplayer(params.playerId).setup(playerOptions);
    };


    function shocker_tick(id, time, min_color, max_color) {
        if ((document.hidden !== undefined) && (document.hidden)) return;

        if (window.shocker_pos[id] == window.shocker_parts[id].length - 1) window.shocker_pos[id] = 0;
        var e_left = document.getElementById('comcodeshocker' + id + '_left');
        if (!e_left) return;
        $cms.dom.html(e_left, window.shocker_parts[id][window.shocker_pos[id]][0]);
        $cms.dom.clearTransitionAndSetOpacity(e_left, 0.6);
        $cms.dom.clearTransitionAndSetOpacity(e_left, 0.0);
        $cms.dom.fadeTransition(e_left, 100, time / 40, 5);

        var e_right = document.getElementById('comcodeshocker' + id + '_right');
        if (!e_right) return;
        $cms.dom.html(e_right, window.shocker_parts[id][window.shocker_pos[id]][1]);
        $cms.dom.clearTransitionAndSetOpacity(e_right, 0);
        $cms.dom.clearTransitionAndSetOpacity(e_right, 0.0);
        $cms.dom.fadeTransition(e_right, 100, time / 20, 5);

        window.shocker_pos[id]++;

        window['comcodeshocker' + id + '_left'] = [0, min_color, max_color, time / 13, []];
        window.setInterval(function () {
            process_wave(e_left);
        }, window['comcodeshocker' + id + '_left'][3]);
    }

    function flip_page(to, pass_id, sections) {
        var i, current_pos = 0, section;

        if (window['big_tabs_auto_cycler_' + pass_id]) {
            window.clearTimeout(window['big_tabs_auto_cycler_' + pass_id]);
            window['big_tabs_auto_cycler_' + pass_id] = null;
        }

        if (typeof to === 'number') {
            for (i = 0; i < sections.length; i++) {
                section = document.getElementById(pass_id + '_section_' + sections[i]);
                if (section) {
                    if ((section.style.display === 'block') && (section.style.position !== 'absolute')) {
                        current_pos = i;
                        break;
                    }
                }
            }

            current_pos += to;
        } else {
            for (i = 0; i < sections.length; i++) {
                if (sections[i] == to) {
                    current_pos = i;
                    break;
                }
            }
        }

        // Previous/next updates
        var x;
        x = document.getElementById(pass_id + '_has_next_yes');
        if (x) {
            x.style.display = (current_pos == sections.length - 1) ? 'none' : 'inline-block';
        }
        x = document.getElementById(pass_id + '_has_next_no');
        if (x) {
            x.style.display = (current_pos == sections.length - 1) ? 'inline-block' : 'none';
        }
        x = document.getElementById(pass_id + '_has_previous_yes');
        if (x) {
            x.style.display = (current_pos == 0) ? 'none' : 'inline-block';
        }
        x = document.getElementById(pass_id + '_has_previous_no');
        if (x) {
            x.style.display = (current_pos == 0) ? 'inline-block' : 'none';
        }

        // We make our forthcoming one instantly visible to stop Google Chrome possibly scrolling up if there is a tiny time interval when none are visible
        x = document.getElementById(pass_id + '_section_' + sections[i]);
        if (x) x.style.display = 'block';

        for (i = 0; i < sections.length; i++) {
            x = document.getElementById(pass_id + '_goto_' + sections[i]);
            if (x) {
                x.style.display = (i == current_pos) ? 'none' : 'inline-block';
            }
            x = document.getElementById(pass_id + '_btgoto_' + sections[i]);
            if (x) {
                x.classList.toggle('big_tab_active', (i == current_pos));
                x.classList.toggle('big_tab_inactive', (i != current_pos));
            }
            x = document.getElementById(pass_id + '_isat_' + sections[i]);
            if (x) {
                x.style.display = (i == current_pos) ? 'inline-block' : 'none';
            }
            x = document.getElementById(pass_id + '_section_' + sections[i]);
            var current_place = document.getElementById(pass_id + '_section_' + sections[current_pos]);
            //var width=current_place?'100%':null;
            var width = current_place ? $cms.dom.contentWidth(current_place) : null;
            if (x) {
                if (x.className === 'comcode_big_tab') {
                    if (i == current_pos) {
                        $cms.dom.clearTransition(x);
                        x.style.width = '';
                        x.style.position = 'static';
                        x.style.zIndex = 10;
                        $cms.dom.clearTransitionAndSetOpacity(x, 1.0);
                    } else {
                        if (x.style.position !== 'static') {
                            $cms.dom.clearTransitionAndSetOpacity(x, 0.0);
                        } else {
                            $cms.dom.clearTransitionAndSetOpacity(x, 1.0);
                        }

                        if (!$cms.dom.hasFadeTransition(x)) {
                            $cms.dom.fadeTransition(x, 0, 30, -5);
                        }
                        x.style.width = (x.offsetWidth - 24) + 'px'; // 24=lhs padding+rhs padding+lhs border+rhs border
                        x.style.position = 'absolute';
                        x.style.zIndex = -10;
                        x.style.top = '0';
                        x.parentNode.style.position = 'relative';
                    }
                    x.style.display = 'block';
                    //x.style.width=width+'px';
                } else {
                    x.style.display = (i == current_pos) ? 'block' : 'none';

                    if (i == current_pos) {
                        $cms.dom.clearTransitionAndSetOpacity(x, 0.0);
                        $cms.dom.fadeTransition(x, 100, 30, 4);
                    }
                }
            }
        }

        if (window['move_between_big_tabs_' + pass_id]) {
            window['big_tabs_auto_cycler_' + pass_id] = window.setInterval(window['move_between_big_tabs_' + pass_id], window['big_tabs_switch_time_' + pass_id]);
        }

        return false;
    }


    // =======
    // COMCODE
    // =======
    window.countdown = countdown;
    function countdown(id, direction, tailing) {
        var countdown = (typeof id === 'object') ? id : document.getElementById(id), i;
        var inside = $cms.dom.html(countdown);
        var multiples = [];
        if (tailing >= 4) multiples.push(365);
        if (tailing >= 3) multiples.push(24);
        if (tailing >= 2) multiples.push(60);
        if (tailing >= 1) multiples.push(60);
        multiples.push(1);
        var us = inside.match(/\d+/g);
        var total = 0, multiplier = 1;

        while (multiples.length > us.length) {
            us.push('0');
        }

        for (i = us.length - 1; i >= 0; i--) {
            multiplier *= multiples[i];
            total += window.parseInt(us[i]) * multiplier;
        }

        if (total > 0) {
            total += direction;
            inside = inside.replace(/\d+/g, '!!!');

            if (total == 0) {
                countdown.className = 'red_alert';
            }

            for (i = 0; i < us.length; i++) {
                us[i] = Math.floor(total / multiplier);
                total -= us[i] * multiplier;
                multiplier /= multiples[i];
                inside = inside.replace('!!!', us[i]);
            }

            $cms.dom.html(countdown, inside);
        }
    }


    window.tick_pos || (window.tick_pos = []);

    window.ticker_tick = ticker_tick;
    function ticker_tick(id, width) {
        if (document.hidden === true) {
            return;
        }

        var el = document.getElementById(id);
        if (!el || $cms.dom.$('#' + id + ':hover')) {
            return;
        }

        el.style.textIndent = window.tick_pos[id] + 'px';
        window.tick_pos[id]--;
        if (window.tick_pos[id] < -1.1 * el.children[0].offsetWidth) {
            window.tick_pos[id] = width;
        }
    }

    window.jumper_pos || (window.jumper_pos = []);
    window.jumper_parts || (window.jumper_parts = []);

    window.jumper_tick = jumper_tick;
    function jumper_tick(id) {
        if (document.hidden === true) {
            return;
        }

        if (window.jumper_pos[id] === (window.jumper_parts[id].length - 1)) {
            window.jumper_pos[id] = 0;
        }
        var el = document.getElementById(id);
        if (!el) {
            return;
        }
        $cms.dom.html(el, window.jumper_parts[id][window.jumper_pos[id]]);
        window.jumper_pos[id]++;
    }

    window.crazy_tick = crazy_tick;
    function crazy_tick() {
        if (window.mouse_x == null) {
            return;
        }
        if (window.mouse_y == null) {
            return;
        }

        var e, i, s_width, biasx, biasy;
        for (i = 0; i < window.crazy_criters.length; i++) {
            e = document.getElementById(window.crazy_criters[i]);
            s_width = e.clientWidth;

            biasx = window.mouse_x - e.offsetLeft;
            if (biasx > 0) {
                biasx = 2;
            } else {
                biasx = -1;
            }

            if (Math.random() * 4 < 1) {
                biasx = 0;
            }

            biasy = window.mouse_y - e.offsetTop;
            if (biasy > 0) {
                biasy = 2;
            } else {
                biasy = -1;
            }

            if (Math.random() * 4 < 1) {
                biasy = 0;
            }

            if (s_width < 100) {
                e.style.width = (s_width + 1) + 'px';
            }

            e.style.left = (e.offsetLeft + (Math.random() * 2 - 1 + biasx) * 30) + 'px';
            e.style.top = (e.offsetTop + (Math.random() * 2 - 1 + biasy) * 30) + 'px';
            e.style.position = 'absolute';
        }
    }
}(window.$cms));

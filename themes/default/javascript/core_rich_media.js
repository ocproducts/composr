(function (Composr) {
    'use strict';

    Composr.behaviors.coreRichMedia = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core_rich_media');
                Composr.initializeTemplates(context, 'core_rich_media');
            }
        }
    };

    var Attachment = Composr.View.extend({
        initialize: function (v, options) {
            Attachment.__super__.initialize.apply(this, arguments);

            preinit_file_input("attachment_multi", "file" + options.i, null, options.postingFieldName, options.filter);

            if (options.syndicationJson !== undefined) {
                show_upload_syndication_options("file" + options.i, options.syndicationJson, Composr.is(options.noQuota));
            }
        },

        events: {
            'change .js-inp-file-attachment': 'setAttachment'
        },

        setAttachment: function () {
            set_attachment('post', this.options.i, '');
        }
    });

    var Carousel = Composr.View.extend({
        mainEl: null,
        initialize: function (v, options) {
            Carousel.__super__.initialize.apply(this, arguments);
            var view = this,
                id = options.carouselId,
                carousel_ns = document.getElementById('carousel_ns_' + id);

            view.mainEl = view.el.querySelector('.main');

            carousel_ns.parentNode.removeChild(carousel_ns);
            view.mainEl.appendChild(carousel_ns);
            view.el.style.display = 'block';

            Composr.load.then(function () {
                view.$('.js-btn-car-move').style.height = view.mainEl.offsetHeight + 'px';

                view.createFaders();
                view.updateFaders();
            });
        },

        createFaders: function () {
            var mainEl = this.mainEl;
            var left = document.createElement('img');
            left.src = Composr.url('{$IMG;,carousel/fade_left}');
            left.style.position = 'absolute';
            left.style.left = '43px';
            left.style.top = '0';
            mainEl.parentNode.appendChild(left);

            var right = document.createElement('img');
            right.src = Composr.url('{$IMG;,carousel/fade_right}');
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

        events: {
            'mousedown .js-btn-car-move': 'move',
            'keypress .js-btn-car-move': 'move'
        },

        move: function (e, btn) {
            var view = this,
                amount = btn.dataset.moveAmount;

            window.setTimeout(function () {
                view.carouselMove(amount);
            }, 10);
        },

        carouselMove: function (amount) {
            var view = this;
            amount = +amount;

            if (amount > 0) {
                view.mainEl.scrollLeft += 3;
                amount--;
                if (amount < 0) {
                    amount = 0;
                }
            } else {
                view.mainEl.scrollLeft -= 3;
                amount++;
                if (amount > 0) {
                    amount = 0;
                }
            }

            view.updateFaders();

            if (amount !== 0) {
                window.setTimeout(function () {
                    view.carouselMove(amount);
                }, 10);
            }
        }
    });

    var ComcodeMediaSet = Composr.View.extend({
        initialize: function (v, options) {
            ComcodeMediaSet.__super__.initialize.apply(this, arguments);

            if (Composr.not(Composr.$CONFIG_OPTION.jsOverlays)) {
                return;
            }

            var imgs, imgsThumbs, setImgWidthHeight = false, mediaSet, as, containsVideo, x, i,
                imgsId = 'imgs_' + options.rand,
                imgsThumbsId = 'imgs_thumbs_' + options.rand,
                thumbWidthConfig = Composr.$CONFIG_OPTION.thumbWidth + 'x' + Composr.$CONFIG_OPTION.thumbWidth;

            if ((thumbWidthConfig !== 'x') && ((options.width + 'x' + options.height) !== 'x')) {
                setImgWidthHeight = true;
            }

            imgs = window[imgsId] = [];
            imgsThumbs = window[imgsThumbsId] = [];

            mediaSet = document.getElementById('media_set_' + options.rand);
            as = window.as = mediaSet.querySelectorAll('a, video');
            containsVideo = false;

            x = 0;
            for (i = 0; i < as.length; i++) {
                if (as[i].localName === 'video') {
                    var span = as[i].getElementsByTagName('span');
                    var title = '';
                    if (span.length !== 0) {
                        title = Composr.dom.html(span[0]);
                        span[0].parentNode.removeChild(span[0]);
                    }

                    imgs.push([Composr.dom.html(as[i]), title, true]);
                    imgsThumbs.push(as[i].poster || '{$IMG^;,video_thumb}');

                    containsVideo = true;

                    x++;
                } else {
                    if ((as[i].children.length === 1) && (as[i].firstElementChild.localName === 'img')) {
                        as[i].title = as[i].title.replace('{!LINK_NEW_WINDOW^;}', '').replace(/^\s+/, '');

                        imgs.push([as[i].href, (as[i].title === '') ? as[i].firstElementChild.alt : as[i].title, false]);
                        imgsThumbs.push(as[i].firstElementChild.src);

                        as[i].onclick = (function (x) {
                            return function () {
                                open_images_into_lightbox(imgs, x);
                                return false;
                            };
                        }(x));
                        if (as[i].rel) {
                            as[i].rel = as[i].rel.replace('lightbox', '');
                        }

                        x++;
                    }
                }
            }

            // If you only want a single image-based thumbnail
            if (containsVideo) {// Remove this 'if' (so it always runs) if you do not want the grid-style layout (plus remove the media_set class from the outer div
                var width = Composr.is(options.width) ? 'style="width: ' + Number(options.width) + 'px"' : '',
                    imgWidthHeight = setImgWidthHeight ? ' width="' + Number(options.width) + '" height="' + Number(options.height) + '"' : '',
                    mediaSetHtml = '\
					<figure class="attachment" ' + width + '>\
						<figcaption>' + Composr.str('{!comcode:MEDIA_SET^;}', imgs.length) + '<\/figcaption>\
						<div>\
							<div class="attachment_details">\
								<a onclick="open_images_into_lightbox(window.imgs); return false;" target="_blank" title="' + escape_html(Composr.str('{!comcode:MEDIA_SET^;}', imgs.length)) + ' {!LINK_NEW_WINDOW^/}" href="#!">\
                                    <img ' + imgWidthHeight + ' src="' + escape_html(imgsThumbs[0]) + '" />\
                                <\/a>\
							<\/div>\
						<\/div>\
					<\/figure>';

                Composr.dom.html(mediaSet, mediaSetHtml);
            }
        }
    });

    Composr.views.coreRichMedia = {
        Attachment: Attachment,
        Carousel: Carousel,
        ComcodeMediaSet: ComcodeMediaSet
    };

    Composr.templates.coreRichMedia = {
        attachments: function attachments(options) {
            window.attachment_template = options.attachmentTemplate;

            if (Composr.is(Composr.$JS_ON)) {
                window.max_attachments = options.maxAttachments;
                window.num_attachments = options.numAttachments;
            }

            window.rebuild_attachment_button_for_next = function (posting_field_name, attachment_upload_button) {
                var filter = options.filter !== undefined ? options.filter : null;

                if (posting_field_name !== options.postingFieldName) {
                    return false;
                }

                if (attachment_upload_button === undefined) {
                    attachment_upload_button = window.attachment_upload_button; // Use what was used last time
                }
                window.attachment_upload_button = attachment_upload_button;

                prepare_simplified_file_input('attachment_multi', 'file' + window.num_attachments, null, options.postingFieldName, filter, window.attachment_upload_button);
            };

            if (Composr.is(options.simpleUi)) {
                window.num_attachments = 1;

                Composr.load.then(function () {
                    if (document.getElementById('attachment_upload_button')) {
                        window.rebuild_attachment_button_for_next(options.postingFieldName, 'attachment_upload_button');
                    }
                });
            }
        },

        comcodeImg: function comcodeImg(options) {
            var img = this,
                refreshTime = Number(options.refreshTime);

            if ((typeof options.rollover === 'string') && (options.rollover !== '')) {
                create_rollover(img.id, options.rollover);
            }

            if (refreshTime > 0) {
                window.setInterval(function () {
                    if (!img.timer) img.timer = 0;
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
        },

        comcodeRandom: function comcodeRandom(options) {
            var rand, part, use, comcoderandom;

            rand = window.parseInt(Math.random() * options.max);

            for (var key in options.parts) {
                if (options.parts.hasOwnProperty(key)) {
                    part = options.parts[key];
                    use = part.val;

                    if (part.num > rand) {
                        break;
                    }
                }
            }

            comcoderandom = document.getElementById('comcoderandom' + options.randIdRandom);
            Composr.dom.html(comcoderandom, use);
        },

        comcodeMediaSet: function (options) {

        },

        comcodePulse: function (options) {
            var id = 'pulse_wave_' + options.randIdPulse;

            window[id] = [0, options.maxColor, options.minColor, options.speed, []];
            window.setInterval(function() {
                process_wave(document.getElementById(id));
            }, options.speed);
        },

        comcodeShocker: function (options) {
            var id = options.randIdShocker, part;

            if (window.shocker_parts === undefined) {
                window.shocker_parts = {};
                window.shocker_pos = {};
            }

            window.shocker_parts[id] = [];
            window.shocker_pos[id] = 0;

            for (var i = 0, len = options.parts.length; i < len; i++) {
                part = options.parts[i];
                window.shocker_parts[id].push([part.left, part.right]);
            }

            shocker_tick(id, options.time, options.maxColor, options.minColor);
            window.setInterval(function () {
                shocker_tick(id, options.time, options.maxColor, options.minColor);
            }, options.time);
        },

        comcodeSectionController: function (options) {
            var container = this,
                passId = Composr.filter.id(options.passId),
                id = 'a' + passId + '_sections';

            window[id] = [];

            for (var i = 0, len = options.sections.length; i < len; i++) {
                window[id].push(options.sections[i]);
            }

            flip_page(0, passId, id);

            Composr.dom.on(container, 'click', '.js-click-flip-page', function (e, clicked) {
                var flipTo = (clicked.dataset.vwFlipTo !== undefined) ? clicked.dataset.vwFlipTo : 0;
                if (Composr.isNumeric(flipTo)) {
                    flipTo = Number(flipTo);
                }

                flip_page(flipTo, passId, id);
            });
        },

        comcodeOverlay: function comcodeOverlay(options) {
            var container = this, id = options.id;

            Composr.dom.on(container, 'click', '.js-click-dismiss-overlay', function () {
                var bi = document.getElementById('main_website_inner');
                if (bi) {
                    clear_transition_and_set_opacity(bi, 1.0);
                }

                document.getElementById(options.randIdOverlay).style.display = 'none';

                if (Composr.is(id)) {
                    set_cookie('og_' + id, '1', 365);
                }
            });

            if (Composr.not(id) || (read_cookie('og_' + id) !== '1')) {
                window.setTimeout(function() {
                    var element, bi;

                    smooth_scroll(0);

                    element = document.getElementById(options.randIdOverlay);
                    element.style.display = 'block';
                    element.parentNode.removeChild(element);
                    document.body.appendChild(element);

                    bi = document.getElementById('main_website_inner');

                    if (bi) {
                        clear_transition_and_set_opacity(bi, 0.4);
                    }

                    clear_transition_and_set_opacity(element, 0.0);
                    fade_transition(element, 100, 30, 3);


                    if (options.timeout !== '-1') {
                        window.setTimeout(function () {
                            if (bi) {
                                clear_transition_and_set_opacity(bi, 1.0);
                            }

                            if (element) {
                                element.style.display = 'none';
                            }
                        }, options.timeout);
                    }
                }, options.timein + 100);
            }
        },

        comcodeBigTabsController: function (options) {
            var container = this,
                passId = Composr.filter.id(options.passId),
                id = passId + '_' + options.bigTabSets,
                fullId = 'a' + id + '_big_tab',
                tabs = options.tabs,
                sections = [], i;

            /* Precache images */
            new Image().src = Composr.url('{$IMG;,big_tabs_controller_button}');
            new Image().src = Composr.url('{$IMG;,big_tabs_controller_button_active}');
            new Image().src = Composr.url('{$IMG;,big_tabs_controller_button_top_active}');
            new Image().src = Composr.url('{$IMG;,big_tabs_controller_button_top}');

            for (i = 0; i < tabs.length; i++) {
                sections.push(Composr.filter.id(tabs[i]));
            }

            window[fullId] = sections;
            window['big_tabs_auto_cycler_' + id] = null;

            if (options.switchTime !== undefined) {
                window['big_tabs_switch_time_' + id] = options.switchtime;
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

            Composr.dom.on(container, 'click', '.js-click-flip-page', function (e, clicked) {
                var flipTo = (clicked.dataset.vwFlipTo !== undefined) ? clicked.dataset.vwFlipTo : 0;
                if (Composr.isNumeric(flipTo)) {
                    flipTo = Number(flipTo);
                }

                flip_page(flipTo, id, fullId);
            });
        },

        comcodeTabBody: function (options) {
            var title = Composr.filter.id(options.title);

            if (Composr.is(options.blockCallUrl)) {
                window['load_tab__' + title] = function () {
                    call_block(options.blockCallUrl, '', document.getElementById('g_' + title));
                };
            }
        },

        comcodeTicker: function (options) {
            var el = document.getElementById('ticktickticker' + options.randIdTicker),
                width = Composr.filter.id(options.width);

            window.tick_pos = window.tick_pos || [];

            if (typeof document.createElement('marquee').scrolldelay === 'undefined') { // Slower, but chrome does not support marquee's
                var my_id = parseInt(Math.random() * 10000);
                window.tick_pos[my_id] = options.width;
                Composr.dom.html(el, '<div onmouseover="this.mouseisover=true;" onmouseout="this.mouseisover=false;" class="ticker" ' +
                    'style="text-indent: ' + width + 'px; width: ' + width + 'px;" id="' + my_id + '"><span>' +
                    Composr.filter.crLf(options.text) + '<\/span><\/div>'
                );
                window.focused = true;
                window.addEventListener('focus', function () {
                    window.focused = true;
                });
                window.addEventListener('blur', function () {
                    window.focused = false;
                });
                window.setInterval(function () {
                    ticker_tick(my_id, options.width);
                }, 100 / options.speed);
            } else {
                Composr.dom.html(el, '<marquee style="display: block" class="ticker" onmouseover="this.setAttribute(\'scrolldelay\',\'10000\');" ' +
                    'onmouseout="this.setAttribute(\'scrolldelay\',' + (100 / options.speed) + ');" scrollamount="2" scrolldelay="' + (100 / options.speed) + '" ' +
                    'width="' + width + '">' + Composr.filter.crLf(options.text) + '<\/marquee>');
            }
        },

        comcodeJumping: function (options) {
            var id = parseInt(Math.random() * 10000);

            jumper_parts[id] = [];
            jumper_pos[id] = 1;

            for (var i = 0, len = options.parts.length; i < len; i++) {
                jumper_parts[id].push(options.parts[i]);
            }

            var comcodejumping = document.getElementById('comcodejumping' + options.randIdJumping);
            Composr.dom.html(comcodejumping, '<span id="' + id + '">' + jumper_parts[id][0] + '<\/span>');

            window.setInterval(function () {
                jumper_tick(id);
            }, options.time);
        },

        mediaYoutube: function () {
            var element = this;

            if (window.done_youtube_player_init === undefined) {
                var tag = document.createElement('script');
                tag.src = "https://www.youtube.com/iframe_api";
                var first_script_tag = document.getElementsByTagName('script')[0];
                first_script_tag.parentNode.insertBefore(tag, first_script_tag);
                window.done_youtube_player_init = true;
            }

            // Tie into callback event to see when finished, for our slideshows}
            // API: https://developers.google.com/youtube/iframe_api_reference}
            window.onYouTubeIframeAPIReady = function () {
                var slideshow_mode = document.getElementById('next_slide');
                var player = new YT.Player(element.id, {
                    width: options.width,
                    height: options.height,
                    videoId: options.remoteId,
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
            }
        },

        mediaRealmedia: function (options) {
            // Tie into callback event to see when finished, for our slideshows
            // API: http://service.real.com/help/library/guides/realone/ScriptingGuide/PDF/ScriptingGuide.pdf
            Composr.load.then(function () {
                if (document.getElementById('next_slide')) {
                    stop_slideshow_timer();
                    window.setTimeout(function () {
                        document.getElementById(options.playerId).addEventListener('stateChange', function (newState) {
                            if (newState == 0) {
                                player_stopped();
                            }
                        });
                        document.getElementById(options.playerId).DoPlay();
                    }, 1000);
                }
            });
        },

        mediaQuicktime: function (options) {
            // Tie into callback event to see when finished, for our slideshows
            // API: http://developer.apple.com/library/safari/#documentation/QuickTime/Conceptual/QTScripting_JavaScript/bQTScripting_JavaScri_Document/QuickTimeandJavaScri.html
            Composr.load.then(function () {
                if (document.getElementById('next_slide')) {
                    stop_slideshow_timer();
                    window.setTimeout(function () {
                        document.getElementById(options.playerId).addEventListener('qt_ended', function () {
                            player_stopped();
                        });
                        document.getElementById(options.playerId).Play();
                    }, 1000);
                }
            });
        },

        mediaVideoGeneral: function (options) {
            // Tie into callback event to see when finished, for our slideshows
            // API: http://developer.apple.com/library/safari/#documentation/QuickTime/Conceptual/QTScripting_JavaScript/bQTScripting_JavaScri_Document/QuickTimeandJavaScri.html
            // API: http://msdn.microsoft.com/en-us/library/windows/desktop/dd563945(v=vs.85).aspx
            Composr.load.then(function () {
                if (document.getElementById('next_slide')) {
                    stop_slideshow_timer();

                    window.setTimeout(function () {
                        var player = document.getElementById(options.playerId);
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
        },

        mediaVimeo: function (options) {
            // Tie into callback event to see when finished, for our slideshows}
            if (document.getElementById('next_slide')) {
                stop_slideshow_timer();
                window.setTimeout(function () {
                    window.addEventListener('message', player_stopped, false);

                    var player = document.getElementById(options.playerId);
                    player.contentWindow.postMessage(JSON.stringify({method: 'addEventListener', value: 'finish'}), 'https://player.vimeo.com/video/' + options.remoteId);
                }, 1000);
            }
        },

        // API: http://www.longtailvideo.com/support/jw-player/jw-player-for-flash-v5/12540/javascript-api-reference
        // Carefully tuned to avoid this problem: http://www.longtailvideo.com/support/forums/jw-player/setup-issues-and-embedding/8439/sound-but-no-video
        mediaAudioWebsafe: function (options) {
            var playerOptions = {
                width: options.width,
                height: options.height,
                autostart: false,
                file: options.url,
                type: options.type,
                image: options.thumbUrl,
                flashplayer: options.flashplayer,
                events: {
                    onComplete: function () {
                        if (document.getElementById('next_slide')) {
                            player_stopped();
                        }
                    },
                    onReady: function () {
                        if (document.getElementById('next_slide')) {
                            stop_slideshow_timer();
                            jwplayer(options.playerId).play(true);
                        }
                    }
                }
            };

            if (Composr.is(options.duration)) {
                playerOptions.duration = options.duration;
            }

            if (Composr.not(Composr.$CONFIG_OPTION.showInlineStats)) {
                playerOptions.events.onPlay = function () {
                    ga_track(null, '{!AUDIO;^}', options.url);
                };
            }

            jwplayer(options.playerId).setup(playerOptions);
        },

        // API: http://www.longtailvideo.com/support/jw-player/jw-player-for-flash-v5/12540/javascript-api-reference
        // Carefully tuned to avoid this problem: http://www.longtailvideo.com/support/forums/jw-player/setup-issues-and-embedding/8439/sound-but-no-video
        mediaVideoWebsafe: function (options) {
            var playerOptions = {
                autostart: false,
                file: options.url,
                type: options.type,
                image: options.thumbUrl,
                flashplayer: options.flashplayer,
                events: {
                    onComplete: function () {
                        if (document.getElementById('next_slide')) player_stopped();
                    },
                    onReady: function () {
                        if (document.getElementById('next_slide')) {
                            stop_slideshow_timer();
                            jwplayer(options.playerId).play(true);
                        }
                    }
                }
            };

            if (Composr.is(options.duration)) {
                playerOptions.duration = options.duration;
            }

            if (Composr.is(options.playerWidth)) {
                playerOptions.width = options.playerWidth;
            }

            if (Composr.is(options.playerHeight)) {
                playerOptions.height = options.playerHeight;
            }

            if (Composr.not(Composr.$CONFIG_OPTION.showInlineStats)) {
                playerOptions.events.onPlay = function () {
                    ga_track(null, '{!VIDEO;^}', options.url);
                };
            }

            jwplayer(options.playerId).setup(playerOptions);
        }
    };

    function shocker_tick(id, time, min_color, max_color) {
        if ((typeof document.hidden != 'undefined') && (document.hidden)) return;

        if (window.shocker_pos[id] == window.shocker_parts[id].length - 1) window.shocker_pos[id] = 0;
        var e_left = document.getElementById('comcodeshocker' + id + '_left');
        if (!e_left) return;
        Composr.dom.html(e_left, window.shocker_parts[id][window.shocker_pos[id]][0]);
        clear_transition_and_set_opacity(e_left, 0.6);
        clear_transition_and_set_opacity(e_left, 0.0);
        fade_transition(e_left, 100, time / 40, 5);

        var e_right = document.getElementById('comcodeshocker' + id + '_right');
        if (!e_right) return;
        Composr.dom.html(e_right, window.shocker_parts[id][window.shocker_pos[id]][1]);
        clear_transition_and_set_opacity(e_right, 0);
        clear_transition_and_set_opacity(e_right, 0.0);
        fade_transition(e_right, 100, time / 20, 5);

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
                    if ((section.style.display == 'block') && (section.style.position != 'absolute')) {
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
        if (x) x.style.display = (current_pos == sections.length - 1) ? 'none' : 'inline-block';
        x = document.getElementById(pass_id + '_has_next_no');
        if (x) x.style.display = (current_pos == sections.length - 1) ? 'inline-block' : 'none';
        x = document.getElementById(pass_id + '_has_previous_yes');
        if (x) x.style.display = (current_pos == 0) ? 'none' : 'inline-block';
        x = document.getElementById(pass_id + '_has_previous_no');
        if (x) x.style.display = (current_pos == 0) ? 'inline-block' : 'none';

        // We make our forthcoming one instantly visible to stop Google Chrome possibly scrolling up if there is a tiny time interval when none are visible
        x = document.getElementById(pass_id + '_section_' + sections[i]);
        if (x) x.style.display = 'block';

        for (i = 0; i < sections.length; i++) {
            x = document.getElementById(pass_id + '_goto_' + sections[i]);
            if (x) x.style.display = (i == current_pos) ? 'none' : 'inline-block';
            x = document.getElementById(pass_id + '_btgoto_' + sections[i]);
            if (x) x.className = x.className.replace(/big\_tab\_(in)?active/, (i == current_pos) ? 'big_tab_active' : 'big_tab_inactive');
            x = document.getElementById(pass_id + '_isat_' + sections[i]);
            if (x) x.style.display = (i == current_pos) ? 'inline-block' : 'none';
            x = document.getElementById(pass_id + '_section_' + sections[i]);
            var current_place = document.getElementById(pass_id + '_section_' + sections[current_pos]);
            //var width=current_place?'100%':null;
            var width = current_place ? Composr.dom.contentWidth(current_place) : null;
            if (x) {
                if (x.className == 'comcode_big_tab') {
                    if (i == current_pos) {
                        if ((x.fader_key !== undefined) && (window.fade_transition_timers[x.fader_key])) {
                            window.clearTimeout(window.fade_transition_timers[x.fader_key]);
                            delete window.fade_transition_timers[x.fader_key];
                        }

                        x.style.width = '';
                        x.style.position = 'static';
                        x.style.zIndex = 10;
                        clear_transition_and_set_opacity(x, 1.0);
                    } else {
                        if (x.style.position != 'static') clear_transition_and_set_opacity(x, 0.0); else clear_transition_and_set_opacity(x, 1.0);
                        if ((typeof x.fader_key == 'undefined') || (!window.fade_transition_timers[x.fader_key]))
                            fade_transition(x, 0, 30, -5);
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
                        clear_transition_and_set_opacity(x, 0.0);
                        fade_transition(x, 100, 30, 4);
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

    function countdown(id, direction, tailing) {
        var countdown = (typeof id === 'object') ? id : document.getElementById(id), i;
        var inside = Composr.dom.html(countdown);
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

            Composr.dom.html(countdown, inside);
        }
    }


    if (window.ticker_tick === undefined) {
        window.tick_pos = [];
    }
    function ticker_tick(id, width) {
        if ((document.hidden === true) || !window.focused) {
            return;
        }

        var el = document.getElementById(id);
        if (!el || el.mouseisover) {
            return;
        }

        el.style.textIndent = window.tick_pos[id] + 'px';
        window.tick_pos[id]--;
        if (window.tick_pos[id] < -1.1 * el.children[0].offsetWidth) {
            window.tick_pos[id] = width;
        }
    }

    if (window.jumper_pos === undefined) {
        window.jumper_pos = [];
        window.jumper_parts = [];
    }
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
        Composr.dom.html(el, window.jumper_parts[id][window.jumper_pos[id]]);
        window.jumper_pos[id]++;
    }

    function crazy_tick() {
        if (window.mouse_x === undefined) {
            return;
        }
        if (window.mouse_y === undefined) {
            return;
        }

        register_mouse_listener();

        var e, i, s_width, biasx, biasy;
        for (i = 0; i < window.crazy_criters.length; i++) {
            e = document.getElementById(window.crazy_criters[i]);
            s_width = e.clientWidth;

            biasx = window.mouse_x - e.offsetLeft;
            if (biasx > 0) biasx = 2; else biasx = -1;
            if (Math.random() * 4 < 1) biasx = 0;
            biasy = window.mouse_y - e.offsetTop;
            if (biasy > 0) biasy = 2; else biasy = -1;
            if (Math.random() * 4 < 1) biasy = 0;

            if (s_width < 100)
                e.style.width = (s_width + 1) + 'px';
            e.style.left = (e.offsetLeft + (Math.random() * 2 - 1 + biasx) * 30) + 'px';
            e.style.top = (e.offsetTop + (Math.random() * 2 - 1 + biasy) * 30) + 'px';
            e.style.position = 'absolute';
        }
    }

    // Exports (legacy)
    window.countdown = countdown;
    window.ticker_tick = ticker_tick;
    window.jumper_tick = jumper_tick;
    window.crazy_tick = crazy_tick;
}(window.Composr));

(function ($, Composr) {
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
        initialize: function (viewOptions, options) {
            Composr.View.prototype.initialize.apply(this, arguments);

            preinit_file_input("attachment_multi", "file" + options.i, null, options.postingFieldName, options.filter);

            if (options.syndicationJson !== undefined) {
                show_upload_syndication_options("file" + options.i, options.syndicationJson, Composr.isTruthy(options.noQuota));
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
            Composr.View.prototype.initialize.apply(this, arguments);
            var that = this,
                id = options.carouselId,
                carousel_ns = document.getElementById('carousel_ns_' + id);

            that.mainEl = that.el.querySelector('.main');

            carousel_ns.parentNode.removeChild(carousel_ns);
            that.mainEl.appendChild(carousel_ns);
            that.el.style.display = 'block';

            Composr.loadWindow.then(function () {
                that.$('.js-btn-car-move').css({
                    height: that.mainEl.offsetHeight + 'px'
                });

                _create_faders(that.mainEl);
                _update_faders(that.mainEl);
            });
        },

        events: {
            'mousedown .js-btn-car-move': 'move',
            'keypress .js-btn-car-move': 'move'
        },

        move: function (e) {
            var that = this,
                btn = e.currentTarget,
                amount = btn.dataset.moveAmount;

            window.setTimeout(function () {
                that.carouselMove(that.el, amount);
            }, 10);
        },

        carouselMove: function (amount) {
            var that = this;

            if (amount > 0) {
                that.mainEl.scrollLeft += 3;
                amount--;
                if (amount < 0) {
                    amount = 0;
                }
            } else {
                that.mainEl.scrollLeft -= 3;
                amount++;
                if (amount > 0) {
                    amount = 0;
                }
            }

            _update_faders(that.mainEl);

            if (amount != 0) {
                window.setTimeout(function () {
                    that.carouselMove(that.el, amount);
                }, 10);
            }
        }
    });

    Composr.views.coreRichMedia = {
        Attachment: Attachment,
        Carousel: Carousel
    };

    Composr.templates.coreRichMedia = {
        attachments: function attachments(options) {
            window.attachment_template = options.attachmentTemplate;

            if (Composr.$JS_ON) {
                window.max_attachments = options.maxAttachments;
                window.num_attachments = options.numAttachments;
            }

            if (Composr.isTruthy(options.simpleUi)) {
                window.num_attachments = 1;

                Composr.loadWindow.then(function () {
                    if (document.getElementById('attachment_upload_button')) {
                        rebuild_attachment_button_for_next(options.postingFieldName, 'attachment_upload_button');
                    }
                });
            }

            window.rebuild_attachment_button_for_next = function rebuild_attachment_button_for_next(posting_field_name, attachment_upload_button) {
                var filter = options.filter !== undefined ? options.filter : null;

                if (posting_field_name !== options.postingFieldName) {
                    return false;
                }

                if (attachment_upload_button === undefined) {
                    attachment_upload_button = window.attachment_upload_button; // Use what was used last time
                }
                window.attachment_upload_button = attachment_upload_button;

                prepare_simplified_file_input('attachment_multi', 'file' + window.num_attachments, null, options.postingFieldName, filter, window.attachment_upload_button);
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

        comcodeMediaSet: function comcodeMediaSet(options) {
            var imgs, imgsThumbs, setImgWidthHeight = false,
                imgsId = 'imgs_' + options.rand,
                imgsThumbsId = 'imgs_thumbs_' + options.rand,
                thumbWidthConfig = Composr.$CONFIG_OPTION.thumbWidth + 'x' + Composr.$CONFIG_OPTION.thumbWidth;

            if (Composr.isFalsy(Composr.$CONFIG_OPTION.jsOverlays)) {
                return;
            }

            if ((thumbWidthConfig !== 'x') && ((options.width + 'x' + options.height) !== 'x') ) {
                setImgWidthHeight = true;
            }

            imgs = window[imgsId] = [];
            imgsThumbs = window[imgsThumbsId] = [];

            window.media_set = document.getElementById('media_set_' + options.rand);
            window.as = media_set.querySelectorAll('a, video');
            window.contains_video = false;

            var x = 0;
            for (var i = 0; i < as.length; i++) {
                if (as[i].nodeName.toLowerCase() === 'video') {
                    var span = as[i].getElementsByTagName('span');
                    var title = '';
                    if (span.length != 0) {
                        title = Composr.dom.html(span[0]);
                        span[0].parentNode.removeChild(span[0]);
                    }

                    imgs.push([Composr.dom.html(as[i]), title, true]);
                    imgsThumbs.push((as[i].poster && as[i].poster != '') ? as[i].poster : '{$IMG;/,video_thumb}');

                    window.contains_video = true;

                    x++;
                } else {
                    if ((as[i].childNodes.length == 1) && (as[i].childNodes[0].nodeName.toLowerCase() == 'img')) {
                        as[i].title = as[i].title.replace('{!LINK_NEW_WINDOW;/}', '').replace(/^\s+/, '');

                        imgs.push([as[i].href, (as[i].title == '') ? as[i].childNodes[0].alt : as[i].title, false]);
                        imgsThumbs.push(as[i].childNodes[0].src);

                        as[i].onclick = function (x) {
                            return function () {
                                open_images_into_lightbox(imgs, x);
                                return false;
                            }
                        }(x);
                        if (as[i].rel) as[i].rel = as[i].rel.replace('lightbox', '');

                        x++;
                    }
                }
            }

            // If you only want a single image-based thumbnail
            if (contains_video) {// Remove this 'if' (so it always runs) if you do not want the grid-style layout (plus remove the media_set class from the outer div
                var width = Composr.isTruthy(options.width) ? 'style="width: ' + Number(options.width) + 'px"' : '',
                    imgWidthHeight = setImgWidthHeight ? ' width="' + Number(options.width) + '" height="' + Number(options.height) + '"' : '',
                    media_set_html = '\
					<figure class="attachment" ' + width + '>\
						<figcaption>' + '{!comcode:MEDIA_SET^/,xxx}'.replace(/xxx/g, imgs.length) + '<\/figcaption>\
						<div>\
							<div class="attachment_details">\
								<a onclick="open_images_into_lightbox(imgs); return false;" target="_blank" title="' + escape_html('{!comcode:MEDIA_SET^/,xxx}'.replace(/xxx/g, imgs.length)) + ' {!LINK_NEW_WINDOW^/}" href="#!">\
                                    <img ' + imgWidthHeight + ' src="' + escape_html(imgsThumbs[0]) + '" />\
                                <\/a>\
							<\/div>\
						<\/div>\
					<\/figure>';

                Composr.dom.html(media_set, media_set_html);
            }
        },

        comcodePulse: function comcodePulse(options) {
            var id = 'pulse_wave_' + options.randIdPulse;

            window[id] = [0, options.maxColor, options.minColor, options.speed, []];
            window.setInterval(function() {
                process_wave(document.getElementById(id));
            }, options.speed);
        },

        comcodeShocker: function comcodeShocker(options) {
            var id = options.randIdShocker, part;

            if (typeof window.shocker_parts === 'undefined') {
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

        comcodeSectionController: function comcodeSectionController(options) {
            var passId = Composr.filters.identifier(options.passId),
                id = 'a' + passId + '_sections';

            window[id] = [];

            for (var i = 0, len = options.sections.length; i < len; i++) {
                window[id].push(options.sections[i]);
            }

            flip_page(0, passId, id);
        },

        comcodeOverlay: function comcodeOverlay(options) {
            if ((typeof options.id !== 'string') || (options.id.trim() === '') || (read_cookie('og_' + options.id) !== '1')) {
                window.setTimeout(function() {
                    var element, bi;

                    smooth_scroll(0);

                    element = document.getElementById(options.randIdOverlay);
                    element.style.display = 'block';
                    element.parentNode.removeChild(element);
                    document.body.appendChild(element);

                    bi = document.getElementById('main_website_inner');

                    if (bi) {
                        set_opacity(bi, 0.4);
                    }

                    set_opacity(element, 0.0);
                    fade_transition(element, 100, 30, 3);


                    if (options.timeout !== '-1') {
                        window.setTimeout(function () {
                            if (bi) {
                                set_opacity(bi, 1.0);
                            }

                            if (element) {
                                element.style.display = 'none';
                            }
                        }, options.timeout);
                    }
                }, options.timein + 100);
            }
        },

        comcodeBigTabsController: function comcodeBigTabsController(options) {
            var passId = Composr.filters.identifier(options.passId),
                identifier = passId + '_' + options.bigTabSets,
                tabs = options.tabs,
                sections = [], i;

            big_tabs_init();

            for (i = 0; i < tabs.length; i++) {
                sections.push(Composr.filters.identifier(tabs[i]));
            }

            window['a' + identifier + '_big_tab'] = sections;
            window['big_tabs_auto_cycler_' + identifier] = null;

            if (typeof options.switchTime !== 'undefined') {
                window['big_tabs_switch_time_' + identifier] = options.switchtime;
                window['move_between_big_tabs_' + identifier] = function () {
                    var next_page = 0, i, x;

                    for (i = 0; i < sections.length; i++) {
                        x = document.getElementById(identifier + '_section_' + sections[i]);
                        if ((x.style.display === 'block') && (x.style.position !== 'absolute')) {
                            next_page = i + 1;
                        }
                    }

                    if (next_page === sections.length) {
                        next_page = 0;
                    }

                    flip_page(sections[next_page], identifier, sections);
                };

                flip_page(0, identifier, sections);
            }
        },

        comcodeTabBody: function comcodeTabBody(options) {
            var title = Composr.filters.identifier(options.title);

            if (Composr.isTruthy(options.blockCallUrl)) {
                window['load_tab__' + title] = function () {
                    call_block(options.blockCallUrl, '', document.getElementById('g_' + title));
                };
            }
        },

        comcodeTicker: function comcodeTicker(options) {
            var el = document.getElementById('ticktickticker' + options.randIdTicker),
                width = Composr.filters.identifier(options.width);

            window.tick_pos = window.tick_pos || [];

            if (typeof document.createElement('marquee').scrolldelay === 'undefined') { // Slower, but chrome does not support marquee's
                var my_id = parseInt(Math.random() * 10000);
                window.tick_pos[my_id] = options.width;
                Composr.dom.html(el, '<div onmouseover="this.mouseisover=true;" onmouseout="this.mouseisover=false;" class="ticker" ' +
                    'style="text-indent: ' + width + 'px; width: ' + width + 'px;" id="' + my_id + '"><span>' +
                    Composr.filters.stripNewLines(options.text) + '<\/span><\/div>'
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
                    'width="' + width + '">' + Composr.filters.stripNewLines(options.text) + '<\/marquee>');
            }
        },

        comcodeJumping: function comcodeJumping(options) {
            var id = parseInt(Math.random() * 10000);

            Composr.required(options, ['randIdJumping', 'parts', 'time']);

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

        mediaYoutube: function mediaYoutube() {
            var element = this;

            if (typeof window.done_youtube_player_init === 'undefined') {
                var tag = document.createElement('script');
                tag.src = "https://www.youtube.com/iframe_api";
                var first_script_tag = document.getElementsByTagName('script')[0];
                first_script_tag.parentNode.insertBefore(tag, first_script_tag);
                window.done_youtube_player_init = true;
            }

            // Tie into callback event to see when finished, for our slideshows}
            // API: https://developers.google.com/youtube/iframe_api_reference}
            window.onYouTubeIframeAPIReady = function onYouTubeIframeAPIReady() {
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

        mediaRealmedia: function mediaRealmedia(options) {
            // Tie into callback event to see when finished, for our slideshows
            // API: http://service.real.com/help/library/guides/realone/ScriptingGuide/PDF/ScriptingGuide.pdf
            Composr.loadWindow.then(function () {
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

        mediaQuicktime: function mediaQuicktime(options) {
            // Tie into callback event to see when finished, for our slideshows
            // API: http://developer.apple.com/library/safari/#documentation/QuickTime/Conceptual/QTScripting_JavaScript/bQTScripting_JavaScri_Document/QuickTimeandJavaScri.html
            Composr.loadWindow.then(function () {
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

        mediaVideoGeneral: function mediaVideoGeneral(options) {
            // Tie into callback event to see when finished, for our slideshows
            // API: http://developer.apple.com/library/safari/#documentation/QuickTime/Conceptual/QTScripting_JavaScript/bQTScripting_JavaScri_Document/QuickTimeandJavaScri.html
            // API: http://msdn.microsoft.com/en-us/library/windows/desktop/dd563945(v=vs.85).aspx
            Composr.loadWindow.then(function () {
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

        mediaVimeo: function mediaVimeo(options) {
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
        mediaAudioWebsafe: function mediaAudioWebsafe(options) {
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

            if ((typeof options.duration === 'string') && (options.duration !== '')) {
                playerOptions.duration = options.duration;
            }

            if (options.inlineStats === '0') {
                playerOptions.events.onPlay = function () {
                    ga_track(null,'{!AUDIO;/}', options.url);
                };
            }

            jwplayer(options.playerId).setup(playerOptions);
        },

        // API: http://www.longtailvideo.com/support/jw-player/jw-player-for-flash-v5/12540/javascript-api-reference
        // Carefully tuned to avoid this problem: http://www.longtailvideo.com/support/forums/jw-player/setup-issues-and-embedding/8439/sound-but-no-video
        mediaVideoWebsafe: function mediaVideoWebsafe(options) {
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

            if ((typeof options.duration === 'string') && (options.duration !== '')) {
                playerOptions.duration = options.duration;
            }

            if ((typeof options.playerWidth === 'string') && (options.playerWidth !== '')) {
                playerOptions.width = options.playerWidth;
            }

            if ((typeof options.playerHeight === 'string') && (options.playerHeight !== '')) {
                playerOptions.height = options.playerHeight;
            }

            if (options.inlineStats === '0') {
                playerOptions.events.onPlay = function () {
                    ga_track(null,'{!VIDEO;/}', options.url);
                };
            }

            jwplayer(options.playerId).setup(playerOptions);
        }
    };
})(window.jQuery || window.Zepto, Composr);


// ======================
// main_image_fader block
// ======================

function initialise_image_fader(data, id) {
    data.fp_animation = document.getElementById('image_fader_' + id);
    data.fp_animation_fader = document.createElement('img');
    data.tease_title = document.getElementById('image_fader_title_' + id);
    data.tease_scrolling_text = document.getElementById('image_fader_scrolling_text_' + id);
    data.fp_animation_fader.className = 'img_thumb';
    data.fp_animation.parentNode.insertBefore(data.fp_animation_fader, data.fp_animation);
    data.fp_animation.parentNode.style.position = 'relative';
    data.fp_animation.parentNode.style.display = 'block';
    data.fp_animation_fader.style.position = 'absolute';
    data.fp_animation_fader.src = '{$IMG;,blank}'.replace(/^https?:/, window.location.protocol);
}

function initialise_image_fader_title(data, v, k) {
    data['title' + k] = v;
    if (k == 0) {
        if (data.tease_title) {
            Composr.dom.html(data.tease_title, data['title' + k]);
        }
    }
}

function initialise_image_fader_html(data, v, k) {
    data['html' + k] = v;
    if (k == 0) {
        if (data.tease_scrolling_text) {
            Composr.dom.html(data.tease_scrolling_text, (data['html' + k] == '') ? '{!MEDIA;}' : data['html' + k]);
        }
    }
}

function initialise_image_fader_image(data, v, k, mill, total) {
    var period_in_msecs = 50;
    var increment = 3;
    if (period_in_msecs * 100 / increment > mill) {
        period_in_msecs = mill * increment / 100;
        period_in_msecs *= 0.9; // A little give
    }

    data['url' + k] = v;
    new Image().src = data['url' + k]; // precache
    window.setTimeout(function () {
        var func = function () {
            data.fp_animation_fader.src = data.fp_animation.src;
            set_opacity(data.fp_animation_fader, 1.0);
            fade_transition(data.fp_animation_fader, 0, period_in_msecs, increment * -1);
            set_opacity(data.fp_animation, 0.0);
            fade_transition(data.fp_animation, 100, period_in_msecs, increment);
            data.fp_animation.src = data['url' + k];
            data.fp_animation_fader.style.left = ((data.fp_animation_fader.parentNode.offsetWidth - data.fp_animation_fader.offsetWidth) / 2) + 'px';
            data.fp_animation_fader.style.top = ((data.fp_animation_fader.parentNode.offsetHeight - data.fp_animation_fader.offsetHeight) / 2) + 'px';
            if (data.tease_title) {
                Composr.dom.html(data.tease_title, data['title' + k]);
            }
            if (data.tease_scrolling_text) {
                Composr.dom.html(data.tease_scrolling_text, data['html' + k]);
            }
        };
        if (k != 0) func();
        window.setInterval(func, mill * total);
    }, k * mill);
}

// =======
// COMCODE
// =======

function big_tabs_init() {
    /* Precache images */
    new Image().src = '{$IMG;,big_tabs_controller_button}'.replace(/^https?:/, window.location.protocol);
    new Image().src = '{$IMG;,big_tabs_controller_button_active}'.replace(/^https?:/, window.location.protocol);
    new Image().src = '{$IMG;,big_tabs_controller_button_top_active}'.replace(/^https?:/, window.location.protocol);
    new Image().src = '{$IMG;,big_tabs_controller_button_top}'.replace(/^https?:/, window.location.protocol);
}

function countdown(id, direction, tailing) {
    var countdown = typeof id === 'object' ? id : document.getElementById(id);
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
    for (var i = us.length - 1; i >= 0; i--) {
        multiplier *= multiples[i];
        total += window.parseInt(us[i]) * multiplier;
    }

    if (total > 0) {
        total += direction;
        inside = inside.replace(/\d+/g, '!!!');
        if (total == 0) {
            countdown.className = 'red_alert';
            //countdown.style.textDecoration='blink';
        }
        for (var i = 0; i < us.length; i++) {
            us[i] = Math.floor(total / multiplier);
            total -= us[i] * multiplier;
            multiplier /= multiples[i];
            inside = inside.replace('!!!', us[i]);
        }
        Composr.dom.html(countdown, inside);
    }
}

function _create_faders(main) {
    var left = document.createElement('img');
    left.setAttribute('src', '{$IMG;,carousel/fade_left}');
    left.style.position = 'absolute';
    left.style.left = '43px';
    left.style.top = '0';
    main.parentNode.appendChild(left);

    var right = document.createElement('img');
    right.setAttribute('src', '{$IMG;,carousel/fade_right}');
    right.style.position = 'absolute';
    right.style.right = '43px';
    right.style.top = '0';
    main.parentNode.appendChild(right);
}

function _update_faders(main) {
    var imgs = main.parentNode.getElementsByTagName('img'),
        left = imgs[imgs.length - 2],
        right = imgs[imgs.length - 1];

    if (left.style.position === 'absolute') {// Check it really is a fader (stops bugs in other areas making bigger weirdness)
        left.style.visibility = (main.scrollLeft == 0) ? 'hidden' : 'visible';
    }

    if (right.style.position === 'absolute'){// Ditto
        right.style.visibility = (main.scrollLeft + main.offsetWidth >= main.scrollWidth - 1) ? 'hidden' : 'visible';
    }
}

function flip_page(to, pass_id, sections) {
    var i, current_pos = 0, section;

    if (window['big_tabs_auto_cycler_' + pass_id]) {
        window.clearTimeout(window['big_tabs_auto_cycler_' + pass_id]);
        window['big_tabs_auto_cycler_' + pass_id] = null;
    }

    if (typeof to == 'number') {
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
                    if ((typeof x.fader_key != 'undefined') && (window.fade_transition_timers[x.fader_key])) {
                        window.clearTimeout(window.fade_transition_timers[x.fader_key]);
                        window.fade_transition_timers[x.fader_key] = null;
                    }

                    x.style.width = '';
                    x.style.position = 'static';
                    x.style.zIndex = 10;
                    set_opacity(x, 1.0);
                } else {
                    if (x.style.position != 'static') set_opacity(x, 0.0); else set_opacity(x, 1.0);
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

                if ((typeof window.fade_transition != 'undefined') && (i == current_pos)) {
                    set_opacity(x, 0.0);
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

function shocker_tick(id, time, min_color, max_color) {
    if ((typeof document.hidden != 'undefined') && (document.hidden)) return;

    if (window.shocker_pos[id] == window.shocker_parts[id].length - 1) window.shocker_pos[id] = 0;
    var e_left = document.getElementById('comcodeshocker' + id + '_left');
    if (!e_left) return;
    Composr.dom.html(e_left, window.shocker_parts[id][window.shocker_pos[id]][0]);
    set_opacity(e_left, 0.6);
    if (typeof window.fade_transition != 'undefined') {
        set_opacity(e_left, 0.0);
        fade_transition(e_left, 100, time / 40, 5);
    }
    var e_right = document.getElementById('comcodeshocker' + id + '_right');
    if (!e_right) return;
    Composr.dom.html(e_right, window.shocker_parts[id][window.shocker_pos[id]][1]);
    set_opacity(e_right, 0);
    if (typeof window.fade_transition != 'undefined') {
        set_opacity(e_right, 0.0);
        fade_transition(e_right, 100, time / 20, 5);
    }
    window.shocker_pos[id]++;

    window['comcodeshocker' + id + '_left'] = [0, min_color, max_color, time / 13, []];
    window.setInterval(function () {
        process_wave(e_left);
    }, window['comcodeshocker' + id + '_left'][3]);
}

if (typeof window.ticker_tick == 'undefined') {
    window.tick_pos = [];
}
function ticker_tick(id, width) {
    if ((typeof document.hidden != 'undefined') && (document.hidden)) return;

    if (!window.focused) return;

    var e = document.getElementById(id);
    if (!e) return;
    if (e.mouseisover) return;
    e.style.textIndent = window.tick_pos[id] + 'px';
    window.tick_pos[id]--;
    if (window.tick_pos[id] < -1.1 * e.childNodes[0].offsetWidth) window.tick_pos[id] = width;
}

if (typeof window.jumper_pos == 'undefined') {
    window.jumper_pos = [];
    window.jumper_parts = [];
}
function jumper_tick(id) {
    if ((typeof document.hidden != 'undefined') && (document.hidden)) return;

    if (window.jumper_pos[id] == window.jumper_parts[id].length - 1) window.jumper_pos[id] = 0;
    var e = document.getElementById(id);
    if (!e) return;
    Composr.dom.html(e, window.jumper_parts[id][window.jumper_pos[id]]);
    window.jumper_pos[id]++;
}

function crazy_tick() {
    if (typeof window.mouse_x == 'undefined') return;
    if (typeof window.mouse_y == 'undefined') return;

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


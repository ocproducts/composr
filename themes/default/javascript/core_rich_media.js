(function ($, Composr) {
    Composr.templates.coreRichMedia = {
        attachments: function attachments(options) {
            window.attachment_template = options.attachmentTemplate;

            if (Composr.$JS_ON) {
                window.max_attachments = options.maxAttachments;
                window.num_attachments = options.numAttachments;
            }

            if (options.simpleUi === '1'){
                window.num_attachments = 1;

                Composr.loadWindow.then(function() {
                    if (document.getElementById('attachment_upload_button')) {
                        rebuild_attachment_button_for_next(options.postingFieldName,'attachment_upload_button');
                    }
                });
            }

            window.rebuild_attachment_button_for_next = function rebuild_attachment_button_for_next(posting_field_name, attachment_upload_button) {
                var filter = typeof options.filter !== 'undefined' ? options.filter : null;

                if (posting_field_name !== options.postingFieldName) {
                    return false;
                }

                if (typeof attachment_upload_button === 'undefined') {
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
            set_inner_html(comcoderandom, use);
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
                        title = get_inner_html(span[0]);
                        span[0].parentNode.removeChild(span[0]);
                    }

                    imgs.push([get_inner_html(as[i]), title, true]);
                    imgsThumbs.push((as[i].poster && as[i].poster != '') ? as[i].poster : '{$IMG;/,video_thumb}');

                    contains_video = true;

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

                set_inner_html(media_set, media_set_html);
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

                    if (typeof window.fade_transition != 'undefined') {
                        set_opacity(element, 0.0);
                        fade_transition(element, 100, 30, 3);
                    }

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
                set_inner_html(el, '<div onmouseover="this.mouseisover=true;" onmouseout="this.mouseisover=false;" class="ticker" ' +
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
                set_inner_html(el, '<marquee style="display: block" class="ticker" onmouseover="this.setAttribute(\'scrolldelay\',\'10000\');" ' +
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
            set_inner_html(comcodejumping, '<span id="' + id + '">' + jumper_parts[id][0] + '<\/span>');

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

    Composr.behaviors.coreRichMedia = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_rich_media');
            }
        }
    };


})(window.jQuery || window.Zepto, Composr);

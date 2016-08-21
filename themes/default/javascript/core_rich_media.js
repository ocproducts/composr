(function ($, Composr) {
    Composr.templates.coreRichMedia = {
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

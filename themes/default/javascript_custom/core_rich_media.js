/*{+START,INCLUDE,core_rich_media,.js,javascript,,1}{+END}*/

(function ($cms) {
    /* global MediaElementPlayer:false */
    'use strict';
    $cms.templates.mediaAudioWebsafe = function mediaAudioWebsafe(params, container) {
        var playerId = strVal(params.playerId), player,
            width = strVal(params.width),
            height = strVal(params.height),
            url = strVal(params.url),
            options = {
                pluginPath: '{$BASE_URL;}/data_custom/mediaelement/',
                enableKeyboard: true,
                success: function (media) {
                    if (!$cms.configOption('show_inline_stats')) {
                        media.addEventListener('play', function () {
                            $cms.gaTrack(null, '{!VIDEO;}', url);
                        });
                    }

                    var embeddedMediaData = $dom.data(container, 'cmsEmbeddedMedia');

                    if (embeddedMediaData != null) {
                        media.addEventListener('play', function () {
                            $dom.trigger(container, 'cms:media:play', {
                                mediaDuration: player.duration,
                                mediaCurrentTime: player.currentTime,
                            });
                        });

                        media.addEventListener('canplay', function () {
                            $dom.trigger(container, 'cms:media:canplay');
                        });

                        media.addEventListener('pause', function () {
                            $dom.trigger(container, 'cms:media:pause');
                        });

                        media.addEventListener('ended', function () {
                            $dom.trigger(container, 'cms:media:ended');
                        });

                        $dom.on(container, 'cms:media:do-play', function () {
                            player.play();
                        });

                        $dom.on(container, 'cms:media:do-pause', function () {
                            player.pause();
                        });

                        embeddedMediaData.ready = true;
                        $dom.trigger(container, 'cms:media:ready');
                    }
                }
            };

        // Scale to a maximum width because we can always maximise - for object/embed players we can use max-width for this
        options.videoWidth = Math.min(950, width);
        options.videoHeight = Math.min(height * (950 / width), height);

        player = new MediaElementPlayer(playerId, options);
    };

    $cms.templates.mediaVideoWebsafe = function mediaVideoWebsafe(params, container) {
        var playerId = strVal(params.playerId),
            mediaElement,
            url = strVal(params.url),
            options = {
                pluginPath: '{$BASE_URL;}/data_custom/mediaelement/',
                enableKeyboard: true,
                success: function (media) {
                    if (document.documentElement.classList.contains('is-gallery-slideshow')) {
                        media.preload = 'auto';
                        media.loop = false;
                    }

                    if (!$cms.configOption('show_inline_stats')) {
                        media.addEventListener('play', function () {
                            $cms.gaTrack(null, '{!VIDEO;}', url);
                        });
                    }

                    var embeddedMediaData = $dom.data(container, 'cmsEmbeddedMedia');

                    if (embeddedMediaData != null) {
                        media.addEventListener('play', function () {
                            $dom.trigger(container, 'cms:media:play', {
                                mediaDuration: mediaElement.duration,
                                mediaCurrentTime: mediaElement.currentTime,
                            });
                        });

                        media.addEventListener('canplay', function () {
                            $dom.trigger(container, 'cms:media:canplay');
                        });

                        media.addEventListener('pause', function () {
                            $dom.trigger(container, 'cms:media:pause');
                        });

                        media.addEventListener('ended', function () {
                            $dom.trigger(container, 'cms:media:ended');
                        });

                        $dom.on(container, 'cms:media:do-play', function () {
                            mediaElement.play();
                        });

                        $dom.on(container, 'cms:media:do-pause', function () {
                            mediaElement.pause();
                        });

                        $dom.on(container, 'cms:media:do-resize', function () {
                            mediaElement.setPlayerSize();
                            mediaElement.setControlsSize();
                        });

                        embeddedMediaData.ready = true;
                        $dom.trigger(container, 'cms:media:ready');
                    }
                }
            };

        // Scale to a maximum width because we can always maximise - for object/embed players we can use max-width for this
        options.videoWidth = params.playerWidth;
        options.videoHeight = params.playerHeight;

        if (params.responsive) {
            options.stretching = 'responsive';
        }

        mediaElement = new MediaElementPlayer(playerId, options);
    };
}(window.$cms));

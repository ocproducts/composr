/*{+START,INCLUDE,core_rich_media,.js,javascript,,1}{+END}*/

(function ($cms) {
    /* global MediaElementPlayer:false */
    'use strict';
    $cms.templates.mediaAudioWebsafe = function mediaAudioWebsafe(params) {
        var playerId = strVal(params.playerId), player,
            width = strVal(params.width),
            height = strVal(params.height),
            url = strVal(params.url),
            options = {
                pluginPath: '{$BASE_URL;}/data_custom/mediaelement/',
                enableKeyboard: true,
                success: function (media) {
                    if (!$cms.isInlineStats()) {
                        media.addEventListener('play', function () {
                            $cms.gaTrack(null, '{!VIDEO;}', url);
                        });
                    }
                    if (document.getElementById('next_slide')) {
                        media.addEventListener('canplay', function () {
                            window.$galleries.stopSlideshowTimer('{!WILL_CONTINUE_AFTER_VIDEO_FINISHED;^}');
                            player.play();
                        });
                        media.addEventListener('ended', function () {
                            window.$galleries.playerStopped();
                        });
                    }
                }
            };

        // Scale to a maximum width because we can always maximise - for object/embed players we can use max-width for this
        options.videoWidth = Math.min(950, width);
        options.videoHeight = Math.min(height * (950 / width), height);

        player = new MediaElementPlayer(playerId, options);
    };

    $cms.templates.mediaVideoWebsafe = function mediaVideoWebsafe(params) {
        var playerId = strVal(params.playerId),
            player,
            width = strVal(params.width),
            height = strVal(params.height),
            url = strVal(params.url),
            options = {
                pluginPath: '{$BASE_URL;}/data_custom/mediaelement/',
                enableKeyboard: true,
                success: function (media) {
                    if (!$cms.isInlineStats()) {
                        media.addEventListener('play', function () {
                            $cms.gaTrack(null, '{!VIDEO;}', url);
                        });
                    }
                    if (document.getElementById('next_slide')) {
                        media.preload = 'auto';
                        media.loop = false;
                        media.addEventListener('canplay', function () {
                            window.$galleries.stopSlideshowTimer('{!WILL_CONTINUE_AFTER_VIDEO_FINISHED;^}');
                            player.play();
                        });
                        media.addEventListener('ended', function () {
                            window.$galleries.playerStopped();
                        });
                    }
                }
            };

        // Scale to a maximum width because we can always maximise - for object/embed players we can use max-width for this
        options.videoWidth = Math.min(950, width);
        options.videoHeight = Math.min(height * (950 / width), height);
        if (params.responsive) {
            options.stretching = 'responsive';
        }

        player = new MediaElementPlayer(playerId, options);
    };
}(window.$cms));

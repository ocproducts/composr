(function ($cms) {
    'use strict';

    if (window.slideshow_timer === undefined) {
        window.slideshow_timer = null;
        window.slideshow_slides = {};
        window.slideshow_time = null;
    }

    $cms.views.BlockMainImageFader = BlockMainImageFader;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function BlockMainImageFader(params) {
        BlockMainImageFader.base(this, 'constructor', arguments);

        var data = {},
            id = params.randFaderImage,
            key;

        data.fp_animation = document.getElementById('image_fader_' + id);
        data.fp_animation_fader = document.createElement('img');
        data.tease_title = document.getElementById('image_fader_title_' + id);
        data.tease_scrolling_text = document.getElementById('image_fader_scrolling_text_' + id);
        data.fp_animation_fader.className = 'img_thumb';
        data.fp_animation.parentNode.insertBefore(data.fp_animation_fader, data.fp_animation);
        data.fp_animation.parentNode.style.position = 'relative';
        data.fp_animation.parentNode.style.display = 'block';
        data.fp_animation_fader.style.position = 'absolute';
        data.fp_animation_fader.src = $cms.img('{$IMG;,blank}');

        for (key in params.titles) {
            this.initializeTitle(data, params.titles[key], key);
        }

        for (key in params.html) {
            this.initializeHtml(data, params.html[key], key);
        }

        for (key in params.images) {
            this.initializeImage(data, params.images[key], key, params.mill, params.images.length);
        }
    }

    $cms.inherits(BlockMainImageFader, $cms.View, /**@lends BlockMainImageFader#*/{
        initializeTitle: function (data, v, k) {
            data['title' + k] = v;
            if (k == 0) {
                if (data.tease_title) {
                    $cms.dom.html(data.tease_title, data['title' + k]);
                }
            }
        },
        initializeHtml: function (data, v, k) {
            data['html' + k] = v;
            if (k == 0) {
                if (data.tease_scrolling_text) {
                    $cms.dom.html(data.tease_scrolling_text, (data['html' + k] == '') ? '{!MEDIA;^}' : data['html' + k]);
                }
            }
        },
        initializeImage: function (data, v, k, mill, total) {
            var period_in_msecs = 50;
            var increment = 3;
            if (period_in_msecs * 100 / increment > mill) {
                period_in_msecs = mill * increment / 100;
                period_in_msecs *= 0.9; // A little give
            }

            data['url' + k] = v;
            new Image().src = data['url' + k]; // precache
            window.setTimeout(function () {
                function func() {
                    data.fp_animation_fader.src = data.fp_animation.src;
                    $cms.dom.clearTransitionAndSetOpacity(data.fp_animation_fader, 1.0);
                    $cms.dom.fadeTransition(data.fp_animation_fader, 0, period_in_msecs, increment * -1);
                    $cms.dom.clearTransitionAndSetOpacity(data.fp_animation, 0.0);
                    $cms.dom.fadeTransition(data.fp_animation, 100, period_in_msecs, increment);
                    data.fp_animation.src = data['url' + k];
                    data.fp_animation_fader.style.left = ((data.fp_animation_fader.parentNode.offsetWidth - data.fp_animation_fader.offsetWidth) / 2) + 'px';
                    data.fp_animation_fader.style.top = ((data.fp_animation_fader.parentNode.offsetHeight - data.fp_animation_fader.offsetHeight) / 2) + 'px';
                    if (data.tease_title) {
                        $cms.dom.html(data.tease_title, data['title' + k]);
                    }
                    if (data.tease_scrolling_text) {
                        $cms.dom.html(data.tease_scrolling_text, data['html' + k]);
                    }
                }

                if (k != 0) {
                    func();
                }

                window.setInterval(func, mill * total);
            }, k * mill);
        }
    });

    $cms.views.GalleryNav = GalleryNav;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function GalleryNav(params) {
        GalleryNav.base(this, 'constructor', arguments);

        window.slideshow_current_position = params._x - 1;
        window.slideshow_total_slides = params._n;

        if (params.slideshow) {
            this.initializeSlideshow();
        }
    }

    $cms.inherits(GalleryNav, $cms.View, /**@lends GalleryNav#*/{
        initializeSlideshow: function () {
            resetSlideshowCountdown();
            startSlideshowTimer();

            window.addEventListener('keypress', toggleSlideshowTimer);

            document.getElementById('gallery_entry_screen').addEventListener('click', function (event) {
                if (event.altKey || event.metaKey) {
                    var b = document.getElementById('gallery_entry_screen');
                    if (b.webkitRequestFullScreen !== undefined) {
                        b.webkitRequestFullScreen(window.Element.ALLOW_KEYBOARD_INPUT);
                    }
                    if (b.mozRequestFullScreenWithKeys !== undefined) {
                        b.mozRequestFullScreenWithKeys();
                    }
                    if (b.requestFullScreenWithKeys !== undefined) {
                        b.requestFullScreenWithKeys();
                    }
                } else {
                    toggleSlideshowTimer();
                }
            });

            slideshowShowSlide(window.slideshow_current_position); // To ensure next is preloaded
        },
        events: function () {
            return {
                'change .js-change-reset-slideshow-countdown': 'resetCountdown',
                'mousedown .js-mousedown-stop-slideshow-timer': 'stopTimer',
                'click .js-click-slideshow-backward': 'slideshowBackward',
                'click .js-click-slideshow-forward': 'slideshowForward'
            };
        },
        resetCountdown: function () {
            resetSlideshowCountdown();
        },
        stopTimer: function () {
            stopSlideshowTimer('{!STOPPED^;}');
        },
        slideshowBackward: function () {
            slideshowBackward();

        },
        slideshowForward: function () {
            slideshowForward();
        }
    });

    $cms.functions.moduleCmsQuiz = function moduleCmsQuiz() {
        document.getElementById('type').addEventListener('change', hideFunc);
        hideFunc();

        function hideFunc() {
            var ob = document.getElementById('type');
            if (ob.value == 'TEST') {
                document.getElementById('percentage').disabled = false;
                document.getElementById('num_winners').disabled = true;
            }
            if (ob.value == 'COMPETITION') {
                document.getElementById('num_winners').disabled = false;
                document.getElementById('percentage').disabled = true;
            }
            if (ob.value == 'SURVEY') {
                document.getElementById('text').value = document.getElementById('text').value.replace(/ \[\*\]/g, '');
                document.getElementById('num_winners').disabled = true;
                document.getElementById('percentage').disabled = true;
            }
        }
    };

    $cms.functions.moduleCmsGalleriesCat = function moduleCmsGalleriesCat() {
        var fn = document.getElementById('fullname');
        if (fn) {
            var form = fn.form;
            fn.addEventListener('change', function () {
                if ((form.elements['name']) && (form.elements['name'].value === '')) {
                    form.elements['name'].value = fn.value.toLowerCase().replace(/[^{$URL_CONTENT_REGEXP_JS}]/g, '_').replace(/\_+$/, '').substr(0, 80);
                }
            });
        }
    };

    $cms.functions.moduleCmsGalleriesRunStartAddCategory = function moduleCmsGalleriesRunStartAddCategory() {
        var form = document.getElementById('main_form');
        form.addEventListener('submit', function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;^,snippet}?snippet=exists_gallery&name=' + encodeURIComponent(form.elements['name'].value);
            if (!$cms.form.doAjaxFieldTest(url)) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
        });
    };


    $cms.templates.blockMainGalleryEmbed = function blockMainGalleryEmbed(params) {
        var container = this,
            carouselId = params.carouselId ? ('' + params.carouselId) : '',
            blockCallUrl = params.blockCallUrl ? ('' + params.blockCallUrl) : '',
            currentLoadingFromPos = +params.start || 0;

        if (!carouselId|| !blockCallUrl) {
            return;
        }

        $cms.dom.on(container, 'click', '.js-click-carousel-prepare-load-more', function () {
            var ob = document.getElementById('carousel_ns_' + carouselId);

            if ((ob.parentNode.scrollLeft + ob.offsetWidth * 2) < ob.scrollWidth) {
                return; // Not close enough to need more results
            }

            currentLoadingFromPos += +params.max || 0;

            $cms.callBlock(blockCallUrl, 'raw=1,cache=0', ob, true);
        });
    };

    $cms.templates.galleryImportScreen = function () {
        var files = document.getElementById('second_files'), i;

        if (!files) {
            return;
        }

        for (i = 0; i < files.options.length; i++) {
            $cms.dom.on(files[i], 'mouseover', function (event) {
                $cms.ui.activateTooltip(this, event, '<img width="500" src="' + $cms.filter.html($cms.$BASE_URL()) + '/uploads/galleries/' + window.encodeURI(this.value) + '" \/>', 'auto');
            });
            $cms.dom.on(files[i], 'mousemove', function (event) {
                $cms.ui.repositionTooltip(this, event);
            });
            $cms.dom.on(files[i], 'mouseout', function (event) {
                $cms.ui.deactivateTooltip(this);
            });
        }
    };

    function startSlideshowTimer() {
        if (!window.slideshow_timer) {
            window.slideshow_timer = window.setInterval(function () {
                window.slideshow_time--;
                showCurrentSlideshowTime();

                if (window.slideshow_time == 0) {
                    slideshowForward();
                }
            }, 1000);
        }

        if (window.slideshow_current_position !== (window.slideshow_total_slides - 1)) {
            document.getElementById('gallery_entry_screen').style.cursor = 'progress';
        }
    }

    function showCurrentSlideshowTime() {
        var changer = document.getElementById('changer_wrap');
        if (changer) {
            $cms.dom.html(changer, $cms.format('{!galleries:CHANGING_IN;^}', Math.max(0, window.slideshow_time)));
        }
    }

    function resetSlideshowCountdown() {
        var slideshow_from = document.getElementById('slideshow_from');
        window.slideshow_time = slideshow_from ? window.parseInt(slideshow_from.value) : 5;

        showCurrentSlideshowTime();

        if (window.slideshow_current_position == window.slideshow_total_slides - 1) {
            window.slideshow_time = 0;
        }
    }

    function toggleSlideshowTimer() {
        if (window.slideshow_timer) {
            stopSlideshowTimer();
        } else {
            showCurrentSlideshowTime();
            startSlideshowTimer();
        }
    }

    function stopSlideshowTimer(message) {
        if (message === undefined) {
            message = '{!galleries:STOPPED;^}';
        }
        var changer = document.getElementById('changer_wrap');
        if (changer) {
            $cms.dom.html(changer, message);
        }
        if (window.slideshow_timer) {
            window.clearInterval(window.slideshow_timer);
        }
        window.slideshow_timer = null;
        document.getElementById('gallery_entry_screen').style.cursor = '';
    }

    function slideshowBackward() {
        if (window.slideshow_current_position === 0) {
            return;
        }

        slideshowShowSlide(window.slideshow_current_position - 1);
    }

    function playerStopped() {
        slideshowForward();
    }

    function slideshowForward() {
        if (window.slideshow_current_position === (window.slideshow_total_slides - 1)) {
            stopSlideshowTimer('{!galleries:LAST_SLIDE;^}');
            return;
        }

        slideshowShowSlide(window.slideshow_current_position + 1);
    }

    function slideshowEnsureLoaded(slide, callback) {
        if (window.slideshow_slides[slide] !== undefined) {
            if (callback !== undefined) {
                callback();
            }
            return; // Already have it
        }

        if (window.slideshow_current_position === slide) {// Ah, it's where we are, so save that in
            window.slideshow_slides[slide] = $cms.dom.html(document.getElementById('gallery_entry_screen'));
            return;
        }

        if ((slide == window.slideshow_current_position - 1) || (slide == window.slideshow_current_position + 1)) {
            var url;
            if (slide == window.slideshow_current_position + 1) {
                url = document.getElementById('next_slide').value;
            }
            if (slide == window.slideshow_current_position - 1) {
                url = document.getElementById('previous_slide').value;
            }

            if (callback !== undefined) {
                $cms.doAjaxRequest(url, function (ajax_result_raw) {
                    _slideshowReadInSlide(ajax_result_raw, slide);
                    callback();
                });
            } else {
                $cms.doAjaxRequest(url, function (ajax_result_raw) {
                    _slideshowReadInSlide(ajax_result_raw, slide);
                });
            }
        } else {
            $cms.ui.alert('Internal error: should not be preloading more than one step ahead');
        }
    }

    function _slideshowReadInSlide(ajax_result_raw, slide) {
        window.slideshow_slides[slide] = ajax_result_raw.responseText.replace(/(.|\n)*<div class="gallery_entry_screen"[^<>]*>/i, '').replace(/<!--DO_NOT_REMOVE_THIS_COMMENT-->\s*<\/div>(.|\n)*/i, '');
    }

    function slideshowShowSlide(slide) {
        slideshowEnsureLoaded(slide, function () {
            var fade_elements;

            if (window.slideshow_current_position !== slide) { // If not already here
                var slideshow_from = document.getElementById('slideshow_from');

                var fade_elements_old = document.body.querySelectorAll('.scale_down');
                if (fade_elements_old[0] !== undefined) {
                    var fade_element_old = fade_elements_old[0];
                    var left_pos = fade_element_old.parentNode.offsetWidth / 2 - fade_element_old.offsetWidth / 2;
                    fade_element_old.style.left = left_pos + 'px';
                    fade_element_old.style.position = 'absolute';
                } // else probably a video

                var cleaned_slide_html = window.slideshow_slides[slide].replace(/<!DOCTYPE [^>]*>/i, '').replace(/<script[^>]*>(.|\n)*?<\/script>/gi, '');
                $cms.dom.html(document.getElementById('gallery_entry_screen'), cleaned_slide_html);

                fade_elements = document.body.querySelectorAll('.scale_down');
                if ((fade_elements[0] !== undefined) && (fade_elements_old[0] !== undefined)) {
                    var fade_element = fade_elements[0];
                    $cms.dom.clearTransitionAndSetOpacity(fade_element, 0);
                    fade_element.parentNode.insertBefore(fade_element_old, fade_element);
                    fade_element.parentNode.style.position = 'relative';
                    $cms.dom.fadeTransition(fade_element, 100.0, 30, 10);
                    $cms.dom.clearTransitionAndSetOpacity(fade_element_old, 1.0);
                    $cms.dom.fadeTransition(fade_element_old, 0.0, 30, -10, true);
                } // else probably a video

                if (slideshow_from){
                    // Make sure stays the same
                    document.getElementById('slideshow_from').value = slideshow_from.value;
                }

                window.slideshow_current_position = slide;

                if (window.show_slide_callback !== undefined) {
                    show_slide_callback();
                }
            }

            fade_elements = document.body.querySelectorAll('.scale_down');
            if (fade_elements[0] !== undefined) {// Is image
                startSlideshowTimer();
                resetSlideshowCountdown();
            } else {// Is video
                stopSlideshowTimer('{!galleries:WILL_CONTINUE_AFTER_VIDEO_FINISHED;^}');
            }

            if (window.slideshow_current_position != window.slideshow_total_slides - 1) {
                slideshowEnsureLoaded(slide + 1);
            } else {
                document.getElementById('gallery_entry_screen').style.cursor = '';
            }
        });
    }

    // Exports to be gotten rid of later
    window.playerStopped = playerStopped;
    window.stopSlideshowTimer = stopSlideshowTimer;
}(window.$cms));


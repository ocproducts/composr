'use strict';
(function ($cms) {
    if (window.slideshow_timer === undefined) {
        window.slideshow_timer = null;
        window.slideshow_slides = {};
        window.slideshow_time = null;
    }

    $cms.views.BlockMainImageFader = BlockMainImageFader;
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

    $cms.inherits(BlockMainImageFader, $cms.View, {
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
                    clear_transition_and_set_opacity(data.fp_animation_fader, 1.0);
                    fade_transition(data.fp_animation_fader, 0, period_in_msecs, increment * -1);
                    clear_transition_and_set_opacity(data.fp_animation, 0.0);
                    fade_transition(data.fp_animation, 100, period_in_msecs, increment);
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
    function GalleryNav(params) {
        GalleryNav.base(this, 'constructor', arguments);

        window.slideshow_current_position = params._x - 1;
        window.slideshow_total_slides = params._n;

        if (params.slideshow) {
            this.initializeSlideshow();
        }
    }

    $cms.inherits(GalleryNav, $cms.View, {
        initializeSlideshow: function () {
            reset_slideshow_countdown();
            start_slideshow_timer();

            window.addEventListener('keypress', toggle_slideshow_timer);

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
                    toggle_slideshow_timer();
                }
            });

            slideshow_show_slide(window.slideshow_current_position); // To ensure next is preloaded
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
            reset_slideshow_countdown();
        },
        stopTimer: function () {
            stop_slideshow_timer('{!STOPPED^;}');
        },
        slideshowBackward: function () {
            slideshow_backward();

        },
        slideshowForward: function () {
            slideshow_forward();
        }
    });

    $cms.functions.moduleCmsQuiz = function moduleCmsQuiz() {
        document.getElementById('type').addEventListener('change', hide_func);
        hide_func();

        function hide_func() {
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

            window.call_block(blockCallUrl, 'raw=1,cache=0', ob, true);
        });
    };

    $cms.templates.galleryImportScreen = function () {
        var files = document.getElementById('second_files'), i;

        if (!files) {
            return;
        }

        function preview_generator_mouseover(event) {
            activate_tooltip(this, event, '<img width="500" src="' + $cms.filter.html($cms.$BASE_URL) + '/uploads/galleries/' + window.encodeURI(this.value) + '" \/>', 'auto');
        }

        function preview_generator_mousemove(event) {
            reposition_tooltip(this, event);
        }

        function preview_generator_mouseout(event) {
            deactivate_tooltip(this);
        }

        for (i = 0; i < files.options.length; i++) {
            $cms.dom.on(files[i], 'mouseover', preview_generator_mouseover);
            $cms.dom.on(files[i], 'mousemove', preview_generator_mousemove);
            $cms.dom.on(files[i], 'mouseout', preview_generator_mouseout);
        }
    };

    function start_slideshow_timer() {
        if (!window.slideshow_timer) {
            window.slideshow_timer = window.setInterval(function () {
                window.slideshow_time--;
                show_current_slideshow_time();

                if (window.slideshow_time == 0) {
                    slideshow_forward();
                }
            }, 1000);
        }

        if (window.slideshow_current_position !== (window.slideshow_total_slides - 1)) {
            document.getElementById('gallery_entry_screen').style.cursor = 'progress';
        }
    }

    function show_current_slideshow_time() {
        var changer = document.getElementById('changer_wrap');
        if (changer) {
            $cms.dom.html(changer, $cms.format('{!galleries:CHANGING_IN;^}', Math.max(0, window.slideshow_time)));
        }
    }

    function reset_slideshow_countdown() {
        var slideshow_from = document.getElementById('slideshow_from');
        window.slideshow_time = slideshow_from ? window.parseInt(slideshow_from.value) : 5;

        show_current_slideshow_time();

        if (window.slideshow_current_position == window.slideshow_total_slides - 1) {
            window.slideshow_time = 0;
        }
    }

    function toggle_slideshow_timer() {
        if (window.slideshow_timer) {
            stop_slideshow_timer();
        } else {
            show_current_slideshow_time();
            start_slideshow_timer();
        }
    }

    function stop_slideshow_timer(message) {
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

    function slideshow_backward() {
        if (window.slideshow_current_position === 0) {
            return;
        }

        slideshow_show_slide(window.slideshow_current_position - 1);
    }

    function player_stopped() {
        slideshow_forward();
    }

    function slideshow_forward() {
        if (window.slideshow_current_position === (window.slideshow_total_slides - 1)) {
            stop_slideshow_timer('{!galleries:LAST_SLIDE;^}');
            return;
        }

        slideshow_show_slide(window.slideshow_current_position + 1);
    }

    function slideshow_ensure_loaded(slide, callback) {
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
                do_ajax_request(url, function (ajax_result_raw) {
                    _slideshow_read_in_slide(ajax_result_raw, slide);
                    callback();
                });
            } else {
                do_ajax_request(url, function (ajax_result_raw) {
                    _slideshow_read_in_slide(ajax_result_raw, slide);
                });
            }
        } else {
            $cms.ui.alert('Internal error: should not be preloading more than one step ahead');
        }
    }

    function _slideshow_read_in_slide(ajax_result_raw, slide) {
        window.slideshow_slides[slide] = ajax_result_raw.responseText.replace(/(.|\n)*<div class="gallery_entry_screen"[^<>]*>/i, '').replace(/<!--DO_NOT_REMOVE_THIS_COMMENT-->\s*<\/div>(.|\n)*/i, '');
    }

    function slideshow_show_slide(slide) {
        slideshow_ensure_loaded(slide, function () {
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
                    clear_transition_and_set_opacity(fade_element, 0);
                    fade_element.parentNode.insertBefore(fade_element_old, fade_element);
                    fade_element.parentNode.style.position = 'relative';
                    fade_transition(fade_element, 100.0, 30, 10);
                    clear_transition_and_set_opacity(fade_element_old, 1.0);
                    fade_transition(fade_element_old, 0.0, 30, -10, true);
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
                start_slideshow_timer();
                reset_slideshow_countdown();
            } else {// Is video
                stop_slideshow_timer('{!galleries:WILL_CONTINUE_AFTER_VIDEO_FINISHED;^}');
            }

            if (window.slideshow_current_position != window.slideshow_total_slides - 1) {
                slideshow_ensure_loaded(slide + 1);
            } else {
                document.getElementById('gallery_entry_screen').style.cursor = '';
            }
        });
    }

    // Exports to be gotten rid of later
    window.player_stopped = player_stopped;
    window.stop_slideshow_timer = stop_slideshow_timer;
}(window.$cms));


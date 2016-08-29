'use strict';

(function ($, Composr) {
    Composr.behaviors.galleries = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'galleries');
            }
        }
    };

    Composr.templates.galleries = {
        galleryNav: function galleryNav(options) {
            window.slideshow_current_position = options._x -1;
            window.slideshow_total_slides = options._n;

            if (Composr.isTruthy(options.slideshow)) {
                initialise_slideshow();
            }
        },

        blockMainGalleryEmbed: function blockMainGalleryEmbed(options) {
            if (!options.carouselId || !options.blockCallUrl) {
                return;
            }

            window['current_loading_from_pos_' + options.carouselId] = options.start || 0;

            window['carousel_prepare_load_more_' + options.carouselId] = function () {
                var ob = document.getElementById('carousel_ns_' + options.carouselId);

                if (ob.parentNode.scrollLeft + ob.offsetWidth * 2 < ob.scrollWidth) return; // Not close enough to need more results

                window['current_loading_from_pos_' + options.carouselId] += options.max;

                call_block(options.blockCallUrl, 'raw=1,cache=0', ob, true);
            };
        },

        blockMainImageFader: function blockMainImageFader(options) {
            var data = {}, key;

            Composr.required(options, ['randFaderImage', 'titles', 'html', 'images', 'mill']);

            initialise_image_fader(data, options.randFaderImage);

            for (key in options.titles) {
                if (options.titles.hasOwnProperty(key)) {
                    initialise_image_fader_title(data, options.titles[key], key);
                }
            }

            for (key in options.html) {
                if (options.html.hasOwnProperty(key)) {
                    initialise_image_fader_html(data, options.html[key], key);
                }
            }

            for (key in options.images) {
                if (options.images.hasOwnProperty(key)) {
                    initialise_image_fader_image(data, options.images[key], options.mill, options.images.length);
                }
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);


if (typeof window.slideshow_timer == 'undefined') {
    window.slideshow_timer = null;
    window.slideshow_slides = {};
    window.slideshow_time = null;
}

function initialise_slideshow() {
    reset_slideshow_countdown();
    start_slideshow_timer();

    window.addEventListener('keypress', toggle_slideshow_timer);

    document.getElementById('gallery_entry_screen').addEventListener('click', function (event) {
        if (event.altKey || event.metaKey) {
            var b = document.getElementById('gallery_entry_screen');
            if (typeof b.webkitRequestFullScreen != 'undefined') b.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
            if (typeof b.mozRequestFullScreenWithKeys != 'undefined') b.mozRequestFullScreenWithKeys();
            if (typeof b.requestFullScreenWithKeys != 'undefined') b.requestFullScreenWithKeys();
        } else {
            toggle_slideshow_timer();
        }
    });

    slideshow_show_slide(window.slideshow_current_position); // To ensure next is preloaded
}

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

    if (window.slideshow_current_position != window.slideshow_total_slides - 1)
        document.getElementById('gallery_entry_screen').style.cursor = 'progress';
}

function show_current_slideshow_time() {
    var changer = document.getElementById('changer_wrap');
    if (changer) Composr.dom.html(changer, '{!galleries:CHANGING_IN,xxx}'.replace('xxx', (window.slideshow_time < 0) ? 0 : window.slideshow_time));
}

function reset_slideshow_countdown() {
    var slideshow_from = document.getElementById('slideshow_from');
    window.slideshow_time = slideshow_from ? window.parseInt(slideshow_from.value) : 5;

    show_current_slideshow_time();

    if (window.slideshow_current_position == window.slideshow_total_slides - 1)
        window.slideshow_time = 0;
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
    if (typeof message == 'undefined') message = '{!galleries:STOPPED;}';
    var changer = document.getElementById('changer_wrap');
    if (changer) Composr.dom.html(changer, message);
    if (window.slideshow_timer) window.clearInterval(window.slideshow_timer);
    window.slideshow_timer = null;
    document.getElementById('gallery_entry_screen').style.cursor = '';
}

function slideshow_backward() {
    if (window.slideshow_current_position == 0) return false;

    slideshow_show_slide(window.slideshow_current_position - 1);

    return false;
}

function player_stopped() {
    slideshow_forward();
}

function slideshow_forward() {
    if (window.slideshow_current_position == window.slideshow_total_slides - 1) {
        stop_slideshow_timer('{!galleries:LAST_SLIDE;}');
        return false;
    }

    slideshow_show_slide(window.slideshow_current_position + 1);

    return false;
}

function slideshow_ensure_loaded(slide, callback) {
    if (typeof window.slideshow_slides[slide] != 'undefined') {
        if (typeof callback != 'undefined') {
            callback();
        }
        return; // Already have it
    }

    if (window.slideshow_current_position == slide) // Ah, it's where we are, so save that in
    {
        window.slideshow_slides[slide] = Composr.dom.html(document.getElementById('gallery_entry_screen'));
        return;
    }

    if ((slide == window.slideshow_current_position - 1) || (slide == window.slideshow_current_position + 1)) {
        var url;
        if (slide == window.slideshow_current_position + 1)
            url = document.getElementById('next_slide').value;
        if (slide == window.slideshow_current_position - 1)
            url = document.getElementById('previous_slide').value;

        if (typeof callback != 'undefined') {
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
        window.fauxmodal_alert('Internal error: should not be preloading more than one step ahead');
    }
}

function _slideshow_read_in_slide(ajax_result_raw, slide) {
    window.slideshow_slides[slide] = ajax_result_raw.responseText.replace(/(.|\n)*<div class="gallery_entry_screen"[^<>]*>/i, '').replace(/<!--DO_NOT_REMOVE_THIS_COMMENT-->\s*<\/div>(.|\n)*/i, '');
}

function slideshow_show_slide(slide) {
    slideshow_ensure_loaded(slide, function () {
        if (window.slideshow_current_position != slide) // If not already here
        {
            var slideshow_from = document.getElementById('slideshow_from');

            var fade_elements_old = document.body.querySelectorAll('.scale_down');
            if (typeof fade_elements_old[0] != 'undefined') {
                var fade_element_old = fade_elements_old[0];
                var left_pos = fade_element_old.parentNode.offsetWidth / 2 - fade_element_old.offsetWidth / 2;
                fade_element_old.style.left = left_pos + 'px';
                fade_element_old.style.position = 'absolute';
            } // else probably a video

            var cleaned_slide_html = window.slideshow_slides[slide].replace(/<!DOCTYPE [^>]*>/i, '').replace(/<script[^>]*>(.|\n)*?<\/script>/gi, '');
            Composr.dom.html(document.getElementById('gallery_entry_screen'), cleaned_slide_html);

            var fade_elements = document.body.querySelectorAll('.scale_down');
            if ((typeof fade_elements[0] != 'undefined') && (typeof fade_elements_old[0] != 'undefined')) {
                var fade_element = fade_elements[0];
                set_opacity(fade_element, 0);
                fade_element.parentNode.insertBefore(fade_element_old, fade_element);
                fade_element.parentNode.style.position = 'relative';
                fade_transition(fade_element, 100.0, 30, 10);
                set_opacity(fade_element_old, 1.0);
                fade_transition(fade_element_old, 0.0, 30, -10, true);
            } // else probably a video

            if (slideshow_from)
                document.getElementById('slideshow_from').value = slideshow_from.value; // Make sure stays the same

            window.slideshow_current_position = slide;

            if (typeof window.show_slide_callback != 'undefined') show_slide_callback();
        }

        var fade_elements = document.body.querySelectorAll('.scale_down');
        if (typeof fade_elements[0] != 'undefined') // Is image
        {
            start_slideshow_timer();
            reset_slideshow_countdown();
        } else // Is video
        {
            stop_slideshow_timer('{!galleries:WILL_CONTINUE_AFTER_VIDEO_FINISHED}');
        }

        if (window.slideshow_current_position != window.slideshow_total_slides - 1)
            slideshow_ensure_loaded(slide + 1);
        else
            document.getElementById('gallery_entry_screen').style.cursor = '';
    });
}


// GALLERY_IMPORT_SCREEN:
function preview_generator_mouseover(event)
{
    if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'<img width="500" src="{$BASE_URL*}/uploads/galleries/'+window.encodeURI(this.value)+'" \/>','auto');
}

function preview_generator_mousemove(event)
{
    if (typeof window.activate_tooltip!='undefined') reposition_tooltip(this,event);
}

function preview_generator_mouseout(event)
{
    if (typeof window.deactivate_tooltip!='undefined') deactivate_tooltip(this);
}

function load_previews()
{
    var files=document.getElementById('second_files');
    if (!files) return;
    for (var i=0;i<files.options.length;i++)
    {
        files[i].onmouseover=preview_generator_mouseover;
        files[i].onmousemove=preview_generator_mousemove;
        files[i].onmouseout=preview_generator_mouseout;
    }
}
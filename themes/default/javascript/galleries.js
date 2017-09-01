(function ($cms) {
    'use strict';

    if (window.slideshowTimer === undefined) {
        window.slideshowTimer = null;
        window.slideshowSlides = {};
        window.slideshowTime = null;
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

        data.fpAnimation = document.getElementById('image_fader_' + id);
        data.fpAnimationFader = document.createElement('img');
        data.teaseTitle = document.getElementById('image_fader_title_' + id);
        data.teaseScrollingText = document.getElementById('image_fader_scrolling_text_' + id);
        data.fpAnimationFader.className = 'img_thumb';
        data.fpAnimation.parentNode.insertBefore(data.fpAnimationFader, data.fpAnimation);
        data.fpAnimation.parentNode.style.position = 'relative';
        data.fpAnimation.parentNode.style.display = 'block';
        data.fpAnimationFader.style.position = 'absolute';
        data.fpAnimationFader.src = $cms.img('{$IMG;,blank}');

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
                if (data.teaseTitle) {
                    $cms.dom.html(data.teaseTitle, data['title' + k]);
                }
            }
        },
        initializeHtml: function (data, v, k) {
            data['html' + k] = v;
            if (k == 0) {
                if (data.teaseScrollingText) {
                    $cms.dom.html(data.teaseScrollingText, (data['html' + k] == '') ? '{!MEDIA;^}' : data['html' + k]);
                }
            }
        },
        initializeImage: function (data, v, k, mill, total) {
            var periodInMsecs = 50;
            var increment = 3;
            if (periodInMsecs * 100 / increment > mill) {
                periodInMsecs = mill * increment / 100;
                periodInMsecs *= 0.9; // A little give
            }

            data['url' + k] = v;
            new Image().src = data['url' + k]; // precache
            setTimeout(function () {
                function func() {
                    data.fpAnimationFader.src = data.fpAnimation.src;
                    $cms.dom.fadeOut(data.fpAnimationFader);
                    $cms.dom.fadeIn(data.fpAnimation);
                    data.fpAnimation.src = data['url' + k];
                    data.fpAnimationFader.style.left = ((data.fpAnimationFader.parentNode.offsetWidth - data.fpAnimationFader.offsetWidth) / 2) + 'px';
                    data.fpAnimationFader.style.top = ((data.fpAnimationFader.parentNode.offsetHeight - data.fpAnimationFader.offsetHeight) / 2) + 'px';
                    if (data.teaseTitle) {
                        $cms.dom.html(data.teaseTitle, data['title' + k]);
                    }
                    if (data.teaseScrollingText) {
                        $cms.dom.html(data.teaseScrollingText, data['html' + k]);
                    }
                }

                if (k != 0) {
                    func();
                }

                setInterval(func, mill * total);
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

        window.slideshowCurrentPosition = params._x - 1;
        window.slideshowTotalSlides = params._n;

        if (params.slideshow) {
            this.initializeSlideshow();
        }
    }

    $cms.inherits(GalleryNav, $cms.View, /**@lends GalleryNav#*/{
        initializeSlideshow: function () {
            resetSlideshowCountdown();
            startSlideshowTimer();

            window.addEventListener('keypress', toggleSlideshowTimer);

            document.getElementById('gallery_nav').addEventListener('click', function (event) {
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

            slideshowShowSlide(window.slideshowCurrentPosition); // To ensure next is preloaded
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
            stopSlideshowTimer('{!galleries:STOPPED^;}');
        },
        slideshowBackward: function () {
            slideshowBackward();

        },
        slideshowForward: function () {
            slideshowForward();
        }
    });

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
        var form = document.getElementById('main_form'),
            submitBtn = document.getElementById('submit_button');
        form.addEventListener('submit', function submitCheck() {
            submitBtn.disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;^,snippet}?snippet=exists_gallery&name=' + encodeURIComponent(form.elements['name'].value);
            e.preventDefault();
            $cms.form.doAjaxFieldTest(url).then(function (valid) {
                if (valid) {
                    form.removeEventListener('submit', submitCheck);
                    form.submit();
                } else {
                    submitBtn.disabled = false;
                }
            });
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
                $cms.ui.activateTooltip(this, event, '<img width="500" src="' + $cms.filter.html($cms.$BASE_URL()) + '/uploads/galleries/' + encodeURI(this.value) + '" \/>', 'auto');
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
        if (!window.slideshowTimer) {
            window.slideshowTimer = setInterval(function () {
                window.slideshowTime--;
                showCurrentSlideshowTime();

                if (window.slideshowTime == 0) {
                    slideshowForward();
                }
            }, 1000);
        }

        if (window.slideshowCurrentPosition !== (window.slideshowTotalSlides - 1)) {
            document.getElementById('gallery_entry_screen').style.cursor = 'progress';
        }
    }

    function showCurrentSlideshowTime() {
        var changer = document.getElementById('changer_wrap');
        if (changer) {
            $cms.dom.html(changer, $cms.format('{!galleries:CHANGING_IN;^}', Math.max(0, window.slideshowTime)));
        }
    }

    function resetSlideshowCountdown() {
        var slideshowFrom = document.getElementById('slideshow_from');
        window.slideshowTime = slideshowFrom ? parseInt(slideshowFrom.value) : 5;

        showCurrentSlideshowTime();

        if (window.slideshowCurrentPosition == window.slideshowTotalSlides - 1) {
            window.slideshowTime = 0;
        }
    }

    function toggleSlideshowTimer() {
        if (window.slideshowTimer) {
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
        if (window.slideshowTimer) {
            clearInterval(window.slideshowTimer);
        }
        window.slideshowTimer = null;
        document.getElementById('gallery_entry_screen').style.cursor = '';
    }

    function slideshowBackward() {
        if (window.slideshowCurrentPosition === 0) {
            return;
        }

        slideshowShowSlide(window.slideshowCurrentPosition - 1);
    }

    function playerStopped() {
        slideshowForward();
    }

    function slideshowForward() {
        if (window.slideshowCurrentPosition === (window.slideshowTotalSlides - 1)) {
            stopSlideshowTimer('{!galleries:LAST_SLIDE;^}');
            return;
        }

        slideshowShowSlide(window.slideshowCurrentPosition + 1);
    }

    function slideshowEnsureLoaded(slide, callback) {
        if (window.slideshowSlides[slide] !== undefined) {
            if (callback !== undefined) {
                callback();
            }
            return; // Already have it
        }

        if (window.slideshowCurrentPosition === slide) { // Ah, it's where we are, so save that in
            window.slideshowSlides[slide] = $cms.dom.html(document.getElementById('gallery_entry_screen'));
            return;
        }

        if ((slide == window.slideshowCurrentPosition - 1) || (slide == window.slideshowCurrentPosition + 1)) {
            var url;
            if (slide == window.slideshowCurrentPosition + 1) {
                url = document.getElementById('next_slide').value;
            }
            if (slide == window.slideshowCurrentPosition - 1) {
                url = document.getElementById('previous_slide').value;
            }

            if (callback !== undefined) {
                $cms.doAjaxRequest(url).then(function (xhr) {
                    _slideshowReadInSlide(xhr, slide);
                    callback();
                });
            } else {
                $cms.doAjaxRequest(url).then(function (xhr) {
                    _slideshowReadInSlide(xhr, slide);
                });
            }
        } else {
            $cms.ui.alert('Internal error: should not be preloading more than one step ahead');
        }
    }

    function _slideshowReadInSlide(ajaxResultRaw, slide) {
        window.slideshowSlides[slide] = ajaxResultRaw.responseText.replace(/(.|\n)*<div class="gallery_entry_screen"[^<>]*>/i, '').replace(/<!--DO_NOT_REMOVE_THIS_COMMENT-->\s*<\/div>(.|\n)*/i, ''); // FUDGE
    }

    function slideshowShowSlide(slide) {
        slideshowEnsureLoaded(slide, function () {
            var fadeElements;

            if (window.slideshowCurrentPosition !== slide) { // If not already here
                var slideshowFrom = document.getElementById('slideshow_from');

                var fadeElementsOld = document.body.querySelectorAll('.scale_down');
                if (fadeElementsOld[0] !== undefined) {
                    var fadeElementOld = fadeElementsOld[0];
                    var leftPos = fadeElementOld.parentNode.offsetWidth / 2 - fadeElementOld.offsetWidth / 2;
                    fadeElementOld.style.left = leftPos + 'px';
                    fadeElementOld.style.position = 'absolute';
                } // else probably a video

                var cleanedSlideHtml = window.slideshowSlides[slide].replace(/<!DOCTYPE [^>]*>/i, ''); // FUDGE
                $cms.dom.html(document.getElementById('gallery_entry_screen'), cleanedSlideHtml);

                fadeElements = document.body.querySelectorAll('.scale_down');
                if ((fadeElements[0] !== undefined) && (fadeElementsOld[0] !== undefined)) {
                    var fadeElement = fadeElements[0];
                    fadeElement.parentNode.insertBefore(fadeElementOld, fadeElement);
                    fadeElement.parentNode.style.position = 'relative';
                    $cms.dom.fadeIn(fadeElement);
                    $cms.dom.fadeOut(fadeElementOld, null, function () {
                        $cms.dom.remove(fadeElementOld);
                    });
                } // else probably a video

                if (slideshowFrom){
                    // Make sure stays the same
                    document.getElementById('slideshow_from').value = slideshowFrom.value;
                }

                window.slideshowCurrentPosition = slide;
            }

            fadeElements = document.body.querySelectorAll('.scale_down');
            if (fadeElements[0] !== undefined) { // Is image
                startSlideshowTimer();
                resetSlideshowCountdown();
            } else { // Is video
                stopSlideshowTimer('{!galleries:WILL_CONTINUE_AFTER_VIDEO_FINISHED;^}');
            }

            if (window.slideshowCurrentPosition != window.slideshowTotalSlides - 1) {
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

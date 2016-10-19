(function ($cms) {
    'use strict';

    $cms.views.CommentsPostingForm = CommentsPostingForm;

    function CommentsPostingForm(params) {
        CommentsPostingForm.base(this, arguments);

        this.form = this.$('form.js-form-comments');
        this.btnSubmit = this.$('.js-btn-submit-comments');

        set_up_comcode_autocomplete('post', !!params.wysiwyg);

        if ($cms.$CONFIG_OPTION.enable_previews && $cms.$FORCE_PREVIEWS) {
            this.btnSubmit.style.display = 'none';
        }

        if (params.useCaptcha) {
            this.addCaptchaChecking();
        }

        if (params.type && params.id) {
            this.initReviewRatings();
        }

        var captchaSpot = this.$('#captcha_spot');
        if (captchaSpot) {
            $cms.dom.html(captchaSpot, params.captcha);
        }
    }

    $cms.inherits(CommentsPostingForm, $cms.View, {
        events: {
            'click .js-btn-full-editor': 'moveToFullEditor',
            'click .js-btn-submit-comments': 'clickBtnSubmit',
            'click .js-click-do-form-preview': 'doFormPreview',
            'submit .js-form-comments': 'submitFormComments',

            'click .js-img-review-bar': 'reviewBarClick',
            'mouseover .js-img-review-bar': 'reviewBarHover',
            'mouseout .js-img-review-bar': 'reviewBarHover'
        },

        initReviewRatings: function () {
            var view = this,
                reviewRatingContainers = view.$$('.js-container-review-rating');

            reviewRatingContainers.forEach(function (container) {
                view.displayReviewRating(container);
            });
        },

        displayReviewRating: function (container, rating) {
            var reviewBars = $cms.dom.$$(container, '.js-img-review-bar');
            if (rating === undefined) {
                rating = $cms.dom.$(container, '.js-inp-review-rating').value;
            }
            rating = +rating || 0;

            reviewBars.forEach(function (reviewBar) {
                var barRating = +reviewBar.dataset.vwRating || 0,
                    shouldHighlight = barRating <= rating; // Whether to highlight this bar

                reviewBar.classList.toggle('rating_star_highlight', shouldHighlight);
                reviewBar.classList.toggle('rating_star', !shouldHighlight);
            });
        },

        reviewBarClick: function (e, reviewBar) {
            var container = this.$closest(reviewBar, '.js-container-review-rating'),
                ratingInput = container.querySelector('.js-inp-review-rating');

            ratingInput.value = +reviewBar.dataset.vwRating || 0;
            this.displayReviewRating(container);
        },

        reviewBarHover: function (e, reviewBar) {
            var container = this.$closest(reviewBar, '.js-container-review-rating'),
                rating = (e.type === 'mouseover') ? reviewBar.dataset.vwRating : undefined;

            this.displayReviewRating(container, rating);
        },

        clickBtnSubmit: function (e, button) {
            var form = this.form;

            form.setAttribute('target', '_self');

            if (form.old_action !== undefined) {
                form.setAttribute('action', form.old_action);
            }

            if (form.onsubmit.call(form, e)) {
                $cms.ui.disableButton(button);
                form.submit();
            }
        },

        doFormPreview: function (e) {
            var form = this.form,
                url = maintain_theme_in_link($cms.$PREVIEW_URL + $cms.$KEEP);

            if (do_form_preview(e, form, url)) {
                form.submit();
            }
        },

        submitFormComments: function (e) {
            var form = this.form,
                opts = this.params;

            if ((opts.moreUrl !== undefined) && (form.action === opts.moreUrl)) {
                return;
            }

            if (!check_field_for_blankness(form.elements.post, e)) {
                e.preventDefault();
                return;
            }

            if (opts.getEmail && !opts.emailOptional && !check_field_for_blankness(form.elements.email, e)) {
                e.preventDefault();
            }
        },

        moveToFullEditor: function (e) {
            var moreUrl = this.params.moreUrl,
                form = this.form;

            // Tell next screen what the stub to trim is
            if (form.elements['post'].default_substring_to_strip !== undefined) {
                if (form.elements['stub'] !== undefined) {
                    form.elements['stub'].value = form.elements['post'].default_substring_to_strip;
                } else {
                    if (moreUrl.indexOf('?') == -1) {
                        moreUrl += '?';
                    } else {
                        moreUrl += '&';
                    }
                    moreUrl += 'stub=' + encodeURIComponent(form.elements['post'].default_substring_to_strip);
                }
            }

            // Try and make post reply a GET parameter
            if (form.elements['parent_id'] !== undefined) {
                if (!moreUrl.includes('?')) {
                    moreUrl += '?';
                } else {
                    moreUrl += '&';
                }
                moreUrl += 'parent_id=' + encodeURIComponent(form.elements['parent_id'].value);
            }

            // Reset form target
            form.setAttribute('target', '_top');
            if (form.old_action !== undefined) form.old_action = form.getAttribute('action');
            form.setAttribute('action', moreUrl);

            // Handle threaded strip-on-focus
            if ((form.elements['post'].strip_on_focus !== undefined) && (form.elements['post'].value == form.elements['post'].strip_on_focus)) {
                form.elements['post'].value = '';
            }

            form.submit();
        },

        /* Set up a form to have its CAPTCHA checked upon submission using AJAX */
        addCaptchaChecking: function () {
            var form = this.form;
            form.old_submit = form.onsubmit;
            form.onsubmit = function () {
                form.elements['submit_button'].disabled = true;
                var url = '{$FIND_SCRIPT;,snippet}?snippet=captcha_wrong&name=' + encodeURIComponent(form.elements['captcha'].value);
                if (!do_ajax_field_test(url)) {
                    var image = document.getElementById('captcha_image');
                    if (!image) image = document.getElementById('captcha_frame');
                    image.src += '&'; // Force it to reload latest captcha
                    document.getElementById('submit_button').disabled = false;
                    return false;
                }
                form.elements['submit_button'].disabled = false;
                if (form.old_submit) {
                    return form.old_submit();
                }
                return true;
            };

            window.addEventListener('pageshow', function () {
                form.elements['captcha'].src += '&'; // Force it to reload latest captcha
            });
        }
    });

    $cms.extend($cms.templates, {
        ratingForm: function ratingForm(params) {
            var rating;

            if (params.error) {
                return;
            }

            for (var i = 0, len = params.allRatingCriteria; i < len; i++) {
                rating = params.allRatingCriteria[i];

                apply_rating_highlight_and_ajax_code((rating.likes === 1), rating.rating, rating.contentType, rating.id, rating.type, rating.rating, rating.contentUrl, rating.contentTitle, true);
            }
        },

        commentsWrapper: function (params) {
            if ((params.serializedOptions !== undefined) && (params.hash !== undefined)) {
                window.comments_serialized_options = params.serializedOptions;
                window.comments_hash = params.hash;
            }
        },

        commentAjaxHandler: function (params) {
            var urlStem = params.urlStem,
                wrapper = $cms.dom.id('comments_wrapper');

            replace_comments_form_with_ajax(params.options, params.hash, 'comments_form', 'comments_wrapper');

            if (wrapper) {
                internalise_ajax_block_wrapper_links(urlStem, wrapper, ['start_comments', 'max_comments'], {});
            }

            // Infinite scrolling hides the pagination when it comes into view, and auto-loads the next link, appending below the current results
            if (params.infiniteScroll) {
                var infinite_scrolling_comments_wrapper = function (event) {
                    internalise_infinite_scrolling(urlStem, wrapper);
                };

                $cms.dom.on(window, 'scroll', infinite_scrolling_comments_wrapper);
                $cms.dom.on(window, 'keydown', infinite_scrolling_block);
                $cms.dom.on(window, 'mousedown', infinite_scrolling_block_hold);
                $cms.dom.on(window, 'mousemove', function () {
                    infinite_scrolling_block_unhold(infinite_scrolling_comments_wrapper);
                });

                // ^ mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
                infinite_scrolling_comments_wrapper();
            }
        }
    });

    function force_reload_on_back() {
        $cms.dom.on(window, 'pageshow', function () {
            window.location.reload();
        });
    }

    /* Update a normal comments topic with AJAX replying */
    function replace_comments_form_with_ajax(options, hash, comments_form_id, comments_wrapper_id) {
        var comments_form = $cms.dom.id(comments_form_id);
        if (comments_form) {
            comments_form.old_onsubmit = comments_form.onsubmit;

            comments_form.onsubmit = function (event, is_preview) {
                is_preview = !!is_preview;

                if (is_preview) {
                    return true;
                }

                // Cancel the event from running
                if (event.cancelable) {
                    event.preventDefault();
                }

                if (!comments_form.old_onsubmit(event)) {
                    return false;
                }

                var comments_wrapper = $cms.dom.id(comments_wrapper_id);
                if (!comments_wrapper) {// No AJAX, as stuff missing from template
                    comments_form.submit();
                    return true;
                }

                var submit_button = $cms.dom.id('submit_button');
                if (submit_button) {
                    $cms.ui.disableButton(submit_button);
                }

                // Note what posts are shown now
                var known_posts = comments_wrapper.querySelectorAll('.post');
                var known_times = [];
                for (var i = 0; i < known_posts.length; i++) {
                    known_times.push(known_posts[i].className.replace(/^post /, ''));
                }

                // Fire off AJAX request
                var post = 'options=' + encodeURIComponent(options) + '&hash=' + encodeURIComponent(hash);
                var post_element = comments_form.elements['post'];
                var post_value = post_element.value;
                if (post_element.default_substring_to_strip !== undefined) // Strip off prefix if unchanged
                {
                    if (post_value.substring(0, post_element.default_substring_to_strip.length) == post_element.default_substring_to_strip)
                        post_value = post_value.substring(post_element.default_substring_to_strip.length, post_value.length);
                }
                for (var i = 0; i < comments_form.elements.length; i++) {
                    if ((comments_form.elements[i].name) && (comments_form.elements[i].name != 'post')) {
                        post += '&' + comments_form.elements[i].name + '=' + encodeURIComponent(clever_find_value(comments_form, comments_form.elements[i]));
                    }
                }
                post += '&post=' + encodeURIComponent(post_value);
                do_ajax_request('{$FIND_SCRIPT;,post_comment}' + keep_stub(true), function (ajax_result) {
                    if ((ajax_result.responseText != '') && (ajax_result.status != 500)) {
                        // Display
                        var old_action = comments_form.action;
                        $cms.dom.outerHtml(comments_wrapper, ajax_result.responseText);
                        comments_form = $cms.dom.id(comments_form_id);
                        old_action = comments_form.action = old_action; // AJAX will have mangled URL (as was not running in a page context), this will fix it back

                        // Scroll back to comment
                        window.setTimeout(function () {
                            var comments_wrapper = $cms.dom.id(comments_wrapper_id); // outerhtml set will have broken the reference
                            smooth_scroll(find_pos_y(comments_wrapper, true));
                        }, 0);

                        // Force reload on back button, as otherwise comment would be missing
                        force_reload_on_back();

                        // Collapse, so user can see what happening
                        var outer = $cms.dom.id('comments_posting_form_outer');
                        if (outer && outer.classList.contains('toggleable_tray')) {
                            $cms.toggleableTray(outer);
                        }

                        // Set fade for posts not shown before
                        var known_posts = comments_wrapper.querySelectorAll('.post');
                        for (var i = 0; i < known_posts.length; i++) {
                            if (!known_times.includes(known_posts[i].className.replace(/^post /, ''))) {
                                clear_transition_and_set_opacity(known_posts[i], 0.0);
                                fade_transition(known_posts[i], 100, 20, 5);
                            }
                        }

                        // And re-attach this code (got killed by $cms.dom.outerHtml)
                        replace_comments_form_with_ajax(options, hash);
                    } else { // Error: do a normal post so error can be seen
                        comments_form.submit();
                    }
                }, post);

                return false;
            };
        }
    }

    function apply_rating_highlight_and_ajax_code(likes, initial_rating, content_type, id, type, rating, content_url, content_title, initialisation_phase, visual_only) {
        rating = +rating || 0;
        visual_only = !!visual_only;

        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].forEach(function (number) {
            var bit = $cms.dom.id('rating_bar_' + number + '__' + content_type + '__' + type + '__' + id);
            if (!bit) {
                return;
            }
            bit.className = (likes ? (rating === number) : (rating >= number)) ? 'rating_star_highlight' : 'rating_star';

            if (!initialisation_phase) {
                return;
            }

            bit.onmouseover = function () {
                apply_rating_highlight_and_ajax_code(likes, initial_rating, content_type, id, type, number, content_url, content_title, false);
            };
            bit.onmouseout = function () {
                apply_rating_highlight_and_ajax_code(likes, initial_rating, content_type, id, type, initial_rating, content_url, content_title, false);
            };

            if (visual_only) {
                return;
            }

            bit.onclick = function (event) {
                event.preventDefault();

                // Find where the rating replacement will go
                var template = '';
                var replace_spot = bit;
                while (replace_spot !== null) {
                    replace_spot = replace_spot.parentNode;

                    if (replace_spot && replace_spot.className) {
                        if (replace_spot.classList.contains('RATING_BOX')) {
                            template = 'RATING_BOX';
                            break;
                        }
                        if (replace_spot.classList.contains('RATING_INLINE_STATIC')) {
                            template = 'RATING_INLINE_STATIC';
                            break;
                        }
                        if (replace_spot.classList.contains('RATING_INLINE_DYNAMIC')) {
                            template = 'RATING_INLINE_DYNAMIC';
                            break;
                        }
                    }
                }
                var _replace_spot = (template === '') ? bit.parentNode.parentNode.parentNode.parentNode : replace_spot;

                // Show loading animation
                $cms.dom.html(_replace_spot, '');
                var loading_image = document.createElement('img');
                loading_image.className = 'ajax_loading';
                loading_image.src = $cms.img('{$IMG;,loading}');
                loading_image.style.height = '12px';
                _replace_spot.appendChild(loading_image);

                // AJAX call
                var snippet_request = 'rating&type=' + encodeURIComponent(type) + '&id=' + encodeURIComponent(id) + '&content_type=' + encodeURIComponent(content_type) + '&template=' + encodeURIComponent(template) + '&content_url=' + encodeURIComponent(content_url) + '&content_title=' + encodeURIComponent(content_title);

                load_snippet(snippet_request, 'rating=' + encodeURIComponent(number), function (ajax_result) {
                    var message = ajax_result.responseText;
                    $cms.dom.outerHtml(_replace_spot, (template === '') ? ('<strong>' + message + '</strong>') : message);
                });

                return false;
            };
        });
    }
}(window.$cms));
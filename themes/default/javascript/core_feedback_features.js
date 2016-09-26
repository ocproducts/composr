(function ($, Composr) {
    'use strict';
    Composr.behaviors.coreFeedbackFeatures = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_feedback_features');
            }
        }
    };

    var CommentsPostingForm = Composr.View.extend({
        form: null,
        btnSubmit: null,
        initialize: function (v, options) {
            CommentsPostingForm.__super__.initialize.apply(this, arguments);
            this.form = this.$('form.js-form-comments');
            this.btnSubmit = this.$('.js-btn-submit-comments');

            set_up_comcode_autocomplete('post', Composr.is(options.wysiwyg));

            if (Composr.is(Composr.$CONFIG_OPTION.enablePreviews, Composr.$FORCE_PREVIEWS)) {
                this.btnSubmit.style.display = 'none';
            }

            if (Composr.is(options.useCaptcha)) {
                this.addCaptchaChecking();
            }

            if (Composr.is(options.type, options.id)) {
                this.initReviewRatings();
            }

            var captchaSpot = this.$('#captcha_spot');
            if (captchaSpot) {
                Composr.dom.html(captchaSpot, options.captcha);
            }
        },

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
            var reviewBars = Composr.dom.$$(container, '.js-img-review-bar');
            if (rating === undefined) {
                rating = container.querySelector('.js-inp-review-rating').value;
            }
            rating = +rating || 0;

            reviewBars.forEach(function (reviewBar) {
                var barRating = +reviewBar.dataset.vwRating || 0;

                if (barRating <= rating) { // Whether to highlight
                    reviewBar.classList.remove('rating_star');
                    reviewBar.classList.add('rating_star_highlight');
                } else {
                    reviewBar.classList.remove('rating_star_highlight');
                    reviewBar.classList.add('rating_star');
                }
            });
        },

        reviewBarClick: function (e, reviewBar) {
            var container = this.$closest(reviewBar, '.js-container-review-rating'),
                ratingInput = container.querySelector('.js-inp-review-rating'),
                rating = +reviewBar.dataset.vwRating || 0;

            ratingInput.value = rating;
            this.displayReviewRating(container, rating);
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
                disable_button_just_clicked(button);
                form.submit();
            }
        },

        doFormPreview: function (e) {
            var form = this.form,
                url = maintain_theme_in_link(Composr.$PREVIEW_URL + Composr.$KEEP);

            if (do_form_preview(e, form, url)) {
                form.submit();
            }
        },

        submitFormComments: function (e) {
            var form = this.form;

            if ((this.options.moreUrl !== undefined) && (form.action === this.options.moreUrl)) {
                return;
            }

            if (!check_field_for_blankness(form.elements.post, e)) {
                e.preventDefault();
                return;
            }

            if (Composr.is(this.options.getEmail) && Composr.not(this.options.emailOptional) && !check_field_for_blankness(form.elements.email, e)) {
                e.preventDefault();
            }
        },

        moveToFullEditor: function (e) {
            var moreUrl = this.options.moreUrl,
                form = this.form;

            // Tell next screen what the stub to trim is
            if (typeof form.elements['post'].default_substring_to_strip != 'undefined') {
                if (typeof form.elements['stub'] != 'undefined') {
                    form.elements['stub'].value = form.elements['post'].default_substring_to_strip;
                } else {
                    if (moreUrl.indexOf('?') == -1) {
                        moreUrl += '?';
                    } else {
                        moreUrl += '&';
                    }
                    moreUrl += 'stub=' + window.encodeURIComponent(form.elements['post'].default_substring_to_strip);
                }
            }

            // Try and make post reply a GET parameter
            if (typeof form.elements['parent_id'] != 'undefined') {
                if (moreUrl.indexOf('?') == -1) {
                    moreUrl += '?';
                } else {
                    moreUrl += '&';
                }
                moreUrl += 'parent_id=' + encodeURIComponent(form.elements['parent_id'].value);
            }

            // Reset form target
            form.setAttribute('target', '_top');
            if (typeof form.old_action != 'undefined') form.old_action = form.getAttribute('action');
            form.setAttribute('action', moreUrl);

            // Handle threaded strip-on-focus
            if ((typeof form.elements['post'].strip_on_focus != 'undefined') && (form.elements['post'].value == form.elements['post'].strip_on_focus))
                form.elements['post'].value = '';

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
                    form.elements['captcha'].src += '&'; // Force it to reload latest captcha
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

    // Expose the views
    Composr.views.CommentsPostingForm = CommentsPostingForm;

    Composr.templates.coreFeedbackFeatures = {
        ratingForm: function ratingForm(options) {
            var rating;

            if (Composr.is(options.error)) {
                return;
            }

            if (Composr.is(Composr.$JS_ON)) {
                for (var i = 0, len = options.allRatingCriteria; i < len; i++) {
                    rating = options.allRatingCriteria[i];

                    apply_rating_highlight_and_ajax_code(rating.likes === '1', rating.rating, rating.contentType, rating.id, rating.type, rating.rating, rating.contentUrl, rating.contentTitle, true);
                }
            }
        },

        commentsWrapper: function commentsWrapper(options) {
            if ((typeof options.serializedOptions !== 'undefined') && (typeof options.hash !== 'undefined')) {
                window.comments_serialized_options = options.serializedOptions;
                window.comments_hash = options.hash;
            }
        },

        commentAjaxHandler: function commentAjaxHandler(options) {
            var urlStem = options.urlStem,
                wrapper = document.getElementById('comments_wrapper');

            replace_comments_form_with_ajax(options.options, options.hash, 'comments_form', 'comments_wrapper');

            if (wrapper) {
                internalise_ajax_block_wrapper_links(urlStem, wrapper, ['start_comments', 'max_comments'], {});
            }

            // Infinite scrolling hides the pagination when it comes into view, and auto-loads the next link, appending below the current results
            if (options.infiniteScroll === '1') {
                var infinite_scrolling_comments_wrapper = function (event) {
                    var wrapper = document.getElementById('comments_wrapper');
                    internalise_infinite_scrolling(urlStem, wrapper);
                };
                window.addEventListener('scroll', infinite_scrolling_comments_wrapper);
                window.addEventListener('keydown', infinite_scrolling_block);
                window.addEventListener('mousedown', infinite_scrolling_block_hold);
                window.addEventListener('mousemove', function () {
                    infinite_scrolling_block_unhold(infinite_scrolling_comments_wrapper);
                });
                // ^ mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
                infinite_scrolling_comments_wrapper();
            }
        }
    };

    function force_reload_on_back() {
        window.addEventListener('pageshow', function () {
            window.location.reload();
        });
    }

    /* Update a normal comments topic with AJAX replying */
    function replace_comments_form_with_ajax(options, hash, comments_form_id, comments_wrapper_id) {
        var comments_form = document.getElementById(comments_form_id);
        if (comments_form) {
            comments_form.old_onsubmit = comments_form.onsubmit;

            comments_form.onsubmit = function (event, is_preview) {
                if ((typeof is_preview != 'undefined') && (is_preview)) return true;

                // Cancel the event from running
                if (event.cancelable) event.preventDefault();

                if (!comments_form.old_onsubmit(event)) return false;

                var comments_wrapper = document.getElementById(comments_wrapper_id);
                if (!comments_wrapper) // No AJAX, as stuff missing from template
                {
                    comments_form.submit();
                    return true;
                }

                var submit_button = document.getElementById('submit_button');
                if (submit_button) disable_button_just_clicked(submit_button);

                // Note what posts are shown now
                var known_posts = comments_wrapper.querySelectorAll('.post');
                var known_times = [];
                for (var i = 0; i < known_posts.length; i++) {
                    known_times.push(known_posts[i].className.replace(/^post /, ''));
                }

                // Fire off AJAX request
                var post = 'options=' + window.encodeURIComponent(options) + '&hash=' + window.encodeURIComponent(hash);
                var post_element = comments_form.elements['post'];
                var post_value = post_element.value;
                if (typeof post_element.default_substring_to_strip != 'undefined') // Strip off prefix if unchanged
                {
                    if (post_value.substring(0, post_element.default_substring_to_strip.length) == post_element.default_substring_to_strip)
                        post_value = post_value.substring(post_element.default_substring_to_strip.length, post_value.length);
                }
                for (var i = 0; i < comments_form.elements.length; i++) {
                    if ((comments_form.elements[i].name) && (comments_form.elements[i].name != 'post'))
                        post += '&' + comments_form.elements[i].name + '=' + window.encodeURIComponent(clever_find_value(comments_form, comments_form.elements[i]));
                }
                post += '&post=' + window.encodeURIComponent(post_value);
                do_ajax_request('{$FIND_SCRIPT;,post_comment}' + keep_stub(true), function (ajax_result) {
                    if ((ajax_result.responseText != '') && (ajax_result.status != 500)) {
                        // Display
                        var old_action = comments_form.action;
                        Composr.dom.outerHtml(comments_wrapper, ajax_result.responseText);
                        comments_form = document.getElementById(comments_form_id);
                        old_action = comments_form.action = old_action; // AJAX will have mangled URL (as was not running in a page context), this will fix it back

                        // Scroll back to comment
                        window.setTimeout(function () {
                            var comments_wrapper = document.getElementById(comments_wrapper_id); // outerhtml set will have broken the reference
                            smooth_scroll(find_pos_y(comments_wrapper, true));
                        }, 0);

                        // Force reload on back button, as otherwise comment would be missing
                        force_reload_on_back();

                        // Collapse, so user can see what happening
                        var outer = document.getElementById('comments_posting_form_outer');
                        if (outer && outer.className.indexOf('toggleable_tray') != -1)
                            toggleable_tray('comments_posting_form_outer');

                        // Set fade for posts not shown before
                        var known_posts = comments_wrapper.querySelectorAll('.post');
                        for (var i = 0; i < known_posts.length; i++) {
                            if (known_times.indexOf(known_posts[i].className.replace(/^post /, '')) == -1) {
                                clear_transition_and_set_opacity(known_posts[i], 0.0);
                                fade_transition(known_posts[i], 100, 20, 5);
                            }
                        }

                        // And re-attach this code (got killed by Composr.dom.outerHtml)
                        replace_comments_form_with_ajax(options, hash);
                    } else // Error: do a normal post so error can be seen
                    {
                        comments_form.submit();
                    }
                }, post);

                return false;
            };
        }
    }

    function apply_rating_highlight_and_ajax_code(likes, initial_rating, content_type, id, type, rating, content_url, content_title, initialisation_phase, visual_only) {
        if (typeof visual_only == 'undefined') visual_only = false;

        var i, bit;
        for (i = 1; i <= 10; i++) {
            bit = document.getElementById('rating_bar_' + i + '__' + content_type + '__' + type + '__' + id);
            if (!bit) continue;

            if (likes) {
                bit.className = (rating == i) ? 'rating_star_highlight' : 'rating_star';
            } else {
                bit.className = (rating >= i) ? 'rating_star_highlight' : 'rating_star';
            }

            if (initialisation_phase) {
                bit.onmouseover = function (i) {
                    return function () {
                        apply_rating_highlight_and_ajax_code(likes, initial_rating, content_type, id, type, i, content_url, content_title, false);
                    }
                }(i);
                bit.onmouseout = function (i) {
                    return function () {
                        apply_rating_highlight_and_ajax_code(likes, initial_rating, content_type, id, type, initial_rating, content_url, content_title, false);
                    }
                }(i);

                if (!visual_only) bit.onclick = function (i) {
                    return function (event) {
                        if (event.cancelable) event.preventDefault();

                        // Find where the rating replacement will go
                        var template = '';
                        var bit = document.getElementById('rating_bar_' + i + '__' + content_type + '__' + type + '__' + id);
                        var replace_spot = bit;
                        while (replace_spot !== null) {
                            replace_spot = replace_spot.parentNode;
                            if (replace_spot !== null && replace_spot.className) {
                                if (replace_spot.className.match(/(^| )RATING_BOX( |$)/)) {
                                    template = 'RATING_BOX';
                                    break;
                                }
                                if (replace_spot.className.match(/(^| )RATING_INLINE_STATIC( |$)/)) {
                                    template = 'RATING_INLINE_STATIC';
                                    break;
                                }
                                if (replace_spot.className.match(/(^| )RATING_INLINE_DYNAMIC( |$)/)) {
                                    template = 'RATING_INLINE_DYNAMIC';
                                    break;
                                }
                            }
                        }
                        var _replace_spot = (template == '') ? bit.parentNode.parentNode.parentNode.parentNode : replace_spot;

                        // Show loading animation
                        Composr.dom.html(_replace_spot, '');
                        var loading_image = document.createElement('img');
                        loading_image.className = 'ajax_loading';
                        loading_image.src = Composr.url('{$IMG;,loading}');
                        loading_image.style.height = '12px';
                        _replace_spot.appendChild(loading_image);

                        // AJAX call
                        var snippet_request = 'rating&type=' + window.encodeURIComponent(type) + '&id=' + window.encodeURIComponent(id) + '&content_type=' + window.encodeURIComponent(content_type) + '&template=' + window.encodeURIComponent(template) + '&content_url=' + window.encodeURIComponent(content_url) + '&content_title=' + window.encodeURIComponent(content_title);
                        var message = load_snippet(snippet_request, 'rating=' + window.encodeURIComponent(i), function (ajax_result) {
                            var message = ajax_result.responseText;
                            Composr.dom.outerHtml(_replace_spot, (template == '') ? ('<strong>' + message + '</strong>') : message);
                        });

                        return false;
                    }
                }(i);
            }
        }
    }


})(window.jQuery || window.Zepto, window.Composr);
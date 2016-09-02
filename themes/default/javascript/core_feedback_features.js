(function ($, Composr) {
    'use strict';
    Composr.behaviors.coreFeedbackFeatures = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core_feedback_features');
                Composr.initializeTemplates(context, 'core_feedback_features');
            }
        }
    };

    var CommentsPostingForm = Composr.View.extend({
        initialize: function (viewOptions, options) {
            this.options = options || {};
            this.form = this.el.querySelector('.js-form-comments');
            this.setup();
        },

        events: {
            'click .js-btn-full-editor': 'moveToFullEditor',

            'click .js-btn-submit-comments': function (e) {
                var form = this.form, button = e.currentTarget;

                form.setAttribute('target', '_self');

                if (form.old_action !== undefined) {
                    form.setAttribute('action', form.old_action);
                }

                if (form.onsubmit.call(form, event)) {
                    disable_button_just_clicked(button);
                    form.submit();
                }
            },

            'submit .js-form-comments': function (e) {
                var form = e.currentTarget;

                if ((this.options.moreUrl !== undefined) && (form.action === this.options.moreUrl)) {
                    return;
                }

                if (!check_field_for_blankness(form.elements.post, e)) {
                    e.preventDefault();
                    return;
                }

                if (Composr.isTruthy(this.options.getEmail) && Composr.isFalsy(this.options.emailOptional) && !check_field_for_blankness(form.elements.email, e)) {
                    e.preventDefault();
                }
            }
        },

        setup: function (options) {
            options = this.options;

            set_up_comcode_autocomplete('post', Composr.isTruthy(options.wysiwyg));

            if (Composr.isTruthy(options.forcePreviews)) {
                document.getElementById('submit_button').style.display = 'none';
            }

            if (Composr.areDefined(options.reviewRatingCriteria, options.type, options.id) && Composr.$JS_ON) {
                var i, reviewTitleId, func,
                    id = Composr.filters.identifier(options.id),
                    type = options.type,
                    typeId = Composr.filters.identifier(type);

                for (i = 0; i < options.reviewRatingCriteria; i++) {
                    reviewTitleId = Composr.filters.identifier(options.reviewRatingCriteria[i].reviewTitle);
                    func = 'new_review_highlight__' + type + ' __' + reviewTitleId + '__' + id;

                    window[func] = (function (func, reviewTitleId) {
                        return function (review, first_time) {
                            var j, bit;
                            for (j = 1; j <= 5; j++) {
                                bit = document.getElementById('review_bar_' + j + '__' + typeId + '__' + reviewTitleId + '__' + id);
                                bit.className = ((review != 0) && (review / 2 >= j)) ? 'rating_star_highlight' : 'rating_star';
                                if (first_time) bit.onmouseover = function (i) {
                                    return function () {
                                        window[func](i * 2, false);
                                    }
                                }(j);
                                if (first_time) bit.onmouseout = function (i) {
                                    return function () {
                                        window[func](window.parseInt(document.getElementById('review_rating__' + typeId + '__' + reviewTitleId + '__' + id).value), false);
                                    }
                                }(j);
                                if (first_time) bit.onclick = function (i) {
                                    return function () {
                                        document.getElementById('review_rating__' + typeId + '__' + reviewTitleId + '__' + id).value = i * 2;
                                    }
                                }(j);
                            }
                        }
                    }(func, reviewTitleId));

                    window[func](0, true);
                }
            }
        },

        moveToFullEditor: function (e) {
            var button = e.currentTarget,
                moreUrl = options.moreUrl,
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
                moreUrl += 'parent_id=' + window.encodeURIComponent(form.elements['parent_id'].value);
            }

            // Reset form target
            form.setAttribute('target', '_top');
            if (typeof form.old_action != 'undefined') form.old_action = form.getAttribute('action');
            form.setAttribute('action', moreUrl);

            // Handle threaded strip-on-focus
            if ((typeof form.elements['post'].strip_on_focus != 'undefined') && (form.elements['post'].value == form.elements['post'].strip_on_focus))
                form.elements['post'].value = '';

            form.submit();
        }
    });

    // Expose the views
    Composr.views.coreFeedbackFeatures = {
        CommentsPostingForm: CommentsPostingForm
    };

    Composr.templates.coreFeedbackFeatures = {
        ratingForm: function ratingForm(options) {
            var rating;

            if (Composr.isTruthy(options.error)) {
                return;
            }

            if (Composr.isTruthy(Composr.$JS_ON)) {
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

})(window.jQuery || window.Zepto, window.Composr);
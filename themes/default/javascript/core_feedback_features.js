(function ($cms) {
    'use strict';

    $cms.views.CommentsPostingForm = CommentsPostingForm;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function CommentsPostingForm(params) {
        CommentsPostingForm.base(this, 'constructor', arguments);

        this.form = this.$('form.js-form-comments');
        this.btnSubmit = this.$('.js-btn-submit-comments');

        $cms.requireJavascript('jquery_autocomplete').then(function () {
            setUpComcodeAutocomplete('post', !!params.wysiwyg);
        });

        if ($cms.$CONFIG_OPTION('enable_previews') && $cms.$FORCE_PREVIEWS()) {
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

    $cms.inherits(CommentsPostingForm, $cms.View, /**@lends CommentsPostingForm#*/{
        events: function () {
            return {
                'click .js-btn-full-editor': 'moveToFullEditor',
                'click .js-btn-submit-comments': 'clickBtnSubmit',
                'click .js-click-do-form-preview': 'doFormPreview',
                'submit .js-form-comments': 'submitFormComments',

                'click .js-img-review-bar': 'reviewBarClick',
                'mouseover .js-img-review-bar': 'reviewBarHover',
                'mouseout .js-img-review-bar': 'reviewBarHover',

                'click .js-click-play-self-audio-link': 'playSelfAudioLink',

                'focus .js-focus-textarea-post': 'focusTexareaPost',

                'click .js-click-open-site-emoticon-chooser-window': 'openEmoticonChooserWindow'
            };
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

        playSelfAudioLink: function (e, link) {
            e.preventDefault();
            $cms.playSelfAudioLink(link);
        },

        focusTexareaPost: function (e, textarea) {
            if (((textarea.value.replace(/\s/g, '') === '{!POST_WARNING;^}'.replace(/\s/g, '')) && ('{!POST_WARNING;^}' !== '')) || ((textarea.strip_on_focus != null) && (textarea.value == textarea.strip_on_focus))) {
                textarea.value = '';
            }

            textarea.classList.remove('field_input_non_filled');
            textarea.classList.add('field_input_filled');
        },

        openEmoticonChooserWindow: function () {
            $cms.ui.open($cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,emoticons}?field_name=post' + $cms.$KEEP()), 'site_emoticon_chooser', 'width=300,height=320,status=no,resizable=yes,scrollbars=no');
        },

        clickBtnSubmit: function (e, button) {
            var form = this.form;

            form.setAttribute('target', '_self');

            if (form.old_action !== undefined) {
                form.setAttribute('action', form.old_action);
            }

            if (form.onsubmit && form.onsubmit.call(form, e)) {
                $cms.ui.disableButton(button);
                form.submit();
            }
        },

        doFormPreview: function (e) {
            var form = this.form,
                url = $cms.maintainThemeInLink($cms.$PREVIEW_URL() + $cms.$KEEP());

            if ($cms.form.doFormPreview(e, form, url)) {
                form.submit();
            }
        },

        submitFormComments: function (e) {
            var form = this.form,
                opts = this.params;

            if ((opts.moreUrl !== undefined) && (form.action === opts.moreUrl)) {
                return;
            }

            if (!$cms.form.checkFieldForBlankness(form.elements.post, e)) {
                e.preventDefault();
                return;
            }

            if (opts.getEmail && !opts.emailOptional && !$cms.form.checkFieldForBlankness(form.elements.email, e)) {
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
            var form = this.form,
                submitBtn = form.elements['submit_button'];
            form.addEventListener('submit', function submitCheck(e) {
                submitBtn.disabled = true;
                var url = '{$FIND_SCRIPT;,snippet}?snippet=captcha_wrong&name=' + encodeURIComponent(form.elements['captcha'].value);
                e.preventDefault();
                $cms.form.doAjaxFieldTest(url).then(function (valid) {
                    if (valid) {
                        form.removeEventListener('submit', submitCheck);
                        form.submit();
                    } else {
                        var image = document.getElementById('captcha_image');
                        if (!image) {
                            image = document.getElementById('captcha_frame');
                        }
                        image.src += '&'; // Force it to reload latest captcha
                        submitBtn.disabled = false;
                    }
                });
            });

            window.addEventListener('pageshow', function () {
                form.elements['captcha'].src += '&'; // Force it to reload latest captcha
            });
        }
    });

    $cms.extend($cms.templates, /**@lends $cms.templates*/{
        ratingForm: function ratingForm(params) {
            var rating;

            if (params.error) {
                return;
            }

            for (var i = 0, len = params.allRatingCriteria; i < len; i++) {
                rating = objVal(params.allRatingCriteria[i]);

                applyRatingHighlightAndAjaxCode((rating.likes === 1), rating.rating, rating.contentType, rating.id, rating.type, rating.rating, rating.contentUrl, rating.contentTitle, true);
            }
        },

        commentsWrapper: function (params, container) {
            if ((params.serializedOptions !== undefined) && (params.hash !== undefined)) {
                window.comments_serialized_options = params.serializedOptions;
                window.comments_hash = params.hash;
            }

            $cms.dom.on(container, 'change', '.js-change-select-submit-form', function (e, select) {
                select.form.submit();
            });
        },

        commentAjaxHandler: function (params) {
            var urlStem = params.urlStem,
                wrapper = $cms.dom.$id('comments_wrapper');

            replaceCommentsFormWithAjax(params.options, params.hash, 'comments_form', 'comments_wrapper');

            if (wrapper) {
                internaliseAjaxBlockWrapperLinks(urlStem, wrapper, ['start_comments', 'max_comments'], {});
            }

            // Infinite scrolling hides the pagination when it comes into view, and auto-loads the next link, appending below the current results
            if (params.infiniteScroll) {
                var infiniteScrollingCommentsWrapper = function (event) {
                    internaliseInfiniteScrolling(urlStem, wrapper);
                };

                $cms.dom.on(window, 'scroll', infiniteScrollingCommentsWrapper);
                $cms.dom.on(window, 'keydown', infiniteScrollingBlock);
                $cms.dom.on(window, 'mousedown', infiniteScrollingBlockHold);
                $cms.dom.on(window, 'mousemove', function () {
                    infiniteScrollingBlockUnhold(infiniteScrollingCommentsWrapper);
                });

                // ^ mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
                infiniteScrollingCommentsWrapper();
            }
        }
    });

    function forceReloadOnBack() {
        $cms.dom.on(window, 'pageshow', function () {
            window.location.reload();
        });
    }

    /* Update a normal comments topic with AJAX replying */
    function replaceCommentsFormWithAjax(options, hash, commentsFormId, commentsWrapperId) {
        var commentsForm = $cms.dom.$id(commentsFormId);
        if (commentsForm) {
            commentsForm.old_onsubmit = commentsForm.onsubmit;

            commentsForm.onsubmit = function (event, isPreview) {
                isPreview = !!isPreview;

                if (isPreview) {
                    return true;
                }

                // Cancel the event from running
                if (event.cancelable) {
                    event.preventDefault();
                }

                if (!commentsForm.old_onsubmit(event)) {
                    return false;
                }

                var commentsWrapper = $cms.dom.$id(commentsWrapperId);
                if (!commentsWrapper) {// No AJAX, as stuff missing from template
                    commentsForm.submit();
                    return true;
                }

                var submitButton = $cms.dom.$id('submit_button');
                if (submitButton) {
                    $cms.ui.disableButton(submitButton);
                }

                // Note what posts are shown now
                var knownPosts = commentsWrapper.querySelectorAll('.post');
                var knownTimes = [];
                for (var i = 0; i < knownPosts.length; i++) {
                    knownTimes.push(knownPosts[i].className.replace(/^post /, ''));
                }

                // Fire off AJAX request
                var post = 'options=' + encodeURIComponent(options) + '&hash=' + encodeURIComponent(hash);
                var postElement = commentsForm.elements['post'];
                var postValue = postElement.value;
                if (postElement.default_substring_to_strip !== undefined) // Strip off prefix if unchanged
                {
                    if (postValue.substring(0, postElement.default_substring_to_strip.length) == postElement.default_substring_to_strip)
                        postValue = postValue.substring(postElement.default_substring_to_strip.length, postValue.length);
                }
                for (var i = 0; i < commentsForm.elements.length; i++) {
                    if ((commentsForm.elements[i].name) && (commentsForm.elements[i].name != 'post')) {
                        post += '&' + commentsForm.elements[i].name + '=' + encodeURIComponent($cms.form.cleverFindValue(commentsForm, commentsForm.elements[i]));
                    }
                }
                post += '&post=' + encodeURIComponent(postValue);
                $cms.doAjaxRequest('{$FIND_SCRIPT;,post_comment}' + $cms.keepStub(true), function (ajaxResult) {
                    if ((ajaxResult.responseText != '') && (ajaxResult.status != 500)) {
                        // Display
                        var oldAction = commentsForm.action;
                        $cms.dom.outerHtml(commentsWrapper, ajaxResult.responseText);
                        commentsForm = $cms.dom.$id(commentsFormId);
                        oldAction = commentsForm.action = oldAction; // AJAX will have mangled URL (as was not running in a page context), this will fix it back

                        // Scroll back to comment
                        window.setTimeout(function () {
                            var commentsWrapper = $cms.dom.$id(commentsWrapperId); // outerhtml set will have broken the reference
                            $cms.dom.smoothScroll($cms.dom.findPosY(commentsWrapper, true));
                        }, 0);

                        // Force reload on back button, as otherwise comment would be missing
                        forceReloadOnBack();

                        // Collapse, so user can see what happening
                        var outer = $cms.dom.$id('comments_posting_form_outer');
                        if (outer && outer.classList.contains('toggleable_tray')) {
                            $cms.toggleableTray(outer);
                        }

                        // Set fade for posts not shown before
                        var knownPosts = commentsWrapper.querySelectorAll('.post');
                        for (var i = 0; i < knownPosts.length; i++) {
                            if (!knownTimes.includes(knownPosts[i].className.replace(/^post /, ''))) {
                                $cms.dom.clearTransitionAndSetOpacity(knownPosts[i], 0.0);
                                $cms.dom.fadeTransition(knownPosts[i], 100, 20, 5);
                            }
                        }

                        // And re-attach this code (got killed by $cms.dom.outerHtml)
                        replaceCommentsFormWithAjax(options, hash);
                    } else { // Error: do a normal post so error can be seen
                        commentsForm.submit();
                    }
                }, post);

                return false;
            };
        }
    }

    function applyRatingHighlightAndAjaxCode(likes, initialRating, contentType, id, type, rating, contentUrl, contentTitle, initialisationPhase, visualOnly) {
        rating = +rating || 0;
        visualOnly = !!visualOnly;

        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].forEach(function (number) {
            var bit = $cms.dom.$id('rating_bar_' + number + '__' + contentType + '__' + type + '__' + id);
            if (!bit) {
                return;
            }
            bit.className = (likes ? (rating === number) : (rating >= number)) ? 'rating_star_highlight' : 'rating_star';

            if (!initialisationPhase) {
                return;
            }

            bit.addEventListener('mouseover', function () {
                applyRatingHighlightAndAjaxCode(likes, initialRating, contentType, id, type, number, contentUrl, contentTitle, false);
            });
            bit.addEventListener('mouseout', function () {
                applyRatingHighlightAndAjaxCode(likes, initialRating, contentType, id, type, initialRating, contentUrl, contentTitle, false);
            });

            if (visualOnly) {
                return;
            }

            bit.addEventListener('click', function (event) {
                event.preventDefault();

                // Find where the rating replacement will go
                var template = '';
                var replaceSpot = bit;
                while (replaceSpot !== null) {
                    replaceSpot = replaceSpot.parentNode;

                    if (replaceSpot && replaceSpot.className) {
                        if (replaceSpot.classList.contains('RATING_BOX')) {
                            template = 'RATING_BOX';
                            break;
                        }
                        if (replaceSpot.classList.contains('RATING_INLINE_STATIC')) {
                            template = 'RATING_INLINE_STATIC';
                            break;
                        }
                        if (replaceSpot.classList.contains('RATING_INLINE_DYNAMIC')) {
                            template = 'RATING_INLINE_DYNAMIC';
                            break;
                        }
                    }
                }
                var _replaceSpot = (template === '') ? bit.parentNode.parentNode.parentNode.parentNode : replaceSpot;

                // Show loading animation
                $cms.dom.html(_replaceSpot, '');
                var loadingImage = document.createElement('img');
                loadingImage.className = 'ajax_loading';
                loadingImage.src = $cms.img('{$IMG;,loading}');
                loadingImage.style.height = '12px';
                _replaceSpot.appendChild(loadingImage);

                // AJAX call
                var snippetRequest = 'rating&type=' + encodeURIComponent(type) + '&id=' + encodeURIComponent(id) + '&content_type=' + encodeURIComponent(contentType) + '&template=' + encodeURIComponent(template) + '&content_url=' + encodeURIComponent(contentUrl) + '&content_title=' + encodeURIComponent(contentTitle);

                $cms.loadSnippet(snippetRequest, 'rating=' + encodeURIComponent(number), true).then(function (ajaxResult) {
                    var message = ajaxResult.responseText;
                    $cms.dom.outerHtml(_replaceSpot, (template === '') ? ('<strong>' + message + '</strong>') : message);
                });

                return false;
            });
        });
    }
}(window.$cms));
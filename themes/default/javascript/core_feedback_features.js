(function ($cms, $util, $dom) {
    'use strict';

    $cms.views.CommentsPostingForm = CommentsPostingForm;
    /**
     * @memberof $cms.views
     * @class $cms.views.CommentsPostingForm
     * @extends $cms.View
     */
    function CommentsPostingForm(params) {
        CommentsPostingForm.base(this, 'constructor', arguments);

        this.form = this.$('form.js-form-comments');
        this.btnSubmit = this.$('.js-btn-submit-comments');

        $cms.requireJavascript(['jquery', 'jquery_autocomplete']).then(function () {
            window.$jqueryAutocomplete.setUpComcodeAutocomplete('post', Boolean(params.wysiwyg));
        });

        if ($cms.configOption('enable_previews') && $cms.isForcePreviews()) {
            this.btnSubmit.style.display = 'none';
        }

        if (params.useCaptcha && ('{$CONFIG_OPTION;,recaptcha_site_key}' === '')) {
            this.addCaptchaChecking();
        }

        if (params.type && params.id) {
            this.initReviewRatings();
        }

        var captchaSpot = this.$('#captcha_spot');
        if (captchaSpot) {
            $dom.html(captchaSpot, params.captcha);
        }
    }

    $util.inherits(CommentsPostingForm, $cms.View, /**@lends $cms.views.CommentsPostingForm#*/{
        events: function () {
            return {
                'click .js-btn-full-editor': 'moveToFullEditor',
                'click .js-btn-submit-comments': 'clickBtnSubmit',
                'click .js-click-do-form-preview': 'doPostingFormPreview',
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
            var reviewBars = $dom.$$(container, '.js-img-review-bar');
            if (rating === undefined) {
                rating = $dom.$(container, '.js-inp-review-rating').value;
            }
            rating = +rating || 0;

            reviewBars.forEach(function (reviewBar) {
                var barRating = +reviewBar.dataset.vwRating || 0,
                    shouldHighlight = barRating <= rating; // Whether to highlight this bar

                reviewBar.classList.toggle('rating-star-highlight', shouldHighlight);
                reviewBar.classList.toggle('rating-star', !shouldHighlight);
            });
        },

        reviewBarClick: function (e, reviewBar) {
            var container = this.$closest(reviewBar, '.js-container-review-rating'),
                ratingInput = container.querySelector('.js-inp-review-rating');

            ratingInput.value = Number(reviewBar.dataset.vwRating) || 0;
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
            if (((textarea.value.replace(/\s/g, '') === '{!POST_WARNING;^}'.replace(/\s/g, '')) && ('{!POST_WARNING;^}' !== '')) || ((textarea.stripOnFocus != null) && (textarea.value == textarea.stripOnFocus))) {
                textarea.value = '';
            }

            textarea.classList.remove('field-input-non-filled');
            textarea.classList.add('field-input-filled');
        },

        openEmoticonChooserWindow: function () {
            $cms.ui.open($cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,emoticons}?field_name=post' + $cms.keep()), 'site_emoticon_chooser', 'width=300,height=320,status=no,resizable=yes,scrollbars=no');
        },

        clickBtnSubmit: function (e, button) {
            var form = button.form;

            form.setAttribute('target', '_self');

            // if (form.oldAction !== undefined) {
            //     form.setAttribute('action', form.oldAction);
            // }
            //
            // if ($dom.trigger(form, 'submit') !== false) {
            //     $cms.ui.disableButton(button);
            //     form.submit();
            // }
            
            $cms.form.doFormSubmit(form);
        },

        doPostingFormPreview: function (e, btn) {
            var form = btn.form,
                url = $cms.maintainThemeInLink($cms.getPreviewUrl() + $cms.keep());
            
            $cms.form.doFormPreview(form, url);
        },

        submitFormComments: function (e) {
            var form = this.form,
                params = this.params;

            if ((params.moreUrl !== undefined) && (form.action === params.moreUrl)) {
                return;
            }

            if (!$cms.form.checkFieldForBlankness(form.elements.post)) {
                e.preventDefault();
                return;
            }

            if (params.getName && !$cms.form.checkFieldForBlankness(form.elements['poster_name_if_guest'])) {
                e.preventDefault();
                return;
            }

            if (params.getTitle && !params.titleOptional && !$cms.form.checkFieldForBlankness(form.elements.title)) {
                e.preventDefault();
                return;
            }

            if (params.getEmail && !params.emailOptional && !$cms.form.checkFieldForBlankness(form.elements.email)) {
                e.preventDefault();
                return;
            }

            if (params.analyticEventCategory) {
                e.preventDefault();
                $cms.gaTrack(null, params.analyticEventCategory, null, function () {
                    $dom.submit(form);
                });
            }
        },

        moveToFullEditor: function () {
            var moreUrl = this.params.moreUrl,
                form = this.form;

            // Tell next screen what the stub to trim is
            if (form.elements['post'].defaultSubstringToStrip !== undefined) {
                if (form.elements['stub'] !== undefined) {
                    form.elements['stub'].value = form.elements['post'].defaultSubstringToStrip;
                } else {
                    if (moreUrl.includes('?')) {
                        moreUrl += '&';
                    } else {
                        moreUrl += '?';
                    }
                    moreUrl += 'stub=' + encodeURIComponent(form.elements['post'].defaultSubstringToStrip);
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
            if (form.oldAction !== undefined) {
                form.oldAction = form.getAttribute('action');
            }
            form.setAttribute('action', moreUrl);

            // Handle threaded strip-on-focus
            if ((form.elements['post'].stripOnFocus !== undefined) && (form.elements['post'].value === form.elements['post'].stripOnFocus)) {
                form.elements['post'].value = '';
            }

            $dom.submit(form);
        },

        /* Set up a form to have its CAPTCHA checked upon submission using AJAX */
        addCaptchaChecking: function () {
            var form = this.form,
                submitBtn = form.elements['submit_button'],
                validValue;
            
            form.addEventListener('submit', function submitCheck(e) {
                var value = form.elements['captcha'].value;
                
                if (value === validValue) {
                    return;
                }
                
                submitBtn.disabled = true;
                var url = '{$FIND_SCRIPT;,snippet}?snippet=captcha_wrong&name=' + encodeURIComponent(value);
                e.preventDefault();
                $cms.form.doAjaxFieldTest(url).then(function (valid) {
                    if (valid) {
                        validValue = value;
                        $dom.submit(form);
                    } else {
                        var image = document.getElementById('captcha_image');
                        if (!image) {
                            image = document.getElementById('captcha-frame');
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

    $cms.templates.ratingForm = function ratingForm(params) {
        var rating;

        if (params.error) {
            return;
        }

        for (var i = 0, len = params.allRatingCriteria; i < len; i++) {
            rating = objVal(params.allRatingCriteria[i]);

            applyRatingHighlightAndAjaxCode((rating.likes === 1), rating.rating, rating.contentType, rating.id, rating.type, rating.rating, rating.contentUrl, rating.contentTitle, true);
        }
    };

    $cms.templates.commentsWrapper = function (params, container) {
        if ((params.serializedOptions !== undefined) && (params.hash !== undefined)) {
            window.commentsSerializedOptions = params.serializedOptions;
            window.commentsHash = params.hash;
        }

        $dom.on(container, 'change', '.js-change-select-submit-form', function (e, select) {
            $dom.submit(select.form);
        });
    };

    $cms.templates.commentAjaxHandler = function (params) {
        var urlStem = params.urlStem,
            wrapper = $dom.$id('comments_wrapper');

        replaceCommentsFormWithAjax(params.options, params.hash, 'comments-form', 'comments_wrapper');

        if (wrapper) {
            $dom.internaliseAjaxBlockWrapperLinks(urlStem, wrapper, ['^start_comments$', '^max_comments$'], {});
        }

        // Infinite scrolling hides the pagination when it comes into view, and auto-loads the next link, appending below the current results
        if (params.infiniteScroll) {
            var infiniteScrollingCommentsWrapper = function (event) {
                $dom.internaliseInfiniteScrolling(urlStem, wrapper);
            };

            $dom.on(window, 'scroll', infiniteScrollingCommentsWrapper);
            $dom.on(window, 'keydown', $dom.infiniteScrollingBlock);
            $dom.on(window, 'mousedown', $dom.infiniteScrollingBlockHold);
            $dom.on(window, 'mousemove', function () {
                $dom.infiniteScrollingBlockUnhold(infiniteScrollingCommentsWrapper);
            });

            // ^ mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
            infiniteScrollingCommentsWrapper();
        }
    };
    
    $cms.templates.postChildLoadLink = function (params, container) {
        var ids = params.implodedIds,
            id = params.id;

        $dom.on(container, 'click', '.js-click-threaded-load-more', function () {
            /* Load more from a threaded topic */
            $cms.loadSnippet('comments&id=' + encodeURIComponent(id) + '&ids=' + encodeURIComponent(ids) + '&serialized_options=' + encodeURIComponent(window.commentsSerializedOptions) + '&hash=' + encodeURIComponent(window.commentsHash), null, true).then(function (html) {
                var wrapper;
                if (id !== '') {
                    wrapper = $dom.$('#post_children_' + id);
                } else {
                    wrapper = container.parentNode;
                }
                container.parentNode.removeChild(container);

                $dom.append(wrapper, html);

                setTimeout(function () {
                    var _ids = ids.split(',');
                    for (var i = 0; i < _ids.length; i++) {
                        var element = document.getElementById('post_wrap_' + _ids[i]);
                        if (element) {
                            $dom.fadeIn(element);
                        }
                    }
                }, 0);
            });
        });

    };

    function forceReloadOnBack() {
        $dom.on(window, 'pageshow', function () {
            window.location.reload();
        });
    }

    /* Update a normal comments topic with AJAX replying */
    function replaceCommentsFormWithAjax(options, hash, commentsFormId, commentsWrapperId) {
        var commentsForm = $dom.$id(commentsFormId);
        if (!commentsForm) {
            return;
        }
        
        $dom.on(commentsForm, 'submit', function commentsAjaxListener(event) {
            var ret;
            
            if (event.detail && (event.detail.triggeredByDoFormPreview || event.detail.triggeredByCommentsAjaxListener )) {
                return true;
            }

            // Cancel the event from running
            event.preventDefault();

            ret = $dom.trigger(commentsForm, 'submit', { detail: { triggeredByCommentsAjaxListener: true } });
            
            if (ret === false) {
                return false;
            }

            var commentsWrapper = $dom.$id(commentsWrapperId);
            if (!commentsWrapper) { // No AJAX, as stuff missing from template
                commentsForm.submit();
                return true;
            }

            var submitButton = $dom.$id('submit-button');
            if (submitButton) {
                $cms.ui.disableButton(submitButton);
            }

            // Note what posts are shown now
            var knownPosts = commentsWrapper.querySelectorAll('.post'),
                knownTimes = [];
            
            for (var i = 0; i < knownPosts.length; i++) {
                knownTimes.push(knownPosts[i].className.replace(/^post /, ''));
            }

            // Fire off AJAX request
            var post = 'options=' + encodeURIComponent(options) + '&hash=' + encodeURIComponent(hash),
                postElement = commentsForm.elements['post'],
                postValue = postElement.value;
            
            if (postElement.defaultSubstringToStrip !== undefined) {// Strip off prefix if unchanged
                if (postValue.substring(0, postElement.defaultSubstringToStrip.length) === postElement.defaultSubstringToStrip) {
                    postValue = postValue.substring(postElement.defaultSubstringToStrip.length, postValue.length);
                }
            }
            for (var j = 0; j < commentsForm.elements.length; j++) {
                if ((commentsForm.elements[j].name) && (commentsForm.elements[j].name !== 'post')) {
                    post += '&' + commentsForm.elements[j].name + '=' + encodeURIComponent($cms.form.cleverFindValue(commentsForm, commentsForm.elements[j]));
                }
            }
            post += '&post=' + encodeURIComponent(postValue);
            $cms.doAjaxRequest('{$FIND_SCRIPT;,post_comment}' + $cms.keep(true), null, post).then(function (xhr) {
                if ((xhr.responseText !== '') && (xhr.status !== 500)) {
                    // Display
                    var oldAction = commentsForm.action;
                    $dom.replaceWith(commentsWrapper, xhr.responseText);
                    commentsForm = $dom.$id(commentsFormId);
                    commentsForm.action = oldAction; // AJAX will have mangled URL (as was not running in a page context), this will fix it back

                    // Scroll back to comment
                    setTimeout(function () {
                        var commentsWrapper = $dom.$id(commentsWrapperId); // outerhtml set will have broken the reference
                        $dom.smoothScroll($dom.findPosY(commentsWrapper, true));
                    }, 0);

                    // Force reload on back button, as otherwise comment would be missing
                    forceReloadOnBack();

                    // Collapse, so user can see what happening
                    var outer = $dom.$id('comments_posting_form_outer');
                    if (outer && outer.classList.contains('toggleable-tray')) {
                        $cms.ui.toggleableTray(outer);
                    }

                    // Set fade for posts not shown before
                    var knownPosts = commentsWrapper.querySelectorAll('.post');
                    for (var i = 0; i < knownPosts.length; i++) {
                        if (!knownTimes.includes(knownPosts[i].className.replace(/^post /, ''))) {
                            $dom.fadeIn(knownPosts[i]);
                        }
                    }

                    // And re-attach this code (got killed by $dom.replaceWith())
                    replaceCommentsFormWithAjax(options, hash);
                } else { // Error: do a normal post so error can be seen
                    commentsForm.submit();
                }
            });

            return false;
        });
    }

    function applyRatingHighlightAndAjaxCode(likes, initialRating, contentType, id, type, rating, contentUrl, contentTitle, initialisationPhase, visualOnly) {
        rating = +rating || 0;
        visualOnly = !!visualOnly;

        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].forEach(function (number) {
            var bit = $dom.$id('rating_bar_' + number + '__' + contentType + '__' + type + '__' + id);
            if (!bit) {
                return;
            }
            bit.className = (likes ? (rating === number) : (rating >= number)) ? 'rating-star-highlight' : 'rating-star';

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
                        if (replaceSpot.classList.contains('rating-box')) {
                            template = 'RATING_BOX';
                            break;
                        }
                        if (replaceSpot.classList.contains('rating-inline-static')) {
                            template = 'RATING_INLINE_STATIC';
                            break;
                        }
                        if (replaceSpot.classList.contains('rating-inline-dynamic')) {
                            template = 'RATING_INLINE_DYNAMIC';
                            break;
                        }
                    }
                }
                var _replaceSpot = (template === '') ? bit.parentNode.parentNode.parentNode.parentNode : replaceSpot;

                // Show loading animation
                $dom.html(_replaceSpot, '');
                var loadingImage = document.createElement('img');
                loadingImage.className = 'ajax-loading';
                loadingImage.src = $util.srl('{$IMG;,loading}');
                loadingImage.style.height = '12px';
                _replaceSpot.appendChild(loadingImage);

                // AJAX call
                var snippetRequest = 'rating&type=' + encodeURIComponent(type) + '&id=' + encodeURIComponent(id) + '&content_type=' + encodeURIComponent(contentType) + '&template=' + encodeURIComponent(template) + '&content_url=' + encodeURIComponent($cms.protectURLParameter(contentUrl)) + '&content_title=' + encodeURIComponent(contentTitle);

                $cms.loadSnippet(snippetRequest, 'rating=' + encodeURIComponent(number), true).then(function (message) {
                    $dom.replaceWith(_replaceSpot, (template === '') ? ('<strong>' + message + '</strong>') : message);
                });

                return false;
            });
        });
    }
    
    /**
     * Reply to a topic using AJAX
     * @param isThreaded
     * @param id
     * @param replyingToUsername
     * @param replyingToPost
     * @param replyingToPostPlain
     * @param isExplicitQuote
     */
    $cms.functions.topicReply = function topicReply(isThreaded, id, replyingToUsername, replyingToPost, replyingToPostPlain, isExplicitQuote) {
        isThreaded = !!isThreaded;
        isExplicitQuote = !!isExplicitQuote;

        var el = this,
            form = $dom.$('form#comments-form');

        var parentIdField;
        if (form.elements['parent_id'] === undefined) {
            parentIdField = document.createElement('input');
            parentIdField.type = 'hidden';
            parentIdField.name = 'parent_id';
            form.appendChild(parentIdField);
        } else {
            parentIdField = form.elements['parent_id'];
            if (window.lastReplyTo !== undefined) {
                window.lastReplyTo.style.opacity = 1;
            }
        }
        window.lastReplyTo = el;
        parentIdField.value = isThreaded ? id : '';

        el.classList.add('activated_quote_button');

        var post = form.elements.post;

        $dom.smoothScroll($dom.findPosY(form, true));

        var outer = $dom.$('#comments_posting_form_outer');
        if (outer && $dom.notDisplayed(outer)) {
            $cms.ui.toggleableTray(outer);
        }

        if (isThreaded) {
            post.value = $util.format('{!QUOTED_REPLY_MESSAGE;^}', [replyingToUsername, replyingToPostPlain]);
            post.stripOnFocus = post.value;
            post.classList.add('field-input-non-filled');
        } else {
            if ((post.stripOnFocus !== undefined) && (post.value == post.stripOnFocus)) {
                post.value = '';
            } else if (post.value !== '') {
                post.value += '\n\n';
            }

            post.focus();
            post.value += '[quote="' + replyingToUsername + '"]\n' + replyingToPost + '\n[snapback]' + id + '[/snapback][/quote]\n\n';

            if (!isExplicitQuote) {
                post.defaultSubstringToStrip = post.value;
            }
        }

        $cms.manageScrollHeight(post);
        post.scrollTop = post.scrollHeight;
    };
}(window.$cms, window.$util, window.$dom));

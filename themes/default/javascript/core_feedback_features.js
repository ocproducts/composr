(function ($, Composr) {
    Composr.templates.coreFeedbackFeatures = {
        ratingForm: function ratingForm(options) {
            var rating;

            if (!Composr.isEmptyOrZero(options.error)) {
                return;
            }

            if (!Composr.isEmptyOrZero(Composr.$JS_ON)) {
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

    Composr.behaviors.coreFeedbackFeatures = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_feedback_features');
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);
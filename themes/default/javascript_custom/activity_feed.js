(function ($cms) {
    'use strict';
    /*
     This provides the JavaScript necessary for the "status" part of activities
     */
    $cms.views.BlockMainActivitiesState = BlockMainActivitiesState;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function BlockMainActivitiesState(params) {
        BlockMainActivitiesState.base(this, 'constructor', arguments);

        this.form = this.$('form.js-form-status-updates');
        this.submitBtn = this.$('.js-btn-submit-update');
        this.textarea = this.$('textarea.js-textarea-activity-status');
        this.notificationEl = this.$('.js-el-activities-update-notification');
    }

    $cms.inherits(BlockMainActivitiesState, $cms.View, /**@lends BlockMainActivitiesState#*/{
        events: function () {
            return {
                'focus textarea.js-textarea-activity-status': 'textareaFocus',
                'blur textarea.js-textarea-activity-status': 'textareaBlur',
                'keyup textarea.js-textarea-activity-status': 'textareaKeyup',
                'keypress textarea.js-textarea-activity-status': 'textareaKeypress',

                'keyup .js-textarea-keyup-manage-scroll-height': 'manageScrollHeight',

                'submit form.js-form-status-updates': 'submitForm'
            };
        },

        textareaFocus: function (e, textarea) {
            if (textarea.value.trim() === '{!activities:TYPE_HERE;^}') {
                textarea.value = '';
                textarea.classList.add('field_input_filled');
                textarea.classList.remove('field_input_non_filled');
            }
            textarea.classList.remove('fade_input');
        },
        textareaBlur: function (e, textarea) {
            if (textarea.value.trim() === '') {
                textarea.value = '{!activities:TYPE_HERE;^}';
                textarea.classList.remove('field_input_filled');
                textarea.classList.add('field_input_non_filled');
            }

            textarea.classList.add('fade_input');
        },
        textareaKeyup: function (e, textarea) {
            if (!$cms.$MOBILE()) {
                $cms.manageScrollHeight(textarea);
            }
            this.maintainCharCount();
        },
        textareaKeypress: function (e, textarea) {
            this.maintainCharCount();
        },

        /**
         * Called on update submission
         */
        submitForm: function (e, form) {
            var subjectText = this.textarea.value.trim();

            if (e) {
                e.preventDefault();
            }

            if ((subjectText === '') || (subjectText === '{!activities:TYPE_HERE;^}')) {
                this.notificationEl.className = 'update_error';
                this.notificationEl.textContent = '{!activities:PLEASE_ENTER_STATUS;^}';
            } else {
                var view = this;
                jQuery.ajax({
                    url: $cms.baseUrl('data_custom/activities_handler.php' + $cms.keepStub(true)),
                    type: 'POST',
                    data: $cms.dom.serialize(form),
                    cache: false,
                    timeout: 5000,
                    // Processes data retrieved for the activities feed and updates the list
                    complete: function (jqXHR, textStatus ) {
                        view.submitBtn.disabled = false;

                        if ((textStatus !== 'success') || !jqXHR.responseXML) {
                            view.notificationEl.className = 'update_error';
                            view.notificationEl.textContent = '{!activities:WENT_WRONG;^}';
                            $cms.dom.hide(view.notificationEl);

                            $cms.dom.fadeIn(view.notificationEl, 1200, function () {
                                setTimeout(function () {
                                    $cms.dom.fadeOut(view.notificationEl, 1200, function () {
                                        view.maintainCharCount();
                                        $cms.dom.fadeIn(view.notificationEl, 1200);
                                    });
                                }, 2400);
                            });
                            return;
                        }

                        var xmlDoc = jqXHR.responseXML,
                            successEl = xmlDoc.querySelector('success'),
                            feedbackEl = xmlDoc.querySelector('feedback');

                        if (successEl.textContent === '0') {
                            if (feedbackEl.textContent.startsWith('{!MUST_LOGIN;^}')) { //if refusal is due to login expiry...
                                $cms.ui.alert('{!MUST_LOGIN;^}');
                            } else {
                                view.notificationEl.className = 'update_error';
                                view.notificationEl.textContent = feedbackEl.textContent;
                            }
                        } else if (successEl.textContent === '1') {
                            view.notificationEl.className = 'update_success';
                            view.notificationEl.textContent = feedbackEl.textContent;

                            if ($cms.dom.$('#activities_feed')) { // The update box won't necessarily have a displayed feed to update
                                sUpdateGetData();
                            }

                            $cms.dom.fadeIn(view.notificationEl, 1200, function () {
                                $cms.dom.fadeOut(view.notificationEl, 1200, function () {
                                    view.notificationEl.className = 'update_success';
                                    view.notificationEl.textContent = '254 {!activities:CHARACTERS_LEFT;^}';
                                    $cms.dom.fadeIn(view.notificationEl, 1200);

                                    var textareaParentEl = view.textarea.parentElement;

                                    $cms.dom.height(textareaParentEl, $cms.dom.height(textareaParentEl));

                                    view.textarea.value = '{!activities:TYPE_HERE;^}';
                                    view.textarea.classList.remove('field_input_filled');
                                    view.textarea.classList.add('field_input_non_filled');

                                    $cms.dom.fadeIn(view.textarea, 1200, function () {
                                        $cms.dom.height(textareaParentEl, '');
                                    });
                                });
                            });
                        }
                    }
                });
            }
        },

        // Maintain feedback on how many characters are available in an update box.
        maintainCharCount: function () {
            var charCount = this.textarea.value.length;

            if (charCount < 255) {
                this.notificationEl.className = 'update_success';
                this.notificationEl.textContent = (254 - charCount) + ' {!activities:CHARACTERS_LEFT;^}';
            } else {
                this.notificationEl.className = 'update_error';
                this.notificationEl.textContent = (charCount - 254) + ' {!activities:CHARACTERS_TOO_MANY;^}';

            }
        }
    });
    
    $cms.templates.cnsMemberProfileActivities = function cnsMemberProfileActivities(params, container) {
        var syndications = params.syndications,
            syndication;

        for (var hook in syndications) {
            syndication = syndications[hook];

            if (syndication.syndicationJavascriptFunctionCalls != null) {
                $cms.executeJsFunctionCalls(syndication.syndicationJavascriptFunctionCalls);
            }
        }
    };

    $cms.templates.activity = function activity(params, container) {
        var liid = strVal(params.liid);

        $cms.dom.on(container, 'click', '.js-submit-confirm-update-remove', function (e) {
            sUpdateRemove(e, liid);
        });
    };

    $cms.templates.blockMainActivities = function blockMainActivities(params) {
        if (!params.isBlockRaw) {
            window.activities_mode = strVal(params.mode);
            window.activities_member_ids = strVal(params.memberIds);

            if (params.start === 0) {
                // "Grow" means we should keep stacking new content on top of old. If not
                // then we should allow old content to "fall off" the bottom of the feed.
                window.activities_feed_grow = !!params.grow;
                window.activities_feed_max = params.max;
                if (document.getElementById('activities_feed')) {
                    setInterval(sUpdateGetData, params.refreshTime * 1000);
                }
            }
        }
    };
}(window.$cms));



// Assume that our activity feed needs updating to start with
if (window.latest_activity === undefined) {
    window.latest_activity = 0;
    window.s_ajax_update_locking = 0;
    window.activities_feed_grow = true;
}

function sUpdateGetData() {
    // Lock feed updates by setting s_ajax_update_locking to 1
    if ((++window.s_ajax_update_locking) > 1) {
        window.s_ajax_update_locking = 1;
    } else {
        // First we check whether our feed is already up to date
        jQuery.ajax({
            url: $cms.baseUrl('data_custom/latest_activity.txt?cache_break=' + Math.floor(Math.random() * 10000)),
            data: {},
            success: function (data) {
                if (parseInt(data) != window.latest_activity) {
                    // If not then remember the new value
                    window.latest_activity = parseInt(data);

                    // Now grab whatever updates are available
                    var url = $cms.baseUrl('data_custom/activities_updater.php' + $cms.keepStub(true)),
                        listElements = jQuery('li', '#activities_feed'),
                        lastId = ((listElements.attr('id') == undefined) ? '-1' : listElements.attr('id').replace(/^activity_/, '')),
                        postVal = 'last_id=' + lastId + '&mode=' + window.activities_mode;

                    if ((window.activities_member_ids != null) && (window.activities_member_ids !== '')) {
                        postVal = postVal + '&member_ids=' + window.activities_member_ids;
                    }

                    postVal += '&csrf_token=' + encodeURIComponent($cms.getCsrfToken()); // For CSRF prevention

                    jQuery.ajax({
                        url: url,
                        type: 'POST',
                        data: postVal,
                        cache: false,
                        timeout: 5000,
                        success: function (data, stat) {
                            sUpdateShow(data, stat);
                        },
                        error: function (a, stat, err) {
                            sUpdateShow(err, stat);
                        }
                    });
                } else {
                    // Allow feed updates
                    window.s_ajax_update_locking = 0;
                }
            },
            dataType: 'text'
        });
    }
}

/**
 * Receive and parse data for the activities activities feed
 */
function sUpdateShow(data, stat) {
    if (window.s_ajax_update_locking > 1) {
        window.s_ajax_update_locking = 1;
    } else {
        var succeeded = false;
        if (stat == 'success') {
            if (jQuery('success', data).text() == '1') {
                var listElements = jQuery('li', '#activities_feed'); // Querying from current browser DOM
                var listItems = jQuery('listitem', data); // Querying from XML definition o new data

                listElements.removeAttr('toFade');

                // Add in new items
                var topOfList = document.getElementById('activities_holder').firstChild;
                jQuery.each(listItems, function () {
                    var thisLi = document.createElement('li');
                    thisLi.id = 'activity_' + jQuery(this).attr('id');
                    thisLi.className = 'activities_box box';
                    thisLi.setAttribute('toFade', 'yes');
                    topOfList.parentNode.insertBefore(thisLi, topOfList);
                    $cms.dom.html(thisLi, window.Base64.decode(jQuery(this).text()));
                });

                var noMessages = document.getElementById('activity_-1');
                if (noMessages) noMessages.style.display = 'none';

                listElements = jQuery('li', '#activities_feed'); // Refresh, so as to include the new activity nodes

                if ((!window.activities_feed_grow) && (listElements.length > window.activities_feed_max)) // Remove anything passed the grow length
                {
                    for (var i = window.activities_feed_max; i < listElements.length; i++) {
                        listElements.last().remove();
                    }
                }

                jQuery('#activities_general_notify').text('');
                jQuery('li[toFade="yes"]', '#activities_feed').hide().fadeIn(1200);
                succeeded = true;
            } else {
                if (jQuery('success', data).text() == '2') {
                    jQuery('#activities_general_notify').text('');
                    succeeded = true;
                }
            }
        }
        if (!succeeded) {
            jQuery('#activities_general_notify').text('{!INTERNAL_ERROR;^}');
        }
        window.s_ajax_update_locking = 0;
    }
}

function sUpdateRemove(event, id) {
    $cms.ui.confirm(
        '{!activities:DELETE_CONFIRM;^}',
        function (result) {
            if (result) {
                var url = $cms.baseUrl('data_custom/activities_removal.php' + $cms.keepStub(true));

                var postVal = 'removal_id=' + id;
                postVal += '&csrf_token=' + encodeURIComponent($cms.getCsrfToken()); // For CSRF prevention

                jQuery.ajax({
                    url: url,
                    type: 'POST',
                    data: postVal,
                    cache: false,
                    timeout: 5000,
                    success: function (data, stat) {
                        sUpdateRemoveShow(data, stat);
                    },
                    error: function (a, stat, err) {
                        sUpdateRemoveShow(err, stat);
                    }
                });
            }
        }
    );
    event.preventDefault();
}

function sUpdateRemoveShow(data, stat) {
    var succeeded = false;
    var statusId = '';

    var animationSpeed = 1600;

    if (stat == 'success') {
        if (jQuery('success', data).text() == '1') {
            statusId = '#activity_' + jQuery('status_id', data).text();
            jQuery('.activities_content', statusId, '#activities_feed').text(jQuery('feedback', data).text()).addClass('activities_content__remove_success').hide().fadeIn(animationSpeed, function () {
                jQuery(statusId, '#activities_feed').fadeOut(animationSpeed, function () {
                    jQuery(statusId, '#activities_feed').remove();
                });
            });
        } else {
            switch (jQuery('err', data).text()) {
                case 'perms':
                    statusId = '#activity_' + jQuery('status_id', data).text();
                    var backupUpText = jQuery('activities_content', statusId, '#activities_feed').text();
                    jQuery('.activities_content', statusId, '#activities_feed').text(jQuery('feedback', data).text()).addClass('activities_content__remove_failure').hide().fadeIn(animationSpeed, function () {
                        jQuery('.activities_content', statusId, '#activities_feed').fadeOut(animationSpeed, function () {
                            jQuery('.activities_content', statusId, '#activities_feed').text(backupUpText).removeClass('activities_content__remove_failure').fadeIn(animationSpeed);
                        });
                    });
                    break;
                case 'missing':
                default:
                    break;
            }
        }
    }
}


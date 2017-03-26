(function ($cms) {

    /*
     This provides the JavaScript necessary for the "status" part of activities
     */

    $cms.views.BlockMainActivitiesState = BlockMainActivitiesState;

    function BlockMainActivitiesState(params) {
        BlockMainActivitiesState.base(this, 'constructor', arguments);

        this.form = this.$('form.js-form-status-updates');
        this.submitBtn = this.$('.js-btn-submit-update');
        this.textarea = this.$('textarea.js-textarea-activity-status');
        this.notificationEl = this.$('.js-el-activities-update-notification');
    }

    $cms.inherits(BlockMainActivitiesState, $cms.View, {
        events: {
            'focus textarea.js-textarea-activity-status': 'textareaFocus',
            'blur textarea.js-textarea-activity-status': 'textareaBlur',
            'keyup textarea.js-textarea-activity-status': 'textareaKeyup',
            'keypress textarea.js-textarea-activity-status': 'textareaKeypress',

            'keyup .js-textarea-keyup-manage-scroll-height': 'manageScrollHeight',

            'submit form.js-form-status-updates': 'submitForm'
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
            if (!$cms.$MOBILE) {
                manage_scroll_height(textarea);
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

                            if ($cms.dom.$('#activities_feed')) {// The update box won't necessarily have a displayed feed to update
                                s_update_get_data();
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

}(window.$cms));

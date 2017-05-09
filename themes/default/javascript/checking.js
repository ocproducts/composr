/* Validation code and other general code relating to forms */
(function ($cms) {
    'use strict';

    /**
     * @memberof $cms.form
     * @param radios
     * @returns {*}
     */
    $cms.form.radioValue = function radioValue(radios) {
        for (var i = 0; i < radios.length; i++) {
            if (radios[i].checked) {
                return radios[i].value;
            }
        }
        return '';
    };

    /**
     * @memberof $cms.form
     * @param the_element
     * @param error_msg
     */
    $cms.form.setFieldError = function setFieldError(the_element, error_msg) {
        if (the_element.name !== undefined) {
            var id = the_element.name;
            var errormsg_element = getErrormsgElement(id);
            if ((error_msg == '') && (id.indexOf('_hour') != -1) || (id.indexOf('_minute') != -1)) { // Do not blank out as day/month/year (which comes first) would have already done it
                return;
            }
            if (errormsg_element) {
                // Make error message visible, if there's an error
                errormsg_element.style.display = (error_msg == '') ? 'none' : 'block';

                // Changed error message
                if ($cms.dom.html(errormsg_element) != $cms.filter.html(error_msg)) {
                    $cms.dom.html(errormsg_element, '');
                    if (error_msg != '') // If there actually an error
                    {
                        the_element.setAttribute('aria-invalid', 'true');

                        // Need to switch tab?
                        var p = errormsg_element;
                        while (p !== null) {
                            p = p.parentNode;
                            if ((error_msg.substr(0, 5) != '{!DISABLED_FORM_FIELD;^}'.substr(0, 5)) && (p) && (p.getAttribute !== undefined) && (p.getAttribute('id')) && (p.getAttribute('id').substr(0, 2) == 'g_') && (p.style.display == 'none')) {
                                $cms.ui.selectTab('g', p.getAttribute('id').substr(2, p.id.length - 2), false, true);
                                break;
                            }
                        }

                        // Set error message
                        var msg_node = document.createTextNode(error_msg);
                        errormsg_element.appendChild(msg_node);
                        errormsg_element.setAttribute('role', 'alert');

                        // Fade in
                        $cms.dom.clearTransitionAndSetOpacity(errormsg_element, 0.0);
                        $cms.dom.fadeTransition(errormsg_element, 100, 30, 4);

                    } else {
                        the_element.setAttribute('aria-invalid', 'false');
                        errormsg_element.setAttribute('role', '');
                    }
                }
            }
        }
        if (($cms.form.isWysiwygField !== undefined) && ($cms.form.isWysiwygField(the_element))) {
            the_element = the_element.parentNode;
        }

        the_element.classList.remove('input_erroneous');

        if (error_msg != '') {
            the_element.classList.add('input_erroneous');
        }

        function getErrormsgElement(id) {
            var errormsg_element = document.getElementById('error_' + id);

            if (!errormsg_element) {
                errormsg_element = document.getElementById('error_' + id.replace(/\_day$/, '').replace(/\_month$/, '').replace(/\_year$/, '').replace(/\_hour$/, '').replace(/\_minute$/, ''));
            }
            return errormsg_element;
        }
    };

    /**
     * @memberof $cms.form
     * @param form
     * @param event
     * @returns {boolean}
     */
    $cms.form.doFormSubmit = function doFormSubmit(form, event) {
        if (!$cms.form.checkForm(form, false)) {
            return false;
        }

        if (form.old_action) {
            form.setAttribute('action', form.old_action);
        }
        if (form.old_target) {
            form.setAttribute('target', form.old_target);
        }
        if (!form.getAttribute('target')) {
            form.setAttribute('target', '_top');
        }

        /* Remove any stuff that is only in the form for previews if doing a GET request */
        if (form.method.toLowerCase() === 'get') {
            var i = 0, name, elements = [];
            for (i = 0; i < form.elements.length; i++) {
                elements.push(form.elements[i]);
            }
            for (i = 0; i < elements.length; i++) {
                name = elements[i].name;
                if (name && ((name.substr(0, 11) == 'label_for__') || (name.substr(0, 14) == 'tick_on_form__') || (name.substr(0, 9) == 'comcode__') || (name.substr(0, 9) == 'require__'))) {
                    elements[i].parentNode.removeChild(elements[i]);
                }
            }
        }
        if (form.onsubmit) {
            var ret = form.onsubmit.call(form, event);
            if (!ret) {
                return false;
            }
        }
        if (!window.just_checking_requirements) {
            form.submit();
        }

        $cms.ui.disableSubmitAndPreviewButtons();

        if (window.detect_interval !== undefined) {
            window.clearInterval(window.detect_interval);
            delete window.detect_interval;
        }

        return true;
    };

    /**
     * @memberof $cms.form
     * @param event
     * @param form
     * @param preview_url
     * @param has_separate_preview
     * @returns {boolean}
     */
    $cms.form.doFormPreview = function doFormPreview(event, form, preview_url, has_separate_preview) {
        has_separate_preview = !!has_separate_preview;

        if (!$cms.dom.$id('preview_iframe')) {
            $cms.ui.alert('{!ADBLOCKER;^}');
            return false;
        }

        preview_url += ((window.mobile_version_for_preview === undefined) ? '' : ('&keep_mobile=' + (window.mobile_version_for_preview ? '1' : '0')));

        var old_action = form.getAttribute('action');

        if (!form.old_action) {
            form.old_action = old_action;
        }
        form.setAttribute('action', /*$cms.maintainThemeInLink - no, we want correct theme images to work*/(preview_url) + ((form.old_action.indexOf('&uploading=1') != -1) ? '&uploading=1' : ''));
        var old_target = form.getAttribute('target');
        if (!old_target) {
            old_target = '_top';
        }
        /* not _self due to edit screen being a frame itself */
        if (!form.old_target) {
            form.old_target = old_target;
        }
        form.setAttribute('target', 'preview_iframe');

        if ((window.$cms.form.checkForm) && (!$cms.form.checkForm(form, true))) {
            return false;
        }

        if (form.onsubmit) {
            var test = form.onsubmit.call(form, event, true);
            if (!test) {
                return false;
            }
        }

        if ((has_separate_preview) || (window.has_separate_preview)) {
            form.setAttribute('action', form.old_action + ((form.old_action.indexOf('?') == -1) ? '?' : '&') + 'preview=1');
            return true;
        }

        $cms.dom.$id('submit_button').style.display = 'inline';

        /* Do our loading-animation */
        if (!window.just_checking_requirements) {
            window.setInterval($cms.dom.triggerResize, 500);
            /* In case its running in an iframe itself */
            $cms.dom.illustrateFrameLoad('preview_iframe');
        }

        $cms.ui.disableSubmitAndPreviewButtons();

        // Turn main post editing back off
        if (window.wysiwygSetReadonly !== undefined) {
            wysiwygSetReadonly('post', true);
        }

        return true;
    };

    /**
     * @memberof $cms.form
     * @param the_element
     * @returns {*|boolean}
     */
    $cms.form.isWysiwygField = function isWysiwygField(the_element) {
        var id = the_element.id;
        return window.wysiwyg_editors && (typeof window.wysiwyg_editors === 'object') && (typeof window.wysiwyg_editors[id] === 'object');
    };

    /**
     * @memberof $cms.form
     * @param form
     * @param element
     * @returns {*}
     */
    $cms.form.cleverFindValue = function cleverFindValue(form, element) {
        if ((element.length !== undefined) && (element.nodeName === undefined)) {
            // Radio button
            element = element[0];
        }

        var value;
        switch (element.localName) {
            case 'textarea':
                value = (window.getTextbox === undefined) ? element.value : getTextbox(element);
                break;
            case 'select':
                value = '';
                if (element.selectedIndex >= 0) {
                    if (element.multiple) {
                        for (var i = 0; i < element.options.length; i++) {
                            if (element.options[i].selected) {
                                if (value != '') value += ',';
                                value += element.options[i].value;
                            }
                        }
                    } else if (element.selectedIndex >= 0) {
                        value = element.options[element.selectedIndex].value;
                        if ((value == '') && (element.getAttribute('size') > 1)) {
                            value = '-1';  // Fudge, as we have selected something explicitly that is blank
                        }
                    }
                }
                break;
            case 'input':
                switch (element.type) {
                    case 'checkbox':
                        value = (element.checked) ? element.value : '';
                        break;

                    case 'radio':
                        value = '';
                        for (var i = 0; i < form.elements.length; i++) {
                            if ((form.elements[i].name == element.name) && (form.elements[i].checked)) {
                                value = form.elements[i].value;
                            }
                        }
                        break;

                    case 'hidden':
                    case 'text':
                    case 'color':
                    case 'date':
                    case 'datetime':
                    case 'datetime-local':
                    case 'email':
                    case 'month':
                    case 'number':
                    case 'range':
                    case 'search':
                    case 'tel':
                    case 'time':
                    case 'url':
                    case 'week':
                    case 'password':
                    default:
                        value = element.value;
                        break;
                }
        }
        return value;
    };

    /**
     * @memberof $cms.form
     * @param the_form
     * @param for_preview
     * @returns {boolean}
     */
    $cms.form.checkForm = function checkForm(the_form, for_preview) {
        var delete_element = $cms.dom.$('#delete');
        if ((!for_preview) && (delete_element != null) && (((delete_element.classList[0] == 'input_radio') && (delete_element.value != '0')) || (delete_element.classList[0] == 'input_tick')) && (delete_element.checked)) {
            return true;
        }

        var j, the_element, erroneous = false, total_file_size = 0, alerted = false, error_element = null, check_result;
        for (j = 0; j < the_form.elements.length; j++) {
            if (!the_form.elements[j]) {
                continue;
            }

            the_element = the_form.elements[j];

            check_result = checkField(the_element, the_form, for_preview);
            if (check_result != null) {
                erroneous = check_result[0] || erroneous;
                if (!error_element && erroneous) error_element = the_element;
                total_file_size += check_result[1];
                alerted = check_result[2] || alerted;

                if (check_result[0]) {
                    var auto_reset_error = function (the_element) {
                        return function (event, no_recurse) {
                            var check_result = checkField(the_element, the_form, for_preview);
                            if ((check_result != null) && (!check_result[0])) {
                                $cms.form.setFieldError(the_element, '');
                            }

                            if ((!no_recurse) && (the_element.className.indexOf('date') != -1) && (the_element.name.match(/\_(day|month|year)$/))) {
                                var e = $cms.dom.$id(the_element.id.replace(/\_(day|month|year)$/, '_day'));
                                if (e != the_element) {
                                    e.onblur(event, true);
                                }
                                var e = $cms.dom.$id(the_element.id.replace(/\_(day|month|year)$/, '_month'));
                                if (e != the_element) {
                                    e.onblur(event, true);
                                }
                                var e = $cms.dom.$id(the_element.id.replace(/\_(day|month|year)$/, '_year'));
                                if (e != the_element) {
                                    e.onblur(event, true);
                                }
                            }
                        };
                    };

                    if (the_element.getAttribute('type') == 'radio') {
                        for (var i = 0; i < the_form.elements.length; i++) {
                            the_form.elements[i].onchange = auto_reset_error(the_form.elements[i]);
                        }
                    } else {
                        the_element.onblur = auto_reset_error(the_element);
                    }
                }
            }
        }

        if ((total_file_size > 0) && (the_form.elements['MAX_FILE_SIZE'])) {
            if (total_file_size > the_form.elements['MAX_FILE_SIZE'].value) {
                if (!erroneous) {
                    error_element = the_element;
                    erroneous = true;
                }
                if (!alerted) {
                    $cms.ui.alert('{!javascript:TOO_MUCH_FILE_DATA;^}'.replace(new RegExp('\\\\{' + '1' + '\\\\}', 'g'), Math.round(total_file_size / 1024)).replace(new RegExp('\\\\{' + '2' + '\\\\}', 'g'), Math.round(the_form.elements['MAX_FILE_SIZE'].value / 1024)));
                }
                alerted = true;
            }
        }

        if (erroneous) {
            if (!alerted) $cms.ui.alert('{!IMPROPERLY_FILLED_IN;^}');
            var posy = $cms.dom.findPosY(error_element, true);
            if (posy == 0) {
                posy = $cms.dom.findPosY(error_element.parentNode, true);
            }
            if (posy != 0)
                $cms.dom.smoothScroll(posy - 50, null, null, function () {
                    try {
                        error_element.focus();
                    } catch (e) {
                    }
                    /* Can have exception giving focus on IE for invisible fields */
                });
        }

        // Try and workaround max_input_vars problem if lots of usergroups
        if (!erroneous) {
            var delete_e = $cms.dom.$id('delete');
            var is_delete = delete_e && delete_e.type == 'checkbox' && delete_e.checked;
            var es = document.getElementsByTagName('select'), e;
            for (var i = 0; i < es.length; i++) {
                e = es[i];
                if ((e.name.match(/^access_\d+_privilege_/)) && ((is_delete) || (e.options[e.selectedIndex].value == '-1'))) {
                    e.disabled = true;
                }
            }
        }

        return !erroneous;

        function checkField(the_element, the_form) {
            var i, the_class, required, my_value, erroneous = false, error_msg = '', regexp, total_file_size = 0, alerted = false;

            // No checking for hidden elements
            if (((the_element.type === 'hidden') || (((the_element.style.display == 'none') || (the_element.parentNode.style.display == 'none') || (the_element.parentNode.parentNode.style.display == 'none') || (the_element.parentNode.parentNode.parentNode.style.display == 'none')) && (($cms.form.isWysiwygField === undefined) || (!$cms.form.isWysiwygField(the_element))))) && ((!the_element.className) || (the_element.classList.contains('hidden_but_needed')) == null)) {
                return null;
            }
            if (the_element.disabled) {
                return null;
            }

            // Test file sizes
            if ((the_element.type == 'file') && (the_element.files) && (the_element.files.item) && (the_element.files.item(0)) && (the_element.files.item(0).fileSize))
                total_file_size += the_element.files.item(0).fileSize;

            // Test file types
            if ((the_element.type == 'file') && (the_element.value) && (the_element.name != 'file_anytype')) {
                var allowed_types = '{$VALID_FILE_TYPES;^}'.split(/,/);
                var type_ok = false;
                var theFileType = the_element.value.indexOf('.') ? the_element.value.substr(the_element.value.lastIndexOf('.') + 1) : '{!NONE;^}';
                for (var k = 0; k < allowed_types.length; k++) {
                    if (allowed_types[k].toLowerCase() == theFileType.toLowerCase()) type_ok = true;
                }
                if (!type_ok) {
                    error_msg = '{!INVALID_FILE_TYPE;^,xx1xx,{$VALID_FILE_TYPES}}'.replace(/xx1xx/g, theFileType).replace(/<[^>]*>/g, '').replace(/&[lr][sd]quo;/g, '\'').replace(/,/g, ', ');
                    if (!alerted) $cms.ui.alert(error_msg);
                    alerted = true;
                }
            }

            // Fix up bad characters
            if (($cms.browserMatches('ie')) && (the_element.value) && (the_element.localName != 'select')) {
                var bad_word_chars = [8216, 8217, 8220, 8221];
                var fixed_word_chars = ['\'', '\'', '"', '"'];
                for (i = 0; i < bad_word_chars.length; i++) {
                    regexp = new RegExp(String.fromCharCode(bad_word_chars[i]), 'gm');
                    the_element.value = the_element.value.replace(regexp, fixed_word_chars[i]);
                }
            }

            // Class name
            the_class = the_element.classList[0];

            // Find whether field is required and value of it
            if (the_element.type == 'radio') {
                required = (the_form.elements['require__' + the_element.name] !== undefined) && (the_form.elements['require__' + the_element.name].value == '1');
            } else {
                required = the_element.className.includes('_required');
            }
            my_value = $cms.form.cleverFindValue(the_form, the_element);

            // Prepare for custom error messages, stored as HTML5 data on the error message display element
            var errormsg_element = (the_element.name === undefined) ? null : getErrormsgElement(the_element.name);

            // Blank?
            if ((required) && (my_value.replace(/&nbsp;/g, ' ').replace(/<br\s*\/?>/g, ' ').replace(/\s/g, '') == '')) {
                error_msg = '{!REQUIRED_NOT_FILLED_IN;^}';
                if ((errormsg_element) && (errormsg_element.getAttribute('data-errorUnfilled') != null) && (errormsg_element.getAttribute('data-errorUnfilled') != ''))
                    error_msg = errormsg_element.getAttribute('data-errorUnfilled');
            } else {
                // Standard field-type checks
                if ((the_element.className.indexOf('date') != -1) && (the_element.name.match(/\_(day|month|year)$/)) && (my_value != '')) {
                    var day = the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_day')].options[the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_day')].selectedIndex].value;
                    var month = the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_month')].options[the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_month')].selectedIndex].value;
                    var year = the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_year')].options[the_form.elements[the_element.name.replace(/\_(day|month|year)$/, '_year')].selectedIndex].value;
                    var source_date = new Date(year, month - 1, day);
                    if (year != source_date.getFullYear()) error_msg = '{!javascript:NOT_A_DATE;^}';
                    if (month != source_date.getMonth() + 1) error_msg = '{!javascript:NOT_A_DATE;^}';
                    if (day != source_date.getDate()) error_msg = '{!javascript:NOT_A_DATE;^}';
                }
                if (((the_class == 'input_email') || (the_class == 'input_email_required')) && (my_value != '') && (!my_value.match(/^[a-zA-Z0-9\._\-\+]+@[a-zA-Z0-9\._\-]+$/))) {
                    error_msg = '{!javascript:NOT_A_EMAIL;^}'.replace('\{1}', my_value);
                }
                if (((the_class == 'input_username') || (the_class == 'input_username_required')) && (my_value != '') && (window.$cms.form.doAjaxFieldTest) && (!$cms.form.doAjaxFieldTest('{$FIND_SCRIPT_NOHTTP;,username_exists}?username=' + encodeURIComponent(my_value)))) {
                    error_msg = '{!javascript:NOT_USERNAME;^}'.replace('\{1}', my_value);
                }
                if (((the_class == 'input_codename') || (the_class == 'input_codename_required')) && (my_value != '') && (!my_value.match(/^[a-zA-Z0-9\-\.\_]*$/))) {
                    error_msg = '{!javascript:NOT_CODENAME;^}'.replace('\{1}', my_value);
                }
                if (((the_class == 'input_integer') || (the_class == 'input_integer_required')) && (my_value != '') && (parseInt(my_value, 10) != my_value - 0)) {
                    error_msg = '{!javascript:NOT_INTEGER;^}'.replace('\{1}', my_value);
                }
                if (((the_class == 'input_float') || (the_class == 'input_float_required')) && (my_value != '') && (parseFloat(my_value) != my_value - 0)) {
                    error_msg = '{!javascript:NOT_FLOAT;^}'.replace('\{1}', my_value);
                }

                // Shim for HTML5 regexp patterns
                if (the_element.getAttribute('pattern')) {
                    if ((my_value != '') && (!my_value.match(new RegExp(the_element.getAttribute('pattern'))))) {
                        error_msg = '{!javascript:PATTERN_NOT_MATCHED;^}'.replace('\{1}', my_value);
                    }
                }

                // Custom error messages
                if (error_msg != '' && errormsg_element != null) {
                    var custom_msg = errormsg_element.getAttribute('data-errorRegexp');
                    if ((custom_msg != null) && (custom_msg != ''))
                        error_msg = custom_msg;
                }
            }

            // Show error?
            $cms.form.setFieldError(the_element, error_msg);

            if ((error_msg != '') && (!erroneous)) {
                erroneous = true;
            }

            return [erroneous, total_file_size, alerted];

            function getErrormsgElement(id) {
                var errormsg_element = $cms.dom.$id('error_' + id);
                if (!errormsg_element) {
                    errormsg_element = $cms.dom.$id('error_' + id.replace(/\_day$/, '').replace(/\_month$/, '').replace(/\_year$/, '').replace(/\_hour$/, '').replace(/\_minute$/, ''));
                }
                return errormsg_element;
            }
        }
    };

    /**
     * @memberof $cms.form
     * @param field
     * @param is_locked
     * @param chosen_ob
     */
    $cms.form.setLocked = function setLocked(field, is_locked, chosen_ob) {
        var radio_button = $cms.dom.$id('choose_' + field.name.replace(/\[\]$/, ''));
        if (!radio_button) {
            radio_button = $cms.dom.$id('choose_' + field.name.replace(/\_\d+$/, '_'));
        }

        // For All-and-not,Line-multi,Compound-Tick,Radio-List,Date/Time: $cms.form.setLocked assumes that the calling code is clever
        // special input types are coded to observe their master input field readonly status)
        var button = $cms.dom.$id('uploadButton_' + field.name.replace(/\[\]$/, ''));

        if (is_locked) {
            var labels = document.getElementsByTagName('label'), label = null;
            for (var i = 0; i < labels.length; i++) {
                if (chosen_ob && (labels[i].getAttribute('for') == chosen_ob.id)) {
                    label = labels[i];
                    break;
                }
            }
            if (!radio_button) {
                if (label) {
                    var label_nice = $cms.dom.html(label).replace('&raquo;', '').replace(/^\s*/, '').replace(/\s*$/, '');
                    if (field.type == 'file') {
                        $cms.form.setFieldError(field, '{!DISABLED_FORM_FIELD_ENCHANCEDMSG_UPLOAD;^}'.replace(/\{1\}/, label_nice));
                    } else {
                        $cms.form.setFieldError(field, '{!DISABLED_FORM_FIELD_ENCHANCEDMSG;^}'.replace(/\{1\}/, label_nice));
                    }
                } else {
                    $cms.form.setFieldError(field, '{!DISABLED_FORM_FIELD;^}');
                }
            }
            field.classList.remove('input_erroneous');
        } else if (!radio_button) {
            $cms.form.setFieldError(field, '');
        }
        field.disabled = is_locked;

        if (button) {
            button.disabled = is_locked;
        }
    };

    /**
     * @memberof $cms.form
     * @param fieldName
     * @param isRequired
     */
    $cms.form.setRequired = function setRequired(fieldName, isRequired) {
        var radio_button = $cms.dom.$('#choose_' + fieldName);

        isRequired = !!isRequired;

        if (radio_button) {
            if (isRequired) {
                radio_button.checked = true;
            }
        } else {
            var required_a = $cms.dom.$('#form_table_field_name__' + fieldName),
                required_b = $cms.dom.$('#required_readable_marker__' + fieldName),
                required_c = $cms.dom.$('#required_posted__' + fieldName),
                required_d = $cms.dom.$('#form_table_field_input__' + fieldName);

            if (required_a) {
                required_a.className = 'form_table_field_name';

                if (isRequired) {
                    required_a.classList.add('required');
                }
            }

            if (required_b) {
                $cms.dom.toggle(required_b, isRequired);
            }

            if (required_c) {
                required_c.value = isRequired ? 1 : 0;
            }

            if (required_d) {
                required_d.className = 'form_table_field_input';
            }
        }

        var element = $cms.dom.$('#' + fieldName);

        if (element) {
            element.className = element.className.replace(/(input_[a-z_]+)_required/g, '$1');

            if (isRequired) {
                element.className = element.className.replace(/(input_[a-z_]+)/g, '$1_required');
            }

            if (element.plupload_object) {
                element.plupload_object.settings.required = isRequired;
            }
        }

        if (!isRequired) {
            var error = $cms.dom.$('#error__' + fieldName);
            if (error) {
                error.style.display = 'none';
            }
        }
    };

    /**
     * @memberof $cms.form
     * @param context
     */
    $cms.form.disablePreviewScripts = function disablePreviewScripts(context) {
        if (context === undefined) {
            context = document;
        }

        var elements, i;

        elements = $cms.dom.$$(context, 'button, input[type="button"], input[type="image"]');
        for (i = 0; i < elements.length; i++) {
            elements[i].addEventListener('click', alertNotInPreviewMode);
        }

        // Make sure links in the preview don't break it - put in a new window
        elements = $cms.dom.$$(context, 'a');
        for (i = 0; i < elements.length; i++) {
            if (elements[i].href && elements[i].href.includes('://')) {
                try {
                    if (!elements[i].href.toLowerCase().startsWith('javascript:') && (elements[i].target !== '_self') && (elements[i].target !== '_blank')) {// guard due to weird Firefox bug, JS actions still opening new window
                        elements[i].target = 'false_blank'; // Real _blank would trigger annoying CSS. This is better anyway.
                    }
                } catch (ignore) {} // IE can have security exceptions
            }
        }

        function alertNotInPreviewMode() {
            $cms.ui.alert('{!NOT_IN_PREVIEW_MODE;^}');
            return false;
        }
    };


    /**
     * Set it up so a form field is known and can be monitored for changes
     * @memberof $cms.form
     * @param container
     */
    $cms.form.setUpChangeMonitor = function setUpChangeMonitor(container) {
        var firstInp = $cms.dom.$(container, 'input, select, textarea');

        if (!firstInp || firstInp.id.includes('choose_')) {
            return;
        }

        $cms.dom.on(container, 'blur change', function () {
            container.classList.toggle('filledin', $cms.form.findIfChildrenSet(container));
        });
    };

    /**
     * @memberof $cms.form
     * @param container
     * @returns {boolean}
     */
    $cms.form.findIfChildrenSet = function findIfChildrenSet(container) {
        var value, blank = true, el,
            elements = $cms.dom.$$(container, 'input, select, textarea');

        for (var i = 0; i < elements.length; i++) {
            el = elements[i];
            if (((el.type === 'hidden') || ((el.style.display === 'none') && !$cms.form.isWysiwygField(el))) && !el.classList.contains('hidden_but_needed')) {
                continue;
            }
            value = $cms.form.cleverFindValue(el.form, el);
            blank = blank && (value == '');
        }
        return !blank;
    };

    /**
     * Calls up a URL to check something, giving any 'feedback' as an error (or if just 'false' then returning false with no message)
     * @memberof $cms.form
     * @param url
     * @param post
     * @returns {boolean}
     */
    $cms.form.doAjaxFieldTest = function doAjaxFieldTest(url, post) {
        var xhr = $cms.doAjaxRequest(url, null, post);
        if ((xhr.responseText != '') && (xhr.responseText.replace(/[ \t\n\r]/g, '') != '0'/*some cache layers may change blank to zero*/)) {
            if (xhr.responseText !== 'false') {
                if (xhr.responseText.length > 1000) {
                    $cms.log('$cms.form.doAjaxFieldTest()', 'xhr.responseText:', xhr.responseText);
                    $cms.ui.alert(xhr.responseText, null, '{!ERROR_OCCURRED;^}', true);
                } else {
                    $cms.ui.alert(xhr.responseText);
                }
            }
            return false;
        }
        return true;
    };

    /**
     * Marking things (to avoid illegally nested forms
     * @param form
     * @param prefix
     * @returns {boolean}
     */
    $cms.form.addFormMarkedPosts = function addFormMarkedPosts(form, prefix) {
        prefix = strVal(prefix);

        var get = form.method.toLowerCase() === 'get',
            i;

        if (get) {
            for (i = 0; i < form.elements.length; i++) {
                if ((new RegExp('&' + prefix + '\d+=1$', 'g')).test(form.elements[i].name)) {
                    form.elements[i].parentNode.removeChild(form.elements[i]);
                }
            }
        } else {
            // Strip old marks out of the URL
            form.action = form.action.replace('?', '&')
                .replace(new RegExp('&' + prefix + '\d+=1$', 'g'), '')
                .replace('&', '?'); // will just do first due to how JS works
        }

        var checkboxes = $cms.dom.$$('input[type="checkbox"][name^="' + prefix + '"]:checked'),
            append = '';

        for (i = 0; i < checkboxes.length; i++) {
            append += (((append === '') && !form.action.includes('?') && !form.action.includes('/pg/') && !get) ? '?' : '&') + checkboxes[i].name + '=1';
        }

        if (get) {
            var bits = append.split('&');
            for (i = 0; i < bits.length; i++) {
                if (bits[i] !== '') {
                    $cms.dom.append(form, $cms.dom.create('input', {
                        name: bits[i].substr(0, bits[i].indexOf('=1')),
                        type: 'hidden',
                        value: '1'
                    }));
                }
            }
        } else {
            form.action += append;
        }

        return append !== '';
    };


    /**
     * Very simple form control flow
     * @param field
     * @returns {boolean}
     */
    $cms.form.checkFieldForBlankness = function checkFieldForBlankness(field) {
        if (!field) {
            // Shame we need this, seems on Google Chrome things can get confused on JS assigned to page-changing events
            return true;
        }

        var value = field.value,
            errorEl = $cms.dom.$('#error_' + field.id);

        if ((value.trim() === '') || (value === '****') || (value === '{!POST_WARNING;^}') || (value === '{!THREADED_REPLY_NOTICE;^,{!POST_WARNING}}')) {
            if (errorEl !== null) {
                errorEl.style.display = 'block';
                $cms.dom.html(errorEl, '{!REQUIRED_NOT_FILLED_IN;^}');
            }

            $cms.ui.alert('{!IMPROPERLY_FILLED_IN;^}');
            return false;
        }

        if (errorEl != null) {
            errorEl.style.display = 'none';
        }

        return true;
    };

    /**
     * @memberof $cms.form
     * @param form
     * @returns {boolean}
     */
    $cms.form.modsecurityWorkaround = function modsecurityWorkaround(form) {
        var temp_form = document.createElement('form');
        temp_form.method = 'post';

        if (form.target) {
            temp_form.target = form.target;
        }
        temp_form.action = form.action;

        var data = $cms.dom.serialize(form);
        data = _modsecurityWorkaround(data);

        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = '_data';
        input.value = data;
        temp_form.appendChild(input);

        if (form.elements.csrf_token) {
            var csrf_input = document.createElement('input');
            csrf_input.type = 'hidden';
            csrf_input.name = 'csrf_token';
            csrf_input.value = form.elements.csrf_token.value;
            temp_form.appendChild(csrf_input);
        }

        temp_form.style.display = 'none';
        document.body.appendChild(temp_form);

        window.setTimeout(function () {
            temp_form.submit();
            temp_form.parentNode.removeChild(temp_form);
        });

        return false;
    };

    /**
     * @memberof $cms.form
     * @param data
     * @returns {string}
     */
    $cms.form.modsecurityWorkaroundAjax = function modsecurityWorkaroundAjax(data) {
        return '_data=' + encodeURIComponent(_modsecurityWorkaround(data));
    };

    function _modsecurityWorkaround(data) {
        data = strVal(data);

        var remapper = {
                '\\': '<',
                '/': '>',
                '<': '\'',
                '>': '"',
                '\'': '/',
                '"': '\\',
                '%': '&',
                '&': '%',
                '@': ':',
                ':': '@'
            },
            out = '',
            char;
        for (var i = 0; i < data.length; i++) {
            char = data[i];
            if (remapper[char] !== undefined) {
                out += remapper[char];
            } else {
                out += char;
            }
        }
        return out;
    }

}(window.$cms));
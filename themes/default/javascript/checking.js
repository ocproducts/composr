/* Validation code and other general code relating to forms */
(function ($cms) {
    'use strict';

    /**
     * @memberof $cms.form
     * @param radios
     * @returns {string}
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
     * @param theElement
     * @param errorMsg
     */
    $cms.form.setFieldError = function setFieldError(theElement, errorMsg) {
        if (theElement.name !== undefined) {
            var id = theElement.name;
            var errormsgElement = getErrormsgElement(id);
            if ((errorMsg == '') && (id.indexOf('_hour') != -1) || (id.indexOf('_minute') != -1)) { // Do not blank out as day/month/year (which comes first) would have already done it
                return;
            }
            if (errormsgElement) {
                // Make error message visible, if there's an error
                errormsgElement.style.display = (errorMsg == '') ? 'none' : 'block';

                // Changed error message
                if ($cms.dom.html(errormsgElement) != $cms.filter.html(errorMsg)) {
                    $cms.dom.html(errormsgElement, '');
                    if (errorMsg != '') // If there actually an error
                    {
                        theElement.setAttribute('aria-invalid', 'true');

                        // Need to switch tab?
                        var p = errormsgElement;
                        while (p !== null) {
                            p = p.parentNode;
                            if ((errorMsg.substr(0, 5) != '{!DISABLED_FORM_FIELD;^}'.substr(0, 5)) && (p) && (p.getAttribute !== undefined) && (p.getAttribute('id')) && (p.getAttribute('id').substr(0, 2) == 'g_') && (p.style.display == 'none')) {
                                $cms.ui.selectTab('g', p.getAttribute('id').substr(2, p.id.length - 2), false, true);
                                break;
                            }
                        }

                        // Set error message
                        var msgNode = document.createTextNode(errorMsg);
                        errormsgElement.appendChild(msgNode);
                        errormsgElement.setAttribute('role', 'alert');

                        // Fade in
                        $cms.dom.fadeIn(errormsgElement);

                    } else {
                        theElement.setAttribute('aria-invalid', 'false');
                        errormsgElement.setAttribute('role', '');
                    }
                }
            }
        }
        if (($cms.form.isWysiwygField !== undefined) && ($cms.form.isWysiwygField(theElement))) {
            theElement = theElement.parentNode;
        }

        theElement.classList.remove('input_erroneous');

        if (errorMsg != '') {
            theElement.classList.add('input_erroneous');
        }

        function getErrormsgElement(id) {
            var errormsgElement = document.getElementById('error_' + id);

            if (!errormsgElement) {
                errormsgElement = document.getElementById('error_' + id.replace(/\_day$/, '').replace(/\_month$/, '').replace(/\_year$/, '').replace(/\_hour$/, '').replace(/\_minute$/, ''));
            }
            return errormsgElement;
        }
    };

    /**
     * @memberof $cms.form
     * @param form
     * @param event
     * @returns {boolean}
     */
    $cms.form.doFormSubmit = function doFormSubmit(form, event, analyticEventCategory) {
        if (!$cms.form.checkForm(form, false)) {
            return false;
        }

        if (form.oldAction) {
            form.setAttribute('action', form.oldAction);
        }
        if (form.oldTarget) {
            form.setAttribute('target', form.oldTarget);
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
                if (name && ((name.substr(0, 11) === 'label_for__') || (name.substr(0, 14) === 'tick_on_form__') || (name.substr(0, 9) === 'comcode__') || (name.substr(0, 9) === 'require__'))) {
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

        if (!window.justCheckingRequirements) {
            if (analyticEventCategory) {
                $cms.gaTrack(null, analyticEventCategory, null, function () {
                    form.submit();
                });
            } else {
                form.submit();
            }
        }

        $cms.ui.disableSubmitAndPreviewButtons();

        if (window.detectInterval !== undefined) {
            clearInterval(window.detectInterval);
            delete window.detectInterval;
        }

        return true;
    };

    /**
     * @memberof $cms.form
     * @param event
     * @param form
     * @param previewUrl
     * @param hasSeparatePreview
     * @returns {boolean}
     */
    $cms.form.doFormPreview = function doFormPreview(event, form, previewUrl, hasSeparatePreview) {
        hasSeparatePreview = !!hasSeparatePreview;

        if (!$cms.dom.$id('preview_iframe')) {
            $cms.ui.alert('{!ADBLOCKER;^}');
            return false;
        }

        previewUrl += ((window.mobileVersionForPreview === undefined) ? '' : ('&keep_mobile=' + (window.mobileVersionForPreview ? '1' : '0')));

        var oldAction = form.getAttribute('action');

        if (!form.oldAction) {
            form.oldAction = oldAction;
        }
        form.setAttribute('action', /*$cms.maintainThemeInLink - no, we want correct theme images to work*/(previewUrl) + ((form.oldAction.indexOf('&uploading=1') != -1) ? '&uploading=1' : ''));
        var oldTarget = form.getAttribute('target');
        if (!oldTarget) {
            oldTarget = '_top';
        }
        /* not _self due to edit screen being a frame itself */
        if (!form.oldTarget) {
            form.oldTarget = oldTarget;
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

        if (hasSeparatePreview) {
            form.setAttribute('action', form.oldAction + ((form.oldAction.indexOf('?') == -1) ? '?' : '&') + 'preview=1');
            return true;
        }

        $cms.dom.$id('submit_button').style.display = 'inline';

        /* Do our loading-animation */
        if (!window.justCheckingRequirements) {
            setInterval($cms.dom.triggerResize, 500);
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
     * @param theElement
     * @returns {*|boolean}
     */
    $cms.form.isWysiwygField = function isWysiwygField(theElement) {
        var id = theElement.id;
        return window.wysiwygEditors && (typeof window.wysiwygEditors === 'object') && (typeof window.wysiwygEditors[id] === 'object');
    };

    /**
     * @memberof $cms.form
     * @param form
     * @param element
     * @returns {string}
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
     * @param theForm
     * @param forPreview
     * @returns {boolean}
     */
    $cms.form.checkForm = function checkForm(theForm, forPreview) {
        var deleteElement = $cms.dom.$('#delete');
        if ((!forPreview) && (deleteElement != null) && (((deleteElement.classList[0] == 'input_radio') && (deleteElement.value != '0')) || (deleteElement.classList[0] == 'input_tick')) && (deleteElement.checked)) {
            return true;
        }

        var j, theElement, erroneous = false, totalFileSize = 0, alerted = false, errorElement = null, checkResult;
        for (j = 0; j < theForm.elements.length; j++) {
            if (!theForm.elements[j]) {
                continue;
            }

            theElement = theForm.elements[j];

            checkResult = checkField(theElement, theForm, forPreview);
            if (checkResult != null) {
                erroneous = checkResult[0] || erroneous;
                if (!errorElement && erroneous) errorElement = theElement;
                totalFileSize += checkResult[1];
                alerted = checkResult[2] || alerted;

                if (checkResult[0]) {
                    var autoResetError = function autoResetError(theElement) {
                        return function (event, noRecurse) {
                            var checkResult = checkField(theElement, theForm, forPreview);
                            if ((checkResult != null) && (!checkResult[0])) {
                                $cms.form.setFieldError(theElement, '');
                            }

                            if ((!noRecurse) && (theElement.classList.contains('date')) && (theElement.name.match(/_(day|month|year)$/))) {
                                var e = $cms.dom.$id(theElement.id.replace(/\_(day|month|year)$/, '_day'));
                                if (e != theElement) {
                                    e.onblur(event, true);
                                }
                                var e = $cms.dom.$id(theElement.id.replace(/\_(day|month|year)$/, '_month'));
                                if (e != theElement) {
                                    e.onblur(event, true);
                                }
                                var e = $cms.dom.$id(theElement.id.replace(/\_(day|month|year)$/, '_year'));
                                if (e != theElement) {
                                    e.onblur(event, true);
                                }
                            }
                        };
                    };

                    if (theElement.getAttribute('type') == 'radio') {
                        for (var i = 0; i < theForm.elements.length; i++) {
                            theForm.elements[i].onchange = autoResetError(theForm.elements[i]);
                        }
                    } else {
                        theElement.onblur = autoResetError(theElement);
                    }
                }
            }
        }

        if ((totalFileSize > 0) && (theForm.elements['MAX_FILE_SIZE'])) {
            if (totalFileSize > theForm.elements['MAX_FILE_SIZE'].value) {
                if (!erroneous) {
                    errorElement = theElement;
                    erroneous = true;
                }
                if (!alerted) {
                    $cms.ui.alert('{!javascript:TOO_MUCH_FILE_DATA;^}'.replace(new RegExp('\\\\{' + '1' + '\\\\}', 'g'), Math.round(totalFileSize / 1024)).replace(new RegExp('\\\\{' + '2' + '\\\\}', 'g'), Math.round(theForm.elements['MAX_FILE_SIZE'].value / 1024)));
                }
                alerted = true;
            }
        }

        if (erroneous) {
            if (!alerted) $cms.ui.alert('{!IMPROPERLY_FILLED_IN;^}');
            var posy = $cms.dom.findPosY(errorElement, true);
            if (posy == 0) {
                posy = $cms.dom.findPosY(errorElement.parentNode, true);
            }
            if (posy != 0)
                $cms.dom.smoothScroll(posy - 50, null, null, function () {
                    try {
                        errorElement.focus();
                    } catch (e) {}
                    /* Can have exception giving focus on IE for invisible fields */
                });
        }

        // Try and workaround max_input_vars problem if lots of usergroups
        if (!erroneous) {
            var deleteE = $cms.dom.$id('delete');
            var isDelete = deleteE && deleteE.type == 'checkbox' && deleteE.checked;
            var es = document.getElementsByTagName('select'), e;
            for (var i = 0; i < es.length; i++) {
                e = es[i];
                if ((e.name.match(/^access_\d+_privilege_/)) && ((isDelete) || (e.options[e.selectedIndex].value == '-1'))) {
                    e.disabled = true;
                }
            }
        }

        return !erroneous;
    };


    function checkField(theElement, theForm) {
        var i,
            theClass,
            required,
            myValue,
            erroneous = false,
            errorMsg = '',
            regexp,
            totalFileSize = 0,
            alerted = false;

        // No checking for hidden elements
        if (((theElement.type === 'hidden') || (((theElement.style.display === 'none') || (theElement.parentNode.style.display === 'none') || (theElement.parentNode.parentNode.style.display === 'none') || (theElement.parentNode.parentNode.parentNode.style.display === 'none')) && (($cms.form.isWysiwygField === undefined) || (!$cms.form.isWysiwygField(theElement))))) && ((!theElement.className) || (theElement.classList.contains('hidden_but_needed')) == null)) {
            return null;
        }
        if (theElement.disabled) {
            return null;
        }

        // Test file sizes
        if ((theElement.type === 'file') && (theElement.files) && (theElement.files.item) && (theElement.files.item(0)) && (theElement.files.item(0).fileSize)) {
            totalFileSize += theElement.files.item(0).fileSize;
        }

        // Test file types
        if ((theElement.type === 'file') && (theElement.value) && (theElement.name !== 'file_anytype')) {
            var allowedTypes = '{$VALID_FILE_TYPES;^}'.split(/,/),
                typeOk = false,
                theFileType = theElement.value.indexOf('.') ? theElement.value.substr(theElement.value.lastIndexOf('.') + 1) : '{!NONE;^}';

            for (var k = 0; k < allowedTypes.length; k++) {
                if (allowedTypes[k].toLowerCase() === theFileType.toLowerCase()) {
                    typeOk = true;
                }
            }
            if (!typeOk) {
                errorMsg = '{!INVALID_FILE_TYPE;^,xx1xx,{$VALID_FILE_TYPES}}'.replace(/xx1xx/g, theFileType).replace(/<[^>]*>/g, '').replace(/&[lr][sd]quo;/g, '\'').replace(/,/g, ', ');
                if (!alerted) {
                    $cms.ui.alert(errorMsg);
                }
                alerted = true;
            }
        }

        // Fix up bad characters
        if (($cms.browserMatches('ie')) && (theElement.value) && (theElement.localName !== 'select')) {
            var badWordChars = [8216, 8217, 8220, 8221];
            var fixedWordChars = ['\'', '\'', '"', '"'];
            for (i = 0; i < badWordChars.length; i++) {
                regexp = new RegExp(String.fromCharCode(badWordChars[i]), 'gm');
                theElement.value = theElement.value.replace(regexp, fixedWordChars[i]);
            }
        }

        // Class name
        theClass = theElement.classList[0];

        // Find whether field is required and value of it
        if (theElement.type === 'radio') {
            required = (theForm.elements['require__' + theElement.name] !== undefined) && (theForm.elements['require__' + theElement.name].value === '1');
        } else {
            required = theElement.className.includes('_required');
        }

        myValue = $cms.form.cleverFindValue(theForm, theElement);

        // Prepare for custom error messages, stored as HTML5 data on the error message display element
        var errorMsgElement = (theElement.name === undefined) ? null : getErrorMsgElement(theElement.name);

        // Blank?
        if ((required) && (myValue.replace(/&nbsp;/g, ' ').replace(/<br\s*\/?>/g, ' ').replace(/\s/g, '') == '')) {
            errorMsg = '{!REQUIRED_NOT_FILLED_IN;^}';
            if ((errorMsgElement) && (errorMsgElement.getAttribute('data-errorUnfilled') != null) && (errorMsgElement.getAttribute('data-errorUnfilled') != ''))
                errorMsg = errorMsgElement.getAttribute('data-errorUnfilled');
        } else {
            // Standard field-type checks
            if ((theElement.classList.contains('date')) && (theElement.name.match(/_(day|month|year)$/)) && (myValue != '')) {
                var _day = theForm.elements[theElement.name.replace(/\_(day|month|year)$/, '_day')];
                var _month = theForm.elements[theElement.name.replace(/\_(day|month|year)$/, '_month')];
                var _year = theForm.elements[theElement.name.replace(/\_(day|month|year)$/, '_year')];
                if (_day && _month && _year) {
                    var day = _day.options[theForm.elements[theElement.name.replace(/\_(day|month|year)$/, '_day')].selectedIndex].value;
                    var month = _month.options[theForm.elements[theElement.name.replace(/\_(day|month|year)$/, '_month')].selectedIndex].value;
                    var year = _year.options[theForm.elements[theElement.name.replace(/\_(day|month|year)$/, '_year')].selectedIndex].value;
                    var sourceDate = new Date(year, month - 1, day);
                    if (year != sourceDate.getFullYear()) {
                        errorMsg = '{!javascript:NOT_A_DATE;^}';
                    }
                    if (month != sourceDate.getMonth() + 1) {
                        errorMsg = '{!javascript:NOT_A_DATE;^}';
                    }
                    if (day != sourceDate.getDate()) {
                        errorMsg = '{!javascript:NOT_A_DATE;^}';
                    }
                }
            }
            if (((theClass === 'input_email') || (theClass === 'input_email_required')) && (myValue != '') && (!myValue.match(/^[a-zA-Z0-9\._\-\+]+@[a-zA-Z0-9\._\-]+$/))) {
                errorMsg = '{!javascript:NOT_A_EMAIL;^}'.replace('\{1}', myValue);
            }
            if (((theClass === 'input_username') || (theClass === 'input_username_required')) && (myValue != '')) {
                errorMsg = '{!javascript:NOT_USERNAME;^}'.replace('\{1}', myValue);
            }
            if (((theClass === 'input_codename') || (theClass === 'input_codename_required')) && (myValue != '') && (!myValue.match(/^[a-zA-Z0-9\-\._]*$/))) {
                errorMsg = '{!javascript:NOT_CODENAME;^}'.replace('\{1}', myValue);
            }
            if (((theClass === 'input_integer') || (theClass === 'input_integer_required')) && (myValue != '') && (parseInt(myValue, 10) != myValue - 0)) {
                errorMsg = '{!javascript:NOT_INTEGER;^}'.replace('\{1}', myValue);
            }
            if (((theClass === 'input_float') || (theClass === 'input_float_required')) && (myValue != '') && (parseFloat(myValue) != myValue - 0)) {
                errorMsg = '{!javascript:NOT_FLOAT;^}'.replace('\{1}', myValue);
            }

            // Shim for HTML5 regexp patterns
            if (theElement.getAttribute('pattern')) {
                if ((myValue !== '') && (!myValue.match(new RegExp(theElement.getAttribute('pattern'))))) {
                    errorMsg = '{!javascript:PATTERN_NOT_MATCHED;^}'.replace('\{1}', myValue);
                }
            }

            // Custom error messages
            if ((errorMsg != '') && (errorMsgElement != null)) {
                var customMsg = errorMsgElement.getAttribute('data-errorRegexp');
                if ((customMsg != null) && (customMsg != '')) {
                    errorMsg = customMsg;
                }
            }
        }

        // Show error?
        $cms.form.setFieldError(theElement, errorMsg);

        if ((errorMsg != '') && (!erroneous)) {
            erroneous = true;
        }

        return [erroneous, totalFileSize, alerted];

        function getErrorMsgElement(id) {
            var errorMsgElement = $cms.dom.$id('error_' + id);
            if (!errorMsgElement) {
                errorMsgElement = $cms.dom.$id('error_' + id.replace(/\_day$/, '').replace(/\_month$/, '').replace(/\_year$/, '').replace(/\_hour$/, '').replace(/\_minute$/, ''));
            }
            return errorMsgElement;
        }
    }

    /**
     * @memberof $cms.form
     * @param field
     * @param isLocked
     * @param chosenOb
     */
    $cms.form.setLocked = function setLocked(field, isLocked, chosenOb) {
        var radioButton = $cms.dom.$id('choose_' + field.name.replace(/\[\]$/, ''));
        if (!radioButton) {
            radioButton = $cms.dom.$id('choose_' + field.name.replace(/\_\d+$/, '_'));
        }

        // For All-and-not,Line-multi,Compound-Tick,Radio-List,Date/Time: $cms.form.setLocked assumes that the calling code is clever
        // special input types are coded to observe their master input field readonly status)
        var button = $cms.dom.$id('uploadButton_' + field.name.replace(/\[\]$/, ''));

        if (isLocked) {
            var labels = document.getElementsByTagName('label'), label = null;
            for (var i = 0; i < labels.length; i++) {
                if (chosenOb && (labels[i].getAttribute('for') == chosenOb.id)) {
                    label = labels[i];
                    break;
                }
            }
            if (!radioButton) {
                if (label) {
                    var labelNice = $cms.dom.html(label).replace('&raquo;', '').replace(/^\s*/, '').replace(/\s*$/, '');
                    if (field.type == 'file') {
                        $cms.form.setFieldError(field, '{!DISABLED_FORM_FIELD_ENCHANCEDMSG_UPLOAD;^}'.replace(/\{1\}/, labelNice));
                    } else {
                        $cms.form.setFieldError(field, '{!DISABLED_FORM_FIELD_ENCHANCEDMSG;^}'.replace(/\{1\}/, labelNice));
                    }
                } else {
                    $cms.form.setFieldError(field, '{!DISABLED_FORM_FIELD;^}');
                }
            }
            field.classList.remove('input_erroneous');
        } else if (!radioButton) {
            $cms.form.setFieldError(field, '');
        }
        field.disabled = isLocked;

        if (button) {
            button.disabled = isLocked;
        }
    };

    /**
     * @memberof $cms.form
     * @param fieldName
     * @param isRequired
     */
    $cms.form.setRequired = function setRequired(fieldName, isRequired) {
        var radioButton = $cms.dom.$('#choose_' + fieldName);

        isRequired = !!isRequired;

        if (!radioButton) {
            var requiredA = $cms.dom.$('#form_table_field_name__' + fieldName),
                requiredB = $cms.dom.$('#required_readable_marker__' + fieldName),
                requiredC = $cms.dom.$('#required_posted__' + fieldName),
                requiredD = $cms.dom.$('#form_table_field_input__' + fieldName);

            if (requiredA) {
                requiredA.className = 'form_table_field_name';

                if (isRequired) {
                    requiredA.classList.add('required');
                }
            }

            if (requiredB) {
                $cms.dom.toggle(requiredB, isRequired);
            }

            if (requiredC) {
                requiredC.value = isRequired ? 1 : 0;
            }

            if (requiredD) {
                requiredD.className = 'form_table_field_input';
            }
        }

        var element = $cms.dom.$('#' + fieldName);

        if (element) {
            element.className = element.className.replace(/(input_[a-z_]+)_required/g, '$1');

            if (isRequired) {
                element.className = element.className.replace(/(input_[a-z_]+)/g, '$1_required');
            }

            if (element.pluploadObject) {
                element.pluploadObject.settings.required = isRequired;
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
                    if (!elements[i].href.toLowerCase().startsWith('javascript:') && (elements[i].target !== '_self') && (elements[i].target !== '_blank')) { // guard due to JS actions still opening new window in some browsers
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
     * Very simple form control flow
     * @param field
     * @returns {boolean}
     */
    $cms.form.checkFieldForBlankness = function checkFieldForBlankness(field, alreadyShownMessage) {
        if (!field) {
            // Things can get confused on JS assigned to page-changing events
            return true;
        }

        var value = field.value,
            errorEl = $cms.dom.$('#error_' + field.id);

        if ((value.trim() === '') || (value === '{!POST_WARNING;^}') || (value === '{!THREADED_REPLY_NOTICE;^,{!POST_WARNING}}')) {
            if (errorEl !== null) {
                errorEl.style.display = 'block';
                $cms.dom.html(errorEl, '{!REQUIRED_NOT_FILLED_IN;^}');
            }

            if (!already_shown_message) {
                $cms.ui.alert('{!IMPROPERLY_FILLED_IN;^}');
            }

            return false;
        }

        if (errorEl != null) {
            errorEl.style.display = 'none';
        }

        return true;
    };

}(window.$cms));

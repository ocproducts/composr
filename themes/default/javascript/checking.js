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
        errorMsg = strVal(errorMsg);
        
        if (theElement.name !== undefined) {
            var id = theElement.name,
                errorMsgElement = getErrorMsgElement(id);
            
            if ((errorMsg === '') && (id.includes('_hour')) || (id.includes('_minute'))) { // Do not blank out as day/month/year (which comes first) would have already done it
                return;
            }
            
            if (errorMsgElement) {
                // Make error message visible, if there's an error
                errorMsgElement.style.display = (errorMsg === '') ? 'none' : 'block';

                // Changed error message
                if ($cms.dom.html(errorMsgElement) !== $cms.filter.html(errorMsg)) {
                    $cms.dom.html(errorMsgElement, '');
                    if (errorMsg !== '') {// If there actually an error
                        theElement.setAttribute('aria-invalid', 'true');

                        // Need to switch tab?
                        var p = errorMsgElement;
                        while (p != null) {
                            p = p.parentNode;
                            if ((errorMsg.substr(0, 5) !== '{!DISABLED_FORM_FIELD;^}'.substr(0, 5)) && (p) && (p.getAttribute !== undefined) && (p.getAttribute('id')) && (p.getAttribute('id').substr(0, 2) === 'g_') && (p.style.display === 'none')) {
                                $cms.ui.selectTab('g', p.getAttribute('id').substr(2, p.id.length - 2), false, true);
                                break;
                            }
                        }

                        // Set error message
                        var msgNode = document.createTextNode(errorMsg);
                        errorMsgElement.appendChild(msgNode);
                        errorMsgElement.setAttribute('role', 'alert');

                        // Fade in
                        $cms.dom.fadeIn(errorMsgElement);

                    } else {
                        theElement.setAttribute('aria-invalid', 'false');
                        errorMsgElement.setAttribute('role', '');
                    }
                }
            }
        }
        
        if ($cms.form.isWysiwygField(theElement)) {
            theElement = theElement.parentNode;
        }

        theElement.classList.toggle('input_erroneous', (errorMsg !== ''));

        function getErrorMsgElement(id) {
            var errorMsgElement = document.getElementById('error_' + id);

            if (!errorMsgElement) {
                errorMsgElement = document.getElementById('error_' + id.replace(/\_day$/, '').replace(/\_month$/, '').replace(/\_year$/, '').replace(/\_hour$/, '').replace(/\_minute$/, ''));
            }
            return errorMsgElement;
        }
    };

    /**
     * @memberof $cms.form
     * @param form
     * @param analyticEventCategory
     * @returns {boolean}
     */
    $cms.form.doFormSubmit = function doFormSubmit(form, analyticEventCategory) {
        return new Promise(function (resolveSubmitPromise) {
            var checkFormPromise = $cms.form.checkForm(form, false);
            
            checkFormPromise.then(function (valid) {
                if (!valid) {
                    return resolveSubmitPromise(false);
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
                    var i, name, elements = arrVal(form.elements);

                    for (i = 0; i < elements.length; i++) {
                        name = elements[i].name;
                        if (name && ((name.substr(0, 11) === 'label_for__') || (name.substr(0, 14) === 'tick_on_form__') || (name.substr(0, 9) === 'comcode__') || (name.substr(0, 9) === 'require__'))) {
                            elements[i].parentNode.removeChild(elements[i]);
                        }
                    }
                }

                if ($cms.dom.trigger(form, 'submit') === false) {
                    return resolveSubmitPromise(false);
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

                return resolveSubmitPromise(true);
            });
        });
    };

    /**
     * @memberof $cms.form
     * @param { HTMLFormElement } form
     * @param {string} previewUrl
     * @param {boolean} hasSeparatePreview
     * @returns { Promise }
     */
    $cms.form.doFormPreview = function doFormPreview(form, previewUrl, hasSeparatePreview) {
        previewUrl = strVal(previewUrl);
        hasSeparatePreview = Boolean(hasSeparatePreview);

        return new Promise(function (resolvePreviewPromise) {
            if (!$cms.dom.$id('preview_iframe')) {
                $cms.ui.alert('{!ADBLOCKER;^}');
                return resolvePreviewPromise(false);
            }

            previewUrl += ((window.mobileVersionForPreview === undefined) ? '' : ('&keep_mobile=' + (window.mobileVersionForPreview ? '1' : '0')));

            var oldAction = form.getAttribute('action');

            if (!form.oldAction) {
                form.oldAction = oldAction;
            }
            form.setAttribute('action', /*$cms.maintainThemeInLink - no, we want correct theme images to work*/(previewUrl) + (form.oldAction.includes('&uploading=1') ? '&uploading=1' : ''));
            var oldTarget = form.getAttribute('target');
            if (!oldTarget) {
                oldTarget = '_top';
            }
            /* not _self due to edit screen being a frame itself */
            if (!form.oldTarget) {
                form.oldTarget = oldTarget;
            }
            form.setAttribute('target', 'preview_iframe');

            var checkFormPromise = $cms.form.checkForm(form, true);

            checkFormPromise.then(function (valid) {
                if (!valid) {
                    return resolvePreviewPromise(false);
                }

                if ($cms.dom.trigger(form, { type: 'submit', triggeredByDoFormPreview: true }) === false) {
                    return resolvePreviewPromise(false);
                }

                if (hasSeparatePreview) {
                    form.setAttribute('action', form.oldAction + (form.oldAction.includes('?') ? '&' : '?') + 'preview=1');
                    return resolvePreviewPromise(true);
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
                    window.wysiwygSetReadonly('post', true);
                }

                return resolvePreviewPromise(true);
            });
        });
    };

    /**
     * @memberof $cms.form
     * @param el
     * @returns {boolean}
     */
    $cms.form.isWysiwygField = function isWysiwygField(el) {
        return (window.wysiwygEditors != null) && (typeof window.wysiwygEditors === 'object') && (window.wysiwygEditors[el.id] != null) && (typeof window.wysiwygEditors[el.id] === 'object');
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
                value = (window.getTextbox === undefined) ? element.value : window.getTextbox(element);
                break;
            case 'select':
                value = '';
                if (element.selectedIndex >= 0) {
                    if (element.multiple) {
                        for (var i = 0; i < element.options.length; i++) {
                            if (element.options[i].selected) {
                                if (value !== '') {
                                    value += ',';
                                }
                                value += element.options[i].value;
                            }
                        }
                    } else if (element.selectedIndex >= 0) {
                        value = element.options[element.selectedIndex].value;
                        if ((value === '') && (element.getAttribute('size') > 1)) {
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
    
    var _lastChangeTimes = {};
    /**
     * @param form
     * @returns { Date }
     */
    $cms.form.lastChangeTime = function lastChangeTime(form) {
        var uid = $cms.uid(form);
        
        if (_lastChangeTimes[uid] === undefined) {
            _lastChangeTimes[uid] = new Date();
            
            $cms.dom.on(form, 'input change reset', function () {
                _lastChangeTimes[uid] = new Date();
            });
        }

        return _lastChangeTimes[uid];
    };
    
    /**
     * @memberof $cms.form
     * @param { HTMLFormElement } theForm
     * @param {boolean} [forPreview]
     * @returns {boolean|Promise<boolean>}
     */
    $cms.form.checkForm = function checkForm(theForm, forPreview) {
        var deleteElement = $cms.dom.$('#delete');
        
        if (!forPreview && (deleteElement != null) && (((deleteElement.classList[0] === 'input_radio') && (deleteElement.value !== '0')) || (deleteElement.classList[0] === 'input_tick')) && (deleteElement.checked)) {
            return Promise.resolve(true);
        }
        
        return  new Promise(function (resolveCheckFormPromise) {
            var erroneous = false, 
                totalFileSize = 0, alerted = false, 
                errorElement = null,
                theElements = arrVal(theForm.elements),
                fieldCheckPromiseCalls = [];
            
            theElements.forEach(function (theElement) {
                fieldCheckPromiseCalls.push(function () {
                    var checkResult = checkField(theElement, theForm);

                    return checkResult.then(function (result) {
                        if (result != null) {
                            erroneous = result.erroneous || erroneous;
                            if (!errorElement && erroneous) {
                                errorElement = theElement;
                            }
                            totalFileSize += result.totalFileSize;
                            alerted = result.alerted || alerted;

                            if (result.erroneous) {
                                if (theElement.type === 'radio') {
                                    for (var i = 0; i < theForm.elements.length; i++) {
                                        theForm.elements[i].onchange = autoResetError;
                                    }
                                } else {
                                    theElement.onblur = autoResetError;
                                }
                            }
                        }
                    });
                });
            });
            
            $cms.promiseSequence(fieldCheckPromiseCalls).then(function () {
                if ((totalFileSize > 0) && (theForm.elements['MAX_FILE_SIZE']) && (totalFileSize > theForm.elements['MAX_FILE_SIZE'].value)) {
                    if (!erroneous) {
                        errorElement = theElements[theElements.length - 1];
                        erroneous = true;
                    }
                    if (!alerted) {
                        $cms.ui.alert('{!javascript:TOO_MUCH_FILE_DATA;^}'.replace(new RegExp('\\\\{' + '1' + '\\\\}', 'g'), Math.round(totalFileSize / 1024)).replace(new RegExp('\\\\{' + '2' + '\\\\}', 'g'), Math.round(theForm.elements['MAX_FILE_SIZE'].value / 1024)));
                        alerted = true;
                    }
                }

                if (erroneous) {
                    if (!alerted) {
                        $cms.ui.alert({ notice: '{!IMPROPERLY_FILLED_IN;^}', single: true });
                    }
                    var posy = $cms.dom.findPosY(errorElement, true);
                    if (posy === 0) {
                        posy = $cms.dom.findPosY(errorElement.parentNode, true);
                    }
                    if (posy !== 0) {
                        $cms.dom.smoothScroll(posy - 50, null, null, function () {
                            try {
                                errorElement.focus();
                            } catch (e) {}
                            /* Can have exception giving focus on IE for invisible fields */
                        });
                    }
                }

                // Try and workaround max_input_vars problem if lots of usergroups
                if (!erroneous) {
                    var deleteE = $cms.dom.$id('delete'),
                        isDelete = deleteE && deleteE.type === 'checkbox' && deleteE.checked,
                        es = document.getElementsByTagName('select'), selectEl;

                    for (var k = 0; k < es.length; k++) {
                        selectEl = es[k];
                        if ((selectEl.name.match(/^access_\d+_privilege_/)) && ((isDelete) || (selectEl.options[selectEl.selectedIndex].value === '-1'))) {
                            selectEl.disabled = true;
                        }
                    }
                }

                resolveCheckFormPromise(!erroneous);
            });
        });
        
        function autoResetError(e, noRecurse) {
            var theElement = this,
                checkResult = checkField(theElement, theForm);

            checkResult.then(function (result) {
                if ((result != null) && !result.erroneous) {
                    $cms.form.setFieldError(theElement, '');
                }

                if (!noRecurse && (theElement.classList.contains('date')) && (theElement.name.match(/_(day|month|year)$/))) {
                    var preid = theElement.id.replace(/\_(day|month|year)$/, ''),
                        el = $cms.dom.$id(preid + '_day');
                    if (el !== theElement) {
                        autoResetError.call(el, null, true);
                    }
                    el = $cms.dom.$id(preid + '_month');
                    if (el !== theElement) {
                        autoResetError.call(el, null, true);
                    }
                    el = $cms.dom.$id(preid + '_year');
                    if (el !== theElement) {
                        autoResetError.call(el, null, true);
                    }
                }
            });
        }
    };

    /**
     * @param theElement
     * @param theForm
     * @return { Promise }
     */
    function checkField(theElement, theForm) {
        return new Promise(function (resolveCheckFieldPromise) {
            var i, theClass, required, myValue,
                erroneous = false,
                errorMsg = '',
                regexp,
                totalFileSize = 0,
                alerted = false;
            
            // No checking for hidden elements
            if (((theElement.type === 'hidden') || (((theElement.style.display === 'none') || (theElement.parentNode.style.display === 'none') || (theElement.parentNode.parentNode.style.display === 'none') || (theElement.parentNode.parentNode.parentNode.style.display === 'none')) && (!$cms.form.isWysiwygField(theElement)))) && (!theElement.classList.contains('hidden_but_needed'))) {
                return resolveCheckFieldPromise(null);
            }
            if (theElement.disabled) {
                return resolveCheckFieldPromise(null);
            }

            // Test file sizes
            if ((theElement.type === 'file') && (theElement.files) && (theElement.files.item) && (theElement.files.item(0)) && (theElement.files.item(0).fileSize)) {
                totalFileSize += theElement.files.item(0).fileSize;
            }

            // Test file types
            if ((theElement.type === 'file') && (theElement.value) && (theElement.name !== 'file_anytype')) {
                var allowedTypes = '{$VALID_FILE_TYPES;^}'.split(/,/),
                    typeOk = false,
                    theFileType = theElement.value.includes('.') ? theElement.value.substr(theElement.value.lastIndexOf('.') + 1) : '{!NONE;^}';

                for (var k = 0; k < allowedTypes.length; k++) {
                    if (allowedTypes[k].toLowerCase() === theFileType.toLowerCase()) {
                        typeOk = true;
                    }
                }
                if (!typeOk) {
                    errorMsg = $cms.format('{!INVALID_FILE_TYPE;^}', [theFileType, '{$VALID_FILE_TYPES}']).replace(/<[^>]*>/g, '').replace(/&[lr][sd]quo;/g, '\'').replace(/,/g, ', ');
                    if (!alerted) {
                        $cms.ui.alert(errorMsg);
                        alerted = true;
                    }
                }
            }

            // Fix up bad characters
            if (($cms.browserMatches('ie')) && (theElement.value) && (theElement.localName !== 'select')) {
                var badWordChars = [8216, 8217, 8220, 8221],
                    fixedWordChars = ['\'', '\'', '"', '"'];
                
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
            var errorMsgElement = (theElement.name === undefined) ? null : getErrorMsgElement(theElement.name),
                isBlank = (required && (myValue.replace(/&nbsp;/g, ' ').replace(/<br\s*\/?>/g, ' ').replace(/\s/g, '') === '')),
                validatePromise = Promise.resolve();
            
            // Blank?
            if (isBlank) {
                errorMsg = '{!REQUIRED_NOT_FILLED_IN;^}';
            } else {
                // Standard field-type checks
                if ((theElement.classList.contains('date')) && (theElement.name.match(/_(day|month|year)$/)) && (myValue !== '')) {
                    var prename = theElement.name.replace(/\_(day|month|year)$/, ''),
                        _day = theForm.elements[prename + '_day'],
                        _month = theForm.elements[prename + '_month'],
                        _year = theForm.elements[prename + '_year'];
                    
                    if (_day && _month && _year) {
                        var day = _day.options[theForm.elements[prename + '_day'].selectedIndex].value,
                            month = _month.options[theForm.elements[prename + '_month'].selectedIndex].value,
                            year = _year.options[theForm.elements[prename + '_year'].selectedIndex].value,
                            sourceDate = new Date(year, month - 1, day);
                        
                        if (Number(year) !== sourceDate.getFullYear()) {
                            errorMsg = '{!javascript:NOT_A_DATE;^}';
                        }
                        if (Number(month) !== (sourceDate.getMonth() + 1)) {
                            errorMsg = '{!javascript:NOT_A_DATE;^}';
                        }
                        if (Number(day) !== sourceDate.getDate()) {
                            errorMsg = '{!javascript:NOT_A_DATE;^}';
                        }
                    }
                }

                // Shim for HTML5 regexp patterns
                if (theElement.getAttribute('pattern') && (myValue !== '') && (!myValue.match(new RegExp(theElement.getAttribute('pattern'))))) {
                    errorMsg = $cms.format('{!javascript:PATTERN_NOT_MATCHED;^}', [myValue]);
                } else if (((theClass === 'input_username') || (theClass === 'input_username_required')) && (myValue !== '') && (myValue !== '****')) {
                    validatePromise = $cms.form.doAjaxFieldTest('{$FIND_SCRIPT_NOHTTP;,username_exists}?username=' + encodeURIComponent(myValue)).then(function (exists) {
                        if (!exists) {
                            errorMsg = $cms.format('{!javascript:NOT_USERNAME;^}', [myValue]);
                        }
                    });
                } else if (((theClass === 'input_email') || (theClass === 'input_email_required')) && (myValue !== '') && (!myValue.match(/^[a-zA-Z0-9\._\-\+]+@[a-zA-Z0-9\._\-]+$/))) {
                    errorMsg = $cms.format('{!javascript:NOT_A_EMAIL;^}', [myValue]);
                } else if (((theClass === 'input_codename') || (theClass === 'input_codename_required')) && (myValue !== '') && (!myValue.match(/^[a-zA-Z0-9\-\._]*$/))) {
                    errorMsg = $cms.format('{!javascript:NOT_CODENAME;^}', [myValue]);
                } else if (((theClass === 'input_integer') || (theClass === 'input_integer_required')) && (myValue !== '') && (parseInt(myValue, 10) !== Number(myValue))) {
                    errorMsg = $cms.format('{!javascript:NOT_INTEGER;^}', [myValue]);
                } else if (((theClass === 'input_float') || (theClass === 'input_float_required')) && (myValue !== '') && (parseFloat(myValue) !== Number(myValue))) {
                    errorMsg = $cms.format('{!javascript:NOT_FLOAT;^}', [myValue]);
                }
            }

            validatePromise.then(function () {
                if ((errorMsg !== '') && errorMsgElement && errorMsgElement.getAttribute('data-errorRegexp')) { // Custom error message?
                    errorMsg = errorMsgElement.getAttribute('data-errorRegexp');
                }

                // Show error?
                $cms.form.setFieldError(theElement, errorMsg);

                if ((errorMsg !== '') && !erroneous) {
                    erroneous = true;
                }

                resolveCheckFieldPromise({
                    erroneous: erroneous,
                    totalFileSize: totalFileSize,
                    alerted: alerted
                });
            });
        });

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
                if (chosenOb && (labels[i].getAttribute('for') === chosenOb.id)) {
                    label = labels[i];
                    break;
                }
            }
            if (!radioButton) {
                if (label) {
                    var labelNice = $cms.dom.html(label).replace('&raquo;', '').replace(/^\s*/, '').replace(/\s*$/, '');
                    if (field.type === 'file') {
                        $cms.form.setFieldError(field, $cms.format('{!DISABLED_FORM_FIELD_ENCHANCEDMSG_UPLOAD;^}', [labelNice]));
                    } else {
                        $cms.form.setFieldError(field, $cms.format('{!DISABLED_FORM_FIELD_ENCHANCEDMSG;^}', [labelNice]));
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
        fieldName = strVal(fieldName);
        isRequired = Boolean(isRequired);
        
        var radioButton = $cms.dom.$('#choose_' + fieldName);

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
            blank = blank && (value === '');
        }
        return !blank;
    };


    /**
     * Very simple form control flow
     * @param field
     * @param alreadyShownMessage
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

            if (!alreadyShownMessage) {
                $cms.ui.alert({ notice: '{!IMPROPERLY_FILLED_IN;^}', single: true });
            }

            return false;
        }

        if (errorEl != null) {
            errorEl.style.display = 'none';
        }

        return true;
    };

}(window.$cms));

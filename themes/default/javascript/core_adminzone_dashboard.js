(function ($cms) {
    'use strict';

    var $IMG_checklist_checklist1 = '{$IMG;,checklist/checklist1}',
        $IMG_checklist_not_completed = '{$IMG;,checklist/not_completed}',
        $IMG_checklist_cross = '{$IMG;,checklist/cross}',
        $IMG_checklist_cross2 = '{$IMG;,checklist/cross2}',
        $IMG_checklist_toggleicon2 = '{$IMG;,checklist/toggleicon2}';

    var $SCRIPT_comcode_convert = '{$FIND_SCRIPT_NOHTTP;,comcode_convert}';

    /**
     * @memberof $cms.views
     * @class BlockMainStaffChecklistCustomTask
     * @extends $cms.View
     */
    function BlockMainStaffChecklistCustomTask() {
        BlockMainStaffChecklistCustomTask.base(this, 'constructor', arguments);

        this.imgChecklistCross = this.$('.js-img-checklist-cross');
        this.imgChecklistStatus = this.$('.js-img-checklist-status');
    }

    $cms.inherits(BlockMainStaffChecklistCustomTask, $cms.View, /**@lends BlockMainStaffChecklistCustomTask#*/{
        events: function () {
            return {
                'mouseover': 'mouseover',
                'mouseout': 'mouseout',

                'click .js-click-confirm-delete': 'confirmDelete',
                'click .js-click-mark-task': 'markTask',
                'keypress .js-keypress-mark-task': 'markTask'
            };
        },

        mouseover: function () {
            this.imgChecklistCross.src = $IMG_checklist_cross2;
        },

        mouseout: function () {
            this.imgChecklistCross.src = $IMG_checklist_cross;
        },

        markTask: function (e) {
            var data = this.el.dataset,
                id = encodeURIComponent(this.params.id);

            // Prevent events on the delete link from triggering this function
            if (this.$closest(e.target, '.js-click-confirm-delete')) {
                return;
            }

            if (data.vwTaskDone === 'not_completed') {
                $cms.loadSnippet('checklist_task_manage', 'type=mark_done&id=' + id, true);
                this.imgChecklistStatus.src = $IMG_checklist_checklist1;
                data.vwTaskDone = 'checklist1';
            } else {
                $cms.loadSnippet('checklist_task_manage', 'type=mark_undone&id=' + id, true);
                this.imgChecklistStatus.src = $IMG_checklist_not_completed;
                data.vwTaskDone = 'not_completed';
            }
        },

        confirmDelete: function () {
            var viewEl = this.el,
                params = this.params,
                message = params.confirmDeleteMessage,
                id = encodeURIComponent(params.id);

            $cms.ui.confirm(message, function (result) {
                if (result) {
                    $cms.loadSnippet('checklist_task_manage', 'type=delete&id=' + id, true);
                    $cms.dom.hide(viewEl);
                }
            });
        }
    });

    /**
     * @memberof $cms.views
     * @class BlockMainStaffLinks
     * @extends $cms.View
     */
    function BlockMainStaffLinks() {
        BlockMainStaffLinks.base(this, 'constructor', arguments);
    }

    $cms.inherits(BlockMainStaffLinks, $cms.View, /**@lends BlockMainStaffLinks#*/{
        events: function () {
            return {
                'click .js-click-staff-block-flip': 'staffBlockFlip',
                'click .js-click-form-submit-headless': 'submitHeadless'
            };
        },
        staffBlockFlip: function () {
            var rand = this.params.randStaffLinks,
                show = this.$('#staff_links_list_' + rand + '_form'),
                hide = this.$('#staff_links_list_' + rand),
                isHideDisplayed = $cms.dom.isDisplayed(hide);

            $cms.dom.toggleWithAria(show, isHideDisplayed);
            $cms.dom.toggleWithAria(hide, !isHideDisplayed);
        },
        submitHeadless: function (e, btn) {
            var form = btn.form,
                blockName = $cms.filter.nl(this.params.blockName),
                map = $cms.filter.nl(this.params.map);

            e.preventDefault();

            ajaxFormSubmitAdminHeadless(form, blockName, map).then((function (submitForm) {
                if (submitForm) {
                    $cms.dom.submit(form);
                }
            }).bind(this));
        }
    });

    /**
     * @memberof $cms.views
     * @class BlockMainStaffWebsiteMonitoring
     * @extends $cms.View
     */
    function BlockMainStaffWebsiteMonitoring() {
        BlockMainStaffWebsiteMonitoring.base(this, 'constructor', arguments);

        var rand = this.params.randWebsiteMonitoring;

        this.tableEl = this.$('#website_monitoring_list_' + rand);
        this.formEl = this.$('.js-form-site-watchlist');
    }

    $cms.inherits(BlockMainStaffWebsiteMonitoring, $cms.View, /**@lends BlockMainStaffWebsiteMonitoring#*/{
        events: function () {
            return {
                'click .js-click-staff-block-flip': 'staffBlockFlip',
                'click .js-click-headless-submit': 'headlessSubmit'
            };
        },

        staffBlockFlip: function () {
            var isTableDisplayed = $cms.dom.isDisplayed(this.tableEl);

            $cms.dom.toggleWithAria(this.formEl, isTableDisplayed);
            $cms.dom.toggleWithAria(this.tableEl, !isTableDisplayed);
        },

        headlessSubmit: function (e) {
            var blockName = $cms.filter.nl(this.params.blockName),
                map = $cms.filter.nl(this.params.map);

            e.preventDefault();

            ajaxFormSubmitAdminHeadless(this.formEl, blockName, map).then((function (submitForm) {
                if (submitForm) {
                    $cms.dom.submit(this.formEl);
                }
            }).bind(this));
        }
    });

    /**
     * @memberof $cms.views
     * @class BlockMainNotes
     * @extends $cms.View
     */
    function BlockMainNotes() {
        BlockMainNotes.base(this, 'constructor', arguments);
        this.formEl = this.$('.js-form-block-main-notes');
    }

    $cms.inherits(BlockMainNotes, $cms.View, /**@lends BlockMainNotes#*/{
        events: function () {
            return {
                'click .js-click-headless-submit': 'headlessSubmit',
                'focus .js-focus-textarea-expand': 'textareaExpand',
                'blur .js-blur-textarea-contract': 'textareaContract',
                'mouseover .js-hover-disable-textarea-size-change': 'disableTextareaSizeChange',
                'mouseout .js-hover-disable-textarea-size-change': 'disableTextareaSizeChange'
            };
        },

        headlessSubmit: function (e) {
            var blockName = $cms.filter.nl(this.params.blockName),
                map = $cms.filter.nl(this.params.map);

            e.preventDefault();

            ajaxFormSubmitAdminHeadless(this.formEl, blockName, map).then((function (submitForm) {
                if (submitForm) {
                    $cms.dom.submit(this.formEl);
                }
            }).bind(this));
        },

        textareaExpand: function (e, textarea){
            textarea.setAttribute('rows', '23');
        },

        textareaContract: function (e, textarea){
            if (!this.formEl.disableSizeChange) {
                textarea.setAttribute('rows', '10');
            }
        },

        disableTextareaSizeChange: function (e) {
            this.formEl.disableSizeChange = (e.type === 'mouseover');
        }
    });

    $cms.views.BlockMainStaffChecklistCustomTask = BlockMainStaffChecklistCustomTask;
    $cms.views.BlockMainStaffLinks = BlockMainStaffLinks;
    $cms.views.BlockMainStaffWebsiteMonitoring = BlockMainStaffWebsiteMonitoring;
    $cms.views.BlockMainNotes = BlockMainNotes;

    $cms.templates.blockMainStaffChecklist = function (params, container) {
        var showAllLink = document.getElementById('checklist_show_all_link'),
            hideDoneLink = document.getElementById('checklist_hide_done_link');

        setTaskHiding(true);

        $cms.dom.on(container, 'click', '.js-click-enable-task-hiding', function () {
            setTaskHiding(true);
        });

        $cms.dom.on(container, 'click', '.js-click-disable-task-hiding', function () {
            setTaskHiding(false);
        });

        $cms.dom.on(container, 'submit', '.js-submit-custom-task', function (e, form) {
            submitCustomTask(form);
        });

        function setTaskHiding(hideEnable) {
            hideEnable = !!hideEnable;

            new Image().src = $IMG_checklist_cross2;
            new Image().src = $IMG_checklist_toggleicon2;

            var i, checklistRows = document.querySelectorAll('.checklist_row'), rowImgs, src;

            for (i = 0; i < checklistRows.length; i++) {
                rowImgs = checklistRows[i].querySelectorAll('img');
                if (hideEnable) {
                    src = rowImgs[rowImgs.length - 1].getAttribute('src');
                    if (rowImgs[rowImgs.length - 1].origsrc) {
                        src = rowImgs[rowImgs.length - 1].origsrc;
                    }
                    if (src && src.includes('checklist1')) {
                        $cms.dom.hide(checklistRows[i]);
                        checklistRows[i].classList.add('task_hidden');
                    } else {
                        checklistRows[i].classList.remove('task_hidden');
                    }
                } else {
                    if (!$cms.dom.isDisplayed(checklistRows[i])) {
                        $cms.dom.fadeIn(checklistRows[i]);
                    }
                    $cms.dom.show(checklistRows[i]);
                    checklistRows[i].classList.remove('task_hidden');
                }
            }

            $cms.dom.toggle(showAllLink, hideEnable);
            $cms.dom.toggle(hideDoneLink, !hideEnable);
        }

        function submitCustomTask(form) {
            $cms.loadSnippet('checklist_task_manage', 'type=add&recur_every=' + encodeURIComponent(form.elements['recur_every'].value) + '&recur_interval=' + encodeURIComponent(form.elements['recur_interval'].value) + '&task_title=' + encodeURIComponent(form.elements['newTask'].value), true).then(function (newTask) {
                form.elements['recur_every'].value = '';
                form.elements['recur_interval'].value = '';
                form.elements['new_task'].value = '';

                $cms.dom.append(document.getElementById('custom_tasks_go_here'), newTask);
            });
        }
    };

    $cms.templates.blockMainStaffActions = function (params) {
        $cms.dom.internaliseAjaxBlockWrapperLinks(params.blockCallUrl, document.getElementById(params.wrapperId), ['.*'], {}, false, true);
    };

    $cms.templates.blockMainStaffTips = function (params) {
        $cms.dom.internaliseAjaxBlockWrapperLinks(params.blockCallUrl, document.getElementById(params.wrapperId), ['^staff_tips_dismiss$', '^rand$'/*cache breaker*/], {}, false, true, false);
    };

    $cms.templates.blockMainStaffChecklistItem = function blockMainStaffChecklistItem(params, container) {
        var $IMG_checklist_toggleicon = $cms.img('{$IMG;,checklist/toggleicon}'),
            $IMG_checklist_toggleicon2 = $cms.img('{$IMG;,checklist/toggleicon2}');

        $cms.dom.on(container, 'mouseover mouseout', function (e, target) {
            var changeToggleIcon = $cms.dom.closest(target, '.js-hover-change-img-toggle-icon', container.parentNode);

            if (changeToggleIcon && (!e.relatedTarget || !changeToggleIcon.contains(e.relatedTarget))) {
                var imgToggleIcon = $cms.dom.$(container, '.js-img-toggle-icon');
                imgToggleIcon.setAttribute('src', (e.type === 'mouseover') ? $IMG_checklist_toggleicon2 : $IMG_checklist_toggleicon);
            }
        });
    };

    function ajaxFormSubmitAdminHeadless(form, blockName, map) {
        var post = '';

        if (blockName !== undefined) {
            blockName = strVal(blockName);
            map = strVal(map);

            var comcode = '[block' + map + ']' + blockName + '[/block]';
            post += 'data=' + encodeURIComponent(comcode);
        }

        for (var i = 0; i < form.elements.length; i++) {
            if (!form.elements[i].disabled && form.elements[i].name) {
                post += '&' + form.elements[i].name + '=' + encodeURIComponent($cms.form.cleverFindValue(form, form.elements[i]));
            }
        }

        return new Promise(function (resolve) {
            $cms.doAjaxRequest($cms.maintainThemeInLink($SCRIPT_comcode_convert + $cms.$KEEP(true)), null, post).then(function (xhr) {
                if (xhr.responseText && (xhr.responseText !== 'false')) {
                    var result = xhr.responseXML && xhr.responseXML.querySelector('result');

                    if (result) {
                        var xhtml = result.textContent,
                            elementReplace = form;

                        while (elementReplace.className !== 'form_ajax_target') {
                            elementReplace = elementReplace.parentNode;
                            if (!elementReplace) {
                                // Oh dear, target not found
                                resolve(/*submitForm: */true);
                                return;
                            }
                        }

                        $cms.dom.html(elementReplace, xhtml);
                        $cms.ui.alert('{!SUCCESS;^}');
                        resolve(/*submitForm: */false); // We've handled it internally
                        return;
                    }
                }

                resolve(/*submitForm: */true);
            })
        });
    }
}(window.$cms));

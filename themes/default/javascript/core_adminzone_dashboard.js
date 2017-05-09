(function ($cms) {
    'use strict';

    var $IMG_checklist_checklist1 = '{$IMG;,checklist/checklist1}',
        $IMG_checklist_not_completed = '{$IMG;,checklist/not_completed}',
        $IMG_checklist_cross = '{$IMG;,checklist/cross}',
        $IMG_checklist_cross2 = '{$IMG;,checklist/cross2}',
        $IMG_checklist_toggleicon2 = '{$IMG;,checklist/toggleicon2}';

    var $SCRIPT_comcode_convert = '{$FIND_SCRIPT_NOHTTP;,comcode_convert}';

    function BlockMainStaffChecklistCustomTask() {
        BlockMainStaffChecklistCustomTask.base(this, 'constructor', arguments);

        this.imgChecklistCross = this.$('.js-img-checklist-cross');
        this.imgChecklistStatus = this.$('.js-img-checklist-status');
    }

    $cms.inherits(BlockMainStaffChecklistCustomTask, $cms.View, {
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
                $cms.loadSnippet('checklist_task_manage', 'type=mark_done&id=' + id);
                this.imgChecklistStatus.src = $IMG_checklist_checklist1;
                data.vwTaskDone = 'checklist1';
            } else {
                $cms.loadSnippet('checklist_task_manage', 'type=mark_undone&id=' + id);
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
                    $cms.loadSnippet('checklist_task_manage', 'type=delete&id=' + id);
                    viewEl.style.display = 'none';
                }
            });
        }
    });

    function BlockMainStaffLinks() {
        BlockMainStaffLinks.base(this, 'constructor', arguments);
    }

    $cms.inherits(BlockMainStaffLinks, $cms.View, {
        events: function () {
            return {
                'click .js-click-staff-block-flip': 'staffBlockFlip',
                'click .js-click-form-submit-headless': 'formSubmitHeadless'
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
        formSubmitHeadless: function (e, btn) {
            var params = this.params;

            if (!ajax_form_submit__admin__headless(btn.form, params.blockName, params.map)) {
                e.preventDefault();
            }
        }
    });

    function BlockMainStaffWebsiteMonitoring() {
        BlockMainStaffWebsiteMonitoring.base(this, 'constructor', arguments);

        var rand = this.params.randWebsiteMonitoring;

        this.tableEl = this.$('#website_monitoring_list_' + rand);
        this.formEl = this.$('.js-form-site-watchlist');
    }

    $cms.inherits(BlockMainStaffWebsiteMonitoring, $cms.View, {
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

            if (!ajax_form_submit__admin__headless(this.formEl, blockName, map)) {
                e.preventDefault();
            }
        }
    });

    function BlockMainNotes() {
        BlockMainNotes.base(this, 'constructor', arguments);
        this.formEl = this.$('.js-form-block-main-notes');
    }

    $cms.inherits(BlockMainNotes, $cms.View, {
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

            if (!ajax_form_submit__admin__headless(this.formEl, blockName, map)) {
                e.preventDefault();
            }
        },

        textareaExpand: function (e, textarea){
            textarea.setAttribute('rows','23');
        },

        textareaContract: function (e, textarea){
            if (!this.formEl.disable_size_change) {
                textarea.setAttribute('rows','10');
            }
        },

        disableTextareaSizeChange: function (e) {
            this.formEl.disable_size_change = (e.type === 'mouseover');
        }
    });

    $cms.views.BlockMainStaffChecklistCustomTask = BlockMainStaffChecklistCustomTask;
    $cms.views.BlockMainStaffLinks = BlockMainStaffLinks;
    $cms.views.BlockMainStaffWebsiteMonitoring = BlockMainStaffWebsiteMonitoring;
    $cms.views.BlockMainNotes = BlockMainNotes;

    $cms.templates.blockMainStaffChecklist = function (params, container) {
        var showAllLink = document.getElementById('checklist_show_all_link'),
            hideDoneLink = document.getElementById('checklist_hide_done_link');

        set_task_hiding(true);

        $cms.dom.on(container, 'click', '.js-click-enable-task-hiding', function () {
            set_task_hiding(true);
        });

        $cms.dom.on(container, 'click', '.js-click-disable-task-hiding', function () {
            set_task_hiding(false);
        });

        $cms.dom.on(container, 'submit', '.js-submit-custom-task', function (e, form) {
            submit_custom_task(form);
        });

        function set_task_hiding(hide_enable) {
            hide_enable = !!hide_enable;

            new Image().src = $IMG_checklist_cross2;
            new Image().src = $IMG_checklist_toggleicon2;

            var i, checklist_rows = document.querySelectorAll('.checklist_row'), row_imgs, src;

            for (i = 0; i < checklist_rows.length; i++) {
                row_imgs = checklist_rows[i].getElementsByTagName('img');
                if (hide_enable) {
                    src = row_imgs[row_imgs.length - 1].getAttribute('src');
                    if (row_imgs[row_imgs.length - 1].origsrc) {
                        src = row_imgs[row_imgs.length - 1].origsrc;
                    }
                    if (src && src.includes('checklist1')) {
                        $cms.dom.hide(checklist_rows[i]);
                        checklist_rows[i].classList.add('task_hidden');
                    } else {
                        checklist_rows[i].classList.remove('task_hidden');
                    }
                } else {
                    if (!$cms.dom.isDisplayed(checklist_rows[i])) {
                        $cms.dom.clearTransitionAndSetOpacity(checklist_rows[i], 0.0);
                        $cms.dom.fadeTransition(checklist_rows[i], 100, 30, 4);
                    }
                    $cms.dom.show(checklist_rows[i]);
                    checklist_rows[i].classList.remove('task_hidden');
                }
            }

            $cms.dom.toggle(showAllLink, hide_enable);
            $cms.dom.toggle(hideDoneLink, !hide_enable);
        }

        function submit_custom_task(form) {
            var new_task = $cms.loadSnippet('checklist_task_manage', 'type=add&recur_every=' + encodeURIComponent(form.elements['recur_every'].value) + '&recur_interval=' + encodeURIComponent(form.elements['recur_interval'].value) + '&task_title=' + encodeURIComponent(form.elements['new_task'].value));

            form.elements.recur_every.value = '';
            form.elements.recur_interval.value = '';
            form.elements.new_task.value = '';

            $cms.dom.append(document.getElementById('custom_tasks_go_here'), new_task);
        }
    };

    $cms.templates.blockMainStaffActions = function (params) {
        internaliseAjaxBlockWrapperLinks(params.blockCallUrl, document.getElementById(params.wrapperId), ['.*'], {}, false, true);
    };

    $cms.templates.blockMainStaffTips = function (params) {
        internaliseAjaxBlockWrapperLinks(params.blockCallUrl, document.getElementById(params.wrapperId), ['staff_tips_dismiss', 'rand'/*cache breaker*/], {}, false, true, false);
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

    function ajax_form_submit__admin__headless(form, block_name, map) {
        var post = '';
        if (block_name !== undefined) {
            if (map === undefined) {
                map = '';
            }
            var comcode = '[block' + map + ']' + block_name + '[/block]';
            post += 'data=' + encodeURIComponent(comcode);
        }
        for (var i = 0; i < form.elements.length; i++) {
            if (!form.elements[i].disabled && form.elements[i].name) {
                post += '&' + form.elements[i].name + '=' + encodeURIComponent($cms.form.cleverFindValue(form, form.elements[i]));
            }
        }
        var request = $cms.doAjaxRequest($cms.maintainThemeInLink($SCRIPT_comcode_convert + $cms.keepStub(true)), null, post);

        if (request.responseText && (request.responseText !== 'false')) {
            var result = request.responseXML.documentElement.querySelector('result');

            if (result) {
                var xhtml = result.textContent;

                var element_replace = form;
                while (element_replace.className !== 'form_ajax_target') {
                    element_replace = element_replace.parentNode;
                    if (!element_replace) {
                        return true;  // Oh dear, target not found
                    }
                }

                $cms.dom.html(element_replace, xhtml);

                $cms.ui.alert('{!SUCCESS;^}');

                return false; // We've handled it internally
            }
        }

        return true;
    }

}(window.$cms));


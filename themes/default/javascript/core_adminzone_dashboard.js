(function ($cms) {
    'use strict';

    var $IMG_checklist_checklist1 = '{$IMG;,checklist/checklist1}',
        $IMG_checklist_not_completed = '{$IMG;,checklist/not_completed}',
        $IMG_checklist_cross = '{$IMG;,checklist/cross}',
        $IMG_checklist_cross2 = '{$IMG;,checklist/cross2}',
        $IMG_checklist_toggleicon2 = '{$IMG;,checklist/toggleicon2}';

    var $SCRIPT_comcode_convert = '{$FIND_SCRIPT_NOHTTP;,comcode_convert}';

    function BlockMainStaffChecklistCustomTask() {
        BlockMainStaffChecklistCustomTask.base(this, arguments);

        this.imgChecklistCross = this.$('.js-img-checklist-cross');
        this.imgChecklistStatus = this.$('.js-img-checklist-status');
    }

    $cms.inherits(BlockMainStaffChecklistCustomTask, $cms.View, {
        events: {
            'mouseover': 'mouseover',
            'mouseout': 'mouseout',

            'click .js-click-confirm-delete': 'confirmDelete',
            'click .js-click-mark-task': 'markTask',
            'keypress .js-keypress-mark-task': 'markTask'
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
                load_snippet('checklist_task_manage', 'type=mark_done&id=' + id);
                this.imgChecklistStatus.src = $IMG_checklist_checklist1;
                data.vwTaskDone = 'checklist1';
            } else {
                load_snippet('checklist_task_manage', 'type=mark_undone&id=' + id);
                this.imgChecklistStatus.src = $IMG_checklist_not_completed;
                data.vwTaskDone = 'not_completed';
            }
        },

        confirmDelete: function () {
            var viewEl = this.el,
                options = this.options,
                message = options.confirmDeleteMessage,
                id = encodeURIComponent(options.id);

            window.fauxmodal_confirm(message, function (result) {
                if (result) {
                    load_snippet('checklist_task_manage', 'type=delete&id=' + id);
                    viewEl.style.display = 'none';
                }
            });
        }
    });

    function BlockMainStaffLinks() {
        BlockMainStaffLinks.base(this, arguments);
    }

    $cms.inherits(BlockMainStaffLinks, $cms.View, {
        events: {
            'click .js-click-staff-block-flip': 'staffBlockFlip',
            'click .js-click-form-submit-headless': 'formSubmitHeadless'
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
        BlockMainStaffWebsiteMonitoring.base(this, arguments);

        var rand = this.params.randWebsiteMonitoring;

        this.tableEl = this.$('#website_monitoring_list_' + rand);
        this.formEl = this.$('.js-form-site-watchlist');
    }

    $cms.inherits(BlockMainStaffWebsiteMonitoring, $cms.View, {
        tableEl: null,
        formEl: null,
        events: {
            'click .js-click-staff-block-flip': 'staffBlockFlip',
            'click .js-click-headless-submit': 'headlessSubmit'
        },

        staffBlockFlip: function () {
            var isTableDisplayed = $cms.dom.isDisplayed(this.tableEl);

            $cms.dom.toggleWithAria(this.formEl, isTableDisplayed);
            $cms.dom.toggleWithAria(this.tableEl, !isTableDisplayed);
        },

        headlessSubmit: function (e) {
            var blockName = $cms.filter.crLf(this.params.blockName),
                map = $cms.filter.crLf(this.params.map);

            if (!ajax_form_submit__admin__headless(this.formEl, blockName, map)) {
                e.preventDefault();
            }
        }
    });

    function BlockMainNotes() {
        BlockMainNotes.base(this, arguments);
        this.formEl = this.$('.js-form-block-main-notes');
    }

    $cms.inherits(BlockMainNotes, $cms.View, {
        formEl: null,
        events: {
            'click .js-click-headless-submit': 'headlessSubmit'
        },

        headlessSubmit: function (e) {
            var blockName = $cms.filter.crLf(this.params.blockName),
                map = $cms.filter.crLf(this.params.map);

            if (!ajax_form_submit__admin__headless(this.formEl, blockName, map)) {
                e.preventDefault();
            }
        }
    });

    $cms.views.BlockMainStaffChecklistCustomTask = BlockMainStaffChecklistCustomTask;
    $cms.views.BlockMainStaffLinks = BlockMainStaffLinks;
    $cms.views.BlockMainStaffWebsiteMonitoring = BlockMainStaffWebsiteMonitoring;
    $cms.views.BlockMainNotes = BlockMainNotes;

    $cms.extend($cms.templates, {
        blockMainStaffChecklist: function () {
            var container = this,
                showAllLink = document.getElementById('checklist_show_all_link'),
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
                            clear_transition_and_set_opacity(checklist_rows[i], 0.0);
                            fade_transition(checklist_rows[i], 100, 30, 4);
                        }
                        $cms.dom.show(checklist_rows[i]);
                        checklist_rows[i].classList.remove('task_hidden');
                    }
                }

                $cms.dom.toggle(showAllLink, hide_enable);
                $cms.dom.toggle(hideDoneLink, !hide_enable);
            }

            function submit_custom_task(form) {
                var new_task = load_snippet('checklist_task_manage', 'type=add&recur_every=' + encodeURIComponent(form.elements['recur_every'].value) + '&recur_interval=' + encodeURIComponent(form.elements['recur_interval'].value) + '&task_title=' + encodeURIComponent(form.elements['new_task'].value));

                form.elements.recur_every.value = '';
                form.elements.recur_interval.value = '';
                form.elements.new_task.value = '';

                $cms.dom.appendHtml(document.getElementById('custom_tasks_go_here'), new_task);
            }
        },

        blockMainStaffActions: function (options) {
            internalise_ajax_block_wrapper_links(options.blockCallUrl, document.getElementById(options.wrapperId), ['.*'], {}, false, true);
        },

        blockMainStaffTips: function (options) {
            internalise_ajax_block_wrapper_links(options.blockCallUrl, document.getElementById(options.wrapperId), ['staff_tips_dismiss', 'rand'/*cache breaker*/], {}, false, true, false);
        }
    });


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
                post += '&' + form.elements[i].name + '=' + encodeURIComponent(clever_find_value(form, form.elements[i]));
            }
        }
        var request = do_ajax_request(maintain_theme_in_link($SCRIPT_comcode_convert + keep_stub(true)), null, post);

        if (request.responseText && (request.responseText !== 'false')) {
            var result = request.responseXML.documentElement.querySelector('result');

            if (result) {
                var xhtml = merge_text_nodes(result.childNodes);

                var element_replace = form;
                while (element_replace.className !== 'form_ajax_target') {
                    element_replace = element_replace.parentNode;
                    if (!element_replace) {
                        return true;  // Oh dear, target not found
                    }
                }

                $cms.dom.html(element_replace, xhtml);

                window.fauxmodal_alert('{!SUCCESS;^}');

                return false; // We've handled it internally
            }
        }

        return true;
    }

}(window.$cms));


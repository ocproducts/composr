(function (Composr) {
    'use strict';

    var $IMG = {
        'checklist/checklist1': '{$IMG;,checklist/checklist1}',
        'checklist/not_completed': '{$IMG;,checklist/not_completed}',
        'checklist/cross': '{$IMG;,checklist/cross}',
        'checklist/cross2': '{$IMG;,checklist/cross2}',
        'checklist/toggleicon2': '{$IMG;,checklist/toggleicon2}'
    };

    Composr.behaviors.coreAdminzoneDashboard = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_adminzone_dashboard');
            }
        }
    };

    var BlockMainStaffChecklistCustomTask = Composr.View.extend({
        imgChecklistCross: null,
        imgChecklistStatus: null,
        initialize: function () {
            BlockMainStaffChecklistCustomTask.__super__.initialize.apply(this, arguments);
            this.imgChecklistCross = this.$('.js-img-checklist-cross');
            this.imgChecklistStatus = this.$('.js-img-checklist-status');
        },

        events: {
            'mouseover': 'mouseover',
            'mouseout': 'mouseout',

            'click .js-click-confirm-delete': 'confirmDelete',
            'click .js-click-mark-task': 'markTask',
            'keypress .js-keypress-mark-task': 'markTask'
        },

        mouseover: function () {
            this.imgChecklistCross.src = $IMG['checklist/cross2'];
        },

        mouseout: function () {
            this.imgChecklistCross.src = $IMG['checklist/cross'];
        },

        markTask: function (e) {
            var data = this.el.dataset,
                id = encodeURIComponent(this.options.id);

            // Prevent events on the delete link from triggering this function
            if (this.$closest(e.target, '.js-click-confirm-delete')) {
                return;
            }

            if (data.vwTaskDone === 'not_completed') {
                load_snippet('checklist_task_manage', 'type=mark_done&id=' + id);
                this.imgChecklistStatus.src = $IMG['checklist/checklist1'];
                data.vwTaskDone = 'checklist1';
            } else {
                load_snippet('checklist_task_manage', 'type=mark_undone&id=' + id);
                this.imgChecklistStatus.src = $IMG['checklist/not_completed'];
                data.vwTaskDone = 'not_completed';
            }
        },

        confirmDelete: function () {
            var viewEl = this.el,
                opts = this.options,
                message = opts.confirmDeleteMessage,
                id = encodeURIComponent(opts.id);

            window.fauxmodal_confirm(message, function (result) {
                if (result) {
                    load_snippet('checklist_task_manage', 'type=delete&id=' + id);
                    viewEl.style.display = 'none';
                }
            });
        }
    });

    var BlockMainStaffLinks = Composr.View.extend({
        events: {
            'click .js-click-staff-block-flip': 'staffBlockFlip',
            'click .js-click-form-submit-headless': 'formSubmitHeadless'
        },
        staffBlockFlip: function () {
            var rand = this.options.randStaffLinks,
                show = this.$('#staff_links_list_' + rand + '_form'),
                hide = this.$('#staff_links_list_' + rand);

            set_display_with_aria(show, (hide.style.display !== 'none') ? 'block' : 'none');
            set_display_with_aria(hide, (hide.style.display !== 'none') ? 'none' : 'block');
        },
        formSubmitHeadless: function (e, btn) {
            var opts = this.options,
                doDefault = ajax_form_submit__admin__headless(null, btn.form, opts.blockName, opts.map);

            if (!doDefault) {
                e.preventDefault();
            }
        }
    });

    var BlockMainStaffWebsiteMonitoring = Composr.View.extend({
        events: {
            'click .js-click-staff-block-flip': 'staffBlockFlip'
        },

        staffBlockFlip: function () {
            var rand = this.options.randWebsiteMonitoring,
                show = Composr.dom.id('website_monitoring_list_' + rand + '_form'),
                hide = Composr.dom.id('website_monitoring_list_' + rand);

            set_display_with_aria(show, (hide.style.display !== 'none') ? 'block' : 'none');
            set_display_with_aria(hide, (hide.style.display !== 'none') ? 'none' : 'block');
        }
    });

    Composr.views.BlockMainStaffChecklistCustomTask = BlockMainStaffChecklistCustomTask;
    Composr.views.BlockMainStaffLinks = BlockMainStaffLinks;
    Composr.views.BlockMainStaffWebsiteMonitoring = BlockMainStaffWebsiteMonitoring;

    Composr.templates.coreAdminzoneDashboard = {
        blockMainStaffChecklist: function () {
            var container = this;

            set_task_hiding(true);

            Composr.dom.on(container, 'click', '.js-click-enable-task-hiding', function () {
                set_task_hiding(true);
            });

            Composr.dom.on(container, 'click', '.js-click-disable-task-hiding', function () {
                set_task_hiding(false);
            });

            Composr.dom.on(container, 'submit', '.js-submit-custom-task', function (e, form) {
                submit_custom_task(form);
            });

            function set_task_hiding(hide_enable) {
                new Image().src = $IMG['checklist/cross2'];
                new Image().src =  $IMG['checklist/toggleicon2'];

                var i, checklist_rows = document.querySelectorAll('.checklist_row'), row_imgs, src;

                for (i = 0; i < checklist_rows.length; i++) {
                    row_imgs = checklist_rows[i].getElementsByTagName('img');
                    if (hide_enable) {
                        src = row_imgs[row_imgs.length - 1].getAttribute('src');
                        if (row_imgs[row_imgs.length - 1].origsrc) {
                            src = row_imgs[row_imgs.length - 1].origsrc;
                        }
                        if (src && src.indexOf('checklist1') != -1) {
                            checklist_rows[i].style.display = 'none';
                            checklist_rows[i].className += ' task_hidden';
                        } else {
                            checklist_rows[i].className = checklist_rows[i].className.replace(/ task_hidden/g, '');
                        }
                    } else {
                        if ((checklist_rows[i].style.display == 'none')) {
                            clear_transition_and_set_opacity(checklist_rows[i], 0.0);
                            fade_transition(checklist_rows[i], 100, 30, 4);
                        }
                        checklist_rows[i].style.display = 'block';
                        checklist_rows[i].className = checklist_rows[i].className.replace(/ task_hidden/g, '');
                    }
                }

                if (hide_enable) {
                    document.getElementById('checklist_show_all_link').style.display = 'block';
                    document.getElementById('checklist_hide_done_link').style.display = 'none';
                } else {
                    document.getElementById('checklist_show_all_link').style.display = 'none';
                    document.getElementById('checklist_hide_done_link').style.display = 'block';
                }
            }

            function submit_custom_task(form) {
                var new_task = load_snippet('checklist_task_manage', 'type=add&recur_every=' + encodeURIComponent(form.elements['recur_every'].value) + '&recur_interval=' + encodeURIComponent(form.elements['recur_interval'].value) + '&task_title=' + encodeURIComponent(form.elements['new_task'].value));

                form.elements.recur_every.value = '';
                form.elements.recur_interval.value = '';
                form.elements.new_task.value = '';

                Composr.dom.appendHtml(document.getElementById('custom_tasks_go_here'), new_task);
            }
        },

        blockMainStaffActions: function (options) {
            internalise_ajax_block_wrapper_links(options.blockCallUrl, document.getElementById(options.wrapperId), ['.*'], {}, false, true);
        },

        blockMainStaffTips: function (options) {
            internalise_ajax_block_wrapper_links(options.blockCallUrl, document.getElementById(options.wrapperId), ['staff_tips_dismiss', 'rand'/*cache breaker*/], {}, false, true, false);
        }
    };

}(window.Composr));

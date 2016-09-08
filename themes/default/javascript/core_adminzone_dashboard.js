(function (Composr) {
    'use strict';

    Composr.behaviors.coreAdminzoneDashboard = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core_adminzone_dashboard');
                Composr.initializeTemplates(context, 'core_adminzone_dashboard');
            }
        }
    };

    var BlockMainStaffLinks = Composr.View.extend({
        initialize: function () {
            BlockMainStaffLinks.__super__.initialize.apply(this, arguments);
        },
        events: {
            'click .js-click-staff-block-flip': 'staffBlockFlip',
            'click .js-click-form-submit-headless': 'formSubmitHeadless'
        },
        staffBlockFlip: function () {
            var rand = this.options.randStaffLinks;
            staff_block_flip_over('staff_links_list_' + rand);
        },
        formSubmitHeadless: function (e) {
            var opts = this.options,
                btn = e.currentTarget,
                doDefault = ajax_form_submit__admin__headless(null, btn.form, opts.blockName, opts.map);

            if (!doDefault) {
                e.preventDefault();
            }
        }
    });

    Composr.views.coreAdminzoneDashboard = {
        BlockMainStaffLinks: BlockMainStaffLinks
    };

    Composr.templates.coreAdminzoneDashboard = {
        blockMainStaffChecklist: function () {
            set_task_hiding(true);
        },

        blockMainStaffActions: function (options) {
            internalise_ajax_block_wrapper_links(options.blockCallUrl, document.getElementById(options.wrapperId), ['.*'], {}, false, true);
        },

        blockMainStaffTips: function (options) {
            internalise_ajax_block_wrapper_links(options.blockCallUrl, document.getElementById(options.wrapperId), ['staff_tips_dismiss', 'rand'/*cache breaker*/], {}, false, true, false);
        }
    };

}(window.Composr));

(function ($, Composr) {
    Composr.templates.coreAdminzoneDashboard = {
        blockMainStaffChecklist: function blockMainStaffChecklist() {
            set_task_hiding(true);
        },

        blockMainStaffActions: function blockMainStaffActions(options) {
            internalise_ajax_block_wrapper_links(options.blockCallUrl, document.getElementById(options.wrapperId),['.*'],{ },false,true);
        },

        blockMainStaffTips: function blockMainStaffTips(options) {
            internalise_ajax_block_wrapper_links(options.blockCallUrl, document.getElementById(options.wrapperId),['staff_tips_dismiss','rand'/*cache breaker*/],{ },false,true,false);
        }
    };

    Composr.behaviors.coreAdminzoneDashboard = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_adminzone_dashboard');
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);

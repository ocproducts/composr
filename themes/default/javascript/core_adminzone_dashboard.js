(function ($, Composr) {
    Composr.templates.coreAdminzoneDashboard = {
        blockMainStaffChecklist: function () {
            set_task_hiding(true);
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

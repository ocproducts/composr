(function ($cms) {
    'use strict';

    $cms.functions.moduleAdminCnsWelcomeEmailsRunStart = function moduleAdminCnsWelcomeEmailsRunStart() {
        var newsletterField = document.getElementById('newsletter');
        var usergroupField = newsletterField.form.elements['usergroup'];
        newsletterField.addEventListener('change', updateNewsletterSettings);
        usergroupField.addEventListener('change', updateNewsletterSettings);
        updateNewsletterSettings();

        function updateNewsletterSettings() {
            var hasNewsletter = (newsletterField.selectedIndex !== 0);
            var hasUsergroup = (usergroupField.selectedIndex !== 0);
            newsletterField.form.elements['usergroup'].disabled = hasNewsletter;
            newsletterField.form.elements['usergroup_type'][0].disabled = hasNewsletter || !hasUsergroup;
            newsletterField.form.elements['usergroup_type'][1].disabled = hasNewsletter || !hasUsergroup;
            newsletterField.form.elements['usergroup_type'][2].disabled = hasNewsletter || !hasUsergroup;
        }
    };
}(window.$cms));

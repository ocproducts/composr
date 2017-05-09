(function ($cms) {
    'use strict';

    $cms.functions.moduleAdminCnsWelcomeEmailsRunStart = function moduleAdminCnsWelcomeEmailsRunStart() {
        var newsletter_field = document.getElementById('newsletter');
        var usergroup_field = newsletter_field.form.elements['usergroup'];
        newsletter_field.addEventListener('change', updateNewsletterSettings);
        usergroup_field.addEventListener('change', updateNewsletterSettings);
        updateNewsletterSettings();

        function updateNewsletterSettings() {
            var has_newsletter = (newsletter_field.selectedIndex != 0);
            var has_usergroup = (usergroup_field.selectedIndex != 0);
            newsletter_field.form.elements['usergroup'].disabled = has_newsletter;
            newsletter_field.form.elements['usergroup_type'][0].disabled = has_newsletter || !has_usergroup;
            newsletter_field.form.elements['usergroup_type'][1].disabled = has_newsletter || !has_usergroup;
            newsletter_field.form.elements['usergroup_type'][2].disabled = has_newsletter || !has_usergroup;
        }
    };

}(window.$cms));
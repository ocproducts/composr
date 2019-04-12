<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_cns
 */

/**
 * Hook class.
 */
class Hook_profiles_tabs_edit_profile
{
    /**
     * Find whether this hook is active.
     *
     * @param  MEMBER $member_id_of The ID of the member who is being viewed
     * @param  MEMBER $member_id_viewing The ID of the member who is doing the viewing
     * @return boolean Whether this hook is active
     */
    public function is_active($member_id_of, $member_id_viewing)
    {
        if (post_param_integer('delete', 0) == 1) {
            return false; // So no form validation
        }

        if (($member_id_of == $member_id_viewing) || (has_privilege($member_id_viewing, 'assume_any_member')) || (has_privilege($member_id_viewing, 'member_maintenance'))) {
            $groups = $GLOBALS['CNS_DRIVER']->get_members_groups($member_id_of);
            $_custom_fields = cns_get_all_custom_fields_match(
                $groups, // groups
                (($member_id_of === null) || ($member_id_of == $member_id_viewing) || (has_privilege($member_id_viewing, 'view_any_profile_field'))) ? null : 1, // public view
                null, // owner view
                (($member_id_of === null) || ($member_id_of != $member_id_viewing) || (has_privilege($member_id_viewing, 'view_any_profile_field'))) ? null : 1 // owner set
            );
            if (count($_custom_fields) == 0) {
                return false;
            }
            return true;
        }
        return false;
    }

    /**
     * Render function for profile tabs edit hooks.
     *
     * @param  MEMBER $member_id_of The ID of the member who is being viewed
     * @param  MEMBER $member_id_viewing The ID of the member who is doing the viewing
     * @param  boolean $leave_to_ajax_if_possible Whether to leave the tab contents null, if this hook supports it, so that AJAX can load it later
     * @return ?array A tuple: The tab title, the tab body text (may be blank), the tab fields, extra JavaScript (may be blank) the suggested tab order, hidden fields (optional) (null: if $leave_to_ajax_if_possible was set), the icon
     */
    public function render_tab($member_id_of, $member_id_viewing, $leave_to_ajax_if_possible = false)
    {
        $order = 10;

        // NB: Actualiser is handled in settings.php

        if ($leave_to_ajax_if_possible) {
            return null;
        }

        // UI

        require_code('form_templates');

        $title = do_lang_tempcode('PROFILE');

        $custom_fields = cns_get_all_custom_fields_match_member($member_id_of);

        require_code('cns_members_action2');
        list($fields, $hidden) = cns_get_member_fields_profile(false, $member_id_of, null, $custom_fields);

        $redirect = get_param_string('redirect', '', INPUT_FILTER_URL_INTERNAL);
        if ($redirect != '') {
            $hidden->attach(form_input_hidden('redirect', static_evaluate_tempcode(protect_url_parameter($redirect))));
        }

        $hidden->attach(form_input_hidden('submitting_profile_tab', '1'));

        $text = '';

        return array($title, $fields, $text, '', $order, $hidden, 'tabs/member_account/edit/profile');
    }
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    banners
 */

/**
 * Hook class.
 */
class Hook_sw_banners
{
    /**
     * Run function for features in the setup wizard.
     *
     * @return array Current settings.
     */
    public function get_current_settings()
    {
        $settings = array();
        $test = $GLOBALS['SITE_DB']->query_select_value_if_there('banners', 'name', array('name' => 'donate'));
        $settings['have_default_banners_donation'] = is_null($test) ? '0' : '1';
        $test = $GLOBALS['SITE_DB']->query_select_value_if_there('banners', 'name', array('name' => 'advertise_here'));
        $settings['have_default_banners_advertising'] = is_null($test) ? '0' : '1';
        return $settings;
    }

    /**
     * Run function for features in the setup wizard.
     *
     * @param  array $field_defaults Default values for the fields, from the install-profile.
     * @return Tempcode An input field.
     */
    public function get_fields($field_defaults)
    {
        if (!addon_installed('banners')) {
            return new Tempcode();
        }

        $current_settings = $this->get_current_settings();
        $field_defaults += $current_settings; // $field_defaults will take precedence, due to how "+" operator works in PHP

        require_lang('banners');
        $fields = new Tempcode();
        if ($current_settings['have_default_banners_donation'] == '1') {
            $fields->attach(form_input_tick(do_lang_tempcode('HAVE_DEFAULT_BANNERS_DONATION'), do_lang_tempcode('DESCRIPTION_HAVE_DEFAULT_BANNERS_DONATION'), 'have_default_banners_donation', $field_defaults['have_default_banners_donation'] == '1'));
        }
        if ($current_settings['have_default_banners_advertising'] == '1') {
            $fields->attach(form_input_tick(do_lang_tempcode('HAVE_DEFAULT_BANNERS_ADVERTISING'), do_lang_tempcode('DESCRIPTION_HAVE_DEFAULT_BANNERS_ADVERTISING'), 'have_default_banners_advertising', $field_defaults['have_default_banners_advertising'] == '1'));
        }
        return $fields;
    }

    /**
     * Run function for setting features from the setup wizard.
     */
    public function set_fields()
    {
        if (!addon_installed('banners')) {
            return;
        }

        if (post_param_integer('have_default_banners_donation', 0) == 0) {
            $test = $GLOBALS['SITE_DB']->query_select_value_if_there('banners', 'name', array('name' => 'donate'));
            if (!is_null($test)) {
                require_code('banners2');
                delete_banner('donate');

                //require_code('zones3');
                //delete_cms_page('site', 'donate', null, true);    Page no longer bundled, can be made via page templates
            }
        }
        if (post_param_integer('have_default_banners_advertising', 0) == 0) {
            $test = $GLOBALS['SITE_DB']->query_select_value_if_there('banners', 'name', array('name' => 'advertise_here'));
            if (!is_null($test)) {
                require_code('banners2');
                delete_banner('advertise_here');

                //require_code('zones3');
                //delete_cms_page('site', 'advertise', null, true);    Page no longer bundled, can be made via page templates
            }
        }
    }
}

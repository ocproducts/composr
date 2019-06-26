<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    captcha
 */

/**
 * Hook class.
 */
class Hook_addon_registry_captcha
{
    /**
     * Get a list of file permissions to set.
     *
     * @param  boolean $runtime Whether to include wildcards represented runtime-created chmoddable files
     * @return array File permissions to set
     */
    public function get_chmod_array($runtime = false)
    {
        return array();
    }

    /**
     * Get the version of Composr this addon is for.
     *
     * @return float Version number
     */
    public function get_version()
    {
        return cms_version_number();
    }

    /**
     * Get the description of the addon.
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'Stop spam-bots from performing actions on the website.';
    }

    /**
     * Get a list of tutorials that apply to this addon.
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array(
            'tut_members',
        );
    }

    /**
     * Get a mapping of dependency types.
     *
     * @return array File permissions to set
     */
    public function get_dependencies()
    {
        return array(
            'requires' => array(),
            'recommends' => array(),
            'conflicts_with' => array(),
            'previously_in_addon' => array('core_captcha'),
        );
    }

    /**
     * Explicitly say which icon should be used.
     *
     * @return URLPATH Icon
     */
    public function get_default_icon()
    {
        return 'themes/default/images/icons/admin/component.svg';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources/hooks/systems/snippets/captcha_wrong.php',
            'sources/hooks/systems/addon_registry/captcha.php',
            'themes/default/templates/FORM_SCREEN_INPUT_CAPTCHA.tpl',
            'themes/default/templates/CAPTCHA_LOOSE.tpl',
            'data/captcha.php',
            'sources/captcha.php',
            'lang/EN/captcha.ini',
            'data/sounds/0.wav',
            'data/sounds/1.wav',
            'data/sounds/2.wav',
            'data/sounds/3.wav',
            'data/sounds/4.wav',
            'data/sounds/5.wav',
            'data/sounds/6.wav',
            'data/sounds/7.wav',
            'data/sounds/8.wav',
            'data/sounds/9.wav',
            'data/sounds/a.wav',
            'data/sounds/b.wav',
            'data/sounds/c.wav',
            'data/sounds/d.wav',
            'data/sounds/e.wav',
            'data/sounds/f.wav',
            'data/sounds/g.wav',
            'data/sounds/h.wav',
            'data/sounds/i.wav',
            'data/sounds/j.wav',
            'data/sounds/k.wav',
            'data/sounds/l.wav',
            'data/sounds/m.wav',
            'data/sounds/n.wav',
            'data/sounds/o.wav',
            'data/sounds/p.wav',
            'data/sounds/q.wav',
            'data/sounds/r.wav',
            'data/sounds/s.wav',
            'data/sounds/t.wav',
            'data/sounds/u.wav',
            'data/sounds/v.wav',
            'data/sounds/w.wav',
            'data/sounds/x.wav',
            'data/sounds/y.wav',
            'data/sounds/z.wav',
            'sources/hooks/systems/config/use_captchas.php',
            'sources/hooks/systems/config/captcha_single_guess.php',
            'sources/hooks/systems/config/css_captcha.php',
            'sources/hooks/systems/config/captcha_noise.php',
            'sources/hooks/systems/config/captcha_on_feedback.php',
            'sources/hooks/systems/config/audio_captcha.php',
            'sources/hooks/systems/config/js_captcha.php',
            'themes/default/javascript/captcha.js',
            'sources/hooks/systems/config/recaptcha_server_key.php',
            'sources/hooks/systems/config/recaptcha_site_key.php',
            'sources/hooks/systems/config/captcha_member_days.php',
            'sources/hooks/systems/config/captcha_member_posts.php',
            'sources/hooks/systems/config/captcha_question_pages.php',
            'sources/hooks/systems/config/captcha_question_total.php',
            'sources/hooks/systems/config/captcha_questions.php',
        );
    }

    /**
     * Get mapping between template names and the method of this class that can render a preview of them.
     *
     * @return array The mapping
     */
    public function tpl_previews()
    {
        return array(
            'templates/FORM_SCREEN_INPUT_CAPTCHA.tpl' => 'form_screen_input_captcha',
            'templates/CAPTCHA_LOOSE.tpl' => 'captcha_loose',
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declarative.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__form_screen_input_captcha()
    {
        require_code('captcha');
        generate_captcha();

        require_css('forms');

        $input = do_lorem_template('FORM_SCREEN_INPUT_CAPTCHA', array(
            'TABINDEX' => placeholder_number(),
        ));
        $captcha = do_lorem_template('FORM_SCREEN_FIELD', array(
            'REQUIRED' => true,
            'SKIP_LABEL' => true,
            'NAME' => 'captcha',
            'PRETTY_NAME' => lorem_phrase(),
            'DESCRIPTION' => lorem_sentence_html(),
            'DESCRIPTION_SIDE' => '',
            'INPUT' => $input,
            'COMCODE' => '',
        ));

        return array(
            lorem_globalise(do_lorem_template('FORM_SCREEN', array(
                'SKIP_WEBSTANDARDS' => true,
                'HIDDEN' => '',
                'TITLE' => lorem_title(),
                'URL' => placeholder_url(),
                'FIELDS' => $captcha,
                'SUBMIT_ICON' => 'buttons/proceed',
                'SUBMIT_NAME' => lorem_word(),
                'TEXT' => lorem_sentence_html(),
            )), null, '', true)
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declarative.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__captcha_loose()
    {
        $name = placeholder_random_id();
        $input = do_lorem_template('FORM_SCREEN_INPUT_TEXT', array(
            'RAW' => true,
            'SCROLLS' => '',
            'TABINDEX' => placeholder_number(),
            'REQUIRED' => '',
            'NAME' => $name,
            'DEFAULT' => '',
        ));
        $fields = new Tempcode();
        $fields->attach(do_lorem_template('FORM_SCREEN_FIELD', array(
            'REQUIRED' => true,
            'SKIP_LABEL' => false,
            'NAME' => $name,
            'PRETTY_NAME' => lorem_word(),
            'DESCRIPTION' => lorem_sentence_html(),
            'DESCRIPTION_SIDE' => '',
            'INPUT' => $input,
            'COMCODE' => '',
        )));

        $tpl = do_lorem_template('FORM', array(
            'GET' => null,
            'SKIP_WEBSTANDARDS' => true,
            'HIDDEN' => '',
            'TITLE' => lorem_title(),
            'URL' => placeholder_url(),
            'FIELDS' => $fields,
            'SUBMIT_ICON' => 'buttons/proceed',
            'SUBMIT_NAME' => lorem_word(),
            'TEXT' => lorem_sentence_html(),
        ));

        return array(
            lorem_globalise(do_lorem_template('CAPTCHA_LOOSE', array(
            )), null, '', true)
        );
    }
}

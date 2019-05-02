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
 * @package    cns_member_avatars
 */

/**
 * Hook class.
 */
class Hook_addon_registry_cns_member_avatars
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
        return 'Member avatars.';
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
        );
    }

    /**
     * Explicitly say which icon should be used.
     *
     * @return URLPATH Icon
     */
    public function get_default_icon()
    {
        return 'themes/default/images/icons/tabs/member_account/edit/avatar.svg';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'themes/default/images/icons/tabs/member_account/edit/avatar.svg',
            'themes/default/images/icons_monochrome/tabs/member_account/edit/avatar.svg',
            'sources/hooks/systems/notifications/cns_choose_avatar.php',
            'sources/hooks/systems/addon_registry/cns_member_avatars.php',
            'themes/default/templates/CNS_EDIT_AVATAR_TAB.tpl',
            'uploads/cns_avatars/index.html',
            'uploads/cns_avatars/.htaccess',
            'sources/hooks/systems/profiles_tabs_edit/avatar.php',
            'themes/default/images/cns_default_avatars/index.html',
            'themes/default/images/cns_default_avatars/system.png',
            'sources/hooks/systems/config/random_avatars.php',
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
            'templates/CNS_EDIT_AVATAR_TAB.tpl' => 'cns_edit_avatar_tab',
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declarative.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__cns_edit_avatar_tab()
    {
        require_lang('cns');
        require_css('cns');

        $avatar = do_lorem_template('CNS_TOPIC_POST_AVATAR', array(
            'AVATAR' => placeholder_image_url(),
        ));

        return array(
            lorem_globalise(do_lorem_template('CNS_EDIT_AVATAR_TAB', array(
                'USERNAME' => lorem_word(),
                'AVATAR' => $avatar,
                'WIDTH' => placeholder_number(),
                'HEIGHT' => placeholder_number(),
            )), null, '', true)
        );
    }
}

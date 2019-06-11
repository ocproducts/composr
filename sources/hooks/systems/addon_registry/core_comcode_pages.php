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
 * @package    core_comcode_pages
 */

/**
 * Hook class.
 */
class Hook_addon_registry_core_comcode_pages
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
        return 'Manage new pages on the website, known as Comcode pages.';
    }

    /**
     * Get a list of tutorials that apply to this addon.
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array(
            'tut_comcode_pages',
            'tut_adv_comcode_pages',
            'tut_information',
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
        return 'themes/default/images/icons/menu/cms/comcode_page_edit.svg';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'themes/default/images/icons/menu/cms/comcode_page_edit.svg',
            'themes/default/images/icons_monochrome/menu/cms/comcode_page_edit.svg',
            'sources/hooks/systems/config/points_COMCODE_PAGE_ADD.php',
            'sources/hooks/systems/addon_registry/core_comcode_pages.php',
            'themes/default/templates/COMCODE_PAGE_EDIT_ACTIONS.tpl',
            'themes/default/templates/COMCODE_PAGE_BOX.tpl',
            'themes/default/templates/GENERATE_PAGE_SITEMAP.tpl',
            'themes/default/templates/GENERATE_PAGE_SITEMAP_SCREEN.tpl',
            'sources/hooks/modules/search/comcode_pages.php',
            'sources/hooks/systems/content_meta_aware/comcode_page.php',
            'sources/hooks/systems/commandr_fs/comcode_pages.php',
            'themes/default/templates/COMCODE_PAGE_SCREEN.tpl',
            'sources/hooks/systems/rss/comcode_pages.php',
            'sources/hooks/systems/cleanup/comcode_pages.php',
            'cms/pages/modules/cms_comcode_pages.php',
            'sources/hooks/systems/preview/comcode_page.php',
            'sources/hooks/systems/attachments/comcode_page.php',
            'sources/hooks/modules/admin_unvalidated/comcode_pages.php',
            'sources/hooks/modules/admin_newsletter/comcode_pages.php',
            'sources/hooks/systems/config/comcode_page_default_review_freq.php',
            'sources/hooks/systems/config/is_on_comcode_page_children.php',
            'sources/hooks/systems/sitemap/comcode_page.php',
            'themes/default/templates/COMCODE_PAGE_MANAGE_SCREEN.tpl',
            'data/modules/cms_comcode_pages/.htaccess',
            'data/modules/cms_comcode_pages/index.html',
            'data/modules/cms_comcode_pages/EN/.htaccess',
            'data/modules/cms_comcode_pages/EN/index.html',
            'data/modules/cms_comcode_pages/EN/about_us.txt',
            'data/modules/cms_comcode_pages/EN/advertise.txt',
            'data/modules/cms_comcode_pages/EN/article.txt',
            'data/modules/cms_comcode_pages/EN/competitor_comparison.txt',
            'data/modules/cms_comcode_pages/EN/contact_us.txt',
            'data/modules/cms_comcode_pages/EN/donate.txt',
            'data/modules/cms_comcode_pages/EN/guestbook.txt',
            'data/modules/cms_comcode_pages/EN/press_release.txt',
            'data/modules/cms_comcode_pages/EN/pricing.txt',
            'data/modules/cms_comcode_pages/EN/landing_page.txt',
            'data/modules/cms_comcode_pages/EN/two_column_layout.txt',
            'data/modules/cms_comcode_pages/EN/under_construction.txt',
            'data/modules/cms_comcode_pages/EN/rules_balanced.txt',
            'data/modules/cms_comcode_pages/EN/rules_corporate.txt',
            'data/modules/cms_comcode_pages/EN/rules_liberal.txt',
            'themes/default/images/under_construction_animated.gif',
            'themes/default/images/icons/menu/pages/guestbook.svg',
            'themes/default/images/icons/menu/pages/donate.svg',
            'themes/default/images/icons/menu/pages/advertise.svg',
            'themes/default/images/icons/contact_methods/address.svg',
            'themes/default/images/icons/contact_methods/email.svg',
            'themes/default/images/icons/contact_methods/index.html',
            'themes/default/images/icons/contact_methods/telephone.svg',
            'themes/default/images/icons/tiers/bronze.svg',
            'themes/default/images/icons/tiers/gold.svg',
            'themes/default/images/icons/tiers/index.html',
            'themes/default/images/icons/tiers/platinum.svg',
            'themes/default/images/icons/tiers/silver.svg',
            'themes/default/images/icons_monochrome/menu/pages/guestbook.svg',
            'themes/default/images/icons_monochrome/menu/pages/donate.svg',
            'themes/default/images/icons_monochrome/menu/pages/advertise.svg',
            'themes/default/images/icons_monochrome/contact_methods/address.svg',
            'themes/default/images/icons_monochrome/contact_methods/email.svg',
            'themes/default/images/icons_monochrome/contact_methods/index.html',
            'themes/default/images/icons_monochrome/contact_methods/telephone.svg',
            'themes/default/images/icons_monochrome/tiers/bronze.svg',
            'themes/default/images/icons_monochrome/tiers/gold.svg',
            'themes/default/images/icons_monochrome/tiers/index.html',
            'themes/default/images/icons_monochrome/tiers/platinum.svg',
            'themes/default/images/icons_monochrome/tiers/silver.svg',
            'sources/hooks/systems/config/search_comcode_pages.php',
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
            'templates/COMCODE_PAGE_SCREEN.tpl' => 'comcode_page_screen',
            'templates/COMCODE_PAGE_EDIT_ACTIONS.tpl' => 'comcode_page_edit_actions',
            'templates/COMCODE_PAGE_BOX.tpl' => 'comcode_page_preview',
            'templates/GENERATE_PAGE_SITEMAP.tpl' => 'administrative__comcode_page_sitemap',
            'templates/GENERATE_PAGE_SITEMAP_SCREEN.tpl' => 'administrative__comcode_page_sitemap',
            'templates/COMCODE_PAGE_MANAGE_SCREEN.tpl' => 'administrative__comcode_page_manage_screen',
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declarative.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__administrative__comcode_page_manage_screen()
    {
        require_lang('zones');
        return array(
            lorem_globalise(do_lorem_template('COMCODE_PAGE_MANAGE_SCREEN', array(
                'TITLE' => lorem_title(),
                'TABLE' => placeholder_table(),
                'SUBMIT_NAME' => lorem_word(),
                'POST_URL' => placeholder_url(),
                'HIDDEN' => '',
                'TEXT' => lorem_paragraph_html(),
                'LINKS' => array(array(
                    'LINK_IMAGE' => placeholder_image_url(),
                    'LINK_URL' => placeholder_url(),
                    'LINK_TEXT' => lorem_phrase(),
                )),
                'FILTER' => '',
                'HAS_PAGINATION' => true,
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
    public function tpl_preview__comcode_page_edit_actions()
    {
        require_lang('zones');

        return array(
            lorem_globalise(do_lorem_template('COMCODE_PAGE_EDIT_ACTIONS', array(
                'VIEW_URL' => placeholder_url(),
                'EDIT_URL' => placeholder_url(),
                'CLONE_URL' => placeholder_url(),
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
    public function tpl_preview__comcode_page_screen()
    {
        return array(
            lorem_globalise(do_lorem_template('COMCODE_PAGE_SCREEN', array(
                'BEING_INCLUDED' => false,
                'IS_PANEL' => false,
                'SUBMITTER' => placeholder_id(),
                'TAGS' => lorem_word_html(),
                'WARNING_DETAILS' => '',
                'EDIT_DATE_RAW' => placeholder_date_raw(),
                'SHOW_AS_EDIT' => lorem_phrase(),
                'CONTENT' => lorem_phrase(),
                'EDIT_URL' => placeholder_url(),
                'ADD_CHILD_URL' => placeholder_url(),
                'NAME' => placeholder_id(),
                'NATIVE_ZONE' => lorem_word(),
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
    public function tpl_preview__comcode_page_preview()
    {
        return array(
            lorem_globalise(do_lorem_template('COMCODE_PAGE_BOX', array(
                'GIVE_CONTEXT' => true,
                'PAGE' => lorem_phrase(),
                'ZONE' => lorem_phrase(),
                'URL' => placeholder_url(),
                'SUMMARY' => lorem_paragraph_html(),
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
    public function tpl_preview__administrative__comcode_page_sitemap()
    {
        $menu_paths = array();
        $menu_paths[] = array(
            'MENU' => lorem_phrase(),
            'MENU_URL' => placeholder_url(),
            'MENU_PATH_COMPONENTS' => array(lorem_phrase()),
        );

        $_page_structure = array();
        $_page_structure[] = array(
            'EDIT_URL' => placeholder_url(),
            'ZONE_NAME' => lorem_phrase(),
            'PAGE_NAME' => lorem_phrase(),
            'PAGE_TITLE' => lorem_phrase(),
            'VALIDATED' => false,
            'TODO' => false,
            'MENU_PATHS' => $menu_paths,
            'CHILDREN' => '',
        );

        $page_structure = do_lorem_template('GENERATE_PAGE_SITEMAP', array(
            'PAGE_STRUCTURE' => $_page_structure,
        ));

        return array(
            lorem_globalise(do_lorem_template('GENERATE_PAGE_SITEMAP_SCREEN', array(
                'TITLE' => lorem_title(),
                'ZONES' => array(lorem_phrase() => lorem_phrase()),
                'PAGE_STRUCTURE' => $page_structure,
            )), null, '', true)
        );
    }

    /**
     * Uninstall default content.
     */
    public function uninstall_test_content()
    {
        if (!is_suexec_like()) {
            return;
        }

        require_code('zones2');
        require_code('zones3');
        require_code('abstract_file_manager');

        $to_delete = $GLOBALS['SITE_DB']->query_select('comcode_pages', array('the_zone', 'the_page'), array('the_page' => 'lorem'));
        foreach ($to_delete as $record) {
            delete_cms_page($record['the_zone'], $record['the_page']);
        }
        $to_delete = $GLOBALS['SITE_DB']->query_select('comcode_pages', array('the_zone', 'the_page'), array('the_zone' => 'lorem'));
        foreach ($to_delete as $record) {
            delete_cms_page($record['the_zone'], $record['the_page']);
        }

        actual_delete_zone('lorem', true);
    }

    /**
     * Install default content.
     */
    public function install_test_content()
    {
        if (!is_suexec_like()) {
            return;
        }

        require_code('zones2');
        require_code('zones3');
        require_code('abstract_file_manager');

        if ($GLOBALS['SITE_DB']->query_select_value_if_there('zones', 'zone_name', array('zone_name' => 'lorem')) === null) {
            actual_add_zone('lorem', lorem_phrase(), DEFAULT_ZONE_PAGE_NAME, lorem_phrase(), 'default', 0);
        }

        $blocks = find_all_blocks();

        // Page testing all main/bottom blocks (DEFAULT_ZONE_PAGE_NAME)
        $blocks_comcode = '';
        foreach (array_keys($blocks) as $block) {
            if (substr($block, 0, 5) == 'main_') {
                $blocks_comcode .= '[title="2"]' . $block . '[/title]';
                $blocks_comcode .= '[block]' . $block . '[/block]' . "\n";
            }

            // Ones with alternate modes we want to display
            if ($block == 'side_calendar') {
                $blocks_comcode .= '[title="2"]' . $block . '[/title]';
                $blocks_comcode .= '[block="listing"]' . $block . '[/block]' . "\n";
            }
        }
        foreach (array_keys($blocks) as $block) {
            if (substr($block, 0, 7) == 'bottom_') {
                $blocks_comcode .= '[title="2"]' . $block . '[/title]';
                $blocks_comcode .= '[block]' . $block . '[/block]' . "\n";
            }
        }
        $_blocks_comcode = '[title]' . lorem_phrase() . '[/title]' . "\n\n";
        $_blocks_comcode .= '{+START,IF,{$IS_ADMIN}}' . "\n" . $blocks_comcode . '{+END}' . "\n";
        save_comcode_page('lorem', DEFAULT_ZONE_PAGE_NAME, fallback_lang(), $_blocks_comcode, 1);

        // Page testing all side blocks ('panel_left')
        $blocks_comcode = '';
        foreach (array_keys($blocks) as $block) {
            if (substr($block, 0, 5) == 'side_') {
                $blocks_comcode .= '[title="2"]' . $block . '[/title]';
                $blocks_comcode .= '[block]' . $block . '[/block]' . "\n";
            }
        }
        $_blocks_comcode = '{+START,IF,{$IS_ADMIN}}' . "\n" . $blocks_comcode . '{+END}' . "\n";
        save_comcode_page('lorem', 'panel_left', fallback_lang(), $_blocks_comcode, 1);

        // Empty pages
        $blocks_comcode = '';
        save_comcode_page('lorem', 'panel_right', fallback_lang(), $blocks_comcode, 1);

        // Simple example page ('lorem')
        $lorem_comcode = '[title]' . lorem_phrase() . '[/title]

[contents][/contents][overlay width="600" height="600"]' . lorem_chunk() . '[/overlay]

[title="2"]media[/title]

[media framed="1"]' . placeholder_image_url() . '[/media]
[media framed="1"]https://www.youtube.com/watch?v=LDfzAA8fNKU[/media]
[media_set]
[media framed="0"]' . placeholder_image_url() . '[/media]
[media framed="0"]' . placeholder_image_url() . '[/media]
[media framed="0"]' . placeholder_image_url() . '[/media]
[media framed="0"]' . placeholder_image_url() . '[/media]
[media framed="0"]' . placeholder_image_url() . '[/media]
[/media_set]

[title="2"]quote[/title]

[quote="' . lorem_phrase() . '"]
' . lorem_chunk() . '
[/quote]

[title="2"]code[/title]

[code]
' . lorem_chunk() . '
[/code]

[title="2"]ticker[/title]

[ticker]' . lorem_sentence() . '[/ticker]

[title="2"]shocker[/title]

[shocker left_0="' . lorem_phrase() . '" right_0="Example Text" left_1="Composr CMS" right_1="Is awesome"][/shocker]

[title="2"]jumping[/title]

[jumping a="Composr CMS" b="Is awesome"][/jumping]

[title="2"]hide[/title]

[hide="' . lorem_phrase() . '"]' . lorem_chunk() . '[/hide]

[title="2"]sections[/title]

[surround]
[section="Example" default="1"]' . lorem_chunk() . '[/section]
[section="Composr"]Composr CMS is awesome[/section]
[section_controller]Example,Composr[/section_controller]
[/surround]

[title="2"]tabs[/title]

[tabs="Example,Composr"]
[tab="Example" default="1"]' . lorem_chunk() . '[/tab]
[tab="Composr"]Composr CMS is awesome[/tab]
[/tabs]

[title="2"]big_tabs[/title]

[surround]
[big_tab_controller]Example,Composr[/big_tab_controller]
[big_tab="Example"]' . lorem_chunk() . '[/big_tab]
[big_tab="Composr"]Composr CMS is awesome[/big_tab]
[/surround]


[concepts
1_key="Composr" 1_value="[pulse]Awesome[/pulse] [tooltip=\"Content Management System\"]CMS[/tooltip]"
2_key="' . lorem_phrase() . '" 2_value="' . lorem_sentence() . '"
][/concepts]
';
        save_comcode_page('lorem', 'lorem', fallback_lang(), $lorem_comcode, 1, DEFAULT_ZONE_PAGE_NAME);

        // Simple example page ('menus')
        $menus_comcode = '[title]' . lorem_phrase() . '[/title]' . "\n\n";
        $menus_comcode .= '[block type="tree"]menu[/block]' . "\n\n" . '[block type="popup"]menu[/block]' . "\n\n";
        $menus_comcode .= '[block type="select"]menu[/block]' . "\n\n";
        $menus_comcode .= '[block type="embossed"]menu[/block]' . "\n\n";
        save_comcode_page('lorem', 'menus', fallback_lang(), $menus_comcode, 1, DEFAULT_ZONE_PAGE_NAME);
    }
}

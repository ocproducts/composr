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
 * @package    core_themeing
 */

/**
 * Module page class.
 */
class Module_admin_svg_sprites
{
    /**
     * Find details of the module.
     *
     * @return ?array Map of module info (null: module is disabled)
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Salman Abbas';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 1;
        $info['locked'] = true;
        $info['update_require_upgrade'] = true;
        return $info;
    }

    /**
     * Uninstall the module.
     */
    public function uninstall()
    {
    }

    /**
     * Install the module.
     *
     * @param  ?integer $upgrade_from What version we're upgrading from (null: new install)
     * @param  ?integer $upgrade_from_hack What hack version we're upgrading from (null: new-install/not-upgrading-from-a-hacked-version)
     */
    public function install($upgrade_from = null, $upgrade_from_hack = null)
    {
    }

    /**
     * Find entry-points available within this module.
     *
     * @param  boolean $check_perms Whether to check permissions
     * @param  ?MEMBER $member_id The member to check permissions as (null: current user)
     * @param  boolean $support_crosslinks Whether to allow cross links to other modules (identifiable via a full-page-link rather than a screen-name)
     * @param  boolean $be_deferential Whether to avoid any entry-point (or even return null to disable the page in the Sitemap) if we know another module, or page_group, is going to link to that entry-point. Note that "!" and "browse" entry points are automatically merged with container page nodes (likely called by page-groupings) as appropriate.
     * @return ?array A map of entry points (screen-name=>language-code/string or screen-name=>[language-code/string, icon-theme-image]) (null: disabled)
     */
    public function get_entry_points($check_perms = true, $member_id = null, $support_crosslinks = true, $be_deferential = false)
    {
        $ret = array(
            'browse' => array('SVG_SPRITES', 'admin/tool'),
            'preview_svg_sprite' => array('PREVIEW_SVG_SPRITE', 'admin/view_this'),
            'generate_svg_sprite' => array('GENERATE_SVG_SPRITE', 'admin/tool'),
        );

        return $ret;
    }

    public $title;

    /**
     * Module pre-run function. Allows us to know metadata for <head> before we start streaming output.
     *
     * @return ?Tempcode Tempcode indicating some kind of exceptional output (null: none)
     */
    public function pre_run()
    {
        $type = get_param_string('type', 'browse');

        if ($type === 'browse') {
            $this->title = get_screen_title('themes:SVG_SPRITES');
        }

        if ($type === 'preview_svg_sprite') {
            $this->title = get_screen_title('themes:PREVIEW_SVG_SPRITE');
        }

        if ($type === '_preview_svg_sprite') {
            $this->title = get_screen_title('themes:PREVIEW_SVG_SPRITE');
        }

        if ($type === 'generate_svg_sprite') {
            $this->title = get_screen_title('themes:GENERATE_SVG_SPRITE');
        }

        if ($type === '_generate_svg_sprite') {
            $this->title = get_screen_title('themes:GENERATE_SVG_SPRITE');
        }

        return null;
    }

    /**
     * Execute the module.
     *
     * @return Tempcode The result of execution
     */
    public function run()
    {
        $type = get_param_string('type', 'browse');

        if ($type == 'browse') {
            return $this->browse();
        }

        if ($type == 'preview_svg_sprite') {
            return $this->preview_svg_sprite();
        }

        if ($type == '_preview_svg_sprite') {
            return $this->_preview_svg_sprite();
        }

        if ($type == 'generate_svg_sprite') {
            return $this->generate_svg_sprite();
        }

        if ($type == '_generate_svg_sprite') {
            return $this->_generate_svg_sprite();
        }

        return new Tempcode();
    }

    /**
     * @return Tempcode The browse UI
     */
    public function browse()
    {
        require_code('templates_donext');
        return do_next_manager(
            get_screen_title('SVG_SPRITES'),
            make_string_tempcode(''),
            array(
                array('admin/view_this', array('_SELF', array('type' => 'preview_svg_sprite'), '_SELF'), do_lang('themes:PREVIEW_SVG_SPRITE')),
                array('admin/tool', array('_SELF', array('type' => 'generate_svg_sprite'), '_SELF'), do_lang('themes:GENERATE_SVG_SPRITE')),
            ),
            do_lang('SVG_SPRITES')
        );
    }

    /**
     * @return Tempcode The Choose theme to preview UI
     */
    public function preview_svg_sprite()
    {
        require_code('themes2');
        require_code('form_templates');

        $theme = $GLOBALS['FORUM_DRIVER']->get_theme(''); // Default to the theme for the Welcome zone
        $theme_entries = create_selection_list_themes($theme, false, true);
        $theme_field = form_input_list(do_lang_tempcode('CHOOSE_THEME'), make_string_tempcode(''), 'theme', $theme_entries);
        $monochrome_field = form_input_tick(do_lang_tempcode('MONOCHROME_ICONS'), '', 'monochrome', get_theme_option('use_monochrome_icons') === '1');

        $fields = new Tempcode();
        $fields->attach($theme_field);
        $fields->attach($monochrome_field);

        $post_url = build_url(array('page' => '_SELF', 'type' => '_preview_svg_sprite'), '_SELF');
        $submit_name = do_lang_tempcode('PREVIEW_SPRITE');
        $text = paragraph(do_lang_tempcode('PREVIEW_SVG_SPRITE'));

        return do_template('FORM_SCREEN', array(
            '_GUID' => '2887f783aea9475bb0955a9ee985e36e',
            'HIDDEN' => '',
            'SUBMIT_ICON' => 'admin/view_this',
            'SUBMIT_NAME' => $submit_name,
            'TITLE' => $this->title,
            'FIELDS' => $fields,
            'URL' => $post_url,
            'TEXT' => $text,
            'SUPPORT_AUTOSAVE' => true,
        ));
    }

    /**
     * @return Tempcode The Preview SVG sprite UI
     */
    public function _preview_svg_sprite()
    {
        require_code('themes');
        require_code('xml');
        require_css('adminzone');

        $theme = post_param_string('theme');
        $monochrome = post_param_integer('monochrome', 0);
        $sprite_path = get_file_base() . '/themes/' . $theme . '/images/icons' . (($monochrome === 1) ? '_monochrome' : '') . '_sprite.svg';

        if (!file_exists($sprite_path)) {
            warn_exit(do_lang('PLEASE_GENERATE_SPRITE', $theme));
        }

        $svg_xml = new CMS_simple_xml_reader(file_get_contents($sprite_path));
        $svg_xml_children = $svg_xml->gleamed[3];
        $sprite_url = find_theme_image('icons' . (($monochrome === 1) ? '_monochrome' : '') . '_sprite', true, false, $theme);
        $sprite_url .= '?t=' . microtime(true);

        $icons = new Tempcode();
        foreach ($svg_xml_children as $symbol) {
            if (!is_array($symbol) || ($symbol[0] !== 'http://www.w3.org/2000/svg:symbol')) {
                continue;
            }
            $symbol_id = (string)$symbol[1]['id'];
            $icons->attach(do_template('PREVIEW_SVG_SPRITE_ICON', array(
                'SPRITE_URL' => $sprite_url,
                'SYMBOL_ID' => $symbol_id,
                'ICON_NAME' => str_replace('__', '/', $symbol_id),
            )));
        }

        return do_template('PREVIEW_SVG_SPRITE_SCREEN', array(
            '_GUID' => '0772b3d967df4000ae58ffd42aef358f',
            'TITLE' => $this->title,
            'SPRITE_PATH' => $sprite_path,
            'ICONS' => $icons,
        ));
    }

    /**
     * @return Tempcode The Choose Theme UI
     */
    public function generate_svg_sprite()
    {
        require_code('themes2');
        require_code('form_templates');

        $theme = $GLOBALS['FORUM_DRIVER']->get_theme(''); // Default to the theme for the Welcome zone
        $theme_entries = create_selection_list_themes($theme, false, true);
        $theme_field = form_input_list(do_lang_tempcode('CHOOSE_THEME'), make_string_tempcode(''), 'theme', $theme_entries);
        $monochrome_field = form_input_tick(do_lang_tempcode('MONOCHROME_ICONS'), '', 'monochrome', get_theme_option('use_monochrome_icons') === '1');

        $fields = new Tempcode();
        $fields->attach($theme_field);
        $fields->attach($monochrome_field);

        $post_url = build_url(array('page' => '_SELF', 'type' => '_generate_svg_sprite'), '_SELF');
        $submit_name = do_lang_tempcode('GENERATE_SPRITE');
        $text = paragraph(do_lang_tempcode('GENERATE_SVG_SPRITE'));

        return do_template('FORM_SCREEN', array(
            '_GUID' => '2887f783aea9475bb0955a9ee985e36e',
            'HIDDEN' => '',
            'SUBMIT_ICON' => 'menu/adminzone/style/themes/css',
            'SUBMIT_NAME' => $submit_name,
            'TITLE' => $this->title,
            'FIELDS' => $fields,
            'URL' => $post_url,
            'TEXT' => $text,
            'SUPPORT_AUTOSAVE' => true,
        ));
    }

    /**
     * @return Tempcode The Generating Sprite UI
     */
    public function _generate_svg_sprite()
    {
        require_code('files2');
        require_code('xml');

        $theme = post_param_string('theme');
        $monochrome = post_param_integer('monochrome', 0);

        $icon_paths = array();

        $default_theme_icons_dir = get_file_base() . '/themes/default/images/icons' . (($monochrome === 1) ? '_monochrome' : '');
        $default_theme_custom_icons_dir = get_file_base() . '/themes/default/images_custom/icons' . (($monochrome === 1) ? '_monochrome' : '');

        $theme_icons_dir = get_file_base() . '/themes/' . $theme . '/images/icons' . (($monochrome === 1) ? '_monochrome' : '');
        $theme_custom_icons_dir = get_file_base() . '/themes/' . $theme . '/images_custom/icons' . (($monochrome === 1) ? '_monochrome' : '');

        if (file_exists($default_theme_icons_dir)) {
            $icon_paths = get_directory_contents($default_theme_icons_dir, $default_theme_icons_dir, IGNORE_ACCESS_CONTROLLERS, true, true, array('svg'));
        }

        if (file_exists($default_theme_custom_icons_dir)) {
            $_icon_paths = get_directory_contents($default_theme_custom_icons_dir, $default_theme_custom_icons_dir, IGNORE_ACCESS_CONTROLLERS, true, true, array('svg'));
            $icon_paths = $this->_override_icon_paths($icon_paths, $_icon_paths);
        }

        if ($theme !== 'default') {
            if (file_exists($theme_icons_dir)) {
                $_icon_paths = get_directory_contents($theme_icons_dir, $theme_icons_dir, IGNORE_ACCESS_CONTROLLERS, true, true, array('svg'));
                $icon_paths = $this->_override_icon_paths($icon_paths, $_icon_paths);
            }

            if (file_exists($theme_custom_icons_dir)) {
                $_icon_paths = get_directory_contents($theme_custom_icons_dir, $theme_custom_icons_dir, IGNORE_ACCESS_CONTROLLERS, true, true, array('svg'));
                $icon_paths = $this->_override_icon_paths($icon_paths, $_icon_paths);
            }
        }

        $base_path_regex = '^' . preg_quote(get_file_base(), '#') . '/themes/[\w\-]+/images(_custom)?/icons(_monochrome)?/';

        $old_icon_paths = $icon_paths;
        $icon_paths = array();
        foreach ($old_icon_paths as $icon_path) {
            $icon_name = substr(preg_replace('#' . $base_path_regex . '#', '', $icon_path), 0, -4);
            $icon_paths[$icon_name] = $icon_path;
        }

        ksort($icon_paths);

        $output = '<' . '?xml version="1.0" encoding="utf-8"?' . '>' . "\n";
        $output .= '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">' . "\n";

        foreach ($icon_paths as $icon_name => $icon_path) {
            $xml = new CMS_simple_xml_reader(file_get_contents($icon_path));
            $output .= '<symbol viewBox="' . $xml->gleamed[1]['viewBox'] . '" id="icon_' . str_replace('/', '__', $icon_name) . '">' . "\n";
            foreach ($xml->gleamed[3] as $child) {
                if (!is_array($child)) {
                    // whitespace?
                    continue;
                }
                $child_xml = $xml->pull_together(array($child), array('' => 'http://www.w3.org/2000/svg', 'xlink:' => 'http://www.w3.org/1999/xlink')) . "\n";

                if (preg_replace('/\s/', '', $child_xml) === '<defs></defs>') {
                    continue; // Skip empty <defs> elements
                }

                $output .= $child_xml;
            }
            $output .= "</symbol>\n";
        }

        $output .= "</svg>\n";

        $sprite_path = get_file_base() . '/themes/default/images/icons' . (($monochrome === 1) ? '_monochrome' : '') . '_sprite.svg';
        $icons_added = array_keys($icon_paths);

        file_put_contents($sprite_path, $output);

        return do_template('GENERATE_SVG_SPRITE_SCREEN', array(
            '_GUID' => '1318e8d111ee4715aae471976f495ccd',
            'TITLE' => $this->title,
            'SPRITE_PATH' => $sprite_path,
            'ICONS_ADDED' => $icons_added,
        ));
    }

    /**
     * Override icon paths.
     *
     * @param  array $icon_paths Icon paths
     * @param  array $overriding_icon_paths Overriding icon paths
     * @return array
     */
    public function _override_icon_paths($icon_paths, $overriding_icon_paths)
    {
        $base_path_regex = '^' . preg_quote(get_file_base(), '#') . '/themes/[\w\-]+/images(_custom)?/icons(_monochrome)?/';

        foreach ($overriding_icon_paths as $overriding_icon_path) {
            $overriding_icon_name = preg_replace('#' . $base_path_regex . '#', '', $overriding_icon_path);
            $icon_paths = array_filter($icon_paths, function ($icon_path) use ($base_path_regex, $overriding_icon_name) {
                // Remove paths for icons that exist in $overriding_icon_paths
                return preg_match('#' . $base_path_regex . preg_quote($overriding_icon_name, '#') . '#', $icon_path) === 0;
            });
        }

        return array_merge($icon_paths, $overriding_icon_paths);
    }
}

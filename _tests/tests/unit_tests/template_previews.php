<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/*EXTRA FUNCTIONS: diff_simple_2*/

/**
 * Composr test case class (unit testing).
 */
class template_previews_test_set extends cms_test_case
{
    public $template_id;

    public function setUp()
    {
        parent::setUp();

        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(0);
        }

        $_GET['keep_has_js'] = '0';
        push_query_limiting(false);
        $_GET['keep_query_limit'] = '0';
        safe_ini_set('memory_limit', '-1');
        $_GET['wide'] = '1';
        $_GET['keep_devtest'] = '1';
        $_GET['keep_has_js'] = '0';
        $_GET['keep_minify'] = '0'; // Disables resource merging, which messes with results
        $_GET['keep_fatalistic'] = '1';
        $GLOBALS['OUTPUT_STREAMING'] = false;

        require_code('lorem');
        require_code('files');
    }

    public function testNoMissingPreviews()
    {
        $templates = array();
        $dh = opendir(get_file_base() . '/themes/default/templates');
        while (($f = readdir($dh)) !== false) {
            if ((strtolower(substr($f, -4)) == '.tpl') && ($f[0] != '.')) {
                $templates[] = 'templates/' . $f;
            }
        }

        $all_previews = find_all_previews__by_template();

        foreach ($templates as $t) {
            $this->assertFalse((!array_key_exists($t, $all_previews)), 'Missing preview for: ' . $t);
        }

        safe_ini_set('ocproducts.type_strictness', '0');
        safe_ini_set('ocproducts.xss_detect', '0');
    }

    public function testScreenPreview()
    {
        require_code('webstandards');
        require_lang('webstandards');
        require_code('themes2');

        $themes = find_all_themes();
        foreach (array_keys($themes) as $theme) {
            if ($theme == '_unnamed_') {
                continue;
            }

            $this->screenPreviewTestForTheme($theme);
        }

        safe_ini_set('ocproducts.type_strictness', '0');
        safe_ini_set('ocproducts.xss_detect', '0');
    }

    protected function screenPreviewTestForTheme($theme)
    {
        global $THEME_BEING_TESTED;
        $THEME_BEING_TESTED = $theme;

        global $LOADED_TPL_CACHE, $BLOCKS_CACHE, $PANELS_CACHE;

        global $RECORD_TEMPLATES_USED, $RECORDED_TEMPLATES_USED;
        $RECORD_TEMPLATES_USED = true;

        $only_do_these = array(); // If you want to test specific templates temporarily put the template names (without .tpl) in this array. But remove again before you commit!

        $lists = find_all_previews__by_template();
        foreach ($lists as $template => $list) {
            if (count($only_do_these) != 0) {
                if (!in_array($template, $only_do_these)) {
                    continue;
                }
            }

            if ($template == 'templates/tempcode_test.tpl') {
                continue;
            }
            if ($template == 'templates/ADMIN_ZONE_SEARCH.tpl') {
                continue; // Only in admin theme, causes problem
            }

            if (is_plain_text_template($template)) {
                continue;
            }

            $hook = $list[0];
            $function = $list[1];

            if (is_file(get_file_base() . '/_tests/screens_tested/' . $theme . '__' . $function . '.tmp')) {
                continue; // To make easier to debug through
            }

            if (php_function_allowed('set_time_limit')) {
                @set_time_limit(0);
            }

            init__lorem();
            push_output_state();
            $LOADED_TPL_CACHE = array();
            $BLOCKS_CACHE = array();
            $PANELS_CACHE = array();

            $RECORDED_TEMPLATES_USED = array();

            $out = render_screen_preview($template, $hook, $function);

            restore_output_state();

            $flag = false;
            foreach ($lists as $template_2 => $list_2) {
                if (count($only_do_these) != 0) {
                    if (!in_array($template_2, $only_do_these)) {
                        continue;
                    }
                }

                if ($template_2 == 'templates/tempcode_test.tpl') {
                    continue;
                }

                if (is_plain_text_template($template_2)) {
                    continue;
                }
                if ($list_2[1] == $function) {
                    // Ignore templates designed for indirect inclusion
                    if (in_array($template_2, array(
                        'templates/NEWSLETTER_PREVIEW.tpl',
                        'templates/GLOBAL_HELPER_PANEL.tpl',
                        'templates/GLOBAL_HTML_WRAP_mobile.tpl',
                        'templates/HTML_HEAD.tpl',
                        'templates/MEMBER_TOOLTIP.tpl',
                        'templates/FORM_STANDARD_END.tpl',
                        'templates/MEMBER_BAR_SEARCH.tpl',
                        'templates/MENU_LINK_PROPERTIES.tpl',
                    ))) {
                        continue;
                    }

                    $this->assertTrue(array_key_exists($template_2, $RECORDED_TEMPLATES_USED), $template_2 . ' not used in preview as claimed in ' . $hook . '/' . $function);
                    if (!array_key_exists($template_2, $RECORDED_TEMPLATES_USED)) {
                        $flag = true;
                    }
                }
            }

            if (!is_object($out)) {
                fatal_exit('Claimed screen for ' . $template . ' is not defined');
            }
            $_out = $out->evaluate();

            if (stripos($_out, '<html') !== false && strpos($_out, '<xsl') === false) {
                $result = check_xhtml($_out, false, false, false, true, true, true, false, false, true);
                if (($result !== null) && (count($result['errors']) == 0)) {
                    $result = null;
                }
            } else {
                $result = null;
            }
            $this->assertTrue(($result === null), $hook . ':' . $function);
            if ($result !== null) {
                require_code('view_modes');
                display_webstandards_results($_out, $result, false, false);
            } else {
                if (!$flag) {
                    cms_file_put_contents_safe(get_file_base() . '/_tests/screens_tested/' . $theme . '__' . $function . '.tmp', '1', FILE_WRITE_FIX_PERMISSIONS);
                }
            }
        }

        $THEME_BEING_TESTED = null;
    }

    public function testRepeatConsistency()
    {
        global $STATIC_TEMPLATE_TEST_MODE, $LOADED_TPL_CACHE, $BLOCKS_CACHE, $PANELS_CACHE;
        $STATIC_TEMPLATE_TEST_MODE = true;

        global $HAS_KEEP_IN_URL_CACHE;
        $_GET['wide'] = '1';
        $HAS_KEEP_IN_URL_CACHE = null;

        $lists = find_all_previews__by_screen();
        foreach ($lists as $function => $tpls) {
            $template = $tpls[0];
            $hook = null;

            if ($template == 'ADMIN_ZONE_SEARCH.tpl') {
                continue; // Only in admin theme, causes problem
            }

            if (is_file(get_file_base() . '/_tests/screens_tested/consistency__' . $function . '.tmp')) {
                continue; // To make easier to debug through
            }

            if (php_function_allowed('set_time_limit')) {
                @set_time_limit(0);
            }

            init__lorem();
            push_output_state();
            $LOADED_TPL_CACHE = array();
            $BLOCKS_CACHE = array();
            $PANELS_CACHE = array();
            $out1 = render_screen_preview($template, $hook, $function);
            $_out1 = $this->cleanupVaryingCode($out1->evaluate());
            restore_output_state();

            init__lorem();
            push_output_state();
            $LOADED_TPL_CACHE = array();
            $BLOCKS_CACHE = array();
            $PANELS_CACHE = array();
            $out2 = render_screen_preview($template, $hook, $function);
            $_out2 = $this->cleanupVaryingCode($out2->evaluate());
            restore_output_state();

            $different = ($_out1 != $_out2);

            $this->assertFalse($different, 'Screen preview not same each time, ' . $function);

            if (!$different) {
                cms_file_put_contents_safe(get_file_base() . '/_tests/screens_tested/consistency__' . $function . '.tmp', '1', FILE_WRITE_FIX_PERMISSIONS);
            } else {
                cms_file_put_contents_safe(get_file_base() . '/_tests/screens_tested/v1__' . '.tmp', $_out1, FILE_WRITE_FIX_PERMISSIONS);
                cms_file_put_contents_safe(get_file_base() . '/_tests/screens_tested/v2__' . '.tmp', $_out2, FILE_WRITE_FIX_PERMISSIONS);

                exit('Error! Do a diff between v1__.tmp and v2__.tmp');
            }

            unset($out1);
            unset($out2);
        }

        safe_ini_set('ocproducts.type_strictness', '0');
        safe_ini_set('ocproducts.xss_detect', '0');
    }

    protected function cleanupVaryingCode($_out)
    {
        $_out = preg_replace('#\s*<script[^<>]*>.*</script>\s*#Us', '', $_out); // We need to replace CSS/JS as load order/merging is not guaranteed consistent
        $_out = preg_replace('#\s*<style[^<>]*>.*</style>\s*#Us', '', $_out);
        $_out = preg_replace('#\s*<link[^<>]*>\s*#', '', $_out);
        $_out = preg_replace('#\s*<meta[^<>]*>\s*#', '', $_out);

        // Maybe got into content, or somehow otherwise double encoded
        $_out = preg_replace('#\s*&lt;script.*&gt;.*&lt;/script&gt;\s*#Us', '', $_out); // We need to replace CSS/JS as load order/merging is not guaranteed consistent
        $_out = preg_replace('#\s*&lt;style.*&gt;.*&lt;/style&gt;\s*#Us', '', $_out);
        $_out = preg_replace('#\s*&lt;link.*&gt;\s*#', '', $_out);

        $_out = preg_replace('#\s#', '', $_out);

        return $_out;
    }

    public function testNoMissingParams()
    {
        global $ATTACHED_MESSAGES, $ATTACHED_MESSAGES_RAW;

        $lists = find_all_previews__by_screen();
        foreach ($lists as $function => $tpls) {
            $template = $tpls[0];
            $hook = null;

            if ($template == 'ADMIN_ZONE_SEARCH.tpl') {
                continue; // Only in admin theme, causes problem
            }

            if (is_file(get_file_base() . '/_tests/screens_tested/nonemissing__' . $function . '.tmp')) {
                continue; // To make easier to debug through
            }

            if (php_function_allowed('set_time_limit')) {
                @set_time_limit(0);
            }

            $ATTACHED_MESSAGES = new Tempcode();
            $ATTACHED_MESSAGES_RAW = array();
            $out1 = render_screen_preview($template, $hook, $function);

            if ($ATTACHED_MESSAGES === null) {
                $ATTACHED_MESSAGES = new Tempcode();
            }
            $put_out = (!$ATTACHED_MESSAGES->is_empty()) || (count($ATTACHED_MESSAGES_RAW) > 0);
            $this->assertFalse($put_out, 'Messages put out by ' . $function . '  (' . strip_html($ATTACHED_MESSAGES->evaluate()) . ')');

            if (!$put_out) {
                cms_file_put_contents_safe(get_file_base() . '/_tests/screens_tested/nonemissing__' . $function . '.tmp', '1', FILE_WRITE_FIX_PERMISSIONS);
            }

            unset($out1);
        }

        safe_ini_set('ocproducts.type_strictness', '0');
        safe_ini_set('ocproducts.xss_detect', '0');
    }

    public function testNoRedundantFunctions()
    {
        $hooks = find_all_hooks('systems', 'addon_registry');
        foreach ($hooks as $hook => $place) {
            require_code('hooks/systems/addon_registry/' . $hook);

            $ob = object_factory('Hook_addon_registry_' . $hook);
            if (!method_exists($ob, 'tpl_previews')) {
                continue;
            }
            $used = array_unique($ob->tpl_previews());

            $code = file_get_contents(get_file_base() . '/' . $place . '/hooks/systems/addon_registry/' . $hook . '.php');

            $matches = array();
            $num_matches = preg_match_all('#function tpl\_preview\_\_(.*)\(#U', $code, $matches);
            for ($i = 0; $i < $num_matches; $i++) {
                $this->assertTrue(in_array($matches[1][$i], $used), 'Non-used screen function ' . $matches[1][$i]);
            }
        }

        safe_ini_set('ocproducts.type_strictness', '0');
        safe_ini_set('ocproducts.xss_detect', '0');
    }

    public function testNoDoublePreviews()
    {
        $all_used = array();

        $hooks = find_all_hook_obs('systems', 'addon_registry', 'Hook_addon_registry_');
        foreach ($hooks as $ob) {
            if (!method_exists($ob, 'tpl_previews')) {
                continue;
            }
            $used = array_unique($ob->tpl_previews());
            foreach (array_keys($used) as $u) {
                $this->assertFalse(array_key_exists($u, $all_used), 'Double defined ' . $u);
            }
            $all_used += $used;
        }

        safe_ini_set('ocproducts.type_strictness', '0');
        safe_ini_set('ocproducts.xss_detect', '0');
    }
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/**
 * Composr test case class (unit testing).
 */
class tutorials_all_linked_test_set extends cms_test_case
{
    public $tutorials;

    public function setUp()
    {
        require_code('tutorials');

        $_GET['keep_tutorial_test'] = '1';

        $this->tutorials = list_tutorials();

        parent::setUp();
    }

    function testHaveFullMetaData()
    {
        foreach ($this->tutorials as $tutorial_name => $tutorial) {
            if (is_numeric($tutorial_name)) {
                continue;
            }

            $this->assertTrue($tutorial['title'] != '', 'Title undefined for ' . $tutorial_name);
            $this->assertTrue($tutorial['author'] != '', 'Author undefined for ' . $tutorial_name);
            $this->assertTrue($tutorial['summary'] != '', 'Summary undefined for ' . $tutorial_name);
            $this->assertTrue($tutorial['icon'] != '', 'Icon undefined for ' . $tutorial_name);
            $this->assertTrue($tutorial['tags'] != array(), 'Tags undefined for ' . $tutorial_name);
            $this->assertTrue(array_intersect($tutorial['raw_tags'], array('novice', 'regular', 'expert')) != array(), 'No difficulty level defined for ' . $tutorial_name);
        }
    }

    function testAddonLinkage()
    {
        foreach ($this->tutorials as $tutorial_name => $tutorial) {
            foreach ($tutorial['tags'] as $tag) {
                if (strtolower($tag) == $tag) { // Addon tag
                    require_code('hooks/systems/addon_registry/' . $tag);
                    $ob = object_factory('Hook_addon_registry_' . $tag);
                    $tutorials = $ob->get_applicable_tutorials();
                    $this->assertTrue(in_array($tutorial_name, $tutorials), $tag . ' addon_registry hook not referring back to ' . $tutorial_name);
                }
            }
        }

        $hooks = find_all_hooks('systems', 'addon_registry');
        foreach (array_keys($hooks) as $hook) {
            require_code('hooks/systems/addon_registry/' . $hook);
            $ob = object_factory('Hook_addon_registry_' . $hook);
            $tutorials = $ob->get_applicable_tutorials();
            foreach ($tutorials as $tutorial_name) {
                $tutorial = get_tutorial_metadata($tutorial_name);
                $this->assertTrue(in_array($hook, $tutorial['tags']), $tutorial_name . ' tutorial tag not referring back to addon_registry hook ' . $hook);
            }
        }
    }

    function testIconLinkage()
    {
        $icons_used = array();
        foreach ($this->tutorials as $tutorial_name => $tutorial) {
            $icons_used[] = $tutorial['icon'];
        }

        /*
        This isn't going to pass. We don't have that many icons.
        $_icons_used = array_count_values($icons_used);
        foreach ($_icons_used as $icon => $count) {
            $this->assertTrue($count <= 3, basename($icon, '.png') . ' tag icon used too much (' . integer_format($count) . ' times), try a more specific tag at the front of the tag list');
        }
        */

        $dh = opendir(get_custom_file_base() . '/themes/default/images_custom/tutorial_icons');
        while (($f = readdir($dh)) !== false) {
            if (substr($f, -4) == '.png') {
                $icon = basename($f, '.png');
                if (!in_array($icon, array('css', 'javascript', 'php', 'video' /*Generic ones we aren't using yet*/))) {
                    $this->assertTrue(in_array(find_theme_image('tutorial_icons/' . $icon), $icons_used), $icon . ' icon is not used');
                }
            }
        }
        closedir($dh);
    }

    function testHasStandardParts()
    {
        $path = get_custom_file_base() . '/docs/pages/comcode_custom/EN';
        $dh = opendir($path);
        while (($f = readdir($dh)) !== false) {
            if (substr($f, -4) == '.txt') {
                if ($f == 'panel_top.txt') {
                    continue;
                }

                $c = file_get_contents($path . '/' . $f);
                $this->assertTrue(strpos($c, '{$SET,tutorial_add_date,') !== false, $f . ' has no defined add date');
                $this->assertTrue(strpos($c, '[block]main_tutorial_rating[/block]') !== false, $f . ' has no rating block');
                if (preg_match('#^sup\_#', $c) == 0 && substr_count($c, '[title="2"') > 1 && strpos($f, 'codebook') === false) {
                    $this->assertTrue(strpos($c, '[contents]decimal,lower-alpha[/contents]') !== false, $f . ' has no TOC');
                }
            }
        }
        closedir($dh);
    }

    function testHasSomePinned()
    {
        $count = 0;
        foreach ($this->tutorials as $tutorial_name => $tutorial) {
            if ($tutorial['pinned']) {
                $count++;
            }
        }

        $desired = 8;
        $this->assertTrue($count == $desired, 'You should pin exactly ' . integer_format($desired) . ' tutorials, you have pinned ' . integer_format($count));
    }

    function testTagSet()
    {
        $tags = list_tutorial_tags(true);
        foreach ($tags as $tag) {
            $this->assertTrue(find_theme_image('tutorial_icons/' . _find_tutorial_image_for_tag($tag), true) != '', 'Tag ' . $tag . ' has no defined image');
        }
    }
}

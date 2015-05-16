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
class tracker_categories_test_set extends cms_test_case
{
    public function testHasAddons()
    {
        $post = array();
        $categories = unserialize(http_download_file(get_brand_base_url() . '/data_custom/composr_homesite_web_service.php?call=get_tracker_categories', null, true, false, 'Composr Test Platform', $post));
        $addons = find_all_hooks('systems', 'addon_registry');
        foreach ($addons as $addon => $place) {
            if ($place == 'sources') {
                $this->assertTrue(in_array($addon, $categories), $addon);
            }
        }
    }

    public function testNoUnknownAddons()
    {
        $post = array();
        $categories = unserialize(http_download_file(get_brand_base_url() . '/data_custom/composr_homesite_web_service.php?call=get_tracker_categories', null, true, false, 'Composr Test Platform', $post));
        $addons = find_all_hooks('systems', 'addon_registry');
        foreach ($categories as $category) {
            if (strtolower($category) != $category) {
                continue; // Only lower case must correspond to addons
            }
            if (strpos($category, '(old)') !== false) {
                continue;
            }

            $this->assertTrue(array_key_exists($category, $addons), $category);
        }
    }
}

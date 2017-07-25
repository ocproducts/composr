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

/**
 * Composr test case class (unit testing).
 */
class _health_check_test_set extends cms_test_case
{
    public function testHealthCheck()
    {
        require_code('health_check');

        $has_fails = false;
        $all_results = run_health_check($has_fails, null, true, true, true, false, true);

        foreach ($all_results as $_bits) {
            list($category_label, $results) = $_bits;
            foreach ($results as $_result) {
                list($section_label, $result, $message) = $_result;
                $this->assertTrue($result != HEALTH_CHECK__FAIL, $category_label . ': ' . $section_label . ': ' . $message);
            }
        }
    }

    // TODO in v11:
        // TODO: cron_log.txt -> cron.log
        // TODO: document data_custom/health_check.log
        // TODO: Strewn TODOs
            // TODO: _health_check
            // TODO: security_hackattack
            // TODO: performance_bloat
            // TODO: install_environment
        // TODO: Move over to bundled
        // TODO: Documentation:
            // TODO: List feature in composr_homesite_featuretray.php
            // TODO: Move addon description mostly over to a tutorial, next to where uptime checking is documented; make sure /s/data_custom/data/
            // TODO: Add to sup_professional_upgrading tutorial
            // TODO: Add to codebook_standards tutorial near the bottom (agency standards)
            // TODO: Add data/health_check.php "Scripts and tools" part of codebook_3 tutorial
        // TODO: Mark done on tracker https://compo.sr/tracker/view.php?id=3314,
}

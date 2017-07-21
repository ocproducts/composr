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

        $all_results = run_health_check(false, false, false);

        foreach ($all_results as $_bits) {
            list($category_label, $results) = $_bits;
            foreach ($results as $_result) {
                list($section_label, $result, $message) = $_result;
                $this->assertTrue($result != HEALTH_CHECK__FAIL, $category_label . ': ' . $section_label . ': ' . $message);
            }
        }
    }

    // TODO: Add chmod test

    // -- integration --

    // TODO: Make lots of config options

    // TODO: The checks should be initiated from a new "Health Check" item on the 'Tools' menu of the Admin Zone, which would call manual mode. There'd be checkboxes to say what tests to run, very similar to 'Website cleanup tools'.
    // TODO: Results would be shown in a table, broken down into categories, then how how many tests passed in each section, and what failed. Each failed check would quote the codename of the hook that failed, and there'd be a config option to list codenames of hooks to not run.

    // TODO: Map $is_test_site to config option

    // TODO: Checks would also be runnable by a health_check.php script in data_custom. This would need http-authentication to run, or an explicit login as an admin. It would need to be documented in the codebook (which lists manually callable scripts). It should allow a parameter to filter which checks to run.

    // TODO: Tie into CRON, but with a config option of whether it runs. It should run as the first CRON hook. E-mail results on a new notification type ("Automatic check failure"). A config option would allow specifying whether to get a daily "all is good" e-mail sent out.

    // -- testing --

    // TODO: Test everything on compo.sr

    // -- documentation in v11 --

    // TODO: List feature in our features list.

    // TODO: Document this Health Check system, including all the checks that run, and how it needs CRON, and how you can plug an external uptime checker tool into the health_check.php script. Maybe this would all be documented next to our advice about something like Uptime Robot.
    /*
    We want to be able to automatically detect when something goes wrong with a website.
    This could be:
     - Software compatibility issue arisen
     - Upgrade fault
     - Hardware failure
     - Hack-attack
     - Some important admin item forgotten
     - Some kind of screw up
    The web is just far too complex and commoditised now for people to be able to intentionally check for everything that could go wrong. We need to get all the checks automated into the system.
    */

    // TODO: Document in the Code Book: Health Check vs Testing Platform vs Local web-standards checks vs PHP-Info vs Website Cleanup Tools vs Staff Checklist vs Health Check manual linking to external tools. Most tests will still be done in the dev cycle (testing platform) [due to needing extra code, or taking a long time to run, or being destructive]

    // TODO: Add running a Health Check to the sup_professional_upgrading and the codebook_standards tutorials.

    // -- v11 --

    // TODO: Move over to bundled in Composr v11

    // TODO: Strewn TODOs

    // TODO: Strip from 'PHP-info' and the Admin Zone dashboard, where it runs currently.

    // TODO: Mark done on tracker https://compo.sr/tracker/view.php?id=3314
}

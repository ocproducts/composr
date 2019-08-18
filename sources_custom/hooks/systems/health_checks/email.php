<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    better_mail
 */

/*EXTRA FUNCTIONS: error_log|Swift_.**/

/*FORCE_ORIGINAL_LOAD_FIRST*/

class Hx_health_check_email extends Hook_health_check_email
{
    /**
     * Run a section of health checks.
     *
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     * @param  ?array $urls_or_page_links List of URLs and/or page-links to operate on, if applicable (null: those configured)
     * @param  ?array $comcode_segments Map of field names to Comcode segments to operate on, if applicable (null: N/A)
     */
    public function testSMTPLogin($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null, $urls_or_page_links = null, $comcode_segments = null)
    {
        if ($check_context == CHECK_CONTEXT__INSTALL) {
            return;
        }
        if ($check_context == CHECK_CONTEXT__SPECIFIC_PAGE_LINKS) {
            return;
        }

        if (!addon_installed('better_mail')) {
            return;
        }

        if ((get_option('smtp_sockets_use') == '0') || (!php_function_allowed('fsockopen'))) {
            $this->stateCheckSkipped('SMTP mailer not enabled');

            return;
        }

        $host = get_option('smtp_sockets_host');
        $port = intval(get_option('smtp_sockets_port'));
        $username = get_option('smtp_sockets_username');
        $password = get_option('smtp_sockets_password');

        require_lang('mail');

        $error = null;

        require_code('swift_mailer/lib/swift_required');
        $transport = (new Swift_SmtpTransport($host, $port))
            ->setUsername($username)
            ->setPassword($password);
        if (($port == 419) || ($port == 465) || ($port == 587)) {
            $transport->setEncryption('tls');
        }

        try {
            $transport->start();
        }
        catch (Swift_SwiftException $e) {
            $error = $e->getMessage();
        }

        $this->assertTrue($error === null, 'SMTP login failed with ' . (($error === null) ? 'N/A' : $error));

        if ($error !== null) {
            if (running_script('cron_bridge')) {
                @error_log('Mailer error: ' . $error); // We log this, as Health Check is not going to be able to send an e-mail
            }
        }
    }
}

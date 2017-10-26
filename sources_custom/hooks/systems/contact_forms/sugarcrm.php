<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    sugarcrm
 */

class Hook_contact_forms_sugarcrm
{
    public function dispatch($subject, $body, $to_email, $to_name, $from_email, $from_name, $attachments, $body_parts, $body_prefix, $body_suffix)
    {
        require_code('sugarcrm');

        global $SUGARCRM;

        if ($SUGARCRM === null) {
            return false;
        }

        try {
            $success = save_message_into_sugarcrm_as_configured(($subject == get_site_name()) ? '' : $subject, $body, $from_email, $from_name, $attachments, $body_parts, $_POST + $_GET + $_COOKIE);
        }
        catch (Exception $e) {
            sugarcrm_failed($e->getMessage());
            return false;
        }

        if (!$success) {
            return false;
        }

        return (get_option('sugarcrm_exclusive_messaging') == '1');
    }
}

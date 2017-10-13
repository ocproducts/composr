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

// Built using this library: https://github.com/asakusuma/SugarCRM-REST-API-Wrapper-Class
// Dev guide: http://support.sugarcrm.com/Documentation/Sugar_Developer/Sugar_Developer_Guide_6.5/Application_Framework/Web_Services/

function init__sugarcrm()
{
    global $SUGARCRM;
    $SUGARCRM = null;

    require_code('sugar_crm_lib');
    require_code('curl');

    $base_url = get_option('sugarcrm_base_url');
    $username = get_option('sugarcrm_username');
    $password = get_option('sugarcrm_password');

    if ((empty($base_url)) || (empty($username))) {
        return;
    }

    $SUGARCRM = new SugarWrapper;

    $SUGARCRM->setUrl($base_url . '/service/v2/rest.php');
    $SUGARCRM->setUsername($username);
    $SUGARCRM->setPassword($password);

    try {
        if (!$SUGARCRM->connect()) {
            sugarcrm_failed('Could not connect to SugarCRM');
        }
    }
    catch (Exception $e) {
        sugarcrm_failed($e->getMessage());
    }
}

function sugarcrm_failed($message)
{
    global $SUGARCRM;
    $SUGARCRM = null;

    if (php_function_allowed('error_log')) {
        error_log('SugarCRM issue: ' . $message, 0);
    }
    require_code('failure');
    relay_error_notification(false, $message);
}

function get_or_create_sugarcrm_account($company)
{
    global $SUGARCRM;

    $response = $SUGARCRM->get(
        'Accounts',
        array('id'),
        array(
            'where' => 'name=\'' . db_escape_string($company) . '\'',
        )
    );
    if (isset($response    [0])) {
        $account_id = $response    [0];
    } else {
        $response = $SUGARCRM->set(
            'Accounts',
            array(
                array('name' => 'name', 'value' => $company),
            )
        );
        $account_id = $response['id'];
    }
    return $account_id;
}

function get_sugarcrm_contact($email_address, $account_id = null)
{
    global $SUGARCRM;

    //$where = 'email1=\'' . db_escape_string($email_address) . '\'';   Not queryable
    $where = "contacts.id IN (SELECT bean_id FROM email_addr_bean_rel eabr JOIN email_addresses ea ON (eabr.email_address_id = ea.id) WHERE bean_module = 'Contacts' AND ea.email_address='" . db_escape_string($email_address) . "' AND eabr.deleted=0)";

    $response = $SUGARCRM->get(
        'Contacts',
        array('id', 'account_id', 'name', 'account_name'),
        array(
            'where' => $where,
        )
    );

    if ($account_id !== null) {
        // We have to do with filtering
        foreach ($response as $contact_details) {
            if ($contact_details['account_id'] === $account_id) {
                if (!isset($contact_details['account_name'])) {
                    $contact_details['account_name'] = $contact_details['name']; // For older versions of SugarCRM
                }

                return $contact_details;
            }
        }
        return null;
    }

    if (isset($response[0])) {
        // Return first result
        $contact_details = $response[0];
        return $contact_details;
    }

    return null;
}

function deconstruct_long_name($username)
{
    $username = str_replace(array('_', '-'), array(' ', ' '), $username);

    if (strpos($username, ' ') === false) {
        $matches = array();
        $name_parts = array();
        $num_matches = preg_match_all('#([A-Z]+[^A-Z]*)#i', $username, $matches);
        for ($i = 0; $i < $num_matches; $i++) {
            $name_parts[] = $matches[1][$i];
        }
    } else {
        $name_parts = explode(' ', $username);
    }

    $last_name = cms_mb_ucwords(trim(array_pop($name_parts), '0123456789'));
    $first_name = cms_mb_ucwords(implode(' ', $name_parts));

    return array($first_name, $last_name);
}

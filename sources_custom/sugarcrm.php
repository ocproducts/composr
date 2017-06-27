<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

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

    $SUGARCRM = new SugarWrapper;

    $base_url = get_option('sugarcrm_base_url');
    $username = get_option('sugarcrm_username');
    $password = get_option('sugarcrm_password');

    $SUGARCRM->setUrl($base_url . '/service/v2/rest.php');
    $SUGARCRM->setUsername($username);
    $SUGARCRM->setPassword($password);

    $SUGARCRM->connect();
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
        array('id', 'account_id', 'name'),
        array(
            'where' => $where,
        )
    );

    if ($account_id !== null) {
        // We have to do with filtering
        foreach ($response as $contact_details) {
            if ($contact_details['account_id'] === $account_id) {
                return $contact_details;
            }
        }
        return null;
    }

    if (isset($response[0])) {
        // Return first result
        $contact_details = $response    [0];
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

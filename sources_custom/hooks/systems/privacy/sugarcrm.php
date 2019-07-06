<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    sugarcrm
 */

/**
 * Hook class.
 */
class Hook_privacy_sugarcrm extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('sugarcrm')) {
            return null;
        }

        return array(
            'cookies' => array(
            ),

            'positive' => array(
            ),

            'general' => array(
                array(
                    'heading' => 'Information transfer',
                    'action' => 'Personal information will be held in our CRM (Customer Relationship Management) tool.',
                    'reason' => 'So we can hold accurate status of our sales and support relationships.',
                ),
            ),

            'database_records' => array(
            ),
        );
    }
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    gallery_syndication
 */

/**
 * Hook class.
 */
class Hook_oauth_youtube
{
    /**
     * Standard information about an oAuth profile.
     *
     * @return array Map of oAuth details
     */
    public function info()
    {
        return array(
            'label' => 'YouTube',
            'available' => addon_installed('gallery_syndication'),
            'protocol' => 'oauth2',
            'options' => array(
                'client_id' => 'google_apis_client_id',
                'client_secret' => 'google_apis_client_secret',
                'api_key' => 'google_apis_api_key',
            ),
            'saved_data' => array(
                'refresh_token_key' => 'youtube_refresh_token',
            ),
            'refresh_token' => null,
            'endpoint' => 'https://accounts.google.com/o/oauth2',
            'scope' => 'https://gdata.youtube.com',
        );
    }
}
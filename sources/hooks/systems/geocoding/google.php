<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/**
 * Hook class.
 */
class Hook_geocoding_google
{
    /**
     * Whether the service is available.
     *
     * @param  boolean $reverse Whether reverse geocoding is requested
     * @return boolean Whether it is
     */
    public function is_available($reverse = false)
    {
        // No key actually needed for Google, but we'll put a preference on other services
        $key1 = get_option('bing_geocoding_api_key');
        $key2 = get_option('mapquest_geocoding_api_key');
        return ($key1 == '') && ($key2 == '');
    }

    /**
     * Geocode a written location.
     *
     * @param  string $location Written location
     * @param  ?Tempcode $error_msg Error message (written by reference) (null: not returned)
     * @return ?array A tuple: Latitude, Longitude, NE lat, NE lng, SW lat, SW lng (null: error)
     */
    public function geocode($location, &$error_msg = null)
    {
        $url_params = '&address=' . urlencode($location);
        $result = $this->_geocode($url_params, $error_msg);
        if ($result === null) {
            return null;
        }

        if (!isset($result['results'][0])) {
            $error_msg = do_lang_tempcode('GEOCODE_INCOMPLETE');
            return null;
        }
        $r = $result['results'][0];

        if (!isset($r['geometry']['location'])) {
            $error_msg = do_lang_tempcode('GEOCODE_INCOMPLETE');
            return null;
        }

        $latitude = $r['geometry']['location']['lat'];
        $longitude = $r['geometry']['location']['lng'];

        $ne_latitude = $r['geometry']['bounds']['northeast']['lat'];
        $ne_longitude = $r['geometry']['bounds']['northeast']['lng'];
        $sw_latitude = $r['geometry']['bounds']['southwest']['lat'];
        $sw_longitude = $r['geometry']['bounds']['southwest']['lng'];

        return array($latitude, $longitude, $ne_latitude, $ne_longitude, $sw_latitude, $sw_longitude);
    }

    /**
     * Geocode a latitude & longitude.
     *
     * @param  float $latitude Latitude
     * @param  float $longitude Longitude
     * @param  ?Tempcode $error_msg Error message (written by reference) (null: not returned)
     * @return ?array A tuple: Formatted address, Street Address, City, County, State, Zip/Postcode, Country, NE lat, NE lng, SW lat, SW lng (null: error)
     */
    public function reverse_geocode($latitude, $longitude, &$error_msg = null)
    {
        $url_params = '&latlng=' . urlencode(float_to_raw_string($latitude, 30)) . ',' . urlencode(float_to_raw_string($longitude, 30));
        $result = $this->_geocode($url_params, $error_msg);
        if ($result === null) {
            return null;
        }

        if (!isset($result['results'][0])) {
            $error_msg = do_lang_tempcode('GEOCODE_INCOMPLETE');
            return null;
        }
        $r = $result['results'][0];

        $street_address = null;
        $city = null;
        $county = null;
        $state = null;
        $postal_code = null;
        $country = null;

        if (!isset($r['formatted_address'])) {
            $error_msg = do_lang_tempcode('GEOCODE_INCOMPLETE');
            return null;
        }
        $location = $r['formatted_address'];

        foreach ($r['address_components'] as $component) {
            if (in_array('street_address', $component['types'])) {
                $street_address = $component['long_name'];
            } else {
                if (in_array('street_number', $component['types'])) {
                    $street_address = $component['long_name'];
                }
                if (in_array('route', $component['types'])) {
                    if ($street_address === null) {
                        $street_address = '';
                    } else {
                        $street_address .= ' ';
                    }
                    $street_address .= $component['long_name'];
                }
            }
            if (in_array('locality', $component['types'])) {
                $city = $component['long_name'];
            }
            if (in_array('administrative_area_level_2', $component['types'])) {
                $county = $component['long_name'];
            }
            if (in_array('administrative_area_level_1', $component['types'])) {
                $state = $component['short_name'];
            }
            if (in_array('postal_code', $component['types'])) {
                $postal_code = $component['short_name'];
            }
            if (in_array('country', $component['types'])) {
                $country = $component['short_name'];
            }
        }

        if (!isset($r['geometry']['bounds'])) {
            $r['geometry']['bounds'] = $r['geometry']['viewport'];
        }
        $ne_latitude = $r['geometry']['bounds']['northeast']['lat'];
        $ne_longitude = $r['geometry']['bounds']['northeast']['lng'];
        $sw_latitude = $r['geometry']['bounds']['southwest']['lat'];
        $sw_longitude = $r['geometry']['bounds']['southwest']['lng'];

        return array($location, $street_address, $city, $county, $state, $postal_code, $country, $ne_latitude, $ne_longitude, $sw_latitude, $sw_longitude);
    }

    /**
     * Geocode a written location.
     *
     * @param  string $url_params What to add into the URL
     * @param  ?Tempcode $error_msg Error message (written by reference) (null: not returned)
     * @return ?array Geocode results (null: error)
     * @ignore
     */
    protected function _geocode($url_params, &$error_msg = null)
    {
        // Test to see if we know we were over the limit in the last 24h
        $limit_test = get_value_newer_than('over_geocode_query_limit', time() - 60 * 60 * 24, true);
        if ($limit_test === 1) {
            $error_msg = do_lang_tempcode('GEOCODE_OVER_QUERY_LIMIT');
            return null;
        }

        $key = get_option('google_apis_api_key');
        /*if ($key == '') { Actually, does work
            $error_msg = do_lang_tempcode('GEOCODE_API_NOT_CONFIGURED');
            return null;
        }*/

        $url = 'https://maps.googleapis.com/maps/api/geocode/json';
        $url .= '?language=' . urlencode(strtolower(get_site_default_lang()));
        if (isset($_COOKIE['google_bias'])) {
            $url .= '&region=' . urlencode($_COOKIE['google_bias']);
        }
        if (($key != '') && (get_option('google_geocoding_api_enabled') == '1')) {
            $url .= '&key=' . urlencode($key);
        }
        $url .= $url_params;

        $_result = http_get_contents($url, array('trigger_error' => false, 'ignore_http_status' => false));

        if (empty($_result)) {
            $error_msg = do_lang_tempcode('GEOCODE_COULD_NOT_CONNECT');
            return null;
        }

        $result = @json_decode($_result, true);
        if (!is_array($result)) {
            $error_msg = do_lang_tempcode('GEOCODE_COULD_NOT_PARSE');
            return null;
        }

        if ($result['status'] == 'OVER_QUERY_LIMIT') {
            set_value('over_geocode_query_limit', '1', true);
            $error_msg = do_lang_tempcode('GEOCODE_OVER_QUERY_LIMIT');
            return null;
        }

        if (isset($result['error_message'])) {
            $error_msg = make_string_tempcode($result['error_message']);
            return null;
        }

        if ($result['status'] == 'ZERO_RESULTS' || $result['status'] == 'REQUEST_DENIED' || $result['status'] == 'UNKNOWN_ERROR') {
            $error_msg = do_lang_tempcode('GEOCODE_' . $result['status']);
            return null;
        }

        if ($result['status'] != 'OK') { // Usually INVALID_REQUEST; should not happen so raise stack trace
            fatal_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }

        return $result;
    }
}

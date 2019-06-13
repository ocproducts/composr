<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    weather
 */

/**
 * Hook class.
 */
class Hook_weather_openweathermap
{
    const INCHES_PER_MM = 0.03937008;

    /**
     * Lookup weather for a location.
     *
     * @param  ?string $location_search Location (null: use $latitude and $longitude)
     * @param  ?float $latitude Latitude (null: use $location_search)
     * @param  ?float $longitude Longitude (null: use $location_search)
     * @param  string $units Units to use
     * @set imperial metric
     * @param  ?integer $max_days Maximum number of days to return if supported (null: no limit)
     * @param  string $errormsg Error message (returned by reference)
     * @return ?array A pair: Weather API forecast in style of extended OpenWeatherMap, Weather API current conditions in style of extended OpenWeatherMap (null: not available)
     */
    public function lookup($location_search = null, $latitude = null, $longitude = null, $units = 'metric', $max_days = null, &$errormsg)
    {
        $api_key = get_option('openweathermap_api_key');

        if ($api_key == '') {
            $errormsg = 'Missing API key';
            return null;
        }

        $lang = strtolower(user_lang());

        require_code('http');

        $wind_directions = array('N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW');

        $forecast = $this->query_endpoint($location_search, $latitude, $longitude, $units, $lang, $api_key, 'https://api.openweathermap.org/data/2.5/forecast', $errormsg);
        if ($forecast === null) {
            return null;
        }
        foreach ($forecast['list'] as &$a) {
            foreach ($a['weather'] as &$b) {
                $b['icon_url'] = 'https://openweathermap.org/img/w/' . $b['icon'] . '.png';
            }

            $rain = (isset($a['rain']['3h']) ? $a['rain']['3h'] : 0);
            if ($units == 'imperial') {
                $rain = $rain * 0.03937008; // Convert to inches
            }
            $a['rain'] = $rain;

            $snow = (isset($a['snow']['3h']) ? $a['snow']['3h'] : 0);
            if ($units == 'imperial') {
                $snow = $snow * self::INCHES_PER_MM; // Convert to inches
            }
            $a['snow'] = $snow;

            $a['precipitation'] = $rain + $snow;

            $a['wind']['direction'] = $wind_directions[intval(round(8.0 * $a['wind']['deg'] / 360.0))];
        }

        $current_conditions = $this->query_endpoint($location_search, $latitude, $longitude, $units, $lang, $api_key, 'https://api.openweathermap.org/data/2.5/weather', $errormsg);
        if ($current_conditions === null) {
            return null;
        }

        foreach ($current_conditions['weather'] as &$b) {
            $b['icon_url'] = 'https://openweathermap.org/img/w/' . $b['icon'] . '.png';
        }

        $current_conditions['wind']['direction'] = $wind_directions[intval(round(8.0 * $current_conditions['wind']['deg'] / 360.0))];

        $result = array($forecast, $current_conditions);

        return $result;
    }

    protected function query_endpoint($location_search, $latitude, $longitude, $units, $lang, $api_key, $url, &$errormsg)
    {
        if ($location_search === null) {
            $url .= '?lat=' . float_to_raw_string($latitude) . '&lon=' . float_to_raw_string($longitude);
        } else {
            $url .= '?q=' . urlencode($location_search);
        }
        $url .= '&appid=' . urlencode($api_key);
        $url .= '&lang=' . urlencode($lang);
        $url .= '&units=' . urlencode($units);
        $url .= '&format=json';

        $response = cache_and_carry('cms_http_request', array($url, array('trigger_error' => false, 'ignore_http_status' => true)), 30);
        list($data, , , , $http_message) = $response;

        if ($http_message != '200') {
            $errormsg = do_lang('WEATHER_ERROR', 'OpenWeatherMap', strval($http_message) . ' error, ' . $data);
            return null;
        }

        $result = @json_decode($data, true);

        if (!is_array($result)) {
            return null;
        }
        if ((!array_key_exists('list', $result)) && (array_key_exists('message', $result))) {
            $errormsg = do_lang('WEATHER_ERROR', 'OpenWeatherMap', $result['message']);
            return null;
        }

        return $result;
    }
}

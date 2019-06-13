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
     * @return ?array A pair: Weather API forecast in standardised simple format, Weather API current conditions in standardised simple format (null: not available)
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
        require_code('locations');

        $wind_directions = array('N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW');

        // Forecast...

        $_forecast = $this->query_endpoint($location_search, $latitude, $longitude, $units, $lang, $api_key, 'https://api.openweathermap.org/data/2.5/forecast', $errormsg);
        if ($_forecast === null) {
            return null;
        }
        $forecast = array();
        foreach ($_forecast['list'] as &$__forecast) {
            $conditions = array();
            foreach ($__forecast['weather'] as &$_condition) {
                $conditions[] = array(
                    'condition' => $_condition['description'],
                    'icon_url' => 'https://openweathermap.org/img/w/' . $_condition['icon'] . '.png',
                );
            }

            $rain = (isset($__forecast['rain']['3h']) ? $__forecast['rain']['3h'] : 0);
            if ($units == 'imperial') {
                $rain = $rain * 0.03937008; // Convert to inches
            }

            $snow = (isset($__forecast['snow']['3h']) ? $__forecast['snow']['3h'] : 0);
            if ($units == 'imperial') {
                $snow = $snow * self::INCHES_PER_MM; // Convert to inches
            }

            $forecast[] = array(
                'timestamp' => $__forecast['dt'],

                'city_name' => $_forecast['city']['name'],
                'country_name' => find_country_name_from_iso($_forecast['city']['country']),

                'temperature' => $__forecast['main']['temp'],
                'temperature_high' => null, // TODO
                'temperature_low' => null, // TODO

                'precipitation' => $rain + $snow,
                'rain' => $rain,
                'snow' => $snow,

                'humidity' => $__forecast['main']['humidity'],
                'visibility' => null,
                'cloudiness' => $__forecast['clouds']['all'],

                'wind_speed' => $__forecast['wind']['speed'],
                'wind_direction' => $wind_directions[intval(round(8.0 * $__forecast['wind']['deg'] / 360.0))],
                'wind_chill' => null,

                'conditions' => $conditions,
            );
        }

        // Current conditions...

        $_current_conditions = $this->query_endpoint($location_search, $latitude, $longitude, $units, $lang, $api_key, 'https://api.openweathermap.org/data/2.5/weather', $errormsg);
        if ($_current_conditions === null) {
            return null;
        }

        $conditions = array();
        foreach ($_current_conditions['weather'] as &$_condition) {
            $conditions[] = array(
                'condition' => $_condition['description'],
                'icon_url' => 'https://openweathermap.org/img/w/' . $_condition['icon'] . '.png',
            );
        }

        $current_conditions = array(
            'city_name' => $_current_conditions['name'],
            'country_name' => find_country_name_from_iso($_current_conditions['sys']['country']),
            'temperature' => $_current_conditions['main']['temp'],
            'humidity' => $_current_conditions['main']['humidity'],
            'visibility' => null,
            'cloudiness' => $_current_conditions['clouds']['all'],
            'wind_speed' => $_current_conditions['wind']['speed'],
            'wind_direction' => $wind_directions[intval(round(8.0 * $_current_conditions['wind']['deg'] / 360.0))],
            'wind_chill' => null,
            'conditions' => $conditions,
        );

        // ---

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

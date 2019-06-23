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
     * @return ?array A pair: Weather API current conditions in standardised simple format, Weather API forecast in standardised simple format (null: not available)
     */
    public function lookup($location_search = null, $latitude = null, $longitude = null, $units = 'metric', $max_days = null, &$errormsg)
    {
        if (!addon_installed('weather')) {
            return null;
        }

        $api_key = get_option('openweathermap_api_key');

        if ($api_key == '') {
            $errormsg = 'Missing API key';
            return null;
        }

        $lang = strtolower(user_lang());

        require_code('http');
        require_code('locations');

        $wind_directions = array('N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW');

        // Current conditions...

        $_current_conditions = $this->query_endpoint($location_search, $latitude, $longitude, $units, $lang, $api_key, 'https://api.openweathermap.org/data/2.5/weather', $errormsg);
        if ($_current_conditions === null) {
            return null;
        }

        $conditions = array();
        foreach ($_current_conditions['weather'] as $_condition) {
            $conditions[] = array(
                'description' => $_condition['description'],
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
            'sunrise' => $_current_conditions['sys']['sunrise'],
            'sunset' => $_current_conditions['sys']['sunset'],
        );

        // Forecast...

        $_forecast_hourly = $this->query_endpoint($location_search, $latitude, $longitude, $units, $lang, $api_key, 'https://api.openweathermap.org/data/2.5/forecast', $errormsg);
        if ($_forecast_hourly === null) {
            return null;
        }
        $forecast_hourly = array();
        foreach ($_forecast_hourly['list'] as $__forecast) {
            $conditions = array();
            foreach ($__forecast['weather'] as $_condition) {
                $conditions[$_condition['description']] = array(
                    'description' => $_condition['description'],
                    'icon_url' => 'https://openweathermap.org/img/w/' . $_condition['icon'] . '.png',
                    'count' => 1,
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

            $forecast_arr = array(
                'timestamp' => $__forecast['dt'],

                'temperature' => $__forecast['main']['temp'],

                'precipitation' => $rain + $snow,
                'rain' => $rain,
                'snow' => $snow,

                'humidity' => $__forecast['main']['humidity'],
                'visibility' => null,
                'cloudiness' => $__forecast['clouds']['all'],

                'wind_speed' => $__forecast['wind']['speed'],
                'wind_deg' => $__forecast['wind']['deg'],
                'wind_chill' => null,

                'conditions' => $conditions,
            );
            $forecast_hourly[] = $forecast_arr;
        }
        if (count($forecast_hourly) == 0) {
            $errormsg = do_lang('NO_ENTRIES');
            return null;
        }

        // Convert from 3-hour intervals to daily intervals
        $forecasts_within_daytime = array();
        $day_sunrise = $current_conditions['sunrise'];
        $day_sunset = $current_conditions['sunset'];
        while ($day_sunset < $forecast_hourly[0]['timestamp']) {
            $day_sunrise += 60 * 60 * 24;
            $day_sunset += 60 * 60 * 24;
        }
        $forecast = array();
        foreach ($forecast_hourly as $i => $forecast_arr) {
            $within_daytime = ($forecast_arr['timestamp'] >= $day_sunrise) && ($forecast_arr['timestamp'] < $day_sunset);
            $end_of_data = ($i == count($forecast_hourly) - 1);

            if ($within_daytime) {
                $forecasts_within_daytime[] = $forecast_arr;
            }

            if ((count($forecasts_within_daytime) > 0) && ((!$within_daytime) || ($end_of_data))) { // We have data to process into a daily forecast
                // Finish off day
                $precipitation = 0.0;
                $rain = 0.0;
                $snow = 0.0;
                $temperatures = array();
                $humidities = array();
                $cloudiness = array();
                $wind_speeds = array();
                $wind_degs = array();
                $conditions = array();
                foreach ($forecasts_within_daytime as $_forecast_arr) {
                    $precipitation += $_forecast_arr['precipitation'];
                    $rain += $_forecast_arr['rain'];
                    $snow += $_forecast_arr['snow'];
                    $temperatures[] = $_forecast_arr['temperature'];
                    $humidities[] = $_forecast_arr['humidity'];
                    $cloudiness[] = $_forecast_arr['cloudiness'];
                    $wind_speeds[] = $_forecast_arr['wind_speed'];
                    $wind_degs[] = $_forecast_arr['wind_deg'];
                    foreach ($_forecast_arr['conditions'] as $key => $condition) {
                        if (isset($conditions[$key])) {
                            $conditions[$key]['count']++;
                        } else {
                            $conditions[$key] = $condition;
                        }
                    }
                }
                sort_maps_by($conditions, '!count');
                $conditions = array_values($conditions);
                foreach ($conditions as $key => $condition) {
                    unset($conditions[$key]['count']);
                }
                $forecast[] = array(
                    'timestamp' => intval(round(($day_sunrise + $day_sunset) / 2.0)),

                    'city_name' => $current_conditions['city_name'],
                    'country_name' => $current_conditions['country_name'],

                    'temperature_average' => array_sum($temperatures) / count($temperatures),
                    'temperature_high' => max($temperatures),
                    'temperature_low' => min($temperatures),

                    'precipitation' => $precipitation,
                    'rain' => $rain,
                    'snow' => $snow,

                    'humidity' => array_sum($humidities) / count($humidities),
                    'visibility' => null,
                    'cloudiness' => array_sum($cloudiness) / count($cloudiness),

                    'wind_speed' => array_sum($wind_speeds) / count($wind_speeds),
                    'wind_direction' => $wind_directions[intval(round(8.0 * (array_sum($wind_degs) / count($wind_degs)) / 360.0))],
                    'wind_chill' => null,

                    'conditions' => $conditions,
                );

                // Set for next day
                if (!$end_of_data) {
                    $forecasts_within_daytime = array();
                    while ($day_sunset < $forecast_hourly[$i + 1]['timestamp']) {
                        $day_sunrise += 60 * 60 * 24;
                        $day_sunset += 60 * 60 * 24;
                    }
                }
            }
        }

        // ---

        $result = array($current_conditions, $forecast);

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

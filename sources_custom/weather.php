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
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__weather()
{
    require_lang('weather');
}

/**
 * Lookup weather for a location.
 *
 * @param  ?string $location_search Location (null: use $latitude and $longitude)
 * @param  ?float $latitude Latitude (null: use $location_search)
 * @param  ?float $longitude Longitude (null: use $location_search)
 * @param  string $units Units to use
 * @set imperial metric
 * @param  ?integer $max_days Maximum number of days to return if supported (null: no limit)
 * @param  ?string $api The API to use (null: first available)
 * @param  string $errormsg Error message (returned by reference)
 * @return ?array A pair: Weather API current conditions in standardised simple format, Weather API forecast in standardised simple format (null: not available)
 */
function weather_lookup($location_search = null, $latitude = null, $longitude = null, $units = 'metric', $max_days = null, &$errormsg = '', $api = null)
{
    if ($location_search === '') {
        $location_search = null;
    }

    if ($location_search === null) {
        if (($latitude === null) || ($longitude === null)) {
            $errormsg = do_lang('NO_LOCATION_SPECIFIED');
            return null;
        }
    }

    $hook_obs = find_all_hook_obs('systems', 'weather', 'Hook_weather_');
    foreach ($hook_obs as $hook => $ob) {
        if (($api === null) || ($hook == $api)) {
            $result = $ob->lookup($location_search, $latitude, $longitude, $units, $max_days, $errormsg);
            if ($result !== null) {
                return $result;
            }
        }
    }

    return null;
}
<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    weather
 */

/**
 * Block class.
 */
class Block_side_weather
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Manuprathap';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 6;
        $info['update_require_upgrade'] = 1;
        $info['locked'] = false;
        $info['parameters'] = array('param', 'unit', 'max_days');
        return $info;
    }

    /**
     * Uninstall the block.
     */
    public function uninstall()
    {
        $GLOBALS['SITE_DB']->drop_table_if_exists('cached_weather_codes');
    }

    /**
     * Install the block.
     *
     * @param  ?integer $upgrade_from What version we're upgrading from (null: new install)
     * @param  ?integer $upgrade_from_hack What hack version we're upgrading from (null: new-install/not-upgrading-from-a-hacked-version)
     */
    public function install($upgrade_from = null, $upgrade_from_hack = null)
    {
        $GLOBALS['SITE_DB']->create_table('cached_weather_codes', array(
            'id' => '*AUTO',
            'w_string' => 'SHORT_TEXT',
            'w_code' => 'INTEGER',
        ));
    }

    /**
     * Find caching details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled).
     */
    public function caching_environment()
    {
        $info = array();
        $info['cache_on'] = 'array(isset($map[\'max_days\'])?intval($map[\'max_days\']):2,(array_key_exists(\'unit\',$map) && ($map[\'unit\']!=\'\'))?$map[\'unit\']:\'c\',array_key_exists(\'param\',$map)?$map[\'param\']:\'\')';
        $info['special_cache_flags'] = CACHE_AGAINST_DEFAULT | CACHE_AGAINST_STAFF_STATUS;
        $info['ttl'] = 60;
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters.
     * @return Tempcode The result of execution.
     */
    public function run($map)
    {
        i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

        require_code('rss');
        require_lang('weather');

        $max_days = isset($map['max_days']) ? intval($map['max_days']) : 2;

        if (array_key_exists('param', $map)) {
            $loc_code = $map['param']; // need to pass loc ID ex :INXX0087
        } else {
            $loc_code = '34503'; // if not found setting a default location for weather
        }

        if (!is_numeric($loc_code)) {
            $test = $GLOBALS['SITE_DB']->query_select_value_if_there('cached_weather_codes', 'w_code', array('w_string' => $loc_code));
            if (is_null($test)) {
                $matches = array();

                require_code('files');

                if (preg_match('#^\-?\d+(\.\d+)?,\-?\d+(\.\d+)?$#', $loc_code) != 0) {
                    $url = 'http://query.yahooapis.com/v1/public/yql?q=' . urlencode('select * from geo.placefinder where text="' . $loc_code . '"') . '&format=json&diagnostics=true&callback=cbfunc';
                    $result = http_download_file($url);

                    if (preg_match('#"woeid":\s*"(\d+)"#', $result, $matches) != 0) {
                        $loc_code = $matches[1];
                    } else {
                        return new Tempcode();
                    }
                } else {
                    $result = http_download_file('http://uk.weather.yahoo.com/search/weather?p=' . urlencode($loc_code));

                    if (preg_match('#<a href=\'/redirwoei/(\d+)\'>#', $result, $matches) != 0) {
                        $loc_code = $matches[1];
                    } elseif (preg_match('#-(\d+)/#', $GLOBALS['HTTP_DOWNLOAD_URL'], $matches) != 0) {
                        $loc_code = $matches[1];
                    } else {
                        return new Tempcode();
                    }
                }

                if (is_numeric($loc_code)) {
                    $GLOBALS['SITE_DB']->query_insert('cached_weather_codes', array(
                        'w_string' => $map['param'],
                        'w_code' => intval($loc_code),
                    ));
                }
            } else {
                $loc_code = strval($test);
            }
        }

        $temperature_unit = (array_key_exists('unit', $map) && ($map['unit'] != '')) ? $map['unit'] : 'c';

        if (is_numeric($loc_code)) {
            $rss_url = 'http://weather.yahooapis.com/forecastrss?w=' . urlencode($loc_code) . '&u=' . urlencode($temperature_unit);
        } else {
            $rss_url = 'http://weather.yahooapis.com/forecastrss?p=' . urlencode($loc_code) . '&u=' . urlencode($temperature_unit);
        }
        $rss = new CMS_RSS($rss_url);

        if (!is_null($rss->error)) {
            $GLOBALS['DO_NOT_CACHE_THIS'] = true;
            require_code('failure');
            relay_error_notification(do_lang('ERROR_HANDLING_RSS_FEED', '', $rss->error), false, 'error_occurred_weather');
            if (cron_installed()) {
                if (!$GLOBALS['FORUM_DRIVER']->is_staff(get_member())) {
                    return new Tempcode();
                }
            }
            return do_template('INLINE_WIP_MESSAGE', array('_GUID' => '046c437a5c3799838155b5c5fbe3be26', 'MESSAGE' => htmlentities($rss->error)));
        }

        if (!isset($rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:LOCATION'])) {
            return new Tempcode(); // No weather for here
        }

        $location_city = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:LOCATION'][0]['CITY'];
        $location_region = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:LOCATION'][0]['REGION'];
        $location_country = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:LOCATION'][0]['COUNTRY'];
        $wind_chill = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:WIND'][0]['CHILL'];
        $wind_direction = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:WIND'][0]['DIRECTION'];
        $wind_speed = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:WIND'][0]['SPEED'];
        $humidity = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:ATMOSPHERE'][0]['HUMIDITY'];
        $visibility = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:ATMOSPHERE'][0]['VISIBILITY'];
        $pressure = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:ATMOSPHERE'][0]['PRESSURE'];
        $pressure_rising = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:ATMOSPHERE'][0]['RISING'];
        $sunrise = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:ASTRONOMY'][0]['SUNRISE'];
        $sunset = $rss->gleamed_feed['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:ASTRONOMY'][0]['SUNSET'];

        $item = $rss->gleamed_items[0];

        $title = $item['title'];

        $content = $item['news'];
        $matches = array();
        $image = '';
        if (preg_match('/<img src="(.*)"\/?' . '>/Usm', $item['news'], $matches) != 0) {
            $image = $matches[1];
        }
        $cur_conditions = '';
        if (preg_match('/Current Conditions:<\/b><br \/>(.*)<BR \/>/Uism', $item['news'], $matches) != 0) {
            $cur_conditions = $matches[1];
        }
        $forecast = '';
        if (preg_match('/Forecast:<\/b><BR \/>(.*)<br \/>/ism', $item['news'], $matches) != 0) {
            $forecast = $matches[1];
        }

        $lat = $item['HTTP://WWW.W3.ORG/2003/01/GEO/WGS84_POS#:LAT'][0]['_'];
        $long = $item['HTTP://WWW.W3.ORG/2003/01/GEO/WGS84_POS#:LONG'][0]['_'];
        $full_link = $item['full_url'];
        $prepared_date = $item['add_date'];
        $dates = array();
        foreach ($item['HTTP://XML.WEATHER.YAHOO.COM/NS/RSS/1.0:FORECAST'] as $i => $forecast) {
            if ($i == $max_days) {
                break;
            }

            $dates[] = array(
                'DATE' => strtotime($forecast['DATE']),
                'DAY' => $forecast['DAY'],
                'LOW' => $forecast['LOW'],
                'HIGH' => $forecast['HIGH'],
                'TEXT' => $forecast['TEXT'],
                'CODE' => $forecast['CODE'],
            );
        }

        return do_template('BLOCK_SIDE_WEATHER', array(
            '_GUID' => '8b46b3437fbe05e587b11dd3347fa195',
            'TITLE' => $title,
            'LOC_CODE' => $loc_code,
            'IMAGE' => $image,
            'COND' => $cur_conditions,
            'FORECAST' => $forecast,
            'LOCATION_CITY' => $location_city,
            'LOCATION_REGION' => $location_region,
            'LOCATION_COUNTRY' => $location_country,
            'WIND_CHILL' => $wind_chill,
            'WIND_DIRECTION' => $wind_direction,
            'WIND_SPEED' => $wind_speed,
            'HUMIDITY' => $humidity,
            'VISIBILITY' => $visibility,
            'PRESSURE' => $pressure,
            'PRESSURE_RISING' => $pressure_rising,
            'SUNRISE' => $sunrise,
            'SUNSET' => $sunset,
            'LAT' => $lat,
            'LONG' => $long,
            'FULL_LINK' => $full_link,
            'PREPARED_DATE' => $prepared_date,
            'DATES' => $dates,
            'TEMPERATURE_UNIT' => $temperature_unit,
            'BLOCK_PARAMS' => block_params_arr_to_str($map),
        ));
    }
}

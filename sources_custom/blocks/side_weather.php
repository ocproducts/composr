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
 * Block class.
 */
class Block_side_weather
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled)
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Manuprathap';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 6;
        $info['update_require_upgrade'] = true;
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
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled)
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
     * @param  array $map A map of parameters
     * @return Tempcode The result of execution
     */
    public function run($map)
    {
        i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

        $error_msg = new Tempcode();
        if (!addon_installed__messaged('weather', $error_msg)) {
            return $error_msg;
        }

        require_lang('weather');

        $block_id = get_block_id($map);

        $max_days = isset($map['max_days']) ? intval($map['max_days']) : 2;
        $temperature_unit = (array_key_exists('unit', $map) && ($map['unit'] != '')) ? $map['unit'] : 'c';

        if (empty($map['param'])) {
            $_woeid = '2487889'; // if not found set a default location for weather
        } else {
            $_woeid = $map['param']; // need to pass a WOEID
        }
        if (!is_numeric($_woeid)) {
            $woeid = $GLOBALS['SITE_DB']->query_select_value_if_there('cached_weather_codes', 'w_code', array('w_string' => $_woeid));
            if ($woeid === null) {
                $matches = array();

                $woeid = $this->_get_woeid($_woeid);
                if ($woeid === null) {
                    return do_template('RED_ALERT', array('_GUID' => 'kff1df2t2tp3wil1mbn7lxz8il9zrex7', 'TEXT' => do_lang_tempcode('WEATHER_LOCATION_NOT_FOUND')));
                }

                $GLOBALS['SITE_DB']->query_insert('cached_weather_codes', array(
                    'w_string' => $_woeid,
                    'w_code' => $woeid,
                ));
            }
        } else {
            $woeid = intval($_woeid);
        }

        list($json_url, $http_result, $result) = $this->_get_weather_data($woeid, $max_days, $temperature_unit);
        if ($result === null) {
            if (empty($http_result->message_b)) {
                $http_result->message_b = do_lang('HTTP_DOWNLOAD_STATUS_SERVER_ERROR', $json_url);
            }

            $GLOBALS['DO_NOT_CACHE_THIS'] = true;
            require_code('failure');
            relay_error_notification($http_result->message_b, false, 'error_occurred_weather');
            if (cron_installed(true)) {
                if (!$GLOBALS['FORUM_DRIVER']->is_staff(get_member())) {
                    return new Tempcode();
                }
            }
            return do_template('INLINE_WIP_MESSAGE', array('_GUID' => '046c437a5c3799838155b5c5fbe3be26', 'MESSAGE' => htmlentities($http_result->message_b)));
        }
        if ($result === false) {
            return do_template('RED_ALERT', array('_GUID' => 'xeve22thxm3o3on96d0b1yg26ec3apzh', 'TEXT' => do_lang_tempcode('NO_RESULTS'))); // No weather for here
        }

        return do_template('BLOCK_SIDE_WEATHER', array(
            '_GUID' => '8b46b3437fbe05e587b11dd3347fa195',

            'BLOCK_ID' => $block_id,
            'BLOCK_PARAMS' => block_params_arr_to_str(array('block_id' => $block_id) + $map),

            'LOC_CODE' => strval($woeid),
            'TEMPERATURE_UNIT' => $temperature_unit,

            'TITLE' => $result['title'],
            'IMAGE' => $result['image'],
            'CUR_CONDITIONS' => $result['cur_conditions'],
            'FORECAST' => $result['forecast'],
            'LOCATION_CITY' => $result['location_city'],
            'LOCATION_REGION' => $result['location_region'],
            'LOCATION_COUNTRY' => $result['location_country'],
            'WIND_CHILL' => $result['wind_chill'],
            'WIND_DIRECTION' => $result['wind_direction'],
            'WIND_SPEED' => $result['wind_speed'],
            'HUMIDITY' => $result['humidity'],
            'VISIBILITY' => $result['visibility'],
            'PRESSURE' => $result['pressure'],
            'PRESSURE_RISING' => $result['pressure_rising'],
            'SUNRISE' => $result['sunrise'],
            'SUNSET' => $result['sunset'],
            'LAT' => $result['lat'],
            'LONG' => $result['long'],
            'FULL_LINK' => $result['full_link'],
            'PREPARED_DATE' => $result['prepared_date'],
            'DATES' => $result['dates'],
        ));
    }

    /**
     * Get weather data.
     *
     * @param  integer The WOEIE
     * @param  integer Maximum data to show
     * @param  string Weather unit
     * @set c f
     * @return array A tuple: Call URL, HTTP result, The data/null/false
     */
    public function _get_weather_data($woeid, $max_days = 2, $temperature_unit = 'c')
    {
        $json_url = 'http://query.yahooapis.com/v1/public/yql?q=select+%2A+from+weather.forecast+where+woeid%3D' . urlencode(strval($woeid)) . '%20AND%20u%3D%22' . urlencode($temperature_unit) . '%22&format=json';
        $http_result = cms_http_request($json_url, array('trigger_error' => false));
        $json = $http_result->data;
        if ($json == '') {
            return array($json_url, $http_result, null);
        }

        $data = @json_decode($json, true);

        if (!isset($data['query']['results']['channel']['location'])) {
            return array($json_url, $http_result, false);
        }

        $feed = $data['query']['results']['channel'];
        $item = $feed['item'];

        $result = array();

        $result['location_city'] = $feed['location']['city'];
        $result['location_region'] = $feed['location']['region'];
        $result['location_country'] = $feed['location']['country'];
        $result['wind_chill'] = $feed['wind']['chill'];
        $result['wind_direction'] = $feed['wind']['direction'];
        $result['wind_speed'] = $feed['wind']['speed'];
        $result['humidity'] = $feed['atmosphere']['humidity'];
        $result['visibility'] = $feed['atmosphere']['visibility'];
        $result['pressure'] = $feed['atmosphere']['pressure'];
        $result['pressure_rising'] = $feed['atmosphere']['rising'];
        $result['sunrise'] = $feed['astronomy']['sunrise'];
        $result['sunset'] = $feed['astronomy']['sunset'];

        $result['title'] = $item['title'];

        $matches = array();

        $result['image'] = '';
        if (preg_match('/<img src="(.*)"\/?' . '>/Usm', $item['description'], $matches) != 0) {
            $result['image'] = $matches[1];
        }

        $result['cur_conditions'] = '';
        if (preg_match('/Current Conditions:<\/b>\n<BR \/>(.*)<BR \/>/Uism', $item['description'], $matches) != 0) {
            $result['cur_conditions'] = $matches[1];
        }

        $result['forecast'] = '';
        if (preg_match('/Forecast:<\/b>\n<BR \/>(.*)<BR \/>/ism', $item['description'], $matches) != 0) {
            $result['forecast'] = $matches[1];

            $result['forecast'] = preg_replace('#(\d+)Low#', '$1 Low', $result['forecast']); // Oh man, bug in Yahoo's layout!

            $num_matches = preg_match_all('#<BR /> (Mon|Tue|Wed|Thu|Fri|Sat|Sun) - .*#', $result['forecast'], $matches);
            for ($i = $max_days - 1; $i < $num_matches; $i++) {
                $result['forecast'] = str_replace($matches[0][$i], '', $result['forecast']);
            }
        }

        $result['lat'] = $item['lat'];
        $result['long'] = $item['long'];
        $result['full_link'] = $item['link'];
        $result['prepared_date'] = $item['pubDate'];

        $result['dates'] = array();
        foreach ($item['forecast'] as $i => $_forecast) {
            if ($i == $max_days) {
                break;
            }

            $result['dates'][] = array(
                'DATE' => strtotime($_forecast['date']),
                'DAY' => $_forecast['day'],
                'LOW' => $_forecast['low'],
                'HIGH' => $_forecast['high'],
                'TEXT' => $_forecast['text'],
                'CODE' => $_forecast['code'],
            );
        }

        return array($json_url, $http_result, $result);
    }

    /**
     * Get a WOEID from a written description.
     *
     * @param  string $written Written description
     * @return ?integer The WOEID
     */
    public function _get_woeid($written)
    {
        $matches = array();
        $url = 'http://query.yahooapis.com/v1/public/yql?q=' . urlencode('select * from geo.places where text="' . $written . '"') . '&format=json';
        $result = http_get_contents($url);
        $json = json_decode($result, true);

        if (isset($json['query']['results']['place'][0]['woeid'])) {
            return intval($json['query']['results']['place'][0]['woeid']);
        }

        return null;
    }
}

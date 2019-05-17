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
 * Automatically populate member geo CPFs as much as possible from other data.
 * Assumes Conversr.
 *
 * @param  ?MEMBER $member_id Member ID to do for (null: all)
 */
function autofill_geo_cpfs($member_id = null)
{
    if (get_forum_type() != 'cns') {
        return;
    }

    $where = null;
    if ($member_id !== null) {
        $where['mf_member_id'] = $member_id;
    }

    $start = 0;
    $max = 100;
    do
    {
        $rows = $GLOBALS['FORUM_DB']->query_select('f_member_custom_fields f JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_members m ON m.id=f.mf_member_id', array('f.*', 'm.id', 'm_ip_address'), $where, 'ORDER BY mf_member_id', $max, $start);
        foreach ($rows as $row) {
            _autofill_geo_cpfs($row);
        }
        $start += $max;
    }
    while (array_key_exists(0, $rows));
}

/**
 * Automatically populate member geo CPFs (worker function).
 *
 * @param  array $row Member row
 *
 * @ignore
 */
function _autofill_geo_cpfs($row)
{
    require_code('cns_members');
    require_code('locations');
    require_code('locations_geocoding');

    $latitude_field = find_cms_cpf_field_id('cms_latitude');
    $longitude_field = find_cms_cpf_field_id('cms_longitude');

    $street_address_field = find_cms_cpf_field_id('cms_street_address');
    $city_field = find_cms_cpf_field_id('cms_city');
    $county_field = find_cms_cpf_field_id('cms_county');
    $state_field = find_cms_cpf_field_id('cms_state');
    $post_code_field = find_cms_cpf_field_id('cms_post_code');
    $country_field = find_cms_cpf_field_id('cms_country');

    $has_street_address = ($street_address_field !== null) && (!empty($row['field_' . strval($street_address_field)]));
    $has_city = ($city_field !== null) && (!empty($row['field_' . strval($city_field)]));
    $has_county = ($county_field !== null) && (!empty($row['field_' . strval($county_field)]));
    $has_state = ($state_field !== null) && (!empty($row['field_' . strval($state_field)]));
    $has_post_code = ($post_code_field !== null) && (!empty($row['field_' . strval($post_code_field)]));
    $has_country = ($country_field !== null) && (!empty($row['field_' . strval($country_field)]));
    $has_latitude = ($latitude_field !== null) && (!empty($row['field_' . strval($latitude_field)]));
    $has_longitude = ($longitude_field !== null) && (!empty($row['field_' . strval($longitude_field)]));

    $has_address = $has_city && $has_country;
    $has_gps = $has_latitude && $has_longitude;
    $has_ip = !empty($row['m_ip_address']);

    $changes = array();

    // GPS from address
    if ((!$has_latitude || !$has_longitude) && (isset($latitude_field)) && (isset($longitude_field))) {
        if ($has_address) {
            $address_components = array();
            if ($has_street_address) {
                $address_components[] = $row['field_' . strval($street_address_field)];
            }
            if ($has_city) {
                $address_components[] = $row['field_' . strval($city_field)];
            }
            if ($has_county) {
                $address_components[] = $row['field_' . strval($county_field)];
            }
            if ($has_state) {
                $address_components[] = $row['field_' . strval($state_field)];
            }
            if ($has_post_code) {
                $address_components[] = $row['field_' . strval($post_code_field)];
            }
            if ($has_country) {
                $address_components[] = $row['field_' . strval($country_field)];
            }

            $gps_parts = geocode(implode(', ', $address_components));
            if ($gps_parts !== null) {
                list($latitude, $longitude) = $gps_parts;
                if (!$has_latitude) {
                    $changes['field_' . strval($latitude_field)] = $latitude;
                }
                if (!$has_longitude) {
                    $changes['field_' . strval($longitude_field)] = $longitude;
                }
            }
        }
    }

    // Address from GPS (or IP)
    if (!$has_city || !$has_county || !$has_state || !$has_country) {
        if ($has_gps) {
            $latitude = $row['field_' . strval($latitude_field)];
            $longitude = $row['field_' . strval($longitude_field)];

            $address_parts = reverse_geocode($latitude, $longitude);
            if ($address_parts !== null) {
                list(, , $city, $county, $state, , $country) = $address_parts;
                if (!$has_city && !empty($city) && (!empty($row['field_' . strval($city_field)]))) {
                    $changes['field_' . strval($city_field)] = $city;
                }
                if (!$has_county && !empty($county) && (!empty($row['field_' . strval($county_field)]))) {
                    $changes['field_' . strval($county_field)] = $county;
                }
                if (!$has_state && !empty($state) && (!empty($row['field_' . strval($state_field)]))) {
                    $changes['field_' . strval($state_field)] = $state;
                }
                if (!$has_country && !empty($country) && (!empty($row['field_' . strval($country_field)]))) {
                    $changes['field_' . strval($country_field)] = $country;
                }
                // We cannot reliably geocode street addresses, so we don't go deeper than cities. We geocode *from* this to get GPS, but not vice-versa.
            }
        } elseif ($has_ip && !$has_country) {
            $country = geolocate_ip($row['m_ip_address']);
            if (!empty($country)) {
                $changes['field_' . strval($country_field)] = $country;
            }
        }
    }

    // Save
    if (!empty($changes)) {
        $GLOBALS['FORUM_DB']->query_update('f_member_custom_fields', $changes, array('mf_member_id' => $row['mf_member_id']), '', 1);
    }
}

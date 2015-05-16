<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    locations
 */

function init__locations()
{
    global $COUNTRY_LIST;
    $COUNTRY_LIST = array(
        'Africa' => array(
            'DZ' => 'Algeria',
            'AO' => 'Angola',
            'BJ' => 'Benin',
            'BW' => 'Botswana',
            'BF' => 'Burkina Faso',
            'BI' => 'Burundi',
            'CM' => 'Cameroon',
            'CV' => 'Cape Verde',
            'CF' => 'Central African Republic',
            'TD' => 'Chad',
            'KM' => 'Comoros',
            'CG' => 'Congo',
            'CD' => 'Congo (Dem. Rep.)',
            'CI' => 'Ivory Coast',
            'DJ' => 'Djibouti',
            'EG' => 'Egypt',
            'GQ' => 'Equatorial Guinea',
            'ER' => 'Eritrea',
            'ET' => 'Ethiopia',
            'GA' => 'Gabon',
            'GM' => 'Gambia',
            'GH' => 'Ghana',
            'GN' => 'Guinea',
            'GW' => 'Guinea-Bissau',
            'KE' => 'Kenya',
            'LS' => 'Lesotho',
            'LR' => 'Liberia',
            'LY' => 'Libya',
            'MG' => 'Madagascar',
            'MW' => 'Malawi',
            'ML' => 'Mali',
            'MR' => 'Mauritania',
            'MU' => 'Mauritius',
            'YT' => 'Mayotte',
            'MA' => 'Morocco',
            'MZ' => 'Mozambique',
            'NA' => 'Namibia',
            'NE' => 'Niger',
            'NG' => 'Nigeria',
            'RW' => 'Rwanda',
            'RE' => 'Réunion',
            'SH' => 'Saint Helena',
            'SN' => 'Senegal',
            'SC' => 'Seychelles',
            'SL' => 'Sierra Leone',
            'SO' => 'Somalia',
            'ZA' => 'South Africa',
            'SD' => 'Sudan',
            'SZ' => 'Swaziland',
            'ST' => 'São Tomé and Príncipe',
            'TZ' => 'Tanzania',
            'TG' => 'Togo',
            'TN' => 'Tunisia',
            'UG' => 'Uganda',
            'EH' => 'Western Sahara',
            'ZM' => 'Zambia',
            'ZW' => 'Zimbabwe',
        ),
        'Americas' => array(
            'AI' => 'Anguilla',
            'AG' => 'Antigua and Barbuda',
            'AR' => 'Argentina',
            'AW' => 'Aruba',
            'BS' => 'Bahamas',
            'BB' => 'Barbados',
            'BZ' => 'Belize',
            'BM' => 'Bermuda',
            'BO' => 'Bolivia',
            'BR' => 'Brazil',
            'VG' => 'British Virgin Islands',
            'CA' => 'Canada',
            'KY' => 'Cayman Islands',
            'CL' => 'Chile',
            'CO' => 'Colombia',
            'CR' => 'Costa Rica',
            'CU' => 'Cuba',
            'DM' => 'Dominica',
            'DO' => 'Dominican Republic',
            'EC' => 'Ecuador',
            'SV' => 'El Salvador',
            'FK' => 'Falkland Islands',
            'GF' => 'French Guiana',
            'GL' => 'Greenland',
            'GD' => 'Grenada',
            'GP' => 'Guadeloupe',
            'GT' => 'Guatemala',
            'GY' => 'Guyana',
            'HT' => 'Haiti',
            'HN' => 'Honduras',
            'JM' => 'Jamaica',
            'MQ' => 'Martinique',
            'MX' => 'Mexico',
            'MS' => 'Montserrat',
            'AN' => 'Netherlands Antilles',
            'NI' => 'Nicaragua',
            'PA' => 'Panama',
            'PY' => 'Paraguay',
            'PE' => 'Peru',
            'PR' => 'Puerto Rico',
            'BL' => 'Saint Barthélemy',
            'KN' => 'Saint Kitts and Nevis',
            'LC' => 'Saint Lucia',
            'MF' => 'Saint Martin',
            'PM' => 'Saint Pierre and Miquelon',
            'VC' => 'Saint Vincent and The Grenadines',
            'SR' => 'Suriname',
            'TT' => 'Trinidad and Tobago',
            'TC' => 'Turks and Caicos Islands',
            'VI' => 'Virgin Islands of the United States',
            'US' => 'United States of America',
            'UY' => 'Uruguay',
            'VE' => 'Venezuela',
        ),
        'Asia' => array(
            'AF' => 'Afghanistan',
            'AM' => 'Armenia',
            'AZ' => 'Azerbaijan',
            'BH' => 'Bahrain',
            'BD' => 'Bangladesh',
            'BT' => 'Bhutan',
            'BN' => 'Brunei',
            'KH' => 'Cambodia',
            'CN' => 'China',
            'CY' => 'Cyprus',
            'GE' => 'Georgia',
            'HK' => 'Hong Kong SAR China',
            'IN' => 'India',
            'ID' => 'Indonesia',
            'IR' => 'Iran',
            'IQ' => 'Iraq',
            'IL' => 'Israel',
            'JP' => 'Japan',
            'JO' => 'Jordan',
            'KZ' => 'Kazakhstan',
            'KW' => 'Kuwait',
            'KG' => 'Kyrgyzstan',
            'LA' => 'Laos',
            'LB' => 'Lebanon',
            'MO' => 'Macau SAR China',
            'MY' => 'Malaysia',
            'MV' => 'Maldives',
            'MN' => 'Mongolia',
            'MM' => 'Myanmar',
            'NP' => 'Nepal',
            'NT' => 'Neutral Zone',
            'KP' => 'Korea (North)',
            'OM' => 'Oman',
            'PK' => 'Pakistan',
            'PS' => 'Palestine',
            'YD' => 'People\'s Democratic Republic of Yemen',
            'PH' => 'Philippines',
            'QA' => 'Qatar',
            'SA' => 'Saudi Arabia',
            'SG' => 'Singapore',
            'KR' => 'Korea (South)',
            'LK' => 'Sri Lanka',
            'SY' => 'Syria',
            'TW' => 'Taiwan',
            'TJ' => 'Tajikistan',
            'TH' => 'Thailand',
            'TL' => 'East Timor', //,'Timor-Leste',
            'TR' => 'Turkey',
            'TM' => 'Turkmenistan',
            'AE' => 'United Arab Emirates',
            'UZ' => 'Uzbekistan',
            'VN' => 'Vietnam',
            'YE' => 'Yemen',
        ),
        'Europe' => array(
            'AL' => 'Albania',
            'AD' => 'Andorra',
            'AT' => 'Austria',
            'BY' => 'Belarus',
            'BE' => 'Belgium',
            'BA' => 'Bosnia and Herzegovina',
            'BG' => 'Bulgaria',
            'HR' => 'Croatia',
            'CY' => 'Cyprus',
            'CZ' => 'Czech Republic',
            'DK' => 'Denmark',
            'DD' => 'East Germany',
            'EE' => 'Estonia',
            'FO' => 'Faroe Islands',
            'FI' => 'Finland',
            'FR' => 'France',
            'DE' => 'Germany',
            'GI' => 'Gibraltar',
            'GR' => 'Greece',
            'GG' => 'Guernsey and Alderney',
            'HU' => 'Hungary',
            'IS' => 'Iceland',
            'IE' => 'Ireland',
            'IM' => 'Isle of Man',
            'IT' => 'Italy',
            'JE' => 'Jersey',
            'LV' => 'Latvia',
            'LI' => 'Liechtenstein',
            'LT' => 'Lithuania',
            'LU' => 'Luxembourg',
            'MK' => 'Macedonia',
            'MT' => 'Malta',
            'FX' => 'Metropolitan France',
            'MD' => 'Moldova',
            'MC' => 'Monaco',
            'ME' => 'Montenegro',
            'NL' => 'Netherlands',
            'NO' => 'Norway',
            'PL' => 'Poland',
            'PT' => 'Portugal',
            'RO' => 'Romania',
            'RU' => 'Russia',
            'SM' => 'San Marino',
            'RS' => 'Serbia',
            'CS' => 'Serbia and Montenegro',
            'SK' => 'Slovakia',
            'SI' => 'Slovenia',
            'ES' => 'Spain',
            'SJ' => 'Svalbard and Jan Mayen',
            'SE' => 'Sweden',
            'CH' => 'Switzerland',
            'UA' => 'Ukraine',
            'SU' => 'Union of Soviet Socialist Republics',
            'GB' => 'United Kingdom',
            'VA' => 'Vatican City',
            'AX' => 'Åland Islands',
            'XK' => 'Kosovo', // Unofficial, http://geonames.wordpress.com/2010/03/08/xk-country-code-for-kosovo/. Currently not fully UN recognised, UN-controlled ex-part of Serbia
        ),
        'Oceania' => array(
            'AS' => 'American Samoa',
            'AQ' => 'Antarctica',
            'AU' => 'Australia',
            'BV' => 'Bouvet Island',
            'IO' => 'British Indian Ocean Territory',
            'CX' => 'Christmas Island',
            'CC' => 'Cocos [Keeling] Islands',
            'CK' => 'Cook Islands',
            'FJ' => 'Fiji Islands',
            'PF' => 'French Polynesia',
            'TF' => 'French Southern Territories',
            'GU' => 'Guam',
            'HM' => 'Heard Island and McDonald Islands',
            'KI' => 'Kiribati',
            'MH' => 'Marshall Islands',
            'FM' => 'Micronesia',
            'NR' => 'Nauru',
            'NC' => 'New Caledonia',
            'NZ' => 'New Zealand',
            'NU' => 'Niue',
            'NF' => 'Norfolk Island',
            'MP' => 'Northern Mariana Islands',
            'PW' => 'Palau',
            'PG' => 'Papua New Guinea',
            'PN' => 'Pitcairn Islands',
            'WS' => 'Samoa',
            'SB' => 'Solomon Islands',
            'GS' => 'South Georgia and the South Sandwich Islands',
            'TK' => 'Tokelau',
            'TO' => 'Tonga',
            'TV' => 'Tuvalu',
            'UM' => 'United States Minor Outlying Islands',
            'VU' => 'Vanuatu',
            'WF' => 'Wallis and Futuna',
        ),
    );
}

function find_continents()
{
    global $COUNTRY_LIST;
    return array_keys($COUNTRY_LIST);
}

function find_continent($country)
{
    static $cache = array();

    if (isset($cache[$country])) {
        return $cache[$country];
    }

    global $COUNTRY_LIST;
    foreach ($COUNTRY_LIST as $continent => $countries) {
        if (in_array($country, $countries)) {
            $cache[$country] = $continent;
            return $continent;
        }
    }

    return null;
}

function find_iso_country_name($country)
{
    static $cache = array();

    if (isset($cache[$country])) {
        return $cache[$country];
    }

    global $COUNTRY_LIST;
    foreach ($COUNTRY_LIST as $countries) {
        $code = array_search($country, $countries);
        if ($code !== false) {
            $cache[$country] = $code;
            return $code;
        }
    }

    return null;
}

function find_country_name_from_iso($iso)
{
    static $cache = array();

    if (isset($cache[$iso])) {
        return $cache[$iso];
    }

    global $COUNTRY_LIST;
    foreach ($COUNTRY_LIST as $countries) {
        if (isset($countries[$iso])) {
            $cache[$iso] = $countries[$iso];
            return $countries[$iso];
        }
    }

    return null;
}

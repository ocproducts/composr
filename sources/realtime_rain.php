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
 * @package    realtime_rain
 */

/**
 * AJAX script for returning realtime-rain data.
 */
function realtime_rain_script()
{
    if (!addon_installed('realtime_rain')) {
        warn_exit(do_lang_tempcode('MISSING_ADDON', escape_html('realtime_rain')));
    }

    if (!has_actual_page_access(get_member(), 'admin_realtime_rain')) {
        access_denied('I_ERROR');
    }

    prepare_for_known_ajax_response();

    cms_ini_set('ocproducts.xss_detect', '0');

    header('Content-Type: text/xml');
    echo '<?xml version="1.0" encoding="' . escape_html(get_charset()) . '"?' . '>';
    echo '<request><result>';
    require_code('realtime_rain');
    require_lang('realtime_rain');

    $time_now = time();
    $from = get_param_integer('from', $time_now - 10);
    $to = get_param_integer('to', $time_now);

    if (get_param_integer('keep_realtime_test', 0) == 1) {
        $types = array('post', 'news', 'recommend', 'polls', 'ecommerce', 'actionlog', 'security', 'chat', 'stats', 'join', 'calendar', 'search', 'point_charges', 'banners', 'point_gifts');
        shuffle($types);

        $events = array();
        $cnt = count($types);
        for ($i = 0; $i < max($cnt, 5); $i++) {
            $timestamp = mt_rand($from, $to);
            $type = array_pop($types);

            $event = rain_get_special_icons(get_ip_address(), $timestamp) + array(
                    'TYPE' => $type,
                    'FROM_MEMBER_ID' => null,
                    'TO_MEMBER_ID' => null,
                    'TITLE' => 'Test',
                    'IMAGE' => rain_get_country_image(get_ip_address()),
                    'TIMESTAMP' => strval($timestamp),
                    'RELATIVE_TIMESTAMP' => strval($timestamp - $from),
                    'TICKER_TEXT' => null,
                    'URL' => null,
                    'IS_POSITIVE' => ($type == 'ecommerce' || $type == 'join'),
                    'IS_NEGATIVE' => ($type == 'security' || $type == 'point_charges'),

                    // These are for showing connections between drops. They are not discriminated, it's just three slots to give an ID code that may be seen as a commonality with other drops.
                    'FROM_ID' => null,
                    'TO_ID' => null,
                    'GROUP_ID' => 'example_' . strval(mt_rand(0, 4)),
                );
            $event['SPECIAL_ICON'] = 'email_icon';
            $event['MULTIPLICITY'] = '10';
            $events[] = $event;
        }
    } else {
        $events = get_realtime_events($from, $to);
    }

    shuffle($events);

    $out = new Tempcode();
    foreach ($events as $event) {
        $out->attach(do_template('REALTIME_RAIN_BUBBLE', $event));
    }
    $out->evaluate_echo();
    echo '</result></request>';

    exit(); // So auto_append_file cannot run and corrupt our output
}

/**
 * Get all the events within a timestamp range.
 *
 * @param  TIME $from From time (inclusive)
 * @param  TIME $to To time (inclusive)
 * @return array List of template parameter sets (perfect for use in a Tempcode LOOP)
 */
function get_realtime_events($from, $to)
{
    //restrictify();

    $drops = array();

    $hooks = find_all_hook_obs('systems', 'realtime_rain', 'Hook_realtime_rain_');
    foreach ($hooks as $ob) {
        $drops = array_merge($drops, $ob->run($from, $to));
    }

    return $drops;
}

/**
 * Make a realtime event bubble's title fit in the available space.
 *
 * @param  string $text Idealised title
 * @return Tempcode Cropped title, with tooltip for full title
 */
function rain_truncate_for_title($text)
{
    return protect_from_escaping(symbol_truncator(array($text, '40', '1'), 'left'));
}

/**
 * Get a country flag image for an IP address.
 *
 * @param  IP $ip_address An IP address
 * @return URLPATH Country flag image (blank: could not find one)
 */
function rain_get_country_image($ip_address)
{
    if ($ip_address == '') {
        return '';
    }

    require_code('locations');

    $country = geolocate_ip($ip_address);
    if ($country === null) {
        return '';
    }

    return find_theme_image('flags/' . $country);
}

/**
 * Returns a map with an icon and multiplicity parameter (that may be null).
 *
 * @param  ?IP $ip_address An IP address (used to check against bots) (null: no IP)
 * @param  TIME $timestamp A timestamp (used to check for logged sent e-mails)
 * @param  ?string $user_agent A user agent (used to check against phones) (null: no user agent)
 * @param  ?string $news News ticker news (null: no news ticker news)
 * @return array Map with an icon and multiplicity parameter
 */
function rain_get_special_icons($ip_address, $timestamp, $user_agent = null, $news = null)
{
    $icon = null;
    $tooltip = '';
    $multiplicity = 1;
    $bot = get_bot_type($user_agent);
    if ($bot !== null) {
        $icon = 'searchengine';
        $tooltip = do_lang('RTEV_BOT');
    } else {
        if (($user_agent !== null) && (is_mobile($user_agent))) {
            $icon = 'phone';
            $tooltip = do_lang('RTEV_PHONE');
        } else {
            $mails_sent = $GLOBALS['SITE_DB']->query_select_value('logged_mail_messages', 'COUNT(*)', array('m_date_and_time' => $timestamp));
            if ($mails_sent > 0) {
                $multiplicity = $mails_sent;
                $icon = 'email';
                $tooltip = do_lang('RTEV_EMAILS', integer_format($multiplicity));
            } elseif ($news !== null) {
                $icon = 'news';
                $tooltip = do_lang('RTEV_NEWS');
            }
        }
    }

    return array('SPECIAL_ICON' => $icon, 'SPECIAL_TOOLTIP' => $tooltip, 'MULTIPLICITY' => strval(min(20, $multiplicity)));
}

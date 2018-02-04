<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    calendar
 */

/**
 * Escapes a string as per the ical format.
 *
 * @param  string $in Input
 * @return string Output
 */
function ical_escape($in)
{
    $ret = str_replace("\n", '\n', str_replace(',', '\,', str_replace(';', '\;', str_replace('\\', '\\\\', $in))));
    if (strpos($ret, ':') !== false) {
        $ret = '"' . str_replace('"', '\"', $ret) . '"';
    }
    return $ret;
}

/**
 * Outputs the logged-in member's calendar view to ical.
 *
 * @param  boolean $headers_and_exit Whether to output headers and exit (if this is false it will still echo out, but you can capture with an output buffer)
 */
function output_ical($headers_and_exit = true)
{
    safe_ini_set('ocproducts.xss_detect', '0');

    if ($headers_and_exit) {
        header('Content-Type: text/calendar');
        header('Content-Disposition: inline; filename="export.ics"');
    }

    if ($_SERVER['REQUEST_METHOD'] == 'HEAD') {
        return;
    }

    if (php_function_allowed('set_time_limit')) {
        @set_time_limit(0);
    }

    $filter = get_param_integer('type_filter', null);
    if ($filter === 0) {
        $filter = null;
    }

    $where = '1=1';

    $privacy_join = '';
    if (addon_installed('content_privacy')) {
        require_code('content_privacy');
        list($privacy_join, $privacy_where) = get_privacy_where_clause('event', 'r', null, 'r.e_member_calendar=' . strval(get_member()));
        $where .= $privacy_where;
    }

    if (get_option('filter_regions') == '1') {
        require_code('locations');
        $where .= sql_region_filter('event', 'r.id');
    }

    if ($filter !== null) {
        if ($where != '') {
            $where .= ' AND ';
        }
        $where .= 'e_type=' . strval($filter);
    }

    if ($where != '') {
        $where .= ' AND ';
    }
    $where .= '(e_member_calendar=' . strval(get_member()) . ' OR e_submitter=' . strval(get_member()) . ' OR e_member_calendar IS NULL)'; // sanity filter

    echo "BEGIN:VCALENDAR\r\n";
    echo "VERSION:2.0\r\n";
    echo "PRODID:-//ocProducts/Composr//NONSGML v1.0//EN\r\n";
    echo "CALSCALE:GREGORIAN\r\n";
    $categories = array();
    $_categories = $GLOBALS['SITE_DB']->query_select('calendar_types', array('*'));
    foreach ($_categories as $category) {
        $categories[$category['id']] = get_translated_text($category['t_title']);
    }
    if (($filter === null) || (!array_key_exists($filter, $categories))) {
        echo "X-WR-CALNAME:" . ical_escape(get_site_name()) . "\r\n";
    } else {
        echo "X-WR-CALNAME:" . ical_escape(get_site_name() . ": " . $categories[$filter]) . "\r\n";
    }

    $start = 0;
    do {
        $events = $GLOBALS['SITE_DB']->query('SELECT * FROM ' . get_table_prefix() . 'calendar_events r' . $privacy_join . ' WHERE ' . $where . ' ORDER BY id ASC', 1000, $start);
        foreach ($events as $event) {
            if (!has_category_access(get_member(), 'calendar', strval($event['e_type']))) {
                continue;
            }

            $public = true;
            if (addon_installed('content_privacy')) {
                require_code('content_privacy');
                if (!has_privacy_access('event', strval($event['id']), $GLOBALS['FORUM_DRIVER']->get_guest_id())) {
                    $public = false;
                }
            }

            echo "BEGIN:VEVENT\r\n";

            echo "DTSTAMP:" . date('Ymd', $event['e_add_date']) . "T" . date('His', $event['e_add_date']) . "Z\r\n";
            echo "CREATED:" . date('Ymd', $event['e_add_date']) . "T" . date('His', $event['e_add_date']) . "Z\r\n";
            if ($event['e_edit_date'] !== null) {
                echo "LAST-MODIFIED:" . date('Ymd', $event['e_add_date']) . "T" . date('His', $event['e_edit_date']) . "Z\r\n";
            }

            echo "SUMMARY:" . ical_escape(get_translated_text($event['e_title'])) . "\r\n";
            $description = get_translated_text($event['e_content']);
            $matches = array();
            $num_matches = preg_match_all('#\[attachment[^\]]*\](\d+)\[/attachment\]#', $description, $matches);
            for ($i = 0; $i < $num_matches; $i++) {
                $description = str_replace($matches[0], '', $description);
                $attachments = $GLOBALS['SITE_DB']->query_select('attachments', array('*'), array('id' => intval($matches[1])));
                if (array_key_exists(0, $attachments)) {
                    $attachment = $attachments[0];
                    require_code('mime_types');
                    echo "ATTACH;FMTTYPE=" . ical_escape(get_mime_type($attachment['a_original_filename'], has_privilege($event['e_submitter'], 'comcode_dangerous'))) . ":" . ical_escape(find_script('attachments') . '?id=' . strval($attachment['id'])) . "\r\n";
                }
            }
            echo "DESCRIPTION:" . ical_escape(strip_comcode($description)) . "\r\n";

            echo "PRIORITY:" . strval($event['e_priority']) . "\r\n";

            if (!is_guest($event['e_submitter'])) {
                echo "ORGANIZER;CN=" . ical_escape($GLOBALS['FORUM_DRIVER']->get_username($event['e_submitter'], true)) . ";DIR=" . ical_escape($GLOBALS['FORUM_DRIVER']->member_profile_url($event['e_submitter'], false));
                $addr = $GLOBALS['FORUM_DRIVER']->get_member_email_address($event['e_submitter']);
                if ($addr != '') {
                    echo ":MAILTO:" . ical_escape($addr);
                }
                echo "\r\n";
            }
            echo "CATEGORIES:" . ical_escape($categories[$event['e_type']]) . "\r\n";
            echo "CLASS:" . ($public ? 'PUBLIC' : 'PRIVATE') . "\r\n";
            echo "STATUS:" . (($event['validated'] == 1) ? 'CONFIRMED' : 'TENTATIVE') . "\r\n";
            echo "UID:" . ical_escape(strval($event['id']) . '@' . get_base_url()) . "\r\n";
            $_url = build_url(array('page' => 'calendar', 'type' => 'view', 'id' => $event['id']), get_module_zone('calendar'), array(), false, false, true);
            $url = $_url->evaluate();
            echo "URL:" . $url . "\r\n";

            require_code('feedback');
            $forum = find_overridden_comment_forum('calendar', strval($event['e_type']));
            if ($forum === null) {
                $forum = get_option('comments_forum_name');
            }
            $start = 0;
            do {
                $count = 0;
                $_comments = $GLOBALS['FORUM_DRIVER']->get_forum_topic_posts($GLOBALS['FORUM_DRIVER']->find_topic_id_for_topic_identifier($forum, 'events_' . strval($event['id']), do_lang('COMMENT')), $count, 1000, $start);
                if (is_array($_comments)) {
                    foreach ($_comments as $comment) {
                        if ($comment['title'] != '') {
                            $comment['message'] = $comment['title'] . ': ' . $comment['message'];
                        }
                        echo "COMMENT:" . ical_escape(strip_comcode(is_object($comment['message']) ? $comment['message'] : $comment['message']) . ' - ' . $GLOBALS['FORUM_DRIVER']->get_username($comment['member'], true) . ' (' . get_timezoned_date_time($comment['date']) . ')') . "\r\n";
                    }
                } else {
                    break;
                }
                $start += 1000;
            } while (count($_comments) == 1000);

            $start_day_of_month = find_concrete_day_of_month($event['e_start_year'], $event['e_start_month'], $event['e_start_day'], $event['e_start_monthly_spec_type'], ($event['e_start_hour'] === null) ? find_timezone_start_hour_in_utc($event['e_timezone'], $event['e_start_year'], $event['e_start_month'], $event['e_start_day'], $event['e_start_monthly_spec_type']) : $event['e_start_hour'], ($event['e_start_minute'] === null) ? find_timezone_start_minute_in_utc($event['e_timezone'], $event['e_start_year'], $event['e_start_month'], $event['e_start_day'], $event['e_start_monthly_spec_type']) : $event['e_start_minute'], $event['e_timezone'], $event['e_do_timezone_conv'] == 1);
            $time = mktime(($event['e_start_hour'] === null) ? 12 : $event['e_start_hour'], ($event['e_start_minute'] === null) ? 0 : $event['e_start_minute'], 0, $event['e_start_month'], $start_day_of_month, $event['e_start_year']);
            if (($event['e_end_year'] === null) || ($event['e_end_month'] === null) || ($event['e_end_day'] === null)) {
                $time2 = null;
            } else {
                $end_day_of_month = find_concrete_day_of_month($event['e_end_year'], $event['e_end_month'], $event['e_end_day'], $event['e_end_monthly_spec_type'], ($event['e_end_hour'] === null) ? find_timezone_end_hour_in_utc($event['e_timezone'], $event['e_end_year'], $event['e_end_month'], $event['e_end_day'], $event['e_end_monthly_spec_type']) : $event['e_end_hour'], ($event['e_end_minute'] === null) ? find_timezone_end_minute_in_utc($event['e_timezone'], $event['e_end_year'], $event['e_end_month'], $event['e_end_day'], $event['e_end_monthly_spec_type']) : $event['e_end_minute'], $event['e_timezone'], $event['e_do_timezone_conv'] == 1);
                $time2 = mktime(($event['e_end_hour'] === null) ? 12 : $event['e_end_hour'], ($event['e_end_minute'] === null) ? 0 : $event['e_end_minute'], 0, $event['e_end_month'], $end_day_of_month, $event['e_end_year']);
            }
            if ($event['e_recurrence'] != 'none') {
                $parts = explode(' ', $event['e_recurrence']);
                if (count($parts) == 1) {
                    $parts[] = '1';
                }

                // Recurrence pattern handling
                for ($i = 0; $i < strlen($parts[1]); $i++) { // For each part of the recurrence pattern we set out a separate event intervaling in step with it
                    if ($i != 0) {
                        switch ($parts[0]) {
                            case 'daily':
                                $time += 60 * 60 * 24;
                                if ($time2 !== null) {
                                    $time2 += 60 * 60 * 24;
                                }
                                break;
                            case 'weekly':
                                $time += 60 * 60 * 24 * 7;
                                if ($time2 !== null) {
                                    $time2 += 60 * 60 * 24 * 7;
                                }
                                break;
                            case 'monthly':
                                $days_in_month = intval(date('D', mktime(0, 0, 0, intval(date('m', $time)) + 1, 0, intval(date('Y', $time)))));
                                $time += 60 * 60 * $days_in_month;
                                if ($time2 !== null) {
                                    $time2 += 60 * 60 * $days_in_month;
                                }
                                break;
                            case 'yearly':
                                $days_in_year = intval(date('Y', mktime(0, 0, 0, 0, 0, intval(date('Y', $time)) + 1)));
                                $time += 60 * 60 * 24 * $days_in_year;
                                if ($time2 !== null) {
                                    $time2 += 60 * 60 * 24 * $days_in_year;
                                }
                                break;
                        }
                    }
                    if ($parts[1][$i] != '0') {
                        echo "DTSTART;TZID=" . $event['e_timezone'] . ":" . date('Ymd', $time) . (($event['e_start_hour'] === null) ? "" : ("T" . date('His', $time))) . "\r\n";
                        if ($time2 !== null) {
                            echo "DTEND:" . date('Ymd', $time2) . (($event['e_end_hour'] === null) ? "" : ("T" . date('His', $time2))) . "\r\n";
                        }
                        $recurrence_code = 'FREQ=' . strtoupper($parts[0]); // MONTHLY etc
                        echo "RRULE:" . $recurrence_code;
                        if (strlen($parts[1]) != 1) {
                            echo ";INTERVAL=" . strval(strlen($parts[1]));
                        }
                        if ($event['e_recurrences'] !== null) {
                            echo ";COUNT=" . strval($event['e_recurrences']);
                        }
                        if ($event['e_start_monthly_spec_type'] != 'day_of_month') {
                            switch ($event['e_start_monthly_spec_type']) {
                                case 'day_of_month_backwards':
                                    // Not supported by iCalendar
                                    break;
                                case 'dow_of_month':
                                case 'dow_of_month_backwards':
                                    echo ';BYDAY=';
                                    echo ($event['e_start_monthly_spec_type'] == 'dow_of_month') ? '+' : '-';
                                    echo strval(intval(floatval($event['e_start_day']) / 7.0 + 1));
                                    switch ($event['e_start_day'] % 7) {
                                        case 0:
                                            echo 'MO';
                                            break;
                                        case 1:
                                            echo 'TU';
                                            break;
                                        case 2:
                                            echo 'WE';
                                            break;
                                        case 3:
                                            echo 'TH';
                                            break;
                                        case 4:
                                            echo 'FR';
                                            break;
                                        case 5:
                                            echo 'SA';
                                            break;
                                        case 6:
                                            echo 'SU';
                                            break;
                                    }
                                    break;
                            }
                        }
                        echo "\r\n";
                    }
                }
            } else {
                echo "DTSTART;TZID=" . $event['e_timezone'] . ":" . date('Ymd', $time) . "T" . date('His', $time) . "\r\n";
                if ($time2 !== null) {
                    echo "DTEND:" . date('Ymd', $time2) . (($event['e_start_hour'] === null) ? "" : "T" . date('His', $time2)) . "\r\n";
                }
            }

            $attendees = $GLOBALS['SITE_DB']->query_select('calendar_reminders', array('*'), array('e_id' => $event['id']), '', 5000/*reasonable limit*/);
            if (count($attendees) == 5000) {
                $attendees = array();
            }
            foreach ($attendees as $attendee) {
                if ($attendee['n_member_id'] != get_member()) {
                    if (!is_guest($event['n_member_id'])) {
                        echo "ATTENDEE;CN=" . ical_escape($GLOBALS['FORUM_DRIVER']->get_username($attendee['n_member_id'], true)) . ";DIR=" . ical_escape($GLOBALS['FORUM_DRIVER']->member_profile_url($attendee['n_member_id'], false));
                    }
                    $addr = $GLOBALS['FORUM_DRIVER']->get_member_email_address($attendee['n_member_id']);
                    if ($addr != '') {
                        echo ":MAILTO:" . ical_escape($addr);
                    }
                    echo "\r\n";
                } else {
                    echo "BEGIN:VALARM\r\n";
                    echo "X-WR-ALARMUID:alarm" . ical_escape(strval($event['id']) . '@' . get_base_url()) . "\r\n";
                    echo "ACTION:AUDIO\r\n";
                    echo "TRIGGER:-PT" . strval($attendee['n_seconds_before']) . "S\r\n";
                    echo "ATTACH;VALUE=URI:Basso\r\n";
                    echo "END:VALARM\r\n";
                }
            }

            echo "END:VEVENT\r\n";
        }

        $start += 1000;
    } while (array_key_exists(0, $events));

    echo "END:VCALENDAR\r\n";

    if ($headers_and_exit) {
        exit();
    }
}

/**
 * Import ical events to members's event calendar.
 *
 * @param  PATH $file_path File path
 */
function ical_import($file_path)
{
    $data = unixify_line_format(file_get_contents($file_path));

    $calendars = explode('BEGIN:VCALENDAR', $data);
    $calendar = end($calendars);
    $events = explode('BEGIN:VEVENT', $calendar);
    foreach ($events as $key => $items) {
        if ($key == 0) {
            continue; // This is before the first event block
        }

        // Pre-processing of notes
        $items = preg_replace('#(.+)\n +(.*)\r?\n#', '${1}${2}' . "\n", $items); // Merge split lines
        $event_nodes = array();
        $nodes = explode("\n", $items);
        foreach ($nodes as $_child) {
            if (strpos($_child, ':') === false) {
                continue;
            }

            $child = array('', '');
            $in_quotes = false;
            $j = 0;
            for ($i = 0; $i < strlen($_child); $i++) {
                $char = $_child[$i];
                if ($char == '"') {
                    $in_quotes = !$in_quotes;
                }
                if (($j != 1) && (!$in_quotes) && ($char == ':')) {
                    $j++;
                } else {
                    $child[$j] .= $char;
                }
            }

            $matches = array();
            if (preg_match('#;TZID=(.*)#', $child[0], $matches)) {
                $event_nodes['TZID'] = $matches[1];
            }
            $child[0] = preg_replace('#;.*#', '', $child[0]);

            if (array_key_exists(1, $child) && $child[0] !== 'PRODID' && $child[0] !== 'VERSION' && $child[0] !== 'END') {
                $event_nodes[$child[0]] = trim($child[1]);
            }
        }

        // Process node data into event properties
        list(, $type_id, $type, $recurrence, $recurrences, $seg_recurrences, $title, $content, $priority, $is_public, $start_year, $start_month, $start_day, $start_monthly_spec_type, $start_hour, $start_minute, $end_year, $end_month, $end_day, $end_monthly_spec_type, $end_hour, $end_minute, $timezone, $validated, $allow_rating, $allow_comments, $allow_trackbacks, $notes) = get_event_data_ical($event_nodes);

        // Add missing event types
        if ($type_id === null) {
            require_code('calendar2');
            $type_id = add_event_type(ucfirst($type), 'icons/calendar/general');
        }

        // Add event
        $id = add_calendar_event($type_id, $recurrence, $recurrences, $seg_recurrences, $title, $content, $priority, $start_year, $start_month, $start_day, $start_monthly_spec_type, $start_hour, $start_minute, $end_year, $end_month, $end_day, $end_monthly_spec_type, $end_hour, $end_minute, $timezone, 1, null, $validated, $allow_rating, $allow_comments, $allow_trackbacks, $notes);

        // Set privacy
        if ($is_public == 0) {
            if (addon_installed('content_privacy')) {
                $GLOBALS['SITE_DB']->query_insert('content_privacy', array(
                    'content_type' => 'event',
                    'content_id' => strval($id),
                    'guest_view' => 0,
                    'member_view' => 0,
                    'friend_view' => 0,
                ));
            }
        }
    }
}

/**
 * Get array of an events from node of an imported ical file.
 *
 * @param  array $event_nodes Array of given event details
 * @return array Returns array of event details for mapping
 */
function get_event_data_ical($event_nodes)
{
    $url = '';
    $type = null; //default value
    $e_recurrence = 'none';
    $recurrences = null;
    $seg_recurrences = 0;
    $title = '';
    $content = '';
    $priority = 2;
    $is_public = 1;
    $start_year = 2000;
    $start_month = 1;
    $start_day = 1;
    $start_hour = 0;
    $start_minute = 0;
    $end_year = null;
    $end_month = null;
    $end_day = null;
    $end_hour = null;
    $end_minute = null;
    $timezone = 'UTC';
    $notes = '';
    $validated = 1;
    $allow_rating = 1;
    $allow_comments = 1;
    $allow_trackbacks = 1;
    $matches = array();
    $start_monthly_spec_type = 'day_of_month';
    $end_monthly_spec_type = $start_monthly_spec_type;
    $start_monthly_spec_type_day = null;

    $rec_array = array('FREQ', 'BYDAY', 'INTERVAL', 'COUNT');
    $rec_by_day = array('MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU');

    //if (array_key_exists('LOCATION', $event_nodes))
    //    $geo_position = $event_nodes['LOCATION'];      We don't support these in Composr, at least not yet

    if ((array_key_exists('CLASS', $event_nodes)) && ($event_nodes['CLASS'] == 'PRIVATE')) {
        $is_public = 0;
    }

    if (array_key_exists('RRULE', $event_nodes)) {
        $byday = '';
        foreach ($rec_array as $value) {
            if (preg_match('/^((.)*(' . $value . '=))([^;]+)/i', $event_nodes['RRULE'], $matches) != 0) {
                switch ($value) {
                    case 'BYDAY':
                        $matches2 = array();
                        if (preg_match('#^([\+\-] )?(\d+) ?(MO|TU|WE|TH|FR|SA|SU)#', end($matches), $matches2) != 0) {
                            if ($matches2[1] == '-') {
                                $start_monthly_spec_type = 'dow_of_month_backwards';
                            } else {
                                $start_monthly_spec_type = 'dow_of_month';
                            }
                            $end_monthly_spec_type = $start_monthly_spec_type;
                            switch ($matches2[3]) { // The data collected here is not actually used, because it is automatically derivable
                                case 'MO':
                                    $start_monthly_spec_type_day = 0 + (intval($matches2[2]) - 1) * 7;
                                    break;
                                case 'TU':
                                    $start_monthly_spec_type_day = 1 + (intval($matches2[2]) - 1) * 7;
                                    break;
                                case 'WE':
                                    $start_monthly_spec_type_day = 2 + (intval($matches2[2]) - 1) * 7;
                                    break;
                                case 'TH':
                                    $start_monthly_spec_type_day = 3 + (intval($matches2[2]) - 1) * 7;
                                    break;
                                case 'FR':
                                    $start_monthly_spec_type_day = 4 + (intval($matches2[2]) - 1) * 7;
                                    break;
                                case 'SA':
                                    $start_monthly_spec_type_day = 5 + (intval($matches2[2]) - 1) * 7;
                                    break;
                                case 'SU':
                                    $start_monthly_spec_type_day = 6 + (intval($matches2[2]) - 1) * 7;
                                    break;
                            }
                        }
                        break;

                    case 'FREQ':
                        $e_recurrence = strtolower(end($matches));
                        break;

                    case 'INTERVAL':
                        $rec_patern = ' 1';

                        for ($i = 1; $i < intval(end($matches)); $i++) {
                            $rec_patern .= '0';
                        }

                        $e_recurrence .= $rec_patern;
                        break;

                    case 'COUNT':
                        $recurrences = end($matches);
                        break;
                }
            }
        }
    }

    if (array_key_exists('CATEGORIES', $event_nodes)) {
        $type = strtolower($event_nodes['CATEGORIES']);
    }

    // Check existency of category
    $type_id = null;
    if ($type === null) {
        $type = do_lang('GENERAL');
    }
    $rows = $GLOBALS['SITE_DB']->query_select('calendar_types', array('id', 't_title'));
    foreach ($rows as $row) {
        if (strtolower($type) == strtolower(get_translated_text($row['t_title']))) {
            $type_id = $row['id'];
        }
    }

    if (array_key_exists('SUMMARY', $event_nodes)) {
        $title = $event_nodes['SUMMARY'];
        $content = $event_nodes['SUMMARY'];
    }
    if (array_key_exists('DESCRIPTION', $event_nodes)) {
        $content = str_replace('\n', "\n", $event_nodes['DESCRIPTION']);
    }

    if (array_key_exists('PRIORITY', $event_nodes)) {
        $priority = $event_nodes['PRIORITY'];
    }

    if (array_key_exists('TZID', $event_nodes)) {
        $timezone = $event_nodes['TZID'];
    }

    if (array_key_exists('URL', $event_nodes)) {
        $url = $event_nodes['URL'];
    }

    $all_day = true;

    if (array_key_exists('DTSTART', $event_nodes)) {
        if (strlen($event_nodes['DTSTART']) == 8) {
            $event_nodes['DTSTART'] .= ' 00:00';
        }
        if (substr($event_nodes['DTSTART'], -6) != ' 00:00') {
            $all_day = false;
        }
        $start = strtotime($event_nodes['DTSTART']);
        $start_year = intval(date('Y', $start));
        $start_month = intval(date('m', $start));
        $start_day = intval(date('d', $start));
        $start_hour = $all_day ? null : intval(date('H', $start));
        $start_minute = $all_day ? null : intval(date('i', $start));
        if ($all_day) {
            $timestamp = mktime(0, 0, 0, $start_month, $start_day, $start_year);
            $amount_forward = tz_time($timestamp, $timezone) - $timestamp;
            $timestamp = $timestamp + $amount_forward;
            list($start_year, $start_month, $start_day) = array_map('intval', explode('-', date('Y-m-d', $timestamp)));
        } else {
            $timestamp = mktime($start_hour, $start_minute, 0, $start_month, $start_day, $start_year);
            $amount_forward = tz_time($timestamp, $timezone) - $timestamp;
            $timestamp = $timestamp + $amount_forward;
            list($start_year, $start_month, $start_day, $start_hour, $start_minute) = array_map('intval', explode('-', date('Y-m-d-H-i-s', $timestamp)));
        }
    }

    if (array_key_exists('DTEND', $event_nodes)) {
        if (strlen($event_nodes['DTEND']) == 8) {
            $event_nodes['DTEND'] .= ' 00:00';
        }
        if (substr($event_nodes['DTEND'], -6) != ' 00:00') {
            $all_day = false;
        }
        $end = strtotime($event_nodes['DTEND']);
        $end_year = intval(date('Y', $end));
        $end_month = intval(date('m', $end));
        $end_day = intval(date('d', $end));
        $end_hour = null;
        $end_minute = null;
        $end_hour = $all_day ? null : intval(date('H', $end));
        $end_minute = $all_day ? null : intval(date('i', $end));

        if ($all_day) {
            $timestamp = mktime(0, 0, 0, $end_month, $end_day, $end_year);
            $amount_forward = tz_time($timestamp, $timezone) - $timestamp;
            $timestamp = $timestamp - $amount_forward;
            list($end_year, $end_month, $end_day) = array_map('intval', explode('-', date('Y-m-d', $timestamp)));
        } else {
            $timestamp = mktime($end_hour, $end_minute, 0, $end_month, $end_day, $end_year);
            $amount_forward = tz_time($timestamp, $timezone) - $timestamp;
            $timestamp = $timestamp - $amount_forward;
            list($end_year, $end_month, $end_day, $end_hour, $end_minute) = array_map('intval', explode('-', date('Y-m-d-H-i-s', $timestamp)));
        }
    }

    if ($start_monthly_spec_type != 'day_of_month') {
        $start_day = find_abstract_day(intval(date('Y', $start)), intval(date('m', $start)), intval(date('d', $start)), $start_monthly_spec_type);
    }

    if (($end_monthly_spec_type != 'day_of_month') && ($end_day !== null)) {
        $end_day = find_abstract_day(intval(date('Y', $end)), intval(date('m', $end)), intval(date('d', $end)), $start_monthly_spec_type/*not encoded differently in iCalendar*/);
    }

    if ($all_day) {
        $start_hour = null;
        $start_minute = null;
        $end_hour = null;
        $end_minute = null;
    }

    $ret = array($url, $type_id, $type, $e_recurrence, $recurrences, $seg_recurrences, $title, $content, $priority, $is_public, $start_year, $start_month, $start_day, $start_monthly_spec_type, $start_hour, $start_minute, $end_year, $end_month, $end_day, $end_monthly_spec_type, $end_hour, $end_minute, $timezone, $validated, $allow_rating, $allow_comments, $allow_trackbacks, $notes);
    return $ret;
}

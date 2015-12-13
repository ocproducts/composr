<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_homesite_support_credits
 */

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

$cms_hours_field = $GLOBALS['FORUM_DB']->query_value_if_there('SELECT id FROM mantis_custom_field_table WHERE name=\'Time estimation (hours)\'');
require_lang('customers');
$title_tracker = do_lang('TRACKER');

$result = get_option('currency', true);
$s_currency = is_null($result) ? 'USD' : strval($result);
$s_credit_value = floatval(get_option('support_credit_value'));
$budget_minutes = intval(get_option('support_budget_priority'));
$multi_rate = (intval(60 / $budget_minutes) < 1) ? 1 : intval(60 / $budget_minutes);
if (!running_script('tracker')) {
    $params = '';
    foreach ($map as $key => $val) {
        $params .= ($params == '') ? '?' : '&';
        $params .= $key . '=' . urlencode($val);
    }
    $params .= static_evaluate_tempcode(symbol_tempcode('KEEP'));
    $frame_name = 'frame_' . uniqid('', true);
    echo '
        <div style="padding: 1em">
            <iframe title="' . $title_tracker . '" frameborder="0" name="' . $frame_name . '" id="' . $frame_name . '" marginwidth="0" marginheight="0" class="expandable_iframe" scrolling="no" src="' . find_script('tracker') . $params . '">' . $title_tracker . '</iframe>
        </div>

        <script>// <![CDATA[
            window.setInterval(function() {
                    if ((typeof window.frames[\'' . $frame_name . '\']!=\'undefined\') && (typeof window.frames[\'' . $frame_name . '\'].trigger_resize!=\'undefined\')) resizeFrame(\'' . $frame_name . '\');
            }, 1000);
        //]]></script>
    ';
    return;
}

require_code('xhtml');

$max = get_param_integer('mantis_max', 10);
$start = get_param_integer('mantis_start', 0);

$db = new DatabaseConnector(get_db_site(), get_db_site_host(), get_db_site_user(), get_db_site_password(), '');

$where = 'duplicate_id=0';
$where .= ' AND view_state=10';
$where .= ' AND severity=10';
if (isset($map['completed'])) {
    $where .= ' AND ' . (($map['completed'] == '0') ? 'a.status<=50' : 'a.status=80');
}
if (isset($map['voted'])) {
    $where .= ' AND (' . (($map['voted'] == '1') ? /*disabled as messy if someone's reported lots 'a.reporter_id='.strval(get_member()).' OR '.*/'EXISTS' : 'NOT EXISTS') . ' (SELECT * FROM mantis_bug_monitor_table p WHERE user_id=' . strval(get_member()) . ' AND p.bug_id=a.id))';
}
if (isset($map['project'])) {
    $where .= ' AND a.project_id=' . strval(intval($map['project']));
}

$order = 'id';

if (isset($map['sort'])) {
    list($sort, $direction) = explode(' ', $map['sort'], 2);
    if (($direction != 'ASC') && ($direction != 'DESC')) {
        $direction = 'DESC';
    }
    switch ($sort) {
        case 'popular':
            $order = 'num_votes ' . $direction;
            break;
        case 'added':
            $order = 'date_submitted ' . $direction;
            break;
        case 'hours':
            $order = 'hours ' . $direction;
            $where .= ' AND ' . db_string_not_equal_to('c.value', '');
            break;
        case 'sponsorship_progress':
            $where .= ' AND (SELECT SUM(amount) FROM mantis_sponsorship_table z WHERE z.bug_id=a.id)<>0';
            $order = '(SELECT SUM(amount) FROM mantis_sponsorship_table z WHERE z.bug_id=a.id)/CAST(c.value AS DECIMAL)*' . strval($multi_rate) . '*' . float_to_raw_string($s_credit_value) . ' ' . $direction;
            break;
    }
}

$select = 'a.*,b.description,d.name AS category';
$select .= ',(SELECT COUNT(*) FROM mantis_bugnote_table x WHERE x.bug_id=a.id) AS num_comments';
$select .= ',(SELECT COUNT(*) FROM mantis_bug_monitor_table y WHERE y.bug_id=a.id) AS num_votes';
$select .= ',(SELECT SUM(amount) FROM mantis_sponsorship_table z WHERE z.bug_id=a.id) AS money_raised';
$select .= ',CAST(c.value AS DECIMAL) as hours';
$select .= ',CAST(c.value AS DECIMAL)*' . strval($multi_rate) . '*' . float_to_raw_string($s_credit_value) . ' AS currency_needed';
$table = 'mantis_bug_table a JOIN mantis_bug_text_table b ON b.id=a.bug_text_id JOIN mantis_custom_field_string_table c ON c.bug_id=a.id AND field_id=' . $cms_hours_field . ' JOIN mantis_category_table d ON d.id=a.category_id';
$query = 'SELECT ' . $select . ' FROM ' . $table . ' WHERE ' . $where . ' ORDER BY ' . $order;

$issues = $db->query($query, $max, $start);
$max_rows = count($db->query($query));

if (count($issues) == 0) {
    echo '<p class="nothing_here">' . do_lang('FEATURES_NOTHING_YET') . '</p>';
} else {
    echo '<div style="font-size: 0.9em">';

    foreach ($issues as $issue) {
        $title = $issue['category'] . ': ' . $issue['summary'];
        $description = $issue['description'];
        $votes = intval($issue['num_votes']);
        $cost = ($issue['hours'] == 0 || is_null($issue['hours'])) ? mixed() : ($issue['hours'] * $s_credit_value * $multi_rate);
        $money_raised = $issue['money_raised'];
        $suggested_by = $issue['reporter_id'];
        $add_date = $issue['date_submitted'];
        $vote_url = get_base_url() . '/tracker/bug_monitor_add.php?bug_id=' . strval($issue['id']);
        $unvote_url = get_base_url() . '/tracker/bug_monitor_delete.php?bug_id=' . strval($issue['id']);
        $voted = !is_null($db->query_select_value_if_there('mantis_bug_monitor_table', 'user_id', array('user_id' => get_member(), 'bug_id' => $issue['id'])));
        $full_url = get_base_url() . '/tracker/view.php?id=' . strval($issue['id']);
        $num_comments = $issue['num_comments'];

        $_cost = is_null($cost) ? do_lang('FEATURES_UNKNOWN_lc') : (static_evaluate_tempcode(comcode_to_tempcode('[currency="' . $s_currency . '"]' . float_to_raw_string($cost) . '[/currency]')));
        $_money_raised = static_evaluate_tempcode(comcode_to_tempcode('[currency="' . $s_currency . '"]' . float_to_raw_string($money_raised) . '[/currency]'));
        $_hours = is_null($cost) ? do_lang('FEATURES_UNKNOWN_lc') : (escape_html(number_format($issue['hours'])) . ' ' . do_lang('FEATURES_HOURS_lc'));
        $_credits = is_null($cost) ? do_lang('FEATURES_UNKNOWN_lc') : (escape_html(number_format($issue['hours'] * $multi_rate)) . ' ' . do_lang('FEATURES_CREDITS_lc'));
        $_percentage = is_null($cost) ? do_lang('FEATURES_UNKNOWN_lc') : (escape_html(float_format(100.0 * $money_raised / $cost, 0)) . '%');
        $member_linked = static_evaluate_tempcode($GLOBALS['FORUM_DRIVER']->member_profile_hyperlink($suggested_by));
        $date_prepped = escape_html(get_timezoned_date($add_date, false));
        $comments_label = $num_comments != 1 ? do_lang('FEATURES_comment') : do_lang('FEATURES_comments');

        $out = '';
        $out .= '
            <div style="float: left; width: 140px; text-align: center; border: 1px solid #AAA" class="medborder">
                    <p style="font-size: 1.5em"><strong>' . escape_html(number_format($votes)) . '</strong> ' . (($votes == 1) ? do_lang('FEATURES_vote') : do_lang('FEATURES_votes')) . '</p>
        ';

        if (!$voted) {
            $out .= '
                            <p onclick="this.style.border=\'1px dotted blue\';"><a style="text-decoration: none" target="_blank" href="' . escape_html($vote_url) . '"><img style="vertical-align: middle" src="' . find_theme_image('tracker/plus') . '" /> <span style="vertical-align: middle">' . do_lang('FEATURES_Vote') . '</span></a></p>
            ';
        } else {
            $out .= '
                            <p onclick="this.style.border=\'1px dotted blue\';"><a style="text-decoration: none" target="_blank" href="' . escape_html($unvote_url) . '"><img style="vertical-align: middle" src="' . find_theme_image('tracker/minus') . '" /> <span style="vertical-align: middle">' . do_lang('FEATURES_Unvote') . '</span></a></p>';
        }

        $out .= '<p style="font-size: 0.8em">' . do_lang('FEATURES_Raised_percent_of', $_percentage, $_credits);

        if (!is_null($cost)) {
            $out .= '
                            <br />
                            <span class="associated_details">(' . do_lang('FEATURES_credits_hours_cost', $_credits, $_hours, $_cost) . ')</span>';
        }
        $out .= '
                    </p>
            </div>

            <div style="margin-left: 150px">
                    <p style="min-height: 7.5em">' . xhtml_substr(nl2br(escape_html($description)), 0, 310, false, true) . '</p>

                    <p style="float: right; margin-bottom: 0" class="associated_details" style="color: #777">' . do_lang('FEATURES_Suggested_by', $member_linked, $date_prepped) . '</p>

                    <p class="associated_link_to_small" style="float: left; margin-bottom: 0">&raquo; <a href="' . escape_html($full_url) . '">' . do_lang('FEATURES_Full_details') . '</a> (' . escape_html(number_format($num_comments)) . ' ' . ($comments_label) . ')</p>
            </div>
        ';

        echo static_evaluate_tempcode(put_in_standard_box(make_string_tempcode($out), $title, 'curved'));
    }

    echo '</div>';
}

require_code('templates_pagination');
$pagination = pagination(make_string_tempcode('Issues'), $start, 'mantis_start', $max, 'mantis_max', $max_rows);
echo '<div class="float_surrounder">';
echo str_replace(get_base_url() . ((get_zone_name() == '') ? '' : '/') . get_zone_name() . '/index.php', find_script('tracker'), $pagination->evaluate());
echo '</div>';

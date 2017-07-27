<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    pointstore
 */

/**
 * Hook class.
 */
class Hook_pointstore_topic_pin
{
    /**
     * Standard pointstore item initialisation function.
     */
    public function init()
    {
        require_lang('cns');
    }

    /**
     * Standard pointstore item "shop front" function.
     *
     * @return array The "shop fronts"
     */
    public function info()
    {
        $class = str_replace('hook_pointstore_', '', strtolower(get_class($this)));
        if (get_option('is_on_' . $class . '_buy') == '0') {
            return array();
        }
        if (has_no_forum()) {
            return array();
        }

        $next_url = build_url(array('page' => '_SELF', 'type' => '_topic_pin', 'id' => $class), '_SELF');
        return array(do_template('POINTSTORE_' . strtoupper($class), array('NEXT_URL' => $next_url)));
    }

    /**
     * Standard stage of pointstore item purchase.
     *
     * @return Tempcode The UI
     */
    public function _topic_pin()
    {
        $class = str_replace('hook_pointstore_', '', strtolower(get_class($this)));
        if (get_option('is_on_' . $class . '_buy') == '0') {
            return new Tempcode();
        }
        if (has_no_forum()) {
            return new Tempcode();
        }

        $title = get_screen_title('TOPIC_PINNING');

        // Build up fields
        require_code('form_templates');
        $fields = new Tempcode();
        if (get_forum_type() == 'cns') {
            $set_name = 'topic';
            $required = true;
            $set_title = do_lang_tempcode('FORUM_TOPIC');
            $field_set = alternate_fields_set__start($set_name);

            $field_set->attach(form_input_tree_list(do_lang_tempcode('CHOOSE'), '', 'select_topic_id', null, 'choose_topic', array(), false));

            $field_set->attach(form_input_integer(do_lang_tempcode('IDENTIFIER'), do_lang_tempcode('DESCRIPTION_FORUM_TOPIC_ID'), 'manual_topic_id', null, false));

            $fields->attach(alternate_fields_set__end($set_name, $set_title, '', $field_set, $required));
        } else {
            $fields->attach(form_input_integer(do_lang_tempcode('FORUM_TOPIC'), do_lang_tempcode('ENTER_TOPIC_ID_MANUALLY'), 'manual_topic_id', null, false));
        }
        $fields->attach(form_input_integer(do_lang_tempcode('TOPIC_PIN_NUMBER_DAYS'), do_lang_tempcode('TOPIC_PIN_NUMBER_DAYS_DESCRIPTION'), 'days', min(7, intval(get_option('topic_pin_max_days'))), true));

        $price = intval(get_option('topic_pin'));
        $text = do_lang_tempcode('PIN_TOPIC_A', escape_html(integer_format($price)));

        // Return template
        $post_url = build_url(array('page' => '_SELF', 'type' => '__topic_pin', 'id' => 'topic_pin'), '_SELF');
        $javascript = "
            var form=document.getElementById('days').form;
            form.old_submit=form.onsubmit;
            form.onsubmit=function() {
                var days=form.elements['days'].value;
                if (days>" . strval(intval(get_option('topic_pin_max_days'))) . ")
                {
                    window.fauxmodal_alert('" . php_addslashes(do_lang('TOPIC_PINNED_MAX_DAYS', integer_format(intval(get_option('topic_pin_max_days'))), 'xxx')) . "'.replace(/xxx/g,days));
                    return false;
                }
                return true;
            };
        ";
        return do_template('FORM_SCREEN', array(
            '_GUID' => '318a1f335fd0d2d9380024eb5438d2d8',
            'HIDDEN' => '',
            'TITLE' => $title,
            'ACTION' => do_lang_tempcode('TOPIC_PINNING'),
            'TEXT' => $text,
            'URL' => $post_url,
            'SUBMIT_ICON' => 'buttons__proceed',
            'SUBMIT_NAME' => do_lang_tempcode('PURCHASE'),
            'FIELDS' => $fields,
            'JAVASCRIPT' => $javascript,
        ));
    }

    /**
     * Standard stage of pointstore item purchase.
     *
     * @return Tempcode The UI
     */
    public function __topic_pin()
    {
        $class = str_replace('hook_pointstore_', '', strtolower(get_class($this)));
        if (get_option('is_on_' . $class . '_buy') == '0') {
            return new Tempcode();
        }
        if (has_no_forum()) {
            return new Tempcode();
        }

        $title = get_screen_title('TOPIC_PINNING');

        // So we don't need to call this big long ugly name...
        $days = post_param_integer('days');
        $topic_id = post_param_integer('select_topic_id', -1);
        if ($topic_id == -1) {
            $_topic_id = post_param_string('manual_topic_id');
            $topic_id = intval($_topic_id);
        }

        $member_id = get_member();
        $points_left = available_points($member_id);

        // First we need to know the price of the number of days we ordered.
        // After that will be compare that price with our users current number of points.
        $day_price = intval(get_option('topic_pin'));
        $total = $day_price * $days;

        if (!($days >= 1)) {
            return warn_screen($title, do_lang_tempcode('TOPIC_PIN_POSITIVE_DAYS'));
        }

        if (($points_left < $total) && (!has_privilege(get_member(), 'give_points_self'))) {
            return warn_screen($title, do_lang_tempcode('TOPIC_PIN_LACK_POINTS', escape_html(integer_format($days)), escape_html(integer_format($total)), array(integer_format($points_left))));
        }

        // The order screen...
        $action = do_lang_tempcode('CONFIRM_TOPIC_PIN', escape_html(integer_format($days)));
        $keep = form_input_hidden('topic_id', strval($topic_id));
        $keep->attach(form_input_hidden('days', strval($days)));
        $proceed_url = build_url(array('page' => '_SELF', 'type' => '___topic_pin', 'id' => 'topic_pin'), '_SELF');

        return do_template('POINTSTORE_CONFIRM_SCREEN', array(
            '_GUID' => '94abff69da7ba3cca3d125ac4d519d72',
            'TITLE' => $title,
            'KEEP' => $keep,
            'ACTION' => $action,
            'COST' => integer_format($total),
            'POINTS_AFTER' => integer_format($points_left - $total),
            'PROCEED_URL' => $proceed_url,
            'CANCEL_URL' => build_url(array('page' => '_SELF'), '_SELF'),
        ));
    }

    /**
     * Standard stage of pointstore item purchase.
     *
     * @return Tempcode The UI
     */
    public function ___topic_pin()
    {
        $class = str_replace('hook_pointstore_', '', strtolower(get_class($this)));
        if (get_option('is_on_' . $class . '_buy') == '0') {
            return new Tempcode();
        }
        if (has_no_forum()) {
            return new Tempcode();
        }

        $title = get_screen_title('TOPIC_PINNING');

        // Define variables
        $member_id = get_member();
        $topic_id = post_param_integer('topic_id');
        $days = post_param_integer('days');
        if ($days > intval(get_option('topic_pin_max_days'))) {
            return warn_screen($title, do_lang_tempcode('TOPIC_PINNED_MAX_DAYS', escape_html(integer_format(intval(get_option('topic_pin_max_days')))), escape_html(integer_format($days))));
        }
        $points_left = available_points($member_id);

        // First we need to know the price of the number of days we ordered. After that, compare that price with our users current number of points.
        $day_price = intval(get_option('topic_pin'));
        $total = $day_price * $days;

        if (($points_left < $total) && (!has_privilege(get_member(), 'give_points_self'))) {
            return warn_screen($title, do_lang_tempcode('TOPIC_PIN_LACK_POINTS', escape_html(integer_format($days)), escape_html(integer_format($total)), escape_html(integer_format($points_left))));
        }

        if (get_forum_type() == 'cns') {
            $currently_pinned = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_topics', 't_pinned', array('id' => $topic_id));
            if (is_null($currently_pinned)) {
                warn_exit(do_lang_tempcode('MISSING_RESOURCE', 'topic'));
            }
            if ($currently_pinned == 1) {
                return warn_screen($title, do_lang_tempcode('TOPIC_PINNED_ALREADY'));
            }
        }

        // Actuate
        $GLOBALS['FORUM_DRIVER']->pin_topic($topic_id);
        require_code('points2');
        charge_member(get_member(), $total, do_lang('TOPIC_PINNING'));
        $GLOBALS['SITE_DB']->query_insert('sales', array('date_and_time' => time(), 'memberid' => get_member(), 'purchasetype' => 'TOPIC_PINNING', 'details' => strval($topic_id), 'details2' => strval($days)));

        $url = build_url(array('page' => '_SELF', 'type' => 'browse'), '_SELF');
        return redirect_screen($title, $url, do_lang_tempcode('ORDER_GENERAL_DONE'));
    }
}
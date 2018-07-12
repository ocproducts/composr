<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    sugarcrm
 */

function user_metadata_display_script()
{
    $member_id = get_param_integer('member_id', get_member());
    $secure_key = get_param_string('secure_key');
    $expected_secure_key = generate_secure_user_metadata_display_key($member_id);
    $advanced = (get_param_integer('advanced', 0) == 1);

    if ($expected_secure_key != $secure_key) {
        if ($GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
            warn_exit('secure_key should be ' . $expected_secure_key);
        }

        access_denied('I_ERROR');
    }

    require_code('lookup');
    $metadata = find_user_metadata(false, $member_id, $advanced);

    require_code('templates_map_table');

    $username = $GLOBALS['FORUM_DRIVER']->get_username($member_id);
    $title = get_screen_title('Viewing metadata of ' . $username, false);

    $tpl = new Tempcode();
    $tpl->attach($title);
    $map_table = generate_recursive_map_table($metadata);
    $tpl->attach($map_table);

    $out = globalise($tpl, null, '', true, true);
    $out->evaluate_echo();
}

function generate_recursive_map_table($metadata)
{
    $_key = mixed();
    $_val = mixed();

    $l_title = do_lang('TITLE', null, null, null, get_site_default_lang());
    $l_url = do_lang('URL', null, null, null, get_site_default_lang());

    $fields = array();

    foreach ($metadata as $key => $val) {
        if (is_array($val)) {
            if ((has_string_keys($val)) || (!array_key_exists(0, $val)) || (!is_array($val[0]))) {
                $fields[$key] = generate_recursive_map_table($val);
            } else {
                $_val = new Tempcode();
                foreach ($val as $__key => $__val) {
                    $_val->attach(generate_recursive_map_table($__val));
                }
                $fields[$key] = $_val;
            }
        } else {
            $fields[$key] = $val;
        }
    }

    $_fields = new Tempcode();
    $skip_title = false;
    foreach ($fields as $_key => $_val) {
        if (is_numeric($_key)) {
            $_key = integer_format($_key);
        }

        if (($_key == $l_title) && ($skip_title)) {
            continue;
        }

        if ((!is_object($_val)) && (strpos($_val, '://') !== false) && (looks_like_url($_val))) {
            if (($_key == $l_url) && (!empty($fields[$l_title]))) {
                $caption = $fields[$l_title];
                $skip_title = true;
            } else {
                $caption = $_val;
            }
            $_val = hyperlink($_val, $caption, true, true);
        }

        $_fields->attach(map_table_field($_key, $_val, is_object($_val)));
    }

    return do_template('MAP_TABLE', array(
        'FIELDS' => $_fields,
        'WIDTHS' => array('200'),
    ));
}

function generate_secure_user_metadata_display_url($member_id)
{
    return find_script('user_metadata_display') . '?member_id=' . strval($member_id) . '&secure_key=' . generate_secure_user_metadata_display_key($member_id);
}

function generate_secure_user_metadata_display_key($member_id)
{
    require_code('crypt');
    $site_salt = get_site_salt();
    return md5(strval($member_id) . $site_salt);
}

function has_string_keys($array)
{
    return count(array_filter(array_keys($array), 'is_string')) > 0;
}

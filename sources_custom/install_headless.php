<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    meta_toolkit
 */

function do_install_to($database, $username, $password, $table_prefix, $safe_mode)
{
    rename(get_file_base() . '/_config.php', get_file_base() . '/_config.php.bak');

    $settings = array(
        'default_lang' => fallback_lang(),
        'db_type' => get_db_type(),
        'forum_type' => 'cns',
        'board_path' => get_file_base() . '/forums',
        'domain' => get_domain(),
        'base_url' => get_base_url(),
        'table_prefix' => $table_prefix,
        'admin_password' => '',
        'admin_password_confirm' => '',
        'send_error_emails_ocproducts' => '1',
        'admin_username' => 'admin',
        'cns_admin_password' => '',
        'cns_admin_password_confirm' => '',
        'clear_existing_forums_on_install' => 'yes',
        'db_site' => $database,
        'db_site_host' => get_db_site_host(),
        'db_site_user' => $username,
        'db_site_password' => $password,
        'user_cookie' => 'cms_member_id',
        'pass_cookie' => 'cms_member_hash',
        'cookie_domain' => '',
        'cookie_path' => '/',
        'cookie_days' => '120',
        'db_forums' => $database,
        'db_forums_host' => get_db_site_host(),
        'db_forums_user' => $username,
        'db_forums_password' => $password,
        'cns_table_prefix' => $table_prefix,
        'confirm' => '1',
    );

    $stages = array(
        array(
            array(),
            array(),
        ),

        array(
            array(
                'step' => '2',
            ),
            array(
                'max' => '1000',
                'default_lang' => fallback_lang(),
            ),
        ),

        array(
            array(
                'step' => '3',
            ),
            array(
                'max' => '1000',
                'default_lang' => fallback_lang(),
                'email' => 'E-mail address',
                'interest_level' => '3',
                'advertise_on' => '0',
            ),
        ),

        array(
            array(
                'step' => '4',
            ),
            array(
                'max' => '1000',
                'default_lang' => fallback_lang(),
                'email' => 'E-mail address',
                'interest_level' => '3',
                'advertise_on' => '0',
                'forum' => 'cns',
                'forum_type' => 'cns',
                'board_path' => get_file_base() . '/forums',
                'use_multi_db' => '0',
                'use_msn' => '0',
                'db_type' => get_db_type(),
            ),
        ),

        array(
            array(
                'step' => '5',
            ),
            $settings,
        ),

        array(
            array(
                'step' => '6',
            ),
            $settings,
        ),

        array(
            array(
                'step' => '7',
            ),
            $settings,
        ),

        array(
            array(
                'step' => '8',
            ),
            $settings,
        ),

        array(
            array(
                'step' => '9',
            ),
            $settings,
        ),

        array(
            array(
                'step' => '10',
            ),
            $settings,
        ),
    );

    foreach ($stages as $stage) {
        list($get, $post) = $stage;
        $url = get_base_url() . '/install.php?keep_safe_mode=' . ($safe_mode ? '1' : '0');
        foreach ($get as $key => $val) {
            $url .= '&' . urlencode($key) . '=' . urlencode($val);
        }
        $data = http_download_file($url, null, true, false, 'Composr', $post);

        if ($GLOBALS['HTTP_MESSAGE'] != '200') {
            break; // Don't keep installing if there's an error
        }
    }

    unlink(get_file_base() . '/_config.php');
    rename(get_file_base() . '/_config.php.bak', get_file_base() . '/_config.php');

    return $GLOBALS['HTTP_MESSAGE'] == '200';
}

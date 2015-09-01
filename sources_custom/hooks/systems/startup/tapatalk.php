<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    cns_tapatalk
 */

/**
 * Hook class.
 */
class Hook_startup_tapatalk
{
    function run()
    {
        if ((get_option('tapatalk_promote_from_website') === '1') && (running_script('index'))) {
            ini_set('ocproducts.type_strictness', '0');

            $board_url = get_base_url(); // NOT the URL to the main forum, used by JS smartbanner to find the mobiquo directory
            $app_forum_name = get_site_name();
            $api_key = get_option('tapatalk_api_key');

            $app_location_url = static_evaluate_tempcode(build_url(array('page' => '_SELF'), '_SELF', null, true, false, true));
            $app_location_url = preg_replace('/^(https|http)/isU', 'tapatalk', $app_location_url);

            $app_ads_enable = 0;
            $app_banner_enable = 1;
            $is_mobile_skin = is_mobile() ? 1 : 0;

            process_monikers(get_page_name());

            $page_type = 'other';
            switch (get_page_name()) {
                case 'topicview':
                    $page_type = 'topic';
                    break;
                case 'forumview':
                    switch (get_param('type', 'browse')) {
                        case 'pts':
                            $page_type = 'pm';
                            break;
                        case 'misc':
                            if (get_param_integer('id', db_get_first_id()) == db_get_first_id()) {
                                $page_type = 'home';

                                // Less likely to confuse Tapatalks forum detection code
                                $app_location_url = get_base_url();
                                $app_location_url = preg_replace('/^(https|http)/isU', 'tapatalk', $app_location_url);
                            } else {
                                $page_type = 'forum';
                            }
                            break;
                    }
                    break;
                case 'search':
                    $page_type = 'search';
                    break;
                case 'members':
                    $page_type = 'profile';
                    break;
                case 'users_online':
                    $page_type = 'online';
                    break;
                case 'topics':
                    $page_type = 'post';
                    break;
            }

            $tapatalk_dir_url = get_base_url();

            require(get_file_base() . '/mobiquo/smartbanner/head.inc.php');

            attach_to_screen_header($app_head_include);

            ini_set('ocproducts.type_strictness', '1');
        }
    }
}

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

/*EXTRA FUNCTIONS: var_export*/

define('MBQ_PUSH_BLOCK_TIME', 60); /* push block time(minutes) */

require_once(dirname(__FILE__) . '/TapatalkBasePush.php');
require_once(dirname(dirname(__FILE__)) . '/include/mobiquo_functions.php');
require_once(dirname(dirname(__FILE__)) . '/include/common_functions.php');
require_once(dirname(dirname(__FILE__)) . '/include/permission_functions.php');

initialise_mobiquo();

/**
 * push class
 */
class TapatalkPush extends TapatalkBasePush
{
    public function __construct()
    {
        parent::__construct($this);
    }

    // Slugs (state storage from server)
    // =================================

    public function get_push_slug()
    {
        $tapatalk_push_slug = get_long_value('tapatalk_push_slug');
        if (is_null($tapatalk_push_slug)) {
            $tapatalk_push_slug = '';
        }
        return $tapatalk_push_slug;
    }

    public function set_push_slug($slug)
    {
        set_long_value('tapatalk_push_slug', $slug);
        return true;
    }

    // Tapatalk members (only these members have notifications relayed through)
    // ========================================================================

    public function set_is_tapatalk_member($member_id, $is = true)
    {
        set_value('is_tapatalk_member__' . strval($member_id), $is ? '1' : '0', true);
    }

    public function get_is_tapatalk_member($member_id)
    {
        $is = get_value('is_tapatalk_member__' . strval($member_id), null, true);
        return ($is === null || $is === '1');
    }

    // Push code
    // =========

    public function do_push($post_id)
    {
        $table_prefix = $GLOBALS['FORUM_DB']->get_table_prefix();
        $post_rows = $GLOBALS['FORUM_DB']->query_select(
            'f_posts p JOIN ' . $table_prefix . 'f_topics t ON t.id=p.p_topic_id LEFT JOIN ' . $table_prefix . 'f_forums f ON f.id=t.t_forum_id',
            array('*', 'p.id AS post_id', 't.id AS topic_id', 'f.id AS forum_id'),
            array('p.id' => $post_id),
            '',
            1
        );
        if (!isset($post_rows[0])) {
            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }
        $post_row = $post_rows[0];

        ini_set('ocproducts.type_strictness', '0');

        // Send basic topic/post
        if (is_null($post_row['p_cache_forum_id'])) {
            $this->do_push_conversation($post_row);
        } else {
            $is_new_topic = ($post_row['t_cache_first_post_id'] == $post_row['post_id']);
            $this->do_push_post($post_row, $is_new_topic);
        }

        // Send mentions
        $just_post_row = db_map_restrict($post_row, array('id', 'p_post'));
        get_translated_tempcode('f_posts', $just_post_row, 'p_post', $GLOBALS['FORUM_DB']); // Just so that the mentions are found
        global $MEMBER_MENTIONS_IN_COMCODE;
        if (isset($MEMBER_MENTIONS_IN_COMCODE)) {
            $this->do_push_mention($post_row, array_unique($MEMBER_MENTIONS_IN_COMCODE));
        }

        // Send quotes
        $comcode = get_translated_text($post_row['p_post']);
        $matches = array();
        $num_matches = preg_match_all('#\[quote( param)?="([^"]+)"\]#', $comcode, $matches);
        $quoted_members = array();
        for ($i = 0; $i < $num_matches; $i++) {
            $member_id = $GLOBALS['FORUM_DRIVER']->get_member_from_username($matches[2][$i]);
            if (!is_null($member_id)) {
                $quoted_members[] = $member_id;
            }
        }
        $this->do_push_quote($post_row, array_unique($quoted_members));
    }

    private function do_push_conversation($post_row)
    {
        $member_ids = array();

        $_member_ids = array();
        $_member_ids[] = $post_row['t_pt_to'];
        $_member_ids[] = $post_row['t_pt_from'];
        $access = $GLOBALS['FORUM_DB']->query_select('f_special_pt_access', array('s_member_id'), array('s_topic_id' => $post_row['topic_id']));
        $member_ids = array_merge($member_ids, collapse_1d_complexity('s_member_id', $access));
        $member_ids = array_unique($member_ids);

        $data = $this->build_data('conv', $post_row, $member_ids, true);
        if (!is_null($data)) {
            self::do_push_request($data);
        }
    }

    private function do_push_post($post_row, $is_new_topic)
    {
        require_code('notifications');
        $notification_ob = _get_notification_ob_for_code('cns_topic');

        $start = 0;
        $max = 100;
        do {
            list($followers, $maybe_more) = $notification_ob->list_members_who_have_enabled('cns_topic', strval($post_row['topic_id']), null, $start, $max);

            $type = ($is_new_topic ? 'newtopic' : 'sub');

            $data = $this->build_data($type, $post_row, $followers);
            if (!is_null($data)) {
                self::do_push_request($data);
            }

            $start += $max;

            if (!$maybe_more) {
                break;
            }
        } while (count($followers) > 0);
    }

    private function do_push_mention($post_row, $mentioned_members)
    {
        $type = 'mention';

        $data = $this->build_data($type, $post_row, $mentioned_members);
        if (!is_null($data)) {
            self::do_push_request($data);
        }
    }

    private function do_push_quote($post_row, $quoted_members)
    {
        $type = 'quote';

        $data = $this->build_data($type, $post_row, $quoted_members);
        if (!is_null($data)) {
            self::do_push_request($data);
        }
    }

    private function build_data($type, $post_row, $_member_ids, $is_pt = false)
    {
        $member_ids = array();
        foreach ($_member_ids as $member_id) {
            if (($this->get_is_tapatalk_member($member_id)) && (has_post_access($post_row['post_id'], $member_id, $post_row))) {
                $member_ids[] = $member_id;
            }
        }

        $board_url = get_forum_base_url();

        $api_key = get_option('tapatalk_api_key');

        $content = get_translated_text($post_row['p_post'], $GLOBALS['FORUM_DB']);

        $arr = array(
            'url' => $board_url,

            'key' => $api_key,

            'type' => $type,

            'title' => $post_row['t_cache_first_title'],
            'content' => tapatalk_strip_comcode($content),
            'author' => $post_row['p_poster_name_if_guest'],
            'authorid' => strval($post_row['p_poster']),
            'author_type' => self::check_return_user_type($post_row['p_poster']),
            'dateline' => $post_row['p_time'],

            'author_ip' => self::getClientIp(),
            'author_ua' => self::getClientUserAgent(),
            'from_app' => self::getIsFromApp(),

            'userid' => implode(',', array_map('strval', $member_ids)),

            'push' => 1,
        );

        if ($is_pt) {
            $arr += array(
                'id' => strval($post_row['topic_id']),
                'mid' => strval($post_row['post_id']),
            );
        } else {
            $arr += array(
                'id' => strval($post_row['topic_id']),
                'subid' => strval($post_row['post_id']),
                'subfid' => strval($post_row['forum_id']),
                'sub_forum_name' => $post_row['f_name'],
            );
        }

        if (count($member_ids) == 0) {
            return null;
        }

        if (empty($api_key)) {
            return null;
        }

        if (is_file(TAPATALK_LOG)) {
            // Request
            $log_file = fopen(TAPATALK_LOG, 'at');
            fwrite($log_file, TAPATALK_REQUEST_ID . ' -- ' . date('Y-m-d H:i:s') . " *PUSH*:\n");
            fwrite($log_file, var_export($arr, true));
            fwrite($log_file, "\n\n");
            fclose($log_file);
        }

        return $arr;
    }

    private function check_return_user_type($member)
    {
        if ($GLOBALS['FORUM_DRIVER']->is_banned($member)) {
            $user_type = 'banned';
        } elseif ($GLOBALS['FORUM_DRIVER']->is_super_admin($member)) {
            $user_type = 'admin';
        } elseif ($GLOBALS['FORUM_DRIVER']->is_staff($member)) {
            $user_type = 'mod';
        }
        //else if($GLOBALS['FORUM_DRIVER']->get_member_row_field($member,'m_validated')==0)
        //{
        //    $user_type = 'unapproved';
        //}
        //else if($GLOBALS['FORUM_DRIVER']->get_member_row_field($member,'m_validated_email_confirm_code')!='')
        //{
        //    $user_type = 'inactive';
        //}
        else {
            $user_type = 'normal';
        }
        return $user_type;
    }
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

require_code('cns_groups');
require_code('cns_members');
require_lang('cns');

$stars = array();

if (multi_lang_content()) {
    $sql = 'SELECT gift_to,SUM(amount) as cnt FROM ' . get_table_prefix() . 'gifts g WHERE ' . $GLOBALS['SITE_DB']->translate_field_ref('reason') . ' LIKE \'' . db_encode_like($map['param'] . ': %') . '\' AND gift_from<>' . strval($GLOBALS['FORUM_DRIVER']->get_guest_id()) . ' GROUP BY gift_to ORDER BY cnt DESC';
} else {
    $sql = 'SELECT gift_to,SUM(amount) as cnt FROM ' . get_table_prefix() . 'gifts g WHERE reason LIKE \'' . db_encode_like($map['param'] . ': %') . '\' AND gift_from<>' . strval($GLOBALS['FORUM_DRIVER']->get_guest_id()) . ' GROUP BY gift_to ORDER BY cnt DESC';
}
$gifts = $GLOBALS['SITE_DB']->query($sql, 10);
$count = 0;
foreach ($gifts as $gift) {
    $member_id = $gift['gift_to'];
    $username = $GLOBALS['FORUM_DRIVER']->get_username($member_id, true);
    if (!is_null($username)) {
        $url = $GLOBALS['FORUM_DRIVER']->member_profile_url($member_id);
        $avatar_url = $GLOBALS['FORUM_DRIVER']->get_member_avatar_url($member_id);
        $signature = get_translated_tempcode('gifts', $GLOBALS['FORUM_DRIVER']->get_member_row($member_id), 'm_signature', $GLOBALS['FORUM_DB']);
        $points = $gift['cnt'];
        $rank = get_translated_text(cns_get_group_property(cns_get_member_primary_group($member_id), 'name'), $GLOBALS['FORUM_DB']);

        $stars[] = array(
            'MEMBER_ID' => strval($member_id),
            'USERNAME' => $username,
            'URL' => $url,
            'AVATAR_URL' => $avatar_url,
            'POINTS' => integer_format($points),
            'RANK' => $rank,
            'SIGNATURE' => $signature,
        );

        $count++;
    }
}

return do_template('BLOCK_MAIN_STARS', array('STARS' => $stars));

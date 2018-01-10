<?php /*

 Composr
 Copyright (c) ocProducts/Tapatalk, 2004-2018

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
class Hook_comcode_preparse_tapatalk
{
    public function preparse(&$comcode)
    {
        if (!defined('IN_MOBIQUO')) {
            $protocol = tacit_https() ? 'https:' : 'http:';
            $comcode = preg_replace('/\[emoji(\d+)\]/i', '[img]' . $protocol . '//emoji.tapatalk-cdn.com/emoji$1.png[/img]', $comcode);
        }
    }
}

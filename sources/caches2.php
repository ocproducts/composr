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
 * @package    core
 */

/**
 * Remove an item from the general cache (most commonly used for blocks).
 *
 * @param  mixed $cached_for The type of what we are caching (e.g. block name) (ID_TEXT or an array of ID_TEXT, the array may be pairs re-specifying $identifier)
 * @param  ?array $identifier A map of identifying characteristics (null: no identifying characteristics, decache all)
 * @param  ?MEMBER $member_id Member to only decache for (null: no limit)
 * @ignore
 */
function _delete_cache_entry($cached_for, $identifier = null, $member_id = null)
{
    if (!is_array($cached_for)) {
        $cached_for = array($cached_for);
    }

    $cached_for_sz = serialize(array($cached_for, $identifier, $member_id));

    static $done_already = array();
    if ($identifier === null) {
        if (array_key_exists($cached_for_sz, $done_already)) {
            return;
        }
    }

    $where = '';

    $bot_statuses = array(true, false);
    $timezones = array_keys(get_timezone_list());

    foreach ($cached_for as $_cached_for) {
        if (is_array($_cached_for)) {
            $_identifier = $_cached_for[1];
            $_cached_for = $_cached_for[0];
        } else {
            $_identifier = $identifier;
        }

        // NB: If we use persistent cache we still need to decache from DB, in case we're switching between for whatever reason. Or maybe some users use persistent cache and others don't. Or maybe some nodes do and others don't.

        if ($GLOBALS['PERSISTENT_CACHE'] !== null) {
            persistent_cache_delete($_cached_for, true);
        }

        if ($where != '') {
            $where .= ' OR ';
        }

        $where .= db_string_equal_to('cached_for', $_cached_for);
        if ($_identifier !== null) {
            $where .= ' AND ' . db_string_equal_to('identifier', md5(serialize($_identifier)));
        }
        if ($member_id !== null) {
            $where .= ' AND the_member=' . strval($member_id);
        }
    }

    $sql = 'DELETE FROM ' . get_table_prefix() . 'cache WHERE ' . $where;

    $GLOBALS['SITE_DB']->query($sql, null, 0, false, true);

    $hooks = find_all_hook_obs('systems', 'decache', 'Hook_decache_');
    foreach ($hooks as $ob) {
        $ob->decache($cached_for, $identifier);
    }

    if ($identifier === null) {
        $done_already[$cached_for_sz] = true;
    }
}

/**
 * Request that the system scheduler loads up a block's caching in the background.
 *
 * @param  ID_TEXT $codename The codename of the block
 * @param  array $map Parameters to call up block with if we have to defer caching
 * @param  integer $special_cache_flags Flags representing how we should cache
 * @param  boolean $tempcode Whether we are caching Tempcode (needs special care)
 */
function request_via_cron($codename, $map, $special_cache_flags, $tempcode)
{
    $staff_status = null;
    $member_id = null;
    $groups = null;
    $is_bot = null;
    $timezone = null;
    $is_ssl = null;
    $theme = null;
    $lang = null;
    get_cache_signature_details($special_cache_flags, $staff_status, $member_id, $groups, $is_bot, $timezone, $is_ssl, $theme, $lang);

    global $TEMPCODE_SETGET;
    $map = array(
        'c_codename' => $codename,
        'c_map' => serialize($map),
        'c_store_as_tempcode' => $tempcode ? 1 : 0,
        'c_staff_status' => $staff_status,
        'c_member' => $member_id,
        'c_groups' => $groups,
        'c_is_bot' => $is_bot,
        'c_timezone' => $timezone,
        'c_is_ssl' => $is_ssl,
        'c_theme' => $theme,
        'c_lang' => $lang,
    );
    if ($GLOBALS['SITE_DB']->query_select_value_if_there('cron_caching_requests', 'id', $map) === null) {
        $GLOBALS['SITE_DB']->query_insert('cron_caching_requests', $map);
    }
}

/**
 * Put a result into the cache.
 *
 * @param  MINIID_TEXT $codename The codename to check for caching
 * @param  integer $ttl The TTL of what is being cached in minutes
 * @param  LONG_TEXT $cache_identifier The requisite situational information (a serialized map) [-> further restraints when reading]
 * @param  mixed $cache The result we are caching
 * @param  integer $special_cache_flags Special cache flags
 * @param  array $_langs_required A list of the language files that need loading to use Tempcode embedded in the cache
 * @param  array $_javascripts_required A list of the javascript files that need loading to use Tempcode embedded in the cache
 * @param  array $_csss_required A list of the css files that need loading to use Tempcode embedded in the cache
 * @param  boolean $tempcode Whether we are caching Tempcode (needs special care)
 * @param  ?BINARY $staff_status Staff status to limit to (null: Get from environment)
 * @param  ?MEMBER $member_id Member to limit to (null: Get from environment)
 * @param  ?SHORT_TEXT $groups Sorted permissive usergroup list to limit to (null: Get from environment)
 * @param  ?BINARY $is_bot Bot status to limit to (null: Get from environment)
 * @param  ?MINIID_TEXT $timezone Timezone to limit to (null: Get from environment)
 * @param  ?BINARY $is_ssl SSL status to limit to (null: Get from environment)
 * @param  ?ID_TEXT $theme The theme this is being cached for (null: Get from environment)
 * @param  ?LANGUAGE_NAME $lang The language this is being cached for (null: Get from environment)
 */
function set_cache_entry($codename, $ttl, $cache_identifier, $cache, $special_cache_flags = CACHE_AGAINST_DEFAULT, $_langs_required = array(), $_javascripts_required = array(), $_csss_required = array(), $tempcode = false, $staff_status = null, $member_id = null, $groups = null, $is_bot = null, $timezone = null, $is_ssl = null, $theme = null, $lang = null)
{
    get_cache_signature_details($special_cache_flags, $staff_status, $member_id, $groups, $is_bot, $timezone, $is_ssl, $theme, $lang);

    global $KEEP_MARKERS, $SHOW_EDIT_LINKS, $INJECT_HIDDEN_TEMPLATE_NAMES;
    if ($KEEP_MARKERS || $SHOW_EDIT_LINKS || $INJECT_HIDDEN_TEMPLATE_NAMES) {
        return;
    }

    $dependencies = implode(':', $_langs_required);
    $dependencies .= '!';
    $dependencies .= implode(':', $_javascripts_required);
    $dependencies .= '!';
    $dependencies .= implode(':', $_csss_required);

    $big_mainstream_cache = false;//($codename != 'menu') && ($ttl > 60 * 5) && (get_users_timezone(get_member()) == get_site_timezone());
    if ($big_mainstream_cache) {
        cms_profile_start_for('set_cache_entry');
    }

    if ($GLOBALS['PERSISTENT_CACHE'] !== null) {
        $pcache = array('dependencies' => $dependencies, 'date_and_time' => time(), 'the_value' => $cache);
        persistent_cache_set(array('CACHE', $codename, md5($cache_identifier), $lang, $theme, $staff_status, $member_id, $groups, $is_bot, $timezone, $is_ssl), $pcache, false, $ttl * 60);
    } else {
        $GLOBALS['SITE_DB']->query_delete('cache', array(
            'lang' => $lang,
            'the_theme' => $theme,
            'cached_for' => $codename,
            'identifier' => md5($cache_identifier),
        ), '', 1);
        $GLOBALS['SITE_DB']->query_insert('cache', array(
            'cached_for' => $codename,
            'dependencies' => $dependencies,
            'lang' => $lang,
            'identifier' => md5($cache_identifier),
            'the_theme' => $theme,
            'staff_status' => $staff_status,
            'the_member' => $member_id,
            'groups' => $groups,
            'is_bot' => $is_bot,
            'timezone' => $timezone,
            'is_ssl' => $is_ssl,
            'the_value' => $tempcode ? $cache->to_assembly($lang) : serialize($cache),
            'date_and_time' => time(),
        ), false, true);
    }

    if ($big_mainstream_cache) {
        cms_profile_end_for('set_cache_entry', $codename . ' - ' . $cache_identifier);
    }
}

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
 * @package    core
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__caches()
{
    global $BLOCK_CACHE_ON_CACHE;
    $BLOCK_CACHE_ON_CACHE = null;

    global $ALLOW_DOUBLE_DECACHE;
    $ALLOW_DOUBLE_DECACHE = false;

    if (!defined('CACHE_AGAINST_NOTHING_SPECIAL')) {
        // These are ways we might enhance block caching with standardised (queryable) additional caching restraints
        define('CACHE_AGAINST_NOTHING_SPECIAL', 0);
        // -
        define('CACHE_AGAINST_STAFF_STATUS', 1);
        define('CACHE_AGAINST_MEMBER', 2);
        define('CACHE_AGAINST_PERMISSIVE_GROUPS', 4);
        define('CACHE_AGAINST_BOT_STATUS', 8);
        define('CACHE_AGAINST_TIMEZONE', 16);
        // -
        define('CACHE_AGAINST_DEFAULT', CACHE_AGAINST_BOT_STATUS | CACHE_AGAINST_TIMEZONE);
    }

    global $PERSISTENT_CACHE, $SITE_INFO;
    /** The persistent cache access object (null if there is no persistent cache).
     *
     * @global ?object $PERSISTENT_CACHE
     */
    $PERSISTENT_CACHE = null;

    $use_persistent_cache = (!empty($SITE_INFO['use_persistent_cache'])); // Default to off because badly configured caches can result in lots of very slow misses
    if (($use_persistent_cache) && (!$GLOBALS['IN_MINIKERNEL_VERSION'])) {
        if ((class_exists('Memcached')) && (($SITE_INFO['use_persistent_cache'] == 'memcached') || ($SITE_INFO['use_persistent_cache'] == '1'))) {
            require_code('persistent_caching/memcached');
            $PERSISTENT_CACHE = new Persistent_caching_memcached();
        } elseif ((class_exists('Memcache')) && (($SITE_INFO['use_persistent_cache'] == 'memcache') || ($SITE_INFO['use_persistent_cache'] == '1'))) {
            require_code('persistent_caching/memcache');
            $PERSISTENT_CACHE = new Persistent_caching_memcache();
        } elseif ((function_exists('apc_fetch')) && (($SITE_INFO['use_persistent_cache'] == 'apc') || ($SITE_INFO['use_persistent_cache'] == '1'))) {
            require_code('persistent_caching/apc');
            $PERSISTENT_CACHE = new Persistent_caching_apccache();
        } elseif ((function_exists('eaccelerator_put')) && (($SITE_INFO['use_persistent_cache'] == 'eaccelerator') || ($SITE_INFO['use_persistent_cache'] == '1'))) {
            require_code('persistent_caching/eaccelerator');
            $PERSISTENT_CACHE = new Persistent_caching_eacceleratorcache();
        } elseif ((function_exists('xcache_get')) && (($SITE_INFO['use_persistent_cache'] == 'xcache') || ($SITE_INFO['use_persistent_cache'] == '1'))) {
            require_code('persistent_caching/xcache');
            $PERSISTENT_CACHE = new Persistent_caching_xcache();
        } elseif ((function_exists('wincache_ucache_get')) && (($SITE_INFO['use_persistent_cache'] == 'wincache') || ($SITE_INFO['use_persistent_cache'] == '1'))) {
            require_code('persistent_caching/wincache');
            $PERSISTENT_CACHE = new Persistent_caching_wincache();
        } elseif ((file_exists(get_custom_file_base() . '/caches/persistent/')) && (($SITE_INFO['use_persistent_cache'] == 'filesystem') || ($SITE_INFO['use_persistent_cache'] == '1'))) {
            require_code('persistent_caching/filesystem');
            $PERSISTENT_CACHE = new Persistent_caching_filecache();
        }
        // NB: sources/hooks/systems/checks/persistent_cache.php also references some of this ^
    }

    /** The smart cache (self-learning cache).
     *
     * @global boolean $SMART_CACHE
     */
    global $SMART_CACHE, $RELATIVE_PATH, $IN_SELF_ROUTING_SCRIPT;
    if ($IN_SELF_ROUTING_SCRIPT) {
        $zone = $RELATIVE_PATH;
        $page = get_param_string('page', ''); // Not get_page_name for bootstrap order reasons
        $screen = get_param_string('type', 'browse');
        $bucket_name = $zone . ':' . $page . ':' . $screen;
        if ($page != 'topicview' && $screen == 'browse') {
            $bucket_name .= ':' . get_param_string('id', '');
        }
    } else {
        $bucket_name = 'script__' . current_script();
    }
    $SMART_CACHE = new Self_learning_cache($bucket_name);

    // Some loading from the smart cache
    global $CSS_OUTPUT_STARTED_LIST, $JS_OUTPUT_STARTED_LIST;
    $CSS_OUTPUT_STARTED_LIST = array();
    $JS_OUTPUT_STARTED_LIST = array();
    global $JAVASCRIPTS, $JS_OUTPUT_STARTED_LIST, $CSSS, $CSS_OUTPUT_STARTED_LIST;
    $test = $SMART_CACHE->get('JAVASCRIPTS');
    if ($test !== null) {
        $JAVASCRIPTS += $test;
        $JS_OUTPUT_STARTED_LIST += $test;
    }
    $test = $SMART_CACHE->get('CSSS');
    if ($test !== null) {
        $CSSS += $test;
        $CSS_OUTPUT_STARTED_LIST += $test;
    }
}

/**
 * The self-learning cache is an adaptive per-page/script cache, which loads from disk in a single efficient operation.
 * If something will not 'get' then the expectation is that a more costly "full load" or "upfront work" operation will be performed, but
 * a 'set' will also happen so on next script load this won't be needed (at least, eventually, after things settle down across different access patterns).
 *
 * The cache size is minimised, only required resources by the particular per-page/script are put there.
 * Typically cache entries will be very small and voluminous, but predictable,
 * hence why we don't just use individual fetches on a conventional cache layer.
 * It is a disk vs CPU tradeoff. The intent is to approach performance as if each page/script were hand-coded to know its exact dependencies.
 *
 * Some usage notes:
 * Cached items should not be too volatile, although the cache is clever enough to not re-save if no real changes actually resulted from set/append operations;
 *  in other words the cache should quickly stabilise and not keep having to do writes
 * You should not use this as an alternative to the persistent cache for caching everything that the persistent cache can already do;
 *  although sometimes it is good to do special batching operations (e.g. avoid repeating query patterns) that would already be separately optimised when the persistent cache was on
 * We cannot always put cache stuff direct into smart cache as it may vary per-usergroup for example;
 *  anything in the cache really should be useful for all page loads, we do not want to have to load a great bloated smart cache on each page load;
 *  the above said, we will often *say* what is needed, then feed this in for doing bulk loads from the dedicated caches (e.g. saying which blocks to bulk load)
 *
 * @package    core
 */
class Self_learning_cache
{
    private $bucket_name = null;
    private $path = null;
    private $data = null; // null means "Nothing loaded"
    private $keys_inital = array();
    private $pending_save = false;
    public $paused = false;
    public $empty = true;
    private $already_invalidated = false;

    /**
     * Constructor. Initialise our cache.
     *
     * @param  ID_TEXT $bucket_name The identifier this cache object is for
     */
    public function __construct($bucket_name)
    {
        $this->bucket_name = $bucket_name;
        $dir = get_custom_file_base() . '/caches/self_learning';
        if (!is_dir($dir)) {
            require_code('files2');
            make_missing_directory($dir);
        }
        //$this->path = $dir . '/' . filter_naughty(str_replace(array('/', '\\', ':'), array('__', '__', '__'), $bucket_name)) . '.gcd'; Windows has a 260 character path limit, so we can't do it this way
        $this->path = $dir . '/' . filter_naughty(md5($bucket_name)) . '.gcd';
        $this->load();
    }

    /**
     * Find whether the smart cache is on.
     *
     * @return boolean Whether it is
     */
    public static function is_on()
    {
        static $is_on = null;
        if ($is_on === null) {
            $is_on = mixed(); // For CQC
        }
        if ($is_on !== null) {
            return $is_on;
        }
        global $SITE_INFO;
        $is_on = (isset($SITE_INFO['self_learning_cache']) && $SITE_INFO['self_learning_cache'] == '1');
        return $is_on;
    }

    /**
     * Load the cache for the particular bucket this cache object is for.
     */
    private function load()
    {
        if (!$this->is_on()) {
            return;
        }

        $data = persistent_cache_get(array('SELF_LEARNING_CACHE', $this->bucket_name));
        if ($data !== null) {
            $this->data = $data;
        } elseif (is_file($this->path)) {
            $_data = cms_file_get_contents_safe($this->path);
            if ($_data !== false) {
                $this->data = @unserialize($_data);
                if ($this->data === false) {
                    $this->invalidate(); // Corrupt
                }
            } else {
                $this->data = null;
            }
        }

        $this->empty = empty($this->data);

        if ($this->data !== null) {
            $this->keys_initial = array_flip(array_keys($this->data));
        }
    }

    /**
     * Get a cache key.
     *
     * @param  ID_TEXT $key Cache key
     * @return ?mixed The value (null: not in cache - needs to be learnt)
     */
    public function get($key)
    {
        if (isset($this->data[$key])) {
            return $this->data[$key];
        }
        return null; // Not set. We cannot take a default value to return, as we need to signal that this was missing in order to allow the cache to be adapted
    }

    /**
     * See if a cache key was initially set.
     *
     * @param  ID_TEXT $key Cache key
     * @return boolean Whether it was
     */
    public function get_initial_status($key)
    {
        return isset($this->keys_initial[$key]);
    }

    /**
     * Set a cache key.
     *
     * @param  ID_TEXT $key Cache key
     * @param  mixed $value Value. Should not be null, as that is reserved for "not in cache"
     */
    public function set($key, $value)
    {
        if ($this->paused) {
            return;
        }

        if (!isset($this->data[$key]) || $this->data[$key] !== $value) {
            $this->data[$key] = $value;

            $this->save(false);
        }
    }

    /**
     * Add something to a list entry in the cache. Uses keys to set the value, then assigns $value_2 to the key.
     * This is efficient for duplication prevention.
     *
     * @param  ID_TEXT $key Cache key
     * @param  mixed $value Value to append (must not be an object or array, so you may need to pre-serialize)
     * @param  mixed $value_2 Secondary value to attach to appended value (optional)
     * @return boolean Whether the value was appended (false if it was already there)
     */
    public function append($key, $value, $value_2 = true)
    {
        if (!isset($this->data[$key])) {
            $this->data[$key] = array();
        }

        if ((!isset($this->data[$key][$value])) && !array_key_exists($value, $this->data[$key]) || $this->data[$key][$value] !== $value_2) {
            if ($this->paused) {
                return true;
            }

            $this->data[$key][$value] = $value_2;

            $this->save(false);

            return true;
        }

        return false;
    }

    /**
     * Save the cache, after some change has happened.
     *
     * @param  boolean $do_immediately Immediately save the cache change (slow...)
     */
    private function save($do_immediately = false)
    {
        if (!$this->is_on()) {
            return;
        }

        if (!$do_immediately) {
            if (!$this->pending_save) {
                // Mark to save later
                register_shutdown_function(array($this, '_page_cache_resave'));
            }
            $this->pending_save = true;
            return;
        }

        $this->_page_cache_resave();
    }

    /**
     * Actually save the cache.
     * Has to be public for register_shutdown_function.
     *
     * @ignore
     */
    public function _page_cache_resave()
    {
        if ($GLOBALS['PERSISTENT_CACHE'] !== null) {
            persistent_cache_set(array('SELF_LEARNING_CACHE', $this->bucket_name), $this->data);
            return;
        }

        if (!is_null($this->path)) {
            $contents = serialize($this->data);

            require_code('files');
            cms_file_put_contents_safe($this->path, $contents, FILE_WRITE_FIX_PERMISSIONS);
        } else {
            fatal_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }
    }

    /**
     * Invalidate the cache, so that it will rebuild.
     */
    public function invalidate()
    {
        if (!$this->is_on()) {
            return;
        }

        if ($this->already_invalidated) {
            return;
        }
        $this->already_invalidated = true;

        if (!is_null($this->path)) {
            @unlink($this->path);
        } else {
            fatal_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }

        $this->data = null;
    }

    /**
     * Called by various other erase_* functions that know the smart cache may be involved.
     */
    public static function erase_smart_cache()
    {
        if (!Self_learning_cache::is_on()) {
            return;
        }

        static $done_once = false;
        global $ALLOW_DOUBLE_DECACHE;
        if (!$ALLOW_DOUBLE_DECACHE) {
            if ($done_once) {
                return;
            }
        }
        $done_once = true;

        $dh = @opendir(get_custom_file_base() . '/caches/self_learning');
        if ($dh !== false) {
            while (($f = readdir($dh)) !== false) {
                if (substr($f, -4) == '.gcd') {
                    @unlink(get_custom_file_base() . '/caches/self_learning/' . $f);
                }
            }
            closedir($dh);
        }

        erase_persistent_cache();

        global $SMART_CACHE;
        if ($SMART_CACHE !== null) {
            $SMART_CACHE->invalidate();
        }
    }
}

/**
 * Get data from the persistent cache.
 *
 * @param  mixed $key Key
 * @param  ?TIME $min_cache_date Minimum timestamp that entries from the cache may hold (null: don't care)
 * @return ?mixed The data (null: not found / null entry)
 */
function persistent_cache_get($key, $min_cache_date = null)
{
    global $PERSISTENT_CACHE;
    //if (($GLOBALS['DEV_MODE']) && (mt_rand(0, 3) == 1)) return null;  Annoying when doing performance tests, but you can enable to test persistent cache more
    if ($PERSISTENT_CACHE === null) {
        return null;
    }

    $test = $PERSISTENT_CACHE->get(get_file_base() . serialize($key), $min_cache_date); // First we'll try specifically for site
    if ($test !== null) {
        return $test;
    }
    /*if (!is_a($PERSISTENT_CACHE, 'Persistent_caching_filecache')) {  Server-wide bad idea
        $test = $PERSISTENT_CACHE->get(('cms' . float_to_raw_string(cms_version_number())) . serialize($key), $min_cache_date); // And last we'll try server-wide
    }*/
    return $test;
}

/**
 * Put data into the persistent cache.
 *
 * @param  mixed $key Key
 * @param  mixed $data The data
 * @param  boolean $server_wide Whether it is server-wide data
 * @param  ?integer $expire_secs The expiration time in seconds. (null: Default expiry in 60 minutes, or never if it is server-wide).
 */
function persistent_cache_set($key, $data, $server_wide = false, $expire_secs = null)
{
    global $PERSISTENT_CACHE;
    if ($PERSISTENT_CACHE === null) {
        return null;
    }
    if ($expire_secs === null) {
        $expire_secs = $server_wide ? 0 : (60 * 60);
    }

    /*if (is_a($PERSISTENT_CACHE, 'Persistent_caching_filecache')) {   Server-wide bad idea
        $server_wide = false;
    }*/
    $server_wide = false;

    $PERSISTENT_CACHE->set(($server_wide ? ('cms' . float_to_raw_string(cms_version_number())) : get_file_base()) . serialize($key), $data, 0, $expire_secs);
}

/**
 * Delete data from the persistent cache.
 *
 * @param  mixed $key Key name
 * @param  boolean $substring Whether we are deleting via substring
 */
function persistent_cache_delete($key, $substring = false)
{
    global $PERSISTENT_CACHE;
    if ($PERSISTENT_CACHE === null) {
        return null;
    }
    if ($substring) {
        $list = $PERSISTENT_CACHE->load_objects_list();
        foreach (array_keys($list) as $l) {
            $delete = true;
            foreach (is_array($key) ? $key : array($key) as $key_part) {
                if (strpos($l, $key_part) === false) { // Should work even though key was serialized, in reasonable cases
                    $delete = false;
                    break;
                }
            }
            if ($delete) {
                $PERSISTENT_CACHE->delete($l);
            }
        }
    } else {
        $PERSISTENT_CACHE->delete(get_file_base() . serialize($key));
        /*if (!is_a($PERSISTENT_CACHE, 'Persistent_caching_filecache')) {  Server-wide bad idea
            $PERSISTENT_CACHE->delete('cms' . float_to_raw_string(cms_version_number()) . serialize($key));
        }*/
    }
}

/**
 * Remove all data from the persistent cache and static cache.
 */
function erase_persistent_cache()
{
    static $done_once = false;
    global $ALLOW_DOUBLE_DECACHE;
    if (!$ALLOW_DOUBLE_DECACHE) {
        if ($done_once) {
            return;
        }
    }
    $done_once = true;

    $path = get_custom_file_base() . '/safe_mode_temp';
    if (is_dir($path)) {
        $d = opendir($path);
        while (($e = readdir($d)) !== false) {
            if (substr($e, -4) == '.dat') {
                @unlink(get_custom_file_base() . '/safe_mode_temp/' . $e);
            }
        }
        closedir($d);
    }

    $path = get_custom_file_base() . '/caches/persistent';
    if (is_dir($path)) {
        $d = opendir($path);
        while (($e = readdir($d)) !== false) {
            if (substr($e, -4) == '.gcd') {
                // Ideally we'd lock while we delete, but it's not stable (and the workaround would be too slow for our efficiency context). So some people reading may get errors while we're clearing the cache. Fortunately this is a rare op to perform.
                @unlink(get_custom_file_base() . '/caches/persistent/' . $e);
            }
        }
        closedir($d);
    }

    $path = get_custom_file_base() . '/caches/guest_pages';
    if (!file_exists($path)) {
        return;
    }
    $d = opendir($path);
    while (($e = readdir($d)) !== false) {
        if ((substr($e, -4) == '.htm' || substr($e, -4) == '.xml') && (strpos($e, '__failover_mode') === false)) {
            // Ideally we'd lock while we delete, but it's not stable (and the workaround would be too slow for our efficiency context). So some people reading may get errors while we're clearing the cache. Fortunately this is a rare op to perform.
            @unlink(get_custom_file_base() . '/caches/guest_pages/' . $e);
        }
    }
    closedir($d);

    require_code('files');
    cms_file_put_contents_safe(get_custom_file_base() . '/data_custom/failover_rewritemap.txt', '', FILE_WRITE_FAILURE_SILENT | FILE_WRITE_FIX_PERMISSIONS);
    cms_file_put_contents_safe(get_custom_file_base() . '/data_custom/failover_rewritemap__mobile.txt', '', FILE_WRITE_FAILURE_SILENT | FILE_WRITE_FIX_PERMISSIONS);

    global $PERSISTENT_CACHE;
    if ($PERSISTENT_CACHE === null) {
        return null;
    }
    $PERSISTENT_CACHE->flush();
}

/**
 * Check to see if caching is enabled.
 *
 * @param  string $type Cache type
 * @set block lang comcode_page template
 * @return boolean Whether it has the caching
 */
function has_caching_for($type)
{
    if (!function_exists('get_option')) {
        return false;
    }

    $setting = (get_option('is_on_' . $type . '_cache') == '1');

    $positive = (get_param_integer('keep_cache', 0) == 1) || (get_param_integer('cache', 0) == 1) || (get_param_integer('keep_cache_' . $type . 's', 0) == 1) || (get_param_integer('cache_' . $type . 's', 0) == 1);

    $not_negative = (get_param_integer('keep_cache', null) !== 0) && (get_param_integer('cache', null) !== 0) && (get_param_integer('keep_cache_' . $type . 's', null) !== 0) && (get_param_integer('cache_' . $type . 's', null) !== 0);

    return ($setting || $positive) && (strpos(get_param_string('special_page_type', ''), 't') === false) && $not_negative;
}

/**
 * Remove an item from the general cache (most commonly used for blocks).
 *
 * @param  mixed $cached_for The type of what we are caching (e.g. block name) (ID_TEXT or an array of ID_TEXT, the array may be pairs re-specifying $identifier)
 * @param  ?array $identifier A map of identifiying characteristics (null: no identifying characteristics, decache all)
 * @param  ?MEMBER $member_id Member to only decache for (null: no limit)
 */
function decache($cached_for, $identifier = null, $member_id = null)
{
    if (get_mass_import_mode()) {
        return;
    }

    require_code('caches2');
    _decache($cached_for, $identifier, $member_id);
}

/**
 * Find the cache-on parameters for 'codename's caching style (prevents us needing to load up extra code to find it).
 *
 * @param  ID_TEXT $codename The codename of what will be checked for caching
 * @return ?array The cached result (null: no cached result)
 */
function find_cache_on($codename)
{
    // See if we have it cached
    global $BLOCK_CACHE_ON_CACHE;
    if ($BLOCK_CACHE_ON_CACHE === null) {
        $BLOCK_CACHE_ON_CACHE = persistent_cache_get('BLOCK_CACHE_ON_CACHE');
        if ($BLOCK_CACHE_ON_CACHE === null) {
            $BLOCK_CACHE_ON_CACHE = list_to_map('cached_for', $GLOBALS['SITE_DB']->query_select('cache_on', array('*')));
            persistent_cache_set('BLOCK_CACHE_ON_CACHE', $BLOCK_CACHE_ON_CACHE);
        }
    }
    if (isset($BLOCK_CACHE_ON_CACHE[$codename])) {
        return $BLOCK_CACHE_ON_CACHE[$codename];
    }
    return null;
}

/**
 * Find the cached result of what is named by codename and the further constraints.
 *
 * @param  ID_TEXT $codename The codename to check for caching
 * @param  LONG_TEXT $cache_identifier The further restraints (a serialized map)
 * @param  integer $special_cache_flags Special cache flags
 * @param  integer $ttl The TTL for the cache entry. Defaults to a very big ttl
 * @param  boolean $tempcode Whether we are caching Tempcode (needs special care)
 * @param  boolean $caching_via_cron Whether to defer caching to CRON. Note that this option only works if the block's defined cache signature depends only on $map (timezone and bot-type are automatically considered)
 * @param  ?array $map Parameters to call up block with if we have to defer caching (null: none)
 * @return ?mixed The cached result (null: no cached result)
 */
function get_cache_entry($codename, $cache_identifier, $special_cache_flags, $ttl = 10000, $tempcode = false, $caching_via_cron = false, $map = null)
{
    $det = array($codename, $cache_identifier, md5($cache_identifier), $special_cache_flags, $ttl, $tempcode, $caching_via_cron, $map);

    global $SMART_CACHE;
    $test = (get_page_name() == 'admin_addons'/*special case*/) ? array() : $SMART_CACHE->get('blocks_needed');
    if (($test === null) || (count($test) < 20)) {
        $SMART_CACHE->append('blocks_needed', serialize($det));
    } else {
        $SMART_CACHE->get('blocks_needed', false); // Disable it for this smart-cache bucket, we probably have some block(s) with the cache signature varying too much
    }

    $rets = _get_cache_entries(array($det), $special_cache_flags);
    return $rets[0];
}

/**
 * Ability to do multiple get_cache_entry at once, for performance reasons.
 *
 * @param  array $dets An array of tuples of parameters (as per get_cache_entry, almost)
 * @param  ?integer $special_cache_flags Special cache flags (null: unknown)
 * @return array Array of results
 *
 * @ignore
 */
function _get_cache_entries($dets, $special_cache_flags = null)
{
    static $cache = array();

    if ($dets == array()) {
        return array();
    }

    $rets = array();

    require_code('temporal');
    $staff_status = (($special_cache_flags !== null) && (($special_cache_flags & CACHE_AGAINST_STAFF_STATUS) !== 0)) ? ($GLOBALS['FORUM_DRIVER']->is_staff(get_member()) ? 1 : 0) : null;
    $member_id = (($special_cache_flags !== null) && (($special_cache_flags & CACHE_AGAINST_MEMBER) !== 0)) ? get_member() : null;
    $groups = (($special_cache_flags !== null) && (($special_cache_flags & CACHE_AGAINST_PERMISSIVE_GROUPS) !== 0)) ? implode(',', array_map('strval', filter_group_permissivity($GLOBALS['FORUM_DRIVER']->get_members_groups(get_member())))) : '';
    $is_bot = (($special_cache_flags !== null) && (($special_cache_flags & CACHE_AGAINST_BOT_STATUS) !== 0)) ? (is_null(get_bot_type()) ? 0 : 1) : null;
    $timezone = (($special_cache_flags !== null) && (($special_cache_flags & CACHE_AGAINST_TIMEZONE) !== 0)) ? get_users_timezone(get_member()) : '';

    // Bulk load
    if ($GLOBALS['PERSISTENT_CACHE'] === null) {
        $do_query = false;

        $sql = 'SELECT cached_for,identifier,the_value,date_and_time,dependencies FROM ' . get_table_prefix() . 'cache WHERE ';
        $sql .= db_string_equal_to('the_theme', $GLOBALS['FORUM_DRIVER']->get_theme());
        if ($staff_status === null) {
            $sql .= ' AND staff_status IS NULL';
        } else {
            $sql .= ' AND staff_status=' . strval($staff_status);
        }
        if ($member_id === null) {
            $sql .= ' AND the_member IS NULL';
        } else {
            $sql .= ' AND the_member=' . strval($member_id);
        }
        if ($groups === null) {
            $sql .= ' AND ' . db_string_equal_to('groups', '');
        } else {
            $sql .= ' AND ' . db_string_equal_to('groups', $groups);
        }
        if ($is_bot === null) {
            $sql .= ' AND is_bot IS NULL';
        } else {
            $sql .= ' AND is_bot=' . strval($is_bot);
        }
        if ($timezone === null) {
            $sql .= ' AND ' . db_string_equal_to('timezone', '');
        } else {
            $sql .= ' AND ' . db_string_equal_to('timezone', $timezone);
        }
        $sql .= ' AND ' . db_string_equal_to('lang', user_lang());
        $sql .= ' AND (1=0';
        foreach ($dets as $det) {
            list($codename, $cache_identifier, $md5_cache_identifier, $special_cache_flags, $ttl, $tempcode, $caching_via_cron, $map) = $det;

            $sz = serialize(array($codename, $md5_cache_identifier));
            if (isset($cache[$sz])) { // Already cached
                $rets[] = $cache[$sz];
                continue;
            }

            $sql .= ' OR ';
            $sql .= db_string_equal_to('cached_for', $codename) . ' AND ' . db_string_equal_to('identifier', $md5_cache_identifier);

            $do_query = true;
        }
        $sql .= ')';
        $cache_rows = $do_query ? $GLOBALS['SITE_DB']->query($sql) : array();
    }

    // Each requested entry
    foreach ($dets as $det) {
        list($codename, $cache_identifier, $md5_cache_identifier, $special_cache_flags, $ttl, $tempcode, $caching_via_cron, $map) = $det;

        $sz = serialize(array($codename, $md5_cache_identifier));
        if (isset($cache[$sz])) { // Already cached
            $rets[] = $cache[$sz];
            continue;
        }

        if ($GLOBALS['PERSISTENT_CACHE'] !== null) {
            $theme = $GLOBALS['FORUM_DRIVER']->get_theme();
            $lang = user_lang();
            $cache_row = persistent_cache_get(array('CACHE', $codename, $md5_cache_identifier, $lang, $theme, $staff_status, $member_id, $groups, $is_bot, $timezone));

            if ($cache_row === null) { // No
                if ($caching_via_cron) {
                    require_code('caches2');
                    request_via_cron($codename, $map, $special_cache_flags, $tempcode);
                    $ret = paragraph(do_lang_tempcode('CACHE_NOT_READY_YET'), '', 'nothing_here');
                } else {
                    $ret = null;
                }

                $cache[$sz] = $ret;
                $rets[] = $ret;
                continue;
            }
        } else {
            $cache_row = mixed();
            foreach ($cache_rows as $_cache_row) {
                if ($_cache_row['cached_for'] == $codename && $_cache_row['identifier'] == $md5_cache_identifier) {
                    $cache_row = $_cache_row;
                    break;
                }
            }

            if ($cache_row === null) { // No
                if ($caching_via_cron) {
                    require_code('caches2');
                    request_via_cron($codename, $map, $special_cache_flags, $tempcode);
                    $ret = paragraph(do_lang_tempcode('CACHE_NOT_READY_YET'), '', 'nothing_here');
                } else {
                    $ret = null;
                }

                $cache[$sz] = $ret;
                $rets[] = $ret;
                continue;
            }

            if ($tempcode) {
                $ob = new Tempcode();
                if (!$ob->from_assembly($cache_row['the_value'], true)) { // Error
                    $ret = null;
                    $cache[$sz] = $ret;
                    $rets[] = $ret;
                    continue;
                }

                $cache_row['the_value'] = $ob;
            } else {
                $cache_row['the_value'] = unserialize($cache_row['the_value']);
            }
        }

        $stale = (($ttl != -1) && (time() > ($cache_row['date_and_time'] + $ttl * 60)));

        if ($stale) { // Stale
            if (!$caching_via_cron) {
                $ret = null;
                $cache[$sz] = $ret;
                $rets[] = $ret;
                continue;
            }

            require_code('caches2');
            request_via_cron($codename, $map, $special_cache_flags, $tempcode);
        }

        // We can use directly...

        $ret = $cache_row['the_value'];
        if ($cache_row['dependencies'] != '') {
            $bits = explode('!', $cache_row['dependencies']);
            $langs_required = explode(':', $bits[0]); // Sometimes lang has got intertwinded with non cacheable stuff (and thus was itself not cached), so we need the lang files
            foreach ($langs_required as $lang) {
                if ($lang != '') {
                    require_lang($lang, null, null, true);
                }
            }
            if (isset($bits[1])) {
                $javascripts_required = explode(':', $bits[1]);
                foreach ($javascripts_required as $javascript) {
                    if (($javascript != '') && (strpos($javascript, 'merged__') === false)) {
                        require_javascript($javascript);
                    }
                }
            }
            if (isset($bits[2])) {
                $csss_required = explode(':', $bits[2]);
                foreach ($csss_required as $css) {
                    if (($css != '') && (strpos($css, 'merged__') === false)) {
                        require_css($css);
                    }
                }
            }
        }

        $cache[$sz] = $ret;
        $rets[] = $ret;
    }
    return $rets;
}

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
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__sitemap_xml()
{
    require_code('xml');

    require_code('sitemap');

    if (!defined('URLS_PER_SITEMAP_SET')) {
        define('URLS_PER_SITEMAP_SET', 250); // Limit is 50,000, but we are allowed up to 50,000 sets, so let's be performant here and have small sets
    }

    global $RUNNING_BUILD_SITEMAP_CACHE_TABLE;
    $RUNNING_BUILD_SITEMAP_CACHE_TABLE = false;
}

/**
 * Top level function to (re)generate a Sitemap (xml file, search-engine-style).
 *
 * @param  ?mixed $callback Callback to run on each iteration (null: none)
 * @param  boolean $force Force reconstruction regardless of update-dates (should not be needed)
 */
function sitemap_xml_build($callback = null, $force = false)
{
    $last_time = intval(get_value('last_sitemap_time_calc_inner', null, true));
    $time = time();

    // Build from sitemap_cache table
    $set_numbers = $GLOBALS['SITE_DB']->query_select('sitemap_cache', array('DISTINCT set_number'), array(), $force ? '' : ' WHERE last_updated>=' . strval($last_time));
    if (count($set_numbers) > 0) {
        foreach ($set_numbers as $set_number) {
            rebuild_sitemap_set($set_number['set_number'], $last_time, $callback);
        }

        // Delete any nodes marked for deletion now they've been reflected in the XML
        $GLOBALS['SITE_DB']->query_delete('sitemap_cache', array(
            'is_deleted' => 1,
        ));

        // Rebuild index file
        rebuild_sitemap_index();

        // Ping search engines
        ping_sitemap_xml(get_custom_base_url() . '/data_custom/sitemaps/index.xml');
    }

    set_value('last_sitemap_time_calc_inner', strval($time), true);
}

/**
 * Write out a Sitemap XML set.
 *
 * @param  integer $set_number Set number
 * @param  TIME $last_time Last sitemap generation time
 * @param  ?mixed $callback Callback to run on each iteration (null: none)
 */
function rebuild_sitemap_set($set_number, $last_time, $callback = null)
{
    // Open
    $sitemaps_out_temppath = cms_tempnam(); // We write to temporary path first to minimise the time our target file is invalid (during generation)
    $sitemaps_out_file = fopen($sitemaps_out_temppath, 'wb');
    $sitemaps_out_path = get_custom_file_base() . '/data_custom/sitemaps/set_' . strval($set_number) . '.xml';
    $blob = '<' . '?xml version="1.0" encoding="' . escape_html(get_charset()) . '"?' . '>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">';
    fwrite($sitemaps_out_file, $blob);

    // Nodes accessible by guests, and not deleted (ignore update time as we are rebuilding whole set)
    $where = array('set_number' => $set_number, 'is_deleted' => 0, 'guest_access' => 1);
    $nodes = $GLOBALS['SITE_DB']->query_select('sitemap_cache', array('*'), $where);
    foreach ($nodes as $node) {
        $page_link = $node['page_link'];
        list($zone, $attributes, $hash) = page_link_decode($page_link);

        if ($callback !== null) {
            call_user_func($callback);
        }

        $add_date = $node['add_date'];
        $edit_date = $node['edit_date'];
        $priority = $node['priority'];

        $url = _build_url($attributes, $zone, array(), false, false, true, $hash);

        $optional_details = '';

        $_lastmod_date = ($edit_date === null) ? $add_date : $edit_date;
        if ($_lastmod_date !== null) {
            $xml_date = xmlentities(date('Y-m-d\TH:i:s', $_lastmod_date) . substr_replace(date('O', $_lastmod_date), ':', 3, 0));
            $optional_details = '
        <lastmod>' . $xml_date . '</lastmod>';
        }

        $langs = find_all_langs();
        foreach (array_keys($langs) as $lang) {
            if ($lang != get_site_default_lang()) {
                $_url = _build_url($attributes + array('keep_lang' => $lang), $zone, array(), false, false, true, $hash);

                $optional_details = '
        <xhtml:link rel="alternate" hreflang="' . strtolower($lang) . '" href="' . xmlentities($_url) . '" />';
            }
        }

        $url_blob = '
    <url>
        <loc>' . xmlentities($url) . '</loc>' . $optional_details . '
        <changefreq>' . xmlentities($node['refreshfreq']) . '</changefreq>
        <priority>' . float_to_raw_string($priority) . '</priority>
    </url>
';
        fwrite($sitemaps_out_file, $url_blob);
    }

    // Close
    $blob = '</urlset>';
    fwrite($sitemaps_out_file, $blob);
    fclose($sitemaps_out_file);
    @unlink($sitemaps_out_path);
    if (!file_exists(dirname($sitemaps_out_path))) {
        require_code('files2');
        make_missing_directory(dirname($sitemaps_out_path));
    }
    rename($sitemaps_out_temppath, $sitemaps_out_path);
    sync_file($sitemaps_out_path);
    fix_permissions($sitemaps_out_path);

    // Gzip
    if (function_exists('gzencode')) {
        require_code('files');
        cms_file_put_contents_safe($sitemaps_out_path . '.gz', gzencode(file_get_contents($sitemaps_out_path), -1), FILE_WRITE_FIX_PERMISSIONS | FILE_WRITE_SYNC_FILE);
    }
}

/**
 * Write out a Sitemap XML index.
 */
function rebuild_sitemap_index()
{
    // Open
    $sitemaps_out_temppath = cms_tempnam(); // We write to temporary path first to minimise the time our target file is invalid (during generation)
    $sitemaps_out_file = fopen($sitemaps_out_temppath, 'wb');
    $sitemaps_out_path = get_custom_file_base() . '/data_custom/sitemaps/index.xml';
    $blob = '<' . '?xml version="1.0" encoding="' . escape_html(get_charset()) . '"?' . '>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';
    fwrite($sitemaps_out_file, $blob);

    // Write out each set
    $sitemap_sets = $GLOBALS['SITE_DB']->query_select('sitemap_cache', array('set_number', 'MAX(last_updated) AS last_updated'), array(), 'GROUP BY set_number');
    foreach ($sitemap_sets as $sitemap_set) {
        $path = get_custom_file_base() . '/data_custom/sitemaps/set_' . strval($sitemap_set['set_number']) . '.xml';
        $url = get_custom_base_url() . '/data_custom/sitemaps/set_' . strval($sitemap_set['set_number']) . '.xml';

        if ((is_file($path)) && (filesize($path) < 120)) {
            // Google gives hard errors on empty sets
            continue;
        }

        if (is_file($path . '.gz')) {
            // Point to .gz if we have been gzipping. We cannot assume we have consistently managed that
            $path .= '.gz';
            $url .= '.gz';
        }

        //$last_updated = $sitemap_set['last_updated']; Actually no, because this cannot find deletes
        $last_updated = filemtime($path);
        $xml_date = xmlentities(date('Y-m-d\TH:i:s', $last_updated) . substr_replace(date('O', $last_updated), ':', 3, 0));

        $set_blob = '
    <sitemap>
        <loc>' . xmlentities($url) . '</loc>
        <lastmod>' . $xml_date . '</lastmod>
    </sitemap>
';
        fwrite($sitemaps_out_file, $set_blob);
    }

    // Close
    $blob = '</sitemapindex>';
    fwrite($sitemaps_out_file, $blob);
    fclose($sitemaps_out_file);
    @unlink($sitemaps_out_path);
    if (!file_exists(dirname($sitemaps_out_path))) {
        @mkdir(dirname($sitemaps_out_path), 0777);
        fix_permissions(dirname($sitemaps_out_path));
    }
    rename($sitemaps_out_temppath, $sitemaps_out_path);
    sync_file($sitemaps_out_path);
    fix_permissions($sitemaps_out_path);
}

/**
 * Ping search engines with an updated sitemap.
 *
 * @param  URLPATH $url Sitemap URL
 * @param  boolean $trigger_error Whether to throw a Composr error, on error
 * @return string HTTP result output
 */
function ping_sitemap_xml($url, $trigger_error = false)
{
    // Ping search engines
    $out = '';
    if (get_option('auto_submit_sitemap') == '1') {
        $ping = true;
        $test_url = str_replace('https://', 'http://', $url);
        $not_local = (substr($test_url, 0, 16) != 'http://localhost') && (substr($test_url, 0, 16) != 'http://127.0.0.1') && (substr($test_url, 0, 15) != 'http://192.168.') && (substr($test_url, 0, 10) != 'http://10.');
        if (($ping) && (get_option('site_closed') == '0') && ($not_local)) {
            // Submit to search engines
            $services = array(
                'http://www.google.com/webmasters/tools/ping?sitemap=',
                'http://www.bing.com/webmaster/ping.aspx?siteMap=',
            );
            foreach ($services as $service) {
                $out .= http_get_contents($service . urlencode($url), array('trigger_error' => $trigger_error));
            }
        }
    }
    return $out;
}

/**
 * Make sure we do not have Sitemap files on disk that are no longer needed.
 */
function clean_unused_sitemap_files()
{
    $pages = array_flip(collapse_1d_complexity('set_number', $GLOBALS['SITE_DB']->query_select('sitemap_cache', array('DISTINCT set_number'))));

    $dh = @opendir(get_custom_file_base() . '/data_custom/sitemaps');
    if ($dh !== false) {
        while (($f = readdir($dh)) !== false) {
            $matches = array();
            if ((preg_match('#^set_(\d+)\.xml(\.gz)?$#', $f, $matches) != 0) && (!array_key_exists(intval($matches[1]), $pages))) {
                @unlink(get_custom_file_base() . '/data_custom/sitemaps/' . $f);
            }
        }
        closedir($dh);
    }
}

/**
 * Our sitemap cache table may need bootstrapping for some reason.
 * Normally we build it iteratively.
 */
function build_sitemap_cache_table()
{
    push_query_limiting(false);

    cms_disable_time_limit();

    $GLOBALS['RUNNING_BUILD_SITEMAP_CACHE_TABLE'] = true;

    disable_php_memory_limit();

    $GLOBALS['SITE_DB']->query_delete('sitemap_cache');

    clean_unused_sitemap_files();

    $GLOBALS['MEMORY_OVER_SPEED'] = true;

    // Load ALL URL ID monikers (for efficiency)
    global $LOADED_MONIKERS_CACHE;
    if ($GLOBALS['SITE_DB']->query_select_value('url_id_monikers', 'COUNT(*)'/*, array('m_deprecated' => 0) Poor performance to include this and it's unnecessary*/) < 10000) {
        $results = $GLOBALS['SITE_DB']->query_select('url_id_monikers', array('m_moniker', 'm_resource_page', 'm_resource_type', 'm_resource_id'), array('m_deprecated' => 0));
        foreach ($results as $result) {
            $LOADED_MONIKERS_CACHE[$result['m_resource_page']][$result['m_resource_type']][$result['m_resource_id']] = $result['m_moniker'];
        }
    }

    // Load ALL guest permissions (for efficiency)
    load_up_all_module_category_permissions($GLOBALS['FORUM_DRIVER']->get_guest_id());

    // Runs via a callback mechanism, so we don't need to load an arbitrary complex structure into memory.
    $callback = '_sitemap_cache_node__nonguest';
    $meta_gather = SITEMAP_GATHER_TIMES;
    $options = SITEMAP_GEN_CONSIDER_VALIDATION | SITEMAP_GEN_MACHINE_SITEMAP;
    retrieve_sitemap_node(
        '',
        $callback,
        /*$valid_node_types=*/null,
        /*$child_cutoff=*/null,
        /*$max_recurse_depth=*/null,
        /*$options=*/$options,
        /*$zone=*/'_SEARCH',
        $meta_gather
    );
    $callback = '_sitemap_cache_node__guest';
    $options = SITEMAP_GEN_CONSIDER_VALIDATION | SITEMAP_GEN_MACHINE_SITEMAP | SITEMAP_GEN_CHECK_PERMS | SITEMAP_GEN_AS_GUEST;
    retrieve_sitemap_node(
        '',
        $callback,
        /*$valid_node_types=*/null,
        /*$child_cutoff=*/null,
        /*$max_recurse_depth=*/null,
        /*$options=*/$options,
        /*$zone=*/'_SEARCH',
        $meta_gather
    );
}

/**
 * Callback for referencing a Sitemap node in the cache. Used for things guests may not necessarily have access to.
 *
 * @param  array $node The Sitemap node
 *
 * @ignore
 */
function _sitemap_cache_node__nonguest($node)
{
    _sitemap_cache_node($node, false);
}

/**
 * Callback for referencing a Sitemap node in the cache. Used for things guests do have access to.
 *
 * @param  array $node The Sitemap node
 *
 * @ignore
 */
function _sitemap_cache_node__guest($node)
{
    _sitemap_cache_node($node, true);
}

/**
 * Backend for callbacks for referencing a Sitemap node in the cache.
 *
 * @param  array $node The Sitemap node
 * @param  boolean $guest_access Whether there is guest access
 *
 * @ignore
 */
function _sitemap_cache_node($node, $guest_access)
{
    $page_link = $node['page_link'];
    if ($page_link === null) {
        return;
    }

    $add_date = isset($node['extra_meta']['add_date']) ? $node['extra_meta']['add_date'] : null;
    $edit_date = isset($node['extra_meta']['edit_date']) ? $node['extra_meta']['edit_date'] : null;
    $priority = $node['sitemap_priority'];
    $refreshfreq = $node['sitemap_refreshfreq'];

    notify_sitemap_node_add($page_link, $add_date, $edit_date, $priority, $refreshfreq, $guest_access);
}

/**
 * Add a row to our sitemap cache.
 *
 * @param  SHORT_TEXT $page_link The page-link
 * @param  ?TIME $add_date The add time (null: unknown)
 * @param  ?TIME $edit_date The edit time (null: same as add time)
 * @param  ?float $priority The sitemap priority, a SITEMAP_IMPORTANCE_* constant (null: unknown - and trigger a Sitemap tail call to find it)
 * @param  ?ID_TEXT $refreshfreq The refresh frequency (null: unknown - and trigger a Sitemap tail call to find it)
 * @set always hourly daily weekly monthly yearly never
 * @param  ?boolean $guest_access Whether guests may access this resource in terms of category permissions not zone/page permissions (if not set to true then it will not end up in an XML Sitemap, but we'll keep tabs of it for other possible uses) (null: unknown - and trigger a Sitemap tail call to find it)
 */
function notify_sitemap_node_add($page_link, $add_date = null, $edit_date = null, $priority = null, $refreshfreq = null, $guest_access = null)
{
    list($zone, $map) = page_link_decode($page_link);
    if (isset($map['page'])) {
        require_code('global4');
        if (!comcode_page_is_indexable($zone, $map['page'])) {
            return;
        }

        // We don't want to leave _SEARCH in there, as it's inconsistent with what the regular Sitemap code goes
        $_zone = get_page_zone($map['page'], false);
        if ($_zone !== null) {
            $page_link = preg_replace('#^_SEARCH:#', $_zone . ':', $page_link);
        }
    }

    // Maybe we're still installing
    if (!$GLOBALS['SITE_DB']->table_exists('sitemap_cache') || running_script('install')) {
        return;
    }

    static $fresh = null;
    if ($fresh === null) {
        $fresh = ($GLOBALS['SITE_DB']->query_select_value('sitemap_cache', 'COUNT(*)') == 0) && (!$GLOBALS['RUNNING_BUILD_SITEMAP_CACHE_TABLE']);
    }

    // Find set number we will write into
    $set_number = $GLOBALS['SITE_DB']->query_select_value_if_there('sitemap_cache', 'set_number', array(), 'WHERE guest_access=1 GROUP BY set_number HAVING COUNT(*)<' . strval(URLS_PER_SITEMAP_SET));
    if ($set_number === null) { // No free space in existing set
        // Next set number in sequence
        $set_number = $GLOBALS['SITE_DB']->query_select_value_if_there('sitemap_cache', 'MAX(set_number)', array('guest_access' => 1));
        if ($set_number === null) {
            $set_number = 0;
        } else {
            $set_number++;
        }
    }

    if (($priority === null) || ($refreshfreq === null) || ($guest_access === null)) {
        $meta_gather = SITEMAP_GATHER_TIMES;
        $options = SITEMAP_GEN_CONSIDER_VALIDATION | SITEMAP_GEN_MACHINE_SITEMAP | SITEMAP_GEN_CHECK_PERMS | SITEMAP_GEN_AS_GUEST;
        $node = retrieve_sitemap_node(
            $page_link,
            /*$callback*/null,
            /*$valid_node_types=*/null,
            /*$child_cutoff=*/null,
            /*$max_recurse_depth=*/null,
            /*$options=*/$options,
            /*$zone=*/'_SEARCH',
            $meta_gather
        );
        if ($node === null) {
            $options = SITEMAP_GEN_CONSIDER_VALIDATION | SITEMAP_GEN_MACHINE_SITEMAP;
            $node = retrieve_sitemap_node(
                $page_link,
                /*$callback*/null,
                /*$valid_node_types=*/null,
                /*$child_cutoff=*/null,
                /*$max_recurse_depth=*/null,
                /*$options=*/$options,
                /*$zone=*/'_SEARCH',
                $meta_gather
            );

            if ($node === null) {
                // Some kind of error
                return;
            }

            if ($guest_access === null) {
                $guest_access = false;
            }
        } else {
            if ($guest_access === null) {
                $guest_access = true;
            }
        }

        if ($add_date === null) {
            $add_date = $node['extra_meta']['add_time'];
        }
        if ($edit_date === null) {
            $edit_date = $node['extra_meta']['edit_time'];
        }
        if ($priority === null) {
            $priority = $node['sitemap_priority'];
        }
        if ($refreshfreq === null) {
            $refreshfreq = $node['sitemap_refreshfreq'];
        }
    }

    // Save into sitemap
    $GLOBALS['SITE_DB']->query_delete('sitemap_cache', array(
        'page_link' => $page_link,
    ), '', 1);
    $GLOBALS['SITE_DB']->query_insert('sitemap_cache', array(
        'page_link' => $page_link,
        'set_number' => $set_number,
        'add_date' => ($add_date === null) ? null : $add_date,
        'edit_date' => ($edit_date === null) ? $add_date : $edit_date,
        'last_updated' => time(),
        'is_deleted' => 0,
        'priority' => $priority,
        'refreshfreq' => $refreshfreq,
        'guest_access' => $guest_access ? 1 : 0,
    ));

    // First population into the table? Do a full build too
    if ($fresh) {
        $fresh = false;
        build_sitemap_cache_table();
    }
}

/**
 * Edit a row in our sitemap cache.
 * For renames instead call notify_sitemap_node_delete then notify_sitemap_node_add.
 *
 * @param  SHORT_TEXT $page_link The page-link
 * @param  ?boolean $guest_access Whether guests may access this resource in terms of category permissions not zone/page permissions (if not set to 1 then it will not end up in an XML Sitemap, but we'll keep tabs of it for other possible uses) (null: unknown)
 */
function notify_sitemap_node_edit($page_link, $guest_access = null)
{
    if ($guest_access === null) {
        notify_sitemap_node_add($page_link); // Go through the full flow, which includes gathering metadata
        return;
    }

    $rows = $GLOBALS['SITE_DB']->query_select('sitemap_cache', array('*'), array(
        'page_link' => $page_link,
    ), '', 1);
    if (!isset($rows[0])) {
        notify_sitemap_node_add($page_link);
        return;
    }

    $GLOBALS['SITE_DB']->query_delete('sitemap_cache', array(
        'page_link' => $page_link,
    ), '', 1);
    $GLOBALS['SITE_DB']->query_insert('sitemap_cache', array(
        'edit_date' => time(),
        'last_updated' => time(),
        'guest_access' => $guest_access ? 1 : 0,
    ) + $rows[0]);
}

/**
 * Mark a row from our sitemap cache as for deletion.
 * It won't be immediately deleted, as we use this as a signal that the XML Sitemap will need updating too.
 * Updates are done in batch, via the system scheduler.
 * This may be called on page-links that may not actually be in the sitemap cache.
 *
 * @param  SHORT_TEXT $page_link The page-link
 */
function notify_sitemap_node_delete($page_link)
{
    $GLOBALS['SITE_DB']->query_update('sitemap_cache', array(
        'last_updated' => time(),
        'is_deleted' => 1,
    ), array('page_link' => $page_link), '', 1);
}

/**
 * Manually delete a node from the sitemap. Sometimes useful if Google Search Console is complaining, because something changed that Composr did not detect.
 *
 * @param  SHORT_TEXT $url The URL
 */
function delete_sitemap_node_manually_by_url($url)
{
    $page_link = url_to_page_link($url);
    notify_sitemap_node_delete($page_link);
    sitemap_xml_build();
}

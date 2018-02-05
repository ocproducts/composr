<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    downloads
 */

/*EXTRA FUNCTIONS: ftp_.**/

/**
 * Hook class.
 */
class Hook_task_import_ftp_downloads
{
    /**
     * Run the task hook.
     *
     * @param  AUTO_LINK $destination The category to import to
     * @param  string $server_url The import URL
     * @param  boolean $subfolders Whether to import subfolders
     * @return ?array A tuple of at least 2: Return mime-type, content (either Tempcode, or a string, or a filename and file-path pair to a temporary file), map of HTTP headers if transferring immediately, map of ini_set commands if transferring immediately (null: show standard success message)
     */
    public function run($destination, $server_url, $subfolders)
    {
        require_code('downloads2');
        require_lang('downloads');

        // Firstly, parse the server URL, to make sure it is fine
        $parsed_url = @parse_url($server_url);
        if ($parsed_url === false) {
            return array(null, do_lang_tempcode('HTTP_DOWNLOAD_BAD_URL', escape_html($server_url)));
        }
        if (!array_key_exists('scheme', $parsed_url)) {
            return array(null, do_lang_tempcode('HTTP_DOWNLOAD_BAD_URL', escape_html($server_url)));
        }
        if ($parsed_url['scheme'] != 'ftp') {
            return array(null, do_lang_tempcode('URL_BEGIN_FTP'));
        }
        if (substr($server_url, strlen($server_url) - 1, 1) != '/') {
            $server_url .= '/';
        }

        $parsed_url = parse_url($server_url);
        $directory = array_key_exists('path', $parsed_url) ? $parsed_url['path'] : '';

        require_lang('installer');
        $conn_id = @ftp_connect(array_key_exists('host', $parsed_url) ? $parsed_url['host'] : 'localhost', array_key_exists('port', $parsed_url) ? $parsed_url['port'] : 21);
        if ($conn_id === false) {
            return array(null, do_lang_tempcode('HTTP_DOWNLOAD_NO_SERVER', escape_html($server_url))); // Yes it's FTP not HTTP, but language string is ok
        }
        if ((array_key_exists('user', $parsed_url)) && (array_key_exists('pass', $parsed_url))) {
            $login_result = @ftp_login($conn_id, $parsed_url['user'], $parsed_url['pass']);
            if ($login_result === false) {
                return array(null, do_lang_tempcode('NO_FTP_LOGIN', @strval($php_errormsg)));
            }
        } else {
            $login_result = @ftp_login($conn_id, 'anonymous', get_option('staff_address'));
            if ($login_result === false) {
                return array(null, do_lang_tempcode('NO_FTP_LOGIN', @strval($php_errormsg)));
            }
        }

        // Check connection
        if (!$login_result) {
            return array(null, do_lang_tempcode('FTP_ERROR'));
        }

        // Failsafe check
        if ((@ftp_nlist($conn_id, $directory . '/dev') !== false) && (@ftp_nlist($conn_id, $directory . '/etc') !== false) && (@ftp_nlist($conn_id, $directory . '/sbin') !== false)) {
            return array(null, do_lang_tempcode('POINTS_TO_ROOT_SCARY', escape_html($directory)));
        }
        if ((@ftp_nlist($conn_id, $directory . '/Program files') !== false) && ((@ftp_nlist($conn_id, $directory . '/Users') !== false) || (@ftp_nlist($conn_id, $directory . '/Documents and settings') !== false)) && (@ftp_nlist($conn_id, $directory . '/Windows') !== false)) {
            return array(null, do_lang_tempcode('POINTS_TO_ROOT_SCARY', escape_html($directory)));
        }

        log_it('FTP_DOWNLOADS');

        // Actually start the scanning
        $num_added = $this->ftp_recursive_downloads_scan($conn_id, $server_url, $directory, $destination, $subfolders);

        ftp_close($conn_id);

        $ret = do_lang_tempcode('SUCCESS_ADDED_DOWNLOADS', escape_html(integer_format($num_added)));
        return array('text/html', $ret);
    }

    /**
     * Worker function to do an FTP import.
     *
     * @param  resource $conn_id The FTP connection
     * @param  URLPATH $url The URL that is equivalent to the base path on our FTP
     * @param  PATH $directory The directory we are scanning
     * @param  AUTO_LINK $dest_cat The destination downloading category
     * @param  boolean $make_subfolders Whether we add hierarchically (as opposed to a flat category fill)
     * @return integer Number of downloads added
     */
    public function ftp_recursive_downloads_scan($conn_id, $url, $directory, $dest_cat, $make_subfolders)
    {
        task_log($this, 'Processing ' . $directory . ' directory for files');

        $num_added = 0;

        $contents = @ftp_nlist($conn_id, $directory);
        if ($contents === false) {
            return 0;
        }
        foreach ($contents as $i => $entry) {
            $full_entry = $entry;
            $parts = explode('/', $entry);
            $entry = $parts[count($parts) - 1];

            // Is the entry a directory?
            if (@ftp_chdir($conn_id, $full_entry . '/')) {
                $full_path = $directory . $entry . '/';
                $full_url = $url . $entry . '/';
                if ($make_subfolders) {
                    // Do we need to make new category, or is it already existent?
                    $category_id = $GLOBALS['SITE_DB']->query_select_value_if_there('download_categories', 'id', array('parent_id' => $dest_cat, $GLOBALS['SITE_DB']->translate_field_ref('category') => $entry));
                    if ($category_id === null) {
                        // Add the directory
                        $category_id = add_download_category(titleify($entry), $dest_cat, '', '', '');
                        require_code('permissions2');
                        set_global_category_access('downloads', $category_id);
                    }
                    // Call this function again to recurse it
                    $num_added += $this->ftp_recursive_downloads_scan($conn_id, $full_url, $full_path, $category_id, true);
                } else {
                    $num_added += $this->ftp_recursive_downloads_scan($conn_id, $full_url, $full_path, $dest_cat, false);
                }
            } else {
                $full_url = $url . $entry;

                // Test to see if the file is already in our database
                $test = $GLOBALS['SITE_DB']->query_select_value_if_there('download_downloads', 'url', array('url' => $full_url));
                if ($test === null) {
                    // It is a file, so add it
                    add_download($dest_cat, titleify($entry), $full_url, '', $GLOBALS['FORUM_DRIVER']->get_username(get_member()), '', null, 1, 1, 1, 1, '', $entry, ftp_size($conn_id, $entry), 0, 0);
                    $num_added++;
                }
            }
        }

        return $num_added;
    }
}

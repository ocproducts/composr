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
 * Hook class.
 */
class Hook_cron_log_purging
{
    /**
     * Get info from this hook.
     *
     * @param  ?TIME $last_run Last time run (null: never)
     * @param  boolean $calculate_num_queued Calculate the number of items queued, if possible
     * @return ?array Return a map of info about the hook (null: disabled)
     */
    public function info($last_run, $calculate_num_queued)
    {
        return array(
            'label' => 'Log purging',
            'num_queued' => null,
            'minutes_between_runs' => 60 * 24,
        );
    }

    /**
     * Run function for system scheduler scripts. Searches for things to do. ->info(..., true) must be called before this method.
     *
     * @param  ?TIME $last_run Last time run (null: never)
     */
    public function run($last_run)
    {
        disable_php_memory_limit();

        $hook_obs = find_all_hook_obs('systems', 'logs', 'Hook_logs_');
        foreach ($hook_obs as $hook_ob) {
            $logs_available = $hook_ob->enumerate_logs();
            foreach ($logs_available as $filename => $details) {
                $path = get_custom_file_base() . '/data_custom/' . $filename;
                if ((is_file($path)) && ($details['days_to_keep'] !== null)) {
                    $this->purge_log($path, $details['days_to_keep']);
                }
            }
        }
    }

    /**
     * Purge a particular log back to just a certain number of days.
     *
     * @param  PATH $path Path to the log
     * @param  integer $days_to_keep Number of days to keep for
     */
    protected function purge_log($path, $days_to_keep)
    {
        $threshold_time = time() - 60 * 60 * 24 * $days_to_keep;

        $lines = array();

        $myfile = fopen($path, 'a+b');
        flock($myfile, LOCK_SH);
        rewind($myfile);
        $matches = array();
        $found_pivot = false;
        $found_some_date = false;
        while (!feof($myfile)) {
            $line = fgets($myfile);
            if ($line === false) {
                break;
            }

            if ($found_pivot) {
                $lines[] = $line;
            } else {
                if (preg_match('#^\[((\d\d)-(\w\w\w)-(\d\d\d\d) (\d\d):(\d\d):(\d\d) \w+)\]#', $line, $matches) != 0) {
                    $time = strtotime($matches[1]);
                    if ($time !== false) {
                        $found_some_date = true;
                        if ($time >= $threshold_time) {
                            $found_pivot = true;
                        }
                    }
                }

                if (!$found_some_date) { // This keeps any lead-in data in the log file intact
                    $lines[] = $line;
                }
            }
        }
        flock($myfile, LOCK_EX);

        ftruncate($myfile, 0);
        rewind($myfile);
        foreach ($lines as $line) {
            fwrite($myfile, $line);
        }
        flock($myfile, LOCK_UN);

        fclose($myfile);
    }
}
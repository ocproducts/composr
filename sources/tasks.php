<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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
function init__tasks()
{
    global $TASK_LOG_FILE;
    $TASK_LOG_FILE = null;
}

/**
 * Script to execute a described task.
 */
function tasks_script()
{
    header('X-Robots-Tag: noindex');

    $id = get_param_integer('id');
    $secure_ref = get_param_string('secure_ref', '');

    $where = array(
        'id' => $id,
        't_locked' => 0,
    );
    if (!$GLOBALS['FORUM_DRIVER']->is_super_admin(get_member())) {
        $where['t_secure_ref'] = $secure_ref;
    }
    $task_rows = $GLOBALS['SITE_DB']->query_select('task_queue', array('*'), $where, '', 1);
    if (!array_key_exists(0, $task_rows)) {
        return; // Missing / locked / secure_ref error
    }
    $GLOBALS['SITE_DB']->query_update('task_queue', array(
        't_locked' => 1,
    ), array(
        'id' => $id,
    ), '', 1);
    $task_row = $task_rows[0];

    execute_task_background($task_row);
}

/**
 * Execute a background task.
 *
 * @param  array $task_row The task row
 */
function execute_task_background($task_row)
{
    require_code('failure');

    global $RUNNING_TASK;
    $RUNNING_TASK = true;

    require_lang('tasks');

    require_code('users_inactive_occasionals');
    $requester = $task_row['t_member_id'];
    create_session($requester, 1);

    disable_php_memory_limit();
    if (php_function_allowed('set_time_limit')) {
        @set_time_limit(0);
    }

    $hook = $task_row['t_hook'];
    $args = @unserialize($task_row['t_args']);
    if ($args === false) {
        $GLOBALS['SITE_DB']->query_delete('task_queue', array(
            'id' => $task_row['id'],
        ), '', 1);

        fatal_exit(do_lang_tempcode('INTERNAL_ERROR'));
    }
    require_code('hooks/systems/tasks/' . filter_naughty_harsh($hook));
    $ob = object_factory('Hook_task_' . filter_naughty_harsh($hook));
    task_log_open();
    task_log(null, 'Starting task ' . $hook);
    $result = call_user_func_array(array($ob, 'run'), $args);
    task_log(null, 'Finished task ' . $hook);
    task_log_close();

    if ($task_row['t_send_notification'] == 1) {
        $attachments = array();

        require_code('notifications');

        if ($result === null) {
            $subject = do_lang('TASK_COMPLETED_SUBJECT', $task_row['t_title']);
            $message = do_notification_lang('TASK_COMPLETED_BODY_SIMPLE');
        } else {
            $content_result = mixed();

            if ($result === false) {
                $mime_type = null;
                $content_result = do_lang('INTERNAL_ERROR');
            } else {
                list($mime_type, $content_result) = $result;
            }

            // Handle error results
            if ($mime_type === null) {
                $subject = do_lang('TASK_FAILED_SUBJECT', $task_row['t_title']);
                $_content_result = is_object($content_result) ? ('[semihtml]' . $content_result->evaluate() . '[/semihtml]') : $content_result;
                $message = do_notification_lang('TASK_FAILED_BODY', $_content_result);
            } else {
                $subject = do_lang('TASK_COMPLETED_SUBJECT', $task_row['t_title']);

                // HTML result
                if ($mime_type == 'text/html') {
                    if (is_array($content_result)) {
                        $path = $content_result[1];
                        $content_result = file_get_contents($path);
                        @unlink($path);
                        sync_file($path);
                    }

                    $_content_result = is_object($content_result) ? ('[semihtml]' . $content_result->evaluate() . '[/semihtml]') : $content_result;
                    $message = do_notification_lang('TASK_COMPLETED_BODY', $_content_result);
                } else {
                    // Some downloaded result
                    if (is_array($content_result)) {
                        $attachments[$content_result[1]] = $content_result[0];
                    } else {
                        fatal_exit(do_lang_tempcode('INTERNAL_ERROR'));
                    }

                    $message = do_notification_lang('TASK_COMPLETED_BODY_ATTACHMENT');
                }
            }
        }

        dispatch_notification('task_completed', null, $subject, $message, array($requester), A_FROM_SYSTEM_PRIVILEGED, array('priority' => 2, 'attachments' => $attachments, 'send_immediately' => true));
    }

    if (is_array($result)) {
        list($mime_type, $content_result) = $result;
        if (is_array($content_result)) {
            @unlink($content_result[1]);
            sync_file($content_result[1]);
        }
    }

    if ($result === false) {
        $GLOBALS['SITE_DB']->query_update('task_queue', array(
            't_locked' => 0,
        ), array(
            'id' => $task_row['id'],
        ), '', 1);
    } else {
        $GLOBALS['SITE_DB']->query_delete('task_queue', array(
            'id' => $task_row['id'],
        ), '', 1);
    }

    $RUNNING_TASK = false;
}

/**
 * Execute a long task, via the task queue.
 *
 * @param  string $plain_title Title to use for completion notification subject lines
 * @param  ?Tempcode $title Title to use if there is no queueing or a queue message (null: don't return a full screen)
 * @param  ID_TEXT $hook The task hook
 * @param  array $args Arguments for the task
 * @param  boolean $run_at_end_of_script Whether to run the task at the end of the script (if it's not going to be put into the task queue)
 * @param  boolean $force_immediate Whether to forcibly bypass the task queue (because we've determined somehow it will be a quick task)
 * @param  boolean $send_notification Whether to send a notification of the task having come out of the queue
 * @return Tempcode UI (function may not return if the task is immediate and doesn't have a text/html result)
 */
function call_user_func_array__long_task($plain_title, $title, $hook, $args = array(), $run_at_end_of_script = false, $force_immediate = false, $send_notification = true)
{
    if (
        (get_param_integer('keep_debug_tasks', 0) == 1) ||
        (get_option('tasks_background') == '0') ||
        ((is_guest()) && ($send_notification)) ||
        (!$GLOBALS['SITE_DB']->table_exists('task_queue')/*LEGACY*/)
    ) {
        $force_immediate = true;
    }

    require_lang('tasks');

    if ($force_immediate) {
        if (($run_at_end_of_script) && (get_value('avoid_register_shutdown_function') !== '1')) {
            @ignore_user_abort(true); // Must keep going till completion

            register_shutdown_function(function () use ($plain_title, $title, $hook, $args, $force_immediate, $send_notification) {
                call_user_func_array__long_task($plain_title, $title, $hook, $args, false, $force_immediate, $send_notification);
            });
            return new Tempcode();
        }

        // Disable limits, as tasks can be resource-intensive
        disable_php_memory_limit();
        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(0);
        }

        // Run task
        require_code('hooks/systems/tasks/' . filter_naughty_harsh($hook));
        $ob = object_factory('Hook_task_' . filter_naughty_harsh($hook));
        task_log_open();
        task_log(null, 'Starting task ' . $hook);
        $result = call_user_func_array(array($ob, 'run'), $args);
        if ($result === false) {
            $result = array(null, do_lang_tempcode('INTERNAL_ERROR'));
        }
        task_log(null, 'Finished task ' . $hook);
        task_log_close();
        if ($result === null) {
            if ($title === null) {
                return new Tempcode();
            }
            return inform_screen($title, do_lang_tempcode('SUCCESS'));
        }
        if (!isset($result[2])) {
            $result[2] = array();
        }
        if (!isset($result[3])) {
            $result[3] = array();
        }
        list($mime_type, $content_result, $headers, $ini_set) = $result;

        // Action ini_set commands
        foreach ($ini_set as $key => $val) {
            cms_ini_set($key, $val);
        }

        // Action HTTP headers
        foreach ($headers as $key => $val) {
            header($key . ': ' . $val);
        }

        // Handle error results
        if ($mime_type === null) {
            if ($title === null) {
                attach_message(do_lang_tempcode('TASK_FAILED_SUBJECT', escape_html($plain_title)), 'warn');
                return $content_result;
            }
            return warn_screen($title, $content_result);
        }

        // HTML result
        if ($mime_type == 'text/html') {
            if (is_array($content_result)) {
                $path = $content_result[1];
                $content_result = file_get_contents($path);
                @unlink($path);
                sync_file($path);
            }

            if ($title === null) {
                return is_object($content_result) ? protect_from_escaping($content_result) : make_string_tempcode($content_result);
            }
            return do_template('FULL_MESSAGE_SCREEN', array(
                '_GUID' => '20e67ceb86e3bbd1e889c6ca116d7a77',
                'TITLE' => $title,
                'TEXT' => is_object($content_result) ? protect_from_escaping($content_result) : make_string_tempcode($content_result),
            ));
        }

        // Some downloaded result
        if (is_array($content_result)) {
            cms_ob_end_clean();
            readfile($content_result[1]);

            @unlink($content_result[1]);
            sync_file($content_result[1]);
        }/* elseif (is_object($content_result))
        {
            $content_result->evaluate_echo(null);
        } else {
            echo $content_result;
        }*/
        else {
            fatal_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }
        $GLOBALS['SCREEN_TEMPLATE_CALLED'] = '';
        exit();
    }

    // Enqueue...

    require_code('crypt');
    $secure_ref = get_secure_random_string();

    $id = $GLOBALS['SITE_DB']->query_insert('task_queue', array(
        't_title' => $plain_title,
        't_hook' => $hook,
        't_args' => serialize($args),
        't_member_id' => get_member(),
        't_secure_ref' => $secure_ref, // Used like a temporary password to initiate the task
        't_send_notification' => $send_notification ? 1 : 0,
        't_locked' => 0,
    ), true);

    if (GOOGLE_APPENGINE) {
        require_once('google/appengine/api/taskqueue/PushTask.php');

        $task = new \google\appengine\api\taskqueue\PushTask('/data/tasks.php', array('id' => strval($id), 'secure_ref' => $secure_ref), array('name' => $hook . '_' . $secure_ref));
        $task_name = $task->add();
    }

    if ($title === null) {
        return do_lang_tempcode('NEW_TASK_RUNNING');
    }
    return inform_screen($title, do_lang_tempcode('NEW_TASK_RUNNING'));
}

/**
 * Open task log.
 */
function task_log_open()
{
    global $TASK_LOG_FILE;
    $log_path = get_custom_file_base() . '/data_custom/tasks.log';
    if (!is_file($log_path)) {
        return;
    }
    $TASK_LOG_FILE = fopen($log_path, 'ab');
    flock($TASK_LOG_FILE, LOCK_EX);
    fseek($TASK_LOG_FILE, 0, SEEK_END);
}

/**
 * Do task logging.
 *
 * @param  ?object $object Task object that the logging comes from (null: N/A)
 * @param  string $message Message to log
 * @param  ?integer $i Iterator position, must be passed for any high frequency calls to this function (null: N/A)
 * @param  ?integer $total Total iterating through (null: N/A)
 */
function task_log($object, $message, $i = null, $total = null)
{
    global $TASK_LOG_FILE;
    if ($TASK_LOG_FILE === null) {
        return;
    }

    static $last_call = null;
    if ($i !== null) {
        if (($last_call !== null) && ($last_call > time() - 5)) {
            return; // We don't want to log more than every 5 seconds for these high frequency calls
        }
        $last_call = time();
    }

    $line = '';
    $line .= date('Y-m-d H:i:s');
    if ($object !== null) {
        $line .= ' [' . get_class($object) . ']';
    }
    $line .= ': ' . $message;
    if ($i !== null) {
        $line .= ' (';
        $line .= integer_format($i);
        if ($total !== null) {
            $line .= '/';
            $line .= integer_format($total);
        }
        $line .= ')';
    }
    $line .= "\n";

    fwrite($TASK_LOG_FILE, $line);
}

/**
 * Close task log.
 */
function task_log_close()
{
    global $TASK_LOG_FILE;
    if ($TASK_LOG_FILE === null) {
        return;
    }
    fclose($TASK_LOG_FILE);
}

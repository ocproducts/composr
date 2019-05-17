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
 * @package    import
 */

/**
 * Hook class.
 */
class Hook_commandr_command_continue_import
{
    /**
     * Run function for Commandr hooks.
     *
     * @param  array $options The options with which the command was called
     * @param  array $parameters The parameters with which the command was called
     * @param  object $commandr_fs A reference to the Commandr filesystem object
     * @return array Array of stdcommand, stdhtml, stdout, and stderr responses
     */
    public function run($options, $parameters, &$commandr_fs)
    {
        if (!addon_installed('import')) {
            return array('', '', '', do_lang('INTERNAL_ERROR'));
        }

        require_lang('import');

        if ((array_key_exists('h', $options)) || (!array_key_exists(0, $parameters)) || (array_key_exists('help', $options))) {
            return array('', do_command_help('continue_import', array('h'), array(true, true)), '', '');
        } else {
            require_code('import');

            disable_php_memory_limit();
            set_database_index_maintenance(true);
            set_mass_import_mode();

            $where = null;
            if (array_key_exists(1, $parameters)) {
                $where = array('imp_session' => $parameters[1]);
            }
            $session = $GLOBALS['SITE_DB']->query_select('import_session', array('*'), $where, '', 2);
            if (!array_key_exists(0, $session)) {
                warn_exit(do_lang_tempcode('MISSING_IMPORT_SESSION'));
            }
            if (array_key_exists(1, $session)) {
                warn_exit(do_lang_tempcode('TOO_MANY_IMPORT_SESSIONS'));
            }

            require_code('users_inactive_occasionals');
            set_session_id($session[0]['imp_session']);

            $importer = $session[0]['imp_hook'];
            $old_base_dir = $session[0]['imp_old_base_dir'];
            $db_name = $session[0]['imp_db_name'];
            $db_user = $session[0]['imp_db_user'];
            $db_password = $parameters[0];
            $db_table_prefix = $session[0]['imp_db_table_prefix'];
            $db_host = $session[0]['imp_db_host'];

            load_import_deps();

            require_code('hooks/modules/admin_import/' . filter_naughty_harsh($importer));
            $object = object_factory('Hook_import_' . filter_naughty_harsh($importer));

            $import_source = ($db_name === null) ? null : new DatabaseConnector($db_name, $db_host, $db_user, $db_password, $db_table_prefix);

            if (get_forum_type() != 'cns') {
                require_code('forum/cns');
                $GLOBALS['CNS_DRIVER'] = new Forum_driver_cns();
                $GLOBALS['CNS_DRIVER']->db = $GLOBALS['SITE_DB'];
                $GLOBALS['CNS_DRIVER']->MEMBER_ROWS_CACHED = array();
            }

            $info = $object->info();
            $_import_list = $info['import'];
            foreach ($_import_list as $import) {
                if ($GLOBALS['SITE_DB']->query_select_value_if_there('import_parts_done', 'imp_session', array('imp_id' => $import, 'imp_session' => get_session_id())) === null) {
                    $function_name = 'import_' . $import;
                    cns_over_local();
                    $func_output = call_user_func_array(array($object, $function_name), array($import_source, $db_table_prefix, $old_base_dir));
                    cns_over_msn();

                    $GLOBALS['SITE_DB']->query_insert('import_parts_done', array('imp_id' => $import, 'imp_session' => get_session_id()));
                }
            }

            log_it('IMPORT');
            post_import_cleanup();
            set_database_index_maintenance(true);
        }

        return array('', '', do_lang('SUCCESS'), '');
    }
}

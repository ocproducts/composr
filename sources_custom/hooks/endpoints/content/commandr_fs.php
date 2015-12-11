<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_mobile_sdk
 */

/**
 * Hook class.
 */
class Hook_endpoint_content_commandr_fs
{
    /**
     * Run an API endpoint.
     *
     * @param  ?string $type Standard type parameter, usually either of add/edit/delete/view (null: not-set).
     * @param  ?string $id Standard ID parameter (null: not-set).
     * @return array Data structure that will be converted to correct response type.
     */
    public function run($type, $id)
    {
        require_lang('composr_mobile_sdk');

        if (!has_actual_page_access(get_member(), 'admin_commandr', 'adminzone')) {
            access_denied('PAGE_ACCESS');
        }

        if (is_null($type)) {
            warn_exit(do_lang_tempcode('NO_PARAMETER_SENT', escape_html('type')));
        }

        if (is_null($id)) {
            $id = '';
        }

        require_code('commandr_fs');
        $commandr_fs = new Commandr_fs();

        $data = array(
            'message' => strip_html(do_lang('SUCCESS')),
        );

        $path_arr = $commandr_fs->_pwd_to_array('/' . $id);

        $is_file = $commandr_fs->_is_file($path_arr);
        $is_dir = $commandr_fs->_is_dir($path_arr);
        $exists = $is_file || $is_dir;
        /*if ($is_dir) {    Actually it's best to force being explicit, allows us to then serve directory listings (no ambiguity)
            require_code('resource_fs');
            $path_arr[] = RESOURCEFS_SPECIAL_DIRECTORY_FILE;
        }*/

        switch ($type) {
            case 'add':
                if (!$exists) {
                    $test = $commandr_fs->write_file($path_arr, post_param_string('data', ''));
                    if (!$test) {
                        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
                    }
                } else {
                    warn_exit(do_lang_tempcode('ALREADY_EXISTS', escape_html($id)));
                }
                break;

            case 'edit':
                if ($exists) {
                    $test = $commandr_fs->write_file($path_arr, post_param_string('data', ''));
                    if (!$test) {
                        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
                    }
                } else {
                    warn_exit(do_lang_tempcode('_MISSING_RESOURCE', escape_html($id)));
                }
                break;

            case 'delete':
                if ($exists) {
                    $test = $commandr_fs->remove_file($path_arr);
                    if (!$test) {
                        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
                    }
                } else {
                    warn_exit(do_lang_tempcode('_MISSING_RESOURCE', escape_html($id)));
                }
                break;

            case 'view':
                if ($exists) {
                    if ($is_dir) {
                        $data = $commandr_fs->listing($path_arr);
                    } else {
                        $__data = $commandr_fs->read_file($path_arr);
                        if ($__data !== false) {
                            $_data = @json_decode($__data, true);
                            if (is_array($_data)) {
                                $data = $_data;
                            } else {
                                $data = array(
                                    'data' => $__data,
                                );
                            }
                        } else {
                            warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
                        }
                    }
                } else {
                    warn_exit(do_lang_tempcode('_MISSING_RESOURCE', escape_html($id)));
                }
                break;

            default:
                warn_exit(do_lang_tempcode('INVALID_ENDPOINT_TYPE'));
        }

        return $data;
    }
}

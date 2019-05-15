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
 * @package    core_cns
 */

/**
 * Hook class.
 */
class Hook_task_export_member_csv
{
    /**
     * Run the task hook.
     *
     * @param  boolean $filter_by_allow Only provide members that have "Receive newsletters and other site updates" set.
     * @param  string $extension File extension to use.
     * @param  string $preset Preset to use.
     * @param  array $fields_to_use List of fields to use (empty: none).
     * @param  array $usergroups List of usergroups to use (empty: all).
     * @param  string $order_by Field to order by.
     * @return ?array A tuple of at least 2: Return mime-type, content (either Tempcode, or a string, or a filename and file-path pair to a temporary file), map of HTTP headers if transferring immediately, map of ini_set commands if transferring immediately (null: show standard success message)
     */
    public function run($filter_by_allow, $extension, $preset, $fields_to_use, $usergroups, $order_by)
    {
        $filename = 'members-' . date('Y-m-d') . '.' . $extension;

        require_code('mime_types');
        $mime_type = get_mime_type($extension, true);

        $headers = array();
        $headers['Content-type'] = $mime_type;
        $headers['Content-Disposition'] = 'attachment; filename="' . escape_header($filename) . '"';

        $ini_set = array();
        $ini_set['ocproducts.xss_detect'] = '0';

        require_code('cns_members_action2');
        list($headings, $cpfs, $subscription_types) = member_get_csv_headings_extended();

        $_headings = $headings;

        // What to filter on
        if ($preset == '') {
            foreach (explode(',', $order_by) as $_order_by) {
                if ((!in_array($_order_by, $fields_to_use)) && (isset($_headings[$_order_by]))) {
                    $fields_to_use[] = $_order_by;
                }
            }
        } else {
            $presets = $this->_get_export_presets();
            $_preset = $presets[$preset];

            $fields_to_use = $_preset['fields'];
            $order_by = array_key_exists('row_order', $_preset) ? $_preset['row_order'] : 'ID';
            $usergroups = array_key_exists('usergroups', $_preset) ? $_preset['usergroups'] : array();
        }
        $headings = array();
        foreach ($fields_to_use as $field_label) {
            $field_name = isset($_headings[$field_label]) ? $_headings[$field_label] : $field_label;/*Must be a pseudo-field so just carry it forward*/
            $headings[$field_label] = is_numeric($field_name) ? intval($field_name) : $field_name;
        }

        // Derive filtering
        if ($usergroups != array()) {
            // Filter just for f_group_members
            $group_filter = '(';
            foreach ($usergroups as $i => $usergroup) {
                if ($i != 0) {
                    $group_filter .= ' OR ';
                }
                $group_filter .= 'gm_group_id=' . strval($usergroup);
            }
            $group_filter .= ')';

            // Filter for f_members
            $group_filter_2 = '(';
            foreach ($usergroups as $i => $usergroup) {
                if ($i != 0) {
                    $group_filter_2 .= ' OR ';
                }
                $group_filter_2 .= 'm_primary_group=' . strval($usergroup);
                $group_filter_2 .= ' OR ';
                $group_filter_2 .= 'EXISTS(SELECT * FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_group_members WHERE gm_member_id=id AND gm_group_id=' . strval($usergroup) . ')';
            }
            $group_filter_2 .= ')';
        } else {
            // Filter just for f_group_members
            $group_filter = '1=1';

            // Filter for f_members
            $group_filter_2 = '1=1';
        }

        $outfile_path = cms_tempnam();
        $outfile = fopen($outfile_path, 'wb');

        $fields = array('id', 'm_username', 'm_email_address', 'm_last_visit_time', 'm_cache_num_posts', 'm_pass_hash_salted', 'm_pass_salt', 'm_password_compat_scheme', 'm_signature', 'm_validated', 'm_join_time', 'm_primary_group', 'm_is_perm_banned', 'm_dob_day', 'm_dob_month', 'm_dob_year', 'm_reveal_age', 'm_language', 'm_allow_emails', 'm_allow_emails_from_staff');
        if (addon_installed('cns_member_avatars')) {
            $fields[] = 'm_avatar_url';
        }
        if (addon_installed('cns_member_photos')) {
            $fields[] = 'm_photo_url';
        }

        // Read member groups
        $groups = $GLOBALS['FORUM_DRIVER']->get_usergroup_list(false, false, true);
        $member_groups_count = $GLOBALS['FORUM_DB']->query_select_value('f_group_members', 'COUNT(*)', array('gm_validated' => 1), ' AND ' . $group_filter);
        if ($member_groups_count < 500) {
            $member_groups = $GLOBALS['FORUM_DB']->query_select('f_group_members', array('gm_member_id', 'gm_group_id'), array('gm_validated' => 1), ' AND ' . $group_filter);
        } else {
            $member_groups = array();
        }

        // Member count
        $member_count = $GLOBALS['FORUM_DB']->query_select_value('f_members LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_member_custom_fields ON id=mf_member_id', 'COUNT(*)', null, ' WHERE ' . $group_filter_2);

        // Output headings
        foreach (array_keys($headings) as $i => $h) {
            if ($i != 0) {
                fwrite($outfile, ',');
            }
            fwrite($outfile, '"' . str_replace('"', '""', $h) . '"');
        }
        fwrite($outfile, "\n");

        // Filter
        $where = array();
        if ($filter_by_allow) {
            $where['m_allow_emails_from_staff'] = 1;
        }

        // Output records
        $at = mixed();
        $limit = get_param_integer('max', 200); // Set 'max' if you don't want all records
        $start = 0;
        do {
            $members = $GLOBALS['FORUM_DB']->query_select('f_members LEFT JOIN ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_member_custom_fields ON id=mf_member_id', array('*'), null, ' WHERE ' . $group_filter_2 . ' ORDER BY id', $limit, $start);

            foreach ($members as $m) {
                if (is_guest($m['id'])) {
                    continue;
                }

                if ($member_groups_count >= 500) {
                    $member_groups = $GLOBALS['FORUM_DB']->query_select('f_group_members', array('gm_member_id', 'gm_group_id'), array('gm_validated' => 1, 'gm_member_id' => $m['id']));
                }

                $out = $this->_get_csv_member_record($m, $groups, $headings, $cpfs, $member_groups, $subscription_types);
                $i = 0;
                foreach ($out as $wider) {
                    if ($i != 0) {
                        fwrite($outfile, ',');
                    }
                    fwrite($outfile, '"' . str_replace('"', '""', $wider) . '"');
                    $i++;
                }
                fwrite($outfile, "\n");
            }

            $start += 200;
        } while (count($members) == 200);

        fclose($outfile);

        // Have to rebuild file for some reason?
        if ($extension != 'csv' || $order_by != 'ID') {
            // Load data
            $data = array();
            $outfile = fopen($outfile_path, 'rb');
            fgetcsv($outfile); // Skip header
            $heading_values = array_keys($headings);
            while (($_data = fgetcsv($outfile)) !== false) {
                $data[] = array_combine($heading_values, $_data);
            }
            fclose($outfile);

            if ($order_by != 'id') {
                // Sort
                sort_maps_by($data, $order_by);
            }

            require_code('files2');
            $filename .= '.' . $extension;
            make_csv($data, $filename, false, false, $outfile_path);
        }

        return array($mime_type, array($filename, $outfile_path), $headers, $ini_set);
    }

    /**
     * Get a CSV-outputtable row for a member.
     *
     * @param  array $m Member row
     * @param  array $groups Map of usergroup details
     * @param  array $headings List of headings to pull from the member row
     * @param  array $cpfs List of CPFS to pull
     * @param  array $member_groups List of member group membership records
     * @param  array $subscription_types List of subscription types
     * @return array The row
     */
    public function _get_csv_member_record($m, $groups, $headings, $cpfs, $member_groups, $subscription_types)
    {
        // Usergroup subscription details
        if (addon_installed('ecommerce')) {
            require_code('ecommerce_subscriptions');
            require_lang('ecommerce');
            $subscriptions = find_member_subscriptions($m['id'], true);
            foreach ($subscription_types as $type_code => $item_name) {
                if (isset($subscriptions[$type_code])) {
                    $sub = $subscriptions[$type_code];
                    $start_time = date('Y/m/d', tz_time($sub['start_time'], get_site_timezone()));
                    $term_start_time = date('Y/m/d', tz_time($sub['term_start_time'], get_site_timezone()));
                    $term_end_time = date('Y/m/d', tz_time($sub['term_end_time'], get_site_timezone()));
                    $expiry_time = date('Y/m/d', tz_time($sub['expiry_time'], get_site_timezone()));
                    $payment_gateway = do_lang('PAYMENT_GATEWAY_' . $sub['payment_gateway']);
                    $state = do_lang('PAYMENT_STATE_' . $sub['state']);
                } else {
                    $start_time = '';
                    $term_start_time = '';
                    $term_end_time = '';
                    $expiry_time = '';
                    $payment_gateway = '';
                    $state = '';
                }
                $m[$item_name . ' (' . do_lang('SUBSCRIPTION_START_TIME') . ')'] = $start_time;
                $m[$item_name . ' (' . do_lang('SUBSCRIPTION_TERM_START_TIME') . ')'] = $term_start_time;
                $m[$item_name . ' (' . do_lang('SUBSCRIPTION_TERM_END_TIME') . ')'] = $term_end_time;
                $m[$item_name . ' (' . do_lang('SUBSCRIPTION_EXPIRY_TIME') . ')'] = $expiry_time;
                $m[$item_name . ' (' . do_lang('PAYMENT_GATEWAY') . ')'] = $payment_gateway;
                $m[$item_name . ' (' . do_lang('STATUS') . ')'] = $state;
            }
        }

        $at = mixed();
        $out = array();
        $i = 0;
        foreach ($headings as $written_heading => $f) {
            if ($f === null) {
                continue;
            }

            if (is_integer($f)) { // CPF
                if ($m['mf_member_id'] === null) {
                    $at = '';
                } else {
                    $at = $m['field_' . strval($f)];
                    if ($at === null) {
                        $at = '';
                    } else {
                        if (strpos($cpfs[$f]['cf_type'], '_trans') !== false) {
                            $at = get_translated_text($at);
                        } elseif (!is_string($at)) {
                            $at = strval($at);
                        }
                    }
                }
                $out[$cpfs[$f]['_cf_name']] = $at;
            } else {
                $parts = explode('/', $f);
                $wider = '';
                foreach ($parts as $i => $part) {
                    switch (substr($part, 0, 1)) {
                        case '*': // language string
                            $at = get_translated_text($m[substr($part, 1)], $GLOBALS['FORUM_DB']);
                            break;

                        case '!': // binary
                            $at = ($m[substr($part, 1)] == 1) ? 'Yes' : 'No'; // Hard-coded in English, because we need a multi-language standard
                            break;

                        case '&': // timestamp
                            $at = date('Y-m-d', intval($m[substr($part, 1)]));
                            break;

                        case '#': // url
                            $at = $m[substr($part, 1)];
                            if ((url_is_local($at)) && ($at != '')) {
                                $at = get_complex_base_url($at) . '/' . $at;
                            }
                            break;

                        case '@': // append other groups
                            $at = isset($groups[$m[substr($part, 1)]]) ? $groups[$m[substr($part, 1)]] : '';

                            foreach ($member_groups as $g) {
                                if ($g['gm_member_id'] == $m['id']) {
                                    if (array_key_exists($g['gm_group_id'], $groups)) {
                                        $at .= '/' . $groups[$g['gm_group_id']];
                                    }
                                }
                            }
                            break;

                        default: // string
                            // Pseudo fields
                            /*switch ($part) {
                                case 'Initials':
                                    $at = cms_preg_replace_safe('#\s*(\w)\w*\s*#', '${1}', $m['field_' . find_cpf_field_id('Forenames')] . ' ' . $m['field_' . find_cpf_field_id('Surname')]);
                                    break 2;

                                case 'Name':
                                    $at = cms_preg_replace_safe('#\s.*$#', '', trim($m['field_' . find_cpf_field_id('Forenames')]));
                                    break 2;
                            }*/

                            $at = $m[$part];
                            break;
                    }
                    if ($i != 0) {
                        if ($f == 'm_pass_hash_salted/m_pass_salt/m_password_compat_scheme') {
                            $wider .= ' / ';
                        } else {
                            $wider .= '/';
                        }
                    }
                    $wider .= is_integer($at) ? strval($at) : (($at === null) ? '' : $at);
                }
                $out[$written_heading] = $wider;

                $i++;
            }
        }

        return $out;
    }
}

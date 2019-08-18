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
function init__actionlog()
{
    require_lang('actionlog');

    if (!defined('ACTIONLOG_FLAGS_NONE')) {
        define('ACTIONLOG_FLAGS_NONE', 0);
        define('ACTIONLOG_FLAG__USER_ACTION', 1); // Used when we use the action log for non-admin actions (as we have no dedicated log for something)
        define('ACTIONLOG_FLAG__GDPR', 2);
    }
}

/**
 * Base action log object.
 * Used for ameliorating action log entries.
 *
 * @package    core_notifications
 */
abstract class Hook_actionlog
{
    /**
     * Get extended action log details if the action log entry type is handled by this hook and we have them.
     *
     * @param  array $actionlog_row Action log row
     * @return ?~array Map of extended data in standard format (null: not available from this hook) (false: hook has responsibility but has failed)
     */
    public function get_extended_actionlog_data($actionlog_row)
    {
        $handlers = $this->get_handlers();

        $type = $actionlog_row['the_type'];

        if (array_key_exists($type, $handlers)) {
            $handler_data = $handlers[$type];

            $identifier = $this->get_identifier($actionlog_row, $handler_data);
            if ($identifier === '') {
                // Fail (note null does not fail, it just means we have no identifier which is fine)
                return false;
            }

            $written_context = $this->get_written_context($actionlog_row, $handler_data, $identifier);
            if ($written_context === null || $written_context === '') {
                // Fail
                return false;
            }

            $bindings = array(
                'ID' => $identifier,
                '0' => ($actionlog_row['param_a'] == '') ? null : $actionlog_row['param_a'],
                '1' => ($actionlog_row['param_b'] == '') ? null : $actionlog_row['param_b'],
                '0__EVEN_EMPTY' => $actionlog_row['param_a'],
                '1__EVEN_EMPTY' => $actionlog_row['param_b'],
            );
            $this->get_extended_actionlog_bindings($actionlog_row, $identifier, $written_context, $bindings);

            $followup_urls = array();
            $followup_page_links = $handler_data['followup_page_links'];
            foreach ($followup_page_links as $caption => $page_link) {
                if ($page_link !== null) {
                    if (is_array($page_link)) {
                        // Some kind of special encoding where a page-link isn't going to work for us
                        $success = true;
                        foreach ($page_link as $special_part) {
                            $success = $success && $this->apply_string_parameter_substitutions($special_part, $bindings);
                        }
                        if ($success) {
                            if (!isset($page_link[0])) {
                                warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
                            }

                            switch ($page_link[0]) {
                                case 'FORUM_DRIVER__PROFILE_URL':
                                    if (count($page_link) != 2) {
                                        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
                                    }

                                    if (is_numeric($page_link[1])) {
                                        $url = $GLOBALS['FORUM_DRIVER']->member_profile_url(intval($page_link[1]), true);
                                        $followup_urls[] = $url;
                                    }
                                    break;

                                default:
                                    warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
                            }
                        }
                    } else {
                        $success = $this->apply_string_parameter_substitutions($page_link, $bindings);
                        if ($success) {
                            $url = page_link_to_url($page_link);
                            $followup_urls[do_lang($caption)] = $url;
                        }
                    }
                }
            }

            return array(
                'flags' => $handler_data['flags'],
                'written_context' => $written_context,
                'followup_urls' => $followup_urls,
            );
        }

        return null;
    }

    /**
     * Get identifier for an action log entry handled by this hook.
     *
     * @param  array $actionlog_row Action log row
     * @param  array $handler_data Handler data
     * @return string Identifier
     */
    protected function get_identifier($actionlog_row, $handler_data)
    {
        $identifier = null;
        if ($handler_data['identifier_index'] === 0) {
            $identifier = $actionlog_row['param_a'];
        } elseif ($handler_data['identifier_index'] === 1) {
            $identifier = $actionlog_row['param_b'];
        }
        return $identifier;
    }

    /**
     * Get written context for an action log entry handled by this hook.
     *
     * @param  array $actionlog_row Action log row
     * @param  array $handler_data Handler data
     * @param  ?string $identifier Identifier (null: none)
     * @return string Written context
     */
    protected function get_written_context($actionlog_row, $handler_data, $identifier)
    {
        $written_context = null;
        if ($handler_data['written_context_index'] === 0) {
            $written_context = $actionlog_row['param_a'];
        } elseif ($handler_data['written_context_index'] === 1) {
            $written_context = $actionlog_row['param_b'];
        }
        if ($written_context === null && $identifier !== null && $handler_data['cma_hook'] !== null) {
            // Work out from CMA hook as we don't have it directly in the action log entry
            require_code('content');
            list($written_context) = content_get_details($handler_data['cma_hook'], $identifier);
        }
        return $written_context;
    }

    /**
     * Get details of action log entry types handled by this hook.
     *
     * @param  array $actionlog_row Action log row
     * @param  ?string $identifier The identifier associated with this action log entry (null: unknown / none)
     * @param  ?string $written_context The written context associated with this action log entry (null: unknown / none)
     * @param  array $bindings Default bindings
     */
    protected function get_extended_actionlog_bindings($actionlog_row, $identifier, $written_context, &$bindings)
    {
        // For overriding
    }

    /**
     * Apply any page-link/URL parameter value substitutions to a string.
     *
     * @param  string $string The string to apply to, changed by reference
     * @param  array $bindings Mapping of bindings to apply
     * @return ~boolean Whether successful applying the bindings (false: null or missing binding)
     */
    protected function apply_string_parameter_substitutions(&$string, $bindings)
    {
        foreach ($bindings as $binding_from => $binding_to) {
            if (is_integer($binding_from)) {
                $binding_from = strval($binding_from);
            }

            $_binding_from = '{' . $binding_from . '}';
            if (strpos($string, $_binding_from) !== false) {
                if ($binding_to !== null) {
                    $string = str_replace($_binding_from, $binding_to, $string);
                } else {
                    return false; // required binding is null
                }
            }

            // Now optional version too
            $_binding_from = '{' . $binding_from . ',OPTIONAL}';
            if (strpos($string, $_binding_from) !== false) {
                if ($binding_to !== null) {
                    $string = str_replace($_binding_from, $binding_to, $string);
                } else {
                    // Just strip the page-link/URL binding
                    $string = preg_replace('#[:&]\w+=' . preg_quote($_binding_from, '#') . '#', '', $string);
                }
            }
        }

        if (strpos($string, '{') !== false) {
            return false; // Missing binding
        }

        return true;
    }

    /**
     * Get details of action log entry types handled by this hook.
     *
     * @return array Map of handler data in standard format
     */
    public function get_handlers()
    {
        return array();
    }
}

/**
 * Get handler flags for a particular action log type.
 *
 * @param  ID_TEXT $the_type Action log type
 * @return integer Flags
 */
function get_handler_flags($the_type)
{
    static $hook_obs = null;
    if ($hook_obs === null) {
        $hook_obs = find_all_hook_obs('systems', 'actionlog', 'Hook_actionlog_');
    }

    foreach ($hook_obs as $hook => $ob) {
        $handlers = $ob->get_handlers();
        if (array_key_exists($the_type, $handlers)) {
            return $handlers[$the_type]['flags'];
        }
    }

    return ACTIONLOG_FLAGS_NONE;
}

/**
 * Try and make an action log entry into a proper link.
 *
 * @param  array $actionlog_row Action log row
 * @param  ?integer $crop_length_a Crop length for parameter (null: no cropping)
 * @param  ?integer $crop_length_b Crop length for parameter (null: no cropping)
 * @return ?array Tuple: enhanced label, enhanced label that may be null, flags, map of followup URLs (null: could not construct a nice link)
 */
function actionlog_linkage($actionlog_row, $crop_length_a = null, $crop_length_b = null)
{
    static $hook_obs = null;
    if ($hook_obs === null) {
        $hook_obs = find_all_hook_obs('systems', 'actionlog', 'Hook_actionlog_');
    }

    foreach ($hook_obs as $hook => $ob) {
        $extended_data = $ob->get_extended_actionlog_data($actionlog_row);
        if ($extended_data !== null) {
            if ($extended_data === false) {
                return null;
            }

            require_code('templates_interfaces');
            if ($crop_length_a === null || $crop_length_b === null) {
                $_written_context = make_string_tempcode(escape_html($extended_data['written_context']));
            } else {
                $_written_context = tpl_crop_text_mouse_over($extended_data['written_context'], $crop_length_a + $crop_length_b + 3/*A bit of extra tolerance*/);
            }
            $_a = do_template('ACTIONLOG_FOLLOWUP_URLS', array(
                '_GUID' => 'd6d634cca4fdf5ff4e8c57a1190fca5d',
                'WRITTEN_CONTEXT' => $_written_context,
                'FOLLOWUP_URLS' => $extended_data['followup_urls'],
            ));
            $_b = null;
            return array($_a, $_b, $extended_data['flags'], $extended_data['followup_urls']);
        }
    }

    return null; // Could not get a match
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    workflows
 */

/**
 * Inject workflow code into the galleries view.
 *
 * @return  string Altered code
 */
function init__site__pages__modules_custom__galleries($code)
{
    // Add a redirection for the workflow handling
    $code = str_replace('if ($type == \'list\') return $this->list_galleries();',
        'if ($type == \'list\') return $this->list_galleries();
        if ($type == \'workflow\') return $this->workflow_handler();',
        $code);

    // Add workflow warnings to flow mode galleries. This has to be done for
    // images...
    $code = str_replace(
        '$current_entry = do_template(\'GALLERY_FLOW_MODE_IMAGE\'',
        '// Add the workflow form if this entry is unvalidated
        if (array_key_exists(\'validated\', $row) && $row[\'validated\'] != 1) {
            require_code(\'workflows\');
            require_lang(\'workflows\');
            // We need to find our ID first
            $wf = get_workflow_of_content(\'image\', strval($row[\'id\']));
            if (!is_null($wf)) {
                $workflow_content_id = get_workflow_content_id(\'image\', strval($row[\'id\']));
                if (!is_null($workflow_content_id)) $warning_details->attach(get_workflow_form($workflow_content_id));
            }
        }
        $current_entry = do_template(\'GALLERY_FLOW_MODE_IMAGE\'',
        $code
    );

    // ...and videos separately.
    $code = str_replace('$current_entry = do_template(\'GALLERY_FLOW_MODE_VIDEO',
        '// Add the workflow form if this entry is unvalidated
        if (array_key_exists(\'validated\', $row) && $row[\'validated\'] != 1) {
            require_code(\'workflows\');
            require_lang(\'workflows\');
            // We need to find our ID first
            $wf = get_workflow_of_content(\'video\', strval($row[\'id\']));
            if (!is_null($wf)) {
                $workflow_content_id = get_workflow_content_id(\'video\', strval($row[\'id\']));
                if (!is_null($workflow_content_id)) $warning_details->attach(get_workflow_form($workflow_content_id));
            }
        }
        $current_entry = do_template(\'GALLERY_FLOW_MODE_VIDEO',
        $code
    );

    // Add workflow warnings to images
    $code = str_replace(
        '} else $warning_details = new Tempcode();

        if ((has_actual_page_access',
        '// Add the workflow form here for now, to save duplicating the condition
        require_code(\'workflows\');
        require_lang(\'workflows\');
        // We need to find our ID first
        // Hack to see whether we are an image or video
        if (array_key_exists(\'image_views\', $myrow)) $content_type = \'image\';
        if (array_key_exists(\'video_views\', $myrow)) $content_type = \'video\';
        $workflow_content_id = get_workflow_content_id($content_type, strval($myrow[\'id\']));
        if (!is_null($workflow_content_id)) $warning_details->attach(get_workflow_form($workflow_content_id));
        } else $warning_details = new Tempcode();

        if ((has_actual_page_access',
        $code
    );

    // Add workflow warnings to videos
    $code = str_replace(
        '} else $warning_details = new Tempcode();

        // Comments',
        'require_code(\'workflows\');
        require_lang(\'workflows\');
        // We need to find our ID first
        $workflow_content_id = get_workflow_content_id(\'video\', strval($id));
        if (!is_null($workflow_content_id)) $warning_details->attach(get_workflow_form($workflow_content_id));
        } else $warning_details = new Tempcode();

        // Comments',
        $code
    );

    // Add workflow handling to the end of the class definition
    $code = str_replace('\'MORE_URL\' => $more_url, \'CATEGORY_NAME\' => $category_name));
    }',
        '\'MORE_URL\' => $more_url, \'CATEGORY_NAME\' => $category_name));
    }
        /**
         * Handler for workflow requests
         */
        function workflow_handler()
        {
            // Only act if workflows are installed
            require_code(\'workflows\');     // Load workflow-related code
            return workflow_update_handler();
        }',
        $code
    );

    $code = str_replace("function pre_run()\n    {", "function pre_run()\n    { i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);", $code);

    return $code;
}

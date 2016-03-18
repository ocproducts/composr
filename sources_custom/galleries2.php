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

function init__galleries2($code)
{
    // We want to inject our workflow handling code into add_image...
    $code = str_replace(
        'log_it(\'ADD_IMAGE\', strval($id), $title);',
        '
        if ($validated == 0) {
            require_code("workflows");
            require_lang("workflows");
            // See if we have a specific workflow to use
            $workflow_id = intval(str_replace("wf_", "", either_param_string("workflow", "wf_-1")));
            // If we have been given a specific workflow, but we do not have access to
            // choose workflows, fall back to the default
            if ($workflow_id != -1 && !can_choose_workflow()) {
                $workflow_id =- 1;
            }

            if ($workflow_id == -1) {
                // Look for the workflow of the containing gallery
                $workflow_id = get_workflow_of_content("gallery", $title);
                if (is_null($workflow_id)) {
                    // Use the default if it has none
                    add_content_to_workflow("image", strval($id));
                    attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text(get_default_workflow())), "inform");
                } else {
                    // The parent has a workflow. Copy it for this.
                    add_content_to_workflow("image", strval($id), $workflow_id);
                    attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text($workflow_id)), "inform");
                }
            } else {
                // Use the specific ID provided
                add_content_to_workflow("image", strval($id), $workflow_id);
                attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text($workflow_id)), "inform");
            }
            log_it(\'ADD_IMAGE\', strval($id), $title);
        }
        ',
        $code
    );

    // ...and add_video...
    $code = str_replace(
        'log_it(\'ADD_VIDEO\', strval($id), $title);',
        '
        if ($validated == 0) {
            require_code("workflows");
            require_lang("workflows");
            // See if we have a specific workflow to use
            $workflow_id = intval(str_replace("wf_", "", either_param_string("workflow", "wf_-1")));
            // If we have been given a specific workflow, but we do not have access to
            // choose workflows, fall back to the default
            if ($workflow_id != -1 && !can_choose_workflow())
                    $workflow_id =- 1;

            if ($workflow_id == -1) {
                // Look for the workflow of the containing gallery
                $workflow_id = get_workflow_of_content("gallery", $title);
                if (is_null($workflow_id)) {
                    // Use the default if it has none
                    add_content_to_workflow("video", strval($id));
                    attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text(get_default_workflow())), "inform");
                } else {
                    // The parent has a workflow. Copy it for this.
                    add_content_to_workflow("video", strval($id), $workflow_id);
                    attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text($workflow_id)), "inform");
                }
            } else {
                // Use the specific ID provided
                add_content_to_workflow("video", strval($id), $workflow_id);
                attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text($workflow_id)), "inform");
            }
            log_it(\'ADD_VIDEO\', strval($id), $title);
        }
        ',
        $code
    );

    // ...and add gallery...
    $code = str_replace('log_it(\'ADD_GALLERY\', $name, $fullname);',
        'require_code("workflows");
        require_lang("workflows");
        // See if we have a specific workflow to use
        $workflow_id = intval(str_replace("wf_", "", either_param_string("workflow", "wf_-1")));
        // If we have been given a specific workflow, but we do not have access to
        // choose workflows, fall back to the default
        if ($workflow_id != -1 && !can_choose_workflow())
            $workflow_id = -1;

        if ($workflow_id == -1) {
            // Look for the workflow of the containing gallery
            $workflow_id = get_workflow_of_content("gallery", $parent_id);
            if (is_null($workflow_id)) {
                // Use the default if it has none
                add_content_to_workflow("gallery", $name);
            } else {
                // The parent has a workflow. Copy it for this.
                add_content_to_workflow("gallery", $name, $workflow_id);
            }
        } else {
            // Use the specific ID provided
            add_content_to_workflow("gallery", $name, $workflow_id);
        }
        log_it(\'ADD_GALLERY\', $name, $fullname);',
        $code
    );

    // Editing is a bit different; we switch the workflow if needed.

    // Do this for images...
    $code = str_replace(
        'log_it(\'EDIT_IMAGE\', strval($id), $title);',
        '
        if ($validated == 0) {
            require_code("workflows");
            require_lang("workflows");
            // See if we have a specific workflow to use
            $edit_workflow = array_key_exists("workflow", $_REQUEST) && (either_param_string("workflow") != "wf_-2");
            $current_workflow = get_workflow_of_content("image", strval($id));
            if ($edit_workflow) {
                $workflow_id = intval(str_replace("wf_", "", either_param_string("workflow", "wf_-1")));
                // If we have been given a specific workflow, but we do not have access to
                // choose workflows, fail
                if (($workflow_id != -1) && (!can_choose_workflow())) {
                    $edit_workflow = false;
                }
            }
            if ($edit_workflow && ($workflow_id == -1)) {
                // Look for the workflow of the containing gallery
                $workflow_id = get_workflow_of_content("gallery", $title);
                if (is_null($workflow_id))
                {
                    // Use the default if it has none
                    if ($current_workflow != get_default_workflow())
                    {
                        add_content_to_workflow("image", strval($id), null, true);
                        attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text(get_default_workflow())), "inform");
                    }
                } else {
                    // The parent has a workflow. Copy it for this.
                    if ($workflow_id != $current_workflow)
                    {
                        add_content_to_workflow("image", strval($id), $workflow_id, true);
                        attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text($workflow_id)), "inform");
                    }
                }
            }
            else if ($edit_workflow) {
                // Use the specific ID provided
                if ($workflow_id != $current_workflow)
                {
                    add_content_to_workflow("image", strval($id), $workflow_id);
                    attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text($workflow_id)), "inform");
                }
            }
            log_it(\'EDIT_IMAGE\', strval($id), $title);
        }
        ',
        $code
    );

    // ...videos...
    $code = str_replace('log_it(\'EDIT_VIDEO\', strval($id), $title);',
        '
        if ($validated == 0)
        {
            require_code("workflows");
            require_lang("workflows");
            // See if we have a specific workflow to use
            $edit_workflow = array_key_exists("workflow", $_REQUEST) && (either_param_string("workflow") != "wf_-2");
            $current_workflow = get_workflow_of_content("video", strval($id));
            if ($edit_workflow) {
                $workflow_id = intval(str_replace("wf_", "", either_param_string("workflow", "wf_-1")));
                // If we have been given a specific workflow, but we do not have access to
                // choose workflows, fail
                if (($workflow_id != -1) && (!can_choose_workflow())) {
                    $edit_workflow = false;
                }
            }
            if (($edit_workflow) && ($workflow_id == -1)) {
                // Look for the workflow of the containing gallery
                $workflow_id = get_workflow_of_content("gallery", $title);
                if (is_null($workflow_id)) {
                    // Use the default if it has none
                    if ($current_workflow != get_default_workflow()) {
                        add_content_to_workflow("video", strval($id), null, true);
                        attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text(get_default_workflow())), "inform");
                    }
                } else {
                    // The parent has a workflow. Copy it for this.
                    if ($workflow_id != $current_workflow) {
                        add_content_to_workflow("video", strval($id), $workflow_id, true);
                        attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text($workflow_id)), "inform");
                    }
                }
            }
            elseif ($edit_workflow) {
                // Use the specific ID provided
                if ($workflow_id != $current_workflow) {
                    add_content_to_workflow("video", strval($id), $workflow_id);
                    attach_message(do_lang("CONTENT_NOW_IN_WORKFLOW", get_translated_text($workflow_id)), "inform");
                }
            }
            log_it(\'EDIT_VIDEO\', strval($id), $title);
        }
        ',
        $code
    );

    // ...and galleries
    $code = str_replace('log_it(\'EDIT_GALLERY\', $name, $fullname);',
        'require_code("workflows");
        require_lang("workflows");
        // See if we have a specific workflow to use
        $edit_workflow = array_key_exists("workflow", $_REQUEST) && (post_param_string("workflow") != "wf_-2");
        $current_workflow = get_workflow_of_content("gallery", $name);
        if ($edit_workflow) {
            $workflow_id = intval(str_replace("wf_", "", either_param_string("workflow", "wf_-1")));
            // If we have been given a specific workflow, but we do not have access to
            // choose workflows, fail
            if (($workflow_id != -1) && (!can_choose_workflow())) {
                $edit_workflow = false;
            }
        }
        if ($edit_workflow && $workflow_id == -1) {
            // Look for the workflow of the containing gallery
            $workflow_id = get_workflow_of_content("gallery", $parent_id);
            if (is_null($workflow_id))
            {
                // Use the default if it has none
                if ($current_workflow != get_default_workflow()) {
                    add_content_to_workflow("gallery", $name, null, true);
                }
            } else {
                // The parent has a workflow. Copy it for this.
                if ($workflow_id != $current_workflow) {
                    add_content_to_workflow("gallery", $name, $workflow_id, true);
                }
            }
        }
        elseif ($edit_workflow) {
            // Use the specific ID provided
            if ($workflow_id != $current_workflow) {
                add_content_to_workflow("gallery", $name, $workflow_id, true);
            }
        }
        log_it(\'EDIT_GALLERY\', $name, $fullname);',
        $code
    );

    // Now we add removal code for the delete functions.
    // We do this for images...
    $code = str_replace('log_it(\'DELETE_IMAGE\', strval($id), get_translated_text($description));',
        'log_it(\'DELETE_IMAGE\', strval($id), get_translated_text($description));
        require_code("workflows");
        require_lang("workflows");
        if (!is_null(get_workflow_of_content("image", strval($id)))) {
            remove_content_from_workflows("image", strval($id));
        }',
        $code
    );

    // ...videos...
    $code = str_replace('log_it(\'DELETE_VIDEO\', strval($id), get_translated_text($description));',
        'log_it(\'DELETE_VIDEO\', strval($id), get_translated_text($description));
        require_code("workflows");
        require_lang("workflows");
        if (!is_null(get_workflow_of_content("video", strval($id)))) {
            remove_content_from_workflows("video", strval($id));
        }',
        $code
    );

    // ...and galleries.
    $code = str_replace('log_it(\'DELETE_GALLERY\', $name, get_translated_text($rows[0][\'fullname\']));',
        'log_it(\'DELETE_GALLERY\', $name, get_translated_text($rows[0][\'fullname\']));
        require_code("workflows");
        require_lang("workflows");
        if (!is_null(get_workflow_of_content("gallery", $name))) {
            remove_content_from_workflows("gallery", $name);
        }',
        $code
    );

    return $code;
}

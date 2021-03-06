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
    i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

    if (!$GLOBALS['SITE_DB']->table_exists('workflow_content')) { // Not installed
        return $code;
    }

    // Add a redirection for the workflow handling
    $code = override_str_replace_exactly(
        "// What are we doing?\n        \$type = get_param_string('type', 'browse');",
        "
        <ditto>
        if (\$type == 'workflow') {
            return \$this->workflow_handler();
        }
        ",
        $code
    );

    // Add workflow warnings to flow mode galleries. This has to be done for images...
    $code = override_str_replace_exactly(
        "\$current_entry = do_template('GALLERY_FLOW_MODE_IMAGE'",
        "
        // Add the workflow form if this entry is unvalidated
        if (\$row['validated'] == 0) {
            require_code('workflows');
            require_lang('workflows');

            \$wf = get_workflow_of_content('image', strval(\$row['id']));
            if (\$wf !== null) {
                \$workflow_content_id = get_workflow_content_id('image', strval(\$row['id']));
                if (\$workflow_content_id !== null) {
                    \$warning_details->attach(get_workflow_form(\$workflow_content_id));
                }
            }
        }
        <ditto>
        ",
        $code
    );

    // ...and videos separately.
    $code = override_str_replace_exactly(
        "\$current_entry = do_template('GALLERY_FLOW_MODE_VIDEO'",
        "
        // Add the workflow form if this entry is unvalidated
        if (\$row['validated'] == 0) {
            require_code('workflows');
            require_lang('workflows');

            \$wf = get_workflow_of_content('video', strval(\$row['id']));
            if (\$wf !== null) {
                \$workflow_content_id = get_workflow_content_id('video', strval(\$row['id']));
                if (\$workflow_content_id !== null) {
                    \$warning_details->attach(get_workflow_form(\$workflow_content_id));
                }
            }
        }
        <ditto>
        ",
        $code
    );

    // Add workflow warnings to images
    $code = override_str_replace_exactly(
        "} else {
            \$warning_details = new Tempcode();
        }

        if ((has_actual_page_access(null, 'cms_galleries', null, null)) && (has_edit_permission('mid', get_member(), \$myrow['submitter'], 'cms_galleries', array('galleries', \$cat)))) {
            \$edit_url = build_url(array('page' => 'cms_galleries', 'type' => '_edit', 'id' => \$id), get_module_zone('cms_galleries'));
        } else {
            \$edit_url = new Tempcode();
        }",
        "
        <ditto>

        if (\$myrow['validated'] == 0) {
            require_code('workflows');
            require_lang('workflows');

            \$workflow_content_id = get_workflow_content_id('image', strval(\$myrow['id']));
            if (\$workflow_content_id !== null) {
                \$warning_details->attach(get_workflow_form(\$workflow_content_id));
            }
        }
        ",
        $code
    );

    // ...and videos separately.
    $code = override_str_replace_exactly(
        "} else {
            \$warning_details = new Tempcode();
        }

        if ((has_actual_page_access(null, 'cms_galleries', null, null)) && (has_edit_permission('mid', get_member(), \$myrow['submitter'], 'cms_galleries', array('galleries', \$cat)))) {
            \$edit_url = build_url(array('page' => 'cms_galleries', 'type' => '_edit_other', 'id' => \$id), get_module_zone('cms_galleries'));
        } else {
            \$edit_url = new Tempcode();
        }",
        "
        <ditto>

        if (\$myrow['validated'] == 0) {
            require_code('workflows');
            require_lang('workflows');

            \$workflow_content_id = get_workflow_content_id('video', strval(\$myrow['id']));
            if (\$workflow_content_id !== null) {
                \$warning_details->attach(get_workflow_form(\$workflow_content_id));
            }
        }
        ",
        $code
    );

    // Add workflow handling to the end of the class definition
    $code = override_str_replace_exactly(
        "\n    }\n}\n",
        "
            }

            /**
             * Handler for workflow requests
             */
            function workflow_handler()
            {
                // Only act if workflows are installed
                require_code('workflows'); // Load workflow-related code
                return workflow_update_handler();
            }
        }
        ",
        $code
    );

    return $code;
}

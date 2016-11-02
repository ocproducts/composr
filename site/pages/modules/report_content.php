<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    tickets
 */

/**
 * Module page class.
 */
class Module_report_content
{
    /**
     * Find details of the module.
     *
     * @return ?array Map of module info (null: module is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham / Patrick Schmalstig';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 4;
        $info['update_require_upgrade'] = true;
        $info['locked'] = false;
        return $info;
    }

    /**
     * Uninstall the module.
     */
    public function uninstall()
    {
        $GLOBALS['SITE_DB']->drop_table_if_exists('reported_content');

        delete_privilege('may_report_content');
    }

    /**
     * Install the module.
     *
     * @param  ?integer $upgrade_from What version we're upgrading from (null: new install)
     * @param  ?integer $upgrade_from_hack What hack version we're upgrading from (null: new-install/not-upgrading-from-a-hacked-version)
     */
    public function install($upgrade_from = null, $upgrade_from_hack = null)
    {
        if ($upgrade_from === null) {
            $GLOBALS['SITE_DB']->create_table('reported_content', array(
                'r_session_id' => '*ID_TEXT',
                'r_content_type' => '*ID_TEXT',
                'r_content_id' => '*ID_TEXT',
                'r_counts' => 'BINARY', // If the content is marked unvalidated, r_counts is set to 0 for each row for it, so if it's revalidated the counts apply elsewhere
            ));
            $GLOBALS['SITE_DB']->create_index('reported_content', 'reported_already', array('r_content_type', 'r_content_id'));
        }

        if (($upgrade_from !== null) && ($upgrade_from < 3)) {
            $GLOBALS['SITE_DB']->alter_table_field('reported_content', 'r_session_id', 'ID_TEXT');
        }

        if (($upgrade_from === null) || ($upgrade_from < 4)) {
            add_privilege('GENERAL_SETTINGS', 'may_report_content', true);

            // Add ticket type
            require_lang('tickets');
            $map = array(
                'guest_emails_mandatory' => 0,
                'search_faq' => 0,
                'cache_lead_time' => null,
            );
            $map += insert_lang('ticket_type_name', do_lang('TT_REPORTED_CONTENT'), 1);
            $ticket_type_id = $GLOBALS['SITE_DB']->query_insert('ticket_types', $map, true);
            require_code('permissions2');
            set_global_category_access('tickets', $ticket_type_id);
        }
    }

    public $title;

    /**
     * Module pre-run function. Allows us to know metadata for <head> before we start streaming output.
     *
     * @return ?Tempcode Tempcode indicating some kind of exceptional output (null: none).
     */
    public function pre_run()
    {
        i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

        $type = get_param_string('type', 'browse');

        // Bot (which runs as a dum guest) could conceivably try and index these things and we don't want that
        attach_to_screen_header('<meta name="robots" content="noindex" />'); // XHTMLXHTML

        require_lang('report_content');

        if ($type == 'browse') {
            $this->title = get_screen_title('REPORT_CONTENT');
        }

        if ($type == 'actual') {
            $this->title = get_screen_title('REPORT_CONTENT');
        }

        return null;
    }

    /**
     * Execute the module.
     *
     * @return Tempcode The result of execution.
     */
    public function run()
    {
        require_lang('cns');

        // Decide what we're doing
        $type = get_param_string('type', 'browse');

        if ($type == 'browse') {
            return $this->form();
        }
        if ($type == 'actual') {
            return $this->actualiser();
        }

        return new Tempcode();
    }

    /**
     * The report UI.
     *
     * @return Tempcode The result of execution.
     */
    public function form()
    {
        require_code('report_content');

        //$url = get_param_string('url', false, INPUT_FILTER_URL_INTERNAL); Not used, as the content type can find it
        $content_type = get_param_string('content_type');
        $content_id = get_param_string('content_id');

        return report_content_form($this->title, $content_type, $content_id);
    }

    /**
     * The report actualiser.
     *
     * @return Tempcode The result of execution.
     */
    public function actualiser()
    {
        if (addon_installed('captcha')) {
            require_code('captcha');
            enforce_captcha();
        }

        require_code('report_content');

        $content_type = post_param_string('content_type');
        $content_id = post_param_string('content_id');
        $post = post_param_string('post');
        $anonymous = post_param_integer('anonymous', 0);

        report_content($content_type, $content_id, $post, $anonymous);

        $_url = post_param_string('url', '', INPUT_FILTER_URL_INTERNAL);
        if ($_url != '') {
            $content_url = make_string_tempcode($_url);
        }
        return redirect_screen($this->title, $content_url, do_lang_tempcode('CONTENT_REPORTED'));
    }
}

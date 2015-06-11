<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    xmppchat
 */

/**
 * Hook class.
 */
class Hook_addon_registry_xmppchat
{
    /**
     * Get a list of file permissions to set
     *
     * @return array File permissions to set
     */
    public function get_chmod_array()
    {
        return array();
    }

    /**
     * Get the version of Composr this addon is for
     *
     * @return float Version number
     */
    public function get_version()
    {
        return cms_version_number();
    }

    /**
     * Get the addon category
     *
     * @return string The category
     */
    public function get_category()
    {
        return 'Development';
    }

    /**
     * Get the addon author
     *
     * @return string The author
     */
    public function get_author()
    {
        return 'Chris Graham';
    }

    /**
     * Find other authors
     *
     * @return array A list of co-authors that should be attributed
     */
    public function get_copyright_attribution()
    {
        return array(
            'Harlan Iverson',
        );
    }

    /**
     * Get the addon licence (one-line summary only)
     *
     * @return string The licence
     */
    public function get_licence()
    {
        return 'LGPL';
    }

    /**
     * Get the description of the addon
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'Replaces the standard Composr chat room with any Jabber chatrooms running on your server.

Usage Instructions:
1) You will need a dedicated server; we assume it is Linux and Apache.
2) We assume Composr is installed to use MySQL.
3) We assume that users are set up with standard Composr password hashing, or md5 hashing, or plain passwords, or vbulletin hashing.
4) Install ejabberd on on your server (it supports builtin BOSH connections -- which are needed for our web interface). Make sure it\'s not version 1, that has problems.
5) It is important mod_http_bind has been enabled on your ejabberd configuration, as well as mod_muc (they are by default).
6) Edit ejabberd.cfg to enable the mod_muc_log module, setting the save path to be <cmsbasepath>/data_custom/jabber-logs (optional).
7) Install this Composr addon to replace Composr\'s normal chat backend with your new XMPP server.
8) Turn on our authentication script by editing ejabberd.cfg.... a) Comment out "{auth_method, internal}." b) Add in: "<cmsbasepath>/data_custom/modules/chat/ejabberd_auth.php" c) Set execute file permissions on the above referenced script, "chmod a+x <cmsbasepath>/data_custom/modules/chat/ejabberd_auth.php"
9) In Composr you should deny access to Guests to the chat module, they are not supported at this time.
10) Instructions for XMPP usage by users have been placed on the chat lobby screen. Note that as an administrator you now need to manage chat rooms via a normal XMPP client: the admin/CMS chat modules will no longer be functional.
11) You may need to set up Proxy server (we\'re not sure why, but on some PHP configurations our proxying script does not work). Something similar to the following needs to be in the Apache configuration to workaround the problem: LoadModule proxy_module /usr/lib/apache2/modules/mod_proxy.so LoadModule proxy_http_module /usr/lib/apache2/modules/mod_proxy_http.so ProxyRequests Off ProxyPass /data_custom/xmpp_proxy.php http://<yourdomainname>:5280/http-bind/ Credits: We used xmpp4js to integrate with our chat frontend, and the Composr/jabber authentication was based on lissyx\'s work.';
    }

    /**
     * Get a list of tutorials that apply to this addon
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array();
    }

    /**
     * Get a mapping of dependency types
     *
     * @return array File permissions to set
     */
    public function get_dependencies()
    {
        return array(
            'requires' => array(
                'Dedicated server running ejabberd',
                'chat',
            ),
            'recommends' => array(),
            'conflicts_with' => array()
        );
    }

    /**
     * Explicitly say which icon should be used
     *
     * @return URLPATH Icon
     */
    public function get_default_icon()
    {
        return 'themes/default/images/icons/48x48/menu/_generic_admin/component.png';
    }

    /**
     * Get a list of files that belong to this addon
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources_custom/hooks/systems/addon_registry/xmppchat.php',
            'data_custom/jabber-logs/index.html',
            'data_custom/jabber-logs/.htaccess',
            'themes/default/javascript_custom/xmpp_crypto.js',
            'themes/default/javascript_custom/xmpp_dom-all.js',
            'themes/default/javascript_custom/xmpp_prototype.js',
            'themes/default/javascript_custom/xmpp_xmpp4js.js',
            'data_custom/xmpp_proxy.php',
            'data_custom/modules/chat/ejabberd_auth.php',
            'themes/default/templates_custom/CHAT_LOBBY_SCREEN.tpl',
            'themes/default/templates_custom/CHAT_ROOM_LINK.tpl',
            'themes/default/templates_custom/CHAT_ROOM_SCREEN.tpl',
            'themes/default/javascript_custom/CHAT.js',
            'sources_custom/chat.php',
            'sources_custom/hooks/systems/content_meta_aware/chat.php',
            'site/pages/modules_custom/chat.php',
            'data_custom/get_avatar.php',
        );
    }
}

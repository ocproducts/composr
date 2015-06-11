<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    amazon_wishlist
 */

/**
 * Hook class.
 */
class Hook_addon_registry_amazon_wishlist
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
        return 'Third Party Integration';
    }

    /**
     * Get the addon author
     *
     * @return string The author
     */
    public function get_author()
    {
        return 'Kamen Blaginov';
    }

    /**
     * Find other authors
     *
     * @return array A list of co-authors that should be attributed
     */
    public function get_copyright_attribution()
    {
        return array();
    }

    /**
     * Get the addon licence (one-line summary only)
     *
     * @return string The licence
     */
    public function get_licence()
    {
        return 'Licensed on the same terms as Composr';
    }

    /**
     * Get the description of the addon
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'An Amazon wishlist block.

Parameters include:
 - Amazon access and secret keys
 - Amazon wishlist ID
 - Amazon domain used

For this addon you will need to login at Amazon web services (http://aws-portal.amazon.com/gp/aws/developer/account/index.html) using your normal Amazon account log in.

Once you have logged in and accepted the security message click on Security credentials on the left hand menu, click access keys and here you will find your access key and security key.

When adding the addon you will be asked for four things: Access key, Security key, wishlist ID and domain. The Access and security keys you can find by following the process above, the wishlist ID is the string of numbers after the Amazon address usually something like "2VAUC2FYIEUZ5". Lastly the domain is either "com" or "co.uk" which will depend on the wishlist URL.

An example of the code is:
[code="Comcode"][block access_key="AKIAJXSQP4CES2F37GWQ" secret_key="xy9e5MHu4f9y7kjOjkysmjd58k2gjzN8YmC2/Ith" wishlist_id="2VAUC2FYIEUZ5" domain="com"]side_amazon_wishlist[/block][/code]
Note: Sometimes wishlists may be quite long, you can create a specific wish list on Amazon to display and use that wishlist ID if you need to limit the amount of items on the list.';
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
                'PHP simplexml extension',
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
            'sources_custom/hooks/systems/addon_registry/amazon_wishlist.php',
            'lang_custom/EN/amazon.ini',
            'sources_custom/blocks/side_amazon_wishlist.php',
            'themes/default/css_custom/amazon_wishlist.css',
            'themes/default/templates_custom/BLOCK_SIDE_AMAZON_WISHLIST.tpl',
        );
    }
}

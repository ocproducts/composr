<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_feedback_features
 */

/**
 * Hook class.
 */
class Hook_rss_comments
{
    /**
     * Run function for RSS hooks.
     *
     * @param  string $full_title A list of categories we accept from
     * @param  TIME $cutoff Cutoff time, before which we do not show results from
     * @param  string $prefix Prefix that represents the template set we use
     * @set RSS_ ATOM_
     * @param  string $date_string The standard format of date to use for the syndication type represented in the prefix
     * @param  integer $max The maximum number of entries to return, ordering by date
     * @return ?array A pair: The main syndication section, and a title (null: error)
     */
    public function run($full_title, $cutoff, $prefix, $date_string, $max)
    {
        require_code('content');

        // Check permissions (this is HARD, we have to tunnel through content_meta_aware hooks)
        $parts = explode('_', $full_title, 2);
        $hook = convert_composr_type_codes('feedback_type_code', $parts[0], 'content_type');
        if ($hook != '') {
            require_code('content');
            $ob = get_content_object($hook);
            if ($ob === null) {
                return null;
            }
            $info = $ob->info();

            // Category access
            $permissions_field = $info['permissions_type_code'];
            if ($permissions_field !== null) {
                $cat = $GLOBALS['SITE_DB']->query_select_value_if_there($info['table'], $info['parent_category_field'], get_content_where_for_str_id($parts[1], $info));
                if ($cat === null) {
                    return null;
                }
                if (!has_category_access(get_member(), $permissions_field, $cat)) {
                    return null;
                }
            }

            // Page/Zone access
            if ($info['view_page_link_pattern'] !== null) {
                $view_page_link_bits = explode(':', $info['view_page_link_pattern']);
                $zone = $view_page_link_bits[0];
                if ($zone == '_SEARCH') {
                    $zone = get_module_zone($view_page_link_bits[1]);
                }
                if (!has_actual_page_access(get_member(), $view_page_link_bits[1], $zone)) {
                    return null;
                }
            }

            // Privacy
            if (addon_installed('content_privacy')) {
                require_code('content_privacy');
                if (!has_privacy_access($hook, $parts[1])) {
                    return null;
                }
            }
        } else {
            $zone = get_page_zone($parts[0], false);
            if ($zone === null) {
                return null;
            }
            if (!has_actual_page_access(get_member(), $parts[0], $zone)) {
                return null;
            }
        }

        $title = null;

        $content = new Tempcode();
        // Comment posts
        $forum = get_param_string('forum', get_option('comments_forum_name'));
        $count = 0;
        $start = 0;
        do {
            $_comments = $GLOBALS['FORUM_DRIVER']->get_forum_topic_posts($GLOBALS['FORUM_DRIVER']->find_topic_id_for_topic_identifier($forum, $full_title, do_lang('COMMENT')), $count, min($max, 1000), $start);
            if (is_array($_comments)) {
                $_comments = array_reverse($_comments);

                foreach ($_comments as $i => $comment) {
                    if ($comment === null) {
                        continue;
                    }
                    if ($i + $start > $max) {
                        break 2;
                    }

                    $timestamp = $comment['date'];
                    if ($timestamp < $cutoff) {
                        break 2;
                    }

                    $if_comments = new Tempcode();

                    $id = strval($comment['id']);
                    $author = $GLOBALS['FORUM_DRIVER']->get_username($comment['member'], false, USERNAME_DEFAULT_BLANK);

                    $news_date = date($date_string, $timestamp);
                    $edit_date = escape_html('');

                    $news_title = xmlentities($comment['title']);
                    if (($news_title != '') && ($title === null)) {
                        $title = $comment['title'];
                    }
                    $_summary = $comment['message'];
                    if (is_object($_summary)) {
                        $_summary = $_summary->evaluate();
                    }
                    $summary = xmlentities($_summary);
                    $news = escape_html('');

                    $category = '';
                    $category_raw = '';

                    $content->attach(do_template($prefix . 'ENTRY', array('VIEW_URL' => new Tempcode(), 'SUMMARY' => $summary, 'EDIT_DATE' => $edit_date, 'IF_COMMENTS' => $if_comments, 'TITLE' => $news_title, 'CATEGORY_RAW' => $category_raw, 'CATEGORY' => $category, 'AUTHOR' => $author, 'ID' => $id, 'NEWS' => $news, 'DATE' => $news_date), null, false, null, '.xml', 'xml'));
                }
            } else {
                break;
            }

            $start += 1000;
        } while (count($_comments) == 1000);

        $title = do_lang('COMMENTS');

        return array($content, $title);
    }
}

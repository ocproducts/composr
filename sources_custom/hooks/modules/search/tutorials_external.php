<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_tutorials
 */

/**
 * Hook class.
 */
class Hook_search_tutorials_external extends FieldsSearchHook
{
    /**
     * Find details for this search hook.
     *
     * @param  boolean $check_permissions Whether to check permissions
     * @param  ?MEMBER $member_id The member ID to check with (null: current member)
     * @return ~?array Map of search hook details (null: hook is disabled) (false: access denied)
     */
    public function info($check_permissions = true, $member_id = null)
    {
        if ($member_id === null) {
            $member_id = get_member();
        }

        require_lang('tutorials');

        $info = array();
        $info['lang'] = do_lang_tempcode('TUTORIALS_EXTERNAL');
        $info['default'] = true;
        $info['integer_category'] = true;

        $info['permissions'] = array();

        return $info;
    }

    /**
     * Run function for search results.
     *
     * @param  string $content Search string
     * @param  boolean $only_search_meta Whether to only do a META (tags) search
     * @param  ID_TEXT $direction Order direction
     * @param  integer $max Start position in total results
     * @param  integer $start Maximum results to return in total
     * @param  boolean $only_titles Whether only to search titles (as opposed to both titles and content)
     * @param  string $content_where Where clause that selects the content according to the main search string (SQL query fragment) (blank: full-text search)
     * @param  SHORT_TEXT $author Username/Author to match for
     * @param  ?MEMBER $author_id Member-ID to match for (null: unknown)
     * @param  mixed $cutoff Cutoff date (TIME or a pair representing the range)
     * @param  string $sort The sort type (gets remapped to a field in this function)
     * @set    title add_date
     * @param  integer $limit_to Limit to this number of results
     * @param  string $boolean_operator What kind of boolean search to do
     * @set    or and
     * @param  string $where_clause Where constraints known by the main search code (SQL query fragment)
     * @param  string $search_under Comma-separated list of categories to search under
     * @param  boolean $boolean_search Whether it is a boolean search
     * @return array List of maps (template, orderer)
     */
    public function run($content, $only_search_meta, $direction, $max, $start, $only_titles, $content_where, $author, $author_id, $cutoff, $sort, $limit_to, $boolean_operator, $where_clause, $search_under, $boolean_search)
    {
        require_code('tutorials');

        $remapped_orderer = '';
        switch ($sort) {
            case 'title':
                $remapped_orderer = 't_title';
                break;

            case 'add_date':
                $remapped_orderer = 't_add_date';
                break;
        }

        $sq = build_search_submitter_clauses('t_submitter', $author_id, $author, 't_author');
        if (is_null($sq)) {
            return array();
        } else {
            $where_clause .= $sq;
        }

        $table = 'tutorials_external r';
        $trans_fields = array();
        $nontrans_fields = array('r.t_title', 'r.t_summary');
        $this->_get_search_parameterisation_advanced_for_content_type('_comcode_page', $table, $where_clause, $trans_fields, $nontrans_fields);

        // Calculate and perform query
        $rows = get_search_rows(null, null, $content, $boolean_search, $boolean_operator, $only_search_meta, $direction, $max, $start, $only_titles, $table, $trans_fields, $where_clause, $content_where, $remapped_orderer, 'r.*,' . tutorial_sql_rating(db_cast('r.id', 'CHAR')) . ',' . tutorial_sql_rating_recent(db_cast('r.id', 'CHAR')) . ',' . tutorial_sql_likes(db_cast('r.id', 'CHAR')) . ',' . tutorial_sql_likes_recent(db_cast('r.id', 'CHAR')), $nontrans_fields);

        $out = array();
        foreach ($rows as $i => $row) {
            $out[$i]['data'] = $row;
            unset($rows[$i]);
            if (($remapped_orderer != '') && (array_key_exists($remapped_orderer, $row))) {
                $out[$i]['orderer'] = $row[$remapped_orderer];
            } elseif (strpos($remapped_orderer, '_rating:') !== false) {
                $out[$i]['orderer'] = $row[$remapped_orderer];
            }
        }

        return $out;
    }

    /**
     * Run function for rendering a search result.
     *
     * @param  array $row The data row stored when we retrieved the result
     * @return Tempcode The output
     */
    public function render($row)
    {
        $tags = collapse_1d_complexity('t_tag', $GLOBALS['SITE_DB']->query_select('tutorials_external_tags', array('t_tag'), array('t_id' => $row['id'])));
        $metadata = get_tutorial_metadata(strval($row['id']), $row, $tags);
        return do_template('TUTORIAL_BOX', templatify_tutorial($metadata));
    }
}

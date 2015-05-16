<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 */
/*EXTRA FUNCTIONS: json_decode*/

/**
 * Block class.
 */
class Block_side_similar_sites
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = false;
        $info['parameters'] = array('criteria', 'max');
        return $info;
    }

    /**
     * Find cacheing details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled).
     */
    public function cacheing_environment()
    {
        $info = array();
        $info['cache_on'] = 'array(array_key_exists(\'criteria\',$map)?$map[\'criteria\']:\'\',array_key_exists(\'max\',$map)?$map[\'max\']:3)';
        $info['ttl'] = 60 * 5;
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters.
     * @return tempcode The result of execution.
     */
    public function run($map)
    {
        i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

        require_lang('similar_sites');

        $criteria = array_key_exists('criteria', $map) ? $map['criteria'] : get_option('site_scope');
        $max = (isset($map['max']) && intval($map['max']) > 0) ? intval($map['max']) : 3;

        $set_search_terms = '';
        $set_search_url = 'related:' . $criteria;

        $search_results_array = $this->retrieveGoogleSearch($set_search_terms, $set_search_url);

        $out = '<ul>';
        $links_count = 0;
        foreach ($search_results_array as $result) {
            //more details in output - page content and short url - if we need more details, i.e. for the main block we could use this
            //$out .= '<li><strong><a href="'.$result["url"].'">'.$result["title"].'</a></strong> '.  $result["content"].' <em>'.$result["visibleUrl"].'</em></li>';
            $links_count++;
            if ($links_count <= $max) {
                $out .= '<li><a href="' . $result['url'] . '" target="_blank">' . $result['title'] . '</a></li>';
            }
        }

        $out .= '</ul>';

        return do_template('BLOCK_SIDE_SIMILAR_SITES', array('_GUID' => '0eeeec88a1496aa8b0db3580dcaa4ed8', 'TITLE' => do_lang_tempcode('BLOCK_SIMILAR_SITES_TITLE'), 'CONTENT' => $out, 'CRITERIA' => $criteria));
    }

    public function retrieveGoogleSearch($search_terms = 'example', $search_url = 'related:example.com')
    {
        require_code('files');
        $google_base_url = 'http://ajax.googleapis.com/ajax/services/search/web';
        $google_base_query = '?v=1.0&rsz=large&q=';
        $google_full_url = $google_base_url . $google_base_query . $search_url . '%20' . $search_terms;

        $returned_google_search = http_download_file($google_full_url);

        $returned_google_search_arr = json_decode($returned_google_search, true);

        return $returned_google_search_arr['responseData']['results'];
    }
}

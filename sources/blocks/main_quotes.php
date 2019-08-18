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
 * @package    random_quotes
 */

/**
 * Block class.
 */
class Block_main_quotes
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled)
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
        $info['parameters'] = array('param', 'title');
        return $info;
    }

    /**
     * Find caching details for the block.
     *
     * @return ?array Map of cache details (cache_on and ttl) (null: block is disabled)
     */
    public function caching_environment()
    {
        $info = array();
        $info['cache_on'] = 'array(array_key_exists(\'title\',$map)?$map[\'title\']:\'-\',array_key_exists(\'param\',$map)?$map[\'param\']:\'quotes\')';
        $info['special_cache_flags'] = CACHE_AGAINST_DEFAULT | CACHE_AGAINST_PERMISSIVE_GROUPS; // Due to edit link
        $info['ttl'] = 5;
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters
     * @return Tempcode The result of execution
     */
    public function run($map)
    {
        $error_msg = new Tempcode();
        if (!addon_installed__messaged('random_quotes', $error_msg)) {
            return $error_msg;
        }

        require_lang('quotes');

        $block_id = get_block_id($map);

        $file = empty($map['param']) ? 'quotes' : $map['param'];
        $title = array_key_exists('title', $map) ? $map['title'] : do_lang('QUOTES');

        require_css('random_quotes');

        require_code('textfiles');

        $path = _find_text_file_path($file, '');
        if ($path == '') {
            return paragraph(do_lang_tempcode('_MISSING_RESOURCE', escape_html($file), escape_html(do_lang('FILE'))), 'ftfgf6cy5oe1lytmzs2wl9snblboow0m', 'nothing-here');
        }

        if (!file_exists($path)) {
            return paragraph(do_lang_tempcode('DIRECTORY_NOT_FOUND', escape_html($path)), 'c175i555gscb3jurcq3chmloeaaxtf3l', 'nothing-here');
        }
        $edit_url = new Tempcode();
        if (($file == 'quotes') && (has_actual_page_access(get_member(), 'quotes', 'adminzone'))) {
            $edit_url = build_url(array('page' => 'quotes'), 'adminzone');
        }
        return do_template('BLOCK_MAIN_QUOTES', array(
            '_GUID' => '7cab7422f603f7b1197c940de48b99aa',
            'BLOCK_ID' => $block_id,
            'TITLE' => $title,
            'EDIT_URL' => $edit_url,
            'FILE' => $file,
            'CONTENT' => comcode_to_tempcode($this->get_random_line($path), null, true),
        ));
    }

    /**
     * Get a random line from a file.
     *
     * @param  PATH $filename The filename
     * @return string The random line
     */
    public function get_random_line($filename)
    {
        $myfile = @fopen(filter_naughty($filename, true), 'rb');
        // TODO: #3467
        if ($myfile === false) {
            return '';
        }
        flock($myfile, LOCK_SH);
        $i = 0;
        $line = array();
        while (true) {
            $line[$i] = fgets($myfile);

            if (($line[$i] === false) || ($line[$i] === null)) {
                break;
            }

            if (trim($line[$i]) != '') {
                $i++;
            }
        }
        if ($i == 0) {
            return '';
        }
        $r = mt_rand(0, $i - 1);
        flock($myfile, LOCK_UN);
        fclose($myfile);
        return trim($line[$r]);
    }
}

<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_abstract_interfaces
 */

/**
 * Get the Tempcode for a view space page. (a view space shows a single entry, with the field name for each field to the left of the value).
 *
 * @param  Tempcode $title The title of the view space; should be out of get_screen_title
 * @param  array $fields An array of mappings between title and value (each mapping being a field)
 * @param  ?Tempcode $text Text to show (null: none)
 * @param  ?Tempcode $buttons Buttons to show (null: none)
 * @param  boolean $responsive Use a responsive layout for the table (too much to fit in 2 columns on a small screen)
 * @return Tempcode The generated view space
 */
function map_table_screen($title, $fields, $text = null, $buttons = null, $responsive = false)
{
    $_fields = new Tempcode();
    foreach ($fields as $key => $val) {
        if (!is_array($val)) {
            $raw = is_object($val);
        } else {
            list($val, $raw) = $val;
        }
        $_fields->attach(map_table_field(do_lang_tempcode($key), $val, $raw));
    }

    return do_template('MAP_TABLE_SCREEN', array(
        '_GUID' => 'c8c6cbc8e7b5a47a3078fd69feb057a0',
        'TITLE' => $title,
        'TEXT' => $text,
        'FIELDS' => $_fields,
        'BUTTONS' => $buttons,
        'RESPONSIVE' => $responsive,
    ));
}

/**
 * Get the Tempcode for a view space field.
 *
 * @param  mixed $name The field title (Tempcode or string). Assumed unescaped.
 * @param  mixed $value The field value (Tempcode or string). Assumed unescaped.
 * @param  boolean $raw Whether the field should be shown as untitled... because it is an element of a subblock of raw rows
 * @param  string $abbr Field abbreviation (blank: none)
 * @return Tempcode The generated view space field
 */
function map_table_field($name, $value, $raw = false, $abbr = '') // Not for use with the above, which takes the fields as a raw map
{
    if ($raw) {
        $value = protect_from_escaping($value);
    }
    return do_template('MAP_TABLE_FIELD', array('_GUID' => '7cd6e583cac2dacc99e3185419d67930', 'ABBR' => $abbr, 'NAME' => $name, 'VALUE' => $value));
}

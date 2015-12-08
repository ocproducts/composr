<?php

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/*
XML or JSON?

We generally prefer JSON when connecting to 3rd party backend services, where no human touches the data transferred.
However in some cases particular standards do require XML, we do use XML for our own AJAX, and we generally tend to prefer XML for user-edited file formats.

To use JSON in Composr, use standard PHP functions and do require_code('json'); in advance so we can plug in missing functions for older PHP versions.
*/

/*CQC: No check*/

// In PHP 5.2 or higher we don't need to bring this in
if (!function_exists('json_encode')) {
    /**
     * Returns the JSON representation of a value.
     *
     * @param  mixed $value The value being encoded. Can be any type except a resource.
     * @return string Encoded data
     */
    function json_encode($value)
    {
        global $services_json;
        if (!isset($services_json)) {
            require_code('json_inner');
            $services_json = new Services_JSON();
        }
        return $services_json->encode($value);
    }

    /**
     * Decodes a JSON string.
     *
     * @param  string $json The JSON string being decoded.
     * @param  boolean $assoc Whether returned objects will be converted into associative arrays.
     * @return ~mixed Decoded data (false: error)
     */
    function json_decode($json, $assoc = false)
    {
        global $services_json;
        if (!isset($services_json)) {
            require_code('json_inner');
            $services_json = new Services_JSON();
        }
        return $services_json->decode($json);
    }
}

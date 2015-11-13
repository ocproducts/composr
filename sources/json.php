<?php

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

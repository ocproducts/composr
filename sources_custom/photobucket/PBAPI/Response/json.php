<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * json response parser
 * 
 * @author Photobucket
 * @package PBAPI
 * @subpackage Response
 * 
 * @copyright Copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * Load Response parent
 */
require_once(dirname(__FILE__).'/../Response.php');

/**
 * Response json format parser
 *
 * Requires either the JSON extension, or the Services_JSON class from PEAR
 * 
 * @package PBAPI
 * @subpackage Response
 */
class PBAPI_Response_json extends PBAPI_Response {
    
    /**
     * Do JSON parse
     *
     * @param string $response_string string to parse
     * @param bool $onlycontent only return content 'node'
     * @return array associative array of response data
     */
    public function parse($string, $onlycontent = false) {
        $result = array();
        
        if (function_exists('json_decode')) {
            $result = json_decode($string, true);
        } else {
            //compatibility using PEAR
            require_once('Services/JSON.php');
            $json = new Services_JSON(SERVICES_JSON_LOOSE_TYPE);
            $result = $json->decode($string);
        }
        
        $this->detectException($result);
        
        if ($onlycontent) return @$result['content'];
        return $result;
    }
    
   /**
     * Returns optimal format string for given parser
     *
     * @return string
     */
    public function getFormat() {
        return 'json';
    }
    
}

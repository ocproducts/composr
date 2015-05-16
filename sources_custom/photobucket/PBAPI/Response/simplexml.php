<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * XML response parser
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
 * Response XML parser using SimpleXML
 *
 * @package PBAPI
 * @subpackage Response
 */
class PBAPI_Response_simplexml extends PBAPI_Response {
    
    /**
     * Do XML parse with simplexml
     *
     * @param string $response_string string to parse
     * @param bool $onlycontent only return content 'node'
     * @return SimpleXMLElement
     */
    public function parse($string, $onlycontent = false) {
        $result = array();
        
        $obj = new SimpleXMLElement($string);
        
        $this->detectException($obj);
        
        if ($onlycontent) return @$obj->content;
        return $obj;
    }
    
    /**
     * Returns optimal format string for given parser
     *
     * @return string
     */
    public function getFormat() {
        return 'xml';
    }
    
    /**
     * Detect an exception using xml element
     *
     * @param SimpleXMLElement $obj
     */
    protected function detectException(SimpleXMLElement $obj) {
        $status = (string) $obj->status;
        if ($status != 'OK') {
            $message = (string) $obj->message;
            $code = (int) $obj->code;
            throw new PBAPI_Exception_Response($message, $code);
        }
    }
    
}

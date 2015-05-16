<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * XMLSerializer response parser
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
 * Response XML parser using PEAR XML_Serializer/Unserializer
 *
 * @package PBAPI
 * @subpackage Response
 */
class PBAPI_Response_xmlserializer extends PBAPI_Response {
    
    /**
     * Do XML parse with XML_Serializer
     *
     * @param string $response_string string to parse
     * @param bool $onlycontent only return content 'node'
     * @return array associative array of response data
     */
    public function parse($string, $onlycontent = false) {
        $result = array();
        
        require_once('XML/Unserializer.php');
        $options = array(
            XML_UNSERIALIZER_OPTION_RETURN_RESULT => true,
            XML_UNSERIALIZER_OPTION_TAG_AS_CLASSNAME => true,
            XML_UNSERIALIZER_OPTION_ATTRIBUTES_ARRAYKEY => '_attribs',
            XML_UNSERIALIZER_OPTION_ATTRIBUTES_PARSE => true,
        );
        $xml = new XML_Unserializer($options);
        $result = $xml->unserialize($string);
        
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
        return 'xml';
    }
    
}

<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * XML to array response parser
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
 * base class for SimpleXML
 */
require_once(dirname(__FILE__).'/simplexml.php');

/**
 * Response XML parser using SimpleXML
 *
 * @package PBAPI
 * @subpackage Response
 */
class PBAPI_Response_simplexmlarray extends PBAPI_Response_simplexml {
    
    /**
     * Do XML parse with simplexml
     *
     * @param string $response_string string to parse
     * @param bool $onlycontent only return content 'node'
     * @return array associative array of response data
     */
    public function parse($string, $onlycontent = false) {
        $obj = parent::parse($string, $onlycontent);
        $result = self::xmlToArray($obj);
        
        return $result;
    }
    
    /**
     * Use SimpleXML Element to turn into an array
     *
     * @param SimpleXMLElement $node
     * @return array
     */
    public static function xmlToArray(SimpleXMLElement $node) {
        //eval attributes
        $attribs = false;
        if ($nodeAttrs = $node->attributes()) {
            foreach ($nodeAttrs as $attrName => $attrValue) {
                $attrName = (string) $attrName;
                $attrValue = (string) $attrValue;
                $attribs[$attrName] = $attrValue;
            }
        }
        
        $results = array();
        if ($children = $node->children()) {
            //node has children, do stuff.
            if ($attribs) $results['_attribs'] = $attribs;
            
            //prescan children to determine count
            $childnums = array();
            foreach ($children as $elementName => $childnode) {
                @$childnums[(string) $elementName]++;
            }

            //build arrays
            foreach ($children as $elementName => $childnode) {
                $elementName = (string) $elementName;
                if ($childnums[$elementName] > 1) {
                    $results[$elementName][] = self::xmlToArray($childnode);
                } else {
                    $results[$elementName] = self::xmlToArray($childnode);
                }
            }
            
        } else {
            //node doesnt have children (leaf)
            if ($attribs) {
                $results['_attribs'] = $attribs;
                $results['content'] = (string) $node;
            } else {
                $results = (string) $node;
            }
        }
        
        return $results; 
    }
    
}

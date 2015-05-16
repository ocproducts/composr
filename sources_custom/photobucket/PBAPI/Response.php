<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * Response parent class
 * 
 * @author jhart
 * @package PBAPI
 * 
 * @copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * Response parser parent class
 *
 * @package PBAPI
 */
abstract class PBAPI_Response {
    
    /**
     * Result data
     *
     * @var array
     */
    protected $result_data = array();
    
    /**
     * parameter holder
     *
     * @var array
     */
    protected $params = array();
    
    /**
     * Class constructor
     *
     * @param array $params
     */
    public function __construct($params = array()) {
        $this->params = $params;
    }
    
    /**
     * Parse response
     *
     * @param string $response_string string to parse
     * @param bool $onlycontent only return content 'node'
     * @return string
     */
    abstract public function parse($string, $onlycontent = false);
    
    /**
     * Detect an exception response and throw a code exception
     *
     * @param array $data parsed data from parser strategy
     */
    protected function detectException(array $data) {
        if ($data['status'] != 'OK') {
            throw new PBAPI_Exception_Response($data['message'], $data['code']);
        }
    }
    
    /**
     * Returns optimal format for given parser
     *
     * @return string
     */
    abstract public function getFormat();

}

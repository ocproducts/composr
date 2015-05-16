<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * PBAPI exception class
 * 
 * @author jhart
 * @package PBAPI
 * 
 * @copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * Exceptions for the PBAPI
 *
 * @package PBAPI
 */
class PBAPI_Exception extends Exception {
    
    /**
     * ref to core PBAPI object 
     *
     * @var PBAPI
     */
    protected $core;
    
    /**
     * Constructor
     *
     * @param string $message
     * @param int|PBAPI $code
     * @param PBAPI|optional $core
     */
    public function __construct($message = null, $code = 0, $core = null) {
        if ($code instanceof PBAPI) {
            $core = $code; 
            $code = 0;
        }
        $this->core = $core;
        $this->message = $message;
        $this->code = $code;
    }
    
    /**
     * return stack of methods for request
     *
     * @return array
     */
    public function getMethodStack() {
        if ($this->core) return $this->core->_getMethodStack();
        else return array();
    }
    
    /**
     * Parameters used in request
     *
     * @return array
     */
    public function getParams() {
        if ($this->core) return $this->core->_getParams();
        else return array();
    }
    
    /**
     * magic tostring
     *
     * @return string
     */
    public function __toString() {
        $str = __CLASS__ . ' ('.$this->getCode().'): "' . $this->getMessage() . "\"\n"
        . 'Method: ' . implode(':',$this->getMethodStack()) . "\n"
        . 'Params: ';
        foreach ($this->getParams() as $k => $v) {
            $str .= "$k => $v, ";
        }
        return $str;
    } 
    
}
